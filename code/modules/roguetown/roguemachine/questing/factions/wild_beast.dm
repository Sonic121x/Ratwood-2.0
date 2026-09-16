/datum/quest_faction/wild_beast
	id = QUEST_FACTION_WILD_BEAST
	name_singular = "野兽"
	name_plural = "野兽"
	group_word = "兽群"
	faction_tag = FACTION_WOLFS
	category = FACTION_CAT_BEAST
	progress_noun = "野兽"
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/fox = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 5,
	)
	crime_weights = list(
		CRIME_BEAST_SHEEP = 10,
		CRIME_BEAST_CATTLE = 6,
		CRIME_BEAST_TRAVELLER = 6,
		CRIME_BEAST_DOGS = 4,
		CRIME_BEAST_WINTER = 4,
		CRIME_BEAST_CORPSE = 3,
		CRIME_BEAST_CHILD = 2,
	)
