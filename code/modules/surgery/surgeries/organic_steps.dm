//BASIC SURGERY STEPS

/// Incision
/datum/surgery_step/incise
	name = "切开"
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
	) // 60% success with any sharp item.
	target_mobtypes = list(/mob/living/carbon/human)
	time = 1.6 SECONDS
	surgery_flags = SURGERY_BLOODY
	surgery_flags_blocked = SURGERY_INCISED | SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_APPRENTICE
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/incise/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始在[target]的[parse_zone(target_zone)]上切开一道口子……"),
		span_notice("[user]开始在[target]的[parse_zone(target_zone)]上切开一道口子。"),
		span_notice("[user]开始在[target]的[parse_zone(target_zone)]上切开一道口子。"))
	return TRUE

/datum/surgery_step/incise/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("鲜血在[target][parse_zone(target_zone)]的切口周围积聚。"),
		span_notice("鲜血在[target][parse_zone(target_zone)]的切口周围积聚。"))
	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.add_wound(/datum/wound/slash/incision)
	return TRUE

/// Clamping
/datum/surgery_step/clamp
	name = "钳夹止血"
	implements = list(
		TOOL_HEMOSTAT = 75,
		TOOL_WIRECUTTER = 60,
		TOOL_IMPROVISED_HEMOSTAT = 38,
	)
	time = 2.4 SECONDS
	surgery_flags_blocked = SURGERY_CLAMPED | SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN
	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/clamp/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始夹住[target][parse_zone(target_zone)]上的出血点……"),
		span_notice("[user]开始夹住[target][parse_zone(target_zone)]上的出血点。"),
		span_notice("[user]开始夹住[target][parse_zone(target_zone)]上的出血点。"))
	return TRUE

/datum/surgery_step/clamp/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我夹住了[target][parse_zone(target_zone)]上的出血点。"),
		span_notice("[user]夹住了[target][parse_zone(target_zone)]上的出血点。"),
		span_notice("[user]夹住了[target][parse_zone(target_zone)]上的出血点。"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_embedded_object(tool, crit_message = FALSE)
	return TRUE

/// Retracting
/datum/surgery_step/retract
	name = "撑开切口"
	implements = list(
		TOOL_RETRACTOR = 75,
		TOOL_SCREWDRIVER = 50,
		TOOL_WIRECUTTER = 35,
		TOOL_IMPROVISED_RETRACTOR = 38,
	)
	time = 2.4 SECONDS
	surgery_flags_blocked = SURGERY_RETRACTED | SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN
	preop_sound = 'sound/surgery/retractor1.ogg'

/datum/surgery_step/retract/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始撑开[target][parse_zone(target_zone)]上的切口……"),
		span_notice("[user]开始撑开[target][parse_zone(target_zone)]上的切口。"),
		span_notice("[user]开始撑开[target][parse_zone(target_zone)]上的切口。"))
	return TRUE

/datum/surgery_step/retract/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我撑开了[target][parse_zone(target_zone)]上的切口。"),
		span_notice("[user]撑开了[target][parse_zone(target_zone)]上的切口。"),
		span_notice("[user]撑开了[target][parse_zone(target_zone)]上的切口。"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_embedded_object(tool, crit_message = FALSE)
	return TRUE

/// Cauterize
/datum/surgery_step/cauterize
	name = "烧灼伤口"
	implements = list(
		TOOL_CAUTERY = 100,
		TOOL_WELDER = 70,
		TOOL_HOT = 35,
	)
	time = 2.4 SECONDS
	surgery_flags = SURGERY_BLOODY
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_APPRENTICE
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/cauterize/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	// If you have medicine expert, you can caut thru armor. Also fails if they're in cmode.
	if(islist(user.status_traits) && ("Medicine Expert" in user.status_traits) && (target.cmode == 0)) 
		ignore_clothes = TRUE
	else // IDK if this is necessary but probably good 4 clarification.
		ignore_clothes = FALSE

	. = ..()
	if(!.)
		return
	return length(bodypart.wounds)

/datum/surgery_step/cauterize/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始烧灼[target][parse_zone(target_zone)]上的伤口……"),
		span_notice("[user]开始烧灼[target][parse_zone(target_zone)]上的伤口。"),
		span_notice("[user]开始烧灼[target][parse_zone(target_zone)]上的伤口。"))
	return TRUE

/datum/surgery_step/cauterize/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我烧灼了[target][parse_zone(target_zone)]上的伤口。"),
		span_notice("[user]烧灼了[target][parse_zone(target_zone)]上的伤口。"),
		span_notice("[user]烧灼了[target][parse_zone(target_zone)]上的伤口。"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		for(var/datum/wound/bleeder in bodypart.wounds)
			bleeder.cauterize_wound()
		bodypart.receive_damage(burn = 25) //painful, but the wounds go away eh?
	if (target.has_status_effect(/datum/status_effect/buff/ozium))
		target.emote ("groan")
	if (!target.has_status_effect(/datum/status_effect/buff/ozium))
		target.emote("scream")
	return TRUE

/// Saw bone
/datum/surgery_step/saw
	name = "锯开骨骼"
	implements = list(
		TOOL_SAW = 80,
		TOOL_SHOVEL = 50,
		TOOL_SHARP = 25,
	)
	possible_locs = list(
		BODY_ZONE_PRECISE_SKULL,
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_NECK,
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
	time = 5 SECONDS
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED
	surgery_flags_blocked = SURGERY_BROKEN | SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/saw/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始锯开[target][parse_zone(target_zone)]的骨骼……"),
		span_notice("[user]开始锯开[target][parse_zone(target_zone)]的骨骼。"),
		span_notice("[user]开始锯开[target][parse_zone(target_zone)]的骨骼。"))
	return TRUE

/datum/surgery_step/saw/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我锯开了[target][parse_zone(target_zone)]的骨骼。"),
		span_notice("[user]锯开了[target][parse_zone(target_zone)]的骨骼！"),
		span_notice("[user]锯开了[target][parse_zone(target_zone)]的骨骼！"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		var/fracture_type = /datum/wound/fracture
		//yes we ignore crit resist here because this is a proper surgical procedure, not a crit
		switch(bodypart.body_zone)
			if(BODY_ZONE_HEAD)
				fracture_type = /datum/wound/fracture/head
			if(BODY_ZONE_PRECISE_NECK)
				fracture_type = /datum/wound/fracture/neck
			if(BODY_ZONE_CHEST)
				fracture_type = /datum/wound/fracture/chest
			if(BODY_ZONE_PRECISE_GROIN)
				fracture_type = /datum/wound/fracture/groin
		if (target.has_status_effect(/datum/status_effect/buff/ozium))
			target.emote ("groan")
		bodypart.add_wound(fracture_type)
	return TRUE

/// Drill bone
/datum/surgery_step/drill
	name = "钻开骨骼"
	implements = list(
		TOOL_DRILL = 80,
		TOOL_SCREWDRIVER = 25,
	)
	time = 3 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_RETRACTED
	surgery_flags_blocked = SURGERY_BROKEN | SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/drill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("我开始钻开[target][parse_zone(target_zone)]的骨骼……"),
		span_notice("[user]开始钻开[target][parse_zone(target_zone)]的骨骼。"),
		span_notice("[user]开始钻开[target][parse_zone(target_zone)]的骨骼。"))
	return TRUE

/datum/surgery_step/drill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("我钻开了[target][parse_zone(target_zone)]的骨骼。"),
		span_notice("[user]钻开了[target][parse_zone(target_zone)]的骨骼！"),
		span_notice("[user]钻开了[target][parse_zone(target_zone)]的骨骼！"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_wound(/datum/wound/puncture/drilling)
	target.emote("scream")
	return TRUE
