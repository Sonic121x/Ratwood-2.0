/datum/surgery/healing
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/heal,
		/datum/surgery_step/cauterize,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/heal
	name = "修复身体"
	implements = list(
		TOOL_SUTURE = 80,
		TOOL_HEMOSTAT = 60,
		TOOL_IMPROVISED_HEMOSTAT = 50,
		TOOL_SCREWDRIVER = 50,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 4 SECONDS
	requires_tech = TRUE
	replaced_by = /datum/surgery_step
	repeating = TRUE
	repeatingonfail = TRUE
	surgery_flags = SURGERY_BLOODY | SURGERY_CLAMPED
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_APPRENTICE
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	/// How much brute damage we heal per completion
	var/brutehealing = 0
	/// How much burn damage we heal per completion
	var/burnhealing = 0
	/**
	 * Heals an extra point of damager per X missing damage of type (burn damage for burn healing, brute for brute)
	 * Smaller Number = More Healing!
	 */
	var/missinghpbonus = 0

/datum/surgery_step/heal/validate_tech(mob/user, mob/living/target, target_zone, datum/intent/intent)
	if(!brutehealing && !burnhealing)
		return FALSE
	return ..()

/datum/surgery_step/heal/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return
	if(!((brutehealing && target.getBruteLoss()) || (burnhealing && target.getFireLoss())))
		return FALSE

/datum/surgery_step/heal/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/woundtype
	if(brutehealing && burnhealing)
		woundtype = "伤口"
	else if(brutehealing)
		woundtype = "瘀伤"
	else //why are you trying to 0,0...?
		woundtype = "烧伤"
	display_results(user, target, span_notice("我尝试处理[target]的部分[woundtype]。"),
			span_notice("[user]尝试处理[target]的部分[woundtype]。"),
			span_notice("[user]尝试处理[target]的部分[woundtype]。"))
	return TRUE

/datum/surgery_step/heal/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/umsg = "你成功处理了[target]的部分伤口" //no period, add initial space to "addons"
	var/tmsg = "[user]处理了[target]的部分伤口" //see above
	var/healing_multiplier = 1
	switch(user.get_skill_level(skill_used))
		if(SKILL_LEVEL_JOURNEYMAN)
			healing_multiplier = 1.2
		if(SKILL_LEVEL_EXPERT)
			healing_multiplier = 1.4
		if(SKILL_LEVEL_MASTER)
			healing_multiplier = 1.7
		if(SKILL_LEVEL_LEGENDARY)
			healing_multiplier = 2
	var/urhealedamt_brute = brutehealing * healing_multiplier
	var/urhealedamt_burn = burnhealing * healing_multiplier
	if(missinghpbonus)
		if(target.stat != DEAD)
			urhealedamt_brute += round((target.getBruteLoss()/ missinghpbonus),0.1)
			urhealedamt_burn += round((target.getFireLoss()/ missinghpbonus),0.1)
	if(!get_location_accessible(target, target_zone))
		urhealedamt_brute *= 0.55
		urhealedamt_burn *= 0.55
		umsg += "，在对方穿着衣物的情况下尽力进行了治疗"
		tmsg += "，在[target]穿着衣物的情况下尽力进行了治疗"
	target.heal_bodypart_damage(urhealedamt_brute,urhealedamt_burn)
	display_results(user, target, span_notice("[umsg]."),
		"[tmsg].",
		"[tmsg].")
	target.update_damage_hud()
	return TRUE

/datum/surgery_step/heal/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("我失手了！"),
		span_warning("[user]失手了！"),
		span_notice("[user]处理了[target]的部分伤口。"), TRUE)
	var/urdamageamt_burn = brutehealing * 0.8
	var/urdamageamt_brute = burnhealing * 0.8
	if(missinghpbonus)
		urdamageamt_brute += round((target.getBruteLoss()/(missinghpbonus*2)),0.1)
		urdamageamt_burn += round((target.getFireLoss()/(missinghpbonus*2)),0.1)

	target.take_bodypart_damage(urdamageamt_brute, urdamageamt_burn)
	target.update_damage_hud()
	return TRUE

/********************BRUTE STEPS********************/
/datum/surgery_step/heal/brute/basic
	name = "处理瘀伤"
	brutehealing = 15
	missinghpbonus = 7
	requires_tech = FALSE
	replaced_by = /datum/surgery_step/heal/brute/upgraded

/datum/surgery_step/heal/brute/upgraded
	name = "处理瘀伤（高级）"
	brutehealing = 20
	missinghpbonus = 4
	requires_tech = TRUE
	replaced_by = /datum/surgery_step/heal/brute/upgraded/femto

/datum/surgery_step/heal/brute/upgraded/femto
	name = "处理瘀伤（实验级）"
	brutehealing = 20
	missinghpbonus = 2
	requires_tech = TRUE
	replaced_by = null

/********************BURN STEPS********************/
/datum/surgery_step/heal/burn/basic
	name = "处理烧伤"
	burnhealing = 15
	missinghpbonus = 7
	requires_tech = FALSE
	replaced_by = /datum/surgery_step/heal/burn/upgraded

/datum/surgery_step/heal/burn/upgraded
	name = "处理烧伤（高级）"
	burnhealing = 20
	missinghpbonus = 4
	requires_tech = TRUE
	replaced_by = /datum/surgery_step/heal/burn/upgraded/femto

/datum/surgery_step/heal/burn/upgraded/femto
	name = "处理烧伤（实验级）"
	burnhealing = 20
	missinghpbonus = 2
	requires_tech = TRUE
	replaced_by = null

/********************COMBO STEPS********************/
/datum/surgery_step/heal/combo
	name = "处理损伤"
	brutehealing = 7
	burnhealing = 7
	missinghpbonus = 7
	requires_tech = FALSE
	replaced_by = /datum/surgery_step/heal/combo/upgraded

/datum/surgery_step/heal/combo/upgraded
	name = "处理损伤（高级）"
	brutehealing = 7
	burnhealing = 7
	missinghpbonus = 4
	requires_tech = TRUE
	replaced_by = /datum/surgery_step/heal/combo/upgraded/femto

/datum/surgery_step/heal/combo/upgraded/femto
	name = "处理损伤（实验级）"
	brutehealing = 7
	burnhealing = 7
	missinghpbonus = 2
	requires_tech = TRUE
	replaced_by = null

/datum/surgery_step/heal/combo/upgraded/femto/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("我失手了！"),
		span_warning("[user]失手了！"),
		span_notice("[user]处理了[target]的部分伤口。"), TRUE)
	target.take_bodypart_damage(5,5)
	return TRUE
