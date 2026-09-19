// 参照寻人术的私人图像实现，不创建公共可见的地图对象，也不占用寻人术会话。
/datum/component/rpg_journal
	var/datum/rpg_quest_tracker/tracker

/datum/rpg_quest_entry
	var/tracking_hint = ""

/datum/component/rpg_journal/proc/start_tracking(datum/component/rpg_system/system, mob/living/carbon/human/user, datum/rpg_quest_entry/entry)
	if(!(entry in active) || system.parent != parent || !system.can_use_system(user))
		return FALSE
	if(tracker?.entry_ref?.resolve() == entry)
		return TRUE
	var/reason = entry.tracking_blocked_reason(user)
	if(reason)
		entry.tracking_hint = reason
		announce(reason)
		return TRUE
	if(tracker)
		var/datum/rpg_quest_entry/previous = tracker.entry_ref?.resolve()
		if(previous)
			previous.tracking_hint = "已切换至其他任务。"
		QDEL_NULL(tracker)
	tracker = new(src, entry, system, user)
	tracker.update_tracking()
	return TRUE

/datum/rpg_quest_entry/proc/tracking_blocked_reason(mob/user)
	if(QDELETED(quest) || generating || submitted || !quest.materialized)
		return "任务尚未接取或已结束。"
	if(has_failed())
		return "任务已失败，无法追踪。"
	if(!submission_blocked_reason(get_submission_items(user)))
		return "条件已满足，可在 RPG 面板提交任务。"
	if(!pick_tracking_target(user))
		return "任务目标无法定位，请检查目标或包裹是否已丢失。"
	return null

// 仅使用计入本任务目标的记录；随从、尸体及已经携带的物品不参与定位。
/datum/rpg_quest_entry/proc/valid_tracking_target(atom/movable/target, mob/user)
	if(QDELETED(quest) || QDELETED(target) || !get_turf(target) || !(WEAKREF(target) in quest.tracked_atoms))
		return FALSE
	if(is_item_task())
		if(!isitem(target) || rpg_item_is_carried(target, user))
			return FALSE
		var/datum/component/quest_object/rpg_cargo/cargo = target.GetComponent(/datum/component/quest_object/rpg_cargo)
		if(cargo?.quest_ref?.resolve() != quest)
			return FALSE
		if(quest.quest_type == QUEST_RETRIEVAL)
			return istype(target, quest.target_item_type)
		var/obj/item/parcel/rpg/parcel = target
		return istype(parcel) && parcel.is_intact()
	if(!isliving(target))
		return FALSE
	var/mob/living/living_target = target
	var/datum/component/quest_object/kill/kill_marker = target.GetComponent(/datum/component/quest_object/kill)
	return living_target.stat != DEAD && kill_marker?.quest_ref?.resolve() == quest && !kill_marker.counted

/datum/rpg_quest_entry/proc/pick_tracking_target(mob/user)
	var/turf/origin = get_turf(user)
	if(!origin || QDELETED(quest))
		return null
	var/atom/movable/best
	var/best_level = INFINITY
	var/best_distance = INFINITY
	for(var/datum/weakref/ref as anything in quest.tracked_atoms)
		var/atom/movable/target = ref.resolve()
		if(!valid_tracking_target(target, user))
			continue
		// 未显现的目标位于生成器内部，get_turf 会解析到生成器地块。
		var/turf/destination = get_turf(target)
		var/level = abs(destination.z - origin.z)
		var/distance = max(abs(destination.x - origin.x), abs(destination.y - origin.y))
		if(level < best_level || (level == best_level && distance < best_distance))
			best = target
			best_level = level
			best_distance = distance
	return best

/datum/rpg_quest_tracker
	var/datum/weakref/journal_ref
	var/datum/weakref/entry_ref
	var/datum/weakref/system_ref
	var/datum/weakref/owner_ref
	var/datum/weakref/target_ref
	var/client/viewer
	var/image/arrow
	var/last_message_time
	var/last_message_signature

/datum/rpg_quest_tracker/New(datum/component/rpg_journal/journal, datum/rpg_quest_entry/entry, datum/component/rpg_system/system, mob/living/carbon/human/user)
	journal_ref = WEAKREF(journal)
	entry_ref = WEAKREF(entry)
	system_ref = WEAKREF(system)
	owner_ref = WEAKREF(user)
	viewer = user.client
	RegisterSignal(journal, COMSIG_QDELETING, PROC_REF(on_tracking_invalidated))
	RegisterSignal(entry, COMSIG_QDELETING, PROC_REF(on_tracking_invalidated))
	RegisterSignal(system, COMSIG_QDELETING, PROC_REF(on_tracking_invalidated))
	RegisterSignal(user, list(COMSIG_QDELETING, COMSIG_MOB_LOGOUT, COMSIG_LIVING_DEATH, SIGNAL_REMOVETRAIT(TRAIT_RPG_SYSTEM)), PROC_REF(on_tracking_invalidated))
	arrow = image(loc = user, layer = ABOVE_MOB_LAYER)
	arrow.plane = BALLOON_CHAT_PLANE
	arrow.appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM
	arrow.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	arrow.maptext_width = 96
	arrow.maptext_height = 64
	arrow.maptext_x = -32
	viewer.images += arrow
	// 快速处理子系统每两分秒执行一次，与寻人术的箭头更新频率相同。
	START_PROCESSING(SSfastprocess, src)

/datum/rpg_quest_tracker/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(viewer && arrow)
		viewer.images -= arrow
	QDEL_NULL(arrow)
	viewer = null
	var/datum/component/rpg_journal/journal = journal_ref?.resolve()
	if(journal?.tracker == src)
		journal.tracker = null
	return ..()

/datum/rpg_quest_tracker/proc/on_tracking_invalidated(datum/source)
	SIGNAL_HANDLER
	var/datum/rpg_quest_entry/entry = entry_ref?.resolve()
	if(entry)
		entry.tracking_hint = "追踪已结束，可在恢复资格后重新开启。"
	qdel(src)

/datum/rpg_quest_tracker/process(delta_time)
	update_tracking()

/datum/rpg_quest_tracker/proc/finish_tracking(message)
	var/datum/rpg_quest_entry/entry = entry_ref?.resolve()
	var/mob/user = owner_ref?.resolve()
	if(entry)
		entry.tracking_hint = message
	if(user?.client == viewer && viewer)
		to_chat(user, span_notice("【RPG 追踪】[message]"))
	qdel(src)

/datum/rpg_quest_tracker/proc/update_tracking()
	var/datum/component/rpg_journal/journal = journal_ref?.resolve()
	var/datum/rpg_quest_entry/entry = entry_ref?.resolve()
	var/datum/component/rpg_system/system = system_ref?.resolve()
	var/mob/living/carbon/human/user = owner_ref?.resolve()
	if(!journal || !entry || !system || !user || !viewer || user.client != viewer || journal.parent != user || !(entry in journal.active) || !system.can_use_system(user))
		finish_tracking("追踪已中断。")
		return
	if(entry.has_failed())
		finish_tracking("任务已失败，停止追踪。")
		return
	if(!entry.submission_blocked_reason(entry.get_submission_items(user)))
		finish_tracking("条件已满足，可在 RPG 面板提交任务。")
		return
	var/turf/origin = get_turf(user)
	if(!origin)
		finish_tracking("当前位置无法定位，停止追踪。")
		return
	var/atom/movable/target = target_ref?.resolve()
	if(!entry.valid_tracking_target(target, user))
		target = entry.pick_tracking_target(user)
		if(!target)
			finish_tracking("任务目标无法定位，请检查目标或包裹是否已丢失。")
			return
		target_ref = WEAKREF(target)
	var/turf/destination = get_turf(target)
	var/dx = destination.x - origin.x
	var/dy = destination.y - origin.y
	var/dz = destination.z - origin.z
	var/distance = max(abs(dx), abs(dy))
	var/direction = 0
	if(dx > 0)
		direction |= EAST
	else if(dx < 0)
		direction |= WEST
	if(dy > 0)
		direction |= NORTH
	else if(dy < 0)
		direction |= SOUTH
	var/symbol = "◎"
	var/direction_text = "同一水平位置"
	switch(direction)
		if(NORTH)
			symbol = "↑"
			direction_text = "北方"
		if(SOUTH)
			symbol = "↓"
			direction_text = "南方"
		if(EAST)
			symbol = "→"
			direction_text = "东方"
		if(WEST)
			symbol = "←"
			direction_text = "西方"
		if(NORTHEAST)
			symbol = "↗"
			direction_text = "东北方"
		if(NORTHWEST)
			symbol = "↖"
			direction_text = "西北方"
		if(SOUTHEAST)
			symbol = "↘"
			direction_text = "东南方"
		if(SOUTHWEST)
			symbol = "↙"
			direction_text = "西南方"
	var/band
	switch(distance)
		if(0 to 7)
			band = "附近"
		if(8 to 14)
			band = "很近"
		if(15 to 40)
			band = "较近"
		if(41 to 100)
			band = "较远"
		else
			band = "遥远"
	var/level_text = dz > 0 ? "上方 [dz] 层" : (dz < 0 ? "下方 [abs(dz)] 层" : "本层")
	// 寻人术在头顶三十二像素处显示，二者并存时将 RPG 箭头上移一行。
	arrow.pixel_y = user.z121_locate_tracker?.tracking ? 80 : 32
	arrow.maptext = "<div style='text-align:center;color:#e2c58b;-dm-text-outline:1px black;font-size:22px'>[symbol]</div><div style='text-align:center;color:#e2c58b;-dm-text-outline:1px black;font-size:10px'>RPG · [level_text]</div>"
	entry.tracking_hint = "[direction_text]，水平约 [distance] 格（[band]），[level_text]。"
	// 方向和格数持续更新，但聊天仅在目标、远近档位或相对楼层变化时发送。
	var/signature = "[REF(target)]|[band]|[dz]"
	if(signature != last_message_signature && (isnull(last_message_time) || world.time >= last_message_time + 3 SECONDS))
		last_message_signature = signature
		last_message_time = world.time
		to_chat(user, span_notice("【RPG 追踪】[entry.quest.title]：[entry.tracking_hint]"))
