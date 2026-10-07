/proc/getbrokeninhands()
	var/text
	for(var/A in typesof(/obj/item))
		var/obj/item/O = new A( locate(1,1,1) )
		if(!O)
			continue
		var/icon/IL = new(O.lefthand_file)
		var/list/Lstates = IL.IconStates()
		var/icon/IR = new(O.righthand_file)
		var/list/Rstates = IR.IconStates()
		var/icon/J = new(O.icon)
		var/list/istates = J.IconStates()
		if(!Lstates.Find(O.icon_state) && !Lstates.Find(O.item_state))
			if(O.icon_state)
				text += "[O.type] 缺少名为以下状态的左手图标\n\"[O.icon_state]\"。\n"
		if(!Rstates.Find(O.icon_state) && !Rstates.Find(O.item_state))
			if(O.icon_state)
				text += "[O.type] 缺少名为以下状态的右手图标\n\"[O.icon_state]\"。\n"


		if(O.icon_state)
			if(!istates.Find(O.icon_state))
				text += "[O.type] 缺少普通图标状态\n\"[O.icon_state]\"，图标文件为 \"[O.icon]\"\n"
		if(O.item_state)
			if(!istates.Find(O.item_state))
				text += "[O.type] 缺少普通图标状态\n\"[O.item_state]\"，图标文件为 \"[O.icon]\"\n"
		text+="\n"
		qdel(O)
	if(text)
		var/F = file("broken_icons.txt")
		fdel(F)
		WRITE_FILE(F, text)
		to_chat(world, "已成功完成并写入 [F]")


