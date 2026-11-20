// 旁观只借用感官，不转移身体、知识或物品权限。
/mob/living
	var/list/group_mindlink_sense_watchers
	var/list/group_mindlink_scene_channels

// sound() 的首参是音频文件，不能把声音对象当作文件来复制；每位听者使用独立对象。
/proc/group_mindlink_copy_sound(sound/template)
	if(!istype(template))
		return null
	var/sound/result = sound(template.file, template.repeat, template.wait, template.channel, template.volume)
	result.frequency = template.frequency
	result.pitch = template.pitch
	result.pan = template.pan
	result.priority = template.priority
	result.status = template.status
	result.offset = template.offset
	result.x = template.x
	result.y = template.y
	result.z = template.z
	result.falloff = template.falloff
	var/list/environment = template.environment
	result.environment = islist(environment) ? environment.Copy() : environment
	var/list/echo = template.echo
	result.echo = islist(echo) ? echo.Copy() : echo
	return result

/datum/group_mindlink_view
	var/next_examine = 0
	var/restoring_sounds = FALSE
	var/list/local_loops = list()
	var/list/remote_loops = list()
	var/list/one_shot_channels = list()
	var/next_sound_channel = 1
	var/list/ambient_sounds = list()
	var/list/ambient_channels = list()
	var/saved_ambience_time
	var/had_ambience_timer = FALSE
	var/last_heard_at = -1
	var/last_heard_speaker
	var/last_heard_text
	var/target_was_hearing = TRUE

/datum/group_mindlink_view/proc/senses_valid()
	return !QDELETED(src) && viewer?.group_mindlink_borrowed_eye() == target && !target.group_mindlink_view

// 与视野锥遮挡规则一致，但也接受物品和地板，不能仅检查人物。
/proc/group_mindlink_visible(mob/living/target, atom/subject)
	if(QDELETED(target) || !target.client || QDELETED(subject) || istype(subject, /atom/movable/screen))
		return FALSE
	if(!isturf(subject) && !isturf(subject.loc))
		return FALSE
	if(is_blind(target) || !subject.alpha || subject.invisibility > target.see_invisible || !(subject in view(target.client.view, target)))
		return FALSE
	var/turf/subject_turf = get_turf(subject)
	if(!subject_turf || subject_turf.z != target.z)
		return FALSE
	if(target.lighting_alpha && get_dist(target, subject) > target.see_in_dark && subject_turf.get_lumcount() <= 0)
		return FALSE
	if(!target.cone_showing || !target.hud_used?.fov?.alpha || get_dist(target, subject) == 0)
		return TRUE
	var/list/blocked_dirs = list()
	var/check_behind = FALSE
	if(target.fovangle & FOV_RIGHT)
		if(target.fovangle & FOV_LEFT)
			blocked_dirs = list(turn(target.dir, 180), turn(target.dir, -90), turn(target.dir, 90))
		else if(target.fovangle & FOV_BEHIND)
			blocked_dirs = list(turn(target.dir, -90))
			check_behind = TRUE
	else if(target.fovangle & FOV_LEFT)
		blocked_dirs = list(turn(target.dir, 90))
		if(target.fovangle & FOV_BEHIND)
			check_behind = TRUE
		else
			blocked_dirs += turn(target.dir, 180)
	else if(target.fovangle & FOV_BEHIND)
		check_behind = TRUE
	else
		blocked_dirs = list(turn(target.dir, 180))
	if(check_behind && subject.BehindAtom(target, turn(target.dir, 180)))
		return FALSE
	for(var/direction in blocked_dirs)
		if(subject.InCone(target, direction))
			return FALSE
	return TRUE

/datum/group_mindlink_view/proc/can_examine(atom/subject)
	return senses_valid() && group_mindlink_visible(target, subject)

/datum/group_mindlink_view/proc/examine_visible(atom/subject)
	if(world.time < next_examine)
		return
	next_examine = world.time + 2
	if(!can_examine(subject))
		to_chat(viewer, span_notice("只能检视借用视角中实际可见的事物。"))
		return
	// 普通 examine 及其信号、检视效果可能改动世界；远程只调用专用只读接口。
	var/list/description = subject.group_mindlink_examine(viewer)
	if(!senses_valid() || !length(description))
		return
	// 以纯文本显示，不保留检查、容器、配方或其他可操作的超链接与悬浮组件。
	var/list/plain_lines = list()
	for(var/line in description)
		plain_lines += html_encode(group_mindlink_plain_text("[line]"))
	to_chat(viewer, examine_block(plain_lines.Join("<br>")))

// 只读接口仅返回可见描述，不发信号、不调用普通检视、不读取容器内容。
// 新增专用描述时必须遵守同一约定，不能调用带动作、通知或状态变化的过程。
/atom/proc/group_mindlink_examine(mob/living/user)
	. = list("那是[name]。")
	if(desc)
		. += desc
	if(!reagents)
		return
	if(reagents.flags & TRANSPARENT)
		if(!length(reagents.reagent_list))
			. += "里面什么也没有。"
		else if(user.can_see_reagents())
			// 仅使用观看者本人的辨认能力，不把远端邻接当作接触检查。
			for(var/datum/reagent/reagent as anything in reagents.reagent_list)
				. += "它包含[round(reagent.volume, 0.1)] [UNIT_FORM_STRING(round(reagent.volume, 0.1))]的[reagent.name]。"
		else
			. += "它包含[round(reagents.total_volume, 0.1)] [UNIT_FORM_STRING(round(reagents.total_volume, 0.1))]的某种物质。"
	else if(reagents.flags & AMOUNT_VISIBLE)
		. += reagents.total_volume ? "它还剩下[round(reagents.total_volume, 0.1)] [UNIT_FORM_STRING(round(reagents.total_volume, 0.1))]。" : "它是空的。"

/obj/item/group_mindlink_examine(mob/living/user)
	. = ..()
	if(original_name && original_name != name)
		. += "原名：[original_name]"
	if(max_integrity > 0 && integrity_failure < 1)
		var/condition = integrity_check()
		if(condition)
			. += condition
	var/list/quality = quality_examine_suffix()
	if(quality)
		. += quality["text"]
	// 只读取现有价格，不调用会随机改价的 get_real_price，也不递归估算容器内容。
	var/value = sellprice || GLOB.derived_sellprices?[type] || lookup_derived_subtype_price(type)
	if(looted && value > 0)
		value = max(1, round(value * LOOTED_SELL_MULT))
	if(value > 0 && (HAS_TRAIT(user, TRAIT_SEEPRICES) || simpleton_price))
		. += "物品本身价值：[value] 玛门币。"
	else if(value > 0 && HAS_TRAIT(user, TRAIT_SEEPRICES_SHITTY))
		var/static/fumbling_seed = text2num(GLOB.rogue_round_id)
		var/estimate = max(1, round(value + (value * clamp(noise_hash(value, fumbling_seed) - 0.25, -0.25, 0.25)), 1))
		. += "物品本身价值：约[estimate] 玛门币（不确定）。"
	if(user.STAINT >= 9)
		if(anvilrepair)
			var/datum/skill/repair_skill = anvilrepair
			. += "可以使用[initial(repair_skill.name)]和一把锤子修理。"
		if(sewrepair)
			. += "可以使用缝纫和一根针修理。"

/obj/item/rogueweapon/group_mindlink_examine(mob/living/user)
	. = ..()
	var/blade_condition = get_blade_dulling_text(src)
	if(blade_condition)
		. += blade_condition

/mob/living/carbon/human/group_mindlink_examine(mob/living/user)
	// 不走 on_examine_face，不新增熟人、不施加心情，也不输出头衔或交互链接。
	var/face_hidden = get_face_name("") != real_name || HAS_TRAIT(user, TRAIT_PROSOPAGNOSIA)
	var/recognized = !face_hidden && (user == src || (real_name in user.mind?.known_people))
	. = list(recognized ? "这是[get_visible_name()]。" : "这是一位未知人物。")
	if(face_hidden)
		. += build_cool_description_unknown(get_mob_descriptors_unknown(TRUE, user), src, user)
	else
		. += build_cool_description(get_mob_descriptors(!recognized, user), src, user)
	var/list/obscured = check_obscured_slots()
	var/static/list/visible_slots = list(SLOT_SHIRT, SLOT_PANTS, SLOT_HEAD, SLOT_ARMOR, SLOT_CLOAK, SLOT_BACK_R, SLOT_BACK_L, SLOT_GLOVES, SLOT_BELT, SLOT_BELT_R, SLOT_BELT_L, SLOT_SHOES, SLOT_WEAR_MASK, SLOT_NECK, SLOT_WRISTS, SLOT_MOUTH)
	for(var/slot in visible_slots)
		if(slot in obscured)
			continue
		var/obj/item/item = get_item_by_slot(slot)
		if(item)
			. += "[p_they(TRUE)]佩戴着[item.name]。"
	for(var/obj/item/item as anything in held_items)
		if(item)
			. += "[p_they(TRUE)]手中拿着[item.name]。"
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_FAKEDEATH))
		. += "[p_they(TRUE)]看起来没有生命迹象。"
	else if(stat != CONSCIOUS)
		. += "[p_they(TRUE)]看起来失去了意识。"

// 拟态仍显示伪装物的描述，不能由专用接口暴露其真实种类。
/mob/living/simple_animal/hostile/retaliate/rogue/mimic/group_mindlink_examine(mob/living/user)
	if(aggressive)
		return ..()
	. = list("那是[name]。")
	if(mimicking_chest::desc)
		. += mimicking_chest::desc

/proc/group_mindlink_plain_text(text)
	var/static/regex/tags = regex(@"<[^>]*>", "g")
	text = replacetext(text, "<br>", "\n")
	return html_decode(tags.Replace(text, ""))

/proc/group_mindlink_examine_choices(mob/living/user)
	var/mob/living/borrowed_eye = user?.group_mindlink_borrowed_eye()
	if(borrowed_eye)
		return view(borrowed_eye.client.view, borrowed_eye)
	return view(user)

/mob/living/carbon/examinate(atom/subject as mob|obj|turf in group_mindlink_examine_choices(usr))
	// 沿用父级检视指令的名称、分类及隐藏设置，避免重复定义指令属性。
	if(!QDELETED(group_mindlink_view))
		group_mindlink_view.examine_visible(subject)
		return
	return ..()

// 只转发环境中的口头交流，排除无线电、手语和心灵等非环境消息。
/proc/group_mindlink_local_speech(atom/movable/speaker, radio_freq, message_mode, message_language)
	if(radio_freq || istype(speaker, /atom/movable/virtualspeaker))
		return FALSE
	if(message_mode && !(message_mode in list(MODE_WHISPER, MODE_WHISPER_CRIT, MODE_SING, MODE_HEADSET, MODE_R_HAND, MODE_L_HAND, MODE_INTERCOM, MODE_DEPARTMENT)))
		return FALSE
	var/datum/language/language = GLOB.language_datum_instances[message_language]
	return !(language?.flags & SIGNLANG)

// human/Hear 的活体头颅过滤先执行，本层不绕过它，也不复制目标的私有聊天输出。
/mob/living/carbon/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!QDELETED(group_mindlink_view) && group_mindlink_local_speech(speaker, radio_freq, message_mode, message_language))
		return
	return ..()

/datum/group_mindlink_view/proc/hear_target(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	if(!senses_valid() || !target.can_hear())
		return
	var/atom/movable/speaker = hearing_args[2]
	var/message_language = hearing_args[3]
	var/raw_message = hearing_args[4]
	var/radio_freq = hearing_args[5]
	var/list/spans = hearing_args[6]
	var/message_mode = hearing_args[7]
	if(QDELETED(speaker) || !group_mindlink_local_speech(speaker, radio_freq, message_mode, message_language))
		return
	// 同一次接收可能经身体与头颅多次进入；只去重同刻、同来源、同内容的事件。
	if(last_heard_at == world.time && last_heard_speaker == REF(speaker) && last_heard_text == raw_message)
		return
	last_heard_at = world.time
	last_heard_speaker = REF(speaker)
	last_heard_text = raw_message
	var/speaker_name = speaker.GetVoice()
	var/mob/living/carbon/human/person
	if(ishuman(speaker))
		person = speaker
	else if(istype(speaker, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = speaker
		person = head.harmless_live_owner || head.original_owner
	if(istype(person))
		if(!(person.real_name in viewer.mind?.known_people) && person != viewer)
			speaker_name = person.get_alt_name(TRUE)
		else
			speaker_name = person.get_alt_name() || person.GetVoice()
	// 保留目标收到的低语缺字，但清除属于目标昵称的高亮；语言仍由观看者判断。
	var/clean_message = html_encode(group_mindlink_plain_text(raw_message))
	var/list/own_spans = viewer.handle_language_spans(spans?.Copy())
	var/rendered = viewer.lang_treat(speaker, message_language, clean_message, own_spans, message_mode)
	to_chat(viewer, "<span class='notice'>\[心灵听觉 · [html_encode(context.link.member_name(target))]\]</span> <span class='name'>[html_encode(speaker_name)]</span> [rendered]")

/datum/group_mindlink_view/proc/start_senses()
	LAZYADD(target.group_mindlink_sense_watchers, src)
	RegisterSignal(target, COMSIG_MOVABLE_HEAR, PROC_REF(hear_target))
	had_ambience_timer = (view_client in SSambience.ambience_listening_clients)
	saved_ambience_time = SSambience.ambience_listening_clients[view_client]
	SSambience.remove_ambience_client(view_client)
	// 只停止已由场景音效入口记录的声音，不能误停直接发送的系统提示或私有音效。
	for(var/sound/playing in view_client.SoundQuery())
		if(viewer.group_mindlink_scene_channels?["[playing.channel]"] == playing.file)
			viewer.stop_sound_channel(playing.channel)
	// 保留令牌监听关系，退场时重新发送仍有效的声音。
	for(var/datum/sound_token/token as anything in viewer.sound_tokens)
		if(findtext("[token.sound?.file]", "sound/music/"))
			continue
		local_loops |= token
		viewer.stop_sound_channel(token.sound_channel)
	process_senses()

/datum/group_mindlink_view/proc/stop_senses()
	if(target)
		UnregisterSignal(target, COMSIG_MOVABLE_HEAR)
		LAZYREMOVE(target.group_mindlink_sense_watchers, src)
	if(view_client)
		for(var/channel in one_shot_channels)
			SEND_SOUND(view_client, sound(null, channel = channel))
		for(var/channel_key in ambient_channels)
			SEND_SOUND(view_client, sound(null, channel = ambient_channels[channel_key]))
	for(var/datum/sound_token/loop as anything in remote_loops.Copy())
		remove_loop(loop)
	SSsounds.free_datum_channels(src)
	if(view_client?.mob == viewer && !QDELETED(viewer))
		restoring_sounds = TRUE
		for(var/datum/sound_token/token as anything in local_loops)
			if(!QDELETED(token) && !isnull(token.listeners[viewer]))
				token.update_listener(viewer, FALSE)
		var/area/current_area = get_area(viewer)
		SSdroning.kill_loop(view_client)
		SSdroning.kill_rain(view_client)
		SSdroning.play_loop(current_area, view_client)
		SSdroning.play_rain(current_area, view_client)
		if(had_ambience_timer)
			SSambience.ambience_listening_clients[view_client] = max(world.time, saved_ambience_time)
		restoring_sounds = FALSE
	local_loops.Cut()
	ambient_sounds.Cut()
	ambient_channels.Cut()
	one_shot_channels.Cut()

// 音效的原始接收名单已由 playsound 检查墙体和传播范围；只在真正的接收者上转发。
/mob/living/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent, channel = 0, pressure_affected = FALSE, sound/S, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE, muffled = FALSE, min_volume = SOUND_DEFAULT_MIN_VOLUME, travel = SOUND_TRAVEL_UNRESTRICTED, floor_volume = null, erp = FALSE, volume_pref = null)
	var/datum/sound_token/token
	for(var/datum/sound_token/candidate as anything in sound_tokens)
		if(candidate.sound_channel == channel)
			token = candidate
			break
	var/scene_sound = (!channel || channel <= CHANNEL_HIGHEST_AVAILABLE) && isturf(turf_source)
	var/sound_file = S?.file || soundin
	if(istype(sound_file, /sound))
		var/sound/file_sound = sound_file
		sound_file = file_sound.file
	if(findtext("[sound_file]", "sound/music/") || findtext("[sound_file]", "sound/misc/notice"))
		scene_sound = FALSE
	if(!QDELETED(group_mindlink_view) && !group_mindlink_view.restoring_sounds && (scene_sound || channel == CHANNEL_WEATHER))
		if(token)
			group_mindlink_view.local_loops |= token
		return FALSE
	if(!scene_sound || !client || !can_hear())
		if(token)
			for(var/datum/group_mindlink_view/view as anything in group_mindlink_sense_watchers)
				view.remove_loop(token)
		return ..()
	// 复制每位听者的声音，沿用当前声音系统的衰减、楼层和混响。
	var/sound/played_sound = S ? group_mindlink_copy_sound(S) : (istype(soundin, /sound) ? group_mindlink_copy_sound(soundin) : sound(get_sfx(soundin)))
	. = ..(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, played_sound, max_distance, falloff_distance, distance_multiplier, use_reverb, muffled, min_volume, travel, floor_volume, erp, volume_pref)
	if(!.)
		if(token)
			for(var/datum/group_mindlink_view/view as anything in group_mindlink_sense_watchers)
				view.remove_loop(token)
		return
	LAZYINITLIST(group_mindlink_scene_channels)
	group_mindlink_scene_channels["[played_sound.channel]"] = played_sound.file
	var/listener_volume = isnull(volume_pref) ? client.prefs.at_overall(client.prefs.mastervol) : volume_pref
	for(var/datum/group_mindlink_view/view as anything in group_mindlink_sense_watchers)
		view.receive_sound(played_sound, token, listener_volume)

/datum/group_mindlink_view/proc/receive_sound(sound/template, datum/sound_token/token, listener_volume)
	if(!senses_valid() || !target.can_hear() || !template?.file || listener_volume <= 0)
		return
	var/sound/received = group_mindlink_copy_sound(template)
	var/preference = token?.respect_instrument_pref ? view_client.prefs.instrumentvol : view_client.prefs.mastervol
	received.volume = min(100, received.volume / listener_volume * view_client.prefs.at_overall(preference))
	if(token)
		var/sound/previous = remote_loops[token]
		received.channel = previous?.channel || SSsounds.reserve_sound_channel_for_datum(src)
		if(!received.channel)
			return
		if(previous?.file != received.file)
			received.status &= ~SOUND_UPDATE
			var/duration = (token.stand_in?.file == template.file) ? token.stand_in_duration : token.sound_duration
			received.offset = token.calculate_offset(duration)
			if(isnull(received.offset))
				SEND_SOUND(view_client, sound(null, channel = received.channel))
				SSsounds.free_sound_channel(received.channel)
				remote_loops -= token
				return
		remote_loops[token] = received
	else
		// 一次性音效使用有界通道池。
		if(length(one_shot_channels) < 8)
			var/channel = SSsounds.reserve_sound_channel_for_datum(src)
			if(channel)
				one_shot_channels += channel
		if(!length(one_shot_channels))
			return
		next_sound_channel = ((next_sound_channel - 1) % length(one_shot_channels)) + 1
		received.channel = one_shot_channels[next_sound_channel++]
	SEND_SOUND(view_client, received)

/datum/group_mindlink_view/proc/remove_loop(datum/sound_token/loop)
	var/sound/previous = remote_loops[loop]
	if(!previous)
		return
	if(view_client)
		SEND_SOUND(view_client, sound(null, channel = previous.channel))
	SSsounds.free_sound_channel(previous.channel)
	remote_loops -= loop

/datum/group_mindlink_view/proc/process_senses()
	if(!senses_valid())
		return
	var/hearing = target.can_hear()
	if(!hearing && target_was_hearing)
		for(var/channel in one_shot_channels)
			SEND_SOUND(view_client, sound(null, channel = channel))
	target_was_hearing = hearing
	SSambience.remove_ambience_client(view_client)
	// 从现有入口取得目标获准听到的声音，也覆盖切入前已开始的令牌。
	for(var/datum/sound_token/token as anything in target.sound_tokens)
		if(!QDELETED(token))
			token.update_listener(target)
	for(var/datum/sound_token/loop as anything in remote_loops.Copy())
		if(QDELETED(loop) || !hearing || isnull(loop.listeners[target]) || (loop.listeners[target] & SOUND_MUTE) || !LAZYACCESS(loop.started_listeners, target))
			remove_loop(loop)
	// 环境底噪与雨声由专用通道直接发送，不经过 playsound_local；只同步这三个环境通道。
	var/list/environment_channels = list(CHANNEL_AMBIENCE, CHANNEL_RAIN, CHANNEL_WEATHER)
	for(var/channel in environment_channels)
		SEND_SOUND(view_client, sound(null, channel = channel))
	var/list/present = list()
	if(target.can_hear())
		for(var/sound/environment in target.client.SoundQuery())
			if(!(environment.channel in environment_channels) || !environment.file || (environment.status & SOUND_MUTE))
				continue
			var/key = "[environment.channel]"
			present += key
			var/sound/previous = ambient_sounds[key]
			var/sound/received = group_mindlink_copy_sound(environment)
			if(!ambient_channels[key])
				ambient_channels[key] = SSsounds.reserve_sound_channel_for_datum(src)
			if(!ambient_channels[key])
				continue
			received.channel = ambient_channels[key]
			received.status = previous?.file == received.file ? SOUND_UPDATE : 0
			// SoundQuery 不提供实际播放音量，环境声直接遵循观看者设置，不能按查询默认值反推。
			received.volume = clamp(view_client.prefs.ambiencevol, 0, 100)
			if(environment.channel == CHANNEL_WEATHER)
				received.volume = clamp(view_client.prefs.mastervol, 0, 100)
				var/datum/looping_sound/weather = SSParticleWeather.runningWeather?.currentSounds[target]
				if(weather?.sound_channel == CHANNEL_WEATHER)
					received.volume = clamp(view_client.prefs.at_overall(weather.volume * view_client.prefs.mastervol * 0.01), 0, 100)
			ambient_sounds[key] = received
			SEND_SOUND(view_client, received)
	for(var/key in ambient_sounds.Copy())
		if(!(key in present))
			SEND_SOUND(view_client, sound(null, channel = ambient_channels[key]))
			ambient_sounds -= key
