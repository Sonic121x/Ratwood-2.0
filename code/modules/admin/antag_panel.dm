GLOBAL_VAR(antag_prototypes)

//Things to do somewhere in the future (If you're reading this feel free to do any of these)
//Add HrefTokens to these
//Make this template or at least remove + "<br>" with joins where you can grasp the big picture.
//Span classes for the headers, wrap sections in div's and style them.
//Move common admin commands to /mob (maybe integrate with vv dropdown so the list is one thing with some flag where to show it)
//Move objective initialization/editing stuff from mind to objectives and completely remove mind.objectives

/proc/cmp_antagpanel(datum/antagonist/A,datum/antagonist/B)
	var/a_cat = initial(A.antagpanel_category)
	var/b_cat = initial(B.antagpanel_category)
	if(!a_cat && !b_cat)
		return sorttext(initial(A.name),initial(B.name))
	return sorttext(b_cat,a_cat)

/datum/mind/proc/add_antag_wrapper(antag_type,mob/user)
	var/datum/antagonist/new_antag = new antag_type()
	new_antag.admin_add(src,user)
	//If something gone wrong/admin-add assign another antagonist due to whatever clean it up
	if(!new_antag.owner)
		qdel(new_antag)

/proc/listtrim(list/L)
	for(var/x in L)
		if(istext(x) && !x)
			L -= x
	return L

/datum/antagonist/proc/antag_panel()
	var/list/commands = list()
	for(var/command in get_admin_commands())
		commands += "<a href='?src=[REF(src)];command=[command]'>[command]</a>"
	var/command_part = commands.Join(" | ")
	var/data_part = antag_panel_data()
	var/objective_part = antag_panel_objectives()
	var/memory_part = antag_panel_memory()

	var/list/parts = listtrim(list(command_part,data_part,objective_part,memory_part))

	return parts.Join("<br>")

/datum/antagonist/proc/antag_panel_objectives()
	var/result = "<i><b>目标</b></i>：<br>"
	if (objectives.len == 0)
		result += "无目标<br>"
	else
		var/obj_count = 1
		for(var/datum/objective/objective in objectives)
			result += "<B>[obj_count]</B>：[objective.explanation_text] <a href='?src=[REF(owner)];obj_edit=[REF(objective)]'>编辑</a> <a href='?src=[REF(owner)];obj_delete=[REF(objective)]'>删除</a> <a href='?src=[REF(owner)];obj_completed=[REF(objective)]'><font color=[objective.completed ? "green" : "red"]>[objective.completed ? "标记为未完成" : "标记为已完成"]</font></a><br>"
			obj_count++
	result += "<a href='?src=[REF(owner)];obj_add=1;target_antag=[REF(src)]'>添加目标</a><br>"
	result += "<a href='?src=[REF(owner)];obj_announce=1'>公布目标</a><br>"
	return result

/datum/antagonist/proc/antag_panel_memory()
	var/out = "<b>记忆：</b><br>"
	out += antag_memory
	out += "<br><a href='?src=[REF(src)];memory_edit=1'>编辑记忆</a><br>"
	return out

/datum/mind/proc/get_common_admin_commands()
	var/common_commands = "<span>常用指令：</span>"
	if(ishuman(current))
		common_commands += "<a href='?src=[REF(src)];common=undress'>脱下衣物</a>"
	return common_commands

/datum/mind/proc/get_special_statuses()
	var/list/result = list()
	if(!current)
		result += span_bad("没有身体！")
	if(current && HAS_TRAIT(current, TRAIT_MINDSHIELD))
		result += span_good("心智受到保护")
	return result.Join(" | ")

/datum/mind/proc/traitor_panel()
	if(!SSticker.HasRoundStarted())
		alert("回合开始前无法使用！", "提示")
		return
	if(QDELETED(src))
		alert("此心智没有关联生物，或因某种原因已被删除！", "编辑记忆")
		return

	var/out = "<B>[name]</B>[(current && (current.real_name!=name))?"（当前角色：[current.real_name]）":""]<br>"
	out += "心智当前所属账号：[key] [active?"（已同步）":"（未同步）"]<br>"
	out += "分配职业：[assigned_role]。<a href='?src=[REF(src)];role_edit=1'>编辑</a><br>"
	out += "阵营与特殊身份：<b><font color='red'>[special_role]</font></b><br>"

	var/special_statuses = get_special_statuses()
	if(length(special_statuses))
		out += get_special_statuses() + "<br>"

	if(!GLOB.antag_prototypes)
		GLOB.antag_prototypes = list()
		for(var/antag_type in subtypesof(/datum/antagonist))
			var/datum/antagonist/A = new antag_type
			if(!A.rogue_enabled)
				continue
			var/cat_id = A.antagpanel_category
			if(!GLOB.antag_prototypes[cat_id])
				GLOB.antag_prototypes[cat_id] = list(A)
			else
				GLOB.antag_prototypes[cat_id] += A
	sortTim(GLOB.antag_prototypes,/proc/cmp_text_asc,associative=TRUE)

	var/list/sections = list()
	var/list/priority_sections = list()

	for(var/antag_category in GLOB.antag_prototypes)
		var/category_header = "<i><b>[antag_category]:</b></i>"
		var/list/antag_header_parts = list(category_header)

		var/datum/antagonist/current_antag
		var/list/possible_admin_antags = list()

		for(var/datum/antagonist/prototype in GLOB.antag_prototypes[antag_category])
			var/datum/antagonist/A = has_antag_datum(prototype.type)
			if(A)
				//We got the antag
				if(!current_antag)
					current_antag = A
				else
					continue //Let's skip subtypes of what we already shown.
			else if(prototype.show_in_antagpanel)
				if(prototype.can_be_owned(src))
					possible_admin_antags += "<a href='?src=[REF(src)];add_antag=[prototype.type]' title='[prototype.type]'>[prototype.name]</a>"
				else
					possible_admin_antags += "<a class='linkOff'>[prototype.name]</a>"
			else
				//We don't have it and it shouldn't be shown as an option to be added.
				continue

		if(!current_antag) //Show antagging options
			if(possible_admin_antags.len)
				antag_header_parts += span_highlight("无")
				antag_header_parts += possible_admin_antags
			else
				//If there's no antags to show in this category skip the section completely
				continue
		else //Show removal and current one
			priority_sections |= antag_category
			antag_header_parts += span_bad("[current_antag.name]")
			antag_header_parts += "<a href='?src=[REF(src)];remove_antag=[REF(current_antag)]'>移除</a>"


		//We aren't antag of this category, grab first prototype to check the prefs (This is pretty vague but really not sure how else to do this)
		var/datum/antagonist/pref_source = current_antag
		if(!pref_source)
			for(var/datum/antagonist/prototype in GLOB.antag_prototypes[antag_category])
				if(!prototype.show_in_antagpanel)
					continue
				pref_source = prototype
				break
		if(pref_source.job_rank)
			antag_header_parts += pref_source.enabled_in_preferences(src) ? "偏好中已启用" : "偏好中已禁用"

		//Traitor : None | Traitor | IAA
		//	Command1 | Command2 | Command3
		//	Secret Word : Banana
		//	Objectives:
		//		1.Do the thing [a][b]
		//		[a][b]
		//	Memory:
		//		Uplink Code: 777 Alpha
		var/cat_section = antag_header_parts.Join(" | ") + "<br>"
		if(current_antag)
			cat_section += current_antag.antag_panel()
		sections[antag_category] = cat_section

	for(var/s in priority_sections)
		out += sections[s]
	for(var/s in sections - priority_sections)
		out += sections[s]

	out += "<br>"

	//Common Memory
	var/common_memory = "<span>通用记忆：</span>"
	common_memory += memory
	common_memory += "<a href='?src=[REF(src)];memory_edit=1'>编辑记忆</a>"
	out += common_memory + "<br>"
	//Other stuff
	out += get_common_admin_commands()

	var/datum/browser/panel = new(usr, "traitorpanel", "", 600, 600)
	panel.set_content(out)
	panel.open()
	return
