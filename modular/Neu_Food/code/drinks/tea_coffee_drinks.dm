// If there's ever more than 10 drinks maybe split this file OK?
/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals
	name = "新鲜玫瑰花瓣"
	desc = "碾碎的玫瑰花瓣，可以食用，具有平衡体液的特性，渴望进一步风干以提炼出它的风味。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter"
	tastes = list("淡淡甜香" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/medicine/antidote = 1) //Extraordinarily minor.
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	name = "干玫瑰花瓣"
	desc = "风干的玫瑰花瓣，适合泡一杯具有平衡体液功效的美味花茶。搭配南瓜香料更能提升其香气。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter_dried"
	tastes = list("淡淡甜香" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/medicine/antidote = 1)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_spiced
	name = "五香玫瑰花瓣"
	desc = "一小捧芬芳馥郁的香料，注定要被煮成一壶绝佳的平衡体液之茶。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter_spiced"
	tastes = list("温和的甜味" = 1, "满口呛人的粉末感" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/medicine/antidote = 1)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/coffeebeans
	name = "咖啡豆"
	desc = "刚取出的咖啡豆，质地坚硬，最好先烘焙。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans"
	tastes = list("生涩苦味" = 1)
	bitesize = 1
	seed = /obj/item/seeds/coffee
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted
	name = "烘焙咖啡豆"
	desc = "烘焙后的咖啡豆，风味深得多，可用于煮咖啡。本地种出的品种甚至不磨碎也能直接冲煮。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans_roasted"
	tastes = list("醇厚焦糖香" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/coffeebeans_spiced
	name = "五香咖啡豆"
	desc = "烘焙咖啡豆，安卧在一层芳香的南瓜香料之上。看起来正适合煮出一壶格外浓郁的咖啡。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans_spiced"
	tastes = list("醇厚的焦糖顺滑" = 1, "满口呛人的粉末感" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	name = "干茶叶"
	desc = "风干的茶叶，可以食用，也能从中取出种子。还需要用磨盘进一步加工。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teadry"
	tastes = list("苦味" = 1)
	seed = /obj/item/seeds/tea
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
	mill_result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground

/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground
	name = "磨碎茶叶"
	desc = "磨碎后的茶叶，可用于泡茶，或进一步与南瓜香料混合。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teaground"
	tastes = list("苦味" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced
	name = "五香茶叶"
	desc = "粗磨茶叶与南瓜香料的混合物，最适合煮出全普赛多尼亚最令人放松的饮品。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teaground_spiced"
	tastes = list("苦味" = 1, "满口呛人的粉末感" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced
	name = "五香巧克力"
	desc = "一小片五香天赐之物，正等待着被煮成一壶丝绒般浓郁的饮品。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "chocolate_spiced"
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("糖分浓郁的醇厚" = 1, "满口呛人的粉末感" = 1)
	faretype = FARE_LAVISH
	rotprocess = null
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/chocolate_spiced/On_Consume(mob/living/eater)
	if(islupian(eater) || isvulp(eater))
		to_chat(eater, span_warning("这五香巧克力尝起来美味极了，但我的胃却在剧烈翻腾！"))
		if(iscarbon(eater))
			var/mob/living/carbon/C = eater
			C.add_nausea(120) // enough to trigger vomiting
		eater.adjustToxLoss(5)
	return ..()
