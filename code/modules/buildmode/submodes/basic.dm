/datum/buildmode_mode/basic
	key = "basic"

/datum/buildmode_mode/basic/show_help(client/c)
	to_chat(c, "<span class='notice'>***********************************************************</span>")
	to_chat(c, "<span class='notice'>左键点击 = 建造/升级</span>")
	to_chat(c, "<span class='notice'>右键点击 = 拆解/删除/降级</span>")
	to_chat(c, "<span class='notice'>Ctrl + 左键点击 = 加固窗</span>")
	to_chat(c, "<span class='notice'>Alt + 左键点击 = 气闸门</span>")
	to_chat(c, "")
	to_chat(c, "<span class='notice'>使用左上角的按钮</span>")
	to_chat(c, "<span class='notice'>改变所建对象的方向。</span>")
	to_chat(c, "<span class='notice'>***********************************************************</span>")

/datum/buildmode_mode/basic/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")
	var/ctrl_click = pa.Find("ctrl")
	var/alt_click = pa.Find("alt")

	if(istype(object,/turf) && left_click && !alt_click && !ctrl_click)
		var/turf/T = object
		if(isfloorturf(object))
			T.PlaceOnTop(/turf/closed/wall/mineral/rogue/decowood)
		log_admin("Build Mode: [key_name(c)] built [T] at [AREACOORD(T)]")
		return
	else if(right_click)
		log_admin("Build Mode: [key_name(c)] deleted [object] at [AREACOORD(object)]")
		if(isturf(object))
			var/turf/T = object
			T.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		else if(isobj(object))
			qdel(object)
		return
