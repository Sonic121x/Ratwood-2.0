/datum/crafting_recipe/roguetown/engineering/void_cube
	name = "虚空魔方"
	result = /obj/item/void_cube
	reqs = list(
		/obj/item/roguegear/bronze = 4,
		/obj/item/riddleofsteel = 1,
		/obj/item/magic/voidstone = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/grown/log/tree = 1
	)
	category = "工程"
	always_availible = TRUE
	skillcraft = /datum/skill/craft/engineering
	// Difficulty 6 makes the craft roll succeed only for legendary engineering.
	craftdiff = 6
	verbage_simple = "制作"
	verbage = "制作"
