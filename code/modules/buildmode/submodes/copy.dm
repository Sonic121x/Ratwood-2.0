/datum/buildmode_mode/copy
	key = "copy"
	var/atom/movable/stored = null

/datum/buildmode_mode/copy/Destroy()
	stored = null
	return ..()

/datum/buildmode_mode/copy/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("左键点击物体/地块/生物 = 生成所选目标的副本"))
	to_chat(c, span_notice("右键点击物体/生物 = 选择要复制的目标"))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/copy/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")

	if(left_click)
		var/turf/T = get_turf(object)
		if(stored)
			DuplicateObject(stored, perfectcopy=1, sameloc=0,newloc=T)
			log_admin("Build Mode: [key_name(c)] copied [stored] to [AREACOORD(object)]")
	else if(right_click)
		if(ismovableatom(object)) // No copying turfs for now.
			to_chat(c, span_notice("已将 [object] 设为模板。"))
			stored = object
