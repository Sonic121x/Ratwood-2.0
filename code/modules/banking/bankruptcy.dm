// Treasury solvency state machine: NORMAL -> IN_ARREARS -> BANKRUPTCY (and back).
// "Azurian Trading Company" renamed to "Ferentian Trading Company" throughout.

/datum/controller/subsystem/treasury/proc/is_in_receivership()
	return treasury_state == TREASURY_BANKRUPTCY

/datum/controller/subsystem/treasury/proc/is_in_arrears_or_worse()
	return treasury_state != TREASURY_NORMAL

/// Dawn payroll insolvency check. Run once per day BEFORE distribute_daily_payments so an
/// arrears advance can cover the day's wages, or sequestration can suspend them, before they
/// are paid out. This is the automatic driver of the same ladder the admin panel's Force
/// Arrears / Force Bankruptcy buttons trigger by hand: from NORMAL, the first shortfall raises
/// arrears (unless a drawn FTC loan already forfeited the grace); a second consecutive shortfall
/// escalates to sequestration.
/datum/controller/subsystem/treasury/proc/evaluate_payroll_solvency()
	if(!steward_machine || !steward_machine.daily_payments || !steward_machine.daily_payments.len)
		return
	var/projected = get_expected_wage_outlay()
	if(projected <= 0)
		return
	if(discretionary_fund.balance >= projected)
		return // the Purse can meet the day's payroll
	switch(treasury_state)
		if(TREASURY_NORMAL)
			// A drawn FTC loan forfeits the arrears grace -> straight to sequestration.
			if(atc_loan_arrears_consumed)
				enter_bankruptcy()
			else
				enter_arrears(projected)
		if(TREASURY_IN_ARREARS)
			enter_bankruptcy() // second consecutive dawn short of payroll
		// TREASURY_BANKRUPTCY: wages already suspended; nothing left to escalate.

/datum/controller/subsystem/treasury/proc/enter_arrears(projected_total)
	if(treasury_state != TREASURY_NORMAL)
		return FALSE
	var/shortfall = max(0, projected_total - discretionary_fund.balance)
	var/loan_amount = max(TREASURY_ARREARS_LOAN, shortfall)
	treasury_state = TREASURY_IN_ARREARS
	treasury_debt += loan_amount
	force_set_round_statistic(STATS_TREASURY_DEBT_OUTSTANDING, treasury_debt)
	record_round_statistic(STATS_ARREARS_DECLARED, 1)
	// Direct credit so the loan itself isn't immediately skimmed against the debt we just registered.
	discretionary_fund.balance += loan_amount
	log_fund_entry(new /datum/treasury_entry("mint", null, discretionary_fund, loan_amount, "费伦提亚贸易公司的欠款垫付"))
	priority_announce(
		"王权的财库在发薪时已空. 费伦提亚市民, 依照常设认捐, 无息垫付 [loan_amount]m 以支付当日的薪资. 若王权明日再次拖欠, 领地将被接管.",
		"市民借款",
		'sound/misc/royal_decree2.ogg',
		"Captain",
	)
	return TRUE

/datum/controller/subsystem/treasury/proc/enter_bankruptcy()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return FALSE
	bankruptcy_count += 1
	record_round_statistic(STATS_BANKRUPTCY_DECLARED, 1)

	// Reset purse to the operating floor. Adjust by difference and log so the ledger reflects
	// the residual being burned (or topped up) rather than a silent assignment.
	if(discretionary_fund.balance > BANKRUPTCY_OPERATING_FLOOR)
		var/excess = discretionary_fund.balance - BANKRUPTCY_OPERATING_FLOOR
		discretionary_fund.balance = BANKRUPTCY_OPERATING_FLOOR
		log_fund_entry(new /datum/treasury_entry("burn", discretionary_fund, null, excess, "接管: 没收金库余款"))
	else if(discretionary_fund.balance < BANKRUPTCY_OPERATING_FLOOR)
		var/topup = BANKRUPTCY_OPERATING_FLOOR - discretionary_fund.balance
		discretionary_fund.balance = BANKRUPTCY_OPERATING_FLOOR
		log_fund_entry(new /datum/treasury_entry("mint", null, discretionary_fund, topup, "接管: 费伦提亚贸易公司的运营储备金"))

	// Existing arrears debt is rolled into the new sequestration debt rather than dropped,
	// so the Crown doesn't escape the smaller obligation by failing harder.
	var/new_debt = BANKRUPTCY_DEBT_FLAT
	treasury_debt += new_debt
	force_set_round_statistic(STATS_TREASURY_DEBT_OUTSTANDING, treasury_debt)
	treasury_state = TREASURY_BANKRUPTCY

	suspend_charters_for_bankruptcy()
	override_trade_for_bankruptcy()
	suspend_wages_for_bankruptcy()

	priority_announce(
		"在没收[atc_seizure_blurb()]以抵偿王权未履行的债务后, 费伦提亚贸易公司 - 备受祝福, 劳作者玛勒姆与梦者阿比索尔最虔诚的仆从 - 慷慨垫付 [BANKRUPTCY_OPERATING_FLOOR]m 的免息储备金并换取对公司 [new_debt]m 的债务. 在债务全部还清前, 公司将接管领地收入并持续包征关税与盐税; 库存与贸易机器均由其掌管, 以确保贸易有序运转并惠及公众. 薪资暂停发放; 除金玺诏书外所有特许状均被废止.",
		"宣布接管",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)
	return TRUE

/datum/controller/subsystem/treasury/proc/suspend_wages_for_bankruptcy()
	if(!steward_machine || !steward_machine.daily_payments)
		return
	var/list/payments = steward_machine.daily_payments
	for(var/mob/living/owner as anything in bank_accounts)
		if(!owner || !(payments[owner.job] > 0))
			continue
		var/datum/fund/account = bank_accounts[owner]
		if(!account || account.wages_suspended)
			continue
		account.wages_suspended = TRUE
		to_chat(owner, span_danger("王权被接管后我的薪资已停发. 领地恢复后将重新发放."))

/datum/controller/subsystem/treasury/proc/resume_wages_after_bankruptcy()
	var/list/payments = steward_machine?.daily_payments
	for(var/mob/living/owner as anything in bank_accounts)
		if(!owner)
			continue
		var/datum/fund/account = bank_accounts[owner]
		if(!account || !account.wages_suspended)
			continue
		account.wages_suspended = FALSE
		if(payments && payments[owner.job] > 0)
			to_chat(owner, span_notice("王权的接管解除后我的薪资已恢复."))

/datum/controller/subsystem/treasury/proc/clear_treasury_debt_state()
	switch(treasury_state)
		if(TREASURY_NORMAL)
			if(atc_loan_arrears_consumed)
				atc_loan_arrears_consumed = FALSE
				priority_announce(
					"王权欠费伦提亚贸易公司的债务已结清. 市民的宽限期已恢复.",
					"费伦提亚贸易公司贷款已结清",
					'sound/misc/royal_decree2.ogg',
					"Captain",
				)
		if(TREASURY_IN_ARREARS)
			exit_arrears()
		if(TREASURY_BANKRUPTCY)
			exit_bankruptcy()

/datum/controller/subsystem/treasury/proc/exit_arrears()
	if(treasury_state != TREASURY_IN_ARREARS)
		return
	treasury_state = TREASURY_NORMAL
	atc_loan_arrears_consumed = FALSE
	priority_announce(
		"王权已结清对市民的欠款. 领地再度恢复偿付能力.",
		"市民款项已偿还",
		'sound/misc/royal_decree2.ogg',
		"Captain",
	)

/datum/controller/subsystem/treasury/proc/exit_bankruptcy()
	if(treasury_state != TREASURY_BANKRUPTCY)
		return
	treasury_state = TREASURY_NORMAL

	// The skim leaves the purse at exactly the operating floor; top up to the recovery target
	// so the Crown has working capital to resume.
	if(discretionary_fund.balance < BANKRUPTCY_RECOVERY_RESET)
		var/topup = BANKRUPTCY_RECOVERY_RESET - discretionary_fund.balance
		discretionary_fund.balance = BANKRUPTCY_RECOVERY_RESET
		log_fund_entry(new /datum/treasury_entry("mint", null, discretionary_fund, topup, "接管解除: 周转资金"))

	resume_wages_after_bankruptcy()
	bankruptcy_concession_picks = BANKRUPTCY_CONCESSION_PICKS
	atc_loan_arrears_consumed = FALSE
	treasury_debt = 0
	force_set_round_statistic(STATS_TREASURY_DEBT_OUTSTANDING, treasury_debt)

	priority_announce(
		"费伦提亚贸易公司归还王权的贸易管理权. 薪资将于明日恢复发放. 领主可, 依据古老特权, 立即恢复最多 [BANKRUPTCY_CONCESSION_PICKS] 份被中止的特许状; 其余仍须遵守颁令之间的惯例间隔.",
		"解除接管",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)

/// Force-suspend bankruptcy-listed Charters, bypassing cooldown and the daily revoke gate -
/// these aren't policy decisions, they're mechanical consequences of default.
/datum/controller/subsystem/treasury/proc/suspend_charters_for_bankruptcy()
	bankruptcy_suspended_decree_ids.Cut()
	for(var/decree_id in BANKRUPTCY_SUSPENDED_DECREES)
		var/datum/decree/D = decrees[decree_id]
		if(!D)
			continue
		if(D.active)
			D.active = FALSE
			D.cooldown_expires = 0
			D.on_revoke()
		D.bankruptcy_suspended = TRUE
		bankruptcy_suspended_decree_ids += decree_id
	steward_machine?.enforce_wage_floors()

/datum/controller/subsystem/treasury/proc/override_trade_for_bankruptcy()
	autoexport_percentage = BANKRUPTCY_AUTOEXPORT_PERCENTAGE
	auto_import_disabled.Cut()
	for(var/good_id in GLOB.trade_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg && tg.importable)
			auto_import_standing[good_id] = TRUE
	dirty_auto_import_view()
	dirty_market_view()

/// Cooldown-free restore of a bankruptcy-suspended charter. Returns TRUE on success.
/datum/controller/subsystem/treasury/proc/restore_charter_via_concession(decree_id)
	if(bankruptcy_concession_picks <= 0)
		return FALSE
	var/datum/decree/D = decrees[decree_id]
	if(!D || !D.bankruptcy_suspended || D.active)
		return FALSE
	D.bankruptcy_suspended = FALSE
	D.active = TRUE
	D.year = CALENDAR_EPOCH_YEAR
	D.cooldown_expires = 0
	D.has_ever_been_active = TRUE
	D.on_restore()
	D.broadcast_state_change()
	bankruptcy_concession_picks -= 1
	bankruptcy_suspended_decree_ids -= decree_id
	steward_machine?.enforce_wage_floors()
	return TRUE

/// Called from set_decree_active before any state change. Golden Bull cannot be revoked
/// during sequestration; bankruptcy-suspended charters are immutable until concession-restored.
/datum/controller/subsystem/treasury/proc/can_mutate_decree(decree_id, new_active)
	if(treasury_state == TREASURY_BANKRUPTCY && decree_id == DECREE_GOLDEN_BULL && !new_active)
		return FALSE
	if(treasury_state != TREASURY_BANKRUPTCY)
		return TRUE
	var/datum/decree/D = decrees[decree_id]
	if(!D)
		return FALSE
	if(D.bankruptcy_suspended)
		return FALSE
	return TRUE

/proc/bankruptcy_state_label(state_value)
	switch(state_value)
		if(TREASURY_NORMAL)
			return "偿付正常"
		if(TREASURY_IN_ARREARS)
			return "欠款中"
		if(TREASURY_BANKRUPTCY)
			return "已被接管"
	return "未知"

/// ATC (Ferentian Trading Company) emergency loan — available throughout the round.
/// Adds debt repaid via future inflow; consumes arrears grace (next missed payroll → sequestration).
/// 已移除紧急贷款的第五天截止限制，保留破产与未还清贷款限制。
/datum/controller/subsystem/treasury/proc/atc_loan_available()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return FALSE
	// 已移除紧急贷款的发放截止日期判断。
	// 不再因游戏天数而返回不可借款。
	return TRUE

/datum/controller/subsystem/treasury/proc/atc_loan_blocker_reason()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return "公司正在管理贸易. 接管解除前不再提供贷款."
	// 已移除紧急贷款窗口关闭的日期判断。
	// 已移除超过截止日的拒绝原因。
	if(atc_loan_arrears_consumed)
		return "先前的垫款尚未偿还. 第一笔贷款结清前公司拒绝再次放贷."
	return null

/datum/controller/subsystem/treasury/proc/take_atc_loan(amount, mob/applicant)
	var/blocker = atc_loan_blocker_reason()
	if(blocker)
		if(applicant)
			to_chat(applicant, span_warning("贷款被拒: [blocker]."))
		return FALSE
	amount = clamp(round(amount), ATC_LOAN_MIN_AMOUNT, ATC_LOAN_MAX_AMOUNT)
	var/debt_owed = round(amount * (1 + ATC_LOAN_INTEREST_RATE))
	treasury_debt += debt_owed
	force_set_round_statistic(STATS_TREASURY_DEBT_OUTSTANDING, treasury_debt)
	atc_loans_drawn_this_round += 1
	atc_loan_arrears_consumed = TRUE
	// Direct credit so principal isn't immediately skimmed against the debt we just registered.
	discretionary_fund.balance += amount
	log_fund_entry(new /datum/treasury_entry("mint", null, discretionary_fund, amount, "费伦提亚贸易公司紧急贷款 (本金)"))
	priority_announce(
		"王权从费伦提亚贸易公司预借 [amount]m 并按惯例支付四分之一的利息, 登记债务 [debt_owed]m. 欠款宽限期就此失效; 若王权下次未能发薪, 领地将直接被接管而不再警告.",
		"王权借款",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)
	log_game("FTC LOAN: [applicant ? key_name(applicant) : "system"] drew [amount]m principal from the Ferentian Trading Company; debt of [debt_owed]m registered")
	return TRUE

GLOBAL_LIST_INIT(atc_seizure_inventory, list(
	"领主的镀金浴盆",
	"王室鹰舍里的一对猎隼",
	"一本鲨皮装帧的彩饰普赛顿圣歌集",
	"描绘猎野猪场景的巨幅奥塔万挂毯",
	"两个伊特鲁斯卡式镀金盐罐",
	"三箱密封的王权珍珠",
	"府邸的圣物匣 (不含圣物)",
	"一架缺了三根销钉的纳莱迪星盘",
	"总管储备的藏红花与肉桂",
	"一副象牙棋具, 缺六枚棋子",
	"一张织锦华盖床, 费了极大力气才拆下",
	"礼拜堂备用的镀金烛台",
	"前任元帅的镶银狩猎号角",
	"一幅早已被遗忘的祖先肖像, 被心怀不满的债务人划破",
	"宫廷献杯官的锡器库存及其钥匙",
	"一只尺寸奢靡得不像话的珠宝镶嵌浴缸",
	"十二桶荒凉海岸烈焰酒, 标明供仲冬宴会使用",
	"一座年代不详的风郡漆衣柜",
	"一本伊特鲁斯卡彩饰异兽志, 被水浸坏",
	"一批赤心发条玩具, 发出微弱的滴答声",
	"珍兽苑的宠物灵猫, 脾气难以捉摸",
	"王权的大座钟, 拆开装了三辆车",
	"一千二百码纳莱迪丝绸, 王权备用的制服衣料",
	"王权储备的盐镇凤尾鱼, 浸油封存",
	"王权应急储备的王田奶酪",
	"两个白牡鹿头, 来自上次王室狩猎的标本",
	"一箱来源不明的未知白色液体, 标着'王权专用 - 不可食用'",
	"一只标着已故总管财产的密封箱",
))

/proc/atc_seizure_blurb()
	var/list/picks = list()
	var/count = rand(2, 3)
	var/list/pool = GLOB.atc_seizure_inventory.Copy()
	for(var/i in 1 to count)
		if(!length(pool))
			break
		var/choice = pick(pool)
		picks += choice
		pool -= choice
	if(length(picks) == 1)
		return picks[1]
	if(length(picks) == 2)
		return "[picks[1]]; 以及[picks[2]]"
	var/last = picks[length(picks)]
	picks.Cut(length(picks), length(picks) + 1)
	return "[jointext(picks, "; ")]; 以及[last]"
