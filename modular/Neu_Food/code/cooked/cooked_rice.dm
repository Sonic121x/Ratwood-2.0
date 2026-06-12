/* .............   RICE   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	name = "熟米饭"
	desc = "朴素的熟米饭，是许多文化中的主食。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "米饭香"
	faretype = FARE_POOR
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_LONG

/*	.................   Rice & pork  ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricepork
	name = "猪肉拌饭"
	tastes = list("米饭香" = 1, "猪肉香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "米饭拌着肥猪肉。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricepork"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & pork & cucumbers ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceporkcuc
	name = "猪肉饭套餐"
	tastes = list("米饭香" = 1, "猪肉香" = 1, "鲜黄瓜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	desc = "米饭拌着肥猪肉和新鲜黄瓜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceporkmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & beef ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebeef
	name = "牛肉拌饭"
	tastes = list("米饭香" = 1, "牛排香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "米饭拌着牛排肉。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebeef"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & beef & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebeefcar
	name = "牛肉饭套餐"
	tastes = list("米饭香" = 1, "牛排香" = 1, "胡萝卜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	desc = "米饭拌着牛排肉和胡萝卜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebeefmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & shrimp ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceshrimp
	name = "虾仁拌饭"
	tastes = list("米饭香" = 1, "虾仁香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "米饭拌着虾仁。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceshrimp"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & shrimp & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar
	name = "虾仁饭套餐"
	tastes = list("米饭香" = 1, "虾仁香" = 1, "胡萝卜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "米饭拌着虾仁和胡萝卜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceshrimpmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & bird ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebird
	name = "禽肉拌饭"
	tastes = list("米饭香" = 1, "鲜美禽肉香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "米饭拌着炸禽肉。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebird"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & bird & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebirdcar
	name = "禽肉饭套餐"
	tastes = list("米饭香" = 1, "鲜美禽肉香" = 1, "胡萝卜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	desc = "米饭拌着炸禽肉和胡萝卜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebirdmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & egg ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceegg
	name = "蛋拌饭"
	tastes = list("米饭香" = 1, "鸡蛋香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "米饭拌着鸡蛋。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceegg"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & cheese ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricecheese
	name = "奶酪拌饭"
	tastes = list("米饭香" = 1, "奶酪香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "米饭上覆着一层融化奶酪。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricecheese"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & egg & cheese ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceeggcheese
	name = "鸡蛋奶酪饭"
	tastes = list("米饭香" = 1, "奶酪香" = 1, "鸡蛋香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	desc = "米饭拌着鸡蛋，上面覆着一层融化奶酪。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceeggcheese"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff
