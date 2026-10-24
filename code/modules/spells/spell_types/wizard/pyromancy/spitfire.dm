#define SPITFIRE_DAMAGE 50
/datum/action/cooldown/spell/projectile/spitfire
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "喷火术"
	desc = "射出低威力火球，撞击时为目标点起少量火焰。\
	激活时用 Shift+G 切换弧线模式，可越过中间生物；弧线攻击伤害降低 25%。\n\
	火焰法术施加灼烧：达到 4 层时，会对瞄准的头部或胸部造成穿甲创伤；瞄准其他部位则在头胸之间随机选择。"
	button_icon_state = "spitfire"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/spitfire
	projectile_type_arc = /obj/projectile/magic/spitfire/arc
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("吐焰而出！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = SPELL_COOLDOWN_POKE
	attunement_school = ASPECT_NAME_PYROMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/spitfire
	name = "喷火弹"
	expose_caster_on_deflect = TRUE
	icon_state = "fireball"
	light_color = "#f8af07"
	light_outer_range = 2
	speed = MAGE_PROJ_VERY_SLOW
	damage = SPITFIRE_DAMAGE
	damage_type = BURN
	woundclass = BCLASS_BURN
	nodamage = FALSE
	flag = "fire"
	hitsound = 'sound/blank.ogg'

/obj/projectile/magic/spitfire/arc
	name = "弧线喷火弹"
	damage = 38
	arcshot = TRUE

/obj/projectile/magic/spitfire/on_hit(target, blocked = FALSE)
	..()
	var/turf/epicenter = get_turf(target)
	if(epicenter)
		new /obj/effect/temp_visual/explosion(epicenter)
		playsound(epicenter, pick('sound/magic/fireball.ogg', 'sound/misc/explode/bottlebomb (2).ogg'), 120, TRUE, 8)
		playsound(epicenter, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 100, TRUE, 4)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src]触及[target]时消散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(out_of_effective_range())
			return
		if(blocked >= 100)
			return
		if(has_frost_stacks(M))
			remove_frost_stack(M)
			visible_message(span_warning("火焰融化了[target]身上的寒霜！"))
			playsound(get_turf(target), 'sound/items/firesnuff.ogg', 100)
			new /obj/effect/temp_visual/snap_freeze(get_turf(M))
		apply_scorch_stack(M, 1, def_zone)
	else if(isatom(target))
		var/atom/A = target
		A.fire_act()

#undef SPITFIRE_DAMAGE
