
/datum/advclass/heartfelt/retinue/magos
	name = "赤心魔导师"
	tutorial = "你是赤心的魔导师，以奥术学识闻名。\
	然而，强盗、死灵术、尸鬼暴动与海盗袭击愈发频繁，赤心早已今非昔比的传言四处流传。\
	旅人时常警告赤心已然陷落，秘密邪教徒的传闻也并不罕见。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/magos
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_COURT

	traits_applied = list(TRAIT_ARCYNE, TRAIT_INTELLECTUAL, TRAIT_ALCHEMY_EXPERT, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_STR = -2,
		STATKEY_CON = -2,
	)

	subclass_mage_aspects = list("mastery" = TRUE, "major" = 1, "minor" = 3, "utilities" = 9, "ward" = TRUE)

	subclass_skills = list(
	/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
	/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
	/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
	/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/heartfelt/retinue/magos/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/talkstone
	cloak = /obj/item/clothing/cloak/black_cloak
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/storage/magebag/starter
	id = /obj/item/clothing/ring/gold
	r_hand = /obj/item/rogueweapon/woodstaff/implement/greater
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/rogueweapon/spellbook/greater = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne = 1,
		/obj/item/scrying = 1,
		/obj/item/chalk = 1,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.change_stat("speed", -1)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
	if(ishumannorthern(H))
		belt = /obj/item/storage/belt/rogue/leather/plaquegold
		cloak = null
		head = /obj/item/clothing/head/roguetown/wizhat
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/wizard
		H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
