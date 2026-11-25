/datum/gnoll_prefs
	var/gnoll_name = ""
	var/gnoll_pronouns = HE_HIM
	var/pelt_type = "firepelt"
	var/list/genitals = list(
		"penis" = FALSE,
		"vagina" = FALSE,
		"breasts" = FALSE
	)
	var/descriptor_height     = /datum/mob_descriptor/height/moderate
	var/descriptor_body       = /datum/mob_descriptor/body/muscular
	var/descriptor_fur        = /datum/mob_descriptor/fur/coarse
	var/descriptor_voice      = /datum/mob_descriptor/voice/growly
	var/descriptor_muzzle     = /datum/mob_descriptor/face/gnoll/long_muzzle
	var/descriptor_expression = /datum/mob_descriptor/face_exp/gnoll/alert

	var/gnoll_voice_color = "a0a0a0"
	var/datum/statpack/gnoll_statpack = new /datum/statpack/wildcard/fated()

	var/headshot_link
	var/list/gallery_alternates = list()
	/// Links that fail validation or overflow their gallery, never shown to anyone but their owner
	var/list/blocked_links = list()
	var/headshot_zoom = HEADSHOT_ZOOM_MIN
	var/headshot_x = HEADSHOT_X_DEFAULT
	var/headshot_y = HEADSHOT_Y_DEFAULT
	var/headshot_framed = FALSE
	var/image_backdrop = GALLERY_BACKDROP_TAVERN
	var/list/card_backgrounds = list()
	var/list/art_view_settings = list()
	/// Presentation inherited by new artwork for this form
	var/list/artwork_defaults
	var/flavortext
	var/ooc_notes
	var/ooc_extra
	var/ooc_extra_img
	var/ooc_extra_img_link
	var/ooc_extra_img_size = OOC_EXTRA_SIZE_MAX
	var/song_artist
	var/song_title
	var/rumour
	var/noble_gossip
	var/nsfwflavortext
	var/nsfw_ooc_extra_img
	var/nsfw_ooc_extra_img_link
	var/nsfw_ooc_extra_img_size = OOC_EXTRA_SIZE_MAX
	var/erpprefs
	var/list/img_gallery = list()
	var/list/nsfw_img_gallery = list()

/datum/gnoll_prefs/New()
	. = ..()
	ensure_gnoll_name()

/datum/gnoll_prefs/proc/generate_random_gnoll_name()
	return "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"

/datum/gnoll_prefs/proc/ensure_gnoll_name()
	if(!gnoll_name)
		gnoll_name = generate_random_gnoll_name()
	return gnoll_name

/datum/gnoll_prefs/proc/get_pronoun_options()
	var/static/list/pronoun_options = list(
		"他" = HE_HIM,
		"她" = SHE_HER,
		"TA" = THEY_THEM,
		"它" = IT_ITS
	)
	return pronoun_options

/datum/gnoll_prefs/proc/get_pelt_options()
	var/static/list/pelt_options = list(
		"焰毛" = "firepelt",
		"腐毛" = "rotpelt",
		"白毛" = "whitepelt",
		"血毛" = "bloodpelt",
		"夜毛" = "nightpelt",
		"暗毛" = "darkpelt"
	)
	return pelt_options

/// Copypaste of the _load_statpack proc from preferences_savefile.dm
/datum/gnoll_prefs/proc/load_gnoll_statpack(savefile/S)
	var/statpack_type
	S["gnoll_statpack"] >> statpack_type
	if (statpack_type && ispath(statpack_type))
		gnoll_statpack = new statpack_type()
	else
		gnoll_statpack = new /datum/statpack/wildcard/fated()

/datum/gnoll_prefs/proc/get_descriptor_options(slot)
	var/static/list/descriptor_options_by_slot = list(
		"height" = list(
				"适中" = /datum/mob_descriptor/height/moderate,
				"中等" = /datum/mob_descriptor/height/middling,
				"矮小" = /datum/mob_descriptor/height/short,
				"高大" = /datum/mob_descriptor/height/tall,
				"高耸" = /datum/mob_descriptor/height/towering,
				"巨人般" = /datum/mob_descriptor/height/giant,
				"娇小" = /datum/mob_descriptor/height/tiny
		),
		"body" = list(
				"普通" = /datum/mob_descriptor/body/average,
				"健美" = /datum/mob_descriptor/body/athletic,
				"肌肉发达" = /datum/mob_descriptor/body/muscular,
				"魁伟" = /datum/mob_descriptor/body/herculean,
				"紧实" = /datum/mob_descriptor/body/toned,
				"厚重" = /datum/mob_descriptor/body/heavy,
				"精瘦" = /datum/mob_descriptor/body/lean,
				"壮硕" = /datum/mob_descriptor/body/burly,
				"枯瘦" = /datum/mob_descriptor/body/gaunt,
				"瘦高" = /datum/mob_descriptor/body/lanky
		),
		"fur" = list(
				"平常" = /datum/mob_descriptor/fur/plain,
				"短毛" = /datum/mob_descriptor/fur/short,
				"粗糙" = /datum/mob_descriptor/fur/coarse,
				"刚硬" = /datum/mob_descriptor/fur/bristly,
				"蓬松" = /datum/mob_descriptor/fur/fluffy,
				"蓬乱" = /datum/mob_descriptor/fur/shaggy,
				"丝滑" = /datum/mob_descriptor/fur/silky,
				"稀疏垂贴" = /datum/mob_descriptor/fur/lank,
				"斑秃" = /datum/mob_descriptor/fur/mangy,
				"绒软" = /datum/mob_descriptor/fur/velvety,
				"浓密" = /datum/mob_descriptor/fur/dense,
				"纠结成团" = /datum/mob_descriptor/fur/matted
		),
		"voice" = list(
				"低吼" = /datum/mob_descriptor/voice/growly,
				"低沉" = /datum/mob_descriptor/voice/deep,
				"洪亮" = /datum/mob_descriptor/voice/booming,
				"沙哑" = /datum/mob_descriptor/voice/gravelly,
				"威严" = /datum/mob_descriptor/voice/commanding,
				"平板" = /datum/mob_descriptor/voice/monotone,
				"普通" = /datum/mob_descriptor/voice/ordinary,
				"轻柔" = /datum/mob_descriptor/voice/soft,
				"庄重" = /datum/mob_descriptor/voice/grave,
				"阴毒" = /datum/mob_descriptor/voice/venomous,
				"冷淡" = /datum/mob_descriptor/voice/dispassionate,
				"哀怨" = /datum/mob_descriptor/voice/whiny,
				"拖腔" = /datum/mob_descriptor/voice/drawling,
				"尖厉" = /datum/mob_descriptor/voice/shrill,
				"生硬" = /datum/mob_descriptor/voice/stilted
		),
		"muzzle" = list(
				"长吻" = /datum/mob_descriptor/face/gnoll/long_muzzle,
				"短吻" = /datum/mob_descriptor/face/gnoll/short_muzzle,
				"宽吻" = /datum/mob_descriptor/face/gnoll/broad_muzzle,
				"窄吻" = /datum/mob_descriptor/face/gnoll/narrow_muzzle,
				"伤疤累累" = /datum/mob_descriptor/face/gnoll/scarred_muzzle,
				"尖吻" = /datum/mob_descriptor/face/gnoll/sharp_muzzle,
				"饱经风霜" = /datum/mob_descriptor/face/gnoll/worn_muzzle,
				"毁容" = /datum/mob_descriptor/face/gnoll/disfigured_muzzle
		),
		"expression" = list(
				"警觉" = /datum/mob_descriptor/face_exp/gnoll/alert,
				"龇牙咧嘴" = /datum/mob_descriptor/face_exp/gnoll/snarling,
				"猎食者般" = /datum/mob_descriptor/face_exp/gnoll/predatory,
				"空洞" = /datum/mob_descriptor/face_exp/gnoll/hollow,
				"凶猛" = /datum/mob_descriptor/face_exp/gnoll/fierce,
				"茫然" = /datum/mob_descriptor/face_exp/gnoll/vacant,
				"卑躬屈膝" = /datum/mob_descriptor/face_exp/gnoll/groveling,
				"不怀好意" = /datum/mob_descriptor/face_exp/gnoll/leering
		)
	)

	return descriptor_options_by_slot[slot]

/datum/gnoll_prefs/proc/get_selected_label(list/options, value)
	for(var/label in options)
		if(options[label] == value)
			return "[label]"
	return null

/datum/gnoll_prefs/proc/list_has_value(list/options, value)
	for(var/label in options)
		if(options[label] == value)
			return TRUE
	return FALSE

/datum/gnoll_prefs/proc/get_descriptor_value(slot)
	switch(slot)
		if("height")
			return descriptor_height
		if("body")
			return descriptor_body
		if("fur")
			return descriptor_fur
		if("voice")
			return descriptor_voice
		if("muzzle")
			return descriptor_muzzle
		if("expression")
			return descriptor_expression

	return null

/datum/gnoll_prefs/proc/set_descriptor_value(slot, value)
	var/list/options = get_descriptor_options(slot)
	if(!options || !list_has_value(options, value))
		return FALSE

	switch(slot)
		if("height")
			descriptor_height = value
		if("body")
			descriptor_body = value
		if("fur")
			descriptor_fur = value
		if("voice")
			descriptor_voice = value
		if("muzzle")
			descriptor_muzzle = value
		if("expression")
			descriptor_expression = value
		else
			return FALSE

	return TRUE

/datum/gnoll_prefs/vv_edit_var(var_name, var_value)
	. = ..()
	for(var/client/client as anything in GLOB.clients)
		if(client?.prefs?.gnoll_prefs == src)
			client.prefs.refresh_character_gallery()
			return

/datum/gnoll_prefs/proc/gnoll_show_ui(mob/user)
	if(!user.client)
		return
	user.client.prefs?.refresh_character_gallery(values_changed = FALSE)

	var/list/dat = list()
	dat += "<html><head><title>豺狼人自定义</title></head><body>"
	dat += "<center><h2>选择你的形态，以血星之名散播恐惧！！</h2></center><br>"

	// Name section
	dat += "<b>当前姓名:</b> [gnoll_name] "
	dat += "<a href='?_src_=gnoll_prefs;action=set_name'>自定义姓名</a> | "
	dat += "<a href='?_src_=gnoll_prefs;action=random_name'>随机豺狼人姓名</a><br>"

	// Pronouns section
	var/list/pronoun_options = get_pronoun_options()
	var/pronoun_label = get_selected_label(pronoun_options, gnoll_pronouns) || "他"
	dat += "<b>代词:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_pronouns'>[pronoun_label]</a>"
	dat += "<br>"

	dat += "<b>语音颜色:</b> <a href='?_src_=gnoll_prefs;action=voice_color'>更改</a><br>"

	dat += "<b>豺狼人属性方案:</b> <a href='?_src_=gnoll_prefs;action=gnoll_statpack'>更改</a><br>"
	dat += "<span style='color:#b2b2b2;'>" 
	if(gnoll_statpack)
		var/stats_string = gnoll_statpack.generate_modifier_string()
		if(stats_string)
			dat += "<b>[gnoll_statpack.name]</b> <i>" + stats_string + "</i><br>"
		else
			dat += "<b>[gnoll_statpack.name]</b><br>"
		dat += "[gnoll_statpack.desc]<br>"
	else
		dat += "未选择<br>"
	dat += "</span><br>"

	// Pelt type section
	var/list/pelt_options = get_pelt_options()
	var/pelt_label = get_selected_label(pelt_options, pelt_type) || "焰毛"
	dat += "<b>毛皮花纹:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_pelt'>[pelt_label]</a>"
	dat += "<br>"

	// Genitals section
	dat += "<b>性征:</b><br>"
	var/list/genital_options = list(
		"阴茎" = "penis",
		"阴道" = "vagina",
		"乳房" = "breasts"
	)
	for(var/genital_label in genital_options)
		var/genital_id = genital_options[genital_label]
		var/status = genitals[genital_id] ? "有" : "无"
		var/toggle_action = genitals[genital_id] ? "disable" : "enable"
		dat += "&nbsp;&nbsp;[genital_label]: [status] "
		dat += "<a href='?_src_=gnoll_prefs;action=toggle_genital;genital=[genital_id];toggle=[toggle_action]'>[toggle_action == "enable" ? "启用" : "禁用"]</a><br>"

	// Height section
	var/list/height_options = get_descriptor_options("height")
	var/height_label = get_selected_label(height_options, descriptor_height) || "适中"
	dat += "<b>身高:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=height'>[height_label]</a>"
	dat += "<br>"

	// Body section
	var/list/body_options = get_descriptor_options("body")
	var/body_label = get_selected_label(body_options, descriptor_body) || "肌肉发达"
	dat += "<b>体格:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=body'>[body_label]</a>"
	dat += "<br>"

	// Fur section
	var/list/fur_options = get_descriptor_options("fur")
	var/fur_label = get_selected_label(fur_options, descriptor_fur) || "粗糙"
	dat += "<b>毛发:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=fur'>[fur_label]</a>"
	dat += "<br>"

	// Voice section
	var/list/voice_options = get_descriptor_options("voice")
	var/voice_label = get_selected_label(voice_options, descriptor_voice) || "低吼"
	dat += "<b>声音:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=voice'>[voice_label]</a>"
	dat += "<br>"

	// Muzzle shape section
	var/list/muzzle_options = get_descriptor_options("muzzle")
	var/muzzle_label = get_selected_label(muzzle_options, descriptor_muzzle) || "长吻"
	dat += "<b>口鼻形状:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=muzzle'>[muzzle_label]</a>"
	dat += "<br>"

	// Expression section
	var/list/expression_options = get_descriptor_options("expression")
	var/expression_label = get_selected_label(expression_options, descriptor_expression) || "警觉"
	dat += "<b>神情:</b> "
	dat += "<a href='?_src_=gnoll_prefs;action=choose_descriptor;slot=expression'>[expression_label]</a>"
	dat += "<br>"

	dat += "<h3>豺狼人风味文本（可选）</h3>"

	dat += "<b>Character Gallery:</b> <a href='byond://?_src_=gnoll_prefs;action=character_gallery'>Change</a>"

	dat += "<br><b>Flavortext: </b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><a href='byond://?_src_=gnoll_prefs;action=flavortext'>Change</a>"
	dat += "<br><b>NSFW Flavortext: </b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><a href='byond://?_src_=gnoll_prefs;action=nsfwflavortext'>Change</a>"
	dat += "<br><b>OOC Notes: </b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><a href='?_src_=gnoll_prefs;action=ooc_notes'>Change</a>"

	dat += "<br><b>传闻与贵族闲话:</b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><br><a href='?_src_=gnoll_prefs;action=rumour'>设置传闻</a><a href='?_src_=gnoll_prefs;action=gossip'>设置闲话</a><a href='?_src_=gnoll_prefs;action=rumour_preview'><i>预览</i></a>"

	dat += "<br><b>ERP Preferences:</b><a href='?_src_=gnoll_prefs;action=formathelp'>(?)</a><a href='?_src_=gnoll_prefs;action=erpprefs'>Change</a>"
	dat += "<br><b>Song:</b> <a href='?_src_=gnoll_prefs;action=ooc_extra'>Change URL</a>"
	dat += "<a href='?_src_=gnoll_prefs;action=change_title'>Change Title</a>"
	dat += "<a href='?_src_=gnoll_prefs;action=change_artist'>Change Artist</a>"
	dat += "<br><a href='?_src_=gnoll_prefs;action=ooc_preview'><b>Preview Examine</b></a>"

	dat += "<center><a href='?_src_=gnoll_prefs;action=close'>关闭</a></center>"
	dat += "</body></html>"

	var/datum/browser/popup = new(user, "gnoll_prefs", "豺狼人自定义", 500, 600)
	popup.set_content(dat.Join())
	popup.open()

/datum/gnoll_prefs/proc/gnoll_process_link(mob/user, list/href_list)
	if(!user || !user.client)
		return

	var/action = href_list["action"]
	switch(action)
		if("set_name")
			var/new_name = input(user, "输入你的豺狼人姓名：", "豺狼人姓名", gnoll_name) as text|null
			if(new_name)
				gnoll_name = sanitize_name(new_name)
				ensure_gnoll_name()
				gnoll_show_ui(user)

		if("random_name")
			gnoll_name = generate_random_gnoll_name()
			gnoll_show_ui(user)

		if("choose_pronouns")
			var/list/pronoun_options = get_pronoun_options()
			var/current_pronoun = get_selected_label(pronoun_options, gnoll_pronouns)
			var/selected_pronoun = input(user, "选择代词", "豺狼人自定义", current_pronoun) as null|anything in pronoun_options
			if(!selected_pronoun)
				return
			gnoll_pronouns = pronoun_options[selected_pronoun]
			gnoll_show_ui(user)

		if("choose_pelt")
			var/list/pelt_options = get_pelt_options()
			var/current_pelt = get_selected_label(pelt_options, pelt_type)
			var/selected_pelt = input(user, "选择毛皮花纹", "豺狼人自定义", current_pelt) as null|anything in pelt_options
			if(!selected_pelt)
				return
			pelt_type = pelt_options[selected_pelt]
			gnoll_show_ui(user)

		if("choose_descriptor")
			var/slot = href_list["slot"]
			var/list/descriptor_options = get_descriptor_options(slot)
			if(!descriptor_options)
				return
			var/current_descriptor = get_selected_label(descriptor_options, get_descriptor_value(slot))
			var/selected_descriptor = input(user, "选择我的外貌描述", "豺狼人自定义", current_descriptor) as null|anything in descriptor_options
			if(!selected_descriptor)
				return
			if(set_descriptor_value(slot, descriptor_options[selected_descriptor]))
				gnoll_show_ui(user)

		if("set_pronouns")
			var/new_pronouns = href_list["pronouns"]
			if(new_pronouns in list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS))
				gnoll_pronouns = new_pronouns
				gnoll_show_ui(user)

		if("set_pelt")
			var/new_pelt = href_list["pelt"]
			var/list/valid_pelts = list("firepelt", "rotpelt", "whitepelt", "bloodpelt", "nightpelt", "darkpelt")
			if(new_pelt in valid_pelts)
				pelt_type = new_pelt
				gnoll_show_ui(user)

		if("toggle_genital")
			var/genital = href_list["genital"]
			var/toggle = href_list["toggle"]
			if(genital in genitals)
				genitals[genital] = (toggle == "enable")
				gnoll_show_ui(user)

		if("set_descriptor")
			var/slot = href_list["slot"]
			var/new_type = text2path(href_list["type"])
			if(!new_type)
				return
			switch(slot)
				if("height")
					var/list/valid_height = list(
						/datum/mob_descriptor/height/moderate,
						/datum/mob_descriptor/height/middling,
						/datum/mob_descriptor/height/short,
						/datum/mob_descriptor/height/tall,
						/datum/mob_descriptor/height/towering,
						/datum/mob_descriptor/height/giant,
						/datum/mob_descriptor/height/tiny
					)
					if(new_type in valid_height)
						descriptor_height = new_type
				if("body")
					var/list/valid_body = list(
						/datum/mob_descriptor/body/average,
						/datum/mob_descriptor/body/athletic,
						/datum/mob_descriptor/body/muscular,
						/datum/mob_descriptor/body/herculean,
						/datum/mob_descriptor/body/toned,
						/datum/mob_descriptor/body/heavy,
						/datum/mob_descriptor/body/lean,
						/datum/mob_descriptor/body/burly,
						/datum/mob_descriptor/body/gaunt,
						/datum/mob_descriptor/body/lanky
					)
					if(new_type in valid_body)
						descriptor_body = new_type
				if("fur")
					var/list/valid_fur = list(
						/datum/mob_descriptor/fur/plain,
						/datum/mob_descriptor/fur/short,
						/datum/mob_descriptor/fur/coarse,
						/datum/mob_descriptor/fur/bristly,
						/datum/mob_descriptor/fur/fluffy,
						/datum/mob_descriptor/fur/shaggy,
						/datum/mob_descriptor/fur/silky,
						/datum/mob_descriptor/fur/lank,
						/datum/mob_descriptor/fur/mangy,
						/datum/mob_descriptor/fur/velvety,
						/datum/mob_descriptor/fur/dense,
						/datum/mob_descriptor/fur/matted
					)
					if(new_type in valid_fur)
						descriptor_fur = new_type
				if("voice")
					var/list/valid_voice = list(
						/datum/mob_descriptor/voice/growly,
						/datum/mob_descriptor/voice/deep,
						/datum/mob_descriptor/voice/booming,
						/datum/mob_descriptor/voice/gravelly,
						/datum/mob_descriptor/voice/commanding,
						/datum/mob_descriptor/voice/monotone,
						/datum/mob_descriptor/voice/ordinary,
						/datum/mob_descriptor/voice/soft,
						/datum/mob_descriptor/voice/grave,
						/datum/mob_descriptor/voice/venomous,
						/datum/mob_descriptor/voice/dispassionate,
						/datum/mob_descriptor/voice/whiny,
						/datum/mob_descriptor/voice/drawling,
						/datum/mob_descriptor/voice/shrill,
						/datum/mob_descriptor/voice/stilted
					)
					if(new_type in valid_voice)
						descriptor_voice = new_type
				if("muzzle")
					var/list/valid_muzzle = list(
						/datum/mob_descriptor/face/gnoll/long_muzzle,
						/datum/mob_descriptor/face/gnoll/short_muzzle,
						/datum/mob_descriptor/face/gnoll/broad_muzzle,
						/datum/mob_descriptor/face/gnoll/narrow_muzzle,
						/datum/mob_descriptor/face/gnoll/scarred_muzzle,
						/datum/mob_descriptor/face/gnoll/sharp_muzzle,
						/datum/mob_descriptor/face/gnoll/worn_muzzle,
						/datum/mob_descriptor/face/gnoll/disfigured_muzzle
					)
					if(new_type in valid_muzzle)
						descriptor_muzzle = new_type
				if("expression")
					var/list/valid_expression = list(
						/datum/mob_descriptor/face_exp/gnoll/alert,
						/datum/mob_descriptor/face_exp/gnoll/snarling,
						/datum/mob_descriptor/face_exp/gnoll/predatory,
						/datum/mob_descriptor/face_exp/gnoll/hollow,
						/datum/mob_descriptor/face_exp/gnoll/fierce,
						/datum/mob_descriptor/face_exp/gnoll/vacant,
						/datum/mob_descriptor/face_exp/gnoll/groveling,
						/datum/mob_descriptor/face_exp/gnoll/leering
					)
					if(new_type in valid_expression)
						descriptor_expression = new_type
			gnoll_show_ui(user)
		if("formathelp")
			var/list/dat = list()
			dat +="可以使用反斜杠（\\）转义特殊字符。<br>"
			dat += "<br>"
			dat += "# 文本 : 设置标题。<br>"
			dat += "|文本| : 将文本居中。<br>"
			dat += "**文本** : 将文本<b>加粗</b>。<br>"
			dat += "*文本* : 将文本设为<i>斜体</i>。<br>"
			dat += "^文本^ : <font size = \"4\">放大</font>文本。<br>"
			dat += "((文本)) : <font size = \"1\">缩小</font>文本。<br>"
			dat += "* 条目 : 无序列表条目。<br>"
			dat += "--- : 添加水平分隔线。<br>"
			dat += "-=FFFFFF文本=- : 为文本指定<font color = '#FFFFFF'>颜色</font>。<br><br>"
			var/datum/browser/popup = new(user, "Formatting Help", nwidth = 400, nheight = 350)
			popup.set_content(dat.Join())
			popup.open(FALSE)
		if("flavortext")
			to_chat(user, "<span class='notice'>["<span class='bold'>风味文本不应包含背景故事或角色内心想法等无法通过感官察觉的内容。</span>"]</span>")
			var/new_flavortext = tgui_input_text(user, "输入你的豺狼人角色描述：", "风味文本", flavortext, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
			if(new_flavortext == null)
				return
			if(new_flavortext == "")
				flavortext = null
				return
			flavortext = new_flavortext
			to_chat(user, "<span class='notice'>已更新豺狼人风味文本</span>")
			log_game("[user] has set their gnoll flavortext'.")
		if("ooc_notes")
			to_chat(user, "<span class='notice'>["<span class='bold'>OOC 备注用于提供角色扮演的互动线索，以及角色的一般信息。</span>"]</span>")
			var/new_ooc_notes = tgui_input_text(user, "输入你的 OOC 偏好：", "OOC 备注", ooc_notes, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
			if(new_ooc_notes == null)
				return
			if(new_ooc_notes == "")
				ooc_notes = null
				gnoll_show_ui(user)
				return
			ooc_notes = new_ooc_notes
			to_chat(user, "<span class='notice'>已更新豺狼人 OOC 备注。</span>")
			log_game("[user] has set their gnoll OOC notes'.")
		if("rumour")
			to_chat(user, span_notice("传闻是别人可能知道、或自以为知道的关于你的事情，不必准确，甚至不必真实。但它们能为其他玩家提供线索，帮助他们与你的角色互动或形成看法。\n<b>请避免露骨的身体描述，但可以写\"经常与人厮混\"之类的传闻。</b>"))
			var/new_rumour = tgui_input_text(user, "输入关于你的角色的传闻：（最多 400 个字符）", "传闻", rumour, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_rumour == null)
				return
			if(new_rumour == "")
				rumour = null
				gnoll_show_ui(user)
				return
			if(length(new_rumour) > 400)
				to_chat(user, span_warning("传闻不能超过 400 个字符。"))
				gnoll_show_ui(user)
				return
			rumour = new_rumour
			to_chat(user, span_notice("已更新豺狼人传闻"))
			log_game("[user] has set their gnoll's rumour'.")
		if("gossip")
			to_chat(user, span_notice("贵族闲话是只在贵族圈中流传的传闻，只有其他出身高贵的人才知道。与普通传闻一样，它们不必准确或真实，但能为其他贵族提供与你的角色互动和评价你的线索。\n<b>请避免露骨的身体描述，但可以写\"经常与人厮混\"之类的传闻。</b>"))
			var/new_gossip = tgui_input_text(user, "输入关于你的豺狼人角色的贵族闲话：（最多 400 个字符）", "贵族闲话", noble_gossip, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_gossip == null)
				return
			if(new_gossip == "")
				noble_gossip = null
				gnoll_show_ui(user)
				return
			if(length(new_gossip) > 400)
				to_chat(user, span_notice("贵族闲话不能超过 400 个字符。"))
				gnoll_show_ui(user)
				return
			noble_gossip = new_gossip
			to_chat(user, span_notice("已更新豺狼人贵族闲话"))
			log_game("[user] has set their gnoll's noble gossip'.")

		if("nsfwflavortext")
			to_chat(user, "<span class='notice'>["<span class='bold'>成人风味文本可用于描述身体，以及其他可能被视为露骨内容的外在细节。</span>"]</span>")
			to_chat(user, "<font color = '#d6d6d6'>留空以清除。</font>")
			var/new_nsfwflavortext = tgui_input_text(user, "输入你的豺狼人角色描述：", "成人风味文本", nsfwflavortext, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
			if(new_nsfwflavortext == null)
				return
			if(new_nsfwflavortext == "")
				new_nsfwflavortext = null
				nsfwflavortext = null
				to_chat(user, "<span class='notice'>已删除豺狼人成人风味文本。</span>")
				return
			nsfwflavortext = new_nsfwflavortext
			to_chat(user, "<span class='notice'>已更新豺狼人成人风味文本</span>")
			log_game("[user] has set their gnoll NSFW flavortext'.")
		if("erpprefs")
			to_chat(user, "<span class='notice'>["<span class='bold'>成人角色扮演偏好。如果你在这里写下“什么都行”或“没有限制”，请不要惊讶于别人照此理解。</span>"]</span>")
			to_chat(user, "<font color = '#d6d6d6'>留空以清除。</font>")
			var/new_erpprefs = tgui_input_text(user, "输入你的偏好：", "ERP 偏好", erpprefs, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
			if(new_erpprefs == null)
				return
			if(new_erpprefs == "")
				new_erpprefs = null
				erpprefs = null
				to_chat(user, "<span class='notice'>已删除 ERP 偏好。</span>")
				gnoll_show_ui(user)
				return
			erpprefs = new_erpprefs
			to_chat(user, "<span class='notice'>已更新 ERP 偏好。</span>")
			log_game("[user] has set their ERP preferences'.")

		if("ooc_preview")
			user.client?.prefs?.open_examine_preview(user, GALLERY_FORM_GNOLL)

		if("character_gallery")
			user.client?.prefs?.open_character_gallery(user, GALLERY_FORM_GNOLL)

		if("rumour_preview")
			var/msg = ""
			if(rumour && length(rumour))
				var/rumour_display = rumour
				rumour_display = html_encode(rumour_display)
				rumour_display = parsemarkdown_basic(rumour_display, hyperlink = TRUE)
				msg += "<b>你想起了镇上关于[gnoll_name]的传闻……</b><br>[rumour_display]"
			if(length(noble_gossip))
				if(msg)
					msg += "<br><br>"
				var/gossip_display = noble_gossip
				gossip_display = html_encode(gossip_display)
				gossip_display = parsemarkdown_basic(gossip_display, hyperlink = TRUE)
				msg += "<b>你想起了其他贵族私下谈论[gnoll_name]时说的话……</b><br>[gossip_display]"
			if(msg)
				to_chat(user, "<span class='info'>[msg]</span>")

		if("ooc_extra")
			to_chat(user, "<span class='notice'>添加合适网站（如 catbox）的 mp3 链接，将歌曲嵌入你的风味文本。</span>")
			to_chat(user, "<span class='notice'>如果歌曲无法正常播放，请确认链接是能在浏览器中正常打开的直链。</span>")
			to_chat(user, "<font color = '#d6d6d6'>留空以清除当前歌曲。</font>")
			to_chat(user, "<font color ='red'>滥用此功能将导致封禁。</font>")
			var/new_extra_link = tgui_input_text(user, "输入歌曲链接（https，支持 catbox）：", "歌曲链接", ooc_extra, encode = FALSE)
			if(new_extra_link == null)
				return
			if(new_extra_link == "")
				new_extra_link = null
				ooc_extra = null
				to_chat(user, "<span class='notice'>已删除豺狼人 OOC 附加内容。</span>")
				gnoll_show_ui(user)
				return
			var/static/list/valid_extensions = list("mp3")
			if(!valid_headshot_link(user, new_extra_link, FALSE, valid_extensions))
				new_extra_link = null
				gnoll_show_ui(user)
				return

			var/list/value_split = splittext(new_extra_link, ".")

			// extension will always be the last entry
			var/extension = value_split[length(value_split)]
			if((extension in valid_extensions))
				ooc_extra = new_extra_link
				to_chat(user, "<span class='notice'>已更新豺狼人歌曲链接。</span>")
				log_game("[user] has set their gnoll Song URL to '[ooc_extra]'.")

		if("change_artist")
			var/new_artist = tgui_input_text(user, "输入歌曲的歌手：", "歌曲歌手", song_artist,  encode = FALSE)
			if(new_artist == null)
				return
			if(new_artist == "")
				gnoll_show_ui(user)
				return
			song_artist = new_artist
			to_chat(user, "<span class='notice'>已更新豺狼人歌曲歌手。</span>")
			log_game("[user] has set their gnoll song artist.")

		if("change_title")
			var/new_title = tgui_input_text(user, "输入歌曲名称：", "歌曲名称", song_title,  encode = FALSE)
			if(new_title== null)
				return
			if(new_title == "")
				gnoll_show_ui(user)
				return
			song_title = new_title
			to_chat(user, "<span class='notice'>已更新豺狼人歌曲名称。</span>")
			log_game("[user] has set their gnoll song title.")

		if("gnoll_statpack")
			// Build statpack list
			var/list/statpacks_available = list()
			for (var/path as anything in GLOB.statpacks - /datum/statpack/wildcard/virtuous) // gnolls can't have virtues
				var/datum/statpack/SP = GLOB.statpacks[path]
				if (!SP.name)
					continue
				// Add stats to the name in the selection list
				var/display_name = SP.name
				var/stats = SP.generate_modifier_string()
				if(stats)
					display_name = "[SP.name] [stats]"
				statpacks_available[display_name] = SP
			
			statpacks_available = sort_list(statpacks_available)
			var/choice = tgui_input_list(user, "选择你的豺狼人属性方案：", "属性方案选择", statpacks_available)
			
			if(choice)
				var/datum/statpack/selected = statpacks_available[choice]
				gnoll_statpack = selected
				to_chat(user, span_notice("已选择豺狼人属性方案：[choice]。"))
				to_chat(user, "<span class='info'>[selected.description_string()]</span>")
			gnoll_show_ui(user)

		if("voice_color")
			var/new_voice = input(user, "选择你的豺狼人语音颜色：", "角色偏好","#"+gnoll_voice_color) as color|null
			if(new_voice)
				if(color_hex2num(new_voice) < 230)
					to_chat(user, "<font color='red'>这个语音颜色太暗，凡人难以辨认。</font>")
					return
				gnoll_voice_color = sanitize_hexcolor(new_voice)
			gnoll_show_ui(user)

		if("close")
			user << browse(null, "window=gnoll_prefs")

	return TRUE

/datum/gnoll_prefs/proc/load_gnoll_prefs(savefile/S)
	if(istype(S))
		S["gnoll_name"]						>> gnoll_name
		S["gnoll_pronouns"]					>> gnoll_pronouns
		S["gnoll_pelt_type"]				>> pelt_type
		if(!pelt_type)
			pelt_type = "firepelt"
		S["gnoll_genitals_penis"]			>> genitals["penis"]
		S["gnoll_genitals_vagina"]			>> genitals["vagina"]
		S["gnoll_genitals_breasts"]			>> genitals["breasts"]
		S["gnoll_descriptor_height"]		>> descriptor_height
		if(!ispath(descriptor_height, /datum/mob_descriptor/height))
			descriptor_height = /datum/mob_descriptor/height/moderate
		S["gnoll_descriptor_body"]			>> descriptor_body
		if(!ispath(descriptor_body, /datum/mob_descriptor/body))
			descriptor_body = /datum/mob_descriptor/body/muscular
		S["gnoll_descriptor_fur"]			>> descriptor_fur
		if(!ispath(descriptor_fur, /datum/mob_descriptor/fur))
			descriptor_fur = /datum/mob_descriptor/fur/coarse
		S["gnoll_descriptor_voice"]			>> descriptor_voice
		if(!ispath(descriptor_voice, /datum/mob_descriptor/voice))
			descriptor_voice = /datum/mob_descriptor/voice/growly
		S["gnoll_descriptor_muzzle"]		>> descriptor_muzzle
		if(!ispath(descriptor_muzzle, /datum/mob_descriptor/face/gnoll))
			descriptor_muzzle = /datum/mob_descriptor/face/gnoll/long_muzzle
		S["gnoll_descriptor_expression"]	>> descriptor_expression
		if(!ispath(descriptor_expression, /datum/mob_descriptor/face_exp/gnoll))
			descriptor_expression = /datum/mob_descriptor/face_exp/gnoll/alert

	load_gnoll_statpack(S)
	
	S["gnoll_voice_color"]			>> gnoll_voice_color
	if(color_hex2num("#" + sanitize_hexcolor(gnoll_voice_color)) < 230)
		gnoll_voice_color = "a0a0a0"

	load_gallery_images(S, src, "gnoll_")

	S["gnoll_flavortext"]			>> flavortext
	S["gnoll_ooc_notes"]			>> ooc_notes
	S["gnoll_ooc_extra"]			>> ooc_extra

	S["gnoll_song_artist"] 			>> song_artist
	S["gnoll_song_title"] 			>> song_title
	S["gnoll_rumour"]				>> rumour
	S["gnoll_noble_gossip"]			>> noble_gossip
	S["gnoll_nsfwflavortext"]		>> nsfwflavortext
	S["gnoll_erpprefs"]			>> erpprefs

	return TRUE

// To be called by preferences savefile code ONLY
/datum/gnoll_prefs/proc/save_gnoll_prefs(savefile/S)
	if(istype(S))
		WRITE_FILE(S["gnoll_name"] , gnoll_name)
		WRITE_FILE(S["gnoll_pronouns"] , gnoll_pronouns)
		WRITE_FILE(S["gnoll_pelt_type"] , pelt_type)
		WRITE_FILE(S["gnoll_genitals_penis"] , genitals["penis"])
		WRITE_FILE(S["gnoll_genitals_vagina"] , genitals["vagina"])
		WRITE_FILE(S["gnoll_genitals_breasts"] , genitals["breasts"])
		WRITE_FILE(S["gnoll_descriptor_height"] , descriptor_height)
		WRITE_FILE(S["gnoll_descriptor_body"] , descriptor_body)
		WRITE_FILE(S["gnoll_descriptor_fur"] , descriptor_fur)
		WRITE_FILE(S["gnoll_descriptor_voice"] , descriptor_voice)
		WRITE_FILE(S["gnoll_descriptor_muzzle"] , descriptor_muzzle)
		WRITE_FILE(S["gnoll_descriptor_expression"] , descriptor_expression)

		WRITE_FILE(S["gnoll_voice_color"] , gnoll_voice_color) 
		WRITE_FILE(S["gnoll_statpack"] , preferences_typepath_or_null(gnoll_statpack))

		save_gallery_images(S, src, "gnoll_")
		WRITE_FILE(S["gnoll_flavortext"] , html_decode(flavortext))
		WRITE_FILE(S["gnoll_ooc_notes"] , html_decode(ooc_notes))
		WRITE_FILE(S["gnoll_ooc_extra"] ,	ooc_extra)
		WRITE_FILE(S["gnoll_song_artist"] , song_artist)
		WRITE_FILE(S["gnoll_song_title"] , song_title)		
		WRITE_FILE(S["gnoll_rumour"] , html_decode(rumour))
		WRITE_FILE(S["gnoll_noble_gossip"] , html_decode(noble_gossip))
		WRITE_FILE(S["gnoll_nsfwflavortext"] , html_decode(nsfwflavortext))
		WRITE_FILE(S["gnoll_erpprefs"] , html_decode(erpprefs))

	return TRUE
