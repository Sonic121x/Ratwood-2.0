/datum/migrant_wave/czwarteki_noble
	name = "兹瓦尔特基随行队"
	max_spawns = 1
	weight = 50
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/czwarteki/lord = 1,
	)
	optional_roles = list(
		/datum/migrant_role/czwarteki/heir = 1,
		/datum/migrant_role/czwarteki/hussar = 2,
		/datum/migrant_role/czwarteki/retainer = 4,
		/datum/migrant_role/czwarteki/servant = 2,
	)
	min_optional_fills = 0
	greet_text = "你是兹瓦尔特基领主麾下随行队的一员，无论是为外交、战争，还是仅仅穿越谷地去探望或援助一位旧盟友。"
