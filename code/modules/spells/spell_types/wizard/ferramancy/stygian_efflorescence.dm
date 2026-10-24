#define MT_STYGIAN "stygian"
#define STYGIAN_DR_DURATION 1 SECONDS

/datum/action/cooldown/spell/projectile/stygian_efflorescence
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	name = "冥河绽放"
	desc = "蓄力后，向面朝方向以宽角度射出五枚锋利黑曜石碎片。首枚可造成重创；同一目标遭受的后续碎片伤害大幅降低至 8，且无法重创。超过 5 格后，投射效果衰减。"
	fluff_desc = "人类学会冶金之前，以锋利石块为兵，尤其是火山脚下的黑曜石。\
	传说各各他山的黑曜石举世无双，锋利得能轻易切开血肉。\
	法师怀着恶意、能量与将人以黑曜石割裂的想象，\
	创造了通向炼铁术的第一道法术。后来人们学会想象冶炼金属、锻造工具，再以魔法重现这一过程。"
	button_icon_state = "stygian"
	sound = 'sound/magic/scrapeblade.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/energy/stygian
	cast_range = SPELL_RANGE_PROJECTILE
	projectiles_per_fire = 5
	point_cost = 3

	click_to_activate = FALSE
	cardinal_aim = TRUE
	shared_cooldown = "ferramancy_strike"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE // It is a big ass shotgun now

	invocations = list("各各他之锋！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE // Use it with an arcyne armament noob 
	charge_time = CHARGETIME_MINOR
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS // Not meant to be the thing you relies on for damage or a staple poke spell, it is something to be mixed in in melee
	attunement_school = ASPECT_NAME_FERRAMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/spread_step = 18

/datum/action/cooldown/spell/projectile/stygian_efflorescence/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	var/base_angle = to_fire.Angle
	if(isnull(base_angle))
		base_angle = Get_Angle(user, target)
	var/center_index = (projectiles_per_fire + 1) / 2
	to_fire.Angle = base_angle + ((iteration - center_index) * spread_step)

// --- Stygian projectile ---

/obj/projectile/energy/stygian
	name = "冥河镰刃"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	range = 7 // Let you pressure a whole screen, in theory
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "stygian"
	max_range = MAGE_LONG_PROJ_RANGE // Effective range is lower than its maximal range
	damage = 34
	damage_type = BRUTE
	woundclass = BCLASS_STAB
	armor_penetration = PEN_LIGHT
	speed = MAGE_PROJ_VERY_SLOW
	flag = "stab"
	hitsound = 'sound/combat/hits/bladed/genstab (1).ogg'
	var/reduced_damage = 7 // 34 + 7 * 4 = 62. A point blank is gonna be as much damage as most of your melee Ferramantic attack, on purpose as a ranged pressure tool as not as a replacement to compete with your fancy NotSpecial

/obj/projectile/energy/stygian/prehit(atom/target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.mob_timers[MT_STYGIAN] && world.time < M.mob_timers[MT_STYGIAN] + STYGIAN_DR_DURATION)
			damage = reduced_damage
			no_crit = TRUE
		else
			M.mob_timers[MT_STYGIAN] = world.time
	return ..()

/obj/projectile/energy/stygian/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src]撞上[target]后碎裂，未造成伤害！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

#undef MT_STYGIAN
#undef STYGIAN_DR_DURATION
