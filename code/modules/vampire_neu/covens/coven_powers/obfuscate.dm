#define COMBAT_COOLDOWN_LENGTH 45 SECONDS
#define REVEAL_COOLDOWN_LENGTH 15 SECONDS
#define OBFUSCATE_ALPHA 10
#define OBFUSCATE_FADE_TIME 0.5 SECONDS

/datum/coven/obfuscate
	name = "隐匿"
	desc = "让活物与不死生物更难察觉你的存在。"
	icon_state = "obfuscate"
	power_type = /datum/coven_power/obfuscate

/datum/coven_power/obfuscate
	name = "Obfuscate power name"
	desc = "Obfuscate power description"
	duration_length = 0.5 MINUTES

	var/static/list/aggressive_signals = list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_ATOM_HITBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACKBY,
	)

/datum/coven_power/obfuscate/proc/on_combat_signal(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("你暴露了自己，隐匿效果随之消散！"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE)

/datum/coven_power/obfuscate/proc/conceal(mob/living/target)
	if (!target)
		return

	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(on_concealed_death), override = TRUE)
	animate(target, alpha = OBFUSCATE_ALPHA, time = OBFUSCATE_FADE_TIME)

/datum/coven_power/obfuscate/proc/unconceal(mob/living/target)
	if (!target)
		return

	UnregisterSignal(target, COMSIG_LIVING_DEATH)
	animate(target, alpha = initial(target.alpha), time = OBFUSCATE_FADE_TIME)

/datum/coven_power/obfuscate/proc/on_concealed_death(mob/living/source)
	SIGNAL_HANDLER

	if (source == owner)
		try_deactivate(direct = TRUE)
	else
		unconceal(source)

/datum/coven_power/obfuscate/proc/true_conceal(mob/living/target)
	if (!target)
		return

	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(on_concealed_death), override = TRUE)
	target.apply_status_effect(/datum/status_effect/buff/obfuscate_veil)

/datum/coven_power/obfuscate/proc/true_unconceal(mob/living/target)
	if (!target)
		return

	UnregisterSignal(target, COMSIG_LIVING_DEATH)
	target.remove_status_effect(/datum/status_effect/buff/obfuscate_veil)

/datum/coven_power/obfuscate/proc/is_seen_check()
	for (var/mob/living/viewer in oviewers(7, owner))
		//cats cannot stop you from Obfuscating
		if (!istype(viewer, /mob/living/carbon) && !viewer.client)
			continue

		//the corpses are not watching you
		if (HAS_TRAIT(viewer, TRAIT_BLIND) || viewer.stat >= UNCONSCIOUS)
			continue

		if (owner.is_clanmate(viewer))
			continue

		to_chat(owner, span_warning("被他人注视时，你无法使用[src]！"))
		return FALSE

	return TRUE

//CLOAK OF SHADOWS - Basic stealth, broken by movement
/datum/coven_power/obfuscate/cloak_of_shadows
	name = "暗影斗篷"
	desc = "融入阴影，只要不引起注意便能隐匿身形。任何移动都会破坏效果。"

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 25
	research_cost = 0

	toggled = TRUE

/datum/coven_power/obfuscate/cloak_of_shadows/pre_activation_checks()
	. = ..()
	if(!.)
		return FALSE
	return is_seen_check()

/datum/coven_power/obfuscate/cloak_of_shadows/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	true_conceal(owner)

/datum/coven_power/obfuscate/cloak_of_shadows/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	true_unconceal(owner)

/datum/coven_power/obfuscate/cloak_of_shadows/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("你离开了原位，[src]的效果随之消散！"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//UNSEEN PRESENCE - Can move while stealthed, but only walking speed
/datum/coven_power/obfuscate/unseen_presence
	name = "无形之影"
	desc = "穿行于人群之中而不被察觉。行走时保持隐形。"

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 25

	toggled = TRUE

/datum/coven_power/obfuscate/unseen_presence/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, TRAIT_GENERIC)
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	true_conceal(owner)

/datum/coven_power/obfuscate/unseen_presence/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, TRAIT_GENERIC)
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	true_unconceal(owner)

/datum/coven_power/obfuscate/unseen_presence/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	if (owner.m_intent == MOVE_INTENT_RUN)
		to_chat(owner, span_danger("你移动得太快，[src]的效果随之消散！"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//VANISH FROM THE MIND'S EYE - Instant stealth activation + memory wipe
/datum/coven_power/obfuscate/vanish_from_the_minds_eye
	name = "抹去心影"
	desc = "瞬间从众目睽睽之下消失，并抹去他人近期记忆中你的身影。"

	level = 3
	research_cost = 2
	vitae_cost = 100
	check_flags = COVEN_CHECK_CAPABLE

	toggled = TRUE

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, TRAIT_GENERIC)
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	true_conceal(owner)

	// Memory wipe effect - make nearby people forget they saw you
	for(var/mob/living/carbon/human/viewer in oviewers(7, owner))
		if(viewer.client && viewer.stat < UNCONSCIOUS && !viewer.is_immune_to_vampire_domination())
			to_chat(viewer, span_hypnophrase("<span style='font-size: 200%; text-shadow: 0 0 8px #ffffff;'>等等……刚才这里不是有人吗？不，一定是我的错觉……</span>"))
			to_chat(viewer, span_hypnophrase("<span style='font-size: 80%; text-shadow: 0 0 6px #ffffff;'>你忘记了自己曾看见[owner]。</span>"))
			// Could add more memory effects here like removing recent chat logs mentioning the user

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, TRAIT_GENERIC)
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	true_unconceal(owner)

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	if (owner.m_intent == MOVE_INTENT_RUN)
		to_chat(owner, span_danger("你移动得太快，[src]的效果随之消散！"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//CLOAK THE GATHERING - Group stealth for multiple people
/datum/coven_power/obfuscate/cloak_the_gathering
	name = "群影之幕"
	desc = "隐去小范围内自己与他人的身形。附近所有盟友都会隐形。"

	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 150

	toggled = TRUE

	var/list/cloaked_mobs = list()

/datum/coven_power/obfuscate/cloak_the_gathering/pre_activation_checks()
	. = ..()
	if(!.)
		return FALSE
	return is_seen_check()

/datum/coven_power/obfuscate/cloak_the_gathering/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	conceal(owner)
	cloaked_mobs = list(owner)

	// Cloak nearby Clan - the veil is not extended to cattle or rivals
	for(var/mob/living/target in oviewers(3, owner))
		if(target.stat >= UNCONSCIOUS)
			continue
		if(!target.is_clanmate(owner))
			continue

		conceal(target)
		cloaked_mobs += target
		to_chat(target, span_notice("你感到一层超自然的帷幕笼罩了自己……"))
		RegisterSignal(target, aggressive_signals, PROC_REF(on_ally_combat_signal), override = TRUE)

	to_chat(owner, span_notice("你将隐匿帷幕延伸至附近的[length(cloaked_mobs) - 1]名盟友身上。"))

/datum/coven_power/obfuscate/cloak_the_gathering/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	// Restore visibility to all cloaked mobs
	for(var/mob/living/target in cloaked_mobs)
		unconceal(target)
		UnregisterSignal(target, aggressive_signals)
		if(target != owner)
			to_chat(target, span_warning("超自然的帷幕消散了……"))

	cloaked_mobs.Cut()

/datum/coven_power/obfuscate/cloak_the_gathering/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("你离开了原位，[src]的效果随之消散！"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

/datum/coven_power/obfuscate/cloak_the_gathering/proc/on_ally_combat_signal(datum/source)
	SIGNAL_HANDLER

	var/mob/living/ally = source
	to_chat(ally, span_danger("你的举动打破了超自然的帷幕！"))

	// Remove this ally from the cloak
	unconceal(ally)
	UnregisterSignal(ally, aggressive_signals)
	cloaked_mobs -= ally

/datum/coven_power/obfuscate/cloak_the_gathering/on_concealed_death(mob/living/source)

	cloaked_mobs -= source
	return ..()

#undef COMBAT_COOLDOWN_LENGTH
#undef REVEAL_COOLDOWN_LENGTH
#undef OBFUSCATE_ALPHA
#undef OBFUSCATE_FADE_TIME
