#define IRC_STATUS_THROTTLE 5

/datum/tgs_chat_command/ircstatus
	name = "status"
	help_text = "获取服务器的管理员人数、玩家人数、游戏模式和实际游戏模式"
	admin_only = TRUE
	var/last_irc_status = 0

/datum/tgs_chat_command/ircstatus/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_status < IRC_STATUS_THROTTLE)
		return
	last_irc_status = rtod
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/status = "管理员：[allmins.len]（在线：[english_list(adm["present"])] 离开：[english_list(adm["afk"])] 隐身：[english_list(adm["stealth"])] 已跳过：[english_list(adm["noflags"])]）。 "
	status += "玩家：[GLOB.clients.len]（活跃：[get_active_player_count(0,1,0)]）。模式：说书人。"
	return status

/datum/tgs_chat_command/irccheck
	name = "check"
	help_text = "获取服务器的玩家人数、游戏模式和地址"
	var/last_irc_check = 0

/datum/tgs_chat_command/irccheck/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_check < IRC_STATUS_THROTTLE)
		return
	last_irc_check = rtod
	var/server = CONFIG_GET(string/server)
	return "[GLOB.round_id ? "回合 #[GLOB.round_id]：" : ""][SSmapping.current_map.map_name] 上有 [GLOB.clients.len] 名玩家，模式：[GLOB.master_mode]；回合[SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "进行中" : "即将结束") : "即将开始"] -- [server ? server : "[world.internet_address]:[world.port]"]"

/datum/tgs_chat_command/ahelp
	name = "ahelp"
	help_text = "<ckey|求助编号> <消息|ticket <close|resolve|icissue|reject|reopen <求助编号>|list>>"
	admin_only = TRUE

/datum/tgs_chat_command/ahelp/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return "参数不足"
	var/target = all_params[1]
	all_params.Cut(1, 2)
	var/id = text2num(target)
	if(id != null)
		var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(id)
		if(AH)
			target = AH.initiator_ckey
		else
			return "未找到求助 #[id]！"
	var/res = IrcPm(target, all_params.Join(" "), sender.friendly_name)
	if(res != "Message Successful")
		return res

/datum/tgs_chat_command/namecheck
	name = "namecheck"
	help_text = "返回指定目标的信息"
	admin_only = TRUE

/datum/tgs_chat_command/namecheck/Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return "参数不足"
	log_admin("Chat Name Check: [sender.friendly_name] on [params]")
	message_admins("[sender.friendly_name] 正在查询 [params] 的名称信息")
	return keywords_lookup(params, 1)

/datum/tgs_chat_command/adminwho
	name = "adminwho"
	help_text = "列出当前在线的管理员"
	admin_only = TRUE

/datum/tgs_chat_command/adminwho/Run(datum/tgs_chat_user/sender, params)
	return ircadminwho()

GLOBAL_LIST(round_end_notifiees)

/datum/tgs_chat_command/endnotify
	name = "endnotify"
	help_text = "在回合结束时提醒指令使用者"
	admin_only = TRUE

/datum/tgs_chat_command/endnotify/Run(datum/tgs_chat_user/sender, params)
	if(!SSticker.IsRoundInProgress() && SSticker.HasRoundStarted())
		return "[sender.mention]，本回合已经结束！"
	LAZYINITLIST(GLOB.round_end_notifiees)
	GLOB.round_end_notifiees[sender.mention] = TRUE
	return "将在回合结束时提醒 [sender.mention]。"

/datum/tgs_chat_command/sdql
	name = "sdql"
	help_text = "执行 SDQL 查询"
	admin_only = TRUE

/datum/tgs_chat_command/sdql/Run(datum/tgs_chat_user/sender, params)
	if(GLOB.AdminProcCaller)
		return "无法执行查询，另一位管理员正在调用过程。请稍后再试。"
	GLOB.AdminProcCaller = "CHAT_[sender.friendly_name]"	//_ won't show up in ckeys so it'll never match with a real admin
	var/list/results = world.SDQL2_query(params, GLOB.AdminProcCaller, GLOB.AdminProcCaller)
	GLOB.AdminProcCaller = null
	if(!results)
		return "查询没有产生输出"
	var/list/text_res = results.Copy(1, 3)
	var/list/refs = results.len > 3 ? results.Copy(4) : null
	. = "[text_res.Join("\n")][refs ? "\n引用：[refs.Join(" ")]" : ""]"

/datum/tgs_chat_command/reload_admins
	name = "reload_admins"
	help_text = "强制服务器重新加载管理员。"
	admin_only = TRUE

/datum/tgs_chat_command/reload_admins/Run(datum/tgs_chat_user/sender, params)
	ReloadAsync()
	log_admin("[sender.friendly_name] reloaded admins via chat command.")
	return "已重新加载管理员。"

/datum/tgs_chat_command/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()
