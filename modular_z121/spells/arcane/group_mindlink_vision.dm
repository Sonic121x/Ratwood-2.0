// 加入主链接即允许成员互相旁观；上下文只记录一次正在进行的旁观及其所属链接。
/mob/living
	var/datum/group_mindlink_view/group_mindlink_view

/datum/group_mindlink_custom/proc/clear_member_vision(mob/living/member)
	for(var/datum/group_mindlink_vision_context/context as anything in vision_contexts.Copy())
		if(context.viewer == member || context.target == member)
			qdel(context)

/datum/group_mindlink_session/proc/vision_logout()
	SIGNAL_HANDLER
	if(selection_spell?.cast_request)
		selection_spell.cast_request.cancel()
	// 断线保留聊天成员资格，当前旁观必须停止；重连后可从现有链接重新开始。
	for(var/datum/group_mindlink_custom/link as anything in links.Copy())
		link.clear_member_vision(holder)

/datum/group_mindlink_session/proc/vision_data()
	var/list/result = list("current" = null, "watchers" = list())
	var/datum/group_mindlink_view/view = holder.group_mindlink_view
	if(!QDELETED(view) && view.context.valid(TRUE))
		result["current"] = list("link" = REF(view.context.link), "person" = REF(view.target), "name" = view.context.link.member_name(view.target))
	for(var/datum/group_mindlink_custom/link as anything in links)
		for(var/datum/group_mindlink_vision_context/context as anything in link.vision_contexts)
			if(context.target != holder || !context.valid(TRUE))
				continue
			var/list/watchers = result["watchers"]
			watchers += list(list("id" = REF(context), "link" = REF(link), "link_name" = "[link.member_name(link.owner)]的链接", "name" = link.member_name(context.viewer)))
	return result

/datum/group_mindlink_session/proc/vision_action(action, list/params)
	if(action == "vision_stop")
		if(holder.group_mindlink_view)
			qdel(holder.group_mindlink_view)
		return TRUE
	// 旧的邀请、接受及撤销操作不再提供任何权限。
	if(action != "vision_start" || selection_spell?.casting)
		return FALSE
	for(var/datum/group_mindlink_custom/link as anything in links)
		if(REF(link) != params["link"] || !link.active || world.time >= link.expires_at || !(holder in link.participants))
			continue
		for(var/mob/living/target as anything in link.participants)
			if(REF(target) != params["person"] || target == holder)
				continue
			if(holder.group_mindlink_view?.context?.link == link && holder.group_mindlink_view.target == target)
				return TRUE
			var/datum/group_mindlink_vision_context/context = new(link, holder, target)
			if(!context.start_view())
				qdel(context)
			return TRUE
	notice("当前链接或目标成员已失效。")
	return TRUE

/datum/group_mindlink_vision_context
	var/datum/group_mindlink_custom/link
	var/mob/living/viewer
	var/mob/living/target
	var/client/viewer_client
	var/client/target_client
	var/datum/mind/viewer_mind
	var/datum/mind/target_mind

/datum/group_mindlink_vision_context/New(datum/group_mindlink_custom/parent_link, mob/living/requester, mob/living/subject)
	. = ..()
	link = parent_link
	viewer = requester
	target = subject
	viewer_client = viewer.client
	target_client = target.client
	viewer_mind = viewer.mind
	target_mind = target.mind
	link.vision_contexts += src

/datum/group_mindlink_vision_context/Destroy()
	if(!QDELETED(viewer?.group_mindlink_view) && viewer.group_mindlink_view.context == src)
		qdel(viewer.group_mindlink_view)
	link?.vision_contexts.Remove(src)
	refresh_pair()
	link = null
	viewer = null
	target = null
	viewer_client = null
	target_client = null
	viewer_mind = null
	target_mind = null
	return ..()

/datum/group_mindlink_vision_context/proc/valid(require_awake = FALSE)
	if(QDELETED(src) || QDELETED(link) || !link.active || world.time >= link.expires_at)
		return FALSE
	if(QDELETED(viewer) || QDELETED(target) || viewer == target || viewer.stat == DEAD || target.stat == DEAD)
		return FALSE
	if(!(viewer in link.participants) || !(target in link.participants))
		return FALSE
	if(!viewer.client || !target.client || viewer.client != viewer_client || target.client != target_client)
		return FALSE
	if(viewer.mind != viewer_mind || target.mind != target_mind || viewer_mind?.current != viewer || target_mind?.current != target)
		return FALSE
	if(require_awake && (viewer.stat != CONSCIOUS || target.stat != CONSCIOUS || viewer.IsUnconscious() || target.IsUnconscious()))
		return FALSE
	return TRUE

/datum/group_mindlink_vision_context/proc/refresh_pair()
	var/datum/group_mindlink_session/viewer_session = group_mindlink_session(viewer, FALSE)
	var/datum/group_mindlink_session/target_session = group_mindlink_session(target, FALSE)
	viewer_session?.refresh()
	target_session?.refresh()

/datum/group_mindlink_vision_context/proc/start_view()
	var/datum/group_mindlink_session/session = group_mindlink_session(viewer, FALSE)
	if(!valid(TRUE))
		session?.notice("双方需要仍在同一主链接内，且在线、清醒。")
		return FALSE
	if(target.group_mindlink_view || target.client.eye != target || viewer.group_mindlink_has_watchers())
		session?.notice("不能转播他人的视角，也不能在自己被观看时借用其他视角。")
		return FALSE
	if((!viewer.group_mindlink_view && viewer.client.eye != viewer) || viewer.remote_control || viewer.control_object || session?.selection_spell?.casting)
		session?.notice("请先结束其他远程视角、控制或正在进行的施法。")
		return FALSE
	if(viewer.group_mindlink_view)
		qdel(viewer.group_mindlink_view)
	new /datum/group_mindlink_view(src)
	return TRUE

/mob/living/proc/group_mindlink_has_watchers(include_sensory = TRUE)
	if(include_sensory && sensory_share_link_custom?.active)
		var/mob/living/partner = sensory_share_link_custom.get_partner(src)
		if(partner?.client?.eye == src)
			return TRUE
	var/datum/group_mindlink_session/session = group_mindlink_session(src, FALSE)
	if(!session)
		return FALSE
	for(var/datum/group_mindlink_custom/link as anything in session.links)
		for(var/datum/group_mindlink_vision_context/context as anything in link.vision_contexts)
			if(context.target == src && context.viewer?.group_mindlink_view?.context == context)
				return TRUE
	return FALSE

// 只在镜头和成员资格都仍属于本功能时接管视觉；其他系统改镜头后立即交还控制。
/mob/living/proc/group_mindlink_borrowed_eye()
	var/datum/group_mindlink_view/view = group_mindlink_view
	if(QDELETED(view) || !client || client.eye != view.target || !view.context?.valid(TRUE) || view.target.client.eye != view.target)
		return null
	return view.target

/datum/group_mindlink_view
	var/datum/group_mindlink_vision_context/context
	var/mob/living/viewer
	var/mob/living/target
	var/client/view_client
	var/previous_move_delay
	var/held_move_delay
	var/last_visual_state
	var/list/blocked_actions = list()

/datum/group_mindlink_view/New(datum/group_mindlink_vision_context/watch_context)
	. = ..()
	context = watch_context
	viewer = context.viewer
	target = context.target
	view_client = viewer.client
	viewer.stop_attack()
	viewer.group_mindlink_view = src
	viewer.verbs |= /mob/living/proc/group_mindlink_return_view
	// 暂停客户端主动移动，不修改定身状态，外力拖拽和强制位移仍正常发生。
	previous_move_delay = view_client.move_delay
	held_move_delay = max(previous_move_delay, context.link.expires_at + 1 SECONDS)
	view_client.move_delay = held_move_delay
	RegisterSignal(viewer, COMSIG_MOVABLE_MOVED, PROC_REF(viewer_moved))
	RegisterSignal(viewer, COMSIG_MOB_STATCHANGE, PROC_REF(state_changed))
	RegisterSignal(target, COMSIG_MOB_STATCHANGE, PROC_REF(state_changed))
	viewer.update_mobility()
	viewer.reset_perspective(target)
	sync_vision()
	start_senses()
	block_actions()
	START_PROCESSING(SSfastprocess, src)
	to_chat(viewer, span_notice("\[心灵视角\] 正在旁观[html_encode(context.link.member_name(target))]，可检视可见物品并聆听对方周围的声音，身体暂时不能主动行动。关闭窗口会继续旁观；请使用 IC →『返回自身视角』退出，也可重开 Group Mindlink 点击返回按钮。"))
	to_chat(target, span_notice("\[心灵视角\] [html_encode(context.link.member_name(viewer))]开始观看你的视角。"))
	context.refresh_pair()

/datum/group_mindlink_view/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	stop_senses()
	if(view_client && view_client.move_delay == held_move_delay)
		view_client.move_delay = previous_move_delay
	for(var/datum/action/action as anything in blocked_actions)
		if(!QDELETED(action))
			UnregisterSignal(action, COMSIG_ACTION_TRIGGER)
	blocked_actions.Cut()
	if(viewer)
		UnregisterSignal(viewer, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_STATCHANGE))
		if(viewer.group_mindlink_view == src)
			viewer.group_mindlink_view = null
		if(!QDELETED(viewer))
			viewer.verbs -= /mob/living/proc/group_mindlink_return_view
			// 只复位仍由本对象占用的镜头，避免抢回其他系统已经接管的视角。
			if(viewer.client?.eye == target)
				viewer.reset_perspective(null)
			viewer.update_mobility()
			viewer.update_sight()
			viewer.update_cone_show()
			viewer.update_vision_cone()
			viewer.update_blindness()
			to_chat(viewer, span_notice("\[心灵视角\] 已停止借用视角，身体恢复自主行动。"))
	if(target)
		UnregisterSignal(target, COMSIG_MOB_STATCHANGE)
		if(!QDELETED(target) && !QDELETED(viewer))
			to_chat(target, span_notice("\[心灵视角\] [html_encode(context.link.member_name(viewer))]已停止观看你的视角。"))
	context?.refresh_pair()
	if(!QDELETED(context))
		qdel(context)
	context = null
	viewer = null
	target = null
	view_client = null
	return ..()

/datum/group_mindlink_view/proc/viewer_moved()
	SIGNAL_HANDLER
	qdel(src)

/datum/group_mindlink_view/proc/state_changed()
	SIGNAL_HANDLER
	if(!context.valid(TRUE))
		qdel(src)

/datum/group_mindlink_view/process()
	if(!context.valid(TRUE) || viewer.client != view_client || view_client.eye != target || target.client.eye != target || target.group_mindlink_view || viewer.remote_control || viewer.control_object)
		qdel(src)
		return
	// 外部系统若另设移动延迟，保存其新值；清理时不会撤销其他来源的延迟。
	if(view_client.move_delay != held_move_delay)
		previous_move_delay = view_client.move_delay
		held_move_delay = max(previous_move_delay, context.link.expires_at + 1 SECONDS)
		view_client.move_delay = held_move_delay
	block_actions()
	sync_vision()
	process_senses()

/datum/group_mindlink_view/proc/block_actions()
	for(var/datum/action/action as anything in viewer.actions)
		if(!(action in blocked_actions))
			blocked_actions += action
			RegisterSignal(action, COMSIG_ACTION_TRIGGER, PROC_REF(block_action))

/datum/group_mindlink_view/proc/block_action()
	SIGNAL_HANDLER
	return COMPONENT_ACTION_BLOCK_TRIGGER

/datum/group_mindlink_view/proc/sync_vision()
	var/state = "[target.sight]|[target.see_in_dark]|[target.see_invisible]|[target.lighting_alpha]|[target.dir]|[target.cone_showing]|[target.hud_used?.fov?.icon_state]|[target.eye_blind]|[HAS_TRAIT(target, TRAIT_BLIND)]"
	if(state == last_visual_state)
		return
	last_visual_state = state
	viewer.update_sight()
	viewer.update_cone_show()
	viewer.update_vision_cone()
	viewer.update_blindness()

// 这些分支仅在借眼期间生效，不施加眩晕或清除其他状态；专用聊天窗口不依赖此行动判定。
/mob/living/carbon/incapacitated(ignore_restraints = FALSE, ignore_grab = TRUE, check_immobilized = FALSE, ignore_stasis = FALSE)
	if(!QDELETED(group_mindlink_view))
		return TRUE
	return ..()

/mob/living/carbon/check_click_intercept(params, A)
	if(!QDELETED(group_mindlink_view))
		var/list/modifiers = params2list(params)
		if(modifiers["shift"] && !modifiers["ctrl"] && !modifiers["alt"] && !modifiers["right"] && !modifiers["middle"])
			group_mindlink_view.examine_visible(A)
		return TRUE
	return ..()

/mob/living/carbon/canUseStorage()
	if(!QDELETED(group_mindlink_view))
		return FALSE
	return ..()

/mob/living/carbon/human/swap_hand(held_index)
	if(!QDELETED(group_mindlink_view))
		return FALSE
	return ..()

// 丢弃快捷键使用非静默参数；只拦截本人主动丢弃，外力卸物和强制掉落仍走原逻辑。
/mob/living/carbon/dropItemToGround(obj/item/item, force = FALSE, silent = TRUE)
	if(!QDELETED(group_mindlink_view) && usr == src && !force && !silent)
		return FALSE
	return ..()

// HUD 的丢弃按钮绕过普通物品点击和行动检查，因此单独拦截其输入入口。
/atom/movable/screen/drop/Click(location, control, params)
	var/mob/living/user = usr
	if(istype(user) && !QDELETED(user.group_mindlink_view))
		return FALSE
	return ..()

/mob/living/proc/group_mindlink_return_view()
	set name = "返回自身视角"
	set category = "IC"
	set desc = "停止通过群体心灵链接观看他人，并恢复自身视角与行动。"
	if(group_mindlink_view)
		qdel(group_mindlink_view)
	else
		verbs -= /mob/living/proc/group_mindlink_return_view
