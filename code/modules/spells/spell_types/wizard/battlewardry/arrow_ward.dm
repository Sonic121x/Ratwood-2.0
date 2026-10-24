/datum/action/cooldown/spell/arrow_ward
	button_icon = 'icons/mob/actions/mage_battlewardry.dmi'
	name = "箭矢结界"
	desc = "在面前召出宽阔的奥术屏障。屏障阻挡正面袭来的投射物，但施法者与盟友可自由穿行并向外射击。"
	button_icon_state = "arrow_ward"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_WARD
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_BATTLEWARDRY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE

	invocations = list("箭矢之墙！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/barrier_width = 5
	var/barrier_duration = 20 SECONDS

/datum/action/cooldown/spell/arrow_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/front = get_turf(cast_on)
	if(!front)
		return FALSE

	var/list/affected_turfs = list()
	affected_turfs += front

	var/perpendicular_dirs
	if(H.dir == SOUTH || H.dir == NORTH)
		perpendicular_dirs = list(WEST, EAST)
	else
		perpendicular_dirs = list(NORTH, SOUTH)

	if(barrier_width >= 3)
		affected_turfs += get_step(front, perpendicular_dirs[1])
		affected_turfs += get_step(front, perpendicular_dirs[2])
	if(barrier_width >= 5)
		affected_turfs += get_step(get_step(front, perpendicular_dirs[1]), perpendicular_dirs[1])
		affected_turfs += get_step(get_step(front, perpendicular_dirs[2]), perpendicular_dirs[2])

	var/cast_dir = H.dir
	for(var/turf/affected_turf in affected_turfs)
		new /obj/effect/temp_visual/telegraph/wall(affected_turf)
		addtimer(CALLBACK(src, PROC_REF(spawn_ward), affected_turf, H, cast_dir), 1 SECONDS)

	H.visible_message(span_notice("[H]竖起一道闪烁的箭矢结界！"))
	return TRUE

/datum/action/cooldown/spell/arrow_ward/proc/spawn_ward(turf/target, mob/caster, shield_direction)
	var/obj/structure/arrow_ward/B = new(target, caster, barrier_duration)
	B.set_shield_dir(shield_direction)

/obj/structure/arrow_ward
	name = "箭矢结界"
	desc = "一堵闪烁的奥术力墙。投射物无法从正面穿过。"
	icon = 'icons/roguetown/misc/arrow_ward.dmi'
	icon_state = "arrow_ward"
	opacity = FALSE
	density = FALSE
	anchored = TRUE
	max_integrity = 120
	layer = ABOVE_MOB_LAYER
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	break_sound = 'sound/magic/magic_nulled.ogg'

	var/shield_dir = NORTH
	var/mob/caster

/obj/structure/arrow_ward/Initialize(mapload, mob/summoner, duration)
	. = ..()
	caster = summoner
	if(duration)
		QDEL_IN(src, duration)

/obj/structure/arrow_ward/Destroy()
	caster = null
	return ..()

/obj/structure/arrow_ward/proc/set_shield_dir(new_dir)
	shield_dir = new_dir
	dir = new_dir

/obj/structure/arrow_ward/CanPass(atom/movable/mover, turf/target)
	if(isprojectile(mover))
		var/obj/projectile/proj = mover
		// Let through if firer is anywhere in the behind arc (e.g. S, SW, SE all pass a N-facing shield)
		if(proj.firer)
			var/behind = REVERSE_DIR(shield_dir)
			var/firer_dir = get_dir(src, proj.firer)
			if(firer_dir & behind)
				return TRUE
		return FALSE
	return TRUE

/obj/structure/arrow_ward/examine(mob/user)
	. = ..()
	. += span_info("结界泛着微光。正面射来的投射物会被偏转，但你可从后方自由穿行并射击。")
