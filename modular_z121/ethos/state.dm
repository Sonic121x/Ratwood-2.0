// 角色记录不参与死亡回归的身体快照，避免需求/破戒标记被回滚。
/datum/mind
	var/datum/z121_ethos/z121_ethos

/mob/living/carbon/human
	var/datum/z121_ethos/z121_ethos_body

/mob/living/carbon/human/proc/z121_get_ethos(create = FALSE)
	RETURN_TYPE(/datum/z121_ethos)
	// 清理旧身体时允许原记录完成移除，不能在移除入口再次绑定身体。
	if(z121_ethos_body?.cleaning)
		return z121_ethos_body
	var/datum/z121_ethos/record = mind?.z121_ethos
	if(!record && z121_ethos_body)
		var/datum/z121_ethos/attached = z121_ethos_body
		// 无主身体不能替另一名角色认领记录；新入住者须有自己的记录。
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
	var/list/mood_base_ends = list()
	var/list/mood_sources = list()
	var/list/mood_recipients = list()
	var/list/timed_mood_cycles = list()
	var/list/timed_mood_ends = list()
	var/list/shortened_moods = list()
	var/list/ethos_cooldowns = list()
	var/list/envy_targets = list()
	var/born_at
	var/last_check
	var/last_sample
	var/was_awake = FALSE
	var/adult_was_enabled = FALSE
	var/lust_elapsed = 0
	var/sloth_elapsed = 0
	var/last_move = 0
	var/last_combat = -600
	var/last_attack = -600
	var/last_attacked = -600
	var/pride_used = FALSE
	var/pride_until = 0
	var/wrath_until = 0
	var/patience_until = 0
	var/patience_pending = FALSE
	var/patience_since = 0
	var/envy_until = 0
	var/envy_alone = 0
	var/sloth_rest = 0
	var/wrath_rest = 0
	var/glutton_hungry = FALSE
	var/envy_skill
	var/envy_ready = FALSE
	var/chastity_since = 0
	var/chastity_lost = FALSE
	var/cleaning = FALSE

/datum/z121_ethos/New(mob/living/carbon/human/H)
	born_at = world.time
	last_sample = world.time
	character = H.mind
	if(character)
		character.z121_ethos = src
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
	if(transfer_host)
		UnregisterSignal(transfer_host, COMSIG_MIND_TRANSFER)
		transfer_host = null
	if(body == H)
		return
	if(H?.z121_ethos_body && H.z121_ethos_body != src)
		H.z121_ethos_body.bind(null)
	if(body && !QDELETED(body))
		sample_activity()
		UnregisterSignal(body, list(COMSIG_MOVABLE_MOVED, COMSIG_MIND_TRANSFER, COMSIG_MOB_EXAMINATE, COMSIG_MOB_STATCHANGE, COMSIG_MOB_ITEM_ATTACK, COMSIG_MOB_ITEM_BEING_ATTACKED))
		for(var/path in subtypesof(/datum/virtue/z121_virtue))
			var/datum/virtue/z121_virtue/V = GLOB.virtues[path]
			UnregisterSignal(body, SIGNAL_REMOVETRAIT(z121_ethos_trait(V.ethos_id)))
		cleaning = TRUE
		clear_body_effects()
		for(var/id in virtues)
			REMOVE_TRAIT(body, z121_ethos_trait(id), "z121_ethos")
		body.z121_ethos_body = null
		cleaning = FALSE
	body = H
	last_sample = world.time
	was_awake = FALSE
	envy_alone = 0
	sloth_rest = 0
	wrath_rest = 0
	if(!H)
		return
	H.z121_ethos_body = src
	RegisterSignal(H, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(H, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))
	RegisterSignal(H, COMSIG_MOB_EXAMINATE, PROC_REF(on_examinate))
	RegisterSignal(H, COMSIG_MOB_STATCHANGE, PROC_REF(on_consciousness_changed))
	RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_item_attack))
	RegisterSignal(H, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(on_item_being_attacked))
	for(var/path in subtypesof(/datum/virtue/z121_virtue))
		var/datum/virtue/z121_virtue/V = GLOB.virtues[path]
		RegisterSignal(H, SIGNAL_REMOVETRAIT(z121_ethos_trait(V.ethos_id)), PROC_REF(on_trait_removed))
	for(var/id in virtues)
		ADD_TRAIT(H, z121_ethos_trait(id), "z121_ethos")
	reconcile_stress()
	reconcile_social()
	sync_effects()

/datum/z121_ethos/proc/on_transfer(mob/source, mob/destination)
	SIGNAL_HANDLER
	bind(ishuman(destination) ? destination : null)
	if(destination && !ishuman(destination))
		transfer_host = destination
		RegisterSignal(destination, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))

/datum/z121_ethos/proc/on_trait_removed(datum/source, trait)
	SIGNAL_HANDLER
	if(cleaning)
		return
	for(var/id in virtues.Copy())
		if(trait == z121_ethos_trait(id) && !HAS_TRAIT(body, trait))
			set_virtue(id, FALSE)

/datum/z121_ethos/proc/on_moved()
	SIGNAL_HANDLER
	last_move = world.time
	sloth_rest = 0
	wrath_rest = 0

// 挥击即使被格挡，也属于主动攻击；治疗和无伤害意图不计入。
/datum/z121_ethos/proc/on_item_attack(datum/source, mob/target, mob/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(user == body && z121_ethos_hostile_item(user, weapon))
		attacking()

// 核心在格挡判定前发送此信号；格挡、闪避也必须中断休息并延续冲突。
/datum/z121_ethos/proc/on_item_being_attacked(datum/source, mob/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(target == body && user != body && z121_ethos_hostile_item(user, weapon))
		attacked()

/datum/z121_ethos/proc/on_consciousness_changed()
	SIGNAL_HANDLER
	sample_activity()
	reset_continuous_conditions()

// 意识变化当刻结清上一段，三秒轮询只负责连续条件及常规效果同步。
/datum/z121_ethos/proc/sample_activity()
	var/elapsed = was_awake ? max(world.time - last_sample, 0) : 0
	if(sins["lust"] && adult_was_enabled)
		lust_elapsed += elapsed
	if(sins["sloth"])
		sloth_elapsed += elapsed
	last_sample = world.time
	was_awake = body && body.stat == CONSCIOUS && !body.IsSleeping() && (!character || character.current == body)
	adult_was_enabled = adult_enabled()
	return was_awake ? elapsed : 0

/datum/z121_ethos/proc/reset_continuous_conditions()
	envy_alone = 0
	sloth_rest = 0
	wrath_rest = 0

/datum/z121_ethos/proc/set_sin(id, enabled)
	if(enabled && !z121_ethos_can_receive_sin(body, id))
		return FALSE
	if(enabled)
		sins[id] = TRUE
	else
		sins -= id
		switch(id)
			if("pride")
				pride_until = 0
			if("envy")
				envy_until = 0
			if("wrath")
				wrath_until = 0
	sync_effects()
	return TRUE

/datum/z121_ethos/proc/set_virtue(id, enabled)
	if(enabled && id == "chastity" && chastity_lost)
		return FALSE
	if(enabled && (!body || body.has_flaw(z121_ethos_opposite_sin(id)) || sins[z121_ethos_paired_id(id)]))
		return FALSE
	if(enabled)
		if(virtues[id])
			return TRUE
		virtues[id] = TRUE
		if(id == "chastity")
			chastity_since = world.time
		ADD_TRAIT(body, z121_ethos_trait(id), "z121_ethos")
	else
		virtues -= id
		cleaning = TRUE
		REMOVE_TRAIT(body, z121_ethos_trait(id), "z121_ethos")
		cleaning = FALSE
		if(id == "chastity")
			restore_stress_timers()
		if(id == "patience")
			patience_until = 0
			patience_pending = FALSE
		clear_given_moods(id)
		if(id == "kindness")
			reconcile_social()
	sync_effects()
	return TRUE

/datum/z121_ethos/proc/break_chastity()
	if(!virtues["chastity"])
		return
	chastity_lost = TRUE
	set_virtue("chastity", FALSE)
	to_chat(body, span_warning("自主之誓已破：你永久失去了本局的贞洁美德，凯旋不会返还。"))

/datum/z121_ethos/proc/adult_enabled()
	return z121_ethos_adult_enabled(body)

/datum/z121_ethos/process()
	if(character && QDELETED(character))
		qdel(src)
		return PROCESS_KILL
	if(character && character.current != body)
		if(ishuman(character.current))
			bind(character.current)
		else if(body)
			bind(null)
	if(!body || QDELETED(body))
		if(!character)
			qdel(src)
			return PROCESS_KILL
		return
	if(world.time < last_check + 3 SECONDS)
		return
	last_check = world.time
	var/awake = body.stat == CONSCIOUS && !body.IsSleeping() && (!character || character.current == body)
	var/elapsed = sample_activity()
	if(!awake)
		reset_continuous_conditions()
	if(awake)
		if(sins["envy"] && envy_until > world.time)
			var/alone = TRUE
			for(var/mob/living/carbon/human/H in view(body))
				if(H != body && H.stat == CONSCIOUS && !H.IsSleeping())
					alone = FALSE
					break
			envy_alone = alone ? envy_alone + elapsed : 0
			if(envy_alone >= 30 SECONDS)
				envy_until = 0
		var/resting = (body.resting || istype(body.buckled, /obj/structure/chair) || body.lying) && last_move < last_sample - elapsed
		if(resting && world.time >= last_combat + 3 SECONDS)
			sloth_rest += elapsed
			if(sloth_rest >= 45 SECONDS)
				sloth_elapsed = 0
			if(!body.cmode)
				wrath_rest += elapsed
				if(wrath_rest >= 10 SECONDS)
					wrath_until = 0
			else
				wrath_rest = 0
		else
			sloth_rest = 0
			wrath_rest = 0
		if(patience_pending && world.time >= patience_since + 10 SECONDS && ready("patience"))
			patience_pending = FALSE
			if(virtues["patience"] && ready("patience"))
				patience_until = world.time + 30 SECONDS
				ethos_cooldowns["patience"] = world.time + 60 SECONDS
	if(world.time >= last_combat + 60 SECONDS)
		pride_used = FALSE
	if(sins["envy"] && envy_ready && !envy_skill)
		lock_envy_skill()
	// 死亡回归可能恢复旧特性标签；不可恢复已经破戒的贞洁。
	if(chastity_lost && HAS_TRAIT(body, z121_ethos_trait("chastity")))
		REMOVE_TRAIT(body, z121_ethos_trait("chastity"), TRAIT_VIRTUE)
		REMOVE_TRAIT(body, z121_ethos_trait("chastity"), "z121_ethos")
	sync_effects()

/datum/z121_ethos/proc/ready(id)
	return world.time >= ethos_cooldowns[id]

/datum/z121_ethos/proc/lock_envy_skill()
	if(!body || !envy_ready || envy_skill || !sins["envy"])
		return
	var/best = -1
	for(var/datum/skill/S as anything in SSskills.all_skills)
		var/level = body.get_skill_level(S.type)
		if(level > best)
			best = level
			envy_skill = S.type

/datum/z121_ethos/proc/finish_envy_initialization()
	if(body && (body.z121_ethos_birth_ready || !SSjob.GetJob(body.mind?.assigned_role)))
		envy_ready = TRUE
		lock_envy_skill()

/datum/z121_ethos/proc/on_examinate(mob/source, atom/target)
	SIGNAL_HANDLER
	if(!sins["envy"] || !ishuman(target) || target == body)
		return
	var/mob/living/carbon/human/H = target
	if(!H.client || body.stat != CONSCIOUS)
		return
	lock_envy_skill()
	var/key = H.mind ? REF(H.mind) : REF(H)
	if(world.time < envy_targets[key] || !envy_skill || H.get_skill_level(envy_skill) < body.get_skill_level(envy_skill) + 2)
		return
	envy_targets[key] = world.time + 10 MINUTES
	envy_until = world.time + 3 MINUTES
	envy_alone = 0
	sync_effects()

/datum/z121_ethos/proc/attacked(actual_damage = 0)
	if(world.time >= last_combat + 60 SECONDS)
		pride_used = FALSE
	last_attacked = world.time
	last_combat = world.time
	sloth_rest = 0
	wrath_rest = 0
	if(virtues["patience"] && !patience_pending)
		patience_pending = TRUE
		patience_since = world.time
	if(sins["wrath"] && actual_damage >= 10 && ready("wrath"))
		wrath_until = world.time + 20 SECONDS
		ethos_cooldowns["wrath"] = world.time + 60 SECONDS
	sync_effects()

/datum/z121_ethos/proc/attacking()
	if(world.time >= last_combat + 60 SECONDS)
		pride_used = FALSE
	last_attack = world.time
	last_combat = world.time
	sloth_rest = 0
	wrath_rest = 0
	// 反击中断连续克制，保留本次受击记录并重新等待十秒。
	if(patience_pending)
		patience_since = world.time

/datum/z121_ethos/proc/fallen()
	if(!sins["pride"] || pride_used)
		return
	pride_used = TRUE
	pride_until = max(pride_until, world.time + 3 MINUTES)
	sync_effects()

/datum/z121_ethos/proc/on_satisfaction(actual_activity = FALSE)
	SIGNAL_HANDLER
	// 不接受通用信号本身：仅动作实际执行的调用栈可重置色欲。
	if(actual_activity && sins["lust"] && adult_enabled())
		sample_activity()
		lust_elapsed = 0
		sync_effects()

/datum/z121_ethos/proc/experience(skill, amount, teaching = FALSE)
	if(amount <= 0)
		return amount
	var/path = ispath(skill) ? skill : skill:type
	var/multiplier = 1
	if(teaching && virtues["humility"])
		multiplier *= 1.3
	if(virtues["diligence"] && !body.z121_ethos_no_labor && z121_ethos_labor_skill(path))
		multiplier *= 1.2
	return amount * multiplier

/datum/z121_ethos/proc/experience_settled(skill, before, after, labor = TRUE)
	if(after <= before || !body)
		return
	var/path = ispath(skill) ? skill : skill:type
	if(sins["envy"] && path == envy_skill)
		envy_until = 0
	if(labor && virtues["diligence"] && !body.z121_ethos_no_labor && !body.z121_ethos_teaching && z121_ethos_labor_skill(path))
		social_mood(body, /datum/stressevent/z121_ethos/diligence, 5 MINUTES)
	sync_effects()

/datum/z121_ethos/proc/social_mood(mob/living/carbon/human/H, path, duration)
	var/datum/z121_ethos/R = H.z121_get_ethos(TRUE)
	R.mood_base_ends[path] = world.time + duration
	if(R.virtues["kindness"] && path != /datum/stressevent/z121_ethos/diligence)
		duration *= 1.25
	R.mood_ends[path] = world.time + duration
	R.mood_sources[path] = WEAKREF(src)
	mood_recipients[REF(R)] = WEAKREF(R)
	R.sync_mood(path, world.time + duration)

/datum/z121_ethos/proc/treated(mob/living/carbon/human/healer)
	if(!healer || healer == body || !healer.client || !body.client)
		return
	if(virtues["humility"] && ready("humility"))
		ethos_cooldowns["humility"] = world.time + 5 MINUTES
		social_mood(body, /datum/stressevent/z121_ethos/humility, 3 MINUTES)
	var/datum/z121_ethos/R = healer.z121_get_ethos()
	if(R?.virtues["kindness"] && R.ready("kindness"))
		R.ethos_cooldowns["kindness"] = world.time + 5 MINUTES
		R.social_mood(body, /datum/stressevent/z121_ethos/kindness, 5 MINUTES)
		R.social_mood(healer, /datum/stressevent/z121_ethos/kindness, 5 MINUTES)

/datum/z121_ethos/proc/sync_mood(path, until)
	if(!body)
		return
	if(until <= world.time)
		body.remove_stress(path)
		timed_mood_cycles -= path
		timed_mood_ends -= path
		return
	var/new_cycle = timed_mood_cycles[path] != until
	if(!new_cycle && timed_mood_ends[path] <= world.time)
		body.remove_stress(path)
		return
	var/datum/stressevent/E = body.get_stress_event(path)
	if(!E)
		E = body.add_stress(path)
	if(E)
		if(new_cycle)
			E.timer = until - world.time
			E.time_added = world.time
			E.z121_ethos_shortened = FALSE
			body.z121_ethos_adjust_stress(E)
			timed_mood_cycles[path] = until
			timed_mood_ends[path] = E.time_added + E.timer
		else
			// 换体或效果重建沿用既定结束时间，不能再次缩短或重新刷新。
			E.timer = timed_mood_ends[path] - world.time
			E.time_added = world.time
			if(timed_mood_ends[path] < until)
				E.z121_ethos_original_timer = until - world.time
				E.z121_ethos_original_end = until
				E.z121_ethos_shortened = TRUE

/datum/z121_ethos/proc/toggle_effect(path, enabled)
	if(!body)
		return
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
	var/proud = sins["pride"] && pride_until > world.time
	toggle_effect(/datum/status_effect/z121_ethos/pride, proud)
	sync_mood(/datum/stressevent/z121_ethos/pride, proud ? pride_until : 0)
	sync_greed()
	var/lusting = sins["lust"] && adult_enabled() && lust_elapsed >= 30 MINUTES
	toggle_effect(/datum/status_effect/z121_ethos/lust, lusting)
	toggle_mood(/datum/stressevent/z121_ethos/lust, lusting)
	var/envious = sins["envy"] && envy_until > world.time
	toggle_effect(/datum/status_effect/z121_ethos/envy, envious)
	sync_mood(/datum/stressevent/z121_ethos/envy, envious ? envy_until : 0)
	if(body.nutrition < 700)
		glutton_hungry = TRUE
	else if(body.nutrition >= 800)
		glutton_hungry = FALSE
	toggle_mood(/datum/stressevent/z121_ethos/gluttony, sins["gluttony"] && !HAS_TRAIT(body, TRAIT_NOHUNGER) && glutton_hungry)
	var/angry = sins["wrath"] && wrath_until > world.time
	toggle_effect(/datum/status_effect/z121_ethos/wrath, angry)
	sync_mood(/datum/stressevent/z121_ethos/wrath, angry ? wrath_until : 0)
	toggle_effect(/datum/status_effect/z121_ethos/sloth, sins["sloth"] && sloth_elapsed >= 15 MINUTES)
	toggle_effect(/datum/status_effect/z121_ethos/chastity, virtues["chastity"] && !chastity_lost && world.time >= chastity_since + 20 MINUTES)
	toggle_effect(/datum/status_effect/z121_ethos/patience, virtues["patience"] && patience_until > world.time)
	sync_pain_compensation()
	toggle_mood(/datum/stressevent/z121_ethos/temperance, virtues["temperance"] && body.nutrition >= 350 && body.nutrition <= 800)
	for(var/path in mood_ends.Copy())
		sync_mood(path, mood_ends[path])
		if(mood_ends[path] <= world.time)
			mood_ends -= path
			mood_base_ends -= path
			mood_sources -= path

/datum/z121_ethos/proc/clear_body_effects()
	for(var/path in subtypesof(/datum/status_effect/z121_ethos))
		body.remove_status_effect(path)
	for(var/path in subtypesof(/datum/stressevent/z121_ethos))
		body.remove_stress(path)
	// 只还原旧身体；角色仍持有贞洁，角色的绝对结束时间必须保留。
	restore_stress_timers(FALSE)
	reconcile_social(TRUE)

/datum/z121_ethos/proc/remove_social_mood(path)
	mood_ends -= path
	mood_base_ends -= path
	mood_sources -= path
	timed_mood_cycles -= path
	timed_mood_ends -= path
	body?.remove_stress(path)

// 只清理由本角色对应美德发出的事件，不能清掉另一位玩家的奖励。
/datum/z121_ethos/proc/clear_given_moods(id)
	var/path
	switch(id)
		if("humility")
			path = /datum/stressevent/z121_ethos/humility
		if("charity")
			path = /datum/stressevent/z121_ethos/charity
		if("kindness")
			path = /datum/stressevent/z121_ethos/kindness
		if("diligence")
			path = /datum/stressevent/z121_ethos/diligence
	if(!path)
		return
	for(var/key in mood_recipients.Copy())
		var/datum/weakref/recipient_ref = mood_recipients[key]
		var/datum/z121_ethos/R = recipient_ref.resolve()
		if(!R)
			mood_recipients -= key
			continue
		var/datum/weakref/source_ref = R.mood_sources[path]
		if(source_ref?.resolve() == src)
			R.remove_social_mood(path)

/datum/z121_ethos/proc/reconcile_social(leaving_body = FALSE)
	if(!body)
		return
	for(var/path in body.stressors.Copy())
		var/datum/stressevent/E = body.stressors[path]
		if(!isnull(E.z121_ethos_social_timer))
			E.timer = E.z121_ethos_social_timer * (virtues["kindness"] && !leaving_body ? 1.25 : 1)
			if(E.time_added + E.timer <= world.time)
				body.remove_stress(path)
	if(!virtues["kindness"] && !leaving_body)
		for(var/path in mood_base_ends.Copy())
			if(mood_ends[path] > mood_base_ends[path])
				mood_ends[path] = mood_base_ends[path]
				sync_mood(path, mood_ends[path])

/datum/z121_ethos/proc/restore_stress_timers(update_record = TRUE)
	if(!body)
		return
	for(var/path in body.stressors.Copy())
		var/datum/stressevent/E = body.stressors[path]
		if(E.z121_ethos_shortened)
			if(E.time_added + E.timer <= world.time)
				body.remove_stress(path)
				continue
			E.timer = E.z121_ethos_original_end - E.time_added
			E.z121_ethos_shortened = FALSE
			if(update_record && shortened_moods[path])
				var/list/history = shortened_moods[path]
				history["actual"] = E.z121_ethos_original_end
				history["shortened"] = FALSE
			if(update_record && timed_mood_cycles[path] == E.z121_ethos_original_end)
				timed_mood_ends[path] = E.z121_ethos_original_end

// 回归快照不能把本局已经结束的缩时心情重新施加，也不能回滚破戒。
/datum/z121_ethos/proc/reconcile_stress()
	if(!body)
		return
	for(var/path in body.stressors.Copy())
		var/datum/stressevent/E = body.stressors[path]
		// 新发生且未缩时的事件不能被同类型旧快照的历史记录覆盖。
		if(!E.z121_ethos_original_end && !E.z121_ethos_shortened)
			continue
		var/list/history = shortened_moods[path]
		if(!history)
			if(!E.z121_ethos_shortened)
				continue
			history = list("original" = E.z121_ethos_original_end, "actual" = E.z121_ethos_shortened_end, "timer" = E.z121_ethos_original_timer, "shortened" = TRUE)
			shortened_moods[path] = history
		if(history["actual"] <= world.time)
			body.remove_stress(path)
			continue
		if(!virtues["chastity"] || chastity_lost)
			history["actual"] = history["original"]
			history["shortened"] = FALSE
		E.time_added = world.time
		E.timer = history["actual"] - world.time
		E.z121_ethos_original_timer = history["timer"]
		E.z121_ethos_original_end = history["original"]
		E.z121_ethos_shortened_end = history["actual"]
		E.z121_ethos_shortened = history["shortened"]

/proc/z121_ethos_money(mob/living/carbon/human/H)
	var/total = 0
	for(var/obj/item/roguecoin/C in H.GetAllContents())
		if(!QDELETED(C))
			total += C.get_real_price()
	return total

/proc/z121_ethos_labor_skill(path)
	return ispath(path, /datum/skill/craft) || ispath(path, /datum/skill/labor)

/proc/z121_ethos_trait(id)
	var/static/list/names = list("humility" = "谦逊", "charity" = "慷慨", "chastity" = "贞洁", "kindness" = "仁爱", "temperance" = "节制", "patience" = "忍耐", "diligence" = "勤勉")
	return "七德：[names[id]]"

