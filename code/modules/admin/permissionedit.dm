/client/proc/edit_admin_permissions()
	set category = "-管理-"
	set name = "权限面板"
	set desc = "编辑管理员权限"
	if(!check_rights(R_PERMISSIONS))
		return
	usr.client.holder.edit_admin_permissions()

/datum/admins/proc/edit_admin_permissions(action, target, operation, page)
	if(!check_rights(R_PERMISSIONS))
		return
	var/list/output = list("<link rel='stylesheet' type='text/css' href='panels.css'><a href='?_src_=holder;[HrefToken()];editrightsbrowser=1'>\[权限\]</a>")
	if(action)
		output += " | <a href='?_src_=holder;[HrefToken()];editrightsbrowserlog=1;editrightspage=0'>\[日志\]</a> | <a href='?_src_=holder;[HrefToken()];editrightsbrowsermanage=1'>\[管理\]</a><hr style='background:#000000; border:0; height:3px'>"
	else
		output += "<br><a href='?_src_=holder;[HrefToken()];editrightsbrowserlog=1;editrightspage=0'>\[日志\]</a><br><a href='?_src_=holder;[HrefToken()];editrightsbrowsermanage=1'>\[管理\]</a>"
	if(action == 1)
		var/logcount = 0
		var/logssperpage = 20
		var/pagecount = 0
		page = text2num(page)
		var/datum/DBQuery/query_count_admin_logs = SSdbcore.NewQuery(
			"SELECT COUNT(id) FROM [format_table_name("admin_log")] WHERE (:target IS NULL OR adminckey = :target) AND (:operation IS NULL OR operation = :operation)",
			list("target" = target, "operation" = operation)
		)
		if(!query_count_admin_logs.warn_execute())
			qdel(query_count_admin_logs)
			return
		if(query_count_admin_logs.NextRow())
			logcount = text2num(query_count_admin_logs.item[1])
		qdel(query_count_admin_logs)
		if(logcount > logssperpage)
			output += "<br><b>页码：</b>"
			while(logcount > 0)
				output += "|<a href='?_src_=holder;[HrefToken()];editrightsbrowserlog=1;editrightstarget=[target];editrightsoperation=[operation];editrightspage=[pagecount]'>[pagecount == page ? "<b>\[[pagecount]\]</b>" : "\[[pagecount]\]"]</a>"
				logcount -= logssperpage
				pagecount++
			output += "|"
		var/datum/DBQuery/query_search_admin_logs = SSdbcore.NewQuery({"
			SELECT
				datetime,
				round_id,
				IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE ckey = adminckey), adminckey),
				operation,
				IF(ckey IS NULL, target, byond_key),
				log
			FROM [format_table_name("admin_log")]
			LEFT JOIN [format_table_name("player")] ON target = ckey
			WHERE (:target IS NULL OR ckey = :target) AND (:operation IS NULL OR operation = :operation)
			ORDER BY datetime DESC
			LIMIT :skip, :take
		"}, list("target" = target, "operation" = operation, "skip" = logssperpage * page, "take" = logssperpage))
		if(!query_search_admin_logs.warn_execute())
			qdel(query_search_admin_logs)
			return
		while(query_search_admin_logs.NextRow())
			var/datetime = query_search_admin_logs.item[1]
			var/round_id = query_search_admin_logs.item[2]
			var/admin_key  = query_search_admin_logs.item[3]
			operation = query_search_admin_logs.item[4]
			target = query_search_admin_logs.item[5]
			var/log = query_search_admin_logs.item[6]
			output += "<p style='margin:0px'><b>[datetime] | 回合编号 [round_id] | 管理员 [admin_key] | 对 [target] 执行操作 [operation]</b><br>[log]</p><hr style='background:#000000; border:0; height:3px'>"
		qdel(query_search_admin_logs)
	if(action == 2)
		output += "<h3>职级无效的管理员 ckey</h3>"
		var/datum/DBQuery/query_check_admin_errors = SSdbcore.NewQuery("SELECT IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("admin")].ckey), ckey), [format_table_name("admin")].`rank` FROM [format_table_name("admin")] LEFT JOIN [format_table_name("admin_ranks")] ON [format_table_name("admin_ranks")].`rank` = [format_table_name("admin")].`rank` WHERE [format_table_name("admin_ranks")].`rank` IS NULL")
		if(!query_check_admin_errors.warn_execute())
			qdel(query_check_admin_errors)
			return
		while(query_check_admin_errors.NextRow())
			var/admin_key = query_check_admin_errors.item[1]
			var/admin_rank = query_check_admin_errors.item[2]
			output += "[admin_key] 的职级 [admin_rank] 不存在 | <a href='?_src_=holder;[HrefToken()];editrightsbrowsermanage=1;editrightschange=[admin_key]'>\[更改职级\]</a> | <a href='?_src_=holder;[HrefToken()];editrightsbrowsermanage=1;editrightsremove=[admin_key]'>\[移除\]</a>"
			output += "<hr style='background:#000000; border:0; height:1px'>"
		qdel(query_check_admin_errors)
		output += "<h3>未使用的职级</h3>"
		var/datum/DBQuery/query_check_unused_rank = SSdbcore.NewQuery("SELECT [format_table_name("admin_ranks")].`rank`, flags, exclude_flags, can_edit_flags FROM [format_table_name("admin_ranks")] LEFT JOIN [format_table_name("admin")] ON [format_table_name("admin")].`rank` = [format_table_name("admin_ranks")].`rank` WHERE [format_table_name("admin")].`rank` IS NULL")
		if(!query_check_unused_rank.warn_execute())
			qdel(query_check_unused_rank)
			return
		while(query_check_unused_rank.NextRow())
			var/admin_rank = query_check_unused_rank.item[1]
			output += {"没有管理员使用职级 [admin_rank] | <a href='?_src_=holder;[HrefToken()];editrightsbrowsermanage=1;editrightsremoverank=[admin_rank]'>\[移除\]</a>
			<br>权限：[rights2text(text2num(query_check_unused_rank.item[2])," ")]
			<br>禁用权限：[rights2text(text2num(query_check_unused_rank.item[3])," ", "-")]
			<br>可编辑权限：[rights2text(text2num(query_check_unused_rank.item[4])," ", "*")]
			<hr style='background:#000000; border:0; height:1px'>"}
		qdel(query_check_unused_rank)
	else if(!action)
		output += {"
		<head>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
		<title>权限面板</title>
		<script type='text/javascript' src='search.js'></script>
		</head>
		<body onload='selectTextField();updateSearch();'>
		<div id='main'><table id='searchable' cellspacing='0'>
		<tr class='title'>
		<th style='width:150px;'>CKEY <a class='small' href='?src=[REF(src)];[HrefToken()];editrights=add'>\[+\]</a></th>
		<th style='width:125px;'>职级</th>
		<th style='width:40%;'>权限</th>
		<th style='width:20%;'>禁用权限</th>
		<th style='width:40%;'>可编辑权限</th>
		</tr>
		"}
		for(var/adm_ckey in GLOB.admin_datums+GLOB.deadmins)
			var/datum/admins/D = GLOB.admin_datums[adm_ckey]
			if(!D)
				D = GLOB.deadmins[adm_ckey]
				if (!D)
					continue
			var/deadminlink = ""
			if(D.owner)
				adm_ckey = D.owner.key
			if (D.deadmined)
				deadminlink = " <a class='small' href='?src=[REF(src)];[HrefToken()];editrights=activate;key=[adm_ckey]'>\[恢复权限\]</a>"
			else
				deadminlink = " <a class='small' href='?src=[REF(src)];[HrefToken()];editrights=deactivate;key=[adm_ckey]'>\[停用权限\]</a>"
			output += "<tr>"
			output += "<td style='text-align:center;'>[adm_ckey]<br>[deadminlink]<a class='small' href='?src=[REF(src)];[HrefToken()];editrights=remove;key=[adm_ckey]'>\[-\]</a><a class='small' href='?src=[REF(src)];[HrefToken()];editrights=sync;key=[adm_ckey]'>\[同步数据库\]</a></td>"
			output += "<td><a href='?src=[REF(src)];[HrefToken()];editrights=rank;key=[adm_ckey]'>[D.rank.name]</a></td>"
			output += "<td><a class='small' href='?src=[REF(src)];[HrefToken()];editrights=permissions;key=[adm_ckey]'>[rights2text(D.rank.include_rights," ")]</a></td>"
			output += "<td><a class='small' href='?src=[REF(src)];[HrefToken()];editrights=permissions;key=[adm_ckey]'>[rights2text(D.rank.exclude_rights," ", "-")]</a></td>"
			output += "<td><a class='small' href='?src=[REF(src)];[HrefToken()];editrights=permissions;key=[adm_ckey]'>[rights2text(D.rank.can_edit_rights," ", "*")]</a></td>"
			output += "</tr>"
		output += "</table></div><div id='top'><b>搜索：</b> <input type='text' id='filter' value='' style='width:70%;' onkeyup='updateSearch();'></div></body>"
	if(QDELETED(usr))
		return
	usr << browse("<!DOCTYPE html><html>[jointext(output, "")]</html>","window=editrights;size=1000x650")

/datum/admins/proc/edit_rights_topic(list/href_list)
	if(!check_rights(R_PERMISSIONS))
		message_admins("[key_name_admin(usr)] 尝试编辑管理员权限，但权限不足。")
		log_admin("[key_name(usr)] attempted to edit admin permissions without sufficient rights.")
		return
	if(IsAdminAdvancedProcCall())
		to_chat(usr, span_adminprefix("已阻止管理员编辑：检测到高级过程调用。"))
		return
	var/admin_key = href_list["key"]
	var/admin_ckey = ckey(admin_key)
	var/datum/admins/D = GLOB.admin_datums[admin_ckey]
	var/use_db
	var/task = href_list["editrights"]
	var/skip
	var/legacy_only
	if(task == "activate" || task == "deactivate" || task == "sync")
		skip = TRUE
	if(!CONFIG_GET(flag/admin_legacy_system) && CONFIG_GET(flag/protect_legacy_admins) && task == "rank")
		if(admin_ckey in GLOB.protected_admins)
			to_chat(usr, span_adminprefix("服务器配置禁止编辑这名管理员的职级。"))
			return
	if(!CONFIG_GET(flag/admin_legacy_system) && CONFIG_GET(flag/protect_legacy_ranks) && task == "permissions")
		if(D.rank in GLOB.protected_ranks)
			to_chat(usr, span_adminprefix("服务器配置禁止编辑此职级的权限标志。"))
			return
	if(CONFIG_GET(flag/load_legacy_ranks_only) && (task == "add" || task == "rank" || task == "permissions"))
		to_chat(usr, span_adminprefix("数据库职级加载已禁用，只能临时修改职级权限，无法永久创建新职级。"))
		legacy_only = TRUE
	if(check_rights(R_DBRANKS, FALSE))
		if(!skip)
			if(!SSdbcore.Connect())
				to_chat(usr, span_danger("无法连接数据库，修改仅临时生效。"))
				use_db = FALSE
			else
				use_db = alert("永久修改会保存至数据库并在后续回合生效；临时修改只影响当前回合", "永久还是临时？", "永久", "临时", "取消")
				if(use_db == "取消")
					return
				if(use_db == "永久")
					use_db = TRUE
				else
					use_db = FALSE
			if(QDELETED(usr))
				return
	if(task != "add")
		D = GLOB.admin_datums[admin_ckey]
		if(!D)
			D = GLOB.deadmins[admin_ckey]
		if(!D)
			return
		if((task != "sync") && !check_if_greater_rights_than_holder(D))
			message_admins("[key_name_admin(usr)] 尝试更改 [admin_key] 的职级，但权限不足。")
			log_admin("[key_name(usr)] attempted to change the rank of [admin_key] without sufficient rights.")
			return
	switch(task)
		if("add")
			admin_ckey = add_admin(admin_ckey, admin_key, use_db)
			if(!admin_ckey)
				return
			change_admin_rank(admin_ckey, admin_key, use_db, null, legacy_only)
		if("remove")
			remove_admin(admin_ckey, admin_key, use_db, D)
		if("rank")
			change_admin_rank(admin_ckey, admin_key, use_db, D, legacy_only)
		if("permissions")
			change_admin_flags(admin_ckey, admin_key, use_db, D, legacy_only)
		if("activate")
			force_readmin(admin_key, D)
		if("deactivate")
			force_deadmin(admin_key, D)
		if("sync")
			sync_lastadminrank(admin_ckey, admin_key, D)
	edit_admin_permissions()

/datum/admins/proc/add_admin(admin_ckey, admin_key, use_db)
	if(admin_ckey)
		. = admin_ckey
	else
		admin_key = input("新管理员的账号","管理员账号") as text|null
		. = ckey(admin_key)
	if(!.)
		return FALSE
	if(!admin_ckey && (. in GLOB.admin_datums+GLOB.deadmins))
		to_chat(usr, span_danger("[admin_key] 已经是管理员。"))
		return FALSE
	if(use_db)
		//if an admin exists without a datum they won't be caught by the above
		var/datum/DBQuery/query_admin_in_db = SSdbcore.NewQuery(
			"SELECT 1 FROM [format_table_name("admin")] WHERE ckey = :ckey",
			list("ckey" = .)
		)
		if(!query_admin_in_db.warn_execute())
			qdel(query_admin_in_db)
			return FALSE
		if(query_admin_in_db.NextRow())
			qdel(query_admin_in_db)
			to_chat(usr, span_danger("[admin_key] 已在管理员数据库中。如果管理员列表中没有显示，请检查“管理”页面。"))
			return FALSE
		qdel(query_admin_in_db)
		var/datum/DBQuery/query_add_admin = SSdbcore.NewQuery(
			"INSERT INTO [format_table_name("admin")] (ckey, `rank`) VALUES (:ckey, 'NEW ADMIN')",
			list("ckey" = .)
		)
		if(!query_add_admin.warn_execute())
			qdel(query_add_admin)
			return FALSE
		qdel(query_add_admin)
		var/datum/DBQuery/query_add_admin_log = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log)
			VALUES (:time, :round_id, :adminckey, INET_ATON(:adminip), 'add admin', :target, CONCAT('New admin added: ', :target))
		"}, list("time" = SQLtime(), "round_id" = "[GLOB.round_id]", "adminckey" = usr.ckey, "adminip" = usr.client.address, "target" = .))
		if(!query_add_admin_log.warn_execute())
			qdel(query_add_admin_log)
			return FALSE
		qdel(query_add_admin_log)

/datum/admins/proc/remove_admin(admin_ckey, admin_key, use_db, datum/admins/D)
	if(alert("确定要移除 [admin_ckey] 吗？","确认移除","移除","取消") == "移除")
		GLOB.admin_datums -= admin_ckey
		GLOB.deadmins -= admin_ckey
		if(D)
			D.disassociate()
		var/m1 = "[key_name_admin(usr)] [use_db ? "永久" : "临时"]将 [admin_key] 从管理员名单中移除"
		var/m2 = "[key_name(usr)] removed [admin_key] from the admins list [use_db ? "permanently" : "temporarily"]"
		if(use_db)
			var/datum/DBQuery/query_add_rank = SSdbcore.NewQuery(
				"DELETE FROM [format_table_name("admin")] WHERE ckey = :ckey",
				list("ckey" = admin_ckey)
			)
			if(!query_add_rank.warn_execute())
				qdel(query_add_rank)
				return
			qdel(query_add_rank)
			var/datum/DBQuery/query_add_rank_log = SSdbcore.NewQuery({"
				INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log)
				VALUES (:time, :round_id, :adminckey, INET_ATON(:adminip), 'remove admin', :admin_ckey, CONCAT('Admin removed: ', :admin_ckey))
			"}, list("time" = SQLtime(), "round_id" = "[GLOB.round_id]", "adminckey" = usr.ckey, "adminip" = usr.client.address, "admin_ckey" = admin_ckey))
			if(!query_add_rank_log.warn_execute())
				qdel(query_add_rank_log)
				return
			qdel(query_add_rank_log)
			sync_lastadminrank(admin_ckey, admin_key)
		message_admins(m1)
		log_admin(m2)

/datum/admins/proc/force_readmin(admin_key, datum/admins/D)
	if(!D || !D.deadmined)
		return
	D.activate()
	message_admins("[key_name_admin(usr)] 强制恢复了 [admin_key] 的管理员权限")
	log_admin("[key_name(usr)] forcefully readmined [admin_key]")

/datum/admins/proc/force_deadmin(admin_key, datum/admins/D)
	if(!D || D.deadmined)
		return
	message_admins("[key_name_admin(usr)] 强制停用了 [admin_key] 的管理员权限")
	log_admin("[key_name(usr)] forcefully deadmined [admin_key]")
	D.deactivate() //after logs so the deadmined admin can see the message.

/datum/admins/proc/auto_deadmin()
	to_chat(owner, span_interface("我现在是一名普通玩家。"))
	var/old_owner = owner
	deactivate()
	message_admins("[old_owner] 的管理员权限已按自动停用配置停用。")
	log_admin("[old_owner] deadmined via auto-deadmin config.")
	return TRUE

/datum/admins/proc/change_admin_rank(admin_ckey, admin_key, use_db, datum/admins/D, legacy_only)
	var/datum/admin_rank/R
	var/list/rank_names = list()
	if(!use_db || (use_db && !legacy_only))
		rank_names += "*新建职级*"
	for(R in GLOB.admin_ranks)
		if((R.rights & usr.client.holder.rank.can_edit_rights) == R.rights)
			rank_names[R.name] = R
	var/new_rank = input("请选择职级", "新职级") as null|anything in rank_names
	if(new_rank == "*新建职级*")
		new_rank = input("请输入新职级", "新建自定义职级") as text|null
	if(!new_rank)
		return
	R = rank_names[new_rank]
	if(!R) //rank with that name doesn't exist yet - make it
		if(D)
			R = new(new_rank, D.rank.rights) //duplicate our previous admin_rank but with a new name
		else
			R = new(new_rank) //blank new admin_rank
		GLOB.admin_ranks += R
	var/m1 = "[key_name_admin(usr)] [use_db ? "永久" : "临时"]将 [admin_key] 的管理员职级改为 [new_rank]"
	var/m2 = "[key_name(usr)] edited the admin rank of [admin_key] to [new_rank] [use_db ? "permanently" : "temporarily"]"
	if(use_db)
		//if a player was tempminned before having a permanent change made to their rank they won't yet be in the db
		var/old_rank
		var/datum/DBQuery/query_admin_in_db = SSdbcore.NewQuery(
			"SELECT `rank` FROM [format_table_name("admin")] WHERE ckey = :admin_ckey",
			list("admin_ckey" = admin_ckey)
		)
		if(!query_admin_in_db.warn_execute())
			qdel(query_admin_in_db)
			return
		if(!query_admin_in_db.NextRow())
			add_admin(admin_ckey, admin_key, TRUE)
			old_rank = "NEW ADMIN"
		else
			old_rank = query_admin_in_db.item[1]
		qdel(query_admin_in_db)
		//similarly if a temp rank is created it won't be in the db if someone is permanently changed to it
		var/datum/DBQuery/query_rank_in_db = SSdbcore.NewQuery(
			"SELECT 1 FROM [format_table_name("admin_ranks")] WHERE `rank` = :new_rank",
			list("new_rank" = new_rank)
		)
		if(!query_rank_in_db.warn_execute())
			qdel(query_rank_in_db)
			return
		if(!query_rank_in_db.NextRow())
			QDEL_NULL(query_rank_in_db)
			var/datum/DBQuery/query_add_rank = SSdbcore.NewQuery({"
				INSERT INTO [format_table_name("admin_ranks")] (`rank`, flags, exclude_flags, can_edit_flags)
				VALUES (:new_rank, '0', '0', '0')
			"}, list("new_rank" = new_rank))
			if(!query_add_rank.warn_execute())
				qdel(query_add_rank)
				return
			qdel(query_add_rank)
			var/datum/DBQuery/query_add_rank_log = SSdbcore.NewQuery({"
				INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log)
				VALUES (:time, :round_id, :adminckey, INET_ATON(:adminip), 'add rank', :new_rank, CONCAT('New rank added: ', :new_rank))
			"}, list("time" = SQLtime(), "round_id" = "[GLOB.round_id]", "adminckey" = usr.ckey, "adminip" = usr.client.address, "new_rank" = new_rank))
			if(!query_add_rank_log.warn_execute())
				qdel(query_add_rank_log)
				return
			qdel(query_add_rank_log)
		qdel(query_rank_in_db)
		var/datum/DBQuery/query_change_rank = SSdbcore.NewQuery(
			"UPDATE [format_table_name("admin")] SET `rank` = :new_rank WHERE ckey = :admin_ckey",
			list("new_rank" = new_rank, "admin_ckey" = admin_ckey)
		)
		if(!query_change_rank.warn_execute())
			qdel(query_change_rank)
			return
		qdel(query_change_rank)
		var/datum/DBQuery/query_change_rank_log = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log)
			VALUES (:time, :round_id, :adminckey, INET_ATON(:adminip), 'change admin rank', :target, CONCAT('Rank of ', :target, ' changed from ', :old_rank, ' to ', :new_rank))
		"}, list("time" = SQLtime(), "round_id" = "[GLOB.round_id]", "adminckey" = usr.ckey, "adminip" = usr.client.address, "target" = admin_ckey, "old_rank" = old_rank, new_rank = "new_rank"))
		if(!query_change_rank_log.warn_execute())
			qdel(query_change_rank_log)
			return
		qdel(query_change_rank_log)
	if(D) //they were previously an admin
		D.disassociate() //existing admin needs to be disassociated
		D.rank = R //set the admin_rank as our rank
		var/client/C = GLOB.directory[admin_ckey]
		D.associate(C)
	else
		D = new(R, admin_ckey, TRUE) //new admin
	message_admins(m1)
	log_admin(m2)

/datum/admins/proc/change_admin_flags(admin_ckey, admin_key, use_db, datum/admins/D, legacy_only)
	var/new_flags = input_bitfield(usr, "授予权限标志<br>[use_db ? "这会影响此职级的所有管理员。" : "这只会影响当前管理员 [admin_key]"]", "admin_flags", D.rank.include_rights, 350, 590, allowed_edit_list = usr.client.holder.rank.can_edit_rights)
	if(isnull(new_flags))
		return
	var/new_exclude_flags = input_bitfield(usr, "禁用权限标志<br>此处启用的标志会从职级权限中移除。<br>禁用标志优先于授予标志。<br>[use_db ? "这会影响此职级的所有管理员。" : "这只会影响当前管理员 [admin_key]"]", "admin_flags", D.rank.exclude_rights, 350, 670, "red", usr.client.holder.rank.can_edit_rights)
	if(isnull(new_exclude_flags))
		return
	var/new_can_edit_flags = input_bitfield(usr, "可编辑权限标志<br>此职级有权使用权限面板时，可以编辑下列标志。<br>无法将管理员改为拥有此处未列出标志的职级。<br>[use_db ? "这会影响此职级的所有管理员。" : "这只会影响当前管理员 [admin_key]"]", "admin_flags", D.rank.can_edit_rights, 350, 710, allowed_edit_list = usr.client.holder.rank.can_edit_rights)
	if(isnull(new_can_edit_flags))
		return
	var/m1 = "[key_name_admin(usr)] [use_db ? "永久修改了职级 [D.rank.name] 的权限" : "临时修改了 [admin_key] 的权限"]"
	var/m2 = "[key_name(usr)] edited the permissions of [use_db ? " rank [D.rank.name] permanently" : "[admin_key] temporarily"]"
	if(use_db || legacy_only)
		var/rank_name = D.rank.name
		var/old_flags
		var/old_exclude_flags
		var/old_can_edit_flags
		var/datum/DBQuery/query_get_rank_flags = SSdbcore.NewQuery(
			"SELECT flags, exclude_flags, can_edit_flags FROM [format_table_name("admin_ranks")] WHERE `rank` = :rank_name",
			list("rank_name" = rank_name)
		)
		if(!query_get_rank_flags.warn_execute())
			qdel(query_get_rank_flags)
			return
		if(query_get_rank_flags.NextRow())
			old_flags = text2num(query_get_rank_flags.item[1])
			old_exclude_flags = text2num(query_get_rank_flags.item[2])
			old_can_edit_flags = text2num(query_get_rank_flags.item[3])
		qdel(query_get_rank_flags)
		var/datum/DBQuery/query_change_rank_flags = SSdbcore.NewQuery(
			"UPDATE [format_table_name("admin_ranks")] SET flags = :new_flags, exclude_flags = :new_exclude_flags, can_edit_flags = :new_can_edit_flags WHERE `rank` = :rank_name",
			list("new_flags" = new_flags, "new_exclude_flags" = new_exclude_flags, "new_can_edit_flags" = new_can_edit_flags, "rank_name" = rank_name)
		)
		if(!query_change_rank_flags.warn_execute())
			qdel(query_change_rank_flags)
			return
		qdel(query_change_rank_flags)
		var/log_message = "Permissions of [rank_name] changed from[rights2text(old_flags," ")][rights2text(old_exclude_flags," ", "-")][rights2text(old_can_edit_flags," ", "*")] to[rights2text(new_flags," ")][rights2text(new_exclude_flags," ", "-")][rights2text(new_can_edit_flags," ", "*")]"
		var/datum/DBQuery/query_change_rank_flags_log = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log)
			VALUES (:time, :round_id, :adminckey, INET_ATON(:adminip), 'change rank flags', :rank_name, :log)
		"}, list("time" = SQLtime(), "round_id" = "[GLOB.round_id]", "adminckey" = usr.ckey, "adminip" = usr.client.address, "rank_name" = rank_name, "log" = log_message))
		if(!query_change_rank_flags_log.warn_execute())
			qdel(query_change_rank_flags_log)
			return
		qdel(query_change_rank_flags_log)
		for(var/datum/admin_rank/R in GLOB.admin_ranks)
			if(R.name != D.rank.name)
				continue
			R.rights = new_flags &= ~new_exclude_flags
			R.exclude_rights = new_exclude_flags
			R.include_rights = new_flags
			R.can_edit_rights = new_can_edit_flags
		for(var/i in GLOB.admin_datums+GLOB.deadmins)
			var/datum/admins/A = GLOB.admin_datums[i]
			if(!A)
				A = GLOB.deadmins[i]
				if (!A)
					continue
			if(A.rank.name != D.rank.name)
				continue
			var/client/C = GLOB.directory[A.target]
			A.disassociate()
			A.associate(C)
	else
		D.disassociate()
		if(!findtext(D.rank.name, "([admin_ckey])")) //not a modified subrank, need to duplicate the admin_rank datum to prevent modifying others too
			D.rank = new("[D.rank.name]([admin_ckey])", new_flags, new_exclude_flags, new_can_edit_flags) //duplicate our previous admin_rank but with a new name
			//we don't add this clone to the admin_ranks list, as it is unique to that ckey
		else
			D.rank.rights = new_flags &= ~new_exclude_flags
			D.rank.include_rights = new_flags
			D.rank.exclude_rights = new_exclude_flags
			D.rank.can_edit_rights = new_can_edit_flags
		var/client/C = GLOB.directory[admin_ckey] //find the client with the specified ckey (if they are logged in)
		D.associate(C) //link up with the client and add verbs
	message_admins(m1)
	log_admin(m2)

/datum/admins/proc/remove_rank(admin_rank)
	if(!admin_rank)
		return
	for(var/datum/admin_rank/R in GLOB.admin_ranks)
		if(R.name == admin_rank && (!(R.rights & usr.client.holder.rank.can_edit_rights) == R.rights))
			to_chat(usr, span_adminprefix("你无法编辑此职级的全部权限，因此不允许删除该职级。"))
			return
	if(!CONFIG_GET(flag/admin_legacy_system) && CONFIG_GET(flag/protect_legacy_ranks) && (admin_rank in GLOB.protected_ranks))
		to_chat(usr, span_adminprefix("不允许删除受保护的职级，必须从 admin_ranks.txt 中移除。"))
		return
	if(CONFIG_GET(flag/load_legacy_ranks_only))
		to_chat(usr, span_adminprefix("数据库职级加载禁用时不允许删除职级。"))
		return
	var/datum/DBQuery/query_admins_with_rank = SSdbcore.NewQuery(
		"SELECT 1 FROM [format_table_name("admin")] WHERE `rank` = :admin_rank",
		list("admin_rank" = admin_rank)
	)
	if(!query_admins_with_rank.warn_execute())
		qdel(query_admins_with_rank)
		return
	if(query_admins_with_rank.NextRow())
		qdel(query_admins_with_rank)
		to_chat(usr, span_danger("错误：尝试删除仍在使用的职级；请告知开发者，这不应该发生。"))
		return
	qdel(query_admins_with_rank)
	if(alert("确定要移除职级 [admin_rank] 吗？","确认移除","移除","取消") == "移除")
		var/m1 = "[key_name_admin(usr)] 永久移除了职级 [admin_rank]"
		var/m2 = "[key_name(usr)] removed rank [admin_rank] permanently"
		var/datum/DBQuery/query_add_rank = SSdbcore.NewQuery(
			"DELETE FROM [format_table_name("admin_ranks")] WHERE `rank` = :admin_rank",
			list("admin_rank" = admin_rank)
		)
		if(!query_add_rank.warn_execute())
			qdel(query_add_rank)
			return
		qdel(query_add_rank)
		var/datum/DBQuery/query_add_rank_log = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log)
			VALUES (:time, :round_id, :adminckey, INET_ATON(:adminip), 'remove rank', :admin_rank, CONCAT('Rank removed: ', :admin_rank))
		"}, list("time" = SQLtime(), "round_id" = "[GLOB.round_id]", "adminckey" = usr.ckey, "adminip" = usr.client.address, "admin_rank" = admin_rank))
		if(!query_add_rank_log.warn_execute())
			qdel(query_add_rank_log)
			return
		qdel(query_add_rank_log)
		message_admins(m1)
		log_admin(m2)

/datum/admins/proc/sync_lastadminrank(admin_ckey, admin_key, datum/admins/D)
	var/sqlrank = "Player"
	if (D)
		sqlrank = D.rank.name
	var/datum/DBQuery/query_sync_lastadminrank = SSdbcore.NewQuery(
		"UPDATE [format_table_name("player")] SET lastadminrank = :rank WHERE ckey = :ckey",
		list("rank" = sqlrank, "ckey" = admin_ckey)
	)
	if(!query_sync_lastadminrank.warn_execute())
		qdel(query_sync_lastadminrank)
		return
	qdel(query_sync_lastadminrank)
	to_chat(usr, span_admin("已成功同步 [admin_key]。"))
