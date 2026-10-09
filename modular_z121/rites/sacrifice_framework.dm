// 献祭会话属于当前身体，并以开始时的心智识别主持者。
/mob/living
	var/datum/z121_sacrifice_session/z121_sacrifice_session

/datum/z121_sacrifice_session
	var/obj/structure/ritualcircle/sacrifice/circle
	var/mob/living/user
	var/datum/mind/original_mind
	var/selection
	var/cancelled = FALSE
	var/performance_active = FALSE

/datum/z121_sacrifice_session/New(obj/structure/ritualcircle/sacrifice/new_circle, mob/living/new_user, new_selection)
	circle = new_circle
	user = new_user
	original_mind = user.mind
	selection = new_selection
	user.z121_sacrifice_session = src
	RegisterSignal(user, COMSIG_MIND_TRANSFER, PROC_REF(cancel))
	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(endpoint_deleted))
	RegisterSignal(circle, COMSIG_QDELETING, PROC_REF(endpoint_deleted))

/datum/z121_sacrifice_session/proc/cancel(datum/source)
	SIGNAL_HANDLER
	cancelled = TRUE

/datum/z121_sacrifice_session/proc/endpoint_deleted(datum/source)
	SIGNAL_HANDLER
	cancelled = TRUE
	if(performance_active)
		qdel(src)

/datum/z121_sacrifice_session/proc/valid()
	return !cancelled && !QDELETED(circle) && !QDELETED(user) && !QDELETED(original_mind) && user.mind == original_mind && circle.valid_rite_user(user, selection, src)

/datum/z121_sacrifice_session/Destroy()
	if(user)
		UnregisterSignal(user, list(COMSIG_MIND_TRANSFER, COMSIG_QDELETING))
		if(user.z121_sacrifice_session == src)
			user.z121_sacrifice_session = null
	if(circle)
		UnregisterSignal(circle, COMSIG_QDELETING)
	circle = null
	user = null
	original_mind = null
	return ..()

// 邻接、信仰、限次及会话占用均在选单返回后重新检查。
/obj/structure/ritualcircle/sacrifice/proc/valid_rite_user(mob/living/user, selection, datum/z121_sacrifice_session/session, check_cooldown = TRUE)
	if(QDELETED(src) || QDELETED(user) || user.stat != CONSCIOUS || !user.mind)
		return FALSE
	var/turf/altar = get_turf(src)
	var/turf/standing = get_turf(user)
	if(!altar || !standing || !isturf(user.loc) || standing.z != altar.z || !Adjacent(user))
		return FALSE
	if(patron_type && user.patron?.type != patron_type)
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_RITUALIST) || (!allow_dreamwalkers && HAS_TRAIT(user, TRAIT_DREAMWALKER)))
		return FALSE
	if(check_cooldown && user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		return FALSE
	if(user.z121_sacrifice_session && user.z121_sacrifice_session != session)
		return FALSE
	return isnull(selection) || (selection in sacrifice_rites)

/obj/structure/ritualcircle/sacrifice/proc/rite_session_valid(mob/living/user)
	var/datum/z121_sacrifice_session/session = user?.z121_sacrifice_session
	return session && session.circle == src && session.valid()

/obj/structure/ritualcircle/sacrifice/proc/wait_for_rite(mob/living/user, delay)
	if(!rite_session_valid(user))
		return FALSE
	var/datum/z121_sacrifice_session/session = user.z121_sacrifice_session
	return do_after(user, delay, target = src, extra_checks = CALLBACK(session, TYPE_PROC_REF(/datum/z121_sacrifice_session, valid))) && rite_session_valid(user)

// 完整祭品清单只在最终检查通过后提交，提交期间不等待。
/datum/z121_sacrifice_offering
	var/turf/altar
	var/list/items = list()
	var/list/reagent_amounts = list()
	var/list/coin_counts = list()
	var/change = 0

/datum/z121_sacrifice_offering/New(turf/new_altar)
	altar = new_altar

/datum/z121_sacrifice_offering/proc/collect_items(item_type, count = 1, organic_hearts = FALSE, lux_vitae = FALSE)
	for(var/obj/item/item in altar)
		if(QDELETED(item) || !istype(item, item_type) || (item in items))
			continue
		if(organic_hearts)
			var/obj/item/organ/heart/heart = item
			if(heart.owner || istype(heart, /obj/item/organ/heart/construct) || heart.status == ORGAN_ROBOTIC)
				continue
		if(lux_vitae && (!item.reagents || item.reagents.get_reagent_amount(/datum/reagent/vitae) < 5))
			continue
		items += item
		count--
		if(count <= 0)
			return TRUE
	return FALSE

/datum/z121_sacrifice_offering/proc/collect_reagents(list/reagent_types, amount)
	for(var/obj/item/reagent_containers/container in altar)
		if(QDELETED(container) || !container.reagents)
			continue
		for(var/reagent_type in reagent_types)
			var/list/planned = reagent_amounts[container]
			if(!planned)
				planned = list()
				reagent_amounts[container] = planned
			var/available = container.reagents.get_reagent_amount(reagent_type) - (planned[reagent_type] ? planned[reagent_type] : 0)
			var/taken = min(amount, available)
			if(taken <= 0)
				continue
			planned[reagent_type] = (planned[reagent_type] ? planned[reagent_type] : 0) + taken
			amount -= taken
			if(amount <= 0)
				return TRUE
	return FALSE

/datum/z121_sacrifice_offering/proc/collect_coins(amount)
	for(var/obj/item/roguecoin/coin in altar)
		if(QDELETED(coin) || !(istype(coin, /obj/item/roguecoin/gold) || istype(coin, /obj/item/roguecoin/silver) || istype(coin, /obj/item/roguecoin/copper)))
			continue
		var/value = initial(coin.sellprice)
		var/count = min(coin.quantity, CEILING(amount / value, 1))
		if(count <= 0)
			continue
		coin_counts[coin] = count
		amount -= count * value
		if(amount <= 0)
			change = -amount
			return TRUE
	return FALSE

/datum/z121_sacrifice_offering/proc/valid()
	if(QDELETED(altar))
		return FALSE
	for(var/obj/item/item as anything in items)
		if(QDELETED(item) || item.loc != altar)
			return FALSE
		if(istype(item, /obj/item/organ/heart))
			var/obj/item/organ/heart/heart = item
			if(heart.owner || istype(heart, /obj/item/organ/heart/construct) || heart.status == ORGAN_ROBOTIC)
				return FALSE
		if(istype(item, /obj/item/reagent_containers/lux) && (!item.reagents || item.reagents.get_reagent_amount(/datum/reagent/vitae) < 5))
			return FALSE
	for(var/obj/item/reagent_containers/container as anything in reagent_amounts)
		if(QDELETED(container) || container.loc != altar || !container.reagents)
			return FALSE
		var/list/planned = reagent_amounts[container]
		for(var/reagent_type in planned)
			if(container.reagents.get_reagent_amount(reagent_type) < planned[reagent_type])
				return FALSE
	for(var/obj/item/roguecoin/coin as anything in coin_counts)
		if(QDELETED(coin) || coin.loc != altar || coin.quantity < coin_counts[coin])
			return FALSE
	return TRUE

/datum/z121_sacrifice_offering/proc/consume()
	if(!valid())
		return FALSE
	for(var/obj/item/reagent_containers/container as anything in reagent_amounts)
		var/list/planned = reagent_amounts[container]
		for(var/reagent_type in planned)
			container.reagents.remove_reagent(reagent_type, planned[reagent_type])
	for(var/obj/item/roguecoin/coin as anything in coin_counts)
		coin.set_quantity(coin.quantity - coin_counts[coin])
		if(coin.quantity <= 0)
			qdel(coin)
	if(change)
		new /obj/item/roguecoin/copper(altar, change)
	for(var/obj/item/item as anything in items)
		qdel(item)
	return TRUE

/datum/z121_sacrifice_offering/Destroy()
	altar = null
	items = null
	reagent_amounts = null
	coin_counts = null
	return ..()

/obj/structure/ritualcircle/sacrifice
	var/new_rite_effect
	var/new_rite_requirements
	var/new_rite_active_icon
	var/new_rite_reward_message
	var/list/new_rite_chants

/obj/structure/ritualcircle/sacrifice/proc/new_rite_environment_valid()
	return TRUE

/obj/structure/ritualcircle/sacrifice/proc/new_rite_can_receive(mob/living/carbon/human/user)
	return ishuman(user) && user.mind && (!new_rite_effect || !user.has_status_effect(new_rite_effect))

/obj/structure/ritualcircle/sacrifice/proc/build_new_offering(datum/z121_sacrifice_offering/offering)
	return FALSE

/obj/structure/ritualcircle/sacrifice/proc/grant_new_reward(mob/living/carbon/human/user)
	user.apply_status_effect(new_rite_effect)

/obj/structure/ritualcircle/sacrifice/proc/run_new_sacrifice(mob/living/user)
	if(!rite_session_valid(user) || !new_rite_can_receive(user) || !new_rite_environment_valid())
		to_chat(user, span_warning("我无法承接这份赐福，或此处尚未满足仪式的条件。"))
		return FALSE
	var/datum/z121_sacrifice_offering/offering = new(get_turf(src))
	var/success = FALSE
	try
		success = complete_new_sacrifice(user, offering)
	catch(var/exception/error)
		qdel(offering)
		throw error
	qdel(offering)
	return success

/obj/structure/ritualcircle/sacrifice/proc/complete_new_sacrifice(mob/living/carbon/human/user, datum/z121_sacrifice_offering/offering)
	if(!build_new_offering(offering))
		to_chat(user, span_warning("法阵上的祭品不足，需要：[new_rite_requirements]。"))
		return FALSE
	for(var/chant in new_rite_chants)
		if(!wait_for_rite(user, 5 SECONDS) || offering.altar != get_turf(src) || !offering.valid() || !new_rite_environment_valid())
			return FALSE
		user.say(chant)
		playsound(offering.altar, 'sound/magic/churn.ogg', 60, FALSE)
	if(!wait_for_rite(user, 3 SECONDS) || !new_rite_can_receive(user) || !new_rite_environment_valid() || offering.altar != get_turf(src) || !offering.valid())
		return FALSE
	if(!offering.consume())
		return FALSE
	grant_new_reward(user)
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
	icon_state = new_rite_active_icon
	offering.altar.visible_message(span_notice("[src]骤然亮起，[user]的献祭得到了回应。"))
	to_chat(user, span_nicegreen(new_rite_reward_message))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/ritualcircle/sacrifice, reset_rune_state)), 120)
	return TRUE
