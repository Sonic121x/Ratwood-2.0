/datum/supply_pack/rogue/underdark
	group = "文化货物" // English: Cultural Stock
	crate_name = "幽暗地域货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/underdark/saber
	name = "幽暗地域军刀"
	cost = 130
	contains = list(/obj/item/rogueweapon/sword/sabre/stalker)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/underdark/dagger
	name = "幽暗地域匕首"
	cost = 130
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/silver/elvish/drow)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/underdark/slurbow
	name = "幽暗地域轻弩"
	cost = 150
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker/lesser)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/underdark/fangeddagger
	name = "幽暗地域獠牙匕首"
	cost = 150
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/dirk)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/underdark/poisondagger
	name = "幽暗地域毒匕首"
	cost = 250
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/corroded)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/underdark/restrainpoison
	name = "幽暗地域束缚毒药"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/stampoison)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/underdark/killerpoison
	name = "幽暗地域致命毒药"
	cost = 35
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/berrypoison)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/underdark/antidote
	name = "幽暗地域解毒剂"
	cost = 15
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/antidote)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/underdark/crocs
	name = "幽暗地域蛛牙全套装备"
	cost = 350
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe,
		/obj/item/clothing/mask/rogue/facemask/shadowfacemask,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants,
		/obj/item/clothing/gloves/roguetown/plate/shadowgauntlets,
	)
	ship_qty_min = 1
	ship_qty_max = 1


