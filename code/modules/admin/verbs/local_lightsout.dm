/client/proc/local_lightsout()
	set category = "-主持-"
	set name = "熄灭附近灯光"

	if(!check_rights(R_ADMIN))
		return

	for(var/obj/O in view(usr.client))
		O.extinguish()
		if(O.type == /obj/machinery/light/roguestreet/)
			var/obj/machinery/light/roguestreet/streetlamp = O
			streetlamp.lights_out()
	var/turf/loc = usr.loc
	message_admins(span_adminnotice("[key_name_admin(usr)] 熄灭了 [loc.x], [loc.y], [loc.z] 附近的灯光"))
