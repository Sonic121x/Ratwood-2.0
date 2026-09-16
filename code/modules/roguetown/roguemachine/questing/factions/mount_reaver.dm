/datum/quest_faction/mount_reaver
	id = QUEST_FACTION_MOUNT_REAVER
	name_singular = "骑乘劫掠者"
	name_plural = "骑乘劫掠者"
	group_word = "帮"
	faction_tag = FACTION_BANDITS
	can_blockade = TRUE
	category = FACTION_CAT_HUMANOID
	// Ratwood deviation: AP's /highwayman/mount_reaver (mounted elite) has no ES equivalent; the raiding
	// core is stood in by searaiders so the warband keeps two distinct types instead of collapsing.
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 70,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 100,
	)
	boss_title_templates = list(
		"%N 铁甲者",
		"%N 碎石者",
		"%N 熊",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
