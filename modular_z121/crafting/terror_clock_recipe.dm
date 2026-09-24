// 恐怖之钟：通用分类中消耗一块钢锭建造，保留原有技能与难度设置。
/datum/crafting_recipe/roguetown/structure/terror_clock
	name = "恐怖之钟"
	result = /obj/structure/terror_clock
	reqs = list(/obj/item/ingot/steel = 1)
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
