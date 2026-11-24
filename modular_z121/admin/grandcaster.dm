#define TRAIT_ADMIN_GRAND_CASTER "GrandCaster"

/proc/grandcaster_has_spell(mob/target, spell_type)
	if(target.mind?.has_spell(spell_type))
		return TRUE

	for(var/datum/action/cooldown/spell/existing_spell in target.mob_spell_list)
		if(istype(existing_spell, spell_type))
			return TRUE

	return FALSE

/proc/grandcaster_ensure_spell(mob/living/target, spell_type)
	if(grandcaster_has_spell(target, spell_type))
		return FALSE

	var/datum/action/cooldown/spell/new_spell = new spell_type
	if(target.mind)
		target.mind.AddSpell(new_spell, target)
	else
		target.AddSpell(new_spell)
	return TRUE

/proc/grandcaster_apply(mob/living/target)
	if(!target || !target.mind)
		return FALSE

	// 统一由管理员来源赋予 四阶 奥术权限与法师护甲，避免影响目标现有职业来源的特性。
	ADD_TRAIT(target, TRAIT_MAGEARMOR, TRAIT_ADMIN_GRAND_CASTER)
	ADD_TRAIT(target, TRAIT_ARCYNE, TRAIT_ADMIN_GRAND_CASTER)

	// 直接补到 四阶 法术常见的奥术熟练度，使目标具备稳定施法能力。
	target.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_MASTER, TRUE)

	// 保留已学法术，以当前已用额度为基准补足 999 点可用额度。
	target.mind.z121_grand_utility_budget = target.mind.get_utility_points_spent() + 999
	var/list/config = target.mind.z121_grand_config(target.mind.mage_aspect_config)
	target.mind.mage_aspect_config = config
	target.mind.aspect_resets_used = 0

	// 手动兜底基础戏法，防止目标此前从未获得过实用法术点调整路径。
	grandcaster_ensure_spell(target, /datum/action/cooldown/spell/touch/prestidigitation)
	// 显式补发学习法术，避免未来主线改动 check_learnspell 行为后让管理员指令失效。
	grandcaster_ensure_spell(target, /datum/action/cooldown/spell/learnspell)
	// 再同步一次学习法术入口，确保实用法术点与入口状态一致。
	target.mind.check_learnspell()
	target.mind.z121_keep_independent_spell(target.mind.get_spell(/datum/action/cooldown/spell/touch/prestidigitation))
	target.mind.z121_keep_independent_spell(target.mind.get_spell(/datum/action/cooldown/spell/learnspell))
	// 基础法术转为独立来源后再次计数，确保剩余额度恰好为 999。
	config["utilities"] = target.mind.get_utility_points_spent() + 999
	target.mind.z121_grand_utility_budget = config["utilities"]

	target.update_stamina()
	target.updatehealth()
	return TRUE

/client/proc/grandcaster()
	set category = "-GameMaster-"
	set name = "授予大施法者资质"
	set desc = "授予学习法术能力、基础戏法和四阶奥术施法资质。主、次法相容量各设为 9，可用重塑额度恢复至 99 点，可用实用法术点恢复至 999 点。"

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return
	if(!target.mind)
		to_chat(src, span_warning("[target] 当前没有可用的意识数据，无法授予大施法者资质。"))
		return

	var/already_empowered = target.mind.z121_grand_utility_budget > 0
	if(!grandcaster_apply(target))
		to_chat(src, span_warning("未能向 [target] 授予大施法者资质。"))
		return

	var/grant_action = already_empowered ? "刷新" : "授予"
	var/list/aspect_config = target.mind.mage_aspect_config
	var/limits = "主法相容量 [aspect_config["major"]]，次法相容量 [aspect_config["minor"]]，可用重塑额度 [target.mind.get_aspect_reset_remaining()] 点，可用实用法术点 999 点。"
	to_chat(src, span_notice("已为 [target] [grant_action]大施法者资质。[limits]"))
	to_chat(target, span_notice("我的大施法者资质已获[grant_action]。我掌握了基础戏法，可以学习法术并施展四阶奥术。[limits]"))
	log_admin("[key_name(usr)] 为 [key_name(target)] [grant_action]了大施法者资质。[limits]")
	message_admins(span_adminnotice("[key_name_admin(usr)] 为 [key_name_admin(target)] [grant_action]了大施法者资质。[limits]"))
	admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] 为你[grant_action]了大施法者资质。[limits]</font>")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "GrandCaster")

#undef TRAIT_ADMIN_GRAND_CASTER
