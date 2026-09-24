/datum/brewing_recipe/butterhairs
	name = "黄油须酒"
	category = "Grain"
	bottle_name = "黄油须酒"
	bottle_desc = "一瓶矮人酿制的黄油须酒。浓郁顺滑，带着黄油般的温润口感。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/butterhairs
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/butter = 1, /obj/item/reagent_containers/food/snacks/grown/wheat = 2, /obj/item/reagent_containers/food/snacks/grown/oat = 3)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 60
	req_species = /datum/species/dwarf

/datum/brewing_recipe/stonebeards
	name = "石须珍藏"
	category = "Grain"
	bottle_name = "石须珍藏"
	bottle_desc = "一瓶矮人酿制的石须珍藏。采用矮人工艺酿成的烈酒，带有浓烈的燕麦风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/stonebeards
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced = 4, /obj/item/reagent_containers/food/snacks/grown/wheat = 2, /obj/item/reagent_containers/food/snacks/grown/oat = 3)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 80
	req_species = /datum/species/dwarf
