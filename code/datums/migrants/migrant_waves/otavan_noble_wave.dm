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
	greet_text = "你是奥塔万外交使团的一员：一支由少数随员和一位普赛顿传教士组成的队伍，随时准备代表祖国出使。"
