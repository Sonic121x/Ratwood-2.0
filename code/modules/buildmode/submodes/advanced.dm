/datum/buildmode_mode/advanced
	key = "advanced"
	var/objholder = null

// FIXME: add logic which adds a button displaying the icon
// of the currently selected path

/datum/buildmode_mode/advanced/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("右键点击建造模式按钮 = 设置对象类型"))
	to_chat(c, span_notice("Alt + 左键点击地块/物体 = 复制对象类型"))
	to_chat(c, span_notice("左键点击地块/物体 = 放置对象"))
	to_chat(c, span_notice("右键点击 = 删除对象"))
	to_chat(c, "")
	to_chat(c, span_notice("使用左上角的按钮"))
	to_chat(c, span_notice("改变所建对象的方向。"))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/advanced/change_settings(client/c)
	var/target_path = input(c, "输入类型路径：", "类型路径", "/obj/structure/closet")
	objholder = text2path(target_path)
	if(!ispath(objholder))
		objholder = pick_closest_path(target_path)
		if(!objholder)
			alert("未选择路径")
			return
		else if(ispath(objholder, /area))
			objholder = null
			alert("不允许使用该路径。")
			return

/datum/buildmode_mode/advanced/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")
	var/alt_click = pa.Find("alt")

	if(left_click && alt_click)
		if (istype(object, /turf) || istype(object, /obj) || istype(object, /mob))
			objholder = object.type
			to_chat(c, span_notice("已选择 [initial(object.name)]（[object.type]）。"))
		else
			to_chat(c, span_notice("[initial(object.name)] 不是地块、物体或生物！请重新选择。"))
	else if(left_click)
		if(ispath(objholder,/turf))
			var/turf/T = get_turf(object)
			log_admin("Build Mode: [key_name(c)] modified [T] in [AREACOORD(object)] to [objholder]")
			T.ChangeTurf(objholder)
		else if(!isnull(objholder))
			var/obj/A = new objholder (get_turf(object))
			A.setDir(BM.build_dir)
			log_admin("Build Mode: [key_name(c)] modified [A]'s [COORD(A)] dir to [BM.build_dir]")
		else
			to_chat(c, span_warning("请先选择对象类型。"))
	else if(right_click)
		if(isobj(object))
			log_admin("Build Mode: [key_name(c)] deleted [object] at [AREACOORD(object)]")
			qdel(object)
