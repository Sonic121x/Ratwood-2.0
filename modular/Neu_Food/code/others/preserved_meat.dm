// -------------- SALUMOI (dwarven smoked sausage) -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/salami
	name = "烟熏香肠"
	desc = "一种盐腌香肠，据说放上十年都不会坏。传说矮人商队正是拿这种“旅粮”夹在面包片里，做出了最早的三明治。"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "salumoi5"
	eat_effect = null
	fried_type = null
	slices_num = 4
	bitesize = 7
	slice_batch = FALSE
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice
	tastes = list("盐腌肉香" = 1)
	rotprocess = null
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/salami/update_icon()
	if(slices_num)
		icon_state = "salumoi[slices_num]"
	else
		icon_state = "salumoi_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/salami/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 4
		if(bitecount == 4)
			slices_num = 3
		if(bitecount == 5)
			slices_num = 2
		if(bitecount == 6)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice
	eat_effect = null
	slices_num = 0
	name = "烟熏香肠片"
	icon_state = "salumoi_slice"
	faretype = FARE_NEUTRAL
	fried_type = null
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	bitesize = 2
	tastes = list("盐腌肉香" = 1)

// -------------- COPPIETTE (dried meat) -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette
	eat_effect = null
	name = "风干肉条"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "jerk5"
	desc = "风干的肉糜条，做法与烟熏香肠相近。嚼起来更费劲些，但总比硬饼干柔软，也没那么干。"
	faretype = FARE_POOR
	fried_type = null
	bitesize = 5
	slice_path = null
	tastes = list("盐腌肉香" = 1)
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)

/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "jerk4"
	if(bitecount == 2)
		icon_state = "jerk3"
	if(bitecount == 3)
		icon_state = "jerk2"
	if(bitecount == 4)
		icon_state = "jerk1"

/obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette
	eat_effect = null
	name = "柠檬风味肉条"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "lemonstick5"
	desc = "'有时，世界看似一个充满敌意与邪恶的地方，但请相信，其中美好远多于丑恶。\
	你只需用心去看——那些看似一连串不幸的事件，或许正是通往崭新征程的第一步。\
	'"
	faretype = FARE_POOR
	fried_type = null
	bitesize = 5
	slice_path = null
	tastes = list("酸得让人皱脸的甜味" = 1, "一缕不幸的焦木余味" = 1)
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)

/obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "lemonstick4"
	if(bitecount == 2)
		icon_state = "lemonstick3"
	if(bitecount == 3)
		icon_state = "lemonstick2"
	if(bitecount == 4)
		icon_state = "lemonstick1"

// -------------- SALO (salted fat) -----------------
/obj/item/reagent_containers/food/snacks/fat/salo
	name = "盐腌肥膘"
	desc = "一整块盐腌猪肥膘，切片即食。瘦肉匮乏时，这是农户储藏间里的老伙计；配点水下肚还挺香。"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "salo4"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	bitesize = 6
	slice_path = /obj/item/reagent_containers/food/snacks/fat/salo/slice
	faretype = FARE_IMPOVERISHED
	slices_num = 4
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	eat_effect = null

/obj/item/reagent_containers/food/snacks/fat/salo/update_icon()
	if(slices_num)
		icon_state = "salo[slices_num]"
	else
		icon_state = "salo_slice"

/obj/item/reagent_containers/food/snacks/fat/salo/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/fat/salo/slice
	name = "盐腌肥膘片"
	icon_state = "saloslice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)

// ------------ PEMMICAN - BROTHBRICK --------------
/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	name = "汤砖"
	desc = "由干肉、浆果与板油融炼而成，数百年来一直是普赛多尼亚远征者的能量来源。\
	它比大多数食物更致密——也可以说更难以下咽——但论及纯粹的营养价值却无出其右。\
	传统上会切片丢入沸水，以便快速煮出一锅浓郁扎实的浓汤。"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "brothbrique4"
	eat_effect = null
	fried_type = null
	slices_num = 4
	bitesize = 6
	slice_batch = FALSE
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL * 2)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/slice
	tastes = list("咸肉" = 1, "干浆果" = 1, "一丝油润的余味" = 1)
	rotprocess = null
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/update_icon()
	if(slices_num)
		icon_state = "brothbrique[slices_num]"
	else
		icon_state = "brothbrique_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 5)
			slices_num = 2
		if(bitecount == 7)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/slice
	name = "汤砖片"
	icon_state = "brothbrique_slice"
	bitesize = 3
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)

// ------------ HELLFIRE STEW - SALO N' TACK --------------
/obj/item/reagent_containers/food/snacks/balefire
	name = "肥膘硬饼"
	desc = "厚实的咸饼干夹着更厚实、更咸的猪肥膘片，再撒上一点胡椒——天作之合。作为汤砖更辛辣也更扎实的变体，\
	它的份量可以用刀进一步细分，炖成一锅格外浓郁的浓汤。"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "balefire4"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL * 2)
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/balefire/slice
	faretype = FARE_NEUTRAL
	slices_num = 4
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	eat_effect = null

/obj/item/reagent_containers/food/snacks/balefire/update_icon()
	if(slices_num)
		icon_state = "balefire[slices_num]"
	else
		icon_state = "balefire_slice"

/obj/item/reagent_containers/food/snacks/balefire/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/balefire/slice
	name = "一块肥膘硬饼"
	desc = "一块撒满胡椒的咸脆饼与一片猪肥膘。冒险者有时间的话，可以坐下来把它炖成一锅扎实的餐食；\
	但对大多数雇佣兵而言，恐怕只能在赶路时嚼着将就了。"
	icon_state = "balefire_slice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL * 2)

// -------------- DRIED FISH FILET -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
	name = "风干鱼柳"
	desc = "一片咸得比活鱼还狠的水产肉片。沿海旅人几乎都会备上它，只是记得多带点水。"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "dried_fish_filet"
	eat_effect = null
	fried_type = null
	bitesize = 3
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	tastes = list("咸鱼香" = 1)
	rotprocess = null
