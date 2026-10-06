
// Sound seems to be capped due to sound falloff formula. Might be something to bring up later.
/datum/looping_sound/rat_alarm
	mid_sounds = 'sound/effects/emergencyratalarm.ogg'
	mid_length = 281
	max_loops = 1
	volume = 80
	extra_range = 7
	persistent_loop = TRUE

/datum/looping_sound/rat_alarm/on_stop()
	. = ..()
	var/obj/structure/lever/wall/rat_alarm/lever = parent
	if(!istype(lever) || !lever.active)
		return
	lever.alarm_ended()

/obj/structure/lever/wall/rat_alarm
	name = "警报拉杆"
	desc = "一根粗陋的拉杆，连着一堆杂乱的齿轮和皮带。旁边愚蠢的刻字写着：“听见尖叫就说明它在运转。”最好别去想另一端连着什么。"
	var/active = FALSE
	var/alarm_cooldown = FALSE
	var/datum/looping_sound/rat_alarm/soundloop

/obj/structure/lever/wall/rat_alarm/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/structure/lever/wall/rat_alarm/attack_hand(mob/user)
	// Taken by the lever/attack_hand code, but it could use a quick refactor to get rid of the unnecessary nested if statements. Since it's simple, I might do it later.
	if(!isliving(user))
		return
	if(alarm_cooldown && !active)
		to_chat(user, span_warning("机关还在复位。"))
		return

	var/mob/living/L = user
	L.changeNext_move(CLICK_CD_MELEE)
	var/used_time = 100 - (L.STASTR * 10)

	if(active)
		user.visible_message(span_warning("[user]用力将拉杆拉回上方！"))
		if(do_after(user, used_time, target = user))
			cancel_alarm()
		return

	user.visible_message(span_warning("[user]用力拉下拉杆！"))

	if(!do_after(user, used_time, target = user))
		return

	active = TRUE
	alarm_cooldown = TRUE
	toggled = TRUE
	icon_state = "leverwall[toggled]"
	playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)

	var/area/local_area = get_area(src)
	var/area_name = local_area ? local_area.name : "未知地点"

	visible_message(span_warning("齿轮转动起来，有什么东西却卡住了。一声湿黏的碎裂声后，响起了上百声细小的尖叫。不久，你听见它们的同伴匆匆赶来，想让这一切停下。"))

	addtimer(CALLBACK(src, PROC_REF(broadcast_alarm), area_name), NORMAL_SCOM_TRANSMISSION_DELAY)
	addtimer(CALLBACK(src, PROC_REF(play_start_sequence)), 5)

/obj/structure/lever/wall/rat_alarm/proc/play_start_sequence()
	playsound(src, 'sound/items/pickbreak.ogg', 80, extrarange = 7)
	addtimer(CALLBACK(src, PROC_REF(start_soundloop)), 5)

/obj/structure/lever/wall/rat_alarm/proc/start_soundloop()
	soundloop = new(src, TRUE)
	for(var/mob/living/hearer in get_hearers_in_range(world.view + 7, src))
		if(hearer.client && get_dist(src, hearer) > world.view)
			to_chat(hearer, span_warning("你听见附近传来可怕的机械尖啸，夹杂着某种小东西惊慌的惨叫。"))

/obj/structure/lever/wall/rat_alarm/proc/broadcast_alarm(area_name)
	var/msg = "<big><span style='color: [GARRISON_SCOM_COLOR]'>[area_name]响起警报。请尽快派人前来。</span></big>"
	for(var/atom/machine in SSroguemachine.scomm_machines)
		if(istype(machine, /obj/item/scomstone/bad/garrison) || istype(machine, /obj/item/scomstone/garrison))
			var/obj/item/scomstone/stone = machine
			stone.repeat_message(msg, src, null)
		else if(istype(machine, /obj/structure/roguemachine/scomm))
			var/obj/structure/roguemachine/scomm/scomm_machine = machine
			if(scomm_machine.garrisonline)
				scomm_machine.repeat_message(msg, src, null)
	SSroguemachine.crown?.repeat_message(msg, src, null)

/obj/structure/lever/wall/rat_alarm/proc/cancel_alarm()
	QDEL_NULL(soundloop)
	playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)
	end_alarm(1 MINUTES)

/obj/structure/lever/wall/rat_alarm/proc/alarm_ended()
	end_alarm(5 MINUTES)

/obj/structure/lever/wall/rat_alarm/proc/end_alarm(cooldown)
	active = FALSE
	toggled = FALSE
	icon_state = "leverwall[toggled]"
	addtimer(CALLBACK(src, PROC_REF(play_end_sequence)), 5)
	addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)

/obj/structure/lever/wall/rat_alarm/proc/play_end_sequence()
	playsound(src, 'sound/items/pickbreak.ogg', 80, extrarange = 7)
	addtimer(CALLBACK(src, PROC_REF(show_end_message)), 5)

/obj/structure/lever/wall/rat_alarm/proc/show_end_message()
	visible_message(span_notice("齿轮终于停下了，至少暂时如此。你似乎听见了一声吱叫，随后便再无动静。"))

/obj/structure/lever/wall/rat_alarm/proc/reset_cooldown()
	alarm_cooldown = FALSE
	QDEL_NULL(soundloop)


