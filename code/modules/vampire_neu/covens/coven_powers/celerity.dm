/datum/coven/celerity
	name = "迅捷"
	desc = "提升你的速度。使用会违反避世戒律。"
	icon_state = "celerity"
	power_type = /datum/coven_power/celerity

/datum/coven_power/celerity
	name = "Celerity power name"
	desc = "Celerity power description"
	grouped_powers = list(
		/datum/coven_power/celerity/one,
		/datum/coven_power/celerity/two,
		/datum/coven_power/celerity/three,
		/datum/coven_power/celerity/four,
		/datum/coven_power/celerity/five,
	)
	var/multiplicative_slowdown = -0.1

/datum/coven_power/celerity/activate(atom/target)
	. = ..()
	if(!.)
		return
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = src.multiplicative_slowdown)
	owner.apply_status_effect(/datum/status_effect/buff/celerity, level)
	if(level > 2)
		owner.AddComponent(/datum/component/after_image)
		playsound(owner, 'sound/magic/timeforward.ogg', 40, TRUE)
		owner.visible_message(span_warning("[owner]开始以非人的速度移动，每个动作都化作残影！"))
		if(level > 3)
			ADD_TRAIT(owner, TRAIT_LEAPER, VAMPIRE_TRAIT)
		if(level > 4)
			ADD_TRAIT(owner, TRAIT_DODGEEXPERT, VAMPIRE_TRAIT)

/datum/coven_power/celerity/deactivate(atom/target, direct)
	. = ..()
	qdel(owner.GetComponent(/datum/component/after_image))
	owner.remove_status_effect(/datum/status_effect/buff/celerity)
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)
	if(level > 2)
		playsound(owner, 'sound/magic/timestop.ogg', 40, TRUE)
		if(level > 3)
			REMOVE_TRAIT(owner, TRAIT_LEAPER, VAMPIRE_TRAIT)
		if(level > 4)
			REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, VAMPIRE_TRAIT)

//CELERITY 1
/datum/coven_power/celerity/one
	name = "迅捷 1"
	desc = "提升你的速度，让行动轻松一些。"

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.15

//CELERITY 2

/datum/coven_power/celerity/two
	name = "迅捷 2"
	desc = "显著提升你的速度与反应能力。"

	level = 2
	research_cost = 1
	vitae_cost = 55
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.2

//CELERITY 3
/datum/coven_power/celerity/three
	name = "迅捷 3"
	desc = "行动更快，反应更迅速。你的身体尽在掌控之中。"

	level = 3
	research_cost = 2
	vitae_cost = 60
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.25

//CELERITY 4
/datum/coven_power/celerity/four
	name = "迅捷 4"
	desc = "突破人类的极限，如闪电般行动。"

	level = 4
	research_cost = 3
	vitae_cost = 65
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.3

//CELERITY 5
/datum/coven_power/celerity/five
	name = "迅捷 5"
	desc = "你如光芒一般，疾驰穿行于世间。"

	level = 5
	research_cost = 4
	vitae_cost = 70
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.35
