




/mob/proc/show_triumphs_list()
	return SStriumphs.show_triumph_leaderboard(src.client)

/mob/proc/get_triumphs()
	if(!ckey)
		return
	return SStriumphs.get_triumphs(ckey)

/client/proc/adjusttriumph()
	set category = "-特殊指令-"
	set name = "调整自身凯旋点"
	var/input = input(src, "要调整多少？") as num
	if(mob && input)
		mob.adjust_triumphs(input)





