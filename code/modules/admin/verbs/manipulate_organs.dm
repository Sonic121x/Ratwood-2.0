/client/proc/manipulate_organs(mob/living/carbon/C in world)
	set name = "操作器官"
	set category = "调试"
	var/operation = input("选择器官操作。", "器官操作", "取消") as null|anything in list("添加器官", "取出器官", "移除器官", "取消")
	if (!operation)
		return

	var/list/organs = list()
	switch(operation)
		if("添加器官")
			for(var/path in subtypesof(/obj/item/organ))
				var/dat = replacetext("[path]", "/obj/item/organ/", ":")
				organs[dat] = path

			var/obj/item/organ/organ = input("选择器官类型：", "器官操作", null) as null|anything in organs
			if(!organ)
				return
			organ = organs[organ]
			organ = new organ
			organ.Insert(C)
			log_admin("[key_name(usr)] has added organ [organ.type] to [key_name(C)]")
			message_admins("[key_name_admin(usr)] 为 [ADMIN_LOOKUPFLW(C)] 添加了器官 [organ.type]")

		if("取出器官", "移除器官")
			for(var/X in C.internal_organs)
				var/obj/item/organ/I = X
				organs["[I.name] ([I.type])"] = I

			var/obj/item/organ = input("选择器官／植入物：", "器官操作", null) as null|anything in organs
			if(!organ)
				return
			organ = organs[organ]
			if(!organ)
				return
			var/obj/item/organ/O

			log_admin("[key_name(usr)] has removed [organ.type] from [key_name(C)]")
			message_admins("[key_name_admin(usr)] 从 [ADMIN_LOOKUPFLW(C)] 身上取出了 [organ.type]")

			if(isorgan(organ))
				O = organ
				O.Remove(C)

			organ.forceMove(get_turf(C))

			if(operation == "remove organ/implant")
				qdel(organ)
