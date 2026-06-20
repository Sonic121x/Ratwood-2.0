/mob/living/simple_animal/hostile/retaliate/rogue/bigrat
	icon = 'icons/roguetown/mob/monster/bigrat.dmi'
	name = "巨鼠"
	desc = "这是一种长着红色小圆眼的大老鼠，被腐物和污秽所吸引。"
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat1"
	gender = MALE
	emote_hear = list("吱吱叫。")
	emote_see = list("清理着鼻子。")
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 5
	pixel_x = -16
	pixel_y = -8
	vision_range = 5
	aggro_vision_range = 9
	base_intents = list(/datum/intent/simple/bite/bigrat)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
							/obj/item/natural/hide = 1, 
							/obj/item/natural/bone = 2, 
							/obj/item/alch/sinew = 1, 
							/obj/item/alch/bone = 1, 
							/obj/item/alch/viscera = 1,
							/obj/item/natural/head/rous = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
							/obj/item/natural/hide = 1, 
							/obj/item/natural/bone = 2, 
							/obj/item/alch/sinew = 1, 
							/obj/item/alch/bone = 1, 
							/obj/item/alch/viscera = 1,
							/obj/item/natural/fur/rat = 1,
							/obj/item/natural/head/rous = 1)
	faction = list("rats")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_sound = 'sound/combat/wooshes/punch/punchwoosh (2).ogg'
	health = 65
	maxHealth = 65
	melee_damage_lower = 17
	melee_damage_upper = 21
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks, 
//					/obj/item/bodypart, 
//					/obj/item/organ, 
					/obj/item/natural/bone, 
					/obj/item/natural/hide)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 6
	STASTR = 9
	STASPD = 10
	deaggroprob = 0
	defprob = 40
	attack_same = 1
	retreat_health = 0.3
	aggressive = 1
	

	remains_type = /obj/effect/decal/remains/bigrat
	eat_forever = TRUE

//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/big_rat
	melee_cooldown = RAT_ATTACK_SPEED
	stat_attack = UNCONSCIOUS

/obj/effect/decal/remains/bigrat
	name = "遗骸"
	gender = PLURAL
	icon_state = "ratbones"
	icon = 'icons/roguetown/mob/monster/bigrat.dmi'
	pixel_x = -16
	pixel_y = -8

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/Initialize(mapload)
	. = ..()
	gender = MALE
	AddElement(/datum/element/ai_flee_while_injured, 0.75, 0.3)
	if(prob(33))
		gender = FEMALE
	if(gender == FEMALE)
		icon_state = "Frat"
		icon_living = "Frat"
		icon_dead = "Frat1"
	update_icon()
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)


/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/death(gibbed)
	..()
	update_icon()


/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		var/mutable_appearance/eye_lights = mutable_appearance(icon, "bigrat-eyes")
		eye_lights.plane = 19
		eye_lights.layer = 19
		add_overlay(eye_lights)

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/rat/aggro (1).ogg','sound/vo/mobs/rat/aggro (2).ogg','sound/vo/mobs/rat/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/rat/pain (1).ogg','sound/vo/mobs/rat/pain (2).ogg','sound/vo/mobs/rat/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/rat/death (1).ogg','sound/vo/mobs/rat/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_NOSE)
			return "鼻子"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "嘴"
		if(BODY_ZONE_PRECISE_SKULL)
			return "头部"
		if(BODY_ZONE_PRECISE_EARS)
			return "头部"
		if(BODY_ZONE_PRECISE_NECK)
			return "脖子"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "前腿"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "前腿"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "腿"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "腿"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "腹部"
		if(BODY_ZONE_PRECISE_GROIN)
			return "尾巴"
		if(BODY_ZONE_HEAD)
			return "头部"
		if(BODY_ZONE_R_LEG)
			return "腿"
		if(BODY_ZONE_L_LEG)
			return "腿"
		if(BODY_ZONE_R_ARM)
			return "前腿"
		if(BODY_ZONE_L_ARM)
			return "前腿"
	return ..()

/datum/intent/simple/bite/bigrat
	clickcd = RAT_ATTACK_SPEED
