/datum/advclass/wretch/outlaw
	name = "亡命徒"
	tutorial = "你是夜里令人闻风丧胆的家伙，用你的狡诈与速度迅速出手，在任何人察觉前带着赃物全身而退。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/outlaw
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_WRETCH)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_MEDIUMARMOR, TRAIT_GRAVEROBBER, TRAIT_BOGWALKER) //Doubt you have much to say about robbing graves
	extra_context = "疾步赋予轻盈步伐及潜行+1；射术赋予感知+1及弩术+1；体能赋予体质+1及运动+1；夜盗赋予夜视及开锁+1；追踪大师赋予完美追踪、侦探能力及追踪+1；双持赋予双持能力及戒备（伪装柔弱）。"
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_STR = -1,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE, //A bonus rather than something to be encouraged
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	)
	subclass_stashed_items = list(
		"缝纫工具包" = /obj/item/repair_kit,
	)

/datum/outfit/job/roguetown/wretch/outlaw/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是夜里令人闻风丧胆的家伙，用你的狡诈与速度迅速出手，在任何人察觉前带着赃物全身而退。"))
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	cloak = /obj/item/clothing/cloak/stabard/dungeon
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel/short
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	backpack_contents = list(
		/obj/item/lockpickring/mundane = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
	)
	if(H.mind)
		var/weapons = list("刺剑","军刀","格挡匕首","鞭子","软剑")
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		var/rangedweapons = list("轻弩", "十字弩")
		var/rangedweapon_choice = input(H,"选择你的弩。", "瞄准。") as anything in rangedweapons
		var/specialization = list("疾步","射术","体能","夜盗","追踪大师","双持")
		var/specialization_choice = input(H, "选择你的专长。", "披甲执兵") as anything in specialization
		H.set_blindness(0)
		switch(weapon_choice)
			if("刺剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/rapier
			if("军刀")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre
			if("格挡匕首")
				beltl = /obj/item/rogueweapon/scabbard/sheath
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
			if("鞭子")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/whip
			if ("软剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/whip/urumi
		switch(rangedweapon_choice)
			if("轻弩")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
				beltr = /obj/item/quiver/bolts
			if("十字弩")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolts
		switch(specialization_choice)
			if("疾步")
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_MASTER, TRUE)
				ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
			if("射术")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
				H.change_stat(STATKEY_PER, 1)
			if("体能")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				H.change_stat(STATKEY_CON, 1)
			if("夜盗")
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_MASTER, TRUE)
				ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
			if("追踪大师")
				H.adjust_skillrank_up_to(/datum/skill/misc/tracking, SKILL_LEVEL_MASTER, TRUE)
				ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)
			if("双持")//Yes the typo is intentional
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_DECEIVING_MEEKNESS, TRAIT_VIRTUE)

		wretch_select_bounty(H)

//Keep it as is from now on, this is kind of overbloated as it be but the entire point of this class is catchall no good doer (speed).
//It is mostly reverted to how it originally was with some boons to not be worse than heretic spy (that is limited, this is not).
//Kettle and Hardened Leather should be maintained in spite of the medium armour it's more there as an option.
//A true hybrid of Melee and Ranged (Xbow / Tossblades)
