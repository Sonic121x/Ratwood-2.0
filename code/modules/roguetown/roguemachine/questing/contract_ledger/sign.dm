/obj/structure/roguemachine/contractledger/proc/play_reject_sound()
	playsound(src, 'sound/misc/machineno.ogg', 80, FALSE, -1)

/obj/structure/roguemachine/contractledger/proc/sign_contract(mob/user, ref)
	if(!ref)
		return
	if(!SStreasury.has_account(user))
		say("[user.real_name]名下并无银行账户记录。")
		play_reject_sound()
		return
	var/datum/quest/Q = locate(ref) in SSquestpool.pool
	if(!Q)
		say("该契约已不再可用。")
		play_reject_sound()
		return
	if(Q.quest_giver_name && Q.quest_giver_name == user.real_name)
		say("你不能签署由你自己发上公告板的契约。")
		play_reject_sound()
		return

	if(is_quest_claim_barred(user))
		say("你的公职禁止你签署契约。把这份差事留给立誓为之的人吧。")
		play_reject_sound()
		return

	if(!is_townie_contract_gate_exempt(user))
		var/elapsed = world.time - SSticker.round_start_time
		if(elapsed < CONTRACT_TOWNIE_GATE_TIME)
			var/remaining_min = round((CONTRACT_TOWNIE_GATE_TIME - elapsed) / (1 MINUTES))
			say("该契约留给佣兵之流。镇民须待 [remaining_min] 分钟后才可签署。")
			play_reject_sound()
			return

	var/active_cap = get_active_quest_cap(user)
	if(count_user_active_contracts(user) >= active_cap)
		say("你已身负 [active_cap] 份契约。先完成一份，再签下一份。")
		play_reject_sound()
		return

	if(SSquestpool.is_on_take_cooldown(user))
		var/remaining_seconds = round(SSquestpool.take_cooldown_remaining(user) / 10)
		say("你已领够了契约。等待 [remaining_seconds] 秒后再签下一份。")
		play_reject_sound()
		return

	var/deposit = Q.deposit_amount
	if(SStreasury.get_balance(user) < deposit)
		say("余额不足。该契约需要 [deposit] 枚玛门的押金。")
		play_reject_sound()
		return

	if(!Q.can_claim(user))
		say(Q.claim_failure_reason(user))
		play_reject_sound()
		return

	if(!SSquestpool.claim(Q, user))
		say("该契约无法派出。请另择一份。")
		play_reject_sound()
		return

	SSquestpool.mark_taken(user)

	var/scroll_type = Q.get_scroll_type()
	var/obj/item/quest_writ/spawned_scroll = new scroll_type(get_turf(src))
	user.put_in_hands(spawned_scroll)
	log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type]")
	spawned_scroll.base_icon_state = Q.get_scroll_icon()
	spawned_scroll.assigned_quest = Q
	Q.quest_scroll = spawned_scroll
	Q.quest_scroll_ref = WEAKREF(spawned_scroll)
	spawned_scroll.update_quest_text()

	SStreasury.burn(SStreasury.get_account(user), deposit, "契约押金")

/obj/structure/roguemachine/contractledger/proc/resolve_turnin_mode(mob/user, obj/item/quest_writ/scroll, mob/living/holder)
	if(user in scroll.get_quest_assignees(user, TRUE))
		return QUEST_TURNIN_SELF
	if(istype(holder))
		var/datum/fellowship/F = holder.current_fellowship
		if(F && F.has_member(user))
			return QUEST_TURNIN_FELLOWSHIP
	if(user.job in GLOB.contract_proxy_officials)
		return QUEST_TURNIN_OFFICIAL
	return null

/obj/structure/roguemachine/contractledger/proc/turn_in_contract(mob/user, obj/item/quest_writ/scroll_in_hand)
	var/datum/quest/Q = scroll_in_hand.assigned_quest
	if(!Q)
		return
	var/mob/living/holder = Q.quest_receiver_reference?.resolve()
	var/mode = resolve_turnin_mode(user, scroll_in_hand, holder)
	if(!mode)
		to_chat(user, span_warning("你并非此契约所指定的任务领取者！"))
		return
	turn_in_scroll(user, scroll_in_hand, mode, holder)

/obj/structure/roguemachine/contractledger/proc/turn_in_scroll(mob/user, obj/item/quest_writ/scroll, mode = QUEST_TURNIN_SELF, mob/holder)
	if(!scroll.assigned_quest?.complete)
		return

	var/datum/quest/completed_quest = scroll.assigned_quest
	var/holder_name = completed_quest.quest_receiver_name
	var/mob/beneficiary = (mode == QUEST_TURNIN_OFFICIAL) ? holder : user
	var/datum/fund/benef_account = SStreasury.get_account(beneficiary)
	if(!benef_account)
		if(mode == QUEST_TURNIN_OFFICIAL)
			say("[holder_name]名下并无账户记录——报酬无法入账。")
		else
			say("无账户记录——交付契约之前，请先到神经锁处登记。")
		return

	var/base_reward = completed_quest.reward_amount
	var/deposit_return = completed_quest.calculate_deposit()
	var/gross_reward = base_reward + deposit_return

	var/quest_levy_exempt = completed_quest.levy_exempt
	if(completed_quest.source == QUEST_SOURCE_TOWNER && hascall(completed_quest, "on_turn_in_pay_giver"))
		call(completed_quest, "on_turn_in_pay_giver")(user, get_turf(src))
	qdel(scroll.assigned_quest)
	qdel(scroll)

	SStreasury.mint(benef_account, gross_reward, "契约报酬 - [src.name]")

	// Levy applies only to the base reward, not the returned deposit. The deposit is the
	// bearer's own money being given back; taxing it would be a hidden levy on principal.
	var/tax_amt = 0
	if(!quest_levy_exempt)
		tax_amt = SStreasury.apply_tax(benef_account, base_reward, TAX_CATEGORY_CONTRACT_LEVY, src.name)
		if(tax_amt > 0)
			record_featured_stat(FEATURED_STATS_TAX_PAYERS, beneficiary, tax_amt)
			record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
	else
		var/levy_rate = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
		SStreasury.record_tax_exemption(TAX_CATEGORY_CONTRACT_LEVY, FLOOR(base_reward * levy_rate, 1))

	var/guild_fee_paid = pay_innkeeper_referral_fees(benef_account, completed_quest, gross_reward)

	var/take_home = gross_reward - tax_amt - guild_fee_paid
	SSquestpool.record_completion(user, completed_quest, take_home, tax_amt)

	var/list/deductions = list()
	if(tax_amt > 0)
		deductions += "[tax_amt] 枚玛门缴纳王室征税"
	if(guild_fee_paid > 0)
		deductions += "[guild_fee_paid] 枚玛门缴纳行会抽成"
	var/deductions_clause = length(deductions) ? "，扣除 [english_list(deductions)]" : ""
	var/deposit_clause = deposit_return > 0 ? " [deposit_return] 枚玛门的押金亦将退还。" : ""
	switch(mode)
		if(QUEST_TURNIN_OFFICIAL)
			say("代[holder_name]之名义，[base_reward] 枚玛门的报酬已记入其账户[deductions_clause]。[deposit_clause]")
		if(QUEST_TURNIN_FELLOWSHIP)
			say("代[holder_name]之名义，你的 [base_reward] 枚玛门报酬已入账[deductions_clause]。[deposit_clause]")
		else
			say("你的 [base_reward] 枚玛门报酬已入账[deductions_clause]。[deposit_clause]")

/obj/structure/roguemachine/contractledger/proc/abandon_by_ref(mob/user, ref)
	if(!ref)
		return
	var/datum/weakref/user_ref = WEAKREF(user)
	var/obj/item/quest_writ/matched_scroll
	var/datum/quest/matched_quest
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.quest_receiver_reference != user_ref)
			continue
		if(REF(Q) != ref)
			continue
		matched_scroll = scroll
		matched_quest = Q
		break
	if(!matched_quest)
		to_chat(user, span_warning("该契约并非由你持有，无法放弃。"))
		return
	if(matched_quest.complete)
		to_chat(user, span_warning("该契约已然完成——请改为交付它。"))
		return
	var/forfeited = matched_quest.calculate_deposit()
	log_quest(user.ckey, user.mind, user, "Abandon [matched_quest.quest_type]")
	SSquestpool.mark_abandoned(user, matched_quest, forfeited)
	to_chat(user, span_warning("契约已作废。你 [forfeited] 枚玛门的押金已被没收。"))
	matched_scroll.assigned_quest = null
	qdel(matched_quest)
	qdel(matched_scroll)
