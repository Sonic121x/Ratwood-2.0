GLOBAL_VAR(moneymaster)

/obj/structure/roguemachine/money
	name = "机器"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "money1"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/izmaster = FALSE
	anchored = TRUE

/obj/structure/roguemachine/money/attackby(obj/item/P, mob/user, params)
	if(!user.cmode)
		if(istype(P, /obj/item/roguecoin))
			budget += P.get_real_price()
			qdel(P)
			update_icon()
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return
		else if(P.get_real_price())
			if(izmaster)
				return ..()
			if(!GLOB.moneymaster)
				say("主人们已经逝去了吗？")
				playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
				return
			if(P.get_real_price() > 100)
				say("这件物品必须交给行会会长交易。")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return
			var/obj/structure/roguemachine/money/twins/T = GLOB.moneymaster
			var/amtofsale = round(P.get_real_price()/2)
			if(amtofsale >= 1)
				if(T.budget >= amtofsale)
					T.budget -= amtofsale
					budget += amtofsale
					update_icon()
				else
					say("主人们付不起……")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
			P.forceMove(T.loc)
			playsound(T.loc, 'sound/misc/hiss.ogg', 100, TRUE, -1)
			say("已按[amtofsale]玛门收购物品。")
			playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
			playsound(T, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)

		return
	..()


/obj/structure/roguemachine/money/Initialize(mapload)
	. = ..()
	icon_state = "money[rand(1,2)]"
	update_icon()

/obj/structure/roguemachine/money/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/money/r/Initialize(mapload)
	. = ..()
	icon_state = "money1"
	update_icon()

/obj/structure/roguemachine/money/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/money/l/Initialize(mapload)
	. = ..()
	icon_state = "money2"
	update_icon()

/obj/structure/roguemachine/money/attack_hand(mob/living/user)
	. = ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)
	to_chat(user, span_info("我顺时针摩擦机器。"))
	if(budget > 0)
		say("[budget]玛门归我所有……")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	update_icon()

/obj/structure/roguemachine/money/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/inputt = alert(user,"选择黄金、白银还是青铜？",,"青铜","白银","黄金")
	if(inputt && Adjacent(user))
		to_chat(user, span_info("我拉动了[inputt == "黄金" ? "金色" : (inputt == "白银" ? "银色" : "青铜色")]的舌头。"))
		if(inputt == "青铜" && budget >= 50)
			budget2change(budget, user, inputt)
			budget = 0
			if(isliving(user))
				var/mob/living/L = user
				L.emote("scream")
				L.Paralyze(50)
				L.Stun(50)
				L.visible_message(span_danger("[user]被堆积如山的硬币埋住了！"))
		else
			budget2change(budget, user, inputt)
			switch(inputt)
				if("黄金")
					var/zenars = budget/10
					if(zenars >= 1)
						for(var/i in 1 to zenars)
							budget -= 10
				if("白银")
					var/zenars = budget/5
					if(zenars >= 1)
						for(var/i in 1 to zenars)
							budget -= 5
				if("青铜")
					if(budget >= 1)
						for(var/i in 1 to budget)
							budget -= 1
		update_icon()

/obj/structure/roguemachine/proc/budget2change(budget, mob/user, specify, turf/custom_turf)
	var/turf/T
	if(custom_turf)
		T = custom_turf
	else if(!user || (!ismob(user)))
		T = get_turf(src)
	else
		T = get_turf(user)
	if(!budget || budget <= 0)
		return
	budget = floor(budget)
	var/type_to_put
	var/zenars_to_put
	if(specify)
		switch(specify)
			if("GOLD", "黄金")
				zenars_to_put = budget/10
				type_to_put = /obj/item/roguecoin/gold
			if("SILVER", "白银")
				zenars_to_put = budget/5
				type_to_put = /obj/item/roguecoin/silver
			if("BRONZE", "青铜")
				zenars_to_put = budget
				type_to_put = /obj/item/roguecoin/copper
			if("MARQUE")
				zenars_to_put = budget
				type_to_put = /obj/item/roguecoin/inqcoin
	else
		var/highest_found = FALSE
		var/zenars = floor(budget/10)
		if(zenars)
			budget -= zenars * 10
			highest_found = TRUE
			type_to_put = /obj/item/roguecoin/gold
			zenars_to_put = zenars
		zenars = floor(budget/5)
		if(zenars)
			budget -= zenars * 5
			if(!highest_found)
				highest_found = TRUE
				type_to_put = /obj/item/roguecoin/silver
				zenars_to_put = zenars
			else
				// Create multiple stacks if needed
				while(zenars > 0)
					var/stack_size = min(zenars, 20)
					var/obj/item/roguecoin/silver_stack = new /obj/item/roguecoin/silver(T, stack_size)
					if(user && zenars == stack_size) // Only put first stack in hands
						user.put_in_hands(silver_stack)
					zenars -= stack_size
		if(budget >= 1)
			if(!highest_found)
				type_to_put = /obj/item/roguecoin/copper
				zenars_to_put = budget
			else
				// Create multiple stacks if needed
				while(budget > 0)
					var/stack_size = min(budget, 20)
					var/obj/item/roguecoin/copper_stack = new /obj/item/roguecoin/copper(T, stack_size)
					if(user && budget == stack_size) // Only put first stack in hands
						user.put_in_hands(copper_stack)
					budget -= stack_size
	if(!type_to_put || zenars_to_put < 1)
		return
	// Create multiple stacks if needed for the main type
	while(zenars_to_put > 0)
		var/stack_size = min(zenars_to_put, 20)
		var/obj/item/roguecoin/G = new type_to_put(T, stack_size)
		if(user && zenars_to_put == stack_size) // Only put first stack in hands
			user.put_in_hands(G)
		zenars_to_put -= stack_size
	playsound(T, 'sound/misc/coindispense.ogg', 100, FALSE, -1)

/obj/structure/roguemachine
	var/budget = 0

// Base /datum/ui_status grants any observer in view range UI_UPDATE, so ghosts could open
// every roguemachine tgui read-only via /obj/attack_ghost -> ui_interact. Block them.
/obj/structure/roguemachine/ui_status(mob/user, datum/ui_state/state)
	if(isobserver(user))
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/proc/withdrawbudget(mob/user)
	var/amt = budget
	if(!amt)
		say("你的余额为零。")
		return
	if(amt < 0)
		say("你的余额为负数。")
		return
	var/list/choicez = list()
	if(amt > 10)
		choicez += "黄金"
	if(amt > 5)
		choicez += "白银"
	choicez += "青铜"
	var/selection = input(user, "请选择硬币材质", src) as null|anything in choicez
	if(!selection)
		return
	var/mod = 1
	if(selection == "黄金")
		mod = 10
	if(selection == "白银")
		mod = 5
	var/coin_amt = input(user, "现有[budget]玛门。你最多可从这台机器取出[floor(amt/mod)]枚[selection]硬币。", src) as null|num
	coin_amt = round(coin_amt)
	if(coin_amt < 1)
		return

	// Check maximum coin limit before deducting balance
	var/max_coins = 20
	if(coin_amt > max_coins)
		to_chat(user, span_warning("超过单次取款上限，每次最多只能取出[max_coins]枚硬币。"))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!Adjacent(user))
		return
	if((coin_amt*mod) > amt)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	budget2change(coin_amt*mod, user, selection)
	budget = budget - coin_amt*mod

/*
/obj/structure/roguemachine/money/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	speaking = !speaking
	to_chat(user, span_info("I press the right eye."))
	update_icon()
*/
/obj/structure/roguemachine/money/obj_break(damage_flag)
	..()
	budget2change(budget)
	budget = 0
	update_icon()

/obj/structure/roguemachine/money/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")

/obj/structure/roguemachine/money/Destroy()
	set_light(0)
	budget2change(budget)
	budget = 0
	return ..()

/obj/structure/roguemachine/money/twins
	name = "双面守财像"
	desc = "它们可以替你保管钱财。"
	icon_state = "twins"
	icon = 'icons/roguetown/misc/64x64.dmi'
	budget = 0
	pixel_x = -16
	izmaster = TRUE

/obj/structure/roguemachine/money/twins/Initialize(mapload)
	. = ..()
	budget = rand(50,200)
	icon_state = "twins"
	update_icon()
	GLOB.moneymaster = src

/obj/structure/roguemachine/money/twins/obj_break(damage_flag)
	. = ..()
	GLOB.moneymaster = null

/obj/structure/roguemachine/money/twins/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	if(budget > 10)
		add_overlay(mutable_appearance(icon, "[icon_state]-e"))
	else
		add_overlay(mutable_appearance(icon, "[icon_state]-b"))
	set_light(1, 1, 1, l_color = "#1b7bf1")
