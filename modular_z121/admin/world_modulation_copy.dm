// 复制上下文保存原件与副本的对应关系，失败时统一回收本次生成的全部物品。
/datum/z121_world_copy
	var/list/originals = list()
	var/list/copies = list()
	var/list/list_copies = list()
	var/committed = FALSE
	var/error_text

/datum/z121_world_copy/Destroy()
	if(!committed)
		for(var/obj/item/original as anything in copies)
			var/obj/item/copy = copies[original]
			if(!QDELETED(copy))
				qdel(copy)
	originals = null
	copies = null
	list_copies = null
	return ..()

/datum/z121_world_copy/proc/inspect_tree(obj/item/original, depth = 0)
	if(QDELETED(original) || (original in originals))
		error_text = "物品已失效或存在循环内容，无法复制。"
		return FALSE
	if(depth > 10 || length(originals) >= 200)
		error_text = "复制上限为十层嵌套、总计二百件物品。"
		return FALSE
	originals += original
	for(var/atom/movable/content in original.contents)
		if(ismob(content))
			error_text = "物品中包含生物，不能复制。"
			return FALSE
		if(isitem(content) && !inspect_tree(content, depth + 1))
			return FALSE
	return TRUE

// 深复制普通列表；内容物引用改指副本，其他运行中对象不沿用原件引用。
/datum/z121_world_copy/proc/copy_value(value, depth = 0)
	if(depth > 32)
		return null
	if(islist(value))
		if(list_copies[value])
			return list_copies[value]
		var/list/source_list = value
		var/list/result = list()
		list_copies[source_list] = result
		for(var/index = 1; index <= length(source_list); index++)
			var/key = source_list[index]
			var/new_key = copy_value(key, depth + 1)
			result += list(new_key)
			if(!isnum(key) && !isnull(key) && !isnull(new_key) && !isnull(source_list[key]))
				result[new_key] = copy_value(source_list[key], depth + 1)
		return result
	if(istype(value, /datum))
		return copies[value]
	if(isicon(value))
		return new /icon(value)
	return value

/datum/z121_world_copy/proc/create_copy(turf/destination)
	// 仅用原版复制函数构造同类型新品；普通变量在全部副本存在后再复制并重定向引用。
	for(var/obj/item/original as anything in originals)
		if(QDELETED(original))
			error_text = "复制过程中原件失效。"
			return null
		var/atom/copy_location = copies[original.loc] || destination
		var/obj/item/copy = DuplicateObject(original, perfectcopy = FALSE, sameloc = FALSE, newloc = copy_location)
		if(QDELETED(copy))
			error_text = "该物品无法初始化为独立副本。"
			return null
		copies[original] = copy
		// 容器构造时可能自带内容，只保留新组件自身的非物品效果对象。
		for(var/atom/movable/default_content in copy.contents.Copy())
			if(ismob(default_content))
				error_text = "该物品会自动创建生物，不能复制。"
				return null
			if(isitem(default_content))
				qdel(default_content)

	var/list/forbidden = GLOB.duplicate_forbidden_vars + list(
		"actions", "actions_types", "active_timers", "signal_procs", "signal_enabled",
		"weak_reference", "cooldowns", "datum_flags", "gc_destroyed", "harddel_deets_dumped",
		"overlays", "underlays", "managed_overlays", "priority_overlays", "our_overlays",
		"appearance", "vis_contents", "vis_locs", "filters", "light", "light_sources",
		"wielded", "altgripped", "equipped_to", "held_index", "screen_loc", "plane", "layer",
		"force_dynamic", "wdefense_dynamic", "icon_angle", "transform",
		"bound_x", "bound_y", "bound_width", "bound_height",
	)
	for(var/obj/item/original as anything in originals)
		var/obj/item/copy = copies[original]
		for(var/variable in original.vars - forbidden)
			var/value = original.vars[variable]
			// 未参与复制的组件、法术等对象保留新物品自己的初始化值。
			if(istype(value, /datum) && !copies[value])
				continue
			copy.vars[variable] = copy_value(value)
		if(original.reagents)
			if(!copy.reagents)
				copy.create_reagents(original.reagents.maximum_volume)
			copy.reagents.clear_reagents()
			copy.reagents.maximum_volume = original.reagents.maximum_volume
			copy.reagents.chem_temp = original.reagents.chem_temp
			// 逐份添加并暂缓反应，避免重组混合物时改变配比；不在原件上触发反应。
			for(var/datum/reagent/reagent as anything in original.reagents.reagent_list)
				copy.reagents.add_reagent(reagent.type, reagent.volume, copy_value(reagent.data), original.reagents.chem_temp, no_react = TRUE)
		else if(copy.reagents)
			copy.reagents.clear_reagents()
		// 副本尚未被双手握持，不能继承原件的临时握持伤害、防御或显示角度。
		copy.update_force_dynamic()
		copy.wdefense_dynamic = copy.wdefense
		copy.update_transform()
		copy.update_icon()
	return copies[originals[1]]

/datum/z121_world_modulation/proc/duplicate_held_item(mob/living/body)
	var/obj/item/original = body.get_active_held_item()
	var/turf/destination = get_turf(body)
	if(QDELETED(original) || !destination)
		notice = "当前活动手中没有可以复制的物品。"
		return
	var/datum/z121_world_copy/context = new
	try
		if(!context.inspect_tree(original))
			notice = context.error_text
		else
			var/obj/item/copy = context.create_copy(destination)
			if(!QDELETED(copy) && can_use(body) && body.get_active_held_item() == original)
				body.put_in_hands(copy)
				context.committed = TRUE
				notice = "已复制 [original.name]，共 [length(context.originals)] 件物品。"
				audit("复制手中物品 [original.type]，共 [length(context.originals)] 件，位置 [AREACOORD(destination)]")
			else
				notice = context.error_text || "原件或当前角色发生变化，已取消复制。"
	catch(var/exception/error)
		log_runtime("世界调制复制异常：[error]")
		notice = "复制失败，已清理本次副本；详情见服务器日志。"
	qdel(context)
