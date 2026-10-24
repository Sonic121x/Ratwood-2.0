/datum/action/cooldown/spell/cataclysm
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "灾变"
	expose_caster_on_deflect = FALSE
	desc = "让山岳崩落。召出纯粹奥术之力构成的巨锤，掷向目标区域。\
		撞击时爆发，碾压 5x5 区域内所有人，造成 75 点钝击伤害并使其易伤。\
		需要 7 点动量。10 点动量时过载：135 点伤害。\
		仅限同一层。可被防御姿态格挡。"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "cataclysm"
	sound = 'sound/combat/ground_smash1.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_ULT

	invocations = list()
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_MAJOR
	hold_drain = 1
	charge_slowdown = 1
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/delay = 10
	var/damage = 75
	var/bonus_damage = 60
	var/area_of_effect = 2
	var/min_momentum = 7
	var/empowered_momentum = 10
	var/vulnerable_duration = 6 SECONDS

/datum/action/cooldown/spell/cataclysm/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/cataclysm/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("我必须握住绑定武器！"))
		return FALSE

	var/turf/T = get_turf(cast_on)
	var/turf/start = get_turf(H)

	if(!T)
		to_chat(H, span_warning("无效目标！"))
		return FALSE

	if(T.density)
		to_chat(H, span_warning("我不能把巨锤掷入实心地面！"))
		return FALSE

	if(T.z != start.z)
		to_chat(H, span_warning("太远了——我必须处于同一层！"))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("动量不足！至少需要 [min_momentum] 层！"))
		return FALSE

	var/stacks = M.stacks
	var/empowered = stacks >= empowered_momentum
	var/final_damage = damage + (empowered ? bonus_damage : 0)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	M.consume_all_stacks()
	to_chat(H, span_notice("释放全部 [stacks] 点动量——灾变[empowered ? "全面强化" : "爆发"]！"))

	H.say("苍穹崩塌！", forced = "spell", language = /datum/language/common)

	playsound(start, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)
	H.visible_message(span_boldwarning("[H]用奥术之力召出一柄巨锤！"))

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/telegraph/blade_storm(affected_turf)

	log_combat(H, cast_on, "used Cataclysm on", zone=H.zone_selected)

	addtimer(CALLBACK(src, PROC_REF(do_hammer_throw), H, held_weapon, T, final_damage, def_zone, empowered), delay)
	. = ..()

/datum/action/cooldown/spell/cataclysm/proc/do_hammer_throw(mob/living/carbon/human/user, obj/item/weapon, turf/dest, final_damage, def_zone, empowered)
	if(QDELETED(user) || user.stat == DEAD)
		return

	user.visible_message(span_boldwarning("[user]掷出巨锤，瞄准[span_combatsecondarybp(parse_zone(def_zone))]！"))
	playsound(get_turf(user), 'sound/combat/shieldraise.ogg', 100)
	var/obj/effect/temp_visual/cataclysm_boulder/boulder = new(get_turf(user))
	var/dx = (dest.x - user.x) * 32
	var/dy = (dest.y - user.y) * 32
	animate(boulder, pixel_x = dx, pixel_y = dy, time = 4)
	var/matrix/q1 = matrix()
	q1.Turn(90)
	animate(boulder, transform = q1, time = 1, flags = ANIMATION_PARALLEL)
	var/matrix/q2 = matrix()
	q2.Turn(180)
	animate(transform = q2, time = 1)
	var/matrix/q3 = matrix()
	q3.Turn(270)
	animate(transform = q3, time = 1)
	animate(transform = matrix(), time = 1)

	addtimer(CALLBACK(src, PROC_REF(do_hammer_impact), user, weapon, dest, final_damage, def_zone, empowered, boulder), 4)

/datum/action/cooldown/spell/cataclysm/proc/do_hammer_impact(mob/living/carbon/human/user, obj/item/weapon, turf/dest, final_damage, def_zone, empowered, obj/effect/temp_visual/cataclysm_boulder/boulder)
	if(!QDELETED(boulder))
		qdel(boulder)

	playsound(dest, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)

	for(var/turf/affected_turf in get_hear(area_of_effect, dest))
		new /obj/effect/temp_visual/kinetic_blast(affected_turf)
		for(var/mob/living/L in affected_turf.contents)
			if(L == user || L.stat == DEAD)
				continue
			if(L.anti_magic_check())
				L.visible_message(span_warning("巨锤在[L]周围碎裂！"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L]承受住了冲击！"))
				continue
			if(empowered)
				arcyne_strike(user, L, weapon, round(final_damage / 2), def_zone, BCLASS_BLUNT, spell_name = "灾变", skip_message = TRUE)
				arcyne_strike(user, L, weapon, round(final_damage / 2), def_zone, BCLASS_BLUNT, spell_name = "灾变")
			else
				arcyne_strike(user, L, weapon, final_damage, def_zone, BCLASS_BLUNT, spell_name = "灾变")
			L.apply_status_effect(/datum/status_effect/debuff/vulnerable, vulnerable_duration)
			playsound(affected_turf, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 60, TRUE)

/obj/effect/temp_visual/cataclysm_boulder
	icon = 'icons/roguetown/weapons/blunt32.dmi'
	icon_state = "iwarhammer"
	name = "奥术巨锤"
	desc = "一柄由纯粹奥术之力构成的巨锤。"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 8
