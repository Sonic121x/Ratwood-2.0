/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog
	name = "沼泽巨魔"
	desc = "精灵传说中，这些怪物曾是登多尔的仆从，奉命守护其领域。如今它们有时会与兽人为伍。据说火焰能抑制它们近乎魔法的再生之力。"
	pixel_x = -16

	wander = FALSE		// bog trolls are ambush predators
	turns_per_move = 4
	see_in_dark = 10

	melee_damage_lower = 30
	melee_damage_upper = 50
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES

	STACON = 16
	STASTR = 16
	STASPD = 3
	STAWIL = 15

	defprob = 30
	dodgetime = 15

/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)	// bogtroll does not mind kneestingers

/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog/after_creation()
	..()
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/nightmare
	eyes.Insert(src)
