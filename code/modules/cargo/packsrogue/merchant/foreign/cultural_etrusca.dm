/datum/supply_pack/rogue/etrusca
	group = "文化货物"
	crate_name = "伊特鲁斯卡货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/etrusca/falchion
	name = "弯刃刀"
	cost = 90
	contains = list(/obj/item/rogueweapon/sword/falchion)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/etrusca/crossbow
	name = "伊特鲁斯卡十字弩"
	cost = 50
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/etrusca/heavy_bolts
	name = "弩矢箭袋"
	cost = 35
	contains = list(/obj/item/quiver/bolts)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/etrusca/pike
	name = "佣兵首领猎猪矛"
	cost = 90
	contains = list(/obj/item/rogueweapon/spear/boar)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/etrusca/etruscan_bascinet
	name = "伊特鲁斯卡巴西内盔"
	cost = 130
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/etrusca/condottieri_kit
	name = "佣兵首领长矛兵套装"
	no_name_quantity = TRUE
	cost = 380
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
		/obj/item/clothing/suit/roguetown/armor/brigandine,
		/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		/obj/item/clothing/gloves/roguetown/plate,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/etrusca/vaquero_kit
	name = "牧侠游骑套装"
	no_name_quantity = TRUE
	cost = 220
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/leather/studded,
		/obj/item/clothing/head/roguetown/helmet/skullcap,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
		/obj/item/clothing/shoes/roguetown/boots/leather,
	)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/etrusca/jamon
	name = "腌制火腿（哈蒙）"
	cost = 45
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/etrusca/coppiette
	name = "伊特鲁斯卡风干肉条"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
	)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/etrusca/salami
	name = "维拉斯卡萨拉米肠"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
	)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/etrusca/cheese
	name = "蒙特卡里纳奶酪轮"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/etrusca/vaquero_ring
	name = "牧侠之戒"
	cost = 150
	contains = list(/obj/item/clothing/neck/roguetown/luckcharm)
	ship_qty_min = 1
	ship_qty_max = 1
