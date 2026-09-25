// 仅在玩家手动查看时生成正文，缓存供后续查看复用。
/proc/z121_changelog_content()
	var/static/rendered_content
	if(!isnull(rendered_content))
		return rendered_content
	var/list/sections = list("<p class='z121-intro'>自定义内容更新记录</p>")
	var/list/entries = z121_changelog_entries()
	for(var/date in sort_list(entries, GLOBAL_PROC_REF(cmp_text_dsc)))
		sections += "<h2>[html_encode(date)]</h2><ul class='z121-changes'>"
		var/list/changes = entries[date]
		for(var/category in changes)
			sections += "<li><strong>[html_encode(category)]</strong><p>[html_encode(changes[category])]</p></li>"
		sections += "</ul>"
	rendered_content = sections.Join()
	return rendered_content

/client/verb/z121_changelog()
	set name = "自定义更新日志"
	set category = "OOC"
	set desc = "查看按日期整理的自定义内容更新记录。"
	open_z121_changelog()

/client/proc/open_z121_changelog()
	if(!mob || QDELETED(mob) || mob.client != src)
		return
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
	popup.set_content(z121_changelog_content())
	// 纯阅读窗口无需关闭回调；内容发送后释放临时窗口数据，避免保留旧角色引用。
	popup.open(FALSE)
	qdel(popup)
