/datum/surgery/extract_lux
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/extract_lux,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/extract_lux
	name = "提取灵辉"
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_IMPROVISED_SCALPEL = 45,
		TOOL_SHARP = 30,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 8 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/extract_lux/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "对方已经死了！")
		return FALSE

/datum/surgery_step/extract_lux/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始从[target]的心脏上刮取灵辉……"),
		span_notice("[user]开始从[target]的心脏上刮取灵辉。"),
		span_notice("[user]开始从[target]的心脏上刮取灵辉。"))
	return TRUE

/datum/surgery_step/extract_lux/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if (!target.has_status_effect(/datum/status_effect/buff/ozium))
		target.emote("painscream")
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || target.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped))
		display_results(user, target, span_notice("你无法从[target]身上提取灵辉，对方已经没有灵辉可供提取了。"),
		"[user]从[target]体内提取灵辉。",
		"[user]从[target]体内提取灵辉。")
		return FALSE
	else
		display_results(user, target, span_notice("你从[target]的心脏中提取出一份灵辉。"),
			"[user]从[target]体内提取灵辉。",
			"[user]从[target]体内提取灵辉。")
		new /obj/item/reagent_containers/lux_impure(target.loc)
		SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
		//record_featured_stat(FEATURED_STATS_CRIMINALS, user)	- This.. isn't normally criminal.
		record_round_statistic(STATS_LUX_HARVESTED)
		target.apply_status_effect(/datum/status_effect/debuff/devitalised)
	return TRUE
