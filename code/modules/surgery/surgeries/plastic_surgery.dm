/datum/surgery/plastic_surgery
	name = "整容手术"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/reshape_face,
		/datum/surgery_step/cauterize,
	)
	possible_locs = list(BODY_ZONE_HEAD)

/// Reshape face
/datum/surgery_step/reshape_face
	name = "重塑面容"
	implements = list(
		TOOL_SCALPEL = 70,
		TOOL_IMPROVISED_SCALPEL = 50,
		TOOL_WIRECUTTER = 50,
		TOOL_SHARP = 35,
	)
	possible_locs = list(BODY_ZONE_HEAD)
	time = 6.4 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/reshape_face/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始改变[target]的容貌……"),
		span_notice("[user]开始改变[target]的容貌。"),
		span_notice("[user]开始在[target]的脸上切开一道口子。"))
	return TRUE

/datum/surgery_step/reshape_face/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart?.has_wound(/datum/wound/facial/disfigurement))
		display_results(user, target, span_notice("我成功恢复了[target]的容貌。"),
			span_notice("[user]成功恢复了[target]的容貌！"),
			span_notice("[user]完成了[target]面部的手术。"))
		bodypart.remove_wound(/datum/wound/facial/disfigurement)
	else
		var/list/names = list("自定义……")
		names += target.dna.species.random_name(target.gender, TRUE)
		var/chosen_name = input(user, "选择一个新名字。", "整容手术") as null|anything in names
		if(chosen_name == "自定义……")
			chosen_name = input(user, "叫什么名字？", "整容手术")
		chosen_name = reject_bad_name(chosen_name)
		if(!chosen_name)
			return
		var/oldname = target.real_name
		target.real_name = chosen_name
		display_results(user, target, span_notice("我彻底改变了[oldname]的容貌，现在对方是[target.real_name]了。"),
			span_notice("[user]彻底改变了[oldname]的容貌，现在对方是[target.real_name]了！"),
			span_notice("[user]完成了[target]面部的手术。"))
	return TRUE

/datum/surgery_step/reshape_face/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("我失手了，毁了[target]的容貌！"),
		span_notice("[user]失手了，毁了[target]的容貌！"),
		span_notice("[user]完成了[target]面部的手术。"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_wound(/datum/wound/facial/disfigurement)
	target.emote("scream")
	return FALSE
