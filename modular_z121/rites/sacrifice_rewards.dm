// 新仪式的临时赐福绑定身体、心智和信仰，死亡或改信后不能自动恢复。
/datum/status_effect/z121_sacrifice_blessing
	on_remove_on_mob_delete = TRUE
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = 5 SECONDS
	var/required_patron
	var/datum/mind/receiving_mind

/datum/status_effect/z121_sacrifice_blessing/on_apply()
	if(!ishuman(owner) || !owner.mind || owner.stat == DEAD || owner.patron?.type != required_patron)
		effectedstats = list()
		return FALSE
	// 状态基类会按属性上下限修正列表，因此每个实例必须持有自己的副本。
	effectedstats = effectedstats.Copy()
	. = ..()
	if(!.)
		return FALSE
	receiving_mind = owner.mind
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(lose_blessing))
	RegisterSignal(owner, COMSIG_MIND_TRANSFER, PROC_REF(lose_blessing))

/datum/status_effect/z121_sacrifice_blessing/proc/lose_blessing(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/z121_sacrifice_blessing/proc/holder_valid()
	return !QDELETED(owner) && owner.stat != DEAD && owner.patron?.type == required_patron && owner.mind == receiving_mind

/datum/status_effect/z121_sacrifice_blessing/tick()
	if(!holder_valid())
		qdel(src)

/datum/status_effect/z121_sacrifice_blessing/on_remove()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER))
	receiving_mind = null
	return ..()

// 永久解锁只保存在本回合心智上，身体更换时撤去旧身体上的专属特质。
/datum/mind
	var/datum/z121_sacrifice_unlocks/z121_sacrifice_unlocks

/datum/z121_sacrifice_unlocks
	var/datum/mind/mind_owner
	var/mob/living/carbon/human/current_body
	var/matthios_unlocked = FALSE

/datum/z121_sacrifice_unlocks/New(datum/mind/new_mind)
	mind_owner = new_mind
	mind_owner.z121_sacrifice_unlocks = src
	START_PROCESSING(SSfastprocess, src)

/datum/z121_sacrifice_unlocks/proc/unlock_matthios()
	matthios_unlocked = TRUE
	sync_rewards()

/datum/z121_sacrifice_unlocks/proc/detach_body()
	if(current_body)
		REMOVE_TRAIT(current_body, TRAIT_SEEPRICES, "z121_matthios_sacrifice")
		UnregisterSignal(current_body, COMSIG_MIND_TRANSFER)
	current_body = null

/datum/z121_sacrifice_unlocks/proc/body_transferred(datum/source)
	SIGNAL_HANDLER
	sync_rewards()

/datum/z121_sacrifice_unlocks/proc/sync_rewards()
	if(QDELETED(mind_owner))
		qdel(src)
		return
	var/mob/living/carbon/human/new_body = ishuman(mind_owner.current) ? mind_owner.current : null
	if(current_body != new_body)
		detach_body()
		current_body = new_body
		if(current_body)
			RegisterSignal(current_body, COMSIG_MIND_TRANSFER, PROC_REF(body_transferred))
	if(current_body)
		if(matthios_unlocked && current_body.patron?.type == /datum/patron/inhumen/matthios)
			ADD_TRAIT(current_body, TRAIT_SEEPRICES, "z121_matthios_sacrifice")
		else
			REMOVE_TRAIT(current_body, TRAIT_SEEPRICES, "z121_matthios_sacrifice")
/datum/z121_sacrifice_unlocks/process()
	sync_rewards()

/datum/z121_sacrifice_unlocks/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	detach_body()
	if(mind_owner?.z121_sacrifice_unlocks == src)
		mind_owner.z121_sacrifice_unlocks = null
	mind_owner = null
	return ..()

// 信仰变更立即撤销新增赐福，同时取消尚在进行的献祭。
/mob/living/carbon/human/set_patron(datum/patron/new_patron)
	. = ..()
	// 保留原有人形信仰过程对奉献对象的同步。
	if(. && devotion)
		devotion.patron = new_patron
	if(z121_sacrifice_session && patron?.type != z121_sacrifice_session.circle?.patron_type)
		z121_sacrifice_session.cancelled = TRUE
	for(var/datum/status_effect/z121_sacrifice_blessing/blessing as anything in status_effects?.Copy())
		if(istype(blessing) && blessing.required_patron != patron?.type)
			qdel(blessing)
	mind?.z121_sacrifice_unlocks?.sync_rewards()

// 数值挂钩直接查询当前姿态，避免轮询延迟影响实际疲劳和防御判定。
/mob/living/proc/z121_victory_glow_active()
	return cmode && has_status_effect(/datum/status_effect/buff/victory_glow)

/mob/living/carbon/human/stamina_add(added as num, emote_override, force_emote = TRUE)
	// 仅豁免移动完成后紧随的原生奔跑扣费，保留涉水和碰撞等其他消耗。
	if(z121_dash?.in_step && z121_dash.waive_run_fatigue && added == 2 && isnull(emote_override) && force_emote)
		z121_dash.waive_run_fatigue = FALSE
		return TRUE
	if(added > 0 && z121_victory_glow_active())
		added *= 0.9
	return ..(added, emote_override, force_emote)
