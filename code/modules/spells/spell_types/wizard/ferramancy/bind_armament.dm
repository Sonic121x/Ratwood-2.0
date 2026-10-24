/datum/action/cooldown/spell/bind_armament
	name = "兵器绑定"
	desc = "绑定一件武器，将其适用技能改为奥术武装。解除绑定后恢复原技能。空手施放可解除；他人拿起武器时，联结会断裂。"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "bind_weapon"
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_FERRAMANCY
	sound = 'sound/magic/charged.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("钢铁，缔结。")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = CHARGETIME_MINOR
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	cooldown_time = 3 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 2
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/bind_skill = /datum/skill/combat/arcyne
	var/obj/item/bound

/datum/action/cooldown/spell/bind_armament/Destroy()
	release_bind()
	return ..()

/datum/action/cooldown/spell/bind_armament/proc/release_bind()
	if(bound && !QDELETED(bound))
		var/datum/component/skill_bind/existing = bound.GetComponent(/datum/component/skill_bind)
		if(existing)
			qdel(existing)
	bound = null

/datum/action/cooldown/spell/bind_armament/proc/get_bound_weapon()
	if(bound && !QDELETED(bound) && bound.GetComponent(/datum/component/skill_bind))
		return bound
	bound = null
	return null

/datum/action/cooldown/spell/bind_armament/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/weapon = H.get_active_held_item()
	if(!weapon)
		var/obj/item/current_bound = get_bound_weapon()
		if(current_bound)
			to_chat(H, span_notice("[current_bound]上的奥术联结消散了。"))
			release_bind()
			return TRUE
		to_chat(H, span_warning("我没有可解除绑定的武器！"))
		return FALSE
	if(!istype(weapon, /obj/item/rogueweapon) || !ispath(weapon.associated_skill, /datum/skill/combat))
		to_chat(H, span_warning("我的技艺无法引导[weapon]。"))
		return FALSE
	if(weapon.GetComponent(/datum/component/skill_bind))
		to_chat(H, span_warning("[weapon]已承载奥术联结。"))
		return FALSE
	release_bind()
	weapon.AddComponent(/datum/component/skill_bind, bind_skill, H)
	bound = weapon
	to_chat(H, span_notice("我为[weapon]施加奥术联结；如今它响应我的召唤术训练。"))
	playsound(get_turf(H), 'sound/magic/charged.ogg', 50, TRUE)
	H.visible_message(span_notice("[H]将手拂过[weapon]，武器泛起微光。"))
	return TRUE
