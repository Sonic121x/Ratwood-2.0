#define MAXIMUM_TOTAL_COMPOST 2000
#define COMPOST_PER_PRODUCED_ITEM 100

/obj/structure/composter
	name = "堆肥箱"
	desc = "用木栏围成的堆肥箱，可让废弃的农产品在其中腐熟成肥料。"
	icon = 'icons/obj/structures/composter.dmi'
	icon_state = "composter"
	density = FALSE
	max_integrity = 200
	anchored = TRUE
	var/unflipped_compost = 0
	var/flipped_compost = 0
	var/ready_compost = 0
	var/processing = FALSE

/obj/structure/composter/halffull
	ready_compost = MAXIMUM_TOTAL_COMPOST * 0.5

/obj/structure/composter/full
	ready_compost = MAXIMUM_TOTAL_COMPOST

/obj/structure/composter/examine(mob/user)
	. = ..()
	var/show_dry = (unflipped_compost > flipped_compost)
	if(ready_compost > COMPOST_PER_PRODUCED_ITEM)
		. += span_info("里面有一些已经腐熟的堆肥。")
	if(show_dry && unflipped_compost >= COMPOST_PER_PRODUCED_ITEM)
		. += span_warning("堆肥需要翻动！")
		. += span_notice("空手右键点击即可翻动堆肥。")

/obj/structure/composter/update_icon()
	. = ..()
	update_overlays()

/obj/structure/composter/Initialize(mapload)
	update_icon()
	. = ..()

/obj/structure/composter/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

#define COMPOST_PROCESS_RATE 300 / (1 MINUTES)

/obj/structure/composter/process()
	var/dt = 10
	var/compost_to_process = min(dt * COMPOST_PROCESS_RATE, flipped_compost)
	// Change flipped compost into most processed compost, and some back unflipped
	flipped_compost -= compost_to_process
	unflipped_compost += compost_to_process * 0.25
	ready_compost += compost_to_process * 0.75
	maybe_stop_processing()


/obj/structure/composter/proc/get_total_compost()
	return unflipped_compost + flipped_compost + ready_compost

/obj/structure/composter/proc/try_handle_flipping_compost(obj/item/attacking_item, mob/user, params)
	var/using_tool = FALSE
	if(attacking_item)
		if(istype(attacking_item, /obj/item/rogueweapon/pitchfork) || istype(attacking_item, /obj/item/rogueweapon/shovel))
			using_tool = TRUE
	var/do_time = using_tool ? 4 SECONDS : 7 SECONDS
	var/fatigue = using_tool ? 10 : 20
	if(do_after(user, get_farming_do_time(user, do_time), target = src))
		apply_farming_fatigue(user, fatigue)
		to_chat(user, span_notice("我翻动了堆肥。"))
		if(using_tool)
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		flip_compost()
	return TRUE

/obj/structure/composter/proc/flip_compost()
	var/flip_amount = unflipped_compost
	unflipped_compost -= flip_amount
	flipped_compost += flip_amount
	maybe_start_processing()
	update_icon()

/obj/structure/composter/proc/try_handle_adding_compost(obj/item/attacking_item, mob/user, batch_process)
	var/compost_value = 0
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks))
		compost_value = 150
	if(istype(attacking_item, /obj/item/natural/chaff))
		compost_value = 150
	if(istype(attacking_item, /obj/item/trash/applecore))
		compost_value = 50
	if(compost_value > 0)
		if(get_total_compost() >= MAXIMUM_TOTAL_COMPOST)
			if(!batch_process)
				to_chat(user, span_warning("堆肥箱已经满了！"))
			return FALSE
		unflipped_compost += min(compost_value, MAXIMUM_TOTAL_COMPOST - get_total_compost())
		if(!batch_process)
			to_chat(user, span_notice("我把\the [attacking_item]放进了\the [src]。"))
		qdel(attacking_item)
		return TRUE
	return FALSE

/obj/structure/composter/proc/try_handle_removing_compost(obj/item/attacking_item, mob/living/user)
	if(ready_compost < COMPOST_PER_PRODUCED_ITEM)
		to_chat(user, span_warning("腐熟的堆肥还不够！"))
		return TRUE
	apply_farming_fatigue(user, 5)
	to_chat(user, span_notice("我取出了一些腐熟的堆肥。"))
	var/obj/item/compost/compost = take_out_compost()
	if(compost)
		user.put_in_active_hand(compost)
	return TRUE

/obj/structure/composter/proc/take_out_compost()
	if(ready_compost < COMPOST_PER_PRODUCED_ITEM)
		return
	ready_compost -= COMPOST_PER_PRODUCED_ITEM
	. = new /obj/item/compost(get_turf(src))
	update_icon()

/obj/structure/composter/attackby(obj/item/attacking_item, mob/user, params)
	user.changeNext_move(CLICK_CD_FAST)
	if(istype(attacking_item,/obj/item/storage/roguebag) && attacking_item.contents.len)
		if(get_total_compost() >= MAXIMUM_TOTAL_COMPOST)
			to_chat(user, span_warning("堆肥箱已经满了！"))
			return
		var/success
		for(var/obj/item/bagged_item in attacking_item.contents)
			if(try_handle_adding_compost(bagged_item, user, params))
				success = TRUE
				if(get_total_compost() >= MAXIMUM_TOTAL_COMPOST)
					break
		if(success)
			to_chat(user, span_info("我将[attacking_item]中所有能用于堆肥的东西倒进了[src]。"))
			attacking_item.update_icon()
		else
			to_chat(user, span_warning("[attacking_item]里没有能用于堆肥的东西。"))
		update_icon()
		return TRUE
	if(try_handle_adding_compost(attacking_item, user, params))
		update_icon()
		return
	. = ..()

/obj/structure/composter/attack_hand(mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	if(try_handle_removing_compost(null, user, null))
		return
	. = ..()

/obj/structure/composter/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	var/obj/item = user.get_active_held_item()
	if(try_handle_flipping_compost(item, user, null))
		return
	return ..()

/obj/structure/composter/update_overlays()
	. = ..()
	var/total_unprocessed = unflipped_compost + flipped_compost
	var/total_processed = ready_compost
	var/show_dry = (unflipped_compost > flipped_compost)
	var/unprocesed_dry_overlay_name
	if(total_unprocessed >= MAXIMUM_TOTAL_COMPOST * 0.60)
		unprocesed_dry_overlay_name = "pre_compost_heavy_dry"
		. += "pre_compost_heavy"
	else if(total_unprocessed >= MAXIMUM_TOTAL_COMPOST * 0.30)
		unprocesed_dry_overlay_name = "pre_compost_mid_dry"
		. += "pre_compost_mid"
	else if (total_unprocessed >= COMPOST_PER_PRODUCED_ITEM)
		unprocesed_dry_overlay_name = "pre_compost_low_dry"
		. += "pre_compost_low"

	if(show_dry && unprocesed_dry_overlay_name)
		var/mutable_appearance/dry_ma = mutable_appearance(icon, unprocesed_dry_overlay_name)
		dry_ma.color = "#ffbb6d"
		dry_ma.alpha = 40
		. += dry_ma

	if(total_processed >= MAXIMUM_TOTAL_COMPOST * 0.60)
		. += "post_compost_heavy"
	else if(total_processed >= MAXIMUM_TOTAL_COMPOST * 0.30)
		. += "post_compost_mid"
	else if (total_processed >= COMPOST_PER_PRODUCED_ITEM)
		. += "post_compost_low"

/obj/structure/composter/proc/maybe_start_processing()
	// Start processing if there is any flipped compost to process
	if(!processing && flipped_compost > 0)
		START_PROCESSING(SSprocessing, src)
		processing = TRUE
		update_overlays()

/obj/structure/composter/proc/maybe_stop_processing()
	// Stop processing if there is no flipped compost left
	if(processing && flipped_compost <= 0)
		STOP_PROCESSING(SSprocessing, src)
		processing = FALSE
		update_overlays()

/obj/item/compost
	name = "堆肥"
	desc = "腐熟的农产品，可以为植物提供养分。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	color = "#ffac38"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32

/obj/item/fertilizer
	name = "肥料"
	desc = "由堆肥、粪肥和骨粉混合而成。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "fertilizer"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
