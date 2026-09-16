/datum/quest_faction/hell_goblin
	id = QUEST_FACTION_HELL_GOBLIN
	name_singular = "地狱哥布林"
	name_plural = "地狱哥布林"
	group_word = "战团"
	faction_tag = FACTION_INFERNAL
	can_blockade = FALSE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/hell = 55,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound = 12,
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher = 8,
	)
	boss_mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher = 60,
		/mob/living/carbon/human/species/goblin/npc/ambush/hell = 40,
	)
	boss_title_templates = list(
		"%N 守望者",
		"%N 余烬者",
		"%N 炭目者",
	)
	boss_name_file = "strings/rt/names/other/devilm.txt"
