GLOBAL_DATUM_INIT(rogue_info, /datum/rogue_info, new)

/datum/rogue_info

	var/list/role_visibility = list(
		"blacksmith" = FALSE,
		"artificer"  = FALSE,
		"steward"    = FALSE,
		"duke"       = FALSE,
		"apothecary" = FALSE,
		"church"     = FALSE,
		"fisher"     = FALSE,
		"university" = FALSE,
		"innkeeper"  = FALSE,
		"tailor"     = FALSE,
		"bathhouse"  = FALSE,
		"merchant"   = FALSE,
		"freeform1"  = FALSE,
		"freeform2"  = FALSE
	)

	var/list/role_data = list(
		"blacksmith" = list(
			"desc" = "公会铁匠擅长锻造护甲、武器、工具及其他金属物品，也能修理装备。",
			"note" = "暂无自定义备注。"
		),
		"artificer" = list(
			"desc" = "公会匠师精通魔法制造与机械，能制作弩、齿轮等物品。",
			"note" = "暂无自定义备注。"
		),
		"steward" = list(
			"desc" = "宫廷总管管理库存、发放冒险者契约，并为要塞招募人员，也可能收购贵重物品。",
			"note" = "暂无自定义备注。"
		),
		"duke" = list(
			"desc" = "我们光荣公国的公爵目前正在受理请愿。",
			"note" = "暂无自定义备注。"
		),
		"apothecary" = list(
			"desc" = "精通草药学与炼金术，能制作药物、药膏和治疗酊剂。可在此治疗伤口、复活死者。",
			"note" = "暂无自定义备注。"
		),
		"church" = list(
			"desc" = "城镇的精神中心，提供指引、葬礼、治疗与复活服务。别错过弥撒，异端。",
			"note" = "暂无自定义备注。"
		),
		"fisher" = list(
			"desc" = "主要的水产供应者，在东侧码头劳作，为城镇提供鲜鱼。",
			"note" = "暂无自定义备注。"
		),
		"university" = list(
			"desc" = "城镇的学术中心，研究历史、科学与奥术理论，常提供附魔服务或能参与战斗的法师。",
			"note" = "暂无自定义备注。"
		),
		"innkeeper" = list(
			"desc" = "当地酒馆的老板，用酒维持和平，为旅人提供住宿、晚餐与烈酒。",
			"note" = "暂无自定义备注。"
		),
		"tailor" = list(
			"desc" = "精通纺织、服装与布料，能够修补衣物、制作新装。",
			"note" = "暂无自定义备注。"
		),
		"bathhouse" = list(
			"desc" = "崇尚伊欧拉洁净之道的圣所，为疲惫的镇民提供公共洗浴与休憩服务。放松身心，让熟练的侍者照顾您的每一项需求。",
			"note" = "暂无自定义备注。"
		),
		"merchant" = list(
			"desc" = "专门进口并分销稀有货物、古物与日常物资的商人，有时也会收购稀有或贵重物品。",
			"note" = "暂无自定义备注。"
		),
		"freeform1" = list(
			"desc" = "在城镇范围内活动的其他职业或势力。",
			"note" = "暂无自定义备注。"
		),
		"freeform2" = list(
			"desc" = "在城镇范围内活动的其他职业或势力。",
			"note" = "暂无自定义备注。"
		),
	)

	var/list/all_flags = list()

/datum/rogue_info/proc/set_role_visibility(role_name, new_status)
	if(!(role_name in role_visibility))
		return FALSE

	if(role_visibility[role_name] == new_status)
		return FALSE

	role_visibility[role_name] = new_status

	for(var/obj/structure/flagpole/F in all_flags)
		F.update_single_role(role_name, new_status)

	return TRUE
