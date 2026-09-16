
// -------------- RAISINS, GIBLETS, SWEETGLASS ------------------
/obj/item/reagent_containers/food/snacks/rogue/raisins
	name = "葡萄干"
	desc = "杰克莓脱去水分后，变成了风味浓郁的小块。就像朴实的硬面包一样，这些葡萄干也会比它们的创造者更持久。\
	当与蜂蜜混合并投入一锅沸腾的油脂中时，便能诞生“甜晶”——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "raisins5"
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干杰克莓" = 1, "缩皱的甜味爆发" = 1)
	faretype = FARE_POOR
	eat_effect = null
	rotprocess = null
	process_step = 1
	foodtype = FRUIT

/obj/item/reagent_containers/food/snacks/rogue/raisins/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "raisins4"
	if(bitecount == 2)
		icon_state = "raisins3"
	if(bitecount == 3)
		icon_state = "raisins2"
	if(bitecount == 4)
		icon_state = "raisins1"

/obj/item/reagent_containers/food/snacks/rogue/raisins/CheckParts(list/parts_list, datum/crafting_recipe/R)
	..()
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		color = M.filling_color
		if(M.reagents)
			M.reagents.remove_reagent(/datum/reagent/consumable/nutriment, M.reagents.total_volume)
			M.reagents.trans_to(src, M.reagents.total_volume)
		qdel(M)

/obj/item/reagent_containers/food/snacks/rogue/raisins/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜杰克莓干块"
			desc = "杰克莓干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			faretype = FARE_FINE
			color = null
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			bitesize = 1
			process_step = 2
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass
			update_icon()
			qdel(I)
			return

//

/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	name = "覆盆子干块"
	desc = "脱去水分的覆盆子，变成了风味浓郁、可以长久保存的小块。与蜂蜜混合并投入一锅滚沸的油脂中，便能诞生'甜晶'——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干覆盆子" = 1, "缩皱的酸意爆发" = 1)
	color = "#FF2A00"

/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜覆盆子干块"
			desc = "覆盆子干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	name = "草莓干块"
	desc = "脱去水分的草莓，变成了风味浓郁、可以长久保存的小块。与蜂蜜混合并投入一锅滚沸的油脂中，便能诞生'甜晶'——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干草莓" = 1, "缩皱的甜味爆发" = 1)
	color = "#FF2A00"

/obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜草莓干块"
			desc = "草莓干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	name = "黑莓干块"
	desc = "脱去水分的黑莓，变成了风味浓郁、可以长久保存的小块。与蜂蜜混合并投入一锅滚沸的油脂中，便能诞生'甜晶'——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干黑莓" = 1, "缩皱的酸甜爆发" = 1)
	color = "#339AB7"

/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜黑莓干块"
			desc = "黑莓干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	name = "李子干块"
	desc = "脱去水分的李子，变成了风味浓郁、可以长久保存的小块。与蜂蜜混合并投入一锅滚沸的油脂中，便能诞生'甜晶'——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干李子" = 1, "缩皱的蜜甜爆发" = 1)
	color = "#FF4F86"

/obj/item/reagent_containers/food/snacks/rogue/raisins/plum/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜李子干块"
			desc = "李子干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	name = "梨干块"
	desc = "脱去水分的梨，变成了风味浓郁、可以长久保存的小块。与蜂蜜混合并投入一锅滚沸的油脂中，便能诞生'甜晶'——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干梨" = 1, "缩皱的酸甜与蜜意爆发" = 1)
	color = "#EAB14F"

/obj/item/reagent_containers/food/snacks/rogue/raisins/pear/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜梨干块"
			desc = "梨干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	name = "柑橘干块"
	desc = "脱去水分的柑橘，变成了风味浓郁、可以长久保存的小块。与蜂蜜混合并投入一锅滚沸的油脂中，便能诞生'甜晶'——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干柑橘" = 1, "缩皱的酸甜爆发" = 1)
	color = "#FF9321"

/obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜柑橘干块"
			desc = "柑橘干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	name = "柠檬干块"
	desc = "脱去水分的柠檬，变成了风味浓郁、可以长久保存的小块。与蜂蜜混合并投入一锅滚沸的油脂中，便能诞生'甜晶'——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干柠檬" = 1, "缩皱的酸涩爆发" = 1)
	color = "#FFBD30"

/obj/item/reagent_containers/food/snacks/rogue/raisins/lemon/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜柠檬干块"
			desc = "柠檬干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	name = "青柠干块"
	desc = "脱去水分的青柠，变成了风味浓郁、可以长久保存的小块。与蜂蜜混合并投入一锅滚沸的油脂中，便能诞生'甜晶'——一种脆甜无比的糖果，\
	在长者与贵族子弟中颇受欢迎。"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("干青柠" = 1, "缩皱的酸涩爆发" = 1)
	color = "#C3DB91"

/obj/item/reagent_containers/food/snacks/rogue/raisins/lime/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹蜜青柠干块"
			desc = "青柠干块，裹满蜜甜，正等待着在一锅滚沸的油脂中接受洗礼。"
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("浓烈到压倒一切的蜜味" = 1, "爆发的甜意" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime
			update_icon()
			qdel(I)
			return

//

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass
	name = "甜晶"
	desc = "一小捧结晶化的杰克莓干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	icon_state = "sweetglass5"
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL * 2)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("玻璃般的杰克莓" = 1, "糖晶般的甜味碎片" = 1)
	faretype = FARE_LAVISH
	color = "#A060FF" //Placeholder until someone wants to twiddle it for themselves. Should be fine, otherwise.
	eat_effect = /datum/status_effect/buff/sweet
	foodtype = FRUIT

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "sweetglass4"
	if(bitecount == 2)
		icon_state = "sweetglass3"
	if(bitecount == 3)
		icon_state = "sweetglass2"
	if(bitecount == 4)
		icon_state = "sweetglass1"

//

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry
	name = "覆盆子甜晶"
	desc = "一小捧结晶化的覆盆子干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	color = "#FF2A00"
	tastes = list("玻璃般的覆盆子" = 1, "糖晶般的酸意碎片" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry
	name = "草莓甜晶"
	desc = "一小捧结晶化的草莓干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	color = "#FF2A00"
	tastes = list("玻璃般的草莓" = 1, "糖晶般的甜味碎片" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry
	name = "黑莓甜晶"
	desc = "一小捧结晶化的黑莓干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	color = "#339AB7"
	tastes = list("玻璃般的黑莓" = 1, "糖晶般的酸甜碎片" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum
	name = "李子甜晶"
	desc = "一小捧结晶化的李子干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	color = "#FF4F86"
	tastes = list("玻璃般的李子" = 1, "糖晶般的蜜甜碎片" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear
	name = "梨甜晶"
	desc = "一小捧结晶化的梨干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	color = "#EAB14F"
	tastes = list("玻璃般的梨" = 1, "糖晶般的酸甜蜜意碎片" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine
	name = "柑橘甜晶"
	desc = "一小捧结晶化的柑橘干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	color = "#FF9321"
	tastes = list("玻璃般的柑橘" = 1, "糖晶般的酸甜碎片" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon
	name = "柠檬甜晶"
	desc = "一小捧结晶化的柠檬干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	color = "#FFBD30"
	tastes = list("玻璃般的柠檬" = 1, "糖晶般的酸涩碎片" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime
	name = "青柠甜晶"
	desc = "一小捧结晶化的青柠干块，在长者与贵族子弟中颇受欢迎。它们只在非常特殊的情况下才会变质，\
	因此成为远行旅人钟爱的零嘴——前提是他们买得起。"
	color = "#C3DB91"
	tastes = list("玻璃般的青柠" = 1, "糖晶般的酸涩碎片" = 1)

// -------------- Trail-mix -----------------
/obj/item/reagent_containers/food/snacks/rogue/trailmix
	name = "什锦干粮"
	desc = "一包收拢得整整齐齐的干货零食，需要时便可取用。因其简单易得，深受游侠们的喜爱。"
	icon = 'modular/Neu_food/icons/cookware/ration.dmi'
	icon_state = "ration_large"//Prob give it'S own subtype later
	eat_effect = null
	fried_type = null
	bitesize = 7
	slice_batch = FALSE
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL * 3)
	tastes = list("葡萄干" = 1, "南瓜" = 1, "干纸" = 1)
	rotprocess = null
