// Replaces the old flat 60% house cut that paid in loose coins.
/obj/structure/roguemachine/headeater
	name = "食首机"
	desc = "一台沉溺于人类最古老职业——杀戮——的机器。登多尔的造物、地精与强盗的头颅投进去，赏金便会直接记入持有者的账户——当然，要先扣掉王权的食首税。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/topay = 0

/obj/structure/roguemachine/headeater/examine(mob/user)
	. = ..()
	. += span_info("左键点击可将一颗头颅投入机器，右键点击可投入机器前方的所有头颅。")
	if(isliving(user) && SStreasury.is_tax_exempt(user, TAX_CATEGORY_HEADEATER_LEVY))
		. += span_smallnotice("王权的食首税：依敕令豁免")
	else
		. += span_smallnotice("王权的食首税：[round(SStreasury.get_tax_rate(TAX_CATEGORY_HEADEATER_LEVY) * 100)]%")
	var/datum/decree/concordat = SStreasury.get_decree(DECREE_ZENITSTADT_CONCORDAT)
	if(concordat?.active)
		. += span_smallnotice("天顶城协定：每笔应税交易中，有 [round(CONCORDAT_TITHE_RATE * 100)]% 从王权的份额中抽作什一税，献给十神教会。")


/obj/structure/roguemachine/headeater/attackby(obj/item/H, mob/user, params)
	. = ..()
	if(!istype(H, /obj/item/natural/head) && !istype(H, /obj/item/bodypart/head))
		to_chat(user, span_danger("它似乎对[H]不感兴趣。"))
		return
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("[src]拒绝了这颗头颅——要从王权的赏金中获益，你必须拥有神经锁账户。"))
		return
	eathead(H, user)

/obj/structure/roguemachine/headeater/proc/payout(mob/user, gross)
	if(gross <= 0)
		return 0
	var/datum/fund/account = SStreasury.get_account(user)
	if(!account)
		return 0
	SStreasury.mint(account, gross, "食首机赏金([src.name])")
	var/tax_amt = SStreasury.apply_tax(account, gross, TAX_CATEGORY_HEADEATER_LEVY, src.name)
	if(tax_amt > 0)
		record_featured_stat(FEATURED_STATS_TAX_PAYERS, user, tax_amt)
		record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
	return gross - tax_amt

/obj/structure/roguemachine/headeater/proc/eathead(obj/item/H, mob/user, supress_message = FALSE, paynow = TRUE)
	var/sellprice = 0
	if(istype(H, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/E = H
		sellprice = E.sellprice
		if(E.no_head_bounty)
			sellprice = 0
	else if(istype(H, /obj/item/natural/head))
		var/obj/item/natural/head/A = H
		sellprice = A.sellprice
	else
		return
	if(sellprice <= 0)
		return
	if(paynow)
		var/net = payout(user, sellprice)
		if(!supress_message)
			var/levy = sellprice - net
			if(levy > 0)
				to_chat(user, span_danger("[src]吞下了[H]，将 [net] 枚玛门记入你的账户，另扣 [levy] 枚玛门作为王权的征税。"))
			else
				to_chat(user, span_danger("[src]吞下了[H]，将 [sellprice] 枚玛门记入你的账户。"))
	else
		topay += sellprice
	qdel(H)

/obj/structure/roguemachine/headeater/attack_right(mob/user)
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("[src]拒绝处理赏金，因为没有注册账户。请前往神经锁。"))
		return
	if(ishuman(user))
		for(var/obj/I in get_turf(src))
			if(istype(I, /obj/item/natural/head))
				eathead(I, user, TRUE, FALSE)
			if(istype(I, /obj/item/bodypart/head))
				eathead(I, user, TRUE, FALSE)
	if(topay > 0)
		var/net = payout(user, topay)
		var/levy = topay - net
		if(levy > 0)
			to_chat(user, span_danger("[src]将 [net] 枚玛门记入你的账户，另扣 [levy] 枚玛门作为王权的征税。"))
		else
			to_chat(user, span_danger("[src]将 [net] 枚玛门记入你的账户。"))
		topay = 0

