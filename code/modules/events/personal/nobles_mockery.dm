/datum/round_event_control/xylix_mocking_nobles
	name = "Mockery (Nobles)"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/xylix_mocking_nobles
	weight = 10
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 20

	tags = list(
		TAG_TRICKERY,
	)

/datum/round_event_control/xylix_mocking_nobles/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client || !istype(H.patron, /datum/patron/divine/xylix) || H.is_noble())
			continue
		if(locate(/obj/effect/proc_holder/spell/invoked/mockery) in H.mind.spell_list)
			return TRUE
	return FALSE

/datum/round_event/xylix_mocking_nobles/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client || !istype(H.patron, /datum/patron/divine/xylix) || H.is_noble())
			continue
		if(locate(/obj/effect/proc_holder/spell/invoked/mockery) in H.mind.spell_list)
			valid_targets += H

	if(!valid_targets.len)
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/mock/noble/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	to_chat(chosen_one, span_userdanger("你是神的选民！"))
	to_chat(chosen_one, span_notice("赛利克斯渴求乐趣！狠狠嘲弄[new_objective.required_count]位贵族，证明你的机智，赢得赛利克斯的青睐！"))
	chosen_one.playsound_local(chosen_one, 'sound/vo/male/evil/laugh (1).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
