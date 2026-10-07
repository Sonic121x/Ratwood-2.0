/client/proc/Debug2()
	set category = "调试"
	set name = "游戏调试"
	if(!check_rights(R_DEBUG))
		return

	if(GLOB.Debug2)
		GLOB.Debug2 = 0
		message_admins("[key_name(src)] 关闭了调试。")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		GLOB.Debug2 = 1
		message_admins("[key_name(src)] 开启了调试。")
		log_admin("[key_name(src)] toggled debugging on.")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Debug Two") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!



/* 21st Sept 2010
Updated by Skie -- Still not perfect but better!
Stuff you can't do:
Call proc /mob/proc/Dizzy() for some player
Because if you select a player mob as owner it tries to do the proc for
/mob/living/carbon/human/ instead. And that gives a run-time error.
But you can call procs that are of type /mob/living/carbon/human/proc/ for that player.
*/
/client/proc/cmd_admin_animalize(mob/M in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "变为简单动物"

	if(!SSticker.HasRoundStarted())
		alert("请等到游戏开始")
		return

	if(!M)
		alert("该生物似乎不存在，请关闭面板重试。")
		return

	if(isnewplayer(M))
		alert("目标不能是大厅玩家（new_player）。")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	INVOKE_ASYNC(M, TYPE_PROC_REF(/mob, Animalize))

//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all(object as text)
	set category = "调试"
	set name = "删除所有同类对象"

	var/list/matches = get_fancy_list_of_atom_types()
	if (!isnull(object) && object!="")
		matches = filter_fancy_list(matches, object)

	if(matches.len==0)
		return
	var/hsbitem = input(usr, "选择要删除的对象。", "删除：") as null|anything in sortList(matches)
	if(hsbitem)
		hsbitem = matches[hsbitem]
		var/counter = 0
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				counter++
				qdel(O)
			CHECK_TICK
		log_admin("[key_name(src)] has deleted all ([counter]) instances of [hsbitem].")
		message_admins("[key_name_admin(src)] 删除了 [hsbitem] 的全部实例（共 [counter] 个）。")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Delete All") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_assume_direct_control(mob/M in GLOB.mob_list)
	set category = "-管理-"
	set name = "直接控制..."
	set desc = ""

	if(M.ckey)
		if(alert("该生物由 [M.key] 控制。确定要接管吗？[M.key] 将变成幽灵。",,"是","否") != "是")
			return
		else
			var/mob/dead/observer/ghost = new/mob/dead/observer(M,1)
			ghost.ckey = M.ckey
	message_admins(span_adminnotice("[key_name_admin(usr)] 直接接管了 [M]。"))
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if( isobserver(adminmob) )
		qdel(adminmob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Assume Direct Control") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_areatest(on_station)
	set category = "地图制作"
	set name = "检查区域"

	var/list/dat = list()
	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_multiple_APCs = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()
	var/list/station_areas_blacklist = typecacheof(list())

	if(SSticker.current_state == GAME_STATE_STARTUP)
		to_chat(usr, "游戏仍在加载，请稍候！")
		return

	var/log_message
	if(on_station)
		dat += "<b>仅检查站点 Z 层级上的区域。</b><br><br>"
		log_message = "station z-levels"
	else
		log_message = "all z-levels"

	message_admins(span_adminnotice("[key_name_admin(usr)] 使用检查区域调试指令检查了 [on_station ? "站点 Z 层级" : "所有 Z 层级"]。"))
	log_admin("[key_name(usr)] used the Test Areas debug command checking [log_message].")

	for(var/area/A in world)
		if(on_station)
			var/turf/picked = safepick(get_area_turfs(A.type))
			if(picked && is_station_level(picked.z))
				if(!(A.type in areas_all) && !is_type_in_typecache(A, station_areas_blacklist))
					areas_all.Add(A.type)
		else if(!(A.type in areas_all))
			areas_all.Add(A.type)
		CHECK_TICK

	for(var/obj/machinery/light/L in GLOB.machines)
		var/area/A = get_area(L)
		if(!A)
			dat += "已跳过位置无效的 [L]，位置：[L.loc]。<br>"
			continue
		if(!(A.type in areas_with_light))
			areas_with_light.Add(A.type)
		CHECK_TICK

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	if(areas_without_APC.len)
		dat += "<h1>没有区域电力控制器的区域：</h1>"
		for(var/areatype in areas_without_APC)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_with_multiple_APCs.len)
		dat += "<h1>有多个区域电力控制器的区域：</h1>"
		for(var/areatype in areas_with_multiple_APCs)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_air_alarm.len)
		dat += "<h1>没有空气警报器的区域：</h1>"
		for(var/areatype in areas_without_air_alarm)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_RC.len)
		dat += "<h1>没有请求控制台的区域：</h1>"
		for(var/areatype in areas_without_RC)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_light.len)
		dat += "<h1>没有灯具的区域：</h1>"
		for(var/areatype in areas_without_light)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_LS.len)
		dat += "<h1>没有灯光开关的区域：</h1>"
		for(var/areatype in areas_without_LS)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_intercom.len)
		dat += "<h1>没有对讲机的区域：</h1>"
		for(var/areatype in areas_without_intercom)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_camera.len)
		dat += "<h1>没有摄像头的区域：</h1>"
		for(var/areatype in areas_without_camera)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(!(areas_with_APC.len || areas_with_multiple_APCs.len || areas_with_air_alarm.len || areas_with_RC.len || areas_with_light.len || areas_with_LS.len || areas_with_intercom.len || areas_with_camera.len))
		dat += "<b>未发现有问题的区域！</b>"

	var/datum/browser/popup = new(usr, "testareas", "检查区域", 500, 750)
	popup.set_content(dat.Join())
	popup.open()


/client/proc/cmd_admin_areatest_station()
	set category = "地图制作"
	set name = "检查区域（站点Z层级）"
	cmd_admin_areatest(TRUE)

/client/proc/cmd_admin_areatest_all()
	set category = "地图制作"
	set name = "检查区域（全部）"
	cmd_admin_areatest(FALSE)

/client/proc/cmd_admin_dress(mob/M in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "选择职业配置"
	if(!(ishuman(M) || isobserver(M)))
		alert("生物无效")
		return

	var/mob/living/carbon/human/H
	if(isobserver(M))
		H = M.change_mob_type(/mob/living/carbon/human, null, null, TRUE)
		// Ensure the new human inherits the ckey from the observer
		if(!H.ckey && M.ckey)
			H.ckey = M.ckey
	else
		H = M
	
	// Show the loadout panel window
	show_loadout_panel(H)

/client/proc/show_loadout_panel(mob/living/carbon/human/H)
	if(!H)
		return
	
	var/body = "<html><head><title>职业配置管理 - [H.name]</title>"
	body += "<style>"
	body += "table { border-collapse: collapse; width: 100%; }"
	body += "th, td { border: 1px solid black; padding: 5px; text-align: left; }"
	body += "th { background-color: #ddd; }"
	body += "</style>"
	body += "</head>"
	body += "<body>"
	
	body += "<b>职业配置管理：[H.name]</b><br><br>"
	
	// Current job display
	var/selected_job_path = GLOB.loadout_selected_jobs[REF(H)]
	var/selected_job_title = "无"
	if(selected_job_path)
		// Check if it's a migrant role or regular job
		if(ispath(selected_job_path, /datum/migrant_role))
			var/datum/migrant_role/MR = selected_job_path
			selected_job_title = initial(MR.name)
		else
			var/datum/job/J = selected_job_path
			selected_job_title = initial(J.display_title) || initial(J.title)
	var/selected_advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	var/selected_advclass_name = "无"
	if(selected_advclass_path)
		var/datum/advclass/AC = selected_advclass_path
		selected_advclass_name = initial(AC.name)
	
	body += "已选职业：<b>[selected_job_title]</b><br>"
	body += "已选子职业：<b>[selected_advclass_name]</b><br>"
	body += "<br>"
	
	// Job selection
	body += "<b>职业选择：</b><br>"
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=select_job;target=[REF(H)]'>选择职业</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=select_advclass;target=[REF(H)]'>选择子职业</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=copy_from_mob;target=[REF(H)]'>复制自...</A>"
	body += "<br><br>"
	
	// Application section
	body += "<b>应用配置：</b><br>"
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_stats;target=[REF(H)]'>应用属性</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_equipment_spells;target=[REF(H)]'>应用装备／法术</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_skills;target=[REF(H)]'>应用技能</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_traits;target=[REF(H)]'>应用特质</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_examine_title;target=[REF(H)]'>应用检视称号</A><br>"
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_all;target=[REF(H)]'>全部应用</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=clean_slate;target=[REF(H)]'>完全重置</A>"
	
	body += "</body></html>"
	
	usr << browse(body, "window=loadout_manager[REF(H)];size=500x400")

// Global variables to store selected job and advclass for each target mob
GLOBAL_LIST_EMPTY(loadout_selected_jobs)
GLOBAL_LIST_EMPTY(loadout_selected_advclasses)

/client/proc/handle_loadout_action(href_list)
	if(!check_rights(R_ADMIN))
		return FALSE
	
	if(!href_list["loadout_action"])
		return FALSE
	
	var/mob/living/carbon/human/H = locate(href_list["target"])
	if(!H || !ishuman(H))
		to_chat(usr, span_warning("目标已不存在或不是人类！"))
		return TRUE
	
	switch(href_list["loadout_action"])
		if("select_job")
			// Build list of all jobs with their titles
			var/list/job_list = list()
			for(var/job_type in subtypesof(/datum/job))
				var/datum/job/J = job_type
				var/job_title = initial(J.title)
				var/job_outfit = initial(J.outfit)
				var/list/job_subclasses = initial(J.job_subclasses)
				// Include jobs with outfit OR jobs with advclass system
				if(job_title && (job_outfit || job_subclasses))
					job_list[initial(J.display_title) || job_title] = job_type
			
			// Add all migrant roles
			for(var/migrant_type in subtypesof(/datum/migrant_role))
				var/datum/migrant_role/MR = migrant_type
				var/migrant_name = initial(MR.name)
				var/migrant_outfit = initial(MR.outfit)
				var/migrant_advclass = initial(MR.advclass_cat_rolls)
				// Include migrant roles with outfit OR advclass system
				if(migrant_name && (migrant_outfit || migrant_advclass) && migrant_name != "MIGRANT ROLE")
					job_list["[migrant_name]（移民）"] = migrant_type
			
			// Sort jobs, then add Search at the top
			var/list/all_jobs = list("搜索……" = "search") + sortList(job_list)
			var/selected_title = input("选择职业：", "职业选择") as null|anything in all_jobs
			if(!selected_title)
				show_loadout_panel(H)
				return TRUE
			
			// If "Search..." was selected, show search dialog
			if(all_jobs[selected_title] == "search")
				var/search_term = input("输入职业名称或搜索词：", "职业搜索") as text|null
				if(!search_term)
					show_loadout_panel(H)
					return TRUE
				
				// Build job list again without Search option
				var/list/searchable_jobs = list()
				for(var/job_type in subtypesof(/datum/job))
					var/datum/job/J = job_type
					var/job_title = initial(J.title)
					var/job_outfit = initial(J.outfit)
					var/list/job_subclasses = initial(J.job_subclasses)
					// Include jobs with outfit OR jobs with advclass system
					if(job_title && (job_outfit || job_subclasses))
						searchable_jobs[initial(J.display_title) || job_title] = job_type
				
				// Add all migrant roles
				for(var/migrant_type in subtypesof(/datum/migrant_role))
					var/datum/migrant_role/MR = migrant_type
					var/migrant_name = initial(MR.name)
					var/migrant_outfit = initial(MR.outfit)
					var/migrant_advclass = initial(MR.advclass_cat_rolls)
					// Include migrant roles with outfit OR advclass system
					if(migrant_name && (migrant_outfit || migrant_advclass) && migrant_name != "MIGRANT ROLE")
						searchable_jobs["[migrant_name]（移民）"] = migrant_type
				
				// Filter by search term
				var/list/matching_jobs = list()
				for(var/job_title in searchable_jobs)
					if(findtext(LOWER_TEXT(job_title), LOWER_TEXT(search_term)))
						matching_jobs[job_title] = searchable_jobs[job_title]
				
				if(!matching_jobs.len)
					to_chat(usr, span_warning("未找到与 '[search_term]' 匹配的职业。"))
					show_loadout_panel(H)
					return TRUE
				
				selected_title = input("选择职业（找到 [matching_jobs.len] 个匹配项）：", "职业搜索结果") as null|anything in sortList(matching_jobs)
				if(!selected_title)
					show_loadout_panel(H)
					return TRUE
				
				var/job_type_path = matching_jobs[selected_title]
				GLOB.loadout_selected_jobs[REF(H)] = job_type_path
				// Clear advclass when new job is selected
				GLOB.loadout_selected_advclasses[REF(H)] = null
				to_chat(usr, span_notice("已选择职业：[selected_title]"))
				// Also set the assigned role
				if(!H.mind)
					H.mind_initialize()
				H.mind.assigned_role = ispath(job_type_path, /datum/job) ? initial(job_type_path:title) : "[initial(job_type_path:name)] (Migrant)"
				
				// Auto-select advclass if job has only one, or open selection if multiple
				// Check if it's a migrant role with advclass_cat_rolls
				if(ispath(job_type_path, /datum/migrant_role))
					var/datum/migrant_role/migrant_datum = new job_type_path()
					if(migrant_datum.advclass_cat_rolls && length(migrant_datum.advclass_cat_rolls))
						// Get advclasses from the role class handler
						var/list/advclass_choices = list()
						for(var/category in migrant_datum.advclass_cat_rolls)
							for(var/datum/advclass/advclass_instance in SSrole_class_handler.sorted_class_categories[category])
								advclass_choices[advclass_instance.name] = advclass_instance.type
						
						if(length(advclass_choices) == 0)
							to_chat(usr, span_warning("未找到此移民角色的进阶职业。"))
						else if(length(advclass_choices) == 1)
							var/only_choice_name = advclass_choices[1]
							var/only_choice = advclass_choices[only_choice_name]
							GLOB.loadout_selected_advclasses[REF(H)] = only_choice
							to_chat(usr, span_notice("已自动选择进阶职业：[only_choice_name]"))
						else
							// Multiple advclasses - open selection automatically
							var/selected = input("选择进阶职业：", "进阶职业选择") as null|anything in sortList(advclass_choices)
							if(selected)
								GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
								to_chat(usr, span_notice("已选择进阶职业：[selected]"))
					qdel(migrant_datum)
				else
					var/datum/job/job_datum = new job_type_path()
					if(job_datum.job_subclasses && length(job_datum.job_subclasses))
						if(length(job_datum.job_subclasses) == 1)
							GLOB.loadout_selected_advclasses[REF(H)] = job_datum.job_subclasses[1]
							var/datum/advclass/AC = job_datum.job_subclasses[1]
							to_chat(usr, span_notice("已自动选择进阶职业：[initial(AC.name)]"))
						else
							// Multiple advclasses - open selection automatically
							var/list/advclass_choices = list()
							for(var/advclass_path in job_datum.job_subclasses)
								var/datum/advclass/AC = advclass_path
								advclass_choices[initial(AC.name)] = advclass_path
							
							var/selected = input("选择进阶职业：", "进阶职业选择") as null|anything in sortList(advclass_choices)
							if(selected)
								GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
								to_chat(usr, span_notice("已选择进阶职业：[selected]"))
					qdel(job_datum)
			else
				// Regular job selected
				var/job_type_path = all_jobs[selected_title]
				GLOB.loadout_selected_jobs[REF(H)] = job_type_path
				// Clear advclass when new job is selected
				GLOB.loadout_selected_advclasses[REF(H)] = null
				to_chat(usr, span_notice("已选择职业：[selected_title]"))
				// Also set the assigned role
				if(!H.mind)
					H.mind_initialize()
				H.mind.assigned_role = ispath(job_type_path, /datum/job) ? initial(job_type_path:title) : "[initial(job_type_path:name)] (Migrant)"
				
				// Auto-select advclass if job has only one, or open selection if multiple
				// Check if it's a migrant role with advclass_cat_rolls
				if(ispath(job_type_path, /datum/migrant_role))
					var/datum/migrant_role/migrant_datum = new job_type_path()
					if(migrant_datum.advclass_cat_rolls && length(migrant_datum.advclass_cat_rolls))
						// Get advclasses from the role class handler
						var/list/advclass_choices = list()
						for(var/category in migrant_datum.advclass_cat_rolls)
							for(var/datum/advclass/advclass_instance in SSrole_class_handler.sorted_class_categories[category])
								advclass_choices[advclass_instance.name] = advclass_instance.type
						
						if(length(advclass_choices) == 0)
							to_chat(usr, span_warning("未找到此移民角色的进阶职业。"))
						else if(length(advclass_choices) == 1)
							var/only_choice_name = advclass_choices[1]
							var/only_choice = advclass_choices[only_choice_name]
							GLOB.loadout_selected_advclasses[REF(H)] = only_choice
							to_chat(usr, span_notice("已自动选择进阶职业：[only_choice_name]"))
						else
							// Multiple advclasses - open selection automatically
							var/selected = input("选择进阶职业：", "进阶职业选择") as null|anything in sortList(advclass_choices)
							if(selected)
								GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
								to_chat(usr, span_notice("已选择进阶职业：[selected]"))
					qdel(migrant_datum)
				else
					var/datum/job/job_datum = new job_type_path()
					if(job_datum.job_subclasses && length(job_datum.job_subclasses))
						if(length(job_datum.job_subclasses) == 1)
							GLOB.loadout_selected_advclasses[REF(H)] = job_datum.job_subclasses[1]
							var/datum/advclass/AC = job_datum.job_subclasses[1]
							to_chat(usr, span_notice("已自动选择进阶职业：[initial(AC.name)]"))
						else
							// Multiple advclasses - open selection automatically
							var/list/advclass_choices = list()
							for(var/advclass_path in job_datum.job_subclasses)
								var/datum/advclass/AC = advclass_path
								advclass_choices[initial(AC.name)] = advclass_path
							
							var/selected = input("选择进阶职业：", "进阶职业选择") as null|anything in sortList(advclass_choices)
							if(selected)
								GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
								to_chat(usr, span_notice("已选择进阶职业：[selected]"))
					qdel(job_datum)
			
			show_loadout_panel(H)
		
		if("select_advclass")
			var/job_type_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_type_path)
				to_chat(usr, span_warning("未选择职业！请先选择职业以查看其进阶职业。"))
				show_loadout_panel(H)
				return TRUE
			
			// Check if it's a migrant role
			if(ispath(job_type_path, /datum/migrant_role))
				var/datum/migrant_role/migrant_datum = new job_type_path()
				if(!migrant_datum.advclass_cat_rolls || !length(migrant_datum.advclass_cat_rolls))
					to_chat(usr, span_warning("此移民角色没有可用的进阶职业。"))
					qdel(migrant_datum)
					show_loadout_panel(H)
					return TRUE
				
				// Get advclasses from the role class handler
				var/list/advclass_choices = list()
				for(var/category in migrant_datum.advclass_cat_rolls)
					for(var/datum/advclass/advclass_instance in SSrole_class_handler.sorted_class_categories[category])
						advclass_choices[advclass_instance.name] = advclass_instance.type
				
				qdel(migrant_datum)
				
				if(!length(advclass_choices))
					to_chat(usr, span_warning("未找到此移民角色的进阶职业。"))
					show_loadout_panel(H)
					return TRUE
				
				var/selected = input("选择进阶职业：", "进阶职业选择") as null|anything in sortList(advclass_choices)
				if(selected)
					GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
					to_chat(usr, span_notice("已选择进阶职业：[selected]"))
			else
				// Regular job
				var/datum/job/selected_job
				for(var/datum/job/J in SSjob.occupations)
					if(J.type == job_type_path)
						selected_job = J
						break
				
				if(!selected_job || !selected_job.job_subclasses || !length(selected_job.job_subclasses))
					to_chat(usr, span_warning("此职业没有可用的进阶职业。"))
					show_loadout_panel(H)
					return TRUE
				
				var/list/advclass_choices = list()
				for(var/advclass_path in selected_job.job_subclasses)
					var/datum/advclass/AC = advclass_path
					advclass_choices[initial(AC.name)] = advclass_path
				
				var/selected = input("选择进阶职业：", "进阶职业选择") as null|anything in sortList(advclass_choices)
				if(selected)
					GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
				to_chat(usr, span_notice("已选择进阶职业：[selected]"))
			show_loadout_panel(H)
		
		if("copy_from_mob")
			copy_loadout_from_mob(H)
			show_loadout_panel(H)
		
		if("apply_stats")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("未选择职业！请先使用“选择职业”。"))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("此职业需要进阶职业！请先使用“选择进阶职业”。"))
				return TRUE
			// Ask for confirmation
			var/confirm = alert(usr, "应用职业属性前，先将属性重置为基础值（包括种族／属性组合加成）？", "应用属性", "先重置", "叠加到当前值", "取消")
			if(confirm == "取消")
				return TRUE
			var/delete_existing = (confirm == "先重置")
			apply_job_stats(H, job_path, delete_existing)
			show_loadout_panel(H)
		
		if("apply_equipment_spells")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("未选择职业！请先使用“选择职业”。"))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("此职业需要进阶职业！请先使用“选择进阶职业”。"))
				return TRUE
			// Ask for confirmation with clear explanation
			var/confirm = alert(usr, "应用前删除当前所有装备和法术？\n\n注意：部分套装会在装备过程中授予法术。", "应用装备／法术", "是", "否", "取消")
			if(confirm == "取消")
				return TRUE
			var/delete_existing = (confirm == "是")
			apply_job_equipment_and_spells(H, job_path, delete_existing)
			show_loadout_panel(H)
		
		if("apply_skills")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("未选择职业！请先使用“选择职业”。"))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("此职业需要进阶职业！请先使用“选择进阶职业”。"))
				return TRUE
			// Ask for confirmation
			var/confirm = alert(usr, "应用前删除当前所有技能？", "应用技能", "是", "否", "取消")
			if(confirm == "取消")
				return TRUE
			var/delete_existing = (confirm == "是")
			apply_job_skills(H, job_path, delete_existing)
			show_loadout_panel(H)
		
		if("apply_traits")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("未选择职业！请先使用“选择职业”。"))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("此职业需要进阶职业！请先使用“选择进阶职业”。"))
				return TRUE
			// Ask for confirmation
			var/confirm = alert(usr, "应用前删除当前所有职业特质？", "应用特质", "是", "否", "取消")
			if(confirm == "取消")
				return TRUE
			var/delete_existing = (confirm == "是")
			apply_job_traits(H, job_path, delete_existing)
			show_loadout_panel(H)
		
		if("apply_examine_title")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("未选择职业！请先使用“选择职业”。"))
				return TRUE
			// No need for delete confirmation - this just overwrites
			apply_job_examine_title(H, job_path)
			show_loadout_panel(H)
		
		if("apply_all")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("未选择职业！请先使用“选择职业”。"))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("此职业需要进阶职业！请先使用“选择进阶职业”。"))
				return TRUE
			// Ask to delete current equipment
			if(alert(usr, "删除当前所有装备？", "确认", "是", "否") == "是")
				for(var/obj/item/I in H.get_equipped_items(TRUE))
					qdel(I)
				for(var/obj/item/I in H.held_items)
					qdel(I)
			apply_full_job_loadout(H, job_path)
			show_loadout_panel(H)
		
		if("clean_slate")
			if(alert(usr, "这会将 [H.name] 重置为空白状态，移除所有装备、技能、查看称号和特质，并重置属性。继续？", "确认完全重置", "是", "否") == "是")
				clean_slate_mob(H)
				show_loadout_panel(H)
	
	return TRUE

/client/proc/robust_dress_shop()

	var/list/baseoutfits = list("裸装","自定义", "按岩丘职业选择……", "搜索职业……")
	var/list/outfits = list()
	var/list/paths = subtypesof(/datum/outfit) - typesof(/datum/outfit/job)  - typesof(/datum/outfit/job/roguetown)

	for(var/path in paths)
		var/datum/outfit/O = path //not much to initalize here but whatever
		if(initial(O.can_be_admin_equipped))
			outfits[initial(O.name)] = path

	var/dresscode = input("选择装备套装", "快捷换装") as null|anything in baseoutfits + sortList(outfits)
	if (isnull(dresscode))
		return

	if (outfits[dresscode])
		dresscode = outfits[dresscode]

	if (dresscode == "自定义")
		var/list/custom_names = list()
		for(var/datum/outfit/D in GLOB.custom_outfits)
			custom_names[D.name] = D
		var/selected_name = input("选择装备套装", "快捷换装") as null|anything in sortList(custom_names)
		dresscode = custom_names[selected_name]
		if(isnull(dresscode))
			return
	
	if (dresscode == "搜索职业……")
		var/search_term = input("搜索职业（输入关键词）：", "职业搜索") as text|null
		if(!search_term)
			return
		
		var/list/roguejob_paths = subtypesof(/datum/outfit/job/roguetown)
		var/list/matching_jobs = list()
		
		for(var/path in roguejob_paths)
			var/datum/outfit/O = path
			var/path_string = "[path]"
			if(findtext(LOWER_TEXT(path_string), LOWER_TEXT(search_term)))
				if(initial(O.can_be_admin_equipped))
					matching_jobs["[path]"] = path
		
		if(!matching_jobs.len)
			to_chat(usr, span_warning("未找到与 '[search_term]' 匹配的职业。"))
			return
		
		dresscode = input("选择职业（找到 [matching_jobs.len] 个匹配项）", "职业搜索结果") as null|anything in sortList(matching_jobs)
		dresscode = matching_jobs[dresscode]
		if(isnull(dresscode))
			return

	if (dresscode == "按岩丘职业选择……")
		var/list/roguejob_paths = subtypesof(/datum/outfit/job/roguetown)
		var/list/roguejob_outfits = list()
		for(var/path in roguejob_paths)
			var/datum/outfit/O = path
			//roguetown coders are morons and didn't give ANY outfits proper fucking names
			if(initial(O.can_be_admin_equipped))
				roguejob_outfits["[path]"] = path

		dresscode = input("选择职业装备", "快捷换装") as null|anything in sortList(roguejob_outfits)
		dresscode = roguejob_outfits[dresscode]
		if(isnull(dresscode))
			return


	return dresscode == "裸装" ? "Naked" : dresscode

// Apply full job loadout including stats, skills, traits, and spells
/client/proc/apply_full_job_loadout(mob/living/carbon/human/H, job_type_path)
	if(!ishuman(H))
		return
	
	// Determine if this is a migrant role or regular job
	var/is_migrant = FALSE
	if(ispath(job_type_path, /datum/migrant_role))
		is_migrant = TRUE
	
	var/datum/outfit/outfit_path = null
	var/datum/outfit/actual_outfit = null
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	if(is_migrant)
		// Get outfit from migrant role - check if it uses advclass_cat_rolls or direct outfit
		var/datum/migrant_role/MR = new job_type_path()
		outfit_path = MR.outfit
		
		// If migrant role has direct outfit, use it
		if(outfit_path)
			actual_outfit = outfit_path
		// If migrant role uses advclass system, get outfit from selected advclass
		else if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			if(advclass_datum.outfit)
				actual_outfit = advclass_datum.outfit
		else if(MR.advclass_cat_rolls)
			to_chat(usr, span_warning("尚未为此移民角色选择进阶职业。请使用“进阶职业”按钮进行选择。"))
		qdel(MR)
	else
		// Get outfit from job type
		var/datum/job/JobType = job_type_path
		outfit_path = initial(JobType.outfit)
		
		var/datum/advclass/advclass_datum = null
		actual_outfit = outfit_path
		
		// If advclass is selected, use its outfit instead
		if(advclass_path)
			advclass_datum = new advclass_path()
			if(advclass_datum.outfit)
				actual_outfit = advclass_datum.outfit
	
	// Equip the outfit if available - equipOutfit handles pre_equip and post_equip internally
	if(actual_outfit)
		H.equipOutfit(actual_outfit)
	else
		to_chat(usr, span_warning("此[is_migrant ? "移民角色" : "职业"]没有可用的装备套装。"))
	
	// Find the corresponding job datum to apply stats/skills (only for regular jobs)
	var/datum/job/job_datum = null
	if(!is_migrant)
		for(var/job_type in subtypesof(/datum/job))
			var/datum/job/J = job_type
			if(initial(J.outfit) == outfit_path || initial(J.outfit_female) == outfit_path)
				job_datum = new job_type()
				break
	
	// Remove old job traits before applying new ones
	if(H.status_traits)
		var/list/traits_to_remove = list()
		for(var/trait in H.status_traits)
			var/list/sources = H.status_traits[trait]
			if(JOB_TRAIT in sources)
				traits_to_remove += trait
		for(var/trait in traits_to_remove)
			REMOVE_TRAIT(H, trait, JOB_TRAIT)
	
	// For migrant roles, equipment and stats are applied via the outfit's pre_equip
	// For regular jobs, we need to handle advclass and job separately
	if(!is_migrant)
		var/datum/advclass/advclass_datum = null
		
		// Apply advclass stats/skills/traits if available, otherwise use job
		if(advclass_path)
			advclass_datum = new advclass_path()
			// Apply advclass stats
			if(length(advclass_datum.subclass_stats))
				for(var/stat in advclass_datum.subclass_stats)
					H.change_stat(stat, advclass_datum.subclass_stats[stat])
			
			// Apply advclass skills
			if(length(advclass_datum.subclass_skills))
				for(var/skill in advclass_datum.subclass_skills)
					H.adjust_skillrank(skill, advclass_datum.subclass_skills[skill], TRUE)
			
			// Apply advclass spell points
			if(advclass_datum.subclass_spellpoints > 0 && H.mind)
				H.mind.adjust_spellpoints(advclass_datum.subclass_spellpoints)
			
			// Apply advclass traits
			if(advclass_datum.traits_applied)
				for(var/trait in advclass_datum.traits_applied)
					ADD_TRAIT(H, trait, JOB_TRAIT)
		else if(job_datum)
			// Apply job stats
			if(length(job_datum.job_stats))
				for(var/stat in job_datum.job_stats)
					H.change_stat(stat, job_datum.job_stats[stat])
			
			// Apply job traits
			if(job_datum.job_traits)
				for(var/trait in job_datum.job_traits)
					ADD_TRAIT(H, trait, JOB_TRAIT)
		
		// Apply spells from job
		if(job_datum && job_datum.spells && H.mind)
			for(var/S in job_datum.spells)
				H.mind.AddSpell(new S)
	
	// Apply racial bonuses for reading (elves) and engineering (constructs)
	if(H.dna?.species)
		if(H.dna.species.name in list("Elf", "Half-Elf"))
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		if(H.dna.species.name in list("Metal Construct"))
			H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
	
	// Call after_spawn if job exists (latejoin=TRUE to skip spawn protection and ready-up bonuses)
	if(job_datum && hascall(job_datum, "after_spawn"))
		H.islatejoin = TRUE  // Mark as latejoin to prevent ready-up bonuses
		job_datum.after_spawn(H, H, TRUE)
	
	// Call after_spawn for migrant roles if it exists
	if(is_migrant)
		var/datum/migrant_role/migrant_datum = new job_type_path()
		if(hascall(migrant_datum, "after_spawn"))
			migrant_datum.after_spawn(H)
		qdel(migrant_datum)
	
	// Clean up any advclass selection hugbox state that may have been applied by after_spawn
	// This must happen AFTER after_spawn since that proc may apply hugbox for advclass selection
	H.advsetup = 0
	H.invisibility = 0
	H.cure_blind("advsetup")
	if(H.status_flags & GODMODE)
		H.status_flags &= ~GODMODE
	REMOVE_TRAIT(H, TRAIT_PACIFISM, HUGBOX_TRAIT)
	// Unregister the movement signal if it exists
	UnregisterSignal(H, COMSIG_MOVABLE_MOVED)
	// Clear any hugbox-related messages
	H.clear_fullscreen("blind")
	// Force end any hugbox timers by calling the end proc (safe to call even if not in hugbox)
	if(hascall(H, "adv_hugboxing_end"))
		H.adv_hugboxing_end()
	
	// Apply examine title
	if(is_migrant)
		// For migrant roles, set the name directly
		var/datum/migrant_role/MR = job_type_path
		H.job = initial(MR.name)
		H.advjob = null
		to_chat(H, span_notice("查看称号已设为：[initial(MR.name)]"))
	else if(job_datum)
		// Determine the appropriate gendered title
		var/title = job_datum.title
		if(job_datum.f_title && (H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F))
			title = job_datum.f_title
		H.job = title
		if(advclass_path)
			var/datum/advclass/adv_for_title = new advclass_path()
			H.advjob = adv_for_title.name
	
	to_chat(H, span_notice("已应用完整职业配置！属性、技能和特质已设置完成。"))
	message_admins("[key_name_admin(usr)] 为 [ADMIN_LOOKUPFLW(H)] 应用了完整职业配置 [actual_outfit]。")
	log_admin("[key_name(usr)] applied full job loadout [actual_outfit] to [key_name(H)].")

// Individual application functions
/client/proc/apply_job_equipment_and_spells(mob/living/carbon/human/H, job_type_path, delete_existing = FALSE)
	if(!ishuman(H))
		return
	
	if(!H.mind)
		H.mind_initialize()
		to_chat(usr, span_notice("已为目标初始化意识。"))
	
	// Determine if this is a migrant role or regular job
	var/is_migrant = FALSE
	if(ispath(job_type_path, /datum/migrant_role))
		is_migrant = TRUE
	
	var/datum/outfit/outfit_path = null
	var/datum/outfit/actual_outfit = null
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	if(is_migrant)
		// Get outfit from migrant role - check if it uses advclass_cat_rolls or direct outfit
		var/datum/migrant_role/MR = new job_type_path()
		outfit_path = MR.outfit
		
		// If migrant role has direct outfit, use it
		if(outfit_path)
			actual_outfit = outfit_path
		// If migrant role uses advclass system, get outfit from selected advclass
		else if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			if(advclass_datum.outfit)
				actual_outfit = advclass_datum.outfit
		else if(MR.advclass_cat_rolls)
			to_chat(usr, span_warning("尚未为此移民角色选择进阶职业。请使用“进阶职业”按钮进行选择。"))
		qdel(MR)
	else
		// Get outfit from job type
		var/datum/job/JobType = job_type_path
		outfit_path = initial(JobType.outfit)
		
		actual_outfit = outfit_path
		
		// If advclass is selected, use its outfit instead
		if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			if(advclass_datum.outfit)
				actual_outfit = advclass_datum.outfit
	
	// Clear existing equipment and spells if requested
	if(delete_existing)
		// Clear equipment
		for(var/obj/item/I in H.get_equipped_items(TRUE))
			qdel(I)
		for(var/obj/item/I in H.held_items)
			qdel(I)
		// Clear spells and spell points
		for(var/obj/effect/proc_holder/spell/S in H.mind.spell_list)
			H.mind.RemoveSpell(S)
		H.mind.spell_points = 0
		H.mind.used_spell_points = 0
	
	// Equip the outfit if available - equipOutfit handles pre_equip and post_equip internally
	// Note: pre_equip hooks may grant spells as part of the equipment process
	if(actual_outfit)
		H.equipOutfit(actual_outfit)
		H.regenerate_icons()
	
	// For migrant roles, spells are already applied via the outfit
	// For regular jobs, apply additional job spells if available
	if(!is_migrant)
		// Find the corresponding job datum to apply any additional job spells
		var/datum/job/job_datum = null
		for(var/job_type in subtypesof(/datum/job))
			var/datum/job/J = job_type
			if(initial(J.outfit) == outfit_path || initial(J.outfit_female) == outfit_path)
				job_datum = new job_type()
				break
		
		// Apply spells from job if available (separate from outfit)
		if(job_datum && job_datum.spells)
			for(var/S in job_datum.spells)
				H.mind.AddSpell(new S)
	
		// Apply spell points from advclass if available
		if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			if(advclass_datum.subclass_spellpoints > 0)
				H.mind.adjust_spellpoints(advclass_datum.subclass_spellpoints)
	
	if(actual_outfit)
		to_chat(H, span_notice("已应用[is_migrant ? "移民角色的" : ""]装备和法术！"))
		message_admins("[key_name_admin(usr)] 为 [ADMIN_LOOKUPFLW(H)] 应用了 [actual_outfit] 的装备和法术。")
		log_admin("[key_name(usr)] applied equipment and spells from [actual_outfit] to [key_name(H)].")
	else
		to_chat(usr, span_warning("此[is_migrant ? "移民角色" : "职业"]没有可用的装备套装。"))

/client/proc/apply_job_stats(mob/living/carbon/human/H, job_type_path, delete_existing = FALSE)
	if(!ishuman(H))
		return
	
	// Get outfit from job type for job finding
	var/datum/job/JobType = job_type_path
	var/datum/outfit/outfit_path = initial(JobType.outfit)
	
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	// Reset stats to baseline (with racial and stat-pack bonuses) if requested
	if(delete_existing)
		H.roll_stats()
	
	// Find the job datum
	var/datum/job/job_datum = null
	for(var/job_type in subtypesof(/datum/job))
		var/datum/job/J = job_type
		if(initial(J.outfit) == outfit_path || initial(J.outfit_female) == outfit_path)
			job_datum = new job_type()
			break
	
	// Apply job stats first
	if(job_datum && length(job_datum.job_stats))
		for(var/stat in job_datum.job_stats)
			H.change_stat(stat, job_datum.job_stats[stat])
	
	// Then apply advclass stats on top
	if(advclass_path)
		var/datum/advclass/advclass_datum = new advclass_path()
		if(length(advclass_datum.subclass_stats))
			for(var/stat in advclass_datum.subclass_stats)
				H.change_stat(stat, advclass_datum.subclass_stats[stat])
	
	to_chat(H, span_notice("已应用职业[advclass_path ? "及进阶职业" : ""]的属性！"))
	message_admins("[key_name_admin(usr)] 为 [ADMIN_LOOKUPFLW(H)] 应用了 [outfit_path] 的属性。")
	log_admin("[key_name(usr)] applied stats from [outfit_path] to [key_name(H)].")

/client/proc/apply_job_skills(mob/living/carbon/human/H, job_type_path, delete_existing = FALSE)
	if(!ishuman(H))
		return
	
	// Get outfit from job type for job finding
	var/datum/job/JobType = job_type_path
	var/datum/outfit/outfit_path = initial(JobType.outfit)
	
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	// Clear all skills if requested
	if(delete_existing)
		for(var/skill_type in subtypesof(/datum/skill))
			var/current_rank = H.get_skill_level(skill_type)
			if(current_rank > 0)
				H.adjust_skillrank(skill_type, -current_rank, TRUE)
	
	// Apply racial skill bonuses first
	if(H.dna?.species)
		if(H.dna.species.name in list("Elf", "Half-Elf"))
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		if(H.dna.species.name in list("Metal Construct"))
			H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
	
	// Apply advclass skills if available
	if(advclass_path)
		var/datum/advclass/advclass_datum = new advclass_path()
		if(length(advclass_datum.subclass_skills))
			for(var/skill in advclass_datum.subclass_skills)
				H.adjust_skillrank(skill, advclass_datum.subclass_skills[skill], TRUE)
	
	to_chat(H, span_notice("已应用[advclass_path ? "进阶职业的" : ""]技能！"))
	message_admins("[key_name_admin(usr)] 为 [ADMIN_LOOKUPFLW(H)] 应用了 [outfit_path] 的技能。")
	log_admin("[key_name(usr)] applied skills from [outfit_path] to [key_name(H)].")

/client/proc/apply_job_traits(mob/living/carbon/human/H, job_type_path, delete_existing = FALSE)
	if(!ishuman(H))
		return
	
	// Get outfit from job type for job finding
	var/datum/job/JobType = job_type_path
	var/datum/outfit/outfit_path = initial(JobType.outfit)
	
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	// Remove old job traits if requested
	if(delete_existing && H.status_traits)
		var/list/traits_to_remove = list()
		for(var/trait in H.status_traits)
			var/list/sources = H.status_traits[trait]
			if(JOB_TRAIT in sources)
				traits_to_remove += trait
		for(var/trait in traits_to_remove)
			REMOVE_TRAIT(H, trait, JOB_TRAIT)
	
	// Find the job datum
	var/datum/job/job_datum = null
	for(var/job_type in subtypesof(/datum/job))
		var/datum/job/J = job_type
		if(initial(J.outfit) == outfit_path || initial(J.outfit_female) == outfit_path)
			job_datum = new job_type()
			break
	
	// Apply job traits first
	if(job_datum && job_datum.job_traits)
		for(var/trait in job_datum.job_traits)
			ADD_TRAIT(H, trait, JOB_TRAIT)
	
	// Then apply advclass traits on top
	if(advclass_path)
		var/datum/advclass/advclass_datum = new advclass_path()
		if(advclass_datum.traits_applied)
			for(var/trait in advclass_datum.traits_applied)
				ADD_TRAIT(H, trait, JOB_TRAIT)
	
	to_chat(H, span_notice("已应用职业[advclass_path ? "及进阶职业" : ""]的特质！"))
	message_admins("[key_name_admin(usr)] 为 [ADMIN_LOOKUPFLW(H)] 应用了 [outfit_path] 的特质。")
	log_admin("[key_name(usr)] applied traits from [outfit_path] to [key_name(H)].")

/client/proc/apply_job_examine_title(mob/living/carbon/human/H, job_type_path)
	if(!ishuman(H))
		return
	
	// Determine if this is a migrant role or regular job
	var/is_migrant = FALSE
	if(ispath(job_type_path, /datum/migrant_role))
		is_migrant = TRUE
	
	// Clear any excommunicated/outlawed status before applying new title
	if(H.real_name in GLOB.excommunicated_players)
		GLOB.excommunicated_players -= H.real_name
	if(H.real_name in GLOB.outlawed_players)
		GLOB.outlawed_players -= H.real_name
	
	if(is_migrant)
		// For migrant roles, set the name directly
		var/datum/migrant_role/migrant_datum = new job_type_path()
		var/title = migrant_datum.name
		H.job = title
		H.advjob = null
		to_chat(H, span_notice("查看称号已设为：[title]"))
		message_admins("[key_name_admin(usr)] 将 [ADMIN_LOOKUPFLW(H)] 的查看称号设为 [title]。")
		log_admin("[key_name(usr)] set examine title for [key_name(H)] to [title].")
		qdel(migrant_datum)
	else
		// Get the job datum directly from the path
		var/datum/job/job_datum = new job_type_path()
		
		var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
		
		if(!job_datum)
			to_chat(usr, span_warning("找不到职业数据对象。"))
			return
		
		// Determine the appropriate title based on gender
		var/title = job_datum.title
		if(job_datum.f_title && (H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F))
			title = job_datum.f_title
		
		// Set the job
		H.job = title
		
		// Set advclass if selected
		if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			H.advjob = advclass_datum.name
			to_chat(H, span_notice("查看称号已设为：[advclass_datum.examine_name || advclass_datum.name]"))
			message_admins("[key_name_admin(usr)] 将 [ADMIN_LOOKUPFLW(H)] 的查看称号设为 [advclass_datum.examine_name || advclass_datum.name]。")
			log_admin("[key_name(usr)] set examine title for [key_name(H)] to [advclass_datum.examine_name || advclass_datum.name].")
		else
			// For jobs with advjob_examine = TRUE, set H.advjob to the appropriate title
			if(job_datum.advjob_examine)
				H.advjob = title
			// Get display title if available
			var/display_title = job_datum.display_title || title
			to_chat(H, span_notice("查看称号已设为：[display_title]"))
			message_admins("[key_name_admin(usr)] 将 [ADMIN_LOOKUPFLW(H)] 的查看称号设为 [display_title]。")
			log_admin("[key_name(usr)] set examine title for [key_name(H)] to [display_title].")

/client/proc/clean_slate_mob(mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	
	// Delete all equipment including items in hands
	for(var/obj/item/I in H.get_equipped_items(TRUE))
		qdel(I)
	// Delete items in hands
	for(var/obj/item/I in H.held_items)
		qdel(I)
	
	// Reset stats to baseline (10) plus racial and stat-pack modifiers
	H.roll_stats()
	
	// Clear all skills
	for(var/skill_type in subtypesof(/datum/skill))
		var/current_rank = H.get_skill_level(skill_type)
		if(current_rank > 0)
			H.adjust_skillrank(skill_type, -current_rank, TRUE)
	
	// Remove all job traits (but preserve species traits)
	if(H.status_traits)
		for(var/trait in H.status_traits)
			if(HAS_TRAIT_FROM(H, trait, JOB_TRAIT))
				REMOVE_TRAIT(H, trait, JOB_TRAIT)
	
	// Clear spells and spell points if they have a mind
	if(H.mind)
		for(var/obj/effect/proc_holder/spell/S in H.mind.spell_list)
			H.mind.RemoveSpell(S)
		// Reset spell points
		H.mind.spell_points = 0
		H.mind.used_spell_points = 0
	
	// Remove from excommunicated and outlawed lists (clears examine text like "HERETIC! SHAME!")
	// Check both real_name and name to be thorough
	if(H.real_name)
		GLOB.excommunicated_players -= H.real_name
		GLOB.outlawed_players -= H.real_name
	if(H.name && H.name != H.real_name)
		GLOB.excommunicated_players -= H.name
		GLOB.outlawed_players -= H.name
	
	// Clear job and advjob to remove examine title
	H.job = null
	H.advjob = null
	
	// Don't clear selected job - let it persist for reapplication
	
	H.regenerate_icons()
	
	to_chat(H, span_warning("你已被完全重置为空白状态！"))
	message_admins("[key_name_admin(usr)] 将 [ADMIN_LOOKUPFLW(H)] 完全重置为空白状态。")
	log_admin("[key_name(usr)] reset [key_name(H)] to a clean slate.")

// Copy loadout from one mob to another
/client/proc/copy_loadout_from_mob(mob/living/carbon/human/target)
	if(!ishuman(target))
		to_chat(usr, span_warning("目标必须是人类！"))
		return
	
	var/list/possible_sources = list()
	// Include all human mobs, whether connected or disconnected
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H != target)
			var/display_name = "[H.name]"
			if(H.ckey)
				display_name += " ([H.ckey])"
			else
				display_name += "（已断线）"
			possible_sources[display_name] = H
	
	if(!possible_sources.len)
		to_chat(usr, span_warning("未找到有效的人形角色！"))
		return
	
	var/source_name = input("选择要复制配置的来源角色：", "复制来源……") as null|anything in sortList(possible_sources)
	if(!source_name)
		return
	
	var/mob/living/carbon/human/source = possible_sources[source_name]
	if(!source || QDELETED(source))
		to_chat(usr, span_warning("来源角色已不存在！"))
		return
	
	// Confirm what to copy
	var/list/copy_options = list("仅装备", "装备 + 技能", "装备 + 技能 + 属性", "全部（装备 + 技能 + 属性 + 特质）")
	var/copy_choice = input("要复制哪些内容？", "复制选项") as null|anything in copy_options
	if(!copy_choice)
		return
	
	// Clear target's equipment first
	if(alert("清除目标当前的装备？", "确认", "是", "否") == "是")
		for(var/obj/item/I in target.get_equipped_items(TRUE))
			qdel(I)
	
	// Copy equipment
	copy_equipment(source, target)
	
	// Copy skills if requested
	if(copy_choice in list("装备 + 技能", "装备 + 技能 + 属性", "全部（装备 + 技能 + 属性 + 特质）"))
		copy_skills(source, target)
	
	// Copy stats if requested
	if(copy_choice in list("装备 + 技能 + 属性", "全部（装备 + 技能 + 属性 + 特质）"))
		copy_stats(source, target)
	
	// Copy traits if requested  
	if(copy_choice == "全部（装备 + 技能 + 属性 + 特质）")
		copy_traits(source, target)
	
	target.regenerate_icons()
	to_chat(usr, span_notice("已将 [source.name] 的配置复制给 [target.name]！"))
	message_admins("[key_name_admin(usr)] 将 [ADMIN_LOOKUPFLW(source)] 的配置复制给了 [ADMIN_LOOKUPFLW(target)]（[copy_choice]）。")
	log_admin("[key_name(usr)] copied loadout from [key_name(source)] to [key_name(target)] ([copy_choice]).")

/client/proc/copy_equipment(mob/living/carbon/human/source, mob/living/carbon/human/target)
	// Copy all worn/held items by creating duplicates
	var/list/items_to_copy = source.get_equipped_items(TRUE)
	// Also add held items
	for(var/obj/item/held in source.held_items)
		if(held && !(held in items_to_copy))
			items_to_copy += held
	
	for(var/obj/item/I in items_to_copy)
		var/obj/item/copy = new I.type()
		
		// Try to equip in appropriate slot
		var/equipped = FALSE
		
		// Check each possible slot
		if(source.head == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_HEAD)
		else if(source.wear_mask == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_WEAR_MASK)
		else if(source.wear_neck == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_NECK)
		else if(source.back == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BACK)
		else if(source.wear_armor == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_ARMOR)
		else if(source.wear_shirt == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_SHIRT)
		else if(source.wear_pants == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_PANTS)
		else if(source.belt == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BELT)
		else if(source.beltl == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BELT_L)
		else if(source.beltr == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BELT_R)
		else if(source.gloves == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_GLOVES)
		else if(source.shoes == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_SHOES)
		else if(source.cloak == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_CLOAK)
		else if(source.backr == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BACK_R)
		else if(source.backl == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BACK_L)
		else if(I in source.held_items)
			// Try to put in hands
			equipped = target.put_in_hands(copy)
		
		// If couldn't equip, drop it at their feet
		if(!equipped)
			copy.forceMove(get_turf(target))

/client/proc/copy_skills(mob/living/carbon/human/source, mob/living/carbon/human/target)
	if(!source.mind || !target.mind)
		return
	
	// Copy all skill ranks
	for(var/skill_type in subtypesof(/datum/skill))
		var/source_rank = source.get_skill_level(skill_type)
		var/target_rank = target.get_skill_level(skill_type)
		
		if(source_rank != target_rank)
			var/difference = source_rank - target_rank
			target.adjust_skillrank(skill_type, difference, TRUE)
	
	to_chat(target, span_notice("我的技能已调整为与[source.name]的能力一致。"))

/client/proc/copy_stats(mob/living/carbon/human/source, mob/living/carbon/human/target)
	// Copy all stats using the correct stat names
	var/list/stat_names = list(STAT_STRENGTH, STAT_PERCEPTION, STAT_INTELLIGENCE, STAT_CONSTITUTION, STAT_WILLPOWER, STAT_SPEED, STAT_FORTUNE)
	
	for(var/stat in stat_names)
		var/source_stat = source.get_stat(stat)
		var/target_stat = target.get_stat(stat)
		var/difference = source_stat - target_stat
		
		if(difference != 0)
			target.change_stat(stat, difference)
	
	to_chat(target, span_notice("我的属性已调整为与[source.name]一致。"))

/client/proc/copy_traits(mob/living/carbon/human/source, mob/living/carbon/human/target)
	// Get source's job datum to find job traits
	var/datum/job/source_job = null
	if(source.mind?.assigned_role)
		for(var/job_type in subtypesof(/datum/job))
			var/datum/job/J = job_type
			if(initial(J.title) == source.mind.assigned_role)
				source_job = new job_type()
				break
	
	// Clear target's job traits first (remove traits from JOB_TRAIT source)
	if(target.status_traits)
		for(var/trait in target.status_traits)
			// Only remove if it's from job trait source
			if(HAS_TRAIT_FROM(target, trait, JOB_TRAIT))
				REMOVE_TRAIT(target, trait, JOB_TRAIT)
	
	// Apply source job's traits to target
	if(source_job && source_job.job_traits)
		for(var/trait in source_job.job_traits)
			ADD_TRAIT(target, trait, JOB_TRAIT)
	
	// Make sure racial traits are preserved for target's actual race
	if(target.dna?.species)
		// Re-apply any racial traits that might have been overwritten
		var/datum/species/S = target.dna.species
		if(S.species_traits)
			for(var/trait in S.species_traits)
				ADD_TRAIT(target, trait, SPECIES_TRAIT)
	
	to_chat(target, span_notice("职业特质已复制，种族特质保持不变。"))

/client/proc/cmd_debug_mob_lists()
	set category = "调试"
	set name = "调试生物列表"
	set desc = ""

	switch(input("哪个列表？") in list("玩家","管理员","生物","存活生物","死亡生物","客户端","已入场玩家"))
		if("玩家")
			to_chat(usr, jointext(GLOB.player_list,","))
		if("管理员")
			to_chat(usr, jointext(GLOB.admins,","))
		if("生物")
			to_chat(usr, jointext(GLOB.mob_list,","))
		if("存活生物")
			to_chat(usr, jointext(GLOB.alive_mob_list,","))
		if("死亡生物")
			to_chat(usr, jointext(GLOB.dead_mob_list,","))
		if("客户端")
			to_chat(usr, jointext(GLOB.clients,","))
		if("已入场玩家")
			to_chat(usr, jointext(GLOB.joined_player_list,","))

/client/proc/cmd_display_del_log()
	set category = "调试"
	set name = "显示 del() 日志"
	set desc = ""

	var/list/dellog = list("<B>本回合经过 qdel 的对象列表</B><BR><BR><ol>")
	sortTim(SSgarbage.items, cmp=/proc/cmp_qdel_item_time, associative = TRUE)
	for(var/path in SSgarbage.items)
		var/datum/qdel_item/I = SSgarbage.items[path]
		dellog += "<li><u>[path]</u><ul>"
		if (I.failures)
			dellog += "<li>失败次数：[I.failures]</li>"
		dellog += "<li>qdel() 次数：[I.qdels]</li>"
		dellog += "<li>Destroy() 耗时：[I.destroy_time]ms</li>"
		if (I.hard_deletes)
			dellog += "<li>硬删除总次数：[I.hard_deletes]</li>"
			dellog += "<li>硬删除耗时：[I.hard_delete_time]ms</li>"
		if (I.slept_destroy)
			dellog += "<li>休眠次数：[I.slept_destroy]</li>"
		if (I.no_respect_force)
			dellog += "<li>忽略强制参数：[I.no_respect_force]</li>"
		if (I.no_hint)
			dellog += "<li>未返回删除提示：[I.no_hint]</li>"
		dellog += "</ul></li>"

	dellog += "</ol>"

	usr << browse(dellog.Join(), "window=dellog")

/client/proc/cmd_display_overlay_log()
	set category = "调试"
	set name = "显示叠加图层日志"
	set desc = ""

	render_stats(SSoverlays.stats, src)

/client/proc/cmd_display_init_log()
	set category = "调试"
	set name = "显示 Initialize() 日志"
	set desc = ""

	usr << browse(replacetext(SSatoms.InitLog(), "\n", "<br>"), "window=initlog")

/client/proc/debug_huds(i as num)
	set category = "调试"
	set name = "调试状态栏"
	set desc = ""

	if(!holder)
		return
	debug_variables(GLOB.huds[i])

/client/proc/jump_to_ruin()
	set category = "调试"
	set name = "跳转至遗迹"
	set desc = ""
	if(!holder)
		return
	var/list/names = list()
	for(var/i in GLOB.ruin_landmarks)
		var/obj/effect/landmark/ruin/ruin_landmark = i
		var/datum/map_template/ruin/template = ruin_landmark.ruin_template

		var/count = 1
		var/name = template.name
		var/original_name = name

		while(name in names)
			count++
			name = "[original_name] ([count])"

		names[name] = ruin_landmark

	var/ruinname = input("选择遗迹", "跳转至遗迹") as null|anything in sortList(names)


	var/obj/effect/landmark/ruin/landmark = names[ruinname]

	if(istype(landmark))
		var/datum/map_template/ruin/template = landmark.ruin_template
		usr.forceMove(get_turf(landmark))
		to_chat(usr, span_name("[template.name]"))
		to_chat(usr, span_italics("[template.description]"))

/client/proc/toggle_medal_disable()
	set category = "调试"
	set name = "切换奖章禁用状态"
	set desc = ""

	if(!check_rights(R_DEBUG))
		return

	SSachievements.hub_enabled = !SSachievements.hub_enabled

	message_admins(span_adminnotice("[key_name_admin(src)] 已[SSachievements.hub_enabled ? "解除" : "启用"]奖章大厅锁定。"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Medal Disable") // If...
	log_admin("[key_name(src)] [SSachievements.hub_enabled ? "disabled" : "enabled"] the medal hub lockout.")

/client/proc/view_runtimes()
	set category = "调试"
	set name = "查看运行时错误"
	set desc = ""

	if(!holder)
		return

	GLOB.error_cache.show_to(src)

/client/proc/pump_random_event()
	set category = "调试"
	set name = "提前触发随机事件"
	set desc = ""
	if(!holder)
		return

	SSevents.scheduled = world.time

	message_admins(span_adminnotice("[key_name_admin(src)] 提前触发了随机事件。"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Pump Random Event")
	log_admin("[key_name(src)] pumped a random event.")

/client/proc/start_line_profiling()
	set category = "性能分析"
	set name = "开始逐行性能分析"
	set desc = ""

	LINE_PROFILE_START

	message_admins(span_adminnotice("[key_name_admin(src)] 开始了逐行性能分析。"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Start Line Profiling")
	log_admin("[key_name(src)] started line by line profiling.")

/client/proc/stop_line_profiling()
	set category = "性能分析"
	set name = "停止逐行性能分析"
	set desc = ""

	LINE_PROFILE_STOP

	message_admins(span_adminnotice("[key_name_admin(src)] 停止了逐行性能分析。"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stop Line Profiling")
	log_admin("[key_name(src)] stopped line by line profiling.")

/client/proc/show_line_profiling()
	set category = "性能分析"
	set name = "显示逐行性能分析"
	set desc = ""

	var/sortlist = list(
		"平均耗时"		=	/proc/cmp_profile_avg_time_dsc,
		"总耗时"	=	/proc/cmp_profile_time_dsc,
		"调用次数"	=	/proc/cmp_profile_count_dsc
	)
	var/sort = input(src, "排序方式？", "排序方式", "平均耗时") as null|anything in sortlist
	if (!sort)
		return
	sort = sortlist[sort]
	profile_show(src, sort)

/client/proc/reload_configuration()
	set category = "调试"
	set name = "重新加载配置"
	set desc = ""
	if(!check_rights(R_DEBUG))
		return
	if(alert(usr, "确定要从磁盘默认路径重新加载配置，并清除本回合的所有配置改动吗？", "确定重置？", "否", "是") == "是")
		config.admin_reload()
