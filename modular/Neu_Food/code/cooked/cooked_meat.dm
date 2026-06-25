// Simple cooked meat from any animals.
// Only includes simple cooked meat instead of the meal.
// Try to order in the same order as raw meat file ok
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	eat_effect = null
	slices_num = 0
	name = "煎牛排"
	desc = "一大块兽肉，煎到了恰到好处的五分熟。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frysteak"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("热牛排香" = 1)
	fried_type = null
	cooked_type = null

/* .............   Roast Pork   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	eat_effect = null
	name = "烤猪肉"
	desc = "一大块猪肉，烤到了恰到好处的酥脆程度。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	faretype = FARE_FINE
	icon_state = "roastpork"
	tastes = list("酥脆猪肉香" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/*	.............   Crispy bacon   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	eat_effect = null
	name = "煎培根"
	desc = "这是松露猪的退休归宿。"
	faretype = FARE_FINE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "friedbacon"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/*	.............   Fryspider   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	name = "煎蜘蛛肉"
	desc = "一条去毛烤制的蜘蛛腿。"
	faretype = FARE_POOR
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "friedspider"
	eat_effect = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/*	.................  Whole Chicken roast   ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	desc = "一只肥美的禽鸟，被烤到恰到好处，外皮酥脆。"
	eat_effect = null
	slices_num = 0
	name = "烤禽"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "roastchicken"
	faretype = FARE_FINE
	portable = FALSE
	tastes = list("鲜美禽肉香" = 1)
	cooked_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	rotprocess = SHELFLIFE_DECENT

/*	.............   Frybird   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	eat_effect = null
	slices_num = 0
	name = "炸鸟排"
	desc = "禽肉被炸到了恰到好处的诱人酥脆。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frybird"
	faretype = FARE_FINE
	portable = FALSE
	fried_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_DECENT

/* ............. Fried Crab ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	eat_effect = null
	slices_num = 0
	name = "炸蟹肉"
	faretype = FARE_NEUTRAL
	portable = FALSE
	desc = "一块炸蟹肉，真香。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "crabmeat"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	desc = ""
	fried_type = null
	cooked_type = null

/* .............   Fried Cabbit   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	eat_effect = null
	slices_num = 0
	name = "炸兔肉"
	desc = "一大块兔肉，被炸到了恰到好处的酥脆程度。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frycabbit"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)	//It's easier and cheaper than normal meat to find.
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("热兔肉香" = 1)
	fried_type = null
	cooked_type = null

/* .............   Fried Volf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	eat_effect = null
	slices_num = 0
	name = "煎狼肉"
	desc = "一大块狼肉，煎到了恰到好处的五分熟。略带野味也有些韧，但很好吃。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "fryvolf"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/* .............   Fried Rous   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/rat/fried
	eat_effect = null
	slices_num = 0
	name = "fried rous"
	desc = "A small, chewy chunk of rous meat. Certain races loves this, others... Not so much."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "rat"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/* .............   Fried Bear   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/bear/fried
	eat_effect = null
	slices_num = 0
	bitesize = 4
	name = "T-bone bear steak"
	desc = "Real meat, for real men."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "bear"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/* .............   Fried Troll   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried
	eat_effect = /datum/status_effect/debuff/uncookedfood
	slices_num = 0
	bitesize = 5
	name = "chewy troll blubber"
	desc = "Cooking it seems to have only caused the meat to toughen up. It is vile, disgusting, like partially hardened jello with greasy chunks hidden within. Perhaps it can be cooked further to stubbornly quell its spirit."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "troll"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_EXTREME
	fried_type = /obj/item/reagent_containers/food/snacks/fat
	cooked_type = /obj/item/reagent_containers/food/snacks/fat
	// Takes a really long time unless you're a skilled cook.
	cooktime = 1500

/* .............   Seared Gnoll   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared
	eat_effect = null
	slices_num = 0
	name = "炙鬣狗人肉"
	desc = "一团恶心得要命、满是筋的鬣狗人肉。看起来炙烤只让肌肉变得更韧了。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "searedgnoll"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_EXTREME
	fried_type = null
	cooked_type = null

/* .............   Fried Filet    ................ */
// This is seafood but is one of the "simple cooked meat" so I put it here.
/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	eat_effect = null
	slices_num = 0
	name = "炸鱼柳"
	desc = "一大片层层剥落的鱼肉，被煎到一碰就散。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "cooked_filet"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("热鱼香" = 1)
	fried_type = null
	cooked_type = null

/* .............   Fried Shellfish    ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	eat_effect = null
	slices_num = 0
	name = "炸贝肉"
	desc = "炸熟的贝肉，有点咸，但很好吃。"
	faretype = FARE_NEUTRAL
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "shellfish_meat_cooked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	fried_type = null
	cooked_type = null


/*	.............   Sausage & Wiener   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	eat_effect = null
	name = "香肠"
	desc = "把美味的肉填进肠衣里制成的食物。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "wiener"
	faretype = FARE_NEUTRAL
	fried_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_EXTREME

/*	.............   Cooked Ham   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/ham/steamed
	name = "蒸火腿"
	desc = "腌制的肉块，可以用刀进一步切分。在任何一个稍有财富的储藏室里，你很难找不到它。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "ham5"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	bitesize = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/ham/sliced
	faretype = FARE_POOR
	slices_num = 4
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	eat_effect = null
	tastes = list("hog" = 1)
	cooked_type = null
	fried_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/steamed/update_icon()
	if(slices_num)
		icon_state = "ham[slices_num]"
	else
		icon_state = "ham_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/steamed/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/sliced
	name = "切片火腿"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "ham_slice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	eat_effect = null
	tastes = list("hog" = 1)
	cooked_type = null
	fried_type = null

/*	.............   Cooked Spidermeat   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/spider/meatball/cooked
	name = "fried spidermeatball"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "spidermeatball_cooked"
	bitesize = 3
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	eat_effect = null
	tastes = list("crispy chitin" = 1)

/obj/item/reagent_containers/food/snacks/rogue/meat/spider/surprise/cooked
	name = "spider surprise"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "spider_surprise_cooked"
	bitesize = 4
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	eat_effect = null
	tastes = list("crispy chitin" = 1, "venom innards" = 1)
	faretype = FARE_FINE
