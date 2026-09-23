// 生成白名单只来自实际制作、兑换及购买目录，客户端不能提交类型路径。
/datum/z121_world_modulation/proc/build_catalog()
	for(var/datum/crafting_recipe/recipe as anything in GLOB.crafting_recipes)
		if(recipe.hides_from_crafting_menu || !recipe.name)
			continue
		var/list/results = islist(recipe.result) ? recipe.result : list(recipe.result)
		for(var/result in results)
			add_catalog_entry(result, "craft", recipe.category, recipe.name)
	for(var/datum/anvil_recipe/recipe as anything in GLOB.anvil_recipes)
		add_catalog_entry(recipe.created_item, "craft", "锻造 · [recipe.i_type]", recipe.name)

	var/list/rpg_catalogs = list(
		"武器" = z121_rpg_weapon_catalog(),
		"装备" = z121_rpg_equipment_catalog(),
		"消耗品" = z121_rpg_consumable_catalog(),
		"材料" = z121_rpg_material_catalog(),
		"魔法物品" = z121_rpg_magic_catalog(),
		"美食" = z121_rpg_delicacy_catalog(),
		"神器" = z121_rpg_artifact_catalog(),
	)
	for(var/category in rpg_catalogs)
		var/list/catalog = rpg_catalogs[category]
		for(var/label in catalog)
			var/list/entry = catalog[label]
			// RPG 名称包含价格后缀，管理员目录中不显示积分。
			var/price_start = findtext(label, "（")
			var/clean_name = price_start ? copytext(label, 1, price_start) : label
			add_catalog_entry(entry[2], "rpg", category, clean_name)

	for(var/pack_type in SSmerchant.supply_packs)
		var/datum/supply_pack/pack = SSmerchant.supply_packs[pack_type]
		for(var/result in pack.contains)
			add_catalog_entry(result, "purchase", pack.group, pack.name)
	for(var/datum/roguestock/stock as anything in SStreasury.stockpile_datums)
		if(!stock.withdraw_disabled && !stock.export_only)
			add_catalog_entry(stock.item_type, "purchase", "仓库 · [stock.category]", stock.name)
	for(var/datum/crown_import/import_entry as anything in GLOB.crown_imports)
		add_catalog_entry(import_entry.item_type, "purchase", "王室进口", import_entry.name)

/datum/z121_world_modulation/proc/add_catalog_entry(atom/entry_type, source, category, label)
	var/kind
	if(ispath(entry_type, /obj/item))
		kind = "items"
	else if(ispath(entry_type, /obj/structure) || ispath(entry_type, /obj/machinery) || ispath(entry_type, /turf))
		kind = "buildings"
	else if(ispath(entry_type, /mob/living))
		kind = "creatures"
	else
		return
	if(initial(entry_type.abstract_type) == entry_type)
		return
	category = category || "其他"
	var/entry_key = "[source]|[category]|[entry_type]"
	if(catalog_keys[entry_key])
		return
	catalog_keys[entry_key] = TRUE
	var/entry_name = label || initial(entry_type.name)
	// 配方或货包有多个产物时，同时标出具体产物，避免同名条目无法区分。
	if(source != "rpg" && entry_name != initial(entry_type.name))
		entry_name += " · [initial(entry_type.name)]"
	catalog_entries += list(list(
		"id" = length(catalog_entries) + 1,
		"name" = entry_name,
		"description" = html_decode(GLOB.html_tags.Replace(initial(entry_type.desc) || "", "")),
		"kind" = kind,
		"source" = source,
		"category" = category,
		"type" = entry_type,
		"terrain" = ispath(entry_type, /turf),
	))

/datum/z121_world_modulation/proc/catalog_data()
	var/list/categories = list("全部")
	var/list/matching = list()
	for(var/list/entry as anything in catalog_entries)
		if(entry["kind"] != current_tab || (catalog_source != "all" && entry["source"] != catalog_source))
			continue
		categories |= entry["category"]
		if(catalog_category == "全部" || catalog_category == entry["category"])
			matching += list(entry)
	var/pages = max(1, CEILING(length(matching) / 24, 1))
	catalog_page = clamp(catalog_page, 1, pages)
	var/list/rows = list()
	for(var/index = 1 + (catalog_page - 1) * 24; index <= min(catalog_page * 24, length(matching)); index++)
		var/list/entry = matching[index]
		var/list/row = entry.Copy()
		row -= "type"
		rows += list(row)
	return list("categories" = categories, "rows" = rows, "page" = catalog_page, "pages" = pages, "total" = length(matching))

/datum/z121_world_modulation/proc/spawn_entry(mob/user, entry_id)
	if(!isnum(entry_id) || entry_id != round(entry_id) || entry_id < 1 || entry_id > length(catalog_entries))
		return
	var/list/entry = catalog_entries[entry_id]
	if(entry["kind"] != current_tab)
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
	audit("生成 [entry_type]，来源 [entry["source"]] / [entry["category"]]，位置 [AREACOORD(destination)]")
