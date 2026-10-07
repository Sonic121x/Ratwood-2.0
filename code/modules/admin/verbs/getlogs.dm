//This proc allows download of past server logs saved within the data/logs/ folder.
/client/proc/getserverlogs()
	set name = "获取服务器日志"
	set desc = ""
	set category = "-服务器-"

	browseserverlogs()

/client/proc/getcurrentlogs()
	set name = "获取当前回合日志"
	set desc = ""
	set category = "-服务器-"

	browseserverlogs("[GLOB.log_directory]/")

/client/proc/browseserverlogs(path = "data/logs/")
	path = browse_files(path)
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] 访问了文件：[path]")
	switch(alert("查看（游戏内）、打开（系统文本编辑器）还是下载？", path, "查看", "打开", "下载"))
		if ("查看")
			src << browse("<pre style='word-wrap: break-word;'>[html_encode(file2text(file(path)))]</pre>", list2params(list("window" = "viewfile.[path]")))
		if ("打开")
			src << run(file(path))
		if ("下载")
			src << ftp(file(path))
		else
			return
	to_chat(src, "正在尝试发送 [path]，文件较大时可能需要几分钟。")
	return
