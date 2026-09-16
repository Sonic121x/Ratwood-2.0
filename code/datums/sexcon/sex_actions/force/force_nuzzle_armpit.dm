/datum/sex_action/force_armpit_nuzzle
	name = "强迫对方贴向腋下"
	require_grab = TRUE
	stamina_cost = 1.0
	user_sex_part = SEX_PART_CHEST
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/force_armpit_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[target]的脑袋强按到了[user.p_their()]腋下！"))

/datum/sex_action/force_armpit_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/armpit_description = user.sexcon.get_armpit_description(user)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]强迫[target]在[user.p_their()][armpit_description]磨蹭。"))
	target.sexcon.do_thrust_animate(user)

	user.sexcon.perform_sex_action(user, 0.5, 0, TRUE)
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		user.sexcon.try_jaw_crush(target)

	user.sexcon.perform_sex_action(target, 0, 1, FALSE)
	user.sexcon.perform_deepthroat_oxyloss(target, 0.6)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/force_armpit_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[target]的脑袋从[user.p_their()]腋下拉开了。"))

/datum/sex_action/force_armpit_nuzzle/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
