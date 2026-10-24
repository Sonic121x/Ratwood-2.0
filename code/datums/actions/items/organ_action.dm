/datum/action/item_action/organ_action
	name = "器官动作"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/organ_action/IsAvailable()
	var/obj/item/organ/attached_organ = target
	if(!attached_organ.owner)
		return FALSE
	return ..()

/datum/action/item_action/organ_action/toggle
	name = "切换器官"

/datum/action/item_action/organ_action/toggle/New(Target)
	..()
	var/obj/item/organ/organ_target = target
	name = "切换[organ_target.name]"

/datum/action/item_action/organ_action/use
	name = "使用器官"

/datum/action/item_action/organ_action/use/New(Target)
	..()
	var/obj/item/organ/organ_target = target
	name = "使用[organ_target.name]"
