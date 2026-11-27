/mob/living
	var/z121_spell_charge_multiplier = 1
	var/z121_spell_silent_cast = FALSE
	var/z121_spell_damage_multiplier = 1
	/// 奥术使用 energy 支付的消耗倍率，体力仍由法术自身结算。
	var/z121_spell_cost_multiplier = 1

/mob/living/proc/z121_update_casting_factors()
	var/datum/component/z121_casting_factors/factors = GetComponent(/datum/component/z121_casting_factors)
	if(!length(z121_active_metamagic) && z121_spell_charge_multiplier == 1 && !z121_spell_silent_cast && z121_spell_damage_multiplier == 1 && z121_spell_cost_multiplier == 1)
		if(factors)
			qdel(factors)
	else if(factors)
		factors.refresh()
	else
		AddComponent(/datum/component/z121_casting_factors)

// 只在启用 VV 因数或超魔的身体上监听。法术被移除或转交时归还原实例参数。
/datum/component/z121_casting_factors
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/spells_by_action = list()
	var/turf/firing_turf

/datum/component/z121_casting_factors/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/z121_casting_factors/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(discover_actions))
	RegisterSignal(parent, COMSIG_MOB_SPELL_ACTIVATED, PROC_REF(on_spell_selected))
	RegisterSignal(parent, COMSIG_MOB_BEFORE_SPELL_CAST, PROC_REF(on_spell_selected))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(track_firing_turf))
	refresh()

/datum/component/z121_casting_factors/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_LIFE, COMSIG_MOB_SPELL_ACTIVATED, COMSIG_MOB_BEFORE_SPELL_CAST, COMSIG_MOVABLE_MOVED))
	clear_spells()

/datum/component/z121_casting_factors/Destroy(force = FALSE, silent = FALSE)
	clear_spells()
	return ..()

/datum/component/z121_casting_factors/proc/clear_spells()
	if(firing_turf)
		UnregisterSignal(firing_turf, COMSIG_PROJECTILE_BEFORE_FIRE)
		firing_turf = null
	for(var/datum/action/action as anything in spells_by_action.Copy())
		release_action(action)

/datum/component/z121_casting_factors/proc/refresh()
	for(var/datum/action/action as anything in spells_by_action)
		var/datum/z121_spell_settings/settings = spells_by_action[action]
		settings.apply(parent)
	discover_actions()
	track_firing_turf()

/datum/component/z121_casting_factors/proc/discover_actions()
	SIGNAL_HANDLER
	var/mob/living/caster = parent
	for(var/datum/action/action as anything in caster.actions)
		track_action(action)

/datum/component/z121_casting_factors/proc/on_spell_selected(datum/source, datum/action/action)
	SIGNAL_HANDLER
	track_action(action)
	return NONE

/datum/component/z121_casting_factors/proc/track_action(datum/action/action)
	if(QDELETED(action) || action.owner != parent)
		return
	var/datum/z121_spell_settings/settings = spells_by_action[action]
	if(settings)
		settings.sync_mode()
		return
	var/datum/spell = action
	if(istype(action, /datum/action/spell_action))
		spell = action.target
	if(!spell || !GLOB.z121_arcane_spell_types[spell.type])
		return
	if(istype(spell, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/modern = spell
		if(modern.primary_resource_type == SPELL_COST_DEVOTION || modern.secondary_resource_type == SPELL_COST_DEVOTION)
			return
	else
		var/obj/effect/proc_holder/spell/legacy = spell
		if(!istype(legacy) || legacy.miracle)
			return
	settings = new(spell)
	spells_by_action[action] = settings
	RegisterSignal(action, list(COMSIG_ACTION_REMOVED, COMSIG_QDELETING), PROC_REF(release_action))
	settings.apply(parent)

/datum/component/z121_casting_factors/proc/release_action(datum/action/action)
	SIGNAL_HANDLER
	var/datum/z121_spell_settings/settings = spells_by_action[action]
	if(!settings)
		return
	UnregisterSignal(action, list(COMSIG_ACTION_REMOVED, COMSIG_QDELETING))
	spells_by_action -= action
	settings.restore(parent)
	qdel(settings)

/datum/component/z121_casting_factors/proc/track_firing_turf()
	SIGNAL_HANDLER
	var/mob/living/caster = parent
	var/turf/new_turf = caster.z121_effective_damage_multiplier() != 1 ? get_turf(caster) : null
	if(firing_turf == new_turf)
		return
	if(firing_turf)
		UnregisterSignal(firing_turf, COMSIG_PROJECTILE_BEFORE_FIRE)
	firing_turf = new_turf
	if(firing_turf)
		RegisterSignal(firing_turf, COMSIG_PROJECTILE_BEFORE_FIRE, PROC_REF(on_projectile_fired))

/datum/component/z121_casting_factors/proc/on_projectile_fired(turf/source, obj/projectile/projectile)
	SIGNAL_HANDLER
	var/mob/living/caster = parent
	var/datum/action/cooldown/spell/spell = projectile.source_spell
	if(!spell && istype(projectile, /obj/projectile/magic/leyline_arrow))
		var/obj/projectile/magic/leyline_arrow/arrow = projectile
		spell = arrow.spell_ref?.resolve()
	if(projectile.firer != caster || !spell || !GLOB.z121_arcane_spell_types[spell.type])
		return
	if(spell.primary_resource_type == SPELL_COST_DEVOTION || spell.secondary_resource_type == SPELL_COST_DEVOTION)
		return
	var/factor = caster.z121_effective_damage_multiplier()
	if(projectile.damage > 0)
		projectile.damage *= factor
	if(istype(projectile, /obj/projectile/magic/aoe/fireball/rogue))
		var/obj/projectile/magic/aoe/fireball/rogue/fireball = projectile
		fireball.arcyne_aoe_damage *= factor
		fireball.structural_damage *= factor
	if("reduced_damage" in projectile.vars)
		projectile.vars["reduced_damage"] *= factor

// 记录实例当前值，兼容法相变体与管理员对实例的设置。编辑角色 VV 时从原值重算。
/datum/z121_spell_settings
	var/datum/spell
	var/list/original = list()
	var/list/applied = list()
	var/current_mode

/datum/z121_spell_settings/New(datum/spell)
	src.spell = spell
	if(("modes" in spell.vars) && ("current_mode" in spell.vars))
		var/list/modes = spell.vars["modes"]
		var/list/mode = length(modes) ? modes[1] : null
		if(islist(mode) && ("charge" in mode) && ("cost" in mode))
			current_mode = spell.vars["current_mode"]
			RegisterSignal(spell, COMSIG_ACTION_OVERLAY_APPLY, PROC_REF(sync_mode))

// 切换施法模式会由法术自己写入新模式的两项基础值，并更新动作按钮。
/datum/z121_spell_settings/proc/sync_mode()
	SIGNAL_HANDLER
	if(!take_new_mode())
		return
	var/datum/action/cooldown/spell/action = spell
	var/mob/living/caster = action.owner
	if(istype(caster))
		scale("charge_time", get_charge_multiplier(caster))
		if(action.primary_resource_type == SPELL_COST_ENERGY)
			scale("primary_resource_cost", caster.z121_effective_cost_multiplier())

/datum/z121_spell_settings/proc/take_new_mode()
	if(isnull(current_mode) || current_mode == spell.vars["current_mode"])
		return FALSE
	current_mode = spell.vars["current_mode"]
	applied -= list("charge_time", "primary_resource_cost")
	original -= list("charge_time", "primary_resource_cost")
	return TRUE

/datum/z121_spell_settings/proc/set_field(field, new_value)
	original[field] = spell.vars[field]
	applied[field] = new_value
	spell.vars[field] = new_value

/datum/z121_spell_settings/proc/scale(field, multiplier)
	if(multiplier != 1 && (field in spell.vars) && isnum(spell.vars[field]) && spell.vars[field] > 0)
		set_field(field, spell.vars[field] * multiplier)

/datum/z121_spell_settings/proc/get_charge_multiplier(mob/living/caster)
	// 焚天灾火的蓄力、咏唱和地面预警均沿用法术自身的时长。
	if(istype(spell, /datum/action/cooldown/spell/projectile/pyroclasm))
		return 1
	return caster.z121_effective_charge_multiplier()

/datum/z121_spell_settings/proc/restore(mob/living/caster)
	if(!QDELETED(spell))
		take_new_mode()
		for(var/field in applied)
			if(spell.vars[field] == applied[field])
				spell.vars[field] = original[field]
		update_legacy_intent(caster)
	applied.Cut()
	original.Cut()

/datum/z121_spell_settings/proc/apply(mob/living/caster)
	restore(caster)
	if(QDELETED(spell))
		return
	if(caster.z121_effective_silent_cast())
		if(spell.vars["invocation_type"] in list(INVOCATION_SHOUT, INVOCATION_WHISPER))
			set_field("invocation_type", INVOCATION_NONE)
		for(var/field in list("dismiss_invocation", "regen_invocation", "barrage_invocation"))
			if((field in spell.vars) && spell.vars[field])
				set_field(field, null)
	var/charge_multiplier = get_charge_multiplier(caster)
	var/damage_multiplier = caster.z121_effective_damage_multiplier()
	if(istype(spell, /obj/effect/proc_holder/spell))
		scale("chargetime", charge_multiplier)
		if(istype(spell, /obj/effect/proc_holder/spell/invoked/projectile) && damage_multiplier != 1)
			var/obj/effect/proc_holder/spell/invoked/projectile/legacy = spell
			var/list/overrides = legacy.projectile_var_overrides.Copy()
			var/damage = ("damage" in overrides) ? overrides["damage"] : initial(legacy.projectile_type.damage)
			if(damage > 0)
				overrides["damage"] = damage * damage_multiplier
				set_field("projectile_var_overrides", overrides)
		update_legacy_intent(caster)
		return
	var/datum/action/cooldown/spell/action = spell
	scale("charge_time", charge_multiplier)
	scale("chant_time", charge_multiplier)
	if(istype(action, /datum/action/cooldown/spell/augment_buff/grasp))
		scale("channel_time", charge_multiplier)
	var/cost_multiplier = caster.z121_effective_cost_multiplier()
	if(action.primary_resource_type == SPELL_COST_ENERGY)
		scale("primary_resource_cost", cost_multiplier)
		scale("hold_drain", cost_multiplier)
	if(action.secondary_resource_type == SPELL_COST_ENERGY)
		scale("secondary_resource_cost", cost_multiplier)
	if(damage_multiplier != 1)
		// 这些实例字段直接提供伤害量。弹体的基础伤害统一在发射信号里处理。
		var/static/list/damage_fields = list(
			"cut_damage", "stab_damage", "blunt_damage", "pierce_damage", "empowered_pierce_damage",
			"strike_damage", "burst_damage", "aoe_damage", "personal_damage", "phantom_damage",
			"crush_damage", "resisted_damage", "hs_damage", "ts_damage", "blast_damage", "beam_damage",
			"pillar_damage", "direct_damage", "splash_damage", "structural_damage", "head_damage",
			"mob_damage", "blast_structural", "barrel_damage", "charge_frag_damage", "crash_structure_damage",
			"heave_damage", "drop_damage", "frag_damage", "fragment_damage",
		)
		for(var/field in damage_fields)
			scale(field, damage_multiplier)
		if(istype(action, /datum/action/cooldown/spell/telegraphed_strike) || istype(action, /datum/action/cooldown/spell/cataclysm) || istype(action, /datum/action/cooldown/spell/thornfall))
			scale("damage", damage_multiplier)
			scale("bonus_damage", damage_multiplier)
			scale("structure_damage", damage_multiplier)
		if(istype(action, /datum/action/cooldown/spell/advance))
			scale("base_damage", damage_multiplier)

/datum/z121_spell_settings/proc/update_legacy_intent(mob/living/caster)
	if(!caster || caster.ranged_ability != spell || !istype(caster.mmb_intent, /datum/intent/spell))
		return
	var/obj/effect/proc_holder/spell/legacy = spell
	caster.mmb_intent.chargetime = legacy.get_chargetime()
