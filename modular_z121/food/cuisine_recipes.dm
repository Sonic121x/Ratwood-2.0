// 中式料理与基础加工的顺序配方；调味只在桌上加入。

/datum/z121_cuisine_preparation_recipe/spring_roll
	base_type = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	trigger_type = /obj/item/kitchen/rollingpin
	trigger_kind = "tool"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待包馅的春卷皮"
	prep_icon = "prep_spring_roll"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/spring_roll
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份卷心菜丝"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/carrot, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份胡萝卜"),
		list("item" = /datum/reagent/consumable/sodiumchloride, "kind" = "reagent", "amount" = 1, "time" = 3 SECONDS, "text" = "加入少许盐")
	)

/datum/z121_cuisine_preparation_recipe/hotpot
	base_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待配菜的狼肉"
	prep_icon = "raw_hotpot"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/hotpot
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份卷心菜丝"),
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份洋葱片"),
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份蒜瓣"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/ginger, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份姜"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/scallion, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份葱"),
		list("item" = /datum/reagent/consumable/ethanol/ricewine, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量米酒"),
		list("item" = /datum/reagent/consumable/sodiumchloride, "kind" = "reagent", "amount" = 3, "time" = 3 SECONDS, "text" = "加入少许盐")
	)

/datum/z121_cuisine_preparation_recipe/dongpo
	base_type = /obj/item/reagent_containers/food/snacks/rogue/meat/pork_belly
	trigger_type = /obj/item/reagent_containers/food/snacks/grown/z121/ginger
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待腌制的五花肉"
	prep_icon = "prep_dongpo"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/dongpo
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/scallion, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份葱"),
		list("item" = /datum/reagent/consumable/sugar, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入少许糖"),
		list("item" = /datum/reagent/consumable/ethanol/ricewine, "kind" = "reagent", "amount" = 10, "time" = 3 SECONDS, "text" = "加入适量米酒"),
		list("item" = /datum/reagent/consumable/z121_soy_sauce, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量酱油")
	)

/datum/z121_cuisine_preparation_recipe/noodles
	base_type = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	trigger_type = /obj/item/rogueweapon/huntingknife/cleaver
	trigger_kind = "tool"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待配菜的刀削面片"
	prep_icon = "prep_noodles"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/noodles
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份卷心菜丝"),
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份洋葱片"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/scallion, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份葱"),
		list("item" = /datum/reagent/consumable/sodiumchloride, "kind" = "reagent", "amount" = 2, "time" = 3 SECONDS, "text" = "加入少许盐")
	)

/datum/z121_cuisine_preparation_recipe/meat_bun
	base_type = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待调馅的肉包面坯"
	prep_icon = "prep_meat_bun"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/meat_bun
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/scallion, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份葱"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/ginger, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份姜"),
		list("item" = /datum/reagent/consumable/z121_soy_sauce, "kind" = "reagent", "amount" = 3, "time" = 3 SECONDS, "text" = "加入适量酱油")
	)

/datum/z121_cuisine_preparation_recipe/vegetable_bun
	base_type = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待调馅的菜包面坯"
	prep_icon = "prep_vegetable_bun"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/vegetable_bun
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/grown/carrot, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份胡萝卜"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/scallion, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份葱"),
		list("item" = /datum/reagent/consumable/sodiumchloride, "kind" = "reagent", "amount" = 1, "time" = 3 SECONDS, "text" = "加入少许盐")
	)

/datum/z121_cuisine_preparation_recipe/sixi
	base_type = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	trigger_type = /obj/item/reagent_containers/food/snacks/grown/z121/scallion
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待揉制的四喜肉馅"
	prep_icon = "prep_sixi"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/sixi
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份碎肉糜"),
		list("item" = /obj/item/reagent_containers/food/snacks/egg, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份鸡蛋"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/ginger, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份姜"),
		list("item" = /datum/reagent/floure, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量面粉")
	)

/datum/z121_cuisine_preparation_recipe/sixi_braise
	base_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/fried_sixi
	trigger_type = /datum/reagent/consumable/z121_soy_sauce
	trigger_kind = "reagent"
	trigger_amount = 5
	trigger_time = 3 SECONDS
	prep_name = "待调汁的四喜丸子"
	prep_icon = "braise_sixi"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/sixi_braise
	steps = list(
		list("item" = /datum/reagent/consumable/sugar, "kind" = "reagent", "amount" = 3, "time" = 3 SECONDS, "text" = "加入少许糖"),
		list("item" = /datum/reagent/consumable/ethanol/ricewine, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量米酒")
	)

/datum/z121_cuisine_preparation_recipe/buddha
	base_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/abalone_soaked
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/sea_cucumber_soaked
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待配齐的佛跳墙炖料"
	prep_icon = "prep_buddha"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/buddha
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份禽肉"),
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/meat/pork_belly, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份猪五花肉"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/ginger, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份姜"),
		list("item" = /datum/reagent/consumable/z121_soy_sauce, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量酱油"),
		list("item" = /datum/reagent/consumable/ethanol/ricewine, "kind" = "reagent", "amount" = 10, "time" = 3 SECONDS, "text" = "加入适量米酒")
	)

/datum/z121_cuisine_preparation_recipe/white_chicken
	base_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	trigger_type = /obj/item/reagent_containers/food/snacks/grown/z121/scallion
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待调味的白切鸡"
	prep_icon = "prep_white_chicken"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/white_chicken
	steps = list(
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/ginger, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份姜"),
		list("item" = /datum/reagent/consumable/sodiumchloride, "kind" = "reagent", "amount" = 2, "time" = 3 SECONDS, "text" = "加入少许盐"),
		list("item" = /datum/reagent/consumable/ethanol/ricewine, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量米酒")
	)

/datum/z121_cuisine_preparation_recipe/white_chicken_finish
	base_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/poached_chicken
	trigger_type = /obj/item/rogueweapon/huntingknife/cleaver
	trigger_kind = "tool"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待调味的白切鸡块"
	prep_icon = "cut_chicken"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/white_chicken
	prep_cooked = TRUE
	steps = list(
		list("item" = /datum/reagent/consumable/z121_soy_sauce, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量酱油"),
		list("item" = /datum/reagent/consumable/oil/tallow, "kind" = "reagent", "amount" = 2, "time" = 3 SECONDS, "text" = "加入适量炼制油脂")
	)

/datum/z121_cuisine_preparation_recipe/mapo
	base_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/tofu
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/doubanjiang
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待切块的麻婆豆腐"
	prep_icon = "prep_mapo"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/mapo
	steps = list(
		list("item" = /obj/item/rogueweapon/huntingknife/cleaver, "kind" = "tool", "amount" = 0, "time" = 3 SECONDS, "text" = "用菜刀切块", "icon" = "cut_mapo", "name" = "待配料的麻婆豆腐块"),
		list("item" = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份碎肉糜"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/chili, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份辣椒"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/sichuan_pepper, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份花椒"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/scallion, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份葱"),
		list("item" = /datum/reagent/consumable/z121_soy_sauce, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量酱油")
	)

/datum/z121_cuisine_preparation_recipe/kungpao
	base_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	trigger_type = /obj/item/reagent_containers/food/snacks/grown/z121/ginger
	trigger_kind = "food"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待切丁的宫保鸡肉"
	prep_icon = "prep_kungpao"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/kungpao
	steps = list(
		list("item" = /obj/item/rogueweapon/huntingknife/cleaver, "kind" = "tool", "amount" = 0, "time" = 3 SECONDS, "text" = "用菜刀切丁", "icon" = "cut_kungpao", "name" = "待配料的生鸡丁"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/chili, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份辣椒"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/peanut, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份花生"),
		list("item" = /obj/item/reagent_containers/food/snacks/grown/z121/scallion, "kind" = "food", "amount" = 0, "time" = 3 SECONDS, "text" = "加入一份葱"),
		list("item" = /datum/reagent/consumable/z121_soy_sauce, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量酱油"),
		list("item" = /datum/reagent/consumable/sugar, "kind" = "reagent", "amount" = 3, "time" = 3 SECONDS, "text" = "加入少许糖"),
		list("item" = /datum/reagent/consumable/z121_rice_vinegar, "kind" = "reagent", "amount" = 5, "time" = 3 SECONDS, "text" = "加入适量米醋")
	)

/datum/z121_cuisine_preparation_recipe/soy_prepare
	base_type = /obj/item/reagent_containers/food/snacks/grown/z121/soybean
	trigger_type = /obj/item/reagent_containers/glass/bowl
	trigger_kind = "bowl"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "碗装黄豆"
	prep_icon = "soy_bowl"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/soy_milk
	requires_knowledge = FALSE
	keeps_bowl = TRUE
	steps = list(
		list("item" = /datum/reagent/water, "kind" = "reagent", "amount" = 20, "time" = 10 SECONDS, "text" = "添足清水，耐心浸泡", "icon" = "soy_soaked", "name" = "浸泡黄豆"),
		list("item" = /obj/item/pestle, "kind" = "tool", "amount" = 0, "time" = 3 SECONDS, "text" = "用研杵磨浆")
	)

/datum/z121_cuisine_preparation_recipe/tofu_press
	base_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/soy_cooked
	trigger_type = /datum/reagent/consumable/z121_rice_vinegar
	trigger_kind = "reagent"
	trigger_amount = 5
	trigger_time = 10 SECONDS
	prep_name = "凝固豆花"
	prep_icon = "soy_curd"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/tofu
	requires_knowledge = FALSE
	keeps_bowl = TRUE
	prep_cooked = TRUE
	steps = list(
		list("item" = /obj/item/kitchen/rollingpin, "kind" = "tool", "amount" = 0, "time" = 10 SECONDS, "text" = "用擀面杖压制成形")
	)

/datum/z121_cuisine_preparation_recipe/abalone_soak
	base_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/abalone_dry
	trigger_type = /obj/item/reagent_containers/glass/bowl
	trigger_kind = "bowl"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待泡发的鲍鱼"
	prep_icon = "abalone_bowl"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/abalone_soaked
	requires_knowledge = FALSE
	keeps_bowl = TRUE
	steps = list(
		list("item" = /datum/reagent/water, "kind" = "reagent", "amount" = 20, "time" = 20 SECONDS, "text" = "添足清水，耐心浸泡")
	)

/datum/z121_cuisine_preparation_recipe/sea_cucumber_soak
	base_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/sea_cucumber_dry
	trigger_type = /obj/item/reagent_containers/glass/bowl
	trigger_kind = "bowl"
	trigger_amount = 0
	trigger_time = 3 SECONDS
	prep_name = "待泡发的海参"
	prep_icon = "sea_cucumber_bowl"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/sea_cucumber_soaked
	requires_knowledge = FALSE
	keeps_bowl = TRUE
	steps = list(
		list("item" = /datum/reagent/water, "kind" = "reagent", "amount" = 20, "time" = 20 SECONDS, "text" = "添足清水，耐心浸泡")
	)
