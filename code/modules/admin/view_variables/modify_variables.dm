GLOBAL_LIST_INIT(VVlocked, list("vars", "datum_flags", "client", "mob"))		//Requires DEBUG
GLOBAL_PROTECT(VVlocked)
GLOBAL_LIST_INIT(VVicon_edit_lock, list("icon", "icon_state", "overlays", "underlays"))		//Requires DEBUG or FUN
GLOBAL_PROTECT(VVicon_edit_lock)
GLOBAL_LIST_INIT(VVckey_edit, list("key", "ckey"))	//Requires DEBUG or SPAWN
GLOBAL_PROTECT(VVckey_edit)
GLOBAL_LIST_INIT(VVpixelmovement, list("bound_x", "bound_y", "step_x", "step_y", "step_size", "bound_height", "bound_width", "bounds"))		//No editing ever.
GLOBAL_PROTECT(VVpixelmovement)

/client/proc/vv_parse_text(O, new_var)
	if(O && findtext(new_var,"\["))
		var/process_vars = alert(usr,"字符串中检测到 \[]，是否按变量解析？","解析变量？","是","否")
		if(process_vars == "是")
			. = string2listofvars(new_var, O)

//do they want you to include subtypes?
//FALSE = no subtypes, strict exact type pathing (or the type doesn't have subtypes)
//TRUE = Yes subtypes
//NULL = User cancelled at the prompt or invalid type given
/client/proc/vv_subtype_prompt(type)
	if (!ispath(type))
		return
	var/list/subtypes = subtypesof(type)
	if (!subtypes || !subtypes.len)
		return FALSE
	if (subtypes && subtypes.len)
		switch(alert("是否严格匹配对象类型？", "类型检测", "仅此类型","此类型及子类型", "取消"))
			if("仅此类型")
				return FALSE
			if("此类型及子类型")
				return TRUE
			else
				return

/client/proc/vv_reference_list(type, subtypes)
	. = list()
	var/list/types = list(type)
	if (subtypes)
		types = typesof(type)

	var/list/fancytypes = make_types_fancy(types)

	for(var/fancytype in fancytypes) //swap the assoication
		types[fancytypes[fancytype]] = fancytype

	var/things = get_all_of_type(type, subtypes)

	var/i = 0
	for(var/thing in things)
		var/datum/D = thing
		i++
		//try one of 3 methods to shorten the type text:
		//	fancy type,
		//	fancy type with the base type removed from the begaining,
		//	the type with the base type removed from the begaining
		var/fancytype = types[D.type]
		if (findtext(fancytype, types[type]))
			fancytype = copytext(fancytype, length(types[type])+1)
		var/shorttype = copytext("[D.type]", length("[type]")+1)
		if (length(shorttype) > length(fancytype))
			shorttype = fancytype
		if (!length(shorttype))
			shorttype = "/"

		.["[D]([shorttype])[REF(D)]#[i]"] = D

/client/proc/mod_list_add_ass(atom/O) //hehe

	var/list/L = vv_get_value(restricted_classes = list(VV_RESTORE_DEFAULT))
	var/class = L["class"]
	if (!class)
		return
	var/var_value = L["value"]

	if(class == VV_TEXT || class == VV_MESSAGE)
		var/list/varsvars = vv_parse_text(O, var_value)
		for(var/V in varsvars)
			var_value = replacetext(var_value,"\[[V]]","[O.vars[V]]")

	return var_value


/client/proc/mod_list_add(list/L, atom/O, original_name, objectvar)
	var/list/LL = vv_get_value(restricted_classes = list(VV_RESTORE_DEFAULT))
	var/class = LL["class"]
	if (!class)
		return
	var/var_value = LL["value"]

	if(class == VV_TEXT || class == VV_MESSAGE)
		var/list/varsvars = vv_parse_text(O, var_value)
		for(var/V in varsvars)
			var_value = replacetext(var_value,"\[[V]]","[O.vars[V]]")

	if (O)
		L = L.Copy()

	L += var_value

	switch(alert("是否为此列表项关联一个值？",,"是","否"))
		if("是")
			L[var_value] = mod_list_add_ass(O) //hehe
	if (O)
		if (O.vv_edit_var(objectvar, L) == FALSE)
			to_chat(src, "对象拒绝了此次修改。")
			return
	log_world("### ListVarEdit by [src]: [(O ? O.type : "/list")] [objectvar]: ADDED=[var_value]")
	log_admin("[key_name(src)] modified [original_name]'s [objectvar]: ADDED=[var_value]")
	message_admins("[key_name_admin(src)] 修改了 [original_name] 的 [objectvar]：添加=[var_value]")

/client/proc/mod_list(list/L, atom/O, original_name, objectvar, index, autodetect_class = FALSE)
	if(!check_rights(R_VAREDIT))
		return
	if(!istype(L, /list))
		to_chat(src, "这不是列表。")
		return

	if(L.len > 1000)
		var/confirm = alert(src, "要编辑的列表很长，继续操作可能导致服务器崩溃。", "警告", "继续", "中止")
		if(confirm != "继续")
			return

	var/is_normal_list = IS_NORMAL_LIST(L)
	var/list/names = list()
	for (var/i in 1 to L.len)
		var/key = L[i]
		var/value
		if (is_normal_list && !isnum(key))
			value = L[key]
		if (value == null)
			value = "null"
		names["#[i] [key] = [value]"] = i
	if (!index)
		var/variable = input("选择变量：","变量") as null|anything in names + "（添加变量）" + "（清除空值）" + "（清除重复项）" + "（打乱顺序）"

		if(variable == null)
			return

		if(variable == "（添加变量）")
			mod_list_add(L, O, original_name, objectvar)
			return

		if(variable == "（清除空值）")
			L = L.Copy()
			listclearnulls(L)
			if (!O.vv_edit_var(objectvar, L))
				to_chat(src, "对象拒绝了此次修改。")
				return
			log_world("### ListVarEdit by [src]: [O.type] [objectvar]: CLEAR NULLS")
			log_admin("[key_name(src)] modified [original_name]'s [objectvar]: CLEAR NULLS")
			message_admins("[key_name_admin(src)] 清除了 [original_name] 的列表 [objectvar] 中的空值")
			return

		if(variable == "（清除重复项）")
			L = uniqueList(L)
			if (!O.vv_edit_var(objectvar, L))
				to_chat(src, "对象拒绝了此次修改。")
				return
			log_world("### ListVarEdit by [src]: [O.type] [objectvar]: CLEAR DUPES")
			log_admin("[key_name(src)] modified [original_name]'s [objectvar]: CLEAR DUPES")
			message_admins("[key_name_admin(src)] 清除了 [original_name] 的列表 [objectvar] 中的重复项")
			return

		if(variable == "（打乱顺序）")
			L = shuffle(L)
			if (!O.vv_edit_var(objectvar, L))
				to_chat(src, "对象拒绝了此次修改。")
				return
			log_world("### ListVarEdit by [src]: [O.type] [objectvar]: SHUFFLE")
			log_admin("[key_name(src)] modified [original_name]'s [objectvar]: SHUFFLE")
			message_admins("[key_name_admin(src)] 打乱了 [original_name] 的列表 [objectvar] 的顺序")
			return

		index = names[variable]


	var/assoc_key
	if (index == null)
		return
	var/assoc = 0
	var/prompt = alert(src, "要编辑键，还是它关联的值？", "关联列表", "键", "关联值", "取消")
	if (prompt == "取消")
		return
	if (prompt == "关联值")
		assoc = 1
		assoc_key = L[index]
	var/default
	var/variable
	var/old_assoc_value		//EXPERIMENTAL - Keep old associated value while modifying key, if any
	if(is_normal_list)
		if (assoc)
			variable = L[assoc_key]
		else
			variable = L[index]
			//EXPERIMENTAL - Keep old associated value while modifying key, if any
			if(IS_VALID_ASSOC_KEY(variable))
				var/found = L[variable]
				if(!isnull(found))
					old_assoc_value = found
			//

	default = vv_get_class(objectvar, variable)

	to_chat(src, "变量类型似乎为 <b>[uppertext(default)]</b>。")

	to_chat(src, "变量内容：[variable]")

	if(default == VV_NUM)
		var/dir_text = ""
		var/tdir = variable
		if(tdir > 0 && tdir < 16)
			if(tdir & 1)
				dir_text += "北"
			if(tdir & 2)
				dir_text += "南"
			if(tdir & 4)
				dir_text += "东"
			if(tdir & 8)
				dir_text += "西"

		if(dir_text)
			to_chat(usr, "若该变量表示方向，则为：[dir_text]")

	var/original_var = variable

	if (O)
		L = L.Copy()
	var/class
	if(autodetect_class)
		if (default == VV_TEXT)
			default = VV_MESSAGE
		class = default
	var/list/LL = vv_get_value(default_class = default, current_value = original_var, restricted_classes = list(VV_RESTORE_DEFAULT), extra_classes = list(VV_LIST, "从列表删除"))
	class = LL["class"]
	if (!class)
		return
	var/new_var = LL["value"]

	if(class == VV_MESSAGE)
		class = VV_TEXT

	switch(class) //Spits a runtime error if you try to modify an entry in the contents list. Dunno how to fix it, yet.
		if(VV_LIST)
			mod_list(variable, O, original_name, objectvar)

		if("从列表删除")
			L.Cut(index, index+1)
			if (O)
				if (O.vv_edit_var(objectvar, L))
					to_chat(src, "对象拒绝了此次修改。")
					return
			log_world("### ListVarEdit by [src]: [O.type] [objectvar]: REMOVED=[html_encode("[original_var]")]")
			log_admin("[key_name(src)] modified [original_name]'s [objectvar]: REMOVED=[original_var]")
			message_admins("[key_name_admin(src)] 修改了 [original_name] 的 [objectvar]：移除=[original_var]")
			return

		if(VV_TEXT)
			var/list/varsvars = vv_parse_text(O, new_var)
			for(var/V in varsvars)
				new_var = replacetext(new_var,"\[[V]]","[O.vars[V]]")


	if(is_normal_list)
		if(assoc)
			L[assoc_key] = new_var
		else
			L[index] = new_var
			if(!isnull(old_assoc_value) && IS_VALID_ASSOC_KEY(new_var))
				L[new_var] = old_assoc_value
	if (O)
		if (O.vv_edit_var(objectvar, L) == FALSE)
			to_chat(src, "对象拒绝了此次修改。")
			return
	log_world("### ListVarEdit by [src]: [(O ? O.type : "/list")] [objectvar]: [original_var]=[new_var]")
	log_admin("[key_name(src)] modified [original_name]'s [objectvar]: [original_var]=[new_var]")
	message_admins("[key_name_admin(src)] 修改了 [original_name] 的变量列表 [objectvar]：[original_var]=[new_var]")

/proc/vv_varname_lockcheck(param_var_name)
	if(param_var_name in GLOB.VVlocked)
		if(!check_rights(R_DEBUG))
			return FALSE
	if(param_var_name in GLOB.VVckey_edit)
		if(!check_rights(R_SPAWN|R_DEBUG))
			return FALSE
	if(param_var_name in GLOB.VVicon_edit_lock)
		if(!check_rights(R_FUN|R_DEBUG))
			return FALSE
	return TRUE

/client/proc/modify_variables(atom/O, param_var_name = null, autodetect_class = 0)
	if(!check_rights(R_VAREDIT))
		return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!(param_var_name in O.vars))
			to_chat(src, "此数据对象（[O]）中不存在名为 [param_var_name] 的变量")
			return
		variable = param_var_name

	else
		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = input("选择变量：","变量") as null|anything in names
		if(!variable)
			return

	if(!O.can_vv_get(variable))
		return

	var_value = O.vars[variable]
	if(!vv_varname_lockcheck(variable))
		return

	var/default = vv_get_class(variable, var_value)

	if(isnull(default))
		to_chat(src, "无法判断变量类型。")
	else
		to_chat(src, "变量类型似乎为 <b>[uppertext(default)]</b>。")

	to_chat(src, "变量内容：[var_value]")

	if(default == VV_NUM)
		var/dir_text = ""
		if(var_value > 0 && var_value < 16)
			if(var_value & 1)
				dir_text += "北"
			if(var_value & 2)
				dir_text += "南"
			if(var_value & 4)
				dir_text += "东"
			if(var_value & 8)
				dir_text += "西"

		if(dir_text)
			to_chat(src, "若该变量表示方向，则为：[dir_text]")

	if(autodetect_class && default != VV_NULL)
		if (default == VV_TEXT)
			default = VV_MESSAGE
		class = default

	var/list/value = vv_get_value(class, default, var_value, extra_classes = list(VV_LIST), var_name = variable)
	class = value["class"]

	if (!class)
		return
	var/var_new = value["value"]

	if(class == VV_MESSAGE)
		class = VV_TEXT

	var/original_name = "[O]"

	switch(class)
		if(VV_LIST)
			if(!islist(var_value))
				mod_list(list(), O, original_name, variable)

			mod_list(var_value, O, original_name, variable)
			return

		if(VV_RESTORE_DEFAULT)
			var_new = initial(O.vars[variable])

		if(VV_TEXT)
			var/list/varsvars = vv_parse_text(O, var_new)
			for(var/V in varsvars)
				var_new = replacetext(var_new,"\[[V]]","[O.vars[V]]")


	if (O.vv_edit_var(variable, var_new) == FALSE)
		to_chat(src, "对象拒绝了此次修改。")
		return
	vv_update_display(O, "varedited", VV_MSG_EDITED)
	log_world("### VarEdit by [key_name(src)]: [O.type] [variable]=[var_value] => [var_new]")
	log_admin("[key_name(src)] modified [original_name]'s [variable] from [html_encode("[var_value]")] to [html_encode("[var_new]")]")
	var/msg = "[key_name_admin(src)] 将 [original_name] 的 [variable] 从 [var_value] 改为 [var_new]"
	message_admins(msg)
	admin_ticket_log(O, msg)
	return TRUE
