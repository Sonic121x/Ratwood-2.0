/datum/migrant_wave/fablefield
	name = "Fablefield剧团"
	track = MIGRANT_TRACK_SPECIAL
	max_spawns = 1
	weight = 20
	required_roles = list(
		/datum/migrant_role/fablefield/goliard = 1,
	)
	optional_roles = list(
		/datum/migrant_role/fablefield/troubadour = 3,
	)
	min_optional_fills = 0
	greet_text = "你们是一支来自美丽 Fablefield 的吟游艺人剧团，为寻求灵感而来到谷地，仿佛每一步都受 Xylix 的奇思所牵引。这里的人们看起来正需要一场精彩演出，那就给他们留下一场永生难忘的表演吧！"
