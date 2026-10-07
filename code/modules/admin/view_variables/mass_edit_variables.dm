/client/proc/cmd_mass_modify_object_variables(atom/A, var_name)
	set category = "调试"
	set name = "批量编辑变量"
	set desc="（目标）编辑目标物品所有实例的变量"

	var/method = 0	//0 means strict type detection while 1 means this type and all subtypes (IE: /obj/item with this set to 1 will set it to ALL items)

	if(!check_rights(R_VAREDIT))
		return

	if(A && A.type)
		method = vv_subtype_prompt(A.type)

	src.massmodify_variables(A, var_name, method)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Mass Edit Variables") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/massmodify_variables(datum/O, var_name = "", method = 0)
	if(!check_rights(R_VAREDIT))
		return
	if(!istype(O))
		return

	var/variable = ""
	if(!var_name)
		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = input("选择哪个变量？", "变量") as null|anything in names
	else
		variable = var_name

	if(!variable || !O.can_vv_get(variable))
		return
	var/default
	var/var_value = O.vars[variable]

	if(variable in GLOB.VVckey_edit)
		to_chat(src, "禁止批量修改 ckey，这会导致所有人的客户端崩溃。")
		return
	if(variable in GLOB.VVlocked)
		if(!check_rights(R_DEBUG))
			return
	if(variable in GLOB.VVicon_edit_lock)
		if(!check_rights(R_FUN|R_DEBUG))
			return
	if(variable in GLOB.VVpixelmovement)
		if(!check_rights(R_DEBUG))
			return
		var/prompt = alert(src, "编辑此变量可能导致本回合的格间平滑移动永久失效。此操作无法撤回", "危险", "中止 ", "继续", " 中止")
		if (prompt != "继续")
			return

	default = vv_get_class(variable, var_value)

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

	var/value = vv_get_value(default_class = default)
	var/new_value = value["value"]
	var/class = value["class"]

	if(!class || !new_value == null && class != VV_NULL)
		return

	if (class == VV_MESSAGE)
		class = VV_TEXT

	if (value["type"])
		class = VV_NEW_TYPE

	var/original_name = "[O]"

	var/rejected = 0
	var/accepted = 0

	switch(class)
		if(VV_RESTORE_DEFAULT)
			to_chat(src, "正在查找对象……")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "正在修改 [items.len] 个对象……")
			for(var/thing in items)
				if (!thing)
					continue
				var/datum/D = thing
				if (D.vv_edit_var(variable, initial(D.vars[variable])) != FALSE)
					accepted++
				else
					rejected++
				CHECK_TICK

		if(VV_TEXT)
			var/list/varsvars = vv_parse_text(O, new_value)
			var/pre_processing = new_value
			var/unique
			if (varsvars && varsvars.len)
				unique = alert(usr, "为每个实例分别处理变量，还是全部使用相同值？", "变量关联", "分别处理", "使用相同值")
				if(unique == "分别处理")
					unique = TRUE
				else
					unique = FALSE
					for(var/V in varsvars)
						new_value = replacetext(new_value,"\[[V]]","[O.vars[V]]")

			to_chat(src, "正在查找对象……")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "正在修改 [items.len] 个对象……")
			for(var/thing in items)
				if (!thing)
					continue
				var/datum/D = thing
				if(unique)
					new_value = pre_processing
					for(var/V in varsvars)
						new_value = replacetext(new_value,"\[[V]]","[D.vars[V]]")

				if (D.vv_edit_var(variable, new_value) != FALSE)
					accepted++
				else
					rejected++
				CHECK_TICK

		if (VV_NEW_TYPE)
			var/many = alert(src, "只创建一个 [value["type"]] 供所有对象共用，还是为每个对象分别创建？", "创建数量", "共用一个", "分别创建", "取消")
			if (many == "取消")
				return
			if (many == "分别创建")
				many = TRUE
			else
				many = FALSE

			var/type = value["type"]
			to_chat(src, "正在查找对象……")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "正在修改 [items.len] 个对象……")
			for(var/thing in items)
				if (!thing)
					continue
				var/datum/D = thing
				if(many && !new_value)
					new_value = new type()

				if (D.vv_edit_var(variable, new_value) != FALSE)
					accepted++
				else
					rejected++
				new_value = null
				CHECK_TICK

		else
			to_chat(src, "正在查找对象……")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "正在修改 [items.len] 个对象……")
			for(var/thing in items)
				if (!thing)
					continue
				var/datum/D = thing
				if (D.vv_edit_var(variable, new_value) != FALSE)
					accepted++
				else
					rejected++
				CHECK_TICK


	var/count = rejected+accepted
	if (!count)
		to_chat(src, "未找到对象")
		return
	if (!accepted)
		to_chat(src, "所有对象都拒绝了此次修改")
		return
	if (rejected)
		to_chat(src, "[count] 个对象中有 [rejected] 个拒绝了此次修改")

	log_world("### MassVarEdit by [src]: [O.type] (A/R [accepted]/[rejected]) [variable]=[html_encode("[O.vars[variable]]")]([list2params(value)])")
	log_admin("[key_name(src)] mass modified [original_name]'s [variable] to [O.vars[variable]] ([accepted] objects modified)")
	message_admins("[key_name_admin(src)] 将 [original_name] 的 [variable] 批量改为 [O.vars[variable]]（修改了 [accepted] 个对象）")

//not using global lists as vv is a debug function and debug functions should rely on as less things as possible.
/proc/get_all_of_type(T, subtypes = TRUE)
	var/list/typecache = list()
	typecache[T] = 1
	if (subtypes)
		typecache = typecacheof(typecache)
	. = list()
	if (ispath(T, /mob))
		for(var/mob/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /obj/machinery))
		for(var/obj/machinery/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /obj/item))
		for(var/obj/item/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /obj))
		for(var/obj/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /atom/movable))
		for(var/atom/movable/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /turf))
		for(var/turf/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /atom))
		for(var/atom/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /client))
		for(var/client/thing in GLOB.clients)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /datum))
		for(var/datum/thing)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else
		for(var/datum/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK
