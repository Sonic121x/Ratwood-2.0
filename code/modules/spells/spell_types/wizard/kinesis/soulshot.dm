#define SOULSHOT_BASE_DAMAGE 80
#define SOULSHOT_PIERCE_DAMAGE_MULT 0.75
/datum/action/cooldown/spell/projectile/soulshot
	button_icon = 'icons/mob/actions/mage_shared.dmi'
	name = "灵魂射击"
	desc = "射出毁灭性的动能光束，贯穿最多 4 个目标。实体障碍会阻挡它。\
	首个目标之后，伤害降为四分之三。\
	从最初法师怀着恶意与毁灭他人的决心排出体内魔力起，这种基础攻击魔法已打磨逾千年。"
	fluff_desc = "自最初法师怀着纯粹恶意与毁灭他人的决心排出魔力以来，这种基础攻击魔法已打磨两千余年。它是奥术箭的自然演进：从勉强凝聚的能量球，化为集中的毁灭光束。『灵魂射击』之名源于古人认为必须倾注灵魂才能释放如此强大的投射。它属于纯粹奥术能量，因此多数法师协调火焰或雷电等『不纯』法相时无法施放。通常，协调增幅术——自己的身体，或动力术——以运动之力挪动敌人的法师，才会使用此术。"
	button_icon_state = "soulshot"
	sound = 'sound/magic/soulshot.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_MEDIUM

	projectile_type = /obj/projectile/magic/soulshot
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("灵魂，出击！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS
	attunement_school = ASPECT_NAME_KINESIS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/soulshot
	name = "灵魂射击"
	tracer_type = /obj/effect/projectile/tracer/bloodsteal
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	damage = SOULSHOT_BASE_DAMAGE
	damage_type = BRUTE
	woundclass = BCLASS_STAB
	nodamage = FALSE
	speed = 0.3
	flag = "piercing"
	hitsound = 'sound/magic/obeliskbeam.ogg'
	light_color = "#9400D3"
	light_outer_range = 7
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	/// How many mob targets have been hit so far.
	var/hits = 0
	/// Maximum mob targets before the beam stops.
	var/max_hits = 4

/obj/projectile/magic/soulshot/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src]触及[target]时消散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	// Only pierce through mobs, not solid objects
	if(!ismob(target))
		qdel(src)
		return . || BULLET_ACT_HIT
	hits++
	// Halve damage after the first target
	if(hits <= 1)
		damage = SOULSHOT_BASE_DAMAGE
	else
		damage = round(SOULSHOT_BASE_DAMAGE * SOULSHOT_PIERCE_DAMAGE_MULT)
	if(hits >= max_hits)
		qdel(src)
		return . || BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE

#undef SOULSHOT_BASE_DAMAGE
#undef SOULSHOT_PIERCE_DAMAGE_MULT
