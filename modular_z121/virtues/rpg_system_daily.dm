// 记录组件独立于商店组件存在：同一具角色躯体重连、复生或重新绑定系统都不会刷新名额。
/datum/component/rpg_system/proc/get_journal()
	var/datum/component/rpg_journal/journal = parent.GetComponent(/datum/component/rpg_journal)
	if(!journal)
		journal = parent.AddComponent(/datum/component/rpg_journal)
	return journal

// 使用未取模的游戏时间，以当前地图的黎明为界，避免星期七天循环和离线漏信号。
/proc/rpg_day_number()
	var/game_time = (world.time - SSticker.round_start_time) * SSticker.station_time_rate_multiplier + SSticker.gametime_offset
	return FLOOR((game_time - SSnightshift.nightshift_dawn_start - 1) / 864000, 1)

/datum/component/rpg_journal
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/offer_day
	var/last_check_day
	var/check_result = ""
	var/notice = ""
	var/next_id = 0
	var/busy = FALSE
	var/list/offers = list()
	var/list/active = list()

/datum/component/rpg_journal/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	START_PROCESSING(SSprocessing, src)

/datum/component/rpg_journal/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(tracker)
	for(var/datum/rpg_quest_entry/entry as anything in (offers + active))
		// 生成过程可能休眠；由返回后的接取流程负责回收，不能中途删除正在执行的任务。
		if(!entry.generating)
			qdel(entry)
	offers.Cut()
	active.Cut()
	return ..()

/datum/component/rpg_journal/process(delta_time)
	if(busy)
		return
	for(var/datum/rpg_quest_entry/entry as anything in active.Copy())
		if(entry.has_failed())
			announce("任务「[entry.quest.title]」已失败，不再占用任务名额。")
			active -= entry
			qdel(entry)
		else
			entry.check_proximity(parent)

/datum/component/rpg_journal/proc/announce(message)
	notice = message
	to_chat(parent, span_notice("【系统任务】[message]"))

// 此选择器绝不回退到已占用或冷却中的地标；预览只检查地图支持，不锁定地点。
/proc/rpg_quest_landmarks(quest_type, region = null, only_available = FALSE)
	var/list/result = list()
	var/list/candidates = SSquestpool.landmarks_by_type[quest_type]
	for(var/obj/effect/landmark/quest_spawner/landmark as anything in candidates)
		if(QDELETED(landmark) || !get_turf(landmark))
			continue
		if(!isnull(region) && landmark.region != region)
			continue
		if(!landmark_region_allows_type(landmark, quest_type))
			continue
		if(only_available && !landmark.is_available_for_quest())
			continue
		result += landmark
	return result

/datum/component/rpg_journal/proc/refresh_day()
	if(busy)
		return
	var/today = rpg_day_number()
	if(!isnull(offer_day) && today <= offer_day)
		return
	offer_day = today
	check_result = ""
	QDEL_LIST(offers)
	offers = list()
	var/list/types = list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RECOVERY, QUEST_RAID, QUEST_BOUNTY, QUEST_NOTORIOUS_BOUNTY)
	var/list/supported = list()
	// 每种类型最多尝试一次完整地标表；避免无效模板导致反复开窗重抽。
	while(length(types) && length(offers) < 6)
		var/quest_type = pick_n_take(types)
		var/datum/rpg_quest_entry/entry = make_offer(quest_type)
		if(!entry)
			continue
		supported += quest_type
		offers += entry
	while(length(supported) && length(offers) < 6)
		var/quest_type = pick(supported)
		var/datum/rpg_quest_entry/entry = make_offer(quest_type)
		if(entry)
			offers += entry
		else
			supported -= quest_type

/datum/component/rpg_journal/proc/make_offer(quest_type)
	var/list/landmarks = rpg_quest_landmarks(quest_type)
	while(length(landmarks))
		var/obj/effect/landmark/quest_spawner/landmark = pick_n_take(landmarks)
		var/datum/quest/quest
		switch(quest_type)
			if(QUEST_RETRIEVAL)
				quest = new /datum/quest/retrieval/rpg()
			if(QUEST_COURIER)
				quest = new /datum/quest/courier/rpg()
			if(QUEST_RECOVERY)
				quest = new /datum/quest/kill/recovery/rpg()
			if(QUEST_NOTORIOUS_BOUNTY)
				quest = new /datum/quest/kill/notorious_bounty/rpg()
			else
				quest = SSquestpool.instantiate_quest_of_type(quest_type)
		if(!quest)
			return
		quest.quest_difficulty = difficulty_for_type(quest_type)
		quest.source = "rpg"
		quest.created_at = world.time
		quest.issued_day = GLOB.dayspassed
		if(!quest.preview(landmark))
			qdel(quest)
			continue
		quest.reward_amount = 0
		quest.deposit_amount = 0
		// RPG 独立委托均可单人接取，仅修改本次任务实例的组队要求。
		quest.required_fellowship_size = 0
		var/datum/rpg_quest_entry/entry = new(quest, ++next_id)
		return entry

/datum/component/rpg_journal/proc/get_ui_data(mob/living/carbon/human/user)
	var/list/candidates = list()
	var/list/tasks = list()
	for(var/datum/rpg_quest_entry/entry as anything in offers)
		var/list/row = entry.get_ui_data(user)
		if(length(active) >= 3)
			row["blocked_reason"] = "同时最多持有三个任务"
		else if(!entry.quest.can_claim(user))
			row["blocked_reason"] = entry.quest.claim_failure_reason(user)
		else if(!length(rpg_quest_landmarks(entry.quest.quest_type, entry.quest.region, TRUE)))
			row["blocked_reason"] = "目标地区暂无空闲任务点"
		candidates += list(row)
	for(var/datum/rpg_quest_entry/entry as anything in active)
		var/list/row = entry.get_ui_data(user)
		row["tracking"] = tracker?.entry_ref?.resolve() == entry
		tasks += list(row)
	return list(
		"day" = offer_day,
		"checked_in" = !isnull(last_check_day) && last_check_day >= offer_day,
		"check_result" = check_result,
		"notice" = notice,
		"offers" = candidates,
		"active" = tasks,
	)

/datum/component/rpg_journal/proc/handle_action(datum/component/rpg_system/system, mob/living/carbon/human/user, action, list/params)
	if(busy || QDELETED(system) || system.parent != parent || !system.can_use_system(user))
		return FALSE
	refresh_day()
	if(action == "check_in")
		if(params["day"] != offer_day || (!isnull(last_check_day) && last_check_day >= offer_day))
			return TRUE
		// 先消费签到资格，再抽取奖励；所有结果仅在服务端产生。
		last_check_day = offer_day
		var/gain = rand(100, 1000)
		var/doubled = FALSE
		var/datum/patron/patron = user.patron
		var/datum/storyteller/storyteller = SSgamemode.current_storyteller
		if(patron && storyteller && patron.storyteller == storyteller.type && prob(10))
			gain *= 2
			doubled = TRUE
		system.points += gain
		check_result = "签到获得 [gain] 积分[doubled ? "（信仰共鸣，双倍奖励）" : ""]。"
		to_chat(user, span_green("【系统签到】[check_result]"))
		return TRUE
	if(system.current_tab != "quests" || params["tab"] != "quests")
		return FALSE
	var/id = params["id"]
	if(!isnum(id) || id < 1 || id != round(id))
		return FALSE
	var/list/entries = action == "quest_accept" ? offers : active
	var/datum/rpg_quest_entry/chosen
	for(var/datum/rpg_quest_entry/entry as anything in entries)
		if(entry.id == id)
			chosen = entry
			break
	if(!chosen)
		return FALSE
	if(action == "quest_track")
		return start_tracking(system, user, chosen)
	if(action == "quest_untrack")
		if(tracker?.entry_ref?.resolve() == chosen)
			QDEL_NULL(tracker)
			chosen.tracking_hint = "已停止追踪。"
		return TRUE
	if(action == "quest_accept")
		if(params["day"] != offer_day || length(active) >= 3)
			return TRUE
		return accept_offer(system, user, chosen)
	if(action == "quest_submit")
		busy = TRUE
		var/list/submission_items = chosen.get_submission_items(user)
		var/reason = chosen.submission_blocked_reason(submission_items)
		if(reason)
			announce(reason)
			busy = FALSE
			return TRUE
		// 校验后全程不休眠；先锁定任务，再收货发奖，物品删除信号不能重复提交。
		chosen.submitted = TRUE
		active -= chosen
		if(!chosen.quest.complete)
			chosen.quest.progress_current = chosen.quest.progress_required
			chosen.quest.mark_complete()
		for(var/obj/item/item as anything in submission_items)
			qdel(item)
		system.points += chosen.reward
		announce("已提交「[chosen.quest.title]」，获得 [chosen.reward] 积分。")
		qdel(chosen)
		busy = FALSE
		return TRUE
	if(action == "quest_abandon")
		active -= chosen
		announce("已放弃「[chosen.quest.title]」，不返还今日候选名额。")
		qdel(chosen)
		return TRUE
	return FALSE

/datum/component/rpg_journal/proc/accept_offer(datum/component/rpg_system/system, mob/living/carbon/human/user, datum/rpg_quest_entry/entry)
	var/datum/quest/quest = entry.quest
	if(!quest.can_claim(user))
		announce(quest.claim_failure_reason(user))
		return TRUE
	var/list/landmarks = rpg_quest_landmarks(quest.quest_type, quest.region, TRUE)
	if(!length(landmarks))
		announce("目标地区暂无空闲任务点，请稍后重试。")
		return TRUE
	var/obj/effect/landmark/quest_spawner/landmark = pick(landmarks)
	busy = TRUE
	entry.generating = TRUE
	landmark.claimed_by = WEAKREF(quest)
	quest.pending_landmark_ref = WEAKREF(landmark)
	quest.target_spawn_area = get_area_name(get_turf(landmark))
	var/preview_count = quest.progress_required
	var/success = quest.materialize(landmark)
	entry.capture_spawned_atoms()
	entry.generating = FALSE
	// 生成可能让出执行权，返回后必须重新验证角色、系统及当日候选资格。
	if(QDELETED(src))
		qdel(entry)
		return FALSE
	if(!success || !entry.has_valid_objectives() || QDELETED(landmark) || landmark.claimed_by?.resolve() != quest || QDELETED(system) || !system.can_use_system(user) || !quest.can_claim(user) || rpg_day_number() != offer_day)
		entry.clear_spawned_atoms(FALSE)
		quest.progress_required = preview_count
		quest.progress_current = 0
		quest.complete = FALSE
		quest.materialized = FALSE
		if(istype(quest, /datum/quest/kill))
			var/datum/quest/kill/kill_quest = quest
			kill_quest.failed = FALSE
		if(!QDELETED(landmark) && landmark.claimed_by?.resolve() == quest)
			landmark.claimed_by = null
		busy = FALSE
		announce("任务生成未完成或接取资格已变化，候选未消耗，请重试。")
		return TRUE
	quest.materialized = TRUE
	quest.on_claim(user)
	offers -= entry
	active += entry
	busy = FALSE
	announce("已接受「[quest.title]」。达到目标后可在 RPG 面板随处提交，获得 [entry.reward] 积分。")
	return TRUE

// 包装独立任务实例，不调用公共任务池的接取或金钱结算，也不生成可兑现的纸质契约。
/datum/rpg_quest_entry
	var/id
	var/datum/quest/quest
	var/reward
	var/generating = FALSE
	var/submitted = FALSE
	var/list/owned_atoms = list()
	var/list/owned_spawners = list()

/datum/rpg_quest_entry/New(datum/quest/new_quest, new_id)
	quest = new_quest
	id = new_id
	switch(quest.quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			reward = 250
		if(QUEST_DIFFICULTY_MEDIUM)
			reward = 750
		if(QUEST_DIFFICULTY_HARD)
			reward = 1500
		if(QUEST_DIFFICULTY_NOTORIOUS)
			reward = 2500

/datum/rpg_quest_entry/Destroy()
	if(!QDELETED(quest))
		clear_spawned_atoms(quest.complete && !has_failed())
		// 地标可能被原框架重新分配；不得给别人的任务点添加冷却。
		var/obj/effect/landmark/quest_spawner/landmark = quest.pending_landmark_ref?.resolve()
		if(landmark?.claimed_by?.resolve() != quest)
			quest.pending_landmark_ref = null
		QDEL_NULL(quest)
	return ..()

/datum/rpg_quest_entry/proc/has_failed()
	if(QDELETED(quest))
		return TRUE
	if(istype(quest, /datum/quest/kill))
		var/datum/quest/kill/kill_quest = quest
		return kill_quest.failed
	return FALSE

/datum/rpg_quest_entry/proc/capture_spawned_atoms()
	owned_atoms |= quest.tracked_atoms
	// 普通赏金的随从不在任务进度表中，需在显现前记录生成器中的归属。
	for(var/datum/weakref/ref as anything in quest.spawners)
		var/obj/effect/quest_spawn/spawner = ref.resolve()
		if(spawner?.contained_atom)
			owned_atoms |= WEAKREF(spawner.contained_atom)
	if(istype(quest, /datum/quest/kill/notorious_bounty))
		var/datum/quest/kill/notorious_bounty/notorious = quest
		owned_atoms |= notorious.goon_refs
	for(var/datum/weakref/ref as anything in owned_atoms)
		var/atom/movable/target = ref.resolve()
		var/obj/effect/quest_spawn/spawner = target?.loc
		if(istype(spawner))
			var/datum/component/quest_object/component = spawner.GetComponent(/datum/component/quest_object)
			if(component?.quest_ref?.resolve() == quest)
				// 恶名随从也须随整场遭遇一起显现。
				quest.spawners |= WEAKREF(spawner)
		var/obj/item/parcel/parcel = ref.resolve()
		if(istype(parcel))
			// 包裹原来的显现检查依赖纸质契约，由角色接近检查代替。
			QDEL_NULL(parcel.proximity_monitor)
			for(var/obj/item/item as anything in parcel.contained_items)
				owned_atoms |= WEAKREF(item)
	owned_spawners |= quest.spawners

/datum/rpg_quest_entry/proc/has_valid_objectives()
	var/mobs = 0
	var/items = 0
	var/parcels = 0
	for(var/datum/weakref/ref as anything in quest.tracked_atoms)
		var/atom/target = ref.resolve()
		if(QDELETED(target))
			continue
		if(isliving(target))
			mobs++
		else if(istype(target, /obj/item/parcel))
			parcels++
		else if(isitem(target))
			items++
	switch(quest.quest_type)
		if(QUEST_RETRIEVAL)
			return items >= quest.progress_required
		if(QUEST_COURIER)
			return parcels > 0
		if(QUEST_RECOVERY)
			return parcels > 0 && mobs > 0
	return mobs >= quest.progress_required && mobs > 0

/datum/rpg_quest_entry/proc/check_proximity(mob/living/carbon/human/user)
	if(QDELETED(quest) || generating || quest.complete || has_failed())
		return
	capture_spawned_atoms()
	if(QDELETED(user) || !user.client || user.stat == DEAD || !HAS_TRAIT(user, TRAIT_RPG_SYSTEM))
		return
	var/turf/origin = get_turf(user)
	if(!origin)
		return
	for(var/datum/weakref/ref as anything in quest.spawners)
		var/obj/effect/quest_spawn/spawner = ref.resolve()
		var/turf/target = get_turf(spawner)
		if(target && target.z == origin.z && get_dist(origin, target) <= spawner.prox_range)
			quest.pop_all_spawners()
			break
	for(var/datum/weakref/ref as anything in quest.tracked_atoms)
		var/obj/item/parcel/parcel = ref.resolve()
		if(!istype(parcel))
			continue
		var/turf/target = get_turf(parcel)
		if(target && target.z == origin.z && get_dist(origin, target) <= 5)
			parcel.invisibility = initial(parcel.invisibility)

/datum/rpg_quest_entry/proc/clear_spawned_atoms(keep_delivered_items)
	capture_spawned_atoms()
	quest.complete = TRUE
	if(istype(quest, /datum/quest/kill))
		var/datum/quest/kill/kill_quest = quest
		kill_quest.failed = TRUE
		kill_quest.clear_hunt_timers()
	if(istype(quest, /datum/quest/kill/notorious_bounty))
		var/datum/quest/kill/notorious_bounty/notorious = quest
		notorious.clear_hunter_marks()
		notorious.clear_boss_marker()
	// 先解除进度监听再删除目标，避免清理本身被计算为击杀或交付。
	for(var/datum/weakref/ref as anything in owned_atoms)
		var/atom/movable/target = ref.resolve()
		if(QDELETED(target))
			continue
		var/datum/component/quest_object/component = target.GetComponent(/datum/component/quest_object)
		if(component?.quest_ref?.resolve() == quest)
			target.remove_filter(component.outline_filter_id)
			component.quest_ref = null
			qdel(component)
		if(isliving(target))
			var/mob/living/mob_target = target
			if(mob_target.client)
				to_chat(mob_target, span_notice("RPG 委托已结束，你回到了观战状态。"))
				mob_target.ghostize(FALSE)
			if(mob_target.stat != DEAD)
				qdel(mob_target)
		else if(!keep_delivered_items)
			qdel(target)
	for(var/datum/weakref/ref as anything in owned_spawners)
		var/obj/effect/quest_spawn/spawner = ref.resolve()
		if(!QDELETED(spawner))
			qdel(spawner)
	quest.spawners.Cut()
	quest.tracked_atoms.Cut()
	owned_atoms.Cut()
	owned_spawners.Cut()

/datum/rpg_quest_entry/proc/is_item_task()
	return quest.quest_type in list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_RECOVERY)

// 沿真实容纳关系向上检查，只经过随身物品，不能穿过其他角色或地面容器。
/proc/rpg_item_is_carried(obj/item/item, mob/user)
	var/atom/container = item
	var/list/visited = list()
	while(container != user)
		if(QDELETED(container) || !isitem(container) || (container in visited))
			return FALSE
		visited += container
		container = container.loc
	return !QDELETED(user)

/datum/rpg_quest_entry/proc/get_submission_items(mob/user)
	var/list/items = list()
	if(QDELETED(quest) || !is_item_task())
		return items
	for(var/datum/weakref/ref as anything in quest.tracked_atoms)
		var/obj/item/item = ref.resolve()
		if(!istype(item) || QDELETED(item) || !rpg_item_is_carried(item, user))
			continue
		var/datum/component/quest_object/rpg_cargo/marker = item.GetComponent(/datum/component/quest_object/rpg_cargo)
		if(marker?.quest_ref?.resolve() != quest)
			continue
		if(quest.quest_type == QUEST_RETRIEVAL)
			if(istype(item, quest.target_item_type))
				items |= item
		else
			var/obj/item/parcel/rpg/parcel = item
			if(istype(parcel) && parcel.is_intact())
				items |= parcel
	return items

// 界面和实际提交共用同一判定；客户端不能指定物品、数量、奖励或完成状态。
/datum/rpg_quest_entry/proc/submission_blocked_reason(list/items)
	if(submitted || generating || QDELETED(quest) || !quest.materialized)
		return "任务尚未就绪或已提交"
	if(has_failed())
		return "任务已失败，无法提交"
	if(is_item_task())
		if(length(items) < quest.progress_required)
			return quest.quest_type == QUEST_RETRIEVAL ? "需随身携带全部任务专属物品（[length(items)]/[quest.progress_required]）" : "需随身携带本任务的完整密封包裹"
	else if(!quest.complete)
		return "尚未完成击杀目标"
	return null

/datum/rpg_quest_entry/proc/get_ui_data(mob/user)
	var/list/difficulty_names = list(QUEST_DIFFICULTY_EASY = "简单", QUEST_DIFFICULTY_MEDIUM = "中等", QUEST_DIFFICULTY_HARD = "困难", QUEST_DIFFICULTY_NOTORIOUS = "恶名")
	var/objective = quest.get_objective_text()
	if(!is_item_task())
		objective += " 达到击杀目标后，可在 RPG 面板随处提交并领取积分。"
	var/list/items = get_submission_items(user)
	var/blocked_reason = submission_blocked_reason(items)
	var/list/data = list(
		"id" = id,
		"name" = quest.title,
		"description" = html_decode(GLOB.html_tags.Replace(objective, "")),
		"difficulty" = difficulty_names[quest.quest_difficulty],
		"reward" = reward,
		"location" = quest.target_spawn_area,
		"current" = quest.progress_current,
		"required" = quest.progress_required,
		"complete" = quest.complete && !has_failed(),
		"failed" = has_failed(),
		"party_size" = quest.required_fellowship_size,
		"item_task" = is_item_task(),
		"carried" = length(items),
		"can_submit" = isnull(blocked_reason),
		"submit_blocked_reason" = blocked_reason,
		"track_blocked_reason" = tracking_blocked_reason(user),
		"tracking_hint" = tracking_hint,
	)
	quest.populate_scroll_ui_data(data)
	return data

// 仅复用基础标记的高亮和生命周期；不挂接寻物、配送的旧交付组件。
// 两个覆盖方法继承父类的信号处理约束，不重复声明禁止休眠标记。
/datum/component/quest_object/rpg_cargo/on_item_dropped(obj/item/dropped_item, mob/user)
	return

/datum/component/quest_object/rpg_cargo/on_examine(datum/source, mob/user, list/examine_list)
	var/datum/quest/quest = quest_ref?.resolve()
	if(!QDELETED(quest))
		examine_list += span_notice("RPG 任务「[quest.title]」的专属物品。接取者随身携带后，可在 RPG 面板提交任务。")

/datum/quest/retrieval/rpg/get_objective_text()
	return "找齐 [progress_required] 件本任务专属的[initial(target_item_type.name)]，随身携带后在 RPG 面板一次提交。提交会消耗这些物品，无需前往交货标记。"

/datum/quest/retrieval/rpg/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	for(var/i in 1 to progress_required)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			return FALSE
		var/obj/item/item = new target_item_type(spawn_turf)
		item.AddComponent(/datum/component/quest_object/rpg_cargo, src)
		add_tracked_atom(item)
	return TRUE

/datum/quest/courier/rpg/get_title()
	return "取回系统委托包裹"

/datum/quest/courier/rpg/get_objective_text()
	return "找到装有[initial(target_delivery_item.name)]的任务包裹，完整携带后在 RPG 面板随处提交。提交会消耗包裹及内容物，无需送往指定区域。"

/datum/quest/courier/rpg/spawn_courier_item(area/delivery_area, obj/effect/landmark/quest_spawner/landmark)
	return rpg_create_quest_parcel(src, landmark, target_delivery_item, 1, "系统委托包裹")

/datum/quest/kill/recovery/rpg/get_objective_text()
	return "取回装有[shipment_name]的完整任务包裹，随身携带后在 RPG 面板随处提交。无需杀光守卫；提交消耗包裹及内容物，并清理本任务剩余的存活守卫。"

/datum/quest/kill/recovery/rpg/spawn_recovery_parcel(obj/effect/landmark/quest_spawner/landmark)
	return rpg_create_quest_parcel(src, landmark, target_delivery_item, shipment_count, "系统回收包裹：[shipment_name]")

/datum/quest/kill/recovery/rpg/on_guardian_killed()
	if(!hunt_timer_id || any_guardians_alive())
		return
	clear_hunt_timers()
	announce_to_bearer("守卫已被斩杀。携带完整任务包裹后，即可在 RPG 面板随处提交。")

// 目的地仅用于沿用原货物抽取表，实际包裹不设置收件地点或职业权限。
/proc/rpg_create_quest_parcel(datum/quest/quest, obj/effect/landmark/quest_spawner/landmark, item_type, amount, parcel_name)
	var/turf/spawn_turf = landmark?.get_safe_spawn_turf()
	if(!spawn_turf || amount < 1)
		return null
	var/obj/item/parcel/rpg/parcel = new(spawn_turf)
	parcel.name = parcel_name
	for(var/i in 1 to amount)
		var/obj/item/item = new item_type(parcel)
		parcel.contained_items += item
		parcel.sealed_contents += WEAKREF(item)
	parcel.AddComponent(/datum/component/quest_object/rpg_cargo, quest)
	quest.add_tracked_atom(parcel)
	return parcel

// 密封货物无法拆装；提交核对原始内容物实例，杜绝取走货物后用同类替换。
/obj/item/parcel/rpg
	name = "系统任务包裹"
	desc = "由 RPG 系统封存的完整任务货物。接取者须随身携带，在 RPG 面板提交；提交后包裹及内容物将被收取。"
	icon_state = "ration_large"
	dropshrink = 1
	var/list/sealed_contents = list()

/obj/item/parcel/rpg/Initialize(mapload)
	. = ..()
	QDEL_NULL(proximity_monitor)

/obj/item/parcel/rpg/attack_self(mob/user)
	to_chat(user, span_notice("这是不可拆封的系统任务包裹，请在 RPG 面板提交任务。"))
	return TRUE

/obj/item/parcel/rpg/attackby(obj/item/item, mob/user)
	to_chat(user, span_warning("系统任务包裹不能拆装或添加物品。"))
	return TRUE

/obj/item/parcel/rpg/proc/is_intact()
	if(!length(sealed_contents) || length(contents) != length(sealed_contents) || length(contained_items) != length(sealed_contents))
		return FALSE
	for(var/datum/weakref/ref as anything in sealed_contents)
		var/obj/item/item = ref.resolve()
		if(QDELETED(item) || item.loc != src || !(item in contained_items))
			return FALSE
	return TRUE

// 已逃脱的回收任务不能靠事后移动包裹重新完成。
/datum/quest/kill/recovery/rpg/mark_complete()
	if(failed || complete)
		return
	return ..()

// 恶名任务保留原本的战斗、观战接管和时限，只将金钱加赏提示改为固定积分说明。
/datum/quest/kill/notorious_bounty/rpg/announce_to_bearer(message)
	if(findtext(message, "赏金增加"))
		message = "敌人已作出应对。此 RPG 委托的奖励仍为固定 2500 积分。"
	return ..(message)
