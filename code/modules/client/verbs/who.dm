
/client/verb/who()
	set name = "在线玩家"
	set category = "Options"

	var/msg = ""

	var/list/Lines = list()

	var/wled = 0
	if(holder)
		to_chat(src, span_info("Loading Whom, please wait..."))
//		if (check_rights(R_ADMIN,0) )//If they have +ADMIN and are a ghost they can see players IC names and statuses.
//			var/mob/dead/observer/G = src.mob
//			if(!G.started_as_observer)//If you aghost to do this, KorPhaeron will deadmin you in your sleep.
//				log_admin("[key_name(usr)] checked advanced who in-round")
		for(var/client/C in GLOB.clients)
			var/entry = "<span class='info'>\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			if (isnewplayer(C.mob))
				entry += " - <font color='darkgray'><b>In Lobby</b></font>"
				if(C.ckey in GLOB.anonymize)
					entry += " (as [get_fake_key(C.ckey)])"
			else
				if(ishuman(C.mob))
					var/mob/living/carbon/human/H = C.mob
					entry += " - Playing as [C.mob.real_name][H.job ? " ([H.job])" : ""]"
				else
					entry += " - Playing as [C.mob.real_name]"
				switch(C.mob.stat)
					if(UNCONSCIOUS)
						entry += " - <font color='darkgray'><b>UNCON</b></font>"
					if(DEAD)
						if(isobserver(C.mob))
							var/mob/dead/observer/O = C.mob
							if(O.started_as_observer)
								entry += " - <font color='gray'>Observing</font>"
							else
								entry += " - <b>GHOST</b>"
						else
							entry += " - <b>DEAD</b>"
				if(C.mob.mind)
					if(C.mob.mind.special_role)
						entry += " - <b><font color='red'>[C.mob.mind.special_role]</font></b>"
//			entry += " [ADMIN_QUE(C.mob)]"

			// entry += " ([CheckIPCountry(C.address)])"
			if(C.whitelisted())
				wled++
				entry += "(WL)"
			entry += "</span>"
			Lines += entry
/*		else//If they don't have +ADMIN
			for(var/client/C in GLOB.clients)
//				var/WL = FALSE
				if(C.whitelisted())
					wled++
//					WL = TRUE
//				if(C.holder)
//					continue
//				var/usedkey = C.ckey
//				if(C.ckey in GLOB.anonymize)
//					usedkey = get_fake_key(C.ckey)
/*				if(WL)
					Lines += span_biginfo("[C.key][hidden ? " (as [get_fake_key(C.ckey)])" : ""]")
				else
					Lines += span_info("[C.key][hidden ? " (as [get_fake_key(C.ckey)])" : ""]")*/
				var/entry = span_info("[usedkey]")
				entry += " ([CheckIPCountry(C.address)])"
				Lines += entry*/
	else
		for(var/client/C in GLOB.clients)
//			var/WL = FALSE
			if(C.whitelisted())
				wled++
//				WL = TRUE
//			if(C.holder)
//				continue
			var/usedkey = C.key
			if(C.ckey in GLOB.anonymize)
				usedkey = get_fake_key(C.ckey)
/*			if(WL)
				Lines += span_biginfo("[usedkey]")
			else
				Lines += span_info("[usedkey]")*/
			Lines += span_info("[usedkey]")
//	if(holder && check_rights(R_ADMIN,0)) //thius is the part where admins see the lines but nobody else
	for(var/line in sortList(Lines))
		msg += "[line]\n"
//#else
//	for(var/line in sortList(Lines))
//		msg += "[line]\n"
	msg += "<b>在席玩家:</b> [length(Lines)]"
	if(holder)
		msg += "<br><b>Whitelisted players:</b> [wled]"
	to_chat(src, msg)

/client/verb/adminwho()
	set category = "-Admin-"
	set name = "Adminwho"
	set desc = "列出当前在线的所有管理员。"

	var/msg = "<b>当前在线管理员:</b>\n"
	if(holder)
		for(var/client/C in GLOB.admins)
			msg += "\t[C] is a [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(isnewplayer(C.mob))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
	else
		for(var/client/C in GLOB.admins)
			if(C.is_afk())
				continue //Don't show afk admins to adminwho
			if(!C.holder.fakekey)
				msg += "\t[C]的权限组为[C.holder.rank]\n"
		msg += span_info("管理员求助也会发送至IRC。即使游戏中没有管理员在线，你仍可提交求助，IRC上的管理员可以看到并回复。")
	to_chat(src, msg)

