/datum/job/roguetown/wapprentice
	title = "Magicians Associate"
	flag = MAGEASSOCIATE
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_races = ACCEPTED_RACES
	spells = list()
	advclass_cat_rolls = list(CTAG_WAPPRENTICE = 20)

	tutorial = "你的导师曾在你身上看见过潜力，尽管以如今这般严苛艰难的学业来看，你也不确定他们是否仍这么想。魔法之路危险难驯，而你距离能自称这一行的熟手，恐怕还差上数十年。听令，服侍，总有一天你会赢得属于自己的帽子。"

	outfit = /datum/outfit/job/roguetown/wapprentice

	display_order = JDO_MAGEASSOCIATE
	give_bank_account = TRUE

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	advjob_examine = TRUE // So that Court Magicians can know if they're teachin' a Apprentice or if someone's a bit more advanced of a player. Just makes the title show up as the advjob's name.
	social_rank = SOCIAL_RANK_YEOMAN
	job_traits = list(TRAIT_ALCHEMY_EXPERT, TRAIT_MAGEDEXTERITY)
	job_subclasses = list(
		/datum/advclass/wapprentice/associate,
		/datum/advclass/wapprentice/apprentice
	)

/datum/outfit/job/roguetown/wapprentice
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/random
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/mageapprentice
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/gladiator // FANCY SANDALS

/datum/advclass/wapprentice/associate
	name = "魔法师助手"
	tutorial = "无人能真正精通奥术的全部领域，但掌握基础\
	并非遥不可及。得到同侪与导师认可后，你成为了一名助手，领取\
	津贴，为王室施展力量——至少不与之为敌。王室或许\
	希望你将雷电掷向他们的仇敌；毕竟奥术除了战争\
	与毁灭，还能有什么用？然而许多法师明白，智慧与奇思才是精通\
	此道的魔导师真正的追求。选择权在你手中。"
	outfit = /datum/outfit/job/roguetown/wapprentice/associate

	category_tags = list(CTAG_WAPPRENTICE)
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/apprentice_associate
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/associate/pre_equip(mob/living/carbon/human/H)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/random
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/magebag/associate
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/gladiator
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	backpack_contents = list(
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		backr = choose_implement(H, "lesser")

/datum/advclass/wapprentice/apprentice
	name = "法师学徒"
	tutorial = "你的导师曾在你身上看见过潜力，尽管以如今这般严苛艰难的学业来看，你也不确定他们是否仍这么想。魔法之路危险难驯，而你距离能自称这一行的熟手，恐怕还差上数十年。听令，服侍，总有一天你会赢得属于自己的帽子。"
	outfit = /datum/outfit/job/roguetown/wapprentice/apprentice

	category_tags = list(CTAG_WAPPRENTICE)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)//emphasizing the "serve" part of their description
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,//running around for errands
	)

/datum/outfit/job/roguetown/wapprentice/apprentice/pre_equip(mob/living/carbon/human/H)
	beltl = /obj/item/storage/magebag/associate
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/outfit/job/roguetown/wapprentice/associate/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..() 			// small bonus picks to get you into your field of study - also a good character-building tool. Not impactful enough to
	var/list/choices = list( // be their own subclasses, by design; your choice will not lock you into anything it just gives you a headstart
		"奥术精通",
		"炼金技艺",
		// "Artificed Luxury" disabled until mgl3pt2 brings artificing to mage proper - also needs a better name
		)
	var/list/choice_descs = list(
		"奥术精通" = "获得额外召唤次数，让你能更快开展各种实验。",
		"炼金技艺" = "炼金技能额外提高一级，让你在此道上略占先机。不改变技能上限。",
		// "Artificed Luxury" = "Grants a bonus to engineering, giving you a head start in the study of artificery. Does not affect skill caps." disabled until mgl3pt2 brings artificing to mage proper
		)
	var/choice = tgui_input_list(H, "你的研究至今沿着哪条道路前进？", "选择你的专长", choices, "奥术精通", descriptions = choice_descs)
	switch(choice)
		if("奥术精通")
			ADD_TRAIT(H, TRAIT_LEYLINE_EXPERTISE, JOB_TRAIT)
		if("炼金技艺")
			spawn(3 SECONDS) H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE) // otherwise this applies before advclass skills and does nothing
		// if("Artificed Luxury") todo in part 2
