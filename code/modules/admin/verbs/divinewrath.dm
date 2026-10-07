/client/proc/divine_wrath(mob/M in GLOB.mob_list)
	if(!holder || !check_rights(R_FUN))
		return

	var/mob/living/target = M

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

	if(!isliving(target))
		to_chat(usr, "此操作仅适用于 /mob/living 类型的实例。")
		return

	var/target_name = input("谁将接受神罚？", "目标姓名") as text|null
	if (!target_name)
		return

	var/curse_pick = input("选择要施加或解除的诅咒。", "选择诅咒") as null|anything in curse_choices
	if (!curse_pick)
		return

	var/curse_type = curse_choices[curse_pick]

	for (var/mob/living/carbon/human/H in GLOB.player_list)
		if (H.real_name == target_name)
			var/datum/curse/temp = new curse_type()

			if (H.is_cursed(temp))
				H.remove_curse(temp)
				priority_announce("诸神解除了 [H.real_name] 身上的[curse_pick]！", title = "DIVINE MERCY", sound = 'sound/misc/bell.ogg')
				message_admins("管理神罚：([ckey]) 解除了 [H.real_name] 身上的[curse_pick] ") //[ADMIN_LOOKUPFLW(user)] Maybe add this here if desirable but dunno.
				log_game("ADMIN DIVINE WRATH: ([ckey]) has lifted [curse_pick] from [H.real_name])")
			else
				if (length(H.curses) >= 1)
					to_chat(src, span_syndradio("[H.real_name] 已受另一种诅咒影响。"))
					message_admins("管理神罚：([ckey]) 试图对 [H.real_name]（[H.ckey]）施加[curse_pick]")
					log_game("ADMIN DIVINE WRATH: ([ckey]) has attempted to strike [H.real_name] ([H.ckey] with [curse_pick])")					
					return

				H.add_curse(curse_type)
				priority_announce("诸神向 [H.real_name] 降下了[curse_pick]！", title = "DIVINE PUNISHMENT", sound = 'sound/misc/excomm.ogg')
				message_admins("管理神罚：([ckey]) 对 [H.real_name]（[H.ckey]）施加了[curse_pick]")
				log_game("ADMIN DIVINE WRATH: ([ckey]) has stricken [H.real_name] ([H.ckey] with [curse_pick])")
