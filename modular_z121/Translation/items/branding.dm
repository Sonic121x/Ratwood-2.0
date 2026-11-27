/proc/input_branding_zone(mob/user, prompt, list/zones, timeout)
	var/list/options = list()
	var/list/buttons = list()
	for(var/zone in zones)
		var/label = GLOB.branding_zone_display_names[zone] || zone
		if(label in options)
			label = "[label] ([zone])"
		options[label] = zone
		buttons += label
	var/choice = tgui_alert(user, prompt, "请于[DisplayTimeText(timeout)]内选择！", buttons, timeout)
	return choice ? options[choice] : null
