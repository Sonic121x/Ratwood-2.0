/client/proc/fix_next_move()
	set category = "调试"
	set name = "解除所有人行动冻结"
	var/largest_move_time = 0
	var/largest_click_time = 0
	var/mob/largest_move_mob = null
	var/mob/largest_click_mob = null
	for(var/mob/M in world)
		if(!M.client)
			continue
		if(M.next_move >= largest_move_time)
			largest_move_mob = M
			if(M.next_move > world.time)
				largest_move_time = M.next_move - world.time
			else
				largest_move_time = 1
		if(M.next_click >= largest_click_time)
			largest_click_mob = M
			if(M.next_click > world.time)
				largest_click_time = M.next_click - world.time
			else
				largest_click_time = 0
		log_admin("DEBUG: [key_name(M)]  next_move = [M.next_move]  lastDblClick = [M.next_click]  world.time = [world.time]")
		M.next_move = 1
		M.next_click = 0
	message_admins("[ADMIN_LOOKUPFLW(largest_move_mob)] 的移动延迟最长，为 [largest_move_time] 帧／[DisplayTimeText(largest_move_time)]！")
	message_admins("[ADMIN_LOOKUPFLW(largest_click_mob)] 的点击延迟最长，为 [largest_click_time] 帧／[DisplayTimeText(largest_click_time)]！")
	message_admins("world.time = [world.time]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Unfreeze Everyone") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/radio_report()
	set category = "调试"
	set name = "无线电报告"

	var/output = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><b>无线电报告</b><hr>"
	for (var/fq in SSradio.frequencies)
		output += "<b>频率：[fq]</b><br>"
		var/datum/radio_frequency/fqs = SSradio.frequencies[fq]
		if (!fqs)
			output += "&nbsp;&nbsp;<b>错误</b><br>"
			continue
		for (var/filter in fqs.devices)
			var/list/f = fqs.devices[filter]
			if (!f)
				output += "&nbsp;&nbsp;[filter]：错误<br>"
				continue
			output += "&nbsp;&nbsp;[filter]: [f.len]<br>"
			for (var/device in f)
				if (istype(device, /atom))
					var/atom/A = device
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device] ([AREACOORD(A)])<br>"
				else
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device]<br>"

	usr << browse(output,"window=radioreport")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Radio Report") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/reload_admins()
	set name = "重新加载管理员"
	set category = "-服务器-"

	if(!src.holder)
		return

	var/confirm = alert(src, "确定要重新加载所有管理员吗？", "确认", "是", "否")
	if(confirm !="是")
		return

	load_admins()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Reload All Admins") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins("[key_name_admin(usr)] 手动重新加载了管理员")

/client/proc/reload_whitelist()
	set name = "重新加载白名单"
	set category = "-服务器-"

	if(!src.holder)
		return

	var/confirm = alert(src, "确定要重新加载白名单吗？", "确认", "是", "否")
	if(confirm !="是")
		return

	load_whitelist()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Reload Whitelist") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins("[key_name_admin(usr)] 手动重新加载了白名单")
