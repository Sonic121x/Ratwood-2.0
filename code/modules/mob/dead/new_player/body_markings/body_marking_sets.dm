/datum/body_marking_set
	///The preview name of the body marking set. HAS to be unique
	var/name
	///List of the body markings in this set
	var/body_marking_list

/datum/body_marking_set/none
	name = "无"
	body_marking_list = list()

/datum/body_marking_set/gradient
	name = "渐变"
	body_marking_list = list(
		/datum/body_marking/gradient
		)

/datum/body_marking_set/socks
	name = "袜状"
	body_marking_list = list(
		/datum/body_marking/sock
		)

/datum/body_marking_set/belly
	name = "腹部"
	body_marking_list = list(
		/datum/body_marking/belly
		)

/datum/body_marking_set/bellysocks
	name = "腹部与袜状"
	body_marking_list = list(
		/datum/body_marking/belly,
		/datum/body_marking/sock,
	)

/datum/body_marking_set/bellysockstertiary
	name = "腹部与袜状"
	body_marking_list = list(
		/datum/body_marking/belly,
		/datum/body_marking/sock/tertiary,
	)

/datum/body_marking_set/bellyscale
	name = "腹鳞"
	body_marking_list = list(
		/datum/body_marking/bellyscale
	)

/datum/body_marking_set/kobold_scale
	name = "狗头人鳞片"
	body_marking_list = list(
		/datum/body_marking/kobold_scale
	)

/datum/body_marking_set/tiger
	name = "虎纹"
	body_marking_list = list(
		/datum/body_marking/tiger
	)

/datum/body_marking_set/tiger_dark
	name = "虎纹（深色）"
	body_marking_list = list(
		/datum/body_marking/tiger/dark
	)

//MOTH

/datum/body_marking_set/moth

/datum/body_marking_set/moth/reddish
	name = "淡红"
	body_marking_list = list(/datum/body_marking/moth/reddish)

/datum/body_marking_set/moth/royal
	name = "皇家"
	body_marking_list = list(/datum/body_marking/moth/royal)

/datum/body_marking_set/moth/gothic
	name = "哥特"
	body_marking_list = list(/datum/body_marking/moth/gothic)

/datum/body_marking_set/moth/whitefly
	name = "白蝇"
	body_marking_list = list(/datum/body_marking/moth/whitefly)

/datum/body_marking_set/moth/burnt_off
	name = "烧焦"
	body_marking_list = list(/datum/body_marking/moth/burnt_off)

/datum/body_marking_set/moth/deathhead
	name = "骷髅天蛾"
	body_marking_list = list(/datum/body_marking/moth/deathhead)

/datum/body_marking_set/moth/poison
	name = "毒纹"
	body_marking_list = list(/datum/body_marking/moth/poison)

/datum/body_marking_set/moth/ragged
	name = "残破"
	body_marking_list = list(/datum/body_marking/moth/ragged)

/datum/body_marking_set/moth/moonfly
	name = "月蛾"
	body_marking_list = list(/datum/body_marking/moth/moonfly)

/datum/body_marking_set/moth/oakworm
	name = "橡木蚕"
	body_marking_list = list(/datum/body_marking/moth/oakworm)

/datum/body_marking_set/moth/jungle
	name = "丛林"
	body_marking_list = list(/datum/body_marking/moth/jungle)

/datum/body_marking_set/moth/witchwing
	name = "巫翼"
	body_marking_list = list(/datum/body_marking/moth/witchwing)

/datum/body_marking_set/moth/lovers
	name = "恋人"
	body_marking_list = list(/datum/body_marking/moth/lovers)

//////////////
/// HARPY ///
////////////

/datum/body_marking_set/harpy_feet_claws
	name = "足爪"
	body_marking_list = list(
		/datum/body_marking/harpy_feet_claws
	)

/datum/body_marking_set/harpy_leg
	name = "哈比腿部颜色覆盖"
	body_marking_list = list(
		/datum/body_marking/harpy_leg
	)
