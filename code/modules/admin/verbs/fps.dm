//replaces the old Ticklag verb, fps is easier to understand
/client/proc/set_server_fps()
	set category = "调试"
	set name = "设置服务器帧率"
	set desc = ""

	if(!check_rights(R_DEBUG))
		return

	var/cfg_fps = CONFIG_GET(number/fps)
	var/new_fps = round(input("设置游戏每秒帧数。可能导致游戏异常（默认：[cfg_fps]）","帧率", world.fps) as num|null)

	if(new_fps <= 0)
		to_chat(src, span_danger("错误：set_server_fps() 的 world.fps 值无效。未作更改。"))
		return
	if(new_fps > cfg_fps * 1.5)
		if(alert(src, "你正在设置较高的帧率：\n\t每秒 [new_fps] 帧\n\tconfig.fps = [cfg_fps]","警告！","确认","中止操作") != "确认")
			return

	var/msg = "[key_name(src)] 将 world.fps 改为 [new_fps]"
	log_admin(msg, 0)
	message_admins(msg, 0)
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Set Server FPS", "[new_fps]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	CONFIG_SET(number/fps, new_fps)
	world.change_fps(new_fps)
