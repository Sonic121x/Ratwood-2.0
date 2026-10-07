/client/proc/list_severed_heads()
	set name = "列出断头"
	set category = "-管理-"
	set desc = "显示所有与身体分离的玩家头颅、其中的意识及其位置。"
	if(!check_rights(R_ADMIN))
		return
	var/dat = "<B>玩家断头列表。</B><HR>"
	dat += "<table cellspacing=5><tr><th>角色</th><th>账号</th><th>占据者</th><th>位置</th></tr>"
	var/found = 0
	for(var/datum/mind/M in SSticker.minds)
		var/obj/item/bodypart/head/severed = M.severed_head_ref?.resolve()
		if(!severed)
			continue
		if(!severed.loc) // An attached head sits in nullspace, so this one is not loose
			continue
		found++
		var/turf/head_turf = get_turf(severed) // ADMIN_VERBOSEJMP expands into src.x, so it needs a var not a proc call
		var/list/nesting = list()
		for(var/atom/container as anything in get_nested_locs(severed))
			nesting += "[container]"
		var/where = length(nesting) ? "位于 [jointext(nesting, " 内，所在容器位于 ")] 内" : "在地上"
		var/occupant = "空"
		if(severed.brainmob)
			occupant = severed.brainmob.key ? "[severed.brainmob.key]" : "离线／已离魂"
		else if(severed.brain)
			occupant = "有大脑，无心智"
		if(severed.brainkill)
			occupant += " （脑死亡）"
		dat += "<tr><td>[M.name] [ADMIN_VV(severed)]</td><td>[M.key ? M.key : "无账号"]</td><td>[occupant]</td><td>[where], [ADMIN_VERBOSEJMP(head_turf)]</td></tr>"
	if(!found)
		dat += "<tr><td colspan=4>没有玩家断头。</td></tr>"
	dat += "</table>"
	usr << browse(dat, "window=severed_heads;size=700x500")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "List Severed Heads")
