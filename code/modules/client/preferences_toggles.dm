//this works as is to create a single checked item, but has no back end code for toggleing the check yet
#define TOGGLE_CHECKBOX(PARENT, CHILD) PARENT/CHILD/abstract = TRUE;PARENT/CHILD/checkbox = CHECKBOX_TOGGLE;PARENT/CHILD/verb/CHILD

//Example usage TOGGLE_CHECKBOX(datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()
#ifdef TESTING
//override because we don't want to save preferences twice.
/datum/verbs/menu/Settings/Set_checked(client/C, verbpath)
	if (checkbox == CHECKBOX_GROUP)
		C.prefs.menuoptions[type] = verbpath
	else if (checkbox == CHECKBOX_TOGGLE)
		var/checked = Get_checked(C)
		C.prefs.menuoptions[type] = !checked
		winset(C, "[verbpath]", "is-checked = [!checked]")

/datum/verbs/menu/Settings/verb/setup_character()
	set name = "Character Preferences"
	set category = "Options"
	set desc = ""
	set hidden = 1
	usr.client.prefs.current_tab = 1
	usr.client.prefs.ShowChoices(usr)
#endif

/client/verb/setup_character()
	set name = "Character Preferences"
	set category = "Options"
	set desc = ""
	if(prefs)
		usr.client.prefs.current_tab = 1
		usr.client.prefs.ShowChoices(usr, 4)

/client/verb/toggle_options_menu()
	set name = "Toggles"
	set category = "Options"
	set desc = ""

	if(!prefs)
		return

	if(!toggles_menu)
		toggles_menu = new(src)

	toggles_menu.ui_interact(mob)

/client/verb/keybindings_menu()
	set name = "Keybindings"
	set category = "Options"
	set desc = ""

	if(!prefs)
		return

	prefs.SetKeybinds(mob, FALSE)

/datum/toggle_options_menu
	var/client/owner

/datum/toggle_options_menu/New(client/C)
	. = ..()
	owner = C

/datum/toggle_options_menu/Destroy(force)
	if(owner?.toggles_menu == src)
		owner.toggles_menu = null
	owner = null
	return ..()

/datum/toggle_options_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ToggleOptionsMenu", "Toggles")
		ui.set_state(GLOB.always_state)
		ui.open()

/datum/toggle_options_menu/ui_data(mob/user)
	var/list/data = list()
	if(!owner?.prefs)
		data["categories"] = list()
		return data

	var/list/graphics_entries = list(
		list("id" = "fullscreen", "label" = "全屏", "enabled" = !!(owner.prefs.toggles & TOGGLE_FULLSCREEN), "desc" = "以全屏模式显示游戏窗口。"),
		list("id" = "crt", "label" = "显像管效果", "enabled" = !!owner.prefs.crt, "desc" = "为地图添加显像管式模糊与扫描线效果。"),
		list("id" = "grain", "label" = "颗粒效果", "enabled" = !!owner.prefs.grain, "desc" = "叠加轻微的胶片颗粒效果。"),
		list("id" = "tgui_multiline", "label" = "多行输入", "enabled" = !!owner.mob?.tgui_multiline, "desc" = "在支持的界面中使用多行输入。"),
	)
	var/list/graphics_selects = list(
		list(
			"id" = "hud_colorblind_palette",
			"label" = "状态栏色盲配色",
			"value" = owner.prefs.hud_colorblind_palette,
			"desc" = "将角色状态栏与热量图标切换为对比度更高的色盲配色。",
			"options" = hud_colorblind_palette_options(),
		),
	)

	var/list/character_entries = list(
		list("id" = "masked_examine", "label" = "蒙面时可检视", "enabled" = !!owner.prefs.masked_examine, "desc" = "允许蒙面时显示角色信息。"),
		list("id" = "top_examine", "label" = "检视信息置顶", "enabled" = !!owner.prefs.top_examine, "desc" = "将头像、姓名等主要检视信息显示在检视区顶部。"),
		list("id" = "wildshape_name", "label" = "兽形时显示姓名", "enabled" = !!owner.prefs.wildshape_name, "desc" = "处于野性变身时显示角色姓名。"),
		list("id" = "nsfw_examine", "label" = "始终显示成人检视信息", "enabled" = !!owner.prefs.nsfw_examine_always, "desc" = "即使穿着衣物，也显示成人检视信息。"),
	)

	var/list/visual_entries = list(
		list("id" = "screen_shake", "label" = "画面震动", "enabled" = !!owner.prefs.shake, "desc" = "在产生冲击的事件中启用镜头震动。"),
		list("id" = "no_redflash", "label" = "护眼模式", "enabled" = !!owner.prefs.no_redflash, "desc" = "关闭疼痛等事件引起的红白画面闪烁。"),
		list("id" = "chat_headshot", "label" = "聊天头像", "enabled" = !!owner.prefs.chatheadshot, "desc" = "有头像时，在聊天旁显示角色头像。"),
		list("id" = "mouseover_role", "label" = "悬停显示职业", "enabled" = !!owner.prefs.show_mouseover_role, "desc" = "鼠标悬停时在玩家姓名下显示职业。"),
		list("id" = "examine_blocks", "label" = "隐藏容器内物品详情", "enabled" = !!owner.prefs.no_examine_blocks, "desc" = "隐藏容器内物品的检视详情。"),
		list("id" = "language_fonts", "label" = "禁用语言字体", "enabled" = !!owner.prefs.no_language_fonts, "desc" = "使用普通字体代替各语言的特殊字体。"),
		list("id" = "language_icon", "label" = "禁用语言图标", "enabled" = !!owner.prefs.no_language_icon, "desc" = "隐藏聊天中的语言图标前缀。"),
		list("id" = "floating_text", "label" = "显示浮动文字", "enabled" = !!(owner.prefs.floating_text_toggles & FLOATING_TEXT), "desc" = "显示浮动的战斗与反馈文字。"),
		list("id" = "xp_text", "label" = "显示经验文字", "enabled" = !!(owner.prefs.floating_text_toggles & XP_TEXT), "desc" = "显示获得经验时的浮动文字。"),
	)

	var/list/gameplay_entries = list(
		list("id" = "autoconsume", "label" = "自动进食", "enabled" = !!owner.prefs.autoconsume, "desc" = "自动重复进食或喂食操作。"),
		list("id" = "autowoodcut", "label" = "自动伐木", "enabled" = !!owner.prefs.autowoodcut, "desc" = "首次挥砍后自动继续砍树。"),
		list("id" = "autopicking", "label" = "自动采矿", "enabled" = !!owner.prefs.autopicking, "desc" = "手持镐点击或撞上岩壁后，自动继续采矿。"),
		list("id" = "show_rolls", "label" = "显示掷骰", "enabled" = !!owner.prefs.showrolls, "desc" = "在聊天中显示战斗与检定的掷骰详情。"),
		list("id" = "combat_strip", "label" = "战斗时可打开脱衣菜单", "enabled" = !!(owner.prefs.toggles & CMODE_STRIPPING), "desc" = "允许在战斗模式中打开脱衣菜单。"),
		list("id" = "hide_unavailable_emotes", "label" = "隐藏不可用发声", "enabled" = !!owner.prefs.hide_unavailable_emotes, "desc" = "隐藏当前身体结构无法使用的发声动作。"),
		list("id" = "vocal_barks", "label" = "听见语音短音", "enabled" = !!owner.prefs.hear_barks, "desc" = "启用简短语音音效。"),
		list("id" = "compliance_notifs", "label" = "顺从状态通知", "enabled" = !!owner.prefs.compliance_notifs, "desc" = "顺从模式改变时在聊天中提示。"),
		list("id" = "skillcap_notifs", "label" = "技能上限通知", "enabled" = !!owner.prefs.skillcap_notifs, "desc" = "技能经验达到上限时通知。"),
		list("id" = "autopunctuation", "label" = "禁用自动标点", "enabled" = !!owner.prefs.no_autopunctuate, "desc" = "不为聊天消息自动添加标点。"),
		list("id" = "deadchat", "label" = "显示亡者聊天", "enabled" = !!(owner.prefs.chat_toggles & CHAT_DSAY), "desc" = "接收亡者聊天消息。"),
		list("id" = "legacy_craft", "label" = "启用旧版制作", "enabled" = !!owner.legacycraft, "desc" = "使用旧版制作界面与操作方式。"),
		list("id" = "roleplay_ads", "label" = "接收角色扮演招募", "enabled" = !!(owner.prefs.toggles & ROLEPLAY_ADS), "desc" = "接收新的角色扮演招募通知。"),
		list("id" = "voting_popup", "label" = "启用投票弹窗", "enabled" = !!owner.prefs.voting_popup, "desc" = "允许投票界面弹出。"),
	
	)

	var/list/audio_entries = list(
		list("id" = "lobby_music", "label" = "大厅音乐", "enabled" = !!(owner.prefs.toggles & SOUND_LOBBY), "desc" = "在大厅中播放音乐。"),
		list("id" = "hear_instruments", "label" = "听见乐器", "enabled" = !!(owner.prefs.toggles & SOUND_INSTRUMENTS), "desc" = "听见吟游诗人乐器、点唱机和音响。"),
	)

	var/list/content_entries = list(
		list("id" = "animal_emotes", "label" = "动物发声音效", "enabled" = !!(!owner.prefs.mute_animal_emotes), "desc" = "播放动物表情动作的音效。"),
		list("id" = "erp_panel", "label" = "启用成人互动面板", "enabled" = !!owner.prefs.sexable, "desc" = "允许他人通过成人互动面板与你互动。"),
		list("id" = "erp_visuals", "label" = "启用成人互动视觉效果", "enabled" = !!owner.prefs.erp_visuals, "desc" = "启用成人互动中的爱心及画面叠加等视觉效果。"),
		list("id" = "chastity", "label" = "启用贞操相关内容", "enabled" = !!owner.prefs.chastenable, "desc" = "显示并允许贞操相关内容。"),
		list("id" = "permanent_binding", "label" = "启用永久束缚", "enabled" = (owner.prefs.chastity_hardmode == CHASTITY_HARDMODE_ENABLED), "desc" = "启用不可逆、仅能用钥匙开启的贞操锁机制。"),
		list("id" = "extreme_erp", "label" = "启用极端成人互动", "enabled" = !!owner.prefs.extreme_erp, "desc" = "允许极端成人互动内容。"),
		list("id" = "edging", "label" = "启用高潮边缘控制", "enabled" = !!owner.prefs.edging, "desc" = "允许高潮边缘控制相关的成人互动。"),
		list("id" = "free_use_default", "label" = "默认允许自由使用", "enabled" = !!owner.prefs.free_use_default, "desc" = "默认开启自由使用。可随时在成人互动面板中手动关闭。"),
		list("id" = "facial_branding", "label" = "启用面部烙印", "enabled" = !!owner.prefs.facial_brands, "desc" = "允许他人在你的脸上烙印。"),
		list("id" = "sensitive_branding", "label" = "启用敏感部位烙印", "enabled" = !!owner.prefs.sensitive_brands, "desc" = "允许他人在你的生殖器与乳房上烙印（若有）。"),
		list("id" = "pubes", "label" = "启用阴毛描述", "enabled" = !!owner.prefs.pubes, "desc" = "检视裸露阴毛的角色时显示阴毛描述（若有）。"),
		list("id" = "pits", "label" = "启用腋毛描述", "enabled" = !!owner.prefs.pits, "desc" = "检视裸露腋下的角色时显示腋毛描述（若有）。"),
		list("id" = "descriptor_color", "label" = "启用彩色描述", "enabled" = !!owner.prefs.descriptor_color, "desc" = "按兴奋程度为生殖器描述着色，并按毛色为体毛描述着色。"),
		list("id" = "cursed_collars", "label" = "启用诅咒项圈", "enabled" = !!owner.prefs.cursed_collarable, "desc" = "允许他人为你戴上诅咒项圈。"),
	)

	data["categories"] = list(
		list("name" = "角色", "entries" = character_entries),
		list("name" = "画面", "entries" = graphics_entries, "selects" = graphics_selects),
		list("name" = "视觉效果", "entries" = visual_entries),
		list("name" = "游戏操作", "entries" = gameplay_entries),
		list("name" = "音频", "entries" = audio_entries),
		list("name" = "内容", "entries" = content_entries),
	)
	return data

/datum/toggle_options_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!owner?.prefs)
		return FALSE

	if(action == "toggle")
		var/id = params["id"]
		switch(id)
			if("fullscreen")
				owner.toggle_fullscreen()
			if("crt")
				owner.crtmode()
			if("grain")
				owner.grainfilter()
			if("tgui_multiline")
				owner.mob?.toggle_tgui_multiline()
			if("screen_shake")
				owner.toggle_screenshake()
			if("no_redflash")
				owner.toggle_redflash()
			if("chat_headshot")
				owner.set_picinchat()
			if("masked_examine")
				owner.masked_examine()
			if("top_examine")
				owner.toggle_topexamine()
			if("mouseover_role")
				owner.toggle_mouseover_role()
			if("nsfw_examine")
				owner.nsfw_examine_always()
			if("examine_blocks")
				owner.toggle_examine_blocks()
			if("wildshape_name")
				owner.toggle_wildshape_name()
			if("language_fonts")
				owner.toggle_language_fonts()
			if("language_icon")
				owner.toggle_language_icon()
			if("floating_text")
				owner.toggle_floatingtext()
			if("xp_text")
				owner.toggle_xptext()
			if("autoconsume")
				owner.autoconsume()
			if("autowoodcut")
				owner.toggle_autowoodcut()
			if("autopicking")
				owner.toggle_autopicking()
			if("show_rolls")
				owner.show_rolls()
			if("combat_strip")
				owner.cmode_strip()
			if("hide_unavailable_emotes")
				owner.toggle_hide_unavailable_emotes()
			if("vocal_barks")
				owner.vocal_barks()
			if("compliance_notifs")
				owner.toggle_compliance_notifs()
			if("skillcap_notifs")
				owner.toggle_skillcap_notifs()
			if("autopunctuation")
				owner.toggle_autopunctuation()
			if("deadchat")
				owner.toggle_deadchat()
			if("legacy_craft")
				owner.toggle_legacycraft()
			if("roleplay_ads")
				owner.toggle_roleplay_ads()
			if("lobby_music")
				owner.toggle_lobby_music()
			if("hear_instruments")
				owner.prefs.toggles ^= SOUND_INSTRUMENTS
				owner.prefs.save_preferences()
				for(var/datum/looping_sound/persistent_loop in GLOB.persistent_sound_loops)
					owner.update_persistent_sound_loop(persistent_loop)
				owner.update_sounds()
				owner.sync_instrument_audio_toggle()
			if("animal_emotes")
				owner.mute_animal_emotes()
			if("erp_panel")
				owner.toggle_ERP()
			if("erp_visuals")
				owner.toggle_ERP_visuals()
			if("chastity")
				owner.toggle_Chastity()
			if("permanent_binding")
				owner.toggle_Chastity_Hardmode()
			if("extreme_erp")
				owner.toggle_extreme_ERP()
			if("edging")
				owner.toggle_edging()
			if("free_use_default")
				owner.toggle_free_use_default()
			if("facial_branding")
				owner.toggle_facial_brands()
			if("sensitive_branding")
				owner.toggle_sensitive_brands()
			if("pubes")
				owner.toggle_pubes()
			if("pits")
				owner.toggle_pits()
			if("descriptor_color")
				owner.toggle_descriptor_color()
			if("cursed_collars")
				owner.toggle_cursed_collars()
			if("voting_popup")
				owner.toggle_voting_popup()
		SStgui.update_uis(src)
		return TRUE

	if(action == "select")
		var/select_id = params["id"]
		switch(select_id)
			if("hud_colorblind_palette")
				if(!owner.prefs.set_hud_colorblind_palette(params["value"]))
					return FALSE
				owner.prefs.save_preferences()
				owner.refresh_colorblind_hud_palette()
		SStgui.update_uis(src)
		return TRUE

	return FALSE

/client/verb/toggle_fullscreen()
	set name = "ToggleFullscreen"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.toggles ^= TOGGLE_FULLSCREEN
		prefs.save_preferences()
		toggle_fullscreeny(prefs.toggles & TOGGLE_FULLSCREEN)

/client/verb/toggle_screenshake()
	set category = "Options"
	set name = "Toggle Screen Shake"
	set hidden = 1
	if(prefs)
		prefs.shake = !prefs.shake
		prefs.save_preferences()
		if(prefs.shake)
			to_chat(src, "已启用屏幕震动。")
		else
			to_chat(src, "已禁用屏幕震动。")

/client/verb/toggle_redflash()
	set category = "Options"
	set name = "Toggle Anti-Eyestrain"
	set hidden = 1
	if(prefs)
		prefs.no_redflash = !prefs.no_redflash
		prefs.save_preferences()
		if(prefs.no_redflash)
			to_chat(src, "屏幕不再因疼痛或其他事件闪烁红光或白光。")
		else
			to_chat(src, "屏幕现在会因疼痛或其他事件闪烁红光或白光。")
	mob.update_redflash_pref(prefs.no_redflash)

/client/verb/masked_examine()
	set category = "Options"
	set name = "Toggle Masked Examine"
	set hidden = 1
	if(prefs)
		prefs.masked_examine = !prefs.masked_examine
		prefs.save_preferences()
		if(prefs.masked_examine)
			to_chat(src, "蒙面时仍可查看你的角色信息。")
		else
			to_chat(src, "蒙面时不再能查看你的角色信息。")

/client/verb/toggle_topexamine()
	set category = "Options"
	set name = "Toggle Top Examine"
	set hidden = 1
	if(prefs)
		prefs.top_examine = !prefs.top_examine
		prefs.save_preferences()
		to_chat(src, "主要检视文本现在显示于检视区块的[prefs.top_examine ? "顶部" : "底部"]。")

/client/verb/toggle_mouseover_role()
	set category = "Options"
	set name = "Toggle Mouseover Role"
	set hidden = 1
	if(prefs)
		prefs.show_mouseover_role = !prefs.show_mouseover_role
		prefs.save_preferences()
		if(prefs.show_mouseover_role)
			to_chat(src, "鼠标悬停时，玩家姓名下方将显示职业。")
		else
			to_chat(src, "鼠标悬停时，玩家姓名下方不再显示职业。")

/client/verb/nsfw_examine_always()
	set category = "Options"
	set name = "Toggle NSFW Examine"
	set hidden = 1
	if(prefs)
		prefs.nsfw_examine_always = !prefs.nsfw_examine_always
		prefs.save_preferences()
		if(prefs.nsfw_examine_always)
			to_chat(src, "你的角色成人信息将始终可见。")
		else
			to_chat(src, "你的角色成人信息仅在裸体时可见。")

/client/verb/mute_animal_emotes()
	set category = "Options"
	set name = "Toggle Animal Noise Emotes"
	set hidden = 1
	if(prefs)
		prefs.mute_animal_emotes = !prefs.mute_animal_emotes
		prefs.save_preferences()
		if(prefs.mute_animal_emotes)
			to_chat(src, "你不再能听到动物叫声。")
		else
			to_chat(src, "你现在能听到动物叫声。")

/client/verb/autoconsume()
	set category = "Options"
	set name = "Toggle AutoConsume"
	set hidden = 1
	if(prefs)
		prefs.autoconsume = !prefs.autoconsume
		prefs.save_preferences()
		if(prefs.autoconsume)
			to_chat(src, "你现在会连续尝试进食、饮用或喂食。")
		else
			to_chat(src, "你不再会连续尝试进食、饮用或喂食。")

/client/verb/toggle_autowoodcut()
	set category = "Options"
	set name = "Toggle AutoWoodcut"
	set hidden = 1
	if(prefs)
		prefs.autowoodcut = !prefs.autowoodcut
		prefs.save_preferences()
		if(prefs.autowoodcut)
			to_chat(src, "你现在会自动继续伐木。")
		else
			to_chat(src, "你不再会自动继续伐木。")

/client/verb/toggle_autopicking()
	set category = "Options"
	set name = "Toggle AutoPicking"
	set hidden = 1
	if(prefs)
		prefs.autopicking = !prefs.autopicking
		prefs.save_preferences()
		if(prefs.autopicking)
			to_chat(src, "你现在会自动继续挖掘岩壁。")
		else
			to_chat(src, "你不再会自动继续挖掘岩壁。")

/client/verb/toggle_hide_unavailable_emotes()
	set category = "Options"
	set name = "Toggle Hide Unavailable Noises"
	set hidden = 1
	if(prefs)
		prefs.hide_unavailable_emotes = !prefs.hide_unavailable_emotes
		prefs.save_preferences()
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			H.update_tongue_noise_verbs()
		if(prefs.hide_unavailable_emotes)
			to_chat(src, "已隐藏不可用的叫声动作。")
		else
			to_chat(src, "现在显示不可用的叫声动作。")

/client/verb/toggle_ERP() // Alters if other people can use the ERP panel ON you.
	set category = "Options"
	set name = "Toggle ERP Panel"
	set hidden = 1
	if(prefs)
		prefs.sexable = !prefs.sexable
		prefs.save_preferences()
		if(prefs.sexable)
			to_chat(src, "其他人现在可以与你进行成人互动。")
		else
			to_chat(src, "其他人现在无法对你进行成人触碰。")

/client/verb/toggle_ERP_visuals()
	set category = "Options"
	set name = "Toggle ERP Visual Effects"
	set hidden = 1
	if(prefs)
		prefs.erp_visuals = !prefs.erp_visuals
		prefs.save_preferences()
		if(prefs.erp_visuals)
			to_chat(src, "已启用成人角色扮演视觉效果。")
		else
			to_chat(src, "已禁用成人角色扮演视觉效果。")
			var/mob/living/carbon/human/H = mob
			if(istype(H) && H.sexcon)
				H.sexcon.update_pink_screen()

/client/verb/toggle_Chastity() // Alters whether the user can see or interact with any content related to chastity devices, including the devices themselves, actions that target them, and messages related to them. This is intended for users who want to avoid accidentally encountering this content, but still want to be able to use the game without missing out on unrelated features.
	set category = "Options"
	set name = "Toggle Chastity Content"
	set hidden = 1
	if(prefs)
		prefs.chastenable = !prefs.chastenable
		prefs.save_preferences()
		if(prefs.chastenable)
			to_chat(src, "已启用贞操锁内容。")
		else
			if(hascall(src, "modular_handle_chastity_toggle_disable"))
				call(src, "modular_handle_chastity_toggle_disable")()
			to_chat(src, "已禁用贞操锁内容。")

/client/verb/toggle_Chastity_Hardmode()
	set category = "Options"
	set name = "Toggle Permanent Binding"
	set hidden = 1
	
	if(!prefs)
		return
	
	// Enabling hard mode requires confirmation
	if(prefs.chastity_hardmode == CHASTITY_HARDMODE_DISABLED)
		var/confirm = alert(src, 
			"永久贞洁束缚：\n\n\
			• 唯有装置独一无二的钥匙可以将其解锁\n\
			• 钥匙可能遗失、遭窃或被永久摧毁\n\
			• 神明干预也无法释放你\n\
			• 开锁器和工具均会失效\n\
			• 即使公爵的万能钥匙也无能为力\n\
			• 无法强行拆除\n\
			• 在钥匙将你释放之前，你将一直受缚\n\n\
			你是否接受这些永久束缚条款？",
			"永久贞操束缚",
			"我接受束缚",
			"我拒绝")
		
		if(confirm != "我接受束缚")
			to_chat(src, span_notice("你拒绝了永久束缚。"))
			return
		
		prefs.chastity_hardmode = CHASTITY_HARDMODE_ENABLED
		prefs.save_preferences()
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			H.chastity_device?.sync_generated_key_metadata(H, mob)
		to_chat(src, span_boldwarning("你已接受永久束缚的条款。唯有钥匙才能带来自由。"))
		log_game("[key_name(src)] enabled permanent chastity binding.")
		message_admins("[key_name_admin(src)] enabled permanent chastity binding.")
	else
		// Disabling requires the humiliation prayer
		to_chat(src, span_notice("要解除永久束缚，你必须向伊欧拉诵念愚者悔罪祷文。"))
		var/sacred_prayer = "Dear Eora, I embraced this binding in foolish haste because I'm a dullard and I'm sorry, so so so sorry for being such a stupid stupid stupid person and I'm begging you please please please free my loins."
		var/encoded_sacred_prayer = html_encode(sacred_prayer)
		var/prayer_prompt = "逐字诵念下列愚者悔罪祷文：\n\n\"[sacred_prayer]\"\n\n（必须亲手输入——神律禁止复制）"
		// multiline=TRUE so the wrapping textarea is readable; bigmodal=TRUE for a large window that shows the full prompt.
		// disable_paste=TRUE enforces hand-typing; max_length locks out anything longer than the prayer itself.
		var/prayer_attempt = tgui_input_text(src, prayer_prompt, "Prayer of Foolish Repentance", default = "", max_length = length(encoded_sacred_prayer), multiline = TRUE, encode = TRUE, ui_state = GLOB.tgui_always_state, bigmodal = TRUE, disable_paste = TRUE)

		if(!prayer_attempt)
			to_chat(src, span_warning("伊欧拉听不见你的沉默。"))
			return

		// tgui_input_text() html-encodes player input, so compare against the prayer normalized the same way.
		if(prayer_attempt != encoded_sacred_prayer)
			to_chat(src, span_warning("伊欧拉拒绝了你不完整的祷文。你必须逐字照原文诵念。"))
			to_chat(src, span_notice("你输入了：\"[prayer_attempt]\""))
			to_chat(src, span_notice("所需祷文：\"[sacred_prayer]\""))
			log_game("[key_name(src)] failed the humiliation prayer (incorrect text).")
			return

		// They did it! The humiliation is complete
		prefs.chastity_hardmode = CHASTITY_HARDMODE_DISABLED
		prefs.save_preferences()
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			H.chastity_device?.sync_generated_key_metadata(H)
		to_chat(src, span_boldnotice("伊欧拉听到了你可怜的恳求，怜悯了你。永久束缚已被解除。"))
		to_chat(src, span_notice("你已撤销永久束缚。现在可以再次用凡俗手段尝试解锁。"))
		log_game("[key_name(src)] disabled permanent chastity binding via humiliation prayer.")
		message_admins("[key_name_admin(src)] disabled permanent chastity binding by reciting the humiliation prayer.")

/client/verb/toggle_extreme_ERP()// toggles gore, ryona, and other extreme content in the ERP panel. This is separate from the regular ERP toggle for users who want to avoid just the extreme content but are okay with milder stuff.
	set category = "Options"
	set name = "Toggle Extreme ERP Content"
	set hidden = 1
	if(prefs)
		prefs.extreme_erp = !prefs.extreme_erp
		prefs.save_preferences()
		if(prefs.extreme_erp)
			to_chat(src, "成人角色扮演面板中的极端内容已启用。")
		else
			if(hascall(src, "modular_handle_extreme_erp_toggle_disable"))
				call(src, "modular_handle_extreme_erp_toggle_disable")()
			to_chat(src, "成人角色扮演面板中的极端内容已禁用。")

/client/verb/toggle_facial_brands()
	set category = "Options"
	set name = "Toggle Facial Branding"
	set hidden = 1
	if(prefs)
		prefs.facial_brands = !prefs.facial_brands
		prefs.save_preferences()
		if(prefs.facial_brands)
			to_chat(src, "其他人现在可以在你的头部烙印。")
		else
			to_chat(src, "其他人不再可以在你的头部烙印。")

/client/verb/toggle_sensitive_brands()
	set category = "Options"
	set name = "Toggle Sensitive Branding"
	set hidden = 1
	if(prefs)
		prefs.sensitive_brands = !prefs.sensitive_brands
		prefs.save_preferences()
		if(prefs.sensitive_brands)
			to_chat(src, "其他人现在可以在你的生殖器和乳房上烙印。")
		else
			to_chat(src, "其他人不再可以在你的生殖器和乳房上烙印。")

/client/verb/toggle_pubes()
	set category = "Options"
	set name = "Toggle Pubic Hair Descriptors"
	set hidden = 1
	if(prefs)
		prefs.pubes = !prefs.pubes
		prefs.save_preferences()
		if(prefs.pubes)
			to_chat(src, "检视裸露的玩家时，现在显示阴毛描述。")
		else
			to_chat(src, "检视裸露的玩家时，不再显示阴毛描述。")

/client/verb/toggle_pits()
	set category = "Options"
	set name = "Toggle Armpit Hair Descriptors"
	set hidden = 1
	if(prefs)
		prefs.pits = !prefs.pits
		prefs.save_preferences()
		if(prefs.pits)
			to_chat(src, "检视裸露的玩家时，现在显示腋毛描述。")
		else
			to_chat(src, "检视玩家时，不再显示腋毛描述。")

/client/verb/toggle_descriptor_color()
	set category = "Options"
	set name = "Toggle Colored Descriptors"
	set hidden = 1
	if(prefs)
		prefs.descriptor_color = !prefs.descriptor_color
		prefs.save_preferences()
		if(prefs.descriptor_color)
			to_chat(src, "现在显示生殖器与体毛描述的颜色。")
		else
			to_chat(src, "不再显示生殖器与体毛描述的颜色。")

/client/verb/toggle_edging() // Toggles edging content in the ERP panel, for psydonites who clearly can't ENDURE.
	set category = "Options"
	set name = "Toggle Edging Content"
	set hidden = 1
	if(prefs)
		prefs.edging = !prefs.edging
		prefs.save_preferences()
		if(prefs.edging)
			to_chat(src, "你将坚忍承受高潮。")
		else
			to_chat(src, "你不再会坚忍承受高潮。")

/client/verb/toggle_free_use_default()
	set category = "Options"
	set name = "Toggle Free Use Default"
	set hidden = 1
	if(prefs)
		prefs.free_use_default = !prefs.free_use_default
		prefs.save_preferences()
		if(prefs.free_use_default)
			to_chat(src, "你将在开局时默认启用自由使用。")
		else
			to_chat(src, "你不再会在开局时默认启用自由使用。")

/client/verb/toggle_voting_popup()
	set category = "Options"
	set name = "Toggle Voting Popup"
	set hidden = 1
	if(!prefs)
		return

	prefs.voting_popup = !prefs.voting_popup
	prefs.save_preferences()
	if(prefs.voting_popup)
		to_chat(src, "发起投票时将弹出投票界面。")
	else
		to_chat(src, "发起投票时不再弹出投票界面。")

	
/client/verb/toggle_cursed_collars() // Toggles cursed collars. Will drop existing collars if toggled off while wearing one
	set category = "Options"
	set name = "Toggle Cursed Collars"
	set hidden = 1
	if(!prefs)
		return
	prefs.cursed_collarable = !prefs.cursed_collarable
	prefs.save_preferences()
	if(prefs.cursed_collarable)
		to_chat(src, "你现在可以被戴上项圈。")
		return
	to_chat(src, "你不再可以被戴上项圈。")
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/human_user = usr
	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = human_user.wear_neck
	if(!istype(collar))
		return
	collar.dropped(human_user)

/client/verb/toggle_compliance_notifs() // The messages need to be on-by-default while this is in its early stages.
	set category = "Options"
	set name = "Toggle Compliance Notifs"
	set hidden = 1
	if(prefs)
		prefs.compliance_notifs = !prefs.compliance_notifs
		prefs.save_preferences()
		if(prefs.compliance_notifs)
			to_chat(src, "启用或禁用顺从模式时，你会收到聊天通知。")
		else
			to_chat(src, "切换顺从模式时，你不再会收到聊天通知。")

/client/verb/toggle_skillcap_notifs()
	set category = "Options"
	set name = "Toggle Skillcap Notifs"
	set hidden = 1
	if(prefs)
		prefs.skillcap_notifs = !prefs.skillcap_notifs
		prefs.save_preferences()
		if(prefs.skillcap_notifs)
			to_chat(src, "角色达到某项技能的经验上限时，你会收到通知。")
		else
			to_chat(src, "角色达到某项技能的经验上限时，你不再会收到聊天通知。")

/client/verb/toggle_examine_blocks()
	set category = "Options"
	set name = "Toggle Examine Blocks"
	set hidden = 1
	if(prefs)
		prefs.no_examine_blocks = !prefs.no_examine_blocks
		prefs.save_preferences()
		if(prefs.no_examine_blocks)
			to_chat(src, "检视物品时不再显示边框。")
		else
			to_chat(src, "检视物品时现在显示边框。")

/client/verb/toggle_wildshape_name()
	set category = "Options"
	set name = "Toggle Wildshape Name"
	set hidden = 1
	if(prefs)
		prefs.wildshape_name = !prefs.wildshape_name
		prefs.save_preferences()
		if(prefs.wildshape_name)
			to_chat(src, "德鲁伊进行荒野变形时，将显示角色姓名。")
		else
			to_chat(src, "德鲁伊进行荒野变形时，将隐藏角色姓名，仅显示动物形态。")

/client/verb/toggle_autopunctuation()
	set category = "Options"
	set name = "Toggle Autopunctuation"
	set hidden = 1
	if(prefs)
		prefs.no_autopunctuate = !prefs.no_autopunctuate
		prefs.save_preferences()
		if(prefs.no_autopunctuate)
			to_chat(src, "你的发言不再自动添加标点。")
		else
			to_chat(src, "你的发言现在会自动添加标点。")

/client/verb/toggle_language_fonts()
	set category = "Options"
	set name = "Toggle Language Fonts"
	set hidden = 1
	if(prefs)
		prefs.no_language_fonts = !prefs.no_language_fonts
		prefs.save_preferences()
		if(prefs.no_language_fonts)
			to_chat(src, "不再使用各语言的特殊字体。")
		else
			to_chat(src, "现在使用各语言的特殊字体。")

/client/verb/toggle_language_icon()
	set category = "Options"
	set name = "Toggle Language Icon"
	set hidden = 1
	if(prefs)
		prefs.no_language_icon = !prefs.no_language_icon
		prefs.save_preferences()
		if(prefs.no_language_icon)
			to_chat(src, "不再在语言前显示语言图标。")
		else
			to_chat(src, "现在在语言前显示语言图标。")

/client/verb/toggle_lobby_music()
	set name = "Toggle Lobby Music"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.toggles ^= SOUND_LOBBY
		prefs.save_preferences()
	if(prefs.toggles & SOUND_LOBBY)
		to_chat(src, "你现在能听到大厅音乐。")
		if(isnewplayer(usr))
			playtitlemusic()
	else
		to_chat(src, "你不再能听到大厅音乐。")
		mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)

/client/verb/toggle_roleplay_ads()
	set name = "Roleplay Ads (Toggle)"
	set category = "OOC"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.toggles ^= ROLEPLAY_ADS
		prefs.save_preferences()
	if(prefs.toggles & ROLEPLAY_ADS)
		to_chat(src, "你现在会收到新的角色扮演招募通知。")
	else
		to_chat(src, "你不再会收到新的角色扮演招募通知。")

/client/verb/stop_sounds_rogue()
	set name = "StopSounds"
	set category = "Options"
	set desc = ""
	if(mob)
		SEND_SOUND(mob, sound(null))

/client/verb/cmode_strip()
	set name = "Combat Mode Stripping"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.toggles ^= CMODE_STRIPPING
		prefs.save_preferences()
	to_chat(src, "你将[prefs.toggles & CMODE_STRIPPING ? "可以" : "无法"]在战斗模式下打开脱衣菜单。")

/client/verb/vocal_barks()
	set name = "Hear Vocal Barks"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.hear_barks = !prefs.hear_barks
		prefs.save_preferences()
	to_chat(src, "你将[prefs.hear_barks ? "听到" : "不再听到"]发言音效。")

/client/verb/toggle_xptext() // Whether the user can see the balloon XP pop ups.
	set category = "Options"
	set name = "Toggle XP Text"
	set hidden = 1
	if(prefs)
		prefs.floating_text_toggles ^= XP_TEXT
		prefs.save_preferences()
	to_chat(src, "你将[prefs.floating_text_toggles & XP_TEXT ? "看到" : "不再看到"]经验浮动提示。")

/client/verb/toggle_floatingtext() // Whether the user can see the balloon pop ups at all.
	set category = "Options"
	set name = "Toggle Floating Text"
	set hidden = 1
	if(prefs)
		prefs.floating_text_toggles ^= FLOATING_TEXT
		prefs.save_preferences()
	to_chat(src, "你将[prefs.floating_text_toggles & FLOATING_TEXT ? "看到" : "不再看到"]浮动文本。")

/client/verb/toggle_deadchat() // Whether the user can see DSAY or not.
	set name = "Show/Hide Deadchat"
	set category = "Options"
	set desc ="切换是否显示亡者聊天"
	set hidden = 1

	if(prefs)
		prefs.chat_toggles ^= CHAT_DSAY
		prefs.save_preferences()
	to_chat(src, "你将[(prefs.chat_toggles & CHAT_DSAY) ? "看到" : "不再看到"]死者频道。")
	if(holder)
		SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Deadchat Visibility", "[prefs.chat_toggles & CHAT_DSAY ? "Enabled" : "Disabled"]"))

/*
//toggles
/datum/verbs/menu/Settings/Ghost/chatterbox
	name = "Chat Box Spam"

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()
	set name = "Show/Hide GhostEars"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTEARS
	to_chat(usr, "作为幽灵，你将[(usr.client.prefs.chat_toggles & CHAT_GHOSTEARS) ? "看到世界中的所有发言" : "仅看到附近角色的发言"]。")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Ears", "[usr.client.prefs.chat_toggles & CHAT_GHOSTEARS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_ears/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTEARS

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_sight)()
	set name = "Show/Hide GhostSight"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTSIGHT
	to_chat(usr, "作为幽灵，你将[(usr.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) ? "看到世界中的所有动作" : "仅看到附近角色的动作"]。")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Sight", "[usr.client.prefs.chat_toggles & CHAT_GHOSTSIGHT ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_sight/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTSIGHT

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_whispers)()
	set name = "Show/Hide GhostWhispers"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTWHISPER
	to_chat(usr, "作为幽灵，你将[(usr.client.prefs.chat_toggles & CHAT_GHOSTWHISPER) ? "看到世界中的所有耳语" : "仅看到附近角色的耳语"]。")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Whispers", "[usr.client.prefs.chat_toggles & CHAT_GHOSTWHISPER ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_whispers/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTWHISPER

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_radio)()
	set name = "Show/Hide GhostRadio"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTRADIO
	to_chat(usr, "作为幽灵，你将[(usr.client.prefs.chat_toggles & CHAT_GHOSTRADIO) ? "看到无线电通讯" : "不再看到无线电通讯"]。")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Radio", "[usr.client.prefs.chat_toggles & CHAT_GHOSTRADIO ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc! //social experiment, increase the generation whenever you copypaste this shamelessly GENERATION 1
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_radio/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTRADIO

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_pda)()
	set name = "Show/Hide GhostPDA"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTPDA
	to_chat(usr, "作为幽灵，你将[(usr.client.prefs.chat_toggles & CHAT_GHOSTPDA) ? "看到世界中的所有PDA消息" : "仅看到附近角色的PDA消息"]。")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost PDA", "[usr.client.prefs.chat_toggles & CHAT_GHOSTPDA ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_pda/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTPDA

/datum/verbs/menu/Settings/Ghost/chatterbox/Events
	name = "Events"

//please be aware that the following two verbs have inverted stat output, so that "Toggle Deathrattle|1" still means you activated it
TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox/Events, toggle_deathrattle)()
	set name = "Toggle Deathrattle"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= DISABLE_DEATHRATTLE
	usr.client.prefs.save_preferences()
	to_chat(usr, "有智慧生物死亡时，你将[(usr.client.prefs.toggles & DISABLE_DEATHRATTLE) ? "不再收到" : "收到"]消息。")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Deathrattle", "[!(usr.client.prefs.toggles & DISABLE_DEATHRATTLE) ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, maybe you should spend some time reading the comments.
/datum/verbs/menu/Settings/Ghost/chatterbox/Events/toggle_deathrattle/Get_checked(client/C)
	return !(C.prefs.toggles & DISABLE_DEATHRATTLE)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox/Events, toggle_arrivalrattle)()
	set name = "Toggle Arrivalrattle"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= DISABLE_ARRIVALRATTLE
	to_chat(usr, "有玩家加入时，你将[(usr.client.prefs.toggles & DISABLE_ARRIVALRATTLE) ? "不再收到" : "收到"]消息。")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Arrivalrattle", "[!(usr.client.prefs.toggles & DISABLE_ARRIVALRATTLE) ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, maybe you should rethink where your life went so wrong.
/datum/verbs/menu/Settings/Ghost/chatterbox/Events/toggle_arrivalrattle/Get_checked(client/C)
	return !(C.prefs.toggles & DISABLE_ARRIVALRATTLE)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost, togglemidroundantag)()
	set name = "Toggle Midround Antagonist"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= MIDROUND_ANTAG
	usr.client.prefs.save_preferences()
	to_chat(usr, "你将[(usr.client.prefs.toggles & MIDROUND_ANTAG) ? "被纳入" : "不再被纳入"]轮次中途反派角色的候选名单。")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Midround Antag", "[usr.client.prefs.toggles & MIDROUND_ANTAG ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/togglemidroundantag/Get_checked(client/C)
	return C.prefs.toggles & MIDROUND_ANTAG*/
/*
TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggletitlemusic)()
	set name = "LobbyMusic"
	set category = "Options"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_LOBBY
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_LOBBY)
		to_chat(usr, "你现在能听到大厅音乐。")
		if(isnewplayer(usr))
			usr.client.playtitlemusic()
	else
		to_chat(usr, "你不再能听到大厅音乐。")
		usr.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Lobby Music", "[usr.client.prefs.toggles & SOUND_LOBBY ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggletitlemusic/Get_checked(client/C)
	return C.prefs.toggles & SOUND_LOBBY


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, togglemidis)()
	set name = "Hear/Silence Midis"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_MIDI
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_MIDI)
		to_chat(usr, "你现在能听到管理员上传的声音。")
	else
		to_chat(usr, "你不再能听到管理员上传的声音。")
		usr.stop_sound_channel(CHANNEL_ADMIN)
		var/client/C = usr.client
		if(C && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
			C.chatOutput.stopMusic()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Hearing Midis", "[usr.client.prefs.toggles & SOUND_MIDI ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/togglemidis/Get_checked(client/C)
	return C.prefs.toggles & SOUND_MIDI


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_instruments)()
	set name = "Hear/Silence Instruments"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_INSTRUMENTS
	usr.client.prefs.save_preferences()
	usr.client.update_sounds()
	usr.client.sync_instrument_audio_toggle()
	if(usr.client.prefs.toggles & SOUND_INSTRUMENTS)
		to_chat(usr, "你现在能听到他人演奏乐器。")
	else
		to_chat(usr, "你不再能听到乐器演奏。")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Instruments", "[usr.client.prefs.toggles & SOUND_INSTRUMENTS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggle_instruments/Get_checked(client/C)
	return C.prefs.toggles & SOUND_INSTRUMENTS


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, Toggle_Soundscape)()
	set name = "Hear/Silence Ambience"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_AMBIENCE
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_AMBIENCE)
		to_chat(usr, "你现在能听到环境音。")
	else
		to_chat(usr, "你不再能听到环境音。")
		usr.stop_sound_channel(CHANNEL_AMBIENCE)
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ambience", "[usr.client.prefs.toggles & SOUND_AMBIENCE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/Toggle_Soundscape/Get_checked(client/C)
	return C.prefs.toggles & SOUND_AMBIENCE


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_ship_ambience)()
	set name = "Hear/Silence Ship Ambience"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_SHIP_AMBIENCE
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_SHIP_AMBIENCE)
		to_chat(usr, "你现在能听到船只环境音。")
	else
		to_chat(usr, "你不再能听到船只环境音。")
		usr.client.ambience_playing = 0
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ship Ambience", "[usr.client.prefs.toggles & SOUND_SHIP_AMBIENCE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, I bet you read this comment expecting to see the same thing :^)
/datum/verbs/menu/Settings/Sound/toggle_ship_ambience/Get_checked(client/C)
	return C.prefs.toggles & SOUND_SHIP_AMBIENCE


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_announcement_sound)()
	set name = "Hear/Silence Announcements"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_ANNOUNCEMENTS
	to_chat(usr, "你将[(usr.client.prefs.toggles & SOUND_ANNOUNCEMENTS) ? "听到公告声音" : "不再听到公告声音"]。")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Announcement Sound", "[usr.client.prefs.toggles & SOUND_ANNOUNCEMENTS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggle_announcement_sound/Get_checked(client/C)
	return C.prefs.toggles & SOUND_ANNOUNCEMENTS


/datum/verbs/menu/Settings/Sound/verb/stop_client_sounds()
	set name = "Stop Sounds"
	set category = "Options"
	set desc = ""
	SEND_SOUND(usr, sound(null))
	var/client/C = usr.client
	if(C && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
		C.chatOutput.stopMusic()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Stop Self Sounds")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_ooc)()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_OOC
	usr.client.prefs.save_preferences()
	to_chat(usr, "你将[(usr.client.prefs.chat_toggles & CHAT_OOC) ? "看到" : "不再看到"]OOC频道消息。")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Seeing OOC", "[usr.client.prefs.chat_toggles & CHAT_OOC ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/listen_ooc/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_OOC

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_bank_card)()
	set name = "Show/Hide Income Updates"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_BANKCARD
	usr.client.prefs.save_preferences()
	to_chat(usr, "收到工资时，你将[(usr.client.prefs.chat_toggles & CHAT_BANKCARD) ? "收到" : "不再收到"]通知。")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Income Notifications", "[(usr.client.prefs.chat_toggles & CHAT_BANKCARD) ? "Enabled" : "Disabled"]"))
/datum/verbs/menu/Settings/listen_bank_card/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_BANKCARD*/


GLOBAL_LIST_INIT(ghost_forms, sortList(list("ghost","ghostking","ghostian2","skeleghost","ghost_red","ghost_black", \
							"ghost_blue","ghost_yellow","ghost_green","ghost_pink", \
							"ghost_cyan","ghost_dblue","ghost_dred","ghost_dgreen", \
							"ghost_dcyan","ghost_grey","ghost_dyellow","ghost_dpink", "ghost_purpleswirl","ghost_funkypurp","ghost_pinksherbert","ghost_blazeit",\
							"ghost_mellow","ghost_rainbow","ghost_camo","ghost_fire", "catghost")))
/client/proc/pick_form()
	if(!is_content_unlocked())
		alert("此设置仅供 BYOND 高级会员账号使用。")
		return
	var/new_form = input(src, "感谢支持 BYOND——请选择幽灵外形：","Thanks for supporting BYOND",null) as null|anything in GLOB.ghost_forms
	if(new_form)
		prefs.ghost_form = new_form
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_icon(new_form)

GLOBAL_LIST_INIT(ghost_orbits, list(GHOST_ORBIT_CIRCLE,GHOST_ORBIT_TRIANGLE,GHOST_ORBIT_SQUARE,GHOST_ORBIT_HEXAGON,GHOST_ORBIT_PENTAGON))

/client/proc/pick_ghost_orbit()
	if(!is_content_unlocked())
		alert("此设置仅供 BYOND 高级会员账号使用。")
		return
	var/new_orbit = input(src, "感谢支持 BYOND——请选择幽灵环绕轨迹：","Thanks for supporting BYOND",null) as null|anything in GLOB.ghost_orbits
	if(new_orbit)
		prefs.ghost_orbit = new_orbit
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.ghost_orbit = new_orbit

/client/proc/pick_ghost_accs()
	var/new_ghost_accs = alert("你希望幽灵尽可能显示完整配饰，隐藏配饰但保留方向外观，还是忽略方向并使用默认外观？",,"full accessories", "only directional sprites", "default sprites")
	if(new_ghost_accs)
		switch(new_ghost_accs)
			if("full accessories")
				prefs.ghost_accs = GHOST_ACCS_FULL
			if("only directional sprites")
				prefs.ghost_accs = GHOST_ACCS_DIR
			if("default sprites")
				prefs.ghost_accs = GHOST_ACCS_NONE
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_icon()

/client/verb/pick_ghost_customization()
	set name = "Ghost Customization"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	if(is_content_unlocked())
		switch(alert("你想更改幽灵外形、环绕轨迹还是配饰设置？",,"Ghost Form","Ghost Orbit","Ghost Accessories"))
			if("Ghost Form")
				pick_form()
			if("Ghost Orbit")
				pick_ghost_orbit()
			if("Ghost Accessories")
				pick_ghost_accs()
	else
		pick_ghost_accs()

/client/verb/pick_ghost_others()
	set name = "Ghosts of Others"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	var/new_ghost_others = alert("其他玩家的幽灵应按其个人设置显示、使用其默认外观，还是始终显示为默认白色幽灵？",,"Their Setting", "Default Sprites", "White Ghost")
	if(new_ghost_others)
		switch(new_ghost_others)
			if("Their Setting")
				prefs.ghost_others = GHOST_OTHERS_THEIR_SETTING
			if("Default Sprites")
				prefs.ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
			if("White Ghost")
				prefs.ghost_others = GHOST_OTHERS_SIMPLE
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_sight()

/client/verb/toggle_intent_style()
	set name = "Toggle Intent Selection Style"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.toggles ^= INTENT_STYLE
	to_chat(src, "[(prefs.toggles & INTENT_STYLE) ? "点击意图按钮可直接选中对应意图。" : "点击意图按钮将按顺时针顺序切换意图。"]")
	prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Intent Selection", "[prefs.toggles & INTENT_STYLE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_hud_pref()
	set name = "Toggle Ghost HUD"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.ghost_hud = !prefs.ghost_hud
	to_chat(src, "幽灵HUD现在[prefs.ghost_hud ? "显示" : "隐藏"]。")
	prefs.save_preferences()
	if(isobserver(mob))
		mob.hud_used.show_hud()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost HUD", "[prefs.ghost_hud ? "Enabled" : "Disabled"]"))

/client/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = ""
	set category = "Preferences"
	set hidden = 1
	if(!holder)
		return
	prefs.inquisitive_ghost = !prefs.inquisitive_ghost
	prefs.save_preferences()
	if(prefs.inquisitive_ghost)
		to_chat(src, span_notice("现在会自动查看你点击的所有事物。"))
	else
		to_chat(src, span_notice("不再自动查看你点击的事物。"))
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Inquisitiveness", "[prefs.inquisitive_ghost ? "Enabled" : "Disabled"]"))

//Admin Preferences
/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Prefs - Admin"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Adminhelp Sound", "[prefs.toggles & SOUND_ADMINHELP ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggledeathalarmsound()
	set name = "Hear/Silence Death Alarms"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	prefs.toggles ^= SOUND_DEATH_ALARM
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_DEATH_ALARM) ? "now" : "no longer"] hear a sound when deaths appear in the admin log.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Death Alarm Sound", "[prefs.toggles & SOUND_DEATH_ALARM ? "Enabled" : "Disabled"]"))

/client/proc/toggleannouncelogin()
	set name = "Do/Don't Announce Login"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	prefs.toggles ^= ANNOUNCE_LOGIN
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & ANNOUNCE_LOGIN) ? "now" : "no longer"] have an announcement to other admins when you login.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Login Announcement", "[prefs.toggles & ANNOUNCE_LOGIN ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_hear_radio()
	set name = "Show/Hide Radio Chatter"
	set category = "Prefs - Admin"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.chat_toggles & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from nearby radios or speakers")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Radio Chatter", "[prefs.chat_toggles & CHAT_RADIO ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Visibility", "[prefs.chat_toggles & CHAT_PRAYER ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_prayer_sound()
	set name = "Toggle Prayer Sounds"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	prefs.toggles ^= SOUND_PRAYERS
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_PRAYERS) ? "now" : "no longer"] hear a sound when prayers arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Sounds", "[usr.client.prefs.toggles & SOUND_PRAYERS ? "Enabled" : "Disabled"]"))

/client/proc/colorasay()
	set name = "Set Asay Color"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	if(!CONFIG_GET(flag/allow_admin_asaycolor))
		to_chat(src, "Custom Asay color is currently disabled by the server.")
		return
	var/new_asaycolor = input(src, "Please select your ASAY color.", "ASAY color", prefs.asaycolor) as color|null
	if(new_asaycolor)
		prefs.asaycolor = sanitize_ooccolor(new_asaycolor)
		prefs.save_preferences()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set ASAY Color")
	return

/client/proc/resetasaycolor()
	set name = "Reset your Admin Say Color"
	set desc = ""
	set category = "Prefs - Admin"
	if(!holder)
		return
	if(!CONFIG_GET(flag/allow_admin_asaycolor))
		to_chat(src, "Custom Asay color is currently disabled by the server.")
		return
	prefs.asaycolor = initial(prefs.asaycolor)
	prefs.save_preferences()

/client/proc/hearallasghost()
	set category = "Prefs - Admin"
	set name = "HearAllAsAdmin"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.chat_toggles ^= CHAT_GHOSTEARS
//	prefs.chat_toggles ^= CHAT_GHOSTSIGHT
	prefs.chat_toggles ^= CHAT_GHOSTWHISPER
	prefs.save_preferences()
	if(prefs.chat_toggles & CHAT_GHOSTEARS)
		to_chat(src, span_notice("I will hear all now."))
	else
		to_chat(src, span_info("I will hear like a mortal."))

/client/proc/hearglobalLOOC()
	set category = "Prefs - Admin"
	set name = "Show/Hide Global LOOC"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.admin_chat_toggles ^= CHAT_ADMINLOOC
	prefs.save_preferences()
	if(prefs.admin_chat_toggles & CHAT_ADMINLOOC)
		to_chat(src, span_notice("I will now hear all LOOC chatter."))
	else
		to_chat(src, span_info("I will now only hear LOOC chatter around me."))

/client/proc/togglespawnmessages()
	set category = "Prefs - Admin"
	set name = "Show/Hide Spawn Logs"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.admin_chat_toggles ^= CHAT_ADMINSPAWN
	prefs.save_preferences()
	to_chat(src, "You will [prefs.admin_chat_toggles & CHAT_ADMINSPAWN ? "see" : "not see any"] spawn logs.")
