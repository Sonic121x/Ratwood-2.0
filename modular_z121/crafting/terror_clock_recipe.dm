// 恐怖之钟：消耗一颗心脏、一颗头颅和五个骨头建造，保留原有技能与难度设置。
/datum/crafting_recipe/roguetown/structure/terror_clock
	name = "恐怖之钟"
	result = /obj/structure/terror_clock
	reqs = list(
		/obj/item/organ/heart = 1,
		/obj/item/bodypart/head = 1,
		/obj/item/natural/bone = 5
	)
	category = "通用"
	always_availible = TRUE
	skillcraft = null
	craftdiff = 0
	verbage_simple = "制作"
	verbage = "制作"

// 以实际建造落点为中心检查整片地面，不能只检查钟脚下的那一格。
/datum/crafting_recipe/roguetown/structure/terror_clock/TurfCheck(mob/user, turf/T)
	if(!..())
		return FALSE
	var/ground_error = terror_clock_ground_error(T)
	if(ground_error)
		to_chat(user, span_warning(ground_error))
		return FALSE
	return TRUE
