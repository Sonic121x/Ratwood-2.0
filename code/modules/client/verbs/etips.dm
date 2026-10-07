/client/verb/toggle_tips()
	set name = "切换查看提示"
	set desc = ""
	set category = "偏好设置"
	set hidden = 1
	if(!holder)
		return
	prefs.enable_tips = !prefs.enable_tips
	prefs.save_preferences()
	to_chat(usr, span_danger("查看提示已[prefs.enable_tips ? "启用" : "禁用"]。"))

/client/verb/change_tip_delay()
	set name = "设置查看提示延迟"
	set desc = ""
	set category = "偏好设置"
	set hidden = 1
	if(!holder)
		return
	var/indelay = stripped_input(usr, "输入提示延迟，单位为毫秒（默认：500）", "输入提示延迟", "", 10)
	indelay = text2num(indelay)
	if(usr)//is this what you mean?
		prefs.tip_delay = indelay
		prefs.save_preferences()
		to_chat(usr, span_danger("提示延迟已设为 [indelay] 毫秒。"))
