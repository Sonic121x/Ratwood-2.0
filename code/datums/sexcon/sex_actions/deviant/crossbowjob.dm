/datum/sex_action/grind_crossbow
	name = "用弩托磨蹭对方"
	check_same_tile = FALSE

/datum/sex_action/grind_crossbow/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow))
		return FALSE
	return TRUE

/datum/sex_action/grind_crossbow/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !istype(held_item, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow))
		return FALSE
	return TRUE

/datum/sex_action/grind_crossbow/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始用自己的弩托磨蹭[target]的胯部……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/grind_crossbow/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user]用弩托[user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]磨蹭着[target]。"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.outercourse_noise()

	user.sexcon.perform_sex_action(target, 1, 4, TRUE)
	target.sexcon.handle_passive_ejaculation(target)
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE	

/datum/sex_action/grind_crossbow/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]移开了弩托……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/grind_crossbow/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
