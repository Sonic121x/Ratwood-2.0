// Verb to link discord accounts to BYOND accounts
/client/verb/linkdiscord()
	set category = "OOC"
	set name = "绑定 Discord 账号"
	set desc = ""
	set hidden = 1
	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("此功能需要运行SQL后端。"))
		return

	if(!SSdiscord) // SS is still starting
		to_chat(src, span_notice("服务器仍在启动，请稍候再尝试绑定账号！"))
		return

	if(!SSdiscord.enabled)
		to_chat(src, span_warning("此功能需要服务器使用TGS工具包运行。"))
		return

	var/stored_id = SSdiscord.lookup_id(usr.ckey)
	if(!stored_id) // Account is not linked
		var/know_how = alert("你知道如何获取Discord用户ID吗？这个ID不是你的Discord用户名和数字标签！（选择“否”将打开指南。）","询问","是","否","取消绑定")
		if(know_how == "否") // Opens discord support on how to collect IDs
			src << link("https://support.discordapp.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID")
		if(know_how == "取消绑定")
			return
		var/entered_id = input("请输入你的Discord用户ID（约18位数字）", "输入Discord用户ID", null, null) as text|null
		SSdiscord.account_link_cache[replacetext(LOWER_TEXT(usr.ckey), " ", "")] = "[entered_id]" // Prepares for TGS-side verification, also fuck spaces
		alert(usr, "账号绑定已开始。请在Discord中提及当前服务器的机器人，并在其后输入\"verify [usr.ckey]\"以完成验证（示例：@The Herald verify [usr.ckey]）。")

	else // Account is already linked
		var/choice = alert("Discord账号[stored_id]已绑定到[usr.ckey]。你想绑定其他账号吗？","已绑定","是","否")
		if(choice == "是")
			var/know_how = alert("你知道如何获取Discord用户ID吗？这个ID不是你的Discord用户名和数字标签！（选择“否”将打开指南。）","询问","是","否", "取消绑定")
			if(know_how == "否") // Opens discord support on how to collect IDs
				src << link("https://support.discordapp.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID")

			if(know_how == "取消绑定")
				return

			var/entered_id = input("请输入你的Discord用户ID（约18位数字）", "输入Discord用户ID", null, null) as text|null
			SSdiscord.account_link_cache[replacetext(LOWER_TEXT(usr.ckey), " ", "")] = "[entered_id]" // Prepares for TGS-side verification, also fuck spaces
			alert(usr, "账号绑定已开始。请在Discord中提及当前服务器的机器人，并在其后输入\"verify [usr.ckey]\"以完成验证（示例：@Mr_Terry verify [usr.ckey]）。")
			// This is so people cant fill the notify list with a fuckload of ckeys
			SSdiscord.notify_members -= "[stored_id]" // The list uses strings because BYOND cannot handle a 17 digit integer
