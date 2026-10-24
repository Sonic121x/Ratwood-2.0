#define CONJURE_UNTETHER_ID "conjure_untether"

/datum/component/conjured_minion
	var/datum/weakref/summoner_ref
	var/recoil_energy_floor = 200
	var/recoil_severity = CONJURE_RECOIL_FULL
	var/recoil_stamina_only = FALSE
	var/dismissing = FALSE
	var/leash_range = 12
	var/next_leash_message = 0
	var/base_alpha = 255
	var/untether_strain = 0
	var/untether_max = 10
	var/tether_timer

/datum/component/conjured_minion/Initialize(mob/living/summoner, energy_floor = 200, severity = CONJURE_RECOIL_FULL, stamina_only = FALSE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/minion = parent
	minion.mark_contract_spawned()
	summoner_ref = WEAKREF(summoner)
	recoil_energy_floor = energy_floor
	recoil_severity = severity
	recoil_stamina_only = stamina_only
	if(isliving(summoner))
		summoner.add_summoned_minion(parent)
	ADD_TRAIT(parent, TRAIT_CONJURED_SUMMON, REF(src))
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_summon_death))
	RegisterSignal(parent, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_leash))
	if(ishuman(parent))
		apply_phantasmal()
		seal_organs()
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	var/mob/living/M = parent
	base_alpha = M.alpha
	make_docile()
	addtimer(CALLBACK(src, PROC_REF(make_docile)), 1.5 SECONDS)
	tether_timer = addtimer(CALLBACK(src, PROC_REF(check_tether)), 4 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/datum/component/conjured_minion/proc/make_docile()
	var/mob/living/M = parent
	if(QDELETED(M) || !M.ai_controller)
		return
	var/mob/living/summoner = summoner_ref?.resolve()
	if(!summoner)
		return
	M.ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, summoner)
	M.ai_controller.set_blackboard_key(BB_TARGETTING_DATUM, GLOB.conjured_targetting)
	M.pet_passive = TRUE

/datum/component/conjured_minion/Destroy(force, silent)
	if(tether_timer)
		deltimer(tether_timer)
		tether_timer = null
	var/mob/living/summoner = summoner_ref?.resolve()
	if(isliving(summoner))
		summoner.remove_summoned_minion(parent)
	if(!QDELETED(parent))
		REMOVE_TRAIT(parent, TRAIT_CONJURED_SUMMON, REF(src))
		var/mob/living/M = parent
		M.remove_movespeed_modifier(CONJURE_UNTETHER_ID)
	return ..()

/datum/component/conjured_minion/proc/on_summon_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	if(dismissing)
		return
	var/mob/living/summoner = summoner_ref?.resolve()
	if(!summoner || summoner.stat == DEAD)
		return
	if(untether_strain > 0 || summoner.z != source.z || get_dist(source, summoner) > leash_range)
		to_chat(summoner, span_warning("一阵隐痛沿地脉传来——[source]在联结范围之外消亡了。"))
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(apply_conjure_recoil), summoner, recoil_energy_floor, recoil_severity, 1, TRUE, recoil_stamina_only)

/datum/component/conjured_minion/proc/check_leash(atom/movable/source, atom/newloc)
	SIGNAL_HANDLER
	var/mob/living/M = source
	var/mob/living/summoner = summoner_ref?.resolve()
	if(!summoner || summoner.z != source.z)
		return
	var/datum/ai_controller/AC = M.ai_controller
	if(AC && AC.blackboard[BB_TRAVEL_DESTINATION])
		return
	var/newdist = get_dist(newloc, summoner)
	if(newdist <= leash_range)
		return
	if(newdist < get_dist(source, summoner))
		return
	if(M.ckey && world.time > next_leash_message)
		next_leash_message = world.time + 3 SECONDS
		to_chat(M, span_warning("与你肉身相连的牵系阻止你继续远行……"))
	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/component/conjured_minion/proc/check_tether()
	var/mob/living/M = parent
	if(QDELETED(M) || dismissing)
		return
	var/mob/living/summoner = summoner_ref?.resolve()
	validate_combat_target(M, summoner)
	if(summoner && !QDELETED(summoner) && summoner.z == M.z && get_dist(M, summoner) <= leash_range)
		if(untether_strain > 0)
			relax_tether(M)
		return
	strain_tether(M)

/datum/component/conjured_minion/proc/validate_combat_target(mob/living/M, mob/living/summoner)
	var/datum/ai_controller/AC = M.ai_controller
	if(!AC)
		return
	var/mob/living/current = AC.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(isnull(current))
		return
	if(!QDELETED(current) && !current.stat)
		if(!summoner || QDELETED(summoner) || summoner.z != M.z)
			return
		if(get_dist(current, summoner) <= leash_range + 1)
			return
	AC.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	if(AC.blackboard[BB_HIGHEST_THREAT_MOB] == current)
		AC.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
	var/list/table = AC.blackboard[BB_MOB_AGGRO_TABLE]
	if(islist(table))
		table -= current

/datum/component/conjured_minion/proc/strain_tether(mob/living/M)
	untether_strain++
	var/mob/living/summoner = summoner_ref?.resolve()
	if(untether_strain == 1)
		M.visible_message(span_warning("[M]忽明忽暗，形体被遥远的地脉拉扯着。"))
		if(summoner)
			to_chat(summoner, span_warning("我感到与[M]的牵系绷紧了——仆从已离我太远。"))
	M.alpha = max(50, M.alpha - 12)
	M.add_movespeed_modifier(CONJURE_UNTETHER_ID, update = TRUE, override = TRUE, multiplicative_slowdown = min(untether_strain, 2) * 0.6)
	if(untether_strain == untether_max - 2 && summoner)
		to_chat(summoner, span_userdanger("与[M]的牵系正在断裂——若不靠近，就会彻底消散！"))
	if(untether_strain < untether_max)
		return
	if(M.ckey)
		untether_strain = untether_max
		return
	M.visible_message(span_warning("地脉牵系断裂，[M]的形体随之崩解。"))
	dismiss_conjured_minion(M)

/datum/component/conjured_minion/proc/relax_tether(mob/living/M)
	untether_strain = 0
	M.remove_movespeed_modifier(CONJURE_UNTETHER_ID)
	M.alpha = base_alpha
	M.visible_message(span_notice("主人回到近旁，[M]的形体稳定下来。"))

/datum/component/conjured_minion/proc/seal_organs()
	var/mob/living/carbon/human/H = parent
	for(var/obj/item/organ/organ as anything in H.internal_organs)
		organ.organ_flags |= ORGAN_INTERNAL_ONLY | ORGAN_SURGERY_HIDDEN

/datum/component/conjured_minion/proc/apply_phantasmal()
	var/mob/living/M = parent
	M.alpha = 170
	var/col = get_phantom_color()
	M.add_atom_colour(soften_color(col, 0.55), FIXED_COLOUR_PRIORITY)
	M.filters += filter(type = "drop_shadow", x = 0, y = 0, size = 2, offset = 0, color = col)

/datum/component/conjured_minion/proc/soften_color(col, blend = 0.55)
	var/list/parts = ReadRGB(col)
	if(length(parts) < 3)
		return col
	return rgb(parts[1] + (255 - parts[1]) * blend, parts[2] + (255 - parts[2]) * blend, parts[3] + (255 - parts[3]) * blend)

/datum/component/conjured_minion/proc/get_phantom_color()
	if(istype(parent, /mob/living/carbon/human/species/skeleton))
		var/list/palette = list("#a76cff", "#7718cf")
		var/mob/living/summoner = summoner_ref?.resolve()
		var/key = summoner ? "[summoner.real_name]" : "zizo"
		var/hash = 0
		for(var/i in 1 to length(key))
			hash += text2ascii(key, i)
		return palette[(hash % length(palette)) + 1]

	var/mob/living/summoner = summoner_ref?.resolve()
	var/key = summoner ? "[summoner.real_name]" : "arcyne"
	var/hash = 0
	for(var/i in 1 to length(key))
		hash += text2ascii(key, i)
	var/list/palette = list("#d13b2e", "#e0a020")
	return palette[(hash % length(palette)) + 1]

/datum/component/conjured_minion/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/mob/living/summoner = summoner_ref?.resolve()

	if(istype(parent, /mob/living/carbon/human/species/skeleton))
		examine_list += span_notice("一具诡异的骷髅，似乎由<font color='#940000'>阿凡泰因丝线</font>与附近法师的意志束缚并驱动。")
		return

	examine_list += span_notice("一名幻影仆从，受[summoner ? summoner.real_name : "未知法师"]的意志支配。")

#undef CONJURE_UNTETHER_ID

/mob/living/carbon/human/proc/release_conjured_gear()
	for(var/obj/item/gear in (get_equipped_items() + held_items))
		if(HAS_TRAIT(gear, TRAIT_NODROP))
			qdel(gear)
			continue
		dropItemToGround(gear, force = TRUE)

/mob/living/proc/add_summoned_minion(mob/living/summon)
	if(QDELETED(summon))
		return
	if(!summoned_minions)
		summoned_minions = list()
	if(summon in summoned_minions)
		return
	if(!length(summoned_minions))
		request_attack_relay()
		RegisterSignal(src, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(relay_attack_to_summons), override = TRUE)
		RegisterSignal(src, COMSIG_MOB_ITEM_ATTACK, PROC_REF(relay_weapon_attack_to_summons), override = TRUE)
		RegisterSignal(src, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(relay_unarmed_attack_to_summons), override = TRUE)
	summoned_minions += summon
	current_fellowship?.push_updates()

/mob/living/proc/remove_summoned_minion(mob/living/summon)
	if(!summoned_minions || !(summon in summoned_minions))
		return
	summoned_minions -= summon
	current_fellowship?.push_updates()
	if(length(summoned_minions))
		return
	summoned_minions = null
	UnregisterSignal(src, list(COMSIG_ATOM_WAS_ATTACKED, COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	release_attack_relay()

/mob/living/proc/request_attack_relay()
	attack_relay_refs++
	if(attack_relay_refs > 1)
		return
	if(!HAS_TRAIT(src, TRAIT_RELAYING_ATTACKER))
		AddElement(/datum/element/relay_attackers)
		attack_relay_self_added = TRUE

/mob/living/proc/release_attack_relay()
	if(attack_relay_refs <= 0)
		return
	attack_relay_refs--
	if(attack_relay_refs > 0)
		return
	if(attack_relay_self_added)
		RemoveElement(/datum/element/relay_attackers)
		attack_relay_self_added = FALSE

/mob/living/proc/relay_attack_to_summons(mob/living/source, atom/attacker, damage)
	SIGNAL_HANDLER
	if(!isliving(attacker) || !length(summoned_minions))
		return
	for(var/mob/living/summon in summoned_minions)
		if(QDELETED(summon) || summon.stat == DEAD || summon == attacker)
			continue
		if(summon.faction_check_mob(attacker))
			continue
		var/datum/component/ai_aggro_system/aggro = summon.GetComponent(/datum/component/ai_aggro_system)
		if(!aggro)
			continue
		aggro.add_threat_to_mob_capped(attacker, 24, 24)

/mob/living/proc/relay_weapon_attack_to_summons(datum/source, mob/target, mob/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(weapon && !weapon.force)
		return
	propagate_focus_aggro(target)

/mob/living/proc/relay_unarmed_attack_to_summons(datum/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(!cmode)
		return
	propagate_focus_aggro(target)

/mob/living/proc/propagate_focus_aggro(atom/target)
	if(!isliving(target) || target == src || !length(summoned_minions))
		return
	for(var/mob/living/summon in summoned_minions)
		if(QDELETED(summon) || summon.stat == DEAD || summon == target)
			continue
		if(summon.faction_check_mob(target))
			continue
		var/datum/component/ai_aggro_system/aggro = summon.GetComponent(/datum/component/ai_aggro_system)
		if(!aggro)
			continue
		aggro.add_threat_to_mob_capped(target, 18, 18)
