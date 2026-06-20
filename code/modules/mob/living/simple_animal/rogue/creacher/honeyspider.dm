/mob/living/simple_animal/hostile/retaliate/rogue/spider
	icon = 'icons/roguetown/mob/monster/spider.dmi'
	name = "蜜蛛"
	icon_state = "honeys"
	icon_living = "honeys"
	icon_dead = "honeys-dead"
	gender = MALE
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 4
	vision_range = 5
	aggro_vision_range = 9
	base_intents = list(/datum/intent/simple/bite/honeyspider)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
							/obj/item/natural/silk = 2, 
							/obj/item/alch/viscera = 1,
							/obj/item/natural/head/honeyspider = 1)
	perfect_butcher_results = list (/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
							/obj/item/natural/silk = 3, 
							/obj/item/alch/viscera = 1, 
							/obj/item/natural/head/honeyspider = 1)
	faction = list("spiders")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_sound = 'sound/combat/wooshes/punch/punchwoosh (2).ogg'
	health = HONEYSPIDER_HEALTH
	maxHealth = HONEYSPIDER_HEALTH
	melee_damage_lower = 17
	melee_damage_upper = 21
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks/rogue/meat, 
					//obj/item/bodypart, 
					/obj/item/organ, 
					)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 6
	STASTR = 9
	STASPD = 10
	deaggroprob = 0
	defprob = 40
	attack_same = 0
	retreat_health = 0.3
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')
	aggressive = 1
	

	//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/spider
	melee_cooldown = HONEYSPIDER_ATTACK_SPEED
	stat_attack = UNCONSCIOUS

/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated
	icon = 'icons/roguetown/mob/monster/spider.dmi'
	name = "斯卡拉克斯蛛"
	icon_state = "skallax"
	icon_living = "skallax"
	icon_dead = "skallax-dead"
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
					/obj/item/natural/hide = 1)
	health = 130
	maxHealth = 130

/mob/living/simple_animal/hostile/retaliate/rogue/spider/Initialize(mapload)
	. = ..()
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_icon()
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)
	AddElement(/datum/element/ai_retaliate)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, INNATE_TRAIT)


/mob/living/simple_animal/hostile/retaliate/rogue/spider/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents)
			L.reagents.add_reagent(/datum/reagent/toxin/venom, 1)

/mob/living/simple_animal/hostile/retaliate/rogue/spider/death(gibbed)
	..()
	update_icon()


/mob/living/simple_animal/hostile/retaliate/rogue/spider/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		var/mutable_appearance/eye_lights = mutable_appearance(icon, "honeys-eyes")
		eye_lights.plane = 19
		eye_lights.layer = 19
		add_overlay(eye_lights)

/mob/living/simple_animal/hostile/retaliate/rogue/spider/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/spider/aggro (1).ogg','sound/vo/mobs/spider/aggro (2).ogg','sound/vo/mobs/spider/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/spider/pain.ogg')
		if("death")
			return pick('sound/vo/mobs/spider/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/spider/idle (1).ogg','sound/vo/mobs/spider/idle (2).ogg','sound/vo/mobs/spider/idle (3).ogg','sound/vo/mobs/spider/idle (4).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/spider/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/spider/Life()
	..()
	if(stat == CONSCIOUS)
		if(!target)
			if(production >= 100)
				production = 0
				visible_message(span_alertalien("[src]产出了一些蜂蜜。"))
				var/turf/T = get_turf(src)
				playsound(T, pick('sound/vo/mobs/spider/speak (1).ogg','sound/vo/mobs/spider/speak (2).ogg','sound/vo/mobs/spider/speak (3).ogg','sound/vo/mobs/spider/speak (4).ogg'), 100, TRUE, -1)
				new /obj/item/reagent_containers/food/snacks/rogue/honey/spider(T)
	if(pulledby && !tame)
		if(HAS_TRAIT(pulledby, TRAIT_WEBWALK))
			return
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/spider/simple_limb_hit(zone)
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
			return "腹部"
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

/datum/intent/simple/bite/honeyspider
	clickcd = HONEYSPIDER_ATTACK_SPEED




/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock
	icon_state = "spiderrock"
	icon_living = "spiderrock"
	icon_dead = "spiderrock-dead"
	name = "岩蛛"
	desc = "这些生于岩丘的野兽，习性与韧性皆与蜜蛛相似，不同的是其头颅深陷、体覆棕色毛茸。"

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 1,
							/obj/item/natural/silk = 2, 
							/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1,
							/obj/item/alch/viscera = 1)
	perfect_butcher_results = list (/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 2,
							/obj/item/natural/silk = 3, 
							/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1, 
							/obj/item/alch/viscera = 1)
