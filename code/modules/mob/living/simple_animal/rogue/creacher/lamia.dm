/mob/living/simple_animal/hostile/retaliate/rogue/lamia
	icon = 'icons/roguetown/mob/monster/lamia.dmi'
	name = "拉弥亚"
	desc = "这种蜿蜒爬行的怪物有着人类躯干、一条巨大的蛇尾和四条刀锋般的手臂。"
	icon_state = "lamia_f"
	icon_living = "lamia_f"
	icon_dead = "lamia_dead"
	gender = FEMALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 9
	move_to_delay = 2
	base_intents = list(/datum/intent/simple/bite, /datum/intent/simple/claw)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/natural/hide = 1)
	faction = list("orcs")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST|MOB_REPTILE
	health = 200
	maxHealth = 200
	melee_damage_lower = 35
	melee_damage_upper = 50
	vision_range = 9
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	food_type = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak, /obj/item/bodypart, /obj/item/organ)
	footstep_type = null
	pooptype = null
	STACON = 6
	STASTR = 11
	STASPD = 12
	deaggroprob = 0
	defprob = 35
	del_on_deaggro = 999 SECONDS
	retreat_health = 0.1
	food = 0
	dodgetime = 15
	aggressive = 1
	remains_type = null
	var/sneaking = FALSE
	var/light_check = 0
	var/light_check_delay = 3 SECONDS
	var/sneak_cooldown = 0
	var/sneak_cooldown_delay = 30 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/lamia/Initialize(mapload)
	. = ..()
	if(prob(20))
		gender = MALE
		icon_state = "lamia"
		icon_living = "lamia"
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/lamia/AttackingTarget()
	if(sneaking)
		break_sneak()
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/lamia/handle_automated_action()
	if(!sneaking && world.time >= sneak_cooldown && isturf(loc) && light_check < world.time)
		var/turf/ourlocation = get_turf(src)
		var/light_amount = ourlocation.get_lumcount()
		light_check = world.time + light_check_delay
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			sneak_now()
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/lamia/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_NOSE)
			return "头部"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "嘴"
		if(BODY_ZONE_PRECISE_SKULL)
			return "头部"
		if(BODY_ZONE_PRECISE_EARS)
			return "头部"
		if(BODY_ZONE_PRECISE_NECK)
			return "脖子"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "刀锋手臂"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "刀锋手臂"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "尾部"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "尾部"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "腹部"
		if(BODY_ZONE_PRECISE_GROIN)
			return "尾部"
		if(BODY_ZONE_HEAD)
			return "头部"
		if(BODY_ZONE_R_LEG)
			return "尾部"
		if(BODY_ZONE_L_LEG)
			return "尾部"
		if(BODY_ZONE_R_ARM)
			return "尾部"
		if(BODY_ZONE_L_ARM)
			return "尾部"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/lamia/proc/sneak_now()
	if(!sneaking && world.time >= sneak_cooldown)
		sneaking = TRUE
		alpha = 100

/mob/living/simple_animal/hostile/retaliate/rogue/lamia/proc/break_sneak()
	sneaking = FALSE
	alpha = 255
	sneak_cooldown = world.time + sneak_cooldown_delay
