/datum/buildmode_mode/fill
	key = "fill"
	
	use_corner_selection = TRUE
	var/objholder = null

/datum/buildmode_mode/fill/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("左键点击地块/物体/生物 = 选择角点"))
	to_chat(c, span_notice("Alt + 左键点击地块/物体/生物 = 删除区域"))
	to_chat(c, span_notice("右键点击建造模式按钮 = 选择对象类型"))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/fill/change_settings(client/c)
	var/target_path = input(c, "输入类型路径：" ,"类型路径","/obj/structure/closet")
	objholder = text2path(target_path)
	if(!ispath(objholder))
		objholder = pick_closest_path(target_path)
		if(!objholder)
			alert("未选择路径。")
			return
		else if(ispath(objholder, /area))
			objholder = null
			alert("此模式不支持区域路径，请使用区域编辑模式。")
			return
	deselect_region()

/datum/buildmode_mode/fill/handle_click(client/c, params, obj/object)
	if(isnull(objholder))
		to_chat(c, span_warning("请先选择对象类型。"))
		deselect_region()
		return
	..()

/datum/buildmode_mode/fill/handle_selected_area(client/c, params)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/alt_click = pa.Find("alt")

	if(left_click) //rectangular
		if(alt_click)
			var/list/deletion_area = block(get_turf(cornerA),get_turf(cornerB))
			for(var/beep in deletion_area)
				var/turf/T = beep
				for(var/atom/movable/AM in T)
					qdel(AM)
				// extreme haircut
				T.ScrapeAway(INFINITY, CHANGETURF_DEFER_CHANGE)
			for(var/beep in deletion_area)
				var/turf/T = beep
				T.AfterChange()
			log_admin("Build Mode: [key_name(c)] deleted turfs from [AREACOORD(cornerA)] through [AREACOORD(cornerB)]")
			// if there's an analogous proc for this on tg lmk
			// empty_region(block(get_turf(cornerA),get_turf(cornerB)))
		else
			for(var/turf/T in block(get_turf(cornerA),get_turf(cornerB)))
				if(ispath(objholder,/turf))
					T.PlaceOnTop(objholder)
				else
					var/obj/A = new objholder(T)
					A.setDir(BM.build_dir)
			log_admin("Build Mode: [key_name(c)] with path [objholder], filled the region from [AREACOORD(cornerA)] through [AREACOORD(cornerB)]")
