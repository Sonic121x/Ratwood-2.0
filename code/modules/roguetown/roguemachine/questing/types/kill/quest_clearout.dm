/datum/quest/kill/clearout
	quest_type = QUEST_CLEAR_OUT
	tp_budget = QUEST_TP_BUDGET_CLEAR_OUT
	threat_bands_cleared = QUEST_BANDS_CLEAR_OUT

/datum/quest/kill/clearout/get_title()
	if(title)
		return title
	if(!faction)
		return "清剿一窝魔物"
	return "清剿[faction.group_word][faction.name_plural]"

/datum/quest/kill/clearout/get_objective_text()
	if(!faction)
		return "消灭约 [progress_required] [initial(target_mob_type.name)]。"
	return "消灭约 [progress_required] 名[faction.name_plural]。"

/datum/quest/kill/clearout/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)
	return TRUE
