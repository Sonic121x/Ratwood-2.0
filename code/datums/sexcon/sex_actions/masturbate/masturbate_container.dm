/datum/sex_action/masturbate_container
	name = "对着容器撸动阴茎"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_COCK
	solo = TRUE

/datum/sex_action/masturbate_container/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	var/holding = user.get_active_held_item()
	if(istype(holding, /obj/item/reagent_containers/glass) != TRUE)
		return FALSE
	return TRUE

/datum/sex_action/masturbate_container/cunt
	name = "对着容器揉弄女阴"
	user_sex_part = SEX_PART_CUNT

/datum/sex_action/masturbate_container/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始对着[user.get_active_held_item()]自慰……"))

/datum/sex_action/masturbate_container/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/container_name = user.get_active_held_item()
	if(!container_name)
		container_name = "容器"
	var/chosen_verb = pick(list("对着\the [container_name]取悦着自己", "隔着\the [container_name]色情地揉弄着自己", "对着\the [container_name]自慰"))

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [chosen_verb]."))

	user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)

	user.sexcon.handle_container_ejaculation()

/datum/sex_action/masturbate_container/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了对着容器自慰的动作。"))

/datum/sex_action/masturbate_container/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
