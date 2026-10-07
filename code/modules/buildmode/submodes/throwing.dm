/datum/buildmode_mode/throwing
	key = "throw"
	
	var/atom/movable/throw_atom = null
	
/datum/buildmode_mode/throwing/Destroy()
	throw_atom = null
	return ..()

/datum/buildmode_mode/throwing/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("左键点击地块/物体/生物 = 选择"))
	to_chat(c, span_notice("右键点击地块/物体/生物 = 投掷"))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/throwing/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")

	if(left_click)
		if(isturf(object))
			return
		throw_atom = object
		to_chat(c, "已选择对象 '[throw_atom]'")
	if(right_click)
		if(throw_atom)
			throw_atom.throw_at(object, 10, 1, c.mob)
			log_admin("Build Mode: [key_name(c)] threw [throw_atom] at [object] ([AREACOORD(object)])")
