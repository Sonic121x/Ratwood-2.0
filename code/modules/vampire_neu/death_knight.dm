/datum/antagonist/skeleton/knight
	name = "Death Knight"
	increase_votepwr = FALSE
	roundend_category = "Vampires"
	antagpanel_category = "Vampire"

/datum/antagonist/skeleton/knight/on_gain()
	. = ..()
	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	for(var/datum/mind/MF in get_minds("Vampire Spawn"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)
	for(var/datum/mind/MF in get_minds("Death Knight"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

/datum/antagonist/skeleton/knight/greet()
	to_chat(owner.current, span_userdanger("我归来是为了侍奉。我将服从命令，以求重获安息。"))
	owner.announce_objectives()
	..()

/datum/antagonist/skeleton/knight/roundend_report()
	var/traitorwin = TRUE

	printplayer(owner)

	var/count = 0
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		for(var/datum/objective/objective in objectives)
			objective.update_explanation_text()
			if(objective.check_completion())
				to_chat(owner, "<B>目标 #[count]</B>: [objective.explanation_text] <span class='greentext'>凯旋！</span>")
			else
				to_chat(owner, "<B>目标 #[count]</B>: [objective.explanation_text] <span class='redtext'>失败。</span>")
				traitorwin = FALSE
			count += objective.triumph_count
	var/special_role_text = "死亡骑士"
	if(traitorwin)
		if(count)
			if(owner)
				owner.adjust_triumphs(count)
		to_chat(world, span_greentext("[special_role_text]凯旋了！"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, span_redtext("[special_role_text]失败了！"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)
