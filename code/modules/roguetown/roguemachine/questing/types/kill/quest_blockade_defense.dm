/datum/quest/kill/blockade_defense
	quest_type = QUEST_BLOCKADE_DEFENSE
	quest_difficulty = QUEST_DIFFICULTY_HARD
	tp_budget = BLOCKADE_WAVE_BASE_TP
	threat_bands_cleared = QUEST_BANDS_BLOCKADE
	required_fellowship_size = 0

	var/current_wave = 0
	var/wave_timer_id
	/// Chat-ping timers. Fire at 2 min and 30 s left so the bearer is warned before forfeit.
	var/wave_warn_7m30s_id
	var/wave_warn_5m_id
	var/wave_warn_2m_id
	var/datum/weakref/wave_landmark_ref
	var/datum/weakref/blockade_ref
	/// TRUE after materialize() arms the quest and before the bearer has triggered wave 1
	/// by entering the landmark's proximity. Prevents double-fire via check_arrival.
	var/armed = FALSE
	var/max_defenders_seen = 0
	/// Auto-fail timer that fires if the bearer never reaches the landmark. Without this, a writ
	/// stashed in a drawer or handed to someone who never travels keeps the blockade slot locked
	/// until round-end.
	/// world.time at which the writ was issued. Used by the Steward's ledger to gate recall
	/// within BLOCKADE_RECALL_WINDOW_DS.
	var/issued_at = 0
	/// Fund the commission draft was burned from, so a recall can mint the cost back to the
	/// correct pot. Null for directives (which burned nothing).
	var/datum/fund/funding_fund
	var/funding_cost = 0
	var/warrant_consumed = 0

/datum/quest/kill/blockade_defense/get_scroll_type()
	return /obj/item/quest_writ/blockade

/// Faction is forced by the blockade, not rolled from threat weights.
/datum/quest/kill/blockade_defense/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		faction = B.get_faction()
	else if(faction_id)
		faction = get_quest_faction(faction_id)
	if(!faction || !length(faction.mob_types))
		return FALSE
	faction_id = faction.id
	target_mob_type = faction.pick_mob_type()
	if(!target_mob_type)
		return FALSE
	progress_required = estimate_mob_count()
	finalize_preview_title()
	return TRUE

/datum/quest/kill/blockade_defense/get_title()
	if(title)
		return title
	var/datum/blockade/B = blockade_ref?.resolve()
	var/datum/economic_region/ER = B?.get_region()
	if(ER)
		return "解除[ER.name]的封锁"
	if(region)
		return "封锁防御：[region]"
	return "破除贸易封锁"

/datum/quest/kill/blockade_defense/get_objective_text()
	var/wave_label = current_wave > 0 ? "第 [current_wave]/[BLOCKADE_TOTAL_WAVES] 波" : "三波攻势将至"
	if(!faction)
		return "[wave_label]。坚守阵线。"
	return "[wave_label]。击溃[faction.name_plural]。"

/datum/quest/kill/blockade_defense/on_first_pop()
	return

/datum/quest/kill/blockade_defense/populate_scroll_ui_static_data(list/data)
	data["blockade_total_waves"] = BLOCKADE_TOTAL_WAVES
	data["blockade_current_wave"] = current_wave
	data["blockade_armed"] = armed ? TRUE : FALSE
	data["blockade_failed"] = failed ? TRUE : FALSE

/datum/quest/kill/blockade_defense/populate_scroll_ui_data(list/data)
	if(current_wave > 0 && wave_timer_id)
		var/left = timeleft(wave_timer_id)
		if(left > 0)
			data["blockade_timer_label"] = "第 [current_wave] 波结束倒计时"
			data["blockade_timer_seconds"] = round(left / 10)

/// Compass target: live wave mobs when present, otherwise the landmark itself. The base impl
/// iterates tracked_atoms (spawned mobs), which is empty while armed (before wave 1) and between
/// waves — the scroll would whisper "location unknown" right when the bearer most needs it.
/datum/quest/kill/blockade_defense/get_target_location()
	var/turf/from_mobs = ..()
	if(from_mobs)
		return from_mobs
	var/obj/effect/landmark/quest_spawner/landmark = wave_landmark_ref?.resolve()
	return landmark ? get_turf(landmark) : null

/// Reward is set at issue time (BLOCKADE_SCROLL_REWARD × region tp_budget_multiplier).
/datum/quest/kill/blockade_defense/calculate_reward(turf/origin_turf, turf/target_turf)
	return reward_amount

/// Materialize arms the quest but does NOT spawn wave 1. The scroll's process() tick polls
/// check_arrival() and fires wave 1 once the bearer is in proximity to the landmark.
/datum/quest/kill/blockade_defense/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	wave_landmark_ref = WEAKREF(landmark)
	armed = TRUE
	return TRUE

/// Called from the scroll's process tick. Tests bearer proximity; fires wave 1 on arrival.
/datum/quest/kill/blockade_defense/proc/check_arrival(mob/bearer)
	if(!armed || failed || complete)
		return
	if(!bearer)
		return
	var/obj/effect/landmark/quest_spawner/landmark = wave_landmark_ref?.resolve()
	if(!landmark)
		return
	var/turf/bearer_turf = get_turf(bearer)
	var/turf/landmark_turf = get_turf(landmark)
	if(!bearer_turf || !landmark_turf)
		return
	if(bearer_turf.z != landmark_turf.z)
		return
	if(get_dist(bearer_turf, landmark_turf) > 7)
		return
	armed = FALSE
	announce_to_bearer("<b>你们已抵达封锁线。</b>做好准备。")
	spawn_wave(1)

/datum/quest/kill/blockade_defense/proc/count_defenders(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return BLOCKADE_DEFENDER_SCALE_MIN
	var/turf/center = get_turf(landmark)
	if(!center)
		return BLOCKADE_DEFENDER_SCALE_MIN
	var/count = 0
	for(var/mob/living/L in range(BLOCKADE_DEFENDER_SCAN_RANGE, center))
		if(!L.client)
			continue
		if(L.stat == DEAD)
			continue
		count++
	return count

/datum/quest/kill/blockade_defense/proc/wave_tp_budget(defenders)
	var/n = clamp(defenders, BLOCKADE_DEFENDER_SCALE_MIN, BLOCKADE_DEFENDER_SCALE_MAX)
	var/mult = 1 + (n - BLOCKADE_DEFENDER_SCALE_MIN) * BLOCKADE_TP_PER_EXTRA_DEFENDER
	return round(BLOCKADE_WAVE_BASE_TP * mult)

/// Reward multiplier from peak turnout, same band as the fight. Baseline at MIN (×1.0).
/datum/quest/kill/blockade_defense/proc/reward_turnout_mult()
	var/n = clamp(max_defenders_seen, BLOCKADE_DEFENDER_SCALE_MIN, BLOCKADE_DEFENDER_SCALE_MAX)
	return 1 + (n - BLOCKADE_DEFENDER_SCALE_MIN) * BLOCKADE_REWARD_PER_EXTRA_DEFENDER

/datum/quest/kill/blockade_defense/proc/spawn_wave(wave_num)
	if(failed || complete)
		return
	if(wave_num < 1 || wave_num > BLOCKADE_TOTAL_WAVES)
		return
	var/obj/effect/landmark/quest_spawner/landmark = wave_landmark_ref?.resolve()
	if(!landmark)
		fail_quest("landmark_lost")
		return
	current_wave = wave_num
	var/defenders = count_defenders(landmark)
	max_defenders_seen = max(max_defenders_seen, defenders)
	tp_budget = wave_tp_budget(defenders)
	total_spawned_tp = 0
	progress_current = 0
	progress_required = 1
	// spawn_kill_mobs returns the actual spawn count; it only rewrites progress_required when that
	// count is > 0, so guard on the count itself — an all-blocked/empty wave would otherwise arm
	// with 1 required kill and 0 mobs and stall the whole wave timer.
	var/spawned = spawn_kill_mobs(landmark)
	if(spawned <= 0)
		fail_quest("composition_empty")
		return
	clear_wave_timers()
	wave_timer_id = addtimer(CALLBACK(src, PROC_REF(on_wave_timeout), wave_num), BLOCKADE_WAVE_TIMER_DS, TIMER_STOPPABLE)
	// Chat pings at 7.5 min, 5 min and 2 min left. Skipped if the wave timer is shorter than the threshold.
	if(BLOCKADE_WAVE_TIMER_DS > (7.5 MINUTES))
		wave_warn_7m30s_id = addtimer(CALLBACK(src, PROC_REF(warn_time_left), wave_num, "七分半钟"), BLOCKADE_WAVE_TIMER_DS - (7.5 MINUTES), TIMER_STOPPABLE)
	if(BLOCKADE_WAVE_TIMER_DS > (5 MINUTES))
		wave_warn_5m_id = addtimer(CALLBACK(src, PROC_REF(warn_time_left), wave_num, "五分钟"), BLOCKADE_WAVE_TIMER_DS - (5 MINUTES), TIMER_STOPPABLE)
	if(BLOCKADE_WAVE_TIMER_DS > (2 MINUTES))
		wave_warn_2m_id = addtimer(CALLBACK(src, PROC_REF(warn_time_left), wave_num, "两分钟"), BLOCKADE_WAVE_TIMER_DS - (2 MINUTES), TIMER_STOPPABLE)
	announce_to_bearer("<b>第 [wave_num]/[BLOCKADE_TOTAL_WAVES] 波</b>正向你们压来。你们有 [BLOCKADE_WAVE_TIMER_DS / 600] 分钟。")
	quest_scroll?.update_quest_text()

/datum/quest/kill/blockade_defense/proc/warn_time_left(wave_num, label)
	if(failed || complete)
		return
	if(wave_num != current_wave)
		return
	announce_to_bearer("<b>第 [wave_num] 波：</b>剩余 [label]。")

/// clear_wave_timers covers the wave + both warn timers; arm_timer_id lives outside it, so an
/// unsanctioned qdel mid-wave (or while still armed) would otherwise leak a stale callback.
/datum/quest/kill/blockade_defense/Destroy()
	clear_wave_timers()
	return ..()

/datum/quest/kill/blockade_defense/proc/clear_wave_timers()
	if(wave_timer_id)
		deltimer(wave_timer_id)
		wave_timer_id = null
	if(wave_warn_7m30s_id)
		deltimer(wave_warn_7m30s_id)
		wave_warn_7m30s_id = null
	if(wave_warn_5m_id)
		deltimer(wave_warn_5m_id)
		wave_warn_5m_id = null
	if(wave_warn_2m_id)
		deltimer(wave_warn_2m_id)
		wave_warn_2m_id = null

/datum/quest/kill/blockade_defense/on_progress_update()
	if(failed || complete)
		return
	if(progress_current < progress_required)
		return
	clear_wave_timers()
	if(current_wave >= BLOCKADE_TOTAL_WAVES)
		mark_complete()
		return
	announce_to_bearer("<b>第 [current_wave] 波已破。</b>又有一波正在集结...")
	addtimer(CALLBACK(src, PROC_REF(spawn_wave), current_wave + 1), 5 SECONDS)

/datum/quest/kill/blockade_defense/proc/on_wave_timeout(wave_num)
	if(failed || complete)
		return
	if(wave_num != current_wave)
		return
	fail_quest("timeout")

/datum/quest/kill/blockade_defense/proc/fail_quest(reason)
	if(failed || complete)
		return
	failed = TRUE
	clear_wave_timers()
	announce_to_bearer("<b>封锁未能破除。</b>卷轴在你手中冒出青烟，片片碎裂。")
	record_round_statistic(STATS_BLOCKADE_CONTRACTS_FAILED, 1)
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
		B.active_quest_ref = null
	despawn_live_wave_mobs()
	quest_scroll?.update_quest_text()
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)

/// Reason the writ cannot be recalled right now, or null if it can. Single source of truth
/// for both the DM recall handler and the Steward's TGUI flavor copy. Recall policy:
/// the bearer gets an uninterrupted BLOCKADE_RECALL_WINDOW_DS to reach the blockade; only
/// after that window, and only if they still haven't engaged (armed == TRUE), may the
/// Steward yank the writ and refund the draft. Once a wave has started the fellowship
/// owns the outcome regardless of elapsed time.
/datum/quest/kill/blockade_defense/proc/recall_blocker()
	if(failed)
		return "契约已经失效"
	if(complete)
		return "封锁已被破除"
	// current_wave > 0 means a wave has actually spawned - the fellowship is committed.
	// armed == FALSE before the scroll is opened (pre-claim), so we can't use !armed
	// here or an untouched writ would incorrectly read as "already engaged".
	if(current_wave > 0)
		return "冒险团已与封锁守军交战"
	if(!issued_at)
		return "契约的签发时间不明"
	var/elapsed = world.time - issued_at
	if(elapsed < BLOCKADE_RECALL_WINDOW_DS)
		var/remaining = BLOCKADE_RECALL_WINDOW_DS - elapsed
		var/minutes_left = max(1, round(remaining / 600))
		return "持契者尚有 [minutes_left] 分钟可抵达封锁，之后方可召回"
	return null

/datum/quest/kill/blockade_defense/proc/can_recall()
	return isnull(recall_blocker())

/// Steward-initiated cancellation. Refunds the original funding draft (if any), then
/// tears down the quest by deleting the scroll - Destroy handles qdeling the quest datum
/// and the blockade's weakref self-heals.
/datum/quest/kill/blockade_defense/proc/recall(mob/recaller, reason = "recalled")
	if(!can_recall())
		return FALSE
	armed = FALSE
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
		B.active_quest_ref = null
	if(funding_fund && funding_cost > 0)
		SStreasury.mint(funding_fund, funding_cost, "Blockade writ recall refund ([recaller ? recaller.real_name : "unknown"])")
		if(funding_fund == SStreasury.burgher_pledge_fund)
			record_round_statistic(STATS_PLEDGE_CONSUMED, -funding_cost)
	if(warrant_consumed > 0)
		SScity_assembly?.refund_defense(warrant_consumed, recaller, "blockade writ recall")
		warrant_consumed = 0
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)
	else
		SSquestpool.pool -= src
		qdel(src)
	return TRUE

/datum/quest/kill/blockade_defense/proc/despawn_live_wave_mobs()
	for(var/datum/weakref/W in tracked_atoms)
		var/mob/living/M = W.resolve()
		if(QDELETED(M))
			continue
		if(M.stat == DEAD)
			continue
		qdel(M)

/// Reward pays immediately on last-wave clear (not at noticeboard turn-in) so the
/// fellowship doesn't have to risk the scroll on the trip home. Scroll burns afterward
/// to prevent double-minting at the contract ledger.
/datum/quest/kill/blockade_defense/mark_complete()
	..()
	clear_wave_timers()
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
		B.active_quest_ref = null
		SSeconomy.clear_blockade(B, "cleared")
	var/mob/lead = quest_receiver_reference?.resolve()
	var/payout = round(reward_amount * reward_turnout_mult())
	if(payout > 0)
		if(lead && SStreasury.has_account(lead))
			var/datum/fund/lead_account = SStreasury.get_account(lead)
			SStreasury.mint(lead_account, payout, "Blockade defense reward ([quest_giver_name || "Crown"] -> [lead.real_name])")
			var/tax_amt = 0
			if(!levy_exempt)
				tax_amt = SStreasury.apply_tax(lead_account, payout, TAX_CATEGORY_CONTRACT_LEVY, "Blockade defense")
				if(tax_amt > 0)
					record_featured_stat(FEATURED_STATS_TAX_PAYERS, lead, tax_amt)
					record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
			record_round_statistic(STATS_BLOCKADE_REWARDS_PAID, payout)
			announce_to_bearer("最后一波已破。报酬已转入你的账户。总额：[payout] 玛门币。税款：[tax_amt] 玛门币。净额：[payout - tax_amt] 玛门币。")
		else
			SStreasury.mint(SStreasury.discretionary_fund, payout, "Blockade defense reward (unbanked bearer)")
			announce_to_bearer("最后一波已破。你的份额由王室保管——请回到神经主处领取。")
	else
		announce_to_bearer("最后一波已破。此乃一项请求——并无报酬。")
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(TR && TR.banditry_hoard > 0)
		var/spoils = TR.banditry_hoard
		TR.banditry_hoard = 0
		if(lead && SStreasury.has_account(lead))
			var/datum/fund/spoils_account = SStreasury.get_account(lead)
			SStreasury.mint(spoils_account, spoils, "Recovered Spoils ([region])")
			var/spoils_tax = SStreasury.apply_tax(spoils_account, spoils, TAX_CATEGORY_RECOVERED_SPOILS, region)
			if(spoils_tax > 0)
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, lead, spoils_tax)
				record_round_statistic(STATS_TAXES_COLLECTED, spoils_tax)
			announce_to_bearer("匪徒的窖藏已被查获——[spoils] 玛门币的赃币。王室以「追回赃物」之名取走 [spoils_tax]。净额：[spoils - spoils_tax] 玛门币。")
		else
			SStreasury.mint(SStreasury.discretionary_fund, spoils, "Recovered Spoils (unbanked bearer, [region])")
			announce_to_bearer("匪徒 [spoils] 玛门币的窖藏已以王室之名查获。")
		GLOB.azure_round_stats[STATS_BANDITRY_HOARD_OUTSTANDING] = SSeconomy.total_banditry_hoard()
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)

// The on-request Hoard Recovery: a writ raised at the Grand Contract Ledger (by a
// Fellowship's own pledge, or commissioned by the Steward) once a region's banditry hoard
// reaches HOARD_RECOVERY_HOARD_MINIMUM. Wave mechanics, recall, and payout are inherited
// from blockade_defense; no /datum/blockade is involved, the writ binds to the threat
// region alone and never blocks trade.
/datum/quest/kill/blockade_defense/hoard_recovery
	quest_type = QUEST_HOARD_RECOVERY

/datum/quest/kill/blockade_defense/hoard_recovery/get_title()
	if(title)
		return title
	// TODO: flavor - plain placeholder, rewrite
	if(region)
		return "寻宝：[region]"
	return "寻宝"

/datum/quest/kill/blockade_defense/hoard_recovery/get_objective_text()
	var/wave_label = current_wave > 0 ? "第 [current_wave]/[BLOCKADE_TOTAL_WAVES] 波" : "三波攻势将至"
	// TODO: flavor - plain placeholder, rewrite
	if(!faction)
		return "[wave_label]。清剿匪徒，夺回窖藏。"
	return "[wave_label]。清剿[faction.name_plural]，夺回窖藏。"

