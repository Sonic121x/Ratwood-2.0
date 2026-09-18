/datum/supply_pack/rogue/vakra
	group = "文化货物" // English: Cultural Stock
	crate_name = "瓦克兰货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/vakra/vreccale
	name = "瓦克兰弗雷卡勒"
	cost = 50
	contains = list(/obj/item/clothing/neck/roguetown/gorget/forlorncollar)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/vakra/helmet
	name = "瓦克兰沃尔夫头盔"
	cost = 70
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/volfplate)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/vakra/warhammer
	name = "镀银战锤"
	cost = 220
	contains = list(/obj/item/rogueweapon/mace/warhammer/steel/silver)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/vakra/shield
	name = "瓦克兰盾"
	cost = 50
	contains = list(/obj/item/rogueweapon/shield/heater)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/vakra/siegebow
	name = "瓦克兰攻城弩"
	cost = 220
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/vakra/siegebolts
	name = "重型弩矢箭袋"
	cost = 60
	contains = list(/obj/item/quiver/heavybolts)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/vakra/forlorn_hope_regalia
	name = "瓦克兰死士先锋全套装备"
	no_name_quantity = TRUE
	cost = 200
	contains = list(
		/obj/item/clothing/neck/roguetown/gorget/forlorncollar,
		/obj/item/clothing/wrists/roguetown/splintarms,
		/obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
		/obj/item/clothing/under/roguetown/splintlegs,
		/obj/item/clothing/suit/roguetown/armor/brigandine/light,
	)
	ship_qty_min = 1
	ship_qty_max = 1
