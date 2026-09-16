/datum/sex_action/armpit_nuzzle
	name = "蹭弄对方腋下"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_CHEST

/datum/sex_action/armpit_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的脑袋凑向了[target]的腋下……"))

/datum/sex_action/armpit_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]蹭弄着[target]的腋下……"))

/datum/sex_action/armpit_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了蹭弄[target]腋下的动作……"))
