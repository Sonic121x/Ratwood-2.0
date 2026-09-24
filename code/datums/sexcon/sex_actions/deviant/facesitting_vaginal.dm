/datum/sex_action/facesitting_vaginal
	name = "用阴部坐在对方脸上"

/datum/sex_action/facesitting_vaginal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/facesitting_vaginal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	// Need to stand up
	if(user.resting)
		return FALSE
	// Target can't stand up
	if(!target.resting)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/facesitting_vaginal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]压低臀部，坐在[target]的脸上！"))

/datum/sex_action/facesitting_vaginal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/verbstring = pick(list("挤压", "强压", "按压", "磨蹭", "冲撞", "紧压"))
	user.sexcon_action_message(user.sexcon.spanify_force("[user]用自己的阴部[user.sexcon.get_generic_force_adjective()][verbstring]着[target]的脸。"))
	
	target.sexcon.make_sucking_noise()
	user.sexcon.do_thrust_animate(target)

	// Fat pussy smash
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_jaw_crush(target)

	// User pleasure
	user.sexcon.perform_sex_action(user, 1, 1, TRUE)
	user.sexcon.handle_passive_ejaculation(target)

	// Target pleasure and oxyloss from strong intent and up
	user.sexcon.perform_deepthroat_oxyloss(target, 1)
	user.sexcon.perform_sex_action(target, 1, 3, FALSE)
	target.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/facesitting_vaginal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]从[target]的脸上起身。"))

/datum/sex_action/facesitting_vaginal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE

