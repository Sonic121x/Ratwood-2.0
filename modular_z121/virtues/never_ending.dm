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
	var/return_committed = FALSE
	var/destroying_body = FALSE
	var/enabled = TRUE
	var/reported_missing_destination = FALSE
	var/return_deadline = 0
	var/return_timer
	var/held_office = FALSE
	var/mob/living/carbon/human/return_origin
	var/mob/living/brain/transfer_brain
	var/mob/living/carbon/human/rebuild_candidate
	var/identity_prepared = FALSE
	var/list/deferred_deletions = list()

/datum/component/z121_death_return/Initialize(mob/living/carbon/human/H)
	if(!istype(parent, /datum/mind) || !istype(H))
		return COMPONENT_INCOMPATIBLE
	bind_body(H)
	observed_day = z121_return_day()
	refresh_save()
	START_PROCESSING(SSprocessing, src)

/datum/component/z121_death_return/InheritComponent(datum/component/C, i_am_original, list/arguments)
	if(!i_am_original || enabled || !length(arguments))
		return
	var/mob/living/carbon/human/H = arguments[1]
	var/datum/mind/M = parent
	if(!istype(H) || QDELETED(H) || M.current != H || !HAS_TRAIT(H, TRAIT_Z121_DEATH_RETURN))
		return
	// 重新赋予只恢复监听，不能借移除再添加美德获得新的存档或次数。
	bind_body(H)
	enabled = TRUE
	state = Z121_RETURN_INVALID
	observed_day = z121_return_day()

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
	try
		saved = new(body)
	catch(var/exception/error)
		// 初次入场也可能遇到不完整的身体数据，失败不能中断控制器的后续监听。
		log_game("死亡回归存档异常：[error.file]:[error.line]，[error]")
		QDEL_NULL(saved)
		return
	snapshot_id++
	state = Z121_RETURN_READY

/datum/component/z121_death_return/proc/on_removed()
	SIGNAL_HANDLER
	// 还原特性来源时的增删不代表玩家失去美德。
	if(restoring && body?.z121_return_changing_traits)
		return
	enabled = FALSE
	return_generation++
	// 正在使用的快照不能在恢复调用栈中删除；出口检测到取消后统一收尾。
	if(restoring)
		return
	state = Z121_RETURN_INVALID
	release_deletions()
	release_office_safely()
	QDEL_NULL(saved)
	QDEL_NULL(pending_save)
	QDEL_NULL(identity)

/datum/component/z121_death_return/proc/on_transfer(datum/source, mob/new_body)
	SIGNAL_HANDLER
	if(restoring)
		if(new_body == rebuild_candidate || new_body == body)
			return
		if(!istype(new_body, /mob/living/brain) || source != return_origin || return_committed)
			on_removed()
			return
	if(istype(new_body, /mob/living/brain) && (state == Z121_RETURN_RUNNING || body?.stat == DEAD || body?.InCritical()))
		unbind_brain()
		transfer_brain = new_body
		RegisterSignal(transfer_brain, COMSIG_PREQDELETED, PROC_REF(on_brain_deleting))
		RegisterSignal(transfer_brain, COMSIG_MIND_TRANSFER, PROC_REF(on_transfer))
		// 大脑暂时接管不等于整具身体已销毁，能复用的原身体仍保留现有物品。
		if(!restoring)
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

// 返回大厅只移动客户端，不一定转移灵魂；不能仅凭灵魂仍指向旧身体就抢回玩家。
/datum/component/z121_death_return/proc/owns_player()
	var/datum/mind/M = parent
	var/client/player = GLOB.directory[ckey(M.key)]
	if(!player)
		return TRUE
	if(player.mob == body || player.mob == transfer_brain)
		return TRUE
	if(isobserver(player.mob))
		var/mob/dead/observer/ghost = player.mob
		return ghost.mind == M
	return FALSE

/datum/component/z121_death_return/proc/begin_return(destroy_body = FALSE)
	if(!enabled)
		return FALSE
	if(!owns_player())
		on_removed()
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
	return_committed = FALSE
	destroying_body = destroy_body
	reported_missing_destination = FALSE
	return_deadline = world.time + 30 SECONDS
	try
		identity = new(body, M)
	catch(var/exception/error)
		log_game("死亡回归身份记录异常：[error.file]:[error.line]，[error]")
		fail_return("无法建立身份交接资料。")
		return FALSE
	return_timer = addtimer(CALLBACK(src, PROC_REF(perform_return), pending_snapshot_id), 0, TIMER_STOPPABLE)
	return TRUE

/datum/component/z121_death_return/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER
	if(!restoring && source == body)
		begin_return(gibbed)

/datum/component/z121_death_return/proc/on_body_deleting(datum/source, force)
	SIGNAL_HANDLER
	if(source != body || (restoring && return_committed))
		return
	// 删除也用于远行、管理清理及变身；它只能续接已经由濒死或死亡触发的回归。
	if(state != Z121_RETURN_RUNNING || !owns_player())
		on_removed()
		return
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
	if(return_timer)
		deltimer(return_timer)
		return_timer = null
	unbind_brain()
	// 换体后旧身体不一定会实际删除，不能让它永远保留恢复中的抑制标记。
	return_origin?.z121_return_preparing = FALSE
	return_origin?.z121_return_effect_record = null
	return_origin?.z121_return_changing_traits = FALSE
	return_origin?.z121_return_release_held_traumas()
	return_origin = null
	// 全局回调不依赖控制器存活，取消回归或删除组件也不会遗留不灭的尸体。
	for(var/datum/target as anything in deferred_deletions)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), target, deferred_deletions[target]), 0)
	deferred_deletions.Cut()

// 失败只废止本份存档；仍存活的原身体可以在下一清晨重新存档。
/datum/component/z121_death_return/proc/fail_return(reason)
	log_game("死亡回归：存档 [pending_snapshot_id] 终止，[reason]")
	state = Z121_RETURN_INVALID
	destroying_body = FALSE
	return_committed = FALSE
	var/datum/mind/M = parent
	try
		if(rebuild_candidate)
			if(M.current == rebuild_candidate)
				// 交接时身体和身份已完整准备；界面异常不能把玩家退回已毁坏的身体。
				bind_body(rebuild_candidate)
				if(!QDELETED(identity?.skills))
					identity.skills.set_current(rebuild_candidate)
				var/turf/destination = pending_save?.find_destination()
				if(destination)
					rebuild_candidate.forceMove(destination)
			else
				if(identity_prepared)
					try
						identity.rollback(rebuild_candidate)
					catch(var/exception/error)
						log_game("死亡回归身份回退异常：[error.file]:[error.line]，[error]")
				qdel(rebuild_candidate)
				bind_body(return_origin)
	catch(var/exception/recovery_error)
		// 兜底恢复也可能触发地图或界面回调；其异常不能阻止释放删除请求。
		log_game("死亡回归收尾异常：[recovery_error.file]:[recovery_error.line]，[recovery_error]")
	if(rebuild_candidate)
		rebuild_candidate.z121_return_preparing = FALSE
		rebuild_candidate.z121_return_effect_record = null
		rebuild_candidate.z121_return_release_held_traumas()
	body?.z121_return_preparing = FALSE
	body?.z121_return_effect_record = null
	body?.z121_return_changing_traits = FALSE
	rebuild_candidate = null
	identity_prepared = FALSE
	restoring = FALSE
	return_generation++
	deferred_dawn = FALSE
	deferred_dawn_alive = FALSE
	release_deletions()
	release_office_safely()
	QDEL_NULL(pending_save)
	QDEL_NULL(identity)

// 回归未完成时补做原死亡流程的职位清理，不能留下永远保留的空席。
/datum/component/z121_death_return/proc/release_office_safely()
	try
		release_office()
	catch(var/exception/error)
		held_office = FALSE
		log_game("死亡回归职位收尾异常：[error.file]:[error.line]，[error]")

/datum/component/z121_death_return/proc/release_office()
	if(held_office && body?.stat == DEAD && SScity_assembly?.is_alderman(body))
		SScity_assembly.demote_alderman("死亡回归未能完成")
		SScity_assembly.notify_alderman_lost_ref(body.real_name, body.job, "died")
	held_office = FALSE

/datum/component/z121_death_return/proc/perform_return(expected_snapshot)
	try
		perform_return_inner(expected_snapshot)
	catch(var/exception/error)
		log_game("死亡回归恢复异常：存档=[expected_snapshot]，位置=[error.file]:[error.line]，[error]")
		if(!QDELETED(src))
			fail_return("身体恢复出现异常，已释放本次回归锁和暂缓删除请求。")

/datum/component/z121_death_return/proc/perform_return_inner(expected_snapshot)
	if(!enabled || restoring || state != Z121_RETURN_RUNNING || !pending_save || expected_snapshot != pending_snapshot_id)
		return
	return_timer = null
	if(!owns_player())
		on_removed()
		return
	sync_day()
	var/datum/mind/M = parent
	var/mob/living/old_current = M.current
	if(old_current && !QDELETED(old_current) && old_current != return_origin && old_current != transfer_brain)
		on_removed()
		return
	var/turf/destination = pending_save.find_destination()
	if(!destination)
		// 仅短暂等待原地图层恢复；超时释放删除请求，不改选落点或永久扣住尸体。
		if(world.time >= return_deadline)
			fail_return("原坐标 [pending_save.saved_x],[pending_save.saved_y],[pending_save.saved_z] 在三十秒内未恢复。")
			return
		if(!reported_missing_destination)
			log_game("死亡回归：存档 [expected_snapshot] 的原坐标暂不可用，等待地图恢复。")
			reported_missing_destination = TRUE
		return_timer = addtimer(CALLBACK(src, PROC_REF(perform_return), expected_snapshot), 1 SECONDS, TIMER_STOPPABLE)
		return
	restoring = TRUE
	body?.z121_return_preparing = TRUE
	body?.z121_return_cancel_ability_sessions()
	body?.z121_return_release_passengers()
	var/mob/living/carbon/human/returned = body
	var/body_restored = FALSE
	if(destroying_body || QDELETED(returned))
		// 先在空位置完整准备身体；准备阶段出错时玩家仍由旧身体或大脑持有。
		returned = new /mob/living/carbon/human(null)
		rebuild_candidate = returned
		returned.z121_return_preparing = TRUE
		ADD_TRAIT(returned, TRAIT_Z121_DEATH_RETURN, TRAIT_VIRTUE)
		var/list/source_map = pending_save.restore(returned, TRUE)
		identity_prepared = TRUE
		identity.apply(returned)
		var/obj/item/organ/brain/prepared_brain = returned.getorganslot(ORGAN_SLOT_BRAIN)
		for(var/datum/z121_return_record/R as anything in pending_save.traumas)
			if(ispath(R.saved_type, /datum/brain_trauma/severe/split_personality))
				var/datum/brain_trauma/personality = prepared_brain?.has_trauma_type(R.saved_type)
				if(personality)
					source_map[R.source_ref] = REF(personality)
		pending_save.profession_values.restore(returned, source_map)
		pending_save.restore_traits(returned, source_map)
		var/datum/component/rpg_journal/journal = returned.GetComponent(/datum/component/rpg_journal)
		var/grants_before = journal?.rpg_spell_point_grants || 0
		pending_save.restore_rpg(returned)
		journal = returned.GetComponent(/datum/component/rpg_journal)
		M.spell_points -= grants_before - (journal?.rpg_spell_point_grants || 0)
		// 准备可能经过外部回调，交接前再次核对，不能夺回已远行或独立转生的玩家。
		if(!enabled || state != Z121_RETURN_RUNNING || expected_snapshot != pending_snapshot_id || !owns_player() || (M.current && !QDELETED(M.current) && M.current != return_origin && M.current != transfer_brain))
			fail_return("准备期间玩家归属已改变，取消灵魂交接。")
			on_removed()
			return
		// 灵魂交接仍使用原技能容器，导师、学徒和技能归属不会复制成第二份。
		var/datum/skill_holder/prepared_skills = returned.ensure_skills()
		identity.skills.known_skills = prepared_skills.known_skills.Copy()
		identity.skills.skill_experience = prepared_skills.skill_experience.Copy()
		prepared_skills.set_current(null)
		qdel(prepared_skills)
		returned.skills = null
		return_origin?.z121_return_release_language_disorders()
		var/datum/status_effect/buff/magic_flight/flight = returned.has_status_effect(/datum/status_effect/buff/magic_flight)
		flight?.z121_return_rebase_flight()
		M.transfer_to(returned, force_key_move = TRUE)
		bind_body(returned)
		if(!QDELETED(identity.skills))
			identity.skills.set_current(returned)
		var/obj/item/organ/brain/brain = returned.getorganslot(ORGAN_SLOT_BRAIN)
		for(var/datum/brain_trauma/severe/aphasia/aphasia in brain?.traumas)
			aphasia.z121_return_bind_mind()
		for(var/datum/status_effect/E as anything in returned.status_effects)
			E.z121_return_bind_mind()
		body_restored = TRUE
	else if(old_current != returned)
		M.transfer_to(returned, force_key_move = TRUE)
	if(returned.buckled)
		returned.buckled.unbuckle_mob(returned, force = TRUE)
	returned.stop_pulling()
	returned.pulledby?.stop_pulling()
	if(!body_restored)
		pending_save.restore(returned)
		if(destroying_body && returned == return_origin)
			if(!enabled || !owns_player() || (M.current != returned && M.current != transfer_brain))
				fail_return("毁体恢复期间玩家归属已改变，取消重建。")
				on_removed()
				return
			// 恢复回调也可能毁体；保住灵魂后下一帧改走重建，不能再复用待删除的身体。
			restoring = FALSE
			return_timer = addtimer(CALLBACK(src, PROC_REF(perform_return), expected_snapshot), 0, TIMER_STOPPABLE)
			return
	if(!enabled || state != Z121_RETURN_RUNNING || expected_snapshot != pending_snapshot_id || M.current != returned || !owns_player())
		fail_return("恢复期间玩家归属已改变，取消后续移动。")
		on_removed()
		return
	if(returned.stat == DEAD)
		returned.become_alive(pending_save.saved_stat, bypass_foreign_brain_check = TRUE)
	// 复苏本身也会触发外部监听，移动前再次确认灵魂与能力仍属于本次回归。
	if(!enabled || state != Z121_RETURN_RUNNING || expected_snapshot != pending_snapshot_id || M.current != returned || !owns_player())
		fail_return("复苏期间玩家归属已改变，取消后续移动。")
		on_removed()
		return
	if(destroying_body && returned == return_origin)
		// 复苏回调也可能申请毁体，提交传送前仍统一转入重建。
		restoring = FALSE
		return_timer = addtimer(CALLBACK(src, PROC_REF(perform_return), expected_snapshot), 0, TIMER_STOPPABLE)
		return
	returned.dna.real_name = returned.real_name
	// 完整身体先回到原坐标；后续界面刷新失败不能把玩家遗留在空位置。
	return_committed = TRUE
	returned.forceMove(destination)
	if(returned.get_bodypart(BODY_ZONE_HEAD))
		M.severed_head_ref = null
	returned.set_suicide(FALSE)
	returned.remove_client_colour(/datum/client_colour/monochrome)
	pending_save.restore_rot(returned)
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
	// 绕过全局肢体缓存，防止重建身体仍显示初始化或旧伤势的外观。
	returned.update_body_parts(TRUE)
	returned.update_action_buttons_icon()
	returned.update_stress_visual(returned.get_stress_amount())
	if(returned.devotion?.holder == returned)
		returned.hud_used?.initialize_bloodpool()
		returned.hud_used?.bloodpool?.set_fill_color("#3C41A4")
		returned.devotion.update_devotion(0, 0, TRUE)
	to_chat(returned, span_notice("晨光仿佛又一次落在你的肩上。你记得那之后的一切。"))
	// 直接发给当前持有者的客户端，不经过环境音传播、旁观或共享感官转发。
	if(returned.client?.mob == returned && returned.mind == M && HAS_TRAIT(returned, TRAIT_Z121_DEATH_RETURN))
		returned.client << sound('modular_z121/sound/death_return.mp3', volume = 80)
	finish_return()

/datum/component/z121_death_return/proc/finish_return()
	// 恢复过程中触发的健康更新不能开启第二次回归。
	sync_day()
	state = Z121_RETURN_USED
	body.z121_return_preparing = FALSE
	rebuild_candidate = null
	identity_prepared = FALSE
	held_office = FALSE
	restoring = FALSE
	destroying_body = FALSE
	return_committed = FALSE
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
	// 恢复调用栈尚未退出时，也先完成候选身体、身份交接和临时标记的收尾。
	if(restoring)
		fail_return("控制器已删除，终止正在执行的恢复。")
	state = Z121_RETURN_INVALID
	release_deletions()
	release_office_safely()
	bind_body(null)
	QDEL_NULL(saved)
	QDEL_NULL(pending_save)
	QDEL_NULL(identity)
	return ..()

// 远行成功后会调用此入口；先终止旧回归，避免下一帧的回调把玩家从大厅拉回。
/mob/living/carbon/human/returntolobby()
	if(client)
		var/datum/component/z121_death_return/controller = mind?.GetComponent(/datum/component/z121_death_return)
		if(controller?.state == Z121_RETURN_RUNNING)
			controller.fail_return("玩家已远行返回大厅，取消回归。")
		controller?.on_removed()
	return ..()

// 这是触发时的身份交接资料，不是清晨存档；保留当前身份、账户与任务。
/datum/z121_return_identity
	var/mob/living/carbon/human/original
	var/datum/mind/owner_mind
	var/list/values = list()
	var/list/accounts = list()
	var/datum/skill_holder/skills
	var/datum/component/rpg_journal/journal
	var/list/rollback_growth
	var/list/rollback_profession = list()
	var/list/rollback_known_skills
	var/list/rollback_skill_experience
	var/rollback_spell_points

/datum/z121_return_identity/New(mob/living/carbon/human/H, datum/mind/M)
	original = H
	owner_mind = M
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
	if(!QDELETED(original))
		journal = original.GetComponent(/datum/component/rpg_journal)
	rollback_growth = journal?.growth_data()
	rollback_known_skills = skills.known_skills.Copy()
	rollback_skill_experience = skills.skill_experience.Copy()
	rollback_spell_points = owner_mind.spell_points
	if(!QDELETED(original) && original.z121_profession)
		for(var/field in list("stats", "experience", "independent_experience", "observed_experience", "removed_experience", "traits"))
			var/list/record = original.z121_profession.vars[field]
			rollback_profession[field] = record.Copy()
	for(var/field in values)
		// 等待落点期间仍可能发生管理调整、退团或身份变更，应以当前记录为准。
		var/value = !QDELETED(original) ? original.vars[field] : values[field]
		if(islist(value))
			var/list/current_values = value
			value = current_values.Copy()
		H.vars[field] = value
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
	if(!QDELETED(original))
		original.z121_return_transfer_identity(H)

// 未提交灵魂交接时，把已经迁移的身份实例原路移回，不删除岗位、任务和账户。
/datum/z121_return_identity/proc/rollback(mob/living/carbon/human/H)
	if(QDELETED(original))
		return
	H.z121_return_transfer_identity(original, TRUE)
	if(journal?.parent == H)
		original.TakeComponent(journal)
	journal?.restore_growth(rollback_growth)
	for(var/list/entry as anything in accounts)
		var/list/bank = entry[1]
		if(H in bank)
			bank[original] = bank[H]
			bank -= H
	if(original.z121_profession)
		for(var/field in rollback_profession)
			var/list/record = rollback_profession[field]
			original.z121_profession.vars[field] = record.Copy()
	if(rollback_known_skills)
		skills.known_skills = rollback_known_skills.Copy()
		skills.skill_experience = rollback_skill_experience.Copy()
	if(!isnull(rollback_spell_points))
		owner_mind.spell_points = rollback_spell_points

/datum/z121_return_identity/Destroy()
	original = null
	owner_mind = null
	skills = null
	journal = null
	values = null
	accounts = null
	return ..()
