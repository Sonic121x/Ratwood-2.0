/datum/migrant_wave/unknightly_heretic_journey
	name = "叛誓之旅"
	max_spawns = 1
	weight = 20
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/ukj_dark_itinerant = 1,
		/datum/migrant_role/ukj_varlet = 1,
	)
	optional_roles = list(
		/datum/migrant_role/ukj_dark_chaplain = 1,
	)
	min_optional_fills = 0
	greet_text = "一位背弃誓言的骑士带着扈从来到这片土地，如今已宣誓效忠飞升者。十神与普赛顿的信徒尽管祈祷吧，那救不了他们。"
