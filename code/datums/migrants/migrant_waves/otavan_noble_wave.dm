/datum/migrant_wave/otavan_envoy
	name = "奥塔万使团"
	max_spawns = 1
	weight = 50
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/otavan/envoy = 1,
	)
	optional_roles = list(
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
		/datum/migrant_role/otavan/scribe = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	min_optional_fills = 0
	greet_text = "你是奥塔万外交使团的一员：一支小规模随从，外加一位普赛顿传教士，随时准备代表你的祖国。"
