/client/proc/adminchangemap()
	set category = "-服务器-"
	set name = "更换地图"
	var/list/maprotatechoices = list()
	for (var/map in config.maplist)
		var/datum/map_config/VM = config.maplist[map]
		var/mapname = VM.map_name
		if (VM == config.defaultmap)
			mapname += " （默认）"

		if (VM.config_min_users > 0 || VM.config_max_users > 0)
			mapname += " \["
			if (VM.config_min_users > 0)
				mapname += "[VM.config_min_users]"
			else
				mapname += "0"
			mapname += "-"
			if (VM.config_max_users > 0)
				mapname += "[VM.config_max_users]"
			else
				mapname += "无限"
			mapname += "\]"

		maprotatechoices[mapname] = VM
	var/chosenmap = input("选择要更换的地图", "更换地图")  as null|anything in sortList(maprotatechoices)|"自定义"
	if (!chosenmap)
		return

	SSticker.maprotatechecked = 1
	if(chosenmap == "自定义")
		message_admins("[key_name_admin(usr)] 正在更换为自定义地图")
		log_admin("[key_name(usr)] is changing the map to a custom map")
		var/datum/map_config/VM = new

		VM.map_name = input("选择地图名称", "地图名称") as null|text
		if(isnull(VM.map_name))
			VM.map_name = "Custom"

		var/map_file = input("选择文件：", "地图文件") as null|file
		if(isnull(map_file))
			return

		if(copytext("[map_file]",-4) != ".dmm")
			to_chat(src, span_warning("文件名必须以 '.dmm' 结尾：[map_file]"))
			return

		if(!fcopy(map_file, "data/custom_maps/[map_file]"))
			return

		// This is to make sure the map works so the server does not start without a map.
		var/datum/parsed_map/M = new (map_file)
		if(!M)
			to_chat(src, span_warning("地图 '[map_file]' 无法正确解析。"))
			return

		if(!M.bounds)
			to_chat(src, span_warning("地图 '[map_file]' 缺少边界信息。"))
			qdel(M)
			return

		qdel(M)

		var/shuttles = alert("要修改穿梭机配置吗？", "地图穿梭机", "是", "否")
		if(shuttles == "是")
			for(var/s in VM.shuttles)
				var/shuttle = input(s, "地图穿梭机") as null|text
				if(!shuttle)
					continue
				if(!SSmapping.shuttle_templates[shuttle])
					to_chat(usr, span_warning("不存在名为 '[shuttle]' 的穿梭机，将使用默认配置。"))
					continue
				VM.shuttles[s] = shuttle

		VM.map_path = "custom"
		VM.map_file = "[map_file]"
		VM.config_filename = "data/next_map.json"
		var/json_value = list(
			"map_name" = VM.map_name,
			"map_path" = VM.map_path,
			"map_file" = VM.map_file,
			"shuttles" = VM.shuttles
		)

		// If the file isn't removed text2file will just append.
		if(fexists("data/next_map.json"))
			fdel("data/next_map.json")
		text2file(json_encode(json_value), "data/next_map.json")

		if(SSmap_vote.set_next_map(VM))
			message_admins("[key_name_admin(usr)] 已将地图更换为 [VM.map_name]")
			SSmap_vote.admin_override = TRUE
	else
		var/datum/map_config/VM = maprotatechoices[chosenmap]
		message_admins("[key_name_admin(usr)] 正在将地图更换为 [VM.map_name]")
		log_admin("[key_name(usr)] is changing the map to [VM.map_name]")
		if (SSmap_vote.set_next_map(VM))
			message_admins("[key_name_admin(usr)] 已将地图更换为 [VM.map_name]")
			SSmap_vote.admin_override = TRUE
