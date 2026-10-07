/proc/possess(obj/O in world)
	set name = "附身物体"
	set category = null
	set hidden = 0

	if((O.obj_flags & DANGEROUS_POSSESSION) && CONFIG_GET(flag/forbid_singulo_possession))
		to_chat(usr, "[O] 太过强大，你无法附身。")
		return

	var/turf/T = get_turf(O)

	if(T)
		log_admin("[key_name(usr)] has possessed [O] ([O.type]) at [AREACOORD(T)]")
		message_admins("[key_name(usr)] 附身于 [AREACOORD(T)] 的 [O] ([O.type])")
	else
		log_admin("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location")
		message_admins("[key_name(usr)] 附身于未知位置的 [O] ([O.type])")

	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.loc = O
	usr.real_name = O.name
	usr.name = O.name
	usr.reset_perspective(O)
	usr.control_object = O
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Possess Object") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/release(obj/O in world)
	set name = "解除物体附身"
	set category = null
	set hidden = 0
	//usr.loc = get_turf(usr)

	if(usr.control_object && usr.name_archive) //if you have a name archived and if you are actually relassing an object
		usr.real_name = usr.name_archive
		usr.name_archive = ""
		usr.name = usr.real_name
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.name = H.get_visible_name()


	usr.loc = get_turf(usr.control_object)
	usr.reset_perspective()
	usr.control_object = null
	usr.forceMove(O.loc)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Release Object") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/givetestverbs(mob/M in GLOB.mob_list)
	set desc = ""
	set category = "调试"
	set name = "授予附身指令"
	M.verbs += /proc/possess
	M.verbs += /proc/release
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Possessing Verbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
