/obj/effect/fun_balloon
	name = "趣味气球"
	desc = ""
	icon_state = ""
	anchored = TRUE
	var/popped = FALSE

/obj/effect/fun_balloon/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/fun_balloon/Destroy()
	SSobj.processing -= src
	. = ..()

/obj/effect/fun_balloon/process()
	if(!popped && check() && !QDELETED(src))
		popped = TRUE
		effect()
		pop()

/obj/effect/fun_balloon/proc/check()
	return FALSE

/obj/effect/fun_balloon/proc/effect()
	return

/obj/effect/fun_balloon/proc/pop()
	visible_message("<span class='notice'>[src]爆开了！</span>")
	playsound(get_turf(src), 'sound/blank.ogg', 50, TRUE, -1)
	qdel(src)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/effect/fun_balloon/attack_ghost(mob/user)
	if(!user.client || !user.client.holder || popped)
		return
	var/confirmation = alert("戳破 [src]？","趣味气球","是","否")
	if(confirmation == "是" && !popped)
		popped = TRUE
		effect()
		pop()

/obj/effect/fun_balloon/sentience
	name = "赋予意识的趣味气球"
	desc = ""
	var/effect_range = 3
	var/group_name = "一群巨型蜘蛛"

/obj/effect/fun_balloon/sentience/effect()
	var/list/bodies = list()
	for(var/mob/living/M in range(effect_range, get_turf(src)))
		bodies += M

	var/question = "是否愿意成为[group_name]中的一员？"
	var/list/candidates = pollCandidatesForMobs(question, ROLE_ASPIRANT, null, FALSE, 100, bodies)
	while(LAZYLEN(candidates) && LAZYLEN(bodies))
		var/mob/dead/observer/C = pick_n_take(candidates)
		var/mob/living/body = pick_n_take(bodies)

		to_chat(body, "<span class='warning'>我的身体被幽灵接管了！</span>")
		message_admins("[key_name_admin(C)] 接管了（[key_name_admin(body)]）")
		body.ghostize(0)
		body.key = C.key
		new /obj/effect/temp_visual/gravpush(get_turf(body))

/obj/effect/fun_balloon/scatter
	name = "散布传送趣味气球"
	desc = ""
	var/effect_range = 5

/obj/effect/fun_balloon/scatter/effect()
	for(var/mob/living/M in range(effect_range, get_turf(src)))
		var/turf/T = find_safe_turf()
		new /obj/effect/temp_visual/gravpush(get_turf(M))
		M.forceMove(T)
		to_chat(M, "<span class='notice'>啪！</span>")
