#define VOID_CLONE_TRAIT_SOURCE "void_clone_custom"
#define VOID_CLONE_CHECK_INTERVAL (1 SECONDS)

/mob/living/carbon/human
	var/datum/void_clone_link/void_clone_link_custom

/mob/living/carbon/human/proc/is_void_clone()
	return void_clone_link_custom?.clone_body == src

/obj/effect/proc_holder/spell/self/learnspell/cast(list/targets, mob/living/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.is_void_clone())
			to_chat(user, span_warning("虚空分身无法学习新的法术。"))
			return FALSE
	return ..()

/obj/effect/proc_holder/spell/self/learnspell/ui_status(mob/user, datum/ui_state/state)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.is_void_clone())
			return UI_CLOSE
	return ..()

/datum/mind
	var/datum/void_clone_link/void_clone_link_custom
	// Keep skills when a collapsing shell has no safe body to return to.
	var/datum/skill_holder/void_clone_saved_skills

/datum/mind/transfer_to(mob/new_character, force_key_move = FALSE)
	. = ..()
	if(!QDELETED(void_clone_saved_skills) && !QDELETED(current) && current.mind == src)
		void_clone_saved_skills.set_current(current)
		void_clone_saved_skills = null

/datum/mind/Destroy()
	QDEL_NULL(void_clone_saved_skills)
	return ..()

/datum/void_clone_link
	var/mob/living/carbon/human/original_body
	var/mob/living/carbon/human/clone_body
	var/datum/mind/owner_mind
	var/cleanup_started = FALSE
	var/next_check = 0

/datum/void_clone_link/New(mob/living/carbon/human/original, mob/living/carbon/human/clone, datum/mind/owner)
	. = ..()
	original_body = original
	clone_body = clone
	owner_mind = owner
	if(original_body)
		original_body.void_clone_link_custom = src
		RegisterSignal(original_body, COMSIG_QDELETING, PROC_REF(on_body_deleting))
	if(clone_body)
		clone_body.void_clone_link_custom = src
		RegisterSignal(clone_body, COMSIG_QDELETING, PROC_REF(on_body_deleting))
	if(owner_mind)
		owner_mind.void_clone_link_custom = src
		RegisterSignal(owner_mind, COMSIG_QDELETING, PROC_REF(on_owner_deleting))
	ensure_switch_spell()
	sync_current_body_spell_access()
	START_PROCESSING(SSfastprocess, src)

/datum/void_clone_link/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	for(var/datum/participant as anything in list(original_body, clone_body, owner_mind))
		if(participant)
			UnregisterSignal(participant, COMSIG_QDELETING)
	if(original_body?.void_clone_link_custom == src)
		original_body.void_clone_link_custom = null
	if(clone_body?.void_clone_link_custom == src)
		clone_body.void_clone_link_custom = null
	if(owner_mind?.void_clone_link_custom == src)
		owner_mind.void_clone_link_custom = null
	original_body = null
	clone_body = null
	owner_mind = null
	return ..()

/datum/void_clone_link/proc/on_body_deleting(datum/source)
	SIGNAL_HANDLER
	// QDELETING fires before Destroy clears the body's mind, skills and inventory.
	cleanup_clone(source == clone_body, source)

/datum/void_clone_link/proc/on_owner_deleting(datum/source)
	SIGNAL_HANDLER
	cleanup_clone(FALSE)

/datum/void_clone_link/process()
	if(cleanup_started)
		return
	if(world.time < next_check)
		return
	next_check = world.time + VOID_CLONE_CHECK_INTERVAL

	if(QDELETED(original_body) || !original_body)
		cleanup_clone(FALSE)
		return

	if(QDELETED(clone_body) || !clone_body)
		cleanup_clone(TRUE)
		return

	if(!has_valid_owner())
		cleanup_clone(TRUE)
		return

	if((clone_body.stat == DEAD) || (clone_body.health <= HEALTH_THRESHOLD_DEAD) || should_force_collapse())
		cleanup_clone(TRUE)
		return

	sync_current_body_spell_access()

/datum/void_clone_link/proc/restore_primary_spell_access(mob/living/body)
	var/datum/mind/M = get_linked_mind()
	if(!M || !body)
		return

	var/obj/effect/proc_holder/spell/clone_spell = M.get_spell(/obj/effect/proc_holder/spell/self/void_clone, TRUE)
	if(clone_spell && clone_spell.action && clone_spell.action.owner != body)
		clone_spell.action.Grant(body)

	var/obj/effect/proc_holder/spell/learn_spell = M.get_spell(/obj/effect/proc_holder/spell/self/learnspell)
	if(learn_spell && learn_spell.action && learn_spell.action.owner != body)
		learn_spell.action.Grant(body)

/datum/void_clone_link/proc/should_force_collapse()
	if(!clone_body || QDELETED(clone_body))
		return FALSE
	if(clone_body.InCritical())
		return TRUE

	var/total_damage = clone_body.getBruteLoss() + clone_body.getFireLoss() + clone_body.getToxLoss() + clone_body.getOxyLoss() + clone_body.getCloneLoss()
	if(total_damage >= clone_body.maxHealth)
		return TRUE
	return FALSE

/datum/void_clone_link/proc/get_linked_mind()
	return QDELETED(owner_mind) ? null : owner_mind

/datum/void_clone_link/proc/has_valid_owner()
	var/datum/mind/M = get_linked_mind()
	if(!M || QDELETED(original_body) || QDELETED(clone_body))
		return FALSE
	if(M.current != original_body && M.current != clone_body)
		return FALSE
	if(M.current.mind != M)
		return FALSE
	var/mob/living/carbon/human/idle_body = M.current == original_body ? clone_body : original_body
	return !idle_body.mind && !idle_body.key

/datum/void_clone_link/proc/can_enter_body(mob/living/carbon/human/body, forced = FALSE)
	if(QDELETED(body) || body.stat == DEAD || (body.mind && body.mind != owner_mind))
		return FALSE
	if(body.key && body.mind != owner_mind)
		return FALSE
	return forced || (body.stat == CONSCIOUS && !body.InCritical())

/datum/void_clone_link/proc/ensure_switch_spell()
	var/datum/mind/M = get_linked_mind()
	if(!M || M.has_spell(/obj/effect/proc_holder/spell/self/void_clone_switch, TRUE))
		return
	M.AddSpell(new /obj/effect/proc_holder/spell/self/void_clone_switch)

/datum/void_clone_link/proc/remove_switch_spell()
	var/datum/mind/M = get_linked_mind()
	if(!M)
		return
	var/obj/effect/proc_holder/spell/switch_spell = M.get_spell(/obj/effect/proc_holder/spell/self/void_clone_switch, TRUE)
	if(switch_spell)
		M.RemoveSpell(switch_spell)

/datum/void_clone_link/proc/sync_current_body_spell_access()
	var/datum/mind/M = get_linked_mind()
	if(!M || !M.current)
		return

	var/mob/living/current_body = M.current
	var/obj/effect/proc_holder/spell/clone_spell = M.get_spell(/obj/effect/proc_holder/spell/self/void_clone, TRUE)
	if(clone_spell && clone_spell.action)
		if(current_body == clone_body)
			if(clone_spell.action.owner == current_body)
				clone_spell.action.Remove(current_body)
		else if(clone_spell.action.owner != current_body)
			clone_spell.action.Grant(current_body)

	var/obj/effect/proc_holder/spell/learn_spell = M.get_spell(/obj/effect/proc_holder/spell/self/learnspell)
	if(learn_spell && current_body == clone_body)
		SStgui.close_user_uis(current_body, learn_spell)
	if(learn_spell && learn_spell.action)
		if(current_body == clone_body)
			if(learn_spell.action.owner == current_body)
				learn_spell.action.Remove(current_body)
		else if(learn_spell.action.owner != current_body)
			learn_spell.action.Grant(current_body)

	var/obj/effect/proc_holder/spell/switch_spell = M.get_spell(/obj/effect/proc_holder/spell/self/void_clone_switch, TRUE)
	if(switch_spell && switch_spell.action && switch_spell.action.owner != current_body)
		switch_spell.action.Grant(current_body)

/datum/void_clone_link/proc/cleanup_clone(force_return, datum/deleting_body)
	if(cleanup_started)
		return
	cleanup_started = TRUE

	var/datum/mind/M = get_linked_mind()
	var/mob/living/carbon/human/old_clone = clone_body
	var/mob/living/carbon/human/old_original = original_body

	if(force_return && M && can_enter_body(old_original, TRUE) && M.current == old_clone && old_clone?.mind == M)
		M.transfer_to(old_original)
		to_chat(old_original, span_userdanger("濒临崩溃的虚空分身把我的意识猛地拽回了本体！"))

	remove_switch_spell()
	if(M && !QDELETED(M.current) && M.current != old_clone && M.current.mind == M)
		restore_primary_spell_access(M.current)

	if(old_clone && (!QDELETED(old_clone) || deleting_body == old_clone))
		// Never transfer a third party's mind into the caster's original body.
		// If return is impossible, preserve the occupant's skills and spells for their ghost.
		var/datum/mind/occupant = old_clone.mind
		if(!QDELETED(occupant) && occupant.current == old_clone)
			if(old_clone.skills?.current == old_clone)
				occupant.void_clone_saved_skills = old_clone.skills
				old_clone.skills.set_current(null)
				old_clone.skills = null
			for(var/obj/effect/proc_holder/spell/S as anything in occupant.spell_list)
				if(S.action?.owner == old_clone)
					S.action.Remove(old_clone)
			var/mob/dead/observer/ghost = old_clone.ghostize(FALSE)
			if(!ghost && old_clone.key)
				ghost = new /mob/dead/observer/rogue/nodraw(old_clone)
				ghost.can_reenter_corpse = FALSE
				ghost.key = old_clone.key
			old_clone.mind = null
			occupant.set_current(null)
		drop_clone_inventory(old_clone)
		old_clone.visible_message(span_warning("[old_clone] 的虚空躯壳开始寸寸崩裂，最后像碎裂的傀儡般塌陷消散！"))
		if(old_original && !QDELETED(old_original))
			to_chat(old_original, span_warning("我与虚空分身之间的联系彻底断裂了。"))
		if(!QDELETED(old_clone))
			qdel(old_clone)

	qdel(src)

/datum/void_clone_link/proc/drop_clone_inventory(mob/living/carbon/human/body)
	var/turf/drop_turf = get_turf(body)
	if(!drop_turf)
		drop_turf = get_turf(original_body)
	if(!drop_turf)
		return
	// Underwear is tracked separately and carbon/Destroy would otherwise delete it.
	if(body.underwear?.loc == body)
		var/obj/item/bodypart/chest = body.get_bodypart(BODY_ZONE_CHEST)
		chest?.remove_bodypart_feature(body.underwear.undies_feature)
		body.underwear.forceMove(drop_turf)
	body.underwear = null
	for(var/obj/item/I in body.contents.Copy())
		// Attached anatomy belongs to the shell; carried organs are still loot.
		if((I in body.bodyparts) || (I in body.internal_organs) || (I in body.implants))
			continue
		body.transferItemToLoc(I, drop_turf, TRUE)

/obj/effect/proc_holder/spell/self/void_clone
	name = "分身术"
	school = "conjuration"
	desc = "以虚空石神奇的力量临时构建一个可以远程操控的躯体。"
	associated_skill = /datum/skill/magic/arcane
	cost = 6
	xp_gain = TRUE
	releasedrain = 100
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 MINUTES
	cooldown_min = 30 MINUTES
	warnie = "spellwarning"
	spell_tier = 3
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "void_clone"
	invocations = list("虚空，塑我伪身！")
	invocation_type = "shout"
	glow_color = "#7f5bff"
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	human_req = TRUE
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/self/void_clone/choose_targets(mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast(user)
		return
	if(H.void_clone_link_custom || H.mind?.void_clone_link_custom)
		to_chat(H, span_warning("我的虚空分身尚未崩解，无法再次施展分身术。"))
		revert_cast(H)
		return

	var/obj/item/magic/voidstone/focus = H.get_active_held_item()
	if(!istype(focus))
		to_chat(H, span_warning("我必须在手中握着一块 voidstone，才能塑造分身。"))
		revert_cast(H)
		return

	H.visible_message(span_warning("[H] 手中的 voidstone 漂浮至半空，开始微微扭曲。"), span_notice("我举起手中的 voidstone，让它在掌前浮起并缓缓扭曲。"))
	if(!continue_clone_channel(H, focus, 15 SECONDS, "我的虚空塑形在最初的共鸣中崩散了。"))
		return

	H.visible_message(span_warning("扭曲的 voidstone 表面裂出暗色纹路，一具与 [H] 极其相似的人形轮廓开始在空中显现。"), span_notice("voidstone 的表面裂出暗色纹路，我的轮廓正被一点点描摹出来。"))
	if(!continue_clone_channel(H, focus, 15 SECONDS, "那具尚未成形的轮廓突然涣散了。"))
		return

	H.visible_message(span_warning("那道人形轮廓渐渐凝实，四肢、面容与身躯像被无形之手一点点雕刻出来。"), span_notice("虚空正在照着我的形体塑造身躯，四肢和面容都开始变得清晰。"))
	if(!continue_clone_channel(H, focus, 15 SECONDS, "我对虚空分身的塑造被强行打断了。"))
		return

	H.visible_message(span_warning("虚空构筑出的空壳终于立起，只差最后一道心念注入，它便会成为 [H] 的伪身。"), span_notice("那具空壳已然成形，只差最后一缕心念，我便能进入其中。"))
	if(!continue_clone_channel(H, focus, 15 SECONDS, "最后的注魂失败了，虚空塑成的身躯当场垮塌。"))
		return

	perform(null, user = H)

/obj/effect/proc_holder/spell/self/void_clone/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!istype(user))
		revert_cast()
		return FALSE
	if(user.void_clone_link_custom || user.mind?.void_clone_link_custom)
		to_chat(user, span_warning("我的虚空分身尚未崩解，无法再次施展分身术。"))
		revert_cast(user)
		return FALSE

	var/obj/item/magic/voidstone/focus = user.get_active_held_item()
	if(!istype(focus))
		to_chat(user, span_warning("失去了手中的 voidstone，分身塑造自然也就失败了。"))
		revert_cast(user)
		return FALSE

	var/turf/spawn_turf = find_clone_spawn_turf(user)
	if(!spawn_turf)
		to_chat(user, span_warning("周围没有足够稳固的空间供分身成形。"))
		revert_cast(user)
		return FALSE

	var/mob/living/carbon/human/clone = new /mob/living/carbon/human(spawn_turf)
	if(!clone)
		to_chat(user, span_warning("虚空未能回应我的塑形。"))
		revert_cast(user)
		return FALSE

	var/obj/item/undies/shell_underwear = clone.underwear
	clone.copy_physical_features(user)
	// copy_physical_features also copies this equipment reference, not just appearance.
	clone.underwear = shell_underwear
	clone.copy_known_languages_from(user, TRUE)
	clone.faction = islist(user.faction) ? user.faction.Copy() : user.faction
	clone.set_patron(user.patron)
	clone.fully_replace_character_name(null, user.real_name)
	clone.regenerate_icons()
	clone.update_body()

	copy_stable_traits(user, clone)
	apply_puppet_traits(clone)
	apply_clone_stat_penalty(user, clone)

	var/datum/mind/M = user.mind
	if(QDELETED(M) || M.current != user)
		qdel(clone)
		revert_cast(user)
		return FALSE

	user.temporarilyRemoveItemFromInventory(focus, TRUE)
	qdel(focus)

	M.transfer_to(clone)
	var/datum/void_clone_link/link = new(user, clone, M)
	addtimer(CALLBACK(link, TYPE_PROC_REF(/datum/void_clone_link, sync_current_body_spell_access)), 0.1 SECONDS)

	clone.visible_message(span_warning("[clone] 睁开双眼，仿佛一具刚被心念点亮的空壳。"), span_notice("我的意识被猛地牵入新塑成的虚空分身之中。"))
	to_chat(clone, span_notice("分身拥有我的法术与技艺，但在我操控它时，无法使用分身术与学习法术。"))
	if(user)
		to_chat(user, span_notice("我的本体留在原地，而意识已投入新塑成的虚空分身之中。"))
	return TRUE

/obj/effect/proc_holder/spell/self/void_clone/proc/continue_clone_channel(mob/living/carbon/human/user, obj/item/magic/voidstone/focus, wait_time, fail_text)
	if(!istype(user) || !istype(focus))
		revert_cast(user)
		return FALSE
	if(user.void_clone_link_custom || user.mind?.void_clone_link_custom)
		to_chat(user, span_warning("已有分身存在，虚空不再回应新的塑形。"))
		revert_cast(user)
		return FALSE
	if(user.get_active_held_item() != focus)
		to_chat(user, span_warning("我必须始终握住那块 voidstone，才能维持分身塑造。"))
		revert_cast(user)
		return FALSE
	if(!do_after(user, wait_time, target = user, progress = TRUE))
		to_chat(user, span_warning("[fail_text]"))
		revert_cast(user)
		return FALSE
	if(user.get_active_held_item() != focus)
		to_chat(user, span_warning("手中的 voidstone 脱离了掌控，分身术随之瓦解。"))
		revert_cast(user)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/void_clone/proc/find_clone_spawn_turf(mob/living/carbon/human/user)
	if(!user)
		return null
	var/turf/origin = get_turf(user)
	if(!origin)
		return null
	var/turf/front = get_step(user, user.dir)
	if(isturf(front) && !front.is_blocked_turf())
		return front
	for(var/turf/T in orange(1, origin))
		if(!T.is_blocked_turf())
			return T
	return null

/obj/effect/proc_holder/spell/self/void_clone/proc/copy_stable_traits(mob/living/carbon/human/source, mob/living/carbon/human/clone)
	if(!source?.status_traits || !clone)
		return
	var/list/allowed_sources = list(JOB_TRAIT, ROUNDSTART_TRAIT, TRAIT_VIRTUE, ADVENTURER_TRAIT, INNATE_TRAIT)
	for(var/trait in source.status_traits)
		var/list/sources = source.status_traits[trait]
		if(!islist(sources))
			continue
		for(var/source_tag in allowed_sources)
			if(source_tag in sources)
				ADD_TRAIT(clone, trait, VOID_CLONE_TRAIT_SOURCE)
				break

/obj/effect/proc_holder/spell/self/void_clone/proc/apply_puppet_traits(mob/living/carbon/human/clone)
	if(!clone)
		return
	var/list/puppet_traits = list(
		TRAIT_NOSLEEP,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOPAIN,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_NOMETABOLISM,
		TRAIT_NOHUNGER
	)
	for(var/trait in puppet_traits)
		ADD_TRAIT(clone, trait, VOID_CLONE_TRAIT_SOURCE)
	if(!(NOBLOOD in clone.dna.species.species_traits))
		clone.dna.species.species_traits += NOBLOOD
	clone.reagents?.end_metabolization(clone, keep_liverless = TRUE)

/obj/effect/proc_holder/spell/self/void_clone/proc/apply_clone_stat_penalty(mob/living/carbon/human/source, mob/living/carbon/human/clone)
	if(!source || !clone)
		return
	var/list/stat_names = list(STAT_STRENGTH, STAT_PERCEPTION, STAT_INTELLIGENCE, STAT_CONSTITUTION, STAT_WILLPOWER, STAT_SPEED, STAT_FORTUNE)
	for(var/stat in stat_names)
		var/target_value = max(get_clone_base_stat(source, stat) - 2, 1)
		var/difference = target_value - clone.get_stat(stat)
		if(difference)
			clone.change_stat(stat, difference)

/obj/effect/proc_holder/spell/self/void_clone/proc/get_clone_base_stat(mob/living/source, stat)
	// Include overflow before removing modifiers, then clamp the permanent stat.
	var/list/buffers = list(STAT_STRENGTH = "BUFSTR", STAT_PERCEPTION = "BUFPER", STAT_INTELLIGENCE = "BUFINT", STAT_CONSTITUTION = "BUFCON", STAT_WILLPOWER = "BUFEND", STAT_SPEED = "BUFSPE", STAT_FORTUNE = "BUFLUC")
	var/value = source.get_stat(stat) + source.vars[buffers[stat]]
	for(var/datum/status_effect/effect as anything in source.status_effects)
		value -= effect.void_clone_stat_modifier(stat)
	for(var/index in source.statindex)
		var/list/modifier = source.statindex[index]
		if(modifier && modifier["stat"] == stat)
			value -= modifier["amt"]
	return clamp(value, 1, 20)

// Read modifiers without removing effects from the original body.
/datum/status_effect/proc/void_clone_stat_modifier(stat)
	return effectedstats[stat] ? effectedstats[stat] : 0

/datum/status_effect/wheel/void_clone_stat_modifier(stat)
	return ..() + (stat == STAT_FORTUNE ? wheeleffect : 0)

/datum/status_effect/buff/stagehands_silence/void_clone_stat_modifier(stat)
	return ..() + ((stat == STAT_SPEED && speed_bonus_applied) ? 1 : 0)

/datum/status_effect/buff/gift_of_the_sun/void_clone_stat_modifier(stat)
	return ..() + ((bonus_active && sun_stats[stat]) ? sun_stats[stat] : 0)

/datum/status_effect/buff/victory_glow/void_clone_stat_modifier(stat)
	return ..() + ((combat_active && combat_stats[stat]) ? combat_stats[stat] : 0)

/obj/effect/proc_holder/spell/self/void_clone_switch
	name = "切换身体"
	desc = "在本体与虚空分身之间切换操控。"
	overlay_state = "blink"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 1 SECONDS
	cooldown_min = 1 SECONDS
	associated_skill = /datum/skill/magic/arcane
	miracle = FALSE
	gesture_required = FALSE
	invocation_type = "none"

/obj/effect/proc_holder/spell/self/void_clone_switch/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!istype(user))
		revert_cast()
		return FALSE
	var/datum/void_clone_link/link = user.void_clone_link_custom
	if(QDELETED(link) || link.cleanup_started)
		to_chat(user, span_warning("我感应不到任何仍然存在的虚空分身。"))
		revert_cast(user)
		return FALSE
	if(QDELETED(link.clone_body) || !link.clone_body || QDELETED(link.original_body) || !link.original_body)
		revert_cast(user)
		link.cleanup_clone(FALSE)
		return FALSE

	var/datum/mind/M = user.mind
	if(!M || M != link.owner_mind || M.current != user || !link.has_valid_owner())
		to_chat(user, span_warning("维系两具身体的意识已经错乱，无法切换。"))
		revert_cast(user)
		return FALSE

	var/mob/living/carbon/human/target_body = (user == link.original_body) ? link.clone_body : link.original_body
	if(!link.can_enter_body(target_body) || (target_body == link.clone_body && link.should_force_collapse()))
		to_chat(user, span_warning("另一具身体已无法清醒地承载我的意识。"))
		revert_cast(user)
		return FALSE

	user.visible_message(span_notice("[user] 的双眼短暂失焦，意识仿佛被一根看不见的丝线猛地拽向了别处。"))
	M.transfer_to(target_body)
	link.sync_current_body_spell_access()
	to_chat(target_body, span_notice("我的意识顺着虚空中的暗线，切换到了另一具身体。"))
	return TRUE

#undef VOID_CLONE_TRAIT_SOURCE
#undef VOID_CLONE_CHECK_INTERVAL
