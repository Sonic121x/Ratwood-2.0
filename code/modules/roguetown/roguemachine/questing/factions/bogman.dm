/datum/quest_faction/bogman
	id = QUEST_FACTION_BOGMAN
	name_singular = "沼泽人"
	name_plural = "沼泽人"
	group_word = "战团"
	faction_tag = FACTION_BANDITS
	can_blockade = TRUE
	category = FACTION_CAT_BOG_DESERTER
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/ambush = 80,
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 100,
	)
	boss_title_templates = list(
		"%N 军士",
		"%N 队长",
		"%N 沼泽人",
		"%N 涉沼者",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
