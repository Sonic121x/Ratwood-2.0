/datum/round_event_control/zizo_shrines
	name = "Profane Construction"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/zizo_shrines
	weight = 7
	earliest_start = 20 MINUTES
	max_occurrences = 1
	min_players = 25

	tags = list(
		TAG_CORRUPTION,
		TAG_WORK,
	)

/datum/round_event_control/zizo_shrines/canSpawnEvent(players_amt, gamemode, fake_check, mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client || !user)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/inhumen/zizo))
			continue
		if(user.get_skill_level(/datum/skill/craft/crafting) < 1)
			continue
		return TRUE

	return FALSE

/datum/round_event/zizo_shrines/start()
	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/zizo))
			continue
		var/mob/living/user = human_mob
		if(user.get_skill_level(/datum/skill/craft/crafting) < 1)
			continue
		valid_targets += human_mob

	if(!valid_targets.len)
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/build_zizo_shrine/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	to_chat(chosen_one, span_userdanger("你是神的选民！"))
	to_chat(chosen_one, span_biginfo("齐佐要你散播腐化！运用你新获得的知识建造[new_objective.target_count]座亵渎神龛，完成齐佐的意志！"))
	to_chat(chosen_one, span_notice("你可以用一根小原木、两块石头和三根木桩建造亵渎神龛。"))
	chosen_one.playsound_local(chosen_one, 'sound/ambience/noises/genspooky (1).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
