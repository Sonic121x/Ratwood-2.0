// Notify
/datum/tgs_chat_command/notify
	name = "notify"
	help_text = "回合结束时提及使用此命令的用户"

/datum/tgs_chat_command/notify/Run(datum/tgs_chat_user/sender, params)
	for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
		if(member == "[sender.mention]")
			SSdiscord.notify_members -= "[SSdiscord.id_clean(sender.mention)]" // The list uses strings because BYOND cannot handle a 17 digit integer
			return "服务器重启时，你将不再收到通知。"
		
	// If we got here, they arent in the list. Chuck 'em in!
	SSdiscord.notify_members += "[SSdiscord.id_clean(sender.mention)]" // The list uses strings because BYOND cannot handle a 17 digit integer
	return "服务器重启时，你将收到通知。"

// Verify
/datum/tgs_chat_command/verify
	name = "verify"
	help_text = "验证你的Discord账号与BYOND账号的绑定"

/datum/tgs_chat_command/verify/Run(datum/tgs_chat_user/sender, params)
	var/lowerparams = replacetext(LOWER_TEXT(params), " ", "") // Fuck spaces
	if(SSdiscord.account_link_cache[lowerparams]) // First if they are in the list, then if the ckey matches
		if(SSdiscord.account_link_cache[lowerparams] == "[SSdiscord.id_clean(sender.mention)]") // If the associated ID is the correct one
			SSdiscord.link_account(lowerparams)
			return "账号绑定成功。"
		else
			return "此ckey未关联到这个Discord账号。如果有人使用了你的用户ID，请告知管理员。"
	else
		return "此账号尚未发起绑定。"
