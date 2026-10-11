

/datum/supply_pack/rogue/magic
	group = "魔法用品" // English: Magic
	crate_name = "商人公会货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/magic/swampzig
	name = "沼叶卷烟"
	cost = 15
	contains = list(/obj/item/clothing/mask/cigarette/rollie/cannabis)

/datum/supply_pack/rogue/magic/silverpsicross
	name = "银教十字"
	cost = 120
	contains = list(/obj/item/clothing/neck/roguetown/psicross/silver)

/datum/supply_pack/rogue/magic/silverdagger
	name = "奥术银匕"
	cost = 130 //used in level 3/4 enchantments
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne)

/datum/supply_pack/rogue/magic/nomag
	name = "反魔之戒"
	cost = 300
	contains = list(/obj/item/clothing/ring/active/nomag)

/datum/supply_pack/rogue/magic/scrying
	name = "占卜球"
	cost = 300
	contains = list(/obj/item/scrying)

/datum/supply_pack/rogue/magic/listenst
	name = "翡翠颈环"
	cost = 250
	contains = list(/obj/item/listenstone)

/datum/supply_pack/rogue/magic/talkstone
	name = "话石"
	cost = 100
	contains = list(/obj/item/clothing/neck/roguetown/talkstone)

/datum/supply_pack/rogue/magic/obsidianfragment
	name = "黑曜石碎片"
	cost = 55
	contains = list(
			/obj/item/magic/obsidian,
			/obj/item/magic/obsidian,
			/obj/item/magic/obsidian,
			)

/datum/supply_pack/rogue/magic/manaflower
	name = "法绽花"
	cost = 55
	contains = list(
			/obj/item/reagent_containers/food/snacks/grown/manabloom,
			/obj/item/reagent_containers/food/snacks/grown/manabloom,
			/obj/item/reagent_containers/food/snacks/grown/manabloom,
			)

/datum/supply_pack/rogue/magic/manacrystal
	name = "结晶化魔力"
	cost = 55
	contains = list(
			/obj/item/magic/manacrystal,
			/obj/item/magic/manacrystal,
			/obj/item/magic/manacrystal,
			)

/datum/supply_pack/rogue/magic/lovepotion
	name = "爱情魔药"
	cost = 300
	contains = list(/obj/item/lovepotion)

/datum/supply_pack/rogue/magic/suidust
	name = "碎晶粉（仅变性）"
	cost = 135
	contains = list(/obj/item/alch/transisdust)
