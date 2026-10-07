#define TRAIT_ADMIN_GRAND_CASTER "GrandCaster"

/proc/grandcaster_has_spell(mob/target, spell_type)
	if(target.mind?.has_spell(spell_type))
		return TRUE

	for(var/obj/effect/proc_holder/spell/existing_spell as anything in target.mob_spell_list)
		if(istype(existing_spell, spell_type))
			return TRUE

	return FALSE

/proc/grandcaster_ensure_spell(mob/living/target, spell_type)
	if(grandcaster_has_spell(target, spell_type))
		return FALSE

	var/obj/effect/proc_holder/spell/new_spell = new spell_type
	if(target.mind)
		target.mind.AddSpell(new_spell, target)
	else
		target.AddSpell(new_spell)
	return TRUE

/proc/grandcaster_apply(mob/living/target)
	if(!target || !target.mind)
		return FALSE

	// 统一由管理员来源赋予 T4 奥术权限与法师护甲，避免影响目标现有职业来源的特性。
	ADD_TRAIT(target, TRAIT_MAGEARMOR, TRAIT_ADMIN_GRAND_CASTER)
	ADD_TRAIT(target, TRAIT_ARCYNE_T4, TRAIT_ADMIN_GRAND_CASTER)

	// 直接补到 T4 法术常见的奥术熟练度，使目标具备稳定施法能力。
	target.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_MASTER, TRUE)

	// 这里将已用点数清零，再把总点数设为 999，确保目标实际可支配 999 点法术点。
	target.mind.used_spell_points = 0
	target.mind.spell_points = 999

	// 手动兜底基础戏法，防止目标此前从未获得过法术点调整路径。
	grandcaster_ensure_spell(target, /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	// 显式补发学习法术，避免未来主线改动 check_learnspell 行为后让管理员指令失效。
	grandcaster_ensure_spell(target, /obj/effect/proc_holder/spell/self/learnspell)
	// 再同步一次学习法术入口，确保法术点与入口状态一致。
	target.mind.check_learnspell()

	target.update_stamina()
	target.updatehealth()
	return TRUE

/client/proc/grandcaster()
	set category = "-GameMaster-"
	set name = "授予大施法者资质"
	set desc = "向选中的玩家授予 999 点法术点、学习法术能力、基础戏法和四阶奥术施法资质。"

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return
	if(!target.mind)
		to_chat(src, span_warning("[target] 当前没有可用的意识数据，无法授予大施法者资质。"))
		return

	var/already_empowered = HAS_TRAIT(target, TRAIT_ARCYNE_T4) && (target.get_skill_level(/datum/skill/magic/arcane) >= SKILL_LEVEL_MASTER) && (target.mind.spell_points >= 999) && grandcaster_has_spell(target, /obj/effect/proc_holder/spell/self/learnspell)
	if(!grandcaster_apply(target))
		to_chat(src, span_warning("未能向 [target] 授予大施法者资质。"))
		return

	if(already_empowered)
		to_chat(src, span_notice("已刷新 [target] 的大施法者资质，并将其可用法术点重置为 999。"))
		to_chat(target, span_notice("浩瀚奥术再度涌入我的脑海。我仍保有 T4 施法资质，并重新获得了 999 点可支配法术点。"))
		log_admin("[key_name(usr)] refreshed GrandCaster on [key_name(target)], restoring T4 arcane access and resetting available spell points to 999.")
		message_admins(span_adminnotice("[key_name_admin(usr)] 刷新了 [key_name_admin(target)] 的大施法者资质，恢复四阶奥术权限，并将可用法术点重置为 999。"))
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] 刷新了你的大施法者资质，恢复四阶奥术权限，并将可用法术点重置为 999。</font>")
	else
		to_chat(src, span_notice("已向 [target] 授予大施法者资质。其现在拥有学习法术能力、999 点法术点、基础戏法和四阶奥术施法资质。"))
		to_chat(target, span_notice("庞大的奥术知识被直接灌入我的意识。我现在能学习法术，拥有 999 点法术点，并可施展 T4 奥术。"))
		log_admin("[key_name(usr)] granted GrandCaster to [key_name(target)], giving Learn Spell, 999 spell points, a base cantrip, and T4 arcane casting capability.")
		message_admins(span_adminnotice("[key_name_admin(usr)] 向 [key_name_admin(target)] 授予了大施法者资质，使其获得学习法术能力、999 点法术点、基础戏法和四阶奥术施法资质。"))
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] 向你授予了大施法者资质，使你获得学习法术能力、999 点法术点、基础戏法和四阶奥术施法资质。</font>")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "GrandCaster")

#undef TRAIT_ADMIN_GRAND_CASTER
