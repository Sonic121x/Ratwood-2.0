/client/proc/adminspell_has_target_spell(mob/target, spell_type)
	if(target.mind?.has_spell(spell_type))
		return TRUE

	for(var/obj/effect/proc_holder/spell/existing_spell as anything in target.mob_spell_list)
		if(istype(existing_spell, spell_type))
			return TRUE

	return FALSE

/client/proc/adminspell_get_target()
	var/list/keys = list()
	for(var/mob/player_mob in GLOB.player_list)
		if(player_mob.client)
			keys += player_mob.client

	var/client/selection = input("请选择一名玩家！", "管理员法术", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return null

	if(!isliving(selection.mob))
		to_chat(src, span_warning("选中的玩家没有可接收法术的存活角色。"))
		return null

	return selection.mob

/client/proc/adminspell_spell_types()
	return list(
		/obj/effect/proc_holder/spell/invoked/adminkill,
		/obj/effect/proc_holder/spell/invoked/adminheal,
		/obj/effect/proc_holder/spell/invoked/blink/adminblink,
		/obj/effect/proc_holder/spell/invoked/mimicry/copy,
	)

/client/proc/adminspell()
	set category = "-GameMaster-"
	set name = "授予管理员法术"
	set desc = "向选中的玩家授予管理员法术组合。"

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return

	var/list/spell_types = adminspell_spell_types()
	var/list/granted_names = list()

	for(var/spell_type in spell_types)
		if(adminspell_has_target_spell(target, spell_type))
			continue

		var/obj/effect/proc_holder/spell/new_spell = new spell_type
		if(target.mind)
			target.mind.AddSpell(new_spell, target)
		else
			target.AddSpell(new_spell)
			message_admins(span_danger("管理员法术已授予没有意识数据的角色；这些法术不会随意识交换或克隆转移。"))

		granted_names += initial(new_spell.name)

	if(!granted_names.len)
		to_chat(src, span_notice("[target] 已掌握全部管理员法术。"))
		return

	var/spell_summary = english_list(granted_names)
	to_chat(src, span_notice("已向 [target] 授予 [spell_summary]。"))
	to_chat(target, span_notice("你获得了以下法术：[spell_summary]。"))

	log_admin("[key_name(usr)] granted the admin spell package ([spell_summary]) to [key_name(target)].")
	var/msg = span_adminnotice("[key_name_admin(usr)] 向 [key_name_admin(target)] 授予了管理员法术组合（[spell_summary]）。")
	message_admins(msg)
	admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] 向你授予了管理员法术组合（[spell_summary]）。</font>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "AdminSpell")

/client/proc/removeadminspell()
	set category = "-GameMaster-"
	set name = "移除管理员法术"
	set desc = "移除选中玩家的管理员法术组合。"

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return

	var/list/spell_types = adminspell_spell_types()
	var/list/removed_names = list()

	for(var/spell_type in spell_types)
		var/obj/effect/proc_holder/spell/mind_spell = target.mind?.get_spell(spell_type)
		if(mind_spell)
			removed_names += initial(mind_spell.name)
			target.mind.RemoveSpell(mind_spell)
			continue

		for(var/obj/effect/proc_holder/spell/mob_spell as anything in target.mob_spell_list)
			if(!istype(mob_spell, spell_type))
				continue
			removed_names += initial(mob_spell.name)
			target.RemoveSpell(mob_spell)
			break

	if(!removed_names.len)
		to_chat(src, span_notice("[target] 没有管理员法术组合中的任何法术。"))
		return

	var/spell_summary = english_list(removed_names)
	to_chat(src, span_notice("已从 [target] 身上移除 [spell_summary]。"))
	to_chat(target, span_notice("你失去了以下法术：[spell_summary]。"))

	log_admin("[key_name(usr)] removed the admin spell package ([spell_summary]) from [key_name(target)].")
	var/msg = span_adminnotice("[key_name_admin(usr)] 从 [key_name_admin(target)] 身上移除了管理员法术组合（[spell_summary]）。")
	message_admins(msg)
	admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] 从你身上移除了管理员法术组合（[spell_summary]）。</font>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "RemoveAdminSpell")
