/datum/round_event_control/baotha_snorting
	name = "Drug Desire"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/baotha_snorting
	weight = 10
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 15

	tags = list(
		TAG_INSANITY,
		TAG_ALCHEMY,
	)

/datum/round_event_control/baotha_snorting/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/baotha))
			continue
		return TRUE

	return FALSE

/datum/round_event/baotha_snorting/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/baotha))
			continue
		valid_targets += human_mob

	if(!valid_targets.len)
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/snort_drugs/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	to_chat(chosen_one, span_userdanger("你是神的选民！"))
	to_chat(chosen_one, span_notice("巴奥莎渴求药物带来的狂喜！吸食毒品，赢得巴奥莎的青睐！"))
	chosen_one.playsound_local(chosen_one, 'sound/ambience/noises/genspooky (1).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
