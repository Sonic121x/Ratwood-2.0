/* * * * * * * * * * * **
 *						*	-Cooking based on slapcrafting
 *		 NeuFood		*	-Uses defines to track nutrition
 *						*	-Meant to replace menu crafting completely for foods
 *						*
 * * * * * * * * * * * **/


/*	........   Templates / Base items   ................ */
/obj/item/reagent_containers // added vars used in neu cooking, might be used for other things too in the future. How it works is in each items attackby code.
	var/short_cooktime = 2 SECONDS
	var/long_cooktime = 3 SECONDS

/obj/item/reagent_containers/proc/update_cooktime(mob/user)
	if(user.mind)
		short_cooktime = (initial(short_cooktime) / get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking)))
		long_cooktime = (initial(long_cooktime) / get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking)))
	else
		short_cooktime = initial(short_cooktime)
		long_cooktime = initial(long_cooktime)

/obj/item/reagent_containers/food/snacks/rogue // base food type, for icons and cooktime, and to make it work with processes like pie making
	icon = 'modular/Neu_Food/icons/unused.dmi' // Still need a backup file lol
	desc = ""
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	foodtype = GRAIN
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	cooktime = 30 SECONDS
	var/process_step // used for pie making and other similar modular foods
	var/datum/food_recipe/active_recipe
	var/current_step = 1

/obj/item/reagent_containers/food/snacks/rogue/examine(mob/user)
	. = ..()
	if(active_recipe && current_step <= active_recipe.ingredients.len)
		var/next_path = active_recipe.ingredients[current_step]
		. += span_smallnotice("配方：<b>[active_recipe.name]</b>。下一步：加入 [initial(next_path:name)]。")

	var/list/possible = SScooking.recipe_index[src.type]
	if(possible && possible.len)
		var/list/recipe_names = list()
		for(var/datum/food_recipe/R in possible)
			var/ingredient = R.ingredients[1]
			recipe_names += "[R.name]（以 [initial(ingredient:name)] 开头）"
		. += span_smallnotice("可以用它来制作：[recipe_names.Join(", ")]。")

	if(cooked_type)
		var/obj/item/CT = cooked_type
		. += span_smallnotice("它已准备就绪，可以被<b>烹饪</b>成 [initial(CT.name)]。")
	if(fried_type)
		var/obj/item/FT = fried_type
		. += span_smallnotice("它已准备就绪，可以被<b>油炸</b>成 [initial(FT.name)]。")
	if(slice_path)
		var/obj/item/ST = slice_path
		. += span_smallnotice("它已准备就绪，可以被<b>切片</b>成 [initial(ST.name)]。")

/obj/item/reagent_containers/food/snacks/rogue/MiddleClick(mob/user)
	. = ..()

	if(!active_recipe)
		to_chat(user, span_warning("[src] 上当前没有激活的配方。"))
		return

	var/confirmation = tgui_alert(user, "你确定要重置 [active_recipe.name] 的制作进度吗？", "重置配方", list("是", "否"))
	if(confirmation != "是" || !active_recipe)
		return

	to_chat(user, span_notice("你清除了 [src] 上 [active_recipe.name] 的制作进度。"))
	active_recipe = null
	current_step = 1
	cut_overlays()

/obj/item/reagent_containers/food/snacks/rogue/attackby(obj/item/I, mob/living/user)
	if(!active_recipe)
		var/datum/food_recipe/R = SScooking.get_recipe(src, I)
		if(R)
			active_recipe = R
		else
			return ..()

	var/obj/structure/table/T = locate() in loc
	if(!T)
		to_chat(user, span_warning("你需要一张桌子来制作 [src.name]。"))
		return

	var/requirement = active_recipe.ingredients[current_step]

	if(ispath(requirement, /datum/reagent))
		var/amt = active_recipe.ingredients[requirement]
		if(I.reagents && I.reagents.has_reagent(requirement, amt))
			do_cooking_step(I, user, requirement, amt)
			return
		else
			to_chat(user, span_warning("你至少需要 [amt] 单位的 [initial(requirement:name)]！"))
			return

	if(current_step <= active_recipe.ingredients.len && istype(I, active_recipe.ingredients[current_step]))
		do_cooking_step(I, user)
		return

	return ..()

/obj/item/reagent_containers/food/snacks/rogue/proc/do_cooking_step(obj/item/I, mob/living/user, req_reagent, req_amt)
	if(!do_after(user, get_cooking_do_time(user, active_recipe.time_per_step), target = src))
		if(current_step == 1)
			active_recipe = null
		return

	playsound(src, 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE)
	
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.mind.add_sleep_experience(/datum/skill/craft/cooking, H.STAINT * active_recipe.experience_per_step)
	if(req_reagent)
		// Re-verify reagent exists after the timer
		if(!I.reagents || !I.reagents.has_reagent(req_reagent, req_amt))
			return
		I.reagents.remove_reagent(req_reagent, req_amt)
		playsound(src, 'modular/Creechers/sound/milking1.ogg', 50, TRUE)
	else
		playsound(src, 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE)
		I.moveToNullspace()

	if(current_step < active_recipe.ingredients.len || active_recipe.needs_cooking)
		var/image/over = image(I.icon, I.icon_state)
		over.transform = matrix() * 0.7 
		switch(current_step)
			if(1) { over.pixel_x = -7; over.pixel_y = 7 }   // NW
			if(2) { over.pixel_x = 7;  over.pixel_y = 7 }   // NE
			if(3) { over.pixel_x = 7;  over.pixel_y = -7 }  // SE
			if(4) { over.pixel_x = -7; over.pixel_y = -7 }  // SW
		add_overlay(over)

	if(!req_reagent)
		qdel(I)
	current_step++
	if(current_step > active_recipe.ingredients.len)
		if(!active_recipe.needs_cooking)
			finalize_cooking()
		else
			to_chat(user, span_nicegreen("[name] 已经可以烹饪了。"))
			cooked_type = active_recipe.result_type
			fried_type = active_recipe.result_type
			active_recipe = null
			current_step = 1

/obj/item/reagent_containers/food/snacks/rogue/proc/finalize_cooking()
	var/res_type = active_recipe.result_type
	var/turf/T = get_turf(src)
	cut_overlays()
	new res_type(T)
	active_recipe = null
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("许多食材都可以在“切”或“剁”意图下用刀左键点击，切成更小的部分。这包括大多数肉类、蔬菜、水果、面包、馅饼、蛋糕、烟熏香肠、黄油、盐腌肥膘等等。")
	. += span_info("大多数食物如果放置过久，最终都会腐烂。将食物存放在密闭的箱子或托盘上，可以有效防止其腐烂。")
	. += span_info("更稀有的食物和饮品，或是用更昂贵的配方制作而成的，都能为享用者带来更多的心情和健康增益。")
	. += span_info("每个人都有自己最爱的一餐与一杯饮品——反之，也有深恶痛绝、避之不及的一餐与一杯饮品。投其所好，他们的心情就会大为改善。")
	. += span_info("贵族们在吃什么——以及怎么吃——方面有着高得多的标准。他们喜欢用合适的餐具享用盛放在盘子里的餐点，而不喜欢平淡廉价的食物。")
	. += span_info("不小心设错了配方？中键点击物品即可清除配方，重新选择另一种。")

/obj/item/reagent_containers/food/snacks/rogue/Initialize()
	. = ..()
	eatverb = pick("咬","咀嚼","小口啃","狼吞虎咽","大口咬")

/obj/item/reagent_containers/food/snacks/rogue/foodbase // root item for uncooked food thats disgusting when raw
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	bitesize = 3
	eat_effect = /datum/status_effect/debuff/uncookedfood

/obj/item/reagent_containers/food/snacks/rogue/foodbase/New() // disables the random placement on creation for this object MAYBE OBSOLETE?
	..()
	pixel_x = 0
	pixel_y = 0

/obj/item/reagent_containers/food/snacks/rogue/preserved // just convenient way to group food with long rotprocess
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks
	var/chopping_sound = FALSE // does it play a choppy sound when batch sliced?
	var/slice_sound = FALSE // does it play the slice sound when sliced?

/obj/item/reagent_containers/food/snacks/proc/changefood(path, mob/living/eater)
	if(!path || !eater)
		return
	var/turf/T = get_turf(eater)
	if(eater.dropItemToGround(src))
		qdel(src)
	var/obj/item/I = new path(T)
	eater.put_in_active_hand(I)

/obj/effect/decal/cleanable/food/mess // decal applied when throwing minced meat for example
	name = "污渍"
	desc = ""
	color = "#ab9d9d"
	icon_state = "tomato_floor1"
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/item/reagent_containers/food/snacks/attackby(obj/item/W, mob/user, params)
	if(user.used_intent.blade_class == slice_bclass && W.wlength == WLENGTH_SHORT)
		if(slice_bclass == BCLASS_CHOP)
			user.visible_message(span_notice("[user]把[src]切碎了！"))
			slice(W, user)
			return 1
		else if(slice(W, user))
			return 1
	..()

/* added to proc
/obj/item/reagent_containers/food/snacks/proc/slice(obj/item/W, mob/user)
	if(slice_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1) // added some choppy sound
	if(chopping_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/chopping_block.ogg', 60, TRUE, -1) // added some choppy sound
*/
/*	........   Kitchen tools / items   ................ */


/obj/item/rogueweapon/huntingknife/cleaver
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	item_state = "cleaver"
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	experimental_onback = FALSE

/obj/item/book/rogue/yeoldecookingmanual // new book with some tips to learn
	name = "古旧烹饪之道"
	desc = "由第四代管家斯文德·胖胡子撰写"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "Neu_cooking.json"

/* * * * * * * * * * * * * * *	*
 *								*
 *		Powder & Salt			*
 *					 			*
 *								*
 * * * * * * * * * * * * * * * 	*/

// -------------- Flour -----------------
/obj/item/reagent_containers/powder/flour
	name = "面粉"
	desc = "怀揣这份志气，我们便能筑起帝国。"
	gender = PLURAL
	icon_state = "flour"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	var/water_added
	experimental_inhand = TRUE

/obj/item/reagent_containers/powder/flour/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("wielded")
				return null
			if("altgrip")
				return null
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 4,"wy" = -1,"ex" = -1,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/reagent_containers/powder/flour/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/obj/item/reagent_containers/powder/flour/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("将目标对准鼻子并左键点击自己，会自动吸入你手中的粉末。")
	. += span_info("大多数粉末在吸入后都能带来各种各样的效果。")

/obj/item/reagent_containers/powder/flour/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/R = I
	if(istype(R) && wet(I, user))
		return TRUE
	return ..()

/obj/item/reagent_containers/powder/flour/proc/wet(obj/item/I, mob/living/user)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	var/is_container = istype(R, /obj/item/reagent_containers)
	// if false, this is a special case like orison
	update_cooktime(user)
	if(water_added)
		return FALSE
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("需要一张桌子......"))
		return FALSE
	if(is_container && (!R.reagents.has_reagent(/datum/reagent/water, 10)))
		to_chat(user, span_notice("还需要更多水才能和开。"))
		return TRUE
	to_chat(user, span_notice("加好水了，现在该揉面了......"))
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user, short_cooktime, target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		name = "湿面粉"
		desc = "在你手中，它注定会成就一番美味。"
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#d9d0cb"
	return TRUE

/obj/item/reagent_containers/powder/flour/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user, short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			new /obj/item/reagent_containers/food/snacks/rogue/dough_base(loc)
			qdel(src)
	else ..()


// -------------- SALT -----------------
/obj/item/reagent_containers/powder/salt
	name = "盐"
	desc = ""
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/powder/salt/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/* -------------- RICE ----------------- */
/obj/item/reagent_containers/food/snacks/grown/rice
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 3
	var/water_added

/obj/item/reagent_containers/food/snacks/grown/rice/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/R = I
	if(istype(R) && wet(I, user))
		return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/grown/rice/proc/wet(obj/item/I, mob/living/user)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	var/is_container = istype(R)
	update_cooktime(user)
	if(water_added)
		return FALSE
	if(isturf(loc)&& (!found_table))
		to_chat(user, "<span class='notice'>需要一张桌子......</span>")
		return FALSE
	if(is_container && (!R.reagents.has_reagent(/datum/reagent/water, 10)))
		to_chat(user, "<span class='notice'>还需要更多水才能淘洗。</span>")
		return TRUE
	to_chat(user, "<span class='notice'>加好水了，现在该用手淘洗了......</span>")
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user,2 SECONDS, target = src))
		user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
		name = "湿米"
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#d9d0cb"
	return TRUE

/obj/item/reagent_containers/food/snacks/grown/rice/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user,3 SECONDS, target = src))
			user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
			new /obj/item/reagent_containers/food/snacks/rogue/ricewet(loc)
			qdel(src)
	else ..()

/* -------------- WET RICE ----------------- */
/obj/item/reagent_containers/food/snacks/rogue/ricewet
	name = "洗净的米"
	desc = ""
	gender = PLURAL
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "rice"
	list_reagents = list(/datum/reagent/floure = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/powder/mineral
	name = "粗矿粉"
	desc = "研碎后的石粉，再加工一下就能制成矿盐。"
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	var/water_added

/obj/item/reagent_containers/powder/coarse_salt
	name = "粗盐"
	desc = "带着些许砂砾感的粗盐，还可以继续磨成更细的盐。"
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	color = "#999797"
	mill_result = /obj/item/reagent_containers/powder/salt

/obj/item/reagent_containers/powder/mineral/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/obj/item/reagent_containers/powder/mineral/attackby(obj/item/I, mob/user, params)
	var/obj/item/reagent_containers/R = I
	if(istype(R) && wet(I, user))
		return TRUE
	return ..()

/obj/item/reagent_containers/powder/mineral/proc/wet(obj/item/I, mob/user)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	var/is_container = istype(R)
	update_cooktime(user)
	if(water_added)
		return FALSE
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("需要一张桌子......"))
		return FALSE
	if(is_container && (!R.reagents.has_reagent(/datum/reagent/water, 10)))
		to_chat(user, span_notice("还需要更多水才能处理。"))
		return TRUE
	to_chat(user, span_notice("加好水了，现在该筛滤它了......"))
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user, short_cooktime, target = src))
		name = "处理过的矿粉"
		desc = "还是相当粗糙，还得再筛一遍。"
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#666262"
	return TRUE

/obj/item/reagent_containers/powder/mineral/attackby(obj/item/I, mob/user, params)
	if(water_added)
		if(istype(I, /obj/item/natural/cloth))
			user.visible_message(span_info("[user] 正在筛滤矿粉……"))
			playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 90, TRUE, -1)
			if(do_after(user, 3 SECONDS, target = src))
				new /obj/item/reagent_containers/powder/coarse_salt(loc)
				qdel(src)
	else ..()

/* -------------- PUMPKIN SPICE ----------------- */
/obj/item/reagent_containers/food/snacks/pumpkinspice
	name = "南瓜香料"
	desc = "源自朴实之地的浓郁风味。"
	gender = PLURAL
	icon_state = "pumpkinspice"
	icon = 'icons/roguetown/items/produce.dmi'
	list_reagents = list(/datum/reagent/consumable/pumpkinspice = 1)
	grind_results = list(/datum/reagent/consumable/pumpkinspice = 10)
	volume = 1
	sellprice = 0

/datum/reagent/consumable/pumpkinspice
	name = "南瓜香料"
	description = "令人愉悦的香料滋味。"
	color = "#ffffff"
