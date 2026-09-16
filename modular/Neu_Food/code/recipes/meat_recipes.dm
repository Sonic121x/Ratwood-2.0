// Fried Steak + Pepper -> Pepper Steak
/datum/food_recipe/pepper_steak
	name = "胡椒牛排"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/peppersteak

// Fried Steak + Fried Onion -> Onion Steak
/datum/food_recipe/onion_steak
	name = "洋葱牛排"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/onionsteak

// Fried Steak + Baked Carrot -> Carrot Steak
/datum/food_recipe/carrot_steak_meat
	name = "胡萝卜牛排"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotsteak

// Fried Bacon + Wiener Egg -> Wiener Egg with Bacon
/datum/food_recipe/bacon_wiener_egg
	name = "培根香肠煎蛋（培根制）"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon

// Fried Bacon + Fried Egg -> Bacon and Eggs
/datum/food_recipe/bacon_egg
	name = "培根煎蛋"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon

// Roast Bird + Pepper -> Spiced Bird-Roast
/datum/food_recipe/spiced_bird
	name = "香料烤禽"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced

// Roast Bird + Butter -> Butter Bird-Roast
/datum/food_recipe/butter_bird
	name = "黄油烤禽"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butter
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter

// Roast Bird + Roast Bird -> Double Stacked Bird-Roast
/datum/food_recipe/double_bird
	name = "塞鸟烤禽"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked

// Frybird + Baked Potato -> Frybird Tato
/datum/food_recipe/frybird_tato_meat
	name = "炸鸟排配土豆"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frybirdtato

// Frybird + Fried Potato -> Frybird Tato (alt)
/datum/food_recipe/frybird_tato_meat_alt
	name = "炸鸟排配土豆（备选）"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frybirdtato

// Fried Cabbit + Garlic Clove -> Garlick Cabbit
/datum/food_recipe/garlick_cabbit
	name = "大蒜卡比特肉"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick

// Fried Volf + Garlic Clove -> Garlick Volf
/datum/food_recipe/garlick_volf
	name = "大蒜沃尔夫肉"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick

// Fried Fish Filet + Pepper -> Pepper Fish
/datum/food_recipe/pepper_fish
	name = "胡椒鱼柳"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pepperfish

// Cooked Sausage + Fried Egg -> Wiener Egg
/datum/food_recipe/wiener_egg_sausage
	name = "香肠煎蛋（香肠制）"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
