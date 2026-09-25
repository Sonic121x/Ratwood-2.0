/datum/surgery/prosthetic_replacement
	name = "肢体移植"
	steps = list(
		/datum/surgery_step/add_prosthetic,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
	)
	requires_bodypart = FALSE //need a missing limb
	requires_missing_bodypart = TRUE
	requires_bodypart_type = NONE

/datum/surgery_step/add_taur
	name = "移植兽形下身"
	implements = list(
		/obj/item/bodypart/taur = 80, 
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 3 SECONDS
	requires_bodypart = FALSE
	requires_missing_bodypart = FALSE
	requires_bodypart_type = NONE
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	visible_required_skill = TRUE

/datum/surgery_step/add_taur/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	var/obj/item/bodypart/left_leg = target.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/right_leg = target.get_bodypart(BODY_ZONE_R_LEG)
	
	// This already covers the taur case because both will be the taur tail
	if(left_leg || right_leg)
		return FALSE

	return ..()

/datum/surgery_step/add_taur/preop(mob/user, mob/living/target, target_zone, obj/item/bodypart/taur/bodypart, datum/intent/intent)
	target_zone = BODY_ZONE_TAUR

	if(bodypart.original_owner != target)
		if(target.has_status_effect(/datum/status_effect/buff/necras_vow) || HAS_TRAIT(target, TRAIT_NECRAS_VOW))	//Status effects are cleared upon death, just in case you want to... attach a permakilled corpse's limbs.
			to_chat(user, span_warning("此人已向内克拉立誓，筋肉排斥外来的血肉，必须使用其自身的血肉。"))
			return FALSE

	display_results(user, target, span_notice("我开始用[bodypart]替换[target]的[parse_zone(target_zone)]……"),
		span_notice("[user]开始用[bodypart]替换[target]的[parse_zone(target_zone)]。"),
		span_notice("[user]开始替换[target]的[parse_zone(target_zone)]。"))
	return TRUE

/datum/surgery_step/add_taur/success(mob/user, mob/living/target, target_zone, obj/item/bodypart/taur/bodypart, datum/intent/intent)
	target_zone = BODY_ZONE_TAUR

	if(bodypart.attach_limb(target) && bodypart.attach_wound)
		bodypart.add_wound(bodypart.attach_wound)
	display_results(user, target, span_notice("我成功为[target]移植了[parse_zone(target_zone)]。"),
		span_notice("[user]成功将[bodypart]移植到[target]的[parse_zone(target_zone)]处！"),
		span_notice("[user]成功为[target]移植了[parse_zone(target_zone)]！"))
	return TRUE

/datum/surgery_step/add_prosthetic
	name = "移植肢体"
	implements = list(
		/obj/item/bodypart = 80,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
	)
	time = 3 SECONDS
	requires_bodypart = FALSE //need a missing limb
	surgery_flags_blocked = SURGERY_CONSTRUCT
	requires_missing_bodypart = TRUE
	requires_bodypart_type = NONE
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	visible_required_skill = TRUE

/datum/surgery_step/add_prosthetic/tool_check(mob/user, obj/item/tool)
	// Use Implant taur instead, which actually works correctly
	if(istype(tool, /obj/item/bodypart/taur))
		return FALSE
	. = ..()

/datum/surgery_step/add_prosthetic/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = tool
	if(target_zone != bodypart.body_zone) //so we can't replace a leg with an arm, or a human arm with a monkey arm.
		to_chat(user, span_warning("[tool]的类型不适合替换[parse_zone(target_zone)]。"))
		return FALSE

	if(bodypart.original_owner != target)
		if(target.has_status_effect(/datum/status_effect/buff/necras_vow) || HAS_TRAIT(target, TRAIT_NECRAS_VOW))	//Status effects are cleared upon death, just in case you want to... attach a permakilled corpse's limbs.
			to_chat(user, span_warning("此人已向内克拉立誓，筋肉排斥外来的血肉，必须使用其自身的血肉。"))
			return FALSE

	// Dullahan-specific refusal should only apply when attaching a head
		if(isdullahan(target) && target_zone == BODY_ZONE_HEAD)
			to_chat(user, span_warning("身体正在排斥这颗头颅。"))
			return FALSE
		if(istype(bodypart, /obj/item/bodypart/head/dullahan))
			to_chat(user, span_warning("头颅正在排斥这具身体。"))
			return FALSE


	display_results(user, target, span_notice("我开始用[tool]替换[target]的[parse_zone(target_zone)]……"),
		span_notice("[user]开始用[tool]替换[target]的[parse_zone(target_zone)]。"),
		span_notice("[user]开始替换[target]的[parse_zone(target_zone)]。"))
	return TRUE

/datum/surgery_step/add_prosthetic/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = tool
	if(bodypart.attach_limb(target) && bodypart.attach_wound)
		bodypart.add_wound(bodypart.attach_wound)
	display_results(user, target, span_notice("我成功为[target]移植了[parse_zone(target_zone)]。"),
		span_notice("[user]成功将[tool]移植到[target]的[parse_zone(target_zone)]处！"),
		span_notice("[user]成功为[target]移植了[parse_zone(target_zone)]！"))
	return TRUE

/datum/surgery/prosthetic_removal
	name = "义肢移除术"
	steps = list(
		/datum/surgery_step/remove_prosthetic
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG
	)
	requires_bodypart = TRUE
	requires_bodypart_type = BODYPART_ROBOTIC

/datum/surgery_step/remove_prosthetic
	name = "移除义肢"
	implements = list(
		TOOL_SAW = 90,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG
	)
	time = 10 SECONDS
	requires_bodypart = TRUE
	requires_bodypart_type = BODYPART_ROBOTIC
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	surgery_flags = NONE
	preop_sound = 'sound/foley/sewflesh.ogg'
	success_sound = 'sound/items/wood_sharpen.ogg'
	visible_required_skill = TRUE


/datum/surgery_step/remove_prosthetic/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始锯断[target]的[parse_zone(target_zone)]义肢的基部……"),
		span_notice("[user]开始锯断[target]的[parse_zone(target_zone)]义肢的基部。"),
		span_notice("[user]开始锯断[target]的[parse_zone(target_zone)]义肢的基部。"))
	return TRUE

/datum/surgery_step/remove_prosthetic/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我锯断了[target]的[parse_zone(target_zone)]义肢的基部。"),
		span_notice("[user]锯断了[target]的[parse_zone(target_zone)]义肢的基部！"),
		span_notice("[user]锯断了[target]的[parse_zone(target_zone)]义肢的基部！"))
	var/obj/item/bodypart/target_limb = target.get_bodypart(check_zone(target_zone))
	target_limb?.drop_limb(TRUE)
	return TRUE
