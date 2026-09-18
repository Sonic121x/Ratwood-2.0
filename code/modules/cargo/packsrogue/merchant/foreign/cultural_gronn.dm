/datum/supply_pack/rogue/gronn
	group = "文化货物" // English: Cultural Stock
	crate_name = "格隆恩货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/gronn/battleaxe
	name = "伊斯卡恩战斧"
	cost = 130
	contains = list(/obj/item/rogueweapon/stoneaxe/battle)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/gronn/gronnarmor
	name = "格隆恩硬化皮甲"
	cost = 60
	contains = list (/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn)

/datum/supply_pack/rogue/gronn/gronnpants
	name = "游牧民硬化皮裤"
	cost = 50
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants)

/datum/supply_pack/rogue/gronn/gronnpantsalt
	name = "格隆恩皮裤"
	cost = 40
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/gronn)

/datum/supply_pack/rogue/gronn/gronnglovesleather
	name = "格隆恩毛衬重型皮手套"
	cost = 40
	contains = list (/obj/item/clothing/gloves/roguetown/angle/gronn)

/datum/supply_pack/rogue/gronn/owl_helmet
	name = "猫头鹰盔"
	cost = 150
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/moose_hood
	name = "驼鹿兜帽"
	cost = 90
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/varangian_hauberk
	name = "瓦兰吉安锁子甲"
	cost = 180
	contains = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/shamanic_coat
	name = "萨满大衣"
	cost = 110
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/kite_shield
	name = "格隆恩鸢盾"
	cost = 90
	contains = list(/obj/item/rogueweapon/shield/atgervi)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/gronn/fur_gloves
	name = "毛衬皮手套"
	cost = 40
	contains = list(/obj/item/clothing/gloves/roguetown/angle/atgervi)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/gronn/bone_gloves
	name = "毛衬骨手套"
	cost = 50
	contains = list(/obj/item/clothing/gloves/roguetown/angle/gronnfur)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/gronn/beast_claws
	name = "兽爪护手"
	cost = 140
	contains = list(/obj/item/clothing/gloves/roguetown/plate/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/fur_pants
	name = "格隆恩毛皮裤"
	cost = 50
	contains = list(/obj/item/clothing/under/roguetown/trou/leather/atgervi)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/gronn/leather_boots
	name = "阿特格维皮靴"
	cost = 45
	contains = list(/obj/item/clothing/shoes/roguetown/boots/leather/atgervi)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/gronn/atgervi_kit
	name = "阿特格维瓦兰吉安套装"
	no_name_quantity = TRUE
	cost = 540
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi,
		/obj/item/clothing/suit/roguetown/armor/brigandine/gronn,
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi,
		/obj/item/clothing/gloves/roguetown/angle/atgervi,
		/obj/item/clothing/under/roguetown/trou/leather/atgervi,
		/obj/item/clothing/shoes/roguetown/boots/leather/atgervi,
		/obj/item/rogueweapon/shield/atgervi,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/gronn/iskarn_kit
	name = "伊斯卡恩萨满套装"
	no_name_quantity = TRUE
	cost = 380
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi,
		/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood,
		/obj/item/clothing/gloves/roguetown/angle/gronnfur,
		/obj/item/clothing/under/roguetown/trou/leather/atgervi,
		/obj/item/clothing/shoes/roguetown/boots/leather/atgervi,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/gronn/spider_honey
	name = "梦者之蜜"
	cost = 60
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider,
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider,
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider,
	)
	ship_qty_min = 3
	ship_qty_max = 6

/datum/supply_pack/rogue/gronn/cured_megafauna
	name = "腌制暮角兽肉"
	cost = 50
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/gronn/gronnic_norsii_plate
	name = "格隆恩诺尔西铁甲"
	cost = 360
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/iron/gronn)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/gronn/gronnic_norsii_helm
	name = "格隆恩诺尔西角盔"
	cost = 90
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/gronnic_brigandine
	name = "格隆恩板甲衣"
	cost = 200
	contains = list(/obj/item/clothing/suit/roguetown/armor/brigandine/gronn)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/norsii_kit
	name = "诺尔西板甲套装（重型）"
	no_name_quantity = TRUE
	cost = 620
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/plate/iron/gronn,
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn,
		/obj/item/clothing/gloves/roguetown/plate/iron/gronn,
		/obj/item/clothing/under/roguetown/platelegs/iron/gronn,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn,
	)
	ship_qty_min = 1
	ship_qty_max = 1
