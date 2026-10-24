/datum/action/cooldown/spell/projectile/fetch
	name = "牵引术"
	desc = "射出魔法箭，将独立放置的物品拉向施法者。对活物无效。"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "fetch"
	sound = 'sound/magic/magnet.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("收回小物")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 8 SECONDS

	projectile_type = /obj/projectile/magic/fetch

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_LOW
	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	allow_cross_z = FALSE

/obj/projectile/magic/fetch
	name = "牵引魔箭"
	icon_state = "cursehand0"
	flag = "blunt"
	range = 15
	cannot_cross_z = TRUE

/obj/projectile/magic/fetch/on_hit(target)
	. = ..()
	var/atom/throw_target = get_step(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		L.visible_message(span_warning("[src]触及[target]时消失！"))
		return BULLET_ACT_BLOCK
	else
		if(isitem(target))
			var/obj/item/I = target
			if(I.anchored || I.move_resist >= MOVE_FORCE_STRONG)
				return
			var/mob/living/carbon/human/carbon_firer
			if (ishuman(firer))
				carbon_firer = firer
				if (carbon_firer?.can_catch_item())
					throw_target = get_turf(firer)
			I.throw_at(throw_target, 200, 3)
