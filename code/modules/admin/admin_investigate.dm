/atom/proc/investigate_log(message, subject)
	if(!message || !subject)
		return
	var/F = file("[GLOB.log_directory]/[subject].html")
	WRITE_FILE(F, "[time_stamp()] [REF(src)] ([x],[y],[z]) || [src] [message]<br>")

/client/proc/investigate_show()
	set name = "调查记录"
	set category = "-管理-"
	if(!holder)
		return

	var/list/investigates = list(INVESTIGATE_RESEARCH, INVESTIGATE_EXONET, INVESTIGATE_PORTAL, INVESTIGATE_SINGULO, INVESTIGATE_WIRES, INVESTIGATE_TELESCI, INVESTIGATE_RECORDS, INVESTIGATE_CARGO, INVESTIGATE_SUPERMATTER, INVESTIGATE_ATMOS, INVESTIGATE_EXPERIMENTOR, INVESTIGATE_BOTANY, INVESTIGATE_HALLUCINATIONS, INVESTIGATE_RADIATION, INVESTIGATE_NANITES, INVESTIGATE_PRESENTS)
	var/list/subject_labels = list(INVESTIGATE_RESEARCH = "研究", INVESTIGATE_EXONET = "外部网络", INVESTIGATE_PORTAL = "传送门", INVESTIGATE_SINGULO = "奇点", INVESTIGATE_WIRES = "线路", INVESTIGATE_TELESCI = "远程传送", INVESTIGATE_RECORDS = "档案", INVESTIGATE_CARGO = "货运", INVESTIGATE_SUPERMATTER = "超物质", INVESTIGATE_ATMOS = "大气", INVESTIGATE_EXPERIMENTOR = "实验仪", INVESTIGATE_BOTANY = "植物学", INVESTIGATE_HALLUCINATIONS = "幻觉", INVESTIGATE_RADIATION = "辐射", INVESTIGATE_NANITES = "纳米机器人", INVESTIGATE_PRESENTS = "礼物")
	var/list/logs_present = list("备注、备忘录、观察名单")
	var/list/logs_missing = list("---")

	for(var/subject in investigates)
		var/temp_file = file("[GLOB.log_directory]/[subject].html")
		if(fexists(temp_file))
			logs_present += subject_labels[subject]
		else
			logs_missing += "[subject_labels[subject]] （空）"

	var/list/combined = sortList(logs_present) + sortList(logs_missing)

	var/selected = input("要调查什么？", "调查记录") as null|anything in combined

	if(!(selected in combined) || selected == "---")
		return

	selected = replacetext(selected, " （空）", "")
	selected = list("研究" = INVESTIGATE_RESEARCH, "外部网络" = INVESTIGATE_EXONET, "传送门" = INVESTIGATE_PORTAL, "奇点" = INVESTIGATE_SINGULO, "线路" = INVESTIGATE_WIRES, "远程传送" = INVESTIGATE_TELESCI, "档案" = INVESTIGATE_RECORDS, "货运" = INVESTIGATE_CARGO, "超物质" = INVESTIGATE_SUPERMATTER, "大气" = INVESTIGATE_ATMOS, "实验仪" = INVESTIGATE_EXPERIMENTOR, "植物学" = INVESTIGATE_BOTANY, "幻觉" = INVESTIGATE_HALLUCINATIONS, "辐射" = INVESTIGATE_RADIATION, "纳米机器人" = INVESTIGATE_NANITES, "礼物" = INVESTIGATE_PRESENTS)[selected] || selected
	if(selected == "备注、备忘录、观察名单" && check_rights(R_ADMIN))
		browse_messages()
		return

	var/F = file("[GLOB.log_directory]/[selected].html")
	if(!fexists(F))
		to_chat(src, span_danger("未找到 [selected] 日志文件。"))
		return
	src << browse("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>[file2text(F)]","window=investigate[selected];size=800x300")
