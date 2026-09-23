// 保留原美德路径以兼容角色偏好；内部标记不登记到玩家可见的特性表。
#define TRAIT_Z121_DEATH_RETURN "z121_death_return"

/datum/virtue/utility/never_ending
	name = "死亡回归"
	desc = "晨光曾在你的影子里停留。此后，有些本该落定的句点，便迟迟没有落下。"
	custom_text = null
	triumph_cost = 99
	added_traits = list(TRAIT_Z121_DEATH_RETURN)

/datum/virtue/utility/never_ending/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(recipient)
		recipient.AddComponent(/datum/component/z121_return_entry)

// 入场流程尚可能进行职业选择，必须等角色实际就绪后建立初始存档。
/datum/component/z121_return_entry
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/z121_return_entry/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	addtimer(CALLBACK(src, PROC_REF(process)), 0)

/datum/component/z121_return_entry/proc/on_login()
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(process)), 0)

/datum/component/z121_return_entry/process()
	var/mob/living/carbon/human/H = parent
	if(!HAS_TRAIT(H, TRAIT_Z121_DEATH_RETURN))
		qdel(src)
		return
	if(!H.mind || !H.client || H.advsetup || H.mind.picking || !SSticker.HasRoundStarted())
		return
	H.mind.AddComponent(/datum/component/z121_death_return, H)
	qdel(src)

/datum/component/z121_return_entry/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

// 使用地图清晨划分连续游戏日，不能使用现实时间或会循环的星期编号。
/proc/z121_return_day()
	var/game_time = (world.time - SSticker.round_start_time) * SSticker.station_time_rate_multiplier + SSticker.gametime_offset
	return FLOOR((game_time - SSnightshift.nightshift_dawn_start - 1) / 864000, 1)

// 控制器属于灵魂，躯体删除不会删除存档和已用次数。
/datum/component/z121_death_return
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/human/body
	var/datum/z121_return_snapshot/saved
	var/datum/z121_return_snapshot/pending_save
	var/save_day
	var/used_day = -INFINITY
	var/pending_day
	var/pending = FALSE
	var/restoring = FALSE
	var/destroying_body = FALSE
	var/enabled = TRUE
	var/mob/living/carbon/human/return_origin
	var/mob/living/brain/transfer_brain
	var/list/deferred_deletions = list()

/datum/component/z121_death_return/Initialize(mob/living/carbon/human/H)
	if(!istype(parent, /datum/mind) || !istype(H))
		return COMPONENT_INCOMPATIBLE
	bind_body(H)
	refresh_save()
	START_PROCESSING(SSprocessing, src)

/datum/component/z121_death_return/proc/bind_body(mob/living/carbon/human/H)
	if(body)
		UnregisterSignal(body, list(COMSIG_LIVING_DEATH, COMSIG_MOB_DAWNED, COMSIG_PREQDELETED, COMSIG_MIND_TRANSFER, SIGNAL_REMOVETRAIT(TRAIT_Z121_DEATH_RETURN)))
	body = H
	if(!body)
		return
	RegisterSignal(body, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(body, COMSIG_MOB_DAWNED, PROC_REF(on_dawn))
	RegisterSignal(body, COMSIG_PREQDELETED, PROC_REF(on_body_deleting))
	RegisterSignal(body, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))
	RegisterSignal(body, SIGNAL_REMOVETRAIT(TRAIT_Z121_DEATH_RETURN), PROC_REF(on_removed))

/datum/component/z121_death_return/process()
	if(enabled && !restoring && !pending && save_day != z121_return_day())
		refresh_save()

/datum/component/z121_death_return/proc/on_dawn()
	SIGNAL_HANDLER
	if(enabled && !restoring && !pending && save_day != z121_return_day())
		refresh_save()

/datum/component/z121_death_return/proc/refresh_save()
	save_day = z121_return_day()
	QDEL_NULL(saved)
	var/datum/mind/M = parent
	if(!enabled || QDELETED(body) || body.stat == DEAD || M.current != body || !HAS_TRAIT(body, TRAIT_Z121_DEATH_RETURN) || !get_turf(body))
		return
	saved = new(body)

/datum/component/z121_death_return/proc/on_removed()
	SIGNAL_HANDLER
	if(restoring)
		return
	enabled = FALSE
	pending = FALSE
	release_deletions()
	QDEL_NULL(saved)
	QDEL_NULL(pending_save)

/datum/component/z121_death_return/proc/on_transfer(datum/source, mob/new_body)
	SIGNAL_HANDLER
	if(restoring)
		return
	// 毁体过程中大脑可能先接管灵魂，仍归属于当前的死亡事件。
	if(pending && istype(new_body, /mob/living/brain))
		unbind_brain()
		transfer_brain = new_body
		RegisterSignal(transfer_brain, COMSIG_PREQDELETED, PROC_REF(on_brain_deleting))
		RegisterSignal(transfer_brain, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))
		return
	// 已经独立转生或被其他躯体接管的灵魂不能被旧存档夺回。
	on_removed()

/datum/component/z121_death_return/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER
	var/datum/mind/M = parent
	if(!enabled || restoring || pending || !saved || M.current != body || !HAS_TRAIT(body, TRAIT_Z121_DEATH_RETURN))
		return
	var/day = z121_return_day()
	if(save_day != day || used_day == day)
		return
	pending = TRUE
	return_origin = body
	destroying_body = gibbed
	pending_day = day
	// 转交快照所有权，避免清晨覆盖已经触发的回归。
	pending_save = saved
	saved = null
	addtimer(CALLBACK(src, PROC_REF(return_from_death)), 0)

/datum/component/z121_death_return/proc/on_body_deleting(datum/source, force)
	SIGNAL_HANDLER
	if(pending && source == return_origin)
		destroying_body = TRUE
		// 信号内只暂缓删除，由死亡调用链结束后的回归任务接管灵魂。
		deferred_deletions[source] = force || deferred_deletions[source]
		return TRUE

/datum/component/z121_death_return/proc/on_brain_deleting(datum/source, force)
	SIGNAL_HANDLER
	if(pending && source == transfer_brain)
		destroying_body = TRUE
		deferred_deletions[source] = force || deferred_deletions[source]
		return TRUE

/datum/component/z121_death_return/proc/unbind_brain()
	if(transfer_brain)
		UnregisterSignal(transfer_brain, list(COMSIG_PREQDELETED, COMSIG_MIND_TRANSFER))
	transfer_brain = null

/datum/component/z121_death_return/proc/release_deletions()
	unbind_brain()
	return_origin = null
	// 成功、失败、移除能力和删除控制器都必须补做原删除请求。
	// 使用全局回调，避免控制器自身销毁后清理任务失效。
	for(var/datum/target as anything in deferred_deletions)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), target, deferred_deletions[target]), 0)
	deferred_deletions.Cut()

/datum/component/z121_death_return/proc/return_from_death()
	if(!pending || restoring || !enabled || !pending_save)
		return
	var/datum/mind/M = parent
	var/mob/living/old_current = M.current
	if(QDELETED(body) || !HAS_TRAIT(body, TRAIT_Z121_DEATH_RETURN) || (old_current != body && !istype(old_current, /mob/living/brain)))
		finish_return()
		return
	if(!destroying_body && body.stat != DEAD)
		finish_return()
		return
	var/turf/destination = pending_save.find_destination(body)
	if(!destination)
		log_game("死亡回归：[key_name(body)] 的存档没有有效落点。")
		finish_return()
		return
	restoring = TRUE
	var/mob/living/carbon/human/returned = body
	if(destroying_body)
		returned = new /mob/living/carbon/human(destination)
		// 社会身份与账户采用死亡时的数据，不从清晨回滚，也不重发职业物品。
		z121_return_transfer_identity(body, returned)
		ADD_TRAIT(returned, TRAIT_Z121_DEATH_RETURN, TRAIT_VIRTUE)
		unbind_brain()
		M.transfer_to(returned, force_key_move = TRUE)
		bind_body(returned)
	else
		if(old_current != returned)
			unbind_brain()
			M.transfer_to(returned, force_key_move = TRUE)
		if(returned.buckled)
			returned.buckled.unbuckle_mob(returned, force = TRUE)
		returned.stop_pulling()
		returned.pulledby?.stop_pulling()
		returned.forceMove(destination)
	pending_save.restore(returned)
	if(returned.stat == DEAD)
		returned.become_alive(CONSCIOUS, bypass_foreign_brain_check = TRUE)
	returned.set_suicide(FALSE)
	returned.remove_client_colour(/datum/client_colour/monochrome)
	qdel(returned.GetComponent(/datum/component/rot))
	if(!returned.client)
		var/mob/dead/observer/ghost = M.get_ghost(TRUE, TRUE)
		ghost?.reenter_corpse()
	if(returned.client)
		for(var/atom/movable/screen/gameover/G in returned.client.screen.Copy())
			returned.client.screen -= G
			qdel(G)
	returned.updatehealth()
	returned.update_mobility()
	returned.update_sight()
	returned.regenerate_icons()
	returned.update_action_buttons_icon()
	used_day = pending_day
	to_chat(returned, span_notice("晨光仿佛又一次落在你的肩上。你记得那之后的一切。"))
	finish_return()

/datum/component/z121_death_return/proc/finish_return()
	restoring = FALSE
	pending = FALSE
	destroying_body = FALSE
	release_deletions()
	if(save_day == z121_return_day())
		QDEL_NULL(saved)
		saved = pending_save
		pending_save = null
	else
		QDEL_NULL(pending_save)
		refresh_save()

/datum/component/z121_death_return/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	enabled = FALSE
	pending = FALSE
	release_deletions()
	bind_body(null)
	QDEL_NULL(saved)
	QDEL_NULL(pending_save)
	return ..()

/proc/z121_return_transfer_identity(mob/living/carbon/human/old_body, mob/living/carbon/human/new_body)
	var/list/fields = list("real_name", "name", "job", "account_id", "faction", "patron", "origin", "statpack", "marriedto", "family_datum", "family_member_datum", "devotion", "inspiration", "charflaw", "flavortext", "ooc_notes", "ooc_extra", "headshot_link", "islatejoin", "allmig_reward", "received_resident_key")
	for(var/field in fields)
		if(field in old_body.vars)
			var/value = old_body.vars[field]
			if(islist(value))
				var/list/values = value
				value = values.Copy()
			new_body.vars[field] = value
	for(var/list/accounts as anything in list(SStreasury.bank_accounts, SStreasury.noble_incomes, SStreasury.poll_tax_advance_days, SStreasury.poll_tax_owed, SStreasury.poll_tax_debt_days))
		if(old_body in accounts)
			accounts[new_body] = accounts[old_body]
			accounts -= old_body
	SStreasury.poll_projection_dirty = TRUE
	// 当前任务和领取记录随人迁移，避免回归重新抽取任务或重复领取奖励。
	var/datum/component/rpg_journal/journal = old_body.GetComponent(/datum/component/rpg_journal)
	if(journal)
		new_body.TakeComponent(journal)
