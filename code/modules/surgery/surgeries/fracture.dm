/datum/surgery/fix_bone
	name = "骨折复位"
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(
		BODY_ZONE_PRECISE_SKULL,
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/set_bone,
		/datum/surgery_step/cauterize,
	)

/datum/surgery_step/set_bone
	name = "复位断骨"
	time = 6.4 SECONDS
	accept_hand = TRUE
	implements = list(
		TOOL_BONESETTER = 80,
		TOOL_HAND = 40,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_BROKEN
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/set_bone/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	. = ..()
	if(!.)
		return
	var/can_set = FALSE
	for(var/datum/wound/fracture/bone in bodypart.wounds)
		can_set ||= bone.can_set
	if(!can_set)
		to_chat(user, span_warning("[target]的[parse_zone(target_zone)]已没有需要复位的骨折。"))
	return can_set

/datum/surgery_step/set_bone/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始为[target]的[parse_zone(target_zone)]复位断骨……"),
		span_notice("[user]开始为[target]的[parse_zone(target_zone)]复位断骨。"),
		span_notice("[user]开始为[target]的[parse_zone(target_zone)]复位断骨。"))
	return TRUE

/datum/surgery_step/set_bone/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我成功为[target]的[parse_zone(target_zone)]复位了断骨，现在还需休养才能完全愈合。"),
		span_notice("[user]成功为[target]的[parse_zone(target_zone)]复位了断骨！"),
		span_notice("[user]成功为[target]的[parse_zone(target_zone)]复位了断骨！"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		for(var/datum/wound/fracture/bone in bodypart.wounds)
			bone.set_bone()
	return TRUE
