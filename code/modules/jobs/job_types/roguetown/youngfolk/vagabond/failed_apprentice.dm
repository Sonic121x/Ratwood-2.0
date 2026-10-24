/datum/advclass/vagabond_mage
	name = "放逐学徒"
	tutorial = "你的导师认定你毫无天赋，于是把你连同那根法杖和对未竟前程的妄想一起赶出了高塔。"
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/vagabond/mage
	traits_applied = list(TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT)
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_CON = -2,
		STATKEY_WIL = -2,
		STATKEY_SPD = -1
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 2, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "包含随机技能与属性。"

/datum/outfit/job/roguetown/vagabond/mage/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/half/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	r_hand = /obj/item/rogueweapon/woodstaff
	l_hand = /obj/item/rogueweapon/spellbook
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
	/obj/item/chalk = 1
	)

	if(H.mind)
		H.adjust_skillrank(/datum/skill/craft/alchemy, rand(1,4), TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, rand(1,4), TRUE)
		H.STAINT = rand(8, 20)
		H.STACON = rand(5, 10)
