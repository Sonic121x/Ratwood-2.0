/datum/action/cooldown/spell/form_blade
	name = "塑刃术"
	desc = "仅凭意志与魔力塑成奥术兵器。用 Shift+G 循环切换形态。同时只能存在一种召唤形态。"
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	button_icon_state = "form_blade"
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_FERRAMANCY
	sound = 'sound/combat/weaponr1.ogg'

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = SPELLCOST_FORM_BLADE

	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	cooldown_time = 5 SECONDS
	shared_cooldown = "form_blade"

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/obj/item/conjured_weapon
	/// Index into forms of the currently-selected weapon.
	var/form_index = 1
	/// Selectable forms, cycled with Shift+G. Each: label, weapon path, invocation.
	var/list/forms = list(
		list("label" = "镰剑", "weapon" = /obj/item/rogueweapon/sword/sabre/ferramancy, "say" = "塑成镰刃！"),
		list("label" = "细剑", "weapon" = /obj/item/rogueweapon/sword/rapier/ferramancy, "say" = "塑成锐针！"),
		list("label" = "巨剑", "weapon" = /obj/item/rogueweapon/greatsword/ferramancy, "say" = "塑成巨剑！"),
		list("label" = "巨斧", "weapon" = /obj/item/rogueweapon/greataxe/steel/doublehead/ferramancy, "say" = "塑成双刃斧！"),
		list("label" = "长戟", "weapon" = /obj/item/rogueweapon/halberd/ferramancy, "say" = "塑成长戟！"),
	)

/datum/action/cooldown/spell/form_blade/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/list/f = forms[form_index]
	var/weapon_type = f["weapon"]
	if(!weapon_type)
		return FALSE

	clear_form_weapons(H)

	if(!H.get_empty_held_indexes())
		to_chat(H, span_warning("我需要空出一只手才能塑成这种形态。"))
		return FALSE

	if(f["say"])
		invocations = list(f["say"])
	var/obj/item/W = new weapon_type(H.drop_location())
	if(W.max_integrity)
		W.max_integrity = round(W.max_integrity * 0.5)
		W.obj_integrity = W.max_integrity
	W.AddComponent(/datum/component/conjured_item, "#5c7cff", FALSE, H, src)
	H.put_in_hands(W)
	conjured_weapon = W
	return TRUE

/datum/action/cooldown/spell/form_blade/Grant(mob/grant_to)
	. = ..()
	update_form_maptext(forms[form_index]["label"])

/datum/action/cooldown/spell/form_blade/toggle_alt_mode(mob/user)
	form_index = (form_index % length(forms)) + 1
	var/list/f = forms[form_index]
	update_form_maptext(f["label"])
	to_chat(user, span_notice("奥术武装已塑为：[f["label"]]。"))
	return TRUE

/// Paint the current form's name onto the action button, matching the ward-cycling display.
/datum/action/cooldown/spell/form_blade/proc/update_form_maptext(label)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		if(!B)
			continue
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(label)
		holder.maptext_x = 3
		holder.color = GLOW_COLOR_METAL

/datum/action/cooldown/spell/form_blade/proc/clear_form_weapons(mob/living/carbon/human/H)
	for(var/datum/action/cooldown/spell/form_blade/form in H.actions)
		if(form.conjured_weapon && !QDELETED(form.conjured_weapon))
			form.conjured_weapon.visible_message(span_warning("[form.conjured_weapon]闪烁着消散了！"))
			qdel(form.conjured_weapon)
		form.conjured_weapon = null
