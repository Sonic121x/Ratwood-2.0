#define ARCYNE_WARD_FILTER "arcyne_ward_glow"
#define BASE_ARCYNE_INTEGRITY 225
#define UPGRADE_ARCYNE_INTEGRITY 300

/datum/action/cooldown/spell/conjure_arcyne_ward
	source_aspect = /datum/magic_aspect/pseudo/wards
	name = "召唤奥术结界"
	desc = "召出覆盖全身的无形奥术结界。再次施放即可解除。\
	实际护甲覆盖的部位由装备负责，结界会让出对应防护——\
	头盔替代头部，面具替代面部，护手替代双手，\
	臂甲替代双臂，腿甲替代双腿，靴子替代双脚。\
	胸部、要害与腹股沟的防护仅在护甲栏与衬衣栏均有装备时被替代。\
	结界耐久为 225，不会自行恢复，破碎后须重新施放。\
	解除时按剩余耐久返还冷却：满耐久无冷却，完全破碎则完整冷却。\
	引导此法术时无法招架或闪避，因为全部专注都用于召唤。\
	结界生效时，法术栏出现对应的再生结界动作，可完整引导 6 秒修复，消耗随受损程度变化。"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "conjure_armor"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE

	// 70 stamina (green bar) drained up-front at charge start — see on_start_charge().
	// 130-ish energy (blue bar) drained over the charge via hold_drain (5/tick * 5Hz * 6s = 150).
	// Total resource drain is heavy to prevent in-combat re-cast abuse.
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 130
	/// Flat stamina hit taken the instant channeling begins, even if the cast is interrupted.
	var/upfront_stamina_cost = 70

	invocations = list("庇护，凝聚！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_time = 6 SECONDS
	charge_slowdown = 3
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES
	blocks_defense_while_channeling = TRUE

	associated_skill = /datum/skill/magic/arcane
	point_cost = 2
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	charge_swingdelay_type = SWINGDELAY_CANCEL
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE

	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/conjured_ward
	var/ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward
	var/dismiss_invocation = "庇护，消散！"
	var/regen_invocation = "庇护，复原！"
	/// Paired regen action - granted alongside the conjure spell itself and lives as long as it does.
	/// IsAvailable() on the regen gates by ward existence, so it sits inert (red) when no ward is active.
	var/datum/action/cooldown/spell/regenerate_arcyne_ward/regen_action
	/// Regen spell path paired with this conjure variant. Children override to their matching regen subtype.
	var/regen_spell_type = /datum/action/cooldown/spell/regenerate_arcyne_ward

/datum/action/cooldown/spell/conjure_arcyne_ward/before_cast(atom/cast_on)
	var/dismissing = conjured_ward && !QDELETED(conjured_ward)
	// Dismiss is instant - temporarily zero charge time, and skip the up-front stamina hit
	var/saved_charge_time
	var/saved_upfront
	if(dismissing)
		saved_charge_time = charge_time
		charge_time = 0
		saved_upfront = upfront_stamina_cost
		upfront_stamina_cost = 0
	. = ..()
	if(dismissing)
		charge_time = saved_charge_time
		upfront_stamina_cost = saved_upfront
	. |= SPELL_NO_IMMEDIATE_COOLDOWN
	if(dismissing)
		// Dismiss doesn't cost stamina, and we handle invocation manually in cast()
		. |= SPELL_NO_IMMEDIATE_COST | SPELL_NO_FEEDBACK

/datum/action/cooldown/spell/conjure_arcyne_ward/on_start_charge()
	. = ..()
	if(upfront_stamina_cost > 0 && isliving(owner))
		var/mob/living/L = owner
		var/adjusted = get_adjusted_cost(upfront_stamina_cost)
		if(adjusted > 0)
			L.stamina_add(adjusted)

/datum/action/cooldown/spell/conjure_arcyne_ward/Grant(mob/grant_to)
	. = ..()
	if(!owner)
		return
	if(!regen_action)
		regen_action = new regen_spell_type(owner)
		regen_action.parent_spell = src
	regen_action.Grant(owner)

/datum/action/cooldown/spell/conjure_arcyne_ward/Remove(mob/living/remove_from)
	if(regen_action)
		regen_action.Remove(remove_from)
	return ..()

/datum/action/cooldown/spell/conjure_arcyne_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Dismiss active ward with proportional cooldown refund
	if(conjured_ward && !QDELETED(conjured_ward))
		var/integrity_ratio = conjured_ward.obj_integrity / conjured_ward.max_integrity
		H.say(dismiss_invocation, forced = "spell", language = /datum/language/common)
		to_chat(owner, span_notice("我解除了奥术结界。"))
		conjured_ward.dismissed = TRUE
		qdel(conjured_ward)
		// Cooldown scales inversely with remaining integrity - full HP = no cooldown, 0 HP = full cooldown
		var/adjusted_cooldown = get_adjusted_cooldown() * (1 - integrity_ratio)
		StartCooldown(adjusted_cooldown)
		return TRUE

	if(H.skin_armor)
		if(!istype(H.skin_armor, /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward))
			to_chat(owner, span_warning("已有其他力量保护着我的皮肤！"))
			return FALSE
		var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/existing = H.skin_armor
		if(existing.arcyne_armor_tier > initial(ward_type:arcyne_armor_tier))
			to_chat(owner, span_warning("已有更强的结界保护我！"))
			return FALSE

	// Toggle on - conjure ward, no cooldown (button stays available for dismiss)
	owner.visible_message(span_notice("一道奥术结界在[owner]周围闪烁着成形！"))
	conjured_ward = new ward_type(H)
	H.skin_armor = conjured_ward
	conjured_ward.setup_ward(H)
	conjured_ward.linked_spell = src
	reset_spell_cooldown()
	// Wake the paired regen button up now that there's a live ward to mend
	regen_action?.build_all_button_icons()
	return TRUE

/datum/action/cooldown/spell/conjure_arcyne_ward/Destroy()
	if(conjured_ward && !QDELETED(conjured_ward))
		conjured_ward.visible_message(span_warning("奥术结界闪烁着消散！"))
		qdel(conjured_ward)
	QDEL_NULL(regen_action)
	return ..()

/datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide
	name = "召唤龙鳞结界"
	desc = "召出龙鳞结界——以龙鳞强化的奥术结界。\
	提供抗火能力，火焰伤害减半，身上的火焰更快熄灭。耐久 300。\
	其余机制同普通奥术结界：让位于实际护甲，不会自行恢复。\
	再次施放可解除。解除或摧毁后开始冷却。"
	button_icon_state = "conjure_dragonhide"
	spell_color = GLOW_COLOR_METAL
	invocations = list("龙鳞，凝聚！")
	dismiss_invocation = "龙鳞，消散！"
	regen_invocation = "龙鳞，复原！"
	point_cost = 4
	exclusive_group = "arcyne_ward"
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dragonhide
	regen_spell_type = /datum/action/cooldown/spell/regenerate_arcyne_ward/dragonhide

/datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide
	name = "召唤晶肤结界"
	desc = "召出晶肤结界——以地脉能量结晶化的奥术结界。\
	提供布面甲级别的防护。破碎时猛烈爆裂，击退附近敌人。耐久 300。\
	其余机制同普通奥术结界：让位于实际护甲，不会自行恢复。\
	再次施放可解除。解除或摧毁后开始冷却。"
	button_icon_state = "conjure_dragonhide"
	spell_color = GLOW_COLOR_ARCANE
	invocations = list("灵晶，凝聚！")
	dismiss_invocation = "灵晶，消散！"
	regen_invocation = "灵晶，复原！"
	charge_time = 6 SECONDS
	point_cost = 4
	spell_tier = 3
	exclusive_group = "arcyne_ward"
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide
	regen_spell_type = /datum/action/cooldown/spell/regenerate_arcyne_ward/crystalhide

// --- Regenerate Arcyne Ward (paired spell, granted while a ward is active) ---

/datum/action/cooldown/spell/regenerate_arcyne_ward
	source_aspect = /datum/magic_aspect/pseudo/wards
	name = "再生奥术结界"
	desc = "引导修复现有奥术结界，将其恢复至满耐久。\
	引导需要 10 秒，体力与能量消耗随结界受损程度变化——\
	近乎完好的结界几乎不耗资源，破碎的结界则接近重新施放的消耗。\
	引导此法术时无法招架或闪避。"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "conjure_armor"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE

	// Costs are scaled at cast time in before_cast() by ward damage.
	// Values here mirror the full-fresh conjure cost so damage_ratio=1 equals a re-cast.
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 130
	var/upfront_stamina_cost = 70

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_time = 10 SECONDS
	hold_drain = 1
	charge_slowdown = 3
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES
	blocks_defense_while_channeling = TRUE

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE

	/// Back-reference to the conjure spell that owns this action, set by grant_regen_action().
	var/datum/action/cooldown/spell/conjure_arcyne_ward/parent_spell

/datum/action/cooldown/spell/regenerate_arcyne_ward/Grant(mob/grant_to)
	. = ..()
	update_regen_maptext()

/datum/action/cooldown/spell/regenerate_arcyne_ward/proc/update_regen_maptext()
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
		holder.maptext = MAPTEXT("<b>再生</b>")
		holder.maptext_x = 2
		holder.color = GLOW_COLOR_ARCANE

/datum/action/cooldown/spell/regenerate_arcyne_ward/IsAvailable(feedback = FALSE)
	if(!parent_spell || QDELETED(parent_spell))
		return FALSE
	if(!parent_spell.conjured_ward || QDELETED(parent_spell.conjured_ward))
		return FALSE
	return ..()

/// Fraction of the ward's max integrity that's missing. 0 at full HP, 1 at zero HP.
/// Drives the proportional resource cost for both check_cost (button state) and before_cast (actual spend).
/datum/action/cooldown/spell/regenerate_arcyne_ward/proc/get_damage_ratio()
	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ward = parent_spell?.conjured_ward
	if(!ward || QDELETED(ward) || !ward.max_integrity)
		return 0
	return 1 - (ward.obj_integrity / ward.max_integrity)

/datum/action/cooldown/spell/regenerate_arcyne_ward/check_cost(feedback = TRUE)
	// IsAvailable, and therefore the button's red state, calls into check_cost. Scale the
	// primary cost the same way before_cast does so the button reflects the real cost, not
	// the unscaled max - otherwise a half-damaged ward shows red whenever you're below full energy.
	var/damage_ratio = get_damage_ratio()
	var/saved_primary = primary_resource_cost
	primary_resource_cost = round(primary_resource_cost * damage_ratio)
	. = ..()
	primary_resource_cost = saved_primary

/datum/action/cooldown/spell/regenerate_arcyne_ward/before_cast(atom/cast_on)
	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ward = parent_spell?.conjured_ward
	if(!ward || QDELETED(ward))
		return ..() | SPELL_CANCEL_CAST

	var/damage_ratio = get_damage_ratio()
	var/saved_upfront = upfront_stamina_cost
	var/saved_drain = hold_drain
	var/saved_primary = primary_resource_cost
	upfront_stamina_cost = round(upfront_stamina_cost * damage_ratio)
	hold_drain = round(hold_drain * damage_ratio)
	primary_resource_cost = round(primary_resource_cost * damage_ratio)

	. = ..()

	upfront_stamina_cost = saved_upfront
	hold_drain = saved_drain
	primary_resource_cost = saved_primary

/datum/action/cooldown/spell/regenerate_arcyne_ward/on_start_charge()
	. = ..()
	if(upfront_stamina_cost > 0 && isliving(owner))
		var/mob/living/L = owner
		var/adjusted = get_adjusted_cost(upfront_stamina_cost)
		if(adjusted > 0)
			L.stamina_add(adjusted)

/datum/action/cooldown/spell/regenerate_arcyne_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ward = parent_spell?.conjured_ward
	if(!ward || QDELETED(ward))
		return FALSE
	H.say(parent_spell.regen_invocation, forced = "spell", language = /datum/language/common)
	to_chat(H, span_notice("我的结界闪烁着，完全恢复了。"))
	if(ward.obj_broken)
		ward.obj_fix(H, full_repair = TRUE)
	else
		ward.obj_integrity = ward.max_integrity
	ward.recalculate_coverage(force_full = TRUE)
	return TRUE

/datum/action/cooldown/spell/regenerate_arcyne_ward/dragonhide
	name = "再生龙鳞结界"
	spell_tier = 2

/datum/action/cooldown/spell/regenerate_arcyne_ward/crystalhide
	name = "再生晶肤结界"
	spell_tier = 3

// --- The Ward Item ---

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward
	name = "奥术结界"
	desc = "保护穿戴者的无形奥术能量屏障。"
	icon_state = null
	break_sound = 'sound/magic/magic_nulled.ogg'

	body_parts_covered = COVERAGE_FULL_BODY_ACTUAL
	body_parts_inherent = COVERAGE_FULL_BODY_ACTUAL
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_LEATHER
	max_integrity = BASE_ARCYNE_INTEGRITY

	blocksound = SOFTHIT

	var/datum/action/cooldown/spell/conjure_arcyne_ward/linked_spell
	var/mob/living/carbon/human/ward_owner
	var/dismissed = FALSE
	var/ward_color = GLOW_COLOR_ARCANE
	var/arcyne_armor_tier = ARCYNE_WARD_TIER_BASE
	var/yields_to_armor = TRUE

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/setup_ward(mob/living/carbon/human/H)
	ward_owner = H
	RegisterSignal(H, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_owner_equip_change))
	RegisterSignal(H, COMSIG_MOB_DROPITEM, PROC_REF(on_owner_equip_change))
	recalculate_coverage(force_full = TRUE)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/on_owner_equip_change(datum/source, obj/item/item)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(recalculate_coverage)), 1)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/recalculate_coverage(force_full = FALSE)
	if(QDELETED(src) || !ward_owner)
		return

	var/new_coverage = COVERAGE_FULL_BODY_ACTUAL

	if(!yields_to_armor)
		body_parts_covered_dynamic = new_coverage
		return

	var/mob/living/carbon/human/H = ward_owner

	if(has_real_armor(H.head))
		new_coverage &= ~(HEAD | HAIR | EARS)

	if(has_real_armor(H.wear_mask))
		new_coverage &= ~(NOSE | MOUTH)

	if(has_real_armor(H.wear_shirt) && has_real_armor(H.wear_armor))
		new_coverage &= ~(CHEST | GROIN | VITALS)

	if(has_real_armor(H.wear_armor, ARM_LEFT | ARM_RIGHT) || has_real_armor(H.wear_shirt, ARM_LEFT | ARM_RIGHT))
		new_coverage &= ~(ARM_LEFT | ARM_RIGHT)

	if(has_real_armor(H.gloves))
		new_coverage &= ~(HAND_LEFT | HAND_RIGHT)

	if(has_real_armor(H.wear_pants))
		new_coverage &= ~(LEG_LEFT | LEG_RIGHT)

	if(has_real_armor(H.shoes))
		new_coverage &= ~(FOOT_LEFT | FOOT_RIGHT)

	if(!force_full)
		new_coverage &= body_parts_covered_dynamic
	body_parts_covered_dynamic = new_coverage

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/has_real_armor(obj/item/clothing/C, coverage_check)
	if(!C || !istype(C))
		return FALSE
	if(!piece_is_armor(C))
		return FALSE
	if(coverage_check)
		return (C.body_parts_covered_dynamic & coverage_check)
	return TRUE

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/piece_is_armor(obj/item/clothing/C)
	if(C.armor_class > ARMOR_CLASS_NONE)
		return TRUE
	if(!C.armor)
		return FALSE
	return (C.armor.getRating("blunt") > 0 || C.armor.getRating("slash") > 0 \
		|| C.armor.getRating("stab") > 0 || C.armor.getRating("piercing") > 0)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	if(ward_owner && damage_amount > 0)
		var/turf/T = get_turf(ward_owner)
		new /obj/effect/temp_visual/spell_impact(T, GLOW_COLOR_ARCANE, SPELL_IMPACT_LOW)
		playsound(T, 'sound/magic/clang.ogg', 50, TRUE)
		flash_ward()
		if(prob(50))
			do_sparks(2, FALSE, T)
	return ..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/flash_ward()
	if(!ward_owner)
		return
	ward_owner.remove_filter(ARCYNE_WARD_FILTER)
	ward_owner.add_filter(ARCYNE_WARD_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_ARCANE, "alpha" = 80, "size" = 1))
	addtimer(CALLBACK(src, PROC_REF(clear_flash)), 3)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/clear_flash()
	if(ward_owner)
		ward_owner.remove_filter(ARCYNE_WARD_FILTER)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dropped(mob/user, silent)
	..()
	cleanup_ward()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/Destroy()
	cleanup_ward()
	return ..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_filter(ARCYNE_WARD_FILTER)
		UnregisterSignal(ward_owner, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_DROPITEM))
		if(ward_owner.skin_armor == src)
			ward_owner.skin_armor = null
		ward_owner = null
	if(linked_spell)
		// Start full cooldown only when destroyed in combat (not dismissed - dismiss handles its own proportional cooldown)
		if(!QDELETED(linked_spell) && !dismissed)
			linked_spell.StartCooldown(linked_spell.get_adjusted_cooldown())
		linked_spell.conjured_ward = null
		// Refresh the paired regen's button state so it goes red now that the ward is gone
		linked_spell.regen_action?.build_all_button_icons()
		linked_spell = null

// --- Dragonhide Ward Item ---

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dragonhide
	name = "龙鳞结界"
	desc = "以龙鳞强化的奥术结界，能够抵御火焰。"
	armor = ARMOR_DRAGONHIDE
	max_integrity = UPGRADE_ARCYNE_INTEGRITY
	ward_color = GLOW_COLOR_FIRE
	arcyne_armor_tier = ARCYNE_WARD_TIER_GREATER

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dragonhide/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/dragonhide)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dragonhide/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/dragonhide)
	..()

// --- Crystalhide Ward Item ---

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide
	name = "晶肤结界"
	desc = "以地脉能量结晶化的奥术结界。能抵抗钝力，却不如板甲坚硬。破碎时会猛烈爆裂。"
	armor = ARMOR_BRIGANDINE
	max_integrity = UPGRADE_ARCYNE_INTEGRITY
	ward_color = GLOW_COLOR_KINESIS
	arcyne_armor_tier = ARCYNE_WARD_TIER_GREATER

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/crystalhide)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/crystalhide)
	..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide/obj_break()
	if(ward_owner)
		blast_back(ward_owner)
	..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide/proc/blast_back(mob/living/wearer)
	if(!wearer)
		return
	for(var/mob/living/target in oview(1, wearer))
		var/throwtarget = get_edge_target_turf(wearer, get_dir(wearer, get_step_away(target, wearer)))
		target.safe_throw_at(throwtarget, 2, 1, wearer, spin = FALSE, force = MOVE_FORCE_EXTREMELY_STRONG)
		target.adjustBruteLoss(20)

#undef ARCYNE_WARD_FILTER
#undef BASE_ARCYNE_INTEGRITY
#undef UPGRADE_ARCYNE_INTEGRITY
