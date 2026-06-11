/obj/item/parcel
	name = "包裹封装纸"
	desc = "一张结实的包裹纸，用于将物品封装后安全投递。包裹最终的大小取决于原物品的尺寸。"
	icon = 'modular/Neu_Food/icons/cookware/ration.dmi'
	icon_state = "ration_wrapper"
	w_class = WEIGHT_CLASS_TINY
	grid_height = 32
	grid_width = 32
	dropshrink = 0.6
	/// Items contained in this parcel. Courier quests pack a single item, Recovery quests pack
	/// 4-6. Released to the turf when an authorized recipient unwraps the seal.
	var/list/obj/item/contained_items = list()
	var/list/allowed_jobs = list()
	var/delivery_area_type

/obj/item/parcel/Initialize(mapload)
	. = ..()
	var/datum/component/quest_object/courier_quest = GetComponent(/datum/component/quest_object)
	if(courier_quest)
		var/datum/quest/quest = courier_quest.quest_ref?.resolve()
		if(quest && quest.quest_type == QUEST_COURIER && quest.target_delivery_location)
			delivery_area_type = quest.target_delivery_location
			allowed_jobs = get_area_jobs(delivery_area_type)
			RegisterSignal(courier_quest, COMSIG_QDELETING, PROC_REF(on_quest_component_deleted))

	invisibility = INVISIBILITY_OBSERVER
	proximity_monitor = new(src, 5)

/obj/item/parcel/HasProximity(mob/nearby)
	if(!istype(nearby))
		return

	var/datum/component/quest_object/quest_component = GetComponent(/datum/component/quest_object)
	if(!istype(quest_component))
		return

	var/datum/quest/quest = quest_component.quest_ref?.resolve()
	if(!istype(quest))
		return

	if(get_dist(get_turf(src), get_turf(quest.quest_scroll_ref?.resolve())) > 5)
		return

	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = get_turf(src), icon_state = "hidden", layer = 18)
	I.layer = 18
	I.plane = 18
	if(!I)
		return
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay_view(I, 5 SECONDS)
	invisibility = initial(invisibility)
	QDEL_NULL(proximity_monitor)

/obj/item/parcel/proc/get_area_jobs(area_type)
	var/static/list/area_jobs = list(
		/area/rogue/indoors/town/tavern = list("Innkeeper", "Tapster", "Cook"),
		/area/rogue/indoors/town/bath = list("Bathhouse Attendant", "Bathmaster"),
		/area/rogue/indoors/town/church = list("Bishop", "Acolyte", "Templar", "Mortician", "Martyr"),
		/area/rogue/indoors/town/dwarfin = list("Guildmaster", "Guildsman"),
		/area/rogue/indoors/town/shop = list("Merchant", "Shophand"),
		/area/rogue/indoors/town/manor = list("Councillor", "Seneschal", "Servant", "Hand", "Knight", "Prince", "Marshal", "Steward", "Clerk", "Grand Duke"),
		/area/rogue/indoors/town/magician = list("Court Magician", "Magicians Associate", "Archivist"),
		/area/rogue/indoors/town/physician = list("Head Physician", "Apothecary"),
		/area/rogue/indoors/town = list("Guild Handler")
	)
	return area_jobs[area_type] || list("Town Crier", "Steward", "Merchant")

/obj/item/parcel/proc/on_quest_component_deleted(datum/source)
	SIGNAL_HANDLER
	return

/obj/item/parcel/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/parcel) || I.w_class > WEIGHT_CLASS_BULKY || length(contained_items))
		to_chat(user, span_warning("你不能用[src]来包这个。"))
		return

	if(do_after(user, 2 SECONDS, target = src))
		user.transferItemToLoc(I, src)
		contained_items += I
		name = "包裹（[I.name]）"
		desc = "一个包裹严实的邮包，里面装着 [I.name]。"
		icon_state = I.w_class >= WEIGHT_CLASS_NORMAL ? "ration_large" : "ration_small"
		dropshrink = 1
		update_icon()
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		to_chat(user, span_notice("你把[I]包进了包裹纸里。"))

/obj/item/parcel/attack_self(mob/user)
	if(!length(contained_items))
		return

	if(delivery_area_type)
		var/area/quest_area = delivery_area_type
		if(ispath(quest_area, /area) && !(user.job in allowed_jobs))
			to_chat(user, span_warning("这个包裹已封装，需投递至 [initial(quest_area.name)]，只能由以下身份开启：[english_list(allowed_jobs)]！"))
			return FALSE

	if(!do_after(user, 2 SECONDS, target = src))
		return

	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
	var/datum/component/quest_object/courier_component = GetComponent(/datum/component/quest_object/courier)
	var/datum/quest/quest = courier_component?.quest_ref?.resolve()
	if(length(contained_items) == 1)
		var/obj/item/only = contained_items[1]
		to_chat(user, span_notice("你从包裹中拆出了[only]。"))
		user.put_in_hands(only)
		only.update_icon()
	else
		to_chat(user, span_notice("你拆开了 [src]，把里面的东西倒了出来。"))
		var/turf/drop_loc = get_turf(user)
		for(var/obj/item/I as anything in contained_items)
			I.forceMove(drop_loc)
			I.update_icon()
	if(quest && !quest.complete)
		quest.progress_current++
		quest.on_progress_update()
	contained_items.Cut()
	qdel(src)

/obj/item/parcel/examine(mob/user)
	. = ..()
	if(!delivery_area_type)
		return

	var/area/delivery_area = delivery_area_type
	if(!ispath(delivery_area, /area))
		return

	. += span_info("这个包裹的收件地是 [initial(delivery_area.name)]。")
	. += (user.job in allowed_jobs) ? \
		span_notice("As [user.job], you're authorized to open this.") : \
		span_warning("It's sealed with an official guild mark - only authorized personnel should open this!")

/obj/item/parcel/towner_caravan
	var/datum/weakref/unlocked_by_owner_ref
	var/owner_name = ""
	var/sealed_noun = "strongbox"

/obj/item/parcel/towner_caravan/Initialize(mapload)
	. = ..()
	invisibility = initial(invisibility)
	QDEL_NULL(proximity_monitor)

/obj/item/parcel/towner_caravan/attack_self(mob/user)
	if(!length(contained_items))
		return
	var/mob/owner = unlocked_by_owner_ref?.resolve()
	if(!owner)
		to_chat(user, span_warning("The [sealed_noun]'s owner is no longer with us. It cannot be opened."))
		return FALSE
	if(owner != user)
		to_chat(user, span_warning("This [sealed_noun] is magickally sealed to [owner_name]. Only they can open it."))
		return FALSE
	if(owner.stat == DEAD)
		to_chat(user, span_warning("You cannot open it in this state."))
		return FALSE
	if(!do_after(user, 2 SECONDS, target = src))
		return
	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
	var/datum/component/quest_object/courier_component = GetComponent(/datum/component/quest_object/courier)
	var/datum/quest/quest = courier_component?.quest_ref?.resolve()
	if(length(contained_items) == 1)
		var/obj/item/only = contained_items[1]
		to_chat(user, span_notice("You unwrap [only] from the [sealed_noun]."))
		user.put_in_hands(only)
		only.update_icon()
	else
		to_chat(user, span_notice("You open the [sealed_noun] and tip out the contents."))
		var/turf/drop_loc = get_turf(user)
		for(var/obj/item/I as anything in contained_items)
			I.forceMove(drop_loc)
			I.update_icon()
	if(quest && !quest.complete)
		quest.progress_current++
		quest.on_progress_update()
	contained_items.Cut()
	qdel(src)

/obj/item/parcel/towner_caravan/examine(mob/user)
	. = ..()
	var/mob/owner = unlocked_by_owner_ref?.resolve()
	if(!owner)
		. += span_warning("The owner is no longer with us. This [sealed_noun] cannot be opened.")
		return
	if(owner == user)
		. += span_notice("It is magickally sealed to you - you can open it yourself.")
	else
		. += span_warning("Magickally sealed to [owner_name]. Only they can open it.")
