/datum/surgery/augmentation
	name = "义体改造"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/replace_limb,
	)
	target_mobtypes = list(/mob/living/carbon/human)

/datum/surgery_step/replace_limb
	name = "替换肢体"
	implements = list(
		/obj/item/bodypart = 80,
	)
	time = 3.2 SECONDS
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_BROKEN
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/replace_limb/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/aug = tool
	if(!istype(aug) || aug.status != BODYPART_ROBOTIC)
		to_chat(user, span_warning("那可不是义体，笨蛋！"))
		return FALSE
	if(aug.body_zone != target_zone)
		to_chat(user, span_warning("[tool]的类型不适合替换[parse_zone(target_zone)]。"))
		return FALSE
	var/obj/item/bodypart/existing = target.get_bodypart(check_zone(target_zone))
	if(!existing)
		user.visible_message(span_notice("[user]寻找着[target]的[parse_zone(user.zone_selected)]。"),
							span_notice("我寻找着[target]的[parse_zone(user.zone_selected)]……"))
		return FALSE
	display_results(user, target, span_notice("我开始为[target]的[parse_zone(user.zone_selected)]进行义体改造……"),
		span_notice("[user]开始用[aug]替换[target]的[parse_zone(user.zone_selected)]。"),
		span_notice("[user]开始为[target]的[parse_zone(user.zone_selected)]进行义体改造。"))
	return TRUE

/datum/surgery_step/replace_limb/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/existing = target.get_bodypart(check_zone(target_zone))
	if(existing)
		var/obj/item/bodypart/bodypart = tool
		if(istype(bodypart) && user.temporarilyRemoveItemFromInventory(bodypart))
			if(bodypart.replace_limb(target, special = TRUE) && bodypart.attach_wound)
				bodypart.add_wound(bodypart.attach_wound)
		display_results(user, target, span_notice("我成功为[target]的[parse_zone(target_zone)]完成了义体改造。"),
			span_notice("[user]成功用[bodypart]替换了[target]的[parse_zone(target_zone)]！"),
			span_notice("[user]成功为[target]的[parse_zone(target_zone)]完成了义体改造！"))
		log_combat(user, target, "augmented", addition="by giving him new [parse_zone(target_zone)] INTENT: [uppertext(user.a_intent?.name)]")
	else
		to_chat(user, span_warning("[target]那里没有血肉构成的[parse_zone(target_zone)]！"))
	return TRUE
