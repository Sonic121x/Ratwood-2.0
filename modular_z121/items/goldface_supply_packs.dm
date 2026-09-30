// modular_z121 自定义金面售卖包
// 通过新增自定义售卖包，把铅弹袋及无尽系列加入金面的对应分类。

/datum/supply_pack/rogue/ranged_weapons/lead_bullet_quiver
	// 名称对齐项目里 /obj/item/quiver/bullet/lead 的现有翻译。
	name = "铅弹袋"
	// 按需求固定为 80 mammon，不吃主线商店包的随机价格浮动。
	cost = 80
	static_cost = TRUE
	contains = list(
		/obj/item/quiver/bullet/lead,
	)

// 无尽系列沿用现有魔法物品分类，基础价格不参与随机浮动。
/datum/supply_pack/rogue/magic/z121_endless_water_pot
	name = "无尽水壶"
	cost = 300
	static_cost = TRUE
	contains = list(/obj/item/reagent_containers/glass/z121_endless_pot/water)

/datum/supply_pack/rogue/magic/z121_endless_tea_pot
	name = "无尽茶壶"
	cost = 800
	static_cost = TRUE
	contains = list(/obj/item/reagent_containers/glass/z121_endless_pot/tea)

/datum/supply_pack/rogue/magic/z121_endless_milk_pot
	name = "无尽奶壶"
	cost = 1500
	static_cost = TRUE
	contains = list(/obj/item/reagent_containers/glass/z121_endless_pot/milk)
