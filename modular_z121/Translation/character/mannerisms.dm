/proc/get_mannerism_display_name(mannerism)
	var/static/list/display_names = list(
		"No mannerism" = "无特殊措辞习惯",
		"Nervous Stutter" = "紧张口吃",
		"Stutter" = "口吃",
		"Heavy Stutter" = "严重口吃",
		"Lisp" = "咬字不清",
		"Hesitant" = "吞吞吐吐",
		"Complex Stutter" = "复合口吃"
	)
	return display_names[mannerism] || mannerism
/proc/input_mannerism_display(mob/user, list/mannerisms)
	var/list/choices = list()
	for(var/mannerism in mannerisms)
		var/label = get_mannerism_display_name(mannerism)
		if(label in choices)
			label = "[label] ([mannerism])"
		choices[label] = mannerism
	var/selected = tgui_input_list(user, "选择你角色的说话习惯：", "角色偏好", choices)
	return selected ? choices[selected] : null
