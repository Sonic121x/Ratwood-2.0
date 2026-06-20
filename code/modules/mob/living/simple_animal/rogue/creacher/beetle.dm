/mob/living/simple_animal/hostile/retaliate/rogue/beetle
	name = "巨型毛绒金龟子"
	desc = "一种巨大的甲虫，浑身覆满厚实如毛皮般的绒毛刚毛。这些温和的巨物常从幽深地底上到地面觅食，尤其偏爱甜美的蘑菇和菌类。"
	icon = 'icons/roguetown/mob/monster/beetle.dmi'
	icon_state = "cuddlebug"
	icon_living = "cuddlebug"
	icon_dead = "dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_emote = list("咔哒作响", "吱喳作响")
	emote_hear = list("咔哒作响。", "轻声吱喳。")
	emote_see = list("咔哒响动着下颚。", "抓挠着地面。", "抖动着触角。")
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 10
	move_to_delay = 8
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/beetle = 4,
		/obj/item/natural/hide = 3,
		/obj/item/natural/fur = 2, // woolly fur
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/viscera = 2,
		/obj/item/roguegem/chitin = 3
	)
	base_intents = list(/datum/intent/simple/headbutt)
	health = 300
	maxHealth = 300
	food_type = list(
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/berries,
	)
	tame_chance = 20
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = null
	faction = list("beetles")
	attack_verb_continuous = "头撞"
	attack_verb_simple = "头撞"
	melee_damage_lower = 20
	melee_damage_upper = 35
	retreat_distance = 3
	minimum_distance = 0
	milkies = FALSE
	STASPD = 10
	STACON = 15
	STASTR = 14
	STAWIL = 8
	pixel_x = -8
	pixel_y = 0
	can_buckle = TRUE
	buckle_lying = 0
	can_saddle = TRUE
	max_buckled_mobs = 1
	aggressive = FALSE
	remains_type = /obj/effect/decal/remains/beetle
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_LARGE
	var/playing_dead = FALSE
	var/play_dead_threshold = 0.3 // Think that pretty clear waht it does. Below 30% play dead. 
	var/chitin_timer = 0 // world.time when chitin can next be shaved
	var/chitin_regrow_time = 5 MINUTES

/mob/living/simple_animal/hostile/retaliate/rogue/beetle/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle", 4.3)
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, "saddle")
			add_overlay(saddlet)

/mob/living/simple_animal/hostile/retaliate/rogue/beetle/tamed()
	..()
	deaggroprob = 30
	if(can_buckle)
		var/datum/component/riding/D = LoadComponent(/datum/component/riding)
		D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 8), TEXT_SOUTH = list(0, 8), TEXT_EAST = list(-2, 8), TEXT_WEST = list(2, 8)))
		D.set_vehicle_dir_layer(NORTH, MOB_LAYER+0.5)
		D.set_vehicle_dir_layer(SOUTH, OBJ_LAYER)
		D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
		D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/mob/living/simple_animal/hostile/retaliate/rogue/beetle/attackby(obj/item/O, mob/user, params)
	if(!stat && tame && istype(O, /obj/item/rogueweapon/chisel))
		if(world.time < chitin_timer)
			to_chat(user, span_warning("甲壳尚未长好，还不足以刮取。"))
			return TRUE
		user.visible_message(span_notice("[user]开始小心地从[src]身上刮取甲壳。"), span_notice("我开始从[src]身上刮取甲壳。"))
		if(do_after(user, 6 SECONDS, src))
			var/obj/item/roguegem/chitin/C = new(get_turf(src))
			user.visible_message(span_notice("[user]从[src]身上刮下了一块甲壳片。"), span_notice("我从[src]身上刮下了一块甲壳片。"))
			user.put_in_hands(C)
			chitin_timer = world.time + chitin_regrow_time
			return TRUE
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/beetle/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/spider/aggro (1).ogg','sound/vo/mobs/spider/aggro (2).ogg','sound/vo/mobs/spider/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/spider/pain.ogg')
		if("death")
			return pick('sound/vo/mobs/spider/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/spider/idle (1).ogg','sound/vo/mobs/spider/idle (2).ogg','sound/vo/mobs/spider/idle (3).ogg','sound/vo/mobs/spider/idle (4).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/beetle/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/beetle/tame/saddled/Initialize(mapload)
	. = ..(mapload)
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

// Remains
/obj/effect/decal/remains/beetle
	name = "甲虫遗骸"
	gender = PLURAL
	icon_state = "rotten"
	icon = 'icons/roguetown/mob/monster/beetle.dmi'

// Beetle meat
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/beetle
	name = "甲虫肉"
	desc = "来自巨型甲虫的肉，富含蛋白质。在某些地下聚落中被视为珍馐。"
	icon_state = "spidermeat"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/beetle/cooked
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	slices_num = 2

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/beetle/cooked
	name = "熟甲虫肉"
	desc = "熟甲虫肉有着坚果般的泥土风味。"
	icon_state = "spidermeat"
	cooked_type = null
	slices_num = 0
	slice_path = null
