/datum/advclass/wretch/mistwalker
	name = "雾行者" //works
	tutorial = "你来自风郡，曾是一名神圣的守护者，将生命奉献于守护你所选的神明神社，抵御盗匪与来自彼界的妖魔……如今？你神圣的家园已经陷落，被毁灭之力占据，你被放逐，游荡于世间。在寻找目标的过程中，你将会发现什么？"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT 
	allowed_patrons = ALL_PATRONS 
	outfit = /datum/outfit/job/roguetown/wretch/mistwalker
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_NOPAINSTUN, TRAIT_BLOOD_RESISTANCE, TRAIT_JOURNEYS_END, TRAIT_DODGEEXPERT) //no armour, literally made to bleed
	maximum_possible_slots = 2 //you probably don't want many of these

	cmode_music = 'sound/music/combat_Kazengun_Firestorm.ogg'
	subclass_stats = list(
		STATKEY_STR = 2, 
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //you'll get real familiar with bleeding
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN, //flavour and useful for making armour
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, //social outcast but can still read protective charms
	)
	subclass_stashed_items = list(
		"Sewing Kit" =  /obj/item/repair_kit, //I am sure you'll find a way to repair your bracers
	)

/datum/advclass/wretch/mistwalker/check_requirements(mob/living/carbon/human/H)
	if(!istype(H.client?.prefs?.origin, /datum/origin/kazengun))
		return FALSE
	return ..()

/datum/outfit/job/roguetown/wretch/mistwalker/pre_equip(mob/living/carbon/human/H)
	..()
	
	if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
		armor = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	else
		armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black

	head = /obj/item/clothing/head/roguetown/mentorhat
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun //eh could be a regular one too
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	mask = /obj/item/clothing/mask/rogue/facemask/steel/kazengun //let them have this
	wrists = /obj/item/clothing/wrists/roguetown/bracers/black
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/kazengun = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)

	if(H.mind)
		var/weapons = list("双手刀 +2 体质", "金棒 +1 力量", "薙刀 +2 感知", "环刀 +2 智力", "小太刀 +1 速度")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("双手刀 +2 体质")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry
				H.change_stat(STATKEY_CON, 2)
			if("金棒 +1 力量")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/mace/goden/kanabo
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1)
			if("薙刀 +2 感知")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/spear/naginata
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_PER, 2)
			if("环刀 +2 智力")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
				H.change_stat(STATKEY_INT, 2)
			if("小太刀 +1 速度") //SPD you can dodge, probably
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				H.change_stat(STATKEY_SPD, 1)

		wretch_select_bounty(H)

/obj/item/clothing/wrists/roguetown/bracers/black
	color = CLOTHING_BLACK
/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	color = CLOTHING_BLACK
/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black
	color = CLOTHING_BLACK
/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black
	color = CLOTHING_BLACK
