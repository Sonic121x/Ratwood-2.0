/datum/surgery/bloodletting
	name = "排出毒素"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/cutvein,
		/datum/surgery_step/bloodlet,
	)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)
	target_mobtypes = list(/mob/living/carbon/human)


/datum/surgery_step/cutvein
	name = "切开静脉"
	implements = list(
		TOOL_SCALPEL = 75,
		TOOL_SHARP = 30,
	)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 5 SECONDS
	surgery_flags = SURGERY_CLAMPED
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/cutvein/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始切开[target][parse_zone(target_zone)]的静脉……"),
		span_notice("[user]开始切开[target][parse_zone(target_zone)]的静脉。"),
		span_notice("[user]开始切开[target][parse_zone(target_zone)]的静脉。"))
	return TRUE

/datum/surgery_step/cutvein/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("鲜血从[target][parse_zone(target_zone)]被切开的静脉中滴落。"),
		span_notice("鲜血从[target][parse_zone(target_zone)]被切开的静脉中滴落。"))
	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.add_wound(/datum/wound/slash/vein)
	return TRUE

/datum/surgery_step/bloodlet
	name = "排出污血"
	implements = list(
		TOOL_HAND = 80,
	)
	accept_hand = TRUE
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 6.4 SECONDS
	surgery_flags = SURGERY_CUTVEIN
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/organ1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/bloodlet/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始从[target][parse_zone(target_zone)]的静脉中挤出血液……"),
		span_notice("[user]开始从[target][parse_zone(target_zone)]的静脉中挤出血液！"),
		span_notice("[user]开始从[target][parse_zone(target_zone)]的静脉中挤出血液！"))
	return TRUE

/datum/surgery_step/bloodlet/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我从[target][parse_zone(target_zone)]的静脉中挤出血液。"),
		span_notice("[user]从[target][parse_zone(target_zone)]的静脉中挤出血液！"),
		span_notice("[user]从[target][parse_zone(target_zone)]的静脉中挤出血液！"))
	target.adjustToxLoss (-25, 0)
	target.adjust_blood_volume(-(50))
	return TRUE
