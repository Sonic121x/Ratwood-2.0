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
	name = "lemony stickets"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "lemonstick5"
	desc = "'At times the world may seem an unfriendly and sinister place, but believe that there is much more good in it than \
	bad. All you have to do is look hard enough - and what might seem to be a series of unfortunate events may in fact be the \
	first steps of a refreshingly new journey.'"
	faretype = FARE_POOR
	fried_type = null
	bitesize = 5
	slice_path = null
	tastes = list("lip-puckering sweetness" = 1, "an unfortunate aftertaste of burnt wood" = 1)
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
	name = "brothbrique"
	desc = "A melding of dried meat, berries, and tallow that has fueled Psydonia's expeditioneers for centuries. It is \
	denser - and arguably less appetizing - than most foodstuffs, but consequently unrivaled in terms of sheer nutritional \
	mirth. Traditionally sliced and dropped into boiling water, in order to make a quick-yet-robust broth."
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
	tastes = list("salted meat" = 1, "dried berries" = 1, "a slightly greasy aftertaste" = 1)
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
	name = "slice of brothbrique"
	icon_state = "brothbrique_slice"
	bitesize = 3
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)

// ------------ HELLFIRE STEW - SALO N' TACK --------------
/obj/item/reagent_containers/food/snacks/balefire
	name = "salotack"
	desc = "Thick, salted biscuits and thicker, saltier slabs of pork fat, and a sprinkling of pepper; a match made in paradise. A spicier but heartier variant of the brothbrique, \
	its portions can be further divvied up with a knife and stewed into a remarkably hearty broth."
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
	name = "piece of salotack"
	desc = "A salted cracker and a slice of pork fat, smothered in pepper. An adventurer can afford the tyme to sit down and stew this into a \
	hearty meal; for most other soldiers-of-fortune, however, they might just have to settle with gnashing it on the go."
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
