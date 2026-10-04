/mob/living/carbon/human/proc/add_bite_animation()
	remove_overlay(SUNDER_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('icons/effects/clan.dmi', "bite", -SUNDER_LAYER)
	overlays_standing[SUNDER_LAYER] = bite_overlay
	apply_overlay(SUNDER_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_bite)), 1.5 SECONDS)

/mob/living/carbon/human/proc/remove_bite()
	remove_overlay(SUNDER_LAYER)

/mob/living/proc/drinksomeblood(mob/living/carbon/victim, sublimb_grabbed)
	if(world.time <= next_move)
		return
	if(world.time < last_drinkblood_use + 2 SECONDS)
		return
	if(!istype(victim))
		to_chat(src, span_warning("我只能从有智慧的活物身上吸血！"))
		return
	if(victim.dna?.species && (NOBLOOD in victim.dna.species.species_traits))
		to_chat(src, span_warning("唉，没有血。"))
		return
	if(!victim.can_be_blood_drunk())
		to_chat(src, span_warning("唉，没有血。"))
		return

	var/datum/antagonist/vampire/VDrinker = mind.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/vampire/VVictim = victim.mind?.has_antag_datum(/datum/antagonist/vampire)

	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(VDrinker && HAS_TRAIT(human_victim, TRAIT_WORN_SILVER_PSICROSS))
			to_chat(src, span_userdanger("是银！嘶嘶嘶！！！"))
			return
		if(VDrinker && HAS_TRAIT(human_victim, TRAIT_SILVER_BLESSED))
			to_chat(src, span_userdanger("血里有银！嘶嘶嘶！！！"))
			return
		human_victim.add_bite_animation()

	last_drinkblood_use = world.time
	changeNext_move(CLICK_CD_MELEE)

	victim.set_blood_volume(max(victim.get_blood_volume() - 5, 0))
	victim.handle_blood()

	playsound(loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)
	beast_feed_pulse()

	SEND_SIGNAL(src, COMSIG_LIVING_DRINKED_LIMB_BLOOD, victim)
	victim.visible_message(span_danger("[src]从[victim]的[parse_zone(sublimb_grabbed)]吸血！"), \
					span_userdanger("[src]从我的[parse_zone(sublimb_grabbed)]吸血！"), span_hear("..."), COMBAT_MESSAGE_RANGE, src)
	to_chat(src, span_warning("我从[victim]的[parse_zone(sublimb_grabbed)]吸血。"))
	log_combat(src, victim, "drank blood from ")

	if(!VDrinker)
		if(!HAS_TRAIT(src, TRAIT_HORDE) && !HAS_TRAIT(src, TRAIT_HEMOPHAGE))
			to_chat(src, span_warning("我要吐了……"))
			addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
		if(HAS_TRAIT(src, TRAIT_HEMOPHAGE) && ishuman(src))
			var/mob/living/carbon/human/H = src
			H.adjust_nutrition(35)
			H.adjust_hydration(35)
			if(H.reagents)
				H.reagents.add_reagent(/datum/reagent/medicine/vital_essence, 12)
			if(H.get_blood_volume() < BLOOD_VOLUME_NORMAL)
				H.set_blood_volume(min(H.get_blood_volume() + 35, BLOOD_VOLUME_NORMAL))
		return

	if(victim.mind?.has_antag_datum(/datum/antagonist/werewolf) || (victim.stat != DEAD && victim.mind?.has_antag_datum(/datum/antagonist/zombie)))
		to_chat(src, span_danger("我要吐了……"))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
		return

	if(VVictim)
		to_chat(src, span_userdanger("<b>你试图吞噬[victim]的血族灵魂。</b>"))

	var/blood_handle
	if(victim.stat == DEAD)
		blood_handle |= BLOOD_PREFERENCE_DEAD
	else
		blood_handle |= BLOOD_PREFERENCE_LIVING

	if(victim.job in list("Priest", "Priestess", "Cleric", "Acolyte", "Templar", "Churchling", "Crusader", "Inquisitor"))
		blood_handle |= BLOOD_PREFERENCE_HOLY
	if(VVictim)
		blood_handle |= BLOOD_PREFERENCE_KIN
		blood_handle  &= ~BLOOD_PREFERENCE_LIVING

	clan.handle_bloodsuck(src, blood_handle)

	if(victim.get_bloodpool() > 0)
		var/used_vitae = 150
		victim.set_blood_volume(max(victim.get_blood_volume() - 45, 0))
		if(victim.get_bloodpool() < used_vitae)  // We assume they're left with 250 vitae or less, so we take it all
			used_vitae = victim.get_bloodpool()
			to_chat(src, span_warning("……可惜只剩些残渣……"))
		victim.adjust_bloodpool(-used_vitae)
		victim.adjust_hydration(- used_vitae * 0.1)
		if(victim.mind && !victim.clan)
			used_vitae = used_vitae * CLIENT_VITAE_MULTIPLIER
		adjust_bloodpool(used_vitae)
		adjust_hydration(used_vitae * 0.1)
	else // Successful diablerie, yes, you can become a vampire lord by sucking him dry. Intentional!
		if(VVictim)
			AdjustMasquerade(-1)
			message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
			log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
			to_chat(src, span_danger("我竟……吞噬了我的血族同胞！"))
			if(VVictim.generation > VDrinker.generation)
				VDrinker.generation = VVictim.generation
			VDrinker.research_points += VVictim.research_points + VVictim.research_spent
			victim.death()
			victim.adjustBruteLoss(-50, TRUE)
			victim.adjustFireLoss(-50, TRUE)
			return
		else if(victim.get_blood_volume() < BLOOD_VOLUME_SURVIVE && victim.stat != DEAD)
			to_chat(src, span_warning("为满足自己的欲望而做出的悲惨献祭，触动了你内心深处的某样东西。"))
			AdjustMasquerade(-1)
			victim.death()
			return

	if(!victim.clan && victim.mind && ishuman(victim) && VDrinker.generation > GENERATION_THINBLOOD && victim.get_blood_volume() <= BLOOD_VOLUME_BAD)
		if(alert(src, "你想创造一名新的血裔吗？", "该隐的诅咒", "就这么办", "我收回决定") != "就这么办")
			to_chat(src, span_warning("我认为[victim]不配。"))
		else
			INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/carbon/human, vampire_conversion_prompt), src)

/mob/living/carbon/human/proc/vampire_conversion_prompt(mob/living/carbon/sire)
	if(!mind)
		return

	var/datum/antagonist/vampire/VDrinker = sire?.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(!istype(VDrinker))
		return

	var/datum/mind/original_mind = mind

	if(alert(src, "你愿意成为吸血鬼血裔吗？警告：拒绝可能导致致命伤害。", "该隐的诅咒", "就这么办", "我收回决定") != "就这么办")
		to_chat(sire, span_danger("你的猎物抽搐着，但诅咒未能生效，仿佛有某种超凡之力介入了……"))
		if(HAS_TRAIT_FROM(src, TRAIT_REFUSED_VAMP_CONVERT, REF(sire)))
			return

		to_chat(sire, span_danger("诅咒未能控制[src]，但你仍然从其体内榨出了最后一滴血能。"))
		sire.adjust_bloodpool(VITAE_PER_UNIQUE_CONVERSION_REJECT)
		ADD_TRAIT(src, TRAIT_REFUSED_VAMP_CONVERT, REF(sire))
		return

	if(sire.stat == DEAD) // If you accept the prompt as a corpse, you get turned into a corpse vampire, which RR's you pretty much
		return FALSE

	if(HAS_TRAIT_FROM(sire, TRAIT_UNLYCKERABLE, REF(src))) // Cannot turn Gnolls to Sires
		return FALSE

	revive(full_heal = TRUE)
	visible_message(span_danger("某种黑暗能量开始从[sire]流入[src]体内……"))
	visible_message(span_red("[src]作为新的血裔站了起来！"))
	original_mind?.transfer_to(src, TRUE)
	var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = sire.clan, forced_clan = TRUE, generation = VDrinker.generation-1)
	mind?.add_antag_datum(new_antag)
	adjust_bloodpool(500)
	remove_sleep_depravation(TRUE)
