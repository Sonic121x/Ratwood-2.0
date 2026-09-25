/datum/round_event_control/antagonist/migrant_wave/evil_knight
	name = "The Unknightly journey"
	wave_type = /datum/migrant_wave/evil_knight

	weight = 6
	max_occurrences = 1

	earliest_start = 10 MINUTES

	tags = list(
		TAG_HAUNTED,
		TAG_COMBAT,
		TAG_VILLIAN,
	)

/datum/migrant_wave/evil_knight
	name = "邪恶骑士之旅"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/evil_knight
	weight = 8
	required_roles = list(
		/datum/migrant_role/dark_itinerant_knight = 1,
		/datum/migrant_role/dark_itinerant_squire = 1,
	)
	greet_text = "这片土地上的人再度亵渎了齐佐，你们前来让他们铭记她的威能。"

/datum/migrant_role/dark_itinerant_knight
	name = "齐佐骑士"
	role_category = "Adventurer"
	greet_text = "你是一名邪恶的游历骑士，与侍从一同踏上旅途，要让混乱吞噬这片土地。"
	antag_datum = /datum/antagonist/zizo_knight
	grant_lit_torch = TRUE

/datum/migrant_role/dark_itinerant_squire
	name = "邪恶骑士侍从"
	role_category = "Adventurer"
	greet_text = "你是一名邪恶骑士的侍从。你是唯一不反对其卑劣行径的人，因此被收留在麾下。"
	antag_datum = /datum/antagonist/zizo_knight/squire
	grant_lit_torch = TRUE

