// 无尽系列：仅由壶自身补充指定液体，所有外部加液路径均被拒绝。
/datum/reagents/z121_endless_pot

/datum/reagents/z121_endless_pot/add_reagent(reagent, amount, list/data = null, reagtemp = 300, no_react = 0, prepend = FALSE)
	var/obj/item/reagent_containers/glass/z121_endless_pot/pot = my_atom
	if(!istype(pot) || !pot.refilling || reagent != pot.endless_reagent)
		return FALSE
	return ..()

/obj/item/reagent_containers/glass/z121_endless_pot
	name = "无尽壶"
	desc = "一把施加了无尽魔法的陶壶，壶中的液体永远不会耗尽，也无法灌入其他液体。"
	icon = 'modular/Neu_Food/icons/cookware/pot.dmi'
	icon_state = "teapot"
	item_state = "pot"
	experimental_inhand = TRUE
	dropshrink = 0.7
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	throwforce = 10
	sharpness = IS_BLUNT
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	volume = 120
	amount_per_transfer_from_this = 25
	possible_transfer_amounts = list(25)
	possible_item_intents = list(INTENT_POUR, INTENT_SPLASH, INTENT_GENERIC)
	reagent_flags = DRAINABLE | NO_REACT
	var/endless_reagent = /datum/reagent/water
	var/refilling = FALSE

/obj/item/reagent_containers/glass/z121_endless_pot/create_reagents(max_vol, flags)
	if(reagents)
		qdel(reagents)
	// 保留可倒出属性，禁止灌入、注入及壶内反应。
	flags = (flags | DRAINABLE | NO_REACT) & ~(REFILLABLE | INJECTABLE)
	reagents = new /datum/reagents/z121_endless_pot(max_vol, flags)
	reagents.my_atom = src

/obj/item/reagent_containers/glass/z121_endless_pot/Initialize(mapload, vol)
	. = ..()
	refill()

/obj/item/reagent_containers/glass/z121_endless_pot/on_reagent_change(changetype)
	. = ..()
	if(refilling || QDELETED(src) || QDELETED(reagents))
		return
	// 合并同一次倾倒产生的回调，等待试剂遍历结束后再补液。
	addtimer(CALLBACK(src, PROC_REF(refill)), 0, TIMER_UNIQUE | TIMER_DELETE_ME)

/obj/item/reagent_containers/glass/z121_endless_pot/proc/refill()
	if(refilling || QDELETED(src) || QDELETED(reagents))
		return
	refilling = TRUE
	reagents.isolate_reagent(endless_reagent)
	reagents.add_reagent(endless_reagent, reagents.maximum_volume - reagents.total_volume, no_react = TRUE)
	refilling = FALSE

/obj/item/reagent_containers/glass/z121_endless_pot/weather_act_on(weather_trait, severity)
	// 无尽壶不收集雨水，避免茶和牛奶被稀释。
	return

/obj/item/reagent_containers/glass/z121_endless_pot/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		to_chat(user, span_warning("无法向[src]中加入其他东西。"))
		return
	return ..()

/obj/item/reagent_containers/glass/z121_endless_pot/examine(mob/user)
	. = ..()
	. += span_notice("壶中的液体会自动补满，每次可倒出二十五单位；无法向壶中灌入或注入液体。")

/obj/item/reagent_containers/glass/z121_endless_pot/getonmobprop(tag)
	if(tag == "gen")
		return list("shrink" = 0.5, "sx" = -7, "sy" = -4, "nx" = 7, "ny" = -4, "wx" = -4, "wy" = -4, "ex" = 2, "ey" = -4, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)
	return ..()

/obj/item/reagent_containers/glass/z121_endless_pot/water
	name = "无尽水壶"
	desc = "一把能无穷无尽地倒出清水的魔法陶壶。清澈的水流永不枯竭。"
	endless_reagent = /datum/reagent/water

/obj/item/reagent_containers/glass/z121_endless_pot/tea
	name = "无尽茶壶"
	desc = "一把能无穷无尽地倒出茶水的魔法陶壶。悠然的茶香永不消散。"
	endless_reagent = /datum/reagent/consumable/caffeine/tea

/obj/item/reagent_containers/glass/z121_endless_pot/milk
	name = "无尽奶壶"
	desc = "一把能无穷无尽地倒出牛奶的魔法陶壶。香醇的牛奶永不耗尽。"
	endless_reagent = /datum/reagent/consumable/milk
