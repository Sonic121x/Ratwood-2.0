// 成功劳动沿用核心经验，明确失败分支不领取勤勉奖励。核心同步由指纹清单校验。

/datum/component/forging/advance_recipe(mob/living/user, breakthrough = FALSE)
	var/moveup = 1
	var/proab = 0
	var/skill_level = user.get_skill_level(current_recipe.appro_skill)
	if(skill_level > current_recipe.smith_skill_level)
		current_recipe.smith_skill_level = skill_level

	if(progress >= current_recipe.max_progress && !needed_item)
		to_chat(user, span_info("已经锻造好了。"))
		user.visible_message(span_warning("[user]敲打着金属锭！"))
		return TRUE
	if(needed_item)
		to_chat(user, span_info("现在该添加[needed_item_text]了。"))
		user.visible_message(span_warning("[user]敲打着金属锭！"))
		return FALSE
	if(current_recipe.using_blade)

		proab += 10
		if(breakthrough)
			moveup *= 1.2


	if(!skill_level && !current_recipe.craftdiff)
		proab = 35
	else if(skill_level < current_recipe.craftdiff)
		proab = 10
	else
		proab = min(45 * skill_level, 100)


	if(prob(proab))
		moveup += round((skill_level * 6 * user.STASTR/10) * (breakthrough ? 1.5 : 1))
		moveup -= current_recipe.craftdiff
		progress = min(progress + moveup, current_recipe.max_progress)
		numberofhits += 1
	else
		moveup = 0
		numberofhits += 1


	if(progress >= current_recipe.max_progress && current_recipe.additional_items.len)
		needed_item = pick(current_recipe.additional_items)
		var/obj/item/I = needed_item
		needed_item_text = initial(I.name)
		current_recipe.additional_items -= needed_item
		progress = 0

	if(!moveup)
		z121_ethos_failed_learning(user, current_recipe.appro_skill, user.STAINT/(current_recipe.craftdiff+3))
		if(!prob(proab))
			user.visible_message(span_warning("[user]敲坏了金属锭！"))
			skill_quality -= 1
			bar_health -= current_recipe.craftdiff

			switch(skill_level)
				if(0)
					bar_health -= 25
				if(1 to 3)
					bar_health -= floor(20 / skill_level)
				if(4)
					bar_health -= 5
				if(5 to 6)
					if(user.badluck(4))
						bar_health -= current_recipe.craftdiff

			if(bar_health <= 0)
				user.visible_message(span_danger("[user]毁掉了金属锭！"))
				qdel(parent)
			return FALSE
		else
			user.visible_message(span_warning("[user]敲打金属锭时失手了！"))
			return FALSE

	else
		if(user.mind)
			skill_quality += (rand(skill_level*12, skill_level*14) * moveup)
			user.mind.add_sleep_experience(current_recipe.appro_skill, user.STAINT/(current_recipe.craftdiff+1), FALSE)

		if(breakthrough)
			user.visible_message(span_deadsay("[user]娴熟地敲打着金属锭！"))
			if(bar_health < 100)
				bar_health += 20
		else
			user.visible_message(span_info("[user]敲打着金属锭！"))

		if(progress >= current_recipe.max_progress && !current_recipe.additional_items.len)
			return TRUE
		return TRUE

/obj/item/fishingrod/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/ft = 120
	var/fpp =  100 - (40 + (sl * 10))
	var/frwt = list(/turf/open/water/river, /turf/open/water/cleanshallow, /turf/open/water/pond)
	var/salwt_coast = list(/turf/open/water/ocean)
	var/salwt_deep = list(/turf/open/water/ocean/deep)
	var/mud = list(/turf/open/water/swamp, /turf/open/water/swamp/deep)
	var/list/modlist
	if(user.used_intent.type == SPEAR_BASH)
		return call(src, /obj/item/proc/afterattack)(target, user, proximity)

	if(!check_allowed_items(target,target_self=1))
		return call(src, /obj/item/proc/afterattack)(target, user, proximity)

	if(istype(target, /turf/open/water))
		if(user.used_intent.type == ROD_CAST && !user.doing)
			if(target in range(user,5))
				user.visible_message("<span class='warning'>[user]抛出了鱼线！</span>", \
									"<span class='notice'>我抛出了鱼线。</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20)
				ft = max(20,ft)
				if(do_after(user,ft, target = target))
					if(baited)
						var/bp = baited.baitpenalty
						var/fishchance = 100
						if(has_world_trait(/datum/world_trait/fishing_decrease))
							fishchance -= 25
						if(has_world_trait(/datum/world_trait/fishing_increase))
							fishchance += 40
						if(user.mind)
							if(!sl)
								fishchance -= 50
							else
								fishchance -= bp
								fishchance -= fpp
						var/mob/living/carbon/human/fisherman = user
						modlist = baited.fishingMods.Copy()
						if(ishuman(fisherman))
							if(fisherman.patron.type == /datum/patron/divine/abyssor)
								modlist["dangerFishingMod"] *= 1.10
								modlist["treasureFishingMod"] *= 0.90
								modlist["rareFishingMod"] *= 1.25
							if(fisherman.STALUC > 10)
								var/trait_bonus = 0
								if(HAS_TRAIT(fisherman, TRAIT_CAUTIOUS_FISHER))
									trait_bonus = 0.20
								var/tier1_bonus = min(fisherman.STALUC - 10, 5)
								var/tier2_bonus = max(fisherman.STALUC - 15, 0)
								var/total_bonus = (tier1_bonus * 0.05) + (tier2_bonus * 0.01) + (trait_bonus)
								modlist["rareFishingMod"] *= (1 + total_bonus)
								modlist["treasureFishingMod"] *= (1 + total_bonus)
								modlist["dangerFishingMod"] *= (1 - (trait_bonus * 3))
						if(prob(fishchance))
							var/A
							if(target.type in frwt)
								A = pickweightAllowZero(createFreshWaterFishWeightListModlist(modlist))
							else if(target.type in salwt_coast)
								A = pickweightAllowZero(createCoastalSeaFishWeightListModlist(modlist))
							else if(target.type in salwt_deep)
								A = pickweightAllowZero(createDeepSeaFishWeightListModlist(modlist))
							else if(target.type in mud)
								A = pickweightAllowZero(createMudFishWeightListModlist(modlist))
							if(A)
								var/ow = 30 + (sl * 10)
								to_chat(user, "<span class='notice'>有什么东西扯动了鱼线！</span>")
								target.balloon_alert_to_viewers("有鱼咬钩！")
								playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
								if(!do_after(user,ow, target = target, same_direction = TRUE))
									if(A in subtypesof(/mob/living))
										var/mob/M = A
										new M(target)
										if (!(M.type == /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab))
											user.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
										user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2)
									else
										new A(user.loc)
										to_chat(user, "<span class='warning'>快收线！</span>")
										teleport_to_dream(user, 10000, 1)
										user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE)
										record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
										record_round_statistic(STATS_FISH_CAUGHT)
										playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
									if(prob(80 - (sl * 10)))
										to_chat(user, "<span class='warning'>该死，它把我的鱼饵吃了。</span>")
										qdel(baited)
										baited = null
								else
									to_chat(user, "<span class='warning'>该死，让它跑了……下次我得记得<b>拉开</b>。</span>")
									if(prob(100 - (sl * 10)))
										to_chat(user, "<span class='warning'>……还把我的鱼饵也带走了。</span>")
										qdel(baited)
										baited = null
						else
							to_chat(user, "<span class='warning'>连个咬钩的都没有……</span>")
							z121_ethos_failed_learning(user, /datum/skill/labor/fishing, fisherman.STAINT/2)
					else
						to_chat(user, "<span class='warning'>没有鱼饵，这样钓毫无意义。</span>")
				else
					to_chat(user, "<span class='warning'>我必须站着不动才能钓鱼。</span>")
			update_icon()

/obj/item/rogueweapon/spear/trident/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/ft = 150
	var/fpp =  130 - (40 + (sl * 15))
	var/frwt = list(/turf/open/water/river, /turf/open/water/cleanshallow, /turf/open/water/pond)
	var/salwt_coast = list(/turf/open/water/ocean)
	var/salwt_deep = list(/turf/open/water/ocean/deep)
	var/mud = list(/turf/open/water/swamp, /turf/open/water/swamp/deep)
	if(istype(target, /turf/open/water))
		if(user.used_intent.type == SPEAR_CAST && !user.doing)
			if(target in range(user,3))
				user.visible_message("<span class='warning'>[user]开始寻找鱼了！</span>", \
									"<span class='notice'>我开始寻找能用叉刺中的鱼。</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20)
				ft = max(20,ft)
				if(do_after(user,ft, target = target))
					var/fishchance = 100
					if(user.mind)
						if(!sl)
							fishchance -= 50
						else
							fishchance -= fpp
					var/mob/living/fisherman = user
					if(prob(fishchance))
						var/A
						if(target.type in frwt)
							A = pickweightAllowZero(createFreshWaterFishWeightListModlist(fishingMods))
						else if(target.type in salwt_coast)
							A = pickweightAllowZero(createCoastalSeaFishWeightListModlist(fishingMods))
						else if(target.type in salwt_deep)
							A = pickweightAllowZero(createDeepSeaFishWeightListModlist(fishingMods))
						else if(target.type in mud)
							A = pickweightAllowZero(createMudFishWeightListModlist(fishingMods))
						if(A)
							var/ow = 30 + (sl * 10)
							to_chat(user, "<span class='notice'>你看见有什么东西了！</span>")
							playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
							if(!do_after(user,ow, target = target))
								if(ismob(A))
									var/mob/M = A
									if(M.type in subtypesof(/mob/living/simple_animal/hostile))
										new M(target)
									else
										new M(user.loc)
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2)
								else
									new A(user.loc)
									teleport_to_dream(user, 10000, 1)
									to_chat(user, "<span class='warning'>快把它拉上来！</span>")
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE)
									record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
									GLOB.azure_round_stats[STATS_FISH_CAUGHT]++
									playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
							else
								to_chat(user, "<span class='warning'>该死，让它跑了……下次我得记得<b>猛地一拉</b>。</span>")
					else
						to_chat(user, "<span class='warning'>连一条鱼都没有……</span>")
						z121_ethos_failed_learning(user, /datum/skill/labor/fishing, fisherman.STAINT/2)
				else
					to_chat(user, "<span class='warning'>想叉鱼就得站着别动。</span>")
			update_icon()

/obj/item/rogueweapon/fishspear/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/ft = 160
	var/fpp =  130 - (40 + (sl * 15))
	var/frwt = list(/turf/open/water/river, /turf/open/water/cleanshallow, /turf/open/water/pond)
	var/salwt_coast = list(/turf/open/water/ocean)
	var/salwt_deep = list(/turf/open/water/ocean/deep)
	var/mud = list(/turf/open/water/swamp, /turf/open/water/swamp/deep)
	if(istype(target, /turf/open/water))
		if(user.used_intent.type == SPEAR_CAST && !user.doing)
			if(target in range(user,3))
				user.visible_message("<span class='warning'>[user]开始寻找鱼了！</span>", \
									"<span class='notice'>我开始寻找能用叉刺中的鱼。</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20)
				ft = max(20,ft)
				if(do_after(user,ft, target = target))
					var/fishchance = 100
					if(user.mind)
						if(!sl)
							fishchance -= 50
						else
							fishchance -= fpp
					var/mob/living/fisherman = user
					if(prob(fishchance))
						var/A
						if(target.type in frwt)
							A = pickweightAllowZero(createFreshWaterFishWeightListModlist(fishingMods))
						else if(target.type in salwt_coast)
							A = pickweightAllowZero(createCoastalSeaFishWeightListModlist(fishingMods))
						else if(target.type in salwt_deep)
							A = pickweightAllowZero(createDeepSeaFishWeightListModlist(fishingMods))
						else if(target.type in mud)
							A = pickweightAllowZero(createMudFishWeightListModlist(fishingMods))
						if(A)
							var/ow = 30 + (sl * 10)
							to_chat(user, "<span class='notice'>你看见有什么东西了！</span>")
							playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
							if(!do_after(user,ow, target = target))
								if(A in subtypesof(/mob/living))
									var/mob/M = A
									new M(target)
									if (!(M.type == /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab))
										user.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2)
								else
									new A(user.loc)
									teleport_to_dream(user, 10000, 1)
									to_chat(user, "<span class='warning'>快把它拉上来！</span>")
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE)
									record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
									record_round_statistic(STATS_FISH_CAUGHT)
									playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
							else
								to_chat(user, "<span class='warning'>该死，让它跑了……下次我得记得<b>猛地一拉</b>。</span>")
					else
						to_chat(user, "<span class='warning'>连一条鱼都没有……</span>")
						z121_ethos_failed_learning(user, /datum/skill/labor/fishing, fisherman.STAINT/2)
				else
					to_chat(user, "<span class='warning'>想叉鱼就得站着别动。</span>")
			update_icon()

/obj/item/rogueweapon/huntingknife/attack_obj(obj/O, mob/living/user)
	if(user.used_intent.type == /datum/intent/snip && istype(O, /obj/item))
		var/obj/item/item = O
		if(item.sewrepair && item.salvage_result)
			var/salvage_time = 70
			salvage_time = (70 - ((user.get_skill_level(/datum/skill/craft/sewing)) * 10))
			if(!do_after(user, salvage_time, target = user))
				return

			if(item.fiber_salvage)
				new /obj/item/natural/fibers(get_turf(item))
			if(istype(item, /obj/item/storage))
				var/obj/item/storage/bag = item
				bag.emptyStorage()
			var/skill_level = user.get_skill_level(/datum/skill/craft/sewing)
			if(prob(50 - (skill_level * 10)))
				to_chat(user, span_info("我手艺不够，糟蹋了一些材料……"))
				playsound(item, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				qdel(item)
				z121_ethos_failed_learning(user, /datum/skill/craft/sewing, user.STAINT)
				return
			item.salvage_amount -= item.torn_sleeve_number
			for(var/i = 1; i <= item.salvage_amount; i++)
				var/obj/item/Sr = new item.salvage_result(get_turf(item))
				Sr.color = item.color
			user.visible_message(span_notice("[user]把[item]拆成了可用材料。"))
			playsound(item, 'sound/items/flint.ogg', 100, TRUE)
			qdel(item)
			user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT))
	return call(src, /obj/item/proc/attack_obj)(O, user)

/obj/structure/fluff/ceramicswheel/attack_right(mob/living/user)
	if(user.get_active_held_item())
		return call(src, /atom/proc/attack_right)(user)
	if(!loaded_clay)
		to_chat(user, span_warning("我得先把黏土放到陶轮上。"))
		return
	if(needs_rewet)
		to_chat(user, span_warning("黏土正在变干。我得先加点水，再继续转。"))
		return

	if(!selected_recipe)
		var/list/recipe_map = list()
		var/list/generated_recipes = list()
		var/list/radial_choices = list()
		for(var/path in subtypesof(/datum/pottery_wheel_recipe))
			if(is_abstract(path))
				continue
			var/datum/pottery_wheel_recipe/R = new path
			generated_recipes += R
			if(!R.valid_for_clay(loaded_clay))
				continue
			var/choice_label = "[R.name] ([SSskills.level_names_plain[R.craftdiff]])"
			recipe_map[choice_label] = R
			var/atom/result_preview = initial(R.result_type)
			var/preview_icon = R.recipe_icon || initial(result_preview.icon)
			var/preview_icon_state = R.recipe_icon_state || initial(result_preview.icon_state)
			radial_choices[choice_label] = image(icon = preview_icon, icon_state = preview_icon_state)

		if(!recipe_map.len)
			to_chat(user, span_warning("这团黏土没法塑造成什么有用的东西。"))
			for(var/datum/pottery_wheel_recipe/R_cleanup0 in generated_recipes)
				qdel(R_cleanup0)
			return

		var/choice = show_radial_menu(user, src, radial_choices, require_near = TRUE, tooltips = TRUE)
		if(!choice)
			for(var/datum/pottery_wheel_recipe/R_cleanup in generated_recipes)
				qdel(R_cleanup)
			return

		selected_recipe = recipe_map[choice]
		if(!selected_recipe)
			for(var/datum/pottery_wheel_recipe/R_cleanup2 in generated_recipes)
				qdel(R_cleanup2)
			return

		for(var/datum/pottery_wheel_recipe/R_cleanup_keep in generated_recipes)
			if(R_cleanup_keep != selected_recipe)
				qdel(R_cleanup_keep)

	if(!selected_recipe.valid_for_clay(loaded_clay))
		to_chat(user, span_warning("这团黏土已经不适合当前选择的造型了。"))
		reset_shaping_progress()
		return

	var/skill_level = user.get_skill_level(/datum/skill/craft/ceramics)
	if(skill_level < selected_recipe.craftdiff)
		to_chat(user, span_warning("这需要我具备 [SSskills.level_names_plain[selected_recipe.craftdiff]] 级陶艺技能。"))
		reset_shaping_progress()
		return


	var/total_spins = selected_recipe.spins_required

	var/base_per_spin = max(1, round(selected_recipe.base_time / total_spins))
	var/time_to_spin = max(6, base_per_spin + (SKILL_LEVEL_JOURNEYMAN - skill_level) * 4)
	to_chat(user, span_notice("我转动陶轮，塑造[loaded_clay]（[spin_progress + 1]/[total_spins]）……"))
	playsound(src, 'sound/foley/grindblade.ogg', 80, FALSE)
	if(!do_after(user, time_to_spin * z121_ethos_craft_multiplier(user), target = src))
		return
	if(!loaded_clay || !selected_recipe || !selected_recipe.valid_for_clay(loaded_clay))
		to_chat(user, span_warning("这团黏土已经不再适合继续加工了。"))
		reset_shaping_progress()
		return


	if(skill_level <= SKILL_LEVEL_EXPERT)
		var/ruin_chance = 0
		switch(skill_level)
			if(SKILL_LEVEL_NONE)
				ruin_chance = 50
			if(SKILL_LEVEL_NOVICE)
				ruin_chance = 30
			if(SKILL_LEVEL_APPRENTICE)
				ruin_chance = 20
			if(SKILL_LEVEL_JOURNEYMAN)
				ruin_chance = 10
			if(SKILL_LEVEL_EXPERT)
				ruin_chance = 5
		if(prob(ruin_chance))
			user.visible_message(span_warning("[user]失去了对轮上黏土的控制，它塌掉了！"), span_warning("我失去了对旋转中黏土的控制，它塌坏了！"))
			playsound(src, 'modular/Neu_Food/sound/kneading.ogg', 80, TRUE)
			qdel(loaded_clay)
			loaded_clay = null
			reset_shaping_progress()
			update_icon()
			if(user.mind)
				z121_ethos_failed_learning(user, /datum/skill/craft/ceramics, 2)
			return

	spin_progress++
	var/required_rewets = get_required_rewet_count()
	if(spin_progress <= required_rewets)
		needs_rewet = TRUE
		to_chat(user, span_notice("这团黏土还需要更多水，我才能继续（[spin_progress]/[selected_recipe.spins_required]）。"))
		return

	var/turf/drop_turf = get_turf(src)
	for(var/spawn_i in 1 to selected_recipe.result_count)
		var/obj/item/I = new selected_recipe.result_type(drop_turf)
		if(istype(I, /obj/item/natural/clay))
			var/obj/item/natural/clay/clay_item = I
			clay_item.creator_skill = skill_level
			clay_item.pottery_quality = calculate_pottery_quality(skill_level)
	user.visible_message(span_notice("[user]把[loaded_clay]塑形成了[selected_recipe.name]。"), span_notice("我把[loaded_clay]塑形成了[selected_recipe.name]。"))
	var/final_craftdiff = selected_recipe.craftdiff
	qdel(loaded_clay)
	loaded_clay = null
	reset_shaping_progress()
	update_icon()

	if(user.mind)
		var/exp_gain = max(2, user.STAINT)
		if(final_craftdiff > 0)
			exp_gain += final_craftdiff * 4
		user.mind.add_sleep_experience(/datum/skill/craft/ceramics, exp_gain, FALSE)

/obj/item/rogueweapon/blowrod/attack_right(mob/living/user)
	if(!user)
		return call(src, /atom/proc/attack_right)(user)

	var/obj/item/natural/glass/heated/G = loaded_glass
	if(!G)
		to_chat(user, span_warning("我得先把热玻璃装到吹制杆上。"))
		return

	if(!G.selected_recipe)
		var/list/recipe_map = list()
		var/list/generated_recipes = list()
		var/list/radial_choices = list()

		for(var/path in subtypesof(/datum/glass_blow_recipe))
			if(is_abstract(path))
				continue
			var/datum/glass_blow_recipe/R = new path
			generated_recipes += R
			var/choice_label = "[R.name] ([SSskills.level_names_plain[R.craftdiff]])"
			recipe_map[choice_label] = R
			radial_choices[choice_label] = image(icon = R.recipe_icon, icon_state = R.recipe_icon_state)

		if(!recipe_map.len)
			for(var/datum/glass_blow_recipe/R_cleanup0 in generated_recipes)
				qdel(R_cleanup0)
			to_chat(user, span_warning("我没法把它塑形成什么有用的东西。"))
			return

		var/choice = show_radial_menu(user, src, radial_choices, require_near = TRUE, tooltips = TRUE)
		if(!choice)
			for(var/datum/glass_blow_recipe/R_cleanup1 in generated_recipes)
				qdel(R_cleanup1)
			return

		G.selected_recipe = recipe_map[choice]
		if(!G.selected_recipe)
			for(var/datum/glass_blow_recipe/R_cleanup2 in generated_recipes)
				qdel(R_cleanup2)
			return

		for(var/datum/glass_blow_recipe/R_cleanup_keep in generated_recipes)
			if(R_cleanup_keep != G.selected_recipe)
				qdel(R_cleanup_keep)

	var/skill_level = user.get_skill_level(/datum/skill/craft/ceramics)
	if(skill_level < G.selected_recipe.craftdiff)
		to_chat(user, span_warning("这件玻璃活需要我具备 [SSskills.level_names_plain[G.selected_recipe.craftdiff]] 级陶艺技能。"))
		QDEL_NULL(G.selected_recipe)
		G.blow_progress = 0
		return


	var/base_per_blow = max(1, round(G.selected_recipe.base_time / G.blows_required))
	var/time_to_blow = max(12, 2 * (base_per_blow + (SKILL_LEVEL_JOURNEYMAN - skill_level) * 4))
	to_chat(user, span_notice("我吹制并塑形热玻璃（[G.blow_progress + 1]/[G.blows_required]）……"))
	playsound(src, "bubbles", 65, FALSE)
	if(!do_after(user, time_to_blow * z121_ethos_craft_multiplier(user), target = src))
		return

	if(loaded_glass != G)
		to_chat(user, span_warning("我失去了对这件玻璃制品的控制。"))
		return


	if(skill_level <= SKILL_LEVEL_EXPERT)
		var/failure_chance = 0
		switch(skill_level)
			if(SKILL_LEVEL_NONE)
				failure_chance = 90
			if(SKILL_LEVEL_NOVICE)
				failure_chance = 50
			if(SKILL_LEVEL_APPRENTICE)
				failure_chance = 40
			if(SKILL_LEVEL_JOURNEYMAN)
				failure_chance = 30
			if(SKILL_LEVEL_EXPERT)
				failure_chance = 20
		if(prob(failure_chance))
			user.visible_message(span_warning("[user]失去了对玻璃的控制，它裂开并粉碎了！"), span_warning("我失去了对熔融玻璃的控制，它裂开并粉碎了！"))
			playsound(src, 'sound/foley/glassbreak.ogg', 75, TRUE)
			loaded_glass = null
			update_icon()
			qdel(G)
			if(user.mind)
				z121_ethos_failed_learning(user, /datum/skill/craft/ceramics, 2)
			return

	G.blow_progress++
	if(G.blow_progress < G.blows_required)
		to_chat(user, span_notice("玻璃的形状正在逐渐成形。"))
		return

	var/final_craftdiff = G.selected_recipe.craftdiff
	var/final_recipe_name = G.selected_recipe.name
	var/turf/drop_turf = get_turf(user)
	var/glass_quality_tier = calculate_glass_quality(skill_level)
	for(var/i in 1 to G.selected_recipe.result_count)
		var/obj/item/result = new G.selected_recipe.result_type(drop_turf)
		apply_glass_quality(result, glass_quality_tier, skill_level)
	user.visible_message(span_notice("[user]完成了对熔融玻璃的塑形，做出了[final_recipe_name]。"), span_notice("我完成了玻璃塑形，做出了[final_recipe_name]。"))

	loaded_glass = null
	update_icon()
	QDEL_NULL(G.selected_recipe)
	qdel(G)

	if(user.mind)
		var/exp_gain = max(2, user.STAINT)
		if(final_craftdiff > 0)
			exp_gain += final_craftdiff * 4
		user.mind.add_sleep_experience(/datum/skill/craft/ceramics, exp_gain, FALSE)

/obj/machinery/light/rogue/cauldron/process()
	z121_ethos_light_process()
	update_icon()
	if(on)
		if(ingredients.len)
			if(brewing < 20)
				if(src.reagents.has_reagent(/datum/reagent/water,waterneed))
					brewing++
					if(prob(10))
						playsound(src, "bubbles", 100, FALSE)
			else if(brewing == 20)
				var/list/outcomes = list()
				for(var/obj/item/ing in src.ingredients)
					if(!istype(ing,/obj/item/alch))
						continue
					var/obj/item/alch/alching = ing
					if(alching.major_pot != null)
						if(outcomes[alching.major_pot] != null)
							outcomes[alching.major_pot] += 3
						else
							outcomes[alching.major_pot] = 3
					if(alching.med_pot != null)
						if(outcomes[alching.med_pot] != null)
							outcomes[alching.med_pot] += 2
						else
							outcomes[alching.med_pot] = 2
					if(alching.minor_pot != null)
						if(outcomes[alching.minor_pot] != null)
							outcomes[alching.minor_pot] += 1
						else
							outcomes[alching.minor_pot] = 1
				sortTim(outcomes,cmp=/proc/cmp_numeric_dsc,associative = 1)
				if(outcomes.len && (outcomes[outcomes[1]] >= 5))
					var/result_path = outcomes[1]
					var/datum/alch_cauldron_recipe/found_recipe = new result_path
					var/amt2raise = lastuser?.STAINT*2
					var/in_cauldron = src?.reagents?.get_reagent_amount(/datum/reagent/water)

					if(!lastuser)
						brewing = 0
						src.visible_message(span_info("没有炼金术士的指引，炼药锅什么都炼制不出来。"))
						return
					if(found_recipe.skill_required > lastuser?.get_skill_level(/datum/skill/craft/alchemy))
						brewing = 0
						src.visible_message(span_warning("锅中的材料混合成了一团恶心的烂泥！也许需要更高明的炼金术士才能处理这个配方。"))
						if(reagents)
							src.reagents.remove_reagent(/datum/reagent/water, in_cauldron)
						for(var/obj/item/ing in src.ingredients)
							qdel(ing)
						src.reagents.add_reagent(/datum/reagent/yuck, in_cauldron)

						z121_ethos_failed_learning(lastuser, /datum/skill/craft/alchemy, amt2raise, FALSE)
						return
					for(var/obj/item/ing in src.ingredients)
						qdel(ing)
					if(reagents)
						src.reagents.remove_reagent(/datum/reagent/water, in_cauldron)
					if(found_recipe.output_reagents.len)
						src.reagents.add_reagent_list(found_recipe.output_reagents)
					if(found_recipe.output_items.len)
						for(var/itempath in found_recipe.output_items)
							new itempath(get_turf(src))

					src.visible_message("<span class='info'>炼药锅沸腾完毕，散发出一股淡淡的[found_recipe.smells_like]气味。</span>")
					lastuser.log_message("brewed [found_recipe.type] in [src] (REAGENTS: [english_list(found_recipe.output_reagents, "none")]) (ITEMS: [english_list(found_recipe.output_items, "none")])", LOG_GAME)
					record_featured_stat(FEATURED_STATS_ALCHEMISTS, lastuser)
					record_round_statistic(STATS_POTIONS_BREWED)

					lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
					playsound(src, "bubbles", 100, TRUE)
					playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
					ingredients = list()
					brewing = 21
					qdel(found_recipe)
				else
					brewing = 0
					src.visible_message("<span class='info'>[src]中的材料完全无法融合...</span>")
					playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
