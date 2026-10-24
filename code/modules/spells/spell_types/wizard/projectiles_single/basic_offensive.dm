/datum/action/cooldown/spell/projectile/basic_offensive
	button_icon = 'icons/mob/actions/mage_shared.dmi'
	name = "基础攻击魔法"
	desc = "沿用数百年的基础攻击魔法。激活时用 Shift+G 切换施放模式：\
	奥术箭攻击单一目标，弧线箭越过障碍，灵魂射击则以光束贯穿多名敌人。"
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

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/current_mode = 1
	var/list/modes = list(
		list("name" = "奥术箭", "tag" = "奥术", "proj" = /obj/projectile/magic/greater_arcyne_bolt, "arc" = FALSE, "icon" = "greater_arcyne_bolt", "cost" = SPELLCOST_MINOR_PROJECTILE, "cooldown" = 5.5 SECONDS, "charge" = CHARGETIME_POKE, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/vlightning.ogg', "invocation" = "魔法之矢！"),
		list("name" = "弧线箭", "tag" = "弧线", "proj" = /obj/projectile/magic/greater_arcyne_bolt, "arc" = TRUE, "icon" = "greater_arcyne_bolt", "cost" = SPELLCOST_MINOR_PROJECTILE, "cooldown" = 5.5 SECONDS, "charge" = CHARGETIME_POKE, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/vlightning.ogg', "invocation" = "魔法之矢！"),
		list("name" = "灵魂射击", "tag" = "光束", "proj" = /obj/projectile/magic/soulshot, "arc" = FALSE, "icon" = "soulshot", "cost" = SPELLCOST_MAJOR_PROJECTILE, "cooldown" = 12 SECONDS, "charge" = CHARGETIME_MAJOR, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/soulshot.ogg', "invocation" = "灵魂，出击！"),
	)

/datum/action/cooldown/spell/projectile/basic_offensive/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/basic_offensive/proc/apply_mode(index)
	var/list/mode = modes[index]
	projectile_type = mode["proj"]
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

/datum/action/cooldown/spell/projectile/basic_offensive/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	var/list/mode = modes[current_mode]
	to_chat(user, span_notice("[name]：[mode["name"]]模式。"))

/datum/action/cooldown/spell/projectile/basic_offensive/proc/update_mode_maptext(tag)
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
		holder.color = "#00ccff"

/datum/action/cooldown/spell/projectile/basic_offensive/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	for(var/i in stats)
		if(findtext(i, "弧线模式"))
			stats -= i
			break
	stats += span_info("施放模式（Shift+G 切换）：奥术箭（直射）／弧线箭（越过掩体）／灵魂射击（贯穿光束）。")
	return stats
