//Not using datum.vv_do_topic for very basic/low level debug things, incase the datum's vv_do_topic is runtiming/whatnot.
/client/proc/vv_do_basic(datum/target, href_list)
	var/target_var = GET_VV_VAR_TARGET
	if(check_rights(R_VAREDIT))
		if(target_var)
			if(href_list[VV_HK_BASIC_EDIT])
				if(!modify_variables(target, target_var, 1))
					return
				switch(target_var)
					if("name")
						vv_update_display(target, "name", "[target]")
					if("dir")
						var/atom/A = target
						if(istype(A))
							vv_update_display(target, "dir", dir2text(A.dir) || A.dir)
					if("ckey")
						var/mob/living/L = target
						if(istype(L))
							vv_update_display(target, "ckey", L.ckey || "无 ckey")
					if("real_name")
						var/mob/living/L = target
						if(istype(L))
							vv_update_display(target, "real_name", L.real_name || "无真实姓名")
			if(href_list[VV_HK_BASIC_CHANGE])
				modify_variables(target, target_var, 0)
			if(href_list[VV_HK_BASIC_MASSEDIT])
				cmd_mass_modify_object_variables(target, target_var)
	if(check_rights(R_ADMIN, FALSE))
		if(href_list[VV_HK_EXPOSE])
			var/value = vv_get_value(VV_CLIENT)
			if (value["class"] != VV_CLIENT)
				return
			var/client/C = value["value"]
			if (!C)
				return
			if(!target)
				to_chat(usr, span_warning("要向 [C] 展示的对象已不存在（已置空或强制删除）"))
				return
			message_admins("[key_name_admin(usr)] 向 [key_name_admin(C)] 展示了一个<a href='?_src_=vars;datumrefresh=[REF(target)]'>变量查看窗口</a>")
			log_admin("Admin [key_name(usr)] Showed [key_name(C)] a VV window of a [target]")
			to_chat(C, "[holder.fakekey ? "管理员" : "[usr.client.key]"]已授予你查看变量窗口的权限")
			C.debug_variables(target)
	if(check_rights(R_DEBUG))
		if(href_list[VV_HK_DELETE])
			usr.client.admin_delete(target)
			if (isturf(src))	// show the turf that took its place
				usr.client.debug_variables(src)
	if(href_list[VV_HK_MARK])
		usr.client.mark_datum(target)
	if(href_list[VV_HK_ADDCOMPONENT])
		if(!check_rights(NONE))
			return
		var/list/names = list()
		var/list/componentsubtypes = sortList(subtypesof(/datum/component), GLOBAL_PROC_REF(cmp_typepaths_asc))
		names += "---组件---"
		names += componentsubtypes
		names += "---元素---"
		names += sortList(subtypesof(/datum/element), GLOBAL_PROC_REF(cmp_typepaths_asc))
		var/result = input(usr, "选择要添加的组件或元素","请确保你了解此操作的影响") as null|anything in names
		if(!usr || !result || result == "---组件---" || result == "---元素---")
			return
		if(QDELETED(src))
			to_chat(usr, "该对象已不存在！")
			return
		var/list/lst = get_callproc_args()
		if(!lst)
			return
		var/datumname = "error"
		lst.Insert(1, result)
		if(result in componentsubtypes)
			datumname = "component"
			target._AddComponent(arglist(lst))
		else
			datumname = "element"
			target._AddElement(arglist(lst))
		log_admin("[key_name(usr)] has added [result] [datumname] to [key_name(src)].")
		message_admins(span_notice("[key_name_admin(usr)] 向 [key_name_admin(src)] 添加了[datumname == "component" ? "组件" : "元素"] [result]。"))
	if(href_list[VV_HK_CALLPROC])
		usr.client.callproc_datum(target)
