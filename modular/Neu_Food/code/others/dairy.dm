/* * * * * * * * * * * * * * *	*
 *								*
 *		Butter & Cheese			*
 *					 			*
 *								*
 * * * * * * * * * * * * * * * 	*/

/*	........   Salting milk (for butter & cheesemaking)   ................ */
/datum/reagent/consumable/milk/salted
	taste_description = "咸牛奶"

/obj/item/reagent_containers/attackby(obj/item/I, mob/living/user, params) // add cook time to containers & salted milk for butter churning
	..()
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/salt))
		if(!reagents.has_reagent(/datum/reagent/consumable/milk, 15))
			to_chat(user, span_warning("牛奶不足。"))
			return
		to_chat(user, span_warning("往牛奶里加盐。"))
		playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		if(do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			reagents.remove_reagent(/datum/reagent/consumable/milk, 15)
			reagents.add_reagent(/datum/reagent/consumable/milk/salted, 15)
			qdel(I)

/*	............   Churning butter   ................ */
/obj/item/reagent_containers/glass/bucket/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/kitchen/spoon))
		if(!reagents.has_reagent(/datum/reagent/consumable/milk/salted, 15))
			to_chat(user, span_warning("咸牛奶不足。"))
			return
		user.visible_message(span_info("[user]搅拌起黄油..."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/churn.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			reagents.remove_reagent(/datum/reagent/consumable/milk/salted, 15)
			new /obj/item/reagent_containers/food/snacks/butter(drop_location())
		return
	..()

// -------------- BUTTER -----------------
/obj/item/reagent_containers/food/snacks/butter
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	name = "黄油条"
	desc = "美味的油脂，足以让无数菜肴更添风味。"
	icon_state = "butter6"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTER_NUTRITION)
	foodtype = DAIRY
	faretype = FARE_IMPOVERISHED
	slice_path = /obj/item/reagent_containers/food/snacks/butterslice
	slices_num = 6
	slice_batch = FALSE
	bitesize = 6
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/butter/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		to_chat(user, span_notice("把鸡蛋磕在黄油上。"))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			new /obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight(drop_location())
			qdel(I)
			qdel(src)
			return
	return ..()

/obj/item/reagent_containers/food/snacks/butter/update_icon()
	if(slices_num)
		icon_state = "butter[slices_num]"
	else
		icon_state = "butter_slice"

/obj/item/reagent_containers/food/snacks/butter/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 5
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/butterslice
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "butter_slice"
	name = "黄油"
	desc = "一小块乳白色的天堂。将其揉入面团是制作许多普赛多尼亚糕点的必要步骤，不过那些更为谦逊的人则更喜欢用它来点缀一片吐司。"
	faretype = FARE_IMPOVERISHED
	foodtype = DAIRY
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)

/obj/item/reagent_containers/food/snacks/butterslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/sugar))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("拌入糖来制作糖霜..."))
			if(do_after(user, long_cooktime, target = src))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
				new /obj/item/reagent_containers/food/snacks/rogue/frosting(drop_location())
				qdel(I)
				qdel(src)
			return
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	return ..()


/*	............   Making fresh cheese   ................ */
/obj/item/reagent_containers/glass/bucket/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/natural/cloth))
		if(reagents.has_reagent(/datum/reagent/consumable/milk/salted, 5))
			user.visible_message(span_info("[user]滤出新鲜的奶酪..."))
			playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				reagents.remove_reagent(/datum/reagent/consumable/milk/salted, 5)
				new /obj/item/reagent_containers/food/snacks/rogue/cheese(drop_location())
			return
	..()


/*	............   Making cheese wheel   ................ */
/obj/item/natural/cloth/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			user.visible_message(span_info("[user]开始把鲜奶酪包进布里..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel(loc)
				qdel(I)
				qdel(src)
			return
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel
	name = "未完成的奶酪轮"
	desc = "凝结并加盐的牛奶，渴望被裹入布里以发挥其全部潜力。你还需要三份鲜奶酪才能完成它。"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "cheesewheel_1"
	w_class = WEIGHT_CLASS_BULKY
	process_step = 1
	var/mature_proc = PROC_REF(maturing_done)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc) && found_table)
			if(process_step == 4)
				return
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user, short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				process_step++
				qdel(I)
				switch(process_step)
					if(2)
						icon_state = "cheesewheel_2"
						desc = "你还需要两份鲜奶酪才能完成它。"
					if(3)
						icon_state = "cheesewheel_3"
						desc = "你还差一份鲜奶酪才能完成它。"
					if(4)
						name = "熟成中的奶酪轮"
						icon_state = "cheesewheel_end"
						desc = "正在缓慢凝固，最好再静置一会儿。"
						addtimer(CALLBACK(src, mature_proc), 5 MINUTES)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel/proc/maturing_done()
	playsound(src.loc, 'modular/Neu_Food/sound/rustle2.ogg', 100, TRUE, -1)
	new /obj/item/reagent_containers/food/snacks/rogue/cheddar(drop_location())
	new /obj/item/natural/cloth(drop_location())
	qdel(src)


// -------------- CHEESE -----------------
/obj/item/reagent_containers/food/snacks/rogue/cheese
	name = "鲜奶酪"
	desc = "凝结并加盐的牛奶，渴望被裹入布里以发挥其全部潜力。"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "freshcheese"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = FRESHCHEESE_NUTRITION)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("奶酪" = 1)
	faretype = FARE_POOR
	foodtype = GRAIN
	eat_effect = null
	rotprocess = SHELFLIFE_DECENT
	become_rot_type = null
	slice_path = null

/obj/item/reagent_containers/food/snacks/rogue/cheese/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("用鲜奶酪左键点击一块布料，即可开始把它包起来。为了获得最佳效果，请先把布料放在桌上。")
	. += span_info("重复这一过程，直到用掉四份鲜奶酪，就能得到一包扎好的包裹。只要时间足够，这个包裹最终会绽放成一整轮奶酪。")

/obj/item/reagent_containers/food/snacks/rogue/cheddar
	name = "奶酪轮"
	desc = "一块炽热的爱意，渴望着陈年。"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "cheesewheel"
	bitesize = 10
	list_reagents = list(/datum/reagent/consumable/nutriment = FRESHCHEESE_NUTRITION*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("奶酪" = 1)
	faretype = FARE_POOR
	eat_effect = null
	rotprocess = SHELFLIFE_LONG
	slices_num = 6
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	become_rot_type = /obj/item/reagent_containers/food/snacks/rogue/cheddar/aged
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/cheddar/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("只要放置足够久不被惊扰，奶酪轮最终会熟成，变得更加奢靡美味。")

/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged
	name = "熟成奶酪轮"
	desc = "一块炽热的爱意，已熟成至完美。"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "blue_cheese"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged
	faretype = FARE_FINE
	become_rot_type = null
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	name = "奶酪角"
	desc = "这可是好大一块切达奶酪！"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "cheese_wedge"
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_TINY
	faretype = FARE_POOR
	tastes = list("奶酪" = 1)
	eat_effect = null
	rotprocess = SHELFLIFE_LONG
	slices_num = 3
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	become_rot_type = /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged

/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged
	name = "熟成奶酪角"
	desc = "配得上一位国王，或一只特别值得嘉奖的老鼠。"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "blue_cheese_wedge"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cheddarslice/aged
	faretype = FARE_FINE
	become_rot_type = null
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	name = "奶酪片"
	desc = "一片咸香。"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "cheese_slice"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("奶酪" = 1)
	eat_effect = null
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_SHORT
	slices_num = null
	slice_path = null
	become_rot_type = null
	baitpenalty = 10
	isbait = TRUE
	fishingMods=list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 0,
		"treasureFishingMod" = 0,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 0.5,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 1 // Just for the funny gimmick of a higher chance for rats and rouses.
	)

/obj/item/reagent_containers/food/snacks/rogue/cheddarslice/aged
	name = "熟成奶酪片"
	desc = "一片天堂。"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "blue_cheese_slice"
	faretype = FARE_FINE
	become_rot_type = null
	rotprocess = null
	fishingMods=list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 0.5,
		"treasureFishingMod" = 0,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 0.5,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 1.5 // Just for the funny gimmick of a higher chance for rats and rouses.
	)

// -------------- FROSTING -----------------
/obj/item/reagent_containers/food/snacks/rogue/frosting
	name = "糖霜"
	desc = "黄油与糖混合打发成的美味糖霜。"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "frosting"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("甜糖霜"=1)
	faretype = FARE_NEUTRAL
	foodtype = DAIRY | SUGAR
	eat_effect = /datum/status_effect/buff/sweet
