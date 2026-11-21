/datum/config_entry/string/guide_catalog_url

/datum/http_request/z121_guide_catalog/build_options()
	return json_encode(list("timeout_seconds" = 10))

/datum/z121_guide_catalog
	var/list/tree = list()
	var/list/pages = list()
	var/default_page_id
	var/node_count = 0

SUBSYSTEM_DEF(z121_guide_catalog)
	name = "指南目录"
	flags = SS_NO_FIRE

	var/datum/z121_guide_catalog/catalog
	var/reload_in_progress = FALSE
	var/initial_load_requested = FALSE

/datum/controller/subsystem/z121_guide_catalog/Initialize(timeofday)
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGIN, PROC_REF(on_player_login))
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGOUT, PROC_REF(on_player_logout))
	for(var/mob/dead/new_player/player in GLOB.player_list)
		if(player.client)
			request_initial_catalog()
			break
	return ..()

/datum/controller/subsystem/z121_guide_catalog/proc/request_initial_catalog()
	if(catalog || initial_load_requested)
		return
	initial_load_requested = TRUE
	INVOKE_ASYNC(src, PROC_REF(load_initial_catalog))

/datum/controller/subsystem/z121_guide_catalog/proc/load_initial_catalog()
	UNTIL(!reload_in_progress)
	if(catalog)
		return
	var/url = trim(CONFIG_GET(string/guide_catalog_url))
	if(!length(url))
		log_config("指南目录不可用，尚未配置 GUIDE_CATALOG_URL。")
		return
	var/list/result = load_catalog(url)
	if(result["error"])
		log_config("指南目录加载失败：[result["error"]]")
		return
	apply_catalog(result["catalog"])

/datum/controller/subsystem/z121_guide_catalog/proc/load_catalog(url)
	if(reload_in_progress)
		return list("error" = "指南目录正在重新加载。")
	if(!is_https_url(url, TRUE))
		return list("error" = "指南目录必须使用有效的公开 HTTPS 地址。")

	reload_in_progress = TRUE
	var/datum/http_request/z121_guide_catalog/request = new
	request.prepare(RUSTG_HTTP_METHOD_GET, url)
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()
	reload_in_progress = FALSE
	if(response.errored)
		return list("error" = "目录请求失败。")
	if(response.status_code != 200)
		return list("error" = "目录返回 HTTP [response.status_code]。")
	if(!istext(response.body) || !length(response.body) || length(response.body) > 524288)
		return list("error" = "目录响应为空或超过 512 KiB。")
	var/datum/z121_guide_catalog/candidate = parse_catalog(safe_json_decode(response.body))
	if(!candidate)
		return list("error" = "目录 JSON 不符合版本 1 的数据结构。")
	return list("catalog" = candidate)

/datum/controller/subsystem/z121_guide_catalog/proc/parse_catalog(list/document)
	if(!islist(document) || document["version"] != 1)
		return
	var/wiki_base = istext(document["wiki_base_url"]) ? trim(document["wiki_base_url"]) : null
	var/list/nodes = document["tree"]
	if(!is_https_url(wiki_base, FALSE) || !islist(nodes) || !length(nodes) || length(nodes) > 64)
		return
	while(copytext(wiki_base, -1) == "/")
		wiki_base = copytext(wiki_base, 1, -1)
	var/datum/z121_guide_catalog/candidate = new
	var/list/seen_ids = list()
	for(var/node as anything in nodes)
		var/list/entry = parse_node(node, wiki_base, candidate, seen_ids, 1)
		if(!entry)
			return
		candidate.tree += list(entry)
	return candidate.default_page_id ? candidate : null

/datum/controller/subsystem/z121_guide_catalog/proc/parse_node(list/node, wiki_base, datum/z121_guide_catalog/candidate, list/seen_ids, depth)
	if(!islist(node) || depth > 8 || ++candidate.node_count > 512)
		return
	var/id = node["id"]
	var/static/regex/id_pattern = regex(@"^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$")
	var/label = catalog_text(node["label"], 128)
	if(!istext(id) || length(id) > 64 || !id_pattern.Find(id) || seen_ids[id] || !label)
		return
	seen_ids[id] = TRUE
	var/kind = node["kind"]
	var/list/entry = list("kind" = kind, "id" = id, "label" = label)
	switch(kind)
		if("page")
			var/title = catalog_text(node["title"], 255)
			if(!title || title == "." || title == ".." || length(seen_ids) > 256)
				return
			candidate.pages[id] = list("label" = label, "url" = "[wiki_base]/[url_encode(title)]?useskin=vector")
			candidate.default_page_id ||= id
		if("category")
			var/list/nodes = node["children"]
			if(!islist(nodes) || !length(nodes) || length(nodes) > 64)
				return
			var/list/children = list()
			for(var/child as anything in nodes)
				var/list/parsed = parse_node(child, wiki_base, candidate, seen_ids, depth + 1)
				if(!parsed)
					return
				children += list(parsed)
			entry["children"] = children
		else
			return
	return entry

/datum/controller/subsystem/z121_guide_catalog/proc/catalog_text(value, limit)
	if(!istext(value))
		return
	value = trim(value)
	var/static/regex/control_chars = regex(@"[\x00-\x1f\x7f]")
	if(!length(value) || length_char(value) > limit || control_chars.Find(value))
		return
	return value

/datum/controller/subsystem/z121_guide_catalog/proc/is_https_url(value, allow_query)
	if(!istext(value) || length(value) > 2048 || findtext(value, "#") || findtext(value, "@") || (!allow_query && findtext(value, "?")))
		return FALSE
	var/static/regex/https_url = regex(@"^https://(?!localhost\.)([a-z0-9-]+\.)+[a-z][a-z0-9-]*(:[0-9]+)?([/?][^\s\\]*)?$", "i")
	return https_url.Find(value)

/datum/controller/subsystem/z121_guide_catalog/proc/apply_catalog(datum/z121_guide_catalog/candidate)
	catalog = candidate
	for(var/client/connected as anything in GLOB.clients)
		ensure_action(connected.player_details, connected.mob)
	for(var/ckey in GLOB.player_details)
		var/datum/player_details/details = GLOB.player_details[ckey]
		var/datum/action/z121_guide_browser/action = locate() in details.player_actions
		if(!action)
			continue
		action.get_selected_page()
		SStgui.close_uis(action)

/datum/controller/subsystem/z121_guide_catalog/proc/on_player_login(datum/source, mob/player)
	SIGNAL_HANDLER
	if(istype(player, /mob/dead/new_player) && player.client)
		request_initial_catalog()
	ensure_action(player.client?.player_details, player)

/datum/controller/subsystem/z121_guide_catalog/proc/on_player_logout(datum/source, mob/player)
	SIGNAL_HANDLER
	var/datum/player_details/details = player.canon_client?.player_details
	if(!details)
		return
	var/datum/action/z121_guide_browser/action = locate() in details.player_actions
	action?.Remove(player)

/datum/controller/subsystem/z121_guide_catalog/proc/ensure_action(datum/player_details/details, mob/player)
	if(!catalog || !details)
		return
	var/datum/action/z121_guide_browser/action = locate() in details.player_actions
	if(!action)
		action = new(details)
		action.selected_page_id = catalog.default_page_id
		details.player_actions += action
	if(player)
		action.Grant(player)
	return action
