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
	var/examining = FALSE
	var/next_examine = 0
	var/restoring_sounds = FALSE
	var/list/local_loops = list()
	var/list/remote_loops = list()
	var/list/loop_templates = list()
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
	if(examining || world.time < next_examine)
		return
	next_examine = world.time + 2
	if(!can_examine(subject))
		to_chat(viewer, span_notice("只能检视借用视角中实际可见的事物。"))
		return
	// 不调用 examinate，避免广播身体正在检视；排除鼻部检查与接触判定。
	examining = TRUE
	var/previous_zone = viewer.zone_selected
	viewer.zone_selected = BODY_ZONE_HEAD
	var/list/description
	try
		description = subject.examine(viewer)
	catch(var/exception/error)
		viewer.zone_selected = previous_zone
		examining = FALSE
		throw error
	viewer.zone_selected = previous_zone
	examining = FALSE
	if(!senses_valid() || !length(description))
		return
	// 以纯文本显示，不保留检查、容器、配方或其他可操作的超链接与悬浮组件。
	var/list/plain_lines = list()
	for(var/line in description)
		plain_lines += html_encode(group_mindlink_plain_text("[line]"))
	to_chat(viewer, examine_block(plain_lines.Join("<br>")))

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

/mob/living/carbon/Adjacent(atom/neighbor)
	if(group_mindlink_view?.examining)
		return FALSE
	if(isliving(neighbor))
		var/mob/living/other = neighbor
		if(other.group_mindlink_view?.examining)
			return FALSE
	return ..()

/mob/living/carbon/can_smell()
	if(group_mindlink_view?.examining)
		return FALSE
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
	// 已在播放的本地循环声也需停止；退场时仅重新接入仍有效且可听到的来源。
	for(var/datum/looping_sound/loop as anything in view_client.played_loops.Copy())
		if(loop.direct && loop.channel != CHANNEL_WEATHER)
			continue
		var/list/entry = view_client.played_loops[loop]
		var/sound/local_sound = entry["SOUND"]
		if(findtext("[local_sound?.file]", "sound/music/"))
			continue
		local_loops |= loop
		if(local_sound)
			viewer.stop_sound_channel(local_sound.channel)
		loop.thingshearing -= WEAKREF(viewer)
		view_client.played_loops -= loop
	// 切入时已存在的声音不必等待下一次循环回调。
	for(var/datum/looping_sound/loop as anything in target.client.played_loops)
		if(!loop.direct)
			receive_loop(loop)
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
	for(var/datum/looping_sound/loop as anything in remote_loops.Copy())
		remove_loop(loop)
	SSsounds.free_datum_channels(src)
	if(view_client?.mob == viewer && !QDELETED(viewer))
		restoring_sounds = TRUE
		for(var/datum/looping_sound/loop as anything in local_loops)
			if(QDELETED(loop) || loop.stopped || !loop_reaches(loop, viewer))
				continue
			viewer.playsound_local(loop.direct ? viewer : get_turf(loop.parent), loop.cursound, loop.volume, loop.vary, loop.frequency, loop.falloff, loop.channel, FALSE, null, loop)
		var/area/current_area = get_area(viewer)
		SSdroning.kill_loop(view_client)
		SSdroning.kill_rain(view_client)
		SSdroning.play_loop(current_area, view_client)
		SSdroning.play_rain(current_area, view_client)
		if(had_ambience_timer)
			SSambience.ambience_listening_clients[view_client] = max(world.time, saved_ambience_time)
		restoring_sounds = FALSE
	local_loops.Cut()
	loop_templates.Cut()
	ambient_sounds.Cut()
	ambient_channels.Cut()
	one_shot_channels.Cut()

// 音效的原始接收名单已由 playsound 检查墙体和传播范围；只在真正的接收者上转发。
/mob/living/playsound_local(atom/turf_source, soundin, vol as num, vary, frequency, falloff, channel, pressure_affected = TRUE, sound/S, repeat, muffled)
	var/datum/looping_sound/loop = istype(repeat, /datum/looping_sound) ? repeat : null
	var/scene_sound = (!channel || channel <= CHANNEL_HIGHEST_AVAILABLE) && (isturf(turf_source) || loop) && !loop?.direct
	var/sound_file = S?.file || soundin
	if(istype(sound_file, /sound))
		var/sound/file_sound = sound_file
		sound_file = file_sound.file
	if(findtext("[sound_file]", "sound/music/") || findtext("[sound_file]", "sound/misc/notice"))
		scene_sound = FALSE
	if(!QDELETED(group_mindlink_view) && !group_mindlink_view.restoring_sounds && (scene_sound || channel == CHANNEL_WEATHER))
		if(loop)
			group_mindlink_view.local_loops |= loop
		return FALSE
	if(!scene_sound || !client || !can_hear())
		return ..()
	// 防止共享的 sound 对象被父过程修改后，下一位观看者继承错误音量或方位。
	var/sound/played_sound = S
	if(!played_sound)
		played_sound = istype(soundin, /sound) ? group_mindlink_copy_sound(soundin) : sound(get_sfx(soundin))
	var/sound/raw_sound
	if(length(group_mindlink_sense_watchers))
		raw_sound = group_mindlink_copy_sound(played_sound)
		played_sound = group_mindlink_copy_sound(raw_sound)
	. = ..(turf_source, soundin, vol, vary, frequency, falloff, channel, pressure_affected, played_sound, repeat, muffled)
	if(.)
		LAZYINITLIST(group_mindlink_scene_channels)
		group_mindlink_scene_channels["[played_sound.channel]"] = played_sound.file
	if(!raw_sound)
		return
	raw_sound.frequency = played_sound.frequency
	for(var/datum/group_mindlink_view/view as anything in group_mindlink_sense_watchers.Copy())
		if(loop)
			view.receive_loop(loop, raw_sound)
		else
			view.receive_sound(turf_source, raw_sound, vol, falloff, muffled)

/datum/group_mindlink_view/proc/spatial_sound(atom/source, sound/template, volume, falloff, muffled)
	if(!senses_valid() || !target.can_hear() || !template?.file)
		return null
	var/turf/listener_turf = get_turf(target)
	var/turf/source_turf = get_turf(source)
	if(!listener_turf || !source_turf)
		return null
	if(isdullahan(target))
		var/mob/living/carbon/human/person = target
		var/datum/species/dullahan/species = person.dna.species
		if(species.headless && species.my_head)
			listener_turf = get_turf(species.my_head)
			muffled = istype(species.my_head.loc, /obj/structure/closet) || istype(species.my_head.loc, /obj/item/storage)
	if(!listener_turf)
		return null
	var/sound/result = group_mindlink_copy_sound(template)
	result.status = 0
	result.wait = 0
	result.repeat = FALSE
	if(muffled)
		volume *= 0.75
		falloff = (falloff || FALLOFF_SOUNDS) * 1.5
		result.environment = 11
	var/area/listener_area = get_area(target)
	if(listener_area && listener_area.soundenv != -1)
		result.environment = listener_area.soundenv
	result.volume = min(volume * (view_client.prefs.mastervol * 0.01), 100)
	result.volume *= max(0, 1 - 0.1 * get_dist(listener_turf, source_turf))
	if(result.volume <= 0)
		return null
	var/dx = source_turf.x - listener_turf.x
	var/dz = source_turf.y - listener_turf.y
	result.x = abs(dx) <= 1 ? 0 : dx
	result.z = abs(dz) <= 1 ? 0 : dz
	result.y = source_turf.z - listener_turf.z
	result.falloff = falloff || FALLOFF_SOUNDS
	return result

/datum/group_mindlink_view/proc/receive_sound(atom/source, sound/template, volume, falloff, muffled)
	var/sound/received = spatial_sound(source, template, volume, falloff, muffled)
	if(!received)
		return
	// 一次性音效使用有界通道池，不随十五分钟内的音效数量持续占用全局通道。
	if(length(one_shot_channels) < 8)
		var/channel = SSsounds.reserve_sound_channel(src)
		if(channel)
			one_shot_channels += channel
	if(!length(one_shot_channels))
		return
	next_sound_channel = ((next_sound_channel - 1) % length(one_shot_channels)) + 1
	received.channel = one_shot_channels[next_sound_channel++]
	SEND_SOUND(view_client, received)

/datum/group_mindlink_view/proc/loop_reaches(datum/looping_sound/loop, mob/living/listener)
	if(QDELETED(loop) || loop.stopped || !loop.parent || !listener?.can_hear())
		return FALSE
	if(loop.direct)
		return loop.parent == listener
	var/turf/source_turf = get_turf(loop.parent)
	if(!source_turf)
		return FALSE
	var/distance = world.view + (loop.extra_range || 1)
	var/list/listeners
	if(!loop.ignore_walls)
		listeners = get_hearers_in_view(distance, source_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)
	else
		listeners = get_hearers_in_range(distance, source_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)
		var/turf/above = GET_TURF_ABOVE(source_turf)
		var/turf/below = GET_TURF_BELOW(source_turf)
		if(above)
			listeners |= get_hearers_in_range(distance, above, RECURSIVE_CONTENTS_CLIENT_MOBS)
		if(below)
			listeners |= get_hearers_in_range(distance, below, RECURSIVE_CONTENTS_CLIENT_MOBS)
	return listener in listeners

/datum/group_mindlink_view/proc/receive_loop(datum/looping_sound/loop, sound/template)
	if(!senses_valid() || QDELETED(loop) || loop.direct || !loop_reaches(loop, target))
		remove_loop(loop)
		return
	if(template)
		loop_templates[loop] = group_mindlink_copy_sound(template)
	else
		template = loop_templates[loop] || loop.cursound
	if(!istype(template))
		template = sound(template)
	if(findtext("[template?.file]", "sound/music/"))
		return
	var/sound/received = spatial_sound(loop.parent, template, loop.volume, loop.falloff, FALSE)
	if(!received)
		remove_loop(loop)
		return
	var/sound/previous = remote_loops[loop]
	if(previous)
		received.channel = previous.channel
		if(previous.file == received.file && loop.repeat_sound)
			received.status = SOUND_UPDATE
	else
		received.channel = SSsounds.reserve_sound_channel(src)
		if(!received.channel)
			return
	received.repeat = loop.repeat_sound
	remote_loops[loop] = received
	SEND_SOUND(view_client, received)

/datum/group_mindlink_view/proc/remove_loop(datum/looping_sound/loop)
	loop_templates -= loop
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
	for(var/datum/looping_sound/loop as anything in remote_loops.Copy())
		if(QDELETED(loop) || !loop_reaches(loop, target))
			remove_loop(loop)
		else if(loop.repeat_sound)
			receive_loop(loop)
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
				ambient_channels[key] = SSsounds.reserve_sound_channel(src)
			if(!ambient_channels[key])
				continue
			received.channel = ambient_channels[key]
			received.status = previous?.file == received.file ? SOUND_UPDATE : 0
			// SoundQuery 不提供实际播放音量，环境声直接遵循观看者设置，不能按查询默认值反推。
			received.volume = clamp(view_client.prefs.ambiencevol, 0, 100)
			if(environment.channel == CHANNEL_WEATHER)
				received.volume = clamp(view_client.prefs.mastervol, 0, 100)
				for(var/datum/looping_sound/weather as anything in target.client.played_loops)
					if(weather.direct && weather.channel == CHANNEL_WEATHER)
						received.volume = clamp(weather.volume * view_client.prefs.mastervol * 0.01, 0, 100)
						break
			ambient_sounds[key] = received
			SEND_SOUND(view_client, received)
	for(var/key in ambient_sounds.Copy())
		if(!(key in present))
			SEND_SOUND(view_client, sound(null, channel = ambient_channels[key]))
			ambient_sounds -= key
