/datum/advclass/foreigner/shepherd
	name = "Szöréndnížine 牧羊人"
	tutorial = "你是一名来自阿瓦尔自由城茨瓦尔特卡的普通牧羊人，或是在朝圣途中，或是因某种缘故逃离了故乡。你能轻松地在荒野中自给自足；只要勤加练习，即使面对披甲的敌人，也能用传统斧头保护自己。"
	extra_context = "该职业适合熟练掌握走位和体力管理的资深冒险者。你的武器具有特殊的攻击意图，灵活切换能让战斗轻松些……至少有时如此。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_languages = list(/datum/language/aavnic)
	outfit = /datum/outfit/job/roguetown/adventurer/freishepherd
	traits_applied = list()
	cmode_music = 'sound/music/frei_shepherd.ogg'
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/freishepherd/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/head/roguetown/paddedcap
	head = /obj/item/clothing/head/roguetown/chaperon/greyscale/shepherd
	neck = /obj/item/clothing/neck/roguetown/psicross/reform
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/rogueweapon/stoneaxe/battle/steppesman/chupa
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/shepherd
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft/freifechter
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flashlight/flare/torch = 1,
						)
