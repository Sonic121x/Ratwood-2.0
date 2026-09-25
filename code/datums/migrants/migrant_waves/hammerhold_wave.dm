/datum/migrant_wave/hammerhold
	name = "铁锤堡劫掠队"
	max_spawns = 1
	weight = 40
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/hammerhold/jarl = 1,
	)
	optional_roles = list(
		/datum/migrant_role/hammerhold/tideweaver = 1,
		/datum/migrant_role/hammerhold/volfskin = 1,
		/datum/migrant_role/hammerhold/huscarl = 4,
		/datum/migrant_role/hammerhold/thrall = 4,
	)
	min_optional_fills = 0
	greet_text = "你们是来自铁锤堡的侦察队，立誓效忠于领主与持环者。在这片异乡建立据点，为日后的劫掠铺路，或许还能抢先夺取财富、招揽信徒并掳获奴隶。"
