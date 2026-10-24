/datum/action/cooldown/spell/air_strike
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "隔空击"
	desc = "你的利刃遁入无形，由地脉向前传送，攻击最远 4 格外的目标。\
	打击落下前有短暂预兆——瞄准敌人将要到达的位置。\
	动量达到 3 点时：消耗 3 点，使伤害翻倍。\
	攻击瞄准的身体部位，并随攻击意图变化：\
		- 劈砍：横向 3x1 区域，可命中多个目标。（30/60 伤害）\
		- 突刺：向前 3x1 直线，贯穿敌人。（20/40 伤害，轻度穿甲）\
		- 钝击：全部力量集中于单一目标。（45/90 伤害）"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "air_strike"
	sound = 'sound/combat/wooshes/bladed/wooshsmall (1).ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 4

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_POKE

	invocations = list("风之击！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = 1
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/cut_damage = 30
	var/stab_damage = 20
	var/stab_ap = PEN_LIGHT
	var/blunt_damage = 45
	var/empowered_mult = 2
	var/momentum_cost = 3

/datum/action/cooldown/spell/air_strike/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("我必须握住绑定武器！"))
		return FALSE

	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("释放 [momentum_cost] 点动量——强化打击！"))

	var/facing = get_dir(get_turf(H), target_turf) || H.dir
	var/datum/intent/current_intent = H.a_intent
	var/blade_class = current_intent?.blade_class || BCLASS_CUT

	switch(blade_class)
		if(BCLASS_STAB, BCLASS_PICK)
			do_stab_strike(H, held_weapon, empowered, target_turf, facing)
		if(BCLASS_BLUNT, BCLASS_SMASH)
			do_blunt_strike(H, held_weapon, empowered, target_turf)
		else
			do_cut_strike(H, held_weapon, empowered, target_turf, facing)

	return TRUE

/datum/action/cooldown/spell/air_strike/proc/do_cut_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, turf/origin, facing)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? (cut_damage * empowered_mult) : cut_damage

	var/list/affected_turfs = get_perpendicular_line(origin, facing)

	for(var/turf/T in affected_turfs)
		new /obj/effect/temp_visual/telegraph/air_strike(T)

	addtimer(CALLBACK(src, PROC_REF(resolve_cut_strike), H, weapon, empowered, affected_turfs, damage, def_zone, facing), 2)

/datum/action/cooldown/spell/air_strike/proc/resolve_cut_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, list/affected_turfs, damage, def_zone, facing)
	if(QDELETED(H) || H.stat == DEAD)
		return

	for(var/turf/T in affected_turfs)
		var/obj/effect/temp_visual/blade_cut/V = new(T)
		V.dir = facing
	playsound(affected_turfs[1], pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 80, TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	for(var/turf/T in affected_turfs)
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, H, punish_caster = deflected ? FALSE : null))
				deflected = TRUE
				continue
			if(empowered)
				arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_CUT, spell_name = "隔空击（劈砍）", skip_message = TRUE)
				arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_CUT, spell_name = "隔空击（劈砍）")
			else
				arcyne_strike(H, victim, weapon, damage, def_zone, BCLASS_CUT, spell_name = "隔空击（劈砍）")
			hit_count++

	if(hit_count)
		H.visible_message(span_danger("[H]挥动[weapon.name]，扫出宽阔的奥术弧光！"))
	else
		H.visible_message(span_notice("[H]挥动[weapon.name]扫过空气！"))
	if(hit_count >= 2)
		var/datum/status_effect/buff/arcyne_momentum/surge = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(surge)
			surge.add_stacks(1)
			to_chat(H, span_notice("双重打击！奥术涌动！"))

/datum/action/cooldown/spell/air_strike/proc/do_stab_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, turf/origin, facing)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? (stab_damage * empowered_mult) : stab_damage

	var/list/affected_turfs = get_forward_line(origin, facing, 3)

	for(var/turf/T in affected_turfs)
		new /obj/effect/temp_visual/telegraph/air_strike(T)

	addtimer(CALLBACK(src, PROC_REF(resolve_stab_strike), H, weapon, empowered, affected_turfs, damage, def_zone, facing), 2)

/datum/action/cooldown/spell/air_strike/proc/resolve_stab_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, list/affected_turfs, damage, def_zone, facing)
	if(QDELETED(H) || H.stat == DEAD)
		return

	for(var/turf/T in affected_turfs)
		var/obj/effect/temp_visual/blade_burst/V = new(T)
		V.dir = facing
	playsound(affected_turfs[1], pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 80, TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	for(var/turf/T in affected_turfs)
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, H, punish_caster = deflected ? FALSE : null))
				deflected = TRUE
				continue
			if(empowered)
				arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_STAB, armor_penetration = stab_ap, spell_name = "隔空击（突刺）", skip_message = TRUE)
				arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_STAB, armor_penetration = stab_ap, spell_name = "隔空击（突刺）")
			else
				arcyne_strike(H, victim, weapon, damage, def_zone, BCLASS_STAB, armor_penetration = stab_ap, spell_name = "隔空击（突刺）")
			hit_count++

	if(hit_count)
		H.visible_message(span_danger("[H]将[weapon.name]向前刺出，一道奥术长枪破空而去！"))
	else
		H.visible_message(span_notice("[H]将[weapon.name]向前刺出，一道奥术长枪划过空处！"))
	if(hit_count >= 2)
		var/datum/status_effect/buff/arcyne_momentum/surge = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(surge)
			surge.add_stacks(1)
			to_chat(H, span_notice("双重打击！奥术涌动！"))

/datum/action/cooldown/spell/air_strike/proc/do_blunt_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, turf/origin)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? (blunt_damage * empowered_mult) : blunt_damage

	new /obj/effect/temp_visual/telegraph/air_strike(origin)

	addtimer(CALLBACK(src, PROC_REF(resolve_blunt_strike), H, weapon, empowered, origin, damage, def_zone), 2)

/datum/action/cooldown/spell/air_strike/proc/resolve_blunt_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, turf/origin, damage, def_zone)
	if(QDELETED(H) || H.stat == DEAD)
		return

	new /obj/effect/temp_visual/kinetic_blast(origin)
	playsound(origin, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 80, TRUE)

	var/mob/living/victim = null
	for(var/mob/living/L in origin)
		if(L == H || L.stat == DEAD)
			continue
		victim = L
		break

	if(!victim)
		H.visible_message(span_notice("[H]将[weapon.name]猛砸而下，震波冲入地面！"))
		return

	if(spell_guard_check(victim, FALSE, H))
		return

	if(empowered)
		arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_BLUNT, spell_name = "隔空击（钝击）", skip_message = TRUE)
		arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_BLUNT, spell_name = "隔空击（钝击）")
	else
		arcyne_strike(H, victim, weapon, damage, def_zone, BCLASS_BLUNT, spell_name = "隔空击（钝击）")
	H.visible_message(span_danger("[H]将[weapon.name]猛砸而下，把全部奥术力量集中于[victim]！"))

/datum/action/cooldown/spell/air_strike/proc/get_perpendicular_line(turf/center, facing)
	var/list/turfs = list()
	turfs += center
	var/perp_dir1
	var/perp_dir2
	if(facing == NORTH || facing == SOUTH)
		perp_dir1 = WEST
		perp_dir2 = EAST
	else
		perp_dir1 = NORTH
		perp_dir2 = SOUTH
	var/turf/left = get_step(center, perp_dir1)
	var/turf/right = get_step(center, perp_dir2)
	if(left) turfs += left
	if(right) turfs += right
	return turfs

/datum/action/cooldown/spell/air_strike/proc/get_forward_line(turf/center, facing, length = 3)
	var/list/turfs = list()
	turfs += center
	var/turf/current = center
	for(var/i in 1 to (length - 1))
		current = get_step(current, facing)
		if(!current)
			break
		turfs += current
	return turfs

/obj/effect/temp_visual/telegraph/air_strike
	light_outer_range = 1
	duration = 3

/obj/effect/temp_visual/arcyne_strike_fx
	icon = 'icons/effects/effects.dmi'
	icon_state = "strike"
	duration = 5
	layer = MASSIVE_OBJ_LAYER
