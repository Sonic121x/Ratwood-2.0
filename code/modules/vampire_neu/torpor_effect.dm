
/// Lying down to pretend to be dead, rather than being killed and regenerating
#define TORPOR_PHASE_RESTING "resting"
/// Dead, and waiting for dormancy before regenerating
#define TORPOR_PHASE_DORMANT "dormant"
/// Head or brain is missing, and in the process of regrowing it
#define TORPOR_PHASE_REGROWING "regrowing"
/// Can't regrow head/brain due to being too low of a tier, fucked.
#define TORPOR_PHASE_AWAITING "awaiting"
/// Regenerating generally until you're healthy enough to revive
#define TORPOR_PHASE_MENDING "mending"

/datum/status_effect/vampire_torpor
	id = "vampire_torpor"
	duration = -1
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/vampire_torpor
	/// The vampire's torpor component, which holds their mind and generation and handles their final death
	var/datum/component/vampire_torpor/torpor_comp
	/// TORPOR_VOLUNTARY or TORPOR_DEATH
	var/mode
	/// How long this death torpor lies dormant before mending, set from the vampire's generation
	var/dormant_needed = 0
	/// How much progress you have made through the dormant phase, can't be a timer as being in a coffin will halve it
	var/dormant_progress = 0
	/// Time spent actually mending, controls the over-time healing scaling
	var/mending_time = 0
	/// Mending put into growing a new head so far, out of TORPOR_HEAD_REGROW_AMOUNT
	var/head_regrow_progress = 0
	/// Hair, beard and the like from the severed head, kept in case the head is destroyed before the new one grows
	var/list/lost_head_features
	/// Health after the last mending tick, to tell when something is hurting them faster than they fix themselves
	var/last_health
	/// What they were last told under each notify_on_change() key, to avoid spamming messages
	var/list/last_notices = list()

/datum/status_effect/vampire_torpor/on_creation(mob/living/new_owner, torpor_mode = TORPOR_VOLUNTARY, datum/component/vampire_torpor/comp)
	mode = torpor_mode
	torpor_comp = comp || new_owner?.GetComponent(/datum/component/vampire_torpor)
	return ..()

/datum/status_effect/vampire_torpor/on_apply()
	. = ..()
	if(!ishuman(owner) || !torpor_comp)
		return FALSE
	var/mob/living/carbon/human/vampire = owner
	ADD_TRAIT(vampire, TRAIT_TORPOR, id)
	ADD_TRAIT(vampire, TRAIT_DEATHCOMA, id)
	ADD_TRAIT(vampire, TRAIT_NODEATH, id)
	ADD_TRAIT(vampire, TRAIT_FAKEDEATH, id)
	RegisterSignal(vampire, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(vampire, COMSIG_LIVING_TRY_OPEN_EYES, PROC_REF(on_try_open_eyes))
	RegisterSignal(vampire, COMSIG_LIVING_REVIVE, PROC_REF(on_revive))
	RegisterSignal(vampire, COMSIG_LIVING_CAN_BE_STAKED, PROC_REF(on_stake_check))
	RegisterSignal(vampire, COMSIG_LIVING_STAKED, PROC_REF(on_staked))
	RegisterSignal(vampire, COMSIG_LIVING_GET_SUCCUMB_WARNINGS, PROC_REF(on_get_succumb_warnings))
	RegisterSignal(vampire, COMSIG_LIVING_SUCCUMBED, PROC_REF(on_succumbed))
	vampire.clan?.disable_covens(vampire)
	vampire.exit_frenzymod()
	if(mode == TORPOR_DEATH)
		apply_death_torpor()
	else
		to_chat(vampire, span_notice("我陷入了不死休眠的可怖沉睡。在旁人眼中，我已是一具尸体，但我的伤势会自行恢复。睁开双眼，我便能醒来。"))
	vampire.update_stat()

/datum/status_effect/vampire_torpor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_TORPOR, id)
	REMOVE_TRAIT(owner, TRAIT_DEATHCOMA, id)
	REMOVE_TRAIT(owner, TRAIT_NODEATH, id)
	REMOVE_TRAIT(owner, TRAIT_FAKEDEATH, id)
	REMOVE_TRAIT(owner, TRAIT_DEATHS_DOOR, id)
	UnregisterSignal(owner, list(
		COMSIG_PARENT_EXAMINE,
		COMSIG_LIVING_TRY_OPEN_EYES,
		COMSIG_LIVING_REVIVE,
		COMSIG_LIVING_CAN_BE_STAKED,
		COMSIG_LIVING_STAKED,
		COMSIG_LIVING_GET_SUCCUMB_WARNINGS,
		COMSIG_LIVING_SUCCUMBED,
	))
	owner.update_stat()
	owner.update_damage_hud()
	return ..()

/datum/status_effect/vampire_torpor/proc/on_examine(mob/living/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!isobserver(user) && !user?.mind?.has_antag_datum(/datum/antagonist/vampire))
		return
	examine_list += get_examine_text()

/// The slain can only open their eyes once the Curse is done holding them under
/datum/status_effect/vampire_torpor/proc/on_try_open_eyes(mob/living/source)
	SIGNAL_HANDLER
	var/refusal = get_rise_refusal()
	if(!refusal)
		return
	to_chat(source, span_warning(refusal))
	return COMPONENT_BLOCK_OPEN_EYES

/datum/status_effect/vampire_torpor/proc/on_revive(mob/living/source, full_heal, admin_revive)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/vampire_torpor/proc/on_stake_check(mob/living/source, mob/living/user, obj/item/stake)
	SIGNAL_HANDLER
	return COMPONENT_STAKE_VULNERABLE

/datum/status_effect/vampire_torpor/proc/on_staked(mob/living/source, mob/living/user, obj/item/stake)
	SIGNAL_HANDLER
	source.visible_message(span_danger("[source]发出最后一声凄厉的哀嚎，身躯随之化为灰烬！"))
	torpor_comp.notify(span_userdanger("木桩！我的心脏！不——"))
	INVOKE_ASYNC(torpor_comp, TYPE_PROC_REF(/datum/component/vampire_torpor, die_for_good), TRUE)
	return COMPONENT_STAKE_HANDLED

// A vampire succumbing just ashes you, end of the line kiddo
/datum/status_effect/vampire_torpor/proc/on_get_succumb_warnings(mob/living/source, list/warnings)
	SIGNAL_HANDLER
	warnings += "若我放弃，便会永远舍弃诅咒：我的身躯将化为灰烬，再也无法复起。"

/datum/status_effect/vampire_torpor/proc/on_succumbed(mob/living/source)
	SIGNAL_HANDLER
	torpor_comp.final_death = TRUE
	to_chat(source, span_userdanger("我舍弃了诅咒。这一次，我不会再醒来。"))

/datum/status_effect/vampire_torpor/proc/enter_death_torpor()
	if(mode == TORPOR_DEATH)
		return
	apply_death_torpor()

/datum/status_effect/vampire_torpor/proc/apply_death_torpor()
	mode = TORPOR_DEATH
	mending_time = 0
	dormant_progress = 0
	dormant_needed = max(GENERATION_METHUSELAH + 1 - torpor_comp.get_generation(), 1) * 1 MINUTES
	ADD_TRAIT(owner, TRAIT_DEATHS_DOOR, id)
	set_eyes_closed(TRUE)
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "deathgasp")
	torpor_comp.notify(span_userdanger("我的肉身已然崩溃，诅咒却不肯放我离去。我陷入了死亡休眠……"))
	owner.update_stat()
	owner.update_damage_hud()
	update_alert()

/datum/status_effect/vampire_torpor/proc/notify_on_change(key, text, style = "warning")
	if(last_notices[key] == text)
		return
	last_notices[key] = text
	if(text)
		torpor_comp.notify("<span class='[style]'>[text]</span>")

/datum/status_effect/vampire_torpor/proc/get_phase()
	if(mode != TORPOR_DEATH)
		return TORPOR_PHASE_RESTING
	if(is_dormant())
		return TORPOR_PHASE_DORMANT
	if(is_missing_vitals())
		return can_regrow() ? TORPOR_PHASE_REGROWING : TORPOR_PHASE_AWAITING
	return TORPOR_PHASE_MENDING

/datum/status_effect/vampire_torpor/proc/is_dormant()
	return mode == TORPOR_DEATH && dormant_progress < dormant_needed

/// How long the dormant phaze lasts, sped up inside a coffin or grave
/datum/status_effect/vampire_torpor/proc/dormant_rate()
	return in_resting_place() ? TORPOR_RESTING_PLACE_MULT : 1

/datum/status_effect/vampire_torpor/proc/dormant_time_left()
	return max(dormant_needed - dormant_progress, 0) / dormant_rate()

/// Whether their blood is strong enough to grow back a head or brain, the weaker generations have to get their own back
/datum/status_effect/vampire_torpor/proc/can_regrow()
	return torpor_comp.get_generation() >= GENERATION_ANCILLAE

/// Whether the vampire's mind is in their body. Decapitation or cutting out the brain carries it off with the brain
/datum/status_effect/vampire_torpor/proc/is_mind_home()
	var/datum/mind/vampire_mind = torpor_comp.get_mind()
	return !vampire_mind || vampire_mind.current == owner

/// Missing something only regrowth or its return can fix
/datum/status_effect/vampire_torpor/proc/is_missing_vitals()
	return !owner.get_bodypart(BODY_ZONE_HEAD) || !owner.getorganslot(ORGAN_SLOT_BRAIN) || !is_mind_home()

/// "head" or "brain", whichever they've lost, for telling them about it
/datum/status_effect/vampire_torpor/proc/lost_vital_name()
	return owner.get_bodypart(BODY_ZONE_HEAD) ? "大脑" : "头颅"

/// Holy fire stops flesh from mending, but only while it actually burns, same as for anyone else
/datum/status_effect/vampire_torpor/proc/is_sundered()
	return owner.is_burning_with(/datum/status_effect/fire_handler/fire_stacks/sunder) || owner.is_burning_with(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed)

/datum/status_effect/vampire_torpor/tick(wait, delta_time)
	var/mob/living/carbon/human/vampire = owner
	if(vampire.stat == DEAD)
		qdel(src)
		return

	// capped so catchup doesnt go insane
	delta_time = min(delta_time, 5 SECONDS)

	if(mode == TORPOR_VOLUNTARY)
		if(!vampire.eyesclosed)
			wake()
			return
		if(!is_mended())
			mend(delta_time)
		notify_on_change("restored", is_mended() ? "我的身体已经完好如初。我随时可以睁开双眼。" : null, "notice")
		return

	if(vampire.get_bodypart(BODY_ZONE_HEAD))
		head_regrow_progress = 0
	if(!is_missing_vitals())
		notify_on_change("vitals", null)
	else if(!handle_missing_vitals())
		return

	if(is_dormant())
		if(!vampire.eyesclosed)
			try_rise_early()
		dormant_progress += delta_time * dormant_rate()
		if(!is_dormant())
			torpor_comp.notify(span_notice("沉眠消退了。我的身体开始自行恢复。"))
		update_alert()
		return

	var/mended = mend(delta_time)
	if(is_missing_vitals() && can_regrow())
		if(!vampire.get_bodypart(BODY_ZONE_HEAD))
			grow_head(mended)
		else if(mended > 0)
			regrow_vitals()
	update_blocker()
	update_alert()
	if(is_missing_vitals())
		return
	if(!vampire.eyesclosed)
		try_rise_early()
		return
	if(is_mended())
		wake()
		return
	notify_on_change("can_rise", can_rise() ? "我的身体已恢复到足以起身。我现在就能睁眼苏醒，也可以继续休养，直到彻底恢复。" : null, "notice")

/// Puts this tick's mending into a new head, telling the vampire and anyone watching as it takes shape
/datum/status_effect/vampire_torpor/proc/grow_head(mended)
	if(mended <= 0)
		return
	var/mob/living/carbon/human/vampire = owner
	var/old_stage = get_head_regrow_stage()
	head_regrow_progress += mended
	if(head_regrow_progress >= TORPOR_HEAD_REGROW_AMOUNT)
		regrow_vitals()
		return
	var/new_stage = get_head_regrow_stage()
	if(new_stage == old_stage)
		return
	switch(new_stage)
		if(1)
			vampire.visible_message(span_danger("[vampire]的断颈蠕动起来，鲜嫩的血肉开始从断口萌生！"))
			torpor_comp.notify(span_notice("血肉开始从我的断颈萌生。新的头颅正在成形。"))
		if(2)
			vampire.visible_message(span_danger("骨骼与筋腱从[vampire]的颈部扭曲生长，逐渐形成头骨的形状！"))
			torpor_comp.notify(span_notice("骨骼与筋腱交织成头骨。我的新头颅已长成一半。"))
		if(3)
			vampire.visible_message(span_danger("一张鲜嫩而尚未成形的脸，从[vampire]颈上的血肉中挤了出来！"))
			torpor_comp.notify(span_notice("新的头骨上长出了面容。它几乎完整了。"))

/datum/status_effect/vampire_torpor/proc/get_head_regrow_percent()
	return round(100 * head_regrow_progress / TORPOR_HEAD_REGROW_AMOUNT)

/// 0 before anything has grown, then 1-3 as the new head buds, takes the shape of a skull, and forms a face
/datum/status_effect/vampire_torpor/proc/get_head_regrow_stage()
	if(head_regrow_progress <= 0)
		return 0
	return clamp(ceil(get_head_regrow_percent() / (100 / 3)), 1, 3)

/datum/status_effect/vampire_torpor/proc/get_mind_vessel()
	var/datum/mind/vampire_mind = torpor_comp.get_mind()
	var/mob/living/brain/brainmob = vampire_mind?.current
	if(!istype(brainmob) || QDELETED(brainmob))
		return null
	var/obj/item/organ/brain/lost_brain = brainmob.loc
	if(!istype(lost_brain) || QDELETED(lost_brain))
		return null
	if(istype(lost_brain.loc, /obj/item/bodypart/head))
		return lost_brain.loc
	return lost_brain

/datum/status_effect/vampire_torpor/proc/handle_missing_vitals()
	var/lost = lost_vital_name()
	var/obj/item/bodypart/head/severed_head = get_mind_vessel()
	if(istype(severed_head))
		lost_head_features = severed_head.bodypart_features?.Copy()
	if(can_regrow())
		notify_on_change("vitals", "我的[lost]被取走了！身体恢复时会重新长出它，并将我拉回体内。", "userdanger")
		return TRUE
	if(torpor_comp.get_mind() && !get_mind_vessel())
		torpor_comp.notify(span_userdanger("我的[lost]毁了……诅咒最后的残余也随之消散。我真正死去了。"))
		torpor_comp.die_for_good(ash = FALSE)
		return FALSE
	notify_on_change("vitals", "我的[lost]被取走了！我的血脉过于稀薄，无法重新长出它——只有将它归还，我才能复起。", "userdanger")
	return TRUE

/datum/status_effect/vampire_torpor/proc/regrow_vitals()
	var/mob/living/carbon/human/vampire = owner
	var/obj/item/old_vessel = get_mind_vessel()
	var/regrew_head = FALSE
	if(!vampire.get_bodypart(BODY_ZONE_HEAD))
		if(!vampire.regenerate_limb(BODY_ZONE_HEAD))
			return
		regrew_head = TRUE
		regrow_head_features(old_vessel)
	restore_organs(allow_brain = TRUE)
	if(!vampire.getorganslot(ORGAN_SLOT_BRAIN))
		return

	var/datum/mind/vampire_mind = torpor_comp.get_mind()
	if(vampire_mind && vampire_mind.current != vampire)
		vampire_mind.transfer_to(vampire)
		vampire_mind.grab_ghost()
	notify_on_change("vitals", null)
	head_regrow_progress = 0

	if(old_vessel && !QDELETED(old_vessel))
		var/turf/vessel_turf = get_turf(old_vessel)
		vessel_turf?.visible_message(span_danger("[old_vessel]枯萎，化为了灰烬！"))
		if(vessel_turf)
			new /obj/item/ash(vessel_turf)
		qdel(old_vessel)

	set_eyes_closed(TRUE)
	if(regrew_head)
		vampire.update_body()
		vampire.update_hair()
		vampire.visible_message(span_danger("[vampire]颈上最后的血肉合拢，长成了一颗完整的新头颅！"))
		to_chat(vampire, span_notice("我的新头颅已长成。我回到了身体里，能感到它正在恢复。"))
	else
		vampire.visible_message(span_danger("某种湿润而暗沉的东西膨胀起来，填满了[vampire]空荡的颅腔……"))
		to_chat(vampire, span_notice("新的大脑长满了我的颅腔。我回到了身体里，能感到它正在恢复。"))

/datum/status_effect/vampire_torpor/proc/regrow_head_features(obj/item/old_vessel)
	var/obj/item/bodypart/head/new_head = owner.get_bodypart(BODY_ZONE_HEAD)
	if(!new_head)
		return
	var/list/features = lost_head_features
	var/obj/item/bodypart/head/old_head = istype(old_vessel, /obj/item/bodypart/head) ? old_vessel : null
	if(old_head && length(old_head.bodypart_features))
		features = old_head.bodypart_features.Copy()
	for(var/datum/bodypart_feature/feature as anything in features)
		old_head?.remove_bodypart_feature(feature)
		new_head.add_bodypart_feature(feature)
	lost_head_features = null

/// Heal based on what level your bloodheal is at
/// for delta_time worth of mending. Returns how much mending was done, 0 if something stopped it
/datum/status_effect/vampire_torpor/proc/mend(delta_time)
	var/mob/living/carbon/human/vampire = owner
	if(in_sunlight() || is_sundered())
		return 0
	var/seconds = delta_time / (1 SECONDS)
	if(mode == TORPOR_VOLUNTARY)
		var/vitae_cost = TORPOR_VOLUNTARY_VITAE_COST * seconds
		if(vampire.get_bloodpool() < vitae_cost)
			return 0
		vampire.adjust_bloodpool(-vitae_cost)

	mending_time += delta_time
	var/datum/coven/bloodheal = vampire.get_coven(/datum/coven/bloodheal)
	// half a point of brute and burn a second per level of Bloodheal, climbing from 1x to 3x over 5 minutes of mending
	var/heal_amount = 0.5 * max(bloodheal?.level, 1) * seconds
	heal_amount *= 1 + 2 * min(mending_time / (5 MINUTES), 1)
	if(in_resting_place())
		heal_amount *= TORPOR_RESTING_PLACE_MULT

	vampire.heal_overall_damage(heal_amount, heal_amount, updating_health = FALSE)
	vampire.adjustOxyLoss(-heal_amount, FALSE)
	vampire.adjustToxLoss(-heal_amount, FALSE)
	vampire.adjustCloneLoss(-heal_amount, FALSE)
	for(var/obj/item/organ/organ as anything in vampire.internal_organs)
		organ.applyOrganDamage(-heal_amount)
	vampire.updatehealth()
	var/list/crippling_names = list()
	for(var/datum/wound/wound as anything in vampire.get_wounds())
		if(is_crippling(wound))
			crippling_names[wound] = wound.name
	vampire.heal_all_wounds(heal_amount * 4)
	var/list/remaining_wounds = vampire.get_wounds()
	for(var/datum/wound/wound as anything in crippling_names)
		if(QDELETED(wound) || !(wound in remaining_wounds))
			torpor_comp.notify(span_notice("我的[crippling_names[wound]]自行愈合了。"))
	restore_organs()
	expel_embedded()
	return heal_amount

/datum/status_effect/vampire_torpor/proc/expel_embedded()
	var/mob/living/carbon/human/vampire = owner
	for(var/obj/item/bodypart/bodypart as anything in vampire.bodyparts)
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			if(bodypart.remove_embedded_object(embedded))
				vampire.visible_message(span_warning("[vampire]的血肉蠕动着，将[embedded]从[bodypart.name]中挤了出来！"))

/datum/status_effect/vampire_torpor/proc/restore_organs(allow_brain = FALSE)
	var/mob/living/carbon/human/vampire = owner
	if(!vampire.get_bodypart(BODY_ZONE_HEAD))
		return
	var/list/missing = get_missing_organ_slots()
	if(!length(missing) || ((ORGAN_SLOT_BRAIN in missing) && !allow_brain))
		return
	vampire.dna.species.regenerate_organs(vampire, null, FALSE)
	var/obj/item/organ/eyes/eyes = vampire.getorganslot(ORGAN_SLOT_EYES)
	if(vampire.clan && !istype(eyes, /obj/item/organ/eyes/night_vision/vampire))
		vampire.clan.implant_vampire_eyes(vampire)

/datum/status_effect/vampire_torpor/proc/get_missing_organ_slots()
	var/mob/living/carbon/human/vampire = owner
	var/datum/species/species = vampire.dna?.species
	. = list()
	if(!species)
		return
	var/list/slots = list()
	for(var/slot in vampire.dna.organ_dna)
		slots |= slot
	for(var/slot in species.organs)
		if(species.is_organ_slot_allowed(vampire, slot))
			slots |= slot
	for(var/slot in slots)
		if(vampire.getorganslot(slot))
			continue
		var/datum/organ_dna/organ_dna = vampire.dna.organ_dna[slot]
		if(organ_dna ? organ_dna.can_create_organ() : species.organs[slot])
			. += slot

// some wounds are lethal
/datum/status_effect/vampire_torpor/proc/get_crippling_wound()
	for(var/datum/wound/wound as anything in owner.get_wounds())
		if(is_crippling(wound))
			return wound
	return null

/datum/status_effect/vampire_torpor/proc/is_crippling(datum/wound/wound)
	if(isnull(wound.whp) || wound.whp <= 0)
		return FALSE
	return wound.mortal || wound.critical || wound.disabling || wound.severity >= WOUND_SEVERITY_CRITICAL

/datum/status_effect/vampire_torpor/proc/get_blocker()
	var/mob/living/carbon/human/vampire = owner
	if(in_sunlight())
		return "阳光灼烧着我，我无法在日照下恢复。"
	if(is_sundered())
		return "圣火在我的血肉中燃烧，火焰不灭，伤口便无法愈合。"
	if(!isnull(last_health) && vampire.health < last_health)
		return "我受伤的速度超过了恢复的速度。"
	switch(get_phase())
		if(TORPOR_PHASE_REGROWING)
			return "我的新[lost_vital_name()]仍在生长。"
		if(TORPOR_PHASE_AWAITING)
			return "必须归还我的[lost_vital_name()]，我才能复起。"
	var/datum/wound/crippling = get_crippling_wound()
	if(crippling)
		return "我的[crippling.name]必须愈合，我才能复起。"
	return null

/datum/status_effect/vampire_torpor/proc/update_blocker()
	notify_on_change("blocker", get_blocker())
	last_health = owner.health

/datum/status_effect/vampire_torpor/proc/is_mended()
	var/mob/living/carbon/human/vampire = owner
	return can_rise() && vampire.health >= vampire.maxHealth && vampire.getBruteLoss() + vampire.getFireLoss() <= 0

/datum/status_effect/vampire_torpor/proc/can_rise()
	var/mob/living/carbon/human/vampire = owner
	if(is_missing_vitals() || get_crippling_wound())
		return FALSE
	return vampire.health > vampire.crit_threshold

/// Why the slain can't open their eyes yet, null if they can
/datum/status_effect/vampire_torpor/proc/get_rise_refusal()
	switch(get_phase())
		if(TORPOR_PHASE_RESTING)
			return null
		if(TORPOR_PHASE_DORMANT)
			return "我无法睁开双眼。休眠还将困住我[DisplayTimeText(dormant_time_left(), 1)]。"
	if(!can_rise())
		return get_blocker() || "我的身体仍然伤得太重，无法复起。"
	return null

/datum/status_effect/vampire_torpor/proc/try_rise_early()
	var/refusal = get_rise_refusal()
	if(refusal)
		torpor_comp.notify(span_warning(refusal))
		set_eyes_closed(TRUE)
		return
	wake()

/datum/status_effect/vampire_torpor/proc/in_sunlight()
	if(GLOB.tod != "day")
		return FALSE
	var/turf/vampire_turf = owner.loc
	return isturf(vampire_turf) && vampire_turf.can_see_sky()

/// A coffin, a grave, or a coffin in a grave
/datum/status_effect/vampire_torpor/proc/in_resting_place()
	return istype(owner.loc, /obj/structure/closet/crate/coffin) || istype(owner.loc, /obj/structure/closet/dirthole)

/datum/status_effect/vampire_torpor/proc/wake()
	var/mob/living/carbon/human/vampire = owner
	if(mode == TORPOR_DEATH)
		set_eyes_closed(FALSE)
		vampire.visible_message(
			span_danger("[vampire]的尸体突然一颤，再次站了起来！"),
			span_userdanger("死亡松开了对我的钳制。我再次复起！"),
		)
		playsound(vampire, 'sound/misc/vampirespell.ogg', 50, TRUE)
	else
		to_chat(vampire, span_warning("我已从休眠中恢复。"))
		vampire.playsound_local(vampire, 'sound/misc/vampirespell.ogg', 50, TRUE)
	qdel(src)

/datum/status_effect/vampire_torpor/proc/set_eyes_closed(closed)
	owner.eyesclosed = closed
	if(closed)
		owner.become_blind("eyelids")
	else
		owner.cure_blind("eyelids")
	if(!owner.hud_used)
		return
	for(var/atom/movable/screen/eye_intent/eye_button in owner.hud_used.static_inventory)
		eye_button.update_icon(owner)

/datum/status_effect/vampire_torpor/proc/update_alert()
	if(!linked_alert)
		return
	var/phase = get_phase()
	var/countdown = 0
	switch(phase)
		if(TORPOR_PHASE_RESTING)
			linked_alert.name = initial(linked_alert.name)
			linked_alert.desc = initial(linked_alert.desc)
		if(TORPOR_PHASE_DORMANT)
			linked_alert.name = "休眠（沉眠中）"
			linked_alert.desc = "诅咒使我沉眠。待这阶段过去，我的身体便会开始恢复[in_resting_place() ? "；在合适的地方安息可以加快这一过程" : ""]。"
			countdown = dormant_time_left()
		if(TORPOR_PHASE_REGROWING)
			linked_alert.name = "休眠（再生[lost_vital_name()]）"
			linked_alert.desc = owner.get_bodypart(BODY_ZONE_HEAD) ? "新的大脑正在我的颅腔中生长。" : "新的头颅正在我的颈上生长：已完成 [get_head_regrow_percent()]%。"
		if(TORPOR_PHASE_AWAITING)
			linked_alert.name = "休眠（等待[lost_vital_name()]）"
			linked_alert.desc = "我的[lost_vital_name()]被取走了。我的血脉过于稀薄，无法重新长出它；只有将它归还，我才能复起。"
		if(TORPOR_PHASE_MENDING)
			linked_alert.name = "休眠（恢复中）"
			linked_alert.desc = "我的血肉正在重新愈合。[can_rise() ? "我的身体已足以复起——现在可以睁眼苏醒，也可以休息至彻底恢复。" : "彻底恢复后，我便能复起。"]"
	if(phase != TORPOR_PHASE_RESTING && phase != TORPOR_PHASE_DORMANT)
		var/blocker = last_notices["blocker"]
		linked_alert.desc += "[blocker ? "<br><br>[blocker]" : ""]<br><br>若我在死亡之门前放弃，便会化为灰烬。"
	linked_alert.update_countdown(countdown)

/datum/status_effect/vampire_torpor/proc/get_examine_text()
	var/they = owner.p_they(TRUE)
	switch(get_phase())
		if(TORPOR_PHASE_RESTING)
			return span_artery("[they]正在休眠中休养。")
		if(TORPOR_PHASE_DORMANT)
			return span_artery("[they]陷入了<b>死亡休眠</b>，正在沉眠。[DisplayTimeText(dormant_time_left(), 1)]后将开始恢复。")
		if(TORPOR_PHASE_REGROWING)
			if(owner.get_bodypart(BODY_ZONE_HEAD))
				return span_artery("[they]陷入了<b>死亡休眠</b>，新的大脑正在颅腔中生长。")
			return span_artery("这具无头躯体陷入了<b>死亡休眠</b>，新的头颅正在颈上生长：已完成 [get_head_regrow_percent()]%。")
		if(TORPOR_PHASE_AWAITING)
			if(owner.get_bodypart(BODY_ZONE_HEAD))
				return span_artery("[they]陷入了<b>死亡休眠</b>，颅腔空荡，正等待大脑被归还。")
			return span_artery("这具无头躯体陷入了<b>死亡休眠</b>，正等待头颅被归还。")
	return span_artery("[they]陷入了<b>死亡休眠</b>，正在恢复。")

/atom/movable/screen/alert/status_effect/vampire_torpor
	name = "休眠"
	desc = "不死者的沉睡。在旁人眼中，我已是一具尸体；休息时，我的身体会自行恢复。睁开双眼，我便能醒来。"
	icon_state = "debuff"

#undef TORPOR_PHASE_RESTING
#undef TORPOR_PHASE_DORMANT
#undef TORPOR_PHASE_REGROWING
#undef TORPOR_PHASE_AWAITING
#undef TORPOR_PHASE_MENDING
