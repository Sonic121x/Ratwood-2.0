/datum/advclass/knave //sneaky bastards - ranged classes of two flavors archers and rogues
	name = "无赖"
	tutorial = "并非所有 马西奥斯 的追随者都会明抢。窃贼、偷猎者和各色不三不四之徒都懂得藏身暗处，从别人手里偷走东西，等受害者回过神来时，他们早已远走高飞。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/knave
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_DODGEEXPERT)//gets dodge expert but no medium armor training - gotta stay light
	subclass_stats = list(
		STATKEY_SPD = 3,//It's all about speed and perception
		STATKEY_PER = 2,
		STATKEY_LCK = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT//Skirmisher equal
	)

/datum/outfit/job/roguetown/bandit/knave/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/coif
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	id = /obj/item/mattcoin
	H.adjust_blindness(-3)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/free)
	var/subtype = list("游荡者", "偷猎者")
	if(H.mind)
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		H.set_blindness(0)
		switch(subtype_choice)
			if("游荡者") //Rogue
				backl= /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow //we really need to make this not a grenade launcher subtype
				beltr = /obj/item/quiver/bolts
				cloak = /obj/item/clothing/cloak/raincloak/mortus //cool cloak
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/matthios
				backr = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
							/obj/item/needle/thorn = 1,
							/obj/item/natural/cloth = 1,
							/obj/item/lockpickring/mundane = 1,
							/obj/item/flashlight/flare/torch = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1
							) //rogue gets lockpicks
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_MASTER, TRUE)
			if("偷猎者") //Poacher
				backl= /obj/item/gun/ballistic/revolver/grenadelauncher/bow
				beltr = /obj/item/quiver/arrows
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm //cool hat
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/matthios
				backr = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
							/obj/item/needle/thorn = 1,
							/obj/item/natural/cloth = 1,
							/obj/item/restraints/legcuffs/beartrap = 2,
							/obj/item/flashlight/flare/torch = 1,
							) //poacher gets mantraps
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_LEGENDARY, TRUE)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, -1)

/datum/outfit/job/roguetown/bandit/knave/post_equip(mob/living/carbon/human/H)
	. = ..()
	for(var/datum/bounty/b in GLOB.head_bounties)
		if(b.target == H.real_name || b.target_hidden == H.real_name)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_PER, 1)
