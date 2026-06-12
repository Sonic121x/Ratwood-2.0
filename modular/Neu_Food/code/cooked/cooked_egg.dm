/obj/item/reagent_containers/food/snacks/rogue/friedegg
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("煎蛋香" = 1)
	name = "煎蛋"
	desc = "you shouldn't be seeing this."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "friedegg"
	portable = FALSE
	faretype = FARE_POOR
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried //so fried-egg specific shit stops getting inherited
	name = "fried egg"
	desc = "Some Astratans enjoy their eggs sunny-side up."

/*	.............   Twin fried eggs   ................ */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("煎蛋香" = 1)
	name = "双份煎蛋"
	faretype = FARE_NEUTRAL
	desc = "双倍蛋黄，双倍快乐。"
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "seggs"
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.............   Deviled Eggs   ................ */
/obj/item/reagent_containers/food/snacks/rogue/stuffedegg
	name = "生夹馅蛋"
	desc = "一颗塞满奶香芝士馅的生蛋。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "deviledegg_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked
	tastes = list("奶香芝士" = 1, "鸡蛋香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	name = "夹馅蛋"
	desc = "一颗塞满奶香芝士馅的蛋。"
	icon_state = "deviledegg"

/*	.............   Tartar   ................ */
//This doesn't really count as either cooked or egg recipe (it does contain an egg at least) so whatever.
/obj/item/reagent_containers/food/snacks/rogue/tartar
	name = "鞑靼生肉"
	desc = "绞肉上覆着生蛋，是草原人的心头好。据说它得名于一位著名的强盗。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "tartar"
	foodtype = MEAT
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_POOR //It's raw meat and egg... come now now

/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*	- Defined as edible food that can be plated and usually needs rare tools or ingridients. Typically based on a snack but not necessarily
 *		 (Meals)		*
 *						*
 * * * * * * * * * * * **/

/*	.................   Valerian Omelette   ................... */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("煎蛋香" = 1, "奶酪香" = 1)
	name = "瓦莱里安煎蛋卷"
	desc = "煎蛋铺在半融化的奶酪上，是一道来自遥远国度的菜肴。"
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "omelette"
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = SHELFLIFE_DECENT

/*	.................   Bacon & Eggs   ................... */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("煎蛋香" = 1, "培根香" = 1)
	name = "培根煎蛋"
	desc = "煎蛋配培根。培根咸香酥脆，与鸡蛋更温和的味道相得益彰。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "baconegg"
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT

/*	.................   Hammerholdian Breakfast   ................... */
//This is an extremely convoluded recipe probably not even worth it but yknow what, why not.
/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("煎蛋香" = 1, "香肠香" = 1)
	name = "香肠煎蛋"
	desc = "一份配着香肠的煎蛋，是完美早晨的好开头。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "wieneregg"
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("煎蛋香" = 1, "香肠香" = 1, "培根香" = 1)
	name = "培根香肠煎蛋"
	desc = "一份配着香肠和培根的煎蛋。离伟大只差一步。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "wienereggbacon"
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("煎蛋香" = 1, "香肠香" = 1, "培根香" = 1, "吐司香" = 1)
	name = "铁锤堡式早餐"
	desc = "北方堡垒的经典早餐，去掉了更异域的配料以适应谷地厨房，是真正的矮人主食。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "hammerbreak"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_DECENT
