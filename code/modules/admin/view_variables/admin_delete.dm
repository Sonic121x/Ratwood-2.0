/client/proc/admin_delete(datum/D)
	var/atom/A = D
	var/coords = ""
	var/jmp_coords = ""
	if(istype(A))
		var/turf/T = get_turf(A)
		if(T)
			coords = "at [COORD(T)]"
			jmp_coords = "at [ADMIN_COORDJMP(T)]"
		else
			jmp_coords = coords = "in nullspace"

	if (alert(src, "确定删除以下对象吗？\n[D]\n[coords]", "确认", "是", "否") == "是")
		log_admin("[key_name(usr)] deleted [D] [coords]")
		message_admins("[key_name_admin(usr)] 删除了 [D]（[jmp_coords]）")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Delete") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		if(isturf(D))
			var/turf/T = D
			T.ScrapeAway()
		else
			vv_update_display(D, "deleted", VV_MSG_DELETED)
			qdel(D)
			if(!QDELETED(D))
				vv_update_display(D, "deleted", "")
