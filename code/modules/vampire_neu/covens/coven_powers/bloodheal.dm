#define HEAL_MULTIPLIER 3.8
/datum/coven/bloodheal
	name = "血愈"
	desc = "借助命髓的力量缓慢再生血肉。"
	icon_state = "bloodheal"
	power_type = /datum/coven_power/bloodheal
	max_level = 5
	experience_multiplier = 1.25
	clan_restricted = TRUE

/datum/coven_power/bloodheal
	name = "Bloodheal power name"
	desc = "Bloodheal power description"

	level = 1
	check_flags = COVEN_CHECK_TORPORED
	vitae_cost = 10
	toggled = TRUE
	cooldown_length = 30 SECONDS
	duration_length = 3 SECONDS

	violates_masquerade = FALSE

	grouped_powers = list(
		/datum/coven_power/bloodheal/one,
		/datum/coven_power/bloodheal/two,
		/datum/coven_power/bloodheal/three,
		/datum/coven_power/bloodheal/four,
		/datum/coven_power/bloodheal/five,
	)

/datum/coven_power/bloodheal/activate()
	. = ..()
	if(!.)
		return

	trigger_healing()

/datum/coven_power/bloodheal/on_refresh()
	trigger_healing()

/datum/coven_power/bloodheal/proc/trigger_healing()
	owner.adjustBruteLoss(-HEAL_MULTIPLIER * level, 0)
	owner.adjustFireLoss(-HEAL_MULTIPLIER * level, 0)
	owner.adjustOxyLoss(-HEAL_MULTIPLIER * level, 0)
	owner.adjustToxLoss(-HEAL_MULTIPLIER * level, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -HEAL_MULTIPLIER * level)
	owner.adjustCloneLoss(-HEAL_MULTIPLIER * level, 0)

	owner.heal_wounds(level * 5)

//BLOODHEAL 1
/datum/coven_power/bloodheal/one
	name = "初级血愈"
	desc = "利用命髓缓慢修复轻伤。"

	level = 1
	research_cost = 0
	vitae_cost = 5
	duration_length = 3 SECONDS
	violates_masquerade = FALSE
	research_cost = 0

//BLOODHEAL 2
/datum/coven_power/bloodheal/two
	name = "血愈"
	desc = "以稳定的速度修复伤口。"

	level = 2
	research_cost = 1
	vitae_cost = 8
	duration_length = 2 SECONDS
	violates_masquerade = FALSE

//BLOODHEAL 3
/datum/coven_power/bloodheal/three
	name = "迅速血愈"
	desc = "以肉眼可见的速度修复伤口。"

	level = 3
	research_cost = 2
	vitae_cost = 16
	duration_length = 1.5 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 4
/datum/coven_power/bloodheal/four
	name = "高级血愈"
	desc = "即使是重伤也能迅速再生。"

	level = 4
	research_cost = 3
	vitae_cost = 20
	duration_length = 1 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 5
/datum/coven_power/bloodheal/five
	name = "强效血愈"
	desc = "修复损伤并恢复受损的器官。"

	level = 5
	research_cost = 4
	vitae_cost = 30
	duration_length = 0.8 SECONDS
	violates_masquerade = TRUE

/datum/coven_power/bloodheal/five/trigger_healing()
	// Uses old heal multiplier
	owner.adjustBruteLoss(-4.5 * level, 0)
	owner.adjustFireLoss(-4.5 * level, 0)
	owner.adjustOxyLoss(-4.5 * level, 0)
	owner.adjustToxLoss(-4.5 * level, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -4.5 * level)
	owner.adjustCloneLoss(-4.5 * level, 0)

	owner.heal_wounds(level * 5)

#undef HEAL_MULTIPLIER
