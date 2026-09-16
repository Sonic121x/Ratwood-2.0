// Generic baked products. Also includes their intermediary forms (raw) before baking.
// For consistency.

/*	.................   Hardtack   ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	name = "生硬饼"
	desc = "软塌塌的生面团，根本不能入口。撒上一些巧克力碎或许能让它更易入口一些。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raw_tack"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/hardtack

/*	.................   Hardtack   ................... */
/obj/item/reagent_containers/food/snacks/rogue/crackerscooked
	name = "硬饼"
	desc = "又脆又硬，像在啃石头。不过，这种咸饼干永远不会坏；对穿越普赛多尼亚的旅人来说，仅此一点就足以让它在行囊里占个位置。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "tack6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	faretype = FARE_POOR
	w_class = WEIGHT_CLASS_TINY
	tastes = list("斯佩耳特麦香" = 1)
	bitesize = 6
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/crackerscooked/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "tack5"
	if(bitecount == 2)
		icon_state = "tack4"
	if(bitecount == 3)
		icon_state = "tack3"
	if(bitecount == 4)
		icon_state = "tack2"
	if(bitecount == 5)
		icon_state = "tack1"


/*	.................   Bread   ................... */
/obj/item/reagent_containers/food/snacks/rogue/bread
	name = "面包条"
	desc = "普赛多尼亚的主食之一，由发酵面团制成。从贫民到教廷贵人，没人能否认一条新鲜出炉面包那朴素的美好。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "loaf6"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	list_reagents = list(/datum/reagent/consumable/nutriment = DOUGH_NUTRITION)
	faretype = FARE_POOR
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/bread/update_icon()
	if(slices_num)
		icon_state = "loaf[slices_num]"
	else
		icon_state = "loaf_slice"

/obj/item/reagent_containers/food/snacks/rogue/bread/On_Consume(mob/living/eater)
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

/*	.................   Breadslice & Toast   ................... */
/obj/item/reagent_containers/food/snacks/rogue/breadslice
	name = "面包片"
	desc = "一天伊始的小小慰藉。无论夹上一片烟熏香肠、盐腌肥膘、奶酪、煎培根还是果酱，都是再合适不过的承载。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "loaf_slice"
	faretype = FARE_POOR
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8

//this is a child so we can be used in sammies
/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	name = "吐司"
	desc = "酥脆爽口却没有烤焦，简直像炼金奇迹。最适合配煎蛋、一块切片黄油或新鲜制作的果酱一起吃。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "toast"
	faretype = FARE_NEUTRAL
	tastes = list("酥脆面包香" = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs
	cooked_type = null
	bitesize = 3
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/buttered
	name = "黄油吐司"
	desc = "酥脆爽口却没有烤焦，简直像炼金奇迹。现在又涂上了厚厚一层黄油。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "toast_butter"
	faretype = FARE_FINE
	tastes = list("黄油香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)

/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/jamtallowed_slice
	tastes = list("酥脆酸甜的果酱香" = 1, "美好一天的开始" = 1)
	name = "黑莓果酱吐司"
	desc = "黑莓果酱抹在一片吐司上。它是普赛多尼亚农民与自耕农钟爱的美味，通常被留作特别日子早晨的点缀。"
	faretype = FARE_FINE
	icon_state = "toast_jamtallow"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/marmaladed_slice
	tastes = list("酥脆甜酸的果酱香" = 1, "美好一天的结束" = 1)
	name = "橘子酱吐司"
	desc = "橘子酱夹在两片去边的温热面包之间。一口下去，连饿熊的肚子都能填饱！"
	faretype = FARE_FINE
	icon_state = "toast_marmalade"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs
	name = "吐司碎"
	desc = "非常适合给油炸食物增加一点酥脆口感。"
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "toastcrumbs"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = 6)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("酥脆口感" = 1)
	cooked_type = null
	foodtype = GRAIN
	bitesize = 1
	rotprocess = SHELFLIFE_DECENT

// -------------- BREAD WITH FOOD ON IT (not american sandwich) -----------------
/obj/item/reagent_containers/food/snacks/rogue/sandwich
	desc = "每一片都像是令人愉悦的天赐美味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	bitesize = 4
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/sandwich/salami
	tastes = list("烟熏香肠" = 1,"面包香" = 1)
	name = "烟熏香肠面包"
	desc = "一片吐司上放着薄薄的烟熏香肠片。行军中的士兵常吃这个。咸香！"
	icon_state = "bread_salami"
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese
	tastes = list("奶酪香" = 1,"面包香" = 1)
	name = "奶酪面包"
	desc = "一片吐司上有一角相当薄的奶酪，融进了面包皮里。"
	icon_state = "bread_cheese"
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/sandwich/egg
	tastes = list("奶酪香" = 1,"鸡蛋香" = 1)
	name = "鸡蛋吐司"
	desc = "一片吐司上放着煎蛋，轻轻一碰就会微微颤动。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL * 2)
	icon_state = "bread_egg"
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/rogue/sandwich/salo
	tastes = list("咸香油脂" = 1)
	name = "盐腌肥膘面包"
	desc = "肥膘顺滑的质地有助于软化粗糙的谷粒面包。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL * 2)
	faretype = FARE_POOR
	icon_state = "bread_salo"
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/rogue/sandwich/bacon
	tastes = list("培根香" = 1)
	name = "培根面包"
	desc = "一片面包上放着酥脆培根，成就完美早餐。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL * 2)
	icon_state = "toast_bacon"
	foodtype = GRAIN | MEAT
/*
/obj/item/reagent_containers/food/snacks/rogue/sandwich/tartar
	tastes = list("dissapointment" = 1)
	name = "tartar bread"
	desc = "A slice of bread with tartar on top for the perfect breakfast. What's that stench?"
	faretype = FARE_POOR
	icon_state = "toast_tartar"
	foodtype = GRAIN | MEAT
*/
/obj/item/reagent_containers/food/snacks/rogue/sandwich/ham
	tastes = list("火腿香" = 1,"面包香" = 1)
	name = "火腿面包"
	desc = "一片吐司上放着厚厚一片火腿。许多市民都喜爱的美味。"
	icon_state = "toast_ham"
	foodtype = GRAIN | MEAT

/*	.................   Bread Buns   ................... */
/obj/item/reagent_containers/food/snacks/rogue/bun
	name = "小圆面包"
	desc = "便于携带、朴实无华，而且完全可以吃光——适合讲究的旅人。它渴望再配上香肠、一角奶酪或一些美味的果酱来好好打扮一番。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "bun"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	faretype = FARE_POOR
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/bun_jamtallow
	name = "黑莓果酱面包"
	desc = "纳莱迪沙漠漫长孤寂的跋涉途中，带上它是绝佳的美味；如果你恰好走私了足够买下阿斯特拉塔王座的星糖，那就更是如此。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	tastes = list("酸甜的果酱香" = 1, "从今日烦恼中奢侈地逃离" = 1)
	icon_state = "bun_jamtallow"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/bun_marmalade
	name = "橘子酱面包"
	desc = "费伦提亚森林漫长孤寂的跋涉途中，带上它是绝佳的美味；如果你恰好是一只涂满油脂的熊类兽裔，那就更是如此。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	tastes = list("甜酸交织的果酱香" = 1, "从今日烦恼中奢侈地逃离" = 1)
	icon_state = "bun_marmalade"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/* 	.................   Crossbuns   ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw
	name = "生十字面包"
	desc = "一块生面团，上面压出了阿斯特拉塔十字的形状。沐于她的光辉之下。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "crossbun_raw"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/crossbun

// Psydon variant
/obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw
	name = "生普赛圣十字面包"
	desc = "一块生面团，上面压出了普赛圣十字的形状。祂长存不灭。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "psycrossbun_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun

/* 	.................   Crossbuns   ................... */
/obj/item/reagent_containers/food/snacks/rogue/crossbun
	name = "十字面包"
	desc = "普赛多尼亚的修道院传统上以它为早餐。阿斯特拉塔人尤其习惯在十字面包上加一片橘子酱，以示对祂金色权威的\
	敬意。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "crossbun"
	faretype = FARE_NEUTRAL // Having nobles vomit from eating holy buns is not a good idea
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/crossbun_jamtallowed
	name = "黑莓果酱十字面包"
	desc = "如此罪恶的美味！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "crossbun_jamtallow"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	tastes = list("甜酸交织的果酱香" = 1, "一种神圣的满足感" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/crossbun_marmaladed
	name = "橘子酱十字面包"
	desc = "在格伦泽尔霍夫特与伊特鲁斯卡的教廷中尤为受宠的美味，尤其是在向阿斯特拉塔致敬的节日期间。\
	据说橘子酱象征着太阳受祝福的光芒与温暖的辉光，\
	不过这种精神上的意涵往往被那些更心急的孩子们所忽略。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "crossbun_marmalade"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	tastes = list("甜酸交织的果酱香" = 1, "一种神圣的共鸣感" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/psycrossbun
	name = "普赛圣十字面包"
	desc = "你能抵御多久吃它的诱惑？想必，你也不敢再往上面涂果酱吧……？"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "psycrossbun"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	faretype = FARE_NEUTRAL // Having nobles vomit from eating holy buns is not a good idea
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/psycrossbun_jamtallowed
	name = "黑莓果酱普赛圣十字面包"
	desc = "在奥塔瓦与岩丘的教廷中尤为受宠的美味，尤其是在向普赛顿的牺牲致敬的节日期间。\
	据说黑莓果酱象征着泣神的泪水，\
	不过这种精神上的意涵往往被那些更心急的孩子们所忽略。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "psycrossbun_jamtallow"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	tastes = list("甜酸交织的果酱香" = 1, "一种绵长的悲伤" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/psycrossbun_marmaladed
	name = "橘子酱普赛圣十字面包"
	desc = "等等，不该是反过来的吗？啊，算了！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "psycrossbun_marmalade"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	tastes = list("酸甜的果酱香" = 1, "一种持续的困惑" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	foodtype = GRAIN | FRUIT

/*	.................   Raisin Bread   ................... */
/obj/item/reagent_containers/food/snacks/rogue/rbread_half
	name = "未完成的葡萄干面团"
	desc = "还需要更多葡萄干！"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dough_raisin"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/rbreaduncooked
	name = "生葡萄干面包"
	desc = "该进烤炉了！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raisinbreaduncooked"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/raisinbread
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	cooked_smell = /datum/pollutant/food/raisin_bread

/obj/item/reagent_containers/food/snacks/rogue/raisinbread
	name = "葡萄干面包"
	desc = "平民中广受欢迎的甜点，这条甜面包上点缀着水果的惊喜。近些年来，它在教廷中也赢得了更多青睐：正是岩丘的修道院为它命名了一款裹着糖衣釉面的变种。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raisinbread6"
	bitesize = 8
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("酥脆面香" = 1,"焦糖水果的小惊喜" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/raisinbread/update_icon()
	if(slices_num)
		icon_state = "raisinbread[slices_num]"
	else
		icon_state = "raisinbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/raisinbread/On_Consume(mob/living/eater)
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

/obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice
	name = "葡萄干面包片"
	desc = "松软有嚼劲。营养又顶饱。朴实而体面。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raisinbread_slice"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL-1)
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_NEUTRAL
	cooked_type = null
	tastes = list("酥脆面香" = 1,"焦糖水果的小惊喜" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.................   Apple Bread   ................... */
/obj/item/reagent_containers/food/snacks/rogue/abread_half
	name = "未完成的苹果面团"
	desc = "还需要更多苹果片！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "dough_apple"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/abreaduncooked
	name = "生苹果面包"
	desc = "该进烤炉了！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "applebread_uncooked"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/applebread
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	cooked_smell = /datum/pollutant/food/apple_bread

/obj/item/reagent_containers/food/snacks/rogue/applebread
	name = "苹果面包"
	desc = "备受喜爱的“葡萄干面包”有位更新鲜的表亲，缀满了烤苹果，敢在贪食者的舌尖融化。无论平民还是贵族，它在瓦洛里亚人心中都占据着特殊的位置。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "applebread6"
	bitesize = 8
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/applebreadslice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("酥脆面香" = 1,"软糯多汁的苹果" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/applebread/update_icon()
	if(slices_num)
		icon_state = "applebread[slices_num]"
	else
		icon_state = "applebread_slice"

/obj/item/reagent_containers/food/snacks/rogue/applebread/On_Consume(mob/living/eater)
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

/obj/item/reagent_containers/food/snacks/rogue/applebreadslice
	name = "苹果面包片"
	desc = "松软有嚼劲。营养又顶饱。朴实却奢华。毫无疑问，比葡萄干更胜一筹。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "applebread_slice"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_FINE
	cooked_type = null
	tastes = list("酥脆面香" = 1,"软糯多汁的苹果" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.................   Tomatoplate  ................... */
/obj/item/reagent_containers/food/snacks/rogue/tomatoplate
	name = "番茄薄饼"
	desc = "源自费伦提亚海岸的烹饪佳肴，据称源于很久以前涌入的伊特鲁斯卡难民之手。扁面饼上番茄酱的浓郁风味，被其 \
	奶酪外衣完美衬托；只差一杯冰凉的啤酒，以及一场 \
	可供起哄的灯笼球赛。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "pizza"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/tomatoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "一丝草本清香" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/tomatoplate_slice
	name = "番茄薄饼切片"
	desc = "“远超各部分之和”的终极诠释。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "pizza_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "一丝草本清香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/meattomatoplate
	name = "香肠番茄薄饼"
	desc = "源自费伦提亚海岸的烹饪佳肴，据称源于很久以前涌入的伊特鲁斯卡难民之手。扁面饼上番茄酱的浓郁风味，被其 \
	奶酪外衣与酥脆香肠完美衬托；只差一杯冰凉的啤酒，以及一场 \
	可供起哄的灯笼球赛。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "meat_pizza"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "酥脆香肠" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | FRUIT | DAIRY | MEAT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/meattomatoplate_slice
	name = "香肠番茄薄饼切片"
	desc = "你是说这是巴奥莎最喜欢的那种切片？"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "meat_pizza_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "酥脆香肠" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | FRUIT | DAIRY | MEAT
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate
	name = "鱼肉番茄薄饼"
	desc = "源自费伦提亚海岸的烹饪佳肴，据称源于很久以前涌入的伊特鲁斯卡难民之手。扁面饼上番茄酱的浓郁风味，被其 \
	奶酪外衣与油润鱼肉完美衬托；只差一杯冰凉的啤酒，以及一场 \
	可供起哄的灯笼球赛。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "fish_pizza"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "油润鱼肉" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | FRUIT | DAIRY | MEAT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate_slice
	name = "鱼肉番茄薄饼切片"
	desc = "恕我直言，大人，但我特意吩咐过不要放鳀鱼或沙丁鱼！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "fish_pizza_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "油润鱼肉" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | FRUIT | DAIRY | MEAT
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/oniontomatoplate
	name = "洋葱番茄薄饼"
	desc = "源自费伦提亚海岸的烹饪佳肴，据称源于很久以前涌入的伊特鲁斯卡难民之手。扁面饼上番茄酱的浓郁风味，被其 \
	奶酪外衣与爽脆洋葱完美衬托；只差一杯冰凉的啤酒，以及一场 \
	可供起哄的灯笼球赛。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "onion_pizza"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/oniontomatoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "爽脆洋葱" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/oniontomatoplate_slice
	name = "洋葱番茄薄饼切片"
	desc = "恕我直言，大人，但我特意吩咐过不要放鳀鱼或沙丁鱼！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "onion_pizza_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "爽脆洋葱" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/truffletomatoplate
	name = "松露番茄薄饼"
	desc = "源自费伦提亚海岸的烹饪佳肴，据称源于很久以前涌入的伊特鲁斯卡难民之手。扁面饼上番茄酱的浓郁风味，被其 \
	奶酪外衣与奢华松露完美衬托；只差一杯冰凉的啤酒，以及一场 \
	可供起哄的灯笼球赛。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "onion_pizza"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/truffletomatoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "咸鲜奢华的松露" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/truffletomatoplate_slice
	name = "松露番茄薄饼切片"
	desc = "配得上国王的切片！……当然，前提是那头松露猪没有碰巧拱到一片有毒的松露。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "onion_pizza_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "咸鲜奢华的松露" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/greatsnackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/poisontruffletomatoplate
	name = "松露番茄薄饼" //Like jackberried treats, this is a poisoned variant! For those who don't properly source their truffles.. or simply want to poison others!
	desc = "源自费伦提亚海岸的烹饪佳肴，据称源于很久以前涌入的伊特鲁斯卡难民之手。扁面饼上番茄酱的浓郁风味，被其 \
	奶酪外衣与奢华松露完美衬托；只差一杯冰凉的啤酒，以及一场 \
	可供起哄的灯笼球赛。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "truffle_pizza"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/poisontruffletomatoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/berrypoison = 5)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "橡胶般苦涩的松露" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/poisontruffletomatoplate_slice
	name = "松露番茄薄饼切片" //Ditto.
	desc = "配得上国王的切片！……当然，前提是那头松露猪没有碰巧拱到一片有毒的松露。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "onion_pizza_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/berrypoison = 5)
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "橡胶般苦涩的松露" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/greatsnackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/peartomatoplate
	name = "梨香番茄薄饼"
	desc = "费伦提亚经典的有趣变奏，出自范德林最受尊崇的烹饪大师之手。扁面饼上番茄酱的浓郁风味，被其奶酪外衣 \
	与甘甜梨肉完美衬托；这曲风味的旋律，数个世纪以来一直鼓舞着 \
	普赛多尼亚艺术家的创造力——希望未来数个世纪亦然。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "pear_pizza"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/peartomatoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "甜中带酸的梨香" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/peartomatoplate_slice
	name = "梨香番茄薄饼切片"
	desc = "你绝不会想到，如此迥异的食材竟能美妙地融为一体；然而它们确实做到了！这便是创造的乐趣……"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "pear_pizza_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("浓郁顺滑的咸番茄味" = 1, "滚烫拉丝的奶酪香" = 1, "咸鲜微酸的梨香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | FRUIT | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.................   Cheese Bun   ................... */

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesebun_raw
	name = "生奶酪面包"
	desc = "该进烤炉了！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "cheesebun_raw"
	color = "#ecce61"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cheesebun
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cheesebun
	name = "新鲜奶酪面包"
	desc = "来自格伦泽尔霍夫特厨房的别致小点。"
	faretype = FARE_FINE
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "cheesebun"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION+FRESHCHEESE_NUTRITION)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("酥脆面包与鲜奶酪香" = 1)
	foodtype = GRAIN | DAIRY
	bitesize = 3
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/bun_raston
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	tastes = list("奶酪香" = 1, "面包香" = 1)
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raston"
	name = "奶酪夹心面包"
	faretype = FARE_FINE
	desc = "一片奶酪融化在两片微烤的小圆面包之间。"
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/*	.................   Miscellanious Buns   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybread
	name = "煎面饼"
	desc = "用黄油煎到酥脆的扁面饼，是精灵厨房的主食之一。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "frybread"
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION)
	tastes = list("外酥内软的面包香" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/bun_grenz
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION+SMALLDOUGH_NUTRITION)
	tastes = list("咸香香肠" = 1, "面包香" = 1)
	name = "格伦泽尔面包肠"
	desc = "经典的面包夹香肠，如今已是格伦泽尔霍夫特菜肴的常客。据说很久以前是精灵最先发明了它，那时他们还会吃别的人……"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "grenzbun"
	foodtype = GRAIN | MEAT
	faretype = FARE_NEUTRAL
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatsnackbuff
