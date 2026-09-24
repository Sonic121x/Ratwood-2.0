// 独立的奥塔瓦佣兵子职业，通过佣兵分类自动注册，保留原有火枪手。
/datum/advclass/z121_otavan_musketeer
	name = "奥塔瓦 游骑火枪手"
	tutorial = "奥塔瓦游骑火枪手 是一群携带着稀有禁忌武器的外来客，他们跨越国境，只为在异国他乡的战火中收割财富。在这个极少听闻枪炮轰鸣的土地上，你手中的黑火药武器既是让人惊骇的致命底牌，也是你最可靠的通行证。无论是急需打破僵局的异国领主，还是在暗中谋划的阴谋家，都渴望雇用你那神乎其神的枪法和令人胆寒的齐射火力。在这片对你充满猜忌的陌生国度，你将作为游离于体制外的无情猎犬，用每一发宝贵的铅弹，在这濒死世界的最前线证明自己的身价。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	outfit = /datum/outfit/job/roguetown/mercenary/z121_otavan_musketeer
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_OTAVA
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/combat_routier.ogg'
	subclass_languages = list(/datum/language/otavan)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_FUSILIER,
		TRAIT_DODGEEXPERT,
		TRAIT_OUTLANDER,
	)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_STR = 1,
		STATKEY_CON = -1,
	)
	// 由职业框架提升至指定等级，保留角色已经掌握的更高技能。
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
	)
	extra_context = "来自奥塔瓦的外乡佣兵，拥有铁心、火枪手与闪避大师特质；擅长火器与追踪，配备燧枪和法刀。"

/datum/outfit/job/roguetown/mercenary/z121_otavan_musketeer
	backl = /obj/item/gun/ballistic/firearm/flintgonne/fusil
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/scabbard/sword/z121_otavan_musketeer
	beltr = /obj/item/powderflask
	head = /obj/item/clothing/head/roguetown/duelhat
	neck = /obj/item/clothing/neck/roguetown/fencerguard
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
	// 背包中的备用火药瓶替换为一袋八发铅弹，腰间仍保留火药瓶。
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/quiver/bullet/lead = 1,
	)

/datum/outfit/job/roguetown/mercenary/z121_otavan_musketeer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(!visualsOnly)
		// 游骑火枪手使用通用佣兵勋章，不归入巡战骑士团。
		H.merctype = 0

// 法刀出生时已经入鞘，不占用双手，也不改变普通剑鞘的行为。
/obj/item/rogueweapon/scabbard/sword/z121_otavan_musketeer/Initialize(mapload)
	. = ..()
	sheathed = new /obj/item/rogueweapon/sword/short/falchion(src)
	update_icon()
