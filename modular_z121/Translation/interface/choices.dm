/proc/get_update_choice_display(value)
	var/static/list/weapons = list(
		"Dual Shamshirs" = "双持沙姆希尔弯刀",
		"Shalal sabre & Shield" = "沙拉尔弯刀与盾牌",
		"Spear" = "长矛",
		"Dory & Shield" = "多利短矛与盾牌",
		"Steel Mace" = "钢钉头锤",
		"Steel Warhammer & Shield" = "钢战锤与盾牌",
		"Grand Mace" = "巨型钉头锤",
		"Battle Axe" = "战斧",
		"Steel Greataxe" = "钢巨斧"
	)
	if(value in weapons)
		return weapons[value]
	if(value == "Arbalest")
		return "重弩手"
	if(value == "Fusilier")
		return "燧枪手"
	var/static/list/labels = list("None" = "无", "Elvish Saber" = "精灵军刀", "Elvish Dagger" = "精灵匕首", "Holy See" = "格伦泽尔霍夫特教廷", "Orthodoxy" = "奥塔瓦正教会", "Misdeed" = "轻罪")
	return labels[value] || value

/proc/input_translation_choice(mob/user, prompt, title, list/values, list/display_names)
	var/list/options = list()
	for(var/value in values)
		var/label = display_names ? (display_names[value] || value) : get_update_choice_display(value)
		if(label in options)
			label = "[label] ([value])"
		options[label] = value
	var/choice = tgui_input_list(user, prompt, title, options)
	return choice ? options[choice] : null
