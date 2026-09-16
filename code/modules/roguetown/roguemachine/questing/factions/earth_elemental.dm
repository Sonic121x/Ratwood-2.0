/datum/quest_faction/earth_elemental
	id = QUEST_FACTION_EARTH_ELEMENTAL
	name_singular = "土元素"
	name_plural = "土元素"
	group_word = "群"
	progress_noun = "元素"
	faction_tag = "earth_elemental"
	can_blockade = FALSE
	category = FACTION_CAT_ELEMENTAL
	allowed_quest_types = list(QUEST_TOWNER_MINER_OREVEIN)
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler = 60,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden = 35,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth = 5,
	)
