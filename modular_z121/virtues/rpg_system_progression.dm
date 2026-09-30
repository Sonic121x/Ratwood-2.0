// 成长记录随角色日志保存，商店关闭、重新绑定及普通复生均不会重复发放奖励。
/datum/component/rpg_journal
	var/rpg_level = 0
	var/rpg_experience = 0
	var/rpg_next_level_experience = 1000
	var/rpg_attribute_points = 0
	var/rpg_skill_points = 0
	var/rpg_trait_points = 0
	// 只记录由技能点兑换的法术点，回溯时不影响其他来源的法术点。
	var/rpg_spell_point_grants = 0

/datum/component/rpg_journal/proc/growth_data()
	return list(
		"level" = rpg_level,
		"experience" = rpg_experience,
		"next_level_experience" = rpg_next_level_experience,
		"attribute_points" = rpg_attribute_points,
		"skill_points" = rpg_skill_points,
		"trait_points" = rpg_trait_points,
		"spell_point_grants" = rpg_spell_point_grants,
	)

// 读档直接恢复保存值，不经过经验奖励入口。
/datum/component/rpg_journal/proc/restore_growth(list/saved)
	var/saved_grants = saved ? saved["spell_point_grants"] : 0
	var/mob/living/carbon/human/host = parent
	if(host.mind && rpg_spell_point_grants != saved_grants)
		// 心智和已学法术不会回滚；保留已用额度，避免退还技能点后重复学习。
		host.mind.spell_points -= rpg_spell_point_grants - saved_grants
		host.mind.check_learnspell()
	rpg_spell_point_grants = saved_grants
	rpg_level = saved ? saved["level"] : 0
	rpg_experience = saved ? saved["experience"] : 0
	rpg_next_level_experience = saved ? saved["next_level_experience"] : 1000
	rpg_attribute_points = saved ? saved["attribute_points"] : 0
	rpg_skill_points = saved ? saved["skill_points"] : 0
	rpg_trait_points = saved ? saved["trait_points"] : 0

// 只有真实收入调用此入口；退款和快照恢复仍直接还原余额。
/datum/component/rpg_system/proc/grant_income(amount)
	if(!isnum(amount) || amount <= 0 || !ishuman(parent) || QDELETED(parent))
		return FALSE
	var/datum/component/rpg_journal/journal = get_journal()
	points += amount
	journal.rpg_experience += amount
	var/previous_level = journal.rpg_level
	while(journal.rpg_experience >= journal.rpg_next_level_experience)
		journal.rpg_experience -= journal.rpg_next_level_experience
		journal.rpg_level++
		journal.rpg_attribute_points++
		if(!(journal.rpg_level % 2))
			journal.rpg_skill_points++
		if(!(journal.rpg_level % 3))
			journal.rpg_trait_points++
		journal.rpg_next_level_experience = CEILING(journal.rpg_next_level_experience * 6 / 5, 1)
	if(journal.rpg_level > previous_level)
		var/attribute_gain = journal.rpg_level - previous_level
		var/skill_gain = FLOOR(journal.rpg_level / 2, 1) - FLOOR(previous_level / 2, 1)
		var/trait_gain = FLOOR(journal.rpg_level / 3, 1) - FLOOR(previous_level / 3, 1)
		to_chat(parent, span_nicegreen("【系统成长】升至 [journal.rpg_level] 级，获得 [attribute_gain] 属性点、[skill_gain] 技能点、[trait_gain] 特性点。"))
	SStgui.update_uis(src)
	return TRUE

/datum/component/rpg_system/proc/currency_balance(currency)
	if(currency == "points")
		return points
	var/datum/component/rpg_journal/journal = get_journal()
	switch(currency)
		if("attribute_points")
			return journal.rpg_attribute_points
		if("skill_points")
			return journal.rpg_skill_points
		if("trait_points")
			return journal.rpg_trait_points
	return 0

/proc/z121_rpg_currency_name(currency)
	switch(currency)
		if("attribute_points")
			return "属性点"
		if("skill_points")
			return "技能点"
		if("trait_points")
			return "特性点"
	return "积分"
