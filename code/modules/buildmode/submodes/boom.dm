/datum/buildmode_mode/boom
	key = "boom"

	var/devastation = -1
	var/heavy = -1
	var/light = -1
	var/flash = -1
	var/flames = -1

/datum/buildmode_mode/boom/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("点击物体 = 引发爆炸"))
	to_chat(c, span_notice("提示：使用“配置/发射补给舱”指令可让爆炸以角色内的方式发生（例如让巡航导弹从天而降，在点击处爆炸！）"))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/boom/change_settings(client/c)
	devastation = input(c, "毁灭范围，-1 表示无", text("输入")) as num|null
	if(devastation == null)
		devastation = -1
	heavy = input(c, "重度冲击范围，-1 表示无", text("输入")) as num|null
	if(heavy == null)
		heavy = -1
	light = input(c, "轻度冲击范围，-1 表示无", text("输入")) as num|null
	if(light == null)
		light = -1
	flash = input(c, "闪光范围，-1 表示无", text("输入")) as num|null
	if(flash == null)
		flash = -1
	flames = input(c, "火焰范围，-1 表示无", text("输入")) as num|null
	if(flames == null)
		flames = -1

/datum/buildmode_mode/boom/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")

	if(left_click)
		explosion(object, devastation, heavy, light, flash, FALSE, TRUE, flames)
		log_admin("Build Mode: [key_name(c)] caused an explosion(dev=[devastation], hvy=[heavy], lgt=[light], flash=[flash], flames=[flames]) at [AREACOORD(object)]")
