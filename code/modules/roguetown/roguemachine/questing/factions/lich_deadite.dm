/datum/quest_faction/lich_deadite
	id = QUEST_FACTION_LICH_DEADITE
	name_singular = "巫妖缚尸鬼"
	name_plural = "巫妖缚尸鬼"
	group_word = "行尸"
	faction_tag = FACTION_LICH
	can_blockade = TRUE
	category = FACTION_CAT_UNDEAD
	mob_types = list(
		/mob/living/carbon/human/species/skeleton/npc/mediumspread = 50,
		/mob/living/carbon/human/species/skeleton/npc/hardspread = 50,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/skeleton/npc/dungeon/lich = 100,
	)
	boss_title_templates = list(
		"%N 不眠者",
		"%N 受缚者",
		"爵士 %N",
		"%N 背誓者",
	)
	boss_name_file = "strings/rt/names/other/deaditenpcfirst.txt"
