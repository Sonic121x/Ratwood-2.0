/datum/antagonist/wretch
	name = "流放者"
	roundend_category = "流放者"
	antagpanel_category = "流放者"
	show_name_in_check_antagonists = FALSE

/datum/antagonist/wretch/get_antag_cap_weight()
	return 0.5

/datum/antagonist/wretch/on_gain()
	. = ..()
	if(owner)
		owner.special_role = "Wretch"

/datum/antagonist/wretch/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null
