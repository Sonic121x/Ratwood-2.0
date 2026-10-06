/datum/surgery/rogue_revival
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/infuse_lux,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/infuse_lux
	name = "Infuse Lux"
	implements = list(
		/obj/item/reagent_containers/lux = 80,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 10 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/infuse_lux/validate_target(mob/user, mob/living/carbon/target, target_zone, datum/intent/intent)
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

/datum/surgery_step/infuse_lux/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始复活[target]……对方的心脏会回应吗？"),
		span_notice("[user]开始将灵辉注入[target]的心脏。"),
		span_notice("[user]开始将灵辉注入[target]的心脏。"))
	return TRUE

/datum/surgery_step/infuse_lux/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/revive_pq = PQ_GAIN_REVIVE
	if(target.mob_biotypes & MOB_UNDEAD)
		display_results(user, target, span_notice("无法将生命注入不死者！必须先治愈腐化。"),
			"[user]将灵辉注入[target]的脏腑。",
			"[user]将灵辉注入[target]的脏腑。")
		return FALSE
	if(istype(user, /mob/living)) 
		var/mob/living/LU = user
		var/excomm_found = FALSE
		for(var/excomm_name in GLOB.excommunicated_players)
			var/clean_excomm = LOWER_TEXT(trim(excomm_name))
			var/clean_target = LOWER_TEXT(trim(target.real_name))
			if(clean_excomm == clean_target)
				excomm_found = TRUE
				break
		if(ispath(LU.patron?.type, /datum/patron/divine) && excomm_found)
			display_results(user, target,
				span_warning("灵辉退缩了！内克拉不愿归还[target]的灵魂。"),
				"[user]尝试向[target]注入灵辉，却遭到了排斥。",
				"[user]尝试向[target]注入灵辉，却遭到了排斥。")
			target.visible_message(span_danger("[target]的身体剧烈抽搐，排斥着光芒！"), span_warning("情况很不对劲……"))
			return FALSE
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		display_results(user, target, span_notice("灵辉不愿与[target]的心脏融合。对方的伤势恐怕仍然太重。"),
			"[user]将灵辉注入[target]的脏腑，却没有任何反应。",
			"[user]将灵辉注入[target]的脏腑，却没有任何反应。")
		return FALSE
	var/mob/dead/observer/spirit = target.get_spirit()
	//GET OVER HERE!
	if(spirit)
		var/mob/dead/observer/ghost = spirit.ghostize()
		qdel(spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = FALSE)
	if (!target.mind.active)
		display_results(user, target, span_notice("[target]的心脏排斥灵辉。如今对方只愿沉浸于美梦。"),
			"[user]将灵辉注入[target]的脏腑，却没有任何反应。",
			"[user]将灵辉注入[target]的脏腑，却没有任何反应。")
		return FALSE
	display_results(user, target, span_notice("你注入灵辉，成功让[target]的心脏重新跳动。"),
		"[user]将灵辉注入[target]的脏腑。",
		"[user]将灵辉注入[target]的脏腑。")
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
	target.apply_status_effect(/datum/status_effect/debuff/revived)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
	return TRUE

/datum/surgery_step/infuse_lux/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("我搞砸了！"),
		span_warning("[user]搞砸了！"),
		span_notice("[user]将灵辉注入[target]的脏腑。"), TRUE)
	return TRUE
