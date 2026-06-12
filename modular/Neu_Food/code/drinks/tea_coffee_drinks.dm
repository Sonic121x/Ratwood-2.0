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
	name = "spiced rosa petals"
	desc = "A palmful of smells so delightfully rich, destined to be distilled into a damn fine cup of humor-balancing tea."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter_spiced"
	tastes = list("mild sweetness" = 1, "a mouthful of cough-inducing powderiness" = 1)
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
	name = "spiced coffee beans"
	desc = "Roasted coffee beans, nestled atop a bed of fragrant pumpkin spice. It looks perfect for brewing a particularly rich kettle of coffee."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans_spiced"
	tastes = list("rich caramel smoothness" = 1, "a mouthful of cough-inducing powderiness" = 1)
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
	name = "spiced tea leaves"
	desc = "A blend of coarsely-ground tea leaves and pumpkin spice, perfect for brewing the most relaxing drinks in all of Psydonia."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teaground_spiced"
	tastes = list("bitterness" = 1, "a mouthful of cough-inducing powderiness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced
	name = "spiced chocolate"
	desc = "A spiced sliver of heaven, awaiting to be brewed into a velvetly rich drink."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "chocolate_spiced"
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("sugary richness" = 1, "a mouthful of cough-inducing powderiness" = 1)
	faretype = FARE_LAVISH
	rotprocess = null
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/chocolate_spiced/On_Consume(mob/living/eater)
	if(islupian(eater) || isvulp(eater))
		to_chat(eater, span_warning("The spiced chocolate tastes delicious but my stomach churns violently!"))
		if(iscarbon(eater))
			var/mob/living/carbon/C = eater
			C.add_nausea(120) // enough to trigger vomiting
		eater.adjustToxLoss(5)
	return ..()
