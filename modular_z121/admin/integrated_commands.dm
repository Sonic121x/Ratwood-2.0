// 收藏属于账号，窗口属于当前连接与身体；旧窗口不能操作新会话。
/client
	var/datum/z121_integrated_commands/z121_commands_panel

/client/proc/z121_integrated_commands()
	set category = "-GameMaster-"
	set name = "集成指令"
	set desc = "收藏并快捷使用当前获授权的管理员指令。"
	if(!check_rights(R_ADMIN) || !mob)
		return
	if(QDELETED(z121_commands_panel))
		z121_commands_panel = new(mob)
	z121_commands_panel.ui_interact(mob)

/datum/z121_integrated_commands
	var/mob/owner
	var/client/owner_client
	var/account_key
	var/list/catalog = list()
	var/list/favorites = list()
	var/notice = "点击星标收藏指令，点击执行打开原指令。"
	var/notice_error = FALSE

/datum/z121_integrated_commands/New(mob/user)
	. = ..()
	owner = user
	owner_client = user.client
	account_key = ckey(owner_client.ckey)
	RegisterSignal(owner, list(COMSIG_MOB_LOGOUT, COMSIG_QDELETING), PROC_REF(end_session))
	for(var/list/group as anything in verb_groups())
		for(var/verb_path in group["verbs"])
			if(verb_path != /client/proc/z121_integrated_commands)
				catalog["[verb_path]"] = verb_path
	load_favorites()

/datum/z121_integrated_commands/Destroy()
	SStgui.close_uis(src)
	if(owner)
		UnregisterSignal(owner, list(COMSIG_MOB_LOGOUT, COMSIG_QDELETING))
	if(owner_client?.z121_commands_panel == src)
		owner_client.z121_commands_panel = null
	owner = null
	owner_client = null
	return ..()

/datum/z121_integrated_commands/proc/end_session()
	SIGNAL_HANDLER
	qdel(src)

/datum/z121_integrated_commands/proc/can_use(mob/user)
	return !QDELETED(owner) && user == owner && owner_client && user.client == owner_client && owner_client.mob == owner && owner_client.z121_commands_panel == src && check_rights_for(owner_client, R_ADMIN)

/datum/z121_integrated_commands/ui_state(mob/user)
	return can_use(user) ? GLOB.always_state : GLOB.never_state

/datum/z121_integrated_commands/ui_status(mob/user, datum/ui_state/state)
	return can_use(user) ? UI_INTERACTIVE : UI_CLOSE

/datum/z121_integrated_commands/ui_interact(mob/user, datum/tgui/ui)
	if(!can_use(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IntegratedCommands", "集成指令")
		ui.open()

// 同一指令可能属于多个权限分组，满足任一分组即可；隐藏列表不能作为授权依据。
/datum/z121_integrated_commands/proc/verb_groups()
	return list(
		list("rights" = 0, "verbs" = GLOB.admin_verbs_default + list(/client/proc/show_verbs)),
		list("rights" = R_ADMIN, "verbs" = GLOB.admin_verbs_admin + GLOB.admin_verbs_poll + get_custom_admin_verbs()),
		list("rights" = R_BAN, "verbs" = GLOB.admin_verbs_ban),
		list("rights" = R_FUN, "verbs" = GLOB.admin_verbs_fun),
		list("rights" = R_SERVER, "verbs" = GLOB.admin_verbs_server),
		list("rights" = R_DEBUG, "verbs" = GLOB.admin_verbs_debug + GLOB.admin_verbs_debug_mapping + list(/client/proc/disable_debug_verbs)),
		list("rights" = R_POSSESS, "verbs" = GLOB.admin_verbs_possess),
		list("rights" = R_PERMISSIONS, "verbs" = GLOB.admin_verbs_permissions),
		list("rights" = R_SOUND, "verbs" = GLOB.admin_verbs_sounds + list(/client/proc/play_web_sound)),
		list("rights" = R_SPAWN, "verbs" = GLOB.admin_verbs_spawn),
		list("rights" = R_BUILD, "verbs" = list(/client/proc/togglebuildmodeself)),
		list("rights" = R_STEALTH, "verbs" = list(/client/proc/stealth)),
	)

/datum/z121_integrated_commands/proc/authorized_verbs()
	var/list/result = list()
	var/rights = owner_client.holder.rank.rights
	for(var/list/group as anything in verb_groups())
		if(!group["rights"] || (rights & group["rights"]))
			result |= group["verbs"]
	if(!CONFIG_GET(string/invoke_youtubedl))
		result -= /client/proc/play_web_sound
	return result

// 与现有菜单一致，将显示名称中的空格转换为连字符，交给原生动词系统处理参数。
/datum/z121_integrated_commands/proc/native_command(procpath/verb_path)
	var/command = verb_path.name
	if(!istext(command) || !length(command))
		return ""
	if(copytext(command, 1, 2) == "@")
		command = copytext(command, 2)
	else
		command = replacetext(command, " ", "-")
	return command

/datum/z121_integrated_commands/proc/command_counts()
	var/list/counts = list()
	// 同名的普通角色指令也可能参与原生命令解析，因此一起检测。
	var/list/current_verbs = owner_client.verbs.Copy()
	current_verbs |= owner.verbs
	for(var/verb_path in current_verbs)
		var/command = lowertext(native_command(verb_path))
		if(length(command))
			counts[command] = (counts[command] || 0) + 1
	return counts

/datum/z121_integrated_commands/proc/unavailable_reason(verb_path, list/authorized, list/counts)
	if(!verb_path)
		return "该指令已移除。"
	if(!(verb_path in authorized))
		return "当前权限不足。"
	if(!(verb_path in owner_client.verbs))
		return "该指令已隐藏或当前不可用。"
	var/command = native_command(verb_path)
	if(!length(command) || findtext(command, ";") || findtext(command, "\n") || findtext(command, ascii2text(13)))
		return "该指令名称不支持快捷执行。"
	if(counts[lowertext(command)] > 1)
		return "存在同名命令，请从原指令入口使用。"
	return ""

/datum/z121_integrated_commands/ui_data(mob/user)
	if(!can_use(user))
		return list()
	var/list/authorized = authorized_verbs()
	var/list/counts = command_counts()
	var/list/rows = list()
	// 收藏先按添加顺序输出，后接其他当前可用的管理员指令。
	var/list/ids = favorites.Copy()
	for(var/id in catalog)
		ids |= id
	for(var/id in ids)
		var/procpath/verb_path = catalog[id]
		var/favorite = (id in favorites)
		var/reason = unavailable_reason(verb_path, authorized, counts)
		if(!favorite && (!verb_path || !(verb_path in authorized) || !(verb_path in owner_client.verbs)))
			continue
		rows += list(list(
			"id" = id,
			"name" = verb_path ? verb_path.name : "已移除的指令",
			"description" = verb_path ? verb_path.desc : id,
			"category" = verb_path ? (verb_path.category || "未分类") : "已移除",
			"favorite" = favorite,
			"available" = !length(reason),
			"reason" = reason,
		))
	return list("commands" = rows, "notice" = notice, "notice_error" = notice_error)

/datum/z121_integrated_commands/proc/save_path()
	return "data/player_saves/[copytext(account_key, 1, 2)]/[account_key]/z121_integrated_commands.sav"

/datum/z121_integrated_commands/proc/load_favorites()
	if(!fexists(save_path()))
		return
	try
		var/savefile/storage = new(save_path())
		var/version
		var/list/saved
		storage["version"] >> version
		storage["favorites"] >> saved
		if(version != 1 || !islist(saved))
			notice = "收藏存档格式无效，暂时使用空收藏。"
			notice_error = TRUE
			log_game("集成指令：读取 [account_key] 的收藏失败，存档格式无效。")
			return
		for(var/id in saved)
			if(istext(id) && copytext(id, 1, 2) == "/")
				favorites |= id
	catch(var/exception/error)
		notice = "读取收藏失败，暂时使用空收藏。"
		notice_error = TRUE
		log_game("集成指令：读取 [account_key] 的收藏失败：[error]")

/datum/z121_integrated_commands/proc/save_favorites(list/updated)
	try
		var/savefile/storage = new(save_path())
		storage["version"] << 1
		storage["favorites"] << updated
		storage.Flush()
	catch(var/exception/error)
		notice = "保存收藏失败，收藏未更新。"
		notice_error = TRUE
		log_game("集成指令：保存 [account_key] 的收藏失败：[error]")
		return FALSE
	favorites = updated
	notice_error = FALSE
	return TRUE

/datum/z121_integrated_commands/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	if(!can_use(ui.user) || usr != owner)
		return FALSE
	if(!(action in list("favorite", "unfavorite", "execute")))
		return FALSE
	var/id = params["id"]
	if(!istext(id))
		return FALSE
	// 移除失效收藏不需要解析路径，也不会调用存档中的任何内容。
	if(action == "unfavorite")
		if(!(id in favorites))
			return FALSE
		var/list/updated = favorites.Copy()
		updated -= id
		if(save_favorites(updated))
			notice = "已取消收藏。"
		return TRUE
	var/verb_path = catalog[id]
	var/reason = unavailable_reason(verb_path, authorized_verbs(), command_counts())
	if(length(reason))
		notice = reason
		notice_error = TRUE
		return TRUE
	if(action == "favorite")
		if(!(id in favorites))
			var/list/updated = favorites.Copy()
			updated += id
			if(save_favorites(updated))
				notice = "已收藏，重新连接后仍会保留。"
		return TRUE
	// 命令只来自服务器目录；编码避免名称被解释为额外的界面设置。
	var/command = native_command(verb_path)
	notice = "已交由原指令处理。"
	notice_error = FALSE
	winset(owner_client, null, "command=[url_encode(command)]")
	return TRUE
