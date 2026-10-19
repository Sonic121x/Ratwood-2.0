// Food that is primarily made out of a cooked vegetable component.
/*	.............   Cooked cabbage   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	name = "熟卷心菜"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "cabbage_fried"
	desc = "农夫的心头好。"
	faretype = FARE_POOR
	portable = FALSE
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("热卷心菜香" = 1)
	rotprocess = SHELFLIFE_LONG

/*	.............   Baked potato   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	name = "烤土豆"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "矮人的最爱，既能当正餐，也能拿来玩烫手山芋。"
	faretype = FARE_POOR
	icon_state = "potato_baked"
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_LONG

/*	.............   Fried potato   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	name = "炸土豆"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "烤得恰到好处的土豆块。"
	icon_state = "potato_fried"
	faretype = FARE_NEUTRAL
	portable = FALSE
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("热土豆香" = 1)
	rotprocess = SHELFLIFE_LONG

/* .............   Baked Carrot   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	name = "烤胡萝卜"
	desc = "一根烤到金黄的胡萝卜，内里柔软而香甜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "carrot_cooked"
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("胡萝卜香" = 1)
	rotprocess = SHELFLIFE_DECENT

/*	.............   Fried onions   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	name = "炸洋葱"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "炙烤后的洋葱成了美味的圈圈。"
	icon_state = "onion_fried"
	faretype = FARE_POOR
	portable = FALSE
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("咸香小食" = 1)
	rotprocess = SHELFLIFE_DECENT

/* .............   Eggplant   ................ */
/obj/item/reagent_containers/food/snacks/rogue/eggplantcarved
	name = "挖空茄子"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplant_carved"
	desc = "一只内部被掏空的茄子，已经准备好塞入肉馅了。"
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/eggplantmeat
	name = "未完成的酿茄子"
	desc = "一只塞着生肉的茄子，已经可以继续铺上番茄了。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplantraw"
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/eggplantstuffedraw
	name = "生酿茄子"
	desc = "一只塞着生肉和番茄的酿茄子，已经准备好下锅了。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplantrawtom"
	rotprocess = SHELFLIFE_LONG
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed

/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	name = "酿茄子"
	desc = "茄子里塞着肉和番茄。真香！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "stuffedeggplant"
	tastes = list("肉香" = 1, "番茄香" = 1, "茄子香" = 1)
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	name = "奶酪酿茄子"
	desc = "顶上覆着奶酪的酿茄子。国王也配得上！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "stuffedeggplantcheese"
	tastes = list("肉香" = 1, "番茄香" = 1, "茄子香" = 1, "奶酪香" = 1)
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/roastseeds
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	tastes = list("烤种子香" = 1)
	name = "烤种子"
	desc = "鸟儿的口粮，人类的小零嘴。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "roastseeds"
	dropshrink = 0.8
	color = "#e5b175"
	foodtype = VEGETABLES
	rotprocess = null

/obj/item/reagent_containers/food/snacks/roastseeds/sunflower
	name = "烤葵花籽"
	tastes = list("烤葵花籽香" = 1)

/obj/item/reagent_containers/food/snacks/roastseeds/pumpkin
	name = "烤南瓜籽"
	tastes = list("烤南瓜籽香" = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/pumpkinspice
