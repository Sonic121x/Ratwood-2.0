/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/roguetest
	map_file_name = "roguetest.dmm"
	realm_name = "罗格测试"
	slot_adjust = list(
		/datum/job/roguetown/villager = 42,
		/datum/job/roguetown/adventurer = 69
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "城守大人", f_title = "女城主")
	)
	tutorial_adjust = list(
		/datum/job/roguetown/lord = "格隆人来了。"
	)
	blacklist = list(
		/datum/job/roguetown/slaver,
		/datum/job/roguetown/rockhillslave,
		/datum/job/roguetown/baron,
		/datum/job/roguetown/baron_retainer,
	)
