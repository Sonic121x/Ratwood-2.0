//Dwarf-exclusive mercenary class with unique armor setups.
/datum/advclass/mercenary/grudgebearer
	name = "负怨铸匠"
	tutorial = "背负着万古未消的宿怨，负怨者被迫流落地表，因为几乎每一个氏族都与你们结怨，而你们也同样痛恨他们。这片腐臭如沼泽的大公国也曾伤害过你和你的族人，你根本不在乎它。金钱不过是达成目的的手段，矿石与钢铁你自己就能开采锻造。真正能为你在族中赢得尊重的，是出自名匠之手的器物。只是，这些杰作未必能换来食物或栖身之所。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/dwarf,
		/datum/species/dwarf/mountain
	)
	outfit = /datum/outfit/job/roguetown/mercenary/grudgebearer
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_dwarf.ogg'
	extra_context = "该分支仅限矮人选择。"
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_TRAINED_SMITH, TRAIT_STEELHEARTED, TRAIT_SMITHING_EXPERT) // Another one off exception for a combat role
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 3, //Anvil "Strikes deftly" is based on PER
		STATKEY_STR = 1,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)

//Because the armor is race-exclusive for repairs, these guys *should* be able to repair their own guys armor layers. A Dwarf smith isn't guaranteed, after all.
/datum/outfit/job/roguetown/mercenary/grudgebearer/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
		belt = /obj/item/storage/belt/rogue/leather/black
		beltr = /obj/item/rogueweapon/mace
		beltl = /obj/item/flashlight/flare/torch
		backl = /obj/item/storage/backpack/rogue/backpack
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		gloves = /obj/item/clothing/gloves/roguetown/plate/dwarven
		pants = /obj/item/clothing/under/roguetown/trou/leather
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
		backpack_contents = list(
			/obj/item/roguekey/mercenary,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/hammer/iron,
			/obj/item/paper/scroll/grudge,
			/obj/item/natural/feather,
			/obj/item/rogueweapon/tongs = 1,
			)
		var/weapons = list("巨型钉头锤", "带刺大槌")
		var/wepchoice = input("选择你的武器。", "可选武器") as anything in weapons
		switch(wepchoice)
			if("巨型钉头锤")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("带刺大槌")
				r_hand = /obj/item/rogueweapon/mace/maul/spiked
				backr = /obj/item/rogueweapon/scabbard/gwstrap
		H.merctype = 8

/datum/advclass/mercenary/grudgebearer/soldier
	name = "负怨战士"
	tutorial = "背负着万古未消的宿怨，负怨者被迫流落地表，因为几乎每一个氏族都与你们结怨，而你们也同样痛恨他们。这片腐臭如沼泽的大公国也曾伤害过你和你的族人，你根本不在乎它。金钱不过是达成目的的手段，矿石与钢铁你自己就能开采锻造。真正能为你在族中赢得尊重的，是出自名匠之手的器物。只是，这些杰作未必能换来食物或栖身之所。"
	outfit = /datum/outfit/job/roguetown/mercenary/grudgebearer_soldier
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_CON = 5,
		STATKEY_WIL = 4,
		STATKEY_STR = 2,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,	//Only here so they'd be able to repair their own armor integrity
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,	//Only here so they'd be able to repair their own armor integrity
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/mercenary/grudgebearer_soldier/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
		belt = /obj/item/storage/belt/rogue/leather/black
		beltl = /obj/item/flashlight/flare/torch
		backl = /obj/item/storage/backpack/rogue/satchel
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		gloves = /obj/item/clothing/gloves/roguetown/plate/dwarven
		pants = /obj/item/clothing/under/roguetown/trou/leather
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven
		backpack_contents = list(
			/obj/item/roguekey/mercenary,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/hammer/iron,
			/obj/item/paper/scroll/grudge,
			/obj/item/natural/feather,
			)
		if(H.mind)
			var/weapons = list("战斧", "巨型钉头锤", "矮人大槌")
			var/wepchoice = input(H, "选择你的武器。", "可选武器") as anything in weapons
			switch(wepchoice)
				if("战斧")
					backr = /obj/item/rogueweapon/stoneaxe/battle
				if("巨型钉头锤")
					r_hand = /obj/item/rogueweapon/mace/goden/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("矮人大槌")
					r_hand = /obj/item/rogueweapon/mace/maul/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
		H.merctype = 8


/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
	name = "负怨者矮人板甲"
	desc = "一套依循古法锻造的坚固矮人板甲，没有矮人与生俱来的工艺知识便无法修整。"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfchest"
	item_state = "dwarfchest"
	armor = ARMOR_PLATE
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	smelt_bar_num = 4

// Smith: Maille-tier protection, medium armor class
/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
	name = "负怨者板条铁围"
	desc = "矮人铁匠穿戴的板甲与锁甲混合护具，没有矮人与生俱来的工艺知识便无法修整。"
	icon_state = "dsmithchest"
	item_state = "dsmithchest"
	armor = ARMOR_PLATE
	armor_class = ARMOR_CLASS_MEDIUM
	body_parts_covered = CHEST|GROIN|VITALS|LEGS
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	smelt_bar_num = 3

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven
	name = "负怨者矮人头盔"
	desc = "一顶坚固的矮人头盔，留出了让矮人胡须伸出的空隙。"
	body_parts_covered = (HEAD | MOUTH | NOSE | EYES | EARS | NECK)	//This specifically omits hair so you could hang your beard out of the helm
	armor = ARMOR_PLATE
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "dwarfhead"
	item_state = "dwarfhead"
	block2add = FOV_BEHIND
	bloody_icon = 'icons/effects/blood64.dmi'
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
	name = "负怨者匠师头盔"
	desc = "一顶坚固的矮人头盔，留出了让矮人胡须伸出的空隙。"
	icon_state = "dsmithhead"
	item_state = "dsmithhead"

/obj/item/clothing/gloves/roguetown/plate/dwarven
	name = "负怨者矮人臂铠"
	desc = "为最短粗的手指量身锻造。"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	sleeved = null
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfhand"
	item_state = "dwarfhand"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_SIDE_STEEL

/obj/item/clothing/shoes/roguetown/boots/armor/dwarven
	name = "负怨者矮人战靴"
	desc = "走动时铿锵作响。"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfshoe"
	item_state = "dwarfshoe"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_SIDE_STEEL
