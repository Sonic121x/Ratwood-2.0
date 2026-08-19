/datum/food_recipe/cake
	abstract_type = /datum/food_recipe/cake
	book_category = FOOD_CAT_CAKES

// Cake Base + Frosting -> Frosted Cake Base (Raw)
/datum/food_recipe/cake/frosted_cake_base
	name = "糖霜蛋糕坯"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/frosting
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frostedcakeuncooked
	time_per_step = 3 SECONDS

// Cake Base + Cheese -> Cheesecake (Raw)
/datum/food_recipe/cake/cheesecake_base
	name = "未烤奶酪蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked
	time_per_step = 5 SECONDS

// Cake Base + Honey -> Honey Cake (Raw)
/datum/food_recipe/cake/honeycake_base
	name = "未烤蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked
	time_per_step = 5 SECONDS

// Cooked Cake + Frosting -> Frosted Cake (for those who forgot to frost first)
/datum/food_recipe/cake/frosted_cake_postbake
	name = "糖霜蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/frosting
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	time_per_step = 5 SECONDS

// Frosted Cake + Apple -> Apple Cake
/datum/food_recipe/cake/apple_cake
	name = "苹果蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applecake
	time_per_step = 5 SECONDS

// Frosted Cake + Berries -> Berry Cake
/datum/food_recipe/cake/berry_cake
	name = "浆果蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/berrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Poison Berries -> Poison Berry Cake
/datum/food_recipe/cake/berry_cake_poison
	name = "毒浆果蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/berrycake/poison
	time_per_step = 5 SECONDS

// Frosted Cake + Blackberry -> Blackberry Cake
/datum/food_recipe/cake/blackberry_cake
	name = "黑莓蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Carrot -> Carrot Cake
/datum/food_recipe/cake/carrot_cake
	name = "胡萝卜蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotcake
	time_per_step = 5 SECONDS

// Frosted Cake + Raw Carrot -> Carrot Cake (alternative)
/datum/food_recipe/cake/carrot_cake_alt
	name = "胡萝卜蛋糕（生胡萝卜）"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/carrot
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotcake
	time_per_step = 5 SECONDS

// Frosted Cake + Lemon -> Lemon Cake
/datum/food_recipe/cake/lemon_cake
	name = "柠檬蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/lemoncake
	time_per_step = 5 SECONDS

// Frosted Cake + Lime -> Lime Cake
/datum/food_recipe/cake/lime_cake
	name = "青柠蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lime
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/limecake
	time_per_step = 5 SECONDS

// Frosted Cake + Mentha -> Mentha Cake
/datum/food_recipe/cake/mentha_cake
	name = "薄荷蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/alch/mentha
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/menthacake
	time_per_step = 5 SECONDS

// Frosted Cake + Peaceflower -> Peace Cake
/datum/food_recipe/cake/peace_cake
	name = "和平蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/clothing/head/peaceflower
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/peacecake
	time_per_step = 5 SECONDS

// Frosted Cake + Raspberry -> Raspberry Cake
/datum/food_recipe/cake/raspberry_cake
	name = "覆盆子蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Rocknut -> Rocknut Cake
/datum/food_recipe/cake/rocknut_cake
	name = "石果蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/nut
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	time_per_step = 5 SECONDS

// Frosted Cake + Strawberry -> Strawberry Cake
/datum/food_recipe/cake/strawberry_cake
	name = "草莓蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/strawberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Tangerine -> Tangerine Cake
/datum/food_recipe/cake/tangerine_cake
	name = "橘子蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinecake
	time_per_step = 5 SECONDS

// Apple Cake + Nut -> Applenut Cake
/datum/food_recipe/cake/applenut_cake
	name = "苹果坚果蛋糕"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/applecake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/nut
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applenutcake
	time_per_step = 3 SECONDS

// Rocknut Cake + Apple -> Applenut Cake (alternative path)
/datum/food_recipe/cake/applenut_cake_alt
	name = "苹果坚果蛋糕（石果制）"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applenutcake
	time_per_step = 3 SECONDS
