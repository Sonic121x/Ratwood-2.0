/proc/get_origin_display_name(origin_title)
	for(var/origin_type as anything in GLOB.origins)
		var/datum/origin/origin = GLOB.origins[origin_type]
		if(origin.origin_title == origin_title)
			return origin.name || origin_title
	return origin_title

/proc/get_preferences_label_display(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		"Identity" = "身份", "Origin" = "出身", "Customization" = "个性定制", "Character Settings" = "角色设置", "Voice" = "声音", "Body" = "身体", "Flavor Text" = "角色描述",
		"Name" = "姓名", "Nickname" = "昵称", "Nickname Color" = "昵称颜色", "Pronouns" = "代词", "Age" = "年龄", "Race" = "种族", "Race Title" = "种族称谓", "Race Bonus" = "种族加成",
		"Body Type" = "体型", "Dominance" = "惯用手", "Family" = "家族", "Preferred Spouse" = "期望配偶", "Preferred Parent" = "期望父母", "Preferred Gender" = "期望性别", "Restrict Species" = "种族限制",
		"Faith" = "信仰", "Patron" = "守护神", "Language" = "语言", "Food Preferences" = "饮食偏好", "Loadout Menu" = "开局装备", "Presets" = "预设", "Statpack" = "属性组合", "Primary Virtue" = "首要美德", "Second Virtue" = "第二美德",
		"Change" = "更改", "None" = "无", "INVALID" = "无效", "Any Gender" = "不限性别", "Default" = "默认", "Select" = "选择", "Add Quirk" = "添加怪癖", "Add Vice" = "添加恶习",
		"\[Remove\]" = "\[移除\]", "\[Configure\]" = "\[配置\]", "\[Clear\]" = "\[清除\]",
		"Unrevivable" = "不可复活", "Combat Music" = "战斗音乐", "Map Preferences" = "地图偏好", "No Preference" = "无偏好", "Familiar Preferences" = "使魔偏好", "Gnoll Preferences" = "豺狼人偏好",
		"Voice Pack" = "语音包", "Voice Color" = "声音颜色", "Voice Pitch" = "音调", "Accent" = "口音", "Speech Mannerism" = "说话习惯", "Vocal Bark" = "发声效果", "<b>Preview Bark</b>" = "<b>试听发声</b>",
		"Vocal Bark Speed" = "发声速度", "Vocal Bark Pitch" = "发声音调", "Vocal Bark Variance" = "发声变化", "Vocal Bark Volume" = "发声音量",
		"Mutant Skintone" = "特殊肤色", "Sprite Scale" = "外观比例", "Mutant Color #1" = "特殊颜色一", "Mutant Color #2" = "特殊颜色二", "Mutant Color #3" = "特殊颜色三",
		"Taur Body Type" = "半人兽体型", "Taur Color" = "半人兽颜色", "Taur Markings" = "半人兽花纹", "Taur Tertiary" = "半人兽第三颜色", "Features" = "身体特征", "Markings" = "花纹", "Descriptors" = "体貌描述", "Update feature colors with change" = "更改时同步特征颜色",
		"NSFW Flavortext" = "成人外貌描述", "ERP Preferences" = "成人角色扮演偏好", "Headshot" = "头像", "Rumours & Noble Gossip" = "传闻与贵族秘闻", "Set Rumours" = "设置传闻", "Set Gossip" = "设置秘闻", "<i>Preview</i>" = "<i>预览</i>",
		"Song" = "歌曲", "Change URL" = "更改链接", "Title" = "标题", "Artist" = "艺术家", "OOC Extra" = "场外附加信息", "NSFW OOC Extra" = "成人场外附加信息", "Image Gallery" = "图片集", "Nsfw Image Gallery" = "成人图片集", "Add" = "添加", "Clear Gallery" = "清空图片集", "Clear Nsfw Gallery" = "清空成人图片集", "<b>Preview Examine</b>" = "<b>预览打量信息</b>"
	)
	return labels[value] || get_character_identity_display(value)

/proc/get_character_identity_display(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		AGE_ADULT = "壮年", AGE_MIDDLEAGED = "中年", AGE_OLD = "老年", AGE_IMMORTAL = "永生",
		HE_HIM = "他", SHE_HER = "她", THEY_THEM = "TA（男装）", THEY_THEM_F = "TA（女装）", IT_ITS = "它", HE_HIM_F = "他（女装）", SHE_HER_M = "她（男装）",
		VOICE_TYPE_MASC = "男声", VOICE_TYPE_FEM = "女声", VOICE_TYPE_ANDR = "中性声音"
	)
	return labels[value] || value

/proc/input_character_identity_choice(mob/user, prompt, title, list/values)
	var/list/options = list()
	for(var/value in values)
		var/label = get_character_identity_display(value)
		if(label in options)
			label = "[label] ([value])"
		options[label] = value
	var/choice = tgui_input_list(user, prompt, title, options)
	return isnull(choice) ? null : options[choice]
