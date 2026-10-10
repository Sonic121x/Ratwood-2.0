// 一次邀请批次锁定施法者及每个目标的身体、思维和客户端，回应不能跨批次复用。
/datum/group_mindlink_cast_request
	var/obj/effect/proc_holder/spell/self/group_mindlink/spell
	var/datum/group_mindlink_session/session
	var/mob/living/caster
	var/datum/mind/caster_mind
	var/client/caster_client
	var/caster_name
	var/deadline
	var/accepting = TRUE
	var/cancelled = FALSE
	var/list/invitations = list()

/datum/group_mindlink_cast_request/New(obj/effect/proc_holder/spell/self/group_mindlink/source_spell, datum/group_mindlink_session/source_session, list/targets)
	. = ..()
	spell = source_spell
	session = source_session
	caster = session.holder
	caster_mind = caster.mind
	caster_client = caster.client
	caster_name = caster.get_visible_name()
	deadline = world.time + 20 SECONDS
	RegisterSignal(caster, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER, COMSIG_MOB_LOGOUT), PROC_REF(caster_lost))
	for(var/mob/living/target as anything in targets)
		invitations += new /datum/group_mindlink_join_invitation(src, target)

/datum/group_mindlink_cast_request/Destroy()
	accepting = FALSE
	if(caster)
		UnregisterSignal(caster, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER, COMSIG_MOB_LOGOUT))
	for(var/datum/group_mindlink_join_invitation/invitation as anything in invitations)
		qdel(invitation)
	invitations.Cut()
	spell = null
	session = null
	caster = null
	caster_mind = null
	caster_client = null
	return ..()

/datum/group_mindlink_cast_request/proc/caster_valid()
	return !QDELETED(spell) && spell.cast_request == src && !QDELETED(session) && session.selection_spell == spell && !QDELETED(caster) && caster.client == caster_client && caster.mind == caster_mind && caster_mind?.current == caster && caster.stat == CONSCIOUS && !caster.IsUnconscious() && !caster.group_mindlink_view && caster_client?.eye == caster && ((spell in caster.mob_spell_list) || (spell in caster_mind.spell_list))

/datum/group_mindlink_cast_request/proc/open_invitations()
	for(var/datum/group_mindlink_join_invitation/invitation as anything in invitations)
		INVOKE_ASYNC(invitation, TYPE_PROC_REF(/datum/group_mindlink_join_invitation, ui_interact), invitation.target)

/datum/group_mindlink_cast_request/proc/all_answered()
	var/pending = FALSE
	for(var/datum/group_mindlink_join_invitation/invitation as anything in invitations)
		if(!invitation.answered && !invitation.identity_valid())
			invitation.respond(FALSE)
		if(!invitation.answered)
			pending = TRUE
	return !pending

/datum/group_mindlink_cast_request/proc/close_invitations()
	accepting = FALSE
	for(var/datum/group_mindlink_join_invitation/invitation as anything in invitations)
		SStgui.close_uis(invitation)

/datum/group_mindlink_cast_request/proc/cancel()
	cancelled = TRUE
	close_invitations()

/datum/group_mindlink_cast_request/proc/caster_lost()
	SIGNAL_HANDLER
	cancel()

/datum/group_mindlink_cast_request/proc/accepted_members()
	var/list/result = list()
	if(cancelled || !caster_valid())
		return result
	var/list/candidates = group_mindlink_candidates(caster)
	for(var/datum/group_mindlink_join_invitation/invitation as anything in invitations)
		if(invitation.accepted && invitation.identity_valid() && candidates[REF(invitation.target)] == invitation.target)
			result |= invitation.target
	return result

/datum/group_mindlink_join_invitation
	var/datum/group_mindlink_cast_request/request
	var/mob/living/target
	var/datum/mind/target_mind
	var/client/target_client
	var/answered = FALSE
	var/accepted = FALSE
	var/identity_lost = FALSE

/datum/group_mindlink_join_invitation/New(datum/group_mindlink_cast_request/source_request, mob/living/subject)
	. = ..()
	request = source_request
	target = subject
	target_mind = subject.mind
	target_client = subject.client
	RegisterSignal(target, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER, COMSIG_MOB_LOGOUT), PROC_REF(target_lost))

/datum/group_mindlink_join_invitation/Destroy()
	answered = TRUE
	if(target)
		UnregisterSignal(target, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER, COMSIG_MOB_LOGOUT))
	SStgui.close_uis(src)
	request = null
	target = null
	target_mind = null
	target_client = null
	return ..()

/datum/group_mindlink_join_invitation/proc/identity_valid()
	return !identity_lost && !QDELETED(request) && !request.cancelled && request.caster_valid() && !QDELETED(target) && target.client == target_client && target.mind == target_mind && target_mind?.current == target && target.stat == CONSCIOUS && !target.IsUnconscious()

/datum/group_mindlink_join_invitation/proc/target_lost()
	SIGNAL_HANDLER
	identity_lost = TRUE
	accepted = FALSE
	respond(FALSE)

/datum/group_mindlink_join_invitation/ui_state(mob/user)
	return GLOB.always_state

/datum/group_mindlink_join_invitation/ui_status(mob/user, datum/ui_state/state)
	return user == target && !answered && request?.accepting && world.time < request.deadline && identity_valid() ? UI_INTERACTIVE : UI_CLOSE

/datum/group_mindlink_join_invitation/ui_interact(mob/user, datum/tgui/ui)
	if(ui_status(user) != UI_INTERACTIVE)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GroupMindlinkJoinRequest", "心灵链接加入邀请")
		ui.open()

/datum/group_mindlink_join_invitation/ui_data(mob/user)
	if(ui_status(user) != UI_INTERACTIVE)
		return list()
	return list("title" = "心灵链接加入邀请", "message" = "[request.caster_name]邀请你加入本次群体心灵链接，最多六人，持续十五分钟。所有成员都可以直接观看彼此的视角、听到周围声音，并检视可见物品；不会获得身体控制权、私聊或系统通知。加入即同意群内互相视听旁观，无需另行确认。你可随时通过 IC → 群体心灵链接退出主链接，终止本链接的旁观权限，退出后不能重新加入。确认后仍须施法引导且你仍在施法者视野内、面容与真名公开。是否同意？", "timeout" = clamp((request.deadline - world.time) / (20 SECONDS), 0, 1))

/datum/group_mindlink_join_invitation/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(ui.user != target || usr != target || ui_status(target) != UI_INTERACTIVE)
		return FALSE
	if(action == "choose" && (params["choice"] in list("同意", "拒绝")))
		respond(params["choice"] == "同意")
		return TRUE
	if(action == "cancel")
		respond(FALSE)
		return TRUE

/datum/group_mindlink_join_invitation/ui_close(mob/user)
	if(!answered && !QDELETED(src))
		respond(FALSE)

/datum/group_mindlink_join_invitation/proc/respond(accept)
	if(answered)
		return
	answered = TRUE
	// 只有仍属于本次批次且当前实际可选的角色，才能记录明确同意。
	if(accept && request?.accepting && world.time < request.deadline && identity_valid())
		var/list/candidates = group_mindlink_candidates(request.caster)
		accepted = candidates[REF(target)] == target
	SStgui.close_uis(src)
