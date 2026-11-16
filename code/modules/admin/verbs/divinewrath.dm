/client/proc/divine_wrath(mob/living/carbon/human/H)
	if(!holder || !check_rights(R_FUN))
		return

	if(!ishuman(H))
		to_chat(usr, span_warning("目标必须是人形生物！"))
		return

	var/list/curse_choices = list(
		"阿斯特拉塔的诅咒" = /datum/curse/astrata,
		"诺克的诅咒" = /datum/curse/noc,
		"登多尔的诅咒" = /datum/curse/dendor,
		"阿比索尔的诅咒" = /datum/curse/abyssor,
		"拉沃克斯的诅咒" = /datum/curse/ravox,
		"内克拉的诅咒" = /datum/curse/necra,
		"赛利克斯的诅咒" = /datum/curse/xylix,
		"佩斯特拉的诅咒" = /datum/curse/pestra,
		"玛勒姆的诅咒" = /datum/curse/malum,
		"伊欧拉的诅咒" = /datum/curse/eora,
		"齐佐的诅咒" = /datum/curse/zizo,
		"格拉加尔的诅咒" = /datum/curse/graggar,
		"马西奥斯的诅咒" = /datum/curse/matthios,
		"巴奥莎的诅咒" = /datum/curse/baotha,
		)

	var/curse_pick = tgui_input_list(usr, "选择要施加或解除的诅咒。", "选择诅咒", curse_choices)
	if(!curse_pick || QDELETED(H))
		return

	var/curse_type = curse_choices[curse_pick]

	if(H.is_cursed(curse_type))
		H.remove_curse(curse_type)
		priority_announce("诸神解除了 [H.real_name] 身上的[curse_pick]！", title = "神之慈悲", sound = 'sound/misc/bell.ogg')
		message_admins("管理员神罚：([ckey]) 解除了 [H.real_name] ([H.ckey]) 身上的[curse_pick]")
		log_game("管理员神罚：([ckey]) 解除了 [H.real_name] ([H.ckey]) 身上的[curse_pick]")
		return

	if(length(H.curses) >= 1)
		to_chat(src, span_syndradio("[H.real_name] 已受另一种诅咒影响。"))
		message_admins("管理员神罚：([ckey]) 尝试向 [H.real_name] ([H.ckey]) 施加[curse_pick]")
		log_game("管理员神罚：([ckey]) 尝试向 [H.real_name] ([H.ckey]) 施加[curse_pick]")
		return

	H.add_curse(curse_type)
	priority_announce("诸神向 [H.real_name] 降下了[curse_pick]！", title = "神罚", sound = 'sound/misc/excomm.ogg')
	message_admins("管理员神罚：([ckey]) 向 [H.real_name] ([H.ckey]) 施加了[curse_pick]")
	log_game("管理员神罚：([ckey]) 向 [H.real_name] ([H.ckey]) 施加了[curse_pick]")
