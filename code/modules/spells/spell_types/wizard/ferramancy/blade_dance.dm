#define BLADE_DANCE_RADIUS 1
#define BLADE_DANCE_DURATION 10 SECONDS
#define BLADE_DANCE_TICK_DAMAGE 20

/datum/action/cooldown/spell/blade_dance
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	name = "剑刃之舞"
	expose_caster_on_deflect = FALSE
	desc = "以旋转的奥术剑刃风暴包裹自身，随身移动，斩击相邻格的一切。\n\n\
	持续 10 秒，每秒对相邻格所有目标造成 20 点物理伤害。"
	button_icon_state = "blade_dance"
	sound = 'sound/magic/scrapeblade.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_FERRAMANCY

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("群刃，起舞！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/obj/effect/blade_dance_zone/active_zone

/datum/action/cooldown/spell/blade_dance/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("伤害：每秒 [BLADE_DANCE_TICK_DAMAGE] 点物理伤害（最多持续 [DisplayTimeText(BLADE_DANCE_DURATION)]）")
	return stats

/datum/action/cooldown/spell/blade_dance/Destroy()
	if(active_zone && !QDELETED(active_zone))
		qdel(active_zone)
	active_zone = null
	return ..()

/datum/action/cooldown/spell/blade_dance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.visible_message(span_boldwarning("[H]被旋转的幽影剑刃风暴吞没！"))
	active_zone = new(get_turf(H), H, src)
	return TRUE

// --- The persistent blade storm, carried by the caster ---

/obj/effect/blade_dance_zone
	name = "剑刃之舞"
	desc = "幽影剑刃构成的旋转漩涡！"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	light_outer_range = 2
	light_color = GLOW_COLOR_METAL
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/mob/living/carbon/human/caster
	var/datum/action/cooldown/spell/blade_dance/source_spell
	var/ticks_remaining
	var/tick_damage = BLADE_DANCE_TICK_DAMAGE
	var/effect_radius = BLADE_DANCE_RADIUS
	var/list/blade_visuals = list()

/obj/effect/blade_dance_zone/Initialize(mapload, mob/living/carbon/human/summoner, datum/action/cooldown/spell/blade_dance/spell_ref)
	. = ..()
	caster = summoner
	source_spell = spell_ref
	ticks_remaining = BLADE_DANCE_DURATION / (1 SECONDS)
	if(caster)
		forceMove(get_turf(caster))
		RegisterSignal(caster, COMSIG_MOVABLE_MOVED, PROC_REF(follow_caster))
	INVOKE_ASYNC(src, PROC_REF(setup_visuals))
	playsound(src, 'sound/magic/scrapeblade.ogg', 80, TRUE, 6)
	START_PROCESSING(SSprocessing, src)
	QDEL_IN(src, BLADE_DANCE_DURATION + 1 SECONDS)

/obj/effect/blade_dance_zone/Destroy()
	if(caster)
		UnregisterSignal(caster, COMSIG_MOVABLE_MOVED)
	if(source_spell)
		source_spell.active_zone = null
	source_spell = null
	caster = null
	QDEL_LIST(blade_visuals)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/blade_dance_zone/proc/follow_caster()
	SIGNAL_HANDLER
	var/turf/dest = get_turf(caster)
	if(dest)
		forceMove(dest)

// Daggers ride in vis_contents so they orbit the storm and follow it as it moves.
/obj/effect/blade_dance_zone/proc/setup_visuals()
	for(var/dx in -effect_radius to effect_radius)
		for(var/dy in -effect_radius to effect_radius)
			if(dx == 0 && dy == 0)
				continue
			var/obj/effect/temp_visual/spinning_dagger/D = new(null, BLADE_DANCE_DURATION + 2 SECONDS, FALSE)
			D.pixel_x = dx * 32
			D.pixel_y = dy * 32
			blade_visuals += D
			vis_contents += D
			D.start_spinning()

/obj/effect/blade_dance_zone/process(delta_time)
	if(ticks_remaining <= 0 || QDELETED(caster) || caster.stat != CONSCIOUS)
		qdel(src)
		return

	if(caster.IsKnockdown() || caster.IsStun() || caster.IsParalyzed() || caster.has_status_effect(/datum/status_effect/debuff/cast_disrupted))
		caster.visible_message(span_boldwarning("[caster]的剑刃风暴散开了！"), span_warning("我的剑刃之舞被打断了！"))
		qdel(src)
		return

	ticks_remaining--
	playsound(src, pick('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg'), 60, TRUE)

	var/turf/center = get_turf(src)
	for(var/turf/T in range(effect_radius, center))
		if(T == center)
			continue
		for(var/mob/living/L in T.contents)
			if(L == caster)
				continue
			if(L.anti_magic_check())
				continue
			if(source_spell?.spell_guard_check(L, FALSE, caster))
				qdel(src)
				return
			if(ishuman(L) && ishuman(caster))
				var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
				if(arcyne_strike(caster, L, null, tick_damage, target_zone, \
					BCLASS_CUT, spell_name = "剑刃之舞", \
					damage_type = BRUTE, \
					skip_animation = TRUE, skip_message = TRUE, \
					allow_shield_check = TRUE) == ARCYNE_STRIKE_WARDED)
					continue
			else
				L.adjustBruteLoss(tick_damage)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_METAL, SPELL_IMPACT_MEDIUM)

#undef BLADE_DANCE_RADIUS
#undef BLADE_DANCE_DURATION
#undef BLADE_DANCE_TICK_DAMAGE

/obj/effect/temp_visual/spinning_dagger
	name = "旋转刀刃"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "tempest_blade"
	duration = 1 SECONDS
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	randomdir = FALSE

/obj/effect/temp_visual/spinning_dagger/Initialize(mapload, custom_duration, start_spin = TRUE)
	if(custom_duration)
		duration = custom_duration
	. = ..()
	if(start_spin)
		SpinAnimation(5, -1, pick(TRUE, FALSE))

/obj/effect/temp_visual/spinning_dagger/proc/start_spinning()
	SpinAnimation(5, -1, pick(TRUE, FALSE))
