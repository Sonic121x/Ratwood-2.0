/datum/sex_action/chastityplay/frot_cage_to_cage
	name = "贞操笼互相磨蹭"
	user_sex_part = SEX_PART_COCK
	user_needs_chastity = TRUE
	target_sex_part = SEX_PART_COCK
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/frot_cage_to_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/user_device = get_chastity_device_name(user)
	var/target_device = get_chastity_device_name(target)
	if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED) || HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		user.visible_message(span_warning("[user]把[user.p_their()]的[user_device]抵上[target]的[target_device]，初次碰撞时金属立刻刮上了尖刺。"))
		return
	user.visible_message(span_warning("[user]逼近[target]，直到[user.p_their()]的[user_device]撞上[target]的[target_device]。"))

/datum/sex_action/chastityplay/frot_cage_to_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/user_device = get_chastity_device_name(user)
	var/target_device = get_chastity_device_name(target)
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	// Chastity device sound is handled internally by perform_sex_action via chastitycourse_noise — no outercourse noise here, it's purely metal-on-metal.
	if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED) || HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用[user_device]顶磨[target]的[target_device]，每一次来回都让尖刺在两侧拖刮勾扯。"))
		user.sexcon.perform_sex_action(user, 0.6, 2.2, TRUE)
		user.sexcon.perform_sex_action(target, 0.6, 2.2, TRUE)
		user.sexcon.try_do_pain_scream(user, 2.2)
		user.sexcon.try_do_pain_scream(target, 2.2)
		user.sexcon.handle_passive_ejaculation(target)
		target.sexcon.handle_passive_ejaculation(user)
		return
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用[user_device]狠狠磨蹭[target]的[target_device]，钢铁相擦的声响又响又粗暴……"))
	user.sexcon.perform_sex_action(user, 1, 1, TRUE)
	user.sexcon.perform_sex_action(target, 1, 1, TRUE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/frot_cage_to_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]后退一步，两件装置在最后一声金属刮擦中分开了。"))

/datum/sex_action/chastityplay/frot_cage_to_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
