/datum/quest_faction/drow
	id = QUEST_FACTION_DROW
	name_singular = "卓尔劫掠者"
	name_plural = "卓尔劫掠者"
	group_word = "巡逻队"
	faction_tag = FACTION_DROW
	can_blockade = TRUE
	category = FACTION_CAT_DROW
	mob_types = list(
		/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 70,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 5,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/elf/dark/drowraider/scourge = 100
	)
	boss_title_templates = list(
		"%N 淬毒者",
		"%N 暗影者",
		"主母 %N",
		"%N 蛛裔",
	)
	boss_name_file = "strings/rt/names/elf/elfdm.txt"
