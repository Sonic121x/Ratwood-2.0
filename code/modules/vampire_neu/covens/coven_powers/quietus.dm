/datum/coven/quietus
	name = "寂灭"
	desc = "潜伏于阴影，仅在必要时出手。掌控毒素、群体惑乱与火焰。"
	icon_state = "daimonion"
	power_type = /datum/coven_power/quietus
	clan_restricted = FALSE

/datum/coven_power/quietus
	name = "Quietus power name"
	desc = "Quietus power description"

//SILENCE OF DEATH
/datum/coven_power/quietus/silence_of_death
	name = "死亡静域"
	desc = "在周围创造一片绝对寂静的区域，使其中的人陷入混乱。"

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	duration_length = 2 SECONDS
	cooldown_length = 60 SECONDS
	var/datum/proximity_monitor/advanced/silence_field/proximity_field
	var/silence_range = 4
	var/validation_timer

/datum/coven_power/quietus/silence_of_death/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(!proximity_field)
		proximity_field = new /datum/proximity_monitor/advanced/silence_field(owner, silence_range, FALSE, src)
		// Apply silence to all mobs currently in range
		apply_initial_silence()
		// Start validation timer to check positions periodically - this is really redundant but its useful incases of forceMove
		validation_timer = addtimer(CALLBACK(src, PROC_REF(validate_silence_field)), 1 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/datum/coven_power/quietus/silence_of_death/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(proximity_field)
		QDEL_NULL(proximity_field)
	if(validation_timer)
		deltimer(validation_timer)
		validation_timer = null

/datum/coven_power/quietus/silence_of_death/proc/apply_initial_silence()
	if(!owner || !proximity_field)
		return

	// Find all mobs within range and apply silence
	for(var/mob/living/carbon/human/target in range(silence_range, owner))
		if(should_affect_target(target))
			proximity_field.add_affected_mob(target)

/datum/coven_power/quietus/silence_of_death/proc/validate_silence_field()
	if(!owner || !proximity_field)
		return

	var/list/current_affected = proximity_field.affected_mobs.Copy()

	// Check each affected mob to see if they're still in range
	for(var/mob/living/carbon/human/target in current_affected)
		if(!target || target.z != owner.z || get_dist(owner, target) > silence_range)
			proximity_field.remove_affected_mob(target)

	// Check for new mobs that entered range
	for(var/mob/living/carbon/human/target in range(silence_range, owner))
		if(should_affect_target(target) && !(target in proximity_field.affected_mobs))
			proximity_field.add_affected_mob(target)

/datum/coven_power/quietus/silence_of_death/proc/should_affect_target(mob/living/carbon/human/target)
	if(target == owner)
		return FALSE
	//the silence spares your own Clan, rival kindred get no such mercy
	if(target.is_clanmate(owner))
		return FALSE
	return TRUE

/datum/coven_power/quietus/silence_of_death/proc/apply_silence(mob/living/carbon/human/target)
	if(!should_affect_target(target))
		return
	if(!HAS_TRAIT(target, TRAIT_SILENT_FOOTSTEPS))
		ADD_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(!HAS_TRAIT(target, TRAIT_DEAF))
		ADD_TRAIT(target, TRAIT_DEAF, "quietus")
		if(target.confused < 20)
			target.confused += 20

/datum/coven_power/quietus/silence_of_death/proc/remove_silence(mob/living/carbon/human/target)
	if(HAS_TRAIT_FROM(target, TRAIT_DEAF, "quietus"))
		REMOVE_TRAIT(target, TRAIT_DEAF, "quietus")
	if(HAS_TRAIT_FROM(target, TRAIT_SILENT_FOOTSTEPS, "quietus"))
		REMOVE_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "quietus")

// Proximity monitor for the silence field
/datum/proximity_monitor/advanced/silence_field
	var/datum/coven_power/quietus/silence_of_death/parent_power
	var/list/affected_mobs = list()

/datum/proximity_monitor/advanced/silence_field/New(atom/center, range, ignore_if_not_on_turf, datum/coven_power/quietus/silence_of_death/power)
	parent_power = power
	. = ..()

/datum/proximity_monitor/advanced/silence_field/setup_field_turf(turf/target)
	. = ..()
	// Check for any mobs already on this turf
	for(var/mob/living/carbon/human/H in target)
		if(parent_power.should_affect_target(H))
			add_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/field_edge_crossed(atom/movable/movable, turf/location, direction)
	. = ..()
	if(istype(movable, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = movable
		if(parent_power.should_affect_target(H))
			add_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/field_edge_uncrossed(atom/movable/movable, turf/location, direction)
	. = ..()
	if(istype(movable, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = movable
		remove_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/proc/add_affected_mob(mob/living/carbon/human/target)
	if(target in affected_mobs)
		return
	affected_mobs |= target
	parent_power.apply_silence(target)

/datum/proximity_monitor/advanced/silence_field/proc/remove_affected_mob(mob/living/carbon/human/target)
	if(!(target in affected_mobs))
		return
	affected_mobs -= target
	parent_power.remove_silence(target)

/datum/proximity_monitor/advanced/silence_field/Destroy()
	// Clean up all affected mobs when the field is destroyed
	for(var/mob/living/carbon/human/H in affected_mobs)
		parent_power.remove_silence(H)
	affected_mobs.Cut()
	parent_power = null
	return ..()

/datum/coven_power/quietus/scorpions_touch
	name = "毒蝎之触"
	desc = "利用命髓加剧流血，并使伤口更加疼痛。"

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING | COVEN_CHECK_FREE_HAND
	violates_masquerade = TRUE
	cooldown_length = 60 SECONDS
	vitae_cost = 150

/datum/coven_power/quietus/scorpions_touch/activate()
	. = ..()
	owner.put_in_hands(new /obj/item/melee/touch_attack/quietus(owner))

//SCORPION'S TOUCH
/obj/item/melee/touch_attack/quietus
	name = "\improper 剧毒之触"
	desc = "污秽的黑色命髓沿着手掌滴落，随时准备渗入伤口。"
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = COLOR_ALMOST_BLACK
	force = 4
	d_type = "stab"
	sharpness = IS_SHARP
	can_parry = FALSE
	associated_skill = /datum/skill/magic/blood
	var/force_per_bloodskill = 4
	var/armor_penetration_per_bloodskill = 6

/obj/item/melee/touch_attack/quietus/attack(mob/living/target, mob/living/carbon/user)
	var/bloodskill = user.get_skill_level(/datum/skill/magic/blood)
	force = initial(force) + (bloodskill * force_per_bloodskill)
	armor_penetration = initial(armor_penetration) + (bloodskill * armor_penetration_per_bloodskill)
	var/bleed_before = isliving(target) ? target.get_bleed_rate() : 0
	. = ..()
	if(QDELETED(target) || !isliving(target))
		return
	if(target.get_bleed_rate() <= bleed_before)
		return
	target.apply_status_effect(/datum/status_effect/debuff/blackvitae)
	target.visible_message(span_warning("[target]的伤口开始溃烂腐败！"))
	to_chat(target, span_danger("原本的疼痛如今化为剧痛！浑身上下都<span class='italics'>更痛了</span>！"))

//BAAL'S CARESS
/datum/coven_power/quietus/baals_caress
	name = "巴尔的爱抚"
	desc = "将命髓转化为毒素，摧毁一切接触到的血肉。"

	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	vitae_cost = 150
	target_type = TARGET_OBJ
	range = 3
	violates_masquerade = TRUE
	cooldown_length = 60 SECONDS

/datum/coven_power/quietus/baals_caress/can_activate(atom/target, alert = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/rogueweapon/target_weapon = target
	if(!istype(target_weapon))
		if(alert)
			to_chat(owner, span_warning("[src]只能用于武器！"))
		return FALSE

	if(!target_weapon.sharpness)
		if(alert)
			to_chat(owner, span_warning("[src]只能用于带刃武器！"))
		return FALSE

	return .

/datum/coven_power/quietus/baals_caress/activate(obj/item/rogueweapon/target)
	. = ..()
	target.AddElement(/datum/element/one_time_poison, list(/datum/reagent/bloodacid = 2))

/datum/coven_power/quietus/taste_of_death
	name = "死亡之味"
	desc = "向敌人吐出一团腐蚀性血液。"

	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	violates_masquerade = TRUE

	var/obj/effect/proc_holder/spell/granted_spell

/datum/coven_power/quietus/taste_of_death/post_gain()
	. = ..()
	if(!owner?.mind)
		return
	granted_spell = new /obj/effect/proc_holder/spell/invoked/projectile/acidsplash/quietus
	owner.mind.AddSpell(granted_spell)

/datum/coven_power/quietus/taste_of_death/post_lose()
	. = ..()
	if(granted_spell)
		owner?.mind?.RemoveSpell(granted_spell)
		granted_spell = null

/obj/effect/proc_holder/spell/invoked/projectile/acidsplash/quietus
	projectile_type = /obj/projectile/magic/acidsplash/quietus

/obj/projectile/magic/acidsplash/quietus
	damage = 80
	flag = "magic"
	speed = 2

//DAGON'S CALL
/datum/coven_power/quietus/dagons_call
	name = "达贡的呼唤"
	desc = "诅咒你最后攻击的人，使其溺死于自己的鲜血。"

	level = 5
	research_cost = 4
	minimal_generation = GENERATION_ANCILLAE
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	cooldown_length = 30 SECONDS

/datum/coven_power/quietus/dagons_call/activate()
	. = ..()
	var/mob/living/lastattacker = owner.lastattacker_weakref?.resolve()
	if(isliving(lastattacker) && !lastattacker.is_clanmate(owner))
		lastattacker.adjustStaminaLoss(80)
		lastattacker.adjust_fire_stacks(6)
		lastattacker.adjustFireLoss(10)
		to_chat(owner, "你向最后攻击的生物[lastattacker]施下了诅咒。")
	else
		to_chat(owner, "你似乎还没有攻击过任何生灵……")
		return

