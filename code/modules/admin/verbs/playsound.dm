/client/proc/play_sound(S as sound)
	set category = "-GameMaster-"
	set name = "声音 - 全域"
	if(!check_rights(R_SOUND))
		return

	var/freq = 1
	var/vol = input(usr, "要以多大音量播放声音？",, 100) as null|num
	if(!vol)
		return
	vol = CLAMP(vol, 1, 100)

	var/sound/admin_sound = new()
	admin_sound.file = S
	admin_sound.priority = 250
	admin_sound.channel = CHANNEL_ADMIN
	admin_sound.frequency = freq
	admin_sound.wait = 1
	admin_sound.repeat = 0
	admin_sound.status = SOUND_STREAM
	admin_sound.volume = vol

	var/res = alert(usr, "向玩家显示这首歌的名称吗？",, "是","否", "取消")
	switch(res)
		if("是")
			to_chat(world, span_boldannounce("管理员播放了：[S]"))
		if("取消")
			return

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] 播放了声音 [S]")

	for(var/mob/M in GLOB.player_list)
		if(M.client.prefs.toggles & SOUND_MIDI)
			var/user_vol = M.client.prefs.musicvol
			if(user_vol)
				admin_sound.volume = vol * (user_vol / 100)
			SEND_SOUND(M, admin_sound)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Global Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/change_music_vol()
	set category = "选项"
	set name = "调整音乐音量"
	set hidden = 1

	if(prefs)
/*		if(blacklisted() == 1)
			var/vol = input(usr, "Current music power: [prefs.musicvol]",, 100) as null|num
			vol = 100
			prefs.musicvol = vol
			prefs.save_preferences()
			mob.update_music_volume(CHANNEL_MUSIC, prefs.musicvol)
			mob.update_music_volume(CHANNEL_LOBBYMUSIC, prefs.musicvol)
			mob.update_music_volume(CHANNEL_ADMIN, prefs.musicvol)
		else*/
		var/vol = input(usr, "当前音乐音量：[prefs.musicvol]",, 100) as null|num
		if(!vol)
			if(vol != 0)
				return
		vol = min(vol, 100)
		prefs.musicvol = vol
		prefs.save_preferences()

		mob.update_music_volume(CHANNEL_MUSIC, prefs.musicvol)
		mob.update_music_volume(CHANNEL_ADMIN, prefs.musicvol)

/client/verb/volume_power_menu()
	set category = "选项"
	set name = "音量设置"

	if(!prefs)
		return

	if(!volume_power_menu)
		volume_power_menu = new(src)

	volume_power_menu.ui_interact(mob)

/client/proc/apply_volume_power_setting(setting_id, volume_value)
	if(!prefs)
		return

	var/vol = clamp(round(volume_value), 0, 100)
	switch(setting_id)
		if("master")
			prefs.mastervol = vol
		if("music")
			prefs.musicvol = vol
			mob?.update_music_volume(CHANNEL_MUSIC, prefs.musicvol)
			mob?.update_music_volume(CHANNEL_ADMIN, prefs.musicvol)
		if("combat")
			prefs.combatmusicvol = vol
			if(mob?.cmode)
				mob.update_music_volume(CHANNEL_BUZZ, prefs.combatmusicvol)
				mob.update_music_volume(CHANNEL_CMUSIC1, prefs.combatmusicvol)
				mob.update_music_volume(CHANNEL_CMUSIC2, prefs.combatmusicvol)
				mob.update_music_volume(CHANNEL_CMUSIC3, prefs.combatmusicvol)
				mob.update_music_volume(CHANNEL_CMUSIC4, prefs.combatmusicvol)
		if("ambience")
			prefs.ambiencevol = vol
			mob?.update_channel_volume(CHANNEL_AMBIENCE, prefs.ambiencevol)
			mob?.update_channel_volume(CHANNEL_RAIN, prefs.ambiencevol)
		if("lobby")
			prefs.lobbymusicvol = vol
			if(isnewplayer(mob))
				mob.update_music_volume(CHANNEL_LOBBYMUSIC, prefs.lobbymusicvol)
		else
			return

	prefs.save_preferences()

/datum/volume_power_menu
	var/client/owner

/datum/volume_power_menu/New(client/C)
	. = ..()
	owner = C

/datum/volume_power_menu/Destroy(force)
	if(owner?.volume_power_menu == src)
		owner.volume_power_menu = null
	owner = null
	return ..()

/datum/volume_power_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VolumePowerMenu", "音量设置")
		ui.set_state(GLOB.always_state)
		ui.open()

/datum/volume_power_menu/ui_data(mob/user)
	var/list/data = list()
	if(!owner?.prefs)
		return data

	data["master"] = isnum(owner.prefs.mastervol) ? owner.prefs.mastervol : initial(owner.prefs.mastervol)
	data["music"] = isnum(owner.prefs.musicvol) ? owner.prefs.musicvol : initial(owner.prefs.musicvol)
	data["combat"] = isnum(owner.prefs.combatmusicvol) ? owner.prefs.combatmusicvol : initial(owner.prefs.combatmusicvol)
	data["ambience"] = isnum(owner.prefs.ambiencevol) ? owner.prefs.ambiencevol : initial(owner.prefs.ambiencevol)
	data["lobby"] = isnum(owner.prefs.lobbymusicvol) ? owner.prefs.lobbymusicvol : initial(owner.prefs.lobbymusicvol)
	return data

/datum/volume_power_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!owner?.prefs)
		return FALSE

	if(action == "set_volume")
		var/setting_id = params["id"]
		var/volume_value = text2num(params["value"])
		owner.apply_volume_power_setting(setting_id, volume_value)
		SStgui.update_uis(src)
		return TRUE

	return FALSE


/client/verb/show_rolls()
	set category = "选项"
	set name = "显示掷骰"
	set hidden = 1

	if(prefs)
		prefs.showrolls = !prefs.showrolls
		prefs.save_preferences()
		if(prefs.showrolls)
			to_chat(src, "已开启掷骰显示")
		else
			to_chat(src, "已关闭掷骰显示")

/client/verb/change_master_vol()
	set category = "选项"
	set name = "调整音效音量"
	set hidden = 1

	if(prefs)
		var/vol = input(usr, "当前音效音量（影响音乐与环境声以外的所有声音）：[prefs.mastervol]",, 100) as null|num
		if(!vol)
			if(vol != 0)
				return
		vol = min(vol, 100)
		prefs.mastervol = vol
		prefs.save_preferences()

/client/verb/change_ambience_vol()
	set category = "选项"
	set name = "调整环境声音量"
	set hidden = 1

	if(prefs)
		var/vol = input(usr, "当前环境声音量：[prefs.ambiencevol]",, 100) as null|num
		if(!vol)
			if(vol != 0)
				return
		vol = min(vol, 100)
		prefs.ambiencevol = vol
		prefs.save_preferences()

		mob.update_channel_volume(CHANNEL_AMBIENCE, prefs.ambiencevol)
		mob.update_channel_volume(CHANNEL_RAIN, prefs.ambiencevol)

/client/verb/change_lobby_music_vol()
	set category = "选项"
	set name = "调整大厅音乐音量"
	set hidden = 1

	if(prefs)
		var/vol = input(usr, "当前大厅音乐音量：[prefs.lobbymusicvol]",, 100) as null|num
		if(!vol)
			if(vol != 0)
				return
		vol = min(vol, 100)
		prefs.lobbymusicvol = vol
		prefs.save_preferences()

		if(isnewplayer(mob))
			mob.update_music_volume(CHANNEL_LOBBYMUSIC, prefs.lobbymusicvol)
/*
/client/verb/help_rpguide()
	set category = "Options"
	set name = "zHelp-RPGuide"

	src << link("https://cdn.discordapp.com/attachments/844865105040506891/938971395445112922/rpguide.jpg")

/client/verb/help_uihelp()
	set category = "Options"
	set name = "zHelp-UIGuide"

	src << link("https://cdn.discordapp.com/attachments/844865105040506891/938275090414579762/unknown.png")
*/

/client/proc/play_local_sound(S as sound)
	set category = "-GameMaster-"
	set name = "声音 - 附近"
	if(!check_rights(R_SOUND))
		return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] 在附近播放了声音 [S]")
	playsound(get_turf(src.mob), S, 50, FALSE, FALSE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Local Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_local_sound_variable(S as sound)
	set category = "-GameMaster-"
	set name = "声音 - 自定义范围"
	if(!check_rights(R_SOUND))
		return

	var/dist = input(usr, "要让声音传播多远？",, 50) as null|num
	if(!dist)
		return
	dist = CLAMP(dist, 1, 100)

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] 在附近播放了声音 [S]")
	playsound(get_turf(src.mob), S, dist, FALSE, FALSE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Local Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_web_sound()
	set category = "-GameMaster-"
	set name = "声音 - 网络"
	if(!check_rights(R_SOUND))
		return

	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(src, span_boldwarning("未配置 Youtube-dl，无法使用此功能")) //Check config.txt for the INVOKE_YOUTUBEDL value
		return

	var/web_sound_input = input("输入内容网址（仅限支持的网站，留空停止播放）", "大人，请选曲。") as text|null
	if(istext(web_sound_input))
		var/web_sound_url = ""
		var/stop_web_sounds = FALSE
		var/list/music_extra_data = list()
		if(length(web_sound_input))

			web_sound_input = trim(web_sound_input)
			if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
				to_chat(src, span_boldwarning("不允许使用非 HTTP(S) 地址。"))
				to_chat(src, span_warning("请使用网站上的完整网址，不能使用 ytsearch: 等 youtube-dl 快捷指令。"))
				return
			var/shell_scrubbed_input = shell_url_scrub(web_sound_input)
			var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
			var/errorlevel = output[SHELLEO_ERRORLEVEL]
			var/stdout = output[SHELLEO_STDOUT]
			var/stderr = output[SHELLEO_STDERR]
			if(!errorlevel)
				var/list/data
				try
					data = json_decode(stdout)
				catch(var/exception/e)
					to_chat(src, span_boldwarning("Youtube-dl JSON 解析失败："))
					to_chat(src, span_warning("[e]: [stdout]"))
					return

				if (data["url"])
					web_sound_url = data["url"]
					var/title = "[data["title"]]"
					var/webpage_url = title
					if (data["webpage_url"])
						webpage_url = "<a href=\"[data["webpage_url"]]\">[title]</a>"
					music_extra_data["start"] = data["start_time"]
					music_extra_data["end"] = data["end_time"]

					var/artist = data["uploader"]
					var/album = data["album"]
					var/upload_date = data["upload_date"]
					var/duration_value = data["duration"]
					var/link_meta = web_sound_input
					if (data["webpage_url"])
						link_meta = "[data["webpage_url"]]"

					// Base metadata for the TGUI media player
					music_extra_data["title"] = title
					music_extra_data["link"] = link_meta
					if(artist)
						music_extra_data["artist"] = artist
					if(album)
						music_extra_data["album"] = album
					if(upload_date)
						music_extra_data["upload_date"] = upload_date
					if(isnum(duration_value))
						music_extra_data["duration"] = "[duration_value] 秒"

					var/res = alert(usr, "向玩家显示这首歌的名称和链接吗？\n[title]", "大人，请选曲。", "否", "是", "取消")
					switch(res)
						if("是")
							to_chat(world, span_boldannounce("管理员播放了：[webpage_url]"))
						if("否")
							// Hide detailed metadata in the chat media widget while still playing the song
							music_extra_data["title"] = null
							music_extra_data["link"] = "Song Link Hidden"
							music_extra_data["duration"] = "Song Duration Hidden"
							music_extra_data["artist"] = "Song Artist Hidden"
							music_extra_data["album"] = "Song Album Hidden"
							music_extra_data["upload_date"] = "Song Upload Date Hidden"
						if("取消")
							return

					SSblackbox.record_feedback("nested tally", "played_url", 1, list("[ckey]", "[web_sound_input]"))
					log_admin("[key_name(src)] played web sound: [web_sound_input]")
					message_admins("[key_name(src)] 播放了网络声音：[web_sound_input]")
			else
				to_chat(src, span_boldwarning("Youtube-dl 获取网址失败："))
				to_chat(src, span_warning("[stderr]"))

		else //pressed ok with blank
			log_admin("[key_name(src)] stopped web sound")
			message_admins("[key_name(src)] 停止了网络声音")
			web_sound_url = null
			stop_web_sounds = TRUE

		if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning("已阻止：内容网址未使用 HTTP(S) 协议"))
			to_chat(src, span_warning("媒体提供方返回的内容网址未使用 HTTP 或 HTTPS 协议"))
			return
		if(web_sound_url || stop_web_sounds)
			for(var/m in GLOB.player_list)
				var/mob/M = m
				var/client/C = M.client
				if(C.prefs.toggles & SOUND_MIDI)
					// Stops playing lobby music and admin loaded music automatically.
					SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
					SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
					if(!stop_web_sounds)
						C.tgui_panel?.play_music(web_sound_url, music_extra_data)
					else
						C.tgui_panel?.stop_music()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Internet Sound")

/client/proc/play_music_global_url()
	set category = "-GameMaster-"
	set name = "音乐 - 全域网址"
	if(!check_rights(R_SOUND))
		return

	var/web_sound_input = input("输入 HTTPS 音频直链（留空停止播放）", "大人，请选曲。") as text|null
	if(isnull(web_sound_input))
		return

	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/list/music_extra_data = list()

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning("不允许使用非 HTTP(S) 地址。"))
			return

		web_sound_url = web_sound_input

		var/title = input(usr, "可选：要显示的歌曲名称（留空显示未知曲目）", "歌曲名称") as null|text
		var/artist = input(usr, "可选：要显示的演唱者（留空隐藏）", "歌曲演唱者") as null|text

		music_extra_data["title"] = title
		music_extra_data["link"] = web_sound_input
		if(artist)
			music_extra_data["artist"] = artist

		var/res = alert(usr, "向玩家显示这首歌的名称和链接吗？\n[title ? title : web_sound_input]", "大人，请选曲。", "否", "是", "取消")
		switch(res)
			if("是")
				to_chat(world, span_boldannounce("管理员播放了：[title ? title : web_sound_input]"))
			if("否")
				music_extra_data["title"] = null
				music_extra_data["link"] = "Song Link Hidden"
				music_extra_data["duration"] = "Song Duration Hidden"
				music_extra_data["artist"] = "Song Artist Hidden"
				music_extra_data["album"] = "Song Album Hidden"
				music_extra_data["upload_date"] = "Song Upload Date Hidden"
			if("取消")
				return
	else
		log_admin("[key_name(src)] stopped global URL music")
		message_admins("[key_name_admin(src)] 停止了全域网址音乐")
		stop_web_sounds = TRUE

	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		to_chat(src, span_boldwarning("已阻止：内容网址未使用 HTTP(S) 协议"))
		return

	if(web_sound_url || stop_web_sounds)
		log_admin("[key_name(src)] played global URL music: [web_sound_input]")
		message_admins("[key_name(src)] 播放了全域网址音乐：[web_sound_input]")
		for(var/mob/M in GLOB.player_list)
			var/client/C = M.client
			if(!C)
				continue
			if(C.prefs.toggles & SOUND_MIDI)
				SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
				SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
				if(!stop_web_sounds)
					C.tgui_panel?.play_music(web_sound_url, music_extra_data)
				else
					C.tgui_panel?.stop_music()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Global Music URL")

/client/proc/play_music_local_url()
	set category = "-GameMaster-"
	set name = "音乐 - 附近网址"
	if(!check_rights(R_SOUND))
		return

	var/web_sound_input = input("输入 HTTPS 音频直链（留空停止播放）", "在附近播放音乐（网址）") as text|null
	if(isnull(web_sound_input))
		return

	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/dist = 0
	var/list/music_extra_data = list()

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning("不允许使用非 HTTP(S) 地址。"))
			return

		web_sound_url = web_sound_input

		dist = input(usr, "要让音乐传播多远？",, 50) as null|num
		if(!dist)
			return
		dist = CLAMP(dist, 1, 100)

		var/title = input(usr, "可选：要显示的歌曲名称（留空显示未知曲目）", "歌曲名称") as null|text
		var/artist = input(usr, "可选：要显示的演唱者（留空隐藏）", "歌曲演唱者") as null|text

		music_extra_data["title"] = title
		music_extra_data["link"] = web_sound_input
		if(artist)
			music_extra_data["artist"] = artist

		var/res = alert(usr, "向附近玩家显示这首歌的名称和链接吗？\n[title ? title : web_sound_input]", "大人，请选曲。", "否", "是", "取消")
		switch(res)
			if("是")
				to_chat(world, span_boldannounce("管理员在附近播放了：[title ? title : web_sound_input]"))
			if("否")
				music_extra_data["title"] = null
				music_extra_data["link"] = "Song Link Hidden"
				music_extra_data["duration"] = "Song Duration Hidden"
				music_extra_data["artist"] = "Song Artist Hidden"
				music_extra_data["album"] = "Song Album Hidden"
				music_extra_data["upload_date"] = "Song Upload Date Hidden"
			if("取消")
				return
	else
		log_admin("[key_name(src)] stopped local URL music")
		message_admins("[key_name_admin(src)] 停止了附近网址音乐")
		stop_web_sounds = TRUE

	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		to_chat(src, span_boldwarning("已阻止：内容网址未使用 HTTP(S) 协议"))
		return

	if(web_sound_url || stop_web_sounds)
		log_admin("[key_name(src)] played local URL music: [web_sound_input]")
		message_admins("[key_name(src)] 播放了附近网址音乐：[web_sound_input]")
		var/turf/source_turf = get_turf(src.mob)
		for(var/mob/M in GLOB.player_list + GLOB.dead_mob_list)
			var/client/C = M.client
			if(!C)
				continue
			if(!(C.prefs.toggles & SOUND_MIDI))
				continue
			if(get_dist(source_turf, get_turf(M)) > dist)
				continue
			SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
			SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
			if(!stop_web_sounds)
				C.tgui_panel?.play_music(web_sound_url, music_extra_data)
			else
				C.tgui_panel?.stop_music()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Local Music URL")

/client/proc/play_music_direct_url(mob/M)
	set category = "-GameMaster-"
	set name = "音乐 - 指定玩家网址"
	if(!check_rights(R_SOUND))
		return

	if(!M)
		M = input("向谁播放？", "在线玩家") as null|anything in (GLOB.player_list + GLOB.dead_mob_list)

	if(!M)
		return

	var/client/C = M.client
	if(!C)
		return

	var/web_sound_input = input("输入 HTTPS 音频直链（留空停止播放）", "大人，请选曲。") as text|null
	if(isnull(web_sound_input))
		return

	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/list/music_extra_data = list()

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning("不允许使用非 HTTP(S) 地址。"))
			return

		web_sound_url = web_sound_input

		var/title = input(usr, "可选：要显示的歌曲名称（留空显示未知曲目）", "歌曲名称") as null|text
		var/artist = input(usr, "可选：要显示的演唱者（留空隐藏）", "歌曲演唱者") as null|text

		music_extra_data["title"] = title
		music_extra_data["link"] = web_sound_input
		if(artist)
			music_extra_data["artist"] = artist

		var/res = alert(usr, "向 [M] 显示这首歌的名称和链接吗？\n[title ? title : web_sound_input]", "大人，请选曲。", "否", "是", "取消")
		switch(res)
			if("是")
				to_chat(M, span_boldannounce("管理员播放了：[title ? title : web_sound_input]"))
			if("否")
				music_extra_data["title"] = null
				music_extra_data["link"] = "Song Link Hidden"
				music_extra_data["duration"] = "Song Duration Hidden"
				music_extra_data["artist"] = "Song Artist Hidden"
				music_extra_data["album"] = "Song Album Hidden"
				music_extra_data["upload_date"] = "Song Upload Date Hidden"
			if("取消")
				return
	else
		log_admin("[key_name(src)] stopped direct URL music for [M]")
		message_admins("[key_name_admin(src)] 停止了向 [M] 播放的网址音乐")
		stop_web_sounds = TRUE

	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		to_chat(src, span_boldwarning("已阻止：内容网址未使用 HTTP(S) 协议"))
		return

	if(web_sound_url || stop_web_sounds)
		log_admin("[key_name(src)] played direct URL music for [M]: [web_sound_input]")
		message_admins("[key_name(src)] 向 [M] 播放了网址音乐：[web_sound_input]")
		if(C.prefs.toggles & SOUND_MIDI)
			SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
			SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
			if(!stop_web_sounds)
				C.tgui_panel?.play_music(web_sound_url, music_extra_data)
			else
				C.tgui_panel?.stop_music()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Direct Music URL")

/client/proc/set_round_end_sound(S as sound)
	set category = "-GameMaster-"
	set name = "声音 - 回合结束"
	if(!check_rights(R_SOUND))
		return

	SSticker.SetRoundEndSound(S)

	log_admin("[key_name(src)] set the round end sound to [S]")
	message_admins("[key_name_admin(src)] 将回合结束声音设为 [S]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Round End Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/stop_sounds()
	set category = "-GameMaster-"
	set name = "声音 - 停止所有播放"
	if(!src.holder)
		return

	log_admin("[key_name(src)] stopped all currently playing sounds.")
	message_admins("[key_name_admin(src)] 停止了所有正在播放的声音。")
	for(var/mob/M in GLOB.player_list)
		SEND_SOUND(M, sound(null))
		var/client/C = M.client
		C?.tgui_panel?.stop_music()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stop All Playing Sounds") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

GLOBAL_LIST_INIT(ambience_files, list(
	'sound/music/area/bath.ogg',
	'sound/music/area/bog.ogg',
	'sound/music/area/catacombs.ogg',
	'sound/music/area/caves.ogg',
	'sound/music/area/church.ogg',
	'sound/music/area/decap.ogg',
	'sound/music/area/dungeon.ogg',
	'sound/music/area/dwarf.ogg',
	'sound/music/area/field.ogg',
	'sound/music/area/forest.ogg',
	'sound/music/area/magiciantower.ogg',
	'sound/music/area/manorgarri.ogg',
	'sound/music/area/sargoth.ogg',
	'sound/music/area/septimus.ogg',
	'sound/music/area/sewers.ogg',
	'sound/music/area/shop.ogg',
	'sound/music/area/spidercave.ogg',
	'sound/music/area/towngen.ogg',
	'sound/music/area/townstreets.ogg'
	))
