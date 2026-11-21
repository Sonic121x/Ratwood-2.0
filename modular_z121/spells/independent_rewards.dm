// 独立奖励按心智记录，不取得职业删除权，也不占用实用学习额度。
/datum/mind
	var/list/z121_independent_spells = list()
	var/z121_grand_utility_budget = 0

/datum/mind/proc/z121_keep_independent_spell(datum/action/cooldown/spell/S)
	if(QDELETED(S) || !(S in spell_list))
		return
	z121_independent_spells |= S.type
	S.utility_learned = FALSE
	S.source_aspect = null

/datum/magic_aspect/revoke_spells(datum/mind/target, list/skip_spells)
	return ..(target, (skip_spells || list()) | target.z121_independent_spells)

/datum/mind/proc/z121_grand_config(list/config)
	if(!z121_grand_utility_budget)
		return config
	var/list/result = config?.Copy() || list("major" = 0, "minor" = 0)
	result["mastery"] = TRUE
	result["utilities"] = max(result["utilities"] || 0, z121_grand_utility_budget)
	return result

// 改选法相奖励不能删除独立奖励。
/datum/mind/swap_choice_spell(datum/magic_aspect/aspect, new_choice)
	var/previous_choice = aspect?.chosen_spell
	var/keep_previous = aspect && (aspect.resolve_variant_spell(previous_choice) in z121_independent_spells)
	if(keep_previous && previous_choice != new_choice)
		aspect.chosen_spell = null
	. = ..()
	if(!. && keep_previous)
		aspect.chosen_spell = previous_choice

/datum/mind/setup_mage_aspects(list/config, grant_attunement = TRUE)
	return ..(z121_grand_config(config), grant_attunement)
