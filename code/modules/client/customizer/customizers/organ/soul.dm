// What comes out of a Dullahan's neck, referred to as their soul.
/datum/customizer/organ/soul
	abstract_type = /datum/customizer/organ/soul
	name = "灵魂"

/datum/customizer_choice/organ/soul
	abstract_type = /datum/customizer_choice/organ/soul
	name = "灵魂"
	organ_type = /obj/item/organ/soul
	organ_slot = ORGAN_SLOT_SOUL


/datum/customizer/organ/soul/fire
	customizer_choices = list(/datum/customizer_choice/organ/soul/fire)
	default_choice = /datum/customizer_choice/organ/soul/fire

/datum/customizer_choice/organ/soul/fire
	name = "火焰"
	organ_type = /obj/item/organ/soul/fire
	sprite_accessories = list(
		/datum/sprite_accessory/soul/fire,
		)
