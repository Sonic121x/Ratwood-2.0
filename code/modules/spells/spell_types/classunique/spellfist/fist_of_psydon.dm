/datum/action/cooldown/spell/fist_of_psydon
	source_aspect = /datum/magic_aspect/pseudo/spellfist
	button_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	button_icon_state = "fist_of_psydon"
	name = "普赛顿之拳"
	expose_caster_on_deflect = FALSE
	desc = "向下挥拳，让奥术之力轰击最远 5 步外的 3x3 目标区域。\
		打击前有短暂预兆，对瞄准部位造成钝击伤害。\
		动量达到 3 点时：消耗 3 点，使伤害翻倍。\
		可被防御姿态偏转。\n\n\
		『踏前，旋拳出击。出拳时，在心中想象再出同样一拳，打开双臂的奥术通路，关闭双腿的通路，让全身重量汇入一击。最后一刻，再关闭双臂通路，使打击将出未出；如此，便如普赛顿亲自挥拳，助你轰出此击。』"

	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW

	cast_range = 5

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_POKE

	invocations = list("击！") // https://en.wiktionary.org/wiki/%D8%B6%D8%B1%D8%A8 -- "To strike, to beat, to hit" in Arabic
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	associated_skill = /datum/skill/magic/arcane

	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	spell_tier = 2

	var/base_damage = 40
	var/empowered_mult = 2
	var/momentum_cost = 3
	var/area_of_effect = 1 // 1-tile radius = 3x3
	var/telegraph_delay = TELEGRAPH_DODGEABLE

/datum/action/cooldown/spell/fist_of_psydon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE

	// Check and consume momentum for empowerment
	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("释放 [momentum_cost] 点动量——强化打击！"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	// Telegraph on 3x3 area
	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/telegraph/air_strike(affected_turf)
	playsound(T, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 60, TRUE)
	H.emote("attackgrunt", forced = TRUE)

	sleep(telegraph_delay)

	if(QDELETED(H) || H.stat == DEAD)
		return

	// Resolve — visual + damage on 3x3
	var/hit_count = 0
	var/deflected = FALSE
	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/kinetic_blast(affected_turf)
		for(var/mob/living/victim in affected_turf)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, H, punish_caster = deflected ? FALSE : null))
				deflected = TRUE
				continue
			if(arcyne_strike(H, victim, null, damage, def_zone, BCLASS_BLUNT, spell_name = "普赛顿之拳") == ARCYNE_STRIKE_WARDED)
				continue
			hit_count++

	playsound(T, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)
	H.emote("attack", forced = TRUE)

	if(hit_count)
		H.visible_message(span_danger("[H]猛然挥拳向下，奥术震波轰入地面！"))
	else
		H.visible_message(span_notice("[H]猛然挥拳向下，震波轰入空地！"))

	log_combat(H, null, "使用了 [name][empowered ? "（强化）" : ""]")
	return TRUE
