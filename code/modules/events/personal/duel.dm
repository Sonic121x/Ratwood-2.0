/datum/round_event_control/ravox_duel
	name = "Honor Duels"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/ravox_duel
	weight = 7
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 30

	tags = list(
		TAG_BATTLE,
	)

/datum/round_event_control/ravox_duel/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/ravox))
			continue
		return TRUE

	return FALSE

/datum/round_event/ravox_duel/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/ravox))
			continue
		valid_targets += human_mob

	if(!valid_targets.len)
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/ravox_duel/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	to_chat(chosen_one, span_userdanger("你是神的选民！"))
	to_chat(chosen_one, span_notice("拉沃克斯要你向他人发起荣誉决斗！赢得[new_objective.duels_required]场决斗，证明你的价值！一方认输或被击昏时，决斗便会结束。"))
	chosen_one.playsound_local(chosen_one, 'sound/vo/male/knight/rage (6).ogg', 70)

	chosen_one.mind.announce_personal_objectives()
