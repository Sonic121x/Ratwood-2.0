/// CONSTRUCT VERSIONS OF SURGERIES

/// Incision
/datum/surgery_step/incise/construct
	name = "揭开外壳"
	surgery_flags = SURGERY_CONSTRUCT
	surgery_flags_blocked = SURGERY_INCISED
	skill_used = /datum/skill/craft/engineering

/datum/surgery_step/incise/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始在[target]的[parse_zone(target_zone)]上开口……"),
		span_notice("[user]开始在[target]的[parse_zone(target_zone)]上开口。"),
		span_notice("[user]开始在[target]的[parse_zone(target_zone)]上开口。"))
	return TRUE

/datum/surgery_step/incise/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("[target]的[parse_zone(target_zone)]被打开，露出了下一层结构。"),
		span_notice("[target]的[parse_zone(target_zone)]被打开，露出了内部结构。"))
	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.add_wound(/datum/wound/slash/incision/construct)
	return TRUE

/// Clamping
/datum/surgery_step/clamp/construct
	name = "固定齿轮"
	surgery_flags = SURGERY_CONSTRUCT
	surgery_flags_blocked = SURGERY_CLAMPED
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null

/datum/surgery_step/clamp/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始固定[target][parse_zone(target_zone)]中的齿轮……"),
		span_notice("[user]开始固定[target][parse_zone(target_zone)]中的齿轮。"),
		span_notice("[user]开始固定[target][parse_zone(target_zone)]中的齿轮。"))
	return TRUE

/datum/surgery_step/clamp/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我固定了[target][parse_zone(target_zone)]中的齿轮。"),
		span_notice("[user]固定了[target][parse_zone(target_zone)]中的齿轮。"),
		span_notice("[user]固定了[target][parse_zone(target_zone)]中的齿轮。"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_embedded_object(tool, crit_message = FALSE)
	return TRUE

/// Retracting
/datum/surgery_step/retract/construct
	name = "打开内舱"
	surgery_flags = SURGERY_CONSTRUCT
	surgery_flags_blocked = SURGERY_RETRACTED
	skill_used = /datum/skill/craft/engineering

/datum/surgery_step/retract/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	return ..()

/datum/surgery_step/retract/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	return ..()

/// Cauterizing -- Nothing, cautery doesn't affect them.

/// Saw bone
/datum/surgery_step/saw/construct
	name = "锯开支撑结构"
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_CONSTRUCT
	surgery_flags_blocked = SURGERY_BROKEN
	skill_used = /datum/skill/craft/engineering

/datum/surgery_step/saw/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始锯开[target][parse_zone(target_zone)]中的支撑结构……"),
		span_notice("[user]开始锯开[target][parse_zone(target_zone)]中的支撑结构。"),
		span_notice("[user]开始锯开[target][parse_zone(target_zone)]中的支撑结构。"))
	return TRUE

/datum/surgery_step/saw/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我锯开了[target]的[parse_zone(target_zone)]。"),
		span_notice("[user]锯开了[target]的[parse_zone(target_zone)]！"),
		span_notice("[user]锯开了[target]的[parse_zone(target_zone)]！"))
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
		bodypart.add_wound(fracture_type)
	return TRUE

/// Drill bone
/datum/surgery_step/drill/construct
	name = "钻开内部结构"
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_CONSTRUCT
	surgery_flags_blocked = SURGERY_BROKEN
	skill_used = /datum/skill/craft/engineering

/datum/surgery_step/drill/construct/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return ..()

/datum/surgery_step/drill/construct/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("我钻开了[target]的[parse_zone(target_zone)]。"),
		span_notice("[user]钻开了[target]的[parse_zone(target_zone)]！"),
		span_notice("[user]钻开了[target]的[parse_zone(target_zone)]！"))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_wound(/datum/wound/puncture/drilling)
	return TRUE

/// Extract lux (Kills dah construct btw)

/datum/surgery_step/extract_lux/construct
	surgery_flags_blocked = null
	surgery_flags = SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN | SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering

/datum/surgery_step/extract_lux/construct/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始从[target]的核心中提取灵辉……这似乎不是个好主意。"),
		span_notice("[user]开始从[target]的核心中提取灵辉。"),
		span_notice("[user]开始从[target]的核心中提取灵辉。"))
	return TRUE

/datum/surgery_step/extract_lux/construct/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("你从[target]的核心中提取出一份灵辉，导致其死亡。"),
		"[user]从[target]体内提取出灵辉，导致其死亡。",
		"[user]从[target]体内提取出灵辉，导致其死亡。")
	new /obj/item/reagent_containers/lux(target.loc)
	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
	record_round_statistic(STATS_LUX_HARVESTED)
	target.death()
	target.emote(message = "全身僵住，核心低沉的嗡鸣逐渐消失，最终如雕像般一动不动。", forced = TRUE)
	return TRUE

/// Reshape face.
/datum/surgery_step/reshape_face/construct // Just doing this so they can have their own surgery. Doesn't change anything.
	surgery_flags = SURGERY_CONSTRUCT | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED
	surgery_flags_blocked = null
	skill_used = /datum/skill/craft/engineering

/// Set Bones
/datum/surgery_step/set_bone/construct
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_BROKEN | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/// Manipulate Organs
/datum/surgery_step/manipulate_organs/construct
	name = "调整内部组件"
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/// Mold organs
/datum/surgery_step/make_organs/construct
	name = "塑造辅助组件"
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/datum/surgery_step/amputate/construct
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_INCISED | SURGERY_BROKEN | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/datum/surgery_step/relocate_bone/construct
	name = "重新固定内部支撑结构"
	skill_used = /datum/skill/craft/engineering
	surgery_flags = SURGERY_DISLOCATED | SURGERY_CONSTRUCT
	surgery_flags_blocked = null

/datum/surgery_step/remove_external_organs/construct
	surgery_flags = SURGERY_INCISED | SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null

/datum/surgery_step/add_prosthetic/construct
	surgery_flags = SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null

/datum/surgery_step/remove_prosthetic/construct
	surgery_flags = SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null

/datum/surgery_step/infuse_lux/construct
	surgery_flags = SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN | SURGERY_CONSTRUCT
	skill_used = /datum/skill/craft/engineering
	surgery_flags_blocked = null
