/datum/sex_action/force_cunnilingus
	name = "强迫对方舔弄"
	require_grab = TRUE
	stamina_cost = 1.0
	user_sex_part = SEX_PART_CUNT
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/force_cunnilingus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[target]的脑袋强按到了[user.p_their()]阴部上！"))

/datum/sex_action/force_cunnilingus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]强迫[target]舔弄[user.p_their()]阴部。"))
	user.sexcon.oralcourse_noise(target)
	target.sexcon.do_thrust_animate(user)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_jaw_crush(target)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)
	user.sexcon.handle_passive_ejaculation(splashed_user = target)

	user.sexcon.perform_sex_action(target, 0, 2, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/force_cunnilingus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[target]的脑袋拽开了。"))

/datum/sex_action/force_cunnilingus/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
