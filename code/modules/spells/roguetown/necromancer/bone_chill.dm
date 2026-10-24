/datum/action/cooldown/spell/bonechill
	name = "彻骨寒意"
	desc = "以死灵魔力的爆发冷彻目标。对活物施加强力减速，并进一步降低力量与速度；对亡灵则治疗所选肢体。无法对自己施放。"
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "bone_chill"
	spell_color = GLOW_COLOR_ZIZO

	cast_range = 7
	sound = 'sound/magic/whiteflame.ogg'
	spell_tier = 2
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE
	primary_resource_type = SPELL_COST_STAMINA
	charge_required = TRUE
	charge_time = 5
	associated_skill = /datum/skill/magic/arcane
	cooldown_time = 15 SECONDS
	spell_requirements = SPELL_REQUIRES_SAME_Z
	self_cast_possible = FALSE
	zizo_spell = TRUE

/datum/action/cooldown/spell/bonechill/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/bonechill/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(target.mob_biotypes & MOB_UNDEAD)
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(owner.zone_selected))
		if(affecting && (affecting.heal_damage(50, 50) || affecting.heal_wounds(50)))
			target.update_damage_overlays()
		target.visible_message(span_danger("[target]在邪恶能量中重塑形体！"), span_notice("黑暗魔法重塑了我！"))
		return TRUE

	target.visible_message(span_info("死灵能量漫涌过 [target]！"), span_userdanger("黑暗能量灌入体内，我只觉得愈发寒冷！"))
	if(iscarbon(target))
		target.apply_status_effect(/datum/status_effect/debuff/chilled)
	else
		target.adjustBruteLoss(20)
	return TRUE
