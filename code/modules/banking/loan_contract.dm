// Loan contracts and indenture writs 
/obj/item/loan_contract
	name = "贷款合同"
	desc = "一份由神经主签发的约束性令状, 带有总管家'的签名. 任何符合资格的持有人均可接受其条款."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper_prep"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	var/issuer_name
	var/issuer_year
	var/principal = 0
	var/term_days = 2
	var/interest_rate = 0.25
	var/total_due = 0
	var/principal_due_on_day = 0
	var/source_fund_id = "crown"

/obj/item/loan_contract/Initialize(mapload)
	. = ..()
	if(!total_due && principal)
		total_due = FLOOR(principal * (1 + (interest_rate * term_days)), 1)

/obj/item/loan_contract/examine(mob/user)
	. = ..()
	var/signature = issuer_name || "神经主"
	var/year = issuer_year || CALENDAR_EPOCH_YEAR
	var/pct = round(interest_rate * 100)
	. += span_info("合同写道: <i>\"兹证明持有人向王权借得[principal]玛门币, 须于接受此贷款后的第[ordinal(term_days)]日全额偿还, 每日按百分之[pct]的单利计息, 合计应还[total_due]玛门币.\"</i>")
	. += span_info("<i>签于[year]年, [signature].</i>")
	. += span_notice("持于手中左键-点击可接受或拒绝其条款.")

/obj/item/loan_contract/proc/ordinal(n)
	if(!isnum(n))
		return "[n]"
	var/suffix = ""
	var/mod100 = n % 100
	if(mod100 < 11 || mod100 > 13)
		switch(n % 10)
			if(1)
				suffix = ""
			if(2)
				suffix = ""
			if(3)
				suffix = ""
	return "[n][suffix]"

/obj/item/loan_contract/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	if(HAS_TRAIT(user, TRAIT_DEBTOR))
		to_chat(user, span_warning("我已被列为拖欠王权债务之人. 我不能再举新债."))
		return
	if(SStreasury.get_loan_for(user))
		to_chat(user, span_warning("我已经欠下王权的债务. 我不能同时背负两笔债务."))
		return
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("我没有神经锁账户来接收这笔款项. 我必须先开户."))
		return
	if(source_fund_id == "church" && (user.job in GLOB.church_positions))
		to_chat(user, span_warning("教会禁止向自己人放贷取息. 伊欧拉'的钱币是给贫苦受难者的, 并非给信徒的."))
		return
	var/datum/fund/preview_fund = SStreasury.resolve_fund_by_id(source_fund_id)
	var/preview_label = preview_fund ? SStreasury.indenture_faction_label(preview_fund) : "未知的出借方"
	var/pct = round(interest_rate * 100)
	var/choice = alert(user, "接受[preview_label]提供的[principal]m贷款, 在[term_days]天后到期且单利为[pct]%/天? 应还总额: [total_due]m.", "来自[preview_label]的贷款", "接受", "拒绝")
	if(choice != "接受")
		to_chat(user, span_notice("我将合同放在一旁, 没有签字."))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(HAS_TRAIT(user, TRAIT_DEBTOR))
		to_chat(user, span_warning("我已被列为拖欠王权债务之人."))
		return
	if(SStreasury.get_loan_for(user))
		to_chat(user, span_warning("我已经欠下王权的债务."))
		return
	var/datum/fund/account = SStreasury.get_account(user)
	if(!account)
		to_chat(user, span_warning("我的神经锁账户不见了."))
		return
	var/datum/fund/issuing_fund = SStreasury.resolve_fund_by_id(source_fund_id)
	if(!issuing_fund)
		to_chat(user, span_warning("令状未列明受认可的出借方. 神经锁无法兑现它."))
		return

	if(issuing_fund == account)
		to_chat(user, span_warning("我不能向自己借款. 神经锁不会兑现这份令状."))
		return

	if(issuing_fund.balance < principal)
		to_chat(user, span_warning("[issuing_fund.name]'的库银不足以兑现这份令状."))
		return
	if(!SStreasury.transfer(issuing_fund, account, principal, "贷款本金"))
		to_chat(user, span_warning("神经锁拒绝转账."))
		return
	if(issuing_fund == SStreasury.discretionary_fund)
		record_treasury_expense(TREASURY_FLOW_LOAN_OUT, treasury_role_of(user), principal)
	var/datum/loan/L = new(user, principal, term_days, interest_rate, issuer_name, issuing_fund)
	SStreasury.loans += L
	record_round_statistic(STATS_LOANS_ISSUED, 1)
	var/lender_label = SStreasury.indenture_faction_label(issuing_fund)
	user.visible_message(span_notice("[user]签署了贷款合同并将[lender_label]'的钱币收入囊中."), \
		span_notice("我接受了[lender_label]提供的[principal]m贷款, 须在[term_days]天后偿还且利率为[pct]%/天. 应还总额: [total_due]m."))
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	send_ooc_note("<b>神经锁:</b> 已收到[lender_label]提供的[principal]m贷款. 将于第[L.due_on_day]天收取[total_due]m.", name = user.real_name)
	qdel(src)

/obj/item/loan_contract/indenture
	name = "契约令状"
	desc = "费伦提亚两个机构之间具有约束力的契约. 只有指定对象'的授权代表才可盖印."
	icon_state = "paper_prep"
	var/target_fund_id

/obj/item/loan_contract/indenture/examine(mob/user)
	. = ..()
	. += span_warning("此契约在接受和违约时均会公开宣告.")
	if(target_fund_id)
		. += span_info("签发对象: [SStreasury.indenture_faction_label(SStreasury.resolve_fund_by_id(target_fund_id))].")

/obj/item/loan_contract/indenture/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	var/datum/fund/issuing_fund = SStreasury.resolve_fund_by_id(source_fund_id)
	var/datum/fund/target_fund = SStreasury.resolve_fund_by_id(target_fund_id)
	if(!issuing_fund || !target_fund)
		to_chat(user, span_warning("契约未列明受认可的当事方. 神经锁无法兑现它."))
		return
	var/obj/structure/roguemachine/vaultbank/target_jawbank = SStreasury.find_jawbank_for_fund_id(target_fund_id)
	if(!target_jawbank)
		to_chat(user, span_warning("[SStreasury.indenture_faction_label(target_fund)]没有颌口金库来接收此契约."))
		return
	if(!target_jawbank.can_accept_indenture(user))
		to_chat(user, span_warning("只有[target_jawbank.get_authority_label()]可以为[SStreasury.indenture_faction_label(target_fund)]的契约盖印."))
		return
	for(var/datum/loan/L in SStreasury.loans)
		if(L.is_institutional && L.target_fund == target_fund)
			to_chat(user, span_warning("[SStreasury.indenture_faction_label(target_fund)]已经有一份尚未清偿的契约."))
			return
	var/pct = round(interest_rate * 100)
	var/choice = alert(user, "代表[SStreasury.indenture_faction_label(target_fund)], 接受[issuing_fund.name]提供的[principal]m借款契约, 在[term_days]天后到期且利率为[pct]%/天? 应还总额: [total_due]m. 此事将公开宣告.", "契约令状", "盖印", "拒绝")
	if(choice != "盖印")
		to_chat(user, span_notice("我将契约放在一旁, 没有盖印."))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(issuing_fund.balance < principal)
		to_chat(user, span_warning("[issuing_fund.name]'的库银不足以兑现此契约."))
		return
	if(!SStreasury.transfer(issuing_fund, target_fund, principal, "契约本金"))
		to_chat(user, span_warning("神经锁拒绝转账."))
		return
	var/datum/loan/L = new(null, principal, term_days, interest_rate, issuer_name, issuing_fund, target_fund)
	SStreasury.loans += L
	record_round_statistic(STATS_LOANS_ISSUED, 1)
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	SStreasury.announce_indenture_acceptance(L, user)
	log_admin("INDENTURE SEALED: [key_name(user)] accepted [principal]m from [issuing_fund.name] on behalf of [target_fund.name] over [term_days]d at [pct]%/day.")
	qdel(src)
