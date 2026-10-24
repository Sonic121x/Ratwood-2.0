/datum/action/cooldown/spell/grasp_of_psydon
	source_aspect = /datum/magic_aspect/pseudo/spellfist
	button_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	button_icon_state = "grasp_of_psydon"
	name = "普赛顿之握"
	expose_caster_on_deflect = FALSE
	desc = "张掌向前猛推，向同层最远 4 步外的区域放出奥术力能触须。短暂预兆后，区域内所有目标都会被拉向你。\
		动量达到 3 点时：消耗 3 点，对每个被拉扯目标的瞄准部位造成 40 点钝击伤害。\n\n\
		『伸出手，打开通路，想象凭祂的意志将渴求的人或物握于掌中，随后收手。关闭通路并握拳，稍稍前推，再度打开通路，你便能隔空攫住敌人，将其拉到身边。』"
	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW

	cast_range = 5

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE

	invocations = list("握！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = 0.5 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/area_of_effect = 1
	var/pull_distance = 7
	var/telegraph_delay = 0.8 SECONDS
	var/base_damage = 15
	var/empowered_damage = 40
	var/momentum_cost = 3

/datum/action/cooldown/spell/grasp_of_psydon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE

	var/turf/caster_turf = get_turf(H)
	if(T.z != caster_turf.z)
		to_chat(H, span_warning("触须无法跨越层面！"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("释放 [momentum_cost] 点动量——强化擒握！"))

	H.emote("attack", forced = TRUE)

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(affected_turf.density)
			continue
		new /obj/effect/temp_visual/grasp_telegraph(affected_turf)

	playsound(T, 'sound/magic/webspin.ogg', 50, TRUE)

	addtimer(CALLBACK(src, PROC_REF(resolve_grasp), H, T, empowered), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/grasp_of_psydon/proc/resolve_grasp(mob/living/carbon/human/H, turf/center, empowered = FALSE)
	if(QDELETED(H) || H.stat == DEAD)
		return

	var/turf/caster_turf = get_turf(H)
	playsound(center, 'sound/combat/grabbreak.ogg', 80, TRUE)

	var/hit_count = 0
	for(var/mob/living/victim in range(area_of_effect, center))
		if(victim == H || victim.stat == DEAD)
			continue
		if(victim.anti_magic_check())
			victim.visible_message(span_warning("力能触须似乎无法攫住[victim]！"))
			playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(victim, TRUE))
			victim.visible_message(span_warning("[victim]挣脱了触须！"))
			continue
		var/def_zone = H.zone_selected || BODY_ZONE_CHEST
		if(arcyne_strike(H, victim, null, base_damage, def_zone, BCLASS_BLUNT, spell_name = "普赛顿之握") == ARCYNE_STRIKE_WARDED)
			continue
		if(empowered)
			if(arcyne_strike(H, victim, null, empowered_damage, def_zone, BCLASS_BLUNT, spell_name = "普赛顿之握（强化）") == ARCYNE_STRIKE_WARDED)
				continue
		victim.throw_at(caster_turf, pull_distance, 4)

		victim.visible_message(span_warning("[victim]被奥术触须拽向[H]！"))
		new /obj/effect/temp_visual/grasp_telegraph/long(get_turf(victim))
		hit_count++

	if(hit_count)
		H.visible_message(span_danger("[H]握紧[H.p_their()]的拳头，将[hit_count > 1 ? "众敌" : "一名敌人"]拉向[H.p_them()]！"))

	log_combat(H, null, "使用了 [name][empowered ? "（强化）" : ""]")

/obj/effect/temp_visual/grasp_telegraph
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	duration = 1 SECONDS

/obj/effect/temp_visual/grasp_telegraph/long
	duration = 2 SECONDS
