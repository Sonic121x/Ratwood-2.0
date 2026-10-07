/datum/buildmode_mode/mapgen
	key = "mapgen"

	use_corner_selection = TRUE
	var/generator_path

/datum/buildmode_mode/mapgen/show_help(client/c)
	to_chat(c, "<span class='notice'>***********************************************************</span>")
	to_chat(c, "<span class='notice'>左键点击地块/物体/生物 = 选择角点</span>")
	to_chat(c, "<span class='notice'>右键点击建造模式按钮 = 选择生成器</span>")
	to_chat(c, "<span class='notice'>***********************************************************</span>")

/datum/buildmode_mode/mapgen/change_settings(client/c)
	var/list/gen_paths = subtypesof(/datum/mapGenerator)
	var/list/options = list()
	for(var/path in gen_paths)
		var/datum/mapGenerator/MP = path
		options[initial(MP.buildmode_name)] = path
	var/type = input(c,"选择生成器类型","类型") as null|anything in options
	if(!type)
		return

	generator_path = options[type]
	deselect_region()

/datum/buildmode_mode/mapgen/handle_click(client/c, params, obj/object)
	if(isnull(generator_path))
		to_chat(c, span_warning("请先选择生成器类型。"))
		deselect_region()
		return
	..()

/datum/buildmode_mode/mapgen/handle_selected_area(client/c, params)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	if(left_click)
		var/datum/mapGenerator/G = new generator_path
		G.defineRegion(cornerA, cornerB, 1)
		highlight_region(G.map)
		var/confirm = alert("确定要运行地图生成器吗？", "运行生成器", "是", "否")
		if(confirm == "是")
			G.generate()
		log_admin("Build Mode: [key_name(c)] ran the map generator '[G.buildmode_name]' in the region from [AREACOORD(cornerA)] to [AREACOORD(cornerB)]")
