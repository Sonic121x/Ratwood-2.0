// Verb to toggle restart notifications
/client/verb/notify_restart()
	set category = "OOC"
	set name = "Notify Restart"
	set desc = ""
	set hidden = 1
	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("此功能需要运行SQL后端。"))
		return

	if(!SSdiscord) // SS is still starting
		to_chat(src, span_notice("服务器仍在启动，请稍候再尝试绑定账号。"))
		return

	if(!SSdiscord.enabled)
		to_chat(src, span_warning("此功能需要服务器使用TGS工具包运行。"))
		return

	var/stored_id = SSdiscord.lookup_id(usr.ckey)
	if(!stored_id) // Account is not linked
		to_chat(src, span_warning("请先使用\"Link Discord Account\"命令绑定Discord账号。"))
		return

	else // Linked
		for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
			if(member == "[stored_id]")
				SSdiscord.notify_members -= "[stored_id]" // The list uses strings because BYOND cannot handle a 17 digit integer
				to_chat(src, span_notice("服务器重启时，我将不再收到通知。"))
				return // This is necassary so it doesnt get added again, as it relies on the for loop being unsuccessful to tell us if they are in the list or not

		// If we got here, they arent in the list. Chuck 'em in!
		to_chat(src, span_notice("服务器重启时，我将收到通知。"))
		SSdiscord.notify_members += "[stored_id]" // The list uses strings because BYOND cannot handle a 17 digit integer
