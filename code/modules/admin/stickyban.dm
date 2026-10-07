/datum/admins/proc/stickyban(action,data)
	if(!check_rights(R_BAN))
		return
	switch (action)
		if ("show")
			stickyban_show()
		if ("add")
			var/list/ban = list()
			var/ckey
			ban["admin"] = usr.ckey
			ban["type"] = list("sticky")
			ban["reason"] = "(InGameBan)([usr.key])" //this will be displayed in dd only

			if (data["ckey"])
				ckey = ckey(data["ckey"])
			else
				ckey = input(usr,"Ckey","Ckey","") as text|null
				if (!ckey)
					return
				ckey = ckey(ckey)
			ban["ckey"] = ckey

			if (get_stickyban_from_ckey(ckey))
				to_chat(usr, span_adminnotice("错误：无法添加关联封禁，该玩家已有生效的关联封禁。"))
				return

			if (data["reason"])
				ban["message"] = data["reason"]
			else
				var/reason = input(usr,"原因","封禁原因","规避封禁") as text|null
				if (!reason)
					return
				ban["message"] = "[reason]"

			if(SSdbcore.Connect())
				var/datum/DBQuery/query_create_stickyban = SSdbcore.NewQuery({"
					INSERT INTO [format_table_name("stickyban")] (ckey, reason, banning_admin)
					VALUES (:ckey, :message, :banning_admin)
				"}, list("ckey" = ckey, "message" = ban["message"], "banning_admin" = usr.ckey))
				if (query_create_stickyban.warn_execute())
					ban["fromdb"] = TRUE
				qdel(query_create_stickyban)

			world.SetConfig("ban",ckey,list2stickyban(ban))
			ban = stickyban2list(list2stickyban(ban))
			ban["matches_this_round"] = list()
			ban["existing_user_matches_this_round"] = list()
			ban["admin_matches_this_round"] = list()
			ban["pending_matches_this_round"] = list()
			SSstickyban.cache[ckey] = ban

			log_admin_private("[key_name(usr)] has stickybanned [ckey].\nReason: [ban["message"]]")
			message_admins(span_adminnotice("[key_name_admin(usr)] 对 [ckey] 实施了关联封禁。\n原因：[ban["message"]]"))

		if ("remove")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]

			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁！"))
				return
			if (alert("确定移除 [ckey] 的关联封禁吗？","确认","是","否") == "否")
				return
			if (!get_stickyban_from_ckey(ckey))
				to_chat(usr, span_adminnotice("错误：该封禁已不存在。"))
				return
			world.SetConfig("ban",ckey, null)
			SSstickyban.cache -= ckey

			if (SSdbcore.Connect())
				SSdbcore.QuerySelect(list(
					SSdbcore.NewQuery("DELETE FROM [format_table_name("stickyban")] WHERE ckey = :ckey", list("ckey" = ckey)),
					SSdbcore.NewQuery("DELETE FROM [format_table_name("stickyban_matched_ckey")] WHERE stickyban = :ckey", list("ckey" = ckey)),
					SSdbcore.NewQuery("DELETE FROM [format_table_name("stickyban_matched_cid")] WHERE stickyban = :ckey", list("ckey" = ckey)),
					SSdbcore.NewQuery("DELETE FROM [format_table_name("stickyban_matched_ip")] WHERE stickyban = :ckey", list("ckey" = ckey))
				), warn = TRUE, qdel = TRUE)


			log_admin_private("[key_name(usr)] removed [ckey]'s stickyban")
			message_admins(span_adminnotice("[key_name_admin(usr)] 移除了 [ckey] 的关联封禁"))

		if ("remove_alt")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			if (!data["alt"])
				return
			var/alt = ckey(data["alt"])
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁！"))
				return

			var/key = LAZYACCESS(ban["keys"], alt)
			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 未关联至 [ckey] 的关联封禁！"))
				return

			if (alert("确定解除 [alt] 与 [ckey] 的关联封禁之间的关联吗？\n注意：BYOND 仍可能重新关联两者，请使用 \[豁免] 使该账号免受封禁。","确认","是","否") == "否")
				return

			//we have to do this again incase something changes
			ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：该封禁已不存在。"))
				return

			key = LAZYACCESS(ban["keys"], alt)

			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 与 [ckey] 的关联封禁之间的关联已不存在。"))
				return

			LAZYREMOVE(ban["keys"], alt)
			world.SetConfig("ban",ckey,list2stickyban(ban))

			SSstickyban.cache[ckey] = ban

			if (SSdbcore.Connect())
				var/datum/DBQuery/query_remove_stickyban_alt = SSdbcore.NewQuery(
					"DELETE FROM [format_table_name("stickyban_matched_ckey")] WHERE stickyban = :ckey AND matched_ckey = :alt",
					list("ckey" = ckey, "alt" = alt)
				)
				query_remove_stickyban_alt.warn_execute()
				qdel(query_remove_stickyban_alt)

			log_admin_private("[key_name(usr)] has disassociated [alt] from [ckey]'s sticky ban")
			message_admins(span_adminnotice("[key_name_admin(usr)] 解除了 [alt] 与 [ckey] 的关联封禁之间的关联"))

		if ("edit")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁！"))
				return
			var/oldreason = ban["message"]
			var/reason = input(usr,"原因","封禁原因","[ban["message"]]") as text|null
			if (!reason || reason == oldreason)
				return
			//we have to do this again incase something changed while we waited for input
			ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：该封禁已不存在。"))
				return
			ban["message"] = "[reason]"

			world.SetConfig("ban",ckey,list2stickyban(ban))

			SSstickyban.cache[ckey] = ban

			if (SSdbcore.Connect())
				var/datum/DBQuery/query_edit_stickyban = SSdbcore.NewQuery(
					"UPDATE [format_table_name("stickyban")] SET reason = :reason WHERE ckey = :ckey",
					list("reason" = reason, "ckey" = ckey)
				)
				query_edit_stickyban.warn_execute()
				qdel(query_edit_stickyban)

			log_admin_private("[key_name(usr)] has edited [ckey]'s sticky ban reason from [oldreason] to [reason]")
			message_admins(span_adminnotice("[key_name_admin(usr)] 将 [ckey] 的关联封禁原因由 [oldreason] 改为 [reason]"))

		if ("exempt")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			if (!data["alt"])
				return
			var/alt = ckey(data["alt"])
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁！"))
				return

			var/key = LAZYACCESS(ban["keys"], alt)
			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 未关联至 [ckey] 的关联封禁！"))
				return

			if (alert("确定将 [alt] 从 [ckey] 的关联封禁中豁免吗？","确认","是","否") == "否")
				return

			//we have to do this again incase something changes
			ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：该封禁已不存在。"))
				return

			key = LAZYACCESS(ban["keys"], alt)

			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 与 [ckey] 的关联封禁之间的关联已不存在。"))
				return
			LAZYREMOVE(ban["keys"], alt)
			key["exempt"] = TRUE
			LAZYSET(ban["whitelist"], alt, key)

			world.SetConfig("ban",ckey,list2stickyban(ban))

			SSstickyban.cache[ckey] = ban

			if (SSdbcore.Connect())
				var/datum/DBQuery/query_exempt_stickyban_alt = SSdbcore.NewQuery(
					"UPDATE [format_table_name("stickyban_matched_ckey")] SET exempt = 1 WHERE stickyban = :ckey AND matched_ckey = :alt",
					list("ckey" = ckey, "alt" = alt)
				)
				query_exempt_stickyban_alt.warn_execute()
				qdel(query_exempt_stickyban_alt)

			log_admin_private("[key_name(usr)] has exempted [alt] from [ckey]'s sticky ban")
			message_admins(span_adminnotice("[key_name_admin(usr)] 将 [alt] 从 [ckey] 的关联封禁中豁免"))

		if ("unexempt")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			if (!data["alt"])
				return
			var/alt = ckey(data["alt"])
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁！"))
				return

			var/key = LAZYACCESS(ban["whitelist"], alt)
			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 未被豁免于 [ckey] 的关联封禁！"))
				return

			if (alert("确定取消 [alt] 对 [ckey] 的关联封禁的豁免吗？","确认","是","否") == "否")
				return

			//we have to do this again incase something changes
			ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：该封禁已不存在。"))
				return

			key = LAZYACCESS(ban["whitelist"], alt)
			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 对 [ckey] 的关联封禁的豁免已不存在。"))
				return

			LAZYREMOVE(ban["whitelist"], alt)
			key["exempt"] = FALSE
			LAZYSET(ban["keys"], alt, key)

			world.SetConfig("ban",ckey,list2stickyban(ban))

			SSstickyban.cache[ckey] = ban

			if (SSdbcore.Connect())
				var/datum/DBQuery/query_unexempt_stickyban_alt = SSdbcore.NewQuery(
					"UPDATE [format_table_name("stickyban_matched_ckey")] SET exempt = 0 WHERE stickyban = :ckey AND matched_ckey = :alt",
					list("ckey" = ckey, "alt" = alt)
				)
				query_unexempt_stickyban_alt.warn_execute()
				qdel(query_unexempt_stickyban_alt)

			log_admin_private("[key_name(usr)] has unexempted [alt] from [ckey]'s sticky ban")
			message_admins(span_adminnotice("[key_name_admin(usr)] 取消了 [alt] 对 [ckey] 的关联封禁的豁免"))

		if ("timeout")
			if (!data["ckey"])
				return
			if (!SSdbcore.Connect())
				to_chat(usr, span_adminnotice("未连接数据库！"))
				return

			var/ckey = data["ckey"]

			if (alert("确定暂停 [ckey] 的关联封禁，直到下回合或该封禁被移除吗？","确认","是","否") == "否")
				return
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁！"))
				return

			ban["timeout"] = TRUE

			world.SetConfig("ban", ckey, null)

			var/cachedban = SSstickyban.cache[ckey]
			if (cachedban)
				cachedban["timeout"] = TRUE

			log_admin_private("[key_name(usr)] has put [ckey]'s sticky ban on timeout.")
			message_admins(span_adminnotice("[key_name_admin(usr)] 暂停了 [ckey] 的关联封禁。"))

		if ("untimeout")
			if (!data["ckey"])
				return
			if (!SSdbcore.Connect())
				to_chat(usr, span_adminnotice("未连接数据库！"))
				return
			var/ckey = data["ckey"]

			if (alert("确定恢复 [ckey] 的关联封禁吗？","确认","是","否") == "否")
				return

			var/ban = get_stickyban_from_ckey(ckey)
			var/cachedban = SSstickyban.cache[ckey]
			if (cachedban)
				cachedban["timeout"] = FALSE
			if (!ban)
				if (!cachedban)
					to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁！"))
					return
				ban = cachedban

			ban["timeout"] = FALSE

			world.SetConfig("ban",ckey,list2stickyban(ban))

			log_admin_private("[key_name(usr)] has taken [ckey]'s sticky ban off of timeout.")
			message_admins(span_adminnotice("[key_name_admin(usr)] 恢复了 [ckey] 的关联封禁。"))


		if ("revert")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			if (alert("确定将 [ckey] 的关联封禁还原至回合开始时或上次编辑后的状态吗？","确认","是","否") == "否")
				return
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁！"))
				return
			var/cached_ban = SSstickyban.cache[ckey]
			if (!cached_ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的关联封禁缓存！"))
			world.SetConfig("ban",ckey,null)

			log_admin_private("[key_name(usr)] has reverted [ckey]'s sticky ban to its state at round start.")
			message_admins(span_adminnotice("[key_name_admin(usr)] 将 [ckey] 的关联封禁还原至回合开始时的状态。"))
			//revert is mostly used when shit goes rouge, so we have to set it to null
			//	and wait a byond tick before assigning it to ensure byond clears its shit.
			sleep(world.tick_lag)
			world.SetConfig("ban",ckey,list2stickyban(cached_ban))


/datum/admins/proc/stickyban_gethtml(ckey)
	var/ban = get_stickyban_from_ckey(ckey)
	if (!ban)
		return
	var/timeout
	if (SSdbcore.Connect())
		timeout = "<a href='?_src_=holder;[HrefToken()];stickyban=[(ban["timeout"] ? "untimeout" : "timeout")]&ckey=[ckey]'>\[[(ban["timeout"] ? "恢复" : "暂停" )]\]</a>"
	else
		timeout = "<a href='?_src_=holder;[HrefToken()];stickyban=revert&ckey=[ckey]'>\[还原\]</a>"
	. = list({"
		<a href='?_src_=holder;[HrefToken()];stickyban=remove&ckey=[ckey]'>\[-\]</a>
		[timeout]
		<b>[ckey]</b>
		<br />"
		[ban["message"]] <b><a href='?_src_=holder;[HrefToken()];stickyban=edit&ckey=[ckey]'>\[编辑\]</a></b><br />
	"})
	if (ban["admin"])
		. += "[ban["admin"]]<br />"
	else
		. += "旧版封禁<br />"
	. += "已关联账号<br />\n<ol>"
	for (var/key in ban["keys"])
		if (ckey(key) == ckey)
			continue
		. += "<li><a href='?_src_=holder;[HrefToken()];stickyban=remove_alt&ckey=[ckey]&alt=[ckey(key)]'>\[-\]</a>[key]<a href='?_src_=holder;[HrefToken()];stickyban=exempt&ckey=[ckey]&alt=[ckey(key)]'>\[豁免\]</a></li>"

	for (var/key in ban["whitelist"])
		if (ckey(key) == ckey)
			continue
		. += "<li><a href='?_src_=holder;[HrefToken()];stickyban=remove_alt&ckey=[ckey]&alt=[ckey(key)]'>\[-\]</a>[key]<a href='?_src_=holder;[HrefToken()];stickyban=unexempt&ckey=[ckey]&alt=[ckey(key)]'>\[取消豁免\]</a></li>"

	. += "</ol>\n"

/datum/admins/proc/stickyban_show()
	if(!check_rights(R_BAN))
		return
	var/list/bans = sticky_banned_ckeys()
	var/list/banhtml = list()
	for(var/key in bans)
		var/ckey = ckey(key)
		banhtml += "<br /><hr />\n"
		banhtml += stickyban_gethtml(ckey)

	var/html = {"
	<head>
		<title>Sticky Bans</title>
	</head>
	<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type=\"text/css\">
	<body>
		<h2>所有关联封禁：</h2> <a href='?_src_=holder;[HrefToken()];stickyban=add'>\[+\]</a><br>
		[banhtml.Join("")]
	</body>
	"}
	usr << browse(html,"window=stickybans;size=700x400")

/proc/sticky_banned_ckeys()
	if (SSdbcore.Connect() || length(SSstickyban.dbcache))
		if (SSstickyban.dbcacheexpire < world.time)
			SSstickyban.Populatedbcache()
		if (SSstickyban.dbcacheexpire)
			return SSstickyban.dbcache.Copy()

	return sortList(world.GetConfig("ban"))


/proc/get_stickyban_from_ckey(ckey)
	. = list()
	if (!ckey)
		return null
	if (SSdbcore.Connect() || length(SSstickyban.dbcache))
		if (SSstickyban.dbcacheexpire < world.time)
			SSstickyban.Populatedbcache()
		if (SSstickyban.dbcacheexpire)
			. = SSstickyban.dbcache[ckey]
			//reset the cache incase its a newer ban (but only if we didn't update the cache recently)
			if (!. && SSstickyban.dbcacheexpire != world.time+STICKYBAN_DB_CACHE_TIME)
				SSstickyban.dbcacheexpire = 1
				SSstickyban.Populatedbcache()
				. = SSstickyban.dbcache[ckey]
			if (.)
				var/list/cachedban = SSstickyban.cache["[ckey]"]
				if (cachedban)
					.["timeout"] = cachedban["timeout"]

				.["fromdb"] = TRUE
			return

	. = stickyban2list(world.GetConfig("ban", ckey)) || stickyban2list(world.GetConfig("ban", ckey(ckey))) || list()

	if (!length(.))
		return null

/proc/stickyban2list(ban, strictdb = TRUE)
	if (!ban)
		return null
	. = params2list(ban)
	if (.["keys"])
		var/keys = splittext(.["keys"], ",")
		var/ckeys = list()
		for (var/key in keys)
			var/ckey = ckey(key)
			ckeys[ckey] = ckey //to make searching faster.
		.["keys"] = ckeys
	if (.["whitelist"])
		var/keys = splittext(.["whitelist"], ",")
		var/ckeys = list()
		for (var/key in keys)
			var/ckey = ckey(key)
			ckeys[ckey] = ckey //to make searching faster.
		.["whitelist"] = ckeys
	.["type"] = splittext(.["type"], ",")
	.["IP"] = splittext(.["IP"], ",")
	.["computer_id"] = splittext(.["computer_id"], ",")
	. -= "fromdb"


/proc/list2stickyban(list/ban)
	if (!ban || !islist(ban))
		return null
	. = ban.Copy()
	if (.["keys"])
		.["keys"] = jointext(.["keys"], ",")
	if (.["IP"])
		.["IP"] = jointext(.["IP"], ",")
	if (.["computer_id"])
		.["computer_id"] = jointext(.["computer_id"], ",")
	if (.["whitelist"])
		.["whitelist"] = jointext(.["whitelist"], ",")
	if (.["type"])
		.["type"] = jointext(.["type"], ",")

	. -= "reverting"
	. -= "matches_this_round"
	. -= "existing_user_matches_this_round"
	. -= "admin_matches_this_round"
	. -= "pending_matches_this_round"


	. = list2params(.)


/client/proc/stickybanpanel()
	set name = "关联封禁面板"
	set category = "-管理-"
	set hidden = 1
	if (!holder)
		return
	holder.stickyban_show()
