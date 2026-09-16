/datum/migrant_wave/gronn
	name = "格隆恩劫掠队"
	max_spawns = 1
	weight = 40
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/gronn/chieftain = 1,
	)
	optional_roles = list(
		/datum/migrant_role/gronn/shaman = 1,
		/datum/migrant_role/gronn/warrior = 3,
		/datum/migrant_role/gronn/tribal = 4,
		/datum/migrant_role/gronn/slave = 4,
	)
	min_optional_fills = 0
	greet_text = "你们是一支直接从格隆恩草原派出的侦察队。失去了主力战帮的支援，在这片陌生之地，你们还能活下去，甚至兴旺起来吗？"
