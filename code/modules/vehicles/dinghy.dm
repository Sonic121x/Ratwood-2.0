
//a ridable boat so players can traverse water tiles without drowning

/obj/vehicle/ridden/dinghy
	name = "小艇"
	desc = "一艘用沥青密封木板缝隙的朴素小船。"
	icon = 'icons/obj/boat.dmi'
	icon_state = "dinghy"
	can_buckle = TRUE
	max_buckled_mobs = 2
	max_occupants = 2
	max_drivers = 2
	layer = ABOVE_MOB_LAYER
	move_resist = 0
	var/allowed_turf = /turf/open/water //includes all subtypes of water
	var/obj/item/rogueweapon/mace/oar/stored_oar
	var/list/riding_offset_all
	var/list/riding_offset_2

/obj/vehicle/ridden/dinghy/Initialize(mapload)
	. = ..()
	riding_offset_all = list(TEXT_NORTH = list(0, 3), TEXT_SOUTH = list(0, 3), TEXT_EAST = list(-2, 3), TEXT_WEST = list(2, 3))
	riding_offset_2 = list(TEXT_NORTH = list(0, -5), TEXT_SOUTH = list(0, 11), TEXT_EAST = list(-10, 3), TEXT_WEST = list(10, 3))

	var/datum/component/riding/base_riding = GetComponent(/datum/component/riding)
	if(base_riding && !istype(base_riding, /datum/component/riding/dinghy))
		qdel(base_riding)
	var/datum/component/riding/Dinghy = LoadComponent(/datum/component/riding/dinghy)
	Dinghy.allowed_turf_typecache = typecacheof(allowed_turf)
	Dinghy.set_riding_offsets(RIDING_OFFSET_ALL, riding_offset_all)
	Dinghy.set_riding_offsets(2, riding_offset_2)
	ADD_TRAIT(src, TRAIT_OAR_PROPELLED, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_ALLOWS_BUCKLED_FACING, INNATE_TRAIT)

/obj/vehicle/ridden/proc/is_resisting_current()
	return FALSE


/obj/vehicle/ridden/dinghy/is_resisting_current()
	if(!HAS_TRAIT(src, TRAIT_OAR_PROPELLED))
		return FALSE
	for(var/mob/living/Living in buckled_mobs)
		for(var/obj/item/I in Living.held_items)
			if(HAS_TRAIT(I, TRAIT_OAR))
				return TRUE
	return FALSE

/obj/vehicle/ridden/dinghy/examine(mob/user)
	. = ..()

	if(stored_oar)
		. += span_notice("小艇侧面固定着一支船桨。")
		. += span_notice("右键点击小艇即可取下。")
	else
		. += span_notice("手持船桨点击小艇，可将船桨固定在侧面。")

/obj/vehicle/ridden/dinghy/relaymove(mob/user, direction)
	if(user?.buckled != src)
		if(is_occupant(user))
			remove_occupant(user)
		return FALSE
	if(!is_occupant(user))
		add_occupant(user)
	return driver_move(user, direction)

/obj/vehicle/ridden/dinghy/handle_buckled_mob_movement(newloc, direct, glide_size_override)
	for(var/mob/living/mob in buckled_mobs)
		var/mob/living/buckled_mob = mob
		if(!buckled_mob || buckled_mob.loc == newloc)
			continue
		buckled_mob.forceMove(newloc)
		buckled_mob.set_glide_size(glide_size_override || glide_size)
		if(direct && !buckled_mob.throwing)
			buckled_mob.setDir(direct)
	return TRUE

/obj/vehicle/ridden/dinghy/Click(location, control, params)
	var/list/modifiers = params2list(params)

	if(modifiers["right"])
		var/mob/living/user = usr
		if(!istype(user))
			return

		if(!stored_oar)
			to_chat(user, span_warning("[src]上没有存放船桨。"))
			return TRUE

		stored_oar.forceMove(drop_location())
		user.put_in_hands(stored_oar)
		to_chat(user, span_notice("我从[src]上取下船桨。"))
		stored_oar = null
		return TRUE
	if(modifiers["ctrl"])
		var/mob/user = usr
		if(!isliving(user))
			return
		if(user.buckled != src)
			return
		// Ctrl+click to face a direction based on click location
		var/new_dir = get_dir(src, location)
		if(new_dir)
			user.setDir(new_dir)
		return TRUE
	.=..()

/obj/vehicle/ridden/dinghy/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/mace/oar))
		if(stored_oar)
			to_chat(user, span_warning("[src]上已经固定了一支船桨。"))
			return TRUE

		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("我无法将[I]固定到[src]上。"))
			return TRUE

		stored_oar = I
		to_chat(user, span_notice("我将[I]固定到[src]上。"))
		return TRUE

	return ..()

/obj/vehicle/ridden/dinghy/post_buckle_mob(mob/living/M)
	. = ..()
	ADD_TRAIT(M, TRAIT_ON_BOAT, "BOAT_TRAIT")

/obj/vehicle/ridden/dinghy/post_unbuckle_mob(mob/living/M)
	. = ..()
	REMOVE_TRAIT(M, TRAIT_ON_BOAT, "BOAT_TRAIT")

/obj/item/rogueweapon/mace/oar
	name = "船桨"
	desc = "一根末端扁平的木杆，用来划船。"
	icon = 'icons/obj/boat_accessories.dmi'
	icon_state = "oar"
	gripped_intents = null
	force = 15
	wdefense = 10
	smeltresult = null

/obj/item/rogueweapon/mace/oar/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_OAR, INNATE_TRAIT)

/datum/crafting_recipe/roguetown/survival/oar
	name = "船桨 (1 根圆木, 2 份纤维)"
	category = "Tools"
	result = /obj/item/rogueweapon/mace/oar
	reqs = list(
		/obj/item/grown/log/tree = 1,
		/obj/item/natural/fibers = 2,
		)
	time = 15

/datum/crafting_recipe/roguetown/survival/boat
	name = "小艇 (4 根圆木, 3 份灰烬, 5 份纤维)"
	category = "Tools"
	result = /obj/vehicle/ridden/dinghy
	reqs = list(
		/obj/item/grown/log/tree = 4,
		/obj/item/ash = 3,
		/obj/item/natural/fibers = 5
		)
	time = 50
