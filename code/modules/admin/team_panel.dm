//Split into Team List -> Team Details ?
/datum/admins/proc/team_listing()
	var/list/content = list()
	for(var/datum/team/T in GLOB.antagonist_teams)
		content += "<h3>[T.name] - [T.type]</h3>"
		content += "<a href='?_src_=holder;[HrefToken()];team_command=rename_team;team=[REF(T)]'>重命名</a>"
		content += "<a href='?_src_=holder;[HrefToken()];team_command=delete_team;team=[REF(T)]'>删除</a>"
		content += "<a href='?_src_=holder;[HrefToken()];team_command=communicate;team=[REF(T)]'>发送消息</a>"
		for(var/command in T.get_admin_commands())
			content += "<a href='?src=[REF(T)];command=[command]'>[command]</a>"
		content += "<br>"
		content += "目标：<br><ol>"
		for(var/datum/objective/O in T.objectives)
			content += "<li>[O.explanation_text] - <a href='?_src_=holder;[HrefToken()];team_command=remove_objective;team=[REF(T)];tobjective=[REF(O)]'>移除</a></li>"
		content += "</ol><a href='?_src_=holder;[HrefToken()];team_command=add_objective;team=[REF(T)]'>添加目标</a><br>"
		content += "成员：<br><ul>"
		for(var/datum/mind/M in T.members)
			content += "<li>[M.name] - <a href='?_src_=holder;[HrefToken()];team_command=remove_member;team=[REF(T)];tmember=[REF(M)]'>移除成员</a></li>"
		content += "</ul><a href='?_src_=holder;[HrefToken()];team_command=add_member;team=[REF(T)]'>添加成员</a>"
		content += "<hr>"
	content += "<a href='?_src_=holder;[HrefToken()];team_command=create_team'>创建团队</a><br>"
	return content.Join()


/datum/admins/proc/check_teams()
	if(!SSticker.HasRoundStarted())
		alert("游戏尚未开始！")
		return

	var/datum/browser/popup = new(usr, "teams", "团队列表", 500, 500)
	popup.set_content(team_listing())
	popup.open()

/datum/admins/proc/admin_create_team(mob/user)
	var/team_name = stripped_input(user,"团队名称：")
	if(!team_name)
		return
	var/datum/team/custom/T = new()
	T.name = team_name

	message_admins("[key_name_admin(usr)] 创建了新的反派团队 [name]。")
	log_admin("[key_name(usr)] created new [name] antagonist team.")

/datum/team/proc/admin_rename(mob/user)
	var/old_name = name
	var/team_name = stripped_input(user,"新的团队名称：","团队重命名",old_name)
	if(!team_name)
		return
	name = team_name
	message_admins("[key_name_admin(usr)] 将团队 [old_name] 重命名为 [name]")
	log_admin("[key_name(usr)] renamed [old_name] team to [name]")

/datum/team/proc/admin_communicate(mob/user)
	var/message = input(user,"发送给团队的消息：","团队消息") as text|null
	if(!message)
		return
	for(var/datum/mind/M in members)
		to_chat(M.current,message)

	message_admins("[key_name_admin(usr)] 向团队 [name] 发送消息：[message]")
	log_admin("Team Message: [key_name(usr)] -> [name] team : [message]")

/datum/team/proc/admin_add_objective(mob/user)
	//any antag with get_team == src => add objective to that antag
	//otherwise create new custom antag
	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	var/selected_type = input("选择目标类型：", "目标类型") as null|anything in GLOB.admin_objective_list
	selected_type = GLOB.admin_objective_list[selected_type]
	if (!selected_type)
		return

	var/datum/objective/O = new selected_type
	O.team = src
	O.admin_edit(user)
	objectives |= O

	var/custom_antag_name

	for(var/datum/mind/M in members)
		var/datum/antagonist/team_antag
		for(var/datum/antagonist/A in M.antag_datums)
			if(A.get_team() == src)
				team_antag = A
		if(!team_antag)
			team_antag = new /datum/antagonist/custom
			if(!custom_antag_name)
				custom_antag_name = stripped_input(user, "自定义团队反派名称：", "自定义反派", "反派")
				if(!custom_antag_name)
					custom_antag_name = "团队成员"
			team_antag.name = custom_antag_name
			M.add_antag_datum(team_antag,src)
		team_antag.objectives |= O

	message_admins("[key_name_admin(usr)] 为 [name] 添加了目标\"[O.explanation_text]\"")
	log_admin("[key_name(usr)] added objective \"[O.explanation_text]\" to [name]")

/datum/team/proc/admin_remove_objective(mob/user,datum/objective/O)
	for(var/datum/mind/M in members)
		for(var/datum/antagonist/A in M.antag_datums)
			A.objectives -= O
	objectives -= O

	message_admins("[key_name_admin(usr)] 移除了 [name] 的目标\"[O.explanation_text]\"")
	log_admin("[key_name(usr)] removed objective \"[O.explanation_text]\" from [name]")
	//qdel maybe

/datum/team/proc/admin_add_member(mob/user)
	var/list/minds = list()
	for(var/mob/M in GLOB.mob_list)
		if(M.mind)
			minds |= M.mind
	var/datum/mind/value = input("选择新成员：", "新团队成员", null) as null|anything in sortNames(minds)
	if (!value)
		return

	message_admins("[key_name_admin(usr)] 将 [key_name_admin(value)] 加入团队 [name]")
	log_admin("[key_name(usr)] added [key_name(value)] as a member of [name] team")

	add_member(value)

/datum/team/proc/admin_remove_member(mob/user,datum/mind/M)
	message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 移出团队 [name]")
	log_admin("[key_name(usr)] removed [key_name(M)] from [name] team")
	remove_member(M)

//After a bit of consideration i block team deletion if there's any members left until unified objective handling is in.
/datum/team/proc/admin_delete(mob/user)
	if(members.len > 0)
		to_chat(user,"团队仍有成员，请先移除成员，并确保你了解此操作的影响。")
		return
	qdel(src)

/datum/team/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	var/commands = get_admin_commands()
	for(var/admin_command in commands)
		if(href_list["command"] == admin_command)
			var/datum/callback/C = commands[admin_command]
			C.Invoke(usr)
			return

/datum/team/proc/get_admin_commands()
	return list()

//Custom team subtype created by the panel, allow forcing hud for the team for now
/datum/team/custom
	var/datum/atom_hud/antag/custom_hud
	var/custom_hud_state = "traitor"

/datum/team/custom/add_member(datum/mind/new_member)
	. = ..()
	if(custom_hud)
		custom_hud.join_hud(new_member.current)
		set_antag_hud(new_member.current,custom_hud_state)

/datum/team/custom/remove_member(datum/mind/member)
	. = ..()
	if(custom_hud)
		custom_hud.leave_hud(member.current)

/datum/team/custom/get_admin_commands()
	. = ..()
	.["强制设置 HUD"] = CALLBACK(src,PROC_REF(admin_force_hud))

//This is here if you want admin created teams to tell each other apart easily.
/datum/team/custom/proc/admin_force_hud(mob/user)
	var/list/possible_icons = icon_states('icons/mob/hud.dmi')
	var/new_hud_state = input(user,"选择 HUD 图标状态","自定义 HUD","traitor") as null|anything in sortList(possible_icons)
	if(!new_hud_state)
		return
	//suppose could ask for color too
	custom_hud_state = new_hud_state
	custom_hud = new
	custom_hud.self_visible = TRUE
	GLOB.huds += custom_hud //Make it show in admin hud

	for(var/datum/mind/M in members)
		custom_hud.join_hud(M.current)
		set_antag_hud(M.current,custom_hud_state)
