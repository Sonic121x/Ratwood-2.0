/datum/food_recipe/rice
	abstract_type = /datum/food_recipe/rice
	book_category = FOOD_CAT_RICE

// Cooked Rice + Fried Steak -> Rice and Beef
/datum/food_recipe/rice/beef
	name = "牛肉拌饭"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebeef

// Cooked Rice + Fatty Roast -> Rice and Pork
/datum/food_recipe/rice/pork
	name = "猪肉拌饭"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricepork

// Cooked Rice + Shrimp -> Rice and Shrimp
/datum/food_recipe/rice/shrimp
	name = "虾仁拌饭"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceshrimp

// Cooked Rice + Fried Poultry Cutlet -> Rice and Bird
/datum/food_recipe/rice/bird
	name = "禽肉拌饭"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebird

// Cooked Rice + Cheddar Slice -> Rice and Cheese
/datum/food_recipe/rice/cheese
	name = "奶酪拌饭"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricecheese

// Cooked Rice + Egg -> Rice and Egg
/datum/food_recipe/rice/egg
	name = "蛋拌饭"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceegg

// Rice and Pork + Cucumber -> Rice and Pork Meal
/datum/food_recipe/rice/pork_cucumber
	name = "猪肉饭套餐"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/ricepork
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceporkcuc

// Rice and Beef + Baked Carrot -> Rice and Beef Meal
/datum/food_recipe/rice/beef_carrot
	name = "牛肉饭套餐"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/ricebeef
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebeefcar

// Rice and Shrimp + Baked Carrot -> Rice and Shrimp Meal
/datum/food_recipe/rice/shrimp_carrot
	name = "虾仁饭套餐"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/riceshrimp
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar

// Rice and Bird + Baked Carrot -> Rice and Bird Meal
/datum/food_recipe/rice/bird_carrot
	name = "禽肉饭套餐"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/ricebird
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebirdcar

// Rice and Egg + Cheddar Slice -> Rice with Egg and Cheese
/datum/food_recipe/rice/egg_cheese
	name = "鸡蛋奶酪饭"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/riceegg
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese

// Rice and Cheese + Egg -> Rice with Egg and Cheese (alternative path)
/datum/food_recipe/rice/cheese_egg
	name = "鸡蛋奶酪饭（备选）"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/ricecheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese
