
/datum/surgery/cure_rot
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/burn_rot,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/burn_rot
	name = "烧除腐败"
	implements = list(
		TOOL_CAUTERY = 85,
		/obj/item/clothing/neck/roguetown/psicross = 85,
		TOOL_WELDER = 70,
		TOOL_HOT = 35,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 8 SECONDS
	surgery_flags = SURGERY_INCISED
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_APPRENTICE
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/burn_rot/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始烧除[target]体内的腐败……"),
		span_notice("[user]开始烧除[target]心脏中的腐败。"),
		span_notice("[user]开始烧除[target]心脏中的腐败。"))
	return TRUE

// calls the remove_rot which is shared with the pestra prayer to remove rot
/datum/surgery_step/burn_rot/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/burndam = 20
	var/stinky = FALSE
	if(user.mind)
		var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
		burndam -= (medskill * 2)
		if(medskill > SKILL_LEVEL_EXPERT)
			burndam = 0

	var/datum/antagonist/zombie/was_zombie = get_deadite_antag_for_body(target)
	var/fully_turned = was_zombie?.has_turned //Make sure someone hasn't yet turned before we knock them dead
	if(target.infected == FALSE)
		if(target.stat == DEAD || fully_turned)
			target.death()	//Kills the target if they are a zombie as a fail-safe.
			var/datum/component/rot/rot = target.GetComponent(/datum/component/rot)
			if(rot && rot.amount && rot.amount >= 5 MINUTES)	//Fail-safe to make sure the dead person has at least rotted for ~5 min.
				stinky = TRUE				

	if(remove_rot(target = target, user = user, method = "surgery", damage = burndam,
		success_message = "你烧除了[target]体内的腐败。",
		fail_message = "手术未能清除腐败。"))
		target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it. (It's perma for zombies, NEEDS to be removed on de-zombify)
		if(stinky)
			target.apply_status_effect(/datum/status_effect/debuff/rotted)			//Temp debuff, needs cure - adds this on surgery.

		display_results(user, target, span_notice("你烧除了[target]体内的腐败。"),
		"[user]烧除了[target]体内的腐败。",
		"[user]用[tool]处理[target]的内脏。")
		return TRUE
	return TRUE
