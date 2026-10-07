/client/proc/jumptoarea(area/A in GLOB.sortedAreas)
	set name = "跳转至区域"
	set desc = ""
	set category = "-管理-"
	if(!src.holder)
//		//to_chat(src, "Only administrators may use this command.")
		return

	if(!A)
		return

	var/list/turfs = list()
	for(var/turf/T in A)
		if(T.density)
			continue
		turfs.Add(T)

	var/turf/T = safepick(turfs)
	if(!T)
		to_chat(src, "没有可跳转的位置！")
		return
	usr.forceMove(T)
	log_admin("[key_name(usr)] jumped to [AREACOORD(A)]")
	message_admins("[key_name_admin(usr)] 跳转至 [AREACOORD(A)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Area") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptoturf(turf/T in world)
	set name = "跳转至地块"
	set category = "-管理-"
	if(!src.holder)
//		//to_chat(src, "Only administrators may use this command.")
		return

	log_admin("[key_name(usr)] jumped to [AREACOORD(T)]")
	message_admins("[key_name_admin(usr)] 跳转至 [AREACOORD(T)]")
	usr.forceMove(T)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Turf") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/jumptomob(mob/M in GLOB.mob_list)
	set category = "-管理-"
	set name = "跳转至生物"

	if(!src.holder)
		//to_chat(src, "Only administrators may use this command.")
		return

	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] 跳转至 [AREACOORD(M)] 的 [ADMIN_LOOKUPFLW(M)]")
	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = get_turf(M)
		if(T && isturf(T))
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			A.forceMove(M.loc)
		else
			to_chat(A, "该生物不在游戏世界中。")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "-管理-"
	set name = "跳转至坐标"

	if (!holder)
		//to_chat(src, "Only administrators may use this command.")
		return

	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = locate(tx,ty,tz)
		A.forceMove(T)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Coordiate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins("[key_name_admin(usr)] 跳转至坐标 [tx], [ty], [tz]")

/client/proc/jumptokey()
	set category = "-管理-"
	set name = "跳转至玩家"

	if(!src.holder)
		//to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input("请选择一名玩家！", "管理员跳转", null, null) as null|anything in sortKey(keys)
	if(!selection)
		to_chat(src, "未找到玩家账号。")
		return
	var/mob/M = selection.mob
	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] 跳转至 [ADMIN_LOOKUPFLW(M)]")

	usr.forceMove(M.loc)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Key") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Getmob(mob/M in GLOB.mob_list - GLOB.dummy_mob_list)
	set category = "-管理-"
	set name = "传送生物至此"
	set desc = ""
	if(!src.holder)
		//to_chat(src, "Only administrators may use this command.")
		return

	var/atom/loc = get_turf(usr)
	log_admin("[key_name(usr)] teleported [key_name(M)] to [AREACOORD(loc)]")
	var/msg = "[key_name_admin(usr)] 将 [ADMIN_LOOKUPFLW(M)] 传送至 [ADMIN_VERBOSEJMP(loc)]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	M.forceMove(loc)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Get Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Getkey()
	set category = "-管理-"
	set name = "传送玩家至此"
	set desc = ""

	if(!src.holder)
		//to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input("请选择一名玩家！", "管理员跳转", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	var/mob/M = selection.mob

	if(!M)
		return
	log_admin("[key_name(usr)] teleported [key_name(M)]")
	var/msg = "[key_name_admin(usr)] 传送了 [ADMIN_LOOKUPFLW(M)]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	if(M)
		M.forceMove(get_turf(usr))
		usr.forceMove(M.loc)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Get Key") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/sendmob(mob/M in sortmobs())
	set category = "-管理-"
	set name = "传送生物至区域"
	if(!src.holder)
		//to_chat(src, "Only administrators may use this command.")
		return
	var/area/A = input(usr, "选择一个区域。", "选择区域") in GLOB.sortedAreas|null
	if(A && istype(A))
		if(M.forceMove(safepick(get_area_turfs(A))))

			log_admin("[key_name(usr)] teleported [key_name(M)] to [AREACOORD(A)]")
			var/msg = "[key_name_admin(usr)] 将 [ADMIN_LOOKUPFLW(M)] 传送至 [AREACOORD(A)]"
			message_admins(msg)
			admin_ticket_log(M, msg)
		else
			to_chat(src, "无法将生物移动到有效位置。")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Send Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
