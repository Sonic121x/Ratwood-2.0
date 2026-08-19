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
	name = "未烤制的葡萄干饼干"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "biscuit_raw"
	color = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/biscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/chocolatebiscuit
	name = "巧克力饼干"
	desc = "一块酥脆的黄油酥点，里面点缀着黏稠的巧克力碎。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "chocolatebiscuit"
	faretype = FARE_LAVISH
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("酥脆黄油面皮" = 1, "浓郁甜腻的流心巧克力" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN| DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw
	name = "未烤制的巧克力饼干"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "chocolatebiscuit_raw"
	color = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolatebiscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/plumbiscuit
	name = "李子饼干"
	desc = "一块酥脆的黄油酥点，上面有带条纹的糖霜和软嫩的李子。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plumbiscuit"
	faretype = FARE_FINE
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("酥脆黄油面皮" = 1, "酸甜糖霜" = 1, "蜜烤李子" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/plumbiscuit_raw
	name = "未烤制的李子饼干"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plumbiscuit_raw"
	color = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/plumbiscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/tangerinebiscuit
	name = "蜜橘饼干"
	desc = "一块酥脆的黄油酥点，上面有厚实的糖霜和成熟的蜜橘。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerinebiscuit"
	faretype = FARE_FINE
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("酥脆黄油面皮" = 1, "清新糖霜" = 1, "微带果酱感的多汁蜜橘" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tangerinebiscuit_raw
	name = "未烤制的蜜橘饼干"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerinebiscuit_raw"
	color = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinebiscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/*	.................   Cookies  ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookie_raw
	name = "半成品曲奇面团块"
	desc = "软糯柔滑，点缀着巧克力碎。比"不能入口"稍微强上那么一点，但还是太生了，没法下嘴……也许再加些巧克力，让它变得更圆满？"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_halfcookiedough"
	cooked_smell = /datum/pollutant/food/cookies_chocolate
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookie_raw
	name = "曲奇面团块"
	desc = "软糯柔滑，浸透了巧克力。这下总算称得上尽善尽美了！不过，还是得先进烤炉待上一阵子！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_cookiedough"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cookie
	cooked_smell = /datum/pollutant/food/cookies_chocolate
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookie
	name = "烤好的曲奇面团块"
	desc = "无论名声还是味道，都与硬饼截然相反。哪怕只是匆匆一闻，也会让你想起家的味道——不过，或许拿出刀来，把这感觉分给几位朋友分享也不坏。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedough6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_TINY
	tastes = list("浓郁黏稠的巧克力" = 1, "带着一丝黄油香的酥脆面团" = 1)
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
	name = "曲奇"
	desc = "酥脆、湿润、又甜又咸；一小片本质的美好，就捧在你掌心。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedough_slice"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL + NUTRITION_QUARTER_MEAL)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	tastes = list("浓郁黏稠的巧克力" = 1, "带着一丝黄油香的酥脆面团" = 1)
	foodtype = GRAIN | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookied_raw
	name = "半成品糖丸曲奇面团块"
	desc = "软糯柔滑，点缀着糖丸碎屑。比"不能入口"稍微强上那么一点，但还是太生了，没法下嘴……也许再加些糖丸，让它变得更圆满？"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_halfcookiedoughd"
	cooked_smell = /datum/pollutant/food/cookies_dragee
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookied_raw
	name = "糖丸曲奇面团块"
	desc = "软糯柔滑，浸透了糖丸。这下总算称得上尽善尽美了！不过，还是得先进烤炉待上一阵子！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_cookiedoughd"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cookied
	cooked_smell = /datum/pollutant/food/cookies_dragee
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookied
	name = "烤好的糖丸曲奇面团块"
	desc = "无论名声还是味道，都与硬饼截然相反。哪怕只是匆匆一闻，也会让你想起少年时光——不过，或许拿出刀来，把这感觉分给几位朋友分享也不坏。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughd6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_TINY
	tastes = list("蜜渍草本的碎屑" = 1, "带着一丝黄油香的酥脆面团" = 1)
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
	name = "糖丸曲奇"
	desc = "酥脆、湿润、又甜又咸……而这一份还渗着甜蜜的生命之血；一小片本质的美好，就捧在你掌心。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughd_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL + NUTRITION_QUARTER_MEAL, /datum/reagent/medicine/healthpot = 5)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	tastes = list("蜜渍草本的碎屑" = 1, "带着一丝黄油香的酥脆面团" = 1)
	foodtype = GRAIN | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookiec_raw
	name = "半成品焦糖曲奇面团块"
	desc = "软糯柔滑，点缀着焦糖碎屑。比"不能入口"稍微强上那么一点，但还是太生了，没法下嘴……也许再加些焦糖，让它变得更圆满？"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_halfcookiedoughc"
	w_class = WEIGHT_CLASS_NORMAL
	cooked_smell = /datum/pollutant/food/cookies_caramel
	eat_effect = null
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookiec_raw
	name = "焦糖曲奇面团块"
	desc = "软糯柔滑，浸透了焦糖。这下总算称得上尽善尽美了！不过，还是得先进烤炉待上一阵子！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_cookiedoughc"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cookiec
	cooked_smell = /datum/pollutant/food/cookies_caramel
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cookiec
	name = "烤好的焦糖曲奇面团块"
	desc = "无论名声还是味道，都与硬饼截然相反。哪怕只是匆匆一闻，也会让你想起异乡的时光——不过，或许拿出刀来，把这感觉分给几位朋友分享也不坏。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughc6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_TINY
	tastes = list("甜到黏牙的焦糖" = 1, "带着一丝黄油香的酥脆面团" = 1)
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
	name = "焦糖曲奇"
	desc = "酥脆、湿润、又甜又咸……而且比平时更黏稠一些；一小片本质的美好，就捧在你掌心。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughc_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL + NUTRITION_QUARTER_MEAL)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	tastes = list("甜到黏牙的焦糖" = 1, "带着一丝黄油香的酥脆面团" = 1)
	foodtype = GRAIN | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookier_raw
	name = "半成品葡萄干曲奇面团块"
	desc = "软糯柔滑，点缀着葡萄干。比"不能入口"稍微强上那么一点，但还是太生了，没法下嘴……也许再加些葡萄干，让它变得更圆满？"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_halfcookiedoughr"
	w_class = WEIGHT_CLASS_NORMAL
	cooked_smell = /datum/pollutant/food/cookies_raisins
	eat_effect = null
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookier_raw
	name = "葡萄干曲奇面团块"
	desc = "软糯柔滑，浸透了葡萄干。这下总算称得上尽善尽美了！不过，还是得先进烤炉待上一阵子！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raw_cookiedoughr"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cookier
	cooked_smell = /datum/pollutant/food/cookies_raisins
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/cookier
	name = "烤好的葡萄干曲奇面团块"
	desc = "无论名声还是味道，都与硬饼截然相反。哪怕只是匆匆一闻，也会让你想起更温暖的日子——不过，或许拿出刀来，把这感觉分给几位朋友分享也不坏。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughr6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_TINY
	tastes = list("迸发的小小果甜" = 1, "带着一丝黄油香的酥脆面团" = 1)
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
	name = "葡萄干曲奇"
	desc = "酥脆、湿润、又甜又咸……还承载着一个更温暖明天的梦想；一小片本质的美好，就捧在你掌心。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookiedoughr_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL + NUTRITION_QUARTER_MEAL)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	tastes = list("迸发的小小果甜" = 1, "带着一丝黄油香的酥脆面团" = 1)
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
	name = "生南瓜球"
	desc = "一个简简单单的面团球，渴望被做成曲奇或下油锅炸一炸。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pumpkinball"
	color = "#d17624"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	w_class = WEIGHT_CLASS_SMALL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	name = "南瓜球"
	desc = "酥脆柔软的面团球，混入了南瓜。意外地可口的小吃。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinball3"
	faretype = FARE_FINE
	filling_color = "#d17624"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_SMALL
	bitesize = 3
	portable = TRUE
	tastes = list("酥脆黄油面皮" = 1, "南瓜香" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pumpkinball/On_Consume(mob/living/eater)
	. = ..()
	if(bitecount == 1)
		icon_state = "pumpkinball2"
	else if(bitecount == 2)
		icon_state = "pumpkinball1"
		name = "南瓜球"

/*	.............   Pumpkin loaf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinloaf_raw
	name = "生南瓜面包"
	desc = "进烤炉吧！"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pumpkindough"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf
	name = "南瓜面包"
	desc = "一条甜面包，烤成了配得上其名的形状。南瓜面包是出人意料的甜点，也很容易与人分享。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinloaf6"
	bitesize = 6
	slices_num = 6
	portable = FALSE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pumpkinloafslice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("甜面包香" = 1,"南瓜香" = 1)
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
	name = "南瓜面包片"
	desc = "柔软而有嚼劲。尽管出身如此，却意外地轻盈。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinloaf_slice"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_NEUTRAL
	cooked_type = null
	tastes = list("甜面包香" = 1, "南瓜香" = 1)
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
	name = "凹窝挞"
	desc = "一种填入果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "baked_dottart"
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	bitesize = 3
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT | DAIRY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + NUTRITION_HALF_MEAL)
	tastes = list("酥脆面皮" = 1)
	rotprocess = SHELFLIFE_LONG
	dropshrink = 1

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/tangerine
	name = "蜜橘凹窝挞"
	desc = "一种填入蜜橘果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。</br>"只要我们和善有礼，世界就会安好。""
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerine_dottart"
	tastes = list("酥脆面皮" = 1, "带着一丝酸甜的蜜橘果酱" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/plum
	name = "李子凹窝挞"
	desc = "一种填入李子果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plum_dottart"
	tastes = list("酥脆面皮" = 1, "带着一丝蜜甜的李子果酱" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/blackberry
	name = "黑莓凹窝挞"
	desc = "一种填入黑莓果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。</br>"我是为了自己才这么做的。我喜欢那样……我很擅长那样。而且我感觉……活着。""
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "blackberry_dottart"
	tastes = list("酥脆面皮" = 1, "带着一丝酸甜的黑莓果酱" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/raspberry
	name = "覆盆子凹窝挞"
	desc = "一种填入覆盆子果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raspberry_dottart"
	tastes = list("酥脆面皮" = 1, "带着一丝酸味的覆盆子果酱" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/strawberry
	name = "草莓凹窝挞"
	desc = "一种填入草莓果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "strawberry_dottart"
	tastes = list("酥脆面皮" = 1, "带着一丝甜味的草莓果酱" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/pear
	name = "梨香凹窝挞"
	desc = "一种填入梨果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pear_dottart"
	tastes = list("酥脆面皮" = 1, "带着一丝酸甜蜜意的梨果酱" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/apple
	name = "苹果凹窝挞"
	desc = "一种填入苹果果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "apple_dottart"
	tastes = list("酥脆面皮" = 1, "带着一丝酸味的焦糖苹果" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/goldapple
	name = "仙馔凹窝挞"
	desc = "一种填入神圣果实果酱的小酥点，适合在整只派显得过于隆重、不适合做开胃小点的时候。</br>"为何越是禁忌的果实，尝起来就越甜美？""
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "gapple_dottart"
	list_reagents = list(/datum/reagent/medicine/stronghealth = 10)
	tastes = list("酥脆面皮" = 1, "神圣的果香甜美" = 1)

/obj/item/reagent_containers/food/snacks/rogue/dot_tart/goldapple/Initialize()
	. = ..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 155, "size" = 1))

/*	.................   Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/rogue/bookbread
	name = "书形面包"
	desc = "当诺克的统治绵延至巅峰的那些日子里，所有敬畏万神殿的正经人都会围坐在温暖炉火旁，交换书籍与这样的酥点。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/bookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1)
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
	name = "书形面包切片"
	desc = "大小和味道都与百科全书相差无几。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/bookbread_slice_jamtallowed
	name = "涂了果酱的书形面包片"
	desc = ""别以为我会忘记，否则我会后悔，我曾对你怀有的那份特别的爱——我的小蓝！""
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread_slice_jamtallow"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "酸甜的果酱味" = 1, "一天中奢华的开始" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/bookbread_slice_marmaladed
	name = "涂了柑橘果酱的书形面包片"
	desc = ""我总会在轻盔底下藏一块柑橘果酱三明治，以防万一！""
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread_slice_marmalade"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "甜酸的果酱味" = 1, "一天中奢华的开始" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | DAIRY | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/pearbookbread
	name = "梨香书形面包"
	desc = "按照传统，诺克节这天孩子们能无偿得到书和酥点，无须交换；这种口味最受小家伙们青睐。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pear_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pearbookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "甜蜜的焦糖梨" = 1)
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
	name = "梨香书形面包切片"
	desc = "唤起年少时更简单时光、更简单书籍的甜蜜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pear_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "甜蜜的焦糖梨" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/plumbookbread
	name = "李子书形面包"
	desc = "诺克节的起源笼罩在迷雾之中，也许是故意如此；不过也有人推测，它最初可能源自普赛多尼亚的某个节日。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plum_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/plumbookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "甜蜜的糖霜李子" = 1)
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
	name = "李子书形面包切片"
	desc = "风味含蓄，最适合搭配更含蓄的书。悬疑小说尤佳。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "plum_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "甜蜜的糖霜李子" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/lemonbookbread
	name = "柠檬书形面包"
	desc = "尽管祂的许多信徒觉得这个节日荒唐可笑，但不可否认，它是在最黑暗月份里摆脱阴郁与绝望的重要喘息。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "lemon_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "甜蜜的糖霜柠檬" = 1)
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
	name = "柠檬书形面包切片"
	desc = "甜中带点酸，就像一出精彩的赛利克斯喜剧。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "lemon_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "甜蜜的糖霜柠檬" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread
	name = "蜜橘书形面包"
	desc = "再寒冷、再黑暗的夜晚也终有尽头。与其独自躲藏，不如与朋友一同度过。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerine_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "甜蜜的蜜橘果胶" = 1)
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
	name = "蜜橘书形面包切片"
	desc = "让人充满英雄气概与满怀希望的热情，就像古老的英雄传奇一样。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "tangerine_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "甜蜜的蜜橘果胶" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread
	name = "黑莓书形面包"
	desc = "自祂飞升之后，盛大的换书传统便日渐式微，邻里之间的猜忌越来越深。然而，即便这样的偏见也永远无法彻底扼杀诺克节的精神。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "blackberry_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "甜蜜的糖霜黑莓" = 1)
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
	name = "黑莓书形面包切片"
	desc = "它唤起一种既着迷又恐惧的复杂感受，就像那些预示着厄运的小说——而这厄运与这种浆果自身的遭遇如出一辙。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "blackberry_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "甜蜜的糖霜黑莓" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread
	name = "覆盆子书形面包"
	desc = "对大多数虔诚的诺克信徒而言，在漫长寒冷的月份里钻研学问，而非沉溺于亲密之事，是更可取的选择。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raspberry_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "甜蜜的糖霜覆盆子" = 1)
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
	name = "覆盆子书形面包切片"
	desc = "它的味道会让人想读一本精彩的爱情小说。出于显而易见的原因，这种口味在法师中不太受欢迎。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "raspberry_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "甜蜜的糖霜覆盆子" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread
	name = "杰克莓书形面包"
	desc = "随着诺克节越来越受欢迎，越来越多难以获得书籍的平民干脆放弃了换书，转而专注于准备食物。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "jacksberry_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "甜蜜的糖霜杰克莓" = 1)
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
	name = "杰克莓书形面包切片"
	desc = "带有泥土气息，让食客想起生长周期和降雨概率。就像一本美味的历书。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "jacksberry_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "甜蜜的糖霜杰克莓" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread
	name = "杰克莓书形面包"
	desc = "随着诺克节越来越受欢迎，越来越多难以获得书籍的平民干脆放弃了换书，转而专注于准备食物。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "jacksberry_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS, /datum/reagent/berrypoison = 12)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "苦涩的糖霜杰克莓" = 1)
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
	name = "杰克莓书形面包切片"
	desc = "带有泥土气息，让食客想起生长周期和降雨概率。就像一本美味的历书。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "jacksberry_bookbread_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "苦涩的糖霜杰克莓" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL, /datum/reagent/berrypoison = 12)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread
	name = "巧克力书形面包"
	desc = "诺克节不仅是孩子与平民的节日，诺克信徒在社会上层最为集中。对这些学者而言，它提供了分享秘密的绝佳机会。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "chocolate_bookbread5"
	slices_num = 5
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_HALF_MEAL)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮" = 1, "浓郁黏稠的巧克力" = 1)
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
	name = "巧克力书形面包切片"
	desc = "像孩子的睡前故事一样浓稠丰厚。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "chocolate_bookbread_slice"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("耐嚼、边缘酥脆的黄油面皮", "浓郁黏稠的巧克力" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_FULL_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | DAIRY
	
