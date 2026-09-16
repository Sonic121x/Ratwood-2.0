/datum/migrant_wave/goldcaravan
	name = "EA-Hasir的黄金商队"
	max_spawns = 1
	weight = 40
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/ea_hasir/merchant = 1,
	)
	optional_roles = list(
		/datum/migrant_role/ea_hasir/guard = 2,
	)
	min_optional_fills = 0
	greet_text = "备受尊崇的 EA Hasir 派出了你们这支黄金商队，只承诺提供格里莫里亚中最上乘的黄金。\
	去把你们金光闪闪的财富与奇珍异宝卖出高价吧。"
