// Dough, and variants thereof for usage in making various baked food items.
// Doesn't include raw variants of bread and others
/*	.................   Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/dough_base
	name = "未完成的面团"
	desc = "再多费一点心思，它就能大有可为。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi' // I know but we are following Raw as a pre-pender
	icon_state = "dough_base"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/dough_base/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/flour))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("继续揉入更多面粉……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/dough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能继续揉制。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/dough
	name = "面团"
	desc = "一切烘焙的起点。涂上黄油，用擀面杖擀平，点缀上苹果和葡萄干……可能性真是无穷无尽！"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dough"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/dough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("把黄油揉进面团里……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/butterdough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("一边揉面，一边拌入葡萄干……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/rbread_half(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("揉面团并加入苹果片……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/abread_half(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团揉成长条形……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团擀平擀薄……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/flatdough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	else
		return ..()

/*	.................   Flatdough  ................... */
/obj/item/reagent_containers/food/snacks/rogue/flatdough
	name = "擀平面团"
	desc = "擀得薄薄的面团，一览无余。用利刃划出纹路，便能备好一张脆饼面坯；抹上番茄酱，则可为农家的盛宴拉开序幕。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "flatdough"
	slices_num = null
	slice_batch = FALSE
	slice_path = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/frybread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/flatdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(I.get_sharpness())
		if(isturf(loc)&& (found_table))
			playsound(user, 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("在[src]上划出纹路……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能划出脆饼坯的纹路！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tomato))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("仔细把番茄捣成浓稠的碎块酱料……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给擀平面团抹上番茄酱！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把番茄片捣成浓稠顺滑的酱料……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给擀平面团抹上番茄酱！"))
	else
		return ..()

/*	.................   Tomatoplate  ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw
	name = "未烤制的番茄薄饼"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pizza_base"
	desc = "擀平面团表面抹了厚厚一层番茄酱。再撒上新鲜奶酪，就能圆满了。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("撕开新鲜奶酪，撒在抹了番茄酱的擀平面团上……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给抹了番茄酱的面团撒上奶酪！"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	name = "未烤制的奶酪番茄薄饼"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pizza_uncooked"
	desc = "擀平面团表面抹了厚厚一层番茄酱，还撒了新鲜奶酪。它已经可以烤成美味的番茄薄饼了，除非你还想添上香肠、鱼柳、洋葱、梨或松露。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("给铺了奶酪的番茄薄饼加上香肠……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给它加上配料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/fish) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("给铺了奶酪的番茄薄饼加上鱼柳……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_fish(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给它加上配料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/truffles))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("给铺了奶酪的番茄薄饼加上松露……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_truffles(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给它加上配料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toxicshrooms))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("给铺了奶酪的番茄薄饼加上松露……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_poisontruffles(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给它加上配料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/onion/rogue))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("仔细把整颗洋葱撕碎，均匀铺在抹了奶酪的番茄薄饼上……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给它加上配料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("给铺了奶酪的番茄薄饼加上洋葱片……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给它加上配料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/pear))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("给铺了奶酪的番茄薄饼加上梨……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_pear(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给它加上配料！"))
	else
		return ..()

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_sausage
	name = "未烤制的香肠番茄薄饼"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "sausage_pizza_uncooked"
	desc = "擀平面团表面抹了厚厚一层番茄酱，撒了新鲜奶酪，还点缀着一片片香肠。它已经可以烤成滋味浓郁的番茄薄饼了。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_meat
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate
	foodtype = GRAIN | FRUIT | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_fish
	name = "未烤制的鱼肉番茄薄饼"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "fish_pizza_uncooked"
	desc = "擀平面团表面抹了厚厚一层番茄酱，撒了新鲜奶酪，还点缀着一条条鱼柳。它已经可以烤成油润可口的番茄薄饼了。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_fish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate
	foodtype = GRAIN | FRUIT | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_truffles
	name = "未烤制的松露番茄薄饼"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "truffle_pizza_uncooked"
	desc = "擀平面团表面抹了厚厚一层番茄酱，撒了新鲜奶酪，还点缀着一颗颗珍稀松露。它已经可以烤成奢靡可口的番茄薄饼了。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/truffletomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_poisontruffles
	name = "未烤制的松露番茄薄饼"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "truffle_pizza_uncooked"
	desc = "擀平面团表面抹了厚厚一层番茄酱，撒了新鲜奶酪，还点缀着一颗颗珍稀松露。它已经可以烤成奢靡可口的番茄薄饼了。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	list_reagents = list(/datum/reagent/berrypoison = 5)
	cooked_smell = /datum/pollutant/food/tomatoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisontruffletomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion
	name = "未烤制的洋葱番茄薄饼"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "onion_pizza_uncooked"
	desc = "擀平面团表面抹了厚厚一层番茄酱，撒了新鲜奶酪，还点缀着一圈圈洋葱。它已经可以烤成乡土气息十足的番茄薄饼了。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_onion
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/oniontomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_pear
	name = "未烤制的梨香番茄薄饼"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pear_pizza_uncooked"
	desc = "擀平面团表面抹了厚厚一层番茄酱，撒了新鲜奶酪，还点缀着一块块多汁的梨。它已经可以烤成创意十足的番茄薄饼了。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_pear
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/peartomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/*	.................   Smalldough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/doughslice
	name = "小面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "doughslice"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bun
	cooked_smell = /datum/pollutant/food/bun
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/doughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("加入新鲜奶酪……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesebun_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/doughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团并在一起……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/dough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/astrata))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("把阿斯特拉塔十字印进面坯里……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross)) // This is gonna be messy cuz other are subtypes
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("把普赛圣十字压进面坯里……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/dough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团揉成长条形……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	else
		return ..()

/*	.................   Butterdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdough
	name = "黄油面团"
	desc = "比起传承，眼前这点成果又算什么？"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough"
	color = "#feffc1"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bookbread
	cooked_smell = /datum/pollutant/food/bookbread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/butterdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把蛋揉进黄油面团里，塑成蛋糕坯……"))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/cake_base(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/kitchen/spoon))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把黄油面团进一步摊开，塑成玛芬坯……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/muffindough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能塑成玛芬！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed) || istype(I, /obj/item/reagent_containers/food/snacks/pumpkinspice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往黄油面团里加入南瓜……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinloaf_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能准备它！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/pear))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把梨揉进黄油面团里，塑成果味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/pearbread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/plum))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把李子揉进黄油面团里，塑成果味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/plumbread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/lemon))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把柠檬揉进黄油面团里，塑成果味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/lemonbread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把蜜橘揉进黄油面团里，塑成果味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tangerinebread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把黑莓揉进黄油面团里，塑成果味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/blackberrybread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把覆盆子揉进黄油面团里，塑成果味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/raspberrybread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把杰克莓揉进黄油面团里，塑成果味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把杰克莓揉进黄油面团里，塑成果味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/poisonberrybread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/chocolate) || istype(I, /obj/item/reagent_containers/food/snacks/chocolate/slice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把巧克力揉进黄油面团里，塑成甜味面包坯……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进巧克力！"))
	else
		return ..()

//

/obj/item/reagent_containers/food/snacks/rogue/pearbread_uncooked
	name = "填梨黄油面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_pear"
	desc = "一堆点缀着梨块的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pearbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/plumbread_uncooked
	name = "填李子黄油面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_plum"
	desc = "一堆点缀着李子块的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/plumbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/lemonbread_uncooked
	name = "填柠檬黄油面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_lemon"
	desc = "一堆点缀着柠檬块的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/tangerinebread_uncooked
	name = "填蜜橘黄油面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_tangerine"
	desc = "一堆点缀着蜜橘块的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/blackberrybread_uncooked
	name = "填黑莓黄油面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_blackberry"
	desc = "一堆点缀着黑莓的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/raspberrybread_uncooked
	name = "填覆盆子黄油面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_raspberry"
	desc = "一堆点缀着覆盆子的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked
	name = "填杰克莓黄油面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_jacksberry"
	desc = "一堆点缀着杰克莓的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybread_uncooked
	name = "填杰克莓黄油面团" //Like pies, these are Evil. Indistinguishable from traditional jackberried variants, until eaten.
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_jacksberry"
	desc = "一堆点缀着杰克莓的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	list_reagents = list(/datum/reagent/berrypoison = 12)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked
	name = "填巧克力黄油面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_chocolate"
	desc = "一堆点缀着巧克力碎的黄油面团，尚未经炉火温热的点化升华。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/chocolate_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread
	foodtype = GRAIN | DAIRY

/*	.................   Butterdough Piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	name = "黄油面团块"
	desc = "一小块好底子，也能擀出一段好味道。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdoughslice"
	color = "#feffc1"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/frybread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pastry
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL

// Dough + rolling pin on table = flat dough. RT got some similar proc for this.
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]擀平……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/piedough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/kitchen/spoon))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("在[src]上压出一个凹窝……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tartdough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed) || istype(I, /obj/item/reagent_containers/food/snacks/pumpkinspice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往黄油面团里加入南瓜……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinball_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能准备它！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往黄油面团里加入蜜橘……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tangerinebiscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tangerinebiscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/plum))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往黄油面团里加入葡萄干……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/plumbiscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/plumbiscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往面团里加入葡萄干……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进水果！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/chocolate) || istype(I, /obj/item/reagent_containers/food/snacks/chocolate/slice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往面团里加入巧克力……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进巧克力！"))
	if(I.get_sharpness())
		if(!isdwarf(user))
			to_chat(user, span_warning("你不懂矮人点心的做法！"))
			return
		else
			if(isturf(loc)&& (found_table))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_notice("把黄油面团切成条，做成椒盐卷饼……"))
				if(do_after(user,short_cooktime, target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw(loc)
					qdel(src)
			else
				to_chat(user, span_warning("你得先把[src]放到桌上才能切。"))
	else
		..()

/*	.................   Muffindough Piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/muffindough
	name = "松饼面团"
	desc = "松饼时间到！"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "muffindough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin
	cooked_smell = /datum/pollutant/food/muffin
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................   Piedough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/piedough
	name = "派皮面团"
	desc = "更丰盛之物的开端。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "piedough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	cooked_smell = /datum/pollutant/food/pie_base
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/piedough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/truffles))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/mushroom)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/crab))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/crab)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/apple)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/potato)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue))//This produces 3 instead of 2 so it'd be obvious go to.
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/cabbage)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/piedough/proc/prepare_handpie(obj/item/I, mob/living/user, handpie_path)
	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("正在包手馅饼……"))
	if(do_after(user,short_cooktime, target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		var/handpie = new handpie_path(get_turf(user))
		user.put_in_hands(handpie)
		qdel(I)
		qdel(src)

/*	.................   Strudel Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/strudeldough
	name = "卷酥面团"
	desc = "尚待填满的美味外壳。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strudel_raw"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
	process_step = 1

/obj/item/reagent_containers/food/snacks/rogue/strudeldough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往面团里填入苹果……"))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "填了一半的卷酥"
			desc = "卷酥坯里装满了苹果，还缺另一半来合拢。"
			process_step = 2
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/nut))
		if(process_step != 2)
			return
		to_chat(user, span_notice("再用石果完成最后的馅料……"))
		if(do_after(user, short_cooktime, target = src))
			name = "填满的卷酥"
			desc = "苹果和坚果已经把卷酥塞得满满当当，接下来只差烘烤。"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/strudel
			process_step = 3
			qdel(I)
			return
	return ..()

/*	.................   Tartdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/tartdough
	name = "凹窝挞面团"
	desc = "一只尚未展露全部潜力的空心面碗。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dottart_base"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
	process_step = 1

/obj/item/reagent_containers/food/snacks/rogue/tartdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入蜜橘……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_tangerine(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能往里填馅！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/plum))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入李子……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_plum(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能压实馅料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入黑莓……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_blackberry(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能压实馅料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入覆盆子……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_raspberry(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能压实馅料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入草莓……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_strawberry(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能压实馅料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/pear))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入梨……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_pear(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能压实馅料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入苹果片……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_apple(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能压实馅料！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入……金苹果片……？"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能压实馅料！"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_tangerine
	name = "未烤制的蜜橘凹窝挞"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "tangerine_dottart_base"
	desc = "一只装满美味蜜橘的黄油面团空心碗，如今只消在炉中烤上一番，便能成就它的全部潜力。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/tangerine
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_plum
	name = "未烤制的李子凹窝挞"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "plum_dottart_base"
	desc = "一只装满家常李子的黄油面团空心碗，如今只消在炉中烤上一番，便能成就它的全部潜力。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/plum
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_blackberry
	name = "未烤制的黑莓凹窝挞"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "blackberry_dottart_base"
	desc = "一只装满酸黑莓的黄油面团空心碗，如今只消在炉中烤上一番，便能成就它的全部潜力。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/blackberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_raspberry
	name = "未烤制的覆盆子凹窝挞"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "raspberry_dottart_base"
	desc = "一只装满酸涩覆盆子的黄油面团空心碗，如今只消在炉中烤上一番，便能成就它的全部潜力。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/raspberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_strawberry
	name = "未烤制的草莓凹窝挞"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strawberry_dottart_base"
	desc = "一只装满甜甜草莓的黄油面团空心碗，如今只消在炉中烤上一番，便能成就它的全部潜力。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/strawberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_pear
	name = "未烤制的梨香凹窝挞"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pear_dottart_base"
	desc = "一只装满蜜渍梨的黄油面团空心碗，如今只消在炉中烤上一番，便能成就它的全部潜力。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/pear
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_apple
	name = "未烤制的苹果凹窝挞"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "apple_dottart_base"
	desc = "一只装满苹果片的黄油面团空心碗，如今只消在炉中烤上一番，便能成就它的全部潜力。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/apple
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple
	name = "未烤制的仙馔凹窝挞"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "gapple_dottart_base"
	desc = "一只装满神圣果实的黄油面团空心碗，如今只消在炉中烤上一番，便能成就它的全部潜力。"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/goldapple
	list_reagents = list(/datum/reagent/medicine/stronghealth = 6) //Because you're going to want something after vomiting up all your guts up for eating raw dough.
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 100, "size" = 1))
