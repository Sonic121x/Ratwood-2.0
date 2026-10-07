GLOBAL_LIST_INIT(ghost_verbs, list(
	/client/proc/ghost_up,
	/client/proc/ghost_down,
	/client/proc/descend,
	/client/proc/reenter_corpse
	))

/client/proc/ghost_up()
	set category = "灵魂"
	set name = "幽灵上升"
	if(isobserver(mob))
		mob.ghost_up()

/client/proc/ghost_down()
	set category = "灵魂"
	set name = "幽灵下降"
	if(isobserver(mob))
		mob.ghost_down()

/client/proc/descend()
	set name = "前往冥界"
	set category = "灵魂"

	switch(alert("进入冥界吗？",,"是","否"))
		if("是")
			if(istype(mob, /mob/living/carbon/spirit))
				return

			if(istype(mob, /mob/living/carbon/human))
				var/mob/living/carbon/human/D = mob
				if(D.buried && D.funeral)
					D.returntolobby()
					return

				var/datum/job/target_job = SSjob.GetJob(D.mind.assigned_role)
				if(target_job)
					if(target_job.job_reopens_slots_on_death)
						target_job.current_positions = max(0, target_job.current_positions - 1)
					if(target_job.same_job_respawn_delay)
						// Store the current time for the player
						GLOB.job_respawn_delays[src.ckey] = world.time + target_job.same_job_respawn_delay
			verbs -= GLOB.ghost_verbs
			mob.returntolobby()
		if("否")
			usr << "你改变了主意。"

/client/proc/reenter_corpse()
	set category = "灵魂"
	set name = "返回尸体"
	if(isobserver(mob))
		var/mob/dead/observer/O = mob
		O.reenter_corpse()

/mob/verb/returntolobby()
	set name = "{返回大厅}"
	set category = "选项"
	set hidden = 1

	if(key)
		GLOB.respawntimes[key] = world.time

	log_game("[key_name(usr)] respawned from underworld")

	to_chat(src, span_info("已成功返回大厅。"))

	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
//	stop_all_loops()
	SSdroning.kill_rain(src.client)
	SSdroning.kill_loop(src.client)
	SSdroning.kill_droning(src.client)
	remove_client_colour(/datum/client_colour/monochrome)
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		qdel(M)
		return

	client?.verbs -= GLOB.ghost_verbs
	M.key = key
	if(istype(src, /mob/dead/observer)) //Be rid of clogging ghost shades
		qdel(src)
	return
