// High efforts (i.e. spiced / buttered / onioned or whatever) meal where meat
// Is the main ingredient.
/*	..................   Pepper steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/peppersteak
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	tastes = list("牛排香" = 1, "胡椒香" = 1)
	name = "胡椒牛排"
	desc = "烤肉表面厚厚覆着磨碎黑胡椒，滋味浓烈。"
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "peppersteak"
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/*	..................   Ducal steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal
	tastes = list("牛排香" = 1, "胡椒香" = 1, "大蒜香" = 1)
	name = "公爵牛排"
	desc = "烤肉表面厚厚覆着磨碎黑胡椒，滋味浓烈，还抹上了大蒜。据说曾是疯公爵最爱的菜肴。"
	faretype = FARE_LAVISH
	icon_state = "ducalsteak"
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	..................   Onion steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/onionsteak
	name = "洋葱牛排"
	desc = "烤肉配上香气四溢的炸洋葱，再浇上两者交融出的肉汁，成就一份令人垂涎的酱汁。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "onionsteak"
	tastes = list("牛排香" = 1, "洋葱香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	foodtype = MEAT
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/*	..................   Carrot Steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/carrotsteak
	name = "胡萝卜牛排"
	desc = "烤肉配上咸香烤胡萝卜，再浇上两者交融出的肉汁，成就一份令人垂涎的酱汁。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "carrotsteak"
	tastes = list("牛排香" = 1, "胡萝卜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	foodtype = MEAT
	faretype = FARE_FINE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/*	.................   Steak & carrot & onion   ................... */
/obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("牛排香" = 1, "洋葱香" = 1, "胡萝卜香" = 1)
	name = "牛排餐"
	desc = "烤肉配上咸香烤胡萝卜与香气四溢的炸洋葱，再浇上三者交融出的肉汁，成就一份令人垂涎的酱汁。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "steakmeal"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Wiener Cabbage   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienercabbage
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	tastes = list("咸香香肠" = 1, "卷心菜香" = 1)
	name = "卷心菜香肠"
	desc = "丰盛扎实的一餐，最适合行军中的士兵。"
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wienercabbage"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff


/*	.................   Wiener & Fried potato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotato
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	tastes = list("咸香香肠" = 1, "土豆香" = 1)
	name = "土豆香肠"
	desc = "扎实又顶饱。"
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wienerpotato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Wiener & Fried onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wieneronions
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	tastes = list("咸香香肠" = 1, "炸洋葱香" = 1)
	name = "洋葱香肠"
	desc = "扎实又够味。"
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wieneronion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Wiener & potato & onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("咸香香肠" = 1, "土豆香" = 1)
	name = "土豆洋葱香肠"
	desc = "扎实又滋补。"
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wpotonion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................  Spiced Baked Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced
	name = "香料烤禽"
	desc = "一只肥美禽鸟被烤得恰到好处，再以香料调味得近乎神赐。"
	faretype = FARE_LAVISH
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "pepperchicken"
	tastes = list("辛香禽肉" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................  Ducal Spiced Baked Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal
	name = "公爵烤禽"
	desc = "一只肥美禽鸟烤得恰到好处，香料调味得近乎神赐，最后再以大蒜点缀。最适合在你儿子战死沙场时大快朵颐……"
	faretype = FARE_LAVISH
	icon_state = "ducalchicken"
	tastes = list("辛香禽肉" = 1, "大蒜香" = 1)
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................  Baked Butter Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter
	name = "黄油烤禽"
	desc = "一只肥美禽鸟被烤得恰到好处，内部满是融化黄油。"
	faretype = FARE_LAVISH
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "butterchicken"
	tastes = list("黄油禽肉香" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................  Baked Double Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked
	name = "塞鸟烤禽"
	desc = "一只肥美禽鸟烤得恰到好处……里面还塞了另一只鸟——是什么驱使你做出这种东西的？普赛顿为你的傲慢而哭泣。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "stuffedchicken"
	eat_effect = /datum/status_effect/buff/mealbuff
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER*2)

/*	.................   Frybird & Tato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdtato
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	tastes = list("炸禽肉香" = 1, "土豆香" = 1)
	name = "炸鸟排配土豆"
	desc = "扎实、慰藉而丰盛——有人说这是拉沃克斯最爱的菜肴。"
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frybirdtato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Frybird Bucket   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER*3)
	tastes = list("炸禽肉香" = 1)
	name = "炸鸟排桶"
	desc = "扎实、慰藉而丰盛。谷地的炸鸟排是全大陆最棒的！现在还装在方便的桶里！"
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frybirdbucket"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............   Fried Cabbit w/ Garlick  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick
	name = "大蒜卡比特肉"
	desc = "一块卡比特肉，炸至完美的酥脆口感——外层裹满大蒜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frycabbit_garlick"
	tastes = list("热卡比特肉香" = 1, "大蒜香" = 1)

/* .............   Fried Cabbit w/ Garlick & Cucumber ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/cucumber
	name = "精灵卡比特烤肉"
	desc = "一块卡比特肉，炸至完美的酥脆口感——外层裹满大蒜，再配上一旁的黄瓜。游侠们认为这会带来好运！"
	icon_state = "frycabbit_garlick_cucumber"
	tastes = list("热卡比特肉香" = 1, "大蒜香" = 1, "黄瓜香" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Garlicked Fried Volf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick
	name = "大蒜沃尔夫肉"
	desc = "一块沃尔夫肉，煎至完美的五分熟。略带野味也有些韧，但很好吃。这块还裹满了大蒜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "fryvolf_garlick"
	tastes = list("野味沃尔夫香" = 1, "大蒜香" = 1)

/* .............  Garlicked Fried Volf w/ Cucumber  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/cucumber
	name = "猎人之宴"
	desc = "一块沃尔夫肉，煎至完美的五分熟。略带野味也有些韧，但很好吃。这块裹满了大蒜，还配上一旁的黄瓜。"
	icon_state = "fryvolf_garlick_cucumber"
	tastes = list("野味沃尔夫香" = 1, "大蒜香" = 1, "黄瓜香" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Honey glazed venison ribs  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs/cooked/glazed
	name = "森林蜜汁"
	desc = "一份鹿肋排，以蜂蜜上釉至完美。金棕色的肉几乎光可鉴人，能映出你自己的倒影。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "ribs_glazed"
	tastes = list("甜鹿肉香" = 1, "蜂蜜香" = 1)
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Wine glazed venison loins  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins/cooked/sauced
	name = "森林恩赐"
	desc = "鹿里脊切成细片，裹上浆果酱与酒釉的混合物。酒液似乎焦糖化成了美味的一层釉。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "loins_sauced"
	tastes = list("嫩鹿肉香" = 1, "焦糖酒香" = 1, "浆果酱" = 1)
	faretype = FARE_LAVISH
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Choice venison cut  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked/choice
	name = "森林珍藏"
	desc = "一份精选鹿肉，煎烤至完美，仍隐约可见粉红的肉质。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "choice_cut"
	tastes = list("醇和鹿肉香" = 1, "大蒜香" = 1, "洋葱香" = 1)
	faretype = FARE_LAVISH
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked/choice/butter
	name = "醇和森林珍藏"
	desc = "一份精选鹿肉，煎烤至完美，仍隐约可见粉红的肉质。浸在一大块黄油里，仿佛之前的肉质还不够软嫩似的。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "choice_cut_b"
	tastes = list("醇和鹿肉香" = 1, "大蒜香" = 1, "洋葱香" = 1, "黄油香" = 1)
	faretype = FARE_LAVISH
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = null

/* .............  Deadite saiga cube  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z/cooked/cubed
	name = "腐肉浓冻"
	desc = "一份由诡异里脊制成的胶状、食尸鬼般的美味。戳一戳，看它颤抖晃动。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "saiga_d_jelly"
	// At last, proper supper
	faretype = FARE_NEUTRAL
	tastes = list("明胶味" = 1, "软塌塌的肉味" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = null
	cooked_smell = /datum/pollutant/food/strange_meat

/* .............  Deadite saiga rib crown  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z/cooked/crown
	name = "黑莓之冠"
	desc = "一顶用诡异肉肋骨打造的冠冕，烹煮到大部分多汁的肉都塌落到底部。下方的肉泥上点缀着无数杰克莓。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "saiga_d_ribs"
	tastes = list("肉泥味" = 1, "杰克莓" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = null
	cooked_smell = /datum/pollutant/food/strange_meat

/* .............  Deadite saiga roses  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z/cooked/roses
	name = "亡者花束"
	desc = "一道用上等诡异肉制成的奇特菜肴，切成薄片并摆成玫瑰的形状。通常会被留在坟墓上以纪念逝者。奥塔瓦的吸血鬼习惯从坟上偷走这些花束，因为他们垂涎这种奇异的肉。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "saiga_d_roses"
	tastes = list("薄而粘的肉味" = 1, "大蒜香" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_FINE
	rotprocess = null
	cooked_smell = /datum/pollutant/food/strange_meat

/* .............  Deadite saiga wellington  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf
	name = "墓中肉糕"
	desc = "由各种肉类拼凑而成的混合物，但主要还是诡异肉。它是一块肉糕，但你宁愿它根本不存在。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "d_bread6"
	tastes = list("易碎软烂的肉糕味" = 1, "食尸鬼味" = 1, "污泥与尘垢" = 1)
	// Safe to eat, not much else, though.
	eat_effect = null
	slices_num = 6
	bitesize = 7
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	cooked_smell = /datum/pollutant/food/strange_meat

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf/update_icon()
	if(slices_num)
		icon_state = "d_bread[slices_num]"
	else
		icon_state = "d_bread_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 2)
			slices_num = 5
		if(bitecount == 3)
			slices_num = 4
		if(bitecount == 4)
			slices_num = 3
		if(bitecount == 5)
			slices_num = 2
		if(bitecount == 6)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf_slice
	name = "肉糕切片"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	desc = "一整块用尸鬼赛加羚羊肉制成的、真正令人作呕的肉糕中的一片。"
	icon_state = "d_bread_slice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	eat_effect = null
	tastes = list("易碎软烂的肉糕味" = 1, "食尸鬼味" = 1, "污泥与尘垢" = 1)
	cooked_type = null
	fried_type = null
	cooked_smell = /datum/pollutant/food/strange_meat
