/mob/living/carbon/human/proc/attempt_steal(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/mob/living/carbon/human/user_human = user
	var/mob/living/carbon/human/target_human = target
	var/thiefskill = user.get_skill_level(/datum/skill/misc/stealing) + (has_world_trait(/datum/world_trait/matthios_fingers) ? 1 : 0)
	var/stealroll = roll("[thiefskill]d6")
	var/targetperception = (target_human.STAPER)
	if(HAS_TRAIT(target_human, TRAIT_WATCHFUL))
		targetperception += 1
	var/list/stealablezones = list("chest", "neck", "groin", "r_hand", "l_hand")
	var/list/stealpos = list()
	var/list/mobsbehind = list()
	var/exp_to_gain = user_human.STAINT
	to_chat(user, span_notice("我试图偷走[target_human]身上的东西……"))	
	if(do_after(user, 5, target = target_human, progress = 0))
		if(stealroll > targetperception)
			//TODO add exp here
			// RATWOOD MODULAR START
			if(target_human.cmode)
				to_chat(user, "<span class='warning'>[target_human]正保持警惕。我没法这样行窃。</span>")
				return
			// RATWOOD MODULAR END
			if(user_human.get_active_held_item())
				to_chat(user, span_warning("我手里拿着东西，没法行窃！"))
				return
			if(!(user.zone_selected in stealablezones))
				to_chat(user, span_warning("那里有什么可偷的？"))
				return
			mobsbehind |= cone(target_human, list(turn(target_human.dir, 180)), list(user))
			if(mobsbehind.Find(user) || target_human.IsUnconscious() || target_human.eyesclosed || target_human.eye_blind || target_human.eye_blurry || !(target_human.mobility_flags & MOBILITY_STAND))
				switch(user_human.zone_selected)
					if("chest")
						if (target_human.get_item_by_slot(SLOT_BACK_L))
							stealpos.Add(target_human.get_item_by_slot(SLOT_BACK_L))
						if (target_human.get_item_by_slot(SLOT_BACK_R))
							stealpos.Add(target_human.get_item_by_slot(SLOT_BACK_R))
					if("neck")
						if (target_human.get_item_by_slot(SLOT_NECK))
							stealpos.Add(target_human.get_item_by_slot(SLOT_NECK))
					if("groin")
						if (target_human.get_item_by_slot(SLOT_BELT_R))
							stealpos.Add(target_human.get_item_by_slot(SLOT_BELT_R))
						if (target_human.get_item_by_slot(SLOT_BELT_L))
							stealpos.Add(target_human.get_item_by_slot(SLOT_BELT_L))
					if("r_hand", "l_hand")
						if (target_human.get_item_by_slot(SLOT_RING))
							stealpos.Add(target_human.get_item_by_slot(SLOT_RING))
				if(length(stealpos) > 0)
					var/obj/item/picked = pick(stealpos)
					target_human.dropItemToGround(picked)
					user.put_in_active_hand(picked)
					to_chat(user, span_green("我偷到了[picked]！"))
					target_human.log_message("has had \the [picked] stolen by [key_name(user_human)]", LOG_ATTACK, color="white")
					user_human.log_message("has stolen \the [picked] from [key_name(target_human)]", LOG_ATTACK, color="white")
					if(target_human.client && target_human.stat != DEAD)
						SEND_SIGNAL(user_human, COMSIG_ITEM_STOLEN, target_human)
						record_featured_stat(FEATURED_STATS_THIEVES, user_human)
						record_featured_stat(FEATURED_STATS_CRIMINALS, user_human)
						GLOB.azure_round_stats[STATS_ITEMS_PICKPOCKETED]++
					if(user.has_flaw(/datum/charflaw/addiction/kleptomaniac))
						user.sate_addiction()
				else
					exp_to_gain /= 2 // these can be removed or changed on reviewer's discretion
					to_chat(user, span_warning("我在那里什么也没找到。也许该换个地方找找。"))
			else
				to_chat(user, "<span class='warning'>对方能看见我！")
		if(stealroll <= 5)
			target_human.log_message("has had an attempted pickpocket by [key_name(user_human)]", LOG_ATTACK, color="white")
			user_human.log_message("has attempted to pickpocket [key_name(target_human)]", LOG_ATTACK, color="white")
			user_human.visible_message(span_danger("[user_human]试图扒窃[target_human]，却失败了！"))
			to_chat(target_human, span_danger("[user_human]试图偷我的东西！"))
		if(stealroll < targetperception)
			target_human.log_message("has had an attempted pickpocket by [key_name(user_human)]", LOG_ATTACK, color="white")
			user_human.log_message("has attempted to pickpocket [key_name(target_human)]", LOG_ATTACK, color="white")
			to_chat(user, span_danger("我行窃失败了！"))
			to_chat(target_human, span_danger("有人试图偷我的东西！"))
			exp_to_gain /= 5 // these can be removed or changed on reviewer's discretion
		// If we're pickpocketing someone else, and that person is conscious, grant XP
		if(user != target_human && target_human.stat == CONSCIOUS)
			user.mind.add_sleep_experience(/datum/skill/misc/stealing, exp_to_gain, FALSE)
		user.changeNext_move(CLICK_CD_MELEE)
