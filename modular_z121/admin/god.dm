#define TRAIT_ADMIN_GOD "God"

/proc/admin_god_stat_keys()
	return list(
		STATKEY_STR,
		STATKEY_PER,
		STATKEY_INT,
		STATKEY_CON,
		STATKEY_WIL,
		STATKEY_SPD,
		STATKEY_LCK,
	)

/proc/admin_god_ensure_skill_uncaps()
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill_ref = GetSkillRef(skill_type)
		if(!skill_ref)
			continue
		if(!islist(skill_ref.trait_uncap))
			skill_ref.trait_uncap = list()
		skill_ref.trait_uncap[TRAIT_ADMIN_GOD] = SKILL_LEVEL_LEGENDARY

/proc/admin_god_apply(mob/living/target)
	if(!target)
		return FALSE

	admin_god_ensure_skill_uncaps()
	ADD_TRAIT(target, TRAIT_ADMIN_GOD, TRAIT_ADMIN_GOD)

	for(var/statkey in admin_god_stat_keys())
		var/current_value = target.get_stat(statkey)
		if(isnull(current_value))
			continue
		var/difference = 20 - current_value
		if(difference)
			target.change_stat(statkey, difference)

	var/datum/skill_holder/skill_holder = target.ensure_skills()
	for(var/skill_type in SSskills.all_skills)
		skill_holder.adjust_skillrank_up_to(skill_type, SKILL_LEVEL_LEGENDARY, TRUE)

	target.update_stamina()
	target.updatehealth()
	return TRUE

/client/proc/god()
	set category = "-GameMaster-"
	set name = "授予神明特性"
	set desc = "向选中的玩家授予神明特性，并将其属性和技能提升至完美。"

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return

	var/already_god = HAS_TRAIT(target, TRAIT_ADMIN_GOD)
	if(!admin_god_apply(target))
		to_chat(src, span_warning("未能向 [target] 授予神明特性。"))
		return

	if(already_god)
		to_chat(src, span_notice("已向 [target] 重新施加神明特性，将全部属性和技能恢复至神明的极限。"))
		to_chat(target, span_notice("神力再次涌入我的体内。神明特性让我的属性与技能重归完美。"))
		log_admin("[key_name(usr)] reapplied the God trait to [key_name(target)] and restored all stats and skills to their maximum.")
		message_admins(span_adminnotice("[key_name_admin(usr)] 向 [key_name_admin(target)] 重新施加了神明特性，将全部属性和技能恢复至上限。"))
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] 向你重新施加了神明特性，将全部属性和技能恢复至上限。</font>")
	else
		to_chat(src, span_notice("已向 [target] 授予神明特性。全部属性已设为 20，全部技能的等级和上限已设为 6。"))
		to_chat(target, span_notice("我获得了神明特性。我的属性已臻完美，所有技能都已达到传奇境界。"))
		log_admin("[key_name(usr)] granted the God trait to [key_name(target)], setting all stats to 20 and all skill caps and levels to 6.")
		message_admins(span_adminnotice("[key_name_admin(usr)] 向 [key_name_admin(target)] 授予了神明特性，将全部属性设为 20，全部技能的等级和上限设为 6。"))
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] 向你授予了神明特性，将全部属性设为 20，全部技能的等级和上限设为 6。</font>")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "God")

#undef TRAIT_ADMIN_GOD
