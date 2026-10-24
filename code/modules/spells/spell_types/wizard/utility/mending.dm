/datum/action/cooldown/spell/mending
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "修补术"
	desc = "以奥术能量修补物品、义肢或人造生物。修复效果随智力提高。"
	button_icon_state = "mending"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = SPELL_RANGE_GROUND
	charge_required = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("裂痕，复原。")
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/repair_percent = 0.20
	var/int_bonus = 0.00

/datum/action/cooldown/spell/mending/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE

	// ITEM PATH (unchanged)
	if(istype(cast_on, /obj/item))
		var/obj/item/I = cast_on

		if(!I.anvilrepair && !I.sewrepair)
			if(owner)
				to_chat(owner, span_warning("连魔法也无法修补这件物品！"))
			return FALSE

		if(I.obj_integrity >= I.max_integrity && I.body_parts_covered_dynamic == I.body_parts_covered)
			if(owner)
				to_chat(owner, span_info("[I]看起来完好无损。"))
			return FALSE

		return TRUE

	// MOB PATH
	if(istype(cast_on, /mob/living))
		var/mob/living/M = cast_on

		// IRONMAN allowed
		if(HAS_TRAIT(M, TRAIT_IRONMAN))
			if(M.getBruteLoss() <= 0 && M.getFireLoss() <= 0)
				if(owner)
					to_chat(owner, span_info("[M]看起来完好无损。"))
				return FALSE
			return TRUE

		// PROSTHETIC CHECK (humans only)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(!BP || QDELETED(BP))
					continue
				if(BP.status == BODYPART_ROBOTIC && (BP.brute_dam > 0 || BP.burn_dam > 0 || length(BP.wounds)))
					return TRUE

		if(owner)
			to_chat(owner, span_warning("这里没有魔法能够修补的东西。"))
		return FALSE

	if(owner)
		to_chat(owner, span_warning("我需要瞄准有实体的东西！"))
	return FALSE

/datum/action/cooldown/spell/mending/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	// ITEM PATH
	if(istype(cast_on, /obj/item))
		var/obj/item/I = cast_on

		user.visible_message(
			span_warning("[user]开始专注于[I]……"),
			span_notice("我开始专注于[I]……")
		)

		if(!do_after(user, 4 SECONDS, TRUE, I, TRUE))
			to_chat(user, span_warning("我的专注被打断了！我没能修好[I]。"))
			return FALSE

		repair_percent = initial(repair_percent)
		int_bonus = CLAMP((user.STAINT * 0.01), 0.01, 0.9)
		repair_percent += int_bonus
		repair_percent *= I.max_integrity

		I.obj_integrity = min(I.obj_integrity + repair_percent, I.max_integrity)

		user.visible_message(span_info("[I]泛起微弱的修补光辉。"))
		playsound(I, 'sound/magic/mending.ogg', 35, TRUE, -2)

		if(I.obj_integrity >= I.max_integrity)
			if(I.obj_broken)
				I.obj_fix()
			if(I.body_parts_covered_dynamic != I.body_parts_covered)
				I.repair_coverage()
				to_chat(user, span_info("[I]被剥落的各层完全修复如初。"))

		return TRUE

	// MOB PATH
	if(istype(cast_on, /mob/living))
		var/mob/living/M = cast_on

		user.visible_message(
			span_warning("[user]开始专注于[M]……"),
			span_notice("我开始专注于[M]……")
		)

		if(!do_after(user, 4 SECONDS, TRUE, M, TRUE))
			to_chat(user, span_warning("我的专注被打断了！"))
			return FALSE

		// IRONMAN HEAL
		if(HAS_TRAIT(M, TRAIT_IRONMAN))
			var/power = 5 + user.STAINT * 0.3 // jakk here, but basically, the more wounded, the less effective, goes from ~40 heal per cast to 5 per cast minimum
			var/brute = M.getBruteLoss()
			var/fire = M.getFireLoss()
			var/MAX_DMG = 300 // total brute or total burn > than this? hammer time, cause this will only heal 5 per cast
			var/MULT = 5
			var/brute_ratio = min(brute / MAX_DMG, 1)
			var/fire_ratio	= min(fire / MAX_DMG, 1)
			var/brute_factor = 1 - (0.9 * brute_ratio)
			var/fire_factor	= 1 - (0.9 * fire_ratio)
			var/brute_heal = max(5, round(power * MULT * brute_factor))
			var/fire_heal	= max(5, round(power * MULT * fire_factor))

			M.adjustBruteLoss(-brute_heal)
			M.adjustFireLoss(-fire_heal)
			M.visible_message(span_info("[M]泛起微弱的修复光芒。"))
			playsound(M, 'sound/magic/mending.ogg', 35, TRUE, -2)
			return TRUE

		// PROSTHETIC LIMB HEAL
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/bodypart/affecting = null
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(!BP || QDELETED(BP))
					continue
				if(BP.status != BODYPART_ROBOTIC)
					continue
				if(BP.brute_dam > 0 || BP.burn_dam > 0 || length(BP.wounds))
					affecting = BP
					break

			if(!affecting)
				to_chat(user, span_warning("没有需要修复的受损义肢。"))
				return FALSE

			var/heal_amount = round(5 + 0.12 * (user.STAINT ** 2)) // jakk here, but this only affects valid limbs

			affecting.heal_damage(heal_amount, heal_amount)
			H.update_damage_overlays()

			user.visible_message(
				span_notice("[user]修复了[M]的[affecting.name]义肢。"),
				span_notice("我修复了[M]的[affecting.name]义肢。")
			)
			playsound(M, 'sound/magic/mending.ogg', 35, TRUE, -2)
			return TRUE

	return FALSE

/datum/action/cooldown/spell/mending/lesser
	name = "次级修补术"
	repair_percent = 0.10
	cooldown_time = 30 SECONDS
	point_cost = 1

/datum/action/cooldown/spell/mending
	exclusive_group = "mending"

/datum/action/cooldown/spell/mending/lesser
	exclusive_group = "mending"
