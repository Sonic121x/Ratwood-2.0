#define PRINTER_COOLDOWN (60 SECONDS)
#define PRINTING_TIME (25 SECONDS)

/obj/machinery/printingpress
	name = "印刷机"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "Ppress_Clean"
	desc = "档案官的奇思妙想。齿轮、油墨与木版，能把写下的文字化为印出的文字。"
	density = TRUE
	var/printing = FALSE
	/// Blank paper for printing books, or a blank canvas for printing paintings.
	var/obj/item/loaded_medium
	var/obj/item/output_item
	/// Which archive each user has open in the archive UI, PLAYER_ARCHIVE_BOOKS or PLAYER_ARCHIVE_PAINTINGS, keyed by REF(user).
	var/list/archive_browsers = list()

	var/static/list/manual_name_to_path = list()
	COOLDOWN_DECLARE(print_cooldown)

/obj/machinery/printingpress/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if(AM == loaded_medium)
		loaded_medium = null
	if(AM == output_item)
		output_item = null
	if(!QDELETED(src))
		update_icon()

/obj/machinery/printingpress/update_icon_state()
	. = ..()
	if(printing)
		icon_state = "Ppress_Printing"
	else if(output_item)
		icon_state = "Ppress_Done"
	else if(loaded_medium)
		icon_state = "Ppress_Prepared"
	else
		icon_state = "Ppress_Clean"

/obj/machinery/printingpress/examine(mob/user)
	. = ..()
	. += span_info("放入空白纸张或空白画布，然后右键选择要印的内容。用空手取回已装入的材料或印好的成品。将成品玩家书籍或署名画布放上去即可归档。")
	if(printing)
		. += span_info("它目前正在印刷。")
	else
		if(output_item)
			. += span_info("它已印好 [output_item]，用空手即可取回。")
		else if(loaded_medium)
			. += span_info("它已装入一张空白[loaded_medium.name]。")
		else
			. += span_info("它空空如也，没有装入任何东西。")
		if(!COOLDOWN_FINISHED(src, print_cooldown))
			. += span_info("它目前正在重新校准，尚不能印刷。")

/obj/machinery/printingpress/attackby(obj/item/O, mob/user, params)
	if(printing)
		to_chat(user, span_warning("[src] 目前正在印刷。请稍候。"))
		return
	if(output_item)
		to_chat(user, span_warning("请先取走印好的物品，再放入新的物品。"))
		return
	if(istype(O, /obj/item/canvas))
		var/obj/item/canvas/M = O
		if(M.is_blank())
			load_medium(M, user)
			return
		if(M.archived)
			to_chat(user, span_warning("只有新画好的画布才能加入档案。"))
			return
		if(!M.author || !M.title)
			to_chat(user, span_warning("这幅画布尚未署名。"))
			return
		var/choice = tgui_alert(user, "要把这幅画加入档案吗？", "确认", list("是", "否"))
		if(choice == "是")
			if(QDELETED(M) || !user.canUseTopic(src, BE_CLOSE) || !user.Adjacent(M))
				return
			M.upload_painting(user)
		else
			to_chat(user, span_notice("你决定不上传这幅画。"))
		return

	if(istype(O, /obj/item/manuscript))
		to_chat(user, span_warning("请先用书籍制作工具完成这份手稿并给它起名，再上传。"))
		return

	if(istype(O, /obj/item/book/rogue/playerbook))
		var/obj/item/book/rogue/playerbook/PB = O
		if(!PB.written)
			to_chat(user, span_warning("这本书尚未撰写与命名。你需要先完成这些才能上传。"))
			return
		// Copies printed or shelved from the archive must not restore books an admin has removed.
		if(!PB.is_in_round_player_generated)
			to_chat(user, span_warning("只有新装订的书籍才能加入档案。"))
			return
		var/choice = tgui_alert(user, "要把这本书加入档案吗？", "确认", list("是", "否"))
		if(choice == "是")
			if(QDELETED(PB) || !user.canUseTopic(src, BE_CLOSE) || !user.Adjacent(PB))
				return
			if(SSlibrarian.playerbook2file(PB, user))
				PB.is_in_round_player_generated = FALSE
		else
			to_chat(user, span_notice("你决定不上传这本书。"))
		return
	if(O.type == /obj/item/paper)
		var/obj/item/paper/paper = O
		if(paper.info)
			to_chat(user, span_warning("纸张必须是空白的，才能放进 [src]。"))
			return
		load_medium(paper, user)
		return
	return ..()

/obj/machinery/printingpress/proc/load_medium(obj/item/medium, mob/user)
	if(loaded_medium)
		to_chat(user, span_warning("它已经装入了 [loaded_medium]。"))
		return
	if(!user.transferItemToLoc(medium, src))
		to_chat(user, span_warning("你无法把 [medium] 放进 [src]。"))
		return
	loaded_medium = medium
	update_icon()
	to_chat(user, span_notice("你把空白[medium.name]放进了 [src]。"))

/obj/machinery/printingpress/attack_hand(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(printing)
		to_chat(user, span_warning("[src] 目前正在印刷。请稍候。"))
		return
	if(output_item)
		// Exited() clears output_item once it leaves, so keep a local reference.
		var/obj/item/printed = output_item
		if(!user.put_in_hands(printed))
			printed.forceMove(get_turf(user))
		to_chat(user, span_notice("你从 [src] 取回了 [printed]。"))
		return
	if(loaded_medium)
		var/obj/item/medium = loaded_medium
		if(!user.put_in_hands(medium))
			medium.forceMove(get_turf(user))
		to_chat(user, span_notice("你从 [src] 取回了 [medium]。"))
		return
	to_chat(user, span_warning("[src] 是空的。"))

/obj/machinery/printingpress/attack_right(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(printing)
		to_chat(user, span_warning("[src] 目前正在印刷。请稍候。"))
		return
	if(output_item)
		to_chat(user, span_warning("[src] 里有一件成品。用空手取回。"))
		return
	var/choice = input(user, "为 [src] 选择一个选项") as null|anything in list("印制《十神的诗篇与行迹》", "印制《正义之书》", "从档案印制书籍", "从档案印制画作", "职业手册")
	switch(choice)
		if("印制《十神的诗篇与行迹》")
			start_printing(user, /obj/item/book/rogue/bibble)
		if("印制《正义之书》")
			start_printing(user, /obj/item/book/rogue/law)
		if("从档案印制书籍")
			open_archive(user, PLAYER_ARCHIVE_BOOKS)
		if("从档案印制画作")
			open_archive(user, PLAYER_ARCHIVE_PAINTINGS)
		if("职业手册")
			if(!length(manual_name_to_path))
				for(var/obj/item/recipe_book/book as anything in subtypesof(/obj/item/recipe_book))
					if(!initial(book.can_spawn))
						continue
					manual_name_to_path[initial(book.name)] = book
			choice = input(user, "为 [src] 选择一个选项") as null|anything in manual_name_to_path
			if(choice)
				start_printing(user, manual_name_to_path[choice])

/// Returns the blank material needed to print the given type, or null if the type cannot be printed.
/obj/machinery/printingpress/proc/get_print_medium(print_type)
	if(print_type == PLAYER_ARCHIVE_PAINTINGS)
		return /obj/item/canvas
	if(print_type == PLAYER_ARCHIVE_BOOKS || print_type == /obj/item/book/rogue/bibble || print_type == /obj/item/book/rogue/law || ispath(print_type, /obj/item/recipe_book))
		return /obj/item/paper

/// Returns TRUE if the press is ready to print the given type.
/obj/machinery/printingpress/proc/can_print(mob/user, print_type)
	if(!user || !user.canUseTopic(src, BE_CLOSE))
		return FALSE
	if(printing)
		to_chat(user, span_warning("[src] 目前正在印刷。请稍候。"))
		return FALSE
	if(output_item)
		to_chat(user, span_warning("请先取走印好的成品，再印下一份。"))
		return FALSE
	var/medium_type = get_print_medium(print_type)
	if(!medium_type)
		to_chat(user, span_warning("那无法印刷。"))
		return FALSE
	if(!istype(loaded_medium, medium_type))
		to_chat(user, span_warning("[src] 需要[medium_type == /obj/item/canvas ? "一张空白画布" : "一张空白纸"]才能印制那个。"))
		return FALSE
	if(!COOLDOWN_FINISHED(src, print_cooldown))
		to_chat(user, span_warning("[src] 仍在重新校准。"))
		return FALSE
	return TRUE

/// Returns TRUE if printing started.
/obj/machinery/printingpress/proc/start_printing(mob/user, print_type, id = null)
	if(!can_print(user, print_type))
		return FALSE
	// Load the archive entry before waiting, so deletion during printing cannot produce a damaged print.
	switch(print_type)
		if(PLAYER_ARCHIVE_BOOKS)
			if(!SSlibrarian.archive.is_usable(id))
				to_chat(user, span_warning("这本书已不在档案中。"))
				return FALSE
			output_item = new /obj/item/book/rogue/playerbook(src, FALSE, null, null, id)
		if(PLAYER_ARCHIVE_PAINTINGS)
			var/obj/item/canvas/print = new /obj/item/canvas(src)
			if(!print.load_archived_painting(id))
				qdel(print)
				to_chat(user, span_warning("这幅画已无法印制。"))
				return FALSE
			output_item = print
		else
			output_item = new print_type(src)
	output_item.desc = output_item.desc ? "[output_item.desc]<br>这是一份印刷副本。" : "这是一份印刷副本。"
	printing = TRUE
	to_chat(user, span_notice("[src] 开始印刷……"))
	playsound(src, 'sound/misc/ppress.ogg', 100, FALSE)
	qdel(loaded_medium)
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(finish_printing)), PRINTING_TIME)
	return TRUE

/obj/machinery/printingpress/proc/finish_printing()
	printing = FALSE
	COOLDOWN_START(src, print_cooldown, PRINTER_COOLDOWN)
	update_icon()
	if(!output_item)
		return
	visible_message(span_notice("[src] 发出嗡鸣，产出了 [output_item]。"))
	if(!istype(output_item, /obj/item/canvas))
		record_round_statistic(STATS_BOOKS_PRINTED)

/// Opens the archive UI listing the books or paintings that can be printed.
/obj/machinery/printingpress/proc/open_archive(mob/user, archive_type)
	if(!can_print(user, archive_type))
		return
	// Reopen rather than update, so switching archives resends the entries and window title.
	var/datum/tgui/existing_ui = SStgui.get_open_ui(user, src)
	existing_ui?.close()
	archive_browsers[REF(user)] = archive_type
	ui_interact(user)

/obj/machinery/printingpress/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		var/datum/player_archive/archive = get_player_archive(archive_browsers[REF(user)])
		ui = new(user, src, "PrintingPressArchive", "[get_player_archive_display(archive?.entry_noun)]档案")
		ui.open()

/obj/machinery/printingpress/ui_close(mob/user)
	. = ..()
	archive_browsers -= REF(user)

/obj/machinery/printingpress/ui_static_data(mob/user)
	var/list/data = ..()
	var/datum/player_archive/archive = get_player_archive(archive_browsers[REF(user)])
	data["archive_type"] = archive?.entry_noun
	data["entries"] = archive ? archive.get_ui_entries() : list()
	return data

/obj/machinery/printingpress/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(action != "print")
		return
	if(start_printing(ui.user, archive_browsers[REF(ui.user)], params["filename"]))
		ui.close()
	return TRUE

#undef PRINTER_COOLDOWN
#undef PRINTING_TIME
