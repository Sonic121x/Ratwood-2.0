/client/proc/reestablish_db_connection()
	set category = "-服务器-"
	set name = "重新连接数据库"
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, span_adminnotice("未启用数据库！"))
		return

	if (SSdbcore.IsConnected())
		if (!check_rights(R_DEBUG,0))
			alert("数据库已连接！（只有具备 +debug 权限的人才能强制重新连接）", "数据库已连接！")
			return

		var/reconnect = alert("数据库已连接！如果你确定该状态有误，可以强制重新连接", "数据库已连接！", "强制重新连接", "取消")
		if (reconnect != "强制重新连接")
			return

		SSdbcore.Disconnect()
		log_admin("[key_name(usr)] has forced the database to disconnect")
		message_admins("[key_name_admin(usr)] <b>强制</b>断开了数据库连接！")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Force Reestablished Database Connection") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	log_admin("[key_name(usr)] is attempting to re-establish the DB Connection")
	message_admins("[key_name_admin(usr)] 正在尝试重新连接数据库")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Reestablished Database Connection") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	SSdbcore.failed_connections = 0
	if(!SSdbcore.Connect())
		message_admins("数据库连接失败：" + SSdbcore.ErrorMsg())
	else
		message_admins("已重新连接数据库")
