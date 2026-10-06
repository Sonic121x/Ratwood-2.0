/obj/structure/infernalengine
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "炼狱引擎"
	desc = "这台引擎通过内部核心循环流动的岩浆，驱动大型机械旋转。"
	icon_state = "infernal0"
	var/base_state = "infernal"
	var/on = FALSE
	//these is built and anchored, artificers need to be careful where they place them, one of the drawbacks
	anchored = TRUE
	density = TRUE
	layer = ABOVE_MOB_LAYER
	stress_generator = TRUE
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_FLIP
	debris = list(/obj/item/magic/infernal/core = 1)

/obj/structure/infernalengine/examine(mob/user)
	. = ..()
	. += span_info("运转期间，这台引擎会持续为相连的机械提供旋转动力。")
	. += span_info("请远离潮湿地形。水会熄灭火焰，使引擎停转。")

/obj/structure/infernalengine/find_rotation_network()
	. = ..()
	setup_rotation(get_turf(src))

/obj/structure/infernalengine/proc/setup_rotation(turf/open/water/river/water)
	if(isopenturf(loc))
		var/turf/open/O = loc
		if(IS_WET_OPEN_TURF(O))
			extinguish()
	if(on)
		icon_state = "infernal1"
		update_icon()
	var/engine_rotation_dir = EAST

	last_stress_generation = 0
	set_stress_generation(1024)
	set_rotational_direction_and_speed(engine_rotation_dir, 32) //high RPM to make up for the difficulty to make this
	return TRUE

/obj/structure/infernalengine/update_animation_effect()
	if(!rotation_network || rotation_network?.overstressed || !rotations_per_minute || !rotation_network?.total_stress) //if the loop is over stressed we turn things off
		extinguish()
		on = FALSE
		return

	//if its working and turned on...
	on = TRUE
	icon_state = "infernal1"
	update_icon()
