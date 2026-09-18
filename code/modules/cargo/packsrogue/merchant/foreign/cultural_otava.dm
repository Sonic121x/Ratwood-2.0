/datum/supply_pack/rogue/otava
	group = "文化货物" // English: Cultural Stock
	crate_name = "奥塔瓦货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/otava/morningstar
	name = "钢制晨星锤"
	cost = 130
	contains = list(/obj/item/rogueweapon/mace/steel/morningstar)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/otava/lance
	name = "步战骑枪"
	cost = 110
	contains = list(/obj/item/rogueweapon/spear/lance)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/otava/falchion
	name = "弯刃刀"
	cost = 90
	contains = list(/obj/item/rogueweapon/sword/falchion)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/otava/lucerne
	name = "卢塞恩战锤"
	cost = 150
	contains = list(/obj/item/rogueweapon/mace/warhammer/steel)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/otava/half_plate
	name = "奥塔万半身甲"
	cost = 320
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/otavan)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/otava/full_plate
	name = "奥塔万全身甲"
	cost = 520
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/otava/klappvisier
	name = "奥塔万克拉普面甲"
	cost = 110
	contains = list(/obj/item/clothing/head/roguetown/helmet/otavan)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/otava/heavy_gambeson
	name = "奥塔万剑术棉甲"
	cost = 100
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/otava/gloves
	name = "奥塔万皮手套"
	cost = 45
	contains = list(/obj/item/clothing/gloves/roguetown/otavan)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/otava/boots
	name = "奥塔万皮靴"
	cost = 50
	contains = list(/obj/item/clothing/shoes/roguetown/boots/otavan)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/otava/trousers
	name = "奥塔万皮裤"
	cost = 55
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/otava/satchel
	name = "奥塔万皮挎包"
	cost = 60
	contains = list(/obj/item/storage/backpack/rogue/satchel/otavan)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/otava/chevalier_kit
	name = "骑士甲胄"
	no_name_quantity = TRUE
	cost = 900
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan,
		/obj/item/clothing/suit/roguetown/armor/plate/full,
		/obj/item/clothing/head/roguetown/helmet/otavan,
		/obj/item/clothing/gloves/roguetown/otavan,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan,
		/obj/item/clothing/shoes/roguetown/boots/otavan,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/otava/sergent_kit
	name = "军士长甲胄"
	no_name_quantity = TRUE
	cost = 640
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan,
		/obj/item/clothing/suit/roguetown/armor/plate/otavan,
		/obj/item/clothing/head/roguetown/helmet/otavan,
		/obj/item/clothing/gloves/roguetown/otavan,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan,
		/obj/item/clothing/shoes/roguetown/boots/otavan,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/otava/cheese
	name = "帕伊斯奶酪轮"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
	)
	ship_qty_min = 3
	ship_qty_max = 7
