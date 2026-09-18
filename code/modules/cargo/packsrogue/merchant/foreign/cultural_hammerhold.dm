/datum/supply_pack/rogue/hammerhold
	group = "文化货物"
	crate_name = "铁锤堡货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/hammerhold/dwarven_maul
	name = "矮人重槌"
	cost = 240
	contains = list(/obj/item/rogueweapon/mace/maul)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/spiked_maul
	name = "尖刺重槌"
	cost = 260
	contains = list(/obj/item/rogueweapon/mace/spiked)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/longbow
	name = "紫杉长弓"
	cost = 80
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/iron_fullplate
	name = "铁锤堡铁甲"
	cost = 380
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/snow_cloak
	name = "诺瓦丁林地卫手斗篷"
	cost = 60
	contains = list(/obj/item/clothing/cloak/forrestercloak/snow)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/hammerhold/ironclad_kit
	name = "铁锤堡铁甲胄"
	no_name_quantity = TRUE
	cost = 410
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson,
		/obj/item/clothing/suit/roguetown/armor/plate/full,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight,
		/obj/item/clothing/neck/roguetown/chaincoif/iron,
		/obj/item/clothing/gloves/roguetown/plate/iron,
		/obj/item/clothing/wrists/roguetown/bracers/iron,
		/obj/item/clothing/under/roguetown/platelegs/iron,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/smoked_sausage
	name = "烟熏高地香肠"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/hammerhold/bacon
	name = "山居培根"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/hammerhold/slayer_axe
	name = "屠戮者战斧"
	cost = 600
	contains = list(/obj/item/rogueweapon/stoneaxe/woodcut/steel)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/slayer_greataxe
	name = "屠戮者巨斧"
	cost = 750
	contains = list(/obj/item/rogueweapon/stoneaxe/battle)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/slayer_belt
	name = "坚固矮人腰带"
	cost = 80
	contains = list(/obj/item/storage/belt/rogue/leather)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/dwarven_warpick
	name = "矮人战镐"
	cost = 120
	contains = list(/obj/item/rogueweapon/pick/militia/steel)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/grudgebearer_smith_kit
	name = "记恨者铁匠甲胄"
	no_name_quantity = TRUE
	cost = 720
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full,
		/obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith,
		/obj/item/clothing/gloves/roguetown/plate/dwarven,
		/obj/item/clothing/shoes/roguetown/boots/armor/dwarven,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/grudgebearer_soldier_kit
	name = "记恨者士兵甲胄"
	no_name_quantity = TRUE
	cost = 1000
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven,
		/obj/item/clothing/head/roguetown/helmet/heavy/dwarven,
		/obj/item/clothing/gloves/roguetown/plate/dwarven,
		/obj/item/clothing/shoes/roguetown/boots/armor/dwarven,
		/obj/item/rogueweapon/shield/tower/metal,
	)
	ship_qty_min = 1
	ship_qty_max = 1
