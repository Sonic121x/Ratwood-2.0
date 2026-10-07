/client/proc/callproc()
	set category = "调试"
	set name = "高级过程调用"
	set waitfor = FALSE
	callproc_blocking()

/client/proc/callproc_blocking(list/get_retval)
	if(!check_rights(R_DEBUG))
		return

	var/datum/target
	var/targetselected = FALSE
	var/returnval

	switch(alert("该过程是否属于某个对象？",,"是","否"))
		if("是")
			targetselected = TRUE
			var/list/value = vv_get_value(default_class = VV_ATOM_REFERENCE, classes = list(VV_ATOM_REFERENCE, VV_DATUM_REFERENCE, VV_MOB_REFERENCE, VV_CLIENT, VV_MARKED_DATUM, VV_TEXT_LOCATE, VV_PROCCALL_RETVAL))
			if (!value["class"] || !value["value"])
				return
			target = value["value"]
			if(!istype(target))
				to_chat(usr, span_danger("目标无效。"))
				return
		if("否")
			target = null
			targetselected = FALSE

	var/procpath = input("过程路径，例如：/proc/fake_blood","路径：", null) as text|null
	if(!procpath)
		return

	//strip away everything but the proc name
	var/list/proclist = splittext(procpath, "/")
	if (!length(proclist))
		return

	var/procname = proclist[proclist.len]
	var/proctype = ("verb" in proclist) ? "verb" :"proc"

	if(targetselected)
		if(!hascall(target, procname))
			to_chat(usr, span_warning("错误：callproc()：类型 [target.type] 没有名为 [procpath] 的 [proctype]。"))
			return
	else
		procpath = "/[proctype]/[procname]"
		if(!text2path(procpath))
			to_chat(usr, span_warning("错误：callproc()：[procpath] 不存在。"))
			return

	var/list/lst = get_callproc_args()
	if(!lst)
		return

	if(targetselected)
		if(!target)
			to_chat(usr, "<font color='red'>错误：callproc()：过程所属的对象已不存在。</font>")
			return
		var/msg = "[key_name(src)] 调用了 [target] 的 [procname]()，[lst.len ? "参数为 [list2params(lst)]":"无参数"]。"
		log_admin(msg)
		message_admins(msg)				//Proccall announce removed.
		admin_ticket_log(target, msg)
		returnval = WrapAdminProcCall(target, procname, lst) // Pass the lst as an argument list to the proc
	else
		//this currently has no hascall protection. wasn't able to get it working.
		log_admin("[key_name(src)] called [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"].")
		message_admins("[key_name(src)] 调用了 [procname]()，[lst.len ? "参数为 [list2params(lst)]":"无参数"]。")			//Proccall announce removed.
		returnval = WrapAdminProcCall(GLOBAL_PROC, procname, lst) // Pass the lst as an argument list to the proc
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Advanced ProcCall") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(get_retval)
		get_retval += returnval
	. = get_callproc_returnval(returnval, procname)
	if(.)
		to_chat(usr, .)

GLOBAL_VAR(AdminProcCaller)
GLOBAL_PROTECT(AdminProcCaller)
GLOBAL_VAR_INIT(AdminProcCallCount, 0)
GLOBAL_PROTECT(AdminProcCallCount)
GLOBAL_VAR(LastAdminCalledTargetRef)
GLOBAL_PROTECT(LastAdminCalledTargetRef)
GLOBAL_VAR(LastAdminCalledTarget)
GLOBAL_PROTECT(LastAdminCalledTarget)
GLOBAL_VAR(LastAdminCalledProc)
GLOBAL_PROTECT(LastAdminCalledProc)
GLOBAL_LIST_EMPTY(AdminProcCallSpamPrevention)
GLOBAL_PROTECT(AdminProcCallSpamPrevention)

/proc/WrapAdminProcCall(datum/target, procname, list/arguments)
	if(target && procname == "Del")
		to_chat(usr, "不允许调用 Del()")
		return

	if(target != GLOBAL_PROC && !target.CanProcCall(procname))
		to_chat(usr, "不允许调用 [target.type]/proc/[procname]！")
		return
	var/current_caller = GLOB.AdminProcCaller
	var/ckey = usr ? usr.client.ckey : GLOB.AdminProcCaller
	if(!ckey)
		CRASH("WrapAdminProcCall with no ckey: [target] [procname] [english_list(arguments)]")
	if(current_caller && current_caller != ckey)
		if(!GLOB.AdminProcCallSpamPrevention[ckey])
			to_chat(usr, span_adminnotice("另一组管理员调用的过程仍在运行，你的过程将在其结束后运行。"))
			GLOB.AdminProcCallSpamPrevention[ckey] = TRUE
			UNTIL(!GLOB.AdminProcCaller)
			to_chat(usr, span_adminnotice("正在运行你的过程"))
			GLOB.AdminProcCallSpamPrevention -= ckey
		else
			UNTIL(!GLOB.AdminProcCaller)
	GLOB.LastAdminCalledProc = procname
	if(target != GLOBAL_PROC)
		GLOB.LastAdminCalledTargetRef = REF(target)
	GLOB.AdminProcCaller = ckey	//if this runtimes, too bad for you
	++GLOB.AdminProcCallCount
	. = world.WrapAdminProcCall(target, procname, arguments)
	if(--GLOB.AdminProcCallCount == 0)
		GLOB.AdminProcCaller = null

//adv proc call this, ya nerds
/world/proc/WrapAdminProcCall(datum/target, procname, list/arguments)
	if(target == GLOBAL_PROC)
		return call("/proc/[procname]")(arglist(arguments))
	else if(target != world)
		return call(target, procname)(arglist(arguments))
	else
		log_admin("[key_name(usr)] attempted to call world/proc/[procname] with arguments: [english_list(arguments)]")

/proc/IsAdminAdvancedProcCall()
#ifdef TESTING
	return FALSE
#else
	return usr && usr.client && GLOB.AdminProcCaller == usr.client.ckey
#endif

/client/proc/callproc_datum(datum/A as null|area|mob|obj|turf)
	set category = "调试"
	set name = "原子对象过程调用"
	set waitfor = 0

	if(!check_rights(R_DEBUG))
		return

	var/procname = input("过程名称，例如：fake_blood","过程：", null) as text|null
	if(!procname)
		return
	if(!hascall(A,procname))
		to_chat(usr, "<font color='red'>错误：callproc_datum()：类型 [A.type] 没有名为 [procname] 的过程。</font>")
		return
	var/list/lst = get_callproc_args()
	if(!lst)
		return

	if(!A || !IsValidSrc(A))
		to_chat(usr, span_warning("错误：callproc_datum()：过程所属的对象已不存在。"))
		return
	log_admin("[key_name(src)] called [A]'s [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"].")
	var/msg = "[key_name(src)] 调用了 [A] 的 [procname]()，[lst.len ? "参数为 [list2params(lst)]":"无参数"]。"
	message_admins(msg)
	admin_ticket_log(A, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Atom ProcCall") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	var/returnval = WrapAdminProcCall(A, procname, lst) // Pass the lst as an argument list to the proc
	. = get_callproc_returnval(returnval,procname)
	if(.)
		to_chat(usr, .)

/client/proc/get_callproc_args()
	var/argnum = input("参数数量","数量：",0) as num|null
	if(isnull(argnum))
		return

	. = list()
	var/list/named_args = list()
	while(argnum--)
		var/named_arg = input("留空表示位置参数。位置参数会被视为先于命名参数添加。", "命名参数") as text|null
		var/value = vv_get_value(restricted_classes = list(VV_RESTORE_DEFAULT))
		if (!value["class"])
			return
		if(named_arg)
			named_args[named_arg] = value["value"]
		else
			. += LIST_VALUE_WRAP_LISTS(value["value"])
	if(LAZYLEN(named_args))
		. += named_args

/client/proc/get_callproc_returnval(returnval,procname)
	. = ""
	if(islist(returnval))
		var/list/returnedlist = returnval
		. = "<font color='blue'>"
		if(returnedlist.len)
			var/assoc_check = returnedlist[1]
			if(istext(assoc_check) && (returnedlist[assoc_check] != null))
				. += "[procname] 返回了一个关联列表："
				for(var/key in returnedlist)
					. += "\n[key] = [returnedlist[key]]"

			else
				. += "[procname] 返回了一个列表："
				for(var/elem in returnedlist)
					. += "\n[elem]"
		else
			. = "[procname] 返回了一个空列表"
		. += "</font>"

	else
		. = "<font color='blue'>[procname] 返回：[!isnull(returnval) ? html_encode(returnval) : "null"]</font>"
