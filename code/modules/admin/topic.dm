/datum/admins/proc/CheckAdminHref(href, href_list)
	var/auth = href_list["admin_token"]
	. = auth && (auth == href_token || auth == GLOB.href_token)
	if(.)
		return
	var/msg = !auth ? "no" : "a bad"
	message_admins("[key_name_admin(usr)] 点击了授权密钥[!auth ? "缺失" : "无效"]的链接！")
	if(CONFIG_GET(flag/debug_admin_hrefs))
		message_admins("调试模式已启用，此调用未被阻止。请让开发者检查本回合日志。")
		log_world("UAH: [href]")
		return TRUE
	log_admin_private("[key_name(usr)] clicked an href with [msg] authorization key! [href]")

/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		message_admins("[usr.key] 试图越权使用管理面板！")
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		return

	if(!CheckAdminHref(href, href_list))
		return

	if(href_list["mass_direct"])
		if(mass_direct_handle_topic(href_list))
			return

	// Open Heal Panel from Player Panel
	if(href_list["heal_panel"])
		var/mob/living/M = locate(href_list["heal_panel"])
		if(M)
			show_heal_panel(M)
		return

	// Open Inventory Panel from Player Panel
	if(href_list["inventory_panel"])
		var/mob/living/M = locate(href_list["inventory_panel"])
		if(M)
			show_inventory_panel(M)
		return

	// Heal panel actions
	if(href_list["heal_target"])
		var/mob/living/M = locate(href_list["heal_target"])
		if(M)
			M.fully_heal(admin_revive = TRUE)
			message_admins("[key_name_admin(usr)] 完全治愈了 [key_name_admin(M)]。")
			log_admin("[key_name(usr)] fully healed [key_name(M)].")
			show_heal_panel(M)
		return

	if(href_list["heal_revive"])
		var/mob/living/M = locate(href_list["heal_revive"])
		if(M)
			M.revive(full_heal = FALSE, admin_revive = TRUE)
			message_admins("[key_name_admin(usr)] 复活了 [key_name_admin(M)]。")
			log_admin("[key_name(usr)] revived [key_name(M)].")
			show_heal_panel(M)
		return

	if(href_list["heal_refresh"])
		var/mob/living/M = locate(href_list["heal_refresh"])
		if(M)
			show_heal_panel(M)
		return

	if(href_list["heal_modify_organs"])
		var/mob/living/carbon/M = locate(href_list["heal_modify_organs"])
		if(M)
			usr.client.manipulate_organs(M)
			show_heal_panel(M)
		return

	if(href_list["heal_blood_add100"])
		var/mob/living/M = locate(href_list["heal_blood_add100"])
		if(M && ishuman(M))
			var/mob/living/carbon/human/H = M
			H.set_blood_volume(min(H.get_blood_volume() + 100, BLOOD_VOLUME_MAXIMUM))
			message_admins("[key_name_admin(usr)] 为 [key_name_admin(M)] 增加了 100 血量。")
			log_admin("[key_name(usr)] added 100 blood to [key_name(M)].")
			show_heal_panel(M)
		return

	if(href_list["heal_blood_add50"])
		var/mob/living/M = locate(href_list["heal_blood_add50"])
		if(M && ishuman(M))
			var/mob/living/carbon/human/H = M
			H.set_blood_volume(min(H.get_blood_volume() + 50, BLOOD_VOLUME_MAXIMUM))
			message_admins("[key_name_admin(usr)] 为 [key_name_admin(M)] 增加了 50 血量。")
			log_admin("[key_name(usr)] added 50 blood to [key_name(M)].")
			show_heal_panel(M)
		return

	if(href_list["heal_blood_sub50"])
		var/mob/living/M = locate(href_list["heal_blood_sub50"])
		if(M && ishuman(M))
			var/mob/living/carbon/human/H = M
			H.set_blood_volume(max(H.get_blood_volume() - 50, 0))
			message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 的血量减少了 50。")
			log_admin("[key_name(usr)] removed 50 blood from [key_name(M)].")
			show_heal_panel(M)
		return

	if(href_list["heal_blood_sub100"])
		var/mob/living/M = locate(href_list["heal_blood_sub100"])
		if(M && ishuman(M))
			var/mob/living/carbon/human/H = M
			H.set_blood_volume(max(H.get_blood_volume() - 100, 0))
			message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 的血量减少了 100。")
			log_admin("[key_name(usr)] removed 100 blood from [key_name(M)].")
			show_heal_panel(M)
		return

	if(href_list["heal_blood_set"])
		var/mob/living/M = locate(href_list["heal_blood_set"])
		if(M && ishuman(M))
			var/mob/living/carbon/human/H = M
			var/new_amount = input(usr, "将血量设为：", "血量", H.get_blood_volume()) as num|null
			if(new_amount != null)
				H.set_blood_volume(clamp(new_amount, 0, BLOOD_VOLUME_MAXIMUM))
				message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 的血量设为 [new_amount]。")
				log_admin("[key_name(usr)] set [key_name(M)]'s blood volume to [new_amount].")
				show_heal_panel(M)
		return

	if(href_list["heal_edit_simple"])
		var/mob/living/M = locate(href_list["heal_edit_simple"])
		if(M && !ishuman(M))
			var/damage_type = href_list["damage_type"]
			var/current_value = 0
			if(damage_type == "brute")
				current_value = M.getBruteLoss()
			else if(damage_type == "burn")
				current_value = M.getFireLoss()
			else if(damage_type == "toxin")
				current_value = M.getToxLoss()
			else if(damage_type == "oxy")
				current_value = M.getOxyLoss()

			var/new_value = input(usr, "设置 [damage_type] 伤害：", "修改伤害", current_value) as num|null
			if(new_value != null)
				new_value = max(0, new_value)
				if(damage_type == "brute")
					M.adjustBruteLoss(new_value - current_value)
				else if(damage_type == "burn")
					M.adjustFireLoss(new_value - current_value)
				else if(damage_type == "toxin")
					M.adjustToxLoss(new_value - current_value)
				else if(damage_type == "oxy")
					M.adjustOxyLoss(new_value - current_value)
				message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 的 [damage_type] 伤害设为 [new_value]。")
				log_admin("[key_name(usr)] set [damage_type] damage to [new_value] on [key_name(M)].")
				show_heal_panel(M)
		return

	if(href_list["heal_edit_overall"])
		var/mob/living/M = locate(href_list["heal_edit_overall"])
		if(M && ishuman(M))
			var/mob/living/carbon/human/H = M
			var/damage_type = href_list["damage_type"]
			var/current_value = 0
			if(damage_type == "toxin")
				current_value = H.getToxLoss()
			else if(damage_type == "oxy")
				current_value = H.getOxyLoss()

			var/new_value = input(usr, "设置 [damage_type] 伤害：", "修改伤害", current_value) as num|null
			if(new_value != null)
				new_value = max(0, new_value)
				if(damage_type == "toxin")
					H.setToxLoss(new_value)
				else if(damage_type == "oxy")
					H.setOxyLoss(new_value)
				message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 的 [damage_type] 伤害设为 [new_value]。")
				log_admin("[key_name(usr)] set [damage_type] damage to [new_value] on [key_name(M)].")
				show_heal_panel(M)
		return

	if(href_list["heal_edit_damage"])
		var/mob/living/M = locate(href_list["heal_edit_damage"])
		var/obj/item/bodypart/BP = locate(href_list["bodypart"])
		if(M && BP && ishuman(M))
			var/damage_type = href_list["damage_type"]
			var/current_value = 0
			if(damage_type == "brute")
				current_value = BP.brute_dam
			else if(damage_type == "burn")
				current_value = BP.burn_dam

			var/new_value = input(usr, "设置 [BP.name] 的 [damage_type] 伤害：", "修改伤害", current_value) as num|null
			if(new_value != null)
				new_value = max(0, new_value)
				if(damage_type == "brute")
					BP.brute_dam = new_value
				else if(damage_type == "burn")
					BP.burn_dam = new_value
				BP.update_limb()
				message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 的 [BP.name] 的 [damage_type] 伤害设为 [new_value]。")
				log_admin("[key_name(usr)] set [BP.name] [damage_type] damage to [new_value] on [key_name(M)].")
				show_heal_panel(M)
		return

	if(href_list["heal_fix_bodypart"])
		var/mob/living/M = locate(href_list["heal_fix_bodypart"])
		var/obj/item/bodypart/BP = locate(href_list["bodypart"])
		if(M && BP && ishuman(M))
			BP.brute_dam = 0
			BP.burn_dam = 0
			BP.update_limb()
			message_admins("[key_name_admin(usr)] 治愈了 [key_name_admin(M)] 的 [BP.name]。")
			log_admin("[key_name(usr)] healed [BP.name] on [key_name(M)].")
			show_heal_panel(M)
		return

	if(href_list["heal_add_wound"])
		var/mob/living/M = locate(href_list["heal_add_wound"])
		var/obj/item/bodypart/BP = locate(href_list["bodypart"])
		if(M && BP && ishuman(M))
			var/list/wound_types = list(
				"骨折" = /datum/wound/fracture,
				"割伤" = /datum/wound/slash,
				"刺伤" = /datum/wound/puncture,
				"烧伤" = /datum/wound/burn,
				"挫伤" = /datum/wound/bruise,
				"动脉损伤" = /datum/wound/artery,
				"咬伤" = /datum/wound/bite,
				"脱臼" = /datum/wound/dislocation
			)
			var/wound_choice = input(usr, "选择伤口类型：", "添加伤口") as null|anything in wound_types
			if(wound_choice)
				var/wound_path = wound_types[wound_choice]
				// Apply body-part-specific wound variants
				if(wound_choice == "骨折")
					if(BP.body_zone == BODY_ZONE_HEAD)
						wound_path = /datum/wound/fracture/head
					else if(BP.body_zone == BODY_ZONE_CHEST)
						wound_path = /datum/wound/fracture/chest
				else if(wound_choice == "动脉损伤")
					if(BP.body_zone == BODY_ZONE_HEAD)
						wound_path = /datum/wound/artery/neck
					else if(BP.body_zone == BODY_ZONE_CHEST)
						wound_path = /datum/wound/artery/chest
				else if(wound_choice == "脱臼")
					if(BP.body_zone == BODY_ZONE_HEAD)
						wound_path = /datum/wound/dislocation/neck

				// Check for wound subtypes (like small/large punctures, small/large slashes, etc.)
				var/list/wound_subtypes = list()
				for(var/subtype in subtypesof(wound_path))
					var/datum/wound/W = subtype
					var/wound_name = initial(W.name)
					if(wound_name && wound_name != initial(wound_path:name))
						wound_subtypes[wound_name] = subtype

				// If there are subtypes, let the user choose
				if(wound_subtypes.len > 0)
					var/subtype_choice = input(usr, "选择伤口严重程度：", "伤口等级") as null|anything in wound_subtypes
					if(subtype_choice)
						wound_path = wound_subtypes[subtype_choice]
					else
						show_heal_panel(M)
						return

				BP.add_wound(wound_path)
				var/datum/wound/applied_wound = wound_path
				var/wound_display_name = initial(applied_wound:name)
				message_admins("[key_name_admin(usr)] 在 [key_name_admin(M)] 的 [BP.name] 上添加了 [wound_display_name]。")
				log_admin("[key_name(usr)] added [wound_display_name] wound to [BP.name] on [key_name(M)].")
			show_heal_panel(M)
		return

	if(href_list["heal_remove_bodypart"])
		var/mob/living/M = locate(href_list["heal_remove_bodypart"])
		var/obj/item/bodypart/BP = locate(href_list["bodypart"])
		if(M && BP && ishuman(M))
			// Special case for chest - just gib them
			if(BP.body_zone == BODY_ZONE_CHEST)
				var/confirm = alert(usr, "移除胸部会使 [M.name] 爆体，仅留下胸部以外的身体部位。继续吗？", "使生物爆体", "是", "取消")
				if(confirm == "是")
					message_admins("[key_name_admin(usr)] 通过移除胸部使 [key_name_admin(M)] 爆体。")
					log_admin("[key_name(usr)] gibbed [key_name(M)] by removing the chest.")
					M.gib(no_brain = FALSE, no_organs = FALSE, no_bodyparts = FALSE)
				return
			// Special case for head - properly remove it
			else if(BP.body_zone == BODY_ZONE_HEAD)
				var/removal_type = alert(usr, "如何移除 [BP.name]？", "移除身体部位", "砍断", "安全截肢", "取消")
				if(removal_type == "砍断")
					BP.drop_limb()
					message_admins("[key_name_admin(usr)] 砍断了 [key_name_admin(M)] 的 [BP.name]。")
					log_admin("[key_name(usr)] chopped off [BP.name] from [key_name(M)].")
				else if(removal_type == "安全截肢")
					BP.drop_limb()
					message_admins("[key_name_admin(usr)] 安全截除了 [key_name_admin(M)] 的 [BP.name]。")
					log_admin("[key_name(usr)] safely amputated [BP.name] from [key_name(M)].")
				show_heal_panel(M)
			// All other limbs
			else
				var/removal_type = alert(usr, "如何移除 [BP.name]？", "移除身体部位", "砍断", "安全截肢", "取消")
				if(removal_type == "砍断")
					// Use admin-only dismember that bypasses all armor checks
					BP.admin_dismember()
					message_admins("[key_name_admin(usr)] 砍断了 [key_name_admin(M)] 的 [BP.name]。")
					log_admin("[key_name(usr)] chopped off [BP.name] from [key_name(M)].")
				else if(removal_type == "安全截肢")
					BP.drop_limb()
					message_admins("[key_name_admin(usr)] 安全截除了 [key_name_admin(M)] 的 [BP.name]。")
					log_admin("[key_name(usr)] safely amputated [BP.name] from [key_name(M)].")
				show_heal_panel(M)
		return

	if(href_list["heal_remove_wound"])
		var/mob/living/M = locate(href_list["heal_remove_wound"])
		var/datum/wound/W = locate(href_list["wound"])
		if(M && W && ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(W in BP.wounds)
					BP.remove_wound(W)
					message_admins("[key_name_admin(usr)] 移除了 [key_name_admin(M)] 的伤口 [W.name]。")
					log_admin("[key_name(usr)] removed wound [W.name] from [key_name(M)].")
					break
			show_heal_panel(M)
		return

	if(href_list["heal_action"])
		if(handle_heal_panel_topic(href_list))
			return

	if(href_list["inventory_action"])
		if(handle_inventory_panel_topic(href_list))
			return

	if(href_list["loadout_action"])
		if(usr.client.handle_loadout_action(href_list))
			return

	if(href_list["ahelp"])
		if(!check_rights(R_AHELP, TRUE))
			return

		var/ahelp_ref = href_list["ahelp"]
		var/datum/admin_help/AH = locate(ahelp_ref)
		if(AH)
			AH.Action(href_list["ahelp_action"])
		else
			to_chat(usr, "工单 [ahelp_ref] 已被删除！")

	else if(href_list["ahelp_tickets"])
		if(!check_rights(R_AHELP))
			return
		GLOB.ahelp_tickets.BrowseTickets(text2num(href_list["ahelp_tickets"]))

	else if(href_list["stickyban"])
		stickyban(href_list["stickyban"],href_list)

	else if(href_list["getplaytimewindow"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["getplaytimewindow"]) in GLOB.mob_list
		if(!M)
			to_chat(usr, span_danger("错误：未找到生物。"))
			return
		cmd_show_exp_panel(M.client)

	else if(href_list["toggleexempt"])
		if(!check_rights(R_ADMIN))
			return
		var/client/C = locate(href_list["toggleexempt"]) in GLOB.clients
		if(!C)
			to_chat(usr, span_danger("错误：未找到客户端。"))
			return
		toggle_exempt_status(C)

	else if(href_list["forceevent"])
		if(!check_rights(R_FUN))
			return
		var/datum/round_event_control/E = locate(href_list["forceevent"]) in SSevents.control
		if(E)
			E.admin_setup(usr)
			var/datum/round_event/event = E.runEvent()
			if(event.announceWhen>0)
				event.processing = FALSE
				var/prompt = alert(usr, "是否向玩家发布事件预警？", "预警", "是", "否", "取消")
				switch(prompt)
					if("是")
						event.announceChance = 100
					if("取消")
						event.kill()
						return
					if("否")
						event.announceChance = 0
				event.processing = TRUE
			message_admins("[key_name_admin(usr)] 触发了事件。（[E.name]）")
			log_admin("[key_name(usr)] has triggered an event. ([E.name])")
		return

	else if(href_list["editrightsbrowser"])
		edit_admin_permissions(0)

	else if(href_list["editrightsbrowserlog"])
		edit_admin_permissions(1, href_list["editrightstarget"], href_list["editrightsoperation"], href_list["editrightspage"])

	if(href_list["editrightsbrowsermanage"])
		if(href_list["editrightschange"])
			change_admin_rank(ckey(href_list["editrightschange"]), href_list["editrightschange"], TRUE)
		else if(href_list["editrightsremove"])
			remove_admin(ckey(href_list["editrightsremove"]), href_list["editrightsremove"], TRUE)
		else if(href_list["editrightsremoverank"])
			remove_rank(href_list["editrightsremoverank"])
		edit_admin_permissions(2)

	else if(href_list["editrights"])
		edit_rights_topic(href_list)

	else if(href_list["gamemode_panel"])
		if(!check_rights(R_ADMIN))
			return
		forceGamemode(usr)

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))
			return
		if(!SSticker.delay_end)
			SSticker.admin_delay_notice = input(usr, "请输入推迟回合结束的原因", "推迟回合结束的原因") as null|text
			if(isnull(SSticker.admin_delay_notice))
				return
		else
			if(alert(usr, "确定取消当前的回合结束延迟吗？当前延迟原因为：\"[SSticker.admin_delay_notice]\"", "取消回合结束延迟", "是", "否") != "是")
				return
			SSticker.admin_delay_notice = null
		SSticker.delay_end = !SSticker.delay_end
		var/reason = SSticker.delay_end ? "for reason: [SSticker.admin_delay_notice]" : "."//laziness
		var/msg = "[SSticker.delay_end ? "delayed" : "undelayed"] the round end [reason]"
		log_admin("[key_name(usr)] [msg]")
		message_admins("[key_name_admin(usr)] [SSticker.delay_end ? "推迟了回合结束，原因：[SSticker.admin_delay_notice]" : "取消了回合结束延迟。"]")
		if(SSticker.ready_for_reboot && !SSticker.delay_end) //we undelayed after standard reboot would occur
			SSticker.standard_reboot()

	else if(href_list["end_round"])
		if(!check_rights(R_ADMIN))
			return

		message_admins(span_adminnotice("[key_name_admin(usr)] 正在考虑结束回合。"))
		if(alert(usr, "此操作会结束回合，确定继续吗？", "确认", "是", "否") == "是")
			if(alert(usr, "最后确认：立即结束回合？", "确认", "是", "否") == "是")
				message_admins(span_adminnotice("[key_name_admin(usr)] 结束了回合。"))
				SSticker.force_ending = 1 //Yeah there we go APC destroyed mission accomplished
				return
			else
				message_admins(span_adminnotice("[key_name_admin(usr)] 决定取消结束回合。"))
		else
			message_admins(span_adminnotice("[key_name_admin(usr)] 决定取消结束回合。"))

	else if(href_list["simplemake"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			to_chat(usr, "此操作仅适用于 /mob 类型的实例。")
			return

		var/delmob = TRUE
		if(!isobserver(M))
			switch(alert("删除原生物？","提示","是","否","取消"))
				if("取消")
					return
				if("否")
					delmob = FALSE

		log_admin("[key_name(usr)] has used rudimentary transformation on [key_name(M)]. Transforming to [href_list["simplemake"]].; deletemob=[delmob]")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] 对 [key_name_admin(M)] 使用了基础变形，变为 [href_list["simplemake"]]；删除原生物=[delmob]</span>")
		switch(href_list["simplemake"])
			if("observer")
				M.change_mob_type( /mob/dead/observer , null, null, delmob )
			if("human")
				var/posttransformoutfit = usr.client.robust_dress_shop()
				if (!posttransformoutfit)
					return
				var/mob/living/carbon/human/newmob = M.change_mob_type( /mob/living/carbon/human , null, null, delmob )
				if(posttransformoutfit && istype(newmob))
					newmob.equipOutfit(posttransformoutfit)
			if("cat")
				M.change_mob_type( /mob/living/simple_animal/pet/cat , null, null, delmob )
			if("runtime")
				M.change_mob_type( /mob/living/simple_animal/pet/cat/Runtime , null, null, delmob )
			if("corgi")
				M.change_mob_type( /mob/living/simple_animal/pet/dog/corgi , null, null, delmob )
			if("ian")
				M.change_mob_type( /mob/living/simple_animal/pet/dog/corgi/Ian , null, null, delmob )
			if("pug")
				M.change_mob_type( /mob/living/simple_animal/pet/dog/pug , null, null, delmob )

	else if(href_list["boot2"])
		if(!check_rights(R_BAN))
			return
		var/mob/M = locate(href_list["boot2"])
		if(ismob(M))
			if(!check_if_greater_rights_than(M.client))
				to_chat(usr, span_danger("错误：对方的权限高于你。"))
				return
			if(alert(usr, "踢出 [key_name(M)]？", "确认", "是", "否") != "是")
				return
			if(!M)
				to_chat(usr, span_danger("错误：[M] 已不存在！"))
				return
			if(!M.client)
				to_chat(usr, span_danger("错误：[M] 已没有客户端！"))
				return
			to_chat(M, span_danger("你已被[usr.client.holder.fakekey ? "管理员" : "[usr.client.key]"]踢出服务器。"))
			log_admin("[key_name(usr)] kicked [key_name(M)].")
			message_admins(span_adminnotice("[key_name_admin(usr)] 踢出了 [key_name_admin(M)]。"))
			qdel(M.client)

	else if(href_list["addmessage"])
		if(!check_rights(R_BAN))
			return
		var/target_key = href_list["addmessage"]
		create_message("message", target_key, secret = 0)

	else if(href_list["addnote"])
		if(!check_rights(R_BAN))
			return
		var/target_key = href_list["addnote"]
		create_message("note", target_key)

	else if(href_list["addwatch"])
		if(!check_rights(R_BAN))
			return
		var/target_key = href_list["addwatch"]
		create_message("watchlist entry", target_key, secret = 1)

	else if(href_list["addmemo"])
		if(!check_rights(R_BAN))
			return
		create_message("memo", secret = 0, browse = 1)

	else if(href_list["addmessageempty"])
		if(!check_rights(R_BAN))
			return
		create_message("message", secret = 0)

	else if(href_list["addnoteempty"])
		if(!check_rights(R_BAN))
			return
		create_message("note")

	else if(href_list["addwatchempty"])
		if(!check_rights(R_BAN))
			return
		create_message("watchlist entry", secret = 1)

	else if(href_list["deletemessage"])
		if(!check_rights(R_BAN))
			return
		var/safety = alert("删除消息或备注？",,"是","否");
		if (safety == "是")
			var/message_id = href_list["deletemessage"]
			delete_message(message_id)

	else if(href_list["deletemessageempty"])
		if(!check_rights(R_BAN))
			return
		var/safety = alert("删除消息或备注？",,"是","否");
		if (safety == "是")
			var/message_id = href_list["deletemessageempty"]
			delete_message(message_id, browse = TRUE)

	else if(href_list["editmessage"])
		if(!check_rights(R_BAN))
			return
		var/message_id = href_list["editmessage"]
		edit_message(message_id)

	else if(href_list["editmessageempty"])
		if(!check_rights(R_BAN))
			return
		var/message_id = href_list["editmessageempty"]
		edit_message(message_id, browse = 1)

	else if(href_list["editmessageexpiry"])
		if(!check_rights(R_BAN))
			return
		var/message_id = href_list["editmessageexpiry"]
		edit_message_expiry(message_id)

	else if(href_list["editmessageexpiryempty"])
		if(!check_rights(R_BAN))
			return
		var/message_id = href_list["editmessageexpiryempty"]
		edit_message_expiry(message_id, browse = 1)

	else if(href_list["editmessageseverity"])
		if(!check_rights(R_BAN))
			return
		var/message_id = href_list["editmessageseverity"]
		edit_message_severity(message_id)

	else if(href_list["secretmessage"])
		if(!check_rights(R_BAN))
			return
		var/message_id = href_list["secretmessage"]
		toggle_message_secrecy(message_id)

	else if(href_list["searchmessages"])
		if(!check_rights(R_BAN))
			return
		var/target = href_list["searchmessages"]
		browse_messages(index = target)

	else if(href_list["nonalpha"])
		if(!check_rights(R_BAN))
			return
		var/target = href_list["nonalpha"]
		target = text2num(target)
		browse_messages(index = target)

	else if(href_list["showmessages"])
		if(!check_rights(R_BAN))
			return
		var/target = href_list["showmessages"]
		browse_messages(index = target)

	else if(href_list["showmemo"])
		if(!check_rights(R_BAN))
			return
		browse_messages("memo")

	else if(href_list["showwatch"])
		if(!check_rights(R_BAN))
			return
		browse_messages("watchlist entry")

	else if(href_list["showwatchfilter"])
		if(!check_rights(R_BAN))
			return
		browse_messages("watchlist entry", filter = 1)

	else if(href_list["showmessageckey"])
		if(!check_rights(R_BAN))
			return
		var/target = href_list["showmessageckey"]
		var/agegate = TRUE
		if (href_list["showall"])
			agegate = FALSE
		browse_messages(target_ckey = target, agegate = agegate)

	else if(href_list["showmessageckeylinkless"])
		var/target = href_list["showmessageckeylinkless"]
		browse_messages(target_ckey = target, linkless = 1)

	else if(href_list["messageedits"])
		if(!check_rights(R_BAN))
			return
		var/datum/DBQuery/query_get_message_edits = SSdbcore.NewQuery(
			"SELECT edits FROM [format_table_name("messages")] WHERE id = :message_id",
			list("message_id" = href_list["messageedits"])
		)
		if(!query_get_message_edits.warn_execute())
			qdel(query_get_message_edits)
			return
		if(query_get_message_edits.NextRow())
			var/edit_log = query_get_message_edits.item[1]
			if(!QDELETED(usr))
				var/datum/browser/browser = new(usr, "Note edits", "备注编辑记录")
				browser.set_content(jointext(edit_log, ""))
				browser.open()
		qdel(query_get_message_edits)

	else if(href_list["mute"])
		if(!check_rights(R_BAN))
			return
		cmd_admin_mute(href_list["mute"], text2num(href_list["mute_type"]))

	else if(href_list["c_mode"])
		return HandleCMode()

	else if(href_list["f_secret"])
		return HandleFSecret()

	else if(href_list["c_mode2"])
		if(!check_rights(R_ADMIN|R_SERVER))
			return

		if (SSticker.HasRoundStarted())
			if (askuser(usr, "游戏已开始。是否将此模式保存为下回合起生效的默认模式？", "保存模式", "是", "取消", Timeout = null) == 1)
				SSticker.save_mode(href_list["c_mode2"])
			HandleCMode()
			return
		GLOB.master_mode = href_list["c_mode2"]
		log_admin("[key_name(usr)] set the mode as [GLOB.master_mode].")
		message_admins(span_adminnotice("[key_name_admin(usr)] 将模式设为 [GLOB.master_mode]。"))
		to_chat(world, span_adminnotice("<b>当前模式：[GLOB.master_mode]</b>"))
		Game() // updates the main game menu
		if (askuser(usr, "是否将此模式保存为服务器默认模式？", "保存模式", "是", "否", Timeout = null) == 1)
			SSticker.save_mode(GLOB.master_mode)
		HandleCMode()

	else if(href_list["f_secret2"])
		if(!check_rights(R_ADMIN|R_SERVER))
			return

		if(SSticker.HasRoundStarted())
			return alert(usr, "游戏已开始。", null, null, null, null)
		if(GLOB.master_mode != "secret")
			return alert(usr, "游戏模式必须为 secret！", null, null, null, null)
		GLOB.secret_force_mode = href_list["f_secret2"]
		log_admin("[key_name(usr)] set the forced secret mode as [GLOB.secret_force_mode].")
		message_admins(span_adminnotice("[key_name_admin(usr)] 将强制 secret 模式设为 [GLOB.secret_force_mode]。"))
		Game() // updates the main game menu
		HandleFSecret()

	else if(href_list["corgione"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["corgione"])
		if(!istype(H))
			to_chat(usr, "此操作仅适用于 /mob/living/carbon/human 类型的实例。")
			return

		log_admin("[key_name(usr)] attempting to corgize [key_name(H)].")
		message_admins(span_adminnotice("[key_name_admin(usr)] 正在尝试将 [key_name_admin(H)] 变为柯基犬。"))
		H.corgize()


	else if(href_list["forcespeech"])
		if(!check_rights(R_FUN))
			return

		var/mob/M = locate(href_list["forcespeech"])
		if(!ismob(M))
			to_chat(usr, "此操作仅适用于 /mob 类型的实例。")

		var/speech = input("让 [key_name(M)] 说什么？", "强制发言", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)
			return
		M.say(speech, forced = "admin speech")
		speech = sanitize(speech) // Nah, we don't trust them
		log_admin("[key_name(usr)] forced [key_name(M)] to say: [speech]")
		message_admins(span_adminnotice("[key_name_admin(usr)] 强制 [key_name_admin(M)] 发言：[speech]"))

	else if(href_list["sendtoprison"])
		if(!check_rights(R_BAN))
			return

		var/mob/M = locate(href_list["sendtoprison"])
		if(!ismob(M))
			to_chat(usr, "此操作仅适用于 /mob 类型的实例。")
			return

		if(alert(usr, "将 [key_name(M)] 送进监狱？", "提示", "是", "否") != "是")
			return

		M.forceMove(pick(GLOB.prisonwarp))
		to_chat(M, span_adminnotice("我被送进监狱了！"))

		log_admin("[key_name(usr)] has sent [key_name(M)] to Prison!")
		message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 送进了监狱！")

	else if(href_list["sendbacktolobby"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendbacktolobby"])

		if(alert(usr, "将 [key_name(M)] 送回大厅？", "提示", "是", "否") != "是")
			return
		var/living = isliving(M)
		if(living)
			if(alert(usr, "[key_name(M)] 的角色还活着。确定要将其送回大厅吗？", "提示", "是", "否") != "是")
				return
		if(!M.client)
			to_chat(usr, span_warning("[M] 似乎没有在线的客户端。"))
			return
		log_admin("[key_name(usr)] has sent [key_name(M)] back to the Lobby.")
		if(living)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(usr, span_warning("活着的生物中，只有人类可以被送回大厅。"))
				return
			var/delete_character = FALSE
			if(alert(usr, "是否同时删除活着的角色 [key_name(M)]？", "提示", "是", "否") == "是")
				log_admin("[key_name(usr)] has chosen to delete the [M] mob while sending the client to lobby.")
				delete_character = TRUE
			H.admin_send_back_to_lobby(usr, delete_character)
		else
			SSdroning.kill_droning(M.client)
			SSdroning.kill_loop(M.client)
			SSdroning.kill_rain(M.client)
			var/mob/dead/new_player/NP = new()
			NP.ckey = M.ckey
			qdel(M)

	else if(href_list["ssd_sendbacktolobby"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/living/carbon/human/H = locate(href_list["ssd_sendbacktolobby"])
		if(!istype(H))
			to_chat(usr, span_warning("此操作仅适用于 /mob/living/carbon/human 类型的实例。"))
			return
		if(H.client || !H.last_logout_time)
			to_chat(usr, span_warning("[H] 已不再处于深度沉睡状态。"))
			return
		if(alert(usr, "让沉睡中的 [key_name(H)] 远行并删除其角色？", "提示", "是", "否") != "是")
			return
		log_admin("[key_name(usr)] has fartraveled slumbering [key_name(H)] after [DisplayTimeText(world.time - H.last_logout_time, 1)] in a deep slumber.")
		message_admins(span_adminnotice("[key_name_admin(usr)] 让深度沉睡了 [DisplayTimeText(world.time - H.last_logout_time, 1)] 的 [key_name_admin(H)] 远行。"))
		H.admin_send_back_to_lobby(usr, TRUE)

	else if(href_list["revive"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			to_chat(usr, "此操作仅适用于 /mob/living 类型的实例。")
			return

		L.revive(full_heal = TRUE, admin_revive = TRUE)
		message_admins(span_danger("管理员 [key_name_admin(usr)] 治愈或复活了 [key_name_admin(L)]！"))
		log_admin("[key_name(usr)] healed / Revived [key_name(L)].")

	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/M = locate(href_list["makeanimal"])
		if(isnewplayer(M))
			to_chat(usr, "此操作不适用于 /mob/dead/new_player 类型的实例。")
			return

		usr.client.cmd_admin_animalize(M)

	else if(href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)

	else if(href_list["adminplayerobservefollow"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/atom/movable/AM = locate(href_list["adminplayerobservefollow"])

		var/client/C = usr.client
		var/can_ghost = TRUE
		if(!isobserver(usr))
			can_ghost = C.admin_ghost()

		if(!can_ghost)
			return
		var/mob/dead/observer/A = C.mob
		A.ManualFollow(AM)

	else if(href_list["admingetmovable"])
		if(!check_rights(R_ADMIN))
			return

		var/atom/movable/AM = locate(href_list["admingetmovable"])
		if(QDELETED(AM))
			return
		AM.forceMove(get_turf(usr))

	else if(href_list["adminplayerobservecoodjump"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/x = text2num(href_list["X"])
		var/y = text2num(href_list["Y"])
		var/z = text2num(href_list["Z"])

		var/client/C = usr.client
		if(!isobserver(usr))
			C.admin_ghost()
		sleep(2)
		C.jumptocoord(x,y,z)

	else if(href_list["adminmoreinfo"])
		var/mob/M = locate(href_list["adminmoreinfo"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "此操作仅适用于 /mob 类型的实例。")
			return

		var/location_description = ""
		var/special_role_description = ""
		var/health_description = ""
		var/gender_description = ""
		var/turf/T = get_turf(M)

		//Location
		if(isturf(T))
			if(isarea(T.loc))
				location_description = "（[M.loc == T ? "坐标" : "位于 [M.loc] 内，坐标"] [T.x], [T.y], [T.z]，区域 <b>[T.loc]</b>）"
			else
				location_description = "（[M.loc == T ? "坐标" : "位于 [M.loc] 内，坐标"] [T.x], [T.y], [T.z]）"

		//Job + antagonist
		if(M.mind)
			special_role_description = "职业：<b>[M.mind.assigned_role]</b>；反派：<font color='red'><b>[M.mind.special_role]</b></font>"
		else
			special_role_description = "职业：<i>缺少心智数据</i> 反派：<i>缺少心智数据</i>"

		//Health
		if(isliving(M))
			var/mob/living/L = M
			var/status
			switch (M.stat)
				if(CONSCIOUS)
					status = "存活"
				if(SOFT_CRIT)
					status = "<font color='orange'><b>濒死</b></font>"
				if(UNCONSCIOUS)
					status = "<font color='orange'><b>[L.InCritical() ? "昏迷且濒死" : "昏迷"]</b></font>"
				if(DEAD)
					status = "<font color='red'><b>死亡</b></font>"
			health_description = "状态 = [status]"
			health_description += "<BR>缺氧：[L.getOxyLoss()] - 毒素：[L.getToxLoss()] - 烧伤：[L.getFireLoss()] - 蛮力：[L.getBruteLoss()] - 克隆损伤：[L.getCloneLoss()] - 脑损伤：[L.getOrganLoss(ORGAN_SLOT_BRAIN)] - 耐力损耗：[L.getStaminaLoss()]"
		else
			health_description = "此生物类型没有生命值。"

		//Gender
		switch(M.gender)
			if(MALE,FEMALE,PLURAL)
				gender_description = "[M.gender]"
			else
				gender_description = "<font color='red'><b>[M.gender]</b></font>"

		to_chat(src.owner, "<b>[M.name] 的信息：</b> ")
		to_chat(src.owner, "生物类型 = [M.type]；性别 = [gender_description] 伤害 = [health_description]")
		to_chat(src.owner, "名称 = <b>[M.name]</b>；真实姓名 = [M.real_name]；心智姓名 = [M.mind?"[M.mind.name]":""]；账号 = <b>[M.key]</b>；")
		to_chat(src.owner, "位置 = [location_description]；")
		to_chat(src.owner, "[special_role_description]")
		to_chat(src.owner, ADMIN_FULLMONTY_NONAME(M))

	else if(href_list["addjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Add = href_list["addjobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Add)
				job.total_positions += 1
				break

		src.manage_free_slots()


	else if(href_list["customjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Add = href_list["customjobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Add)
				var/newtime = null
				newtime = input(usr, "需要多少个职业名额？", "设置职业名额", "[newtime]") as num|null
				if(!newtime)
					to_chat(src.owner, "将名额设为该职业当前已占用的名额数")
					job.total_positions = job.current_positions
					break
				job.total_positions = newtime

		src.manage_free_slots()

	else if(href_list["removejobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Remove = href_list["removejobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Remove && job.total_positions - job.current_positions > 0)
				job.total_positions -= 1
				break

		src.manage_free_slots()

	else if(href_list["unlimitjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Unlimit = href_list["unlimitjobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Unlimit)
				job.total_positions = -1
				break

		src.manage_free_slots()

	else if(href_list["limitjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Limit = href_list["limitjobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Limit)
				job.total_positions = job.current_positions
				break

		src.manage_free_slots()

	else if(href_list["adminsmite"])
		if(!check_rights(R_BAN|R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list["adminsmite"]) in GLOB.mob_list
		if(!H || !istype(H))
			to_chat(usr, "此操作仅适用于 /mob/living/carbon/human 类型的实例。")
			return

		usr.client.smite(H)
/*
	else if(href_list["CentComReply"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["CentComReply"])
		usr.client.admin_headset_message(M, RADIO_CHANNEL_CENTCOM)

	else if(href_list["SyndicateReply"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["SyndicateReply"])
		usr.client.admin_headset_message(M, RADIO_CHANNEL_SYNDICATE)

	else if(href_list["HeadsetMessage"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["HeadsetMessage"])
		usr.client.admin_headset_message(M)
*/
	else if(href_list["jumpto"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))
			return

		if(alert(usr, "确认操作？", "提示", "是", "否") != "是")
			return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["increase_skill"])
		var/mob/M = locate(href_list["increase_skill"])
		var/datum/skill/skill = href_list["skill"]
		M.adjust_skillrank(text2path(skill), 1)
		message_admins(span_danger("管理员 [key_name_admin(usr)] 提高了 [key_name_admin(M)] 的 [skill] 技能等级"))
		log_admin("[usr] increased [M]'s [initial(skill.name)] skill.")
		show_player_panel_next(M, "skills")

	else if(href_list["decrease_skill"])
		var/mob/M = locate(href_list["decrease_skill"])
		var/datum/skill/skill = href_list["skill"]
		M.adjust_skillrank(text2path(skill), -1)
		message_admins(span_danger("管理员 [key_name_admin(usr)] 降低了 [key_name_admin(M)] 的 [skill] 技能等级"))
		log_admin("[usr] decreased [M]'s [initial(skill.name)] skill.")
		show_player_panel_next(M, "skills")

	else if(href_list["set_skill"])
		var/mob/M = locate(href_list["set_skill"])
		var/skill_path = text2path(href_list["skill"])
		var/datum/skill/skill = GetSkillRef(skill_path)
		var/current_level = M.get_skill_level(skill_path)
		var/new_level = input(usr, "设置 [skill.name] 等级（0-6）：", "设置技能", current_level) as num|null
		if(new_level != null && M)
			new_level = clamp(new_level, 0, 6)
			var/difference = new_level - current_level
			if(difference != 0)
				M.adjust_skillrank(skill_path, difference, TRUE)
				message_admins(span_danger("管理员 [key_name_admin(usr)] 将 [key_name_admin(M)] 的 [skill.name] 设为 [new_level]（原为 [current_level]）"))
				log_admin("[usr] set [M]'s [skill.name] skill to [new_level] (was [current_level]).")
			show_player_panel_next(M, "skills")

	else if(href_list["add_language"])
		var/mob/M = locate(href_list["add_language"])
		var/datum/language/lang = text2path(href_list["language"])
		M.grant_language(lang)
		message_admins(span_danger("管理员 [key_name_admin(usr)] 为 [key_name_admin(M)] 添加了语言 [lang]"))
		log_admin("[usr] added [lang] to [M].")
		show_player_panel_next(M, "languages")

	else if(href_list["remove_language"])
		var/mob/M = locate(href_list["remove_language"])
		var/datum/language/lang = text2path(href_list["language"])
		M.remove_language(lang, source = LANGUAGE_SOURCE_ALL)
		message_admins(span_danger("管理员 [key_name_admin(usr)] 移除了 [key_name_admin(M)] 的语言 [lang]"))
		log_admin("[usr] removed [lang] to [M].")
		show_player_panel_next(M, "languages")

	else if(href_list["add_stat"])
		var/mob/living/M = locate(href_list["add_stat"])
		var/statkey = href_list["stat"]
		message_admins(span_danger("管理员 [key_name_admin(usr)] 提高了 [key_name_admin(M)] 的 [statkey] 属性"))
		M.change_stat(statkey, 1)
		log_admin("[usr] increased [M]'s [statkey].")
		show_player_panel_next(M, "stats")

	else if(href_list["lower_stat"])
		var/mob/living/M = locate(href_list["lower_stat"])
		var/statkey = href_list["stat"]
		message_admins(span_danger("管理员 [key_name_admin(usr)] 降低了 [key_name_admin(M)] 的 [statkey] 属性"))
		M.change_stat(statkey, -1)
		log_admin("[usr] decreased [M]'s [statkey].")
		show_player_panel_next(M, "stats")

	else if(href_list["set_stat"])
		var/mob/living/M = locate(href_list["set_stat"])
		var/statkey = href_list["stat"]
		var/current_value = M.get_stat(statkey)
		var/new_value = input(usr, "设置 [statkey] 属性值：", "设置属性", current_value) as num|null
		if(new_value != null && M)
			var/difference = new_value - current_value
			if(difference != 0)
				M.change_stat(statkey, difference)
				message_admins(span_danger("管理员 [key_name_admin(usr)] 将 [key_name_admin(M)] 的 [statkey] 设为 [new_value]（原为 [current_value]）"))
				log_admin("[usr] set [M]'s [statkey] to [new_value] (was [current_value]).")
			show_player_panel_next(M, "stats")

	else if(href_list["set_patron"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/living/M = locate(href_list["set_patron"])
		if(!isliving(M))
			to_chat(usr, span_warning("目标必须是活着的生物。"))
			return
		var/patron_type = text2path(href_list["patron"])
		if(!patron_type)
			return

		// For divine spellcasters (those with devotion), we need to handle spells specially
		var/is_divine_caster = FALSE
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.devotion)
				is_divine_caster = TRUE

		// Remove old patron bonuses/spells
		if(M.patron)
			M.patron.on_loss(M)

			// For divine casters, remove devotion spells from old patron
			if(is_divine_caster && ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.devotion && M.patron.miracles)
					for(var/spell_type in M.patron.miracles)
						if(H.mind?.has_spell(spell_type))
							H.mind.RemoveSpell(spell_type)

		// Set new patron
		M.set_patron(patron_type)

		// For divine casters, grant new patron's devotion spells
		if(is_divine_caster && ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.devotion)
				// Reinitialize devotion with new patron
				H.devotion.patron = M.patron
				// Update the level to trigger spell granting
				H.devotion.try_add_spells(silent = FALSE)

		message_admins(span_danger("管理员 [key_name_admin(usr)] 将 [key_name_admin(M)] 的信仰神祇改为 [initial(M.patron.name)]"))
		log_admin("[usr] changed [M]'s patron to [initial(M.patron.name)].")
		show_player_panel_next(M, "patron")

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["individuallog"])
		if(!check_rights(R_BAN))
			return

		var/mob/M = locate(href_list["individuallog"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "此操作仅适用于 /mob 类型的实例。")
			return

		//a highlight toggle pinged from the POV page's javascript, record it and do not re-render
		if(href_list["povhl"])
			usr.client.toggle_pov_highlight(M, href_list["log_src"], href_list["pov_mode"], href_list["povhl"])
			return

		//same for the filter checkboxes, so a page turn keeps what was filtered out
		if(href_list["povfilter"])
			usr.client.set_pov_filters(M, href_list["log_src"], href_list["pov_mode"], href_list["povfilter"])
			return

		show_individual_logging_panel(M, href_list["log_src"], href_list["log_type"] || INDIVIDUAL_ATTACK_LOG, text2num(href_list["log_page"]) || 1, href_list["pov_mode"], href_list["pov_paging"], text2num(href_list["page_len"]) || 0, text2num(href_list["pov_tail"]), href_list["pov_focus"], href_list["pov_fresh"], text2num(href_list["pov_at"]))
	else if(href_list["languagemenu"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["languagemenu"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "此操作仅适用于 /mob 类型的实例。")
			return
		var/datum/language_holder/H = M.get_language_holder()
		H.open_language_menu(usr)

	else if(href_list["traitor"])
		if(!check_rights(R_BAN))
			return

		if(!SSticker.HasRoundStarted())
			alert("游戏尚未开始！")
			return

		var/mob/M = locate(href_list["traitor"])
		if(!ismob(M))
			var/datum/mind/D = M
			if(!istype(D))
				to_chat(usr, "此操作仅适用于 /mob 和 /mind 类型的实例。")
				return
			else
				D.traitor_panel()
		else
			show_traitor_panel(M)

	else if(href_list["initmind"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["initmind"])
		if(!ismob(M) || M.mind)
			to_chat(usr, "此操作仅适用于没有心智的生物。")
			return
		M.mind_initialize()

	else if(href_list["create_object"])
		if(!check_rights(R_SPAWN))
			return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_SPAWN))
			return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_SPAWN))
			return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_SPAWN))
			return
		return create_mob(usr)

	else if(href_list["dupe_marked_datum"])
		if(!check_rights(R_SPAWN))
			return
		return DuplicateObject(marked_datum, perfectcopy=1, newloc=get_turf(usr))

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_SPAWN))
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				continue
			else if(!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
				continue
			paths += path

		if(!paths)
			alert("提交的路径列表为空。")
			return
		if(length(paths) > 5)
			alert("请减少对象类型数量（最多 5 种）。")
			return

		var/list/offset = splittext(href_list["offset"],",")
		var/number = CLAMP(text2num(href_list["object_count"]), 1, ADMIN_SPAWN_CAP)
		var/X = offset.len > 0 ? text2num(offset[1]) : 0
		var/Y = offset.len > 1 ? text2num(offset[2]) : 0
		var/Z = offset.len > 2 ? text2num(offset[3]) : 0
		var/obj_dir = text2num(href_list["object_dir"])
		if(obj_dir && !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = null
		var/obj_name = sanitize(href_list["object_name"])
		var/quality_raw = href_list["object_quality"]
		var/obj_quality = null
		var/obj_quality_set = FALSE
		if(length(quality_raw))
			obj_quality = text2num(quality_raw)
			if(!isnull(obj_quality) && obj_quality >= ITEM_QUALITY_RUINED && obj_quality <= ITEM_QUALITY_MASTERWORK)
				obj_quality_set = TRUE
			else
				obj_quality = null


		var/atom/target //Where the object will be spawned
		var/where = href_list["object_where"]
		if (!( where in list("onfloor","frompod","inhand","inmarked") ))
			where = "onfloor"


		switch(where)
			if("inhand")
				if (!iscarbon(usr))
					to_chat(usr, "只有碳基生物或机器人可以将物品生成在手中。")
					where = "onfloor"
				target = usr

			if("onfloor", "frompod")
				switch(href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if("inmarked")
				if(!marked_datum)
					to_chat(usr, "未标记任何对象，已取消生成。")
					return
				else if(!istype(marked_datum, /atom))
					to_chat(usr, "标记的对象无法作为目标，目标必须为 /atom 类型。已取消生成。")
					return
				else
					target = marked_datum

		var/obj/structure/closet/supplypod/centcompod/pod

		if(target)
			if(where == "frompod")
				pod = new()

			for (var/path in paths)
				for (var/i = 0; i < number; i++)
					if(path in typesof(/turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N && obj_name)
							N.name = obj_name
					else
						var/atom/O
						if(where == "frompod")
							O = new path(pod)
						else
							O = new path(target)

						if(!QDELETED(O))
							O.flags_1 |= ADMIN_SPAWNED_1
							if(obj_dir)
								O.setDir(obj_dir)
							if(obj_quality_set && istype(O, /obj/item))
								var/obj/item/spawned_item = O
								if(istype(spawned_item, /obj/item/ingot))
									var/obj/item/ingot/ING = spawned_item
									ING.apply_smelt_quality(obj_quality)
								else if(spawned_item.has_item_quality)
									spawned_item.apply_quality(null, null, obj_quality)
							if(obj_name)
								O.name = obj_name
								if(ismob(O))
									var/mob/M = O
									M.real_name = obj_name
							if(ishuman(O))
								var/mob/living/carbon/human/spawned_human = O
								spawned_human.taints_loot = !!href_list["taints_loot"]
								if(!spawned_human.taints_loot)
									for(var/obj/item/I in spawned_human.get_equipped_items(TRUE) + spawned_human.held_items)
										I.unmark_as_looted()
							if(where == "inhand" && isliving(usr) && isitem(O))
								var/mob/living/L = usr
								var/obj/item/I = O
								L.put_in_hands(I)

		if(pod)
			new /obj/effect/DPtarget(target, pod)

		if (number == 1)
			log_admin("[key_name(usr)] created a [english_list(paths)]")
			spawn_message_admins("[key_name_admin(usr)] 生成了一个 [english_list(paths)]")
		else
			log_admin("[key_name(usr)] created [number]ea [english_list(paths)]")
			spawn_message_admins("[key_name_admin(usr)] 生成了各 [number] 个 [english_list(paths)]")
		return

	else if(href_list["secrets"])
		Secrets_topic(href_list["secrets"],href_list)

	else if(href_list["check_antagonist"])
		if(!check_rights(R_BAN))
			return
		usr.client.check_antagonists()

	else if(href_list["check_hunted_targets"])
		if(!check_rights(R_BAN))
			return
		if(!SSticker.HasRoundStarted())
			alert("游戏尚未开始！")
			return
		usr.client.holder.check_hunted_targets()

	else if(href_list["kick_all_from_lobby"])
		if(!check_rights(R_BAN))
			return
		if(SSticker.IsRoundInProgress())
			var/afkonly = text2num(href_list["afkonly"])
			if(alert("确定踢出大厅中的[afkonly ? "所有挂机" : "所有"]玩家吗？","提示","是","取消") != "是")
				to_chat(usr, "已取消踢出大厅玩家")
				return
			var/list/listkicked = kick_clients_in_lobby(span_danger("我被[usr.client.holder.fakekey ? "管理员" : "[usr.client.key]"]踢出了大厅。"), afkonly)

			var/strkicked = ""
			for(var/name in listkicked)
				strkicked += "[name], "
			message_admins("[key_name_admin(usr)] 踢出了大厅中的[afkonly ? "所有挂机" : "所有"]玩家，共 [length(listkicked)] 人：[strkicked ? strkicked : "--"]")
			log_admin("[key_name(usr)] has kicked [afkonly ? "all AFK" : "all"] clients from the lobby. [length(listkicked)] clients kicked: [strkicked ? strkicked : "--"]")
		else
			to_chat(usr, "此操作仅可在游戏进行时使用。")

	else if(href_list["create_outfit_finalize"])
		if(!check_rights(R_ADMIN))
			return
		create_outfit_finalize(usr,href_list)
	else if(href_list["load_outfit"])
		if(!check_rights(R_ADMIN))
			return
		load_outfit(usr)
	else if(href_list["create_outfit_menu"])
		if(!check_rights(R_ADMIN))
			return
		create_outfit(usr)
	else if(href_list["delete_outfit"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/outfit/O = locate(href_list["chosen_outfit"]) in GLOB.custom_outfits
		delete_outfit(usr,O)
	else if(href_list["save_outfit"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/outfit/O = locate(href_list["chosen_outfit"]) in GLOB.custom_outfits
		save_outfit(usr,O)

	else if(href_list["viewruntime"])
		var/datum/error_viewer/error_viewer = locate(href_list["viewruntime"])
		if(!istype(error_viewer))
			to_chat(usr, span_warning("该运行时错误查看器已不存在。"))
			return

		if(href_list["viewruntime_backto"])
			error_viewer.show_to(owner, locate(href_list["viewruntime_backto"]), href_list["viewruntime_linear"])
		else
			error_viewer.show_to(owner, null, href_list["viewruntime_linear"])

	else if(href_list["showrelatedacc"])
		if(!check_rights(R_ADMIN))
			return
		var/client/C = locate(href_list["client"]) in GLOB.clients
		var/thing_to_check
		if(href_list["showrelatedacc"] == "cid")
			thing_to_check = C.related_accounts_cid
		else
			thing_to_check = C.related_accounts_ip
		thing_to_check = splittext(replacetext(thing_to_check, "Requires database", "需要数据库支持"), ", ")


		var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'></head><body>按 [uppertext(href_list["showrelatedacc"])] 查找的关联账号：")
		dat += thing_to_check

		usr << browse(dat.Join("<br>") + "</body></html>", "window=related_[C];file=related_[REF(C)].html;size=420x300")

	else if(href_list["modantagrep"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/C = M.client
		usr.client.cmd_admin_mod_antag_rep(C, href_list["modantagrep"])
		show_player_panel(M)

	else if(href_list["modtriumphs"])
		if(!check_rights(R_BAN))
			return
		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		usr.client.cmd_admin_mod_triumphs(M, href_list["modtriumphs"])
		show_player_panel(M)

	else if(href_list["modpq"])
		if(!check_rights(R_BAN))
			return
		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		usr.client.cmd_admin_mod_pq(M, href_list["modpq"])
		show_player_panel(M)

	else if(href_list["slowquery"])
		if(!check_rights(R_ADMIN))
			return
		var/answer = href_list["slowquery"]
		if(answer == "yes")
			log_query_debug("[usr.key] | Reported a server hang")
			if(alert(usr, "刚才是否点击过管理按钮？", "查询导致的服务器卡顿报告", "是", "否") == "是")
				var/response = input(usr,"刚才进行了什么操作？","查询导致的服务器卡顿报告") as null|text
				if(response)
					log_query_debug("[usr.key] | [response]")
		else if(answer == "no")
			log_query_debug("[usr.key] | Reported no server hang")

	else if(href_list["rebootworld"])
		if(!check_rights(R_ADMIN))
			return
		var/confirm = alert("确定重启服务器吗？", "确认重启", "是", "否")
		if(confirm == "否")
			return
		if(confirm == "是")
			restart()

	else if(href_list["check_teams"])
		if(!check_rights(R_ADMIN))
			return
		check_teams()

	else if(href_list["team_command"])
		if(!check_rights(R_ADMIN))
			return
		switch(href_list["team_command"])
			if("create_team")
				admin_create_team(usr)
			if("rename_team")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_rename(usr)
			if("communicate")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_communicate(usr)
			if("delete_team")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_delete(usr)
			if("add_objective")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_add_objective(usr)
			if("remove_objective")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(!T)
					return
				var/datum/objective/O = locate(href_list["tobjective"]) in T.objectives
				if(O)
					T.admin_remove_objective(usr,O)
			if("add_member")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_add_member(usr)
			if("remove_member")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(!T)
					return
				var/datum/mind/M = locate(href_list["tmember"]) in T.members
				if(M)
					T.admin_remove_member(usr,M)
		check_teams()

	else if(href_list["editpq"])
		if(!check_rights(R_BAN))
			return
		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/mob_client = M.client
		var/amt2change = input("玩家质量分（PQ）调整多少？（[!check_rights(R_BAN,0) ? "范围为 -20 至 20；" : ""]输入 0 仅添加备注）") as null|num
		if(!check_rights(R_BAN,0))
			amt2change = CLAMP(amt2change, -20, 20)
		var/raisin = stripped_input("简要说明此次调整的原因", "游戏主持", "", null)
		if(!amt2change && !raisin)
			return
		adjust_playerquality(amt2change, mob_client.ckey, usr.ckey, raisin)
		for(var/client/C in GLOB.clients) // I hate this, but I'm not refactoring the cancer above this point.
			if(LOWER_TEXT(C.key) == LOWER_TEXT(mob_client.ckey))
				to_chat(C, "<span class=\"admin\"><span class=\"prefix\">管理员记录：</span> <span class=\"message linkify\">[usr.key]将你的玩家质量分（PQ）调整了[amt2change]，原因：[raisin]</span></span>")
				return
	else if(href_list["showpq"])
		if(!check_rights(R_BAN))
			return
		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/mob_client = M.client
		check_pq_menu(mob_client.key)

	else if(href_list["edittriumphs"])
		if(!check_rights(R_BAN))
			return
		var/mob/M = (locate(href_list["mob"]) in GLOB.mob_list)
		if(!M?.key)
			alert(usr, "[M] 没有关联的账号。")
			return

		var/amt2change = input(usr, "凯旋点调整多少？（-100 至 100）") as null|num
		amt2change = clamp(amt2change, -100, 100)
		if(!amt2change)
			return

		var/raisin = stripped_input(usr, "简要说明此次调整的原因", "游戏主持", null, null)
		M.adjust_triumphs(amt2change, FALSE, raisin)
		message_admins("[usr.key] 将 [M.key] 的凯旋点调整了 [amt2change]，[!raisin ? "未提供原因" : "原因：[raisin]"]。")
		log_admin("[usr.key] adjusted [M.key]'s triumphs by [amt2change] with [!raisin ? "no reason given" : "reason: [raisin]"].")

	else if(href_list["newbankey"])
		var/player_key = href_list["newbankey"]
		var/player_ip = href_list["newbanip"]
		var/player_cid = href_list["newbancid"]
		ban_panel(player_key, player_ip, player_cid)

	else if(href_list["intervaltype"]) //check for ban panel, intervaltype is used as it's the only value which will always be present
		if(href_list["roleban_delimiter"])
			ban_parse_href(href_list)
		else
			ban_parse_href(href_list, TRUE)

	else if(href_list["searchunbankey"] || href_list["searchunbanadminkey"] || href_list["searchunbanip"] || href_list["searchunbancid"])
		var/player_key = href_list["searchunbankey"]
		var/admin_key = href_list["searchunbanadminkey"]
		var/player_ip = href_list["searchunbanip"]
		var/player_cid = href_list["searchunbancid"]
		unban_panel(player_key, admin_key, player_ip, player_cid)

	else if(href_list["unbanpagecount"])
		var/page = href_list["unbanpagecount"]
		var/player_key = href_list["unbankey"]
		var/admin_key = href_list["unbanadminkey"]
		var/player_ip = href_list["unbanip"]
		var/player_cid = href_list["unbancid"]
		unban_panel(player_key, admin_key, player_ip, player_cid, page)

	else if(href_list["editbanid"])
		var/edit_id = href_list["editbanid"]
		var/player_key = href_list["editbankey"]
		var/player_ip = href_list["editbanip"]
		var/player_cid = href_list["editbancid"]
		var/role = href_list["editbanrole"]
		var/duration = href_list["editbanduration"]
		var/applies_to_admins = text2num(href_list["editbanadmins"])
		var/reason = url_decode(href_list["editbanreason"])
		var/page = href_list["editbanpage"]
		var/admin_key = href_list["editbanadminkey"]
		ban_panel(player_key, player_ip, player_cid, role, duration, applies_to_admins, reason, edit_id, page, admin_key)

	else if(href_list["unbanid"])
		var/ban_id = href_list["unbanid"]
		var/player_key = href_list["unbankey"]
		var/player_ip = href_list["unbanip"]
		var/player_cid = href_list["unbancid"]
		var/role = href_list["unbanrole"]
		var/page = href_list["unbanpage"]
		var/admin_key = href_list["unbanadminkey"]
		unban(ban_id, player_key, player_ip, player_cid, role, page, admin_key)

	else if(href_list["unbanlog"])
		var/ban_id = href_list["unbanlog"]
		ban_log(ban_id)

	else if(href_list["beakerpanel"])
		beaker_panel_act(href_list)

	else if(href_list["reloadpolls"])
		GLOB.polls.Cut()
		GLOB.poll_options.Cut()
		load_poll_data()
		poll_list_panel()

	else if(href_list["newpoll"])
		poll_management_panel()

	else if(href_list["editpoll"])
		var/datum/poll_question/poll = locate(href_list["editpoll"]) in GLOB.polls
		poll_management_panel(poll)

	else if(href_list["deletepoll"])
		var/datum/poll_question/poll = locate(href_list["deletepoll"]) in GLOB.polls
		poll.delete_poll()
		poll_list_panel()

	else if(href_list["initializepoll"])
		poll_parse_href(href_list)

	else if(href_list["submitpoll"])
		var/datum/poll_question/poll = locate(href_list["submitpoll"]) in GLOB.polls
		poll_parse_href(href_list, poll)

	else if(href_list["clearpollvotes"])
		var/datum/poll_question/poll = locate(href_list["clearpollvotes"]) in GLOB.polls
		poll.clear_poll_votes()
		poll_management_panel(poll)

	else if(href_list["addpolloption"])
		var/datum/poll_question/poll = locate(href_list["addpolloption"]) in GLOB.polls
		poll_option_panel(poll)

	else if(href_list["editpolloption"])
		var/datum/poll_option/option = locate(href_list["editpolloption"]) in GLOB.poll_options
		var/datum/poll_question/poll = locate(href_list["parentpoll"]) in GLOB.polls
		poll_option_panel(poll, option)

	else if(href_list["deletepolloption"])
		var/datum/poll_option/option = locate(href_list["deletepolloption"]) in GLOB.poll_options
		var/datum/poll_question/poll = option.delete_option()
		poll_management_panel(poll)

	else if(href_list["submitoption"])
		var/datum/poll_option/option = locate(href_list["submitoption"]) in GLOB.poll_options
		var/datum/poll_question/poll = locate(href_list["submitoptionpoll"]) in GLOB.polls
		poll_option_parse_href(href_list, poll, option)

	else if(href_list["readcommends"])
		var/the_key = href_list["readcommends"]
		var/popup_window_data = "<center>[the_key]</center>"

		var/json_file = file("data/player_saves/[copytext(the_key,1,2)]/[the_key]/commends.json")
		if(!fexists(json_file))
			WRITE_FILE(json_file, "{}")
		var/list/json = json_decode(file2text(json_file))
		for(var/giver in json)
			popup_window_data += "[giver]: [json[giver]]<br>"

		var/datum/browser/noclose/popup = new(usr, "commendscheck", "", 370, 220)
		popup.set_content(popup_window_data)
		popup.open()

	else if(href_list["cursemenu"])
		var/the_key = href_list["cursemenu"]

		// load JSON
		var/json_file = file("data/player_saves/[copytext(the_key,1,2)]/[the_key]/curses.json")
		if(!fexists(json_file))
			WRITE_FILE(json_file, "{}")

		var/list/json = json_decode(file2text(json_file))
		if(!json)
			json = list()

		var/popup = "<center><b>[the_key] 的诅咒</b><br><br>"

		// detect if any valid entries exist
		var/has_any = FALSE
		for(var/c in json)
			if(json[c])
				has_any = TRUE
				break

		if(!has_any)
			popup += "<i>未找到诅咒。</i><br>"
		else
			popup += "<b>生效中的诅咒：</b><br>"
			for(var/curse_name in json)
				if(!json[curse_name])
					continue

				popup += "<a href='?_src_=holder;[HrefToken()];inspectcurse=[curse_name];key=[the_key]'>[curse_name]</a> "

				popup += "<a href='?_src_=holder;[HrefToken()];removecurse=[curse_name];key=[the_key]'><font color='red'>X</font></a><br>"

		popup += "<br><hr><br>"

		popup += "<a href='?_src_=holder;[HrefToken()];addcurse=[the_key]'><b>添加新诅咒</b></a><br><br>"

		popup += "<a href='?_src_=holder;[HrefToken()];clearallcurses=[the_key]'><font color='red'>清除所有诅咒</font></a>"

		popup += "</center>"

		var/datum/browser/noclose/B = new(usr, "cursecheck", "诅咒", 380, 350)
		B.set_content(popup)
		B.open()
		return
	else if(href_list["addcurse"])
		var/key = href_list["addcurse"]

		// Find mob by ckey
		var/mob/M = null
		for(var/client/C)
			if(C && C.ckey == key)
				M = C.mob
				break

		if(!M)
			usr << "<span class='warning'>玩家不在线。</span>"
			return

		usr.client.curse_player_popup(M)
		return


	else if(href_list["removecurse"])
		// UI sends:
		// removecurse = curse_name
		// key        = player ckey
		var/curse_name = href_list["removecurse"]
		var/key = href_list["key"]

		if(!key || !curse_name)
			usr << "<span class='warning'>移除请求无效。</span>"
			return

		if(remove_player_curse(key, curse_name))
			usr << "<span class='notice'>已移除 [key] 的诅咒 <b>[curse_name]</b>。</span>"
		else
			usr << "<span class='warning'>无法移除 [key] 的诅咒 <b>[curse_name]</b>。</span>"

		src.player_panel_new()
		return

	else if(href_list["clearallcurses"])
		var/key = href_list["clearallcurses"]

		var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/curses.json")
		fdel(json_file)
		WRITE_FILE(json_file, "{}")

		// refresh live state if online
		refresh_player_curses_for_key(key)

		usr << "<span class='notice'>已清除 [key] 的所有诅咒。</span>"

		src.player_panel_new()
		return


	else if(href_list["inspectcurse"])
		var/curse_name = href_list["inspectcurse"]
		var/key = href_list["key"]

		if(!key || !curse_name)
			usr << "<span class='warning'>所选诅咒无效。</span>"
			return

		var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/curses.json")
		if(!fexists(json_file))
			WRITE_FILE(json_file, "{}")

		var/list/json = json_decode(file2text(json_file))
		if(!json || !json[curse_name])
			usr << "<span class='warning'>未找到诅咒。</span>"
			return

		var/list/C = json[curse_name]

		var/text = "<b><u>诅咒：</u></b> [curse_name]<br><hr>"
		var/list/curse_field_labels = list("expires" = "到期日", "flavor" = "风格", "chance" = "触发概率（%）", "cooldown" = "冷却时间（秒）", "last_trigger" = "上次触发时间", "trigger" = "触发条件", "effect" = "效果", "effect_args" = "效果参数", "admin" = "施加者", "reason" = "原因", "character_name" = "绑定角色名", "trait" = "特质", "debuff_id" = "状态效果类型", "reagent_type" = "试剂类型", "amount" = "数量", "mob_type" = "生物类型")
		for(var/field in C)
			var/value = C[field]

			if(islist(value))
				text += "<b>[curse_field_labels[field] || field]：</b><br>"
				for(var/subfield in value)
					text += "&nbsp;&nbsp;<b>[curse_field_labels[subfield] || subfield]：</b> [value[subfield]]<br>"
			else
				text += "<b>[curse_field_labels[field] || field]：</b> [value]<br>"

		if(C["expires"])
			var/days_left = C["expires"] - now_days()
			if(days_left < 0) days_left = 0
			text += "<br><b>剩余天数：</b>[days_left]<br>"

		if(C["cooldown"])
			text += "<b>冷却时间（秒）：</b>[C["cooldown"]]<br>"

		if(C["last_trigger"])
			text += "<b>上次触发时间戳：</b>[C["last_trigger"]]<br>"

		var/datum/browser/noclose/inspect = new(usr, "curseinfo", "诅咒详情", 400, 360)
		inspect.set_content("<center>[text]</center>")
		inspect.open()
		return


/datum/admins/proc/HandleCMode()
	if(!check_rights(R_ADMIN))
		return

	var/dat = {"<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>选择要游玩的模式：</B><HR>"}
	for(var/mode in config.modes)
		dat += {"<A href='?src=[REF(src)];[HrefToken()];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
	dat += {"<A href='?src=[REF(src)];[HrefToken()];c_mode2=secret'>秘密模式</A><br>"}
	dat += {"<A href='?src=[REF(src)];[HrefToken()];c_mode2=random'>随机模式</A><br>"}
	dat += {"当前：[GLOB.master_mode]"}
	usr << browse(dat, "window=c_mode")

/datum/admins/proc/HandleFSecret()
	if(!check_rights(R_ADMIN))
		return

	if(SSticker.HasRoundStarted())
		return alert(usr, "游戏已开始。", null, null, null, null)
	if(GLOB.master_mode != "secret")
		return alert(usr, "游戏模式必须为 secret！", null, null, null, null)
	var/dat = {"<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>要强制秘密模式使用哪种游戏模式？此功能会修改实际模式，同时向玩家显示为秘密模式。仅在当前模式为秘密模式时可用。</B><HR>"}
	for(var/mode in config.modes)
		dat += {"<A href='?src=[REF(src)];[HrefToken()];f_secret2=[mode]'>[config.mode_names[mode]]</A><br>"}
	dat += {"<A href='?src=[REF(src)];[HrefToken()];f_secret2=secret'>随机（默认）</A><br>"}
	dat += {"当前：[GLOB.secret_force_mode]"}
	usr << browse(dat, "window=f_secret")
