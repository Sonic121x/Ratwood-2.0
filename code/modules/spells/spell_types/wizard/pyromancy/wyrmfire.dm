#define FIREBALL_DAMAGE 90
#define FIREBALL_AOE_DAMAGE 50
#define ARTILLERY_FIREBALL_DAMAGE 80
#define ARTILLERY_FIREBALL_AOE_DAMAGE 50
#define PILLAR_OF_FLAME_DAMAGE 110
#define PILLAR_OF_FLAME_CURTAIN_LIFE (5 SECONDS)
#define WYRMFIRE_VULNERABLE_DURATION (5 SECONDS)
#define CATACLYSM_DAMAGE 300
#define CATACLYSM_STRUCTURAL_DAMAGE 3000
#define CATACLYSM_RADIUS 4

// Abstract base for the Wyrmfire family - not grantable on its own.
/datum/action/cooldown/spell/projectile/fireball
	abstract_type = /datum/action/cooldown/spell/projectile/fireball
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "火球术"
	desc = "射出撞击时爆炸的火球，灼烧并减速附近目标。\n\
	火焰法术施加灼烧：达到 4 层时，会对瞄准的头部或胸部造成穿甲创伤；瞄准其他部位则在头胸之间随机选择。"
	button_icon_state = "fireball"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_PYROMANCY

	projectile_type = /obj/projectile/magic/aoe/fireball/rogue
	projectile_type_arc = /obj/projectile/magic/aoe/fireball/rogue/arc
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 6
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("火球，迸发！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = SPELL_COOLDOWN_BIG_WHOOPER

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/aoe/fireball/rogue
	name = "火球"
	expose_caster_on_deflect = TRUE
	speed = MAGE_PROJ_VERY_SLOW
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 0
	damage = FIREBALL_DAMAGE
	damage_type = BURN
	woundclass = BCLASS_BURN
	nodamage = FALSE
	flag = "fire"
	hitsound = 'sound/blank.ogg'
	aoe_range = 0
	/// Radius for AOE arcyne_strike blast around impact point. 0 = no AOE.
	var/arcyne_aoe_radius = 1
	/// Flat AOE damage dealt by arcyne_strike around the impact point.
	var/arcyne_aoe_damage = FIREBALL_AOE_DAMAGE
	/// Structural damage dealt to structures/walls in AOE radius. 0 = none.
	var/structural_damage = 60
	/// Radius for structural damage. Uses arcyne_aoe_radius if not set.
	var/structural_damage_radius = 0

// Legacy for compatibility reason
/obj/projectile/magic/aoe/fireball/rogue/arc
	name = "弧线火球"
	arcshot = TRUE

/obj/projectile/magic/aoe/fireball/rogue/on_hit(target, blocked = FALSE)
	..()
	var/mob/living/M = ismob(target) ? target : null

	if(M?.anti_magic_check())
		visible_message(span_warning("[src]触及[target]时消散了！"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		qdel(src)
		return BULLET_ACT_BLOCK

	if(out_of_effective_range())
		return

	if(M && blocked < 100)
		apply_scorch_stack(M, 2, def_zone)
		M.apply_status_effect(/datum/status_effect/debuff/vulnerable, WYRMFIRE_VULNERABLE_DURATION)

	var/aoe_damage = arcyne_aoe_damage

	var/turf/epicenter = get_turf(target)

	if(epicenter)
		new /obj/effect/temp_visual/explosion(epicenter)
		playsound(epicenter, pick('sound/misc/explode/bomb.ogg', 'sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'), 120, TRUE, 8)
		playsound(epicenter, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 100, TRUE, 4)

	if(arcyne_aoe_radius > 0 && isliving(firer))
		var/mob/living/caster = firer
		var/mob/living/direct_hit = M
		for(var/turf/T in range(arcyne_aoe_radius, epicenter))
			new /obj/effect/temp_visual/fire(T)
			for(var/mob/living/L in T)
				if(L == direct_hit || L.stat == DEAD || L == caster)
					continue
				if(L.anti_magic_check())
					continue
				if(L.guard_deflect_spell("Fireball", TRUE, caster, punish_caster = FALSE))
					continue
				if(arcyne_strike(caster, L, null, aoe_damage, BODY_ZONE_CHEST, \
					BCLASS_BURN, spell_name = "火球（爆炸）", \
					allow_shield_check = TRUE, damage_type = BURN, \
					skip_animation = TRUE) == ARCYNE_STRIKE_WARDED)
					continue
				apply_scorch_stack(L, 1)
				L.apply_status_effect(/datum/status_effect/debuff/vulnerable, WYRMFIRE_VULNERABLE_DURATION)
				L.Slowdown(1)

	if(arcyne_aoe_radius > 0)
		var/struct_radius = structural_damage_radius ? structural_damage_radius : arcyne_aoe_radius
		for(var/turf/T in range(struct_radius, epicenter))
			T.fire_act()
			for(var/atom/A in T)
				if(ismob(A))
					continue
				A.fire_act()
		if(structural_damage > 0)
			for(var/obj/structure/damaged in view(struct_radius, epicenter))
				if(!istype(damaged, /obj/structure/flora/newbranch))
					damaged.take_damage(structural_damage, BRUTE, "blunt", 1)
			for(var/turf/closed/wall/damagedwalls in view(struct_radius, epicenter))
				damagedwalls.take_damage(structural_damage, BRUTE, "blunt", 1)

	return TRUE

// Combination spell for the pyromancer artillery mage - switch modes with Shift+G.
/datum/action/cooldown/spell/projectile/fireball/barrage
	name = "龙焰术"
	desc = "倾泻毁灭性烈火，每次打击都会使受害者易伤。用 Shift+G 切换施放模式：\n\
	火球：直射造成 90 伤害，对目标周围造成 50 范围伤害。\n\
	攻城火球：弧线轰炸，重创建筑并产生烟雾，造成 80 伤害与 50 范围伤害。\n\
	烈焰之柱：瞄准地面，短暂预警后在 3x3 区域爆发，造成 110 伤害，并留下覆盖整个区域的火幕。\n\
	火焰法术施加灼烧：达到 4 层时，会对瞄准的头部或胸部造成穿甲创伤；瞄准其他部位则在头胸之间随机选择。"
	charge_swingdelay_type = SWINGDELAY_PENALTY
	var/current_mode = 1
	var/list/modes = list(
		list("name" = "火球", "tag" = "火球", "proj" = /obj/projectile/magic/aoe/fireball/rogue, "proj_arc" = /obj/projectile/magic/aoe/fireball/rogue/arc, "arc" = FALSE, "icon" = "fireball", "cost" = SPELLCOST_MAJOR_PROJECTILE, "cooldown" = 16 SECONDS, "charge" = CHARGETIME_MAJOR, "slowdown" = CHARGING_SLOWDOWN_MEDIUM, "sound" = 'sound/magic/fireball.ogg', "invocation" = "烈焰之球！"),
		list("name" = "攻城火球", "tag" = "轰炸", "proj" = /obj/projectile/magic/aoe/fireball/rogue/artillery, "proj_arc" = /obj/projectile/magic/aoe/fireball/rogue/artillery/arc, "arc" = TRUE, "icon" = "fireball_artillery", "cost" = SPELLCOST_MAJOR_PROJECTILE, "cooldown" = 16 SECONDS, "charge" = CHARGETIME_HEAVY, "slowdown" = CHARGING_SLOWDOWN_HEAVY, "sound" = 'sound/magic/fireball.ogg', "invocation" = "烈焰球，轰击！"),
		list("name" = "烈焰之柱", "tag" = "火柱", "proj" = /obj/projectile/magic/aoe/fireball/rogue, "proj_arc" = /obj/projectile/magic/aoe/fireball/rogue/arc, "arc" = FALSE, "ground" = TRUE, "icon" = "fireball_greater", "cost" = SPELLCOST_MAJOR_PROJECTILE, "cooldown" = 16 SECONDS, "charge" = CHARGETIME_HEAVY, "slowdown" = CHARGING_SLOWDOWN_HEAVY, "sound" = 'sound/magic/fireball.ogg', "invocation" = "吞噬之炎！"),
	)
	var/pillar_radius = 1
	var/pillar_delay = 2 SECONDS
	var/pillar_damage = PILLAR_OF_FLAME_DAMAGE

/datum/action/cooldown/spell/projectile/fireball/barrage/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	for(var/i in stats.Copy())
		if(findtext(i, "伤害：") || findtext(i, "弧线模式"))
			stats -= i
	stats += span_info("伤害：火球 [FIREBALL_DAMAGE]（+[FIREBALL_AOE_DAMAGE] 溅射）／攻城火球 [ARTILLERY_FIREBALL_DAMAGE]（+[ARTILLERY_FIREBALL_AOE_DAMAGE] 溅射）／烈焰之柱 [pillar_damage]（3x3）")
	stats += span_info("施放模式（Shift+G）：火球（直射）／攻城火球（弧线轰炸）／烈焰之柱（地面爆发）。")
	return stats

/datum/action/cooldown/spell/projectile/fireball/barrage/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/fireball/barrage/proc/apply_mode(index)
	var/list/mode = modes[index]
	projectile_type = mode["proj"]
	projectile_type_arc = mode["proj_arc"]
	arc_mode = mode["arc"]
	button_icon_state = mode["icon"]
	primary_resource_cost = mode["cost"]
	cooldown_time = mode["cooldown"]
	charge_time = mode["charge"]
	charge_slowdown = mode["slowdown"]
	sound = mode["sound"]
	invocations = list(mode["invocation"])
	build_all_button_icons()
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/fireball/barrage/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	var/list/mode = modes[current_mode]
	to_chat(user, span_notice("[name]：[mode["name"]]模式。"))

/datum/action/cooldown/spell/projectile/fireball/barrage/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.color = "#ff8a3d"

/datum/action/cooldown/spell/projectile/fireball/barrage/fire_projectile(atom/target)
	if(!modes[current_mode]["ground"])
		return ..()
	var/turf/epicenter = get_turf(target)
	if(!epicenter)
		return FALSE
	for(var/turf/T in range(pillar_radius, epicenter))
		new /obj/effect/temp_visual/telegraph/pillar/fadein(T, pillar_delay)
	playsound(epicenter, 'sound/magic/charging_fire.ogg', 80, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pillar_of_flame_erupt), epicenter, owner, pillar_radius, pillar_damage, owner.zone_selected), pillar_delay)
	return TRUE

/obj/effect/temp_visual/telegraph/pillar
	light_color = GLOW_COLOR_FIRE
	duration = 2 SECONDS

/obj/effect/temp_visual/telegraph/pillar/fadein
	fade_in = TRUE

/obj/effect/temp_visual/fire_pillar
	icon = 'icons/effects/32x96.dmi'
	icon_state = "pillar"
	light_outer_range = 2
	light_color = LIGHT_COLOR_FIRE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER

/proc/pillar_of_flame_erupt(turf/epicenter, mob/living/carbon/human/caster, radius, damage, aim_zone)
	if(!epicenter)
		return
	new /obj/effect/temp_visual/explosion(epicenter)
	new /obj/effect/temp_visual/fire_pillar(epicenter)
	playsound(epicenter, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 100, TRUE, 5)
	for(var/turf/T in range(radius, epicenter))
		new /obj/effect/temp_visual/dragonfire(T)
		new /obj/effect/curtain_fire(T, PILLAR_OF_FLAME_CURTAIN_LIFE, caster, aim_zone)
		T.fire_act()
		for(var/atom/A in T)
			A.fire_act()
		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				continue
			if(L.anti_magic_check())
				continue
			if(L.guard_deflect_spell("烈焰之柱", TRUE, caster, punish_caster = FALSE))
				continue
			if(istype(caster) && !QDELETED(caster))
				if(arcyne_strike(caster, L, null, damage, aim_zone || BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "烈焰之柱", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE) == ARCYNE_STRIKE_WARDED)
					continue
			else
				L.adjustFireLoss(damage)
			apply_scorch_stack(L, 2)
			L.apply_status_effect(/datum/status_effect/debuff/vulnerable, WYRMFIRE_VULNERABLE_DURATION)

/obj/projectile/magic/aoe/fireball/rogue/artillery
	name = "攻城火球"
	damage = ARTILLERY_FIREBALL_DAMAGE
	arcyne_aoe_radius = 1
	arcyne_aoe_damage = ARTILLERY_FIREBALL_AOE_DAMAGE
	structural_damage = 300
	structural_damage_radius = 1

/obj/projectile/magic/aoe/fireball/rogue/artillery/arc
	name = "弧线攻城火球"
	damage = 60
	arcshot = TRUE

/obj/projectile/magic/aoe/fireball/rogue/artillery/on_hit(target)
	var/cached_radius = structural_damage_radius
	. = ..()
	if(. == BULLET_ACT_BLOCK)
		return
	var/turf/fallzone = get_turf(target)
	if(!fallzone)
		return
	if(out_of_effective_range())
		return
	for(var/turf/open/visual in view(cached_radius, fallzone))
		var/obj/effect/temp_visual/lavastaff/Lava = new /obj/effect/temp_visual/lavastaff(visual)
		animate(Lava, alpha = 255, time = 5)
	var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/fast
	S.set_up(cached_radius, fallzone)
	S.start()

/obj/effect/ebeam/pyroclasm
	color = "#ff2b1a"

/obj/effect/particle_effect/smoke/pyroclasm
	color = "#2e2e2e"
	alpha = 130
	opaque = FALSE
	opacity = FALSE
	lifetime = 20

/datum/effect_system/smoke_spread/pyroclasm
	effect_type = /obj/effect/particle_effect/smoke/pyroclasm

// Megumin's EXPLOSION (KonoSuba): https://konosuba.fandom.com/wiki/Explosion
/datum/action/cooldown/spell/projectile/pyroclasm
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "焚天灾火"
	desc = "炽红烈火，诸元素中最耀眼者！\n\
	遵循普赛顿的法则，\n\
	毁去祂所创造的一切——\n\
	尘归尘，令祂的造物归于灰烬！\n\
	大焚灭！\n\
	火焰法术施加灼烧：达到 4 层时，会对瞄准的头部或胸部造成穿甲创伤；瞄准其他部位则在头胸之间随机选择。"
	button_icon_state = "fireball_greater"
	sound = null
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_PYROMANCY
	cast_range = SPELL_RANGE_TWO_SCREENS // Special range
	weapon_cast_penalized = TRUE
	associated_skill = /datum/skill/magic/arcane
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	invocations = list()
	invocation_type = INVOCATION_NONE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = 10
	secondary_resource_type = SPELL_COST_NONE

	charge_required = TRUE
	charge_time = 2 SECONDS
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 5 MINUTES

	spell_tier = 4
	point_cost = 9
	spell_impact_intensity = SPELL_IMPACT_HIGH

	var/blast_radius = CATACLYSM_RADIUS
	var/blast_damage = CATACLYSM_DAMAGE
	displayed_damage = CATACLYSM_DAMAGE
	var/blast_structural = CATACLYSM_STRUCTURAL_DAMAGE
	var/chant_time = 12 SECONDS
	var/energy_requirement = 800
	var/exhaust_delay = 3 SECONDS
	var/hotspot_life = 15 SECONDS
	var/hotspot_chance = 60

/datum/action/cooldown/spell/projectile/pyroclasm/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	var/turf/epicenter = get_turf(cast_on)
	if(!epicenter || !(epicenter in get_hear(cast_range, owner)))
		owner?.balloon_alert(owner, "无法清楚看见那个位置！")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/projectile/pyroclasm/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/caster = owner
	if(!istype(caster) || caster.energy < energy_requirement)
		if(feedback)
			owner?.balloon_alert(owner, "能量不足，无法咏唱——需要 [energy_requirement]！")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/projectile/pyroclasm/fire_projectile(atom/target)
	var/turf/epicenter = get_turf(target)
	if(!epicenter)
		return FALSE
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		return FALSE
	var/list/warnings = list()
	for(var/turf/T in blast_turfs(epicenter))
		warnings += new /obj/effect/temp_visual/telegraph/pillar/fadein(T, chant_time)
	playsound(get_turf(caster), 'sound/magic/charging_fire.ogg', 80, TRUE)
	INVOKE_ASYNC(src, PROC_REF(perform_chant), caster, epicenter, warnings)
	return TRUE

/datum/action/cooldown/spell/projectile/pyroclasm/proc/perform_chant(mob/living/carbon/human/caster, turf/epicenter, list/warnings)
	var/static/list/chant = list(
		"炽红烈火，诸元素中最耀眼者！！",
		"遵循普赛顿的法则！！",
		"毁去祂所创造的一切！！",
		"尘归尘，令祂的造物归于灰烬！！",
	)
	var/datum/beam/aim = new(caster, epicenter, 'icons/effects/beam.dmi', "b_beam", INFINITY, 20, /obj/effect/ebeam/pyroclasm)
	INVOKE_ASYNC(aim, TYPE_PROC_REF(/datum/beam, Start))
	var/seg = chant_time / length(chant)
	for(var/i in 1 to length(chant))
		addtimer(CALLBACK(src, PROC_REF(chant_line), caster, chant[i]), seg * (i - 1))
	caster.visible_message(span_boldwarning("[caster]将[caster.p_their()]的双臂举向天空，开始可怖的咏唱！"))
	if(!do_after(caster, chant_time, needhand = FALSE))
		if(!QDELETED(aim))
			qdel(aim)
		QDEL_LIST(warnings)
		reset_spell_cooldown()
		if(!QDELETED(caster))
			caster.energy_add(-100)
			caster.balloon_alert(caster, "<font color='#ff3333'>施法被打断！</font>")
			caster.visible_message(span_warning("[caster]的咏唱被打断，周围汇聚的火焰四散而去！"))
		return
	if(!QDELETED(aim))
		qdel(aim)
	caster.say("大焚灭！！", forced = "spell", language = /datum/language/common)
	erupt(caster, epicenter)

/datum/action/cooldown/spell/projectile/pyroclasm/proc/chant_line(mob/living/carbon/human/caster, line)
	if(QDELETED(caster) || !caster.doing)
		return
	caster.say(line, forced = "spell", language = /datum/language/common)

/datum/action/cooldown/spell/projectile/pyroclasm/proc/erupt(mob/living/carbon/human/caster, turf/epicenter)
	if(!epicenter)
		return
	var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/pyroclasm
	S.set_up(blast_radius, epicenter)
	S.start()
	new /obj/effect/temp_visual/explosion(epicenter)
	new /obj/effect/temp_visual/fire_pillar(epicenter)
	playsound(epicenter, pick('sound/misc/explode/bomb.ogg', 'sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg'), 120, TRUE, 10)
	var/max_shake_dist = blast_radius + world.view
	for(var/mob/M in GLOB.player_list)
		if(M == caster)
			continue
		var/turf/M_turf = get_turf(M)
		if(!M_turf || !is_in_zweb(M_turf.z, epicenter.z))
			continue
		var/dist = get_dist(M_turf, epicenter)
		if(dist > max_shake_dist)
			continue
		shake_camera(M, 25, CLAMP(6 - (dist * 0.5), 1, 6))
	var/list/hit = blast_turfs(epicenter)
	for(var/turf/T in hit)
		new /obj/effect/temp_visual/dragonfire(T)
		new /obj/effect/temp_visual/fire(T)
		if(prob(50))
			new /obj/effect/temp_visual/explosion(T)
		T.fire_act()
		if(prob(hotspot_chance))
			new /obj/effect/curtain_fire(T, hotspot_life, caster)
		if(istype(T, /turf/closed/wall))
			T.take_damage(blast_structural, BRUTE, "blunt", TRUE)
		for(var/atom/A in T)
			if(ismob(A))
				continue
			A.fire_act()
		for(var/mob/living/L in T)
			if(QDELETED(L) || L.stat == DEAD)
				continue
			if(L.anti_magic_check())
				continue
			if(istype(caster) && !QDELETED(caster))
				if(arcyne_strike(caster, L, null, blast_damage, BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "焚天灾火", damage_type = BURN, skip_animation = TRUE) == ARCYNE_STRIKE_WARDED)
					continue
			else
				L.adjustFireLoss(blast_damage)
			apply_scorch_stack(L, 3)
		for(var/obj/structure/damaged in T)
			if(!istype(damaged, /obj/structure/flora/newbranch))
				damaged.take_damage(blast_structural, BRUTE, "blunt", TRUE)
	if(!QDELETED(caster))
		addtimer(CALLBACK(src, PROC_REF(exhaust_caster), caster), exhaust_delay)

/datum/action/cooldown/spell/projectile/pyroclasm/proc/exhaust_caster(mob/living/carbon/human/caster)
	if(QDELETED(caster))
		return
	caster.energy_add(-caster.energy)
	caster.stamina_add(caster.max_stamina)

/datum/action/cooldown/spell/projectile/pyroclasm/proc/blast_turfs(turf/epicenter)
	var/list/affected = list()
	affected[epicenter] = TRUE
	var/list/frontier = list(epicenter)
	for(var/i in 1 to blast_radius)
		var/list/next_frontier = list()
		for(var/turf/T in frontier)
			for(var/turf/adj in orange(1, T))
				if(affected[adj])
					continue
				affected[adj] = TRUE
				if(!adj.is_blocked_turf(TRUE))
					next_frontier += adj
		frontier = next_frontier
	return affected

#undef FIREBALL_DAMAGE
#undef FIREBALL_AOE_DAMAGE
#undef ARTILLERY_FIREBALL_DAMAGE
#undef ARTILLERY_FIREBALL_AOE_DAMAGE
#undef PILLAR_OF_FLAME_DAMAGE
#undef PILLAR_OF_FLAME_CURTAIN_LIFE
#undef WYRMFIRE_VULNERABLE_DURATION
#undef CATACLYSM_DAMAGE
#undef CATACLYSM_STRUCTURAL_DAMAGE
#undef CATACLYSM_RADIUS
