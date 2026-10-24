// 只适配新版实际存在的攻击动作；旧气化、刃爆和瞬凝不再定义。
/datum/action/cooldown/spell/z121/invoked/pain
	z121_serpent_offensive = TRUE

/datum/action/cooldown/spell/gravity
	z121_serpent_offensive = TRUE

/datum/action/cooldown/spell/wither
	z121_serpent_offensive = TRUE

/datum/action/cooldown/spell/fulmination
	z121_serpent_offensive = TRUE

/datum/action/cooldown/spell/ultio
	z121_serpent_offensive = TRUE

// 延迟回调保留当次来源，只调用一次原生效果；离腹或宿主免疫则不产生内部命中。
/datum/z121_serpent_cast/proc/resolve_native(datum/action/cooldown/spell/spell, effect_proc, list/extra_args, as_line = FALSE)
	var/mob/living/target = host()
	if(!target || blocks(target) || QDELETED(spell) || spell.owner != caster_ref.resolve())
		return
	var/turf/center = get_turf(target)
	var/list/arguments = list(as_line ? list(center) : center)
	if(extra_args)
		arguments += extra_args
	var/datum/z121_serpent_cast/previous = spell.z121_serpent_cast
	spell.z121_serpent_cast = src
	call(spell, effect_proc)(arglist(arguments))
	if(!QDELETED(spell))
		spell.z121_serpent_cast = previous

/datum/action/cooldown/spell/gravity/cast(atom/cast_on)
	if(!z121_serpent_cast)
		return ..()
	z121_serpent_notify_cast(cast_on)
	new /obj/effect/temp_visual/gravity_trap(get_turf(cast_on))
	addtimer(CALLBACK(z121_serpent_cast, TYPE_PROC_REF(/datum/z121_serpent_cast, resolve_native), src, PROC_REF(gravity_crush)), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/wither/cast(atom/cast_on)
	if(!z121_serpent_cast)
		return ..()
	z121_serpent_notify_cast(cast_on)
	new /obj/effect/temp_visual/telegraph/wither_line(get_turf(cast_on), strike_delay)
	addtimer(CALLBACK(z121_serpent_cast, TYPE_PROC_REF(/datum/z121_serpent_cast, resolve_native), src, PROC_REF(strike_line), null, TRUE), strike_delay)
	return TRUE

/datum/action/cooldown/spell/fulmination/cast(atom/cast_on)
	if(!z121_serpent_cast)
		return ..()
	z121_serpent_notify_cast(cast_on)
	var/delay = current_mode == 1 ? hs_telegraph : ts_telegraph
	new /obj/effect/temp_visual/telegraph/thunderstrike(get_turf(cast_on), delay)
	if(current_mode == 1)
		addtimer(CALLBACK(z121_serpent_cast, TYPE_PROC_REF(/datum/z121_serpent_cast, resolve_native), src, PROC_REF(heavens_strike_damage)), delay)
	else
		addtimer(CALLBACK(z121_serpent_cast, TYPE_PROC_REF(/datum/z121_serpent_cast, resolve_thunder), src, ts_radius, ts_damage), delay)
	return TRUE

/datum/z121_serpent_cast/proc/resolve_thunder(datum/action/cooldown/spell/spell, radius, damage)
	var/mob/living/target = host()
	var/mob/living/caster = caster_ref.resolve()
	if(!target || blocks(target) || QDELETED(spell) || spell.owner != caster)
		return
	thunderstrike_erupt(get_turf(target), caster, radius, damage, spell, spell.name)

/datum/action/cooldown/spell/ultio/cast(atom/cast_on)
	if(!z121_serpent_cast)
		return ..()
	z121_serpent_notify_cast(cast_on)
	new /obj/effect/temp_visual/telegraph/wall/fire/ultio(get_turf(cast_on))
	addtimer(CALLBACK(z121_serpent_cast, TYPE_PROC_REF(/datum/z121_serpent_cast, resolve_native), src, PROC_REF(detonate), list(owner.zone_selected || BODY_ZONE_CHEST)), impact_delay)
	return TRUE

// 新版炼铁打击保留原生蓄势、伤害与命中去重，只将第一段攻击对准宿主。
/datum/action/cooldown/spell/ferramancy_strike
	z121_serpent_offensive = TRUE
	var/datum/z121_serpent_cast/z121_pattern_context
	var/z121_resolving_pattern = FALSE

/datum/action/cooldown/spell/ferramancy_strike/can_cast_spell(feedback = TRUE)
	if(z121_pattern_context)
		return FALSE
	return ..()

/datum/action/cooldown/spell/ferramancy_strike/windup_and_strike(mob/living/H, atom/cast_on)
	z121_pattern_context = z121_serpent_cast
	. = ..()
	if(!QDELETED(src) && !z121_resolving_pattern)
		z121_pattern_context = null

/datum/action/cooldown/spell/ferramancy_strike/execute_hits(mob/living/H, facing, list/indicator, atom/movable/visual)
	z121_resolving_pattern = TRUE
	. = ..()
	if(!QDELETED(src))
		z121_resolving_pattern = FALSE
		z121_pattern_context = null

/datum/action/cooldown/spell/ferramancy_strike/get_pattern_origin(mob/living/H)
	if(!z121_pattern_context)
		return ..()
	var/mob/living/host = z121_pattern_context.host()
	var/turf/center = get_turf(host)
	if(!center)
		return null
	var/list/offsets = get_pattern_offsets()
	if(!length(offsets))
		return center
	var/list/first = offsets[1]
	var/list/rotated = rotate_offset(first[1], first[2], get_cardinal(H.dir))
	return locate(center.x - rotated[1], center.y - rotated[2], center.z)

/datum/action/cooldown/spell/ferramancy_strike/can_strike_victim(mob/living/H, mob/living/L)
	if(z121_pattern_context)
		return L == z121_pattern_context.host() && !z121_pattern_context.blocks(L) && ..()
	return ..()

// 龙焰术的地面模式使用原生火柱效果，延迟期间继续核验宿主和施法来源。
/datum/action/cooldown/spell/projectile/fireball/barrage/fire_projectile(atom/target)
	if(!z121_serpent_cast || !modes[current_mode]["ground"])
		return ..()
	var/turf/center = get_turf(target)
	if(!center)
		return FALSE
	for(var/turf/T in range(pillar_radius, center))
		new /obj/effect/temp_visual/telegraph/pillar/fadein(T, pillar_delay)
	playsound(center, 'sound/magic/charging_fire.ogg', 80, TRUE)
	addtimer(CALLBACK(z121_serpent_cast, TYPE_PROC_REF(/datum/z121_serpent_cast, resolve_pillar), src, pillar_radius, pillar_damage, owner.zone_selected), pillar_delay)
	return TRUE

/datum/z121_serpent_cast/proc/resolve_pillar(datum/action/cooldown/spell/spell, radius, damage, aim_zone)
	var/mob/living/target = host()
	var/mob/living/carbon/human/caster = caster_ref.resolve()
	if(!target || blocks(target) || QDELETED(spell) || spell.owner != caster)
		return
	pillar_of_flame_erupt(get_turf(target), caster, radius, damage, aim_zone)

// 薄冰术只铺设新版冰面，不恢复旧瞬凝的伤害或冻结特判。
/datum/action/cooldown/spell/verglas
	z121_serpent_offensive = TRUE

/datum/action/cooldown/spell/verglas/cast(atom/cast_on)
	if(!z121_serpent_cast)
		return ..()
	var/mob/living/carbon/human/caster = owner
	var/mob/living/host = z121_serpent_cast.host()
	if(!istype(caster) || !host || z121_serpent_cast.blocks(host))
		return FALSE
	// 新版模式顺序为铺冰、固守、滑行；腹内没有可供施法者滑行的地面。
	if(verglas_mode != 1)
		if(caster.has_status_effect(/datum/status_effect/verglas_concentration))
			caster.remove_status_effect(/datum/status_effect/verglas_concentration)
			return FALSE
		if(caster.has_status_effect(/datum/status_effect/verglas_concentration/skate))
			caster.remove_status_effect(/datum/status_effect/verglas_concentration/skate)
			return FALSE
	if(verglas_mode == 3)
		to_chat(caster, span_warning("身处腹内，无法踏冰滑行。"))
		return FALSE
	var/turf/center = get_turf(host)
	var/hold = verglas_mode == 2
	var/list/tiles = list()
	z121_serpent_notify_cast(host)
	playsound(center, 'sound/spellbooks/crystal.ogg', 80, TRUE)
	for(var/turf/T in get_hear(verglas_radius, center))
		if(T.density || istype(T, /turf/open/water) || (locate(/obj/effect/verglas) in T))
			continue
		tiles += new /obj/effect/verglas(T, hold ? 0 : 15 SECONDS)
	if(hold && length(tiles))
		caster.apply_status_effect(/datum/status_effect/verglas_concentration, tiles, center)
	return TRUE
