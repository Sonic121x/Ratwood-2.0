/datum/action/z121_guide_browser
	name = "指南浏览器"
	desc = "浏览服务器 Wiki 指南。"
	button_icon_state = "round_end"
	show_to_observers = FALSE

	var/selected_page_id

/datum/action/z121_guide_browser/Remove(mob/remove_from)
	if(!owner || owner != remove_from)
		return
	SStgui.close_uis(src)
	return ..()

/datum/action/z121_guide_browser/Trigger(trigger_flags)
	if(!..() || ui_status(owner, null) != UI_INTERACTIVE)
		return FALSE
	return ui_interact(owner)

/datum/action/z121_guide_browser/ui_status(mob/user, datum/ui_state/state)
	if(user && user == owner && user.client?.mob == user && SSz121_guide_catalog.catalog)
		return UI_INTERACTIVE
	return UI_CLOSE

/datum/action/z121_guide_browser/ui_interact(mob/user, datum/tgui/ui)
	if(ui_status(user, null) != UI_INTERACTIVE)
		return FALSE
	if(user.client.byond_version < 516)
		return open_page_external(user, TRUE)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GuideBrowser", name)
		ui.open()
	return TRUE

/datum/action/z121_guide_browser/ui_static_data(mob/user)
	return list("guide_tree" = SSz121_guide_catalog.catalog?.tree)

/datum/action/z121_guide_browser/ui_data(mob/user)
	var/datum/z121_guide_catalog/catalog = SSz121_guide_catalog.catalog
	var/list/page = get_selected_page()
	return list(
		"selected_id" = selected_page_id,
		"selected_title" = page?["label"],
		"page_url" = page?["url"],
		"wiki_available" = !!catalog,
		"supports_iframe" = user.client?.byond_version >= 516,
	)

/datum/action/z121_guide_browser/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..() || ui.user != usr || ui_status(ui.user, state) != UI_INTERACTIVE)
		return
	switch(action)
		if("select_page")
			var/page_id = params["id"]
			if(!istext(page_id) || !SSz121_guide_catalog.catalog.pages[page_id])
				return
			selected_page_id = page_id
			return TRUE
		if("open_external")
			return open_page_external(ui.user)

/datum/action/z121_guide_browser/proc/get_selected_page()
	var/datum/z121_guide_catalog/catalog = SSz121_guide_catalog.catalog
	if(!catalog)
		return
	if(!selected_page_id || !catalog.pages[selected_page_id])
		selected_page_id = catalog.default_page_id
	return catalog.pages[selected_page_id]

/datum/action/z121_guide_browser/proc/open_page_external(mob/user, confirm = FALSE)
	var/list/page = get_selected_page()
	if(!page)
		user.balloon_alert(user, "百科暂不可用")
		return FALSE
	if(confirm && tgui_alert(user, "此指南将在浏览器中打开，是否继续？", name, list("是", "否")) != "是")
		return FALSE
	if(ui_status(user, null) != UI_INTERACTIVE)
		return FALSE
	DIRECT_OUTPUT(user, link(page["url"]))
	return TRUE
