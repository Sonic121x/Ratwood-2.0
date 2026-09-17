// 授权属于主链接，观看状态属于观看者；关闭镜头不会顺带撤销已同意的授权。
/mob/living
	var/datum/group_mindlink_view/group_mindlink_view

/datum/group_mindlink_custom/proc/find_vision_permission(mob/living/viewer, mob/living/target)
	for(var/datum/group_mindlink_vision_permission/permission as anything in vision_permissions)
		if(!QDELETED(permission) && permission.viewer == viewer && permission.target == target)
			return permission

/datum/group_mindlink_custom/proc/clear_member_vision(mob/living/member)
	for(var/datum/group_mindlink_vision_permission/permission as anything in vision_permissions.Copy())
		if(permission.viewer == member || permission.target == member)
			qdel(permission)

/datum/group_mindlink_session/proc/vision_logout()
	SIGNAL_HANDLER
	// 断线保留聊天成员资格，但不能保留需要本人确认的视觉授权。
	for(var/datum/group_mindlink_custom/link as anything in links.Copy())
		link.clear_member_vision(holder)

/datum/group_mindlink_session/proc/vision_data()
	var/list/result = list("current" = null, "incoming" = list(), "outgoing" = list())
	var/datum/group_mindlink_view/view = holder.group_mindlink_view
	if(!QDELETED(view))
		result["current"] = list("id" = REF(view.permission), "name" = view.target.real_name)
	for(var/datum/group_mindlink_custom/link as anything in links)
		for(var/datum/group_mindlink_vision_permission/permission as anything in link.vision_permissions)
			if(!permission.valid() || (permission.viewer != holder && permission.target != holder))
				continue
			var/incoming = permission.target == holder
			var/mob/living/other = incoming ? permission.viewer : permission.target
			var/list/entries = result[incoming ? "incoming" : "outgoing"]
			entries += list(list("id" = REF(permission), "link" = REF(link), "link_name" = "[link.owner.real_name]的链接", "person" = REF(other), "name" = other.real_name, "approved" = permission.approved, "watching" = other == permission.viewer ? other.group_mindlink_view?.permission == permission : holder.group_mindlink_view?.permission == permission))
	return result

/datum/group_mindlink_session/proc/find_vision_permission(id)
	for(var/datum/group_mindlink_custom/link as anything in links)
		for(var/datum/group_mindlink_vision_permission/permission as anything in link.vision_permissions)
			if(REF(permission) == id && (permission.viewer == holder || permission.target == holder) && permission.valid())
				return permission

/datum/group_mindlink_session/proc/vision_action(action, list/params)
	if(action == "vision_stop")
		if(holder.group_mindlink_view)
			qdel(holder.group_mindlink_view)
		return TRUE
	if(action == "vision_revoke_all")
		for(var/datum/group_mindlink_custom/link as anything in links.Copy())
			for(var/datum/group_mindlink_vision_permission/permission as anything in link.vision_permissions.Copy())
				if(permission.target == holder)
					qdel(permission)
		return TRUE
	if(action == "vision_request")
		if(holder.IsUnconscious())
			notice("清醒时才能发起视角请求。")
			return TRUE
		for(var/datum/group_mindlink_custom/link as anything in links)
			if(REF(link) != params["link"] || !link.active || world.time >= link.expires_at || !(holder in link.participants))
				continue
			for(var/mob/living/target as anything in link.participants)
				if(REF(target) != params["person"] || target == holder)
					continue
				if(QDELETED(target) || !target.client || target.stat != CONSCIOUS || target.IsUnconscious())
					notice("对方需要在线且清醒，才能本人同意视角请求。")
					return TRUE
				if(link.find_vision_permission(holder, target))
					notice("已有待处理请求或有效授权，请查看视角面板。")
					return TRUE
				// 同一对角色在其他主链接中的待处理邀请也不能重复弹出。
				for(var/datum/group_mindlink_custom/other_link as anything in links)
					var/datum/group_mindlink_vision_permission/pending = other_link.find_vision_permission(holder, target)
					if(pending && !pending.approved)
						notice("对方尚有你的视角请求待处理，请先等待或取消。")
						return TRUE
				if(world.time < last_vision_request + 5 SECONDS)
					notice("每五秒最多发起一次视角请求，请稍候。")
					return TRUE
				last_vision_request = world.time
				var/datum/group_mindlink_vision_permission/permission = new(link, holder, target)
				notice("已请求观看[target.real_name]的视角，等待对方同意。")
				INVOKE_ASYNC(permission, TYPE_PROC_REF(/datum/group_mindlink_vision_permission, ui_interact), target)
				return TRUE
		return TRUE
	var/datum/group_mindlink_vision_permission/permission = find_vision_permission(params["id"])
	if(!permission)
		notice("这份视角请求或授权已经失效。")
		return TRUE
	switch(action)
		if("vision_accept", "vision_decline")
			if(permission.target == holder && !permission.approved)
				permission.respond(holder, action == "vision_accept")
		if("vision_revoke")
			if(permission.target == holder)
				qdel(permission)
		if("vision_cancel")
			if(permission.viewer == holder && !permission.approved)
				qdel(permission)
		if("vision_start")
			if(permission.viewer == holder)
				permission.start_view()
	return TRUE

// 请求对象直接使用现有确认弹窗界面，避免原生弹窗回退后失去超时和身份校验。
/datum/group_mindlink_vision_permission
	var/datum/group_mindlink_custom/link
	var/mob/living/viewer
	var/mob/living/target
	var/client/viewer_client
	var/client/target_client
	var/approved = FALSE
	var/deadline
	var/request_timer

/datum/group_mindlink_vision_permission/New(datum/group_mindlink_custom/parent_link, mob/living/requester, mob/living/subject)
	. = ..()
	link = parent_link
	viewer = requester
	target = subject
	viewer_client = viewer.client
	target_client = target.client
	deadline = world.time + 20 SECONDS
	link.vision_permissions += src
	request_timer = addtimer(CALLBACK(src, PROC_REF(expire_request)), 20 SECONDS, TIMER_STOPPABLE)
	START_PROCESSING(SSprocessing, src)
	refresh_pair()

/datum/group_mindlink_vision_permission/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(request_timer)
		deltimer(request_timer)
	SStgui.close_uis(src)
	if(viewer?.group_mindlink_view?.permission == src)
		qdel(viewer.group_mindlink_view)
	link?.vision_permissions.Remove(src)
	var/reason = approved ? "视角授权已撤销或随链接失效，再次观看需要重新同意。" : "视角请求未获同意、已取消或已经失效。"
	for(var/mob/living/member as anything in list(viewer, target))
		if(!QDELETED(member))
			to_chat(member, span_notice("\[心灵视角\] [reason]"))
	refresh_pair()
	link = null
	viewer = null
	target = null
	viewer_client = null
	target_client = null
	return ..()

/datum/group_mindlink_vision_permission/proc/valid(require_awake = FALSE)
	if(QDELETED(src) || QDELETED(link) || !link.active || world.time >= link.expires_at)
		return FALSE
	if(QDELETED(viewer) || QDELETED(target) || viewer == target || viewer.stat == DEAD || target.stat == DEAD)
		return FALSE
	if(!(viewer in link.participants) || !(target in link.participants))
		return FALSE
	if(!viewer.client || !target.client || viewer.client != viewer_client || target.client != target_client)
		return FALSE
	if(require_awake && (viewer.stat != CONSCIOUS || target.stat != CONSCIOUS || viewer.IsUnconscious() || target.IsUnconscious()))
		return FALSE
	return TRUE

/datum/group_mindlink_vision_permission/process()
	if(!valid(!approved))
		qdel(src)

/datum/group_mindlink_vision_permission/proc/expire_request()
	if(!approved)
		qdel(src)

/datum/group_mindlink_vision_permission/proc/refresh_pair()
	var/datum/group_mindlink_session/viewer_session = group_mindlink_session(viewer, FALSE)
	var/datum/group_mindlink_session/target_session = group_mindlink_session(target, FALSE)
	viewer_session?.refresh()
	target_session?.refresh()

/datum/group_mindlink_vision_permission/ui_state(mob/user)
	return GLOB.always_state

/datum/group_mindlink_vision_permission/ui_status(mob/user, datum/ui_state/state)
	return user == target && !approved && world.time < deadline && valid(TRUE) ? UI_INTERACTIVE : UI_CLOSE

/datum/group_mindlink_vision_permission/ui_interact(mob/user, datum/tgui/ui)
	if(ui_status(user) != UI_INTERACTIVE)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AlertModal", "心灵视角请求")
		ui.open()

/datum/group_mindlink_vision_permission/ui_data(mob/user)
	if(user != target || !valid(TRUE))
		return list()
	return list("title" = "心灵视角请求", "message" = "[viewer.real_name]请求观看你的视角。这是单向授权，仅在[link.owner.real_name]创建的本次主链接内有效，允许反复观看。你可随时在群体心灵链接窗口撤销。是否同意？", "buttons" = list("拒绝", "同意"), "autofocus" = FALSE, "large_buttons" = FALSE, "swapped_buttons" = FALSE, "timeout" = clamp((deadline - world.time) / (20 SECONDS), 0, 1))

/datum/group_mindlink_vision_permission/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(ui.user != target || usr != target || ui_status(target) != UI_INTERACTIVE)
		return FALSE
	if(action == "choose" && (params["choice"] in list("同意", "拒绝")))
		respond(target, params["choice"] == "同意")
		return TRUE
	if(action == "cancel")
		respond(target, FALSE)
		return TRUE

/datum/group_mindlink_vision_permission/ui_close(mob/user)
	if(!approved && !QDELETED(src))
		qdel(src)

/datum/group_mindlink_vision_permission/proc/respond(mob/user, accept)
	if(user != target || approved)
		return
	if(!accept || world.time >= deadline || !valid(TRUE))
		qdel(src)
		return
	approved = TRUE
	if(request_timer)
		deltimer(request_timer)
		request_timer = null
	SStgui.close_uis(src)
	to_chat(viewer, span_notice("\[心灵视角\] [html_encode(target.real_name)]已同意，可在窗口中主动选择『观看视角』。"))
	to_chat(target, span_notice("\[心灵视角\] 你已授权[html_encode(viewer.real_name)]在本次主链接内观看你的视角，可随时撤销。"))
	refresh_pair()

/datum/group_mindlink_vision_permission/proc/start_view()
	var/datum/group_mindlink_session/session = group_mindlink_session(viewer, FALSE)
	if(!approved || !valid(TRUE))
		session?.notice("当前没有有效授权，或双方未处于在线清醒状态。")
		return
	if(viewer.group_mindlink_view?.permission == src)
		return
	if(target.group_mindlink_view || target.client.eye != target || viewer.group_mindlink_has_watchers())
		session?.notice("不能转播他人的视角，也不能在自己被观看时借用其他视角。")
		return
	if((!viewer.group_mindlink_view && viewer.client.eye != viewer) || viewer.remote_control || viewer.control_object || session?.selection_spell?.casting)
		session?.notice("请先结束其他远程视角、控制或正在进行的施法。")
		return
	if(viewer.group_mindlink_view)
		qdel(viewer.group_mindlink_view)
	new /datum/group_mindlink_view(src)

/mob/living/proc/group_mindlink_has_watchers(include_sensory = TRUE)
	if(include_sensory && sensory_share_link_custom?.active)
		var/mob/living/partner = sensory_share_link_custom.get_partner(src)
		if(partner?.client?.eye == src)
			return TRUE
	var/datum/group_mindlink_session/session = group_mindlink_session(src, FALSE)
	if(!session)
		return FALSE
	for(var/datum/group_mindlink_custom/link as anything in session.links)
		for(var/datum/group_mindlink_vision_permission/permission as anything in link.vision_permissions)
			if(permission.target == src && permission.viewer?.group_mindlink_view?.permission == permission)
				return TRUE
	return FALSE

// 只在镜头和授权都仍属于本功能时接管视觉；其他系统改镜头后立即交还控制。
/mob/living/proc/group_mindlink_borrowed_eye()
	var/datum/group_mindlink_view/view = group_mindlink_view
	if(QDELETED(view) || !client || client.eye != view.target || !view.permission?.valid(TRUE) || view.target.client.eye != view.target)
		return null
	return view.target

/datum/group_mindlink_view
	var/datum/group_mindlink_vision_permission/permission
	var/mob/living/viewer
	var/mob/living/target
	var/client/view_client
	var/previous_move_delay
	var/held_move_delay
	var/last_visual_state
	var/list/blocked_actions = list()

/datum/group_mindlink_view/New(datum/group_mindlink_vision_permission/authorization)
	. = ..()
	permission = authorization
	viewer = permission.viewer
	target = permission.target
	view_client = viewer.client
	viewer.stop_attack()
	viewer.group_mindlink_view = src
	viewer.verbs |= /mob/living/proc/group_mindlink_return_view
	// 暂停客户端主动移动，不修改定身状态，外力拖拽和强制位移仍正常发生。
	previous_move_delay = view_client.move_delay
	held_move_delay = max(previous_move_delay, permission.link.expires_at + 1 SECONDS)
	view_client.move_delay = held_move_delay
	RegisterSignal(viewer, COMSIG_MOVABLE_MOVED, PROC_REF(viewer_moved))
	RegisterSignal(viewer, COMSIG_MOB_STATCHANGE, PROC_REF(state_changed))
	RegisterSignal(target, COMSIG_MOB_STATCHANGE, PROC_REF(state_changed))
	viewer.update_mobility()
	viewer.reset_perspective(target)
	sync_vision()
	block_actions()
	START_PROCESSING(SSfastprocess, src)
	to_chat(viewer, span_notice("\[心灵视角\] 正在观看[html_encode(target.real_name)]，身体暂时不能主动行动。可在窗口或 IC 动词中返回自身视角。"))
	to_chat(target, span_notice("\[心灵视角\] [html_encode(viewer.real_name)]开始观看你的视角。"))
	permission.refresh_pair()

/datum/group_mindlink_view/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
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
			to_chat(target, span_notice("\[心灵视角\] [html_encode(viewer.real_name)]已停止观看你的视角。"))
	permission?.refresh_pair()
	permission = null
	viewer = null
	target = null
	view_client = null
	return ..()

/datum/group_mindlink_view/proc/viewer_moved()
	SIGNAL_HANDLER
	qdel(src)

/datum/group_mindlink_view/proc/state_changed()
	SIGNAL_HANDLER
	if(!permission.valid(TRUE))
		qdel(src)

/datum/group_mindlink_view/process()
	if(!permission.valid(TRUE) || viewer.client != view_client || view_client.eye != target || target.client.eye != target || target.group_mindlink_view || viewer.remote_control || viewer.control_object)
		qdel(src)
		return
	// 外部系统若另设移动延迟，保存其新值；清理时不会撤销其他来源的延迟。
	if(view_client.move_delay != held_move_delay)
		previous_move_delay = view_client.move_delay
		held_move_delay = max(previous_move_delay, permission.link.expires_at + 1 SECONDS)
		view_client.move_delay = held_move_delay
	block_actions()
	sync_vision()

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
