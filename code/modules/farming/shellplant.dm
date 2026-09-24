/obj/item/natural/shellplant
	name = "硬壳植物"
	desc = "你本不该看到这个。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = ""
	var/foodamt = 1 //how much food can be extracted
	var/foodextracted = null //the food item to extract from the plant
	var/seed = null
	var/shell = null

// ======== PUMPKINS ========
/obj/item/natural/shellplant/pumpkin
	name = "南瓜"
	desc = "厚实的南瓜皮包裹着出奇紧密的果肉。"
	icon_state = "pumpkin"
	w_class = WEIGHT_CLASS_NORMAL
	foodamt = 6
	foodextracted = /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced
	seed = /obj/item/seeds/pumpkin
	shell = /obj/item/pumpkinshell
	var/open = FALSE

/obj/item/natural/shellplant/pumpkin/examine(mob/user)
	. = ..()
	
	if(open)
		. += span_smallnotice("它已经切开了，我可以用勺子挖出果肉。\n")
		. += span_smallnotice("还剩 [foodamt] 块果肉。")
	else
		. += span_smallnotice("我可以切开它取出果肉，直接剁成块，或砸碎它取出种子。")

/obj/item/natural/shellplant/pumpkin/attackby(obj/item/I, mob/living/user, params)
	if((user.used_intent.blade_class == BCLASS_CUT) && (I.wlength == WLENGTH_SHORT) && (!user.used_intent.noaa))
		if(!open)
			if(do_after(user, 0.5 SECONDS))
				playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1)
				icon_state = "pumpkin-open"
				open = TRUE
				return
		return
	if((user.used_intent.blade_class == BCLASS_CHOP) && (!user.used_intent.noaa))
		if(do_after(user, 0.5 SECONDS))
			playsound(get_turf(user), 'modular/Neu_Food/sound/chopping_block.ogg', 60, TRUE, -1)
			while(foodamt-- > 0)
				new foodextracted(loc)
			qdel(src)
			return
	if((user.used_intent.blade_class == BCLASS_BLUNT) && (!user.used_intent.noaa))
		if(seed)
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			if(prob(5))
				user.visible_message(span_warning("[user]没能取出种子。"))
			else
				new seed(loc)
				if(prob(90))
					new seed(loc)
				if(prob(23))
					new seed(loc)
				if(prob(6))
					new seed(loc)
		qdel(src)
		return
	if(istype(I, /obj/item/kitchen/spoon) && open)
		if(do_after(user, 0.5 SECONDS))
			if(foodextracted)
				new foodextracted(loc)
				foodamt--
				user.visible_message(span_notice("[user]挖出了[src]的果肉。"), \
							span_notice("我挖出了[src]的果肉。"))
			if(foodamt <= 0)
				if(shell)
					new shell(loc)
				if(seed)
					playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
					if(prob(5))
						user.visible_message(span_warning("[user]没能取出种子。"))
					else
						new seed(loc)
						if(prob(90))
							new seed(loc)
						if(prob(23))
							new seed(loc)
						if(prob(6))
							new seed(loc)
				qdel(src)
		return
	return

/obj/item/pumpkinshell
	name = "南瓜壳"
	desc = "取出果肉和种子后留下的空南瓜壳。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "pumpkinshell"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/pumpkinshell/examine(mob/user)
	. = ..()
	. += span_smallnotice("用小刀刺或切，我可以把它雕成各种装饰品。")

/obj/item/pumpkinshell/attackby(obj/item/I, mob/living/user, params)
	if((user.used_intent.blade_class == BCLASS_CUT || user.used_intent.blade_class == BCLASS_STAB) && (I.wlength == WLENGTH_SHORT) && (!user.used_intent.noaa))
		ui_interact(user)
		return

// -------- TGUI implementation! --------
/obj/item/pumpkinshell/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Carving", "Carving")
		ui.open()

/obj/item/pumpkinshell/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/pumpkin_carvings)
	)

/obj/item/pumpkinshell/ui_static_data(mob/user)
	var/list/data = ..()

	var/list/carvings = list()
	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/pumpkin_carvings)

	for(var/obj/item/flashlight/flare/torch/lantern/pumpkin/P as anything in typesof(/obj/item/flashlight/flare/torch/lantern/pumpkin))
		UNTYPED_LIST_ADD(carvings, list(
			"name" = P.name,
			"ref" = REF(P),
			"icon" = spritesheet.icon_class_name(sanitize_css_class_name("carving_[REF(P)]"))
		))
	data["carvings"] = carvings
	return data

/obj/item/pumpkinshell/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("choose_carving")
			var/obj/item/flashlight/flare/torch/lantern/pumpkin/P = locate(params["ref"])
			var/mob/user = ui.user
			if(!P)
				return TRUE

			user.visible_message(span_notice("[user]开始雕刻[P.name]。"), \
							span_notice("我开始雕刻[P.name]。"))
			if(do_after(user, 2 SECONDS))
				playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1)
				new P(loc)

			ui.close()
			qdel(src)
			return TRUE
