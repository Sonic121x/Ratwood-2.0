/datum/job/roguetown/archivist
	title = "Archivist"
	tutorial = "你谨慎地保存并整理古老卷轴与典籍，将这片土地累积的知识封存下来，留待后世承继。无论贵族还是农夫，都会为了历史与事实前来向你求证；而你为本周诸事留下的详尽记录，终将成为公爵仁德与领地繁荣的见证……又或者并非如此。毕竟，真正握着权力的人是你：由你来决定后世会如何回望这些时日。"
	flag = ARCHIVIST
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	spells = list()
	vice_restrictions = list(/datum/charflaw/unintelligible)
	allowed_races = ACCEPTED_RACES
	allowed_ages = ALL_AGES_LIST
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'

	outfit = /datum/outfit/job/roguetown/archivist
	display_order = JDO_ARCHIVIST
	give_bank_account = 15
	min_pq = 1 // Please do not read smut while brewing bottle bombs. It upsets the maids when they have to scrape archivists off the ceiling.
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN
	job_traits = list(
		TRAIT_INTELLECTUAL,
		TRAIT_SEEPRICES_SHITTY,
		TRAIT_GOODWRITER,
		TRAIT_MEDICINE_EXPERT,
		TRAIT_ALCHEMY_EXPERT,
		TRAIT_SMITHING_EXPERT,
		TRAIT_SEWING_EXPERT,
		TRAIT_SURVIVAL_EXPERT,
		TRAIT_HOMESTEAD_EXPERT, // Archivist teaches everyone everything.
		)
	advclass_cat_rolls = list(CTAG_ARCHIVIST = 2)
	job_subclasses = list(
		/datum/advclass/archivist
	)

/datum/advclass/archivist
	name = "档案官"
	tutorial = "你谨慎地保存并整理古老卷轴与典籍，将这片土地累积的知识封存下来，留待后世承继。无论贵族还是农夫，都会为了历史与事实前来向你求证；而你为本周诸事留下的详尽记录，终将成为公爵仁德与领地繁荣的见证……又或者并非如此。毕竟，真正握着权力的人是你：\
	由你来决定后世会如何回望这些时日。"
	outfit = /datum/outfit/job/roguetown/archivist/basic
	subclass_languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/orcish,
		/datum/language/grenzelhoftian,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/kazengunese,
		/datum/language/draconic,
		/datum/language/aavnic, // All but beast, which is associated with werewolves.
	)
	category_tags = list(CTAG_ARCHIVIST)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_CON = -1,
		STATKEY_STR = -1
	)
	age_mod = /datum/class_age_mod/archivist
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 2, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_LEGENDARY,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/archivist/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/robe/archivist
		head	= /obj/item/clothing/head/roguetown/roguehood/black
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/robe/archivist
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
		pants = /obj/item/clothing/under/roguetown/tights/black
		head = /obj/item/clothing/head/roguetown/nightman
	backr = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/archivist
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	mask = /obj/item/clothing/mask/rogue/spectacles
	id = /obj/item/scomstone/bad
	backpack_contents = list(
		/obj/item/recipe_book/alchemy,
		/obj/item/skillbook/unfinished, //give the book man a starter book, enough paper for 3 pages, and a writing instrument to get him started
		/obj/item/natural/feather,
		/obj/item/paper,
		/obj/item/paper,
		/obj/item/paper,
		/obj/item/rogueweapon/spellbook
	)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/teach)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/refocusstudies)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/takeapprentice)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/learn)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/silence/archivist_silence)
