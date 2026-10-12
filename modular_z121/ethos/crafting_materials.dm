// 直接加工与炉灶制作采用当前操作者的耗时倍率；搬运、倒水及采掘保持原有耗时。
#define Z121_ETHOS_MIN_STEW_TEMPERATURE 374
#define Z121_ETHOS_STEW_WATER 29
#define Z121_ETHOS_STEW_WATER_AFTER 1

/obj/item/grown/log/tree/small/attackby(obj/item/I, mob/living/user, params)
	if(item_flags & IN_STORAGE)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/skill_level = user.get_skill_level(/datum/skill/craft/carpentry)
	var/planking_time = (45 - (skill_level * 5))
	var/woodtotal = 1
	switch (skill_level)
		if (0)
			woodtotal = 1
		if (1)
			woodtotal = 3
		if (2)
			woodtotal = pick(4,5)
		if (3)
			woodtotal = pick(6,7)
		if (4)
			woodtotal = pick(8,9)
		if (5)
			woodtotal = pick(10,11)
		if (6)
			woodtotal = pick(12)
		else
			woodtotal = 3
	if(HAS_TRAIT(user, TRAIT_MASTER_CARPENTER))
		woodtotal += pick(2,3)
	if(I.tool_behaviour == TOOL_SAW)
		playsound(get_turf(src.loc), 'sound/foley/sawing.ogg', 100)
		user.visible_message("<span class='notice'>[user]开始把[src]锯成木板。</span>")
		if(do_after(user, planking_time * z121_ethos_craft_multiplier(user)))
			if(user.is_holding(src))
				user.dropItemToGround(src)
			for(var/i=1, i<=woodtotal, ++i)
				new /obj/item/natural/wood/plank(get_turf(src.loc))
			var/lumber_skill = user.get_skill_level(/datum/skill/labor/lumberjacking)
			if(prob(lumber_skill + user.goodluck(2)))
				new /obj/item/grown/log/tree/small/essence(get_turf(src.loc))
				to_chat(user, span_warning("登多尔在哭泣……"))
				playsound(src, pick('sound/items/gem.ogg'), 100, FALSE)
			user.mind.add_sleep_experience(/datum/skill/craft/carpentry, (user.STAINT*0.5))
			new /obj/effect/decal/cleanable/debris/woody(get_turf(src))
			qdel(src)
			return
	call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item, attackby))(I, user, params)

/obj/item/grown/log/tree/stick/attackby(obj/item/I, mob/living/user, params)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(user.used_intent?.blade_class == BCLASS_CUT)
		playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 100)
		user.visible_message(span_notice("[user]开始削尖[src]。"))
		if(do_after(user, 4 SECONDS * z121_ethos_craft_multiplier(user)))
			user.visible_message(span_notice("[user]削尖了[src]。"))
			var/obj/item/grown/log/tree/stake/S = new /obj/item/grown/log/tree/stake(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(S)
			qdel(src)
		else
			user.visible_message(span_warning("[user]削尖了[src]。"))
		return
	if(istype(I, /obj/item/grown/log/tree/stick))
		var/obj/item/natural/B = I
		var/obj/item/natural/bundle/stick/N = new(src.loc)
		to_chat(user, "我把木棍捆在了一起。")
		qdel(B)
		qdel(src)
		user.put_in_hands(N)
	else if(istype(I, /obj/item/natural/bundle/stick))
		var/obj/item/natural/bundle/B = I
		if(istype(src, B.stacktype))
			if(B.amount < B.maxamount)
				B.amount++
				B.update_bundle()
				user.visible_message("[user]把[src]塞进[I]。", "我把[src]塞进[I]。")
				qdel(src)
			else
				to_chat(user, "我不能再往这捆里加木棍了，不然它就要散架了。")
			return

/obj/item/natural/stone/attackby(obj/item/W, mob/living/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	var/skill_level = user.get_skill_level(/datum/skill/craft/masonry)
	var/work_time = (35 - (skill_level * 5))
	if(istype(W, /obj/item/natural/stone))
		playsound(src.loc, pick('sound/items/stonestone.ogg'), 100)
		user.visible_message(span_info("[user]将两块石头互相敲击。"))
		if(prob(10))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_step(user,user.dir)
			S.set_up(1, 1, front)
			S.start()
	if( user.used_intent.type == /datum/intent/chisel )
		if(istype(W, /obj/item/rogueweapon/chisel/assembly))
			var/obj/item/rogueweapon/chisel/assembly/chisel_set = W
			if(chisel_set.wielded)
				var/turf/work_turf = get_turf(src)
				var/obj/item/natural/stone/current_stone = src
				while(current_stone)
					playsound(current_stone.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
					user.visible_message("<span class='info'>[user]将石头凿成石块。</span>")
					if(!do_after(user, work_time * z121_ethos_craft_multiplier(user), target = current_stone))
						return
					new /obj/item/natural/stoneblock(get_turf(current_stone.loc))
					if(HAS_TRAIT(user, TRAIT_MASTER_MASON))
						new /obj/item/natural/stoneblock(get_turf(current_stone.loc))
					new /obj/effect/decal/cleanable/debris/stony(get_turf(current_stone))
					playsound(current_stone.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
					qdel(current_stone)
					user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*0.2))
					if(QDELETED(chisel_set) || !chisel_set.wielded)
						return
					var/obj/item/natural/stone/next_stone = null
					for(var/obj/item/natural/stone/S in work_turf)
						next_stone = S
						break
					if(!next_stone)
						return
					current_stone = next_stone
				return
		playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
		user.visible_message("<span class='info'>[user]将石头凿成方块。</span>")
		if(do_after(user, work_time * z121_ethos_craft_multiplier(user)))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			if(HAS_TRAIT(user, TRAIT_MASTER_MASON))
				new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/effect/decal/cleanable/debris/stony(get_turf(src))
			playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
			qdel(src)
			user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*0.2))
		return
	else if(istype(W, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须用双手来凿方块。"))
	else if(user.used_intent.type == /datum/intent/wing/shred && !user.cmode || user.used_intent.type == /datum/intent/wing/cut && !user.cmode)
		playsound(src.loc, pick('sound/items/sharpen_long1.ogg','sound/items/sharpen_long2.ogg'), 100, TRUE)
		user.visible_message(span_notice("[user]打磨了[W]！"))
		W.add_bintegrity(12, user)
		if(prob(35))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_step(user,user.dir)
			S.set_up(1, 1, front)
			S.start()
	else
		call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/natural, attackby))(W, user, params)

/obj/item/natural/rock/attackby(obj/item/W, mob/living/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	var/skill_level = user.get_skill_level(/datum/skill/craft/masonry)
	var/work_time = (120 - (skill_level * 15))
	if(istype(W, /obj/item/natural/stone))
		user.visible_message(span_info("[user]用石头敲击巨石。"))
		playsound(src.loc, 'sound/items/stonestone.ogg', 100)
		if(prob(35))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_turf(src)
			S.set_up(1, 1, front)
			S.start()
		return
	if(istype(W, /obj/item/natural/rock))
		playsound(src.loc, pick('sound/items/stonestone.ogg'), 100)
		user.visible_message(span_info("[user]将两块巨石互相敲击。"))
		if(prob(10))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_turf(src)
			S.set_up(1, 1, front)
			S.start()
		return
	if(istype(W, /obj/item/rogueweapon/pick))
		if(!isliving(user))
			return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/natural, attackby))(W, user, params)
		var/mob/living/living_user = user
		if(!living_user.client || !living_user.client.prefs?.autopicking)
			return call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/natural, attackby))(W, user, params)
		user.doing = FALSE
		while(!QDELETED(src) && user.Adjacent(src))
			if((living_user.energy <= 0))
				break
			if(!do_after(user, CLICK_CD_MELEE, TRUE, src))
				break
			call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/natural, attackby))(W, user, params)
		return
	if( user.used_intent.type == /datum/intent/chisel )
		playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
		user.visible_message("<span class='info'>[user]将巨石凿成石块。</span>")
		if(do_after(user, work_time * z121_ethos_craft_multiplier(user)))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			if(HAS_TRAIT(user, TRAIT_MASTER_MASON))
				new /obj/item/natural/stoneblock(get_turf(src.loc))
				new /obj/item/natural/stoneblock(get_turf(src.loc))
				new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/effect/decal/cleanable/debris/stony(get_turf(src))
			playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
			user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*0.5))
			qdel(src)
		return
	else if(istype(W, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须用双手来凿方块。"))
	call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/natural, attackby))(W, user, params)

/obj/structure/roguerock/attackby(obj/item/W, mob/living/user, params)
	. = call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/structure, attackby))(W, user, params)
	var/stonetotal = 4
	if(HAS_TRAIT(user, TRAIT_MASTER_MASON))
		stonetotal += stonetotal
	if( user.used_intent.type == /datum/intent/chisel )
		playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
		user.visible_message("<span class='info'>[user]将岩石凿成了石块。</span>")
		if(do_after(user, 10 SECONDS * z121_ethos_craft_multiplier(user)))
			for(var/i=1, i<=stonetotal, ++i)
				new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/effect/decal/cleanable/debris/stony(get_turf(src))
			playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
			user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*1))
			qdel(src)
		return
	else if(istype(W, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须用双手来凿石块。"))

/obj/item/reagent_containers/glass/mortar/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I,/obj/item/pestle))
		if(!to_grind)
			to_chat(user, "<span class='warning'>没有什么可研磨的。</span>")
			return
		var/obj/item/working_material = to_grind
		if((to_grind.type == /obj/item/seeds/treesap) && reagents.get_reagent_amount(/datum/reagent/water/blessed) >= 10)
			if(!ishuman(user) || user.get_skill_level(/datum/skill/magic/druidic) < SKILL_LEVEL_NOVICE)
				to_chat(user, span_warning("我缺乏德鲁伊的知识，无法从这些种子中提取 登多尔 的祝福。"))
				return
			user.visible_message(span_info("[user]将[to_grind]研磨进圣水，提取出 登多尔 的祝福。"))
			playsound(loc, 'sound/foley/mortarpestle.ogg', 100, FALSE)
			if(do_after(user, 10 * z121_ethos_craft_multiplier(user), target = src))
				if(QDELETED(working_material) || to_grind != working_material || !reagents?.has_reagent(/datum/reagent/water/blessed, 10))
					return
				reagents.remove_reagent(/datum/reagent/water/blessed, 10)
				new /obj/item/alch/blessedseedpowder(get_turf(src))
				QDEL_NULL(to_grind)
				to_chat(user, span_notice("种子吸收了 登多尔 的祝福，形成了发光粉末。"))
				if(user.mind)
					user.mind.add_sleep_experience(/datum/skill/magic/druidic, 5)
			return
		var/datum/alch_grind_recipe/foundrecipe = find_recipe()
		if(foundrecipe == null)
			to_chat(user, "<span class='warning'>你觉得那不会有效！</span>")
			return
		user.visible_message("<span class='info'>[user]开始研磨[to_grind]。</span>")
		playsound(loc, 'sound/foley/mortarpestle.ogg', 100, FALSE)
		if(do_after(user, 10 * z121_ethos_craft_multiplier(user), target = src))
			// 固定本次研磨材料，避免另一人先完成后仍领取产物和经验。
			if(QDELETED(working_material) || to_grind != working_material)
				return
			user.log_message("ground [to_grind] into [english_list(foundrecipe.valid_outputs, "nothing")] with [src]", LOG_GAME)
			for(var/output in foundrecipe.valid_outputs)
				for(var/i in 1 to foundrecipe.valid_outputs[output])
					new output(get_turf(src))
			if(foundrecipe.bonus_chance_outputs.len > 0)
				for(var/bonus_output in foundrecipe.bonus_chance_outputs)
					var/base_chance = foundrecipe.bonus_chance_outputs[bonus_output]
					var/final_chance = foundrecipe.get_bonus_output_chance(bonus_output, user, base_chance)
					if(final_chance >= roll(1, 100))
						new bonus_output(get_turf(user))
			if(istype(to_grind,/obj/item/rogueore) || istype(to_grind,/obj/item/ingot))
				user.fullscreen_redflash("whiteflash")
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_turf(src)
				S.set_up(1, 1, front)
				S.start()
			QDEL_NULL(to_grind)
			if(user.mind)
				user.adjust_experience(/datum/skill/craft/alchemy, user.STAINT, FALSE)
			return
	if(istype(I ,/obj/item/reagent_containers/glass))
		if(user.used_intent.type == INTENT_POUR)
			testing("attackobj2")
			if(!I.reagents.total_volume)
				to_chat(user, span_warning("[I]是空的！"))
				return

			if(reagents.holder_full())
				to_chat(user, span_warning("[src]已满。"))
				return
			user.visible_message(span_notice("[user]把[I]倒入[src]。"), \
							span_notice("我把[I]倒入[src]。"))
			if(user.m_intent != MOVE_INTENT_SNEAK)
				if(poursounds)
					playsound(user.loc,pick(poursounds), 100, TRUE)
			for(var/i in 1 to 10)
				if(do_after(user, 8, target = src))
					if(!I.reagents.total_volume)
						break
					if(reagents.holder_full())
						break
					if(!I.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user))
						reagents.reaction(src, TOUCH, amount_per_transfer_from_this)
					onfill(I, user, silent = TRUE)
				else
					break
			return

		if(is_drainable() && (user.used_intent.type == /datum/intent/fill))
			testing("attackobj3")
			if(!reagents.total_volume)
				to_chat(user, span_warning("[src]是空的！"))
				return

			if(I.reagents.holder_full())
				to_chat(user, span_warning("[I]已满。"))
				return
			if(user.m_intent != MOVE_INTENT_SNEAK)
				if(fillsounds)
					playsound(user.loc,pick(fillsounds), 100, TRUE)
			user.visible_message(span_notice("[user]用[src]装满了[I]。"), \
								span_notice("我用[src]装满了[I]。"))
			for(var/i in 1 to 10)
				if(do_after(user, 8, target = src))
					if(I.reagents.holder_full())
						break
					if(!reagents.total_volume)
						break
					reagents.trans_to(I, amount_per_transfer_from_this, transfered_by = user)
				else
					break

			return
	if(to_grind)
		to_chat(user, "<span class='warning'>[src]已满！</span>")
		return
	var/recipe = find_recipe(I)
	if(recipe == null && I.grind_results == null && I.juice_results == null)
		to_chat(user, "<span class='warning'>[I]不能被研磨！！</span>")
		return
	if(!user.transferItemToLoc(I,src))
		to_chat(user, "<span class='warning'>[I]粘在我手上了！</span>")
		return
	if(!istype(I,/obj/item/pestle) && !to_grind && user.transferItemToLoc(I,src))
		to_chat(user, "<span class='info'>我把[I]加入到[src]中。</span>")
		to_grind = I
		return
	call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/item/reagent_containers/glass, attackby))(I, user, null)

/obj/machinery/light/rogue/hearth/attack_right(mob/user)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)
	while(do_after(user, 2 SECONDS / cooktime_divisor * z121_ethos_craft_multiplier(user), target = src))
		to_chat(user, span_info("我煽了煽 [src]的火焰。"))
		try_cook(cooktime_divisor)

/obj/machinery/light/rogue/hearth/attackby(obj/item/W, mob/living/user, params)
	lastuser = user
	var/datum/skill/craft/cooking/cs = lastuser?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)

	if(!attachment)
		if(istype(W, /obj/item/cooking/pan) || istype(W, /obj/item/reagent_containers/glass/bucket/pot ) || istype(W, /obj/item/reagent_containers/glass/crucible))
			playsound(get_turf(user), 'sound/foley/dropsound/shovel_drop.ogg', 40, TRUE, -1)
			attachment = W
			user.doUnEquip(W)
			W.forceMove(src)
			update_icon()
			return
	else
		if(istype(attachment, /obj/item/reagent_containers/glass/crucible))
			var/obj/item/reagent_containers/glass/crucible/crucible = attachment
			if(crucible.hot)
				to_chat(user, span_warning("坩埚太烫了，无法放入锭！等它冷却下来。"))
				return

			if(istype(W, /obj/item/ingot/iron) || istype(W, /obj/item/ingot/steel))
				if(crucible.get_total_ingots() >= crucible.max_ingots)
					to_chat(user, span_warning("坩埚已满。"))
					return

				user.visible_message(span_info("[user]将一块锭放入坩埚中。"))
				if(do_after(user, 10 * z121_ethos_craft_multiplier(user), target = src))
					var/ingot_type = W.type
					if(crucible.add_ingot(ingot_type, user) > 0)
						qdel(W)
				return
		if(istype(W, /obj/item/reagent_containers/glass/bowl))
			to_chat(user, "<span class='notice'>先把锅从炉灶上拿开。</span>")
			return
		if(istype(attachment, /obj/item/cooking/pan))
			if(W.type in subtypesof(/obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/S = W
				if(istype(W, /obj/item/reagent_containers/food/snacks/egg))
					if(W.icon_state != "rawegg")
						playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
						sleep(25)
						W.icon_state = "rawegg"
				if(!food)
					S.forceMove(src)
					food = S
					update_icon()
					playsound(src.loc, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 5)
					return
			if(W.type in subtypesof(/obj/item/seeds))
				var/obj/item/seeds/S = W
				if(!food)
					S.forceMove(src)
					food = S
					update_icon()
					playsound(src.loc, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 5)
					return

		else if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot))
			var/obj/item/reagent_containers/glass/bucket/pot = attachment
			if(istype(W, /obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/S = W
				if(S.fat_yield)
					if(pot.reagents.has_reagent(/datum/reagent/water))
						to_chat(user, span_warning("你不能在有水的锅里炼油！"))
						return
					if(do_after(user, 2 SECONDS / cooktime_divisor * z121_ethos_craft_multiplier(user), target = src))
						if(QDELETED(S) || QDELETED(pot) || attachment != pot || !pot.reagents || pot.reagents.has_reagent(/datum/reagent/water))
							return
						var/fat_amount = S.fat_yield
						user.visible_message(span_info("[user]在锅里融化[S]。"))
						qdel(S)
						pot.reagents.add_reagent(/datum/reagent/consumable/oil/tallow, fat_amount)
						return
				if(pot.reagents.has_reagent(/datum/reagent/consumable/oil/tallow) && S.deep_fried_type)
					if(!pot.reagents.has_reagent(/datum/reagent/consumable/oil/tallow, OIL_CONSUMED))
						to_chat(user, span_notice("油不够。"))
						return
					if(pot.reagents.has_reagent(/datum/reagent/water))
						to_chat(user, span_warning("你不能在有水的锅里油炸！"))
						return
					if(do_after(user, DEEP_FRY_TIME / cooktime_divisor * z121_ethos_craft_multiplier(user), target = src))
						// 其他操作者可能在读条期间换锅、加水或用完油。
						if(QDELETED(S) || QDELETED(pot) || attachment != pot || !pot.reagents?.has_reagent(/datum/reagent/consumable/oil/tallow, OIL_CONSUMED) || pot.reagents.has_reagent(/datum/reagent/water))
							return
						user.visible_message(span_info("[user]在锅里油炸了[S]。"))
						pot.reagents.remove_reagent(/datum/reagent/consumable/oil/tallow, OIL_CONSUMED)
						new S.deep_fried_type(src.loc)
						qdel(S)
						add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
						return
			for(var/datum/stew_recipe/R in GLOB.stew_recipes)
				for(var/I in R.inputs)
					if(istype(W, I))
						if(!pot.reagents.has_reagent(/datum/reagent/water, Z121_ETHOS_STEW_WATER + Z121_ETHOS_STEW_WATER_AFTER))
							to_chat(user, span_notice("水不够。"))
							return
						if(pot.reagents.chem_temp < Z121_ETHOS_MIN_STEW_TEMPERATURE)
							to_chat(user, span_notice("[pot]还没沸腾！"))
							return
						if(do_after(user, 2 SECONDS / cooktime_divisor * z121_ethos_craft_multiplier(user), target = src))
							if(QDELETED(W) || QDELETED(pot) || attachment != pot || !pot.reagents?.has_reagent(/datum/reagent/water, Z121_ETHOS_STEW_WATER + Z121_ETHOS_STEW_WATER_AFTER) || pot.reagents.chem_temp < Z121_ETHOS_MIN_STEW_TEMPERATURE)
								return
							user.visible_message(span_info("[user]把[W]放入锅中。"))
							qdel(W)
							playsound(src.loc, 'sound/items/Fish_out.ogg', 20, TRUE)
							// 开始烹煮即预留整份水，防止并发操作重复占用最后一份。
							pot.reagents.remove_reagent(/datum/reagent/water, Z121_ETHOS_STEW_WATER + Z121_ETHOS_STEW_WATER_AFTER)
							sleep(R.cooktime / cooktime_divisor)
							if(QDELETED(pot) || !pot.reagents)
								return
							playsound(src, "bubbles", 30, TRUE)
							var/produced = pot.reagents.add_reagent(R.output, Z121_ETHOS_STEW_WATER + Z121_ETHOS_STEW_WATER_AFTER)
							if(produced && !QDELETED(user))
								add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
							return
	. = call(src, Z121_ETHOS_OVERRIDE_PROC(/obj/machinery/light/rogue, attackby))(W, user, params)

/obj/item/reagent_containers/food/snacks/rogue/do_cooking_step(obj/item/I, mob/living/user, req_reagent, req_amt)
	var/datum/food_recipe/recipe = active_recipe
	var/step = current_step
	if(!recipe)
		return
	if(!do_after(user, get_cooking_do_time(user, recipe.time_per_step) * z121_ethos_craft_multiplier(user), target = src))
		if(active_recipe == recipe && current_step == step && step == 1)
			active_recipe = null
		return
	// 多人同时加工或等待中重置配方，不能把旧步骤结算到新配方。
	if(active_recipe != recipe || current_step != step || QDELETED(I))
		return

	playsound(src, 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE)

	if(req_reagent)

		if(!I.reagents || !I.reagents.has_reagent(req_reagent, req_amt))
			return
		I.reagents.remove_reagent(req_reagent, req_amt)
		playsound(src, 'modular/Creechers/sound/milking1.ogg', 50, TRUE)
	else
		playsound(src, 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE)
		I.moveToNullspace()

	// 食材已实际消耗后才结算经验，缺料或取消不能领取勤勉奖励。
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.mind.add_sleep_experience(/datum/skill/craft/cooking, H.STAINT * active_recipe.experience_per_step)

	if(current_step < active_recipe.ingredients.len || active_recipe.needs_cooking)
		var/image/over = image(I.icon, I.icon_state)
		over.transform = matrix() * 0.7
		switch(current_step)
			if(1) { over.pixel_x = -7; over.pixel_y = 7 }
			if(2) { over.pixel_x = 7;  over.pixel_y = 7 }
			if(3) { over.pixel_x = 7;  over.pixel_y = -7 }
			if(4) { over.pixel_x = -7; over.pixel_y = -7 }
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

#undef Z121_ETHOS_MIN_STEW_TEMPERATURE
#undef Z121_ETHOS_STEW_WATER
#undef Z121_ETHOS_STEW_WATER_AFTER
