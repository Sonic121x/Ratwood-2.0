#define BATTLE_WARD_RUNE_DURATION (1 MINUTES)
#define BATTLE_WARD_TELEGRAPH_TIME (3 SECONDS)

/datum/action/cooldown/spell/battle_ward
	button_icon = 'icons/mob/actions/mage_battlewardry.dmi'
	name = "战斗符阵"
	desc = "引导奥术能量，在目标区域以 X 形布下五道符文结界。符文脆弱，一分钟后消散。与永久符文结界不同，战斗符阵不分敌我，也会攻击施法者及盟友。跳跃或飞越可避开，几次扎实打击即可摧毁。符文种类取决于当前结界模式。\n\
	使用替代模式快捷键，在眩晕、火焰、寒冷与伤害之间切换。"
	button_icon_state = "battle_ward"
	sound = 'sound/magic/charging.ogg'
	spell_color = GLOW_COLOR_WARD
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_BATTLEWARDRY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("战阵，铭刻！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/ward_mode = RUNE_WARD_STUN
	var/list/ward_modes = list(RUNE_WARD_STUN, RUNE_WARD_FIRE, RUNE_WARD_CHILL, RUNE_WARD_DAMAGE)
	var/static/list/ward_mode_labels = list(RUNE_WARD_STUN = "眩晕", RUNE_WARD_FIRE = "火焰", RUNE_WARD_CHILL = "寒冷", RUNE_WARD_DAMAGE = "伤害")

/datum/action/cooldown/spell/battle_ward/Grant(mob/grant_to)
	. = ..()
	update_ward_maptext()

/datum/action/cooldown/spell/battle_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/rune_path = get_rune_path()
	if(!rune_path)
		return FALSE

	// X pattern: center + 4 corners
	var/list/target_turfs = list()
	target_turfs += center
	target_turfs += get_step(center, NORTHWEST)
	target_turfs += get_step(center, NORTHEAST)
	target_turfs += get_step(center, SOUTHWEST)
	target_turfs += get_step(center, SOUTHEAST)

	// Show telegraph visuals before runes appear
	for(var/turf/T in target_turfs)
		new /obj/effect/temp_visual/telegraph/wall/battle_ward(T)

	playsound(center, 'sound/magic/whiteflame.ogg', 60, TRUE)
	H.visible_message(span_warning("[H]完成复杂的铭刻——符文开始显现！"), span_notice("我完成了[ward_mode]结界图案的铭刻。"))

	addtimer(CALLBACK(src, PROC_REF(spawn_runes), target_turfs, rune_path, H.real_name, H.ckey || "no ckey"), BATTLE_WARD_TELEGRAPH_TIME)
	return TRUE

/datum/action/cooldown/spell/battle_ward/proc/spawn_runes(list/turfs, rune_path, caster_name, caster_ckey)
	for(var/turf/T in turfs)
		var/obj/structure/rune_ward/rune = new rune_path(T)
		rune.owner_name = caster_name
		rune.owner_ckey = caster_ckey
		rune.max_integrity = 50
		rune.obj_integrity = 50
		QDEL_IN(rune, BATTLE_WARD_RUNE_DURATION)

/datum/action/cooldown/spell/battle_ward/proc/get_rune_path()
	switch(ward_mode)
		if(RUNE_WARD_STUN)
			return /obj/structure/rune_ward/stun
		if(RUNE_WARD_FIRE)
			return /obj/structure/rune_ward/fire
		if(RUNE_WARD_CHILL)
			return /obj/structure/rune_ward/chill
		if(RUNE_WARD_DAMAGE)
			return /obj/structure/rune_ward/damage
	return null

/datum/action/cooldown/spell/battle_ward/toggle_alt_mode(mob/user)
	var/current_index = ward_modes.Find(ward_mode)
	current_index = (current_index % length(ward_modes)) + 1
	ward_mode = ward_modes[current_index]
	var/label = ward_mode_labels[ward_mode] || uppertext(ward_mode)
	to_chat(user, span_notice("结界模式已设为：[label]。"))
	update_ward_maptext()
	return TRUE

/datum/action/cooldown/spell/battle_ward/proc/update_ward_maptext()
	var/label = ward_mode_labels[ward_mode]
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(label)
		holder.maptext_x = 5
		holder.color = GLOW_COLOR_WARD

/obj/effect/temp_visual/telegraph/wall/battle_ward
	light_color = GLOW_COLOR_WARD
	duration = BATTLE_WARD_TELEGRAPH_TIME

#undef BATTLE_WARD_RUNE_DURATION
#undef BATTLE_WARD_TELEGRAPH_TIME
