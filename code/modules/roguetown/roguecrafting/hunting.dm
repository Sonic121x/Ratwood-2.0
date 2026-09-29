/datum/crafting_recipe/roguetown/hunting
	abstract_type = /datum/crafting_recipe/roguetown/hunting/
	skillcraft = /datum/skill/misc/hunting
	craft_xp_override = 1

/datum/crafting_recipe/roguetown/hunting/bait
	name = "诱饵"
	result = /obj/item/bait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/wheat = 2,
		)
	subtype_reqs = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/sbaita
	name = "甜诱饵（苹果）"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/apple = 2,
		)
	subtype_reqs = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/sbait
	name = "甜诱饵（浆果）"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2,
		)
	subtype_reqs = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/bloodbait
	name = "血诱饵"
	result = /obj/item/bait/bloody
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat = 2,
		)
	subtype_reqs = TRUE
	craftdiff = 2
