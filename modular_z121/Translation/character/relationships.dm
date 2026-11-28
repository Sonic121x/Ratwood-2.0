/proc/get_family_section_display(section)
	var/static/list/sections = list("Character" = "我的招募", "Matchmaking" = "匹配设置", "Board" = "招募公告", "Relationships" = "已建立的关系")
	return sections[section] || section

/proc/get_family_relation_display(value)
	if(!istext(value))
		return value
	var/static/list/names = list(
		"spouse" = "配偶", "sibling" = "兄弟姐妹", "parent" = "父母", "offspring" = "子女",
		"lover" = "恋人", "cousin" = "堂表亲", "friend" = "朋友",
		"son" = "儿子", "daughter" = "女儿", "child" = "孩子", "brother" = "兄弟", "sister" = "姐妹",
		"husband" = "丈夫", "wife" = "妻子", "distant relative" = "远亲",
		"father" = "父亲", "mother" = "母亲", "progeny" = "子女", "adoptive progeny" = "养子女",
		"parents sibling" = "父母的兄弟姐妹", "in law" = "姻亲"
	)
	return names[lowertext(value)] || value

/proc/format_family_relations(list/relations)
	var/list/labels = list()
	for(var/relation in relations)
		labels += get_family_relation_display(relation)
	return jointext(labels, "、")

/proc/get_family_gender_display(value)
	switch(value)
		if(ANY_GENDER)
			return "不限性别"
		if(SAME_GENDER)
			return "同性"
		if(DIFFERENT_GENDER)
			return "异性"
	return value

/datum/family_board_menu/proc/select_family_options(mob/user, list/values, list/defaults, species = FALSE)
	var/list/labels = list()
	var/list/originals = list()
	var/list/checked = list()
	for(var/value in values)
		var/label = species ? get_species_display_name(value) : get_family_relation_display(value)
		while(label in originals)
			label = "[label]（[value]）"
		labels += label
		originals[label] = value
		if(value in defaults)
			checked += label
	var/list/selected = tgui_input_checkboxes(user,
		species ? "选择种族" : "希望结成哪些关系？", species ? "种族偏好" : "人际关系", labels,
		min_checked = species ? 0 : 1, max_checked = species ? 200 : 6,
		default_checked = checked, strict_modern = TRUE,
		window_width = species ? 400 : 300, window_height = species ? 600 : 350)
	if(isnull(selected))
		return null
	var/list/result = list()
	for(var/label in selected)
		result += originals[label]
	return result

/datum/family_board_menu/proc/select_family_option(mob/user, list/values, choosing_gender = FALSE)
	var/list/options = list()
	for(var/value in values)
		var/label = choosing_gender ? get_family_gender_display(value) : get_family_relation_display(value)
		while(label in options)
			label = "[label]（[value]）"
		options[label] = value
	var/choice = tgui_input_list(user, choosing_gender ? "希望匹配哪种性别？" : "要以什么身份回应？", "人际关系", options, choosing_gender ? get_family_gender_display(prefs.gender_choice) : null)
	return choice ? options[choice] : null
