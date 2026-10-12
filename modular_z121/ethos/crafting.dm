// 制作耗时在实际步骤传入；等待菜单不会影响同角色的其他动作。核心同步由指纹清单校验。
/proc/z121_ethos_craft_multiplier(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		return H.z121_ethos_craft_delay()
	return 1

/datum/component/personal_crafting/construct_item(mob/user, datum/crafting_recipe/R)
	if (HAS_TRAIT(user, TRAIT_CURSE_MALUM))
		to_chat(user, span_warning("你被诅咒的双手颤抖不止，根本无法制作任何东西……玛勒姆不允许如此。"))
		return
	if(user.doing)
		return
	var/list/contents = get_surroundings(user)

	var/turf/T = get_step(user, user.dir)
	var/obj/N
	var/result_name
	if(islist(R.result))
		N = R.result[1]
	else
		N = R.result
	result_name = N.name
	if(isopenturf(T) && R.wallcraft)
		to_chat(user, span_warning("这东西得靠着墙制作。"))
		return
	if(!isopenturf(T) || R.ontile)
		T = get_turf(user.loc)
	if(!R.TurfCheck(user, T))
		to_chat(user, span_warning("我没法在这里制作。"))
		return
	if(isturf(R.result))
		for(var/obj/structure/fluff/traveltile/TT in range(7, user))
			if(TT.craftblock)
				to_chat(user, span_warning("我没法在这里制作。"))
				return
	if(ispath(R.result, /obj/structure) || ispath(R.result, /obj/machinery))
		for(var/obj/structure/fluff/traveltile/TT in range(7, user))
			if(TT.craftblock)
				to_chat(user, span_warning("我没法在这里制作。"))
				return
		for(var/obj/structure/S in T)
			if(R.buildsame && istype(S, R.result))
				if(user.dir == S.dir)
					to_chat(user, span_warning("有东西挡住了。"))
					return
				continue
			if(R.structurecraft && istype(S, R.structurecraft))
				continue
			if(S.density && !R.ignoredensity)
				to_chat(user, span_warning("有东西挡住了。"))
				return
		for(var/obj/machinery/M in T)
			if(M.density)
				to_chat(user, span_warning("有东西挡住了。"))
				return
	if(R.req_table)
		if(!(locate(/obj/structure/table) in T))
			to_chat(user, span_warning("我得在桌上制作这个。"))
			return
	if(R.structurecraft)
		if(!(locate(R.structurecraft) in T))
			var/str
			if(ispath(R.structurecraft, /obj/))
				var/obj/O = R.structurecraft
				str = initial(O.name)
			to_chat(user, span_warning("我缺少所需的设施：<b>[str]</b>"))
			return
	if(check_contents(R, contents))
		if(check_tools(user, R, contents))
			if(R.craftsound)
				playsound(T, R.craftsound, 100, TRUE)
			var/time2use = 10
			for(var/i = 1 to 100)
				if(do_after(user, time2use * z121_ethos_craft_multiplier(user), target = user))
					contents = get_surroundings(user)
					if(!check_contents(R, contents))
						return FALSE
					if(!check_tools(user, R, contents))
						return FALSE
					var/prob2craft = 25
					if(R.craftdiff)
						prob2craft -= (25*R.craftdiff)
					if(R.skillcraft)
						if(user.mind)
							prob2craft += (user.get_skill_level(R.skillcraft) * 25)
					else
						prob2craft = 100
					if(isliving(user))
						var/mob/living/L = user
						if(L.STAINT > 10)
							prob2craft += ((10-L.STAINT)*-1)*2
					prob2craft = CLAMP(prob2craft, 0, 99)
					if(!prob(prob2craft))
						if(user.client?.prefs.showrolls)
							to_chat(user, span_danger("我没能做出[result_name]…… [prob2craft]%"))
							continue
						to_chat(user, span_danger("我没能做出[result_name]。"))
						continue
					var/list/quality_capture = R.skip_quality ? list() : null
					var/list/parts = del_reqs(R, user, quality_capture)
					var/inherited_quality = quality_capture?["min_quality"]
					if(islist(R.result))
						var/list/L = R.result
						for(var/IT in L)
							var/atom/movable/I = new IT(T)

							if(R.skillcraft == /datum/skill/craft/ceramics && ismob(user))
								apply_pottery_quality_to_item(I, user.get_skill_level(R.skillcraft))
							I.CheckParts(parts, R)
							I.OnCrafted(user.dir, user)
							if(isitem(I))
								var/obj/item/CI = I
								CI.was_crafted = TRUE
								if(CI.has_item_quality)
									if(R.skip_quality)
										if(!isnull(inherited_quality))
											CI.apply_quality(null, null, inherited_quality)
									else
										CI.apply_quality(user, R.skillcraft)
							I.add_fingerprint(user)
					else
						if(ispath(R.result, /turf))
							var/turf/X = T.PlaceOnTop(R.result)
							if(X)
								X.OnCrafted(user.dir, user)
								X.add_fingerprint(user)
								if(R.loud)
									X.loud_message("能听见施工的动静。")
						else
							var/atom/movable/I = new R.result (T)

							if(R.skillcraft == /datum/skill/craft/ceramics && ismob(user))
								apply_pottery_quality_to_item(I, user.get_skill_level(R.skillcraft))
							I.CheckParts(parts, R)
							if(R.diagonal)
								I.OnCrafted(I.SelectDiagDirection(), user)
							else
								I.OnCrafted(user.dir, user)
							if(isitem(I))
								var/obj/item/CI = I
								CI.was_crafted = TRUE
								if(CI.has_item_quality)
									if(R.skip_quality)
										if(!isnull(inherited_quality))
											CI.apply_quality(null, null, inherited_quality)
									else
										CI.apply_quality(user, R.skillcraft)
							I.add_fingerprint(user)
					user.visible_message(span_notice("[user] [R.verbage]了[result_name]!"), \
										span_notice("我[R.verbage_simple]了[result_name]!"))
					user.log_message("crafted [result_name] ([R.type])", LOG_GAME)
					if(user.mind && R.skillcraft)
						if(isliving(user))
							var/mob/living/L = user
							var/amt2raise
							if(R.craft_xp_override >= 0)
								amt2raise = R.craft_xp_override
							else
								amt2raise = L.STAINT * 2
								if(R.craftdiff > 0)
									amt2raise += (R.craftdiff * 10)
							if(amt2raise > 0)
								user.mind.add_sleep_experience(R.skillcraft, amt2raise, FALSE)
					return TRUE
				return FALSE
			return FALSE
		var/str
		var/toollen = R.tools.len
		if(toollen)
			if(toollen > 1)
				for(var/i = 1, i<=toollen, i++)
					if(ispath(R.tools[i], /obj/))
						var/obj/O = R.tools[i]
						str += "[initial(O.name)][(i != toollen) ? ", " : ""]"
			else
				for(var/obj/O as anything in R.tools)
					str += "[initial(O.name)]"
		to_chat(usr, span_warning("我缺少工具。我需要：<b>[str]</b>"))
		return FALSE
	return FALSE

/obj/machinery/anvil/forging_loop(mob/living/user, obj/item/rogueweapon/hammer/hammer, datum/component/forging/forging_comp)
	while(current_workpiece && forging_comp?.forging_stage == FORGING_STAGE_ACTIVE)

		if(!hott && istype(current_workpiece, /obj/item/ingot))
			to_chat(user, span_warning("它太冷了。"))
			return

		var/used_str = user.STASTR
		if(iscarbon(user))
			var/mob/living/carbon/carbon_user = user
			if(carbon_user.domhand)
				used_str = carbon_user.get_str_arms(carbon_user.used_hand)
			if(HAS_TRAIT(carbon_user, TRAIT_FORGEBLESSED))
				carbon_user.stamina_add(max(21 - (used_str * 3), 0)*advance_multiplier)
			else
				carbon_user.stamina_add(max(40 - (used_str * 3), 0)*advance_multiplier)

		var/total_chance = 7 * user.get_skill_level(forging_comp.current_recipe.appro_skill) * user.STAPER/10 * hammer.quality
		var/breakthrough = 0
		if(prob((1 + total_chance)*advance_multiplier))
			user.fullscreen_redflash("whiteflash")
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_turf(src)
			S.set_up(1, 1, front)
			S.start()
			breakthrough = 1
			forging_comp.numberofbreakthroughs++

		SEND_SIGNAL(current_workpiece, COMSIG_ITEM_HAMMERED_ON_ANVIL, src, user, hammer, breakthrough)

		playsound(src,pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)
		if(do_after(user, 20 * z121_ethos_craft_multiplier(user), target = src))
			advance_multiplier = 0.50
		else
			break
	return

/obj/machinery/loom/attack_hand(mob/user)
	var/mob/living/weaver = user
	var/weavetime = 2 SECONDS
	var/skilltimemod = 0.2 SECONDS
	var/skill = weaver.get_skill_level(/datum/skill/craft/sewing)
	var/required_fibers = 2
	var/efficiently_text = ""
	if(isliving(user) && weaver.stat == CONSCIOUS)
		if(HAS_TRAIT(user, TRAIT_EFFICIENT_WEAVER))
			required_fibers = 1
			efficiently_text = "手法娴熟的"
		if(src.storedfiber < required_fibers)
			to_chat(user, "你的纤维不够，做不了这件事。")
		else
			to_chat(user, "你开始[efficiently_text]织布……")
			while(src.storedfiber >= required_fibers)
				if(!do_after(weaver, (weavetime - (skilltimemod*skill)) * z121_ethos_craft_multiplier(weaver), target = src) || src.storedfiber < required_fibers)
					break
				src.storedfiber -= required_fibers
				new /obj/item/natural/cloth(get_turf(src))
				weaver.mind.add_sleep_experience(/datum/skill/craft/sewing, (weaver.STAINT*0.5))

/obj/machinery/tanningrack/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/natural/hide) && !istype(I, /obj/item/natural/hide/cured))
		if(!hide)
			I.forceMove(src)
			hide = I
			update_icon()
			return
		else
			to_chat(user, span_warning("架子上已经有东西了！"))
			return
	if((user.used_intent.type == /datum/intent/dagger/cut || user.used_intent.type == /datum/intent/sword/cut || user.used_intent.type == /datum/intent/axe/cut) && hide)
		if(anchored)
			var/skill_level = max(user.get_skill_level(/datum/skill/craft/tanning))
			var/work_time = (120 - (skill_level * 15))
			var/pieces_to_spawn = rand(1, min(skill_level + 1, 6))
			var/sound_played = FALSE
			var/obj/item/natural/hide/working_hide = hide
			to_chat(user, span_warning("我开始刮削兽皮..."))
			if(!do_after(user, work_time * z121_ethos_craft_multiplier(user), target = src))
				return
			// 另一位操作者可能已经完成鞣制或换上了新的兽皮。
			if(QDELETED(working_hide) || hide != working_hide || !anchored || !user.Adjacent(src))
				return
			playsound(src,pick('sound/items/book_open.ogg','sound/items/book_page.ogg'), 100, FALSE)
			QDEL_NULL(hide)
			user.mind.add_sleep_experience(/datum/skill/craft/tanning, user.STAINT * 2)
			update_icon()
			var/essence_factor = 1

			switch(skill_level)
				if(SKILL_LEVEL_NOVICE)
					essence_factor = 1
				if(SKILL_LEVEL_APPRENTICE)
					essence_factor = 2
				if(SKILL_LEVEL_JOURNEYMAN)
					essence_factor = 3
				if(SKILL_LEVEL_EXPERT)
					essence_factor = 6
				if(SKILL_LEVEL_MASTER)
					essence_factor = 8
				if(SKILL_LEVEL_LEGENDARY)
					essence_factor = 10
			for(var/i = 0; i < pieces_to_spawn; i++)
				if(prob(essence_factor + user.goodluck(2)))
					new /obj/item/natural/cured/essence(get_turf(user))
					if(!sound_played)
						sound_played = TRUE
						to_chat(user, span_warning("登多尔 降下恩惠……"))
						playsound(src,pick('sound/items/gem.ogg'), 100, FALSE)
				new /obj/item/natural/hide/cured(get_turf(user))
			return
		else
			to_chat(user, span_warning("我得先用木桩把它固定住，才能处理这张兽皮。"))
			return
	if(istype(I, /obj/item/grown/log/tree/stake))
		if(anchored)
			anchored = FALSE
			to_chat(user, span_warning("[src]现在可以移动了。"))
		else
			anchored = TRUE
			to_chat(user, span_warning("你固定好了[src]。"))
		playsound(src,pick('sound/foley/woodclimb.ogg'), 100, TRUE)
		return
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/machinery, attackby))(I, user, params)

/obj/structure/fluff/grindwheel/attackby(obj/item/I, mob/living/user, params)
	if(I.max_blade_int)
		playsound(loc,'sound/foley/grindblade.ogg', 100, FALSE)
		if(do_after(user, 41 * z121_ethos_craft_multiplier(user), target = src))
			I.restore_bintegrity()
		return
	if(istype(I, /obj/item/grown/log/tree/small))
		var/skill_level = user.get_skill_level(/datum/skill/craft/carpentry)
		var/wood_time = (40 - (skill_level * 5))
		playsound(src, pick('sound/misc/slide_wood (2).ogg', 'sound/misc/slide_wood (1).ogg'), 100, FALSE)
		if(do_after(user, wood_time * z121_ethos_craft_multiplier(user), target = src))
			var/failed = prob(max(40 - (skill_level * 10), 0)) || !skill_level
			if(failed)
				to_chat(user, span_info("该死！我把这块木头弄坏了……"))
				playsound(src,'sound/combat/hits/onwood/destroyfurniture.ogg', 100, FALSE)
			else
				new /obj/item/natural/wood/plank(get_turf(src))
			if(failed)
				z121_ethos_failed_learning(user, /datum/skill/craft/carpentry, user.STAINT * 0.5)
			else
				user.mind.add_sleep_experience(/datum/skill/craft/carpentry, user.STAINT * 0.5)
			qdel(I)
			return
	return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/structure, attackby))(I, user, params)

// 黏土所有揉制步骤共享此纯耗时入口，包括重新润湿后的徒手揉制。
/obj/item/natural/clay/get_knead_time(mob/living/user, base_time)
	return ..() * z121_ethos_craft_multiplier(user)
