// 铸造、磨谷和成品加工在各自的制作读条中使用怠惰倍率。

#define Z121_ETHOS_BASE_GRIND_TIME 1 SECONDS

/obj/item/mold/attackby(obj/item/W, mob/user, params)

	if(istype(W, /obj/item/sprue_funnel))
		if(attached_sprue)
			to_chat(user, span_warning("这个模具已经装上浇口和漏斗了。"))
			return

		if(!user.transferItemToLoc(W, src))
			return

		attached_sprue = W
		update_icon()
		user.visible_message(span_info("[user]把浇口和漏斗装到了模具上。"))
		return

	if(istype(W, /obj/item/reagent_containers/glass/crucible))
		var/obj/item/reagent_containers/glass/crucible/crucible = W

		if(!attached_sprue)
			to_chat(user, span_warning("这个模具需要先装上浇口和漏斗，才能往里浇金属。"))
			return

		if(pouring || cooling)
			to_chat(user, span_warning("这个模具已经在使用中了。"))
			return

		if(!crucible.hot)
			to_chat(user, span_warning("坩埚里的金属还不够热，无法浇注。"))
			return

		if(crucible.get_total_ingots() <= 0)
			to_chat(user, span_warning("坩埚是空的。"))
			return

		user.visible_message(span_info("[user]开始把熔融金属倒入模具。"))
		pouring = TRUE
		update_icon()

		if(do_after(user, (30) * z121_ethos_craft_multiplier(user), target = src))

			var/primary_metal = crucible.get_primary_metal()
			if(crucible.ingots[primary_metal] && crucible.ingots[primary_metal] > 0)
				crucible.ingots[primary_metal]--

				if(crucible.ingots[primary_metal] <= 0)
					crucible.ingots -= primary_metal

				if(crucible.get_total_ingots() <= 0)
					crucible.heat_progress = 0
					crucible.hot = FALSE

				crucible.update_icon()
				pouring = FALSE
				cooling = TRUE
				cooling_progress = 0
				cooling_metal_type = primary_metal
				update_icon()

				user.visible_message(span_info("[user]将熔融金属浇进了模具。它还需要时间冷却并凝固。"))
				START_PROCESSING(SSprocessing, src)
			else
				to_chat(user, span_warning("没能在坩埚里找到合适的金属。"))
				pouring = FALSE
				update_icon()
		else

			pouring = FALSE
			update_icon()

		return

	call(src, /obj/item/attackby)(arglist(args))

/obj/item/millstone/attackby(obj/item/W, mob/living/user, params)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	var/scaled_grind_time = Z121_ETHOS_BASE_GRIND_TIME / get_cooktime_divisor(cs)
	if(W.mill_result)
		if(do_after(user, (scaled_grind_time) * z121_ethos_craft_multiplier(user), target = src))
			new W.mill_result(get_turf(loc))
			qdel(W)
	call(src, /obj/item/attackby)(arglist(args))

/obj/item/grown/log/tree/attacked_by(obj/item/I, mob/living/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/skill_level = user.get_skill_level(/datum/skill/labor/lumberjacking)
	var/planking_time = (40 - (skill_level * 5))
	if(lumber_amount && I.tool_behaviour == TOOL_SAW)
		playsound(get_turf(src.loc), 'sound/foley/sawing.ogg', 100)
		user.visible_message("<span class='notice'>[user]开始将[src]锯成小块。</span>")
		if(do_after(user, (planking_time) * z121_ethos_craft_multiplier(user)))
			new /obj/item/grown/log/tree/small(get_turf(src.loc))
			new /obj/item/grown/log/tree/small(get_turf(src.loc))
			if(prob(skill_level + user.goodluck(2)))
				new /obj/item/grown/log/tree/small(get_turf(src.loc))
			if(prob(skill_level + user.goodluck(2)))
				new /obj/item/grown/log/tree/small/essence(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
			user.mind.add_sleep_experience(/datum/skill/labor/lumberjacking, (user.STAINT*0.5))
			new /obj/effect/decal/cleanable/debris/woody(get_turf(src))
			qdel(src)
			return
	if(user.used_intent.blade_class == BCLASS_CHOP && lumber_amount && lumber)
		var/lumber_time = (40 - (skill_level * 5))
		var/minimum = 1
		playsound(src, 'sound/misc/woodhit.ogg', 100, TRUE)
		if(!do_after(user, lumber_time, target = user))
			return
		if(skill_level > 0)
			minimum = 2
		lumber_amount = rand(minimum, max(round(skill_level), minimum))
		var/sound_played = FALSE
		for(var/i = 0; i < lumber_amount; i++)
			new lumber(get_turf(src))

			if(prob(skill_level + user.goodluck(2)))
				new /obj/item/grown/log/tree/small/essence(get_turf(user))
				if(!sound_played)
					sound_played = TRUE
					to_chat(user, span_warning("登多尔在哭泣……"))
					playsound(src,pick('sound/items/gem.ogg'), 100, FALSE)
		if(blessed)
			if(prob(50))
				to_chat(user, span_notice("登多尔的祝福保留了大量的木材，让我的收获几乎翻倍。"))
				new /obj/item/grown/log/tree/small(get_turf(src))
				new /obj/item/grown/log/tree/small(get_turf(src))
			else if(prob(80))
				to_chat(user, span_notice("登多尔的祝福为我留下了更多可用的木材。"))
				new /obj/item/grown/log/tree/small(get_turf(src))
		if(!skill_level)
			to_chat(user, span_info("由于经验不足，我糟蹋了一些木材..."))
		user.mind.add_sleep_experience(/datum/skill/labor/lumberjacking, (user.STAINT*0.5))
		playsound(src, destroy_sound, 100, TRUE)
		qdel(src)
		return TRUE
	call(src, /obj/attacked_by)(arglist(args))

/obj/item/dye_brush/attack_turf(turf/T, mob/living/user)
	if(!iswallturf(T))
		return
	if(!dye)
		to_chat(user, span_warning("[src]上没有染料！"))
		return
	if(T.color)
		to_chat(user, span_warning("[T]已经被<font color=[T.color]>染料</font>上过色了！"))
		return

	if(!do_after(user, (6 SECONDS) * z121_ethos_craft_multiplier(user), TRUE, T))
		return
	user.visible_message(span_notice("[user]完成了对[T]的<font color=[dye]>上色</font>。"), \
		span_notice("我完成了对[T]的<font color=[dye]>上色</font>。")
	)
	playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
	T.color = dye

	call(src, /obj/item/proc/attack_turf)(arglist(args))

/obj/item/dye_brush/attack_obj(obj/O, mob/living/user)
	if(!isstructure(O))
		return
	if(!dye)
		to_chat(user, span_warning("[src]上没有染料！"))
		return
	if(O.color)
		to_chat(user, span_warning("[O]已经被<font color=[O.color]>染料</font>上过色了！"))
		return

	if(!do_after(user, (3 SECONDS) * z121_ethos_craft_multiplier(user), TRUE, O))
		return
	user.visible_message(span_notice("[user]完成了对[O]的<font color=[dye]>上色</font>。"), \
		span_notice("我完成了对[O]的<font color=[dye]>上色</font>。")
	)
	playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
	O.color = dye

	call(src, /obj/item/proc/attack_obj)(arglist(args))

/obj/item/polishing_cream/attack_obj(obj/O, mob/living/user)
	if(!isitem(O) || !uses)
		return call(src, /obj/item/proc/attack_obj)(arglist(args))
	var/obj/item/thing = O
	if(!thing.anvilrepair)
		return call(src, /obj/item/proc/attack_obj)(arglist(args))
	if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)) && (!thing.polished || (thing.polished == 4 && !thing.polish_bonus)) && obj_integrity <= max_integrity)
		to_chat(user, span_info("我开始往[thing]上涂抹抛光膏……"))
		if(do_after(user, (50 - user.STASPD*2) * z121_ethos_craft_multiplier(user), target = O))
			thing.polished = 1
			uses--
			thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
			thing.add_atom_colour("#635e65", FIXED_COLOUR_PRIORITY)
			thing.RegisterSignal(thing, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(remove_polish))
			if(uses <= 8)
				smeltresult = null
				icon_state = "low_cream"
			if(!uses)
				icon_state = "empty_cream"

/obj/item/armor_brush/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return call(src, /obj/item/proc/attack_obj)(arglist(args))
	var/obj/item/thing = O
	if(thing.polished == 1 && roughness)
		if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)))
			to_chat(user, span_info("我开始粗略地刷开[thing]上的抛光膏……"))
			playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 100, TRUE)
			if(do_after(user, (50 - user.STASTR*1.5) * z121_ethos_craft_multiplier(user), target = O))
				thing.polished = 2
				thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
				thing.add_atom_colour("#9e9e9e", FIXED_COLOUR_PRIORITY)

	else if(thing.polished == 2 && !roughness)
		if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)))
			to_chat(user, span_info("我开始轻柔地打磨[thing]的边缘……"))
			playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 100, TRUE)
			if(do_after(user, (50 - user.STASTR*1.5) * z121_ethos_craft_multiplier(user), target = O))
				thing.polished = 3
				thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
				thing.add_atom_colour("#cccccc", FIXED_COLOUR_PRIORITY)

#undef Z121_ETHOS_BASE_GRIND_TIME
