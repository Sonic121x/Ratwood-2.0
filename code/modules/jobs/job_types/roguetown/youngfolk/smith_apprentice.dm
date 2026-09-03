/datum/job/roguetown/gapprentice
	title = "Guild Apprentice"
	display_title = "行会学徒"
	flag = GUILDAPPRENTICE
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)

	tutorial = "长时间的工作和累断腰的活儿甚至不足以描述你一天为师傅所做的四分之一。这活儿又累又脏，你也没多少空闲时间——但有朝一日你会拥有自己的铁匠铺，到那时你收的学徒会是你师傅的两倍。"

	outfit = /datum/outfit/job/roguetown/gapprentice
	display_order = JDO_GUILDAPPRENTICE
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_PEASANT

	advclass_cat_rolls = list(CTAG_GUILDAPPRENTICE = 2)
	job_subclasses = list(
		/datum/advclass/gapprentice
	)
	job_traits = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT)


/datum/advclass/gapprentice
	name = "行会学徒"
	tutorial = "长时间的工作和累断腰的活儿甚至不足以描述你一天为师傅所做的四分之一。这活儿又累又脏，你也没多少空闲时间——但有朝一日你会拥有自己的铁匠铺，到那时你收的学徒会是你师傅的两倍。"
	outfit = /datum/outfit/job/roguetown/gapprentice/basic
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	category_tags = list(CTAG_GUILDAPPRENTICE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list(//apprentice levels in all smithing/engineering section. Journeyman in smelting.
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN, // Apprentice has spent more time smelting then smithing or tinkering
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/gapprentice/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/roguekey/crafterguild
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/tongs = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		)
	if(H.gender == MALE)
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = null
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		cloak = /obj/item/clothing/cloak/apron/brown
