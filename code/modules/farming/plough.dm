/obj/structure/plough
	name = "犁"
	desc = "装有铁犁铧的木犁，用于翻耕土地、种植作物。"
	icon = 'icons/obj/structures/plough.dmi'
	icon_state = "plough"
	density = TRUE
	max_integrity = 600
	anchored = FALSE
	climbable = FALSE
	facepull = FALSE
	drag_slowdown = 2

/obj/structure/plough/examine(mob/user)
	. = ..()
	. += span_notice("开启潜行后拖动它，可以翻耕沿途的泥地和草地。")

/obj/structure/plough/Moved(oldLoc, movement_dir)
	. = ..()
	if(pulledby && pulledby.m_intent == MOVE_INTENT_SNEAK)
		user_tries_tilling(pulledby, get_turf(src))

/obj/structure/plough/proc/user_tries_tilling(mob/living/user, turf/location)
	if(istype(location, /turf/open/floor/rogue/grass) || istype(location, /turf/open/floor/rogue/grassred) || istype(location, /turf/open/floor/rogue/grassyel) || istype(location, /turf/open/floor/rogue/grasscold))
		apply_farming_fatigue(user, 10)
		playsound(location,'sound/items/dig_shovel.ogg', 100, TRUE)
		location.ChangeTurf(/turf/open/floor/rogue/dirt, flags = CHANGETURF_INHERIT_AIR)
		return
	if(istype(location, /turf/open/floor/rogue/dirt))
		playsound(location,'sound/items/dig_shovel.ogg', 100, TRUE)
		var/obj/structure/soil/soil = get_soil_on_turf(location)
		if(soil)
			soil.user_till_soil(user)
		else
			apply_farming_fatigue(user, 10)
			new /obj/structure/soil(location)
		return
