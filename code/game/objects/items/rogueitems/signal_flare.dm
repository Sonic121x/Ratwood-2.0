#define FLARE_SHELTER_COLOR "orange"
#define FLARE_ILLUMINATION_COLOR "bright"

GLOBAL_LIST_EMPTY(signal_flare_codebook)

/proc/get_signal_flare_codebook()
	/*
		Sets meanings to each signal flare code and color. This ensures that every round that the meaning for each color is randomized.
		Only the Garrison and Keep Noblemen can interpret its meaning, except for the orange shelter signal which is universally known.
	*/

	// If initialized, return codebook and color meanings immediately. Avoids reshuffling again, you dummy.
	if(length(GLOB.signal_flare_codebook))
		return GLOB.signal_flare_codebook

	// Otherwise, set meaning to each pretty color! :D
	var/list/meanings = shuffle(list(
		"'遇险求救！'",
		"'一切安全！'",
		"'发现敌人！'",
		"'请求增援！'",
		"'撤退！'",
		"'在此集结！'"
	))

	// Assign the meaning to each color. Order is shuffled, so colors will always have unique meaning each round
	GLOB.signal_flare_codebook = list(
		"red"    = meanings[1],
		"blue"   = meanings[2],
		"green"  = meanings[3],
		"yellow" = meanings[4],
		"white"  = meanings[5],
		"purple" = meanings[6],
		"orange" = "'放下一切，快跑，找地方躲起来。'"
	)

	return GLOB.signal_flare_codebook

// Shared by the canister and the Wolkenmaw itself: what a character's role tells them about the codes,
// independent of whether they're currently holding a live round.
/proc/get_signal_flare_codebook_lines(mob/user)
	var/list/lines = list()
	if(!user)
		return lines
	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/static/list/townsfolk = GLOB.youngfolk_positions + GLOB.peasant_positions + GLOB.yeoman_positions + GLOB.church_positions + GLOB.courtier_positions
	if(user.job in can_interpret)
		lines += span_notice("你认出了这些隐晦的简写刻痕所代表的信号含义：")
		for(var/color in codebook)
			lines += span_notice("&nbsp;&nbsp;<font color='[color]'><b>[list("red" = "红色", "blue" = "蓝色", "green" = "绿色", "yellow" = "黄色", "white" = "白色", "purple" = "紫色", "orange" = "橙色")[color] || color]</b></font>: [codebook[color]]")
	else if(user.job in townsfolk)
		lines += span_cult("你认出了<font color='orange'><b>橙色</b></font>信号弹：人人都知道它的含义是[codebook[FLARE_SHELTER_COLOR]]")
	else
		lines += span_notice("这些颜色各有含义，但你没有受过解读它们的训练。")
	return lines

/obj/item/signal_flare
	name = "信号弹筒"
	desc = "一个装满易燃粉末和彩色布料的密封炼金弹筒。将其装入云口信号枪，便能发射出数里外都能看见的鲜艳烟柱。只能使用一次。动动脑子再用，傻瓜。"
	icon = 'icons/roguetown/items/flaregun.dmi'
	icon_state = "flarecanister_ready"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP
	grid_height = 32
	grid_width = 32
	var/spent = FALSE

/obj/item/signal_flare/proc/mark_spent()
	spent = TRUE
	name = "用过的信号弹筒"
	desc = "一个散发着刺鼻火药焦味的空信号弹筒。已经没用了。"
	icon_state = "flarecanister_empty"

/obj/item/signal_flare/examine(mob/user)
	// This allows garrison to read the code for each color and share this information. Good for interrogation or for hired mercenaries, me thinks.
	. = ..()
	if(spent)
		return
	. += get_signal_flare_codebook_lines(user)

/obj/item/signal_flare/attack_self(mob/living/user)
	if(spent)
		to_chat(user, span_notice("它已经用过了，只剩下火药的焦味。"))
		return
	to_chat(user, span_notice("我需要将它装入云口信号枪才能发射。"))

// Held to full charge like shooting a crossbow, so a stray click can't loose a signal.
/datum/intent/use/flaregun
	name = "瞄准"
	chargetime = 8
	no_early_release = TRUE
	charging_slowdown = 1

/obj/item/signal_flare_gun
	name = "云口信号枪"
	desc = "一把由木材和黑铁制成的阔口魔法手铳，进口自格伦泽尔霍夫特。折开枪身，装入炼金信号弹筒，再合拢上膛，就能发射出数里外都能看见的鲜艳烟柱，引来朋友或敌人。动动脑子再用，傻瓜。"
	icon = 'icons/roguetown/items/flaregun.dmi'
	icon_state = "flaregun_unload"
	item_state = "flaregun"
	lefthand_file = 'icons/mob/inhands/weapons/flaregun_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flaregun_righthand.dmi'
	experimental_inhand = FALSE
	experimental_onhip = TRUE
	possible_item_intents = list(/datum/intent/use/flaregun)
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	grid_width = 32
	grid_height = 32
	
	var/obj/item/signal_flare/canister
	var/cocked = FALSE
	var/spawn_loaded = FALSE
	/// Prevents the color menu from opening twice when a single click routes through multiple attack paths.
	var/firing = FALSE
	/// Signal chosen ahead of time. When set, firing skips the menu entirely.
	var/primed_color
	var/list/fire_sound = list(
		'modular_helmsguard/sound/arquebus/arquefire.ogg',
		'modular_helmsguard/sound/arquebus/arquefire2.ogg',
		'modular_helmsguard/sound/arquebus/arquefire3.ogg',
		'modular_helmsguard/sound/arquebus/arquefire4.ogg',
		'modular_helmsguard/sound/arquebus/arquefire5.ogg',
	)
	var/load_sound = 'modular_helmsguard/sound/arquebus/musketload.ogg'
	var/cock_sound = 'modular_helmsguard/sound/arquebus/musketcock.ogg'
	var/fuse_sound = 'modular_helmsguard/sound/arquebus/fuse.ogg'
	var/break_open_sound = 'sound/items/knife_open.ogg'
	var/dry_fire_sound = 'modular_helmsguard/sound/arquebus/musketcock.ogg'

/obj/item/signal_flare_gun/loaded
	spawn_loaded = TRUE

/obj/item/signal_flare_gun/Initialize(mapload)
	. = ..()
	if(spawn_loaded && !canister)
		canister = new(src)
	update_gun_icon()

/obj/item/signal_flare_gun/Destroy()
	if(canister)
		canister.forceMove(drop_location())
		canister = null
	return ..()

/obj/item/signal_flare_gun/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	if(gone == canister)
		canister = null
		cocked = FALSE
		update_gun_icon()

// Closed and cocked shows the ready sprite, while broken open shows the unload sprite.
/obj/item/signal_flare_gun/proc/update_gun_icon()
	icon_state = cocked ? "flaregun_default" : "flaregun_unload"

/obj/item/signal_flare_gun/examine(mob/user)
	. = ..()
	if(!canister)
		. += span_notice("弹膛是空的。")
	else if(canister.spent)
		. += span_notice("弹膛里有一个用过的弹筒，需要将其退出。")
	else if(!cocked)
		. += span_notice("已装入弹筒，但必须合拢上膛才能发射。")
	else
		. += span_notice("已装填完毕，随时可以发射。")
	if(primed_color)
		. += span_notice("旋钮已设为[signal_label(primed_color)]，发射时无需再次选择信号。")
	. += span_info("用鼠标中键点击它可预先设置旋钮，发射时便不会再询问信号选择。")
	. += get_signal_flare_codebook_lines(user)

/obj/item/signal_flare_gun/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/signal_flare))
		var/obj/item/signal_flare/new_canister = W
		if(canister)
			to_chat(user, span_warning("弹膛里已经有一个弹筒了。"))
			return
		if(cocked)
			to_chat(user, span_warning("[src]已经合拢，我需要先折开枪身才能装填。"))
			return
		if(new_canister.spent)
			to_chat(user, span_warning("这个弹筒已经用过了，装进去也毫无用处。"))
			return
		if(!user.transferItemToLoc(new_canister, src))
			return
		canister = new_canister
		update_gun_icon()
		playsound(src, load_sound, 100)
		user.visible_message(span_notice("[user]将[new_canister]装进[src]敞开的弹膛里，必须合拢上膛才能发射。"))
		return
	return ..()

/obj/item/signal_flare_gun/attack_self(mob/living/user)
	if(!cocked && !canister?.spent)
		cocked = TRUE
		update_gun_icon()
		playsound(src, cock_sound, 100)
		user.visible_message(span_notice("[user]合拢[src]并将其上膛[canister ? "，随时可以发射" : ""]。"))
		return
	eject_canister(user)

/obj/item/signal_flare_gun/proc/dry_fire(mob/living/user)
	playsound(src, dry_fire_sound, 30, TRUE)
	user.visible_message(span_danger("[src]的击锤敲在空弹膛上。*咔哒*"))

/obj/item/signal_flare_gun/proc/signal_label(signal)
	return signal == FLARE_ILLUMINATION_COLOR ? "照明" : (list("red" = "红色", "blue" = "蓝色", "green" = "绿色", "yellow" = "黄色", "white" = "白色", "purple" = "紫色", "orange" = "橙色")[signal] || signal)

/obj/item/signal_flare_gun/MiddleClick(mob/user, params)
	if(!isliving(user) || user.incapacitated())
		return ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)
	set_signal_dial(user)

/obj/item/signal_flare_gun/proc/set_signal_dial(mob/living/user)
	// Labelled distinctly from the firing menu so the two are never mistaken for each other.
	var/list/choices = list()
	var/list/signals = build_flare_choices(user)
	for(var/label in signals)
		choices["设置旋钮：[label]"] = signals[label]
	choices["每次询问"] = null
	var/picked = input(user, "预设无需再次询问即可发射的信号。", "预设信号") as null|anything in choices
	if(!picked)
		return
	if(QDELETED(src) || !Adjacent(user) || user.incapacitated())
		return
	primed_color = choices[picked]
	if(!primed_color)
		to_chat(user, span_notice("我清除了[src]的旋钮设置，每次发射前都会询问信号选择。"))
		return
	to_chat(user, span_notice("我将[src]的旋钮设为[signal_label(primed_color)]。"))

/obj/item/signal_flare_gun/attack_right(mob/user)
	if(canister && isliving(user))
		eject_canister(user)
		return
	return ..()

/obj/item/signal_flare_gun/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(!istype(user))
		return
	if(proximity_flag && ((target in user.contents) || !isturf(target)))
		return
	if(!cocked)
		to_chat(user, span_warning("[src]需要先上膛。"))
		return
	if(!canister || canister.spent)
		dry_fire(user)
		return
	// Checked here rather than in the click chain, as bows and crossbows do.
	if(user.client && user.client.chargedprog < 100)
		to_chat(user, span_warning("我将[src]举向天空的时间还不够长。"))
		return
	fire_flare(user)

/obj/item/signal_flare_gun/proc/eject_canister(mob/living/user)
	var/obj/item/signal_flare/ejected_canister = canister
	canister = null
	cocked = FALSE
	update_gun_icon()
	playsound(src, break_open_sound, 100)
	if(!ejected_canister)
		user.visible_message(span_notice("[user]折开[src]，弹膛是空的。"))
		return
	ejected_canister.forceMove(get_turf(src))
	if(ejected_canister.spent)
		user.visible_message(span_notice("[user]折开[src]，用过的弹筒叮当落地。"))
	else
		user.visible_message(span_notice("[user]折开[src]，弹筒滚落到地上。"))

/obj/item/signal_flare_gun/proc/fire_flare(mob/living/user)
	if(firing)
		return
	var/area/user_area = get_area(user)
	if(!user_area.outdoors)
		to_chat(user, span_warning("我需要在露天处才能发射它。"))
		return
	firing = TRUE
	do_fire_flare(user)
	firing = FALSE

/obj/item/signal_flare_gun/proc/build_flare_choices(mob/living/user)
	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/user_can_interpret = (user.job in can_interpret)
	var/list/choices = list()

	// Carries no code, so anyone can fire it and nobody reads meaning into it. Just light.
	choices["照明"] = FLARE_ILLUMINATION_COLOR

	for(var/color in codebook)
		if(color == FLARE_SHELTER_COLOR && !can_fire_shelter_signal(user))
			continue
		// Sorted by alphabet in both instances, cannot be cheesed by non-garrison players.
		if(user_can_interpret)
			// Sorted by meaning
			choices["[codebook[color]]：（[signal_label(color)]）"] = color
		else
			// Sorted by color. So no ability to cheese by memorizing order, methinks?
			choices["[signal_label(color)]"] = color

	return choices

/obj/item/signal_flare_gun/proc/can_fire_shelter_signal(mob/living/user)
	var/static/list/shelter_authorized = list("Grand Duke", "Marshal", "Hand", "Knight Captain")
	return (user.job in shelter_authorized)

/obj/item/signal_flare_gun/proc/do_fire_flare(mob/living/user)
	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/chosen_color = primed_color

	// A signal primed by someone else doesn't grant their authority to fire it.
	if(chosen_color == FLARE_SHELTER_COLOR && !can_fire_shelter_signal(user))
		chosen_color = null

	if(!chosen_color)
		var/list/choices = build_flare_choices(user)
		var/picked = input(user, "选择要发射的信号。", "信号弹") as null|anything in choices
		if(!picked)
			return
		chosen_color = choices[picked]

	if(!canister || canister.spent)
		return

	user.visible_message(span_warning("[user]将[src]举向天空，准备发射……"))
	playsound(src, fuse_sound, 80)
	if(!do_after(user, 1.5 SECONDS, target = src))
		to_chat(user, span_warning("我被打断了！"))
		return

	if(!canister || canister.spent || !cocked)
		return
		
	// Re-check outdoors, the wind-up takes time, and the shooter may have stepped inside since.
	var/area/user_area = get_area(user)
	if(!user_area.outdoors)
		to_chat(user, span_warning("我已经不在露天处了！"))
		return

	var/turf/origin = get_turf(user)
	var/meaning = codebook[chosen_color]
	var/colored_name = "<font color='[chosen_color]'><b>[signal_label(chosen_color)]</b></font>"
	if(chosen_color == FLARE_ILLUMINATION_COLOR)
		colored_name = "<font color='white'><b>耀眼的白色</b></font>"

	user.visible_message(span_warning("[user]发射了[src]！一道[signal_label(chosen_color)]烟柱冲上天空！"))
	playsound(user.loc, pick(fire_sound), 100, TRUE)
	canister.mark_spent()

	var/obj/effect/signal_flare_light/muzzle_flash = new(origin)
	muzzle_flash.set_light(4, 2, 2, l_color = "#ffddaa", l_on = TRUE)
	QDEL_IN(muzzle_flash, 0.5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(spawn_smoke_puff), origin), 5)
	addtimer(CALLBACK(src, PROC_REF(spawn_smoke_puff), origin), 10)
	addtimer(CALLBACK(src, PROC_REF(spawn_smoke_puff), origin), 16)

	var/static/list/flare_hex = list(
		"red"    = "#ff8877",
		"blue"   = "#6688ff",
		"green"  = "#66ffaa",
		"yellow" = "#ffdd66",
		"white"  = "#ffffff",
		"purple" = "#bb66ff",
		"orange" = "#ff9944",
		"bright" = "#ffffff"
	)

	var/hex = flare_hex[chosen_color]
	addtimer(CALLBACK(src, PROC_REF(flare_illuminate), origin, hex, meaning, colored_name, chosen_color, can_interpret), 2 SECONDS)

/obj/item/signal_flare_gun/proc/spawn_smoke_puff(turf/origin)
	new /obj/effect/particle_effect/smoke/arquebus(origin)

/obj/item/signal_flare_gun/proc/flare_illuminate(turf/origin, hex, meaning, colored_name, chosen_color, list/can_interpret)
	// Illumination rounds burn wider and longer. Everything else is a normal flare.
	var/illuminating = (chosen_color == FLARE_ILLUMINATION_COLOR)
	var/glow_range = illuminating ? 12 : 8
	var/glow_duration = illuminating ? 30 SECONDS : 10 SECONDS

	// Burn above the rooftops where there's open sky, so walls don't swallow the light.
	var/turf/glow_turf = origin
	var/turf/above = get_step_multiz(origin, UP)
	if(above && isopenspace(above))
		glow_turf = above

	var/obj/effect/signal_flare_light/glow = new(glow_turf)
	glow.set_light(glow_range, 4, 3, l_color = hex, l_on = TRUE)

	QDEL_IN(glow, glow_duration)

	playsound(origin, pick('sound/misc/explode/explosionfar (1).ogg', 'sound/misc/explode/explosionfar (2).ogg', 'sound/misc/explode/explosionfar (3).ogg'), 40, TRUE)

	var/list/scatter_turfs = list()
	var/area/turf_area

	for(var/turf/candidate_turf in range(7, origin))
		turf_area = get_area(candidate_turf)
		if(isopenturf(candidate_turf) && turf_area.outdoors)
			scatter_turfs += candidate_turf

	for(var/i in 1 to 4)
		if(!length(scatter_turfs))
			break

		var/turf/landing = pick(scatter_turfs)

		scatter_turfs -= landing

		var/turf/below = get_step_multiz(landing, DOWN)

		while(isopenspace(landing) && below)
			landing = below
			below = get_step_multiz(landing, DOWN)

		if(isopenspace(landing))
			continue

		var/obj/effect/signal_flare_remnant/remnant = new(landing)

		remnant.color = hex
		var/mutable_appearance/ember_glow = mutable_appearance(remnant.icon, remnant.icon_state)
		ember_glow.blend_mode = BLEND_ADD
		ember_glow.color = hex
		remnant.overlays += ember_glow
		remnant.set_light(2, 1, 2, l_color = hex, l_on = TRUE)

		QDEL_IN(remnant, 60 SECONDS)

		// Embers have a chance to set fire where they land
		if(prob(10))
			new /obj/effect/hotspot(landing)

	var/static/list/townsfolk = GLOB.youngfolk_positions + GLOB.peasant_positions + GLOB.yeoman_positions + GLOB.church_positions + GLOB.courtier_positions

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD || isbrain(player))
			continue

		var/distance = get_dist(player, origin)
		if(distance <= 7 || distance > 200)
			continue

		var/can_interpret_flare = (player.job in can_interpret)
		var/is_townsfolk_and_shelter_signal = (chosen_color == FLARE_SHELTER_COLOR) && (player.job in townsfolk)

		var/dirtext = "在"
		var/direction = angle2dir(Get_Angle(player, origin))

		switch(direction)
			if(NORTH)
				dirtext += "北方"
			if(SOUTH)
				dirtext += "南方"
			if(EAST)
				dirtext += "东方"
			if(WEST)
				dirtext += "西方"
			if(NORTHWEST)
				dirtext += "西北方"
			if(NORTHEAST)
				dirtext += "东北方"
			if(SOUTHWEST)
				dirtext += "西南方"
			if(SOUTHEAST)
				dirtext += "东南方"
			else
				dirtext = "在某个无法辨明的方向"

		var/disttext

		if(distance < 50)
			disttext = "距离比较近"
		else if(distance < 100)
			disttext = "有一段距离"
		else
			disttext = "距离相当远"

		var/msg = "<big>一枚[colored_name]信号弹[dirtext]照亮了天空，[disttext]！</big>"

		if(can_interpret_flare && meaning)
			msg += " <i>你知道这个颜色的含义是：[meaning]</i>"
		else if(is_townsfolk_and_shelter_signal)
			msg += span_userdanger(" 你知道这代表着：[meaning]")

		to_chat(player, span_boldnotice(msg))

/obj/effect/signal_flare_light
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/signal_flare_remnant
	name = "余烬"
	desc = "信号弹留下的发光余烬。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
