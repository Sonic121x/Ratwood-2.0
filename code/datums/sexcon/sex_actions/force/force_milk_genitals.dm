/datum/sex_action/force_milk_genitals
	name = "强行榨取下体"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	/// Target's genitals are being stimulated; set so modular_emit_received_sex_action_signal can resolve receiver_part.
	target_sex_part = SEX_PART_COCK

/datum/sex_action/force_milk_genitals/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return
	var/holding = user.get_active_held_item()
	if(!istype(holding, /obj/item/reagent_containers/glass))
		return FALSE
	return TRUE

/datum/sex_action/force_milk_genitals/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始隔着[user.get_active_held_item()]撸弄[target]的下体……"))

/datum/sex_action/force_milk_genitals/proc/get_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]把[target]的阴茎撸进[user.get_active_held_item()]里……")

/datum/sex_action/force_milk_genitals/proc/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user]停止了把[target]撸向容器。")

/datum/sex_action/force_milk_genitals/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(get_perform_message(user, target))
	user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)

	target.sexcon.handle_cock_milking(user)

/datum/sex_action/force_milk_genitals/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(get_finish_message(user, target))

/datum/sex_action/force_milk_genitals/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/force_milk_genitals/cunt
	name = "强行榨取小穴"
	target_sex_part = SEX_PART_CUNT

/datum/sex_action/force_milk_genitals/cunt/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user]停止了隔着容器抠弄[target]。")

/datum/sex_action/force_milk_genitals/cunt/get_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]隔着[user.get_active_held_item()]抠弄[target]的小穴……")
