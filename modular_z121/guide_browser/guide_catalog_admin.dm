/client/proc/z121_reload_guide_catalog()
	set name = "重新加载指南目录"
	set desc = "从 HTTPS JSON 接口重新加载指南目录。"
	set category = "-服务器-"

	if(!check_rights(R_SERVER))
		return
	var/current_url = CONFIG_GET(string/guide_catalog_url)
	var/new_url = tgui_input_text(mob, "输入指南目录的 HTTPS 地址。", "重新加载指南目录", current_url, 2048, encode = FALSE)
	if(isnull(new_url) || !check_rights_for(src, R_SERVER))
		return
	new_url = trim(new_url)
	if(!length(new_url))
		to_chat(src, span_warning("必须提供指南目录网址。"))
		return
	var/list/result = SSz121_guide_catalog.load_catalog(new_url)
	if(result["error"])
		to_chat(src, span_warning("指南目录重新加载失败：[result["error"]] [SSz121_guide_catalog.catalog ? "仍在使用原有目录。" : "指南浏览器仍不可用。"]"))
		log_admin("[key_name(src)]重新加载指南目录失败：[result["error"]]")
		return
	var/datum/z121_guide_catalog/candidate = result["catalog"]
	CONFIG_SET(string/guide_catalog_url, new_url)
	SSz121_guide_catalog.apply_catalog(candidate)
	to_chat(src, span_notice("指南目录已重新加载，共 [candidate.node_count] 个节点。此次地址仅在当前运行期间生效。若需重启后保留，请更新 config.txt。"))
	log_admin("[key_name(src)]重新加载了指南目录，共 [candidate.node_count] 个节点。")
	message_admins("[key_name_admin(src)]重新加载了指南目录，共 [candidate.node_count] 个节点。")
	SSblackbox.record_feedback("nested tally", "admin_verb", 1, list("Reload Guide Catalog"))
