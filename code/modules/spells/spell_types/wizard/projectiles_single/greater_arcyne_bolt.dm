/datum/action/cooldown/spell/projectile/greater_arcyne_bolt
	button_icon = 'icons/mob/actions/mage_shared.dmi'
	name = "高等奥术箭"
	desc = "向单一目标射出凝聚的奥术能量箭。\
	激活时用 Shift+G 切换弧线模式，以较低伤害越过障碍。"
	fluff_desc = "古老的攻击魔法，自诞生起便常被戏称为\"法师的投石索\"，或与灵魂射击同龄，甚至更早。多数魔导师已弃用奥术箭，改投强大致命、\"不会失手\"的灵魂射击；但仍有人偏爱它，因为它能越过盟友头顶，也不会贯穿敌人的身体。此变体从较弱的原版改良而来，可靠而强劲。它是否仍像从前那样擅长击倒恶魔，尚有争论。"
	button_icon_state = "greater_arcyne_bolt"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	projectile_type = /obj/projectile/magic/greater_arcyne_bolt
	projectile_type_arc = /obj/projectile/magic/greater_arcyne_bolt/arc
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("奥术，成矢！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5.5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	attunement_school = ASPECT_NAME_KINESIS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/greater_arcyne_bolt
	name = "高等奥术箭"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	damage = 54
	damage_type = BRUTE
	flag = "blunt"
	woundclass = BCLASS_BLUNT
	intdamfactor = 1
	nodamage = FALSE
	speed = MAGE_PROJ_FAST
	max_range = MAGE_LONG_PROJ_RANGE
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	var/list/impact_sounds = list('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')

/obj/projectile/magic/greater_arcyne_bolt/arc
	name = "弧线高等奥术箭"
	damage = 41
	arcshot = TRUE

/obj/projectile/magic/greater_arcyne_bolt/on_hit(target)
	if(length(impact_sounds))
		hitsound = pick(impact_sounds)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src]触及[target]时消散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		playsound(get_turf(target), hitsound, 80, TRUE)
	return ..()
