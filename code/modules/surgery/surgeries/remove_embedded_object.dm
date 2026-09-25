/datum/surgery/embedded_removal
	name = "嵌入物取出术"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/remove_object,
	)

/datum/surgery_step/remove_object
	name = "取出嵌入物"
	implements = list(
		TOOL_HEMOSTAT = 80,
		TOOL_IMPROVISED_HEMOSTAT = 65,
		TOOL_HAND = 50,
	)
	time = 3.2 SECONDS
	accept_hand = TRUE
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_NOVICE
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/remove_object/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	. = ..()
	if(!.)
		return
	return length(bodypart.embedded_objects)

/datum/surgery_step/remove_object/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return
	return length(target.get_embedded_objects())

/datum/surgery_step/remove_object/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我寻找着嵌在[target]的[parse_zone(user.zone_selected)]里的异物……"),
		span_notice("[user]寻找着嵌在[target]的[parse_zone(user.zone_selected)]里的异物。"),
		span_notice("[user]在[target]的[parse_zone(user.zone_selected)]里寻找着什么。"))
	return TRUE

/datum/surgery_step/remove_object/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	var/objects = 0
	if(bodypart)
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			objects++
			bodypart.remove_embedded_object(embedded)
	for(var/obj/item/embedded as anything in target.simple_embedded_objects)
		objects++
		target.simple_remove_embedded_object(embedded)

	var/s = (objects > 1 ? "件异物" : "件异物")
	if(objects > 0)
		display_results(user, target, span_notice("我成功从[target]的[bodypart]中取出了[objects][s]。"),
			span_notice("[user]成功从[target]的[bodypart]中取出了[objects][s]！"),
			span_notice("[user]成功从[target]的[bodypart]中取出了[objects][s]！"))
	else if(bodypart)
		to_chat(user, span_warning("我没有在[target]的[bodypart]里找到嵌入的异物！"))
	else
		to_chat(user, span_warning("我没有在[target]体内找到嵌入的异物！"))
	return TRUE
