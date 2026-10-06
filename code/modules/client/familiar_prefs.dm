/datum/familiar_prefs
	/// Reference to our prefs
	var/datum/preferences/prefs
	var/familiar_name
	var/familiar_specie
	var/familiar_headshot_link
	var/familiar_flavortext
	var/familiar_flavortext_display
	var/familiar_ooc
	var/familiar_ooc_notes
	var/familiar_ooc_notes_display
	var/familiar_ooc_extra
	var/familiar_ooc_extra_link
	var/familiar_pronouns = THEY_THEM // Default pronouns

/datum/familiar_prefs/New(datum/preferences/passed_prefs)
	. = ..()
	prefs = passed_prefs

/datum/familiar_prefs/proc/fam_show_ui()
	var/client/client = prefs?.parent
	if (!client)
		return

	var/list/dat = list()
		// --- Familiar species display using mapping ---
	if (familiar_specie && GLOB.familiar_display_names[familiar_specie])
		var/specie_type = GLOB.familiar_display_names[familiar_specie] ? GLOB.familiar_display_names[familiar_specie] : "未知种族"
		dat += "<div align='center'><font size=4 color='#bbbbbb'>[specie_type]</font></div>"

	dat += "<br><b>魔宠姓名:</b> <a href='?_src_=familiar_prefs;preference=familiar_name;task=input'>[familiar_name]（设置姓名）</a>"

	// --- Pronoun selection ---
	var/list/pronoun_display = list(
		HE_HIM = "他",
		SHE_HER = "她",
		THEY_THEM = "他们",
		IT_ITS = "它"
	)
	var/selected_pronoun = pronoun_display[familiar_pronouns] ? pronoun_display[familiar_pronouns] : "他们"
	dat += "<br><b>代称:</b> <a href='?_src_=familiar_prefs;preference=familiar_pronouns;task=select'>[selected_pronoun]</a>"

	dat += "<br><b>魔宠头肩像:</b> <a href='?_src_=familiar_prefs;preference=familiar_headshot;task=input'>更改</a>"
	if (familiar_headshot_link)
		dat += "<br><img src='[familiar_headshot_link]' width='100px' height='100px'>"

	dat += "<br><b>风味文本:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_flavortext;task=input'>更改</a>"

	dat += "<br><b>OOC 备注:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_ooc_notes;task=input'>更改</a>"

	dat += "<br><b>魔宠 OOC 附加内容:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_ooc_extra;task=input'>更改</a>"

	var/display_name = "未选择"
	var/list/all_types = GLOB.familiar_types
	for (var/name in all_types)
		if (all_types[name] == familiar_specie)
			display_name = name
			break
	dat += "<br><b>所选魔宠类型:</b> <a href='?_src_=familiar_prefs;preference=familiar_specie;task=select'>[display_name]</a>"

	if (familiar_specie)
		var/lore_blurb = GLOB.familiar_lore_blurbs[familiar_specie]
		if (lore_blurb)
			dat += "<br><i><b>背景设定参考:</b> [lore_blurb]</i>"

	if (client in GLOB.familiar_queue)
		dat += "<br><a href='?_src_=familiar_prefs;preference=familiar_queue;task=leave'>退出队列</a>"
	else
		dat += "<br><a href='?_src_=familiar_prefs;preference=familiar_queue;task=join'>加入队列</a>"

	var/datum/browser/popup = new(client?.mob, "Be a Familiar", "<center>成为魔宠</center>", 330, 410)
	popup.set_window_options("can_close=1")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/familiar_prefs/proc/fam_process_link(mob/user, list/href_list)
	if(!user)
		return

	var/task = href_list["task"]

	switch(href_list["preference"])
		if("familiar_name")
			var/new_name = input(user, "选择你的魔宠角色姓名：", "身份") as text|null
			if(new_name)
				new_name = reject_bad_name(new_name)
				if(new_name)
					familiar_name = new_name
					to_chat(user, "<span class='notice'>魔宠姓名已设为[new_name]。</span>")
				else
					to_chat(user, "<font color='red'>无效姓名。姓名长度必须在2到[MAX_NAME_LEN]个字符之间，且只能包含A-Z、a-z、-、'、.和,。</font>")
				
		if ("familiar_pronouns")
			var/list/pronoun_options = list(
				"他" = HE_HIM,
				"她" = SHE_HER,
				"他们" = THEY_THEM,
				"它" = IT_ITS
			)
			var/choice = input(user, "选择你的魔宠代称：", "代称") as null|anything in pronoun_options
			if(choice)
				familiar_pronouns = pronoun_options[choice]
				to_chat(user, "<span class='notice'>魔宠代称已设为[choice]。</span>")
				
		if("familiar_headshot")
			to_chat(user, "<span class='notice'>请使用不含成人内容的头肩像，以保持沉浸感。<b>请勿使用真人照片或不严肃的图片。</b></span>")
			to_chat(user, "<span class='notice'>请确认使用图片直链。图片会缩小至325x325像素。</span>")
			var/new_headshot_link = input(user, "输入头肩像链接（https；支持gyazo、discord、lensdump、imgbox、catbox、imgbb、filegarden）：", "头肩像", familiar_headshot_link) as text|null
			if(new_headshot_link == null)
				return
			if(new_headshot_link == "")
				familiar_headshot_link = null
				fam_show_ui()
				return
			if(!valid_headshot_link(user, new_headshot_link))
				familiar_headshot_link = null
				fam_show_ui()
				return
			familiar_headshot_link = new_headshot_link
			to_chat(user, "<span class='notice'>已更新魔宠头肩像</span>")
			log_game("[user] has set their Familiar Headshot image to '[familiar_headshot_link]'.")

		if("familiar_flavortext")
			to_chat(user, "<span class='notice'><b>风味文本不应包含背景故事或角色内心想法等无法通过感官察觉的内容。</b></span>")
			var/new_flavortext = input(user, "输入你的魔宠角色描述：", "风味文本", familiar_flavortext) as message|null
			if(new_flavortext == null)
				return
			if(new_flavortext == "")
				familiar_flavortext = null
				familiar_flavortext_display = null
				fam_show_ui()
				return
			familiar_flavortext = new_flavortext
			var/ft = html_encode(parsemarkdown_basic(familiar_flavortext))
			ft = replacetext(ft, "\n", "<BR>")
			familiar_flavortext_display = ft
			to_chat(user, "<span class='notice'>已更新魔宠风味文本</span>")
			log_game("[user] has set their familiar flavortext.")

		if("familiar_ooc_notes")
			var/new_ooc_notes = input(user, "输入你的OOC偏好：", "OOC 备注", familiar_ooc_notes) as message|null
			if(new_ooc_notes == null)
				return
			if(new_ooc_notes == "")
				familiar_ooc_notes = null
				familiar_ooc_notes_display = null
				fam_show_ui()
				return
			familiar_ooc_notes = new_ooc_notes
			var/ooc = html_encode(parsemarkdown_basic(familiar_ooc_notes))
			ooc = replacetext(ooc, "\n", "<BR>")
			familiar_ooc_notes_display = ooc
			to_chat(user, "<span class='notice'>已更新魔宠 OOC 备注。</span>")
			log_game("[user] has set their Familiar OOC notes.")

		if("familiar_ooc_extra")
			to_chat(user, "<span class='notice'>添加mp3、mp4或jpg/png链接（catbox、discord等）。</span>")
			to_chat(user, "<span class='notice'>视频会缩小至约300x300像素。滥用此功能将导致封禁。</span>")
			to_chat(user, "<font color='#d6d6d6'>输入一个空格以删除。</font>")
			var/link = input(user, "输入附加内容链接（https）", "魔宠 OOC 附加内容", familiar_ooc_extra_link) as text|null
			if(link == null)
				return
			if(link == "")
				link = null
				fam_show_ui()
				return
			if(link == " ")
				familiar_ooc_extra = null
				familiar_ooc_extra_link = null
				to_chat(user, "<span class='notice'>已删除魔宠 OOC 附加内容。</span>")
				fam_show_ui()
				return
			var/static/list/valid_ext = list("jpg", "jpeg", "png", "gif", "mp4", "mp3")
			if(!valid_headshot_link(user, link, FALSE, valid_ext))
				link = null
				fam_show_ui()
				return
			familiar_ooc_extra_link = link
			var/ext = LOWER_TEXT(splittext(link, ".")[length(splittext(link, "."))])
			var/info
			switch(ext)
				if("jpg", "jpeg", "png", "gif")
					familiar_ooc_extra = "<div align='center'><br><img src='[link]'/></div>"
					info = "嵌入图片。"
				if("mp4")
					familiar_ooc_extra = "<div align='center'><br><video width='288' height='288' controls><source src='[link]' type='video/mp4'></video></div>"
					info = "视频。"
				if("mp3")
					familiar_ooc_extra = "<div align='center'><br><audio controls><source src='[link]' type='audio/mp3'>你的浏览器不支持音频播放。</audio></div>"
					info = "嵌入音频。"
			to_chat(user, "<span class='notice'>已将魔宠 OOC 附加内容更新为[info]</span>")
			log_game("[user] has set their Familiar OOC Extra to '[link]'.")

		if ("familiar_queue")
			if (task == "join")
				var/datum/preferences/prefs = user?.client?.prefs
				var/datum/familiar_prefs/fam_pref = prefs?.familiar_prefs
				
				if (!fam_pref)
					to_chat(user, "<span class='warning'>魔宠偏好尚未初始化。</span>")
					return

				if (!fam_pref.familiar_name || !fam_pref.familiar_flavortext_display || !fam_pref.familiar_specie)
					to_chat(user, "<span class='warning'>加入队列前，你必须设置魔宠的姓名、描述和类型。</span>")
					return

				if (!(user.client in GLOB.familiar_queue))
					GLOB.familiar_queue += user.client
					to_chat(user, "<span class='notice'>你已加入魔宠队列。</span>")

			else if (task == "leave")
				if (user.client in GLOB.familiar_queue)
					GLOB.familiar_queue -= user.client
					to_chat(user, "<span class='notice'>你已退出魔宠队列。</span>")

		if ("familiar_specie")
			var/list/all_types = GLOB.familiar_types

			var/choice = input(user, "选择魔宠类型：", "魔宠类型") as null|anything in all_types
			if (choice)
				var/path = all_types[choice]
				if (path)
					familiar_specie = path
					to_chat(user, "<span class='notice'>魔宠类型已设为[choice]</span>")
					log_game("[user] has set familiar type to [choice]")
				else
					to_chat(user, span_warning("选择该魔宠类型时发生错误。"))

	if(user.client)
		fam_show_ui()

/datum/familiar_prefs/proc/load_familiar_prefs(savefile/S)
	S["familiar_name"]					>> familiar_name
	S["familiar_pronouns"]				>> familiar_pronouns
	S["familiar_specie"]				>> familiar_specie
	S["familiar_headshot_link"]			>> familiar_headshot_link
	S["familiar_flavortext"]			>> familiar_flavortext
	S["familiar_ooc_notes"]				>> familiar_ooc_notes
	S["familiar_ooc_extra"]				>> familiar_ooc_extra
	S["familiar_ooc_extra_link"]		>> familiar_ooc_extra_link
	return TRUE

/datum/familiar_prefs/proc/save_familiar_prefs(savefile/S)
	if(istype(S))
		WRITE_FILE(S["familiar_name"] , familiar_name)
		WRITE_FILE(S["familiar_pronouns"] , familiar_pronouns)
		WRITE_FILE(S["familiar_specie"] , familiar_specie)
		WRITE_FILE(S["familiar_headshot_link"] , familiar_headshot_link)
		WRITE_FILE(S["familiar_flavortext"] , familiar_flavortext)
		WRITE_FILE(S["familiar_ooc_notes"] , familiar_ooc_notes)
		WRITE_FILE(S["familiar_ooc_extra"] , familiar_ooc_extra)
		WRITE_FILE(S["familiar_ooc_extra_link"] , familiar_ooc_extra_link)
	return TRUE


