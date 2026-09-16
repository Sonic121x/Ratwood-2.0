/datum/sex_action/chastityplay/cockcage_to_belt
	name = "用贞操笼顶住贞操带"
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT
	target_needs_chastity = TRUE
	user_sex_part = SEX_PART_COCK
	user_needs_chastity = TRUE

/datum/sex_action/chastityplay/cockcage_to_belt/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]逼近[target]，直到[user.p_their()]的贞操笼严丝合缝地顶上[target.p_their()]那条上锁的贞操带。"))

/datum/sex_action/chastityplay/cockcage_to_belt/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] grinds [user.p_their()] cage against [target]'s belt, the slow steel-on-steel drag loud enough to make nearby people wince..."))
	// Chastity device sound is handled internally by perform_sex_action via chastitycourse_noise — no outercourse noise here, it's purely metal-on-metal.

	user.sexcon.perform_sex_action(user, 1.1, 1, TRUE)
	user.sexcon.perform_sex_action(target, 1.1, 1, TRUE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cockcage_to_belt/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]向后退开，两件装置伴着最后一声刺耳的金属刮响分离开来。"))

/datum/sex_action/chastityplay/cockcage_to_belt/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
