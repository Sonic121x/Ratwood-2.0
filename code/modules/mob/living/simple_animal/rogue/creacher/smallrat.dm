///For the Nosferatu Vampire Lord transformationn
/mob/living/simple_animal/hostile/retaliate/smallrat
	name = "老鼠"
	desc = ""
	icon_state = "srat"
	icon = 'icons/roguetown/mob/monster/rat.dmi'
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("吱吱叫")
	speak_chance = 1
	maxHealth = 15
	health = 15
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_verb_continuous = "咬"
	attack_verb_simple = "咬"
	response_help_continuous = "抚摸"
	response_help_simple = "抚摸"
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	faction = list("hostile")
	attack_sound = 'sound/blank.ogg'
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY

	var/stepped_sound = 'sound/blank.ogg'
