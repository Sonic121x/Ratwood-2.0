// special old class ported from RW1
/datum/advclass/manorguard/retainer
	name = "家臣"
	tutorial = "你是一名上了年纪的兵士，已忠心效力数十年。尽管青春活力已逝，但纪律与经验犹存。"
	outfit = /datum/outfit/job/roguetown/manorguard/retainer
	allowed_ages = list(AGE_OLD)
	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,// seems kinda lame but remember guardsman bonus!!
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/manorguard/retainer/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	beltl = /obj/item/rogueweapon/sword/decorated
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("战锤与盾","斧与盾","长戟","巨斧")
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("战锤与盾")
				beltr = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/iron
			if("斧与盾")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/iron
			if("长戟")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("巨斧")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/armor_options = list("锁子甲套", "链甲套")
		var/armor_choice = input(H, "选择你的护甲。", "披甲执兵") as anything in armor_options

		switch(armor_choice)
			if("锁子甲套")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				pants = /obj/item/clothing/under/roguetown/splintlegs

			if("链甲套")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				pants = /obj/item/clothing/under/roguetown/chainlegs

		var/helmets = list(
		"简易头盔" 	= /obj/item/clothing/head/roguetown/helmet,
		"壶形盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"中头盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"轻盔"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"翼盔" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"颅骨盔"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "执盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]
