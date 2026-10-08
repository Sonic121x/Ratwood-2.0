// 保留原美德路径以兼容角色偏好；内部标记不登记到玩家可见的特性表。
#define TRAIT_Z121_DEATH_RETURN "z121_death_return"

/datum/virtue/utility/never_ending
	name = "死亡回归（-39）"
	desc = "晨光曾在你的影子里停留。此后，有些本该落定的句点，便迟迟没有落下。"
	custom_text = null
	triumph_cost = 39
	// 选择界面会直接展示此列表；内部标记改在实际赋予美德时添加。
	added_traits = list()

/datum/virtue/utility/never_ending/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(recipient)
		ADD_TRAIT(recipient, TRAIT_Z121_DEATH_RETURN, TRAIT_VIRTUE)
		recipient.AddComponent(/datum/component/z121_return_entry)

// 入场流程尚可能进行职业选择，必须等角色实际就绪后建立初始存档。
/datum/component/z121_return_entry
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

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

// 控制器属于灵魂，快照与触发次数不依赖尸体生命周期。
#define Z121_RETURN_INVALID 0
#define Z121_RETURN_READY 1
#define Z121_RETURN_RUNNING 2
#define Z121_RETURN_USED 3

/datum/component/z121_death_return
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/mob/living/carbon/human/body
	var/datum/z121_return_snapshot/saved
	var/datum/z121_return_snapshot/pending_save
	var/datum/z121_return_identity/identity
	var/state = Z121_RETURN_INVALID
	var/snapshot_id = 0
	var/pending_snapshot_id = 0
	var/return_generation = 0
	var/observed_day
	var/deferred_dawn = FALSE
	var/deferred_dawn_alive = FALSE
	var/restoring = FALSE
	var/destroying_body = FALSE
	var/enabled = TRUE
	var/reported_missing_destination = FALSE
	var/mob/living/carbon/human/return_origin
	var/mob/living/brain/transfer_brain
	var/list/deferred_deletions = list()

/datum/component/z121_death_return/Initialize(mob/living/carbon/human/H)
	if(!istype(parent, /datum/mind) || !istype(H))
		return COMPONENT_INCOMPATIBLE
	bind_body(H)
	observed_day = z121_return_day()
	refresh_save()
	START_PROCESSING(SSprocessing, src)

/datum/component/z121_death_return/proc/bind_body(mob/living/carbon/human/H)
	if(body)
		UnregisterSignal(body, list(COMSIG_LIVING_HEALTH_UPDATE, COMSIG_LIVING_DEATH, COMSIG_MOB_DAWNED, COMSIG_PREQDELETED, COMSIG_MIND_TRANSFER, SIGNAL_REMOVETRAIT(TRAIT_Z121_DEATH_RETURN)))
	body = H
	if(!body)
		return
	RegisterSignal(body, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(body, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))
	RegisterSignal(body, COMSIG_MOB_DAWNED, PROC_REF(on_dawn))
	RegisterSignal(body, COMSIG_PREQDELETED, PROC_REF(on_body_deleting))
	RegisterSignal(body, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))
	RegisterSignal(body, SIGNAL_REMOVETRAIT(TRAIT_Z121_DEATH_RETURN), PROC_REF(on_removed))

/datum/component/z121_death_return/process()
	sync_day()
	check_condition()

/datum/component/z121_death_return/proc/on_dawn()
	SIGNAL_HANDLER
	sync_day()

/datum/component/z121_death_return/proc/sync_day()
	if(!enabled || observed_day == z121_return_day())
		return
	observed_day = z121_return_day()
	if(state == Z121_RETURN_RUNNING)
		// 跨清晨时只记录当时生死，不用恢复到一半的身体覆盖锁定快照。
		deferred_dawn = TRUE
		deferred_dawn_alive = !QDELETED(body) && body.stat != DEAD
		return
	refresh_save()

/datum/component/z121_death_return/proc/refresh_save()
	QDEL_NULL(saved)
	state = Z121_RETURN_INVALID
	var/datum/mind/M = parent
	if(!enabled || QDELETED(body) || body.stat == DEAD || M.current != body || !HAS_TRAIT(body, TRAIT_Z121_DEATH_RETURN) || !get_turf(body))
		return
	saved = new(body)
	snapshot_id++
	state = Z121_RETURN_READY

/datum/component/z121_death_return/proc/on_removed()
	SIGNAL_HANDLER
	// 还原特性来源时的增删不代表玩家失去美德。
	if(restoring)
		return
	enabled = FALSE
	state = Z121_RETURN_INVALID
	return_generation++
	release_deletions()
	QDEL_NULL(saved)
	QDEL_NULL(pending_save)
	QDEL_NULL(identity)

/datum/component/z121_death_return/proc/on_transfer(datum/source, mob/new_body)
	SIGNAL_HANDLER
	if(restoring)
		return
	if(istype(new_body, /mob/living/brain) && (state == Z121_RETURN_RUNNING || body?.stat == DEAD || body?.InCritical()))
		unbind_brain()
		transfer_brain = new_body
		RegisterSignal(transfer_brain, COMSIG_PREQDELETED, PROC_REF(on_brain_deleting))
		RegisterSignal(transfer_brain, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))
		// 大脑暂时接管不等于整具身体已销毁，能复用的原身体仍保留现有物品。
		begin_return()
		return
	// 外部转生已接管灵魂时，不允许旧身体把玩家夺回。
	on_removed()

/datum/component/z121_death_return/proc/on_health_update()
	SIGNAL_HANDLER
	sync_day()
	check_condition()

/datum/component/z121_death_return/proc/check_condition()
	if(state != Z121_RETURN_READY || !enabled || QDELETED(body))
		return
	if(body.stat == DEAD || body.InCritical())
		begin_return()

/datum/component/z121_death_return/proc/begin_return(destroy_body = FALSE)
	if(!enabled)
		return FALSE
	sync_day()
	if(state == Z121_RETURN_RUNNING)
		destroying_body = destroying_body || destroy_body
		return TRUE
	var/datum/mind/M = parent
	if(state != Z121_RETURN_READY || !saved || QDELETED(body) || !HAS_TRAIT(body, TRAIT_Z121_DEATH_RETURN) || (M.current != body && M.current != transfer_brain))
		return FALSE
	// 先锁定本次机会并废止旧遗言，再安排恢复；信号内不执行可能休眠的恢复操作。
	state = Z121_RETURN_RUNNING
	return_generation++
	pending_snapshot_id = snapshot_id
	pending_save = saved
	saved = null
	return_origin = body
	destroying_body = destroy_body
	reported_missing_destination = FALSE
	identity = new(body)
	addtimer(CALLBACK(src, PROC_REF(perform_return), pending_snapshot_id), 0)
	return TRUE

/datum/component/z121_death_return/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER
	if(!restoring && source == body)
		begin_return(gibbed)

/datum/component/z121_death_return/proc/on_body_deleting(datum/source, force)
	SIGNAL_HANDLER
	if(!restoring && source == body)
		begin_return(TRUE)
	if(state == Z121_RETURN_RUNNING && source == return_origin)
		destroying_body = TRUE
		deferred_deletions[source] = force || deferred_deletions[source]
		return TRUE

/datum/component/z121_death_return/proc/on_brain_deleting(datum/source, force)
	SIGNAL_HANDLER
	if(state == Z121_RETURN_RUNNING && source == transfer_brain)
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
	// 全局回调不依赖控制器存活，取消回归或删除组件也不会遗留不灭的尸体。
	for(var/datum/target as anything in deferred_deletions)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), target, deferred_deletions[target]), 0)
	deferred_deletions.Cut()

/datum/component/z121_death_return/proc/perform_return(expected_snapshot)
	if(!enabled || restoring || state != Z121_RETURN_RUNNING || !pending_save || expected_snapshot != pending_snapshot_id)
		return
	sync_day()
	var/datum/mind/M = parent
	var/mob/living/old_current = M.current
	if(old_current && !QDELETED(old_current) && old_current != return_origin && old_current != transfer_brain)
		on_removed()
		return
	var/turf/destination = pending_save.find_destination()
	if(!destination)
		// 坐标所在地图层暂时不存在时保留锁定机会；不更换落点，也不消耗存档。
		if(!reported_missing_destination)
			log_game("死亡回归：存档 [expected_snapshot] 的原坐标暂不可用，等待地图恢复。")
			reported_missing_destination = TRUE
		addtimer(CALLBACK(src, PROC_REF(perform_return), expected_snapshot), 1 SECONDS)
		return
	restoring = TRUE
	var/mob/living/carbon/human/returned = body
	if(destroying_body || QDELETED(returned))
		// 重建先在空位置完成，避免新身体的默认状态在落点触发伤害。
		returned = new /mob/living/carbon/human(null)
		identity.apply(returned)
		ADD_TRAIT(returned, TRAIT_Z121_DEATH_RETURN, TRAIT_VIRTUE)
		M.transfer_to(returned, force_key_move = TRUE)
		if(!QDELETED(identity.skills))
			identity.skills.set_current(returned)
		bind_body(returned)
	else if(old_current != returned)
		M.transfer_to(returned, force_key_move = TRUE)
	if(returned.buckled)
		returned.buckled.unbuckle_mob(returned, force = TRUE)
	returned.stop_pulling()
	returned.pulledby?.stop_pulling()
	pending_save.restore(returned)
	if(returned.stat == DEAD)
		returned.become_alive(pending_save.saved_stat, bypass_foreign_brain_check = TRUE)
	if(returned.get_bodypart(BODY_ZONE_HEAD))
		M.severed_head_ref = null
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
	// 强制原坐标，不因墙壁、占位者或危险地形而改选落点。
	returned.forceMove(destination)
	to_chat(returned, span_notice("晨光仿佛又一次落在你的肩上。你记得那之后的一切。"))
	finish_return()

/datum/component/z121_death_return/proc/finish_return()
	// 恢复过程中触发的健康更新不能开启第二次回归。
	sync_day()
	state = Z121_RETURN_USED
	restoring = FALSE
	destroying_body = FALSE
	release_deletions()
	QDEL_NULL(pending_save)
	QDEL_NULL(identity)
	if(deferred_dawn)
		deferred_dawn = FALSE
		if(deferred_dawn_alive)
			refresh_save()
		else
			state = Z121_RETURN_INVALID
		deferred_dawn_alive = FALSE

/datum/component/z121_death_return/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	enabled = FALSE
	state = Z121_RETURN_INVALID
	release_deletions()
	bind_body(null)
	QDEL_NULL(saved)
	QDEL_NULL(pending_save)
	QDEL_NULL(identity)
	return ..()

// 这是触发时的身份交接资料，不是清晨存档；保留当前身份、账户与任务。
/datum/z121_return_identity
	var/mob/living/carbon/human/original
	var/list/values = list()
	var/list/accounts = list()
	var/datum/skill_holder/skills
	var/datum/component/rpg_journal/journal

/datum/z121_return_identity/New(mob/living/carbon/human/H)
	original = H
	skills = H.ensure_skills()
	journal = H.GetComponent(/datum/component/rpg_journal)
	var/list/fields = list("real_name", "name", "job", "account_id", "faction", "patron", "origin", "statpack", "marriedto", "family_datum", "family_member_datum", "devotion", "inspiration", "charflaw", "flavortext", "ooc_notes", "ooc_extra", "headshot_link", "islatejoin", "allmig_reward", "received_resident_key")
	for(var/field in fields)
		if(field in H.vars)
			var/value = H.vars[field]
			if(islist(value))
				var/list/items = value
				value = items.Copy()
			values[field] = value
	for(var/list/bank as anything in list(SStreasury.bank_accounts, SStreasury.noble_incomes, SStreasury.poll_tax_advance_days, SStreasury.poll_tax_owed, SStreasury.poll_tax_debt_days))
		accounts += list(list(bank, H in bank, bank[H]))

/datum/z121_return_identity/proc/apply(mob/living/carbon/human/H)
	for(var/field in values)
		H.vars[field] = values[field]
	for(var/list/entry as anything in accounts)
		var/list/bank = entry[1]
		if(original && (original in bank))
			bank[H] = bank[original]
			bank -= original
		else if(entry[2])
			bank[H] = entry[3]
	SStreasury.poll_projection_dirty = TRUE
	if(!QDELETED(journal))
		H.TakeComponent(journal)

/datum/z121_return_identity/Destroy()
	original = null
	skills = null
	journal = null
	values = null
	accounts = null
	return ..()
