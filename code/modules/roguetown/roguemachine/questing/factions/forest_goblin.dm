/datum/quest_faction/forest_goblin
	id = QUEST_FACTION_FOREST_GOBLIN
	name_singular = "野性哥布林"
	name_plural = "野性哥布林"
	group_word = "帮"
	faction_tag = FACTION_ORCS
	can_blockade = FALSE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush = 90,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 5,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 100,
	)
	boss_title_templates = list(
		"%N 酋长",
		"格鲁格-%N",
		"%N-咬人者",
		"大块头 %N",
	)
	boss_name_file = "strings/rt/names/other/goblinm.txt"
