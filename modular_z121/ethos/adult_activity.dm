// 每次成功动作使用独立凭据，固定参与者，停止和异常不能留下活动计数。
/proc/z121_ethos_adult_enabled(mob/living/carbon/human/H)
	return ishuman(H) && !QDELETED(H) && (H.age in list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)) && H.client?.prefs?.sexable

/datum/z121_ethos_activity
	var/datum/weakref/controller_ref
	var/datum/weakref/actor_ref
	var/datum/weakref/receiver_ref
	var/action_type
	var/list/controllers = list()

/datum/z121_ethos_activity/New(datum/sex_controller/controller, mob/living/carbon/human/actor, mob/living/carbon/human/receiver, action)
	controller_ref = WEAKREF(controller)
	actor_ref = WEAKREF(actor)
	receiver_ref = WEAKREF(receiver)
	action_type = action
	if(!z121_ethos_adult_enabled(actor) || !z121_ethos_adult_enabled(receiver))
		return
	var/list/participants = list(actor, receiver)
	participants = uniqueList(participants)
	for(var/mob/living/carbon/human/H in participants)
		if(H?.sexcon)
			controllers |= H.sexcon
			H.sexcon.z121_ethos_activities |= src
			H.z121_get_ethos()?.break_chastity()

/datum/z121_ethos_activity/proc/valid()
	var/datum/sex_controller/C = controller_ref?.resolve()
	var/mob/living/carbon/human/actor = actor_ref?.resolve()
	var/mob/living/carbon/human/receiver = receiver_ref?.resolve()
	return C && actor && receiver && C.current_action == action_type && C.user == actor && C.target == receiver && !C.desire_stop && z121_ethos_adult_enabled(actor) && z121_ethos_adult_enabled(receiver)

/datum/z121_ethos_activity/Destroy()
	for(var/datum/sex_controller/C in controllers)
		if(!QDELETED(C))
			C.z121_ethos_activities -= src
	controllers.Cut()
	return ..()

/datum/sex_controller/stop_current_action()
	for(var/datum/z121_ethos_activity/A in z121_ethos_activities.Copy())
		if(A.controller_ref?.resolve() == src)
			qdel(A)
	return ..()

// 自然代谢及药物推动的后台满足不能借用正在等待的成人动作凭据。
/datum/sex_controller/process_sexcon(dt)
	handle_arousal_unhorny(dt)
	handle_charge(dt)
	z121_ethos_background_depth++
	try
		handle_passive_ejaculation()
	catch(var/exception/error)
		z121_ethos_background_depth--
		throw error
	z121_ethos_background_depth--
