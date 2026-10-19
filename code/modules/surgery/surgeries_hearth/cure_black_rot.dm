/datum/surgery/cure_black_rot
	name = "黑腐清除手术"
	desc = "切除黑腐并去除腐化根源的专门手术，极其危险。"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/extract_black_rose_residue,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/extract_black_rose_residue
	name = "切除黑腐"
	implements = list(
		TOOL_SCALPEL = 85,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 12 SECONDS
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/extract_black_rose_residue/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_userdanger("我小心地尝试从[target]的血肉中切除黑色黏液……"),
		span_userdanger("[user]小心地尝试从[target]的胸部切除黑色黏液。"),
		span_userdanger("[user]小心地尝试从[target]的胸部切除黑色黏液。"))
	return TRUE

/datum/surgery_step/extract_black_rose_residue/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(!target.has_status_effect(/datum/status_effect/black_rot))
		display_results(user, target, span_warning("患处已烧灼干净，未发现仍在蔓延的黑腐。"),
			"[user]烧灼了伤口。",
			"[user]烧灼了伤口。")
		return TRUE

	var/damage = 50
	var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
	damage -= (medskill * 6)
	damage = max(0, damage)
	target.adjustBruteLoss(damage)
	if(target.remove_status_effect(/datum/status_effect/black_rot))
		display_results(user, target, span_notice("黑腐的侵蚀消退了。"),
			"[user]完成了患处的净化，[target]血肉中的黑色消退了。",
			"[user]用[tool]烧灼并净化[target]的胸部。")
	else
		display_results(user, target, span_warning("热量未能清除残存的腐败！"),
			"[user]尝试烧灼伤口，但腐化仍顽固不退。",
			"[user]尝试烧灼伤口，但腐化仍顽固不退。")
	return TRUE
