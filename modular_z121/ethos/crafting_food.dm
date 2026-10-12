// 独立烹饪与食材加工只在实际制作步骤应用怠惰倍率。

// 同名核心覆写按原顺序连接，拾取、倒水、进食及其他父类交互不额外延长。

/obj/item/natural/bundle/stick/attackby(obj/item/W, mob/living/user)
	. = call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/natural/bundle, attackby))(arglist(args))
	user.changeNext_move(CLICK_CD_MELEE)
	if(user.used_intent?.blade_class == BCLASS_CUT)
		playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 100)
		user.visible_message(span_info("[user]开始削尖[src]里的木棍..."), span_info("我开始削尖[src]里的木棍..."))
		for(var/i in 1 to (amount - 1))
			if(!do_after(user, (20) * z121_ethos_craft_multiplier(user)))
				break
			var/turf/T = get_turf(user.loc)
			var/obj/item/grown/log/tree/stake/S = new /obj/item/grown/log/tree/stake(T)
			amount--

			if (amount == 1)

				var/obj/item/ST = new stacktype(T)
				if(user.is_holding(src))
					user.doUnEquip(src, TRUE, T, silent = TRUE)
				qdel(src)
				var/holding = user.put_in_hands(ST)

				if(!do_after(user, (20) * z121_ethos_craft_multiplier(user)))
					break
				S = new /obj/item/grown/log/tree/stake(T)
				if(holding)
					user.doUnEquip(ST, TRUE, T, silent = TRUE)
				qdel(ST)
			else
				update_bundle()
			user.put_in_hands(S)
			S.pixel_x = rand(-3, 3)
			S.pixel_y = rand(-3, 3)
		return

/obj/item/natural/cloth/proc/z121_ethos_prepare_medicine_cloth(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/C = I
	if(!istype(C))
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/natural, attackby))(arglist(args))
	if(C.reagents.has_reagent(/datum/reagent/medicine/healthpot, 10) && !medicine_amount)
		to_chat(user, span_notice("将[src]浸泡在治疗药水中..."))
		if(do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
			// 读条结束重新核对药液和药布，不能叠加并发浸泡。
			if(QDELETED(C) || medicine_amount || !C.reagents?.has_reagent(/datum/reagent/medicine/healthpot, 10))
				return
			C.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 10)
			medicine_quality = 1
			medicine_amount += 10
			desc += " 它已被治疗药水浸泡。"
			detail_color = "#ff0000"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/medicine/stronghealth, 10) && !medicine_amount)
		to_chat(user, span_notice("将[src]浸泡在强效治疗药水中..."))
		if(do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
			// 读条结束重新核对药液和药布，不能叠加并发浸泡。
			if(QDELETED(C) || medicine_amount || !C.reagents?.has_reagent(/datum/reagent/medicine/stronghealth, 10))
				return
			C.reagents.remove_reagent(/datum/reagent/medicine/stronghealth, 10)
			medicine_quality = 2
			medicine_amount += 10
			desc += " 它已被强效治疗药水浸泡。."
			detail_color = "#820000"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10) && !medicine_amount)
		to_chat(user, span_notice("将[src]浸泡在生命之水中..."))
		if(do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
			// 读条结束重新核对药液和药布，不能叠加并发浸泡。
			if(QDELETED(C) || medicine_amount || !C.reagents?.has_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10))
				return
			C.reagents.remove_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10)
			medicine_quality = 0.5
			medicine_amount += 60
			desc += " 它已被生命之水浸泡。"
			detail_color = "#6e6e6e"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/water/blessed, 10) && !medicine_amount)
		to_chat(user, span_notice("将[src]浸泡在圣水中..."))
		if(do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
			// 读条结束重新核对药液和药布，不能叠加并发浸泡。
			if(QDELETED(C) || medicine_amount || !C.reagents?.has_reagent(/datum/reagent/water/blessed, 10))
				return
			C.reagents.remove_reagent(/datum/reagent/water/blessed, 10)
			medicine_quality = 0.2
			medicine_amount += 20
			desc += " 它已被祝福之水浸泡。"
			detail_color = "#6a9295"
			update_icon()

/obj/item/natural/cloth/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			user.visible_message(span_info("[user]开始把鲜奶酪包进布里..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel(loc)
				qdel(I)
				qdel(src)
			return
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	z121_ethos_prepare_medicine_cloth(arglist(args))

/obj/item/ration/attackby(obj/item/I, mob/user)
	. = call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item, attackby))(arglist(args))
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/F = I
		if(food)
			to_chat(user, span_warning("[src]中已经包裹了其他物品。"))
			return
		if(do_after(user, (2 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
			user.transferItemToLoc(F, src)
			food = I
			to_chat(user, span_notice("你用口粮包装纸包裹了[F]。"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			F.rotprocess = null
			if(I.w_class >= WEIGHT_CLASS_NORMAL)
				name = "[food.name]大型口粮包"
				desc = "一个包含[food.name]的大型口粮包。"
				icon_state = "ration_large"
				dropshrink = 1

			else
				name = "[food.name]小型口粮包"
				desc = "一个包含[food.name]的小型口粮包。"
				icon_state = "ration_small"
				dropshrink = 1
			update_icon()

/obj/item/reagent_containers/attackby(obj/item/I, mob/living/user, params)
	call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item, attackby))(arglist(args))
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/salt))
		if(!reagents.has_reagent(/datum/reagent/consumable/milk, 15))
			to_chat(user, span_warning("牛奶不足。"))
			return
		to_chat(user, span_warning("往牛奶里加盐。"))
		playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			// 等待结束后复核原料，防止并发加工领取空材料的劳动奖励。
			if(QDELETED(I) || !reagents?.has_reagent(/datum/reagent/consumable/milk, 15))
				return
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			reagents.remove_reagent(/datum/reagent/consumable/milk, 15)
			reagents.add_reagent(/datum/reagent/consumable/milk/salted, 15)
			qdel(I)

/obj/item/reagent_containers/food/snacks/butter/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		to_chat(user, span_notice("把鸡蛋磕在黄油上。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			new /obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight(drop_location())
			qdel(I)
			qdel(src)
			return
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/butterslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/sugar))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("拌入糖来制作糖霜..."))
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
				new /obj/item/reagent_containers/food/snacks/rogue/frosting(drop_location())
				qdel(I)
				qdel(src)
			return
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/fat/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在灌制香肠..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/grown/rice/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
			user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
			new /obj/item/reagent_containers/food/snacks/rogue/ricewet(loc)
			qdel(src)
	else call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item, attack_hand))(arglist(args))

/obj/item/reagent_containers/food/snacks/grown/rice/wet(obj/item/I, mob/living/user)
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
	if(do_after(user, (2 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
		if(water_added || (is_container && (QDELETED(R) || !R.reagents?.has_reagent(/datum/reagent/water, 10))))
			return TRUE
		user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
		name = "湿米"
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#d9d0cb"
	return TRUE

/obj/item/reagent_containers/food/snacks/rogue/butterdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把蛋揉进黄油面团里，塑成蛋糕坯……"))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/muffindough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能塑成玛芬！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed) || istype(I, /obj/item/reagent_containers/food/snacks/pumpkinspice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往黄油面团里加入南瓜……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进巧克力！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]擀平……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/piedough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/kitchen/spoon))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("在[src]上压出一个凹窝……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tartdough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed) || istype(I, /obj/item/reagent_containers/food/snacks/pumpkinspice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往黄油面团里加入南瓜……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能填进巧克力！"))
	if(I.get_sharpness())
		if(!isdwarf(user) && !HAS_TRAIT(user, TRAIT_DWARVEN_CHEF))
			to_chat(user, span_warning("你不懂矮人点心的做法！"))
			return
		else
			if(isturf(loc)&& (found_table))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_notice("把黄油面团切成条，做成椒盐卷饼……"))
				if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw(loc)
					qdel(src)
			else
				to_chat(user, span_warning("你得先把[src]放到桌上才能切。"))
	else
		call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/dough_base/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/flour))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("继续揉入更多面粉……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/dough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能继续揉制。"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/dough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("把黄油揉进面团里……"))
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/rbread_half(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("揉面团并加入苹果片……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/abread_half(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团揉成长条形……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/flatdough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/doughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("加入新鲜奶酪……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("把普赛圣十字压进面坯里……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/dough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团揉成长条形……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/flatdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(I.get_sharpness())
		if(isturf(loc)&& (found_table))
			playsound(user, 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("在[src]上划出纹路……"))
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给擀平面团抹上番茄酱！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc) && found_table)
			if(process_step == 4)
				return
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往炸鸟肉上打入一枚蛋。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "裹蛋嫩炸鸟肉"
			desc = "打过鸡蛋的炸鸟肉坯子，还在等面包屑和热油锅。"
			icon_state = "chickentender_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("给炸鸟肉裹上面包屑。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "裹屑嫩炸鸟肉"
			desc = "已经裹好面包屑的炸鸟肉坯子，就等下锅了。"
			icon_state = "chickentender_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/chickentender
			update_icon()
			qdel(I)
			return
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往炸肉排上打入一枚蛋。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "裹蛋炸肉排"
			desc = "打过鸡蛋的炸肉排坯子，还在等面包屑和热油锅。"
			icon_state = "nitzel_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("给炸肉排裹上面包屑。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "裹屑炸肉排"
			desc = "已经裹好面包屑的炸肉排坯子，就等下锅了。"
			icon_state = "nitzel_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
			update_icon()
			qdel(I)
			return
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作鱼派……"))
			name = "未完成的鱼派"
			process_step += 1
			fishy = TRUE
			update_icon()
			qdel(I)
			return
		if(fishy && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往鱼派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(fishy && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("鱼派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作肉派……"))
			name = "未完成的肉派"
			process_step += 1
			meaty = TRUE
			update_icon()
			qdel(I)
			return
		if(meaty && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往肉派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(meaty && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("肉派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider))
		if(!isdarkelf(user) && !HAS_TRAIT(user, TRAIT_UNDERDARK_CHEF))
			to_chat(user, span_warning("你不懂幽暗地域的珍馐之道！"))
			return
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作蛛肉派……"))
			name = "未完成的蛛肉派"
			process_step += 1
			spidermeaty = TRUE
			update_icon()
			qdel(I)
			return
		if(spidermeaty && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往蛛肉派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(spidermeaty && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("蛛肉派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		else
			to_chat(user, span_notice("你不懂幽暗地域的珍馐之道！"))

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed))
		if (process_step > 2)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作南瓜派……接下来需要一些新鲜奶酪。"))
			name = "未完成的南瓜派"
			desc = initial(desc) + "\n" + span_smallnotice("它需要一些新鲜奶酪。")
			process_step += 1
			pumpkinpie = TRUE
			update_icon()
			qdel(I)
			return
	if(pumpkinpie)
		if (process_step > 4)
			return
		if(process_step == 2 && istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				to_chat(user, span_notice("把南瓜和奶酪在派里拌匀。还差一枚蛋。"))
				desc = initial(desc) + "\n" + span_smallnotice("它需要一枚蛋。")
				process_step += 1
				update_icon()
				qdel(I)
				return
		else if(process_step == 3 && istype(I, /obj/item/reagent_containers/food/snacks/egg))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 30, TRUE, -1)
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				to_chat(user, span_notice("把馅料和蛋在南瓜派里拌匀。就差糖了！"))
				desc = initial(desc) + "\n" + span_smallnotice("它需要一些糖。")
				process_step += 1
				update_icon()
				qdel(I)
				return
		else if(process_step == 4 && istype(I, /obj/item/reagent_containers/food/snacks/sugar))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				name = "生南瓜派"
				desc = initial(desc)
				filling_color = "#df5c04"
				cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pumpkin
				cooked_smell = /datum/pollutant/food/pumpkin_pie
				process_step += 1
				update_icon()
				qdel(I)

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced)  || istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese) )
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浓馅派……"))
			name = "未完成的浓馅派"
			process_step += 1
			potpie = TRUE
			var/mutable_appearance/pot1 = mutable_appearance(icon, "fill_pot1")
			add_overlay(pot1)
			qdel(I)
			return
		if(potpie && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浓馅派里添馅。还得再加一些。"))
			process_step += 1
			var/mutable_appearance/pot2 = mutable_appearance(icon, "fill_pot2")
			add_overlay(pot2)
			qdel(I)
			return
		if(potpie && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浓馅派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			var/mutable_appearance/pot3 = mutable_appearance(icon, "fill_pot3")
			add_overlay(pot3)
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/egg) )
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浓馅派……"))
			name = "未完成的浓馅派"
			process_step += 1
			potpie = TRUE
			var/mutable_appearance/egg1 = mutable_appearance(icon, "fill_egg1")
			add_overlay(egg1)
			qdel(I)
			return
		if(potpie && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浓馅派里添馅。还得再加一些。"))
			process_step += 1
			var/mutable_appearance/egg2 = mutable_appearance(icon, "fill_egg2")
			add_overlay(egg2)
			qdel(I)
			return
		if(potpie && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浓馅派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			var/mutable_appearance/egg3 = mutable_appearance(icon, "fill_egg3")
			add_overlay(egg3)
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/bacon) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry) || istype(I, /obj/item/reagent_containers/food/snacks/fat) )
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浓馅派……"))
			name = "未完成的浓馅派"
			process_step += 1
			potpie = TRUE
			var/mutable_appearance/animal1 = mutable_appearance(icon, "fill_fish1")
			add_overlay(animal1)
			qdel(I)
			return
		if(potpie && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浓馅派里添馅。还得再加一些。"))
			process_step += 1
			var/mutable_appearance/animal2 = mutable_appearance(icon, "fill_fish2")
			add_overlay(animal2)
			qdel(I)
			return
		if(potpie && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浓馅派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			var/mutable_appearance/animal3 = mutable_appearance(icon, "fill_fish3")
			add_overlay(animal3)
			qdel(I)
			return

		var/mutable_appearance/animal1 = mutable_appearance(icon, "fill_fish1")
		add_overlay(animal1)

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/crab))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作蟹派……你觉得剩下的某一份蟹肉或许可用卷心菜丝代替。"))
			name = "未完成的蟹派"
			process_step += 1
			crabby = TRUE
			update_icon()
			qdel(I)
			return
		if(crabby && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往蟹派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(crabby && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("蟹派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced))
		if (process_step > 4 || process_step == 1)
			return
		if (substitute == TRUE)
			to_chat(user, span_notice("这只派里的卷心菜已经太多了。"))
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(crabby && process_step >= 2 && process_step <= 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("用卷心菜代替这份蟹派中的一部分蟹肉……"))
			process_step += 1
			substitute = TRUE
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作苹果派……"))
			name = "未完成的苹果派"
			process_step += 1
			applepie = TRUE
			update_icon()
			qdel(I)
			return
		if(applepie && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往苹果派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(applepie && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("苹果派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浆果派……"))
			name = "未完成的浆果派"
			process_step += 1
			berrypie = TRUE
			poisoning = TRUE
			update_icon()
			qdel(I)
			return
		if(berrypie && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浆果派里添馅。还得再加一些。"))
			process_step += 1
			poisoning = TRUE
			update_icon()
			qdel(I)
			return
		if(berrypie && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浆果派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			poisoning = TRUE
			update_icon()
			qdel(I)
			return

	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浆果派……"))
			name = "未完成的浆果派"
			process_step += 1
			berrypie = TRUE
			update_icon()
			qdel(I)
			return
		if(berrypie && process_step == 2 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浆果派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(berrypie && process_step == 3 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浆果派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/piedough))
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
		if(fishy && process_step == 4 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "生鱼派"
			icon_state = "fishpie_raw"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
			cooked_smell = /datum/pollutant/food/fish_pie
			filling_color = "#d44197"
			process_step += 1
			update_icon()
			qdel(I)
		else if(meaty && process_step == 4 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "生肉派"
			icon_state = "meatpie_raw"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat
			cooked_smell = /datum/pollutant/food/meat_pie
			filling_color = "#b43628"
			process_step += 1
			update_icon()
			qdel(I)
		else if(spidermeaty && process_step == 4 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "生蛛肉派"
			icon_state = "spiderpie_raw"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/spider
			cooked_smell = /datum/pollutant/food/spider_pie
			filling_color = "#6a9153"
			process_step += 1
			update_icon()
			qdel(I)
		else if(potpie && process_step == 4 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "生浓馅派"
			filling_color = "#755430"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot
			cooked_smell = /datum/pollutant/food/pot_pie
			process_step += 1
			update_icon()
			qdel(I)
		else if(applepie && process_step == 4 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "生苹果派"
			filling_color = "#947a4b"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
			cooked_smell = /datum/pollutant/food/apple_pie
			process_step += 1
			update_icon()
			qdel(I)
		else if(poisoning && process_step == 4 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "生浆果派"
			filling_color = "#4a62cf"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison
			cooked_smell = /datum/pollutant/food/berry_pie
			process_step += 1
			update_icon()
			qdel(I)
		else if(berrypie && process_step == 4 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "生浆果派"
			filling_color = "#4a62cf"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
			cooked_smell = /datum/pollutant/food/berry_pie
			process_step += 1
			update_icon()
			qdel(I)
		else if(crabby && process_step == 4 && do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "生蟹派"
			filling_color = "#f1e0cb"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab
			cooked_smell = /datum/pollutant/food/crab_pie
			process_step += 1
			update_icon()
			qdel(I)
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往蛛肉炸排上打入一枚蛋。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "裹蛋蛛肉炸排"
			desc = "打过鸡蛋的蛛肉炸排坯子，还在等面包屑和热油锅。"
			icon_state = "schnitzel_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("给蛛肉炸排裹上面包屑。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "裹屑蛛肉炸排"
			desc = "已经裹好面包屑的蛛肉炸排坯子，就等下锅了。"
			icon_state = "schnitzel_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
			update_icon()
			qdel(I)
			return
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给黄油裹上面包屑。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "裹屑侍从之悦"
			desc = "一条裹好面包屑的黄油，就等下锅油炸。"
			icon_state = "squiresdelight_step2"
			process_step = 2
			deep_fried_type = /obj/item/reagent_containers/food/snacks/squiresdelight
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("给铺了奶酪的番茄薄饼加上香肠……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_pear(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给它加上配料！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("撕开新鲜奶酪，撒在抹了番茄酱的擀平面团上……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上，才能给抹了番茄酱的面团撒上奶酪！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往炸肉排上打入一枚蛋。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "裹蛋维也纳炸肉排"
			desc = "打过鸡蛋的维也纳炸肉排坯子，还在等面包屑和热油锅。"
			icon_state = "wienernitzel_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("给炸肉排裹上面包屑。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "裹屑维也纳炸肉排"
			desc = "已经裹好面包屑的维也纳炸肉排坯子，就等下锅了。"
			icon_state = "wienernitzel_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/wiener
			update_icon()
			qdel(I)
			return
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/meat/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]拍松成炸肉排坯。"))
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀压！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/meat/crab/proc/z121_ethos_prepare_crab_meat(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, "<span class='notice'>用黄油面皮把蟹肉包起来……</span>")
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把它放到桌上！"))
		return TRUE
	. = call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue/meat, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/meat/crab/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, "<span class='notice'>用黄油面皮把螃蟹包起来……</span>")
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw(loc)
				qdel(I)
				qdel(src)
		return TRUE
	. = z121_ethos_prepare_crab_meat(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在灌制香肠……"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/fat))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在灌制香肠……"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在准备鞑靼生肉……"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tartar(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能处理。"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue/meat, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider/attackby(obj/item/I, mob/living/user)
	var/obj/structure/table/found_table = locate() in (loc)
	update_cooktime(user)
	if(!isdarkelf(user) && !HAS_TRAIT(user, TRAIT_UNDERDARK_CHEF))
		to_chat(user, span_warning("你不懂幽暗地域的珍馐之道！"))
		return
	else
		if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider))
			if(isturf(loc)&& (found_table))
				to_chat(user, span_notice("正在准备蜘蛛肉丸……"))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/meat/spider/meatball/(loc)
					qdel(I)
					qdel(src)
			else
				to_chat(user, span_warning("你得先把[src]放到桌上才能加工。"))
		if(istype(I, /obj/item/reagent_containers/powder/flour))
			if(isturf(loc)&& (found_table))
				to_chat(user, span_notice("把面粉和[src]拌在一起……"))
				playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
				if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/meat/spider/surprise/(loc)
					qdel(I)
					qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]拍松。"))
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀压！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue/meat, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("正在拍松[src]。"))
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue/meat, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/meat/spider/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]拍松成蛛肉炸排坯。"))
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀压！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue/meat, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove))
		if(isturf(loc) && found_table)
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick(loc)
				qdel(I)
				qdel(src)
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue/meat, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/piedough/prepare_handpie(obj/item/I, mob/living/user, handpie_path)
	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("正在包手馅饼……"))
	if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		var/handpie = new handpie_path(get_turf(user))
		user.put_in_hands(handpie)
		qdel(I)
		qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/raisins/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/raisins/lemon/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/raisins/lime/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/raisins/pear/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/raisins/plum/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给果干块裹上蜂蜜。"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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

/obj/item/reagent_containers/food/snacks/rogue/strudeldough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往面团里填入苹果……"))
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			name = "填满的卷酥"
			desc = "苹果和坚果已经把卷酥塞得满满当当，接下来只差烘烤。"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/strudel
			process_step = 3
			qdel(I)
			return
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/food/snacks/rogue/tartdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("往凹窝挞面团里填入蜜橘……"))
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
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
			if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能压实馅料！"))
	else
		return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/food/snacks/rogue, attackby))(arglist(args))

/obj/item/reagent_containers/glass/bucket/proc/z121_ethos_churn_butter(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/kitchen/spoon))
		if(!reagents.has_reagent(/datum/reagent/consumable/milk/salted, 15))
			to_chat(user, span_warning("咸牛奶不足。"))
			return
		user.visible_message(span_info("[user]搅拌起黄油..."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/churn.ogg', 100, TRUE, -1)
		if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			// 等待结束后复核原料，防止并发加工领取空材料的劳动奖励。
			if(QDELETED(I) || !reagents?.has_reagent(/datum/reagent/consumable/milk/salted, 15))
				return
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			reagents.remove_reagent(/datum/reagent/consumable/milk/salted, 15)
			new /obj/item/reagent_containers/food/snacks/butter(drop_location())
		return
	call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/glass, attackby))(arglist(args))

/obj/item/reagent_containers/glass/bucket/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/natural/cloth))
		if(reagents.has_reagent(/datum/reagent/consumable/milk/salted, 5))
			user.visible_message(span_info("[user]滤出新鲜的奶酪..."))
			playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
			if(do_after(user, (long_cooktime) * z121_ethos_craft_multiplier(user), target = src))
				// 等待结束后复核原料，防止并发加工领取空材料的劳动奖励。
				if(QDELETED(I) || !reagents?.has_reagent(/datum/reagent/consumable/milk/salted, 5))
					return
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				reagents.remove_reagent(/datum/reagent/consumable/milk/salted, 5)
				new /obj/item/reagent_containers/food/snacks/rogue/cheese(drop_location())
			return
	z121_ethos_churn_butter(arglist(args))

/obj/item/reagent_containers/glass/bucket/pot/teapot/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		if(reagents.total_volume)
			to_chat(user, span_notice("茶壶里还有液体时，我没法给它上釉。"))
			return
		if(do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
			to_chat(user, span_notice("我用染色刷给茶壶上了釉。"))
			new /obj/item/reagent_containers/glass/bucket/pot/teapot/fancy(get_turf(src))
			qdel(src)
		return
	. = call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/glass/bucket/pot, attackby))(arglist(args))

/obj/item/reagent_containers/glass/cup/ceramic/attackby(obj/item/I, mob/living/carbon/human/user)
	. = call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/glass/cup, attackby))(arglist(args))
	if(istype(I, /obj/item/dye_brush))
		if(reagents.total_volume)
			to_chat(user, span_notice("杯子里还有液体时，我没法给它上釉。"))
			return
		if(do_after(user, (2 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
			to_chat(user, span_notice("我用染料刷给杯子上了釉。"))
			new /obj/item/reagent_containers/glass/cup/ceramic/fancy(get_turf(src))
			qdel(src)
		return

/obj/item/reagent_containers/powder/flour/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			new /obj/item/reagent_containers/food/snacks/rogue/dough_base(loc)
			qdel(src)
	else call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item, attack_hand))(arglist(args))

/obj/item/reagent_containers/powder/flour/wet(obj/item/I, mob/living/user)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	var/is_container = istype(R, /obj/item/reagent_containers)

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
	if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
		if(water_added || (is_container && (QDELETED(R) || !R.reagents?.has_reagent(/datum/reagent/water, 10))))
			return TRUE
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		name = "湿面粉"
		desc = "在你手中，它注定会成就一番美味。"
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#d9d0cb"
	return TRUE

/obj/item/reagent_containers/powder/mineral/proc/z121_ethos_wet_mineral(obj/item/I, mob/user, params)
	var/obj/item/reagent_containers/R = I
	if(istype(R) && wet(I, user))
		return TRUE
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers, attackby))(arglist(args))

/obj/item/reagent_containers/powder/mineral/attackby(obj/item/I, mob/user, params)
	if(water_added)
		if(istype(I, /obj/item/natural/cloth))
			user.visible_message(span_info("[user] 正在筛滤矿粉……"))
			playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 90, TRUE, -1)
			if(do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), target = src))
				new /obj/item/reagent_containers/powder/coarse_salt(loc)
				qdel(src)
	else z121_ethos_wet_mineral(arglist(args))

/obj/item/reagent_containers/powder/mineral/wet(obj/item/I, mob/user)
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
	if(do_after(user, (short_cooktime) * z121_ethos_craft_multiplier(user), target = src))
		if(water_added || (is_container && (QDELETED(R) || !R.reagents?.has_reagent(/datum/reagent/water, 10))))
			return TRUE
		name = "处理过的矿粉"
		desc = "还是相当粗糙，还得再筛一遍。"
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#666262"
	return TRUE
