//I wish we had interfaces sigh, and i'm not sure giving team and antag common root is a better solution here

//Name shown on antag list
/datum/antagonist/proc/antag_listing_name()
	if(!owner)
		return "未分配"
	if(owner.current)
		return "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(owner.current)]'>[owner.current.real_name]</a> "
	else
		return "<a href='?_src_=vars;[HrefToken()];Vars=[REF(owner)]'>[owner.name]</a> "

//Whatever interesting things happened to the antag admins should know about
//Include additional information about antag in this part
/datum/antagonist/proc/antag_listing_status()
	if(!owner)
		return "（未分配）"
	if(!owner.current)
		return "<font color=red>（身体已毁）</font>"
	else
		if(owner.current.stat == DEAD)
			return "<font color=red>（已死亡）</font>"
		else if(!owner.current.client)
			return "（未连接客户端）"

//Builds the common FLW PM TP commands part
//Probably not going to be overwritten by anything but you never know
/datum/antagonist/proc/antag_listing_commands()
	if(!owner)
		return
	var/list/parts = list()
	parts += "<a href='?priv_msg=[ckey(owner.key)]'>私信</a>"
	if(owner.current) //There's body to follow
		parts += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(owner.current)]'>跟随</a>"
	else
		parts += ""
	parts += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(owner)]'>显示目标</a>"
	return parts //Better as one cell or two/three

//Builds table row for the antag
// Jim (Status) FLW PM TP
/datum/antagonist/proc/antag_listing_entry()
	var/list/parts = list()
	if(show_name_in_check_antagonists)
		parts += "[antag_listing_name()]([name])"
	else
		parts += antag_listing_name()
	parts += antag_listing_status()
	parts += antag_listing_commands()
	return "<tr><td>[parts.Join("</td><td>")]</td></tr>"


/datum/team/proc/get_team_antags(antag_type,specific = FALSE)
	. = list()
	for(var/datum/antagonist/A in GLOB.antagonists)
		if(A.get_team() == src && (!antag_type || !specific && istype(A,antag_type) || specific && A.type == antag_type))
			. += A

//Builds section for the team
/datum/team/proc/antag_listing_entry()
	//NukeOps:
	// Jim (Status) FLW PM TP
	// Joe (Status) FLW PM TP
	//Disk:
	// Deep Space FLW
	var/list/parts = list()
	parts += "<b>[antag_listing_name()]</b><br>"
	parts += "<table cellspacing=5>"
	for(var/datum/antagonist/A in get_team_antags())
		parts += A.antag_listing_entry()
	parts += "</table>"
	parts += antag_listing_footer()
	return parts.Join()

/datum/team/proc/antag_listing_name()
	return name

/datum/team/proc/antag_listing_footer()
	return

//Moves them to the top of the list if TRUE
/datum/antagonist/proc/is_gamemode_hero()
	return FALSE

/datum/team/proc/is_gamemode_hero()
	return FALSE

/datum/admins/proc/build_antag_listing()
	var/list/sections = list()
	var/list/priority_sections = list()

	var/list/all_teams = list()
	var/list/all_antagonists = list()

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue
		all_teams |= A.get_team()
		all_antagonists += A

	for(var/datum/team/T in all_teams)
		for(var/datum/antagonist/X in all_antagonists)
			if(X.get_team() == T)
				all_antagonists -= X
		if(T.is_gamemode_hero())
			priority_sections += T.antag_listing_entry()
		else
			sections += T.antag_listing_entry()

	sortTim(all_antagonists, GLOBAL_PROC_REF(cmp_antag_category))

	var/current_category
	var/list/current_section = list()
	for(var/i in 1 to all_antagonists.len)
		var/datum/antagonist/current_antag = all_antagonists[i]
		var/datum/antagonist/next_antag
		if(i < all_antagonists.len)
			next_antag = all_antagonists[i+1]
		if(!current_category)
			current_category = current_antag.roundend_category
			current_section += "<b>[capitalize(current_category)]</b><br>"
			current_section += "<table cellspacing=5>"
		current_section += current_antag.antag_listing_entry() // Name - (Traitor) - FLW | PM | TP

		if(!next_antag || next_antag.roundend_category != current_antag.roundend_category) //End of section
			current_section += "</table>"
			if(current_antag.is_gamemode_hero())
				priority_sections += current_section.Join()
			else
				sections += current_section.Join()
			current_section.Cut()
			current_category = null
	var/list/all_sections = priority_sections + sections
	return all_sections.Join("<br>")

/datum/admins/proc/check_antagonists()
	if(!SSticker.HasRoundStarted())
		alert("游戏尚未开始！")
		return
	var/list/dat = list("<html><head><title>Round Status</title></head><body><h1><B>回合状态</B></h1>")
	dat += "<a href='?_src_=holder;[HrefToken()];gamemode_panel=1'>游戏模式面板</a><br>"
	dat += "回合时长：<B>[DisplayTimeText(world.time - SSticker.round_start_time)]</B><BR>"
	dat += "<BR>"
	dat += "<a href='?_src_=holder;[HrefToken()];end_round=[REF(usr)]'>立即结束回合</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];delay_round_end=1'>[SSticker.delay_end ? "正常结束回合" : "延迟回合结束"]</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];ctf_toggle=1'>启用/禁用夺旗模式</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];rebootworld=1'>重启世界</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];check_teams=1'>查看团队</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];check_hunted_targets=1'>豺狼人信息</a>"
	var/connected_players = GLOB.clients.len
	var/lobby_players = 0
	var/observers = 0
	var/observers_connected = 0
	var/living_players = 0
	var/living_players_connected = 0
	var/living_players_antagonist = 0
	var/brains = 0
	var/other_players = 0
	// var/living_skipped = 0
	// var/drones = 0
	for(var/mob/M in GLOB.mob_list)
		if(M.ckey)
			if(isnewplayer(M))
				lobby_players++
				continue
			else if(M.stat != DEAD && M.mind && !isbrain(M))
				// if(is_centcom_level(M.z))
				// 	living_skipped++
				// 	continue
				living_players++
				if(M.mind.special_role)
					living_players_antagonist++
				if(M.client)
					living_players_connected++
			else if(M.stat == DEAD || isobserver(M))
				observers++
				if(M.client)
					observers_connected++
			else if(isbrain(M))
				brains++
			else
				other_players++
	dat += "<BR><b><font color='blue' size='3'>玩家：|[connected_players - lobby_players] 人在游戏中|[connected_players] 人已连接|[lobby_players] 人在大厅|</font></b>"
	dat += "<BR><b><font color='green'>存活玩家：|[living_players_connected] 人在线|[living_players - living_players_connected] 人已断开连接|[living_players_antagonist] 人是反派|</font></b>"
	// dat += "<BR><b><font color='#bf42f4'>SKIPPED \[On centcom Z-level\]: [living_skipped] living players|[drones] living drones|</font></b>"
	dat += "<BR><b><font color='red'>死亡/观察玩家：|[observers_connected] 人在线|[observers - observers_connected] 人已断开连接|[brains] 个大脑|</font></b>"
	if(other_players)
		dat += "<BR><span class='danger'>有 [other_players] 位玩家状态无效，或统计代码存在问题！</span>"
	dat += "<br><br>"

	dat += build_antag_listing()

	dat += "</body></html>"
	usr << browse(dat.Join(), "window=roundstatus;size=500x500")

/datum/admins/proc/check_hunted_targets()
	if(!SSticker.HasRoundStarted())
		alert("游戏尚未开始！")
		return

	var/list/combat_roles = get_gnoll_tracking_combat_roles()
	var/list/hunted_targets = list()
	var/list/combat_targets = list()
	var/list/direct_scent_targets = list()
	var/list/tracking_gnolls_by_target_ref = list()

	for(var/mob/living/L in GLOB.player_list)
		if(!L || QDELETED(L) || L.stat == DEAD)
			continue
		if(istype(L, /mob/living/carbon/human/dummy) || !L.mind)
			continue

		if(HAS_TRAIT(L, TRAIT_GNOLL_HUNTED))
			hunted_targets += L
		else if(L.job in combat_roles)
			combat_targets += L

	for(var/datum/antagonist/gnoll/G in GLOB.antagonists)
		var/mob/living/gnoll_mob = G.owner?.current
		if(!gnoll_mob || QDELETED(gnoll_mob))
			continue
		var/mob/living/tracked_target = G.get_tracked_target()
		if(!tracked_target)
			continue
		if(!(tracked_target in hunted_targets) && !(tracked_target in combat_targets) && !(tracked_target in direct_scent_targets))
			direct_scent_targets += tracked_target

		var/target_ref = "\ref[tracked_target]"
		if(!tracking_gnolls_by_target_ref[target_ref])
			tracking_gnolls_by_target_ref[target_ref] = list()

		var/list/tracking_gnolls = tracking_gnolls_by_target_ref[target_ref]
		if(!(gnoll_mob in tracking_gnolls))
			tracking_gnolls += gnoll_mob

	var/list/active_targets = length(hunted_targets) ? hunted_targets : combat_targets
	var/list/display_targets = active_targets.Copy()
	if(length(direct_scent_targets))
		for(var/mob/living/direct_target in direct_scent_targets)
			if(!(direct_target in display_targets))
				display_targets += direct_target
	var/active_source = length(hunted_targets) ? "豺狼人的猎物特质" : "战斗职业候补"
	var/selection_mode_description = "遵循豺狼人追踪规则：优先选择所有被猎杀目标；没有有效的被猎杀目标时，才选择战斗职业。"
	if(length(direct_scent_targets))
		selection_mode_description += " 下方也会显示豺狼人正在通过直接气味追踪的目标。"
	var/slot_open_display = "不可用"
	var/gnoll_spawn_status = "已启用"
	var/list/subclass_slot_lines = list("不可用")

	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	if(gnoll_job)
		var/gnoll_total_slots = max(gnoll_job.total_positions, 0)
		var/gnoll_open_slots = max(gnoll_total_slots - gnoll_job.current_positions, 0)
		slot_open_display = "[gnoll_open_slots]/[gnoll_total_slots]"

		subclass_slot_lines = list()
		if(!SSrole_class_handler)
			subclass_slot_lines += "不可用（职业处理器尚未初始化）"
		else
			for(var/adv in gnoll_job.job_subclasses)
				var/datum/advclass/advpath = adv
				var/datum/advclass/subclass = SSrole_class_handler.get_advclass_by_name(initial(advpath.name))
				if(!subclass)
					continue

				if(subclass.maximum_possible_slots == -1)
					subclass_slot_lines += "[subclass.name]：无限制"
					continue

				var/subclass_open_slots = max(subclass.maximum_possible_slots - subclass.total_slots_occupied, 0)
				subclass_slot_lines += "[subclass.name]: [subclass_open_slots]/[subclass.maximum_possible_slots]"

		if(!length(subclass_slot_lines))
			subclass_slot_lines += "（无）"

	if(gnoll_job && !gnoll_job.total_positions)
		gnoll_spawn_status = "本回合未生成名额"

	var/subclass_slots_display = subclass_slot_lines.Join("<br>")

	var/list/dat = list("<html><head><title>Gnoll Information</title></head><body><h1><B>豺狼人信息</B></h1>")
	dat += "<a href='?_src_=holder;[HrefToken()];check_hunted_targets=1'>刷新</a><br>"
	dat += "<br><b>选择模式：</b> [active_source]"
	dat += "<br><b>豺狼人生成：</b> "
	dat += gnoll_spawn_status
	dat += "<br><b>豺狼人空缺名额：</b> "
	dat += slot_open_display
	dat += "<br><b>子职业名额（空缺/总数）：</b><br>"
	dat += subclass_slots_display
	dat += "<br><i>[selection_mode_description]</i><br><br>"

	if(!length(display_targets))
		dat += "没有可供豺狼人追踪的有效目标。"
	else
		var/list/sorted_target_rows = list()
		for(var/mob/living/target in display_targets)
			var/target_name = "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(target)]'>[target.real_name]</a>"
			var/target_location = AREACOORD(target)
			var/target_key = target.ckey || "（无）"
			var/target_job = target.job || "（无）"
			var/target_source = "直接气味"
			if(target in hunted_targets)
				target_source = "豺狼人的猎物特质"
			else if(target in combat_targets)
				target_source = "战斗职业候补"
			var/target_ref = "\ref[target]"
			var/gnoll_tracking_display = "（无）"
			var/gnoll_tracking_locations = "（无）"
			var/list/tracking_gnolls = tracking_gnolls_by_target_ref[target_ref]
			if(length(tracking_gnolls))
				var/list/tracking_name_links = list()
				var/list/tracking_location_labels = list()
				for(var/mob/living/gnoll_mob in tracking_gnolls)
					tracking_name_links += "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(gnoll_mob)]'>[gnoll_mob.real_name]</a>"
					tracking_location_labels += "[gnoll_mob.real_name]: [AREACOORD(gnoll_mob)]"
				gnoll_tracking_display = tracking_name_links.Join(", ")
				gnoll_tracking_locations = tracking_location_labels.Join("<br>")
			var/row_key = "[LOWER_TEXT(target.real_name)]-[REF(target)]"
			sorted_target_rows[row_key] = "<tr><td>[target_name]</td><td>[target_location]</td><td>[target_key]</td><td>[target_job]</td><td>[target_source]</td><td>[gnoll_tracking_display]</td><td>[gnoll_tracking_locations]</td></tr>"

		sortTim(sorted_target_rows, GLOBAL_PROC_REF(cmp_text_asc), associative = TRUE)

		dat += "<table cellspacing=5>"
		dat += "<tr><th align='left'>目标</th><th align='left'>位置</th><th align='left'>账号</th><th align='left'>职业</th><th align='left'>来源</th><th align='left'>追踪中的豺狼人</th><th align='left'>追踪者位置</th></tr>"
		for(var/row_key in sorted_target_rows)
			dat += sorted_target_rows[row_key]
		dat += "</table>"

	dat += "</body></html>"
	usr << browse(dat.Join(), "window=gnollinformation;size=700x500")
