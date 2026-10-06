GLOBAL_LIST_EMPTY(tennite_schisms)

/datum/tennite_schism
	var/datum/weakref/challenger_god
	var/datum/weakref/astrata_god
	var/list/supporters_astrata = list()
	var/list/supporters_challenger = list()
	var/list/neutrals = list()
	var/halfway_passed = FALSE

/datum/tennite_schism/New(datum/patron/challenger)
	. = ..()
	src.challenger_god = WEAKREF(challenger)
	src.astrata_god = WEAKREF(GLOB.patronlist[/datum/patron/divine/astrata])
	GLOB.tennite_schisms += src

/datum/tennite_schism/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN)
	GLOB.tennite_schisms -= src
	return ..()

/datum/tennite_schism/proc/announce()
	var/datum/patron/challenger = challenger_god.resolve()
	if(!challenger)
		return

	priority_announce("[challenger.name]挑战阿斯特拉塔的领导地位！这场冲突将在不到2天内，以双方存活支持者的数量决定胜负。[challenger.name]承诺获胜后重赏信徒，而阿斯特拉塔誓言报复一切胆敢违抗祂的人。选择你的阵营，或置身事外……", "Schism within the Ten", 'sound/magic/marked.ogg')
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		setup_mob(H)

	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(handle_latejoin))

/datum/tennite_schism/proc/handle_latejoin(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER
	if(!istype(spawned, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = spawned
	var/datum/patron/challenger = challenger_god?.resolve()
	if(!challenger || !H)
		return

	to_chat(H, span_notice("十神内部分裂正在发生！[challenger.name]挑战了阿斯特拉塔的领导地位！"))
	setup_mob(H)

/datum/tennite_schism/proc/setup_mob(mob/living/carbon/human/H)
	if(!istype(H) || H.stat == DEAD || !H.mind)
		return

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/choose_schism_side)
	if(!is_tennite(H))
		to_chat(H, span_notice("你虽不是十神信徒，不会影响这场冲突的最终结果，却可以假扮信徒，借分裂实现自己的目的……"))

/datum/tennite_schism/proc/process_winner()
	var/datum/patron/challenger = challenger_god.resolve()
	var/datum/patron/astrata = astrata_god.resolve()

	if(!challenger || !astrata)
		return

	var/astrata_count = 0
	var/challenger_count = 0

	for(var/datum/weakref/supporter_ref in supporters_astrata)
		var/mob/living/carbon/human/supporter = supporter_ref.resolve()
		if(supporter && supporter.stat != DEAD && is_tennite(supporter))
			astrata_count++

	for(var/datum/weakref/supporter_ref in supporters_challenger)
		var/mob/living/carbon/human/supporter = supporter_ref.resolve()
		if(supporter && supporter.stat != DEAD && is_tennite(supporter))
			challenger_count++

	if(astrata_count >= challenger_count)
		priority_announce("阿斯特拉塔的光辉战胜了[challenger.name]的挑战！太阳女王证明了自己是普赛顿真正的继承者！", "Astrata is VICTORIOUS!", 'sound/magic/ahh2.ogg')
		adjust_storyteller_influence("Astrata", 200)
		adjust_storyteller_influence(challenger.name, -50)

		for(var/datum/weakref/supporter_ref in supporters_astrata)
			var/mob/living/carbon/human/supporter = supporter_ref.resolve()
			if(supporter && supporter.patron == astrata)
				for(var/obj/effect/proc_holder/spell/self/choose_schism_side/spell in supporter.mind.spell_list)
					if(spell.chose_early)
						to_chat(supporter, span_notice("阿斯特拉塔的光辉获胜了！你坚定的虔诚换来了许多凯旋点。"))
						supporter.adjust_triumphs(3)
					else
						to_chat(supporter, span_notice("阿斯特拉塔的光辉获胜了，但你迟来的支持无法获得奖赏。"))
					break
			else if(supporter)
				to_chat(supporter, span_notice("阿斯特拉塔的光辉战胜了[challenger.name]的挑战！太阳女王要求你全力支持祂。"))

		for(var/datum/weakref/supporter_ref in supporters_challenger)
			var/mob/living/carbon/human/supporter = supporter_ref.resolve()
			if(supporter)
				to_chat(supporter, span_userdanger("永远别再违抗我！"))
				supporter.electrocute_act(5, astrata)

		cleanup_schism()

	else if(challenger_count > astrata_count)
		priority_announce("[challenger.name]成功挑战了阿斯特拉塔的暴政！太阳女王被迫不情愿地与[challenger.name]分享权力……", "[challenger.name] RULES!", 'sound/magic/inspire_02.ogg')
		adjust_storyteller_influence(challenger.name, 200)
		adjust_storyteller_influence("Astrata", -50)

		for(var/datum/weakref/supporter_ref in supporters_challenger)
			var/mob/living/carbon/human/supporter = supporter_ref.resolve()
			if(supporter && supporter.patron == challenger)
				for(var/obj/effect/proc_holder/spell/self/choose_schism_side/spell in supporter.mind.spell_list)
					if(spell.chose_early)
						to_chat(supporter, span_notice("[challenger.name]的挑战成功了！你坚定的信仰换来了凯旋点奖赏。"))
						supporter.adjust_triumphs(2)
					else
						to_chat(supporter, span_notice("[challenger.name]获胜了，但你迟来的支持无法获得奖赏。"))
					break
			else if(supporter)
				for(var/obj/effect/proc_holder/spell/self/choose_schism_side/spell in supporter.mind.spell_list)
					if(spell.chose_early)
						to_chat(supporter, span_notice("[challenger.name]成功挑战了阿斯特拉塔的暴政！你的支持换来了一点凯旋点。"))
						supporter.adjust_triumphs(1)
					else
						to_chat(supporter, span_notice("[challenger.name]的挑战成功了，但你迟来的支持无法获得奖赏。"))
					break
		for(var/datum/weakref/supporter_ref in supporters_astrata)
			var/mob/living/carbon/human/supporter = supporter_ref.resolve()
			if(supporter)
				to_chat(supporter, span_userdanger("无能的蠢货！"))
				supporter.electrocute_act(5, astrata)

		if(GLOB.todoverride == null)
			addtimer(CALLBACK(src, PROC_REF(astrata_scorn)), 15 SECONDS)

		addtimer(CALLBACK(src, PROC_REF(select_and_announce_vice_priest), challenger), 30 SECONDS)

/datum/tennite_schism/proc/astrata_scorn()
		priority_announce("你们不配沐浴我的圣光，忘恩负义的猪猡！", "Astrata's Scorn", 'sound/magic/fireball.ogg')
		GLOB.todoverride = "night"
		settod()
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(reset_tod_override)), 20 MINUTES)

/datum/tennite_schism/proc/select_and_announce_vice_priest(datum/patron/challenger)
	var/mob/living/carbon/human/selected_priest = null
	var/was_supporter = FALSE

	// First try to find a challenger supporter who is also clergy
	for(var/datum/weakref/supporter_ref in supporters_challenger)
		var/mob/living/carbon/human/human_mob = supporter_ref.resolve()
		if(human_mob && human_mob.stat != DEAD && human_mob.client && (human_mob.mind?.assigned_role in GLOB.church_positions) && human_mob.patron == challenger)
			selected_priest = human_mob
			was_supporter = TRUE
			break

	// If no supporter found, fall back to any clergy member who has the challenger as his patron
	if(!selected_priest)
		for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
			if(human_mob.stat != DEAD && human_mob.client && (human_mob.mind?.assigned_role in GLOB.church_positions) && human_mob.patron == challenger)
				selected_priest = human_mob
				break

	// Promote the selected priest if we found one
	if(selected_priest)
		selected_priest.job = "Vice Bishop"
		selected_priest.advjob = "Vice Bishop"
		selected_priest.migrant_type = null
		var/datum/devotion/D = selected_priest.devotion
		if(D)
			D.passive_devotion_gain = 1
			D.passive_progression_gain = 1
			START_PROCESSING(SSobj, D)
		selected_priest.verbs |= /mob/living/carbon/human/proc/devotionreport
		selected_priest.verbs |= /mob/living/carbon/human/proc/clericpray
		selected_priest.verbs |= /mob/living/carbon/human/proc/churchexcommunicate
		//selected_priest.verbs |= /mob/living/carbon/human/proc/churchcurse	- Add this back seperate later in a seperate PR. Good feature, PR too big tho.
		selected_priest.verbs |= /mob/living/carbon/human/proc/churchannouncement

		priority_announce("[challenger.name]选定[selected_priest.real_name]为新任主教！权力共享开始了！", "Bishop rises", 'sound/magic/inspire_02.ogg')

		if(was_supporter)
			to_chat(selected_priest, span_green("[challenger.name]向你投以微笑！你在分裂期间忠诚的支持，为你赢得了副主教之位！"))
		else
			to_chat(selected_priest, span_green("虽然你在分裂期间并未公开支持[challenger.name]，你仍被选中担任副主教！"))

		if(D)
			to_chat(selected_priest, span_notice("你获得了持续增长的虔诚，以及发布公告与执行绝罚的权能！"))

	cleanup_schism()

/datum/tennite_schism/proc/cleanup_schism()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.mind)
			continue
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/choose_schism_side)

	qdel(src)

/// Announces the current standings in the schism
/datum/tennite_schism/proc/announce_standings()
	var/datum/patron/challenger = challenger_god.resolve()
	var/datum/patron/astrata = astrata_god.resolve()

	if(!challenger || !astrata)
		return

	var/astrata_count = 0
	var/challenger_count = 0

	for(var/datum/weakref/supporter_ref in supporters_astrata)
		var/mob/living/carbon/human/supporter = supporter_ref.resolve()
		if(supporter && supporter.stat != DEAD && is_tennite(supporter))
			astrata_count++

	for(var/datum/weakref/supporter_ref in supporters_challenger)
		var/mob/living/carbon/human/supporter = supporter_ref.resolve()
		if(supporter && supporter.stat != DEAD && is_tennite(supporter))
			challenger_count++

	if(astrata_count >= challenger_count)
		priority_announce("阿斯特拉塔在分裂中领先！祂很快便会施行报复……", "Schism Rages On", 'sound/magic/marked.ogg')
	else if(challenger_count > astrata_count)
		priority_announce("[challenger.name]在分裂中领先！阿斯特拉塔很快便会被迫让步……", "Schism Rages On", 'sound/magic/marked.ogg')

	halfway_passed = TRUE

/datum/tennite_schism/proc/change_side(mob/living/carbon/human/user, new_side)
	supporters_astrata -= WEAKREF(user)
	supporters_challenger -= WEAKREF(user)
	neutrals -= WEAKREF(user)

	switch(new_side)
		if("astrata")
			supporters_astrata += WEAKREF(user)
			to_chat(user, span_notice("你已宣布效忠阿斯特拉塔！"))
		if("challenger")
			supporters_challenger += WEAKREF(user)
			var/datum/patron/challenger = challenger_god.resolve()
			if(challenger)
				to_chat(user, span_notice("你已宣布效忠[challenger.name]！"))
		if("neutral")
			neutrals += WEAKREF(user)
			to_chat(user, span_notice("你已宣布在分裂中保持中立。"))

/obj/effect/proc_holder/spell/self/choose_schism_side
	name = "Choose your side"
	overlay_state = "limb_attach"
	recharge_time = 20 SECONDS
	var/chose_early = FALSE
	var/uses_remaining = 2

/obj/effect/proc_holder/spell/self/choose_schism_side/cast(mob/living/carbon/human/user)
	if(!length(GLOB.tennite_schisms))
		to_chat(user, span_warning("当前没有可参与的分裂。"))
		return

	var/datum/tennite_schism/current_schism = GLOB.tennite_schisms[1]
	var/datum/patron/challenger = current_schism.challenger_god.resolve()

	if(uses_remaining <= 0)
		to_chat(user, span_warning("你已确定在分裂中的最终阵营。"))
		return

	var/list/options = list()
	options["阿斯特拉塔"] = "astrata"
	options["中立"] = "neutral"
	if(challenger)
		options["[challenger.name]"] = "challenger"
	var/choice = input(user, "选择你在分裂中的阵营，你还可以改变[uses_remaining]次立场", "Choose your side") as null|anything in options
	if(!choice || !current_schism)
		return

	var/current_side
	var/datum/weakref/user_ref = WEAKREF(user)
	if(user_ref in current_schism.supporters_astrata)
		current_side = "astrata"
	else if(user_ref in current_schism.supporters_challenger)
		current_side = "challenger"
	else
		current_side = "neutral"

	if(options[choice] == current_side)
		to_chat(user, span_notice("你已经支持这个阵营了！"))
		return

	uses_remaining--
	current_schism.change_side(user, options[choice])

	if(!current_schism.halfway_passed)
		chose_early = TRUE

	if(uses_remaining <= 0)
		if(action)
			action.UpdateButtonIcon()
		to_chat(user, span_boldnotice("你在分裂中的阵营现已最终确定。"))
	return TRUE

/datum/round_event_control/schism_within_ten
	name = "Schism within the Ten"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/schism_within_ten
	weight = 0.25
	max_occurrences = 1
	min_players = 55
	earliest_start = 20 MINUTES
	allowed_storytellers = list(/datum/storyteller/noc, /datum/storyteller/ravox, /datum/storyteller/necra, /datum/storyteller/xylix, /datum/storyteller/pestra, /datum/storyteller/abyssor, /datum/storyteller/dendor, /datum/storyteller/malum)
	//Once more 'generic' god interventions are in, add to Psydon as well.

/datum/round_event_control/schism_within_ten/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	var/alternative_events = FALSE
	for(var/datum/round_event_control/E in SSgamemode.control)
		if(E.track != EVENT_TRACK_INTERVENTION)
			continue
		if(E == src)
			continue
		if(E.canSpawnEvent(players_amt, gamemode, fake_check))
			alternative_events = TRUE
			break

	if(!alternative_events)
		return FALSE

	var/datum/patron/challenger = find_strongest_challenger()
	if(!challenger)
		return FALSE

	return FALSE

/datum/round_event/schism_within_ten/start()
	if(LAZYLEN(GLOB.tennite_schisms) > 0)
		return

	var/datum/patron/strongest_challenger = find_strongest_challenger()
	if(!strongest_challenger)
		return

	// Notify challenger god's followers
	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue

		if(human_mob.patron == strongest_challenger)
			to_chat(human_mob, span_notice("你听到了守护神的神圣召唤——挑战阿斯特拉塔权威的时刻已到！准备迎接即将到来的分裂！"))
			human_mob.playsound_local(human_mob, 'sound/magic/marked.ogg', 100)

	new /datum/tennite_schism(strongest_challenger)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(announce_schism_start)), 2 MINUTES)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(announce_schism_standings)), 16 MINUTES)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(announce_schism_end)), 33 MINUTES)

/// Officially starts the schism with an announcement and ability to choose sides
/proc/announce_schism_start()
	for(var/datum/tennite_schism/schism in GLOB.tennite_schisms)
		schism.announce()

/// Announces current standings in the schism
/proc/announce_schism_standings()
	for(var/datum/tennite_schism/schism in GLOB.tennite_schisms)
		schism.announce_standings()

/// Officially ends the schism and declares the winner of it
/proc/announce_schism_end()
	for(var/datum/tennite_schism/schism in GLOB.tennite_schisms)
		schism.process_winner()

/// Checks if the mob has any divine pantheon god as their patron
/proc/is_tennite(mob/living/carbon/human/human_mob)
	if(!human_mob.patron)
		return FALSE
	return istype(human_mob.patron, /datum/patron/divine)

/// Resets day cycle override to null
/proc/reset_tod_override()
	GLOB.todoverride = null

/// Finds strongest divine pantheon to challenge Astrata
/proc/find_strongest_challenger()
	var/datum/patron/strongest_challenger
	var/highest_influence = 0
	var/astrata_influence = get_storyteller_influence("Astrata") || 0

	for(var/type in subtypesof(/datum/patron/divine) - list(/datum/patron/divine/astrata, /datum/patron/divine/eora))
		var/datum/patron/divine/god = GLOB.patronlist[type]
		if(!god)
			continue

		var/has_clergy = FALSE
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.stat != DEAD && H.client && H.patron == god && (H.mind?.assigned_role in GLOB.church_positions))
				has_clergy = TRUE
				break

		if(!has_clergy)
			continue

		var/god_influence = get_storyteller_influence(god.name) || 0
		if(god_influence > highest_influence && god_influence > astrata_influence)
			highest_influence = god_influence
			strongest_challenger = god

	return strongest_challenger
