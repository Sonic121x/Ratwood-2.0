/datum/language/drone
	name = "Drone"
	desc = ""
	speech_verb = "唧唧地说"
	ask_verb = "好奇地唧唧叫"
	exclaim_verb = "大声唧唧叫"
	spans = list(SPAN_ROBOT)
	key = "9"
	flags = NO_STUTTER
	syllables = list(".", "|")
	// ...|..||.||||.|.||.|.|.|||.|||
	space_chance = 0
	sentence_chance = 0
	default_priority = 20

	icon_state = "drone"
