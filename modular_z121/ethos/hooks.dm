GLOBAL_DATUM(z121_ethos_service, /datum/z121_ethos_service)

/datum/z121_ethos_service
/datum/z121_ethos_service/proc/register()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_created))
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		watch(H)

/datum/z121_ethos_service/proc/on_created(datum/source, mob/created)
	SIGNAL_HANDLER
	if(ishuman(created))
		watch(created)

/datum/z121_ethos_service/proc/watch(mob/living/carbon/human/H)
	RegisterSignal(H, COMSIG_PARENT_EXAMINE, PROC_REF(on_examined))

/datum/z121_ethos_service/proc/on_examined(mob/living/carbon/human/target, mob/viewer, list/lines)
	SIGNAL_HANDLER
	if(ishuman(viewer))
		var/mob/living/carbon/human/H = viewer
		H.z121_get_ethos()?.on_examinate(H, target)

// 同类型覆写继续现有链，调用者仅在当前执行栈内切换，结束或异常时还原。
/mob/living/carbon/human/attacked_by(obj/item/I, mob/living/user)
	var/mob/saved_user = usr
	var/datum/z121_ethos_hit/hit
	if(I && user && user != src)
		hit = new(src, user)
		usr = user
	try
		. = ..()
	catch(var/exception/error)
		usr = saved_user
		hit?.finish()
		throw error
	usr = saved_user
	hit?.finish()

/mob/living/carbon/human/attack_hand(mob/user)
	var/mob/saved_user = usr
	var/datum/z121_ethos_hit/hit
	if(isliving(user) && user != src && user:used_intent?.type != INTENT_HELP && !(offered_item_ref && user:used_intent?.type != INTENT_HARM))
		hit = new(src, user)
		usr = user
	try
		. = ..()
	catch(var/exception/error)
		usr = saved_user
		hit?.finish()
		throw error
	usr = saved_user
	hit?.finish()

/mob/living/carbon/human/attack_animal(mob/living/simple_animal/attacker)
	var/mob/saved_user = usr
	var/datum/z121_ethos_hit/hit
	if(attacker && attacker != src)
		hit = new(src, attacker)
		usr = attacker
	try
		. = ..()
	catch(var/exception/error)
		usr = saved_user
		hit?.finish()
		throw error
	usr = saved_user
	hit?.finish()

/mob/living/carbon/human/bullet_act(obj/projectile/P, def_zone = BODY_ZONE_CHEST)
	var/mob/saved_user = usr
	var/datum/z121_ethos_hit/hit
	if(isliving(P?.firer) && P.firer != src)
		hit = new(src, P.firer)
		usr = P.firer
	try
		. = ..()
	catch(var/exception/error)
		usr = saved_user
		hit?.finish()
		throw error
	usr = saved_user
	hit?.finish()


/datum/sex_controller
	var/list/z121_ethos_activities = list()
	var/z121_ethos_background_depth = 0

/datum/sex_controller/after_ejaculation(consume_charge = TRUE)
	var/actual_activity = FALSE
	if(!z121_ethos_background_depth)
		for(var/datum/z121_ethos_activity/A in z121_ethos_activities)
			if(A.valid())
				actual_activity = TRUE
				break
	. = ..()
	if(actual_activity && !user.has_status_effect(/datum/status_effect/debuff/false_sensation))
		user.z121_get_ethos()?.on_satisfaction(TRUE)

/mob/living/carbon/human
	var/z121_ethos_food_depth = 0
	var/z121_ethos_natural_nutrition = FALSE
	var/z121_ethos_natural_hydration = FALSE
	var/z121_ethos_teaching = FALSE

/datum/species/handle_digestion(mob/living/carbon/human/H)
	var/old_nutrition = H.z121_ethos_natural_nutrition
	var/old_hydration = H.z121_ethos_natural_hydration
	H.z121_ethos_natural_nutrition = TRUE
	H.z121_ethos_natural_hydration = TRUE
	try
		. = ..()
	catch(var/exception/error)
		H.z121_ethos_natural_nutrition = old_nutrition
		H.z121_ethos_natural_hydration = old_hydration
		throw error
	H.z121_ethos_natural_nutrition = old_nutrition
	H.z121_ethos_natural_hydration = old_hydration

/datum/reagent/consumable/on_mob_life(mob/living/carbon/M)
	var/mob/living/carbon/human/H = ishuman(M) ? M : null
	if(H)
		H.z121_ethos_food_depth++
	try
		. = ..()
	catch(var/exception/error)
		if(H && !QDELETED(H))
			H.z121_ethos_food_depth--
		throw error
	if(H && !QDELETED(H))
		H.z121_ethos_food_depth--

/mob/living/carbon/human/adjust_nutrition(change)
	var/datum/z121_ethos/R = z121_get_ethos()
	if(change < 0 && z121_ethos_natural_nutrition)
		z121_ethos_natural_nutrition = FALSE
		if(R?.virtues["temperance"])
			change *= 0.8
	if(change > 0 && z121_ethos_food_depth && R?.sins["gluttony"])
		change *= 0.8
	return ..(change)

/mob/living/carbon/human/adjust_hydration(change)
	if(change < 0 && z121_ethos_natural_hydration)
		z121_ethos_natural_hydration = FALSE
		if(z121_get_ethos()?.virtues["temperance"])
			change *= 0.8
	return ..(change)

// 赠予使用成功接受的入口，不能通过仅伸手/拒绝赠予获得奖励。
/obj/item
	var/z121_ethos_gift_rewarded = FALSE

/mob/living/carbon/human/accept_offered_item(mob/living/offerer, obj/offered_item, stealthy)
	. = ..()
	if(!ishuman(offerer) || !istype(offered_item, /obj/item) || offered_item.loc != src)
		return
	var/mob/living/carbon/human/giver = offerer
	var/obj/item/I = offered_item
	var/datum/z121_ethos/R = giver.z121_get_ethos()
	if(!client || !giver.client || giver == src || !R?.virtues["charity"] || !R.ready("charity") || (!istype(I, /obj/item/roguecoin) && I.z121_ethos_gift_rewarded))
		return
	var/eligible = istype(I, /obj/item/reagent_containers/food/snacks)
	if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = I
		eligible = C.sellprice * (C.quantity - C.z121_ethos_rewarded_coins()) >= 20
	if(I.reagents)
		for(var/datum/reagent/medicine/M in I.reagents.reagent_list)
			if(M.volume > 0)
				eligible = TRUE
	if(!eligible)
		return
	I.z121_ethos_gift_rewarded = TRUE
	if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = I
		C.z121_ethos_set_coin_rewards(C.quantity)
	R.ethos_cooldowns["charity"] = world.time + 10 MINUTES
	R.social_mood(src, /datum/stressevent/z121_ethos/charity, 5 MINUTES)
	R.social_mood(giver, /datum/stressevent/z121_ethos/charity, 5 MINUTES)

/obj/item/natural/cloth/attack(mob/living/M, mob/user, def_zone)
	var/mob/living/carbon/human/H = ishuman(M) ? M : null
	var/obj/item/bodypart/part = H?.get_bodypart(check_zone(user.zone_selected))
	var/needed = part && !part.bandage && part.get_bleed_rate() > 0
	. = ..()
	if(needed && part && !QDELETED(part) && part.bandage == src && ishuman(user))
		H.z121_get_ethos(TRUE).treated(user)

/mob/living/carbon/human/proc/z121_ethos_experience(skill, amount)
	var/datum/z121_ethos/R = z121_get_ethos()
	if(!R)
		return amount
	// 教学额外经验已经计算30%，不重复加入勤勉的劳动奖励。
	if(z121_ethos_teaching)
		return amount
	return R.experience(skill, amount)

/mob/living/carbon/human/proc/z121_ethos_craft_delay()
	var/datum/z121_ethos/R = z121_get_ethos()
	return R?.sins["sloth"] && R.sloth_elapsed >= 15 MINUTES ? 1.15 : 1

