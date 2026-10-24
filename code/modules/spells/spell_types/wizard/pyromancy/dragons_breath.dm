/datum/action/cooldown/spell/telegraphed_strike/dragons_breath
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "龙息术"
	expose_caster_on_deflect = FALSE
	desc = "向前喷出宽阔锥形烈焰，烧灼沿途一切并击退命中者。\
	蓄势时无法轻易脱身，且会暴露破绽。\n\
	火焰法术施加灼烧：达到 4 层时，会对瞄准的头部或胸部造成穿甲创伤；瞄准其他部位则在头胸之间随机选择。"
	button_icon_state = "fire_blast"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_PYROMANCY

	invocation_type = INVOCATION_SHOUT
	invocations = list("巨龙，吐息！")

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	cooldown_time = 20 SECONDS
	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	damage = 65
	strike_damage_type = BURN
	blade_class = BCLASS_BURN
	committed_strike = TRUE
	interruptible = FALSE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	windup_time = TELEGRAPH_AREA_DENIAL
	sweep_step = 0
	strike_sound = 'sound/magic/fireball.ogg'
	detonate_sound = 'sound/misc/explode/incendiary (1).ogg'

	var/cone_range = 4
	var/cone_half_width = 0
	var/sweep_by_ring = FALSE
	var/ignite_pattern = TRUE
	var/push_dist = 2
	var/scorch_stacks = 1

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/proc/cone_rings()
	var/list/rings = list()
	for(var/d in 1 to cone_range)
		var/list/ring = list()
		var/half = cone_half_width || max(1, round(d / 2))
		for(var/lat in -half to half)
			ring += list(list(lat, d))
		rings += list(ring)
	return rings

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/get_sweep_bands()
	if(sweep_by_ring)
		return cone_rings()
	return list(get_pattern_offsets())

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/get_pattern_offsets()
	var/list/flat = list()
	for(var/list/ring in cone_rings())
		flat += ring
	return flat

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/on_hit_target(mob/living/H, mob/living/L, facing)
	if(scorch_stacks)
		apply_scorch_stack(L, scorch_stacks)
	if(!push_dist)
		return
	var/push_dir = get_dir(H, L)
	if(!push_dir)
		push_dir = facing
	L.safe_throw_at(get_ranged_target_turf(L, push_dir, push_dist), push_dist, 2, H, force = MOVE_FORCE_STRONG)

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/on_impact(mob/living/H, facing, atom/movable/visual)
	if(!ignite_pattern)
		return
	for(var/turf/T in get_pattern_turfs(H, facing))
		new /obj/effect/temp_visual/dragonfire(T)
		for(var/atom/movable/A in T)
			if(ismob(A))
				continue
			A.fire_act()

/obj/effect/temp_visual/dragonfire
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	layer = GASFIRE_LAYER
	light_outer_range = LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	blend_mode = BLEND_ADD
	duration = 8
