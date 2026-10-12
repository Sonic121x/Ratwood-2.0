// 独立实例与来源，避免影响其他特质的效果。
/datum/status_effect/z121_ethos
	duration = -1
	tick_interval = -1
	needs_processing = FALSE
	alert_type = null

/datum/status_effect/z121_ethos/pride
	id = "z121_ethos_pride"
	effectedstats = list(STATKEY_WIL = -1)

/datum/status_effect/z121_ethos/greed
	id = "z121_ethos_greed"
	effectedstats = list(STATKEY_WIL = -1)

/datum/status_effect/z121_ethos/lust
	id = "z121_ethos_lust"
	effectedstats = list(STATKEY_PER = -1)

/datum/status_effect/z121_ethos/envy
	id = "z121_ethos_envy"
	effectedstats = list(STATKEY_WIL = -1)

/datum/status_effect/z121_ethos/wrath
	id = "z121_ethos_wrath"
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = -2)

/datum/status_effect/z121_ethos/sloth
	id = "z121_ethos_sloth"
	effectedstats = list(STATKEY_SPD = -1)

/datum/status_effect/z121_ethos/chastity
	id = "z121_ethos_chastity"
	effectedstats = list(STATKEY_WIL = 1)

/datum/status_effect/z121_ethos/patience
	id = "z121_ethos_patience"
	effectedstats = list(STATKEY_WIL = 1)

/datum/status_effect/z121_ethos/pain_compensation
	id = "z121_ethos_pain_compensation"

/datum/status_effect/z121_ethos/pain_compensation/on_creation(mob/living/new_owner, compensation)
	effectedstats = list(STATKEY_LCK = compensation)
	return ..()

/datum/stressevent/z121_ethos
	timer = INFINITY
	max_stacks = 1

/datum/stressevent/z121_ethos/pride
	stressadd = 4
	desc = "颜面扫地：他们看见了我的狼狈。"

/datum/stressevent/z121_ethos/greed
	stressadd = 3
	desc = "钱囊太轻，我无法安心。"

/datum/stressevent/z121_ethos/lust
	stressadd = 3
	desc = "欲望让我难以专心。"

/datum/stressevent/z121_ethos/envy
	stressadd = 3
	desc = "他人的光芒刺痛了我。"

/datum/stressevent/z121_ethos/gluttony
	stressadd = 3
	desc = "我还没有吃够。"

/datum/stressevent/z121_ethos/wrath
	stressadd = 4
	desc = "我怒火中烧。"

/datum/stressevent/z121_ethos/humility
	stressadd = -2
	desc = "我接受了他人的帮助。"

/datum/stressevent/z121_ethos/charity
	stressadd = -3
	desc = "分享使人充实。"

/datum/stressevent/z121_ethos/kindness
	stressadd = -2
	desc = "我们照料着彼此。"

/datum/stressevent/z121_ethos/temperance
	stressadd = -2
	desc = "适量即可，我很满足。"

/datum/stressevent/z121_ethos/diligence
	stressadd = -2
	desc = "劳动让我踏实。"

/datum/stressevent
	var/z121_ethos_original_timer
	var/z121_ethos_original_end
	var/z121_ethos_shortened_end
	var/z121_ethos_shortened = FALSE
	var/z121_ethos_social_timer

/mob/living/carbon/human/proc/z121_ethos_adjust_stress(datum/stressevent/E)
	var/datum/z121_ethos/R = z121_get_ethos()
	if(!E || !R || E.type == /datum/stressevent/z121_ethos/pride)
		return E
	if(R.virtues["kindness"] && E.stressadd < 0 && E.timer > 0 && E.timer < INFINITY && !istype(E, /datum/stressevent/z121_ethos) && z121_ethos_social_event(E.type))
		if(isnull(E.z121_ethos_social_timer))
			E.z121_ethos_social_timer = E.timer
		E.timer = E.z121_ethos_social_timer * 1.25
	if(R.virtues["chastity"] && !R.chastity_lost && world.time >= R.chastity_since + 20 MINUTES && E.stressadd > 0 && E.timer > 0 && E.timer < INFINITY)
		if(!E.z121_ethos_shortened)
			E.z121_ethos_original_timer = E.timer
			E.z121_ethos_shortened = TRUE
		E.timer = E.z121_ethos_original_timer * 0.85
		E.z121_ethos_original_end = E.time_added + E.z121_ethos_original_timer
		E.z121_ethos_shortened_end = E.time_added + E.timer
		R.shortened_moods[E.type] = list("original" = E.z121_ethos_original_end, "actual" = E.z121_ethos_shortened_end, "timer" = E.z121_ethos_original_timer, "shortened" = TRUE)
	else
		// 破戒后重新发生的同类心情是新周期，不能沿用旧结束时间。
		R.shortened_moods -= E.type
		E.z121_ethos_original_timer = null
		E.z121_ethos_original_end = null
		E.z121_ethos_shortened_end = null
		E.z121_ethos_shortened = FALSE
	return E

/datum/status_effect/z121_ethos/pride/on_remove()
	var/mob/living/carbon/human/H = ishuman(owner) ? owner : null
	. = ..()
	var/datum/z121_ethos/R = H?.z121_get_ethos()
	if(R && !R.cleaning && R.sins["pride"] && R.pride_until > world.time && !QDELETED(H))
		// 直接删除状态的清理入口也不能改变绝对期限；退出旧删除栈后重建。
		addtimer(CALLBACK(R, TYPE_PROC_REF(/datum/z121_ethos, sync_effects)), 0)

/datum/status_effect/z121_ethos/pride/Destroy(force = FALSE)
	var/mob/living/carbon/human/H = ishuman(owner) ? owner : null
	if(!force && H && !QDELETED(H))
		var/datum/z121_ethos/R = H.z121_get_ethos()
		if(R && !R.cleaning && R.sins["pride"] && R.pride_until > world.time)
			// 普通清理不能制造短暂无属性惩罚的间隙；身体清理与强制删除仍交给引擎。
			return QDEL_HINT_LETMELIVE
	return ..()

/mob/living/carbon/human/remove_status_effect(effect)
	var/datum/z121_ethos/R = z121_get_ethos()
	var/datum/status_effect/template = effect
	if((ispath(effect, /datum/status_effect) || istype(template)) && initial(template.id) == "z121_ethos_pride" && R?.sins["pride"] && R.pride_until > world.time && !R.cleaning)
		return FALSE
	return ..()

// 本分支疼痛的属性代价来自压力档位的幸运惩罚；仅补偿疼痛新增的那一部分。
/proc/z121_ethos_mood_penalty(mob/living/carbon/human/H, stress)
	switch(get_stress_threshold(stress))
		if(STRESS_THRESHOLD_STRESSED)
			return 1
		if(STRESS_THRESHOLD_STRESSED_BAD)
			return HAS_TRAIT(H, TRAIT_EORAN_CALM) || HAS_TRAIT(H, TRAIT_EORAN_SERENE) ? 0 : 2
		if(STRESS_THRESHOLD_FREAKING_OUT)
			return 2
	return 0

/datum/z121_ethos/proc/sync_pain_compensation()
	var/compensation = 0
	var/datum/stressevent/pain = body.get_stress_event(/datum/stressevent/painmax)
	if(virtues["patience"] && pain && pain.time_added + pain.timer > world.time)
		var/total = body.get_stress_amount()
		// 使用同一个压力结算入口，保留意志、翻倍和伊欧拉特性的规则。
		var/list/with_pain = body.stressors
		body.stressors = with_pain.Copy()
		body.stressors -= /datum/stressevent/painmax
		var/without_pain
		try
			without_pain = body.get_stress_amount()
		catch(var/exception/error)
			body.stressors = with_pain
			throw error
		body.stressors = with_pain
		compensation = max(0, z121_ethos_mood_penalty(body, total) - z121_ethos_mood_penalty(body, without_pain)) * 0.2
	var/datum/status_effect/current = body.has_status_effect(/datum/status_effect/z121_ethos/pain_compensation)
	if(current && current.effectedstats[STATKEY_LCK] == compensation)
		return
	body.remove_status_effect(/datum/status_effect/z121_ethos/pain_compensation)
	if(compensation)
		body.apply_status_effect(/datum/status_effect/z121_ethos/pain_compensation, compensation)

// 只列社交来源的正面心情；食物、药物、劳动等不因此延长。
/proc/z121_ethos_social_event(path)
	var/static/list/social = list(/datum/stressevent/joke, /datum/stressevent/tragedy, /datum/stressevent/blessed, /datum/stressevent/fresh_haircut, /datum/stressevent/music, /datum/stressevent/pretty, /datum/stressevent/noble_bowed_to, /datum/stressevent/noble_bowed_at, /datum/stressevent/eoran_blessing, /datum/stressevent/eoran_blessing_greater, /datum/stressevent/sermon, /datum/stressevent/goodloving, /datum/stressevent/empathic_bond_formed, /datum/stressevent/proximity_comfort)
	for(var/parent_path in social)
		if(ispath(path, parent_path))
			return TRUE
	return FALSE

