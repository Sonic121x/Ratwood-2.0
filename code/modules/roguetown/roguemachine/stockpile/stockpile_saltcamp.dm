#define SALT_CHANCE_MAX 200
#define SALT_CHANCE_PERCENT (100/SALT_CHANCE_MAX)

GLOBAL_LIST_EMPTY(saltmineticketmachines)

/obj/structure/roguemachine/stockpile_saltcamp
	name = "赛利克斯的赎罪"
	desc = "是否能被赐予自由，还是被永世无视，全由赛利克斯裁定。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "stockpile_vendor"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	obj_flags = INDESTRUCTIBLE

	var/list/salt_accounts = list()
	var/salt_spent_on_gambling = 0
	var/gambling_active = FALSE

/obj/structure/roguemachine/stockpile_saltcamp/Destroy()
	salt_accounts = null
	return ..()

/obj/structure/roguemachine/stockpile_saltcamp/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_DUNGEONMASTER_LABOR_CAMP))
		. += span_info("机器中开出的中奖票券会被人[span_boldwarning("极其")]热切地当作藏品追捧。")
	else
		. += span_info("右键可存入机器前方的全部盐。")

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_salt_balance(mob/user)
	if(!user || !ishuman(user))
		return 0
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			return salt_accounts[X]

	salt_accounts += target_name // make account
	salt_accounts[target_name] = 0

	return salt_accounts[target_name]

/obj/structure/roguemachine/stockpile_saltcamp/proc/add_salt_balance(mob/user, amt = 0)
	if(!user || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			salt_accounts[X] += amt
			if(salt_accounts[X] < 0)
				salt_accounts[X] = 0
			return

	salt_accounts += target_name // make account
	salt_accounts[target_name] = amt

/obj/structure/roguemachine/stockpile_saltcamp/proc/set_salt_balance(mob/user, amt = 0)
	if(!user || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			salt_accounts[X] = amt
			return

	salt_accounts += target_name // make account
	salt_accounts[target_name] = amt

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_odds_of_winning(mob/user)
	var/balance = get_salt_balance(user)
	if(balance >= SALT_CHANCE_MAX)
		return 100
	balance *= SALT_CHANCE_PERCENT
	return balance

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_odds_of_winning_string(mob/user)
	var/balance = get_odds_of_winning(user)
	var/string
	if(balance <= 0)
		return "<font color='#f54646'>[pick("NO CHANCE", "NO SALT, NO CHANCE", "FOOL, MINE SOME SALT!", "GO MINE, YOU DULLARD!")]</font>"
	else if(balance < 10)
		string = "<font color='#f54646'>"
	else if(balance < 20)
		string = "<font color='#f36c6c'>"	
	else if(balance < 40)
		string = "<font color='#f5b546'>"
	else if(balance < 60)
		string = "<font color='#cff546'>"
	else if(balance < 80)
		string = "<font color='#acf546'>"
	else if(balance < 100)
		string = "<font color='#4ff546'>"
	else
		return "<font color='#4ff546'>[pick("WHY ARE YOU STILL HERE?!", "YOU ARE A SHAMEFUL FOOL!", "ARE YOU COMPENSATING?", "PLEASE, GO OUTSIDE!", "DID THEY FORGET YOU!?")]</font>"
	string += "[balance]%</font>"
	return string

/obj/structure/roguemachine/stockpile_saltcamp/proc/roll_for_ticket(mob/user)
	gambling_active = TRUE
	playsound(src, 'sound/misc/letsgogambling.ogg', 100, FALSE, -1)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 1)
	animate(pixel_x = oldx-1, time = 1)
	animate(pixel_x = oldx, time = 1)
	sleep(50)
	var/prob_of_winning = get_odds_of_winning(user)
	if(prob_of_winning == 100 || prob(prob_of_winning)) // we won!
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		gambling_active = FALSE
		return TRUE
	playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
	gambling_active = FALSE
	return FALSE

/obj/structure/roguemachine/stockpile_saltcamp/Topic(href, href_list)
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(gambling_active)
		return
	switch(href_list["task"])
		if("roll")
			if(!get_salt_balance(usr))
				src.say(pick("急什么，蠢货；你得有盐才能为自由豪赌。", "你没有盐。", "没有盐的罪犯根本算不上罪犯。", "要玩这场游戏，你得先让地面尝到盐。"))
				return
			close_ui(usr)
			src.say("向赛利克斯俯首，愿好运眷顾你。")
			if(!roll_for_ticket(usr)) // if we lost the game (like you just did lol), add to spent counter and reset account back to zero
				salt_spent_on_gambling += get_salt_balance(usr)
				set_salt_balance(usr, 0)
				src.say(pick("下次运气会更好，罪犯。", "你输了！愿你的泪水能帮你筛石。", "何等愚行，下次再试吧！", "哈！你这吃盐的家伙，根本没机会赢！"))
				return
			set_salt_balance(usr, 0)
			src.say("噢快瞧瞧，这儿出了个赢家！！")
			playsound(src, 'sound/misc/triumph_win_twnn.ogg', 100, FALSE, -1)
			var/obj/item/detroyt_toll/ive_got_a_golden_ticket = new /obj/item/detroyt_toll(get_turf(src))
			if(!usr.put_in_hands(ive_got_a_golden_ticket))
				ive_got_a_golden_ticket.forceMove(get_turf(src))

/obj/structure/roguemachine/stockpile_saltcamp/proc/close_ui(mob/living/user)
	if(!user?.mind?.current)
		return
	user.mind.current << browse(null, "window=saltcamp")

/obj/structure/roguemachine/stockpile_saltcamp/attack_hand(mob/living/user, menu_name)
	. = ..()
	if(.)
		return
	if(gambling_active)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	var/contents = "<center>喂饱机器 - 赢得你的<font color='#ab8000'>自由</font><BR>"
	contents += "----------<BR>"
	contents += "投入盐来提升运气<BR>"
	contents += "当前几率：[get_odds_of_winning_string(user)]<BR>"
	contents += "----------<BR>"
	contents += "<a href='?src=[REF(src)];task=roll'>(为自由掷运)</a><BR>"
	contents += "</center>"

	var/datum/browser/popup = new(user, "saltcamp", "", 500, 500)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/stockpile_saltcamp/proc/attemptsell(obj/item/reagent_containers/powder/salt/I, mob/H, message = TRUE, sound = TRUE)
	if(!istype(I))
		return FALSE
	qdel(I)
	add_salt_balance(H, 1)
	if(sound == TRUE)
		playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	if(message == TRUE)
		say("盐已存入。你当前的胜率为 [get_odds_of_winning(H)]%。")
	return TRUE

/obj/structure/roguemachine/stockpile_saltcamp/attackby(obj/item/P, mob/user, params)
	if(gambling_active)
		return FALSE
	if(ishuman(user))
		if(istype(P, /obj/item/reagent_containers/powder/salt))
			attemptsell(P, user, TRUE, TRUE)
			return FALSE
	. = ..()

/obj/structure/roguemachine/stockpile_saltcamp/attack_right(mob/user)
	if(gambling_active)
		return
	if(ishuman(user))
		var/found_salt = FALSE
		for(var/obj/I in get_turf(src))
			found_salt |= attemptsell(I, user, FALSE, FALSE)
		if(found_salt)
			say("盐已存入。你当前的中奖率为 [get_odds_of_winning(user)]%。")
		playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/ticket_master
	name = "票券滑道"
	desc = "只有持中奖彩票的人才能乘上这条通往自由的破烂滑道。看上去凡是穿过去的人都会被剥个精光。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	obj_flags = INDESTRUCTIBLE
	var/out_of_service = FALSE
	var/obj/structure/roguemachine/ticket_master/slide_other_end = null
	var/gid

/obj/structure/roguemachine/ticket_master/Initialize(mapload)
	. = ..()
	GLOB.saltmineticketmachines += src

/obj/structure/roguemachine/ticket_master/Destroy()
	GLOB.saltmineticketmachines -= src
	if(!out_of_service && slide_other_end)
		slide_other_end.slide_other_end = null
		slide_other_end.out_of_service = TRUE
	..()

/obj/structure/roguemachine/ticket_master/attack_hand(mob/living/user, menu_name)
	. = ..()
	if(.)
		return
	if(out_of_service) // aka the mapper forgot to link the other machine
		say("抱歉，滑道停止服务！")
	else
		say("你得先用票券赢得自由。")

/obj/structure/roguemachine/ticket_master/attackby(obj/item/P, mob/user, params)
	if(!out_of_service && !slide_other_end)
		for(var/obj/structure/roguemachine/ticket_master/O in GLOB.saltmineticketmachines)
			if(O.gid == gid && src != O)
				slide_other_end = O
				O.slide_other_end = src
		if(!slide_other_end)
			out_of_service = TRUE
	if(out_of_service) // aka the mapper forgot to link the other machine
		say("抱歉，滑道停止服务！")
		return ..()
	if(ishuman(user))
		var/mob/living/carbon/human/winner = user
		if(istype(P, /obj/item/detroyt_toll))
			if(winner.buckled) // don't stay remote-buckled
				winner.buckled.unbuckle_mob(winner, TRUE)
			var/turf/T = get_turf(slide_other_end)
			if(T)
				playsound(src, 'sound/misc/disposalflush.ogg', 50, FALSE, -1)
				playsound(slide_other_end, 'sound/misc/disposalflush.ogg', 50, FALSE, -1)
				for(var/obj/item/W in winner)
					if(W == P) // don't drop ticket
						continue
					if(istype(W, /obj/item/undies)) // let them keep their modesty
						continue
					if(HAS_TRAIT(W, TRAIT_NO_SELF_UNEQUIP) || HAS_TRAIT(W, TRAIT_NODROP) || HAS_TRAIT(W, CURSED_ITEM_TRAIT))
						continue
					winner.dropItemToGround(W)
				winner.regenerate_icons()
				if(do_teleport(winner, T, channel = TELEPORT_CHANNEL_FREE, forced = TRUE))
					winner.Paralyze(5 SECONDS, ignore_canstun = TRUE)
					to_chat(winner, span_danger("你瞬间被吸进了滑道！"))
				else
					to_chat(winner, span_danger("有什么东西阻止你被拉进滑道！"))
		else
			say("你得先用票券赢得自由。")
		return FALSE
	. = ..()

#undef SALT_CHANCE_MAX
#undef SALT_CHANCE_PERCENT
