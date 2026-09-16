/datum/quest_faction/moon_goblin
	id = QUEST_FACTION_MOON_GOBLIN
	name_singular = "月辉哥布林"
	name_plural = "月辉哥布林"
	group_word = "战团"
	faction_tag = FACTION_ORCS
	can_blockade = FALSE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 80,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 10,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 100,
	)
	boss_title_templates = list(
		"月酋长 %N",
		"%N-居暗者",
		"%N 苍白者",
		"%N 地窟之主",
	)
	boss_name_file = "strings/rt/names/other/goblinm.txt"
