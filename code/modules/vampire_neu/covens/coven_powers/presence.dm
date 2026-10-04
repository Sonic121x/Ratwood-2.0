/datum/coven/presence
	name = "威仪"
	desc = "让范围内的目标更容易受到伤害。"
	icon_state = "presence"
	power_type = /datum/coven_power/presence

/datum/coven_power/presence
	name = "Presence power name"
	desc = "Presence power description"

//AWE
/datum/coven_power/presence/awe
	name = "敬慕"
	desc = "让周围的人仰慕你，并渴望靠近你。"
	gif = "Awe.gif"

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	vitae_cost = 150
	range = 4
	multi_activate = TRUE
	cooldown_length = 2 MINUTES

/datum/coven_power/presence/awe/pre_activation_checks(mob/living/target)
	. = ..()
	if(!.)
		return FALSE

	if(!isliving(target))
		return FALSE

	if(target.is_clanmate(owner))
		to_chat(owner, span_warning("你不会像驱使牲畜那样迫使自己的氏族屈服。"))
		return FALSE

	var/mypower = owner.STAINT
	var/theirpower = target.STAINT - 5
	if((theirpower >= mypower))
		to_chat(owner, span_warning("[target]的意志太强大，无法动摇！"))
		return FALSE

	return TRUE

/datum/coven_power/presence/awe/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	target.create_walk_to(2 SECONDS, owner)

	if(!owner.cmode)
		to_chat(target, "<span class='userlove'><b>跟我来~</b></span>")
		owner.say("跟我来~")
	else
		to_chat(target, "<span class='userlove'><b>过来</b></span>")
		owner.say("过来！！")


/datum/coven_power/presence/awe/deactivate(mob/living/carbon/human/target, direct = FALSE)
	. = ..()
	target?.remove_overlay(MUTATIONS_LAYER)

//DREAD GAZE
/datum/coven_power/presence/dread_gaze
	name = "恐惧凝视"
	desc = "仅凭言语与目光便让他人心生恐惧。"

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 4
	vitae_cost = 150

	multi_activate = TRUE
	cooldown_length = 2 MINUTES

/datum/coven_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	to_chat(target, "<span class='userlove'><b>畏惧我吧</b></span>")
	owner.say("畏惧我吧！！")
	var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
	for(var/i in 1 to 15)
		addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
	target.emote("scream")
	target.do_jitter_animation(2 SECONDS)

/datum/coven_power/presence/dread_gaze/deactivate(mob/living/carbon/human/target, direct = FALSE)
	. = ..()
	target?.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/human/proc/step_away_caster(mob/living/step_from)
	walk(src, 0)
	if(can_frenzy_move())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_away(src, step_from, 99)

/datum/coven_power/presence/fall
	name = "跪伏"
	desc = "让他人在你面前跪下。"

	level = 3
	research_cost = 2
	vitae_cost = 300
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 4

	multi_activate = TRUE
	cooldown_length = 2 MINUTES

/datum/coven_power/presence/fall/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	target.Immobilize(2 SECONDS)
	to_chat(target, "<span class='userlove'><b>跪下</b></span>")
	owner.say("跪下！！")
	target.set_resting(TRUE, TRUE)

/datum/coven_power/presence/fall/deactivate(mob/living/carbon/human/target, direct = FALSE)
	. = ..()
	target?.remove_overlay(MUTATIONS_LAYER)

//SUMMON
/datum/coven_power/presence/summon
	name = "召来"
	desc = "与朋友保持亲近，与敌人更加亲近。将目标传送到你身边。"

	level = 4
	research_cost = 3
	vitae_cost = 300
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 2 MINUTES

/datum/coven_power/presence/summon/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	to_chat(target, "<span class='userlove'><b>到我身边来</b></span>")
	owner.say("到我身边来！！")
	target.Immobilize(1.5 SECONDS)
	new /obj/effect/temp_visual/vamp_summon (get_turf(target))
	new /obj/effect/temp_visual/vamp_summon/end (get_turf(owner))
	addtimer(CALLBACK(src, PROC_REF(finish_teleport), owner, target, get_turf(owner)), 1.5 SECONDS)

/datum/coven_power/presence/summon/proc/finish_teleport(mob/living/user, mob/living/target, turf/target_turf)
	// Teleport subordinate to user
	if(target_turf)
		new /obj/effect/temp_visual/vamp_teleport(get_turf(target))
		target.forceMove(target_turf)

		// Messages
		to_chat(user, "<span class='notice'>你将[target.real_name]召到了身边。</span>")
		to_chat(target, "<span class='userdanger'>你被迫出现在[user.real_name]面前！</span>")

		// Announce to nearby clan members
		for(var/mob/living/carbon/human/observer in view(7, user))
			if(observer.is_clanmate(user) && observer != user && observer != target)
				to_chat(observer, "<span class='info'>[user.real_name]召来了[target.real_name]。</span>")

/datum/coven_power/presence/summon/deactivate(mob/living/carbon/human/target, direct = FALSE)
	. = ..()
	target?.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/human/proc/step_toward_caster(mob/living/step_to)
	walk(src, 0)
	if(can_frenzy_move())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_towards(src, step_to, 99)

//MAJESTY
/datum/coven_power/presence/majesty
	name = "王者威严"
	desc = "展现至高的威严，让他人几乎无法违抗或伤害你。"

	level = 5
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	vitae_cost = 35
	toggled = TRUE
	cooldown_length = 90 SECONDS
	duration_length = 5 SECONDS
	var/list/affected_mobs = list() // Track who's affected by majesty

/datum/coven_power/presence/majesty/activate()
	. = ..()
	if(!.)
		return FALSE

	owner.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	owner.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	owner.apply_overlay(MUTATIONS_LAYER)

	owner.apply_status_effect(/datum/status_effect/majesty_active)

	var/list/nearby_mobs = range(7, owner)
	for(var/mob/living/M in nearby_mobs)
		if(M == owner || !can_affect_target(M))
			continue
		apply_majesty_effect(M)

	to_chat(owner, "<span class='notice'>你散发出绝对权威与尊贵的气场，让他人不由自主地服从。</span>")
	owner.visible_message("<span class='warning'>[owner]变得威严无比，令人敬畏！</span>", "<span class='notice'>你感到自己的威仪令人无法抗拒。</span>")

/datum/coven_power/presence/majesty/on_refresh()
	var/list/nearby_mobs = range(7, owner)
	var/list/checked_mobs = list()
	for(var/mob/living/M in nearby_mobs)
		checked_mobs |= M
		if(M == owner || !can_affect_target(M))
			continue
		apply_majesty_effect(M)

	for(var/mob/living/mob in affected_mobs)
		if(!(mob in checked_mobs))
			remove_majesty_effect(mob)
			affected_mobs -= mob

/datum/coven_power/presence/majesty/deactivate(mob/living/carbon/human/target, direct = FALSE)
	. = ..()
	owner.remove_overlay(MUTATIONS_LAYER)
	owner.remove_status_effect(/datum/status_effect/majesty_active)

	for(var/mob/living/M in affected_mobs)
		remove_majesty_effect(M)
	affected_mobs.Cut()

	to_chat(owner, "<span class='notice'>你那令人无法抗拒的威仪消退了。</span>")

/datum/coven_power/presence/majesty/proc/can_affect_target(mob/living/target)
	if(!istype(target))
		return FALSE
	if(target.stat == DEAD)
		return FALSE
	if(target.is_clanmate(owner))
		return FALSE
	if(target in affected_mobs)
		return FALSE
	return TRUE

/datum/coven_power/presence/majesty/proc/apply_majesty_effect(mob/living/target)
	if(!can_affect_target(target))
		return

	affected_mobs |= target
	target.apply_status_effect(/datum/status_effect/majesty_compulsion, owner)

	if(prob(70))
		if(target.get_active_held_item())
			target.visible_message("<span class='warning'>[target]似乎被[owner]的威仪震慑了！</span>")
			target.dropItemToGround(target.get_active_held_item())

		target.stop_pulling()
		if(target.cmode)
			target.cmode = FALSE

/datum/coven_power/presence/majesty/proc/remove_majesty_effect(mob/living/target)
	if(!target)
		return
	target.remove_status_effect(/datum/status_effect/majesty_compulsion)

/datum/status_effect/majesty_active
	id = "majesty_active"
	duration = -1
	alert_type = null

/datum/status_effect/majesty_active/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))

/datum/status_effect/majesty_active/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_PARENT_ATTACKBY))

/datum/status_effect/majesty_active/proc/on_attackby(atom/source, obj/item/attacking_item, mob/living/user, params)
	SIGNAL_HANDLER

	if(!user || user == source)
		return

	if(!user.has_status_effect(/datum/status_effect/majesty_compulsion))
		return

	if(prob(60))
		to_chat(user, "<span class='warning'>你发现自己根本无法下手伤害[source]！对方的威势太过强大！</span>")
		to_chat(source, "<span class='notice'>[user]被你的威严震慑，犹豫不决。</span>")
		return COMPONENT_NO_AFTERATTACK

/datum/status_effect/majesty_compulsion
	id = "majesty_compulsion"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/majesty_compulsion
	var/mob/living/majesty_user

/datum/status_effect/majesty_compulsion/on_creation(mob/living/new_owner, mob/living/user)
	majesty_user = user
	to_chat(new_owner, span_cultbigbold("你受到一股强大威势的压制，几乎无法做出任何违抗对方的举动。"))
	return ..()

/datum/status_effect/majesty_compulsion/on_apply()
	. = ..()
	if(!majesty_user)
		return FALSE

	RegisterSignal(owner, COMSIG_ITEM_PRE_ATTACK, PROC_REF(on_pre_attack))
	//RegisterSignal(owner, COMSIG_ITEM_PRE_ATTACK_SECONDARY, PROC_REF(on_pre_attack_secondary))
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(on_say))

	//the compulsion has no duration of its own, so it has to die with whoever cast it
	RegisterSignal(majesty_user, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH), PROC_REF(on_majesty_user_gone))

	if(owner.mind)
		owner.add_stress(/datum/stressevent/majesty_compelled)

/datum/status_effect/majesty_compulsion/on_remove()
	. = ..()
	UnregisterSignal(owner, list(
		COMSIG_ITEM_PRE_ATTACK,
		//COMSIG_ITEM_PRE_ATTACK_SECONDARY,
		COMSIG_MOB_SAY
	))

	if(majesty_user)
		UnregisterSignal(majesty_user, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH))
		majesty_user = null

	if(owner.mind)
		owner.remove_stress(/datum/stressevent/majesty_compelled)

/datum/status_effect/majesty_compulsion/proc/on_majesty_user_gone()
	SIGNAL_HANDLER

	to_chat(owner, span_notice("那股强大的威势终于不再压制你了。"))
	qdel(src)

/datum/status_effect/majesty_compulsion/proc/on_pre_attack(obj/item/source, atom/target, mob/user, params)
	SIGNAL_HANDLER

	if(target != majesty_user || user != owner)
		return

	if(prob(80))
		to_chat(user, "<span class='warning'>你无法下手攻击[majesty_user]！对方的威势太过强大！</span>")
		return COMPONENT_NO_ATTACK

/datum/status_effect/majesty_compulsion/proc/on_pre_attack_secondary(obj/item/source, atom/target, mob/user, params)
	SIGNAL_HANDLER

	if(target != majesty_user || user != owner)
		return

	if(prob(80))
		to_chat(user, "<span class='warning'>你无法下手攻击[majesty_user]！对方的威势太过强大！</span>")
		return FALSE
	//	COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN

/datum/status_effect/majesty_compulsion/proc/on_say(mob/source, list/speech_args)
	SIGNAL_HANDLER

	if(!majesty_user)
		return

	var/message = speech_args[SPEECH_MESSAGE]

	if(findtext(message, majesty_user.name) && (findtext(message, "fuck") || findtext(message, "shit") || findtext(message, "damn") || findtext(message, "kill") || findtext(message, "attack")))
		if(prob(70))
			to_chat(source, "<span class='warning'>话语卡在你的喉咙里。你无法说出[majesty_user]的坏话！</span>")
			speech_args[SPEECH_MESSAGE] = ""

/atom/movable/screen/alert/status_effect/majesty_compulsion
	name = "威势震慑"
	desc = "你受到一股强大威势的压制，几乎无法做出任何违抗对方的举动。"
	icon_state = "debuff"

/datum/stressevent/majesty_compelled
	desc = "这里有人的威势如此强大，我在对方身边几乎无法清醒地思考。"
	stressadd = -3
