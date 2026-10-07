/client/proc/panicbunker()
	set category = "-服务器-"
	set name = "切换紧急准入限制"
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, span_adminnotice("未启用数据库！"))
		return

	var/new_pb = !CONFIG_GET(flag/panic_bunker)
	CONFIG_SET(flag/panic_bunker, new_pb)

	log_admin("[key_name(usr)] has toggled the Panic Bunker, it is now [new_pb ? "on" : "off"]")
	message_admins("[key_name_admin(usr)] 已[new_pb ? "启用" : "禁用"]紧急准入限制。")
	if (new_pb && !SSdbcore.Connect())
		message_admins("数据库未连接！重新连接前，紧急准入限制无法生效。")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Panic Bunker", "[new_pb ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/whitelistbunker()
	set category = "-服务器-"
	set name = "切换白名单准入限制"
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, span_adminnotice("未启用数据库！"))
		return

	var/new_pb = !CONFIG_GET(flag/whitelist_bunker)
	CONFIG_SET(flag/whitelist_bunker, new_pb)

	log_admin("[key_name(usr)] has toggled the Whitelist Bunker, it is now [new_pb ? "on" : "off"]")
	message_admins("[key_name_admin(usr)] 已[new_pb ? "启用" : "禁用"]白名单准入限制。")
	if (new_pb && !SSdbcore.Connect())
		message_admins("数据库未连接！重新连接前，白名单准入限制无法生效。")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Whitelist Bunker", "[new_pb ? "Enabled" : "Disabled"]"))

