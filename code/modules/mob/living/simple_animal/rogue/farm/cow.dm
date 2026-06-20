
/mob/living/simple_animal/hostile/retaliate/rogue/cow
	icon = 'icons/roguetown/mob/monster/cow.dmi'
	name = "母牛"
	desc = ""
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = list("哞哞叫。")
	emote_see = list("晃了晃脑袋。", "咀嚼着反刍的食物。")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	move_to_delay = 8
	animal_species = /mob/living/simple_animal/hostile/retaliate/rogue/bull
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2, /obj/item/alch/sinew = 2, /obj/item/natural/bone = 4, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 4,
						/obj/item/natural/hide=1, /obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 3, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 6,
						/obj/item/natural/hide=2, /obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 4, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)
	base_intents = list(/datum/intent/simple/headbutt)
	health = 80
	maxHealth = 80
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/wheat,/obj/item/reagent_containers/food/snacks/grown/oat)
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/cow
	milkies = TRUE
	faction = list("cows")
	attack_verb_continuous = "头撞"
	attack_verb_simple = "头撞"
	melee_damage_lower = 10
	melee_damage_upper = 25
	STASPD = 2
	STACON = 20
	STASTR = 12
	childtype = list(/mob/living/simple_animal/hostile/retaliate/rogue/cow/cowlet = 95, /mob/living/simple_animal/hostile/retaliate/rogue/cow/bullet = 5)
	remains_type = /obj/effect/decal/remains/cow

/obj/effect/decal/remains/cow
	name = "遗骸"
	gender = PLURAL
	icon_state = "skele"
	icon = 'icons/roguetown/mob/monster/cow.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/cow/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/cow/aggro (1).ogg','sound/vo/mobs/cow/aggro (2).ogg','sound/vo/mobs/cow/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/cow/pain (1).ogg','sound/vo/mobs/cow/pain (2).ogg')
		if("death")
			return pick('sound/vo/mobs/cow/death (1).ogg','sound/vo/mobs/cow/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/cow/idle (1).ogg','sound/vo/mobs/cow/idle (2).ogg','sound/vo/mobs/cow/idle (3).ogg','sound/vo/mobs/cow/idle (4).ogg','sound/vo/mobs/cow/idle (5).ogg')


/mob/living/simple_animal/hostile/retaliate/rogue/cow/cowlet
	name = "小牛"
	desc = ""
	icon_state = "cowlet"
	icon_living = "cowlet"
	icon_dead = "cowlet_dead"
	icon_gib = "cowlet_gib"
	animal_species = null
	base_intents = list(/datum/intent/simple/headbutt)
	health = 20
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	maxHealth = 20
	milkies = FALSE
	melee_damage_lower = 1
	melee_damage_upper = 6
	STACON = 5
	STASTR = 5
	STASPD = 5
	defprob = 50
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/cow

/mob/living/simple_animal/hostile/retaliate/rogue/cow/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_NOSE)
			return "鼻口部"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "鼻口部"
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

/mob/living/simple_animal/hostile/retaliate/rogue/cow/attack_hand(mob/living/carbon/M)
	if(!stat && M.used_intent.type == INTENT_DISARM && icon_state != icon_dead && !has_buckled_mobs())
		M.visible_message(span_warning("[M]推翻了[src]。"),
			span_notice("我推翻了[src]。"))
		to_chat(src, span_danger("我被[M]推倒了！"))
		Paralyze(60, ignore_canstun = TRUE)
		icon_state = "[initial(icon_state)]_tip"
		spawn(60)
			if(!stat && M)
				icon_state = icon_living
	else
		..()

/mob/living/simple_animal/hostile/retaliate/rogue/bull
	icon = 'icons/roguetown/mob/monster/cow.dmi'
	name = "公牛"
	icon_state = "bull"
	icon_living = "bull"
	icon_dead = "bull_dead"
	icon_gib = "bull_gib"
	gender = MALE
	emote_hear = list("咀嚼着。")
	emote_see = list("晃了晃脑袋。", "咀嚼着反刍的食物。")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	move_to_delay = 8
	base_intents = list(/datum/intent/simple/headbutt)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2, /obj/item/alch/sinew = 2, /obj/item/natural/bone = 4, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 4,
						/obj/item/natural/hide=1, /obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 3, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 6,
						/obj/item/natural/hide=2, /obj/item/natural/bundle/bone/full = 1, /obj/item/alch/sinew = 4, /obj/item/alch/bone = 1, /obj/item/alch/viscera = 2)
	faction = list("cows")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_same = 0
	attack_verb_continuous = "头撞"
	attack_verb_simple = "头撞"
	health = 150
	maxHealth = 150
	melee_damage_lower = 25
	melee_damage_upper = 50
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/wheat,/obj/item/reagent_containers/food/snacks/grown/oat)
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/cow
	STACON = 20
	STASTR = 12
	STASPD = 2
	remains_type = /obj/effect/decal/remains/cow

/mob/living/simple_animal/hostile/retaliate/rogue/bull/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/cow/aggro (1).ogg','sound/vo/mobs/cow/aggro (2).ogg','sound/vo/mobs/cow/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/cow/pain (1).ogg','sound/vo/mobs/cow/pain (2).ogg')
		if("death")
			return pick('sound/vo/mobs/cow/death (1).ogg','sound/vo/mobs/cow/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/cow/idle (1).ogg','sound/vo/mobs/cow/idle (2).ogg','sound/vo/mobs/cow/idle (3).ogg','sound/vo/mobs/cow/idle (4).ogg','sound/vo/mobs/cow/idle (5).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/bull/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/bull/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_NOSE)
			return "鼻口部"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "鼻口部"
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

/mob/living/simple_animal/hostile/retaliate/bull/taunted(mob/user)
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/cow/bullet
	name = "小牛"
	desc = ""
	gender = MALE
	icon_state = "bullet"
	icon_living = "bullet"
	icon_dead = "bullet_dead"
	icon_gib = "bullet_gib"
	animal_species = null
	base_intents = list(/datum/intent/simple/headbutt)
	health = 20
	maxHealth = 20
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	milkies = FALSE
	melee_damage_lower = 1
	melee_damage_upper = 6
	STACON = 5
	STASTR = 5
	STASPD = 5
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/bull

/mob/living/simple_animal/hostile/retaliate/rogue/cow/test/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)


