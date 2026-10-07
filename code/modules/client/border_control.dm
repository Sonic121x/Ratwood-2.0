//Handles server whitelisting - set to 0? No whitelist. 1? Any ckeys that connect get added to list; no whitelist required still. 2? Only Ckeys on the list can connect.
#define BORDER_CONTROL_DISABLED 0
#define BORDER_CONTROL_LEARNING 1
#define BORDER_CONTROL_ENFORCED 2


GLOBAL_LIST_EMPTY(whitelistedCkeys)
GLOBAL_VAR_INIT(borderControlFile, new /savefile("data/bordercontrol.db"))
GLOBAL_VAR_INIT(whitelistLoaded, 0)

//////////////////////////////////////////////////////////////////////////////////
/proc/BC_ModeToText(mode)
	switch(mode)
		if(BORDER_CONTROL_DISABLED)
			return "已禁用"
		if(BORDER_CONTROL_LEARNING)
			return "自动收录"
		if(BORDER_CONTROL_ENFORCED)
			return "强制执行"

//////////////////////////////////////////////////////////////////////////////////
/proc/BC_IsKeyAllowedToConnect(key)
	key = ckey(key)

	var/borderControlMode = CONFIG_GET(number/border_control)

	if(borderControlMode == BORDER_CONTROL_DISABLED)
		return 1
	else if (borderControlMode == BORDER_CONTROL_LEARNING)
		if(!BC_IsKeyWhitelisted(key))
			message_admins("[key] 已加入服务器，并被加入准入白名单。")
			log_admin("[key] has joined and was added to the border whitelist.")
		BC_WhitelistKey(key)
		return 1
	else
		return BC_IsKeyWhitelisted(key)

//////////////////////////////////////////////////////////////////////////////////
/proc/BC_IsKeyWhitelisted(key)
	key = ckey(key)

	if(!GLOB.whitelistLoaded)
		BC_LoadWhitelist()

	if(LAZYISIN(GLOB.whitelistedCkeys, key))
		return 1
	else
		return 0

//////////////////////////////////////////////////////////////////////////////////
//ADMIN_VERB_ADD(/client/proc/BC_WhitelistKeyVerb, R_ADMIN, FALSE)
///client/proc/BC_WhitelistKeyVerb()
/datum/admins/proc/BC_WhitelistKeyVerb()

	set name = "BC - 将账号加入白名单"
	set category = "-服务器-"

	var/key = input("要加入白名单的 ckey", "加入白名单") as null|text

	if(key)
		var/confirm = alert("将 [key] 加入准入白名单？", , "是", "否")
		if(confirm == "是")
			message_admins("[key_name(usr)] 将 [key] 加入了准入白名单。")
			log_admin("[key_name(usr)] added [key] to the border whitelist.")
			BC_WhitelistKey(key)


//////////////////////////////////////////////////////////////////////////////////
/proc/BC_WhitelistKey(key)
	var/keyAsCkey = ckey(key)

	if(!GLOB.whitelistLoaded)
		BC_LoadWhitelist()

	if(!keyAsCkey)
		return 0
	else
		if(LAZYISIN(GLOB.whitelistedCkeys,keyAsCkey))
			// Already in
			return 0
		else
			LAZYINITLIST(GLOB.whitelistedCkeys)

			ADD_SORTED(GLOB.whitelistedCkeys, keyAsCkey, /proc/cmp_text_asc)

			BC_SaveWhitelist()
			return 1



//////////////////////////////////////////////////////////////////////////////////
//ADMIN_VERB_ADD(/client/proc/BC_RemoveKeyVerb, R_ADMIN, FALSE)
///client/proc/BC_RemoveKeyVerb()
/datum/admins/proc/BC_RemoveKeyVerb()
	set name = "BC - 将账号移出白名单"
	set category = "-服务器-"

	var/keyToRemove = input("要移除的 ckey", "移出白名单") as null|anything in GLOB.whitelistedCkeys

	if(keyToRemove)
		var/confirm = alert("将 [keyToRemove] 从准入白名单中移除？", , "是", "否")
		if(confirm == "是")
			message_admins("[key_name(usr)] 将 [keyToRemove] 从准入白名单中移除了。")
			log_admin("[key_name(usr)] removed [keyToRemove] from the border whitelist.")
			BC_RemoveKey(keyToRemove)

	return


//////////////////////////////////////////////////////////////////////////////////
/proc/BC_RemoveKey(key)
	key = ckey(key)

	if(!LAZYISIN(GLOB.whitelistedCkeys, key))
		return 1
	else
		if(GLOB.whitelistedCkeys)
			GLOB.whitelistedCkeys.Remove(key)
		BC_SaveWhitelist()
		return 1




//////////////////////////////////////////////////////////////////////////////////
//ADMIN_VERB_ADD(/client/proc/BC_ToggleState, R_ADMIN, FALSE)
///client/proc/BC_ToggleState()
/datum/admins/proc/BC_ToggleState()

	set name = "BC - 切换准入模式"
	set category = "-服务器-"
	set desc= "启用或禁用服务器准入限制"

	var/borderControlMode = CONFIG_GET(number/border_control)

	var/choice = input("新模式（当前模式：[BC_ModeToText(borderControlMode)]）", "准入限制模式") as null|anything in list("已禁用", "自动收录", "强制执行")

	switch(choice)
		if("已禁用")
			if(borderControlMode != BORDER_CONTROL_DISABLED)
				borderControlMode = BORDER_CONTROL_DISABLED
				message_admins("已禁用准入限制。")
				log_admin("has disabled border control.")
		if("自动收录")
			if(borderControlMode != BORDER_CONTROL_LEARNING)
				borderControlMode = BORDER_CONTROL_LEARNING
				message_admins("已将准入限制设为在账号连接时自动收录！")
				log_admin("has set border control to learn new keys on connection!")
			var/confirm = alert("收录当前已连接的账号？", , "是", "否")
			if(confirm == "是")
				for(var/client/C in GLOB.clients)
					if (BC_WhitelistKey(C.key))
						message_admins("[key_name(usr)] 批量收录当前玩家，将 [C.key] 加入了准入白名单。")
						log_admin("[key_name(usr)] added [C.key] to the border whitelist by adding all current clients.")

		if("强制执行")
			if(borderControlMode != BORDER_CONTROL_ENFORCED)
				borderControlMode = BORDER_CONTROL_ENFORCED
				message_admins("已强制执行准入限制。未收录的账号无法加入。")
				log_admin("has enforced border controls. New keys can no longer join.")

	CONFIG_SET(number/border_control, borderControlMode)

	return


//////////////////////////////////////////////////////////////////////////////////

/hook/startup/proc/loadBorderControlWhitelistHook()
	BC_LoadWhitelist()
	return 1

//////////////////////////////////////////////////////////////////////////////////
/proc/BC_LoadWhitelist()

	LAZYCLEARLIST(GLOB.whitelistedCkeys)

	LAZYINITLIST(GLOB.whitelistedCkeys)

	if(!GLOB.borderControlFile)
		return 0

	GLOB.borderControlFile["whitelistedCkeys"] >> GLOB.whitelistedCkeys

	GLOB.whitelistLoaded = 1


//////////////////////////////////////////////////////////////////////////////////
/proc/BC_SaveWhitelist()
	if(!GLOB.whitelistedCkeys)
		return 0

	if(!GLOB.borderControlFile)
		return 0

	GLOB.borderControlFile["whitelistedCkeys"] << GLOB.whitelistedCkeys
