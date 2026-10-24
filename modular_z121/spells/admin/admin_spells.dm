/datum/action/cooldown/spell/z121/invoked/adminkill
	name = "管理员处决"
	desc = "以管理员之力立即杀死选中的目标。"
	point_cost = 1
	primary_resource_cost = 0
	hold_drain = 0
	charge_time = 0
	cooldown_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	cast_range = 20
	invocations = list()
	invocation_type = "none"

/datum/action/cooldown/spell/z121/invoked/adminkill/z121_apply(atom/cast_on)
	var/list/targets = list(cast_on)
	var/mob/living/user = owner
	if(!isliving(targets[1]))
		to_chat(user, span_warning("我只能对生物目标使用这道法术。"))
		z121_cancel()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.stat == DEAD)
		to_chat(user, span_notice("[target] 已经死了。"))
		z121_cancel()
		return FALSE

	target.visible_message(span_danger("[target] 被压倒性的管理员之力当场处决！"), span_userdanger("压倒性的管理员之力瞬间终结了我的生命！"))
	target.death()
	return TRUE

/datum/action/cooldown/spell/z121/invoked/adminheal
	name = "管理员复原"
	desc = "立即完全治疗选中的生物目标；若目标已经死亡，则尝试将其复活并完全治疗。"
	point_cost = 1
	primary_resource_cost = 0
	hold_drain = 0
	charge_time = 0
	cooldown_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	cast_range = 20
	invocations = list()
	invocation_type = "none"

/datum/action/cooldown/spell/z121/invoked/adminheal/z121_apply(atom/cast_on)
	var/list/targets = list(cast_on)
	var/mob/living/user = owner
	if(!isliving(targets[1]))
		to_chat(user, span_warning("我只能对生物目标施加治疗。"))
		z121_cancel()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.stat == DEAD)
		if(!target.revive(full_heal = TRUE, admin_revive = TRUE))
			to_chat(user, span_warning("无法使 [target] 恢复生机。"))
			z121_cancel()
			return FALSE
		target.visible_message(span_notice("[target] 在管理员之力的作用下重获新生！"), span_green("我在一瞬间重获新生！"))
		return TRUE

	target.fully_heal(admin_revive = TRUE, break_restraints = TRUE)
	target.visible_message(span_notice("[target] 身上的伤势瞬间消失了！"), span_green("我的伤势完全恢复了！"))
	return TRUE

/datum/action/cooldown/spell/blink/z121_admin
	name = "管理员闪现"
	desc = "传送到同一位面内选中的位置，最远可达20格；仍受障碍物和传送区域限制。"
	point_cost = 1
	primary_resource_cost = 0
	hold_drain = 0
	charge_time = 0
	cooldown_time = 0
	spell_tier = 1
	charge_slowdown = 0
	invocations = list()
	invocation_type = "none"
	max_range = 20
	cast_range = 20
	charge_required = FALSE

// 保留途经区域的禁传检查，其他判定、施法通知和传送效果复用父级。
/datum/action/cooldown/spell/blink/z121_admin/cast(atom/cast_on)
	var/turf/start = get_turf(owner)
	var/turf/destination = get_turf(cast_on)
	if(start && destination)
		var/list/turf_list = getline(start, destination)
		if(length(turf_list))
			turf_list.len--
		for(var/turf/traversal_turf in turf_list)
			var/area/traversal_area = get_area(traversal_turf)
			if(traversal_area?.noteleport)
				to_chat(owner, span_warning("这片区域不允许我传送！"))
				return FALSE
	return ..()

/datum/action/cooldown/spell/z121/invoked/mimicry/copy
	name = "物品复制"
	desc = "复制触手可及的物品及其液体和容器内容。容器内容最多递归复制8层，并跳过抽象物品、循环分支和无法装入容器的物品。"
	point_cost = 1
	primary_resource_cost = 0
	hold_drain = 0
	charge_time = 0
	cooldown_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	cast_range = 1
	invocations = list()
	invocation_type = "none"
	var/max_copy_depth = 8

/datum/action/cooldown/spell/z121/invoked/mimicry/copy/proc/copy_item_state(obj/item/source, obj/item/duplicate)
	duplicate.name = source.name
	duplicate.desc = source.desc
	duplicate.color = source.color
	duplicate.icon_state = source.icon_state
	duplicate.item_state = source.item_state
	duplicate.dir = source.dir
	duplicate.pixel_x = source.pixel_x
	duplicate.pixel_y = source.pixel_y
	duplicate.transform = source.transform

	if(hasvar(source, "amount") && hasvar(duplicate, "amount"))
		duplicate.vars["amount"] = source.vars["amount"]
	if(hasvar(source, "maxamount") && hasvar(duplicate, "maxamount"))
		duplicate.vars["maxamount"] = source.vars["maxamount"]
	if(hasvar(source, "quality") && hasvar(duplicate, "quality"))
		duplicate.vars["quality"] = source.vars["quality"]
	if(hasvar(source, "obj_integrity") && hasvar(duplicate, "obj_integrity"))
		duplicate.vars["obj_integrity"] = source.vars["obj_integrity"]
	if(hasvar(source, "max_integrity") && hasvar(duplicate, "max_integrity"))
		duplicate.vars["max_integrity"] = source.vars["max_integrity"]
	if(hascall(duplicate, "set_quantity") && hasvar(source, "quantity"))
		call(duplicate, "set_quantity")(source.vars["quantity"])
	else if(hasvar(source, "quantity") && hasvar(duplicate, "quantity"))
		duplicate.vars["quantity"] = source.vars["quantity"]

	// 复制液体内容：如果源物品是液体容器并且里面有液体，
	// 则将试剂一并复制到复制品中，确保复制品不是空容器。
	if(source.reagents && source.reagents.total_volume > 0)
		if(!duplicate.reagents)
			duplicate.create_reagents(source.reagents.maximum_volume)
		for(var/datum/reagent/source_reagent in source.reagents.reagent_list)
			duplicate.reagents.add_reagent(source_reagent.type, source_reagent.volume)

/datum/action/cooldown/spell/z121/invoked/mimicry/copy/proc/can_copy_item(obj/item/source)
	if(!source)
		return FALSE
	if(source.item_flags & ABSTRACT)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/z121/invoked/mimicry/copy/proc/get_item_contents(obj/item/source)
	var/datum/component/storage/source_storage = source.GetComponent(/datum/component/storage)
	if(source_storage)
		return source_storage.contents()
	return source.contents.Copy()

/datum/action/cooldown/spell/z121/invoked/mimicry/copy/proc/clear_duplicate_contents(obj/item/duplicate)
	if(!duplicate?.contents.len)
		return FALSE

	for(var/obj/item/contained as anything in duplicate.contents.Copy())
		qdel(contained)

/datum/action/cooldown/spell/z121/invoked/mimicry/copy/proc/place_copied_item(obj/item/duplicate_item, obj/item/duplicate_container)
	var/datum/component/storage/target_storage = duplicate_container.GetComponent(/datum/component/storage)
	if(!target_storage)
		duplicate_item.forceMove(duplicate_container)
		return TRUE

	if(!target_storage.can_be_inserted(duplicate_item, TRUE, null))
		return FALSE
	return !!target_storage.handle_item_insertion(duplicate_item, TRUE, null)

/datum/action/cooldown/spell/z121/invoked/mimicry/copy/proc/copy_item_contents(obj/item/source, obj/item/duplicate, list/copy_stats, list/visited = null, depth = 0)
	if(!source || !duplicate)
		return FALSE

	if(!visited)
		visited = list()

	var/source_ref = REF(source)
	if(visited[source_ref])
		copy_stats["skipped_recursive"] += 1
		return FALSE
	visited[source_ref] = TRUE

	clear_duplicate_contents(duplicate)

	var/list/source_contents = get_item_contents(source)
	if(!source_contents.len)
		return FALSE

	if(depth >= max_copy_depth)
		copy_stats["skipped_depth"] += source_contents.len
		return FALSE

	for(var/obj/item/source_child as anything in source_contents)
		if(!can_copy_item(source_child))
			copy_stats["skipped_abstract"] += 1
			continue

		var/obj/item/duplicate_child = new source_child.type(get_turf(duplicate))
		copy_item_state(source_child, duplicate_child)
		if(!place_copied_item(duplicate_child, duplicate))
			copy_stats["skipped_restricted"] += 1
			qdel(duplicate_child)
			continue

		copy_stats["copied_nested"] += 1
		copy_item_contents(source_child, duplicate_child, copy_stats, visited, depth + 1)

/datum/action/cooldown/spell/z121/invoked/mimicry/copy/z121_apply(atom/cast_on)
	var/list/targets = list(cast_on)
	var/mob/living/user = owner
	var/atom/target = targets[1]
	if(!istype(target, /obj/item))
		to_chat(user, span_warning("我只能复制触手可及的物品。"))
		z121_cancel()
		return FALSE

	var/obj/item/target_item = target
	if(target_item.item_flags & ABSTRACT)
		to_chat(user, span_warning("[target_item] 没有可供复制的稳定形态。"))
		z121_cancel()
		return FALSE

	var/obj/item/duplicate = new target_item.type(user.drop_location())
	copy_item_state(target_item, duplicate)
	var/list/copy_stats = list(
		"copied_nested" = 0,
		"skipped_abstract" = 0,
		"skipped_restricted" = 0,
		"skipped_depth" = 0,
		"skipped_recursive" = 0,
	)
	copy_item_contents(target_item, duplicate, copy_stats)

	var/list/copy_notes = list()
	if(copy_stats["copied_nested"])
		copy_notes += "已复制容器内的[copy_stats["copied_nested"]]件物品"
	if(copy_stats["skipped_abstract"])
		copy_notes += "已跳过[copy_stats["skipped_abstract"]]件抽象物品"
	if(copy_stats["skipped_restricted"])
		copy_notes += "因容器限制跳过[copy_stats["skipped_restricted"]]件物品"
	if(copy_stats["skipped_depth"])
		copy_notes += "因递归深度限制跳过[copy_stats["skipped_depth"]]件物品"
	if(copy_stats["skipped_recursive"])
		copy_notes += "已跳过[copy_stats["skipped_recursive"]]个循环分支"

	var/copy_summary = copy_notes.len ? "（[jointext(copy_notes, "；")]）" : ""
	if(!user.put_in_hands(duplicate))
		to_chat(user, span_notice("我复制了 [target_item]，但双手已满，复制品掉到了地上。[copy_summary]"))
	else
		to_chat(user, span_notice("我将 [target_item] 的复制品握在手中。[copy_summary]"))
	return TRUE
