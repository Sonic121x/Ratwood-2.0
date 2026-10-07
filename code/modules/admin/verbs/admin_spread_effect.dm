/client/proc/admin_spread_effect()
	set name = "扩散效果"
	set category = "-GameMaster-"

	if(!check_rights(R_ADMIN))
		return

	var/list/effect_types = typesof(/datum/effect_system/smoke_spread)

	var/list/effect_names = list()
	for(var/type in effect_types)
		effect_names[type] = "[type]"

	var/selected_type = input("选择要扩散的效果：", "选择效果") as null|anything in effect_names
	if(!selected_type)
		return

	var/new_radius = input("输入效果半径（1-10）：", "设置效果半径", 2) as num|null
	if(!new_radius)
		return
	new_radius = clamp(new_radius, 1, 10)

	var/datum/effect_system/smoke_spread/S = new selected_type
	var/turf/T = usr.loc
	S.set_up(new_radius, T)
	S.start()

	to_chat(usr, span_notice("已在 ([T.x], [T.y], [T.z]) 施放 [selected_type] 效果，半径为 [new_radius]。"))
//can be expanded the other effects later
