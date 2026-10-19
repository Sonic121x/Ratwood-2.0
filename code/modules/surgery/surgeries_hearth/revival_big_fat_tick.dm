/datum/surgery/rogue_revival_with_a_big_fat_tick
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/infuse_tick,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/infuse_tick
	name = "注入水蛭蜱"
	implements = list(
		/obj/item/leechtick_bloated = 80,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 10 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN
	skill_min = SKILL_LEVEL_APPRENTICE
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/infuse_tick/validate_target(mob/user, mob/living/carbon/target, target_zone, datum/intent/intent)
	. = ..()
	if(target.stat < DEAD)
		to_chat(user, "对方还没死！")
		return FALSE
	var/obj/item/organ/heart/H = target.getorganslot(ORGAN_SLOT_HEART)
	if(!H)
		to_chat(user, "[target]没有心脏！")
		return FALSE
	if(!target.check_revive(user))
		return FALSE

/datum/surgery_step/infuse_tick/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始复活[target]……对方的心脏会回应吗？"),
		span_notice("[user]开始将水蛭蜱注入[target]的心脏。"),
		span_notice("[user]开始将水蛭蜱注入[target]的心脏。"))
	return TRUE

/datum/surgery_step/infuse_tick/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/revive_pq = PQ_GAIN_REVIVE
	if(target.mob_biotypes & MOB_UNDEAD)
		display_results(user, target, span_notice("无法将生命注入不死者！必须先治愈腐化。"),
			"[user]将水蛭蜱注入[target]的脏腑。",
			"[user]将水蛭蜱注入[target]的脏腑。")
		return FALSE
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE)
	if(!target.mind.active)
		to_chat(user, "内克拉还不愿放开[target]。")
		return
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		display_results(user, target, span_notice("水蛭蜱不愿与[target]的心脏融合。对方的伤势恐怕仍然太重。"),
			"[user]将水蛭蜱注入[target]的脏腑，却没有任何反应。",
			"[user]将水蛭蜱注入[target]的脏腑，却没有任何反应。")
		return FALSE
	display_results(user, target, span_notice("你注入水蛭蜱的内脏，成功让[target]的心脏重新跳动。"),
		"[user]将水蛭蜱注入[target]的脏腑。",
		"[user]将水蛭蜱注入[target]的脏腑。")
	target.emote("breathgasp")
	target.Jitter(100)
	record_round_statistic(STATS_LUX_REVIVALS)
	target.update_body()
	target.visible_message(span_notice("[target]被从内克拉的掌中拉回！"), span_green("我从虚无中醒来。"))
	qdel(tool)
	if(target.mind)
		if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
			adjust_playerquality(revive_pq, user.ckey)
			ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
	target.apply_status_effect(/datum/status_effect/debuff/leech_schizophrenia)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
	return TRUE

/datum/surgery_step/infuse_tick/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("我搞砸了！"),
		span_warning("[user]搞砸了！"),
		span_notice("[user]将水蛭蜱注入[target]的脏腑，发出令人作呕的挤压声。"), TRUE)
	return TRUE
