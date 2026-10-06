/datum/coven/potence
	name = "巨力"
	desc = "提高近战与徒手攻击伤害。"
	icon_state = "potence"
	power_type = /datum/coven_power/potence

/datum/coven_power/potence
	name = "Potence power name"
	desc = "Potence power description"

	grouped_powers = list(
		/datum/coven_power/potence/one,
		/datum/coven_power/potence/two,
		/datum/coven_power/potence/three,
		/datum/coven_power/potence/four,
		/datum/coven_power/potence/five
	)

/datum/coven_power/potence/activate()
	. = ..()
	if(!.)
		return
	owner.dna.species.punch_damage += POTENCE_PUNCH_DAMAGE_PER_LEVEL * level
	owner.apply_status_effect(/datum/status_effect/buff/potence, level)
	if(level > 2)
		owner.visible_message(span_warning("[owner]绷紧肌肉，看起来强壮了许多！"))
		if(level > 3)
			ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, VAMPIRE_TRAIT)
			ADD_TRAIT(owner, TRAIT_ZJUMP, VAMPIRE_TRAIT)
			ADD_TRAIT(owner, TRAIT_NOFALLDAMAGE1, VAMPIRE_TRAIT)

/datum/coven_power/potence/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= POTENCE_PUNCH_DAMAGE_PER_LEVEL * level
	owner.remove_status_effect(/datum/status_effect/buff/potence)
	if(level > 2)
		owner.visible_message(span_warning("[owner]放松了身体。"))
		if(level > 3)
			REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, VAMPIRE_TRAIT)
			REMOVE_TRAIT(owner, TRAIT_ZJUMP, VAMPIRE_TRAIT)
			REMOVE_TRAIT(owner, TRAIT_NOFALLDAMAGE1, VAMPIRE_TRAIT)
//POTENCE 1
/datum/coven_power/potence/one
	name = "巨力一阶"
	desc = "强化你的肌肉，每一击都势大力沉。"

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

//POTENCE 2
/datum/coven_power/potence/two
	name = "巨力二阶"
	desc = "获得超越肌肉极限的力量，摧毁人和物。"

	level = 2
	research_cost = 1
	vitae_cost = 55
	check_flags = COVEN_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

//POTENCE 3
/datum/coven_power/potence/three
	name = "巨力三阶"
	desc = "化身毁灭之力，举起不可举之物，击碎不可碎之物。"

	level = 3
	research_cost = 2
	vitae_cost = 60
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

//POTENCE 4
/datum/coven_power/potence/four
	name = "巨力四阶"
	desc = "只要命髓尚存，你便是一具不屈的战争机器。"

	level = 4
	research_cost = 3
	vitae_cost = 65
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

//POTENCE 5
/datum/coven_power/potence/five
	name = "巨力五阶"
	desc = "若向世人展示这份力量，他们或许会奉你为神。"

	level = 5
	research_cost = 4
	vitae_cost = 70
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS
