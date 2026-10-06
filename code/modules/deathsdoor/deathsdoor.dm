GLOBAL_LIST_INIT(deaths_door_entries,list())
GLOBAL_VAR(deaths_door_exit)//turf at necra's shrine on each map

/obj/structure/deaths_door_shrine
	name = "A Way Out"
	desc = "无论以何种方式，这诡异的宁静终将结束。"
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "doorway"
	opacity = FALSE
	density = TRUE
	max_integrity = 0

/obj/structure/deaths_door_shrine/attack_hand(mob/living/user)
	to_chat(user, span_notice("你伸手探向发光的传送门……"))
	if(!do_after(user, 2 SECONDS, src))
		return

	if(user.mob_biotypes & MOB_UNDEAD)
		user.visible_message(span_danger("冥下侍女搅碎了亡灵！"))
		explosion(get_turf(user), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	exit_deaths_door(user, user)

/obj/structure/deaths_door_shrine/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O, /mob/living))
		return
	var/mob/living/target = O

	if(target.mob_biotypes & MOB_UNDEAD)
		target.visible_message(span_danger("冥下侍女搅碎了亡灵！"))
		explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	if(user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(target))
		return
	if(!do_after_mob(user, target, 1 SECONDS))
		return

	exit_deaths_door(user, target)

	user.visible_message(
		span_notice("[user]引领[target]穿过内克拉的神龛。")
	)

/obj/structure/deaths_door_shrine/proc/exit_deaths_door(mob/living/user, mob/living/target = null)
	var/list/dests = list()

	// Acolytes can choose exits
	if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/necras_sight))
		var/list/sight_dests = get_necras_sight_entries(user)
		if(length(sight_dests))
			for(var/turf/T in sight_dests)
				dests[T] = sight_dests[T]

	// Always allow shrine exit
	if(GLOB.deaths_door_exit)
		dests[GLOB.deaths_door_exit] = "内克拉神龛"
	// Warn Necra followers without sight
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/necras_sight))
		if(user.patron == /datum/patron/divine/necra)
			to_chat(user, span_warning("内克拉的道路在你面前模糊不清。你缺乏选择道路的视野。"))

	if(!length(dests))
		message_admins("Death's Door Shrine: No exit destinations! Inform a mapper!")	//You're missing /obj/effect/landmark/deaths_door/exit from the map
		return

	var/turf/T = prompt_deaths_door_exit(user, dests)
	if(!T)
		return
	target.forceMove(T)
	playsound(get_turf(target), 'sound/misc/portalenter.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	target.visible_message(span_danger("随着[user]踉跄着走出死寂的领域，空气扭曲并迅速变冷。"))

/proc/prompt_deaths_door_exit(mob/living/user, list/dests)
	if(!length(dests))
		return null

	if(length(dests) == 1)
		return dests[1]

	// Build display list: label -> turf
	var/list/named = list()
	for(var/turf/T as anything in dests)
		var/label = dests[T]
		if(!label)
			label = "[get_area(T)]"
		named[label] = T

	var/choice = input(user, "选择一条离开死亡边缘的道路：", "Necra's Way") \
		as null|anything in named
	if(!choice)
		return null

	return named[choice]

/proc/get_necras_sight_entries(mob/living/user)
	var/list/targets = list()
	var/obj/effect/proc_holder/spell/invoked/necras_sight/spell = \
		locate(/obj/effect/proc_holder/spell/invoked/necras_sight) in user.mind?.spell_list
	if(!spell)
		return targets

	for(var/obj/O in spell.marked_objects.Copy())
		// prune deleted objects
		if(!O || QDELETED(O))
			spell.marked_objects -= O
			continue

		if(!isturf(O.loc))
			spell.marked_objects -= O
			continue
		var/turf/T = O.loc
		var/label = spell.marked_objects[O]

		// Fallback safety
		if(!label || !length(label))
			label = O.name

		targets[T] = label

	return targets

/obj/structure/deaths_door_portal
	name = "死亡之门"
	icon = 'icons/mob/actions/necramiracles.dmi'
	icon_state = "necraportal"
	anchored = TRUE
	density = FALSE
	var/turf/destination

/obj/structure/deaths_door_portal/Initialize(mapload, mob/living/_caster)
	. = ..()
	var/list/dests = GLOB.deaths_door_entries
	if(!length(dests))
		message_admins("Death's Door Portal: No entry destinations! Inform a mapper!")	//You're missing any landmarks that are subtypes of /obj/effect/landmark/deaths_door/entry in deaths precipice
		return

	destination = pick(dests)
	addtimer(CALLBACK(src, PROC_REF(expire)), 15 SECONDS)

/obj/structure/deaths_door_portal/proc/expire()
	if(QDELETED(src))
		return
	visible_message(span_notice("发光的传送门关闭了！"))
	playsound(get_turf(src), 'sound/misc/deadbell.ogg', 50, TRUE, -2)
	qdel(src)

/obj/structure/deaths_door_portal/attack_hand(mob/living/user)
	playsound(get_turf(src), 'sound/misc/carriage2.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	to_chat(user, span_notice("你伸手探向发光的传送门……"))
	if(!do_after(user, 2 SECONDS, src))
		return
	enter_portal(user)

/obj/structure/deaths_door_portal/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O, /mob/living))
		return
	var/mob/living/M = O

	if(user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(M))
		return
	playsound(get_turf(src), 'sound/misc/carriage2.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	if(!do_after_mob(user, M, 2 SECONDS))
		return

	if(M.mob_biotypes & MOB_UNDEAD)
		to_chat(user, span_danger("冥下侍女搅碎了亡灵！"))
		explosion(get_turf(M), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	enter_portal(M, user)

	user.visible_message(
		span_warning("[user]将[M]拖入死亡之门！")
	)

/obj/structure/deaths_door_portal/proc/enter_portal(mob/living/target, mob/living/forcer)
	if(!destination)
		return
	playsound(get_turf(src), 'sound/misc/portalenter.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	target.forceMove(destination)

GLOBAL_VAR_INIT(underworld_strands, 0)
/obj/effect/landmark/underworldstrands
	var/spawn_timer

/obj/effect/landmark/underworldstrands/Initialize(mapload)
	. = ..()
	start_timer()

/obj/effect/landmark/underworldstrands/Destroy()
	if(spawn_timer)
		deltimer(spawn_timer)
	return ..()

/obj/effect/landmark/underworldstrands/proc/start_timer()
	if(spawn_timer)
		deltimer(spawn_timer)

	var/delay = rand(15 MINUTES, 30 MINUTES)
	// Single line: addtimer is a macro and macro arguments cannot span newlines
	spawn_timer = addtimer(CALLBACK(src, PROC_REF(try_spawn)), delay, TIMER_STOPPABLE)
/obj/effect/landmark/underworldstrands/proc/try_spawn()
	spawn_timer = null
	if(GLOB.underworld_strands >= 4)
		start_timer()
		return
	var/turf/T = get_turf(src)
	if(!T)
		start_timer()
		return

	// If lux already present, reset timer
	for(var/obj/item/soulthread/deathsdoor/L in T)
		start_timer()
		return

	// Otherwise spawn new lux
	new /obj/item/soulthread/deathsdoor(T)

	start_timer()
/obj/item/soulthread/deathsdoor
	name = "微光灵辉丝线"
	desc = "来自坟墓、散发诡异光芒的丝线。"
	var/should_track = TRUE

/obj/item/soulthread/deathsdoor/Initialize(mapload)
	. = ..()
	if(should_track)
		GLOB.underworld_strands += 1

/obj/item/soulthread/deathsdoor/Destroy()
	if(should_track)
		GLOB.underworld_strands -= 1
	return ..()

/obj/item/soulthread/deathsdoor/pickup(mob/user)
	..()
	if(should_track)
		GLOB.underworld_strands -= 1

/obj/item/soulthread/deathsdoor/dropped(mob/user)
	..()
	if(should_track)
		GLOB.underworld_strands += 1

/mob/living/proc/extract_from_deaths_edge()//for total exhaustion in death's precipice
	// Already unconscious? Don't loop
	if(stat >= UNCONSCIOUS)
		return
	src.apply_status_effect(/datum/status_effect/debuff/devitalised)
	src.SetSleeping(20 SECONDS)
	var/turf/T = get_adventurer_latejoin_turf()
	if(!T)
		return

	visible_message(
		span_danger("内克拉的掌握收紧，[src]倒下了。"),
		span_cultboldtalic("倒下之前，你最后看见的是一个幽魂正从你胸口直接扯出一缕缕灵辉。")
	)

	src.forceMove(T)

/mob/living/proc/get_adventurer_latejoin_turf()
	var/list/candidates = list()

	for(var/obj/effect/landmark/start/adventurerlate/L in GLOB.landmarks_list)
		if(L.loc && isturf(L.loc))
			candidates += L.loc

	if(!length(candidates))
		return null

	return pick(candidates)

/obj/structure/waywardspirit
	name = "A Wayward Soul"
	desc = "迷失于死亡的宁静，永不归来。"
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "hollow"
	opacity = FALSE
	density = FALSE
	max_integrity = 0
