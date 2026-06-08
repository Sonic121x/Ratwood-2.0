//Fluff structures serve no purpose and exist only for enriching the environment. They can be destroyed with a wrench.

/obj/structure/well
	name = "水井"
	desc = "一口深井，可以从里面打水。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "well"
	anchored = TRUE
	density = TRUE
	opacity = 0
	climb_time = 40
	climbable = TRUE
	layer = 2.91
	damage_deflection = 30


/obj/structure/well/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bucket))
		var/obj/item/reagent_containers/glass/bucket/W = I
		if(W.reagents.holder_full())
			to_chat(user, span_warning("[W]已经装满了。"))
			return
		if(do_after(user, 1 SECONDS, target = src))
			var/list/waterl = list(/datum/reagent/water = 250)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>我从[src]里给[W]打满了水。</span>")
			playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 80, FALSE)
			return
	else ..()

/obj/structure/well/poisoned
	name = "毒井"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "well"
	color = "#59aa65"
	anchored = TRUE
	density = TRUE
	opacity = 0
	climb_time = 40
	climbable = TRUE
	layer = 2.91
	damage_deflection = 30

/obj/structure/well/poisoned/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bucket))
		var/obj/item/reagent_containers/glass/bucket/W = I
		if(W.reagents.holder_full())
			to_chat(user, span_warning("[W]已经装满了。"))
			return
		if(do_after(user, 30, target = src))
			var/list/waterl = list(/datum/reagent/water = 50, /datum/reagent/organpoison = 50)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>我从[src]里打起一桶泛着异色的污水。</span>")
			playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 80, FALSE)
			return
	else ..()

/obj/structure/well/fountain
	name = "饮水喷泉"
	desc = "一个比直接从河里喝水稍微文明一点的选择。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	pixel_x = -15

/obj/structure/well/fountain/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		user.visible_message(span_info("[user]开始从[src]喝水。"))
		drink_act(user, L)
		return
	..()

/obj/structure/well/fountain/proc/drink_act(mob/user, mob/living/L)
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	if(L.stat != CONSCIOUS)
		return
	if(do_after(L, 25, target = src))
		var/list/waterl = list(/datum/reagent/water = 5)
		var/datum/reagents/reagents = new()
		reagents.add_reagent_list(waterl)
		reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
		playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
		drink_act(user, L)
	return


/obj/structure/well/fountainswamp
	name = "沼泽喷泉"
	desc = "一处带着沼泽腥气的喷泉，看起来水质很差。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	color = "#a3c2a8"
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	pixel_x = -15

/obj/structure/well/fountainswamp/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		user.visible_message(span_info("[user]开始从[src]喝水。"))
		drink_act(user, L)
		return
	..()

/obj/structure/well/fountainswamp/proc/drink_act(mob/user, mob/living/L)
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	if(L.stat != CONSCIOUS)
		return
	if(do_after(L, 25, target = src))
		var/list/waterl = list(/datum/reagent/water/gross = 5)
		var/datum/reagents/reagents = new()
		reagents.add_reagent_list(waterl)
		reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
		playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
		drink_act(user, L)
	return
