/datum/supply_pack/rogue/aavnr
	group = "文化货物" // English: Cultural Stock
	crate_name = "阿夫尼克货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/aavnr/shashka
	name = "阿夫尼克的沙什卡"
	cost = 90
	contains = list(/obj/item/rogueweapon/sword/sabre/steppesman)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/aavnr/recurve_bow
	name = "阿夫尼克骑弓"
	cost = 80
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/steppe_axe
	name = "草原民战斧"
	cost = 95
	contains = list(/obj/item/rogueweapon/stoneaxe/battle/steppesman)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/nagaika
	name = "哥萨克纳盖卡鞭"
	cost = 45
	contains = list(/obj/item/rogueweapon/whip/nagaika)
	ship_qty_min = 2
	ship_qty_max = 3

/datum/supply_pack/rogue/aavnr/steppe_shield
	name = "草原民铁盾"
	cost = 75
	contains = list(/obj/item/rogueweapon/shield/iron/steppesman)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/shishak
	name = "希沙克盔"
	cost = 70
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet/shishak)
	ship_qty_min = 2
	ship_qty_max = 3

/datum/supply_pack/rogue/aavnr/papakha
	name = "哥萨克帕帕哈帽"
	cost = 25
	contains = list(/obj/item/clothing/head/roguetown/papakha)
	ship_qty_min = 3
	ship_qty_max = 5

/datum/supply_pack/rogue/aavnr/ironmask
	name = "铁面战面具"
	cost = 95
	contains = list(
		/obj/item/clothing/mask/rogue/facemask/steel/steppesman,
		/obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
	)
	ship_qty_min = 2
	ship_qty_max = 3

/datum/supply_pack/rogue/aavnr/chargah
	name = "恰尔加加垫卡夫坦"
	cost = 60
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/aavnr/hatanga
	name = "草原哈坦嘎大衣"
	cost = 85
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/aavnr/steppe_scale
	name = "草原鳞甲"
	cost = 220
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/scale/steppe)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/szabrista_kit
	name = "阿夫尼克军刀手甲胄套装"
	no_name_quantity = TRUE
	cost = 430
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah,
		/obj/item/clothing/suit/roguetown/armor/plate/scale/steppe,
		/obj/item/clothing/head/roguetown/helmet/sallet/shishak,
		/obj/item/clothing/mask/rogue/facemask/steel/steppesman,
		/obj/item/clothing/neck/roguetown/chaincoif,
		/obj/item/clothing/gloves/roguetown/chain,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
		/obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman,
		/obj/item/clothing/cloak/raincloak/furcloak,
		/obj/item/rogueweapon/shield/iron/steppesman,
		/obj/item/rogueweapon/sword/sabre/steppesman,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/aavnr/druzhina_kit
	name = "阿夫尼克德鲁日纳猎手套装"
	no_name_quantity = TRUE
	cost = 260
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe,
		/obj/item/clothing/head/roguetown/helmet/sallet/shishak,
		/obj/item/clothing/neck/roguetown/leather,
		/obj/item/clothing/gloves/roguetown/fingerless_leather,
		/obj/item/clothing/wrists/roguetown/bracers/leather,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
		/obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman,
		/obj/item/clothing/cloak/raincloak/furcloak,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/aavnr/freifechter_jacket
	name = "自由斗剑团击剑外套"
	cost = 95
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/freifechter_shirt
	name = "加垫击剑衬衣"
	cost = 55
	contains = list(/obj/item/clothing/suit/roguetown/shirt/freifechter)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/freifechter_breeches
	name = "击剑马裤"
	cost = 45
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/freifechter_boots
	name = "击剑靴"
	cost = 50
	contains = list(/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/freifechter_gloves
	name = "击剑手套"
	cost = 45
	contains = list(/obj/item/clothing/gloves/roguetown/angle/grenzelgloves)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/aavnr/freifechter_kit
	name = "自由斗剑团军刀手货品"
	no_name_quantity = TRUE
	cost = 340
	contains = list(
		/obj/item/clothing/suit/roguetown/shirt/freifechter,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic,
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short,
		/obj/item/clothing/gloves/roguetown/angle/grenzelgloves,
		/obj/item/clothing/wrists/roguetown/bracers/leather,
		/obj/item/clothing/neck/roguetown/psicross/reform,
		/obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/aavnr/saiga_sausage
	name = "烟熏赛加羚羊香肠"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/aavnr/coppiette
	name = "腹地风干肉条"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
	)
	ship_qty_min = 2
	ship_qty_max = 5
