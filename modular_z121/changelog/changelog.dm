GLOBAL_DATUM(z121_changelog_service, /datum/z121_changelog_service)

/client
	// 状态仅属于本次连接；重连自动重置，换身体不会重置。
	var/z121_changelog_shown = FALSE
	var/z121_changelog_pending = FALSE

// 大厅角色和观察者的初始化不发送普通角色创建信号，须在创建时单独接入登录监听。
// 仍调用原有创建流程；启动过早时由服务初始化时的角色扫描补齐。
/mob/dead/New()
	. = ..()
	GLOB.z121_changelog_service?.watch_mob(src)

/proc/register_z121_changelog()
	if(GLOB.z121_changelog_service)
		return
	GLOB.z121_changelog_service = new
	GLOB.z121_changelog_service.register()

/datum/z121_changelog_service
	var/rendered_content

/datum/z121_changelog_service/proc/register()
	rendered_content = build_content()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_mob_created))
	// 兼顾子系统初始化之前已创建的大厅角色与已连接玩家。
	for(var/mob/player in GLOB.mob_list)
		watch_mob(player)

/datum/z121_changelog_service/proc/on_mob_created(datum/source, mob/player)
	SIGNAL_HANDLER
	watch_mob(player)

/datum/z121_changelog_service/proc/watch_mob(mob/player)
	if(QDELETED(player))
		return
	// 创建入口与启动扫描可能遇到同一角色，只更新本服务的监听，不重复注册。
	RegisterSignal(player, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login), override = TRUE)
	if(player.client)
		queue_popup(player.client)

/datum/z121_changelog_service/proc/on_login(mob/player, client/player_client)
	SIGNAL_HANDLER
	queue_popup(player_client)

/datum/z121_changelog_service/proc/queue_popup(client/player_client)
	if(!player_client || player_client.z121_changelog_shown || player_client.z121_changelog_pending)
		return
	player_client.z121_changelog_pending = TRUE
	// 等待登录面板就绪，稍晚于原版日志弹出；不在登录信号中打开界面。
	addtimer(CALLBACK(src, PROC_REF(show_popup), player_client), 5 SECONDS)

/datum/z121_changelog_service/proc/show_popup(client/player_client)
	if(!player_client)
		return
	player_client.z121_changelog_pending = FALSE
	// 手动提前阅读后不再自动打开；断线后旧客户端不会向新连接发送窗口。
	if(player_client.z121_changelog_shown)
		return
	player_client.open_z121_changelog()

/datum/z121_changelog_service/proc/build_content()
	var/list/sections = list("<p class='z121-intro'>自定义内容更新记录</p>")
	var/list/entries = z121_changelog_entries()
	for(var/date in sort_list(entries, GLOBAL_PROC_REF(cmp_text_dsc)))
		sections += "<h2>[html_encode(date)]</h2><ul class='z121-changes'>"
		var/list/changes = entries[date]
		for(var/category in changes)
			sections += "<li><strong>[html_encode(category)]</strong><p>[html_encode(changes[category])]</p></li>"
		sections += "</ul>"
	return sections.Join()

/client/verb/z121_changelog()
	set name = "自定义更新日志"
	set category = "OOC"
	set desc = "查看按日期整理的自定义内容更新记录。"
	open_z121_changelog()

/client/proc/open_z121_changelog()
	if(!mob || QDELETED(mob) || mob.client != src || !GLOB.z121_changelog_service)
		return
	z121_changelog_shown = TRUE
	// 固定窗口名使重复打开刷新同一个窗口；每次使用客户端当前控制的角色。
	var/datum/browser/popup = new(mob, "z121_changelog", "自定义内容更新日志", 760, 650)
	popup.add_head_content({"
		<style>
			body { background: #191b1d; color: #e3dfd5; font-family: 'Microsoft YaHei', 'SimSun', sans-serif; font-size: 15px; }
			.uiWrapper { padding: 12px; }
			.uiTitle { color: #d8c392; font-size: 22px; }
			.z121-intro { color: #b9b4a9; }
			h2 { color: #d8c392; border-bottom: 1px solid #555044; padding-bottom: 8px; }
			.z121-changes { list-style: none; padding: 0; margin: 0; }
			.z121-changes li { margin-bottom: 18px; padding: 12px; background: #25282b; border-left: 3px solid #8d805c; }
			.z121-changes strong { color: #e9d5a5; font-size: 17px; }
			.z121-changes p { line-height: 1.8; margin: 6px 0 0; }
		</style>
	"})
	popup.set_content(GLOB.z121_changelog_service.rendered_content)
	// 纯阅读窗口无需关闭回调；内容发送后释放临时窗口数据，避免保留旧角色引用。
	popup.open(FALSE)
	qdel(popup)
