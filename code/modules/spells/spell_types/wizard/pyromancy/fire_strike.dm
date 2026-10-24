/datum/action/cooldown/spell/fire_strike
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "炎坠术"
	expose_caster_on_deflect = FALSE
	desc = "短暂延迟后向指定位置降下火球，损坏 5x5 区域内的建筑，并留下烟云与火幕。你也无法免疫自己的火焰。\n\
	火焰法术施加灼烧：达到 4 层时，会对瞄准的头部或胸部造成穿甲创伤；瞄准其他部位则在头胸之间随机选择。"
	button_icon_state = "grenzel_meteor"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_PYROMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("烈焰之球，坠落！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 75 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/blast_radius = 2
	var/impact_delay = 2 SECONDS
	var/structural_damage = 600
	var/mob_damage = 110
	displayed_damage = 110
	var/curtain_life = 10 SECONDS

/datum/action/cooldown/spell/fire_strike/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE
	if(!(center in get_hear(cast_range, get_turf(H))))
		to_chat(H, span_warning("我无法向看不见的地方施法！"))
		return FALSE

	for(var/turf/T in range(blast_radius, center))
		new /obj/effect/temp_visual/telegraph/wall/fire(T)
	center.visible_message(span_boldwarning("上方空气燃烧起来——有东西正坠落！"))
	addtimer(CALLBACK(src, PROC_REF(drop_fireball), center), impact_delay)
	return TRUE

/datum/action/cooldown/spell/fire_strike/proc/drop_fireball(turf/center)
	if(QDELETED(src) || QDELETED(owner))
		return
	new /obj/effect/temp_visual/falling_boulder/fireball(center, CALLBACK(src, PROC_REF(fire_impact), center))

/datum/action/cooldown/spell/fire_strike/proc/fire_impact(turf/center)
	if(QDELETED(src) || QDELETED(owner))
		return
	var/mob/living/carbon/human/caster = owner
	playsound(center, 'sound/magic/fireball.ogg', 100, TRUE, 6)
	new /obj/effect/temp_visual/spell_impact(center, spell_color, spell_impact_intensity)

	for(var/turf/T in range(blast_radius, center))
		for(var/obj/structure/S in T.contents)
			S.take_damage(structural_damage * 2, BRUTE, "blunt")
		T.take_damage(structural_damage * 2, BRUTE, "blunt")
		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				continue
			if(spell_guard_check(L, TRUE))
				continue
			if(istype(caster) && ishuman(L))
				if(arcyne_strike(caster, L, null, mob_damage, BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "炎坠术", damage_type = BURN, skip_animation = TRUE) == ARCYNE_STRIKE_WARDED)
					continue
			else
				L.adjustFireLoss(mob_damage)
			apply_scorch_stack(L, 2)
			L.Knockdown(3)

	for(var/turf/T in range(blast_radius, center))
		new /obj/effect/curtain_fire(T, curtain_life, owner)

	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(4, center)
	smoke.start()

/obj/effect/temp_visual/falling_boulder/fireball
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "meteor"
	name = "坠落火球"
	color = "#ff7722"
