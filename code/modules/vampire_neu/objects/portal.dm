/obj/structure/vampire/portalmaker
	name = "裂隙之门"
	icon_state = "obelisk"
	var/sending = FALSE

/obj/structure/vampire/portalmaker/attack_hand(mob/living/user)
	var/list/possibleportals = list()

	. = TRUE


	if(!user.has_bloodpool_cost(1000))
		to_chat(user, span_warning("这需要1000点血能，我没有那么多。"))
		return
	var/list/choices = list("返回", "送往", "我收回决定")
	switch(input(user, "选择哪种传送门？", "传送门类型") as null|anything in choices)
		if("我收回决定")
			return

		if("返回")
			for(var/obj/item/clothing/neck/portalamulet/P in GLOB.vampire_objects)
				possibleportals += P
			var/atom/choice = input(user, "选择开启传送门的区域", "选择") as null|anything in possibleportals
			if(!choice)
				return
			user.visible_message("[user]开始召唤传送门。", "我开始召唤传送门。")
			if(!do_after(user, 3 SECONDS, src))
				return

			user.has_bloodpool_cost(-1000)
			if(istype(choice, /obj/item/clothing/neck/portalamulet))
				var/obj/item/clothing/neck/portalamulet/A = choice
				A.uses -= 1
				var/obj/effect/landmark/vteleportdestination/VR = new(A.loc)
				VR.amuletname = A.name
				create_portal_return(A.name, 3000)
				user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
				if(A.uses <= 0)
					A.visible_message("[A]碎裂了！")
					qdel(A)
		if("送往")
			if(sending)
				to_chat(user, "已有一扇传送门开启了！")
				return
			for(var/obj/item/clothing/neck/portalamulet/P in GLOB.vampire_objects)
				possibleportals += P
			var/atom/choice = input(user, "选择传送门通往的区域", "选择") as null|anything in possibleportals
			if(!choice)
				return
			user.visible_message("[user]开始召唤传送门。", "我开始召唤传送门。")
			if(do_after(user, 3 SECONDS, src))
				user.has_bloodpool_cost(-1000)
				if(istype(choice, /obj/item/clothing/neck/portalamulet))
					var/obj/item/clothing/neck/portalamulet/A = choice
					A.uses -= 1
					var/turf/G = get_turf(A)
					new /obj/effect/landmark/vteleportsenddest(G.loc)
					if(A.uses <= 0)
						A.visible_message("[A]碎裂了！")
						qdel(A)
					create_portal()
					user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)

/obj/structure/vampire/portal
	name = "诡异传送门"
	icon_state = "portal"
	var/duration = 999
	var/spawntime = null
	density = FALSE

/obj/structure/vampire/portal/Initialize(mapload)
	. = ..()
	set_light(3, 2, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)
	playsound(loc, 'sound/misc/portalopen.ogg', 100, FALSE, pressure_affected = FALSE)

	addtimer(CALLBACK(src, PROC_REF(delete)), 60 SECONDS)

/obj/structure/vampire/portal/proc/delete()
	visible_message(span_boldnotice("[src]颤动着，随后迅速关闭。"))
	qdel(src)

/obj/structure/vampire/portal/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		for(var/obj/effect/landmark/vteleport/dest in GLOB.landmarks_list)
			playsound(loc, 'sound/misc/portalenter.ogg', 100, FALSE, pressure_affected = FALSE)
			AM.forceMove(dest.loc)
			break

/obj/structure/vampire/portal/sending
	name = "诡异传送门"
	icon_state = "portal"
	duration = 999
	spawntime = null
	var/turf/destloc

/obj/structure/vampire/portal/sending/Crossed(atom/movable/AM)
	if(isliving(AM))
		for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
			AM.forceMove(V.loc)

/obj/structure/vampire/portal/sending/Destroy()
	for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
		qdel(V)
	for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
		P.sending =  FALSE
	return ..()

/obj/structure/vampire/portalmaker/proc/create_portal_return(aname,duration)
	for(var/obj/effect/landmark/vteleportdestination/Vamp in GLOB.landmarks_list)
		if(Vamp.amuletname == aname)
			var/obj/structure/vampire/portal/P = new(get_turf(Vamp))
			P.duration = duration
			P.spawntime = world.time
			P.visible_message(span_boldnotice("伴随着令人作呕的撕裂声，一扇阴森的传送门出现了。"))
		qdel(Vamp)

/obj/structure/vampire/portalmaker/proc/create_portal(choice,duration)
	sending = TRUE
	for(var/obj/effect/landmark/vteleportsending/S in GLOB.landmarks_list)
		var/obj/structure/vampire/portal/sending/P = new(S.loc)
		P.visible_message(span_boldnotice("伴随着令人作呕的撕裂声，一扇阴森的传送门出现了。"))

/obj/item/clothing/neck/portalamulet
	name = "传送门护符"
	icon_state = "bloodtooth"
	icon = 'icons/roguetown/clothing/neck.dmi'
	var/uses = 3

/obj/item/clothing/neck/portalamulet/Initialize(mapload)
	GLOB.vampire_objects |= src
	. = ..()

/obj/item/clothing/neck/portalamulet/Destroy()
	GLOB.vampire_objects -= src
	return ..()

/* DISABLED FOR NOW
/obj/item/clothing/neck/portalamulet/attack_self(mob/user, params)
	. = ..()
	if(alert(user, "Create a portal?", "PORTAL GEM", "Yes", "No") == "Yes")
		uses -= 1
		var/obj/effect/landmark/vteleportdestination/Vamp = new(loc)
		Vamp.amuletname = name
		for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
			P.create_portal_return(name, 3000)
		user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
		if(uses <= 0)
			visible_message("[src] shatters!")
			qdel(src)
*/
