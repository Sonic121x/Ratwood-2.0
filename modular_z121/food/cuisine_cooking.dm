// 炉灶与锅分别记录占用；取走锅后也不能用同一口锅同时开始第二批料理。
/obj/machinery/light/rogue/hearth
	var/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/z121_cuisine_batch

/obj/item/reagent_containers/glass/bucket/pot
	var/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/z121_cuisine_batch

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/examine(mob/user)
	. = ..()
	var/datum/reagent/R = liquid_type
	. += span_notice("在炉灶上架好锅，添足[initial(R.name)]，烧热后下料[cuisine_verb]，守在炉边细心照看火候。")
	if(needs_bowl)
		. += span_notice("另一只手需要拿着空碗，供出锅时盛装。")

// 普通烤炉和煎锅只能烧坏生坯，不能绕过专用交互生成成品。
/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/heating_act(atom/A)
	return

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/cooking(input, burninput, atom/A)
	if(!cuisine_hearth)
		burning(burninput)
	return

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/proc/cuisine_error(mob/living/user, obj/machinery/light/rogue/hearth/H, obj/item/reagent_containers/glass/bucket/pot/P, underway = FALSE)
	if(QDELETED(user) || user.stat || (requires_cuisine_knowledge && !HAS_TRAIT(user, TRAIT_Z121_CUISINE)))
		return "你一时无法专心料理，或还未熟悉这道菜的做法。"
	if(QDELETED(H) || QDELETED(P) || !H.Adjacent(user) || !H.on || H.attachment != P || P.loc != H)
		return "需要在身旁点燃的炉灶上架好锅，并一直照看火候。"
	if((H.z121_cuisine_batch && H.z121_cuisine_batch != src) || (P.z121_cuisine_batch && P.z121_cuisine_batch != src) || (H.food && H.food != src))
		return "这口锅正在处理别的食物。"
	if(!z121_cuisine_fresh(src) || eat_effect != /datum/status_effect/debuff/uncookedfood)
		return "这份食材已经变质、烧坏或被吃过，不宜再拿来做菜。"
	if(z121_requires_bowl)
		var/obj/item/reagent_containers/glass/bowl/B = trash
		if(!istype(B) || QDELETED(B) || B.loc != src || B.reagents.total_volume)
			return "盛装食材的碗不在原处，或碗里混入了别的汤水。"
	if(!P.reagents?.has_reagent(liquid_type, liquid_amount))
		return "锅里的水或油脂不足。"
	// 使用单一水或油作为烹饪介质，避免混汤或油水混合后仍被当作正常蒸煮。
	if(P.reagents.total_volume > P.reagents.get_reagent_amount(liquid_type))
		return "锅里需要纯净的水或炼制油脂，请先清理混入的其他液体。"
	if(P.reagents.chem_temp < 374)
		return "锅还不够热，请等待水沸腾或油烧热。"
	if(underway)
		if(loc != H || H.food != src || H.z121_cuisine_batch != src || P.z121_cuisine_batch != src)
			return "食材已经离锅，无法继续照料火候。"
		if(needs_bowl && (QDELETED(cuisine_bowl) || cuisine_bowl.loc != src || cuisine_bowl.reagents.total_volume))
			return "盛装的空碗已经不在手边。"
	return null

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/proc/cuisine_can_continue(mob/living/user)
	return !QDELETED(src) && !cuisine_error(user, cuisine_hearth, cuisine_pot, TRUE)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/pre_attack(atom/A, mob/living/user, params)
	if(..())
		return TRUE
	var/obj/machinery/light/rogue/hearth/H
	if(istype(A, /obj/machinery/light/rogue/hearth))
		H = A
	else if(istype(A, /obj/item/reagent_containers/glass/bucket/pot) && istype(A.loc, /obj/machinery/light/rogue/hearth))
		H = A.loc
	else
		return FALSE
	if(cuisine_hearth || user.doing || user.get_active_held_item() != src)
		return TRUE
	if(!istype(H.attachment, /obj/item/reagent_containers/glass/bucket/pot))
		to_chat(user, span_warning("先在炉灶上架好一口锅。"))
		return TRUE
	var/obj/item/reagent_containers/glass/bucket/pot/P = H.attachment
	var/error_text = cuisine_error(user, H, P)
	if(error_text)
		to_chat(user, span_warning(error_text))
		return TRUE
	if(needs_bowl)
		for(var/obj/item/reagent_containers/glass/bowl/B in user.held_items)
			if(!B.reagents.total_volume)
				if(user.transferItemToLoc(B, src))
					cuisine_bowl = B
				break
		if(!cuisine_bowl)
			to_chat(user, span_warning("请用另一只手拿一只空碗来盛装。"))
			return TRUE
	cuisine_hearth = H
	cuisine_pot = P
	H.z121_cuisine_batch = src
	P.z121_cuisine_batch = src
	if(!user.transferItemToLoc(src, H))
		cuisine_release()
		return TRUE
	H.food = src
	H.update_icon()
	to_chat(user, span_notice("你将[name]下锅，开始细心[cuisine_verb]。"))
	var/duration = cuisine_time / get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking))
	var/success = do_after(user, duration, needhand = FALSE, target = H, extra_checks = CALLBACK(src, PROC_REF(cuisine_can_continue), user))
	if(QDELETED(src))
		return TRUE
	if(!success || !cuisine_can_continue(user))
		to_chat(user, span_warning("你停下了烹饪，将食材与餐具放回炉边。"))
		cuisine_release()
		return TRUE
	var/obj/item/reagent_containers/food/snacks/S = new result_type(get_turf(H))
	// 加热结果可能仍需上桌加工，容器和保质状态继续传递。
	z121_cuisine_transfer(src, S, TRUE)
	P.reagents.remove_reagent(liquid_type, liquid_amount)
	P.update_icon()
	if(cuisine_bowl)
		cuisine_bowl.forceMove(S)
		S.trash = cuisine_bowl
		cuisine_bowl = null
	if(istype(S, /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot))
		// 共享火锅使用刚才的实体锅，分完后归还，不额外生成锅具。
		H.attachment = null
		H.boilloop.stop()
		P.forceMove(S)
		S.trash = P
	if(user.mind)
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
	to_chat(user, span_nicegreen("[S.name]做好了！"))
	cuisine_release()
	qdel(src)
	return TRUE

// 成功、中断和物品被销毁都走同一清理路径，避免炉灶残留占用或吞掉碗。
/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/proc/cuisine_release()
	var/turf/T = get_turf(src)
	if(!QDELETED(cuisine_hearth))
		if(cuisine_hearth.food == src)
			cuisine_hearth.food = null
		if(cuisine_hearth.z121_cuisine_batch == src)
			cuisine_hearth.z121_cuisine_batch = null
		cuisine_hearth.update_icon()
		if(loc == cuisine_hearth && T)
			forceMove(T)
	if(!QDELETED(cuisine_pot) && cuisine_pot.z121_cuisine_batch == src)
		cuisine_pot.z121_cuisine_batch = null
	if(!QDELETED(cuisine_bowl) && T)
		cuisine_bowl.forceMove(T)
	cuisine_bowl = null
	cuisine_hearth = null
	cuisine_pot = null

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/Destroy()
	cuisine_release()
	return ..()
