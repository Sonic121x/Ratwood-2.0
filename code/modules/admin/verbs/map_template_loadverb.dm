/client/proc/map_template_load()
	set category = "-主持-"
	set name = "地图模板 - 放置"

	var/datum/map_template/template

	var/map = input(src, "选择要放置在你当前位置的地图模板","放置地图模板") as null|anything in sortList(SSmapping.map_templates)
	if(!map)
		return
	template = SSmapping.map_templates[map]

	var/turf/T = get_turf(mob)
	if(!T)
		return

	var/list/preview = list()
	for(var/S in template.get_affected_turfs(T,centered = TRUE))
		var/image/item = image('icons/turf/overlays.dmi',S,"greenOverlay")
		item.plane = ABOVE_LIGHTING_PLANE
		preview += item
	images += preview
	if(alert(src,"确认位置。","确认模板放置","是","否") == "是")
		if(template.load(T, centered = TRUE))
			message_admins(span_adminnotice("[key_name_admin(src)] 在 [ADMIN_COORDJMP(T)] 放置了地图模板 ([template.name])"))
		else
			to_chat(src, "地图放置失败")
	images -= preview

/client/proc/map_template_upload()
	set category = "-主持-"
	set name = "地图模板 - 上传"

	var/map = input(src, "选择要上传到模板库的地图模板","上传地图模板") as null|file
	if(!map)
		return
	if(copytext("[map]",-4) != ".dmm")
		to_chat(src, span_warning("文件名必须以 '.dmm' 结尾：[map]"))
		return
	var/datum/map_template/M
	switch(alert(src, "这是什么类型的地图？", "地图类型", "普通", "穿梭机", "取消"))
		if("普通")
			M = new /datum/map_template(map, "[map]", TRUE)
		else
			return
	if(!M.cached_map)
		to_chat(src, span_warning("地图模板 '[map]' 无法正确解析。"))
		return

	var/datum/map_report/report = M.cached_map.check_for_errors()
	var/report_link
	if(report)
		report.show_to(src)
		report_link = " - <a href='?src=[REF(report)];[HrefToken(TRUE)];show=1'>校验报告</a>"
		to_chat(src, span_warning("地图模板 '[map]' <a href='?src=[REF(report)];[HrefToken()];show=1'>未通过校验</a>。"))
		if(report.loadable)
			var/response = alert(src, "地图未通过校验，仍要加载吗？", "地图错误", "取消", "仍然上传")
			if(response != "仍然上传")
				return
		else
			alert(src, "地图未通过校验，无法加载。", "地图错误", "知道了")
			return

	SSmapping.map_templates[M.name] = M
	message_admins(span_adminnotice("[key_name_admin(src)] 上传了地图模板 '[map]' ([M.width]x[M.height])[report_link]。"))
	to_chat(src, span_notice("地图模板 '[map]' 已可放置 ([M.width]x[M.height])"))
