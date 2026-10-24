#define ARCYNE_BARRAGE_SLOWDOWN_ID "arcyne_barrage_channel"

/datum/action/cooldown/spell/projectile/arcyne_barrage
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "奥术弹幕"
	desc = "飞弹法师的终极论证——朝一个方向持续十秒射出可贯穿、可弹跳的奥术箭脉冲，每箭最多贯穿五个目标。\
	引导时可以行走，但速度大幅降低，且无法改变方向。\
	眩晕、倒地或被抓住都会打断引导。"
	button_icon_state = "arcyne_barrage"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_TELOMANCY

	click_to_activate = TRUE
	cast_range = 21

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list()
	invocation_type = INVOCATION_NONE
	var/barrage_invocation = "飞矢，终极之理！"

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_time = CHARGETIME_HEAVY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 4
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/channel_duration = 10 SECONDS
	var/pulse_interval = 2 SECONDS
	var/bolts_per_pulse = 5
	var/pulse_spread = 120
	var/channel_slowdown = 3

/datum/action/cooldown/spell/projectile/arcyne_barrage/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("伤害：每箭 45（每轮 [bolts_per_pulse] 枚，最多贯穿 5 人）")
	return stats

/datum/action/cooldown/spell/projectile/arcyne_barrage/before_cast(atom/cast_on)
	. = ..()
	. |= SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/projectile/arcyne_barrage/fire_projectile(atom/target)
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_barrage/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.say(barrage_invocation, forced = "spell", language = /datum/language/common)

	var/locked_angle = dir2angle(H.dir)
	var/end_time = world.time + channel_duration
	var/pulse_index = 0

	H.visible_message(span_danger("<b>[H]释放出一场奥术箭风暴！</b>"))
	playsound(get_turf(H), 'sound/magic/vlightning.ogg', 100, TRUE)
	H.add_movespeed_modifier(ARCYNE_BARRAGE_SLOWDOWN_ID, update = TRUE, priority = 100, multiplicative_slowdown = channel_slowdown, movetypes = GROUND)

	while(world.time < end_time)
		if(!channel_valid(H))
			end_channel(H, TRUE)
			return TRUE

		pulse_index++
		fire_pulse(H, locked_angle, pulse_index)

		new /obj/effect/temp_visual/spell_impact(get_turf(H), spell_color, spell_impact_intensity)
		sleep(pulse_interval)

	end_channel(H, FALSE)
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/end_channel(mob/living/carbon/human/H, interrupted)
	if(H)
		H.remove_movespeed_modifier(ARCYNE_BARRAGE_SLOWDOWN_ID)
	if(interrupted)
		StartCooldown(get_adjusted_cooldown() / 2)
		if(H)
			to_chat(H, span_warning("我的弹幕中断了！"))
	else
		StartCooldown(get_adjusted_cooldown())

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/channel_valid(mob/living/carbon/human/H)
	if(QDELETED(H))
		return FALSE
	if(H.stat != CONSCIOUS)
		return FALSE
	if(H.IsParalyzed() || H.IsStun() || H.IsKnockdown() || H.IsUnconscious())
		return FALSE
	if(H.pulledby)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/fire_pulse(mob/living/carbon/human/H, locked_angle, pulse_index)
	var/arc_start = locked_angle - (pulse_spread / 2)
	var/step_size = bolts_per_pulse > 1 ? (pulse_spread / (bolts_per_pulse - 1)) : 0
	for(var/i in 1 to bolts_per_pulse)
		fire_barrage_bolt(H, arc_start + (step_size * (i - 1)))

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/fire_barrage_bolt(mob/living/carbon/human/H, angle)
	var/obj/projectile/magic/arcyne_barrage_bolt/bolt = new(get_turf(H))
	bolt.firer = H
	bolt.fired_from = get_turf(H)
	bolt.def_zone = BODY_ZONE_CHEST
	bolt.spell_impact_intensity = SPELL_IMPACT_MEDIUM
	H.apply_spell_accuracy(bolt)
	bolt.setAngle(angle)
	bolt.fire()

/obj/projectile/magic/arcyne_barrage_bolt
	name = "高等奥术箭"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	damage = 45
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = 30
	speed = 3
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	intdamfactor = 1
	ricochets_max = 5
	ricochet_chance = 100
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 40
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	var/hits = 0
	var/max_hits = 5

/obj/projectile/magic/arcyne_barrage_bolt/on_hit(target)
	hitsound = pick('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src]触及[target]后无害地消散！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()
	if(!ismob(target))
		return
	hits++
	if(hits >= max_hits)
		qdel(src)
		return . || BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE

#undef ARCYNE_BARRAGE_SLOWDOWN_ID
