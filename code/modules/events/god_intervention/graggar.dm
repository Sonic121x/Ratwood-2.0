/// Tracks culling pairings
GLOBAL_LIST_EMPTY(graggar_cullings)

/datum/culling_duel
	var/datum/weakref/challenger
	var/datum/weakref/target
	var/datum/weakref/challenger_heart
	var/datum/weakref/target_heart

/datum/culling_duel/New(mob/challenger, mob/target)
	. = ..()
	src.challenger = WEAKREF(challenger)
	src.target = WEAKREF(target)
	var/obj/item/organ/heart/c_heart = challenger.getorganslot(ORGAN_SLOT_HEART)
	var/obj/item/organ/heart/t_heart = target.getorganslot(ORGAN_SLOT_HEART)
	src.challenger_heart = WEAKREF(c_heart)
	src.target_heart = WEAKREF(t_heart)

/datum/culling_duel/Destroy()
	GLOB.graggar_cullings -= src
	return ..()

/datum/culling_duel/proc/handle_heart_destroyed(which_heart)
	var/mob/living/carbon/human/winner
	var/mob/living/carbon/human/loser

	if(which_heart == "target")
		winner = challenger.resolve()
		loser = target.resolve()
	else if(which_heart == "challenger")
		winner = target.resolve()
		loser = challenger.resolve()

	if(winner)
		winner.remove_stress(/datum/stressevent/graggar_culling_unfinished)
		winner.verbs -= /mob/living/carbon/human/proc/remember_culling
		winner.add_stress(/datum/stressevent/graggar_culling_finished)
		winner.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)
		to_chat(winner, span_notice("你对手的心脏已被摧毁！虽然这不是格拉加尔渴求的荣耀吞食，祂仍认可你并非弱者。"))
		winner.adjust_triumphs(1)
	if(loser)
		loser.remove_stress(/datum/stressevent/graggar_culling_unfinished)
		loser.verbs -= /mob/living/carbon/human/proc/remember_culling
		loser.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)
		to_chat(loser, span_red("你辜负了格拉加尔，弱者！"))
		loser.change_stat(STATKEY_STR, -1)
		loser.change_stat(STATKEY_CON, -1)
		loser.change_stat(STATKEY_WIL, -1)
		loser.change_stat(STATKEY_SPD, -1)
		loser.change_stat(STATKEY_LCK, 1)
		//loser.gib()	- Removed to avoid RRing them fully. Instead, we punish his stats.

	qdel(src)

/datum/culling_duel/proc/process_win(mob/living/winner, mob/living/loser)
	winner.remove_stress(/datum/stressevent/graggar_culling_unfinished)
	winner.verbs -= /mob/living/carbon/human/proc/remember_culling
	winner.change_stat(STATKEY_STR, 1)
	winner.change_stat(STATKEY_WIL, 1)
	winner.change_stat(STATKEY_CON, 1)
	winner.change_stat(STATKEY_SPD, 1)
	winner.change_stat(STATKEY_LCK, 1)
	to_chat(winner, span_notice("你吞食对手的心脏，向格拉加尔证明了实力！现在，对手的力量归你所有！"))
	winner.adjust_triumphs(2)
	winner.add_stress(/datum/stressevent/graggar_culling_finished)
	winner.playsound_local(winner, 'sound/ambience/noises/genspooky (1).ogg', 100)

	if(loser)
		loser.remove_stress(/datum/stressevent/graggar_culling_unfinished)
		loser.verbs -= /mob/living/carbon/human/proc/remember_culling
		to_chat(loser, span_boldred("这是你最后一次辜负格拉加尔！"))
		loser.gib()

	qdel(src)

/// Verb for the graggar's culling contestants to remember their targets
/mob/living/carbon/human/proc/remember_culling()
	set name = "格拉加尔的猎杀"
	set category = "格拉加尔"
	if(!mind)
		return
	mind.recall_culling(src)

/datum/round_event_control/graggar_culling
	name = "Graggar's Culling"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/graggar_culling
	weight = 8
	earliest_start = 25 MINUTES
	max_occurrences = 1
	min_players = 35
	allowed_storytellers = list(/datum/storyteller/graggar)

/datum/round_event_control/graggar_culling/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE
	if(GLOB.patron_follower_counts["Graggar"] < 3)
		return FALSE

/datum/round_event/graggar_culling/start()
	var/list/contenders = list()
	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue

		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/graggar))
			continue

		var/obj/item/organ/heart/heart = human_mob.getorganslot(ORGAN_SLOT_HEART)
		if(!heart)
			continue

		contenders += human_mob

	if(length(contenders) < 2)
		return

	// 25% chance for grand culling (multiple pairs)
	var/grand_culling = prob(25)
	var/max_pairs = grand_culling ? floor(length(contenders) / 2) : 1

	for(var/i in 1 to max_pairs)
		if(length(contenders) < 2)
			break

		var/mob/living/carbon/human/first_chosen = pick_n_take(contenders)
		var/mob/living/carbon/human/second_chosen = pick_n_take(contenders)

		var/datum/culling_duel/new_duel = new(first_chosen, second_chosen)
		GLOB.graggar_cullings += new_duel

		var/first_chosen_location = first_chosen.prepare_deathsight_message()
		var/second_chosen_location = second_chosen.prepare_deathsight_message()

		// Notify first chosen
		first_chosen.add_stress(/datum/stressevent/graggar_culling_unfinished)
		first_chosen.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/extract_heart)
		first_chosen.verbs |= /mob/living/carbon/human/proc/remember_culling
		to_chat(first_chosen, span_userdanger("你是格拉加尔的选民！"))
		to_chat(first_chosen, span_red("弱者应滋养强者，这是格拉加尔的意志。吞食担任[second_chosen.job]的[span_notice(second_chosen.real_name)]的心脏，证明自己并非弱者，换取无法想象的力量。若失败，被吞食的便是你。"))
		to_chat(first_chosen, span_red("担任[second_chosen.job]的[span_notice("[second_chosen.real_name]")]就在[span_notice("[second_chosen_location]")]的某处。在对方吃掉你的心脏之前，先吃掉对方的！格拉加尔命令对方的头颅必须留在肩上，因为必须证明实力，无论心脏是否还在跳动。"))
		if(grand_culling)
			to_chat(first_chosen, span_notice("格拉加尔宣告一场大猎杀！今日，众多心脏将成为强者的食粮！"))
		first_chosen.playsound_local(first_chosen, 'sound/magic/marked.ogg', 100)

		// Notify second chosen
		second_chosen.add_stress(/datum/stressevent/graggar_culling_unfinished)
		second_chosen.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/extract_heart)
		second_chosen.verbs |= /mob/living/carbon/human/proc/remember_culling
		to_chat(second_chosen, span_userdanger("你是格拉加尔的选民！"))
		to_chat(second_chosen, span_red("弱者应滋养强者，这是格拉加尔的意志。吞食担任[first_chosen.job]的[span_notice(first_chosen.real_name)]的心脏，证明自己并非弱者，换取无法想象的力量。若失败，被吞食的便是你。"))
		to_chat(second_chosen, span_red("担任[first_chosen.job]的[span_notice("[first_chosen.real_name]")]就在[span_notice("[first_chosen_location]")]的某处。在对方吃掉你的心脏之前，先吃掉对方的！格拉加尔命令对方的头颅必须留在肩上，因为必须证明实力，无论心脏是否还在跳动。"))
		if(grand_culling)
			to_chat(second_chosen, span_notice("格拉加尔宣告一场大猎杀！今日，众多心脏将成为强者的食粮！"))
		second_chosen.playsound_local(second_chosen, 'sound/magic/marked.ogg', 100)
