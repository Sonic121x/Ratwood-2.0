/datum/migrant_wave/heartfelt
	name = "赤心宫廷"
	max_spawns = 1
	weight = 50
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
	)
	optional_roles = list(
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 5,
	)
	min_optional_fills = 0
	greet_text = "你是赤心的强大男爵，谷地的边陲封臣。无论是因为边境遭侵、单纯想四处游历、造访谷地，还是出于只有你与你宫廷知晓的政治图谋，你都带着一支精选的精锐随从，前来造访谷地。"
	greet_text_by_fill = list(
		"5" = "你是赤心的强大男爵，谷地的边陲封臣。无论是因为边境遭侵、单纯想四处游历、造访谷地，还是出于只有你与你宫廷知晓的政治图谋，你都带着一支精选的精锐随从，前来造访谷地。",
		"3" = "你是赤心的强大男爵，谷地的边陲封臣。无论是因为边境遭侵、单纯想四处游历、造访谷地，还是出于只有你与你宫廷知晓的政治图谋，你都带着一支精选的精锐随从，前来造访谷地。只可惜，你随从中似乎有几人忘了带行李，只得折返。",
	)
