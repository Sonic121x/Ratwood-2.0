// 账号级提示仅表达玩家偏好，不更改战斗、互动权限或管理员处理规则。
GLOBAL_DATUM(z121_ooc_examine_service, /datum/z121_ooc_examine_service)
GLOBAL_LIST_INIT(z121_ooc_examine_labels, list(
	"pvp_none" = "【OOC提示-PVP无感】",
	"erp_none" = "【OOC提示-ERP无感】",
	"lrp" = "【OOC提示-LRP】",
	"mrp" = "【OOC提示-MRP】",
	"pvp_ready" = "【OOC提示-PVP准备】",
	"erp_interest" = "【OOC提示-ERP兴趣】",
	"erp_enthusiast" = "【OOC提示-ERP狂热】",
	"custom_1" = "【自定义OOC提示1】",
	"custom_2" = "【自定义OOC提示2】",
	"custom_3" = "【自定义OOC提示3】",
))
GLOBAL_LIST_INIT(z121_ooc_examine_descriptions, list(
	"pvp_none" = "该玩家对于PVP内容完全无感，不会参与到任何的PVP对抗中，也不想被卷入，如果发现该玩家主动参与到PVP内容或者被卷入，可以向管理员提交情况",
	"erp_none" = "该玩家对于ERP内容完全无感，不会参与到任何的ERP内容中，也不想被卷入",
	"lrp" = "该玩家能做到LRP要求，比如战前放话，较为合理的角色扮演",
	"mrp" = "该玩家对自己的RP水平有较高要求，可以做到战斗中RP，充分合理的代入角色",
	"pvp_ready" = "该玩家做好了面对游戏中任何可能的合理的PVP内容的准备，哪怕是出城被强盗劫杀也是合理的",
	"erp_interest" = "该玩家对ERP内容有一定兴趣，可以接受不太过分的ERP内容",
	"erp_enthusiast" = "该玩家对于ERP内容非常感兴趣，可以接受任何情况的ERP内容",
	"custom_1" = "允许玩家自定义显示的OOC提示内容",
	"custom_2" = "允许玩家自定义显示的OOC提示内容",
	"custom_3" = "允许玩家自定义显示的OOC提示内容",
))
GLOBAL_LIST_INIT(z121_ooc_examine_conflicts, list(
	list("pvp_none", "pvp_ready"),
	list("erp_none", "erp_interest", "erp_enthusiast"),
	list("lrp", "mrp"),
))

/client
	var/z121_ooc_examine_editing = FALSE

/mob
	// 保留账号数据引用，使断线与死亡后的身体仍能显示提示；接管时替换引用。
	var/datum/z121_ooc_examine_profile/z121_ooc_profile
	// 检视后信号用于补足未发送正常检视信号的形态，弱引用避免滞留目标。
	var/datum/weakref/z121_ooc_examined_ref
	var/z121_ooc_examined_at = -1

/proc/register_z121_ooc_examine()
	if(GLOB.z121_ooc_examine_service)
		return
	GLOB.z121_ooc_examine_service = new
	GLOB.z121_ooc_examine_service.register()

/datum/z121_ooc_examine_service
	var/list/profiles = list()

/datum/z121_ooc_examine_service/proc/register()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_mob_created))
	for(var/mob/player in GLOB.mob_list)
		watch_mob(player)

/datum/z121_ooc_examine_service/proc/on_mob_created(datum/source, mob/created)
	SIGNAL_HANDLER
	watch_mob(created)

/datum/z121_ooc_examine_service/proc/watch_mob(mob/player)
	RegisterSignal(player, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	RegisterSignal(player, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(player, COMSIG_MOB_EXAMINATE, PROC_REF(on_examinate))
	if(player.client)
		player.z121_ooc_profile = get_profile(player.client.ckey)

/datum/z121_ooc_examine_service/proc/get_profile(account_key)
	account_key = ckey(account_key)
	if(!length(account_key))
		return null
	var/datum/z121_ooc_examine_profile/profile = profiles[account_key]
	if(!profile)
		profile = new(account_key)
		profiles[account_key] = profile
	return profile

/datum/z121_ooc_examine_service/proc/on_login(mob/player, client/player_client)
	SIGNAL_HANDLER
	player.z121_ooc_profile = get_profile(player_client?.ckey)

/datum/z121_ooc_examine_service/proc/on_examine(mob/target, mob/viewer, list/examine_lines)
	SIGNAL_HANDLER
	if(!viewer || !islist(examine_lines))
		return
	viewer.z121_ooc_examined_ref = WEAKREF(target)
	viewer.z121_ooc_examined_at = world.time
	if(target.z121_ooc_profile)
		examine_lines += target.z121_ooc_profile.examine_lines()

/datum/z121_ooc_examine_service/proc/on_examinate(mob/viewer, atom/target)
	SIGNAL_HANDLER
	var/already_shown = viewer.z121_ooc_examined_at == world.time && viewer.z121_ooc_examined_ref?.resolve() == target
	viewer.z121_ooc_examined_ref = null
	viewer.z121_ooc_examined_at = -1
	if(already_shown || !ismob(target))
		return
	// 简单动物等形态没有正常检视信号，在原检视结果之后补上同一组提示。
	var/mob/player = target
	var/list/lines = player.z121_ooc_profile?.examine_lines()
	if(length(lines))
		to_chat(viewer, viewer.client?.prefs?.no_examine_blocks ? lines.Join("\n") : examine_block(lines.Join("\n")))

/datum/z121_ooc_examine_profile
	var/account_key
	var/list/selected = list()
	var/list/custom_text = list("custom_1" = "", "custom_2" = "", "custom_3" = "")

/datum/z121_ooc_examine_profile/New(player_key)
	account_key = ckey(player_key)
	load_profile()

/datum/z121_ooc_examine_profile/proc/save_path()
	return "data/player_saves/[copytext(account_key, 1, 2)]/[account_key]/z121_ooc_examine.sav"

// 自定义内容始终保存为纯文本；换行折为空格，输出时统一转义。
/proc/z121_ooc_plain_text(value)
	if(!istext(value))
		return ""
	return trim(replacetext(replacetext(replacetext(value, ascii2text(13), " "), "\n", " "), "\t", " "))

/proc/z121_ooc_conflicting_labels(list/choices)
	var/list/conflicting = list()
	for(var/list/group as anything in GLOB.z121_ooc_examine_conflicts)
		var/list/matches = group & choices
		if(length(matches) > 1)
			for(var/id in matches)
				conflicting += GLOB.z121_ooc_examine_labels[id]
	return conflicting.Join("、")

/datum/z121_ooc_examine_profile/proc/load_profile()
	if(!fexists(save_path()))
		return
	try
		var/savefile/storage = new(save_path())
		var/version
		var/list/saved_selected
		var/list/saved_custom
		storage["version"] >> version
		storage["selected"] >> saved_selected
		storage["custom_text"] >> saved_custom
		if(version != 1)
			return
		if(islist(saved_custom))
			for(var/id in custom_text)
				custom_text[id] = copytext_char(z121_ooc_plain_text(saved_custom[id]), 1, 257)
		if(!islist(saved_selected))
			return
		// 按展示顺序筛选已知项目；异常互斥存档只保留每组最先出现的一项。
		for(var/id in GLOB.z121_ooc_examine_labels)
			if(!(id in saved_selected) || ((id in custom_text) && !length(custom_text[id])))
				continue
			var/list/candidate = selected.Copy()
			candidate += id
			if(!length(z121_ooc_conflicting_labels(candidate)))
				selected = candidate
	catch(var/exception/error)
		selected = list()
		custom_text = list("custom_1" = "", "custom_2" = "", "custom_3" = "")
		log_game("OOC检视文本：读取 [account_key] 的存档失败：[error]")

/datum/z121_ooc_examine_profile/proc/save_profile(list/new_selected, list/new_custom)
	try
		var/savefile/storage = new(save_path())
		storage["version"] << 1
		storage["selected"] << new_selected
		storage["custom_text"] << new_custom
		storage.Flush()
	catch(var/exception/error)
		log_game("OOC检视文本：保存 [account_key] 的存档失败：[error]")
		return FALSE
	// 写盘成功后才替换共享数据，所有关联身体下次检视时立即使用新设置。
	selected = new_selected.Copy()
	custom_text = new_custom.Copy()
	return TRUE

/datum/z121_ooc_examine_profile/proc/examine_lines()
	var/list/lines = list()
	for(var/id in GLOB.z121_ooc_examine_labels)
		if(!(id in selected))
			continue
		var/body = (id in custom_text) ? custom_text[id] : GLOB.z121_ooc_examine_descriptions[id]
		if(length(body))
			lines += span_notice("[GLOB.z121_ooc_examine_labels[id]]：[html_encode(body)]")
	return lines

/client/verb/z121_ooc_examine_text()
	set name = "OOC检视文本"
	set category = "OOC"
	set desc = "选择或编辑向其他玩家展示的OOC提示，设置按账号保存。"
	if(z121_ooc_examine_editing)
		to_chat(src, span_notice("你已经打开了OOC检视文本编辑窗口。"))
		return
	if(!mob)
		return
	z121_ooc_examine_editing = TRUE
	try
		edit_z121_ooc_examine_text()
	catch(var/exception/error)
		log_game("OOC检视文本：编辑流程发生异常：[error]")
		if(src)
			to_chat(src, span_warning("OOC检视文本编辑失败，请重新打开指令。"))
	if(src)
		z121_ooc_examine_editing = FALSE

/client/proc/edit_z121_ooc_examine_text()
	register_z121_ooc_examine()
	var/datum/z121_ooc_examine_profile/profile = GLOB.z121_ooc_examine_service.get_profile(ckey)
	if(!profile)
		return
	var/mob/editor = mob
	editor.z121_ooc_profile = profile
	var/list/labels = list()
	var/list/descriptions = list()
	var/list/checked_labels = list()
	for(var/id in GLOB.z121_ooc_examine_labels)
		var/label = GLOB.z121_ooc_examine_labels[id]
		labels += label
		descriptions[label] = GLOB.z121_ooc_examine_descriptions[id]
		if(id in profile.selected)
			checked_labels += label
	var/list/new_selected
	while(TRUE)
		// 强制使用已有多选界面，避免关闭现代输入的玩家被降级为单选。
		checked_labels = tgui_input_checkboxes(editor, "可多选；PVP两项、ERP三项、LRP与MRP分别互斥。全部取消勾选可隐藏提示。确认后编辑已勾选的自定义提示，中途取消不会保存。", "OOC检视文本", labels, min_checked = 0, max_checked = 10, default_checked = checked_labels, descriptions = descriptions, strict_modern = TRUE, window_width = 650, window_height = 700)
		if(!src || mob != editor || isnull(checked_labels))
			return
		new_selected = list()
		for(var/id in GLOB.z121_ooc_examine_labels)
			if(GLOB.z121_ooc_examine_labels[id] in checked_labels)
				new_selected += id
		var/conflicts = z121_ooc_conflicting_labels(new_selected)
		if(!length(conflicts))
			break
		to_chat(src, span_warning("以下提示互斥，请重新选择：[conflicts]"))
	var/list/new_custom = profile.custom_text.Copy()
	for(var/id in new_custom)
		if(!(id in new_selected))
			continue
		while(TRUE)
			// 原生输入配合字符计数，避免通用输入组件按字节限制中文长度。
			var/entry = input(src, "请输入提示内容，最多256个字符，不能为空。换行将显示为空格；取消会放弃本次所有修改。", GLOB.z121_ooc_examine_labels[id], new_custom[id]) as message|null
			if(!src || mob != editor || isnull(entry))
				return
			entry = z121_ooc_plain_text(entry)
			if(!length(entry) || length_char(entry) > 256)
				to_chat(src, span_warning("自定义OOC提示必须包含1至256个字符，请重新输入。"))
				continue
			new_custom[id] = entry
			break
	if(profile.save_profile(new_selected, new_custom))
		to_chat(src, span_notice("OOC检视文本已按账号保存，当前启用[length(new_selected)]项提示。"))
	else
		to_chat(src, span_warning("OOC检视文本保存失败，当前设置未更改，请稍后重试。"))
