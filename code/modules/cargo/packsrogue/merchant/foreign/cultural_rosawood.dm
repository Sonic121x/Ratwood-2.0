// the woad light helm and maille, the blackoak barbutes, the woad recurve bow and the javelin
// quiver do not exist. Their packs are omitted until those items are ported.
/datum/supply_pack/rogue/rosawood
	group = "文化货物" // English: Cultural Stock
	crate_name = "罗莎木货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/rosawood/woad_helm
	name = "靛纹精灵头盔"
	cost = 95
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/rosawood/woad_plate
	name = "靛纹精灵板甲"
	cost = 160
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/elven_plate)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/rosawood/elven_gloves
	name = "靛纹精灵手套"
	cost = 30
	contains = list(/obj/item/clothing/gloves/roguetown/elven_gloves)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/rosawood/forrester_cloak
	name = "林地卫手斗篷"
	cost = 45
	contains = list(/obj/item/clothing/cloak/forrestercloak)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/rosawood/woad_furcloak
	name = "守林人毛皮斗篷"
	cost = 55
	contains = list(/obj/item/clothing/cloak/raincloak/furcloak/woad)
	ship_qty_min = 2
	ship_qty_max = 4

// Ranged

/datum/supply_pack/rogue/rosawood/recurve_bow
	name = "反曲弓"
	cost = 50
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/rosawood/yew_longbow
	name = "紫杉长弓"
	cost = 75
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/rosawood/arrows
	name = "箭袋"
	cost = 35
	contains = list(/obj/item/quiver/arrows)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/rosawood/bodkins
	name = "锥头箭箭袋"
	cost = 60
	contains = list(/obj/item/quiver/bodkin)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/rosawood/honey
	name = "罐装蜂蜜"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey,
		/obj/item/reagent_containers/food/snacks/rogue/honey,
		/obj/item/reagent_containers/food/snacks/rogue/honey,
	)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/rosawood/raisin_loaf
	name = "葡萄干面包"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread,
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread,
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread,
	)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/rosawood/apples
	name = "罗莎木苹果"
	cost = 20
	contains = list(
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
	)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/rosawood/pears
	name = "罗莎木梨"
	cost = 20
	contains = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
	)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/rosawood/berries
	name = "罗莎木杰克莓"
	cost = 20
	contains = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
	)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/rosawood/butter
	name = "黄油"
	cost = 30
	contains = list(
		/obj/item/reagent_containers/food/snacks/butter,
		/obj/item/reagent_containers/food/snacks/butter,
		/obj/item/reagent_containers/food/snacks/butter,
	)
	ship_qty_min = 1
	ship_qty_max = 3

//// Elven Blades
/datum/supply_pack/rogue/rosawood/elfsword
	name = "精灵短剑"
	cost = 60
	contains = list(/obj/item/rogueweapon/sword/short/elf)
	ship_qty_min = 2
	ship_qty_max = 3

/datum/supply_pack/rogue/rosawood/elflongsword
	name = "精灵长剑"
	cost = 80
	contains = list(/obj/item/rogueweapon/sword/long/elf)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/rosawood/elfswordspear
	name = "精灵剑矛"
	cost = 100
	contains = list(/obj/item/rogueweapon/spear/naginata/elf)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/rosawood/elfcurveblade
	name = "精灵曲刃剑"
	cost = 120
	contains = list(/obj/item/rogueweapon/greatsword/elf)
	ship_qty_min = 1
	ship_qty_max = 2
