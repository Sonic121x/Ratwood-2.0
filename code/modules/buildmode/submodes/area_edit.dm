/datum/buildmode_mode/area_edit
	key = "areaedit"
	var/area/storedarea
	var/image/areaimage

/datum/buildmode_mode/area_edit/New()
	areaimage = image('icons/turf/areas.dmi', null, "yellow")
	..()

/datum/buildmode_mode/area_edit/enter_mode(datum/buildmode/BM)
	BM.holder.images += areaimage

/datum/buildmode_mode/area_edit/exit_mode(datum/buildmode/BM)
	areaimage.loc = null // de-color the area
	BM.holder.images -= areaimage
	return ..()

/datum/buildmode_mode/area_edit/Destroy()
	QDEL_NULL(areaimage)
	storedarea = null
	return ..()

/datum/buildmode_mode/area_edit/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("左键点击物体/地块/生物 = 涂抹区域"))
	to_chat(c, span_notice("右键点击物体/地块/生物 = 选择要涂抹的区域"))
	to_chat(c, span_notice("右键点击建造模式按钮 = 创建新区域"))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/area_edit/change_settings(client/c)
	var/target_path = input(c, "输入类型路径：", "类型路径", "/area")
	var/areatype = text2path(target_path)
	if(ispath(areatype,/area))
		var/areaname = input(c, "输入区域名称：", "区域名称", "区域")
		if(!areaname || !length(areaname))
			return
		storedarea = new areatype
		storedarea.power_equip = 0
		storedarea.power_light = 0
		storedarea.power_environ = 0
		storedarea.always_unpowered = 0
		storedarea.name = areaname
		areaimage.loc = storedarea // color our area

/datum/buildmode_mode/area_edit/handle_click(client/c, params, object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")

	if(left_click)
		if(!storedarea)
			to_chat(c, span_warning("请先配置或选择要涂抹的区域！"))
			return
		var/turf/T = get_turf(object)
		if(get_area(T) != storedarea)
			log_admin("Build Mode: [key_name(c)] added [AREACOORD(T)] to [storedarea]")
			storedarea.contents.Add(T)
	else if(right_click)
		var/turf/T = get_turf(object)
		storedarea = get_area(T)
		areaimage.loc = storedarea // color our area
