/obj/item/flashlight/lantern/shrunken
	name = "干瘪提灯"
	desc = "一盏引路明灯。"
	icon_state = "shrunkenlamp"
	item_state = "shrunkenlamp"
	lefthand_file = 'icons/roguetown/underworld/enigma_husks.dmi'
	righthand_file = 'icons/roguetown/underworld/enigma_husks.dmi'
	light_outer_range = 4
	light_power = 20
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	light_system = STATIC_LIGHT
/obj/item/flashlight/lantern/shrunken/update_brightness(mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)
	set_light_on(on)

/obj/structure/underworld/carriageman
	name = "车夫"
	desc = "死者须付渡资，生者尚可议价。车夫会执起缰绳，为我引路——只要我付得起代价。"
	icon = 'icons/roguetown/underworld/enigma_carriageman.dmi'
	icon_state = "carriageman"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	density = TRUE
	var/toll = FALSE
/obj/structure/underworld/carriageman/Initialize(mapload)
	. = ..()
	set_light(5, 4, 30, l_color = LIGHT_COLOR_BLUE)

/obj/structure/underworld/carriageman/attack_hand(mob/living/user)
	if(!istype(user, /mob/living/carbon/spirit))
		if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE)&& toll)
			to_chat(user, "<br><font color=purple><span class='bold'>渡资易手，誓约退让，且自前行。</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			toll = FALSE
			if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
				user.remove_status_effect(/datum/status_effect/debuff/ritesexpended)
			return
		if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE)&& !toll)
			to_chat(user, "<br><font color=purple><span class='bold'>仪式难测，一日一誓——<br>交付渡资，誓约便退让。</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			return
		to_chat(user, span_warning("车夫不理会活人。"))
		return
	var/mob/living/carbon/spirit/ghost = user
	if(!ghost.paid)
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
		to_chat(user, "<br><font color=purple><span class='bold'>取来渡资，方可登车。</span></font>")
	else
		to_chat(user, "<br><font color=purple><span class='bold'>渡资易手，且自前行。</span></font>")
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)

/obj/structure/underworld/carriageman/attackby(obj/item/W, mob/living/user)
	if(!istype(user, /mob/living/carbon/spirit)&& !toll && HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		if(istype(W, /obj/item/thetoll))
			qdel(W)
			to_chat(user, "<br><font color=purple><span class='bold'>渡资已付，交易已成。</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			toll = TRUE
			return
	if(!istype(user, /mob/living/carbon/spirit)&& toll && HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		if(istype(W, /obj/item/thetoll))
			to_chat(user, "<br><font color=purple><span class='bold'>一次只做一笔交易。</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			return
	if(!istype(user, /mob/living/carbon/spirit) && !HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		to_chat(user, span_warning("车夫不理会活人。"))
	var/mob/living/carbon/spirit/ghost = user
	if(istype(W, /obj/item/underworld/coin))
		if(!ghost.paid)
			qdel(W)
			to_chat(ghost, "<br><font color=purple><span class='bold'>渡资已付，登上马车，冥下侍女正在彼端等候。</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			ghost.paid = TRUE
			return
		if(ghost.paid)
			to_chat(ghost, "<br><font color=purple><span class='bold'>再多的渡资也无法改变她的裁决。</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
	else
		to_chat(ghost, "<br><font color=purple><span class='bold'>我只收渡资。</span></font>")
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)

/obj/structure/underworld/barrier //Blocks sprite locations
	name = "不要站在这里"
	desc = "冥下侍女正在等候。"
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"
	density = TRUE
	anchored = TRUE

/obj/structure/underworld/carriage_normal
	name = "马车"
	desc = "幽谷在等待。"
	icon = 'icons/roguetown/underworld/enigma_carriage.dmi'
	icon_state = "carriage_normal"
	anchored = TRUE
	density = TRUE

/obj/structure/underworld/carriage_normal/Initialize(mapload)
	. = ..()
	set_light(5, 3, 30, l_color = LIGHT_COLOR_WHITE)

/obj/structure/underworld/carriage
	name = "马车"
	desc = "冥下侍女正在等候。"
	icon = 'icons/roguetown/underworld/enigma_carriage.dmi'
	icon_state = "carriage_lit"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	density = TRUE


/obj/structure/underworld/carriage/Initialize(mapload)
	. = ..()
	set_light(5, 3, 30, l_color = LIGHT_COLOR_BLUE)

/obj/structure/underworld/carriage/attack_hand(mob/living/carbon/spirit/user)
	if(user.paid)
		switch(alert("你准备好接受裁决了吗？",,"是","否"))
			if("是")
				playsound(user, 'sound/misc/deadbell.ogg', 50, TRUE, -2, ignore_walls = TRUE)
				user.returntolobby()
			if("否")
				usr << "你延缓了命运的到来。"
	else
		to_chat(user, "<B><font size=3 color=red>门锁着。</font></B>")

GLOBAL_VAR_INIT(underworld_coins, 0)

/obj/item/underworld/coin
	name = "渡资"
	desc = "这不仅仅是一枚硬币。"
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "soultoken_floor"
	var/should_track = TRUE

/obj/item/underworld/coin/Initialize(mapload)
	. = ..()
	if(should_track)
		GLOB.underworld_coins += 1

/obj/item/underworld/coin/Destroy()
	if(should_track)
		GLOB.underworld_coins -= 1
	coin_upkeep()
	return ..()

/obj/item/underworld/coin/pickup(mob/user)
	..()
	if(should_track)
		GLOB.underworld_coins -= 1
	coin_upkeep()
	icon_state = "soultoken"

/obj/item/underworld/coin/dropped(mob/user)
	..()
	if(should_track)
		GLOB.underworld_coins += 1
	icon_state = "soultoken_floor"

/obj/item/underworld/coin/notracking
	should_track = FALSE

/proc/coin_upkeep()
	if(GLOB.underworld_coins < 8)
		for(var/obj/effect/landmark/underworldcoin/B in GLOB.landmarks_list)
			new /obj/item/underworld/coin(B.loc)

/obj/item/detroyt_toll
	name = "车票"
	desc = "这不仅仅是一块压实的盐。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "ticket_detroyt"
