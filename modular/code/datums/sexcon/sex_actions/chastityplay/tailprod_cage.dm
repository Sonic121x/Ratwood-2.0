/datum/sex_action/chastityplay/tailprod_cage
	name = "用尾巴拨弄对方的贞操笼"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_TAIL
	target_sex_part = SEX_PART_COCK
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/tailprod_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]的尾巴低低扫过，缠上[target]的[get_chastity_device_name(target)]，感受着那装置的分量。"))

/datum/sex_action/chastityplay/tailprod_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]让[user.p_their()]的尾巴沿着[target]的[get_chastity_device_name(target)]缓缓缠绕摩挲，尾尖耐心而熟练地压进栅栏之间的缝隙……"))
	user.sexcon.perform_sex_action(target, 1.3, 2, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/tailprod_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]的尾巴从[target]的[get_chastity_device_name(target)]上松开，任其垂落下来。"))

/datum/sex_action/chastityplay/tailprod_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
