// For definition - any non-bread premium product dough that is also not a cake.
/*	.................   Pastry   ................... */
/obj/item/reagent_containers/food/snacks/rogue/pastry
	name = "酥点"
	desc = "酥脆、黄油香浓、层层起酥，令人愉悦。深受孩子和嗜甜者喜爱。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pastry"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	tastes = list("酥脆黄油面皮" = 1)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/biscuit
	name = "葡萄干饼干"
	desc = "一块酥脆的黄油酥点，里面有有嚼劲的葡萄干。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "biscuit"
	faretype = FARE_NEUTRAL
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("酥脆黄油面皮" = 1, "葡萄干香" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw
	name = "uncooked raisin biscuit"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "biscuit_raw"
	color = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/biscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/chocolatebiscuit
	name = "chocolate biscuit"
	desc = "A crispy buttery pastry with gooey specklings of chocolate inside."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "chocolatebiscuit"
	faretype = FARE_LAVISH
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("crispy butterdough" = 1, "richly sweet and molten chocolate" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN| DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw
	name = "uncooked chocolate biscuit"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "chocolatebiscuit_raw"
	color = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolatebiscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/plumbiscuit
	name = "plum biscuit"
	desc = "A crispy buttery pastry with streaked frosting and tender plums."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plumbiscuit"
	faretype = FARE_FINE
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("crispy butterdough" = 1, "tangy frosting" = 1, "sweetly baked plums" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/plumbiscuit_raw
	name = "uncooked plum biscuit"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plumbiscuit_raw"
	color = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/plumbiscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/tangerinebiscuit
	name = "tangerine biscuit"
	desc = "A crispy buttery pastry with caked frosting and ripe tangerines."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerinebiscuit"
	faretype = FARE_FINE
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("crispy butterdough" = 1, "zesty frosting" = 1, "lightly jammed and juicy tangerines" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tangerinebiscuit_raw
	name = "uncooked tangerine biscuit"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerinebiscuit_raw"
	color = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinebiscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/*	.................   Cookies  ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookie_raw
	name = "slab of half-done cookiedough"
	desc = "Doughy, soft, and speckled with chocolate. A little less than 'unacceptable', but still far too raw to peck at.. maybe some more chocolate, to round it out?"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_halfcookiedough"
	cooked_smell = /datum/pollutant/food/cookies_chocolate
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookie_raw
	name = "slab of cookiedough"
	desc = "Doughy, soft, and drenched in chocolate. Now that is acceptable, through-and-through! Time for a stint in the oven, first!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_cookiedough"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cookie
	cooked_smell = /datum/pollutant/food/cookies_chocolate
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookie
	name = "baked slab of cookiedough"
	desc = "The inverse to hardtack; both in reputation and taste. Just a passing whiff reminds you of home - though, perhaps it wouldn't hurt to bring out a knife and share that feeling with some friends."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedough6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_TINY
	tastes = list("rich and gooey chocolate" = 1, "crispy dough with a hint of butteriness" = 1)
	bitesize = 8
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cookieslice
	slice_batch = FALSE
	cooked_smell = /datum/pollutant/food/cookies_chocolate
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookie/update_icon()
	if(slices_num)
		icon_state = "cookiedough[slices_num]"
	else
		icon_state = "cookiedough_slice"

/obj/item/reagent_containers/food/snacks/rogue/cookie/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 5
		if(bitecount == 4)
			slices_num = 4
		if(bitecount == 5)
			slices_num = 3
		if(bitecount == 6)
			slices_num = 2
		if(bitecount == 7)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/cookieslice
	name = "cookie"
	desc = "Crispy, moist, sweet and savory; a sliver of ontological goodness, cradled in the palm of your hand."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedough_slice"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL + NUTRITION_QUARTER_MEAL)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	tastes = list("rich and gooey chocolate" = 1, "crispy dough with a hint of butteriness" = 1)
	foodtype = GRAIN | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookied_raw
	name = "slab of half-done dragéelidough"
	desc = "Doughy, soft, and speckled with dragée dropplings. A little less than 'unacceptable', but still far too raw to peck at.. maybe some more dragée, to round it out?"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_halfcookiedoughd"
	cooked_smell = /datum/pollutant/food/cookies_dragee
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookied_raw
	name = "slab of dragéelidough"
	desc = "Doughy, soft, and drenched in dragée. Now that is acceptable, through-and-through! Time for a stint in the oven, first!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_cookiedoughd"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cookied
	cooked_smell = /datum/pollutant/food/cookies_dragee
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookied
	name = "baked slab of dragéelidough"
	desc = "The inverse to hardtack; both in reputation and taste. Just a passing whiff reminds you of your youth - though, perhaps it wouldn't hurt to bring out a knife and share that feeling with some friends."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughd6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_TINY
	tastes = list("shards of candied herbiness" = 1, "crispy dough with a hint of butteriness" = 1)
	bitesize = 8
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cookiesliced
	slice_batch = FALSE
	cooked_smell = /datum/pollutant/food/cookies_dragee
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookied/update_icon()
	if(slices_num)
		icon_state = "cookiedoughd[slices_num]"
	else
		icon_state = "cookiedoughd_slice"

/obj/item/reagent_containers/food/snacks/rogue/cookied/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 5
		if(bitecount == 4)
			slices_num = 4
		if(bitecount == 5)
			slices_num = 3
		if(bitecount == 6)
			slices_num = 2
		if(bitecount == 7)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/cookiesliced
	name = "dragéelie"
	desc = "Crispy, moist, sweet and savory.. and in this case, oozing with sweetened lifeblood; a sliver of ontological goodness, cradled in the palm of your hand."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughd_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL + NUTRITION_QUARTER_MEAL, /datum/reagent/medicine/healthpot = 5)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	tastes = list("shards of candied herbiness" = 1, "crispy dough with a hint of butteriness" = 1)
	foodtype = GRAIN | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookiec_raw
	name = "slab of half-done carameliedough"
	desc = "Doughy, soft, and speckled with caramel dropplings. A little less than 'unacceptable', but still far too raw to peck at.. maybe some more caramel, to round it out?"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_halfcookiedoughc"
	w_class = WEIGHT_CLASS_NORMAL
	cooked_smell = /datum/pollutant/food/cookies_caramel
	eat_effect = null
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookiec_raw
	name = "slab of carameliedough"
	desc = "Doughy, soft, and drenched in caramel. Now that is acceptable, through-and-through! Time for a stint in the oven, first!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_cookiedoughc"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cookiec
	cooked_smell = /datum/pollutant/food/cookies_caramel
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookiec
	name = "baked slab of carameliedough"
	desc = "The inverse to hardtack; both in reputation and taste. Just a passing whiff reminds you of times abroad - though, perhaps it wouldn't hurt to bring out a knife and share that feeling with some friends."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughc6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_TINY
	tastes = list("tooth-grippingly sweet caramel" = 1, "crispy dough with a hint of butteriness" = 1)
	bitesize = 8
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cookieslicec
	slice_batch = FALSE
	cooked_smell = /datum/pollutant/food/cookies_caramel
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookiec/update_icon()
	if(slices_num)
		icon_state = "cookiedoughc[slices_num]"
	else
		icon_state = "cookiedoughc_slice"

/obj/item/reagent_containers/food/snacks/rogue/cookiec/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 5
		if(bitecount == 4)
			slices_num = 4
		if(bitecount == 5)
			slices_num = 3
		if(bitecount == 6)
			slices_num = 2
		if(bitecount == 7)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/cookieslicec
	name = "caramelie"
	desc = "Crispy, moist, sweet and savory.. and a bit stickier than usual; a sliver of ontological goodness, cradled in the palm of your hand."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughc_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL + NUTRITION_QUARTER_MEAL)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	tastes = list("tooth-grippingly sweet caramel" = 1, "crispy dough with a hint of butteriness" = 1)
	foodtype = GRAIN | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookier_raw
	name = "slab of half-done raelseinidough"
	desc = "Doughy, soft, and speckled with raisins. A little less than 'unacceptable', but still far too raw to peck at.. maybe some more raisins, to round it out?"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_halfcookiedoughr"
	w_class = WEIGHT_CLASS_NORMAL
	cooked_smell = /datum/pollutant/food/cookies_raisins
	eat_effect = null
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookier_raw
	name = "slab of raelseinidough"
	desc = "Doughy, soft, and drenched in raisins. Now that is acceptable, through-and-through! Time for a stint in the oven, first!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_cookiedoughr"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cookier
	cooked_smell = /datum/pollutant/food/cookies_raisins
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/cookier
	name = "baked slab of raelseinidough"
	desc = "The inverse to hardtack; both in reputation and taste. Just a passing whiff reminds you of warmer daes - though, perhaps it wouldn't hurt to bring out a knife and share that feeling with some friends."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughr6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_TINY
	tastes = list("little bursts of fruity sweetness" = 1, "crispy dough with a hint of butteriness" = 1)
	bitesize = 8
	slices_num = 6
	cooked_smell = /datum/pollutant/food/cookies_raisins
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cookieslicer
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/cookier/update_icon()
	icon_state = slices_num ? "cookiedoughr[slices_num]" : "cookiedoughr_slice"

/obj/item/reagent_containers/food/snacks/rogue/cookier/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/cookieslicer
	name = "raelseini"
	desc = "Crispy, moist, sweet and savory.. and the dreams of a warmer tomorrow; a sliver of ontological goodness, cradled in the palm of your hand."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughr_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL + NUTRITION_QUARTER_MEAL)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	tastes = list("little bursts of fruity sweetness" = 1, "crispy dough with a hint of butteriness" = 1)
	foodtype = GRAIN | DAIRY | FRUIT

// MISSING RECIPE
/obj/item/reagent_containers/food/snacks/rogue/cookie_unused		//It's a biscuit.......
	name = "微笑饼干"
	desc = "看起来不像开心的笑脸，更像痛苦扭曲的表情。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookie"
	color = "#ecce61"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw
	name = "生椒盐卷饼"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "prezzel_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/prezzel
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/prezzel
	name = "椒盐卷饼"
	desc = "仅次于切片面包的好东西。它的配方在矮人间是严守的秘密；他们对此执着到就连审判庭最痛苦的手段也撬不开口。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "prezzel"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	faretype = FARE_FINE
	tastes = list("酥脆黄油面皮" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.............   Pumpkin balls   ................ */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinball_raw
	name = "uncooked pumpkin ball"
	desc = "A simple ball of dough, yearning to be cookied or fried."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pumpkinball"
	color = "#d17624"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	w_class = WEIGHT_CLASS_SMALL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	name = "pumpkin balls"
	desc = "Crispy and soft ball of dough mixed with pumpkin. A surprisingly nice snack."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinball3"
	faretype = FARE_FINE
	filling_color = "#d17624"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_SMALL
	bitesize = 3
	portable = TRUE
	tastes = list("crispy butterdough" = 1, "pumpkin" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pumpkinball/On_Consume(mob/living/eater)
	. = ..()
	if(bitecount == 1)
		icon_state = "pumpkinball2"
	else if(bitecount == 2)
		icon_state = "pumpkinball1"
		name = "pumpkin ball"

/*	.............   Pumpkin loaf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinloaf_raw
	name = "raw pumpkin loaf"
	desc = "Into the oven you go!"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pumpkindough"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf
	name = "pumpkin loaf"
	desc = "A loaf of sweetbread baked into a shape worthy of its name. Pumpkin loaves are surprising desserts, easily shared."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinloaf6"
	bitesize = 6
	slices_num = 6
	portable = FALSE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pumpkinloafslice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("sweetbread" = 1,"pumpkin" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf/update_icon()
	if(slices_num)
		icon_state = "pumpkinloaf[slices_num]"
	else
		icon_state = "pumpkinloaf_slice"

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 5
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)
	update_icon()

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloafslice
	name = "pumpkin loaf slice"
	desc = "Soft and chewy. It's surprisingly light despite its origin."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinloaf_slice"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_NEUTRAL
	cooked_type = null
	tastes = list("sweetbread" = 1, "pumpkin" = 1)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw
	name = "生手馅饼"
	desc = "进烤炉吧！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "handpie_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	w_class = WEIGHT_CLASS_NORMAL
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/mushroom
	name = "生蘑菇手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	foodtype = GRAIN | VEGETABLES
	tastes = list("蘑菇香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish
	name = "生鱼肉手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	foodtype = GRAIN | MEAT
	tastes = list("鱼肉香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat
	name = "生肉手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	foodtype = GRAIN | MEAT
	tastes = list("肉香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/crab
	name = "生蟹肉手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	foodtype = GRAIN | MEAT
	tastes = list("蟹肉香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry
	name = "生浆果手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	foodtype = GRAIN | FRUIT
	tastes = list("浆果香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/poison
	name = "生浆果手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)
	foodtype = GRAIN | FRUIT
	tastes = list("苦涩浆果香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/apple
	name = "生苹果手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	foodtype = GRAIN | FRUIT
	tastes = list("苹果香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/potato
	name = "生土豆手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	foodtype = GRAIN | VEGETABLES
	tastes = list("土豆香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/cabbage//These two are classics no idea how it didn't already exist.
	name = "生卷心菜手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	foodtype = GRAIN | VEGETABLES
	tastes = list("卷心菜香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/handpie
	name = "手馅饼"
	desc = "矮人在自己的方言里也把它叫作“手馅饼”。在外皮被咬开之前，它能长久保持新鲜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "handpie"
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	bitesize = 4
	faretype = FARE_FINE
	bonus_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION+MINCE_NUTRITION)
	tastes = list("酥脆面皮" = 1)
	rotprocess = null
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/handpie/mushroom
	name = "蘑菇手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	name = "鱼肉手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	name = "肉手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	name = "土豆手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	name = "卷心菜手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	name = "蟹肉手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	name = "浆果手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	name = "浆果手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	name = "苹果手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/On_Consume(mob/living/eater)
	..()
	icon_state = "handpie[bitecount]"
	if(bitecount == 1)
		rotprocess = SHELFLIFE_DECENT
		addtimer(CALLBACK(src, PROC_REF(begin_rotting)), 20, TIMER_CLIENT_TIME)

/*	.................   Muffins   ................... */
/obj/item/reagent_containers/food/snacks/rogue/muffin
	name = "松饼"
	desc = "制作简单，人人都爱。像蘑菇一样的小点心，再加点配料会更好。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "muffin"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	tastes = list("酥脆黄油面皮" = 1)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/muffin/cheese
	name = "生奶酪松饼"
	desc = "一只蘑菇形的小点心，上面覆着奶酪。还需要继续烘烤！"
	icon_state = "muffin_cheese_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	cooked_smell = /datum/pollutant/food/muffin

/obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	name = "奶酪松饼"
	desc = "一只蘑菇形的小点心，上面覆着奶酪。很适合殷实农民享用。"
	icon_state = "muffin_cheese"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION)
	tastes = list("酥脆黄油面皮" = 1, "奶酪香" = 1)
	faretype = FARE_FINE
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/muffin/honey
	name = "生蜂蜜松饼"
	desc = "一只蘑菇形的小点心，上面覆着蜂蜜。还需要继续烘烤！"
	icon_state = "muffin_honey_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/honey/baked
	cooked_smell = /datum/pollutant/food/muffin

/obj/item/reagent_containers/food/snacks/rogue/muffin/honey/baked
	name = "蜂蜜松饼"
	desc = "一只蘑菇形的小点心，上面覆着蜂蜜。很适合市民享用。"
	icon_state = "muffin_honey"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	cooked_smell = /datum/pollutant/food/muffin
	faretype = FARE_FINE
	cooked_type = null

/*	.................   Strudel   ................... */
/obj/item/reagent_containers/food/snacks/rogue/strudel
	name = "果馅卷"
	desc = "格伦泽尔霍夫特农家食物的巅峰。一条填满苹果酱和坚果的长酥卷，足以驱走饥饿的绞痛。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "strudel"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION*2)
	tastes = list("酥苹果香" = 1, "石果" = 1)
	foodtype = GRAIN | FRUIT
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/strudelslice
	slice_batch = TRUE
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/strudelslice
	name = "果馅卷切片"
	desc = "一片满是苹果香甜的美味，只看着就让人口水直流。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "strudel_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("酥苹果香" = 1, "石果" = 1)
	foodtype = GRAIN | FRUIT
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = null
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/strudel/sugar
	name = "糖衣果馅卷"
	desc = "格伦泽尔霍夫特农家食物的巅峰。一条填满苹果酱和坚果的长酥卷，足以驱走饥饿的绞痛。这一份甚至还裹了糖衣！"
	icon_state = "strudel_sugar"
	tastes = list("酥苹果香" = 1, "石果" = 1 ,"糖香" = 1)
	faretype = FARE_LAVISH
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/strudelslice/sugar

/obj/item/reagent_containers/food/snacks/rogue/strudelslice/sugar
	name = "糖衣果馅卷切片"
	desc = "一片满是苹果香甜的美味，只看着就让人口水直流。要是再配点奶油，这就是送给审判官的完美礼物了。"
	icon_state = "strudel_sugar_slice"
	tastes = list("酥苹果香" = 1, "石果" = 1 ,"糖香" = 1)
	faretype = FARE_LAVISH

/*	.................   Tarts  ................... */
/obj/item/reagent_containers/food/snacks/rogue/dot_tart
	name = "dot tart"
	desc = "A small pastry filled with jammed fruits, for when a whole pie would be inappropiate for canapes."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "baked_dottart"
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	bitesize = 3
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT | DAIRY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_HALF_MEAL)
	tastes = list("crispy dough" = 1)
	rotprocess = SHELFLIFE_LONG
	dropshrink = 1

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/tangerine
	name = "tangerine dot tart"
	desc = "A small pastry filled with jammed tangerines, for when a whole pie would be inappropiate for canapes. </br>'If we're kind and polite, the world will be right.'"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerine_dottart"
	tastes = list("crispy dough" = 1, "tangerine jam with a hint of tarty-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/plum
	name = "plum dot tart"
	desc = "A small pastry filled with jammed plums, for when a whole pie would be inappropiate for canapes."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plum_dottart"
	tastes = list("crispy dough" = 1, "plum jam with a hint of honey-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/blackberry
	name = "blackberry dot tart"
	desc = "A small pastry filled with jammed blackberries, for when a whole pie would be inappropiate for canapes. </br>'I did it for me. I liked it.. I was good at it. And I felt.. alive.'"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "blackberry_dottart"
	tastes = list("crispy dough" = 1, "blackberry jam with a hint of sour-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/raspberry
	name = "raspberry dot tart"
	desc = "A small pastry filled with jammed raspberries, for when a whole pie would be inappropiate for canapes."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raspberry_dottart"
	tastes = list("crispy dough" = 1, "raspberry jam with a hint of tartness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/strawberry
	name = "strawberry dot tart"
	desc = "A small pastry filled with jammed strawberries, for when a whole pie would be inappropiate for canapes."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "strawberry_dottart"
	tastes = list("crispy dough" = 1, "strawberry jam with a hint of sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/pear
	name = "pear dot tart"
	desc = "A small pastry filled with jammed pears, for when a whole pie would be inappropiate for canapes."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pear_dottart"
	tastes = list("crispy dough" = 1, "pear jam with a hint of tarty-honeyiness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/apple
	name = "apple dot tart"
	desc = "A small pastry filled with jammed apples, for when a whole pie would be inappropiate for canapes."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "apple_dottart"
	tastes = list("crispy dough" = 1, "caramelized apples with a hint of tartness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/goldapple
	name = "ambrosia dot tart"
	desc = "A small pastry filled with the jam of a divine fruit, for when a whole pie would be inappropiate for canapes. </br>'Why must the most forbidden fruits taste the sweetest?'"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "gapple_dottart"
	list_reagents = list(/datum/reagent/medicine/stronghealth = 10)
	tastes = list("crispy dough" = 1, "divinely fruity sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/goldapple/Initialize()
	. = ..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 155, "size" = 1))

/*	.................   Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/rogue/bookbread
	name = "bookbread loaf"
	desc = "On the days when Noc's reign lengthens to its apex, all proper Pantheon-fearing folk huddle by their warm hearths, exchanging both books and pastries such as this."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/bookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/bookbread/update_icon()
	icon_state = slices_num ? "bookbread[slices_num]" : "bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/bookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)
/obj/item/reagent_containers/food/snacks/rogue/bookbread_slice
	name = "sliced bookbread"
	desc = "About the same size and taste as an encyclopedia."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/bookbread_slice_jamtallowed
	name = "slice of jamtallowed bookbread"
	desc = "'Don't think that I'd forget, or I'd regret, the special love I had for you - my baby blue!'"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread_slice_jamtallow"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweetly-sour jamminess" = 1, "a lavish start to the dae" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/bookbread_slice_marmaladed
	name = "slice of marmaladed bookbread"
	desc = "'I always keep a marmalade sandwich under my sallet, just in case!'"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread_slice_marmalade"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweet-tarty jamminess" = 1, "a lavish start to the dae" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/pearbookbread
	name = "pear bookbread"
	desc = "Children on Nocsmas are traditionally granted both book and pastry without expectation of exchange, this variety is prefered by most little ones."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pear_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pearbookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweetly caramelized pears" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/pearbookbread/update_icon()
	icon_state = slices_num ? "pear_bookbread[slices_num]" : "pear_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/pearbookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/pearbookbread_slice
	name = "sliced pear bookbread"
	desc = "Evokes the sweetness of younger, simpler times, and simpler books."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pear_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "sweetly caramelized pears" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/plumbookbread
	name = "plum bookbread"
	desc = "The origin of Nocsmas are shrouded in mystery, perhaps intentionally so, though some theorize it may have had its origins as an originally Psydonian holidae."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plum_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/plumbookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweetly frosted plums" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/plumbookbread/update_icon()
	icon_state = slices_num ? "plum_bookbread[slices_num]" : "plum_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/plumbookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/plumbookbread_slice
	name = "sliced plum bookbread"
	desc = "A subtle flavor, best for enjoying subtler books. Mysteries prefered."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plum_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "sweetly frosted plums" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/lemonbookbread
	name = "lemon bookbread"
	desc = "Though many followers of Her find the holidae laughable, it's undeniably an important respite from the doom and gloom of the darkest month."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "lemon_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweetly frosted lemons" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/lemonbookbread/update_icon()
	icon_state = slices_num ? "lemon_bookbread[slices_num]" : "lemon_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/lemonbookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/lemonbookbread_slice
	name = "sliced lemon bookbread"
	desc = "Sweet but a little sour, like a good Xylixian comedy."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "lemon_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "sweetly frosted lemons" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread
	name = "tangerine bookbread"
	desc = "Even the coldest, darkest nites end eventually. Better to weather them with friends than to hide away."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerine_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweetly jellied tangerines" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread/update_icon()
	icon_state = slices_num ? "tangerine_bookbread[slices_num]" : "tangerine_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread_slice
	name = "sliced tangerine bookbread"
	desc = "Fills one with heroic vigor and hopeful enthusiasm, similar to historic-fantasies of old."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerine_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "sweetly jellied tangerines" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread
	name = "blackberry bookbread"
	desc = "Following Her ascension, the great exchanging of books has met steady decline, as neighbor suspects neighbor more and more. Yet, even such prejudices could never hope to fully smother the spirit of Nocmas."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "blackberry_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweetly frosted blackberries" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread/update_icon()
	icon_state = slices_num ? "blackberry_bookbread[slices_num]" : "blackberry_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread_slice
	name = "sliced blackberry bookbread"
	desc = "It evokes a feeling of contrasting fascination and dread, not unlike novels that may foretell a doom similar to what befell this very berry."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "blackberry_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "sweetly frosted blackberries" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread
	name = "raspberry bookbread"
	desc = "Spending the long cold months in academic rather than intimate pursuit is preferable for most devout Noccians."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raspberry_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweetly frosted raspberries" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread/update_icon()
	icon_state = slices_num ? "raspberry_bookbread[slices_num]" : "raspberry_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread_slice
	name = "sliced raspberry bookbread"
	desc = "Has a taste that puts one in the mood for a good romance novel. For obvious reasons, this flavor isnt very popular with mages."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raspberry_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "sweetly frosted raspberries" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread
	name = "jacksberried bookbread"
	desc = "As Nocsmas gained broader appeal, more and more commonfolk with poor access to books instead chose to simply forego their exchanging, focusing instead on the preparation of food."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "jacksberry_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "sweetly frosted jackberries" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread/update_icon()
	icon_state = slices_num ? "jacksberry_bookbread[slices_num]" : "jacksberry_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread_slice
	name = "sliced jacksberried bookbread"
	desc = "Has an earthy taste that reminds the eater of growth cycles and rainfall percentages. Like a delicious almanac."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "jacksberry_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "sweetly frosted jackberries" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread
	name = "jacksberried bookbread"
	desc = "As Nocsmas gained broader appeal, more and more commonfolk with poor access to books instead chose to simply forego their exchanging, focusing instead on the preparation of food."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "jacksberry_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS, /datum/reagent/berrypoison = 12)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "bitterly frosted jackberries" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread/update_icon()
	icon_state = slices_num ? "jacksberry_bookbread[slices_num]" : "jacksberry_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread_slice
	name = "sliced jacksberried bookbread"
	desc = "Has an earthy taste that reminds the eater of growth cycles and rainfall percentages. Like a delicious almanac."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "jacksberry_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "bitterly frosted jackberries" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL, /datum/reagent/berrypoison = 12)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread
	name = "chocolate bookbread"
	desc = "Nocsmas is not only a holiday for children and commoners, for Noccians are found most concentrated in the upper echelons of society. For these academics, it provies a much needed opportunity to share their secrets."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "chocolate_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_HALF_MEAL)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "rich and gooey chocolate" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread/update_icon()
	icon_state = slices_num ? "chocolate_bookbread[slices_num]" : "chocolate_bookbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread/On_Consume(mob/living/eater)
    ..()
    if(!slices_num)
        return
    if(bitecount >= 7)
        changefood(slice_path, eater)
        return
    if(bitecount > 3)
        slices_num = (8 - bitecount)

/obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread_slice
	name = "sliced chocolate bookbread"
	desc = "As thick and rich as a child's bedtyme story."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "chocolate_bookbread_slice"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough", "rich and gooey chocolate" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_FULL_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | DAIRY
	
