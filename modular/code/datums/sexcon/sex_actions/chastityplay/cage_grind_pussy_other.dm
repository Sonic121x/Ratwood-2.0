/datum/sex_action/chastityplay/cage_grind_pussy_other
	name = "用你的贞操笼磨蹭对方阴部"
	user_sex_part = SEX_PART_COCK
	user_needs_chastity = TRUE
	target_sex_part = SEX_PART_CUNT
	target_needs_functional = TRUE

/datum/sex_action/chastityplay/cage_grind_pussy_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]前挺[user.p_their()]的腰，让[user.p_their()]的[get_chastity_device_name(user)]贴上[target]裸露的阴部。"))

/datum/sex_action/chastityplay/cage_grind_pussy_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]缓慢而刻意地用[user.p_their()]的贞操笼磨蹭[target]的阴部，栅栏温热地压着，却毫不退让……"))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(user, 1.2, 0, TRUE)
	user.sexcon.perform_sex_action(target, 1.7, 1, TRUE)
	user.sexcon.handle_passive_ejaculation()
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_grind_pussy_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]缓缓退开，[user.p_their()]的[get_chastity_device_name(user)]的金属从[target]身上抽离，发出最后一声刮擦。"))

/datum/sex_action/chastityplay/cage_grind_pussy_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
