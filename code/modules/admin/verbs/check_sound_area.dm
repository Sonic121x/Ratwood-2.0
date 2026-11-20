/**
 * Reports the current area's sound settings and the listener's active point ambience.
 *
 * Reads runtime area values, including soundproofing changed after map initialization.
 */
/client/proc/check_sound_area()
	set category = "调试"
	set name = "检查区域声音"
	if(!check_rights(R_DEBUG))
		return
	// The ear, not the body: a headless dullahan's sound is decided where the head is
	var/turf/here = get_turf(point_ambience.ear || mob)
	if(!here)
		to_chat(usr, span_warning("你当前不在任何地块上。"))
		return
	var/area/A = get_area(here)
	if(!A)
		to_chat(usr, span_warning("这里没有区域。"))
		return

	var/list/msg = list("<b>[A.name]</b>  <span class='notice'>[A.type]</span>")
	msg += "隔音：<b>[A.soundproof ? "是，此处说话仅在视线范围内传播，成人互动音效限制在房间内" : "否，声音正常向外传播"]</b>"
	msg += "声场（soundenv）：[A.soundenv][A.soundenv ? "" : "（未设置，空间音效使用 SOUND_DEFAULT_ENVIRONMENT [SOUND_DEFAULT_ENVIRONMENT]）"]"
	msg += "地块（[here.x],[here.y],[here.z]） | 转换类型（converted_type）[A.converted_type || "无"]"

	var/turf/above = GET_TURF_ABOVE(here)
	var/turf/below = GET_TURF_BELOW(here)
	for(var/turf/T in list(above, below))
		var/area/other = get_area(T)
		msg += "[T == above ? "上方" : "下方"]：[other ? "[other.name]，隔音 [other.soundproof ? "是" : "否"]" : "无"]"

	var/river_mark = SSpoint_ambience.river_fill.marks[here]
	var/fill_state = "未标记，不在河流声音范围内"
	if(!isnull(river_mark))
		fill_state = RIVER_FILL_AUDIBLE(river_mark) ? "可达，路径距离 [RIVER_FILL_COST(river_mark) * 0.5] 格" : "被阻挡，无声"
	msg += "河声覆盖：[SSpoint_ambience.river_fill.done ? fill_state : "等待初始填充"] | 区域河声（river_ambience）[A.river_ambience ? "开启" : "关闭"]"

	// Report the last sent volume rather than recomputing playback for the diagnostic
	var/list/playing = list()
	for(var/datum/point_ambience_category/category as anything in SSpoint_ambience.categories)
		var/atom/source = point_ambience.sources[category]
		if(!source)
			continue
		var/datum/point_ambience_slot/slot = LAZYACCESS(point_ambience.slots, category.index)
		var/vol = slot ? slot.last_volume : null
		var/turf/source_turf = SSpoint_ambience.source_turfs[source] || get_turf(source)
		var/where = "位置未知"
		if(category == SSpoint_ambience.river_category)
			where = "覆盖：[fill_state]"
		else if(source_turf)
			var/dx = source_turf.x - here.x
			var/dy = source_turf.y - here.y
			var/distsq = dx * dx + dy * dy
			where = "[round(sqrt(distsq), 0.1)] 格"
			if(distsq > category.range_sq)
				where += "，已超出其 [category.range] 格范围，属于异常"
			if(source_turf.z != here.z)
				where += "，相隔 [abs(source_turf.z - here.z)] 层"
			// Muffling also changes filtering and environment, so equal volumes can sound
			// different
			switch(SSpoint_ambience.source_occluded(source_turf, here, category))
				if(OCCLUSION_MUFFLED)
					where += "，<b>闷化</b>（无混响声场加遮挡低通滤波，不只是降低音量）"
				if(OCCLUSION_SOLID)
					where += "，遮挡检查判定为完全阻挡，但仍在播放，属于异常"
		playing += "&nbsp;&nbsp;[get_sound_setting_display(category.config_name)]：<b>[isnull(vol) ? "未知" : round(vol, 0.1)]</b>/100，[where]"
	msg += "你的通道上的局部环境音：[length(playing) ? "" : "<b>无</b>"]"
	msg += playing

	to_chat(usr, jointext(msg, "<br>"))
