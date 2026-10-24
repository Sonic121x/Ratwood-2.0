/datum/action/cooldown/spell/bestow_ward
	source_aspect = /datum/magic_aspect/battlewardry
	name = "赐予结界"
	desc = "引导奥术能量，以保护结界包裹盟友。结界为全身提供轻甲防护，\
	可覆盖在实际护甲之外。持续 3 分钟，或直到被摧毁。\
	无法替换同等或更强的现有结界。 "
	button_icon = 'icons/mob/actions/mage_battlewardry.dmi'
	button_icon_state = "bestow_ward"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_WARD
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_BATTLEWARDRY

	click_to_activate = TRUE
	cast_range = 4
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("赐予庇护！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1.5 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed
	var/ward_duration = 3 MINUTES

/datum/action/cooldown/spell/bestow_ward/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		return FALSE

	var/mob/living/carbon/human/target = cast_on
	if(!ishuman(target))
		to_chat(caster, span_warning("我只能为人赐予结界。"))
		return FALSE

	if(target == caster)
		to_chat(caster, span_warning("我不能对自己赐予结界。"))
		return FALSE

	if(target.skin_armor)
		if(!istype(target.skin_armor, /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward))
			to_chat(caster, span_warning("[target]已有超出我能力的力量保护。"))
			return FALSE

		var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/existing = target.skin_armor

		if(existing.arcyne_armor_tier > ARCYNE_WARD_TIER_OTHER)
			to_chat(caster, span_warning("[target]已有更强的结界。"))
			return FALSE

		if(istype(existing, /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed))
			var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/B = existing

			// Damaged ward: restore it, consuming duration based on repaired durability.
			if(B.obj_integrity < B.max_integrity)
				var/restored = B.max_integrity - B.obj_integrity

				var/time_remaining = max(0, B.expires_at - world.time)
				var/time_penalty = restored * 5 SECONDS

				qdel(B)

				var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/newward = new ward_type(target)
				target.skin_armor = newward
				newward.setup_ward(target)

				// If repairing would consume over half the remaining duration,
				// rebuild the ward from scratch with a fresh timer.
				if(time_penalty > (time_remaining / 2))
					newward.set_duration(ward_duration)

					target.visible_message(span_notice("奥术之力涌动，[target]的奥术结界被彻底重建！"))
					to_chat(caster, span_notice("我从头重建了[target]的结界。"))
				else
					var/new_duration = max(10 SECONDS, time_remaining - time_penalty)

					newward.set_duration(new_duration)

					target.visible_message(span_notice("[target]受损的奥术结界恢复了全部强度！"))
					to_chat(caster, span_notice("我牺牲部分剩余持续时间，修复了[target]的结界。"))

				return TRUE

			// Undamaged ward: extend duration.
			B.extend_duration(ward_duration)

			target.visible_message(span_notice("[target]的奥术结界亮了起来，持续时间延长了！"))
			to_chat(caster, span_notice("我加固了[target]的结界。"))
			return TRUE

	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/ward = new ward_type(target)
	target.skin_armor = ward
	ward.setup_ward(target)
	ward.set_duration(ward_duration)

	target.visible_message(span_notice("一道奥术结界在[target]周围闪烁着成形！"))
	to_chat(caster, span_notice("我为[target]赐予奥术结界。"))
	return TRUE

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed
	name = "受赐结界"
	desc = "由另一位法师施加的奥术结界。无法主动解除，只能等待其消退或被摧毁。"
	max_integrity = 200
	arcyne_armor_tier = ARCYNE_WARD_TIER_OTHER
	ward_color = GLOW_COLOR_WARD
	armor = ARMOR_BRIGANDINE
	yields_to_armor = FALSE
	var/duration_timer
	var/expires_at = 0


/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/proc/set_duration(duration)
	if(duration_timer)
		deltimer(duration_timer)
	expires_at = world.time + duration
	duration_timer = QDEL_IN_STOPPABLE(src, duration)


/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/proc/extend_duration(duration)
	var/time_remaining = max(0, expires_at - world.time)
	if(duration_timer)
		deltimer(duration_timer)
	expires_at = world.time + time_remaining + duration
	duration_timer = QDEL_IN_STOPPABLE(src, time_remaining + duration)


/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/Destroy()
	if(duration_timer)
		deltimer(duration_timer)
		duration_timer = null
	return ..()


/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/obj_break(damage_flag)
	if(obj_broken)
		return
	obj_broken = TRUE
	if(ward_owner)
		ward_owner.visible_message(span_yellow("<i>[ward_owner]的受赐结界碎成尘埃！</i>"))
	if(break_sound)
		playsound(get_turf(src), break_sound, 120, TRUE)
	addtimer(CALLBACK(src, PROC_REF(shatter_delete)), 0)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/proc/shatter_delete()
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/setup_ward(mob/living/carbon/human/H)
	ward_owner = H
	RegisterSignal(H, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_owner_equip_change))
	RegisterSignal(H, COMSIG_MOB_DROPITEM, PROC_REF(on_owner_equip_change))
	recalculate_coverage()
	H.add_filter("bestowed_ward_glow", 2, list("type" = "outline", "color" = ward_color, "alpha" = 200, "size" = 1))


/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_filter("bestowed_ward_glow")
	..()
