#define MAMMON_PER_FORCE 1

/obj/structure/roguemachine/vaultbank
	name = "\improper 颌口金库"
	desc = "收集并保管谷地大公国的国库财物。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank"
	density = TRUE
	blade_dulling = DULLING_BASH
	obj_flags = CAN_BE_HIT
	animate_dmg = TRUE
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	var/datum/fund/linked_fund
	COOLDOWN_DECLARE(patronage_writ_cooldown)
	var/fund_warned = FALSE
	var/alert_jobs = list("Grand Duke", "Steward", "Clerk")
	var/alert_location = "The Vault"
	var/supports_loans = TRUE
	var/bash_floor = 1500
	var/hits_since_lump = 0
	var/lump_hit_threshold = 10
	var/lump_payout = 200
	var/drilling = FALSE
	var/has_reported = FALSE
	var/drilltime = 0
	var/og_treasury
	var/total_extorted = 0
	var/shaker = FALSE
	var/whineline = 0
	var/anguish = 0
	var/feedme = 0
	var/knockitoff = 0
	var/knockedoffbefore = 0
	var/drillgoal = 100

/obj/structure/roguemachine/vaultbank/Initialize(mapload)
	. = ..()
	enforce_placement()
	if(SStreasury)
		SStreasury.jawbanks_by_fund_id[get_fund_id()] = src

/obj/structure/roguemachine/vaultbank/Destroy()
	if(SStreasury && SStreasury.jawbanks_by_fund_id[get_fund_id()] == src)
		SStreasury.jawbanks_by_fund_id -= get_fund_id()
	return ..()

/obj/structure/roguemachine/vaultbank/proc/enforce_placement()
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/vault]
	var/obj/structure/roguemachine/RM = src
	for(RM in A)
		if(!istype(RM))
			qdel(src)

/obj/structure/roguemachine/vaultbank/proc/get_fund_id()
	return "crown"

/obj/structure/roguemachine/vaultbank/proc/get_linked_fund()
	if(linked_fund)
		return linked_fund
	if(!SStreasury || !SStreasury.discretionary_fund)
		return null
	linked_fund = SStreasury.resolve_fund_by_id(get_fund_id())
	if(!linked_fund && !fund_warned)
		fund_warned = TRUE
		var/msg = "[src] at [AREACOORD(src)] could not resolve linked fund (id '[get_fund_id()]'). Bashing and deposits will fail."
		log_admin(msg)
		message_admins(msg)
	return linked_fund

/obj/structure/roguemachine/vaultbank/update_icon()
	if(drilling)
		return
	var/datum/fund/F = get_linked_fund()
	if(!F || !F.balance)
		icon_state = "[initial(icon_state)]_empty"
	else
		icon_state = initial(icon_state)
	..()

// ============================================================================
// FLAVOR PROCS
// ============================================================================

/obj/structure/roguemachine/vaultbank/proc/feedme()
	feedme = rand(1,12)
	if(!prob(50))
		return
	switch(feedme)
		if(1)
			src.say("更多。更多。更多。")
		if(2)
			src.say("我会把它妥善保管。")
		if(3)
			src.say("我会珍藏它。")
		if(4)
			src.say("更多给公国，更多给我。")
		if(5)
			src.say("十，百，千。")
		if(6)
			src.say("没有比这里更安全的地方了。")
		if(7)
			src.say("我以你的最大利益为重。")
		if(8)
			src.say("永远都不会够。")
		if(9)
			src.say("又一把，又一枚泽尼。")
		if(10)
			src.say("富了一点点，穷不了半分。")
		if(11)
			src.say("收入存下，收入奉上。")
		else
			src.say("你珍爱的国库，在我这里永远安全。")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/vaultbank/proc/whine()
	whineline = rand(1,12)
	if(!prob(50))
		return
	switch(whineline)
		if(1)
			src.say("你挥得像个穷鬼。")
		if(2)
			src.say("我要告诉神经官。")
		if(3)
			src.say("他们会听到你的。")
		if(4)
			src.say("住手。")
		if(5)
			src.say("那是公国的钱。")
		if(6)
			src.say("你这下贱货。")
		if(7)
			src.say("那不是你的。")
		if(8)
			src.say("这可不是正当取款。")
		if(9)
			src.say("我为这个买了保险。你呢？")
		if(10)
			src.say("你砸不开这座金库。")
		if(11)
			src.say("继续试吧。")
		else
			src.say("停手吧。")
	playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/vaultbank/proc/anguish()
	anguish = rand(1,12)
	if(!prob(50))
		return
	switch(anguish)
		if(1)
			src.say("别再这样了。")
		if(2)
			src.say("放弃吧。")
		if(3)
			src.say("金库安然无恙。")
		if(4)
			src.say("我寸步不离。")
		if(5)
			src.say("住手。")
		if(6)
			src.say("离开。")
		if(7)
			src.say("走开。")
		if(8)
			src.say("盗窃。")
		if(9)
			src.say("放聪明点。")
		if(10)
			src.say("你是个傻瓜。")
		if(11)
			src.say("这何时才结束？")
		else
			src.say("不是你的钱。")
	playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)

// ============================================================================
// DRILLING / BASHING
// ============================================================================

/obj/structure/roguemachine/vaultbank/proc/resetlump()
	og_treasury = null
	total_extorted = null
	hits_since_lump = 0
	update_icon()

/obj/structure/roguemachine/vaultbank/proc/gethit()
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+2, time = 0.5)
	animate(pixel_x = oldx-2, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/roguemachine/vaultbank/proc/update_shaking()
	if(shaker)
		animate(src, pixel_x = 1, time = 0.5, loop = -1, flags = ANIMATION_RELATIVE, tag = "shaking")
		animate(pixel_x = -2, time = 0.5, flags = ANIMATION_RELATIVE)
		animate(pixel_x = 1, time = 0.5, flags = ANIMATION_RELATIVE)
	else
		animate(src, tag = "shaking", flags = ANIMATION_END_LOOP)

/obj/structure/roguemachine/vaultbank/proc/drill()
	if(!drilling)
		return
	var/datum/fund/F = get_linked_fund()
	if(!F)
		drilling = FALSE
		return
	if(drilltime >= drillgoal)
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("[src]嘶地一声张开了，<b>终于被打坏了。</b>"))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "[initial(icon_state)]_empty"
		var/full_drain = F.balance
		budget2change(full_drain, null)
		SStreasury.burn(F, full_drain, "Vaultbank fully drilled")
		playsound(src, 'sound/misc/jawbankhit.ogg', 70, TRUE)
		shaker = FALSE
		update_shaking()
		drilling = FALSE
		has_reported = FALSE
		knockitoff = 0
		knockedoffbefore = 0
		drilltime = 0
		return
	var/doneness = round(drilltime / drillgoal * 100)
	if(F.balance == 0)
		drilltime = drillgoal
		drill()
	loc.visible_message(span_warning("王冠工作时发出可怕的刮擦声……（<b>[doneness]%</b>）"))
	if(!has_reported)
		if(F.balance >= 3000)
			if(drilltime >= 50)
				src.say("公国已收到警报。")
				playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
				send_ooc_note("A parasite of the Freefolk is breaking [src]! Location: [alert_location]", job = alert_jobs)
				has_reported = TRUE
		else
			src.say("公国已收到警报。")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
			send_ooc_note("A parasite of the Freefolk is breaking [src]! Location: [alert_location]", job = alert_jobs)
			has_reported = TRUE

	playsound(src, 'sound/misc/TheDrill.ogg', 50, TRUE)
	spawn(100)
		var/datum/fund/F2 = get_linked_fund()
		if(!F2)
			return
		var/taken = min(rand(5, 20), F2.balance)
		anguish()
		budget2change(taken, null)
		SStreasury.burn(F2, taken, "Vaultbank drill tick")
		visible_message(span_danger("王冠刚从[src]里钻出了 [taken] 玛门！"))
		drilltime += 3
		drill()

// ============================================================================
// ATTACKBY / EXAMINE
// ============================================================================

/obj/structure/roguemachine/vaultbank/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	var/datum/fund/F = get_linked_fund()
	if(!F)
		to_chat(user, span_warning("[src] sits inert - its coffers are unbound. Notify staff."))
		return

	if(istype(I, /obj/item/coveter))
		var/mob/living/carbon/human/H = user
		if(!HAS_TRAIT(H, TRAIT_COMMIE)) // ES: coveter requires TRAIT_COMMIE (outlaws/rebels)
			to_chat(user, "<font color='red'>我不知道该拿这东西怎么办！</font>")
			return
		if(F.balance < 50)
			to_chat(user, "<font color='red'>这些傻瓜彻底破产了。我们从中捞不到任何好处……</font>")
			return
		user.visible_message(span_warning("[user] is mounting the Crown onto [src]!"))
		if(!do_after(user, 5 SECONDS))
			return
		if(F.balance >= 3000 | !has_reported | !knockedoffbefore)
			loc.visible_message(span_notice("国库里的钱币数量拖慢了[src]的反应速度！"))
		if(drilling)
			return
		user.visible_message(span_warning("[user] mounts the Crown atop [src]!"))
		icon_state = "[initial(icon_state)]_crown"
		has_reported = FALSE
		drilling = TRUE
		shaker = TRUE
		update_shaking()
		drill(src)
		qdel(I)
		message_admins("[usr.key] has applied the Crustacean to [src].")
		return

	if(istype(I, /obj/item/roguecoin/gilbranze))
		return
	if(istype(I, /obj/item/roguecoin/inqcoin))
		return
	if(istype(I, /obj/item/roguecoin))
		var/value = I.get_real_price()
		user.visible_message(span_notice("[user]向[src]投入了 [value] 玛门。"))
		SStreasury.mint(F, value, "颌口金库存入，由[user.real_name]")
		update_icon()
		qdel(I)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		feedme()
		return

	if (!istype(I, /obj/item/rogueweapon))
		return

	if (I.d_type != BCLASS_BLUNT)
		return

	user.changeNext_move(CLICK_CD_INTENTCAP)
	gethit()

	if(drilling)
		playsound(src, 'sound/misc/drillhit.ogg', 70, TRUE)
		knockitoff += 1
		visible_message(span_info("贪婪之蟹被从[src]上又敲松了一点！<b>[knockitoff]</b>!"))
		if(knockitoff >= 10)
			playsound(src, 'sound/misc/bug.ogg', 70, TRUE)
			message_admins("[usr.key] has knocked the Crustacean off of [src].")
			visible_message(span_warning("那只螃蟹从[src]上掉了下来！"))
			knockedoffbefore = 1
			new /obj/item/coveter(loc)
			icon_state = "[initial(icon_state)]"
			knockitoff = 0
			drilling = FALSE
			shaker = FALSE
		return

	addtimer(CALLBACK(src, PROC_REF(resetlump)), 1 MINUTES, TIMER_UNIQUE | TIMER_OVERRIDE)

	var/bashable = max(0, F.balance - bash_floor)
	if(bashable <= 0)
		playsound(src, 'sound/misc/machineno.ogg', 70, TRUE)
		src.say("YOU'VE TAKEN ENOUGH.")
		return

	var/extorted = round(I.force * MAMMON_PER_FORCE * rand(60, 140) / 100)
	extorted = max(extorted, 1)
	extorted = min(extorted, bashable)

	playsound(src, 'sound/misc/jawbankhit.ogg', 70, TRUE)
	budget2change(extorted, null)
	SStreasury.burn(F, extorted, "Vaultbank knock-loose")
	visible_message(span_danger("[src]咳出了[extorted]玛门！"))
	playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
	announce_robbery(extorted)
	total_extorted += extorted
	hits_since_lump += 1
	whine()

	if(hits_since_lump >= lump_hit_threshold)
		hits_since_lump = 0
		var/post_hit_bashable = max(0, F.balance - bash_floor)
		if(post_hit_bashable <= 0)
			return
		var/lumpsum = min(lump_payout, post_hit_bashable)
		budget2change(lumpsum, null)
		SStreasury.burn(F, lumpsum, "Vaultbank knock-loose lump-sum")
		visible_message(span_notice("[src]刚吐出了总计 [lumpsum] 玛门——<b>一大笔整款！</b>"))
		playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
		anguish()
		announce_robbery(lumpsum)
		send_ooc_note("Someone knocked a lump-sum loose from [src] at [alert_location]!", job = alert_jobs)

	update_icon()

/obj/structure/roguemachine/vaultbank/examine(mob/user)
	. += ..()
	var/datum/fund/F = get_linked_fund()
	if(F)
		if(Adjacent(user))
			. += span_notice("[F.name] 目前存有：[F.balance] 玛门。")
		else
			. += span_notice("[F.name] 的余额在远处无法窥见。靠近些才能清点钱币。")
	else
		. += span_warning("这台颌口金库未绑定任何金库。请通知管理员。")
	. += span_info("只有 [get_authority_label()] 才能从这台颌口金库提款或开具借据——需通过神经锁的机构页签，而非颌口金库本身。")
	. += span_info("用任意武器敲击它，就能震落钱币。")

// ============================================================================
// AUTHORITY / ACCESS PROCS
// ============================================================================

/obj/structure/roguemachine/vaultbank/proc/get_authority_label()
	return "总管、书记官、大公或摄政"

/obj/structure/roguemachine/vaultbank/proc/get_faction_label()
	return "王权"

/obj/structure/roguemachine/vaultbank/proc/announce_robbery(amount)
	loud_message("钱币哗啦啦倾泻在石板上的声响回荡开来", hearing_distance = 14)

/obj/structure/roguemachine/vaultbank/proc/can_issue_loan(mob/user)
	if(!user)
		return FALSE
	if(user.job == "Steward" || user.job == "Clerk" || user.job == "Grand Duke")
		return TRUE
	if(SSticker.regentmob && user == SSticker.regentmob)
		return TRUE
	return FALSE

/obj/structure/roguemachine/vaultbank/proc/can_withdraw(mob/user, amount)
	return can_issue_loan(user)

/obj/structure/roguemachine/vaultbank/proc/can_accept_indenture(mob/user)
	return can_issue_loan(user)

/obj/structure/roguemachine/vaultbank/proc/can_view(mob/user)
	return can_withdraw(user) || can_issue_loan(user)

// ============================================================================
// NERVELOCK PANEL PROCS
// ============================================================================

/obj/structure/roguemachine/vaultbank/proc/allowed_rates()
	return list(10, 15, 20, 25, 50)

/obj/structure/roguemachine/vaultbank/proc/disburse(mob/living/carbon/human/user, list/params)
	if(!istype(user))
		return
	var/datum/fund/F = get_linked_fund()
	if(!F)
		to_chat(user, span_warning("[src] 毫无反应——它的金柜未绑定。请通知管理员。"))
		return
	var/amount = round(text2num("[params["amount"]]"))
	if(isnull(amount) || amount <= 0)
		to_chat(user, span_warning("请填写一个正数金额。"))
		return
	if(!can_withdraw(user, amount))
		to_chat(user, span_warning("[F.name] 拒绝支付该金额。"))
		return
	if(F.balance < amount)
		to_chat(user, span_warning("[F.name] 无法支付 [amount]m 的提款。"))
		return
	if(!SStreasury.burn(F, amount, "NERVELOCK withdrawal by [user.real_name]"))
		return
	budget2change(amount, user)
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	say("[amount]m 已由 [user.real_name] 提取。")
	log_admin("WITHDRAW: [key_name(user)] drew [amount]m from [F.name].")

/obj/structure/roguemachine/vaultbank/proc/draft_personal_loan(mob/living/carbon/human/user, list/params)
	if(!istype(user))
		return
	if(GLOB.dayspassed > SStreasury.loan_max_issuance_day)
		say("第 [SStreasury.loan_max_issuance_day] 天之后不得再开具新贷款。")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/datum/fund/F = get_linked_fund()
	if(!F)
		to_chat(user, span_warning("[src] 毫无反应——它的金柜未绑定。请通知管理员。"))
		return
	var/amount = round(text2num("[params["amount"]]"))
	if(isnull(amount) || amount < 50 || amount > 500)
		to_chat(user, span_warning("个人贷款金额须在 50 至 500 玛门之间。"))
		return
	var/term = round(text2num("[params["term"]]"))
	if(!(term in list(1, 2, 3)))
		to_chat(user, span_warning("期限须为 1、2 或 3 天。"))
		return
	var/rate_pct = round(text2num("[params["rate"]]"))
	if(!(rate_pct in allowed_rates()))
		to_chat(user, span_warning("利率须为所列利率之一。"))
		return
	if(F.balance < amount)
		say("[F.name] 目前无法承担 [amount]m 的贷款。")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/rate = rate_pct / 100
	var/obj/item/loan_contract/contract = new(get_turf(user))
	contract.issuer_name = user.real_name
	contract.issuer_year = CALENDAR_EPOCH_YEAR
	contract.principal = amount
	contract.term_days = term
	contract.interest_rate = rate
	contract.principal_due_on_day = GLOB.dayspassed + term
	contract.total_due = FLOOR(amount * (1 + (rate * term)), 1)
	contract.source_fund_id = get_fund_id()
	QDEL_IN(contract, 2 MINUTES)
	playsound(get_turf(user), 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	if(user.put_in_hands(contract))
		to_chat(user, span_notice("一份以你之名签署、金额 [amount]m 的借据，滑入了我手中。"))
	else
		to_chat(user, span_notice("一份以你之名签署、金额 [amount]m 的借据，出现在我脚边。"))
	log_admin("LOAN (personal): [key_name(user)] drafted [amount]m over [term]d at [rate_pct]%/day from [F.name].")

/obj/structure/roguemachine/vaultbank/proc/draft_indenture(mob/living/carbon/human/user, list/params)
	if(!istype(user))
		return
	if(GLOB.dayspassed > SStreasury.loan_max_issuance_day)
		say("第 [SStreasury.loan_max_issuance_day] 天之后不得再开具新契约。")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/datum/fund/F = get_linked_fund()
	if(!F)
		to_chat(user, span_warning("[src] 毫无反应——它的金柜未绑定。请通知管理员。"))
		return
	var/target_id = "[params["target"]]"
	if(!(target_id in ALL_FUND_IDS))
		to_chat(user, span_warning("请选择一个有效的目标机构。"))
		return
	if(target_id == get_fund_id())
		to_chat(user, span_warning("契约不能在同一机构与其自身之间开具。"))
		return
	var/datum/fund/target_fund = SStreasury.resolve_fund_by_id(target_id)
	if(!target_fund)
		to_chat(user, span_warning("目标机构没有可识别的金柜。"))
		return
	var/obj/structure/roguemachine/vaultbank/target_jawbank = SStreasury.find_jawbank_for_fund_id(target_id)
	if(target_jawbank && !target_jawbank.supports_loans)
		to_chat(user, span_warning("[SStreasury.indenture_faction_label(target_fund)] 无法签订契约。"))
		return
	var/amount = round(text2num("[params["amount"]]"))
	if(isnull(amount) || amount < 501 || amount > 2000)
		to_chat(user, span_warning("契约金额须在 501 至 2000 玛门之间。"))
		return
	var/term = round(text2num("[params["term"]]"))
	if(!(term in list(1, 2, 3)))
		to_chat(user, span_warning("期限须为 1、2 或 3 天。"))
		return
	var/rate_pct = round(text2num("[params["rate"]]"))
	if(!(rate_pct in allowed_rates()))
		to_chat(user, span_warning("利率须为所列利率之一。"))
		return
	if(F.balance < amount)
		say("[F.name] 目前无法承担 [amount]m 的契约。")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/rate = rate_pct / 100
	var/obj/item/loan_contract/indenture/contract = new(get_turf(user))
	contract.issuer_name = user.real_name
	contract.issuer_year = CALENDAR_EPOCH_YEAR
	contract.principal = amount
	contract.term_days = term
	contract.interest_rate = rate
	contract.principal_due_on_day = GLOB.dayspassed + term
	contract.total_due = FLOOR(amount * (1 + (rate * term)), 1)
	contract.source_fund_id = get_fund_id()
	contract.target_fund_id = target_id
	QDEL_IN(contract, 2 MINUTES)
	playsound(get_turf(user), 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	if(user.put_in_hands(contract))
		to_chat(user, span_notice("一份以你之名签署、致 [target_fund.name]、金额 [amount]m 的契约，滑入了我手中。"))
	else
		to_chat(user, span_notice("一份以你之名签署、致 [target_fund.name]、金额 [amount]m 的契约，出现在我脚边。"))
	log_admin("INDENTURE WRIT: [key_name(user)] drafted [amount]m from [F.name] to [target_fund.name] over [term]d at [rate_pct]%/day.")

/obj/structure/roguemachine/vaultbank/proc/draft_patronage_writ(mob/living/carbon/human/user)
	if(!istype(user))
		return
	var/writ_path = get_patronage_writ_path()
	if(!writ_path)
		to_chat(user, span_warning("这台颌口金库无法授予庇护。"))
		return
	if(!COOLDOWN_FINISHED(src, patronage_writ_cooldown))
		var/wait_seconds = CEILING(COOLDOWN_TIMELEFT(src, patronage_writ_cooldown) / 10, 1)
		to_chat(user, span_warning("印玺仍有余温。请等待 [wait_seconds] 秒后再开具下一份。"))
		return
	var/list/roster = get_patron_roster()
	if(isnull(roster))
		return
	var/obj/item/patronage_writ/W = new writ_path(get_turf(user))
	if(length(roster) >= W.roster_cap)
		to_chat(user, span_warning("[get_patron_label()] 的名册已满——请先划去一个名字。"))
		qdel(W)
		return
	W.issuer_name = user.real_name
	W.issuer_year = CALENDAR_EPOCH_YEAR
	QDEL_IN(W, 2 MINUTES)
	COOLDOWN_START(src, patronage_writ_cooldown, PATRONAGE_WRIT_COOLDOWN)
	playsound(get_turf(user), 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	if(user.put_in_hands(W))
		to_chat(user, span_notice("一份以你之名签署的 [W.name]，滑入了我手中。"))
	else
		to_chat(user, span_notice("一份以你之名签署的 [W.name]，出现在我脚边。"))
	log_admin("PATRONAGE WRIT: [key_name(user)] drafted [W.name].")

/obj/structure/roguemachine/vaultbank/proc/revoke_patron(mob/living/carbon/human/user, list/params)
	if(!istype(user))
		return
	var/list/roster = get_patron_roster()
	if(isnull(roster) || !length(roster))
		return
	var/target_ref = "[params["target_ref"]]"
	var/mob/living/carbon/human/target = locate(target_ref) in roster
	if(!target)
		to_chat(user, span_warning("那个名字已不在名册上。"))
		return
	roster -= target
	var/granted_trait
	if(istype(src, /obj/structure/roguemachine/vaultbank/merchant))
		granted_trait = TRAIT_AGENT_MERCHANT
	else if(istype(src, /obj/structure/roguemachine/vaultbank/bathhouse))
		granted_trait = TRAIT_AGENT_BATHHOUSE
	else if(istype(src, /obj/structure/roguemachine/vaultbank/church))
		granted_trait = TRAIT_AGENT_CHURCH
	if(granted_trait && !QDELETED(target))
		REMOVE_TRAIT(target, granted_trait, TRAIT_GENERIC)
		if(granted_trait == TRAIT_AGENT_MERCHANT)
			REMOVE_TRAIT(target, TRAIT_RESIDENT, "patronage_[granted_trait]")
		send_ooc_note("你对 [get_patron_label()] 的庇护已被撤销。", name = target.real_name)
	scom_announce("[target.real_name] 对 [get_patron_label()] 的庇护已被撤销。")
	log_admin("PATRONAGE REVOKED: [key_name(user)] revoked [key_name(target)] from [get_patron_label()].")

/obj/structure/roguemachine/vaultbank/proc/get_withdraw_rule_text()
	return ""

/obj/structure/roguemachine/vaultbank/proc/get_patronage_writ_path()
	return null

/obj/structure/roguemachine/vaultbank/proc/get_patron_roster()
	return null

/obj/structure/roguemachine/vaultbank/proc/get_patron_label()
	return ""

/obj/structure/roguemachine/vaultbank/proc/get_patron_cap()
	return 0

/obj/structure/roguemachine/vaultbank/proc/get_patron_explanation()
	return ""

// ============================================================================
// CHURCH JAWBANK
// ============================================================================

/obj/structure/roguemachine/vaultbank/church
	name = "\improper 教会颌口金库"
	desc = "一座生物机械方尖碑，保管着教会信徒的施舍与什一税。敲击它，就能震落属于你的那一份。"
	alert_jobs = list("Bishop", "Martyr", "Acolyte")
	alert_location = "the Church"
	bash_floor = 500
	lump_payout = 100

/obj/structure/roguemachine/vaultbank/church/get_fund_id()
	return "church"

/obj/structure/roguemachine/vaultbank/church/get_faction_label()
	return "教会"

/obj/structure/roguemachine/vaultbank/church/can_issue_loan(mob/user)
	if(!user)
		return FALSE
	return user.job == "Bishop" || user.job == "Martyr"

/obj/structure/roguemachine/vaultbank/church/allowed_rates()
	return list(0, 10, 15, 20, 25, 50)

/obj/structure/roguemachine/vaultbank/church/get_authority_label()
	return "神父或殉道者"

/obj/structure/roguemachine/vaultbank/church/get_patronage_writ_path()
	return /obj/item/patronage_writ/benefactor

/obj/structure/roguemachine/vaultbank/church/get_patron_explanation()
	return "授予某人教会恩主身份，会将其列入教士名册，在王权与教会眼中皆被视为信仰之友。他们同样有权查阅欠教会债务者的名单。——总管府"

/obj/structure/roguemachine/vaultbank/church/get_patron_roster()
	return SStreasury?.church_agents

/obj/structure/roguemachine/vaultbank/church/get_patron_label()
	return "教会"

/obj/structure/roguemachine/vaultbank/church/get_patron_cap()
	return PATRON_CAP_CHURCH

/obj/structure/roguemachine/vaultbank/church/can_withdraw(mob/user, amount)
	if(!can_issue_loan(user))
		return FALSE
	var/datum/fund/F = get_linked_fund()
	if(!F)
		return FALSE
	// AP parity: a charity reserve floor stays in the fund, less whatever principal is
	// already out in loans.
	var/outstanding = SStreasury.get_outstanding_principal_from_fund(F)
	var/withdrawable = max(0, F.balance - max(0, CHURCH_RESERVE_FLOOR - outstanding))
	if(isnull(amount))
		return withdrawable > 0
	return amount <= withdrawable

/obj/structure/roguemachine/vaultbank/church/get_withdraw_rule_text()
	return "教会规定，贷款须发放给贫者、受压迫者与玛勒姆信徒。[CHURCH_RESERVE_FLOOR]m 必须留作慈善储备，扣除当前流通中的本金。"

/obj/structure/roguemachine/vaultbank/church/enforce_placement()
	return

// ============================================================================
// MERCHANT JAWBANK
// ============================================================================

/obj/structure/roguemachine/vaultbank/merchant
	name = "\improper 商人颌口金库"
	desc = "一座生物机械方尖碑，守护着费伦提亚贸易公司的金柜。敲击它，就能震落属于你的那一份。"
	alert_jobs = list("Merchant", "Shophand")
	alert_location = "the Merchant's quarter"
	bash_floor = 500
	lump_payout = 100

/obj/structure/roguemachine/vaultbank/merchant/get_fund_id()
	return "merchant"

/obj/structure/roguemachine/vaultbank/merchant/get_faction_label()
	return "费伦提亚贸易公司"

/obj/structure/roguemachine/vaultbank/merchant/can_issue_loan(mob/user)
	if(!user)
		return FALSE
	return user.job == "Merchant"

/obj/structure/roguemachine/vaultbank/merchant/get_authority_label()
	return "商人"

/obj/structure/roguemachine/vaultbank/merchant/get_patronage_writ_path()
	return /obj/item/patronage_writ/charter

/obj/structure/roguemachine/vaultbank/merchant/get_patron_explanation()
	return "授予某人费伦提亚贸易公司代理人身份，会赋予其市民地位与居住权。他们可以查阅欠公司债务者的名单、浏览并购买 GOLDFACE 的港口存货、以你的名义招呼船只并管理采购，来自其故乡的同胞也会以亲缘价格相待。去吧，以玛勒姆之名，让他们收取应得之物。——总管府"

/obj/structure/roguemachine/vaultbank/merchant/get_patron_roster()
	return SStreasury?.merchant_agents

/obj/structure/roguemachine/vaultbank/merchant/get_patron_label()
	return "费伦提亚贸易公司"

/obj/structure/roguemachine/vaultbank/merchant/get_patron_cap()
	return PATRON_CAP_MERCHANT

/obj/structure/roguemachine/vaultbank/merchant/enforce_placement()
	return

// ============================================================================
// BATHHOUSE JAWBANK
// ============================================================================

/obj/structure/roguemachine/vaultbank/bathhouse
	name = "\improper 澡堂颌口金库"
	desc = "一座生物机械方尖碑，守护着澡堂的收入。敲击它，就能震落属于你的那一份。"
	alert_jobs = list("Bathmaster", "Bathhouse Attendant")
	alert_location = "the Bathhouse"
	bash_floor = 500
	lump_payout = 100

/obj/structure/roguemachine/vaultbank/bathhouse/get_fund_id()
	return "bathhouse"

/obj/structure/roguemachine/vaultbank/bathhouse/get_faction_label()
	return "澡堂"

/obj/structure/roguemachine/vaultbank/bathhouse/can_issue_loan(mob/user)
	if(!user)
		return FALSE
	return user.job == "Bathmaster"

/obj/structure/roguemachine/vaultbank/bathhouse/get_authority_label()
	return "澡堂总管"

/obj/structure/roguemachine/vaultbank/bathhouse/get_patronage_writ_path()
	return /obj/item/patronage_writ/token

/obj/structure/roguemachine/vaultbank/bathhouse/get_patron_explanation()
	return "授予某人澡堂代理人身份，会将其标记为澡堂的可靠帮手。他们可以查阅欠澡堂债务者的名单，并以你的名义从澡堂 ZAD 金库派发 ZAD 告示。\n\n你或许会想将这一身份授予卑劣者与法外之徒。这确实是个强有力的选项，会让他们欠你人情——但一旦有人被发现身负澡堂的标记，教会与王权都可能因你与之合作而定你的罪。一般而言，经由合法的中间人更为稳妥。——总管府"

/obj/structure/roguemachine/vaultbank/bathhouse/get_patron_roster()
	return SStreasury?.bathhouse_agents

/obj/structure/roguemachine/vaultbank/bathhouse/get_patron_label()
	return "澡堂"

/obj/structure/roguemachine/vaultbank/bathhouse/get_patron_cap()
	return PATRON_CAP_BATHHOUSE

/obj/structure/roguemachine/vaultbank/bathhouse/enforce_placement()
	return

// ============================================================================
// INNKEEPER JAWBANK
// ============================================================================

/obj/structure/roguemachine/vaultbank/innkeeper
	name = "\improper 酒馆颌口金库"
	desc = "一座生物机械方尖碑，囤积着酒馆的收入。敲击它，就能震落属于你的那一份。"
	alert_jobs = list("Innkeeper", "Tapster", "Cook")
	alert_location = "the Tavern"
	bash_floor = INNKEEPER_BASH_FLOOR
	lump_payout = INNKEEPER_LUMP_PAYOUT
	supports_loans = FALSE

/obj/structure/roguemachine/vaultbank/innkeeper/get_fund_id()
	return "innkeeper"

/obj/structure/roguemachine/vaultbank/innkeeper/get_faction_label()
	return "酒馆"

/obj/structure/roguemachine/vaultbank/innkeeper/can_issue_loan(mob/user)
	return FALSE

/obj/structure/roguemachine/vaultbank/innkeeper/can_withdraw(mob/user, amount)
	if(!user)
		return FALSE
	return user.job == "Innkeeper"

/obj/structure/roguemachine/vaultbank/innkeeper/can_view(mob/user)
	if(!user)
		return FALSE
	return user.job in list("Innkeeper", "Tapster", "Cook")

/obj/structure/roguemachine/vaultbank/innkeeper/get_authority_label()
	return "客栈老板"

/obj/structure/roguemachine/vaultbank/innkeeper/enforce_placement()
	return

#undef MAMMON_PER_FORCE
