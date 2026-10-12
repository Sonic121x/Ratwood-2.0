// 本局记录跟随 mind；身体快照不能回滚色欲计时或贞洁失效标记。
/datum/mind
	var/datum/z121_ethos/z121_ethos

/mob/living/carbon/human
	var/datum/z121_ethos/z121_ethos_body

/mob/living/carbon/human/proc/z121_get_ethos(create = FALSE)
	RETURN_TYPE(/datum/z121_ethos)
	if(z121_ethos_body?.cleaning)
		return z121_ethos_body
	var/datum/z121_ethos/record = mind?.z121_ethos
	if(!record && z121_ethos_body)
		var/datum/z121_ethos/attached = z121_ethos_body
		if(attached.character && attached.character != mind)
			attached.bind(null)
		else
			record = attached
	if(!record && create)
		record = new(src)
	if(record && mind && !mind.z121_ethos)
		mind.z121_ethos = record
		record.character = mind
	if(record && record.body != src)
		record.bind(src)
	return record

/datum/z121_ethos
	var/datum/mind/character
	var/mob/living/carbon/human/body
	var/mob/transfer_host
	var/list/sins = list()
	var/list/virtues = list()
	var/list/mood_ends = list()
	var/last_check = 0
	var/last_sample
	var/lust_elapsed
	var/chastity_lost = FALSE
	var/glutton_hungry = FALSE
	var/cleaning = FALSE
	var/effects_active = FALSE

/datum/z121_ethos/New(mob/living/carbon/human/H)
	character = H.mind
	if(character)
		character.z121_ethos = src
	last_sample = world.time
	bind(H)
	START_PROCESSING(SSprocessing, src)

/datum/z121_ethos/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(character?.z121_ethos == src)
		character.z121_ethos = null
	bind(null)
	character = null
	return ..()

/datum/z121_ethos/proc/bind(mob/living/carbon/human/H)
	if(QDELETED(H))
		H = null
	if(transfer_host)
		UnregisterSignal(transfer_host, COMSIG_MIND_TRANSFER)
		transfer_host = null
	if(body == H)
		return
	if(H?.z121_ethos_body && H.z121_ethos_body != src)
		H.z121_ethos_body.bind(null)
	if(body && !QDELETED(body))
		capture_moods()
		UnregisterSignal(body, COMSIG_MIND_TRANSFER)
		for(var/id in z121_ethos_virtue_ids())
			UnregisterSignal(body, SIGNAL_REMOVETRAIT(z121_ethos_trait(id)))
		UnregisterSignal(body, SIGNAL_REMOVETRAIT(z121_ethos_chastity_lost_trait()))
		clear_body_effects()
		cleaning = TRUE
		for(var/id in z121_ethos_virtue_ids())
			REMOVE_TRAIT(body, z121_ethos_trait(id), "z121_ethos")
		REMOVE_TRAIT(body, z121_ethos_chastity_lost_trait(), "z121_ethos")
		cleaning = FALSE
		body.z121_ethos_body = null
	body = H
	effects_active = FALSE
	glutton_hungry = FALSE
	if(!H)
		return
	H.z121_ethos_body = src
	RegisterSignal(H, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))
	for(var/id in z121_ethos_virtue_ids())
		RegisterSignal(H, SIGNAL_REMOVETRAIT(z121_ethos_trait(id)), PROC_REF(on_trait_removed))
	RegisterSignal(H, SIGNAL_REMOVETRAIT(z121_ethos_chastity_lost_trait()), PROC_REF(on_trait_removed))
	sync_traits()
	sync_effects()

/datum/z121_ethos/proc/on_transfer(mob/source, mob/destination)
	SIGNAL_HANDLER
	bind(ishuman(destination) ? destination : null)
	if(destination && !ishuman(destination))
		transfer_host = destination
		RegisterSignal(destination, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))

/datum/z121_ethos/proc/on_trait_removed(datum/source, trait)
	SIGNAL_HANDLER
	if(cleaning || body?.z121_return_changing_traits)
		return
	for(var/id in virtues.Copy())
		if((trait == z121_ethos_trait(id) || (id == "chastity" && trait == z121_ethos_chastity_lost_trait())) && !HAS_TRAIT(body, trait))
			set_virtue(id, FALSE)

/datum/z121_ethos/proc/sync_traits()
	if(!body || QDELETED(body))
		return
	cleaning = TRUE
	for(var/id in z121_ethos_virtue_ids())
		if(virtues[id] && !(id == "chastity" && chastity_lost))
			ADD_TRAIT(body, z121_ethos_trait(id), "z121_ethos")
		else
			REMOVE_TRAIT(body, z121_ethos_trait(id), "z121_ethos")
	if(virtues["chastity"] && chastity_lost)
		ADD_TRAIT(body, z121_ethos_chastity_lost_trait(), "z121_ethos")
	else
		REMOVE_TRAIT(body, z121_ethos_chastity_lost_trait(), "z121_ethos")
	cleaning = FALSE

/datum/z121_ethos/proc/set_sin(id, enabled)
	if(enabled && !z121_ethos_can_receive_sin(body, id))
		return FALSE
	sample_clock()
	if(enabled)
		sins[id] = TRUE
		if(id == "lust" && isnull(lust_elapsed))
			lust_elapsed = 0
	else
		sins -= id
		if(id == "envy")
			remove_timed_mood(/datum/stressevent/z121_ethos/envy)
		if(id == "gluttony")
			glutton_hungry = FALSE
	sync_effects()
	return TRUE

/datum/z121_ethos/proc/set_virtue(id, enabled)
	if(enabled && (!body || body.has_flaw(z121_ethos_opposite_sin(id)) || sins[z121_ethos_paired_id(id)]))
		return FALSE
	if(enabled)
		virtues[id] = TRUE
	else
		virtues -= id
		if(id == "charity")
			remove_timed_mood(/datum/stressevent/z121_ethos/charity)
		if(id == "kindness")
			remove_timed_mood(/datum/stressevent/z121_ethos/kindness)
	sync_traits()
	sync_effects()
	return TRUE

// 累计世界时间而非清醒时间；不使用取模时钟或黎明次数。
/datum/z121_ethos/proc/sample_clock()
	if(!isnull(lust_elapsed))
		lust_elapsed = min(24 HOURS, lust_elapsed + max(0, world.time - last_sample) * max(0, SSticker.station_time_rate_multiplier))
	last_sample = world.time

/datum/z121_ethos/proc/on_climax()
	sample_clock()
	if(sins["lust"])
		lust_elapsed = 0
	if(virtues["chastity"] && !chastity_lost)
		chastity_lost = TRUE
		sync_traits()
		to_chat(body, span_warning("自主之誓已失效：本局不再提供意志加成，凯旋不会返还。"))
	sync_effects()

/datum/z121_ethos/process()
	if(character && QDELETED(character))
		qdel(src)
		return PROCESS_KILL
	if(world.time < last_check + 3 SECONDS)
		return
	last_check = world.time
	sample_clock()
	if(character && character.current != body)
		bind(ishuman(character.current) ? character.current : null)
	else if(body && !character && body.mind)
		body.z121_get_ethos()
	if(!body || QDELETED(body))
		if(!character)
			qdel(src)
			return PROCESS_KILL
		return
	sync_effects()

/datum/z121_ethos/proc/on_examinate(mob/living/carbon/human/target)
	if(!sins["envy"] || !body || body.stat != CONSCIOUS || target == body || !target.client || target.stat == DEAD)
		return
	for(var/datum/skill/S as anything in SSskills.all_skills)
		if(target.get_skill_level(S.type) >= body.get_skill_level(S.type) + 2)
			grant_mood(/datum/stressevent/z121_ethos/envy)
			return

/datum/z121_ethos/proc/grant_mood(path)
	if(!body || body.stat == DEAD)
		return
	var/datum/stressevent/E = body.add_stress(path)
	if(E)
		E.timer = 3 MINUTES
		mood_ends[path] = E.time_added + E.timer

// 外部正常清除的限时心情不重建；换体和死亡清理前保留仍存在的结束时间。
/datum/z121_ethos/proc/capture_moods()
	if(!effects_active || !body || QDELETED(body))
		return
	for(var/path in mood_ends.Copy())
		if(mood_ends[path] <= world.time || !body.has_stress_event(path))
			remove_timed_mood(path)

/datum/z121_ethos/proc/remove_timed_mood(path)
	mood_ends -= path
	body?.remove_stress(path)

/datum/z121_ethos/proc/toggle_effect(path, enabled)
	if(enabled)
		if(!body.has_status_effect(path))
			body.apply_status_effect(path)
	else
		body.remove_status_effect(path)

/datum/z121_ethos/proc/toggle_mood(path, enabled)
	if(enabled)
		if(!body.has_stress_event(path))
			body.add_stress(path)
	else
		body.remove_stress(path)

/datum/z121_ethos/proc/sync_effects()
	if(!body || QDELETED(body))
		return
	capture_moods()
	if(body.stat == DEAD)
		clear_body_effects()
		effects_active = FALSE
		return
	var/restoring = !effects_active
	effects_active = TRUE
	toggle_mood(/datum/stressevent/z121_ethos/pride, sins["pride"] && body.IsKnockdown())
	toggle_mood(/datum/stressevent/z121_ethos/greed, sins["greed"] && z121_ethos_money(body) < 50)
	toggle_effect(/datum/status_effect/z121_ethos/lust, sins["lust"] && z121_ethos_adult_enabled(body) && lust_elapsed >= 24 HOURS)
	if(body.nutrition < 700)
		glutton_hungry = TRUE
	else if(body.nutrition >= 800)
		glutton_hungry = FALSE
	toggle_mood(/datum/stressevent/z121_ethos/gluttony, sins["gluttony"] && !HAS_TRAIT(body, TRAIT_NOHUNGER) && glutton_hungry)
	toggle_effect(/datum/status_effect/z121_ethos/wrath, sins["wrath"] && body.getBruteLoss() + body.getFireLoss() >= 20)
	toggle_effect(/datum/status_effect/z121_ethos/sloth, sins["sloth"])
	toggle_effect(/datum/status_effect/z121_ethos/humility, virtues["humility"])
	toggle_effect(/datum/status_effect/z121_ethos/chastity, virtues["chastity"] && !chastity_lost)
	toggle_mood(/datum/stressevent/z121_ethos/temperance, virtues["temperance"] && body.nutrition >= 350 && body.nutrition <= 800)
	toggle_mood(/datum/stressevent/z121_ethos/patience, virtues["patience"] && body.stat == CONSCIOUS && !body.IsSleeping() && body.resting && body.lying)
	for(var/path in mood_ends.Copy())
		if(mood_ends[path] <= world.time)
			remove_timed_mood(path)
		else if(restoring)
			var/datum/stressevent/E = body.add_stress(path)
			if(E)
				E.timer = mood_ends[path] - world.time

/datum/z121_ethos/proc/clear_body_effects()
	for(var/path in subtypesof(/datum/status_effect/z121_ethos))
		body.remove_status_effect(path)
	for(var/path in subtypesof(/datum/stressevent/z121_ethos))
		body.remove_stress(path)

/proc/z121_ethos_money(mob/living/carbon/human/H)
	var/total = 0
	for(var/obj/item/roguecoin/C in H.GetAllContents())
		if(!QDELETED(C))
			total += C.get_real_price()
	return total

/proc/z121_ethos_adult_enabled(mob/living/carbon/human/H)
	return H && (H.age in list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)) && H.client?.prefs?.sexable

/proc/z121_ethos_virtue_ids()
	var/static/list/ids = list("humility", "charity", "chastity", "kindness", "temperance", "patience", "diligence")
	return ids

/proc/z121_ethos_trait(id)
	var/static/list/names = list("humility" = "谦逊", "charity" = "慷慨", "chastity" = "贞洁", "kindness" = "仁爱", "temperance" = "节制", "patience" = "忍耐", "diligence" = "勤勉")
	return "七德：[names[id]]"

/proc/z121_ethos_chastity_lost_trait()
	return "七德：贞洁（已失效）"

