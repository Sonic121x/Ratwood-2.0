/datum/quest_faction/bleakisle_reaver
	id = QUEST_FACTION_BLEAKISLE_REAVER
	name_singular = "荒岛劫掠者"
	name_plural = "荒岛劫掠者"
	group_word = "战团"
	faction_tag = FACTION_GRONNMEN
	can_blockade = TRUE
	category = FACTION_CAT_GRONN
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 60,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
		/mob/living/carbon/human/species/human/northern/bog_deserters/ambush = 10,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 100,
	)
	boss_title_templates = list(
		"%N 盐骨",
		"%N 誓涛者",
		"%N 船长",
		"%N 灰岛之主",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
