/datum/sex_action/force_footjob
	name = "拿对方的脚来发泄"
	check_same_tile = FALSE
	require_grab = TRUE
	stamina_cost = 1.0
	target_sex_part = SEX_PART_FEET
	user_sex_part = SEX_PART_COCK
	user_needs_functional = TRUE

/datum/sex_action/force_footjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]抓住[target]的双脚，强行夹住了[user.p_their()]肉棒！"))

/datum/sex_action/force_footjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]拿[target]的双脚套弄起自己。"))
	user.sexcon.outercourse_noise(target)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)
	user.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/force_footjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]肉棒从[target]双脚之间抽了出来。"))
