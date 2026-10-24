// 恢复效果只安装保存的实例、计时和持续关系，不重播获得效果时的即时行为。
/mob/living/carbon/human
	var/z121_return_preparing = FALSE
	var/z121_return_changing_traits = FALSE
	var/datum/z121_return_record/z121_return_effect_record
	var/list/z121_return_held_traumas

/mob/living/carbon/human/proc/z121_is_return_restoring()
	var/datum/component/z121_death_return/controller = z121_return_controller()
	return z121_return_preparing || controller?.restoring

/datum/status_effect/New(list/arguments)
	var/mob/living/carbon/human/H = length(arguments) ? arguments[1] : null
	if(istype(H) && H.z121_return_effect_record?.saved_type == type)
		H.z121_return_effect_record.install_effect(src, H)
		return
	on_creation(arglist(arguments))

/datum/status_effect
	var/list/z121_return_applied_stats

// 保存本效果真实施加的增量；属性缓冲存在时，名义数值不能用于反向结算。
/datum/status_effect/on_apply()
	effectedstats = effectedstats?.Copy()
	if(ishuman(owner) && isnull(z121_return_applied_stats))
		z121_return_applied_stats = list()
	for(var/stat in effectedstats)
		if(effectedstats[stat] < 0)
			if(owner.get_stat(stat) + effectedstats[stat] < 1)
				for(var/i in 1 to abs(effectedstats[stat]))
					if(owner.get_stat(stat) + effectedstats[stat] + i == 1)
						effectedstats[stat] += i
						break
		else if(owner.get_stat(stat) + effectedstats[stat] > 20)
			effectedstats[stat] = 20 - owner.get_stat(stat)
		var/before = ishuman(owner) ? z121_parallel_stat_total(owner, stat) : 0
		owner.change_stat(stat, effectedstats[stat])
		if(ishuman(owner))
			z121_return_applied_stats[stat] += z121_parallel_stat_total(owner, stat) - before
	return TRUE

/datum/status_effect/proc/z121_return_remove_stats()
	if(ishuman(owner) && !isnull(z121_return_applied_stats))
		for(var/stat in z121_return_applied_stats)
			z121_parallel_stat_delta(owner, stat, -z121_return_applied_stats[stat])
		z121_return_applied_stats.Cut()
	else
		for(var/stat in effectedstats)
			owner.change_stat(stat, -effectedstats[stat])

/datum/status_effect/on_remove()
	z121_return_remove_stats()
	if(mob_effect)
		owner.clear_overhead_indicator(mob_effect, mob_effect_layer)

/datum/status_effect/be_replaced()
	z121_return_remove_stats()
	owner.clear_alert(id)
	if(owner)
		LAZYREMOVE(owner.status_effects, src)
		if(owner.status_effects_by_id && owner.status_effects_by_id[id] == src)
			owner.status_effects_by_id -= id
		owner = null
	qdel(src)

/datum/z121_return_record/proc/install_effect(datum/status_effect/E, mob/living/carbon/human/H)
	apply(E)
	E.owner = H
	if(E.duration != -1)
		E.duration += world.time
	if(E.tick_interval != -1)
		E.tick_interval += world.time
	LAZYADD(H.status_effects, E)
	if(!length(H.status_effects_by_id))
		H.status_effects_by_id = alist()
	H.status_effects_by_id[E.id] = E
	if(E.alert_type)
		E.linked_alert = H.throw_alert(E.id, E.alert_type)
		if(E.linked_alert)
			E.linked_alert.attached_effect = E
	if(E.needs_processing)
		START_PROCESSING(SSfastprocess, E)
	restore_timers(E)
	if(istype(E, /datum/status_effect/debuff/mishap_feeblemind))
		var/datum/status_effect/debuff/mishap_feeblemind/feeble = E
		feeble.old_languages = new /datum/language_holder(null)
		feeble.owner_language_holder = H.get_language_holder()
		language_backup?.apply(feeble.old_languages)
	for(var/filter_name in effect_filters)
		var/list/parameters = z121_return_copy(effect_filters[filter_name])
		var/priority = parameters["priority"]
		parameters -= "priority"
		H.add_filter(filter_name, priority, parameters)
	E.z121_return_rebind()

// 只列出效果自己负责删除的滤镜，不复制装备、其他角色或环境添加的滤镜。
/datum/status_effect/proc/z121_return_filter_names()
	var/static/list/names = list("haste" = "haste_glow", "healing" = "miracle_heal_glow", "healing_campfire" = "miracle_heal_glow", "originhealing" = "originhealing", "stamina_campfire" = "campfire_stamina", "lay_hands" = "lay_hands_glow", "bloodheal" = "miracle_bloodheal_glow", "psyhealing" = "psydon_heal_glow", "psyvived" = "psydon_revival_glow", "fortify" = "fortify_glow", "convergence" = "convergence_glow", "soulchurnerprotection" = "crankboxbuff_glow", "guidinglight" = "sun_glow", "bloodrage" = "bloodrage", "invigoration" = "invigoration_filter", "recuperation" = "recuperation")
	return names[id] ? list(names[id]) : list()

// 只有与当前宿主绑定的持久关系需要重建；特性及数值由身体快照统一还原。
/datum/status_effect/proc/z121_return_rebind()
	z121_return_bind_mind()
	if(istype(src, /datum/status_effect/fire_handler/fire_stacks))
		RegisterSignal(owner, COMSIG_ATOM_UPDATE_OVERLAYS, TYPE_PROC_REF(/datum/status_effect/fire_handler/fire_stacks, add_fire_overlay))
	if(istype(src, /datum/status_effect/incapacitating/sleeping))
		var/datum/status_effect/incapacitating/sleeping/E = src
		E.carbon_owner = owner
		E.human_owner = owner
	if(istype(src, /datum/status_effect/debuff/mishap_arcane_drunkenness))
		var/datum/status_effect/debuff/mishap_arcane_drunkenness/E = src
		E.human_owner = owner
	if(istype(src, /datum/status_effect/debuff/liver_failure))
		RegisterSignal(owner, COMSIG_LIVING_LIFE, TYPE_PROC_REF(/datum/status_effect/debuff/liver_failure, on_life))
	if(istype(src, /datum/status_effect/freon))
		RegisterSignal(owner, COMSIG_LIVING_RESIST, TYPE_PROC_REF(/datum/status_effect/freon, owner_resist))
		var/datum/status_effect/freon/E = src
		owner.add_overlay(E.cube)
	if(istype(src, /datum/status_effect/trance))
		RegisterSignal(owner, COMSIG_MOVABLE_HEAR, TYPE_PROC_REF(/datum/status_effect/trance, hypnotize))
		owner.add_client_colour(/datum/client_colour/monochrome/trance)
	if(istype(src, /datum/status_effect/buff/all_seeing_insight))
		var/datum/status_effect/buff/all_seeing_insight/E = src
		E.grant_full_vision()
	if(istype(src, /datum/status_effect/buff/accel))
		var/datum/status_effect/buff/accel/E = src
		if(E.afterimage_active)
			owner.AddComponent(/datum/component/after_image)
	if(istype(src, /datum/status_effect/debuff/sleepytime/t3))
		owner.add_movespeed_modifier("SLEEP_TIER3", update = TRUE, priority = 100, multiplicative_slowdown = 1.25)
	if(istype(src, /datum/status_effect/debuff/submissive))
		owner.add_movespeed_modifier("SUBMISSIVE", multiplicative_slowdown = 4)
	if(istype(src, /datum/status_effect/debuff/staggered) || istype(src, /datum/status_effect/debuff/hobbled))
		owner.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)
	if(istype(src, /datum/status_effect/debuff/necrandeathdoorwilloss))
		owner.add_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING, multiplicative_slowdown = PULL_PRONE_SLOWDOWN)
	if(istype(src, /datum/status_effect/debuff/mishap_arcane_high))
		owner.overlay_fullscreen("arcane_high", /atom/movable/screen/fullscreen/druqks)
	if(istype(src, /datum/status_effect/debuff/vampbite))
		owner.overlay_fullscreen("vampirebite", /atom/movable/screen/fullscreen/weedsm)
	if(istype(src, /datum/status_effect/debuff/cold))
		owner.add_atom_colour(rgb(136, 191, 255), TEMPORARY_COLOUR_PRIORITY)
		addtimer(CALLBACK(owner, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, rgb(136, 191, 255)), max(0, duration - world.time))
	if(istype(src, /datum/status_effect/debuff/blackvitae))
		owner.add_atom_colour(rgb(67, 67, 67), TEMPORARY_COLOUR_PRIORITY)
		addtimer(CALLBACK(owner, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, rgb(67, 67, 67)), max(0, duration - world.time))
	if(mob_effect_icon_state)
		var/remaining = duration == -1 ? mob_effect_dur : max(0, duration - world.time - 1)
		mob_effect = owner.play_overhead_indicator_flick(mob_effect_icon, mob_effect_icon_state, remaining, mob_effect_layer, null, mob_effect_offset_y, mob_effect_offset_x)

// 重建身体完成灵魂交接后，再将语言异常绑定到真正的当前语言容器。
/datum/brain_trauma/severe/aphasia/proc/z121_return_bind_mind()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && H.z121_return_preparing && !H.mind)
		return
	mob_language = owner.get_language_holder()
	// 清晨后的语言学习仍属于当前记忆，治愈时应与存档中的恢复依据合并保留。
	prev_language.copy_known_languages_from(mob_language)
	prev_language.remove_language(/datum/language/aphasia, source = LANGUAGE_SOURCE_ALL)
	mob_language.remove_all_languages()
	mob_language.grant_language(/datum/language/aphasia)

// 旧身体的语言异常必须在灵魂离开前结束，避免其删除回调污染新身体的语言。
/mob/living/carbon/human/proc/z121_return_release_language_disorders()
	var/obj/item/organ/brain/brain = getorganslot(ORGAN_SLOT_BRAIN)
	for(var/datum/brain_trauma/severe/aphasia/aphasia in brain?.traumas.Copy())
		qdel(aphasia)
	for(var/datum/status_effect/E as anything in status_effects?.Copy())
		if(istype(E, /datum/status_effect/debuff/mishap_feeblemind) || istype(E, /datum/status_effect/debuff/mishap_langloss))
			qdel(E)

/datum/status_effect/proc/z121_return_bind_mind()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && H.z121_return_preparing && !H.mind)
		return
	if(istype(src, /datum/status_effect/debuff/mishap_feeblemind))
		var/datum/status_effect/debuff/mishap_feeblemind/E = src
		E.owner_language_holder = owner.get_language_holder()
		E.old_languages.copy_known_languages_from(E.owner_language_holder)
		E.old_languages.remove_language(/datum/language/aphasia, source = LANGUAGE_SOURCE_ALL)
		E.owner_language_holder.remove_all_languages()
		owner.language_holder.grant_language(/datum/language/aphasia)
	if(istype(src, /datum/status_effect/debuff/mishap_langloss))
		var/datum/status_effect/debuff/mishap_langloss/E = src
		if(E.removed_language)
			owner.remove_language(E.removed_language, source = LANGUAGE_SOURCE_ALL)

/datum/status_effect/debuff/mishap_feeblemind/Destroy()
	. = ..()
	QDEL_NULL(old_languages)
	owner_language_holder = null

// 当前冷却、身份及环境效果迁移原实例，不把它们回滚到清晨或重新开始计时。
/mob/living/carbon/human/proc/z121_return_release_passengers()
	var/datum/status_effect/debuff/harpy_flight/flight = has_status_effect(/datum/status_effect/debuff/harpy_flight)
	if(flight)
		flight.UnregisterSignal(src, COMSIG_MOVABLE_UNBUCKLE)
	// 复用原身体也要解除乘客，避免传送时把其他角色一起带回存档坐标。
	for(var/mob/living/passenger as anything in buckled_mobs?.Copy())
		unbuckle_mob(passenger, force = TRUE)
		if(flight)
			passenger.movement_type &= ~FLYING
			var/turf/landing = get_turf(passenger)
			landing?.zFall(passenger)
	if(!QDELETED(flight))
		flight.buckled_mob = null
		flight.RegisterSignal(src, COMSIG_MOVABLE_UNBUCKLE, TYPE_PROC_REF(/datum/status_effect/debuff/harpy_flight, harpy_mob_unbuckle))

/mob/living/carbon/human/proc/z121_return_transfer_external_effects(mob/living/carbon/human/replacement)
	for(var/datum/status_effect/E as anything in status_effects?.Copy())
		if(QDELETED(E) || z121_return_bodily_status(E))
			continue
		// 攀爬和搭乘依赖旧地点与实际抓握，换体后不能凭空延续这些关系。
		if(istype(E, /datum/status_effect/debuff/climbing_lfwb) || istype(E, /datum/status_effect/debuff/harpy_passenger))
			qdel(E)
			continue
		if(istype(E, /datum/status_effect/debuff/harpy_flight))
			var/obj/item/organ/wings/harpy/wings = replacement.getorganslot(ORGAN_SLOT_WINGS)
			if(!istype(wings))
				qdel(E)
				continue
			var/datum/status_effect/debuff/harpy_flight/flight = E
			// 乘客留在原地；只迁移自身飞行，不复制爪子、搭乘物或其他角色。
			z121_return_release_passengers()
			// 先解除旧监听，避免失效的乘客弱引用在核心解扣回调中被访问。
			flight.remove_signals()
			movement_type &= ~FLYING
			flying = FALSE
			dna.species.speedmod -= 0.3
			remove_movespeed_modifier(MOVESPEED_ID_SPECIES, TRUE)
			animate(src)
			flight.buckled_mob = null
			flight.passenger = null
			flight.harpy = replacement
			flight.harpy_wings = wings
			replacement.movement_type |= FLYING
			replacement.flying = TRUE
			replacement.dna.species.speedmod += 0.3
			replacement.add_movespeed_modifier(MOVESPEED_ID_SPECIES, TRUE, 100, override = TRUE, multiplicative_slowdown = replacement.dna.species.speedmod)
			animate(replacement, pixel_y = replacement.pixel_y + 3, time = 6, loop = -1)
			animate(pixel_y = replacement.pixel_y - 3, time = 6)
		var/list/listeners = E.signal_procs?[src]?.Copy()
		if(listeners)
			E.UnregisterSignal(src, listeners)
			for(var/signal_name in listeners)
				E.RegisterSignal(replacement, signal_name, listeners[signal_name])
		status_effects -= E
		if(status_effects_by_id?[E.id] == E)
			status_effects_by_id -= E.id
		clear_alert(E.id)
		E.owner = replacement
		if(istype(E, /datum/status_effect/debuff/harpy_flight))
			var/datum/status_effect/debuff/harpy_flight/flight = E
			flight.init_signals()
		if(istype(E, /datum/status_effect/buff/obfuscate_veil))
			// 帷幕的定时刷新只续隐匿时间，不会重设新身体透明度。
			alpha = initial(alpha)
			mob_timers[MT_INVISIBILITY] = 0
			replacement.alpha = 0
			var/datum/status_effect/buff/obfuscate_veil/veil = E
			veil.refresh_invisibility()
		LAZYADD(replacement.status_effects, E)
		if(!length(replacement.status_effects_by_id))
			replacement.status_effects_by_id = alist()
		replacement.status_effects_by_id[E.id] = E
		if(E.alert_type)
			E.linked_alert = replacement.throw_alert(E.id, E.alert_type)
			if(E.linked_alert)
				E.linked_alert.attached_effect = E
		var/list/applied_stats = isnull(E.z121_return_applied_stats) ? E.effectedstats : E.z121_return_applied_stats
		for(var/stat in applied_stats)
			z121_parallel_stat_delta(src, stat, -applied_stats[stat])
			z121_parallel_stat_delta(replacement, stat, applied_stats[stat])
		for(var/filter_name in E.z121_return_filter_names())
			if(filter_data?[filter_name])
				var/list/current_parameters = filter_data[filter_name]
				var/list/parameters = current_parameters.Copy()
				var/priority = parameters["priority"]
				parameters -= "priority"
				replacement.add_filter(filter_name, priority, parameters)
				remove_filter(filter_name)
		for(var/trait in status_traits?.Copy())
			var/source = TRAIT_STATUS_EFFECT(E.id)
			if(HAS_TRAIT_FROM(src, trait, source))
				ADD_TRAIT(replacement, trait, source)
				REMOVE_TRAIT(src, trait, source)
		if(istype(E, /datum/status_effect/buff/xylix_pratfall))
			var/datum/status_effect/buff/xylix_pratfall/pratfall = E
			if(pratfall.proxy)
				pratfall.proxy.owner_ref = WEAKREF(replacement)
		if(istype(E, /datum/status_effect/buff/guidinglight))
			var/datum/status_effect/buff/guidinglight/light = E
			light.mob_light_obj?.forceMove(replacement)
		if(istype(E, /datum/status_effect/eoranaura))
			var/mutable_appearance/aura = overlays_standing["eoranaura"]
			if(aura)
				replacement.overlays_standing["eoranaura"] = aura
				replacement.apply_overlay("eoranaura")
				remove_overlay("eoranaura")
