/obj/structure/roguemachine/contractledger
	name = "大契约台账"
	desc = "一本镶着金边的厚重账簿，安放在置有佣兵行会旗帜的底座之上。无数附魔书页间填满了佣兵行会签发的各类契约与悬赏，随着契约的签发与完成，神秘符文不断浮现又褪去。"
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "contractledger"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	layer = GAME_PLANE_UPPER
	/// Turf south of the ledger, marked with a drop-here decal. Retrieval-quest items carry a
	/// component that consumes them on any tile bearing this decal.
	var/input_point
	/// Directive quota tracking. Reset when GLOB.dayspassed advances past directives_day_stamp.
	var/directives_issued_today = 0
	var/directives_day_stamp = -1

/obj/structure/roguemachine/contractledger/Initialize(mapload)
	. = ..()
	input_point = locate(x, y - 1, z)
	var/obj/effect/decal/marker_export/marker = new(get_turf(input_point))
	marker.desc = "将寻回类任务的物品丢弃在此处即可交付。"
	marker.layer = ABOVE_OBJ_LAYER
	SSquestpool.registered_ledgers += src

/obj/structure/roguemachine/contractledger/Destroy()
	SSquestpool.registered_ledgers -= src
	return ..()

/// Lazy-reset of the daily directive quota. Called wherever directive state is read or
/// mutated — cheap comparison, auto-rolls over when GLOB.dayspassed advances.
/obj/structure/roguemachine/contractledger/proc/refresh_directive_quota()
	if(directives_day_stamp != GLOB.dayspassed)
		directives_day_stamp = GLOB.dayspassed
		directives_issued_today = 0

/obj/structure/roguemachine/contractledger/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("<b>左键点击</b>可打开大契约台账，在此可签署新契约，亦可放弃你手中的契约。")
	. += span_info("要<b>交付</b>已完成的契约，请手持任务卷轴点击台账。")
	. += span_info("寻回类任务的物品应<b>丢置于台账前方的标记地砖上</b>。")
	. += span_info("放弃契约会将其押金没收充入王室金库，并使你进入一段短暂的行会冷静期，之后方可放弃下一份契约。")
	. += span_info("取自<b>契约目标</b>的头颅不另计悬赏——契约的报酬即为全额支付。契约之外猎得的野兽与匪徒，仍可在食首机处换得钱币。")
	. += span_info("<b>酒馆老板</b>可在此编写流言契约，消耗流言点数为国度各处播撒寻回、递送与轻量击杀任务。")
	. += span_info("<b>[english_list(GLOB.crown_authority_roles)]</b>可在此委托防御令状——资金出自市民认捐、王室金库，或以无资金的请令形式签发。总管是首要的委托人；总管缺席时由其余人代行。在领主缺席时代行摄政者，在其摄政期内继承委托之权。")
	. += span_info("<b>镇民</b>可用自己的钱币发布契约。契约可钉上公告板，亦可当面转交。<b>[english_list(GLOB.crown_authority_roles)]</b>可委托其中任何一份，但将按双倍价格从王室金库支取。唯有发布者可开启追回之物。")
	. += span_info("若你战死，你的<b>冒险团</b>可代你交付你持有的契约。报酬与征税将记入交付者名下，并适用其免税身份（若有）。")
	. += span_info("<b>[english_list(GLOB.contract_proxy_officials)]</b>可代持有人交付任何已完成的契约，将报酬记入持有人本人的账户。他们不抽取分文。")

/obj/structure/roguemachine/contractledger/attackby(obj/item/P, mob/living/carbon/human/user, params)
	. = ..()
	if(istype(P, /obj/item/quest_writ/blockade))
		post_blockade_writ(user, P)
		return
	if(istype(P, /obj/item/quest_writ))
		turn_in_contract(user, P)
		return
	return

/obj/structure/roguemachine/contractledger/proc/post_blockade_writ(mob/living/carbon/human/user, obj/item/quest_writ/blockade/writ)
	var/datum/quest/kill/blockade_defense/Q = writ.assigned_quest
	if(!istype(Q))
		return
	if(Q.is_directive)
		to_chat(user, span_warning("总管请令不可公开张贴——必须直接交予持令人。"))
		return
	if(Q.quest_receiver_reference)
		to_chat(user, span_warning("此令状已被领取——无法钉上公告板。"))
		return
	if(Q in SSquestpool.pool)
		to_chat(user, span_warning("此令状已钉在台账之上。"))
		return
	if(!Q.blockade_ref?.resolve())
		to_chat(user, span_warning("此令状所应对的封锁已然解除。"))
		return
	Q.required_fellowship_size = BLOCKADE_FELLOWSHIP_REQUIREMENT
	Q.created_at = world.time
	Q.quest_scroll = null
	Q.quest_scroll_ref = null
	writ.assigned_quest = null
	SSquestpool.pool += Q
	var/datum/blockade/B = Q.blockade_ref.resolve()
	if(B)
		B.active_scroll_ref = null
	playsound(src, 'sound/items/inqslip_sealed.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("你将[writ.name]钉在台账上。如今它需要一支[BLOCKADE_FELLOWSHIP_REQUIREMENT]人的冒险团前来应召。"))
	qdel(writ)

/obj/structure/roguemachine/contractledger/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	ui_interact(user)

/obj/structure/roguemachine/contractledger/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/contractledger/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/contractledger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ContractLedger")
		ui.open()

/obj/structure/roguemachine/contractledger/ui_data(mob/user)
	var/list/data = list()
	var/datum/job/mob_job = user?.job ? SSjob.GetJob(user.job) : null
	data["is_handler"] = !!mob_job?.is_quest_giver
	data["balance"] = SStreasury.get_balance(user)
	data["has_account"] = SStreasury.has_account(user)
	var/active_base = mob_job?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	var/active_bonus = get_active_quest_fellowship_bonus(user)
	data["active_max"] = active_base + active_bonus
	data["active_max_base"] = active_base
	data["active_fellowship_bonus"] = active_bonus
	data["active_count"] = count_user_active_contracts(user)
	var/gate_remaining = 0
	if(!is_townie_contract_gate_exempt(user))
		var/elapsed = world.time - SSticker.round_start_time
		if(elapsed < CONTRACT_TOWNIE_GATE_TIME)
			gate_remaining = round((CONTRACT_TOWNIE_GATE_TIME - elapsed) / 10)
	data["townie_gate_remaining"] = gate_remaining
	data["townie_contract_gate_exempt_jobs"] = SSjob.townie_contract_gate_exempt_display_names()
	data["take_cooldown_remaining"] = round(SSquestpool.take_cooldown_remaining(user) / 10)
	var/mob/living/L = user
	var/datum/fellowship/F = istype(L) ? L.current_fellowship : null
	data["user_fellowship_size"] = F ? length(F.get_members()) : 0
	data["pool"] = build_pool_listing()
	data["active"] = build_active_listing(user)
	data["regions"] = build_region_listing()
	data["hoard_recovery_regions"] = build_hoard_recovery_region_listing()
	data["hoard_recovery_pledge"] = HOARD_RECOVERY_PLEDGE
	data["hoard_recovery_fellowship_min"] = BLOCKADE_FELLOWSHIP_REQUIREMENT
	data["hoard_recovery_hoard_min"] = HOARD_RECOVERY_HOARD_MINIMUM
	data["scout_regions"] = SSregionthreat.build_scout_region_rows()
	data["spoils_tax_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_RECOVERED_SPOILS)
	data["tax_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
	data["guild_cut_rate"] = GUILD_REFERRAL_FEE_PCT
	data["can_proxy_turnin"] = (user.job in GLOB.contract_proxy_officials)
	var/list/dynamic_roles = resolve_dynamic_roles(user)
	data["dynamic_roles"] = dynamic_roles
	data["dynamic_role"] = length(dynamic_roles) ? dynamic_roles[1] : null
	if("innkeeper" in dynamic_roles)
		data["rumor_points"] = round(SStreasury.rumor_points, 0.1)
		data["rumor_refill_base"] = RUMOR_POINTS_BASE_REFILL
		data["rumor_refill_per_player"] = RUMOR_POINTS_PER_PLAYER
		data["rumor_active_players"] = get_active_player_count()
		data["rumor_costs"] = GLOB.rumor_point_costs.Copy()
		data["rumor_regions_by_type"] = build_rumor_regions_by_type()
		data["rumor_destinations"] = build_rumor_destinations()
		data["rumor_log"] = SStreasury.rumor_log
		data["rumor_lucrative_mult"] = RUMOR_LUCRATIVE_MULT
		// Per-region reward multipliers powering the Compose tab's "(xN reward)" suffix and the
		// bleak/dangerous/settled flavor line. The builder procs existed but were never wired in.
		data["region_tp_multipliers"] = build_region_tp_multipliers()
		data["region_delivery_multipliers"] = build_region_delivery_multipliers()
	if("steward" in dynamic_roles)
		data["is_alderman_acting"] = (SScity_assembly?.is_alderman(user) && user.job != "Steward") ? TRUE : FALSE
		data["pledge_balance"] = SStreasury.burgher_pledge_fund ? SStreasury.burgher_pledge_fund.balance : 0
		data["pledge_refill_base"] = BURGHER_PLEDGE_BASE_REFILL
		data["pledge_refill_per_player"] = BURGHER_PLEDGE_PER_PLAYER
		data["pledge_active_players"] = get_active_player_count()
		data["pledge_available"] = SStreasury.burgher_pledge_fund ? TRUE : FALSE
		// Guild Charter of Arms tribute contributes a flat bonus to the Pledge refill when active.
		var/datum/decree/arms_charter = SStreasury.get_decree(DECREE_GUILD_CHARTER_OF_ARMS)
		data["pledge_guild_bonus"] = (arms_charter?.active) ? GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS : 0
		var/datum/decree/golden = SStreasury.get_decree(DECREE_GOLDEN_BULL)
		data["pledge_golden_active"] = (golden?.active) ? TRUE : FALSE
		data["crown_purse_balance"] = SStreasury?.discretionary_fund?.balance || 0
		data["defense_costs"] = GLOB.defense_quest_tier_costs.Copy()
		data["defense_regions_by_type"] = build_defense_regions_by_type()
		data["blockade_region_labels"] = build_blockade_region_labels()
		data["defense_destinations"] = build_rumor_destinations()
		// Powers the Commission tab's per-region "(xN reward)" suffix and yield flavor line.
		data["region_tp_multipliers"] = build_region_tp_multipliers()
		data["defense_log"] = SStreasury.defense_log
		data["blockade_recall_list"] = build_blockade_recall_list()
		data["blockade_recall_window_seconds"] = BLOCKADE_RECALL_WINDOW_DS / 10
		data["bonus_pay_light_mult"] = COMMISSION_BONUS_PAY_LIGHT_MULT
		data["bonus_pay_full_mult"] = COMMISSION_BONUS_PAY_MULT
		refresh_directive_quota()
		data["directives_per_day"] = COMMISSION_REQUESTS_PER_DAY
		data["directives_issued_today"] = directives_issued_today
	if("towner" in dynamic_roles)
		data["towner_postings"] = build_towner_posting_listing(user)
		data["towner_purse_balance"] = SStreasury?.discretionary_fund?.balance || 0
	return data

// crown_authority_roles lives in _es_compat.dm (ES 3-role roster: Steward/Clerk/Grand Duke).
// AP's 7-role court list is intentionally NOT ported here (would duplicate-define the global).

GLOBAL_LIST_INIT(crown_authority_roles, list(
	"Steward",
	"Grand Duke",
	"Hand",
	"Clerk",
	"Marshal",
	"Councillor",
	"Prince",
))

GLOBAL_LIST_INIT(contract_proxy_officials, list(
	"Steward",
	"Clerk",
))

/// TRUE if the user has standing to commission defense writs - either by job, or by sitting as
/// the current Regent (Regent inherits commission authority for the duration of their regency,
/// so a Consort or Prince crowned by the Titan gains access they wouldn't otherwise have).
/obj/structure/roguemachine/contractledger/proc/can_commission(mob/user)
	if(!user)
		return FALSE
	if(user.job in GLOB.crown_authority_roles)
		return TRUE
	if(SSticker?.regentmob == user)
		return TRUE
	if(SScity_assembly?.is_alderman(user) && SScity_assembly.current_warrant?.defense_remaining > 0)
		return TRUE
	return FALSE

/obj/structure/roguemachine/contractledger/proc/resolve_dynamic_roles(mob/user)
	var/list/roles = list()
	if(user?.job in GLOB.tavern_positions)
		roles += "innkeeper"
	if(can_commission(user))
		roles += "steward"
	roles += "towner"
	return roles

/obj/structure/roguemachine/contractledger/proc/build_region_listing()
	var/list/known = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		known += TR.region_name
	return known

/obj/structure/roguemachine/contractledger/proc/build_hoard_recovery_region_listing()
	var/list/listing = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(TR.banditry_hoard < HOARD_RECOVERY_HOARD_MINIMUM)
			continue
		// A true blockade takes precedence
		if(TR.has_active_blockade())
			continue
		var/datum/quest/existing = TR.active_hoard_recovery_ref?.resolve()
		listing += list(list(
			"region" = TR.region_name,
			"hoard" = TR.banditry_hoard,
			"danger" = TR.get_danger_level(),
			"active" = (existing && !QDELETED(existing)) ? TRUE : FALSE,
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/request_hoard_recovery(mob/living/carbon/human/user, region_name)
	if(!ishuman(user))
		return
	var/datum/threat_region/TR = SSregionthreat.get_region(region_name)
	if(!TR)
		return
	if(TR.banditry_hoard < HOARD_RECOVERY_HOARD_MINIMUM)
		to_chat(user, span_warning("[TR.region_name]的宝藏低于[HOARD_RECOVERY_HOARD_MINIMUM]枚玛门——你无法为其发起寻宝令状。"))
		return
	if(TR.has_active_blockade())
		to_chat(user, span_warning("[TR.region_name]正处于封锁之中——必须以封锁防御令状将其清除。"))
		return
	var/datum/quest/existing = TR.active_hoard_recovery_ref?.resolve()
	if(existing && !QDELETED(existing))
		to_chat(user, span_warning("一份针对[TR.region_name]的寻宝令状已在外流传。"))
		return
	var/datum/fellowship/F = user.current_fellowship
	if(!F || length(F.get_members()) < BLOCKADE_FELLOWSHIP_REQUIREMENT)
		to_chat(user, span_warning("唯有[BLOCKADE_FELLOWSHIP_REQUIREMENT]人或以上的冒险团方可发起寻宝。"))
		return
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("无账户记录——发起寻宝之前，请先到神经锁处登记。"))
		return
	var/datum/fund/pledge_account = SStreasury.get_account(user)
	if(SStreasury.get_balance(user) < HOARD_RECOVERY_PLEDGE)
		to_chat(user, span_warning("发起寻宝令状需要[HOARD_RECOVERY_PLEDGE]枚玛门的押金。"))
		return
	if(!SStreasury.burn(pledge_account, HOARD_RECOVERY_PLEDGE, "寻宝押金([TR.region_name])"))
		to_chat(user, span_warning("该押金无法从你的账户中扣除。"))
		return
	var/datum/quest/kill/blockade_defense/Q = SSquestpool.issue_hoard_recovery_request(TR, user, pledge_account, HOARD_RECOVERY_PLEDGE)
	if(!Q)
		SStreasury.mint(pledge_account, HOARD_RECOVERY_PLEDGE, "寻宝押金退还(签发失败)")
		to_chat(user, span_warning("此刻无法为[TR.region_name]发起寻宝令状。你的押金已退还。"))
		return
	playsound(src, 'sound/items/inqslip_sealed.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("已为[TR.region_name]签发寻宝令状。"))
	SSquestpool.log_event("hoard_recovery_request", "[user.real_name] called a hoard recovery on [TR.region_name] (hoard [TR.banditry_hoard], pledge [HOARD_RECOVERY_PLEDGE])")

/obj/structure/roguemachine/contractledger/proc/build_pool_listing()
	var/list/listing = list()
	for(var/datum/quest/Q as anything in SSquestpool.pool)
		var/expected_count = Q.progress_required
		var/threat_bands = 0
		if(istype(Q, /datum/quest/kill))
			var/datum/quest/kill/KQ = Q
			threat_bands = KQ.threat_bands_cleared
		var/lapse_minutes = max(0, round((Q.get_lapse_time() - world.time) / 600, 1))
		listing += list(list(
			"ref" = REF(Q),
			"title" = Q.title || "未命名契约",
			"type" = Q.quest_type,
			"difficulty" = Q.quest_difficulty,
			"reward" = Q.reward_amount,
			"deposit" = Q.deposit_amount,
			"area" = Q.target_spawn_area,
			"region" = Q.region,
			"objective" = Q.get_objective_text(),
			"expected_count" = expected_count,
			"threat_bands" = threat_bands,
			"levy_exempt" = Q.levy_exempt,
			"guild_cut_exempt" = Q.guild_cut_exempt,
			"is_rumor" = Q.source == QUEST_SOURCE_RUMOR,
			"is_defense" = Q.source == QUEST_SOURCE_DEFENSE || Q.source == QUEST_SOURCE_BLOCKADE,
			"is_towner" = Q.source == QUEST_SOURCE_TOWNER,
			"is_standing" = Q.source == QUEST_SOURCE_RUMOR || Q.source == QUEST_SOURCE_DEFENSE || Q.source == QUEST_SOURCE_TOWNER || Q.source == QUEST_SOURCE_BLOCKADE,
			"required_fellowship_size" = Q.required_fellowship_size,
			"lapse_minutes" = lapse_minutes,
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/build_active_listing(mob/user)
	var/list/listing = list()
	var/datum/weakref/user_ref = WEAKREF(user)
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q)
			continue
		if(Q.quest_receiver_reference != user_ref)
			continue
		listing += list(list(
			"ref" = REF(Q),
			"title" = Q.title || "未命名契约",
			"type" = Q.quest_type,
			"difficulty" = Q.quest_difficulty,
			"area" = Q.target_spawn_area,
			"region" = Q.region,
			"progress_current" = Q.progress_current,
			"progress_required" = Q.progress_required,
			"complete" = Q.complete,
		))
	return listing

/proc/get_active_quest_fellowship_bonus(mob/user)
	var/mob/living/L = user
	if(!istype(L))
		return 0
	var/datum/fellowship/F = L.current_fellowship
	if(!F || !F.is_leader(L))
		return 0
	var/size = length(F.get_members())
	if(size >= 3)
		return QUEST_ACTIVE_FELLOWSHIP_BONUS_BAND
	if(size >= 2)
		return QUEST_ACTIVE_FELLOWSHIP_BONUS_PAIR
	return 0

/proc/get_active_quest_cap(mob/user)
	var/datum/job/J = user?.job ? SSjob.GetJob(user.job) : null
	var/base = J?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	return base + get_active_quest_fellowship_bonus(user)

/obj/structure/roguemachine/contractledger/proc/count_user_active_contracts(mob/user)
	var/datum/weakref/user_ref = WEAKREF(user)
	var/count = 0
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.complete)
			continue
		if(Q.quest_receiver_reference == user_ref)
			count++
	return count

/obj/structure/roguemachine/contractledger/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!user?.Adjacent(src))
		return TRUE
	switch(action)
		if("sign")
			sign_contract(user, params["ref"])
			return TRUE
		if("abandon")
			abandon_by_ref(user, params["ref"])
			return TRUE
		if("compose_rumor")
			compose_rumor_from_tgui(user, params)
			return TRUE
		if("commission_defense")
			commission_defense_from_tgui(user, params)
			return TRUE
		if("recall_blockade_writ")
			recall_blockade_writ_from_tgui(user, params)
			return TRUE
		if("compose_towner")
			compose_towner_from_tgui(user, params)
			return TRUE
		if("request_hoard_recovery")
			request_hoard_recovery(user, params["region"])
			return TRUE
