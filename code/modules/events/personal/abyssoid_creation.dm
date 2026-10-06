/datum/round_event_control/create_abyssoids
	name = "Create Abyssoids"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/create_abyssoids
	weight = 7
	earliest_start = 5 MINUTES
	max_occurrences = 1
	min_players = 15

	tags = list(
		TAG_WATER,
		TAG_NATURE,
	)

/datum/round_event_control/create_abyssoids/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/abyssor))
			continue
		return TRUE

	return FALSE

/datum/round_event/create_abyssoids/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/abyssor))
			continue
		valid_targets += H

	if(!valid_targets.len)
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/create_abyssoids/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	var/obj/effect/proc_holder/spell/self/create_abyssoid/abyssoid_spell = new()
	chosen_one.mind.AddSpell(abyssoid_spell)

	to_chat(chosen_one, span_userdanger("你是神的选民！"))
	to_chat(chosen_one, span_blue("阿比索尔要让所有人记住祂！创造一支神圣的深渊水蛭大军，将它们分发给那些忘恩负义之徒！"))
	chosen_one.playsound_local(chosen_one, 'sound/items/bucket_transfer (2).ogg', 100)

	to_chat(chosen_one, span_notice("阿比索尔赐予你将普通水蛭转化为深渊水蛭的力量！你只需付出少许鲜血的代价……"))

	chosen_one.mind.announce_personal_objectives()
