/datum/migrant_wave/slaver
	name = "兹班图奴隶贩子"
	max_spawns = 1
	weight = 60
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/slaver/master = 1,
	)
	optional_roles = list(
		/datum/migrant_role/slaver/slavemerc = 6,
		/datum/migrant_role/slaver/slavez = 4,
	)
	min_optional_fills = 1
	greet_text = "一支从兹班图沙漠来到大陆的奴隶贩子队伍，希望通过买卖那些不幸劳工来聚敛财富。"
