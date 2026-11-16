/**
 * Edits point ambience load settings at runtime and logs each change.
 *
 * The menu repeats until cancelled and displays current values. Configuration supplies startup
 * defaults. Acoustic wall and door policies remain available through variable editing.
 */
/client/proc/point_ambience_mode()
	set category = "调试"
	set name = "局部环境音模式"
	if(!check_rights(R_DEBUG))
		return
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	while(TRUE)
		var/interval = ambience.move_service_interval
		var/running = ambience.move_service_interval_running_override
		var/steps = ambience.move_service_steps
		var/cap = ambience.max_services_per_tick
		var/door_period = ambience.door_recheck ? ambience.door_recheck_period : 0
		var/list/entries = list(
			"模式：[get_sound_setting_display(point_ambience_mode_name(ambience.mode))]" = "mode",
			"移动更新间隔：[interval] 分秒" = "interval",
			"奔跑专用间隔：[running ? "[running] 分秒" : "无"]" = "running",
			"步数：[steps ? steps : "关闭"]" = "steps",
			"超速静音：[ambience.speed_cutoff ? "开启" : "关闭"]" = "cutoff",
			"每刻处理数：[cap ? cap : "不限"]" = "cap",
			"队列：[ambience.use_queue ? "开启" : "关闭"]" = "queue",
			"静止检查跳过时限：[ambience.standing_skip] 分秒" = "skip",
			"门状态复查：[door_period ? "每 [door_period] 分秒" : "关闭"]" = "doors",
			"将模式以外的设置恢复为配置值" = "reset",
		)
		var/not_live = (ambience.mode == POINT_AMBIENCE_LIVE) ? "" : " 当前未启用实时局部环境音，这些设置将在启用后生效。"
		var/pick = input(src, "局部环境音负载设置。选择一项进行修改，完成后取消。1 分秒为 0.1 秒。[not_live]", "局部环境音模式") as null|anything in entries
		if(!pick)
			return
		switch(entries[pick])
			if("mode")
				if(ambience.mode == POINT_AMBIENCE_FALLBACK)
					to_chat(src, span_warning("局部环境音正在使用启动时由 POINT_AMBIENCE_MODE 指定的备用循环音。此指令无法切回该模式，退出后须等到下一回合才能恢复。"))
				var/choice = input_sound_display("实时模式会随移动和时钟刻为每位客户端更新最近的声源。关闭则静音。备用循环音只能在启动时选择：回合中切入该模式会让所有声源同时开始普通循环播放，拖延 SSsound_loops 中的其他任务。", "局部环境音模式", list("Live", "Off"), point_ambience_mode_name(ambience.mode))
				var/new_mode = (choice == "Live") ? POINT_AMBIENCE_LIVE : POINT_AMBIENCE_OFF
				if(!choice || new_mode == ambience.mode)
					continue
				point_ambience_setting_changed("mode", point_ambience_mode_name(ambience.mode), choice)
				ambience.set_mode(new_mode)
			if("interval")
				var/binds = steps ? " 步数为 [steps]，正常移动者会更早触发步数更新；此间隔仅约束每步耗时超过 [round(interval / steps, 0.1)] 分秒的移动者。" : " 步数限制已关闭，此值决定所有移动者的更新间隔。"
				var/value = point_ambience_number("同一客户端两次移动钩子更新之间的最长时间，单位为分秒（0.1 秒）。0 表示每步更新。[binds]", "移动更新间隔", interval)
				if(!isnull(value))
					point_ambience_setting_changed("move interval", interval, value)
					ambience.move_service_interval = value
			if("running")
				var/binds = steps ? " 步数为 [steps]，正常奔跑者会更早触发步数更新；此间隔仅约束每步耗时超过 [round((running ? running : interval) / steps, 0.1)] 分秒的移动者。" : ""
				var/value = point_ambience_number("替代奔跑客户端的移动更新间隔。0 表示不覆盖，奔跑者沿用普通移动间隔，并非不受限制。普通移动间隔为 0 时，所有人的间隔限制均关闭，此项无效。[binds]", "奔跑专用间隔", running)
				if(!isnull(value))
					point_ambience_setting_changed("running override", running, value)
					ambience.move_service_interval_running_override = value
			if("steps")
				var/value = point_ambience_number("正常行走或奔跑时，两次移动钩子更新之间最多允许的步数。只会缩短上述两种间隔，它们仍作为最长时限；0 表示不干预。间隔为 12 时，步数设为 2 会让速度 10 的行走者每 6 分秒更新一次，而非每 12 分秒，处理次数翻倍。", "步数", steps)
				if(!isnull(value))
					point_ambience_setting_changed("steps", steps, value)
					ambience.move_service_steps = value
			if("cutoff")
				var/value = point_ambience_toggle("因药物、能力、变形或快速坐骑而超过自然速度 15 奔跑速度的角色，移动时听不到局部环境音。自己手中的火炬仍会发声。关闭后，这些角色与其他人一样正常更新。", "超速静音", ambience.speed_cutoff)
				if(!isnull(value))
					point_ambience_setting_changed("speed cutoff", ambience.speed_cutoff ? "on" : "off", value ? "on" : "off")
					ambience.speed_cutoff = value
			if("cap")
				var/value = point_ambience_number("所有客户端每刻移动更新次数的总上限。启用队列时，这是出队预算，余下任务等到下一刻。内联处理时会拒绝超额更新，且时钟刻耗时超过一半后也会拒绝。0 关闭这两种限制。每秒 20 刻时，设为 8 可每秒处理最多 160 次，足够 48 名行走者每步都更新。", "每刻处理数", cap)
				if(!isnull(value))
					point_ambience_setting_changed("services per tick", cap, value)
					ambience.max_services_per_tick = value
			if("queue")
				// fire() drains existing marks even when queueing is disabled. Only new movement
				// runs inline
				var/value = point_ambience_toggle("开启：移动时标记客户端，子系统下次运行时按等待时间依次处理，遵守次数上限和自身的时钟刻预算。关闭：每步都在 Move() 内联处理，此时该刻的其他任务已耗费各自份额，唯一限制是在时钟刻耗时过半后拒绝处理。关闭会加重高负载服务器的压力，而非节省开销。", "队列", ambience.use_queue)
				if(!isnull(value))
					point_ambience_setting_changed("queue", ambience.use_queue ? "on" : "off", value ? "on" : "off")
					ambience.use_queue = value
			if("skip")
				var/value = point_ambience_number("每秒一次的遍历检查会跳过在此时限内已因移动更新过的客户端，单位为分秒。否则，正在行走的人会在即将离开的地块上被重复更新。0 表示从不跳过。代价是停步后的追赶延迟：最坏情况下为此时限加一秒。", "静止检查跳过时限", ambience.standing_skip)
				if(!isnull(value))
					point_ambience_setting_changed("standing skip", ambience.standing_skip, value)
					ambience.standing_skip = value
			if("doors")
				var/value = point_ambience_number("收集开关门附近听者并重新更新声音的间隔，单位为分秒，让站着不动的人也能听见变化。0 表示关闭，听者须移动后才能听见变化。反复开关的门每周期只收集一次，因此间隔越短反应越快，开销也越大。单名听者实测：每次收集约 24 微秒，每名听者重新更新约 72 微秒。", "门状态复查", door_period)
				if(!isnull(value))
					point_ambience_setting_changed("door re-check", door_period, value)
					ambience.door_recheck = value > 0
					if(value)
						ambience.door_recheck_period = value
					else
						ambience.changed_doors.Cut()
			if("reset")
				var/confirm = input_sound_display("将模式以外的所有设置恢复为配置值，并将门状态复查恢复为默认值？", "重置局部环境音", list("Reset", "Cancel"))
				if(confirm == "Reset")
					point_ambience_reset_settings()

/// Puts every setting the config seeds, the mode aside, back to its config value, logging each change
/client/proc/point_ambience_reset_settings()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	var/value = CONFIG_GET(number/point_ambience_move_interval)
	point_ambience_setting_changed("move interval", ambience.move_service_interval, value)
	ambience.move_service_interval = value
	value = CONFIG_GET(number/point_ambience_move_interval_running_override)
	point_ambience_setting_changed("running override", ambience.move_service_interval_running_override, value)
	ambience.move_service_interval_running_override = value
	value = CONFIG_GET(number/point_ambience_move_steps)
	point_ambience_setting_changed("steps", ambience.move_service_steps, value)
	ambience.move_service_steps = value
	value = !!CONFIG_GET(number/point_ambience_speed_cutoff)
	point_ambience_setting_changed("speed cutoff", ambience.speed_cutoff ? "on" : "off", value ? "on" : "off")
	ambience.speed_cutoff = value
	value = CONFIG_GET(number/point_ambience_max_services_per_tick)
	point_ambience_setting_changed("services per tick", ambience.max_services_per_tick, value)
	ambience.max_services_per_tick = value
	value = !!CONFIG_GET(number/point_ambience_queue)
	point_ambience_setting_changed("queue", ambience.use_queue ? "on" : "off", value ? "on" : "off")
	ambience.use_queue = value
	value = CONFIG_GET(number/point_ambience_standing_skip)
	point_ambience_setting_changed("standing skip", ambience.standing_skip, value)
	ambience.standing_skip = value
	// Reset configured acoustic settings too, invalidating their previous results
	value = CONFIG_GET(number/point_ambience_falloff_hardness)
	if(value != ambience.falloff_hardness)
		point_ambience_setting_changed("falloff hardness", ambience.falloff_hardness, value)
		ambience.set_falloff_hardness(value)
	value = !!CONFIG_GET(number/point_ambience_pan_depth_floor)
	if(value != !!ambience.pan_depth_floor)
		point_ambience_setting_changed("pan depth floor", ambience.pan_depth_floor ? "on" : "off", value ? "on" : "off")
		ambience.pan_depth_floor = value
		ambience.invalidate_listener_cache()
	// No config entry, so the default in the code
	value = initial(ambience.door_recheck) ? initial(ambience.door_recheck_period) : 0
	point_ambience_setting_changed("door re-check", ambience.door_recheck ? ambience.door_recheck_period : 0, value)
	ambience.door_recheck = initial(ambience.door_recheck)
	ambience.door_recheck_period = initial(ambience.door_recheck_period)

/// A whole number of at least 0, or null when cancelled
/client/proc/point_ambience_number(message, title, current)
	var/value = input(src, message, title, current) as null|num
	return isnull(value) ? null : max(0, round(value))

/// TRUE or FALSE, or null when cancelled. A list rather than alert(), which has no cancel
/client/proc/point_ambience_toggle(message, title, current)
	var/choice = input_sound_display(message, title, list("On", "Off"), current ? "On" : "Off")
	return isnull(choice) ? null : (choice == "On")

/// One admin message and log line per setting that actually changed
/client/proc/point_ambience_setting_changed(setting, old_value, new_value)
	if(old_value == new_value)
		return
	var/summary = "将局部环境音的[get_sound_setting_display(setting)]从[get_sound_setting_display(old_value)]改为[get_sound_setting_display(new_value)]"
	message_admins("[key_name_admin(src)] [summary]。")
	log_admin("[key_name(src)] [summary]。")

/proc/point_ambience_mode_name(mode)
	switch(mode)
		if(POINT_AMBIENCE_LIVE)
			return "Live"
		if(POINT_AMBIENCE_OFF)
			return "Off"
		if(POINT_AMBIENCE_FALLBACK)
			return "Fallback loops"
	return "unknown"
