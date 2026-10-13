// 成品与半成品分属独立类型，避免普通加热路径直接产出中式成品。
/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine
	icon = 'modular_z121/icon/food.dmi'
	experimental_inhand = TRUE
	grid_width = 32
	grid_height = 32
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	bonus_reagents = null
	cooktime = 0

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/spring_roll
	name = "春卷"
	desc = "金黄的薄皮裹着卷心菜与胡萝卜，咬开时酥声清脆。"
	icon_state = "spring_roll"
	tastes = list("酥脆面皮" = 2, "清甜蔬菜" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/dongpo
	name = "东坡肉"
	desc = "方正的五花肉焖得红亮酥软，肥瘦相间，酒香与甜润酱汁融在一起。"
	icon_state = "dongpo"
	faretype = FARE_LAVISH
	foodtype = MEAT
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("软糯五花肉" = 3, "甜润酒香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/noodles
	name = "刀削面"
	desc = "宽薄不一的面片浸在清汤里，边缘柔滑，中心筋道，点缀着清香蔬菜。"
	icon_state = "noodles"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("筋道面片" = 2, "清鲜菜汤" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/meat_bun
	name = "肉包子"
	desc = "蓬松面皮收成细密褶口，里面包着鲜香多汁的肉馅。"
	icon_state = "meat_bun"
	foodtype = GRAIN | MEAT
	tastes = list("松软面皮" = 1, "鲜香肉馅" = 2)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/vegetable_bun
	name = "菜包子"
	desc = "雪白面皮里包着卷心菜和胡萝卜，褶口间透出一点青绿。"
	icon_state = "vegetable_bun"
	tastes = list("松软面皮" = 1, "清甜菜馅" = 2)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot_serving
	name = "一碗狼肉火锅"
	desc = "一碗热腾腾的狼肉与蔬菜，清汤带着葱姜、蒜与米酒的香气。"
	icon_state = "hotpot_serving"
	foodtype = MEAT | VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("浓厚狼肉汤" = 2, "蒜香蔬菜" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot
	name = "狼肉火锅"
	desc = "一锅炖得浓香的狼肉与蔬菜，可以用空碗分成四份共享。"
	icon_state = "hotpot"
	w_class = WEIGHT_CLASS_BULKY
	foodtype = MEAT | VEGETABLES
	volume = 120
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL * 4)
	tastes = list("浓厚狼肉汤" = 2, "蒜香蔬菜" = 1)
	var/servings = 4
	var/serving_busy = FALSE
	var/serving_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot_serving

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot/examine(mob/user)
	. = ..()
	. += span_notice("还可分装[servings]碗。用手中的空碗盛取即可。")

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot/canconsume(mob/eater, mob/user, silent = FALSE)
	if(!silent)
		to_chat(user, span_notice("请先用空碗分装[name]。"))
	return FALSE

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot/attack_animal(mob/M)
	return

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot/attackby(obj/item/I, mob/living/user, params)
	if(!istype(I, /obj/item/reagent_containers/glass/bowl))
		return ..()
	var/obj/item/reagent_containers/glass/bowl/B = I
	if(serving_busy || servings <= 0 || user.stat || !Adjacent(user) || !(B in user.held_items))
		return TRUE
	if(B.reagents.total_volume)
		to_chat(user, span_warning("请先将碗里的东西倒空。"))
		return TRUE
	serving_busy = TRUE
	var/success = do_after(user, 2 SECONDS, target = src)
	if(QDELETED(src))
		return TRUE
	if(!success)
		serving_busy = FALSE
		return TRUE
	if(QDELETED(user) || user.stat || QDELETED(B) || servings <= 0 || !Adjacent(user) || !(B in user.held_items) || B.reagents.total_volume)
		serving_busy = FALSE
		return TRUE
	if(!user.transferItemToLoc(B, src))
		serving_busy = FALSE
		return TRUE
	var/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/S = new serving_type(get_turf(src))
	// 按剩余份数平分现有试剂，保留调味与污染，不凭空增加营养。
	S.reagents.clear_reagents()
	S.reagents.maximum_volume = max(S.reagents.maximum_volume, reagents.total_volume / servings)
	reagents.trans_to(S, reagents.total_volume / servings)
	S.warming = warming
	S.eat_effect = eat_effect
	S.extra_eat_effect = extra_eat_effect
	S.color = color
	if(eat_effect == /datum/status_effect/debuff/rotfood)
		S.become_rotten()
	B.forceMove(S)
	S.trash = B
	servings--
	serving_busy = FALSE
	user.put_in_hands(S)
	to_chat(user, span_notice("你盛出[S.name]，还剩[servings]份。"))
	if(!servings)
		generate_trash(get_turf(src))
		qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw
	name = "待烹的信义食材"
	icon = 'modular_z121/icon/food.dmi'
	experimental_inhand = TRUE
	grid_width = 32
	grid_height = 32
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | VEGETABLES
	rotprocess = SHELFLIFE_SHORT
	eat_effect = /datum/status_effect/debuff/uncookedfood
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	bonus_reagents = null
	cooktime = 0
	cooked_type = null
	fried_type = null
	deep_fried_type = null
	var/result_type
	var/cuisine_time = 40 SECONDS
	var/cuisine_verb = "蒸制"
	var/liquid_type = /datum/reagent/water
	var/liquid_amount = 10
	var/needs_bowl = FALSE
	var/requires_cuisine_knowledge = TRUE
	var/obj/machinery/light/rogue/hearth/cuisine_hearth
	var/obj/item/reagent_containers/glass/bucket/pot/cuisine_pot
	var/obj/item/reagent_containers/glass/bowl/cuisine_bowl

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/spring_roll
	name = "生春卷"
	desc = "浅白薄皮折好收口，裹住清甜素馅，尚需入热油炸至金黄。"
	icon_state = "raw_spring_roll"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/spring_roll
	cuisine_time = 30 SECONDS
	cuisine_verb = "炸制"
	liquid_type = /datum/reagent/consumable/oil/tallow
	liquid_amount = 5

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/hotpot
	name = "狼肉火锅配料"
	desc = "生狼肉、卷心菜、洋葱和蒜瓣，配好葱姜、米酒和盐，可炖成四人共享的火锅。"
	icon_state = "raw_hotpot"
	foodtype = MEAT | VEGETABLES
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot
	cuisine_time = 60 SECONDS
	cuisine_verb = "炖煮"
	liquid_amount = 120

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/dongpo
	name = "腌好的东坡肉"
	desc = "肥瘦分层的五花肉拌入葱姜、糖、米酒和酱油，仍带生肉的浅红色，需要耐心焖煮。"
	icon_state = "raw_dongpo"
	foodtype = MEAT
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/dongpo
	cuisine_time = 60 SECONDS
	cuisine_verb = "焖煮"
	liquid_amount = 30

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/noodles
	name = "生刀削面"
	desc = "用菜刀削出的宽薄面片，配上蔬菜，等待入沸水煮熟。出锅时需要手边有一只空碗。"
	icon_state = "raw_noodles"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/noodles
	cuisine_time = 30 SECONDS
	cuisine_verb = "煮制"
	liquid_amount = 30
	needs_bowl = TRUE

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/meat_bun
	name = "生肉包"
	desc = "尚未膨起的面皮捏成褶口，包着葱姜酱油调味的肉馅，需隔水蒸熟。"
	icon_state = "raw_meat_bun"
	foodtype = GRAIN | MEAT
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/meat_bun

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/vegetable_bun
	name = "生菜包"
	desc = "尚未膨起的面皮裹住卷心菜与胡萝卜，褶口透着青绿，需隔水蒸熟。"
	icon_state = "raw_vegetable_bun"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/vegetable_bun
