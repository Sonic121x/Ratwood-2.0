/obj/effect/proc_holder/spell/invoked/adminkill
	name = "管理员处决"
	desc = "以管理员之力立即杀死选中的目标。"
	school = "necromancy"
	cost = 1
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 20
	invocations = list()
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/adminkill/cast(list/targets, mob/living/user)
	if(!isliving(targets[1]))
		to_chat(user, span_warning("我只能对生物目标使用这道法术。"))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.stat == DEAD)
		to_chat(user, span_notice("[target] 已经死了。"))
		revert_cast()
		return FALSE

	target.visible_message(span_danger("[target] 被压倒性的管理员之力当场处决！"), span_userdanger("压倒性的管理员之力瞬间终结了我的生命！"))
	target.death()
	return TRUE

/obj/effect/proc_holder/spell/invoked/adminheal
	name = "管理员复原"
	desc = "立即完全治疗选中的生物目标；若目标已经死亡，则尝试将其复活并完全治疗。"
	school = "restoration"
	cost = 1
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 20
	invocations = list()
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/adminheal/cast(list/targets, mob/living/user)
	if(!isliving(targets[1]))
		to_chat(user, span_warning("我只能对生物目标施加治疗。"))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.stat == DEAD)
		if(!target.revive(full_heal = TRUE, admin_revive = TRUE))
			to_chat(user, span_warning("无法使 [target] 恢复生机。"))
			revert_cast()
			return FALSE
		target.visible_message(span_notice("[target] 在管理员之力的作用下重获新生！"), span_green("我在一瞬间重获新生！"))
		return TRUE

	target.fully_heal(admin_revive = TRUE, break_restraints = TRUE)
	target.visible_message(span_notice("[target] 身上的伤势瞬间消失了！"), span_green("我的伤势完全恢复了！"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/blink/adminblink
	name = "管理员闪现"
	desc = "传送到同一位面内选中的位置，最远可达20格；仍受障碍物和传送区域限制。"
	cost = 1
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0
	cooldown_min = 0
	spell_tier = 1
	human_req = FALSE
	gesture_required = FALSE
	no_early_release = FALSE
	charging_slowdown = 0
	invocations = list()
	invocation_type = "none"
	max_range = 20

// 仅为管理员闪现提供中文提示，保持上游闪现的判定与效果，不调用父级以免重复施法。
/obj/effect/proc_holder/spell/invoked/blink/adminblink/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
	var/turf/start = get_turf(user)

	if(!T)
		to_chat(user, span_warning("目标位置无效！"))
		revert_cast()
		return

	if(T.teleport_restricted == TRUE)
		to_chat(user, span_warning("我无法传送到这里！"))

	if(T.z != start.z)
		to_chat(user, span_warning("我只能在同一位面内传送！"))
		revert_cast()
		return

	if(istransparentturf(T))
		to_chat(user, span_warning("我不能传送到悬空的位置！"))
		revert_cast()
		return

	if(T.density)
		to_chat(user, span_warning("我不能传送进墙里！"))
		revert_cast()
		return

	// 保留距离限制。
	var/distance = get_dist(start, T)
	if(distance > max_range)
		to_chat(user, span_warning("那个位置太远了！我最多只能闪现[max_range]格。"))
		revert_cast()
		return

	user.visible_message(span_warning("<b>[user] 的身体泛起奥术微光，准备闪现！</b>"),
		span_notice("<b>我凝聚奥术之力，准备跨越空间！</b>"))

	// 检查沿途的墙壁和区域限制，目标地块不包含在这份路径中。
	var/list/turf_list = getline(start, T)
	if(length(turf_list) > 0)
		turf_list.len--

	for(var/turf/turf in turf_list)
		var/area/turf_area = get_area(turf)
		if(turf_area?.noteleport)
			to_chat(user, span_warning("这片区域不允许我传送！"))
			return
		if(turf.density)
			to_chat(user, span_warning("我不能闪现穿过墙壁！"))
			revert_cast()
			return

	// 保留沿途及目标处的门、窗、栏杆和闸门检查。
	for(var/turf/traversal_turf in turf_list)
		for(var/obj/structure/mineral_door/door in (traversal_turf.contents + T.contents))
			if(door.density)
				to_chat(user, span_warning("我不能闪现穿过门！"))
				revert_cast()
				return

		for(var/obj/structure/roguewindow/window in (traversal_turf.contents + T.contents))
			if(window.density && !window.climbable)
				to_chat(user, span_warning("我不能闪现穿过窗户！"))
				revert_cast()
				return

		for(var/obj/structure/bars/bars in (traversal_turf.contents + T.contents))
			if(bars.density)
				to_chat(user, span_warning("我不能闪现穿过栏杆！"))
				revert_cast()
				return

		for(var/obj/structure/gate/gate in (traversal_turf.contents + T.contents))
			if(gate.density)
				to_chat(user, span_warning("我不能闪现穿过闸门！"))
				revert_cast()
				return

	var/obj/spot_one = new phase(start, user.dir)
	var/obj/spot_two = new phase(T, user.dir)
	spot_one.Beam(spot_two, "purple_lightning", time = 1.5 SECONDS)
	playsound(T, 'sound/magic/blink.ogg', 25, TRUE)

	// 闪现前解除座椅或刑具的固定，避免传送后仍被远程束缚。
	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)
	do_teleport(user, T, channel = TELEPORT_CHANNEL_MAGIC)

	user.visible_message(span_danger("<b>[user] 在一阵神秘的紫色闪光中消失了！</b>"), span_notice("<b>我在一瞬间跨越了空间！</b>"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/mimicry/copy
	name = "物品复制"
	desc = "复制触手可及的物品及其液体和容器内容。容器内容最多递归复制8层，并跳过抽象物品、循环分支和无法装入容器的物品。"
	school = "illusion"
	cost = 1
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 1
	invocations = list()
	invocation_type = "none"
	action_icon_state = "mimicry"
	var/max_copy_depth = 8

/obj/effect/proc_holder/spell/invoked/mimicry/copy/proc/copy_item_state(obj/item/source, obj/item/duplicate)
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

/obj/effect/proc_holder/spell/invoked/mimicry/copy/proc/can_copy_item(obj/item/source)
	if(!source)
		return FALSE
	if(source.item_flags & ABSTRACT)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/mimicry/copy/proc/get_item_contents(obj/item/source)
	var/datum/component/storage/source_storage = source.GetComponent(/datum/component/storage)
	if(source_storage)
		return source_storage.contents()
	return source.contents.Copy()

/obj/effect/proc_holder/spell/invoked/mimicry/copy/proc/clear_duplicate_contents(obj/item/duplicate)
	if(!duplicate?.contents.len)
		return

	for(var/obj/item/contained as anything in duplicate.contents.Copy())
		qdel(contained)

/obj/effect/proc_holder/spell/invoked/mimicry/copy/proc/place_copied_item(obj/item/duplicate_item, obj/item/duplicate_container)
	var/datum/component/storage/target_storage = duplicate_container.GetComponent(/datum/component/storage)
	if(!target_storage)
		duplicate_item.forceMove(duplicate_container)
		return TRUE

	if(!target_storage.can_be_inserted(duplicate_item, TRUE, null))
		return FALSE
	return !!target_storage.handle_item_insertion(duplicate_item, TRUE, null)

/obj/effect/proc_holder/spell/invoked/mimicry/copy/proc/copy_item_contents(obj/item/source, obj/item/duplicate, list/copy_stats, list/visited = null, depth = 0)
	if(!source || !duplicate)
		return

	if(!visited)
		visited = list()

	var/source_ref = REF(source)
	if(visited[source_ref])
		copy_stats["skipped_recursive"] += 1
		return
	visited[source_ref] = TRUE

	clear_duplicate_contents(duplicate)

	var/list/source_contents = get_item_contents(source)
	if(!source_contents.len)
		return

	if(depth >= max_copy_depth)
		copy_stats["skipped_depth"] += source_contents.len
		return

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

/obj/effect/proc_holder/spell/invoked/mimicry/copy/cast(list/targets, mob/living/user)
	var/atom/target = targets[1]
	if(!istype(target, /obj/item))
		to_chat(user, span_warning("我只能复制触手可及的物品。"))
		revert_cast()
		return FALSE

	var/obj/item/target_item = target
	if(target_item.item_flags & ABSTRACT)
		to_chat(user, span_warning("[target_item] 没有可供复制的稳定形态。"))
		revert_cast()
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
