/datum/round_event_control/dead_whispers
	name = "Whispers of the Dead"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/dead_whispers
	weight = 7
	earliest_start = 15 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_HAUNTED,
	)

/datum/round_event_control/dead_whispers/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	if(length(GLOB.last_words) < 7)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/necra))
			continue
		return TRUE

	return FALSE

/datum/round_event/dead_whispers/start()
	if(length(GLOB.last_words) < 7)
		return FALSE

	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/necra))
			continue
		valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/listen_whispers/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	to_chat(chosen_one, span_userdanger("你是内克拉的选民！"))
	to_chat(chosen_one, span_notice("你必须更深入地理解死亡，才能为它做好准备。为此，戴上内克拉护符前往教堂，聆听亡者的低语。"))
	chosen_one.playsound_local(chosen_one, 'sound/ambience/noises/genspooky (1).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
