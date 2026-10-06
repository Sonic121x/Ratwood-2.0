/// CPR
// Mouth to Mouth to fix oxygen loss.
// Target mouth on a person on the floor with help intent. If they are passed out from oxy-damage, you will start breathing air into their lungs.

/datum/surgery_step/mouth_to_mouth
	name = "口对口人工呼吸"

	possible_locs = list(BODY_ZONE_HEAD)
	time = 3 SECONDS
	accept_hand = TRUE
	accept_any_item = TRUE
	possible_intents = list(
		INTENT_HELP
	)
	possible_locs = list(
		BODY_ZONE_PRECISE_MOUTH
	)
	lying_required = TRUE
	self_operable = FALSE
	//Those skill levels mean a 40 to 60 chance to fail rate at NONE skill. Just enough to barely keep people from expiring.
	skill_min = SKILL_LEVEL_NONE
	skill_median = SKILL_LEVEL_APPRENTICE
	surgery_flags = NONE
	repeating = TRUE

	// How much oxy damage we heal per completion
	var/oxyhealing = 15

/datum/surgery_step/mouth_to_mouth/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return
	if(!((oxyhealing && target.getOxyLoss())))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_NOBREATH))
		to_chat(user, span_notice("我无法为对方做人工呼吸，我自己都不需要呼吸！"))	//Stops skeles and rotcured people from giving MTM.
		return FALSE


/datum/surgery_step/mouth_to_mouth/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我尝试向[target]的口中吹气。"),
			span_notice("[user]尝试向[target]的口中吹气。"),
			span_notice("[user]尝试向[target]的口中吹气。"))
	return TRUE

/datum/surgery_step/mouth_to_mouth/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("你成功向[target]的肺中吹入了一口气。"),
		"[user]向[target]吹入了一口气。",
		"[user]向[target]吹入了一口气。")
	target.adjustOxyLoss(-oxyhealing)
	return TRUE

/datum/surgery_step/mouth_to_mouth/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("我失败了！"),
		span_warning("[user]失败了！"),
		span_notice("[user]没能向[target]的肺中吹入空气。"), TRUE)
	return TRUE
