// 类型路径同时充当稳定 ID；生成时只接受服务端预设或已登记的物品类型。
/datum/z121_world_modulation/proc/add_catalog_entry(atom/entry_type, category, subcategory, label, aliases)
	var/kind
	if(ispath(entry_type, /obj/item))
		kind = "items"
	else if(ispath(entry_type, /obj/structure) || ispath(entry_type, /obj/machinery) || ispath(entry_type, /turf))
		kind = "buildings"
	else if(ispath(entry_type, /mob/living))
		kind = "creatures"
	else
		return
	if(initial(entry_type.abstract_type) == entry_type || catalog_entries["[entry_type]"])
		return
	catalog_entries["[entry_type]"] = list(
		"id" = "[entry_type]",
		"name" = label || initial(entry_type.name),
		"description" = html_decode(GLOB.html_tags.Replace(initial(entry_type.desc) || "", "")),
		"aliases" = aliases || initial(entry_type.name),
		"kind" = kind,
		"category" = category,
		"subcategory" = subcategory,
		"type" = entry_type,
		"terrain" = ispath(entry_type, /turf),
	)

// 全类型检索只读取初始元数据，不为搜索实例化物品。
/proc/z121_world_item_index()
	var/static/list/entries
	if(!isnull(entries))
		return entries
	entries = list()
	for(var/obj/item/path as anything in subtypesof(/obj/item))
		if(initial(path.abstract_type) == path)
			continue
		entries["[path]"] = list(
			"id" = "[path]", "type" = path, "kind" = "items",
			"name" = initial(path.name),
			"description" = html_decode(GLOB.html_tags.Replace(initial(path.desc) || "", "")),
			"category" = "全类型检索", "subcategory" = "物品",
		)
	return entries

/datum/z121_world_modulation/proc/catalog_data()
	var/list/categories = list("全部")
	var/list/subcategories = list("全部")
	var/list/matching = list()
	var/list/exact = list()
	var/lookup = current_tab == "items" && catalog_lookup
	var/list/entries = lookup ? z121_world_item_index() : catalog_entries
	for(var/id in entries)
		var/list/entry = entries[id]
		if(entry["kind"] != current_tab)
			continue
		if(!lookup)
			categories |= entry["category"]
			if(catalog_category != "全部" && catalog_category != entry["category"])
				continue
			subcategories |= entry["subcategory"]
			if(catalog_subcategory != "全部" && catalog_subcategory != entry["subcategory"])
				continue
		var/list/preset = catalog_entries[id]
		var/searchable = "[entry["name"]] [entry["description"]] [preset?["name"]] [preset?["aliases"]]"
		if(length(catalog_query))
			if(lowertext(catalog_query) == lowertext(id) || lowertext(catalog_query) == lowertext(entry["name"]) || (preset && lowertext(catalog_query) == lowertext(preset["name"])))
				exact += list(entry)
				continue
			if(!findtext(searchable, catalog_query) && !findtext(id, catalog_query))
				continue
		else if(lookup)
			continue
		matching += list(entry)
	matching = exact + matching
	var/pages = max(1, CEILING(length(matching) / 24, 1))
	catalog_page = clamp(catalog_page, 1, pages)
	var/list/rows = list()
	for(var/index = 1 + (catalog_page - 1) * 24; index <= min(catalog_page * 24, length(matching)); index++)
		var/list/entry = matching[index]
		var/list/row = entry.Copy()
		row -= "type"
		if(lookup && catalog_entries[row["id"]])
			var/list/preset = catalog_entries[row["id"]]
			row["name"] = preset["name"]
			row["aliases"] = preset["aliases"]
		rows += list(row)
	return list("categories" = categories, "subcategories" = subcategories, "rows" = rows, "page" = catalog_page, "pages" = pages, "total" = length(matching))

/datum/z121_world_modulation/proc/spawn_entry(mob/user, entry_id)
	if(!istext(entry_id))
		return
	var/list/entry = catalog_entries[entry_id]
	if(current_tab == "items" && catalog_lookup)
		var/list/item_index = z121_world_item_index()
		entry = item_index[entry_id]
	if(!entry || entry["kind"] != current_tab)
		return
	var/turf/destination = get_turf(user)
	if(spawn_position == "front")
		destination = get_step(destination, user.dir)
	if(!destination)
		notice = "当前位置没有可用地块。"
		return
	var/entry_type = entry["type"]
	var/atom/created
	if(ispath(entry_type, /turf))
		created = destination.ChangeTurf(entry_type)
	else
		created = new entry_type(destination)
	if(QDELETED(created))
		notice = "条目初始化失败，未生成可用对象。"
		return
	created.setDir(user.dir)
	if(isitem(created) && isliving(user) && spawn_position == "here")
		var/obj/item/item = created
		user.put_in_hands(item)
	notice = "已生成：[entry["name"]]。"
	audit("生成 [entry_type]，分类 [entry["category"]] / [entry["subcategory"]]，位置 [AREACOORD(destination)]")
