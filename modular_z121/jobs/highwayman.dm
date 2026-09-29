// 普通冒险者子职业，仅通过冒险者标签登记，不赋予反派身份。
/datum/advclass/z121_highwayman
	name = "拦路悍匪"
	tutorial = "用石头击晕守卫并从监狱出逃后，你设法偷到了一把火枪和短刀，是时候改善一下自己的生活品质了；你这样想到……结果很成功，你拦下了一辆马车并以老练的技术杀了所有人，但因为过去的经历，你放走了车上的母子，一时的怜悯换不来终身的救赎，还可能会导致杀身之祸，权衡利弊之下，你来到了一个新的小镇，选择隐瞒自己过去的所作所为，成为一名普通外乡人"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/z121_highwayman
	category_tags = list(CTAG_ADVENTURER)
	class_select_category = CLASS_CAT_ROGUE
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_OUTLANDER)
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(STATKEY_STR = 1, STATKEY_INT = 2, STATKEY_SPD = 3, STATKEY_LCK = -2)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "入职自选三项近战武技和一项火枪终结技。武技先附着手持武器，命中后触发；积攒三层架势可准备一次终结技。穿戴中甲或重甲时禁止使用技能，并清除待发招式与临时增益。"

/datum/outfit/job/roguetown/adventurer/z121_highwayman/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/gun/ballistic/z121_millicombat_pistol
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/flashlight/flare/torch/lantern
	mask = /obj/item/clothing/head/roguetown/scarf
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	// 一枚金币价值十马蒙；左右挎包不重复发放补给。
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/roguecoin/gold = 1,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 2,
	)

/datum/outfit/job/roguetown/adventurer/z121_highwayman/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(!visualsOnly && H.mind)
		H.AddComponent(/datum/component/z121_highwayman)
