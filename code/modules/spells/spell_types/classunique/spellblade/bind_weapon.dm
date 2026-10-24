/datum/action/cooldown/spell/bind_weapon
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "武器绑定"
	desc = "将手持武器绑定为奥术导体。绑定武器成功打击时会积累奥术动量，为能力提供力量。\
		也可用武器召回来将其从任意位置召回手中。\
		武器必须符合你的战颂流派——剑刃需剑或匕首，方阵武士需长柄武器，执锤者需钉头锤或战锤。\
		重新绑定可恢复丢失的奥术动量状态；旧武器被毁时也可绑定新武器。\
		空手施放可解除当前武器的绑定。"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "bind_weapon"
	sound = 'sound/magic/charged.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_POKE

	invocations = list("奥术，缔结。")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/bind_weapon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/weapon = H.get_active_held_item()
	if(!weapon)
		// Empty hands - unbind current weapon if one exists
		var/datum/status_effect/buff/arcyne_momentum/unbind_M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(unbind_M?.bound_weapon && !QDELETED(unbind_M.bound_weapon))
			var/datum/component/arcyne_conduit/old_conduit = unbind_M.bound_weapon.GetComponent(/datum/component/arcyne_conduit)
			if(old_conduit)
				qdel(old_conduit)
			to_chat(H, span_notice("[unbind_M.bound_weapon]上的奥术联结消散了。我已解除绑定。"))
			playsound(get_turf(H), 'sound/magic/charging.ogg', 30, TRUE)
			unbind_M.bound_weapon = null
			return TRUE
		to_chat(H, span_warning("我没有可解除绑定的武器！"))
		return FALSE

	var/datum/component/arcyne_conduit/existing_conduit = weapon.GetComponent(/datum/component/arcyne_conduit)
	if(existing_conduit)
		var/mob/living/existing_owner = existing_conduit.owner_ref?.resolve()
		if(existing_owner && existing_owner != H)
			to_chat(H, span_warning("[weapon]已被另一位魔剑士绑定！"))
			return FALSE
		if(existing_owner == H)
			to_chat(H, span_warning("[weapon]已经是我的绑定导体了！"))
			return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		M = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)

	if(M?.chant)
		var/valid = FALSE
		var/list/valid_skills
		switch(M.chant)
			if("blade")
				valid_skills = list(/datum/skill/combat/swords, /datum/skill/combat/knives)
			if("phalangite")
				valid_skills = list(/datum/skill/combat/polearms)
			if("macebearer")
				valid_skills = list(/datum/skill/combat/maces, /datum/skill/combat/axes)
		if(valid_skills)
			valid = (weapon.associated_skill in valid_skills)
		if(!valid)
			to_chat(H, span_warning("这件武器不符合我的战颂流派！"))
			return FALSE

	if(M?.bound_weapon && !QDELETED(M.bound_weapon))
		var/datum/component/arcyne_conduit/old_conduit = M.bound_weapon.GetComponent(/datum/component/arcyne_conduit)
		if(old_conduit)
			qdel(old_conduit)
		to_chat(H, span_notice("[M.bound_weapon]上的奥术联结消散了。"))

	weapon.AddComponent(/datum/component/arcyne_conduit, owner = H)
	if(M)
		M.bound_weapon = weapon
	to_chat(H, span_notice("我将[weapon]绑定为奥术导体。它的打击将积累动量。"))
	playsound(get_turf(H), 'sound/magic/charged.ogg', 50, TRUE)
	H.visible_message(span_notice("[H]将手拂过[weapon]，武器开始泛起微光。"))
	return TRUE
