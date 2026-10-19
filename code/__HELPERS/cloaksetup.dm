/mob/proc/cloak_and_title_setup()
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(cloak_and_title_setup)), 50)
		return
	var/list/allowed_cloaks
	var/name_index
	switch(src.mind.assigned_role)
		if("Knight")
			name_index = "骑士的"
			allowed_cloaks = list(
			"朱蓬" = 			/obj/item/clothing/cloak/stabard/surcoat/guard,
			"骑士罩袍" = 	/obj/item/clothing/cloak/tabard/retinue,
			"短罩袍" = 	/obj/item/clothing/cloak/stabard/guard,
			"披风" = 			/obj/item/clothing/cloak/cape/guard,
			"守卫兜帽" = 		/obj/item/clothing/cloak/stabard/guardhood)
		if("Squire")
			name_index = "侍从的"
			allowed_cloaks = list(
			"朱蓬" = 			/obj/item/clothing/cloak/stabard/surcoat/guard,
			"披风" = 			/obj/item/clothing/cloak/cape/guard,
			"长罩袍" =		/obj/item/clothing/cloak/tabard/retinue,
			"短罩袍" = 	/obj/item/clothing/cloak/stabard/guard,
			"守卫兜帽" = 		/obj/item/clothing/cloak/stabard/guardhood)
		if("Man at Arms")
			name_index = "府卫的"
			allowed_cloaks = list(
			"朱蓬" = 			/obj/item/clothing/cloak/stabard/surcoat/guard,
			"罩袍" = 			/obj/item/clothing/cloak/stabard/guard,
			"守卫兜帽" = 		/obj/item/clothing/cloak/stabard/guardhood
			)
		if("Sergeant")
			name_index = "军士的"
			allowed_cloaks = list(
			"朱蓬" = 			/obj/item/clothing/cloak/stabard/surcoat/guard,
			"罩袍" = 			/obj/item/clothing/cloak/stabard/guard,
			"披风" = 			/obj/item/clothing/cloak/cape/guard,
			"守卫兜帽" = 		/obj/item/clothing/cloak/stabard/guardhood
			)

	var/choive_key = input(src, "选择你的披风", "确认身份") as anything in allowed_cloaks
	var/typepath = allowed_cloaks[choive_key]
	var/obj/item/clothing/cloak/cloak_choice = new typepath(src)
	var/list/namesplit = splittext(src.real_name, " ")
	if(src.mind.assigned_role == "Knight")
		cloak_choice.name = "[name_index] [cloak_choice.name] ([namesplit[2]])"
	else
		cloak_choice.name = "[name_index] [cloak_choice.name] ([namesplit[1]])"
	src.equip_to_slot_or_del(cloak_choice, SLOT_CLOAK)
