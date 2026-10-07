// Copypasta of bordercontrol system

GLOBAL_LIST_EMPTY(donatorCkeys)
GLOBAL_VAR_INIT(donatorCkeysSaveFile, new /savefile("data/donators.db"))
GLOBAL_VAR_INIT(donatorLoaded, 0)

/proc/is_donator(key)
	key = ckey(key)

	if(!GLOB.donatorLoaded)
		load_donators()
	if(LAZYISIN(GLOB.donatorCkeys, key))
		return TRUE
	else
		return FALSE

/proc/donator_addkey(key)
	var/keyAsCkey = ckey(key)
	if(!GLOB.donatorLoaded)
		load_donators()
	
	if(!keyAsCkey)
		return FALSE
	else
		if(LAZYISIN(GLOB.donatorCkeys, keyAsCkey))
			return FALSE
		else
			LAZYINITLIST(GLOB.donatorCkeys)
			ADD_SORTED(GLOB.donatorCkeys, keyAsCkey, /proc/cmp_text_asc)
			save_donators()
			return TRUE

/proc/donator_removekey(key)
	key = ckey(key)

	if(!LAZYISIN(GLOB.donatorCkeys, key))
		return TRUE
	else if(GLOB.donatorCkeys)
		LAZYREMOVE(GLOB.donatorCkeys, key)
		save_donators()
		return TRUE

/proc/load_donators()
	LAZYCLEARLIST(GLOB.donatorCkeys)

	LAZYINITLIST(GLOB.donatorCkeys)

	if(!GLOB.donatorCkeysSaveFile)
		return FALSE

	GLOB.donatorCkeysSaveFile["donatorCkeys"] >> GLOB.donatorCkeys

	GLOB.donatorLoaded = TRUE

/proc/save_donators()
	if(!GLOB.donatorCkeys)
		return FALSE
	if(!GLOB.donatorCkeysSaveFile)
		return FALSE

	GLOB.donatorCkeysSaveFile["donatorCkeys"] << GLOB.donatorCkeys

// Procs goes here
/datum/admins/proc/admin_add_donator_verb()
	set name = "BC - 添加赞助者 ckey"
	set category = "-服务器-"

	var/key = input("要添加的 ckey", "添加赞助者 ckey") as null|text

	if(key)
		var/confirm = alert("将 [key] 加入赞助者名单？（对方需要重新连接以更新状态）", , "是", "否")
		if(confirm == "是")
			message_admins("[key_name(usr)] 将 [key] 加入了赞助者名单。")
			log_admin("[key_name(usr)] added [key] to the donator list.")
			donator_addkey(key)

/datum/admins/proc/admin_remove_donator_verb()
	set name = "BC - 移除赞助者 ckey"
	set category = "-服务器-"

	var/key = input("要移除的 ckey", "移除赞助者 ckey") as null|anything in GLOB.donatorCkeys

	if(key)
		var/confirm = alert("将 [key] 从赞助者名单中移除？", , "是", "否")
		if(confirm == "是")
			message_admins("[key_name(usr)] 将 [key] 从赞助者名单中移除了。")
			log_admin("[key_name(usr)] removed [key] from the donator list.")
			donator_removekey(key)
