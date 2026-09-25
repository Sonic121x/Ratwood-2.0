#define HARMLESS_REATTACH_GLOW_FILTER "harmless_reattach_glow"
#define HARMLESS_HEAD_HEARING_SOURCE "harmless_live_head"

/atom/movable/screen/alert/status_effect/buff/harmless_dismemberment
	name = "无害肢解"
	desc = "我的肉身像一件被温柔拆开的旧衣。断口不流血，不呼痛，只在等待被放回原处。"
	icon_state = "buff"

/mob/living/carbon/human
	var/obj/item/bodypart/head/harmless_live_head_source
	var/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/harmless_dismemberment_selector_spell
	var/mob/living/carbon/human/harmless_dismemberment_locked_target

/mob/living/carbon/human/proc/get_harmless_live_head_source()
	if(QDELETED(harmless_live_head_source))
		harmless_live_head_source = null
		return null
	if(!harmless_live_head_source?.harmless_live_head)
		harmless_live_head_source = null
		return null
	if(harmless_live_head_source.harmless_live_owner != src)
		harmless_live_head_source = null
		return null
	var/datum/status_effect/buff/harmless_dismemberment/effect = has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
	if(QDELETED(effect) || !(harmless_live_head_source in effect.detached_bodyparts) || get_bodypart(BODY_ZONE_HEAD) || isdullahan(src))
		harmless_live_head_source.disable_harmless_live_head()
		return null
	return harmless_live_head_source

// 头身分离时，仅由头颅转发环境对话；无线电及非环境消息仍沿用原有接收方式。
/mob/living/carbon/human/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, original_message, obj/item/bodypart/head/relay_head)
	var/obj/item/bodypart/head/live_head = get_harmless_live_head_source()
	var/static/list/nonlocal_modes = list(MODE_BINARY, MODE_CHANGELING, MODE_ADMIN, MODE_DEADMIN)
	var/local_speech = !radio_freq && !(message_mode in nonlocal_modes) && !istype(speaker, /atom/movable/virtualspeaker)
	if(live_head && local_speech && relay_head != live_head)
		return
	return ..(message, speaker, message_language, raw_message, radio_freq, spans, message_mode, original_message)

// 本覆盖替代 dullahan_head.dm 中的 head/Hear，需保留原生头颅的转发行为。
/obj/item/bodypart/head/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	. = ..()
	if(harmless_live_head)
		var/mob/living/carbon/human/head_owner = harmless_live_owner
		if(!QDELETED(head_owner) && head_owner.get_harmless_live_head_source() == src)
			return head_owner.Hear(message, speaker, message_language, raw_message, radio_freq, spans, message_mode, original_message, src)
		return
	if(!QDELETED(original_owner))
		original_owner.Hear(message, speaker, message_language, raw_message, radio_freq, spans, message_mode, original_message)

/mob/living/carbon/human/proc/get_harmless_dismemberment_locked_target()
	if(QDELETED(harmless_dismemberment_locked_target))
		harmless_dismemberment_locked_target = null
		return null
	if(!harmless_dismemberment_locked_target)
		return null
	var/datum/status_effect/buff/harmless_dismemberment/effect = harmless_dismemberment_locked_target.has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
	if(!effect || effect.controller != src || effect.controller_mind != mind)
		harmless_dismemberment_locked_target = null
		return null
	return harmless_dismemberment_locked_target

/mob/living/carbon/human/proc/set_harmless_dismemberment_locked_target(mob/living/carbon/human/target)
	if(!istype(target))
		return
	harmless_dismemberment_locked_target = target

/mob/living/carbon/human/proc/clear_harmless_dismemberment_locked_target(mob/living/carbon/human/target)
	if(target && harmless_dismemberment_locked_target != target)
		return
	harmless_dismemberment_locked_target = null

/mob/living/carbon/human/GetSource()
	var/obj/item/bodypart/head/live_head = get_harmless_live_head_source()
	if(live_head)
		return live_head
	return ..()

/mob/living/carbon/human/GetVoice()
	var/obj/item/bodypart/head/live_head = get_harmless_live_head_source()
	if(live_head)
		return "[real_name]的头颅"
	// 复刻核心 /mob/living/carbon/human/GetVoice（say.dm）的行为：本覆盖取代了核心同名
	// 过程，而 ..() 只会落到父级 GetVoice，会跳过“特殊嗓音”（伪装/变声）逻辑。
	// 因此这里必须自行优先返回特殊嗓音，否则返回真名，避免全局变声功能失效。
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language = null, message_mode, original_message)
	var/obj/item/bodypart/head/live_head = get_harmless_live_head_source()
	if(live_head)
		// 顶着活体头颅时，把说话整体转交给头颅处理（其内含独立的头颅嗓音逻辑）。
		return live_head.send_speech(message, message_range, live_head, bubble_type, spans, message_language, message_mode, original_message)
	// 无活体头颅：本覆盖取代了核心 human/send_speech 与 xylix 拟声术的同名覆盖，
	// 而 ..() 只会落到父级 /mob/living/send_speech，会丢失 xylix 戏法傀儡的发声中继。
	// 因此这里复刻“当前生效的核心行为”（xylix 版本：调用父级后，向戏法傀儡的旁观者投射聊天气泡）。
	. = ..()
	if(!istype(loc, /obj/effect/dummy/parlor_trick))
		return
	var/obj/effect/dummy/parlor_trick/parlor_dummy = loc
	var/list/hearers = get_hearers_in_view(message_range, source)
	for(var/mob/M in hearers)
		M.create_chat_message(parlor_dummy, message_language, message, spans, message_mode)

/obj/item/bodypart/head/send_speech(message, message_range = 6, obj/source = src, bubble_type = "default", list/spans, datum/language/message_language = null, message_mode, original_message)
	var/mob/living/carbon/human/head_owner = harmless_live_owner
	if(!harmless_live_head)
		return ..()
	if(QDELETED(head_owner) || head_owner.get_harmless_live_head_source() != src)
		return
	if(!bubble_type || bubble_type == "default")
		bubble_type = head_owner.bubble_icon || "default"
	// 在模块内适配 living/say.dm：以头颅位置为发声源，
	// 权限、状态效果、日志身份及声音设置仍取自原主人。
	var/atom/movable/speaker_atom = src
	var/static/list/eavesdropping_modes = list(MODE_WHISPER = TRUE, MODE_WHISPER_CRIT = TRUE)
	var/eavesdrop_range = 0
	var/Zs_too = FALSE
	var/Zs_all = FALSE
	var/Zs_yell = FALSE
	var/listener_has_ceiling	= TRUE
	var/speaker_has_ceiling		= TRUE
	var/turf/speaker_turf = get_turf(speaker_atom)
	if(!speaker_turf)
		return
	var/turf/speaker_ceiling = GET_TURF_ABOVE(speaker_turf)
	var/line_of_sight_only = FALSE

	if(speaker_ceiling)
		if(istransparentturf(speaker_ceiling))
			speaker_has_ceiling = FALSE
	if(eavesdropping_modes[message_mode])
		eavesdrop_range = EAVESDROP_EXTRA_RANGE

	if(message_mode != MODE_WHISPER)
		Zs_too = TRUE
		if(say_test(message) == "2")	// 单感叹号喊话：扩大范围并允许传至相邻楼层。
			message_range += 10
			Zs_yell = TRUE
		if(say_test(message) == "3")	// 双感叹号大喊。
			message_range += 10
			Zs_all = TRUE

	var/area/speaker_area = get_area(speaker_atom)
	if(speaker_area?.soundproof)
		line_of_sight_only = TRUE
		Zs_too = FALSE
		Zs_yell = FALSE
		Zs_all = FALSE
	// 沿用 AZURE 的祷术扩音效果。
	if (head_owner.has_status_effect(/datum/status_effect/thaumaturgy))
		spans |= SPAN_REALLYBIG
		var/datum/status_effect/thaumaturgy/buff = locate() in head_owner.status_effects
		message_range += (5 + buff.potency) // 最多额外增加 12 格传播范围。
		for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
			if (prob(buff.potency * 3) && S.speaking) // 每个正在发声的 SCOM 按强度每级 3% 的概率转播喊话，不受施法者位置限制。
				S.verb_say = "惊恐地尖叫"
				S.verb_exclaim = "惊恐地尖叫"
				S.verb_yell = "惊恐地尖叫"
				S.say(message, spans = list("info", "reallybig"))
				S.verb_say = initial(S.verb_say)
				S.verb_exclaim = initial(S.verb_exclaim)
				S.verb_yell = initial(S.verb_yell)
		head_owner.remove_status_effect(/datum/status_effect/thaumaturgy)
	// 祷术扩音处理结束。
	var/list/listening = line_of_sight_only ? get_hearers_in_view(message_range + eavesdrop_range, source) : get_hearers_in_range(message_range + eavesdrop_range, source)
	// 为听见记录添加标记，每个听众只计算一次距离：~ 表示听到被星号遮蔽的低语，
	// 数字键盘方向表示画面外的声源方向；传播范围不足以超出画面时跳过。
	if(eavesdrop_range || message_range > SEEN_LOG_OFFSCREEN_DIST)
		for(var/mob/listener as anything in listening)
			var/listener_dist = get_dist(source, listener)
			if(eavesdrop_range && listener_dist > message_range)
				listening[listener] = "~"
			else if(listener_dist > SEEN_LOG_OFFSCREEN_DIST)
				listening[listener] = seen_direction_tag(listener, source)
	if(Zs_too)
		if(speaker_ceiling) // 将上层听众纳入候选接收者。
			for(var/mob/listener as anything in (line_of_sight_only ? get_hearers_in_view(message_range + eavesdrop_range, speaker_ceiling) : get_hearers_in_range(message_range + eavesdrop_range, speaker_ceiling)))
				if(!(listener in listening))
					listening[listener] = "^"
		if(!line_of_sight_only) // 仅限视线传播时，不额外搜索下层听众。
			var/turf/below_turf = GET_TURF_BELOW(speaker_turf)
			if(below_turf)
				for(var/mob/listener as anything in get_hearers_in_range(message_range + eavesdrop_range, below_turf))
					if(!(listener in listening))
						listening[listener] = "v"
	var/alist/admin_listeners = alist()
	var/do_ghost_protection = has_ghost_protection(head_owner)
	if(Zs_all)
		for(var/mob/potential_listener as anything in GLOB.player_list)
			if(!potential_listener.client?.prefs)
				continue
			if(!head_owner.client) // 避免将非玩家生物的叫声额外广播出去。
				continue
			if(get_dist(potential_listener, speaker_atom) > message_range) // 超出正常听觉范围。
				continue // 此处不检查管理员专用的远距离低语监听设置。
			if(do_ghost_protection && isobserver(potential_listener))
				var/mob/dead/observer/potential_observer = potential_listener
				if(!potential_observer.bypasses_ghost_protection())
					continue
			if(!is_in_zweb(speaker_turf.z,potential_listener.z))
				continue
			listening |= potential_listener
	// 按管理员的全局听觉和低语监听设置添加接收者。
	for(var/client/admin as anything in GLOB.admins)
		if(!(admin?.prefs.chat_toggles & CHAT_GHOSTEARS))
			continue
		if(!head_owner.client) // 避免向管理员额外转播非玩家生物的叫声。
			continue
		var/mob/observer = admin.mob
		if(get_dist(observer, speaker_atom) > message_range) // 超出正常听觉范围。
			if(eavesdropping_modes[message_mode] && !(admin.prefs.chat_toggles & CHAT_GHOSTWHISPER)) // 未开启远距离低语监听时跳过低语。
				continue
		if(!is_in_zweb(speaker_turf.z,observer.z))
			continue
		listening |= observer
		admin_listeners[observer] = TRUE
	if(do_ghost_protection) // 仅在启用幽灵保护时遍历并过滤接收者。
		for(var/mob/dead/observer/ghost in listening) // 提前移除无权旁听的幽灵，避免其进入听见记录。
			if(ghost.bypasses_ghost_protection())
				continue
			listening -= ghost

	var/eavesdropping
	var/eavesrendered
	if(eavesdrop_range)
		eavesdropping = stars(message)
		eavesrendered = compose_message(speaker_atom, message_language, eavesdropping, null, spans, message_mode)

	/// 实际收到消息的接收者，用于后续语音指令处理。
	var/list/heard_message = list()
	var/list/heard_mobs = list()
	listening |= speaker_atom

	var/rendered = compose_message(speaker_atom, message_language, message, null, spans, message_mode)
	var/alist/speaker_ceiling_nearby = alist()
	if(Zs_too && !Zs_all && !speaker_has_ceiling && speaker_ceiling) // 仅在需要时建立上层接收者索引。
		// 不限于活体，幽灵和已注册听觉的头颅也需要接收消息。
		for(var/atom/movable/hearer in get_hearers_in_view(message_range, speaker_ceiling)) // 检查上层位置的视线可达性。
			speaker_ceiling_nearby[hearer] = TRUE
	for(var/atom/movable/AM as anything in listening)
		var/hearall = FALSE
		var/turf/listener_turf = get_turf(AM)
		if(!listener_turf || QDELETED(AM))
			continue
		var/turf/listener_ceiling = get_step_multiz(listener_turf, UP)
		if(istype(AM, /obj/item/listeningdevice)) // 保留监听设备绕过楼层遮挡的特殊规则。
			hearall = TRUE
		listener_has_ceiling = listener_ceiling && !istransparentturf(listener_ceiling)
		if(!hearall && !Zs_too && !admin_listeners[AM] && listener_turf.z != speaker_turf.z)
			continue
		var/keenears = HAS_TRAIT(AM, TRAIT_KEENEARS)
		if(!hearall && Zs_too && listener_turf.z != speaker_turf.z && !Zs_all)
			if(!Zs_yell && !keenears)
				if(listener_turf.z < speaker_turf.z && listener_has_ceiling)	// 听众位于下层，且其上方被天花板遮挡。
					continue
				if(listener_turf.z > speaker_turf.z && speaker_has_ceiling)		// 听众位于上层，且发声者上方被天花板遮挡。
					continue
				if(listener_has_ceiling && speaker_has_ceiling)	// 双方位于不同楼层且均有天花板遮挡，无法听见。
					continue
			else if(abs((listener_turf.z - speaker_turf.z)) >= 2)	// 单感叹号喊话或敏锐听觉仍不能跨越两层及以上。
				continue
			if(speaker_atom != AM && !Zs_yell && !keenears)	// 自己总能听见自己；喊话和敏锐听觉可绕过相邻楼层遮挡。
				if(!speaker_ceiling || speaker_has_ceiling || listener_turf.z != speaker_ceiling.z || !speaker_ceiling_nearby[AM])
					// 发声者一侧无法直通时，再检查听众一侧是否存在无遮挡通路。
					if(!listener_ceiling || listener_has_ceiling || speaker_turf.z != listener_ceiling.z || !(speaker_atom in hearers(world.view, listener_ceiling)))
						continue
		var/highlighted_message
		var/atom/movable/tocheck = AM
		var/mob/hearing_mob
		if(ismob(AM))
			hearing_mob = AM
		if(ishuman(AM))
			var/mob/living/carbon/human/listener = AM
			// 环境对话由已注册听觉的头颅接收，身体不再重复接收。
			if(listener.get_harmless_live_head_source() && !admin_listeners[AM])
				continue
		else if(istype(AM, /obj/item/bodypart/head))
			var/obj/item/bodypart/head/listener_head = AM
			if(listener_head.harmless_live_head)
				hearing_mob = listener_head.harmless_live_owner
		if(ishuman(hearing_mob))
			var/mob/living/carbon/human/target = hearing_mob
			var/name_to_highlight = target.nickname
			if(name_to_highlight && name_to_highlight != "" && name_to_highlight != "Please Change Me")
				highlighted_message = replacetext_char(message, name_to_highlight, "<b><font color = #[target.highlight_color]>[name_to_highlight]</font></b>")
			var/datum/species/dullahan/target_species = target.dna?.species
			if(istype(target_species) && target_species.headless)
				tocheck = target_species.my_head
		if(eavesdrop_range && get_dist(source, tocheck) > message_range+keenears && !(admin_listeners[AM]))
			AM.Hear(eavesrendered, speaker_atom, message_language, eavesdropping, null, spans, message_mode, original_message)
			heard_message |= hearing_mob || AM
		else
			AM.Hear(rendered, speaker_atom, message_language, highlighted_message || message, null, spans, message_mode, original_message)
			heard_message |= hearing_mob || AM
		if(hearing_mob)
			heard_mobs[hearing_mob] = listening[AM]
	log_seen(head_owner, null, heard_mobs, message, SEEN_LOG_SAY)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, head_owner, message)

	// 检查喊话中的投降指令。
	if(findtext(message, regex("yield|give\\s*up|surrender|stop\\s*resisting","i")))
		head_owner.play_overhead_private_rclickemote(heard_message, "yield")
		for(var/mob/living/carbon/human in heard_message)
			human.apply_status_effect(/datum/status_effect/debuff/yield_prompt)

	// 向符合设置的接收者显示聊天气泡。
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in heard_mobs)
		if(M.client?.prefs)
			if(M.client && !M.client.prefs.chat_on_map)
				speech_bubble_recipients.Add(M.client)
	var/image/I = image('icons/mob/talk.dmi', speaker_atom, "[bubble_type][say_test(message)]", FLY_LAYER)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), I, speech_bubble_recipients, 30)

	speaker_atom.vocal_bark = head_owner.vocal_bark
	speaker_atom.vocal_bark_id = head_owner.vocal_bark_id
	speaker_atom.vocal_pitch = head_owner.vocal_pitch
	speaker_atom.vocal_pitch_range = head_owner.vocal_pitch_range
	speaker_atom.vocal_volume = head_owner.vocal_volume
	speaker_atom.vocal_speed = max(1, head_owner.vocal_speed)
	// 单独建立声音接收者列表，避免声音偏好过滤影响原有的对话接收者记录。
	if(SEND_SIGNAL(speaker_atom, COMSIG_MOVABLE_QUEUE_BARK, heard_mobs, args) || speaker_atom.vocal_bark || speaker_atom.vocal_bark_id)
		var/list/hears_barks = list()
		for(var/mob/M in heard_mobs)
			if(M.client?.prefs?.hear_barks)
				hears_barks += M
		var/is_yell = Zs_yell || Zs_all
		var/barks = min(round((length(message) / speaker_atom.vocal_speed)) + 1, BARK_MAX_BARKS)
		var/total_delay = 0
		speaker_atom.vocal_current_bark = world.time
		for(var/i in 1 to barks)
			if(total_delay > BARK_MAX_TIME)
				break
			addtimer(CALLBACK(speaker_atom, TYPE_PROC_REF(/atom/movable, bark), hears_barks, message_range, (speaker_atom.vocal_volume * (is_yell ? 1.5 : 1)), BARK_DO_VARY(speaker_atom.vocal_pitch, speaker_atom.vocal_pitch_range), speaker_atom.vocal_current_bark), total_delay)
			total_delay += rand(DS2TICKS(speaker_atom.vocal_speed / BARK_SPEED_BASELINE), DS2TICKS(speaker_atom.vocal_speed / BARK_SPEED_BASELINE) + DS2TICKS((speaker_atom.vocal_speed / BARK_SPEED_BASELINE) * (is_yell ? 0.5 : 1))) TICKS
	if(message_mode != MODE_WHISPER)
		head_owner.send_live_head_voice(message, src)

/mob/living/carbon/human/proc/send_live_head_voice(message, obj/item/bodypart/head/live_head)
	if(!message || !length(message) || !istype(live_head))
		return
	playsound(get_turf(live_head), 'sound/misc/talk.ogg', 100, FALSE, -1)

/obj/item/bodypart/head
	var/harmless_live_head = FALSE
	var/mob/living/carbon/human/harmless_live_owner

/obj/item/bodypart/head/GetVoice()
	if(harmless_live_head && harmless_live_owner)
		return "[harmless_live_owner.real_name]的头颅"
	return ..()

/obj/item/bodypart/head/examine(mob/user)
	. = ..()
	// 复刻核心 head/examine（head.dm，即当前生效的核心版本）的悬赏售卖提示：
	// 本覆盖取代了核心同名过程，若不补回，所有头颅都会丢失这条提示。
	if(sellprice && !no_head_bounty)
		. += span_notice("这颗头颅似乎属于王国司法机关通缉的对象，可以卖给商人或食颅者。")
	if(harmless_live_head && harmless_live_owner)
		. += span_notice("这颗头还活着。它的眼神并未熄灭，仿佛正隔着自己的眼窝向外张望。")
		if(harmless_live_owner.client?.eye == src)
			. += span_notice("你有一种怪异的感觉: 它此刻正借由这颗头注视着你。")

/obj/item/bodypart/head/Destroy()
	disable_harmless_live_head()
	// 复刻核心 /obj/item/bodypart/head/Destroy（head.dm）的器官清理：本覆盖取代了核心
	// 同名过程，而 ..() 只会落到父级 /obj/item/bodypart/Destroy（并不清理这些器官）。
	// 若不补回，头颅被删除时其脑/脑内意识体/眼/耳/舌都会泄漏或留下悬挂引用。顺序敏感。
	QDEL_NULL(brainmob)
	QDEL_NULL(brain)
	QDEL_NULL(eyes)
	QDEL_NULL(ears)
	QDEL_NULL(tongue)
	return ..()

/obj/item/bodypart/head/attach_limb(mob/living/carbon/C, special)
	if(harmless_live_head && C != harmless_live_owner)
		return FALSE
	// 保留核心头颅接回行为，再清除本法术的临时活体头颅状态。
	if(brain)
		if(brainmob)
			brainmob.forceMove(brain)
			brain.brainmob = brainmob
			brainmob = null
		brain.Insert(C)
		brain = null

	if(tongue)
		tongue = null
	if(ears)
		ears = null
	if(eyes)
		eyes = null

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.hair_color = hair_color
		H.hairstyle = hairstyle
		H.facial_hair_color = facial_hair_color
		H.facial_hairstyle = facial_hairstyle
		H.lip_style = lip_style
		H.lip_color = lip_color
	if(real_name)
		C.real_name = real_name
	real_name = ""
	name = initial(name)
	if(C.mind?.severed_head_ref?.resolve() == src)
		C.mind.severed_head_ref = null

	var/success = ..()
	if(success)
		disable_harmless_live_head()
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			H.harmless_live_head_source?.disable_harmless_live_head()
		var/datum/status_effect/buff/harmless_dismemberment/effect = C.has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
		if(!QDELETED(effect))
			effect.refresh_detached_bodyparts()
			effect.refresh_monitored_bodyparts()
	return success

/obj/item/bodypart/head/attackby(obj/item/I, mob/user, params)
	// 活体头颅：可直接拿食物喂给它的原主人。
	if(harmless_live_head && harmless_live_owner && istype(I, /obj/item/reagent_containers/food/) && ishuman(user))
		I.attack(harmless_live_owner, user)
		return
	// 复刻核心 /obj/item/bodypart/head/attackby（_bodyparts.dm）的“用锋利物切开头颅取出器官”
	// 逻辑：本覆盖取代了核心同名过程，而 ..() 只会落到父级 /obj/item/bodypart/attackby，
	// 会丢失头颅特有的开颅取器官交互。若不补回，所有头颅都无法再被切开取器官。
	if(length(contents) && I.get_sharpness() && !user.cmode)
		add_fingerprint(user)
		playsound(loc, 'sound/combat/hits/bladed/genstab (1).ogg', 60, vary = FALSE)
		user.visible_message(span_warning("[user]开始剖开[src]。"),\
			span_notice("你开始剖开[src]……"))
		if(do_after(user, 5 SECONDS, target = src))
			drop_organs(user)
			user.visible_message(span_danger("[user]剖开了[src]！"),\
				span_notice("你剖开了[src]。"))
		return
	return ..()

/obj/item/bodypart/head/say_mod(input, message_mode)
	if(harmless_live_head)
		if(message_mode == MODE_WHISPER || message_mode == MODE_WHISPER_CRIT)
			return "低低呢喃"
		if(copytext(input, length(input) - 1) == "!!")
			return "猛然尖啸"
		var/ending = copytext(input, length(input))
		if(ending == "?")
			return "幽幽发问"
		if(ending == "!")
			return "突兀惊呼"
		return "轻声开口"
	return ..()

/obj/item/bodypart/head/proc/enable_harmless_live_head(mob/living/carbon/human/head_owner)
	if(QDELETED(head_owner) || !istype(head_owner) || isdullahan(head_owner))
		return
	head_owner.harmless_live_head_source?.disable_harmless_live_head()
	harmless_live_head = TRUE
	harmless_live_owner = head_owner
	head_owner.harmless_live_head_source = src
	become_hearing_sensitive(HARMLESS_HEAD_HEARING_SOURCE)
	if(HAS_TRAIT(head_owner, TRAIT_KEENEARS))
		ADD_TRAIT(src, TRAIT_KEENEARS, HARMLESS_HEAD_HEARING_SOURCE)
	RegisterSignal(head_owner, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(restore_harmless_head_view))
	desc = "这颗头被一层不肯散去的古怪魔力维系着。它仍在呼吸，仍在倾听，也仍在看。"
	head_owner.reset_perspective(src)
	to_chat(head_owner, span_notice("我的视野猛然一沉，随后竟从自己被捧起的头颅里重新睁开了眼。"))

/obj/item/bodypart/head/proc/restore_harmless_head_view(mob/living/carbon/human/head_owner)
	SIGNAL_HANDLER
	if(!QDELETED(head_owner) && head_owner.get_harmless_live_head_source() == src)
		head_owner.reset_perspective(src)

/obj/item/bodypart/head/proc/disable_harmless_live_head()
	if(!harmless_live_head)
		return
	lose_hearing_sensitivity(HARMLESS_HEAD_HEARING_SOURCE)
	REMOVE_TRAIT(src, TRAIT_KEENEARS, HARMLESS_HEAD_HEARING_SOURCE)
	if(harmless_live_owner)
		UnregisterSignal(harmless_live_owner, COMSIG_MOB_CLIENT_LOGIN)
	if(!QDELETED(harmless_live_owner) && harmless_live_owner.client?.eye == src)
		harmless_live_owner.reset_perspective()
	if(harmless_live_owner?.harmless_live_head_source == src)
		harmless_live_owner.harmless_live_head_source = null
	harmless_live_head = FALSE
	harmless_live_owner = null
	desc = initial(desc)

/datum/status_effect/buff/harmless_dismemberment
	id = "harmless_dismemberment"
	alert_type = /atom/movable/screen/alert/status_effect/buff/harmless_dismemberment
	duration = 2 MINUTES
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	var/list/monitored_bodyparts = list()
	/// 仅自动接回本效果实际拆下的肢体；续时保留此清单。
	var/list/detached_bodyparts = list()
	/// 分离的头颅被删除后仍保留缺头记录，接入替代头时清除。
	var/head_separated = FALSE
	var/resources_cleaned = FALSE
	var/selection_pending = FALSE
	var/selection_generation = 0
	var/list/reattach_candidate_since = list()
	var/list/reattach_glow_announced = list()
	var/mob/living/carbon/human/controller
	var/mob/living/controller_body
	var/datum/mind/controller_mind
	var/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/selector_spell

/datum/status_effect/buff/harmless_dismemberment/on_creation(mob/living/new_owner, new_duration = null, mob/living/new_controller = null)
	if(new_duration)
		duration = new_duration
	if(isliving(new_controller))
		controller_body = new_controller
	if(ishuman(new_controller))
		controller = new_controller
		controller_mind = new_controller.mind
	return ..()

/datum/status_effect/buff/harmless_dismemberment/on_apply()
	. = ..()
	if(!. || !iscarbon(owner))
		return FALSE

	ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, id)
	ADD_TRAIT(owner, TRAIT_NOBREATH, id)
	refresh_monitored_bodyparts()
	if(controller_body)
		update_controller_transfer_signal(null, controller_body)
	if(controller)
		set_controller(controller)
	else
		ensure_selector_spell()
	to_chat(owner, span_notice("一道潮湿而温柔得令人不安的魔力覆上了我的身体。现在，只要切口平整迅速，我的血肉便会像本就该分开那样安静裂离。"))
	return TRUE

/datum/status_effect/buff/harmless_dismemberment/on_remove()
	var/mob/living/carbon/carbon_owner = owner
	var/kill_headless_owner = !QDELETED(carbon_owner) && head_separated && !isdullahan(carbon_owner) && !carbon_owner.get_bodypart(BODY_ZONE_HEAD) && carbon_owner.stat != DEAD
	if(kill_headless_owner)
		log_combat(controller, carbon_owner, "lost harmless dismemberment head support on", addition = "effect ended with its head still missing", log_seen = FALSE)
	cleanup_resources()
	. = ..()
	if(QDELETED(carbon_owner))
		return
	if(kill_headless_owner)
		carbon_owner.visible_message(
			span_danger("[carbon_owner] 身上的诡异缝合魔法忽然褪去，失去归处的性命也随之倏然断绝！"),
			span_userdanger("维系我头身分离的那层温柔恶意终于散了。没能归位的头颅，也把我的命一起带走了。")
		)
		carbon_owner.death()
		return
	if(length(carbon_owner.get_missing_limbs()))
		to_chat(carbon_owner, span_warning("断口上的柔和魔力已经消失。那些还未来得及归位的部件，从此便不再属于我。"))
	else
		to_chat(carbon_owner, span_notice("覆在断口上的古怪柔光渐渐退去，我的身体终于又像一个完整的人了。"))

/datum/status_effect/buff/harmless_dismemberment/be_replaced()
	// 宿主删除会进入此流程，此时只清理资源，不执行效果到期的死亡结算。
	cleanup_resources()
	return ..()

/datum/status_effect/buff/harmless_dismemberment/Destroy()
	. = ..()
	cleanup_resources()

/datum/status_effect/buff/harmless_dismemberment/proc/cleanup_resources()
	if(resources_cleaned)
		return
	resources_cleaned = TRUE
	invalidate_selection()
	unregister_monitored_bodyparts()
	clear_all_reattach_glows()
	for(var/obj/item/bodypart/limb as anything in detached_bodyparts.Copy())
		forget_detached_bodypart(limb)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.harmless_live_head_source?.disable_harmless_live_head()
	reattach_candidate_since = list()
	reattach_glow_announced = list()
	controller?.clear_harmless_dismemberment_locked_target(owner)
	remove_selector_spell()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, id)
		REMOVE_TRAIT(owner, TRAIT_NOBREATH, id)

/datum/status_effect/buff/harmless_dismemberment/tick()
	refresh_detached_bodyparts()
	refresh_monitored_bodyparts()
	try_reattach_nearby_bodyparts()

/datum/status_effect/buff/harmless_dismemberment/refresh(mob/living/new_owner, new_duration = null, mob/living/new_controller = null)
	if(new_duration)
		duration = world.time + new_duration
	else
		..()
	if(ishuman(new_controller))
		set_controller(new_controller)
	else if(controller)
		ensure_selector_spell()

/datum/status_effect/buff/harmless_dismemberment/proc/set_controller(mob/living/carbon/human/new_controller)
	var/mob/living/old_controller_body = controller_body
	if(controller == new_controller && controller_body == new_controller && controller_mind == new_controller?.mind)
		update_controller_transfer_signal(old_controller_body, new_controller)
		controller?.set_harmless_dismemberment_locked_target(owner)
		ensure_selector_spell()
		return
	controller?.clear_harmless_dismemberment_locked_target(owner)
	log_combat(new_controller, owner, "took control of harmless dismemberment on", addition = "previous controller: [key_name(controller)]", log_seen = FALSE)
	invalidate_selection()
	clear_selector_spell()
	controller = new_controller
	controller_body = new_controller
	controller_mind = new_controller?.mind
	update_controller_transfer_signal(old_controller_body, new_controller)
	controller?.set_harmless_dismemberment_locked_target(owner)
	ensure_selector_spell()

/datum/status_effect/buff/harmless_dismemberment/proc/update_controller_transfer_signal(mob/living/old_controller_body, mob/living/new_controller_body)
	if(old_controller_body)
		UnregisterSignal(old_controller_body, COMSIG_MIND_TRANSFER)
	if(new_controller_body)
		RegisterSignal(new_controller_body, COMSIG_MIND_TRANSFER, PROC_REF(handle_controller_mind_transfer))

/datum/status_effect/buff/harmless_dismemberment/proc/handle_controller_mind_transfer(mob/living/old_controller, mob/living/new_controller)
	SIGNAL_HANDLER
	if(controller_body != old_controller)
		return
	log_combat(old_controller, owner, "transferred harmless dismemberment control for", addition = "new body: [key_name(new_controller)]", log_seen = FALSE)
	invalidate_selection()
	var/mob/living/old_controller_body = controller_body
	controller?.clear_harmless_dismemberment_locked_target(owner)
	clear_selector_spell()
	controller_body = new_controller
	controller_mind = new_controller?.mind || controller_mind
	update_controller_transfer_signal(old_controller_body, new_controller)
	if(!ishuman(new_controller))
		controller = null
		return
	controller = new_controller
	controller.set_harmless_dismemberment_locked_target(owner)
	ensure_selector_spell()

/datum/status_effect/buff/harmless_dismemberment/proc/invalidate_selection()
	selection_generation++
	selection_pending = FALSE

/datum/status_effect/buff/harmless_dismemberment/proc/can_be_manipulated_by(mob/living/user)
	if(resources_cleaned || QDELETED(src) || QDELETED(owner) || QDELETED(user) || QDELETED(controller) || !istype(user) || !istype(controller))
		return FALSE
	if(user != controller)
		return FALSE
	if(user.mind != controller_mind)
		return FALSE
	if(owner.has_status_effect(type) != src || controller.harmless_dismemberment_locked_target != owner)
		return FALSE
	return TRUE

/datum/status_effect/buff/harmless_dismemberment/proc/ensure_selector_spell()
	if(!controller_mind || !controller)
		return
	if(QDELETED(selector_spell))
		selector_spell = null
	if(!selector_spell)
		selector_spell = new /obj/effect/proc_holder/spell/self/harmless_dismemberment_select
		controller_mind.AddSpell(selector_spell, controller)
	controller.harmless_dismemberment_selector_spell = selector_spell
	selector_spell.linked_target = owner
	selector_spell.linked_effect = src

/datum/status_effect/buff/harmless_dismemberment/proc/clear_selector_spell()
	if(controller?.harmless_dismemberment_selector_spell == selector_spell)
		controller.harmless_dismemberment_selector_spell = null
	if(selector_spell)
		selector_spell.remove_from_specific_holder(controller_mind)
	selector_spell = null

/datum/status_effect/buff/harmless_dismemberment/proc/remove_selector_spell()
	if(controller_body)
		update_controller_transfer_signal(controller_body, null)
	clear_selector_spell()
	controller = null
	controller_body = null
	controller_mind = null

/datum/status_effect/buff/harmless_dismemberment/proc/enable_reattach_glow(obj/item/bodypart/limb)
	if(!istype(limb) || QDELETED(limb) || limb.get_filter(HARMLESS_REATTACH_GLOW_FILTER))
		return
	limb.add_filter(HARMLESS_REATTACH_GLOW_FILTER, 2, list("type" = "outline", "color" = "#4ea1e6", "alpha" = 200, "size" = 1))

/datum/status_effect/buff/harmless_dismemberment/proc/disable_reattach_glow(obj/item/bodypart/limb)
	if(!istype(limb) || QDELETED(limb))
		return
	limb.remove_filter(HARMLESS_REATTACH_GLOW_FILTER)

/datum/status_effect/buff/harmless_dismemberment/proc/clear_all_reattach_glows()
	for(var/obj/item/bodypart/limb as anything in reattach_glow_announced)
		disable_reattach_glow(limb)

/datum/status_effect/buff/harmless_dismemberment/proc/forget_detached_bodypart(obj/item/bodypart/limb)
	detached_bodyparts -= limb
	reattach_candidate_since -= limb
	reattach_glow_announced -= limb
	if(!limb)
		return
	UnregisterSignal(limb, COMSIG_QDELETING)
	disable_reattach_glow(limb)
	if(istype(limb, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = limb
		if(head.harmless_live_owner == owner)
			head.disable_harmless_live_head()

/datum/status_effect/buff/harmless_dismemberment/proc/handle_detached_bodypart_deleted(obj/item/bodypart/limb)
	SIGNAL_HANDLER
	forget_detached_bodypart(limb)

/datum/status_effect/buff/harmless_dismemberment/proc/refresh_detached_bodyparts()
	if(QDELETED(owner) || !iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(carbon_owner.get_bodypart(BODY_ZONE_HEAD))
		head_separated = FALSE
		if(ishuman(carbon_owner))
			var/mob/living/carbon/human/human_owner = carbon_owner
			human_owner.harmless_live_head_source?.disable_harmless_live_head()
	for(var/obj/item/bodypart/limb as anything in detached_bodyparts.Copy())
		if(QDELETED(limb))
			forget_detached_bodypart(limb)
			continue
		if(limb.owner || carbon_owner.get_bodypart(limb.body_zone))
			log_combat(controller, owner, "ended harmless dismemberment tracking for", limb, "part reattached or replaced", log_seen = FALSE)
			forget_detached_bodypart(limb)

/datum/status_effect/buff/harmless_dismemberment/proc/refresh_monitored_bodyparts()
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/carbon_owner = owner
	var/list/current_bodyparts = list()
	for(var/obj/item/bodypart/bodypart as anything in carbon_owner.bodyparts)
		if(bodypart.body_zone == BODY_ZONE_CHEST)
			continue
		current_bodyparts += bodypart
		if(!(bodypart in monitored_bodyparts))
			RegisterSignal(bodypart, COMSIG_MOB_DISMEMBER, PROC_REF(handle_harmless_dismember))

	for(var/obj/item/bodypart/bodypart as anything in monitored_bodyparts)
		if(QDELETED(bodypart) || !(bodypart in current_bodyparts))
			UnregisterSignal(bodypart, COMSIG_MOB_DISMEMBER)

	monitored_bodyparts = current_bodyparts

/datum/status_effect/buff/harmless_dismemberment/proc/unregister_monitored_bodyparts()
	for(var/obj/item/bodypart/bodypart as anything in monitored_bodyparts)
		if(QDELETED(bodypart))
			continue
		UnregisterSignal(bodypart, COMSIG_MOB_DISMEMBER)
	monitored_bodyparts = list()

/datum/status_effect/buff/harmless_dismemberment/proc/handle_harmless_dismember(obj/item/bodypart/source, obj/item/bodypart/bodypart)
	SIGNAL_HANDLER

	var/obj/item/bodypart/target_bodypart = bodypart
	if(!istype(target_bodypart))
		target_bodypart = source
	if(!istype(target_bodypart) || target_bodypart.owner != owner)
		return NONE
	if(!separate_bodypart(target_bodypart))
		return NONE
	return COMPONENT_CANCEL_DISMEMBER

/datum/status_effect/buff/harmless_dismemberment/proc/separate_bodypart(obj/item/bodypart/bodypart)
	if(resources_cleaned || QDELETED(owner) || QDELETED(bodypart) || !istype(bodypart) || !iscarbon(owner) || bodypart.owner != owner)
		return FALSE
	if(bodypart.body_zone == BODY_ZONE_CHEST)
		return FALSE

	var/mob/living/carbon/carbon_owner = owner
	var/is_head = bodypart.body_zone == BODY_ZONE_HEAD
	var/native_head = is_head && isdullahan(carbon_owner)
	var/atom/drop_spot = carbon_owner.drop_location()

	if(!bodypart.drop_limb(!native_head))
		return FALSE
	if(is_head && !native_head)
		head_separated = TRUE
	carbon_owner.updatehealth()
	carbon_owner.update_mobility()
	carbon_owner.update_inv_gloves()
	carbon_owner.update_inv_shoes()
	carbon_owner.update_inv_head()
	log_combat(controller, carbon_owner, "separated a bodypart with harmless dismemberment from", bodypart, log_seen = FALSE, zone = bodypart.body_zone)
	if(QDELETED(bodypart))
		return TRUE
	detached_bodyparts |= bodypart
	RegisterSignal(bodypart, COMSIG_QDELETING, PROC_REF(handle_detached_bodypart_deleted))
	refresh_monitored_bodyparts()

	if(drop_spot)
		bodypart.forceMove(drop_spot)
	reattach_candidate_since -= bodypart
	disable_reattach_glow(bodypart)
	reattach_glow_announced -= bodypart
	if(get_dist(bodypart, carbon_owner) <= 1)
		reattach_candidate_since[bodypart] = world.time

	if(is_head)
		if(ishuman(carbon_owner) && !native_head)
			var/mob/living/carbon/human/human_owner = carbon_owner
			var/obj/item/bodypart/head/head = bodypart
			head.enable_harmless_live_head(human_owner)
		carbon_owner.visible_message(
			span_notice("[carbon_owner] 的头颅在一层近乎慈悲的魔力包裹下平整地离开了身体，却连一滴血也没有舍得流出来。"),
			span_notice("我的头颅在法术托举下与身体平整分离，可我的意识仍牢牢系在这颗被捧起的头里。")
		)
	else
		carbon_owner.visible_message(
			span_notice("[carbon_owner] 的[bodypart.name]在柔和得令人发寒的魔力中平整地与身体分离开来，像只是被轻轻拆下。"),
			span_notice("我的[bodypart.name]在法术的托扶下平整地离开了身体，却没有带来半点痛楚，只有一种古怪的空落感。")
		)

	return TRUE

/datum/status_effect/buff/harmless_dismemberment/proc/try_reattach_nearby_bodyparts()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	var/list/current_candidates = list()
	for(var/obj/item/bodypart/limb as anything in detached_bodyparts.Copy())
		if(!can_reattach_bodypart(human_owner, limb))
			continue
		current_candidates += limb
		var/started_waiting = reattach_candidate_since[limb]
		if(!isnum(started_waiting))
			reattach_candidate_since[limb] = world.time
			continue
		if(world.time - started_waiting >= 3 SECONDS && !(limb in reattach_glow_announced))
			enable_reattach_glow(limb)
			reattach_glow_announced += limb
			limb.visible_message(
				span_info("[limb] 静静落在地上，断口边缘渐渐亮起一圈象征归位的柔和蓝光。"),
				null
			)
		if(world.time - started_waiting < 5 SECONDS)
			continue
		if(!limb.attach_limb(human_owner, TRUE))
			continue
		forget_detached_bodypart(limb)
		// 接回后立即恢复肢解保护，避免等到下一次轮询前再次被砍断。
		refresh_monitored_bodyparts()
		log_combat(controller, human_owner, "reattached a bodypart with harmless dismemberment to", limb, log_seen = FALSE, zone = limb.body_zone)

		human_owner.visible_message(
			span_notice("[limb] 被无形的牵引轻轻拽回了 [human_owner] 的断口，像一块终于寻回原位的骨肉。"),
			span_notice("[limb] 在我的断口附近落地停留片刻后，终于在那股古怪而温柔的牵引下愈合接回。")
		)

	for(var/obj/item/bodypart/limb as anything in reattach_candidate_since)
		if(QDELETED(limb) || !(limb in current_candidates))
			reattach_candidate_since -= limb
			disable_reattach_glow(limb)
			reattach_glow_announced -= limb

/datum/status_effect/buff/harmless_dismemberment/proc/can_reattach_bodypart(mob/living/carbon/human/human_owner, obj/item/bodypart/limb)
	if(QDELETED(human_owner) || QDELETED(limb) || !istype(human_owner) || !istype(limb) || !(limb in detached_bodyparts))
		return FALSE
	if(limb.owner)
		return FALSE
	var/turf/owner_turf = get_turf(human_owner)
	if(!isturf(limb.loc) || !owner_turf || limb.z != owner_turf.z || get_dist(limb, owner_turf) > 1)
		return FALSE
	if(human_owner.get_bodypart(limb.body_zone))
		return FALSE
	return TRUE

// cast_check() 还会检查或消耗充能，不能直接用于弹窗结束后的复核。
// 这两个法术没有装备或虔诚要求，此处只复核其当前施法条件。
/obj/effect/proc_holder/spell/self/proc/can_continue_harmless_cast(mob/living/carbon/human/user, datum/mind/casting_mind, client/casting_client)
	if(QDELETED(src) || QDELETED(user) || !ishuman(user) || QDELETED(casting_mind))
		return FALSE
	if(!casting_client || user.client != casting_client || user.mind != casting_mind || casting_mind.current != user)
		return FALSE
	if(!(src in casting_mind.spell_list) && !(src in user.mob_spell_list))
		return FALSE
	if(user.stat != CONSCIOUS || user.incapacitated(ignore_restraints = !gesture_required) || HAS_TRAIT(user, TRAIT_PARALYSIS))
		return FALSE
	if((!ignore_cockblock && HAS_TRAIT(user, TRAIT_SPELLCOCKBLOCK)) || HAS_TRAIT(user, TRAIT_CURSE_NOC))
		return FALSE
	var/turf/caster_turf = get_turf(user)
	if(!caster_turf || (is_centcom_level(caster_turf.z) && !centcom_cancast))
		return FALSE
	if(!phase_allowed && istype(user.loc, /obj/effect/dummy))
		return FALSE
	if(!antimagic_allowed && user.anti_magic_check(TRUE, FALSE, FALSE, 0, TRUE) && !HAS_TRAIT(user, TRAIT_SPELL_DISPERSION))
		return FALSE
	if(gesture_required && (user.handcuffed || !user.has_active_hand()))
		return FALSE
	if(invocation_type == "whisper" || invocation_type == "shout")
		if((!user.can_speak_vocal() && !(mute_allowed && HAS_TRAIT(user, TRAIT_PERMAMUTE) && !user.check_mouth_grabbed())) || !user.getorganslot(ORGAN_SLOT_TONGUE))
			return FALSE
		var/datum/language/default_language = user.get_default_language()
		if(default_language && (initial(default_language.flags) & SIGNLANG))
			return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/proc/revert_harmless_cast(mob/living/user)
	if(!QDELETED(src) && !QDELETED(user))
		revert_cast(user)
	return FALSE

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select
	name = "指定脱落"
	desc = "在无害肢解持续期间，无论相隔多远，都可仅对锁定目标再次指定要无伤脱落的部位。"
	action_icon_state = "abduct"
	overlay_state = "blink"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 1 SECONDS
	cooldown_min = 1 SECONDS
	range = 0
	associated_skill = /datum/skill/magic/arcane
	miracle = FALSE
	gesture_required = FALSE
	var/mob/living/carbon/human/linked_target
	var/datum/status_effect/buff/harmless_dismemberment/linked_effect

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/Destroy()
	if(linked_effect?.selector_spell == src)
		linked_effect.selector_spell = null
	if(linked_effect?.controller?.harmless_dismemberment_selector_spell == src)
		linked_effect.controller.harmless_dismemberment_selector_spell = null
	linked_target = null
	linked_effect = null
	return ..()

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/proc/remove_from_holder(mob/living/user)
	remove_from_specific_holder(user?.mind)

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/proc/remove_from_specific_holder(datum/mind/M)
	if(M?.spell_list && (src in M.spell_list))
		M.spell_list -= src
	qdel(src)

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/cast(list/targets, mob/living/user = usr)
	if(QDELETED(user) || !ishuman(user))
		return revert_harmless_cast(user)
	if(QDELETED(linked_target) || QDELETED(linked_effect) || linked_effect.owner != linked_target)
		to_chat(user, span_warning("那层牵引血肉的法术已经散了。"))
		remove_from_holder(user)
		return FALSE
	if(!linked_effect.can_be_manipulated_by(user))
		to_chat(user, span_warning("这道断离牵引如今已不再回应我的手。"))
		remove_from_holder(user)
		return FALSE
	if(linked_target != user && (!linked_target.client || linked_target.stat != CONSCIOUS))
		to_chat(user, span_warning("只有仍然清醒、能够回应这道法术的人，才能继续接受无害肢解的指定脱落。"))
		revert_cast(user)
		return FALSE

	var/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/main_spell = user.mind?.get_spell(/obj/effect/proc_holder/spell/invoked/harmless_dismemberment, TRUE)
	if(!main_spell)
		to_chat(user, span_warning("我一时无法重新牵动这道法术。"))
		remove_from_holder(user)
		return FALSE

	var/separated = main_spell.prompt_initial_separation(user, linked_target, src)
	if(QDELETED(src) || QDELETED(user))
		return FALSE
	if(!separated)
		return revert_harmless_cast(user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/get_detachable_bodypart_choices(mob/living/carbon/human/target)
	var/list/detachable = list()
	if(!istype(target))
		return detachable

	if(target.get_bodypart(BODY_ZONE_HEAD))
		detachable += "头颅"
	if(target.get_bodypart(BODY_ZONE_L_ARM))
		detachable += "左臂"
	if(target.get_bodypart(BODY_ZONE_R_ARM))
		detachable += "右臂"
	if(target.get_bodypart(BODY_ZONE_L_LEG))
		detachable += "左腿"
	if(target.get_bodypart(BODY_ZONE_R_LEG))
		detachable += "右腿"
	if(target.get_bodypart(BODY_ZONE_TAUR))
		detachable += "尾巴"
	return detachable

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/get_choice_bodypart(mob/living/carbon/human/target, choice)
	if(!istype(target) || !choice)
		return null

	switch(choice)
		if("头颅")
			return target.get_bodypart(BODY_ZONE_HEAD)
		if("左臂")
			return target.get_bodypart(BODY_ZONE_L_ARM)
		if("右臂")
			return target.get_bodypart(BODY_ZONE_R_ARM)
		if("左腿")
			return target.get_bodypart(BODY_ZONE_L_LEG)
		if("右腿")
			return target.get_bodypart(BODY_ZONE_R_LEG)
		if("尾巴")
			return target.get_bodypart(BODY_ZONE_TAUR)

	return null

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/prompt_initial_separation(mob/living/user, mob/living/carbon/human/target, obj/effect/proc_holder/spell/self/selection_spell = src)
	if(QDELETED(user) || QDELETED(target) || !istype(user) || !istype(target) || QDELETED(selection_spell))
		return
	var/datum/mind/casting_mind = user.mind
	var/client/casting_client = user.client
	var/datum/mind/target_mind = target.mind
	var/client/target_client = target.client
	if(!selection_spell.can_continue_harmless_cast(user, casting_mind, casting_client))
		return FALSE

	var/datum/status_effect/buff/harmless_dismemberment/effect = target.has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
	if(QDELETED(effect) || effect.selection_pending)
		return
	if(!effect.can_be_manipulated_by(user))
		to_chat(user, span_warning("这道无害肢解当前并不受我支配。"))
		return
	if(target != user && (!target.client || target.stat != CONSCIOUS))
		to_chat(user, span_warning("只有仍然清醒、能够回应这道法术的人，才能继续接受无害肢解的指定脱落。"))
		return

	var/list/detachable = get_detachable_bodypart_choices(target)
	if(!length(detachable))
		to_chat(user, span_warning("[target] 身上已经没有可供无害分离的部位了。"))
		return

	effect.selection_pending = TRUE
	var/selection_generation = ++effect.selection_generation
	var/choice = input(user, "选择要从 [target] 身上无害分离的部位。", "无害肢解") as null|anything in detachable
	if(QDELETED(effect) || selection_generation != effect.selection_generation)
		return FALSE
	effect.selection_pending = FALSE
	if(QDELETED(src) || QDELETED(user) || QDELETED(target) || QDELETED(effect))
		return
	if(QDELETED(selection_spell) || !selection_spell.can_continue_harmless_cast(user, casting_mind, casting_client))
		return FALSE
	if(!(src in casting_mind.spell_list) && !(src in user.mob_spell_list))
		return FALSE
	if(target.mind != target_mind || target.client != target_client)
		return FALSE
	if(!effect.can_be_manipulated_by(user))
		to_chat(user, span_warning("那股牵引血肉的柔力已不再听从我的指定。"))
		return
	if(target != user && (!target.client || target.stat != CONSCIOUS))
		to_chat(user, span_warning("只有仍然清醒、能够回应这道法术的人，才能继续接受无害肢解的指定脱落。"))
		return
	if(!choice)
		to_chat(user, span_notice("我暂时没有让任何部位脱落。"))
		return
	if(target.anti_magic_check())
		to_chat(user, span_warning("反魔法阻止了这次指定脱落，但已有的生命维持仍会持续至法术结束。"))
		return FALSE

	var/obj/item/bodypart/chosen = get_choice_bodypart(target, choice)
	if(!istype(chosen) || chosen.owner != target)
		to_chat(user, span_warning("[target] 的[choice]已经不在原位了。"))
		return
	var/chosen_name = chosen.name
	if(!effect.separate_bodypart(chosen))
		to_chat(user, span_warning("[target] 的[chosen_name]没能顺利分离。"))
		return

	to_chat(user, span_notice("我指定了 [target] 的[chosen_name] 脱落。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment
	parent_type = /obj/effect/proc_holder/spell/self
	name = "无害肢解"
	desc = "用 10 秒的诡异引导挑选 3 格内一名自愿者，让其在两分钟里化作一具可被平整拆开的活体圣匣。肢体与头颅会在无痛、无血、无死的温柔里分离，并在靠近断口时自行归位；待时限耗尽，仍未归位之物便不再回来。"
	action_icon_state = "bloodcrawl"
	cost = 4
	xp_gain = TRUE
	releasedrain = 40
	chargedrain = 1
	chargetime = 0
	recharge_time = 5 MINUTES
	cooldown_min = 5 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "harmless_dismemberment"
	spell_tier = 3
	invocations = list("肉可离，命暂留，归处莫迟。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 4
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 3
	miracle = FALSE
	gesture_required = TRUE
	var/harmless_cast_pending = FALSE

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/get_selectable_spell_targets(mob/living/carbon/human/user)
	var/list/possible_targets = list()
	if(!istype(user))
		return possible_targets
	var/mob/living/carbon/human/locked_target = user.get_harmless_dismemberment_locked_target()
	if(locked_target)
		if(locked_target.client && locked_target.stat == CONSCIOUS && (locked_target in range(range, user)))
			possible_targets += locked_target
		return possible_targets
	for(var/mob/living/carbon/human/possible_target in range(range, user))
		if(QDELETED(possible_target))
			continue
		if(possible_target != user && (!possible_target.client || possible_target.stat != CONSCIOUS))
			continue
		possible_targets += possible_target
	return possible_targets

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/choose_spell_target(mob/living/carbon/human/user)
	if(!istype(user))
		return null
	var/list/possible_targets = get_selectable_spell_targets(user)
	if(!length(possible_targets))
		return null
	return input(user, "选择 3 格范围内要施加“无害肢解”的清醒对象。", "无害肢解") as null|mob in sortNames(possible_targets)

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/cast(list/targets, mob/living/user = usr)
	if(harmless_cast_pending)
		return FALSE
	harmless_cast_pending = TRUE
	. = perform_harmless_cast(user)
	if(QDELETED(src))
		return FALSE
	harmless_cast_pending = FALSE
	if(QDELETED(user))
		return FALSE

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/perform_harmless_cast(mob/living/user)
	if(!ishuman(user))
		return revert_harmless_cast(user)

	var/mob/living/carbon/human/human_user = user
	var/datum/mind/casting_mind = user.mind
	var/client/casting_client = user.client
	if(!can_continue_harmless_cast(human_user, casting_mind, casting_client))
		return revert_harmless_cast(user)
	var/mob/living/carbon/human/locked_target = human_user.get_harmless_dismemberment_locked_target()
	var/list/possible_targets = get_selectable_spell_targets(human_user)
	if(!length(possible_targets))
		if(locked_target)
			to_chat(human_user, span_warning("无害肢解仍缝在 [locked_target] 身上；若想再次续上或改投这道法术，对方必须清醒且位于我 3 格范围内。"))
		else
			to_chat(human_user, span_warning("我周围 3 格内没有清醒且能够回应这道法术的对象。"))
		revert_cast(human_user)
		return FALSE

	human_user.visible_message(
		span_notice("[human_user] 将手轻轻按在自己的喉颈与腕骨之间，像在替一具尚未拆开的肉身丈量缝线。"),
		span_notice("我开始维持那道漫长而古怪的拆解咒，引导即将降临的温柔断离。")
	)
	if(!do_after(human_user, 10 SECONDS, target = human_user, progress = TRUE))
		if(!QDELETED(human_user))
			to_chat(human_user, span_warning("我的拆解咒在成形前散掉了。"))
		return revert_harmless_cast(human_user)

	if(!can_continue_harmless_cast(human_user, casting_mind, casting_client))
		return revert_harmless_cast(human_user)

	var/mob/living/carbon/human/spelltarget = choose_spell_target(human_user)
	if(!can_continue_harmless_cast(human_user, casting_mind, casting_client))
		return revert_harmless_cast(human_user)
	if(!ishuman(spelltarget))
		to_chat(human_user, span_notice("我让那道缝在空气里的温柔恶意暂时停了下来。"))
		revert_cast(human_user)
		return FALSE
	if(!(spelltarget in get_selectable_spell_targets(human_user)))
		to_chat(human_user, span_warning("[spelltarget] 已经不在我能触及的断离范围内了。"))
		revert_cast(human_user)
		return FALSE

	if(spelltarget.anti_magic_check())
		spelltarget.visible_message(span_warning("[spelltarget] 周身泛起一阵反魔法涟漪，将那道缝在血肉间的怪异温柔尽数震散！"))
		to_chat(human_user, span_warning("[spelltarget] 身上的反魔法抵消了无害肢解。"))
		playsound(get_turf(spelltarget), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast(human_user)
		return FALSE

	if(spelltarget != human_user)
		if(spelltarget.stat != CONSCIOUS || !spelltarget.client)
			to_chat(human_user, span_warning("只有清醒且能够亲自同意的人，才能接受这道法术。"))
			revert_cast(human_user)
			return FALSE

		var/datum/mind/consenting_mind = spelltarget.mind
		var/client/consenting_client = spelltarget.client
		log_combat(human_user, spelltarget, "requested consent for harmless dismemberment from", log_seen = FALSE)
		var/consent = alert(spelltarget, "[human_user] 想对你施放“无害肢解”。接下来的两分钟里，你的肢体与头颅会在不流血、不呼痛、不立刻死去的情况下被平整分离，并在靠近断口时自行归位。若时限结束仍未归位，分离便会成为永久。要接受吗？", "无害肢解", "同意", "拒绝")
		if(QDELETED(spelltarget) || !can_continue_harmless_cast(human_user, casting_mind, casting_client))
			return revert_harmless_cast(human_user)
		if(spelltarget.mind != consenting_mind || spelltarget.client != consenting_client || !(spelltarget in get_selectable_spell_targets(human_user)))
			return revert_harmless_cast(human_user)
		if(spelltarget.stat != CONSCIOUS || !spelltarget.client)
			to_chat(human_user, span_warning("只有清醒且能够亲自同意的人，才能接受这道法术。"))
			revert_cast(human_user)
			return FALSE
		if(consent != "同意")
			log_combat(spelltarget, human_user, "declined harmless dismemberment from", log_seen = FALSE)
			to_chat(human_user, span_warning("[spelltarget] 拒绝接受无害肢解。"))
			to_chat(spelltarget, span_notice("我拒绝了 [human_user] 的无害肢解。"))
			revert_cast(human_user)
			return FALSE
		log_combat(spelltarget, human_user, "consented to harmless dismemberment from", log_seen = FALSE)
		if(spelltarget.anti_magic_check())
			to_chat(human_user, span_warning("[spelltarget] 的反魔法阻止了这次施法。"))
			return revert_harmless_cast(human_user)

	var/already_enchanted = spelltarget.has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
	spelltarget.apply_status_effect(/datum/status_effect/buff/harmless_dismemberment, 2 MINUTES, human_user)
	var/datum/status_effect/buff/harmless_dismemberment/effect = spelltarget.has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
	if(QDELETED(effect))
		return revert_harmless_cast(human_user)
	effect.set_controller(human_user)
	log_combat(human_user, spelltarget, already_enchanted ? "refreshed harmless dismemberment on" : "applied harmless dismemberment to", log_seen = FALSE)
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 70, TRUE, soundping = TRUE)

	if(spelltarget == human_user)
		if(already_enchanted)
			human_user.visible_message(span_notice("[human_user] 再度抚过自己的四肢与颈项，让那道缝在血肉里的古怪魔法重新流转起来。"))
			to_chat(human_user, span_notice("我重新续上了自己身上的无害肢解。"))
		else
			human_user.visible_message(span_notice("[human_user] 以魔力轻抚自己的四肢与颈项，肉身随之浮现出一层柔和却令人不安的缝合辉光。"))
			to_chat(human_user, span_notice("我的血肉被这道法术轻轻托住了。接下来的两分钟里，即便分离，它们也不会立刻把我弃下。"))
	else
		if(already_enchanted)
			human_user.visible_message(span_notice("[human_user] 重新续接了 [spelltarget] 身上的无害肢解。"))
			to_chat(human_user, span_notice("我重新续上了 [spelltarget] 身上的无害肢解。"))
			to_chat(spelltarget, span_notice("那道维系我断口的古怪柔力重新充盈了起来。"))
		else
			human_user.visible_message(span_notice("[human_user] 贴近 [spelltarget]，以低缓咒语将一层柔和而诡异的魔力缝进了 [spelltarget.p_their()] 血肉。"))
			to_chat(human_user, span_notice("我把无害肢解缝进了 [spelltarget] 的血肉里。接下来的两分钟里，[spelltarget.p_their()] 的身体会像一件还能活着的器皿那样被拆开。"))
			to_chat(spelltarget, span_notice("[human_user] 的魔法轻柔地覆上了我的身体。接下来的两分钟里，只要切口平整迅速，我的肢体与头颅就能在不死不伤的古怪温柔中分离，并在归位时重新接回。"))
			to_chat(human_user, span_notice("在法术维持期间，我还可以继续点按“指定脱落”来反复选择新的部位。"))

	// 先完成实际施法，再异步等待肢体选择，避免消耗、冷却和咒语
	// 被弹窗拖延到施法者身份改变或死亡之后才结算。
	INVOKE_ASYNC(src, PROC_REF(prompt_initial_separation), human_user, spelltarget)

	return TRUE

#undef HARMLESS_REATTACH_GLOW_FILTER
#undef HARMLESS_HEAD_HEARING_SOURCE
