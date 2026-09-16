/datum/migrant_wave/knightly_journey
	name = "骑士之旅"
	max_spawns = 1
	weight = 50
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/kj_knight = 1,
		/datum/migrant_role/kj_squire = 1,
	)
	optional_roles = list(
		/datum/migrant_role/kj_chaplain = 1,
		/datum/migrant_role/kj_follower = 2,
	)
	min_optional_fills = 0
	greet_text = "一位久经沙场的游侠骑士策马驶入这片土地，他的侍从已入行数年，不再是个新手。前路尚有战斗，也有值得传颂的功业。"
