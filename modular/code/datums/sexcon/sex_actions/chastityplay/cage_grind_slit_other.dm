/datum/sex_action/chastityplay/cage_grind_slit_other
	name = "用你的贞操笼磨蹭对方生殖缝"
	user_sex_part = SEX_PART_COCK
	user_needs_chastity = TRUE
	target_sex_part = SEX_PART_SLIT_SHEATH
	target_needs_functional = TRUE

/datum/sex_action/chastityplay/cage_grind_slit_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
	if(penis.sheath_type != SHEATH_TYPE_SLIT)
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/cage_grind_slit_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
	if(penis.sheath_type != SHEATH_TYPE_SLIT)
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/cage_grind_slit_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]向前贴近，直到[user.p_their()]的[get_chastity_device_name(user)]贴上[target]紧闭的生殖缝。"))

/datum/sex_action/chastityplay/cage_grind_slit_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]缓慢而不肯停歇地用[user.p_their()]的[get_chastity_device_name(user)]磨蹭[target]的生殖缝……"))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(user, 1.2, 1, TRUE)
	user.sexcon.perform_sex_action(target, 1.6, 0, TRUE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_grind_slit_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]向后摇开，让[user.p_their()]的[get_chastity_device_name(user)]与[target]的生殖缝分离。"))

/datum/sex_action/chastityplay/cage_grind_slit_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
