// 快照仅复制值数据，不保存可变的身体、器官、药剂或伤口实例。
// 身份、任务、物品和灵魂引用由回归控制器按当前状态处理。
/proc/z121_return_copy(value, depth = 0)
	if(depth > 12)
		return null
	if(islist(value))
		var/list/source = value
		var/list/result = list()
		for(var/i in 1 to source.len)
			var/key = source[i]
			if(islist(key))
				result += list(z121_return_copy(key, depth + 1))
			else if(!istype(key, /datum))
				result += key
				if(!isnum(key) && !isnull(key) && !isnull(source[key]))
					result[key] = z121_return_copy(source[key], depth + 1)
		return result
	if(istype(value, /datum))
		return null
	return value

/datum/z121_return_record
	var/saved_type
	var/source_ref
	var/list/values = list()
	var/list/saved_traits
	var/list/bodily_timers = list()
	var/list/relative_times = list()
	var/datum/z121_return_record/language_backup
	var/list/effect_filters = list()

/datum/z121_return_record/New(datum/source, list/fields)
	saved_type = source.type
	source_ref = REF(source)
	saved_traits = z121_return_copy(source.status_traits)
	if(istype(source, /datum/brain_trauma/severe/aphasia))
		var/datum/brain_trauma/severe/aphasia/aphasia = source
		if(aphasia.prev_language)
			language_backup = new(aphasia.prev_language, list("languages", "only_speaks_language", "selected_default_language", "omnitongue"))
	if(istype(source, /datum/status_effect))
		var/datum/status_effect/E = source
		for(var/filter_name in E.z121_return_filter_names())
			if(E.owner?.filter_data?[filter_name])
				effect_filters[filter_name] = z121_return_copy(E.owner.filter_data[filter_name])
		if(istype(E, /datum/status_effect/debuff/mishap_feeblemind))
			var/datum/status_effect/debuff/mishap_feeblemind/feeble = E
			if(feeble.old_languages)
				language_backup = new(feeble.old_languages, list("languages", "shadow_languages", "only_speaks_language", "selected_default_language", "omnitongue"))
	for(var/datum/timedevent/T as anything in source.active_timers)
		if(z121_return_bodily_timer(T))
			bodily_timers += list(list(T.callBack.delegate, z121_return_copy(T.callBack.arguments), max(0, T.timeToRun - world.time)))
	// 默认只供纯数据的伤口、外观和生理数据使用；原子必须明确列出可恢复字段。
	if(!fields)
		fields = source.vars.Copy()
	for(var/field in fields)
		if(!(field in source.vars) || (field in list("type", "parent_type", "vars", "tag", "gc_destroyed", "datum_flags", "active_timers", "status_traits", "comp_lookup", "signal_procs", "signal_enabled", "open_uis", "weak_reference", "cooldowns", "abstract_type", "harddel_deets_dumped", "datum_components", "registered_signals", "should_persist_effects")))
			continue
		if(findtext(field, "timer"))
			continue
		var/value = source.vars[field]
		if(istype(value, /datum))
			continue
		values[field] = z121_return_copy(value)
	// 伤病直接比较世界时间的字段也必须转换，不能把旧的绝对时刻写回新身体。
	if(istype(source, /datum/wound) || istype(source, /datum/status_effect) || istype(source, /datum/brain_trauma))
		for(var/field in list("start_time", "last_stage_tick", "next_removal_check", "last_aura_tick", "last_dead_time", "next_portal", "next_damage_warning", "next_crisis", "next_check", "next_scare"))
			if(isnum(values[field]))
				if((field in list("next_removal_check", "last_aura_tick", "last_dead_time")) && !values[field])
					continue
				relative_times[field] = values[field] - world.time
				values -= field

/datum/z121_return_record/Destroy()
	QDEL_NULL(language_backup)
	return ..()

/datum/z121_return_record/proc/apply(datum/target)
	for(var/field in values)
		if(field in target.vars)
			target.vars[field] = z121_return_copy(values[field])
	for(var/field in relative_times)
		target.vars[field] = world.time + relative_times[field]

// 只重建身体症状、感染及器官计时，不复制遗言、交易或施法回调。
/proc/z121_return_bodily_timer(datum/timedevent/T)
	if(QDELETED(T) || T.spent || !T.callBack || (T.flags & TIMER_CLIENT_TIME))
		return FALSE
	if(T.callBack.delegate == TYPE_PROC_REF(/atom, remove_atom_colour))
		return T.callBack.arguments?[1] == TEMPORARY_COLOUR_PRIORITY && (T.callBack.arguments?[2] in list(rgb(136, 191, 255), rgb(67, 67, 67)))
	return T.callBack.delegate in list(TYPE_PROC_REF(/mob/living, cure_blind), TYPE_PROC_REF(/obj/item/bodypart, remove_crit_paralysis), TYPE_PROC_REF(/datum/wound/heatstroke, cure_heatstroke), TYPE_PROC_REF(/datum/wound, wake_werewolf), TYPE_PROC_REF(/datum/wound/grievous, reset_dismemberment_immunity), TYPE_PROC_REF(/obj/item/organ/heart, stop_if_unowned), TYPE_PROC_REF(/datum/brain_trauma/special/death_whispers, cease_whispering))

/datum/z121_return_record/proc/restore_timers(datum/target)
	for(var/datum/timedevent/T as anything in target.active_timers?.Copy())
		if(z121_return_bodily_timer(T))
			qdel(T)
	for(var/list/entry as anything in bodily_timers)
		var/list/callback_args = list(target, entry[1])
		callback_args += z121_return_copy(entry[2])
		var/datum/callback/CB = new(arglist(callback_args))
		var/timer_id = addtimer(CB, entry[3], TIMER_STOPPABLE)
		// 将新计时编号写回对应症状，治愈、删除及再次感染时仍能正确取消。
		if(entry[1] == TYPE_PROC_REF(/datum/wound/heatstroke, cure_heatstroke))
			var/datum/wound/heatstroke/W = target
			W.cure_timer = timer_id
		else if(entry[1] == TYPE_PROC_REF(/datum/wound, wake_werewolf))
			var/datum/wound/W = target
			W.werewolf_infection_timer = timer_id

// 肢体与器官字段显式列出，避免覆盖位置、拥有者、处理队列或缓存引用。
/proc/z121_return_limb_fields()
	return list("body_zone", "aux_zone", "held_index", "status", "disabled", "brute_dam", "burn_dam", "stamina_dam", "max_stamina_damage", "max_damage", "max_pain_damage", "cremation_progress", "brute_reduction", "burn_reduction", "skin_tone", "body_gender", "species_id", "species_color", "mutation_color", "species_icon", "use_digitigrade", "should_draw_gender", "should_draw_greyscale", "no_update", "rotted", "skeletonized", "fingers", "organ_slowdown", "is_prosthetic", "limb_material", "markings", "aux_markings", "brainkill", "hair_color", "hairstyle", "hair_alpha", "facial_hair_color", "facial_hairstyle", "lip_style", "lip_color", "branded_writing_on_neck", "unlimited_bleeding", "two_stage_death", "grievously_wounded", "branded_writing", "enslavement_mark", "brand_owner_name")

/proc/z121_return_organ_fields()
	return list("name", "slot", "zone", "zone_checked", "organ_flags", "maxHealth", "damage", "prev_damage", "healing_factor", "decay_factor", "low_threshold", "high_threshold", "low_threshold_passed", "high_threshold_passed", "now_failing", "now_fixed", "high_threshold_cleared", "low_threshold_cleared", "accessory_type", "accessory_colors", "visible_organ", "bodypart_icon", "bodypart_icon_state", "enslavement_mark", "brand_owner_name", "brain_death", "suicided", "damage_delta", "beat", "heartattack", "eye_color", "heterochromia", "second_color", "sight_flags", "see_in_dark", "eye_blind", "eye_damage", "penis_size", "functional", "sheath_type", "ball_size", "virility", "breast_size", "lactating", "milk_max", "fertility", "wings_color", "wing_natural_gradient", "wing_natural_color", "wing_dye_gradient", "wing_dye_color")

/proc/z121_return_body_fields()
	return list("gender", "age", "hair_color", "hairstyle", "facial_hair_color", "facial_hairstyle", "eye_color", "voice_color", "voice_pitch", "detail_color", "skin_tone", "lip_style", "lip_color", "shavelevel", "has_stubble", "socks", "accessory", "detail", "marking", "resize", "health", "max_stamina", "maxHealth", "crit_threshold", "nutrition", "hydration", "bodytemperature", "stamina", "energy", "max_energy", "drunkenness", "druggy", "hallucination", "dizziness", "drowsyness", "jitteriness", "stuttering", "slurring", "confused", "disgust", "losebreath", "breath_tick", "failed_last_breath", "resting", "eyesclosed", "stam_paralyzed", "bloodpool", "silent", "eye_blind", "eye_blurry", "fire_stacks", "on_fire", "STASTR", "STAPER", "STAINT", "STACON", "STAWIL", "STASPD", "STALUC", "BUFSTR", "BUFPER", "BUFINT", "BUFCON", "BUFEND", "BUFSPE", "BUFLUC", "statbuf", "statindex")

// 外貌必须先于种族和器官重建恢复，避免初始化时的默认性别、肤色污染生成结果。
/proc/z121_return_appearance_fields()
	return list("gender", "age", "hair_color", "hairstyle", "facial_hair_color", "facial_hairstyle", "eye_color", "voice_color", "voice_pitch", "detail_color", "skin_tone", "mutant_skin", "lip_style", "lip_color", "shavelevel", "has_stubble", "accessory", "detail", "marking", "mob_descriptors")

// 同一种族的实例也可能拥有不同的外观参数，不能只保存类型路径。
/proc/z121_return_species_appearance_fields()
	return list("name", "limbs_id", "clothes_id", "limbs_icon_m", "limbs_icon_f", "icon_override", "icon_override_m", "icon_override_f", "sexes", "offset_features", "dam_icon", "dam_icon_f", "hairyness", "custom_clothes", "use_f", "use_m", "hair_color", "hair_alpha", "use_skintones", "mutant_skin_option", "fixed_mut_color", "damage_overlay_type", "species_traits", "custom_base_icon")

/datum/z121_return_snapshot
	var/body_ref
	var/saved_x
	var/saved_y
	var/saved_z
	var/species_type
	var/saved_stat
	var/saved_native_flight = FALSE
	var/stamina_regen_delay
	var/datum/z121_return_record/body_values
	var/datum/z121_return_record/appearance_values
	var/datum/z121_return_record/species_appearance
	var/list/custom_descriptors = list()
	var/datum/z121_return_record/dna_values
	var/datum/z121_return_record/physiology_values
	var/datum/z121_return_record/armor_values
	var/datum/z121_return_record/rot_values
	var/list/organ_dna = list()
	var/list/limbs = list()
	var/list/organs = list()
	var/list/wounds = list()
	var/list/features = list()
	var/list/traumas = list()
	var/list/statuses = list()
	var/list/reagents = list()
	var/list/addictions = list()
	var/addiction_tick
	var/list/traits
	var/list/known_skills
	var/list/skill_experience
	var/list/losses
	var/blood
	var/chem_temp
	var/datum/z121_return_profession/profession_values
	var/saved_stress = 0
	var/list/stress_records = list()

/datum/z121_return_snapshot/New(mob/living/carbon/human/H)
	body_ref = REF(H)
	var/turf/T = get_turf(H)
	saved_x = T.x
	saved_y = T.y
	saved_z = T.z
	species_type = H.dna.species.type
	saved_stat = H.stat
	stamina_regen_delay = max(0, H.stam_regen_start_time - world.time)
	body_values = new(H, z121_return_body_fields() + list("succubus_internal_count", "succubus_is_queen", "hal_screwyhud", "derpspeech"))
	H.z121_return_equipment_symptoms(body_values.values)
	var/list/equipment = H.z121_return_equipment_stats()
	var/list/equipment_stats = equipment["stats"]
	for(var/stat in equipment_stats)
		var/list/fields = z121_parallel_stat_fields(stat)
		var/total = body_values.values[fields[1]] + body_values.values[fields[2]] - equipment_stats[stat]
		body_values.values[fields[1]] = clamp(total, 1, 20)
		body_values.values[fields[2]] = total - body_values.values[fields[1]]
	var/list/saved_indexes = body_values.values["statindex"]
	for(var/index in equipment["indexes"])
		saved_indexes -= index
	appearance_values = new(H, z121_return_appearance_fields())
	species_appearance = new(H.dna.species, z121_return_species_appearance_fields())
	// 种族主动飞行的物理修正必须与飞行姿态一起恢复，鹰身人当前飞行仍跟随外部实例。
	saved_native_flight = H.dna.species.override_float || istype(H.dna.species, /datum/species/shapebat) || istype(H.dna.species, /datum/species/shapecrow)
	species_appearance.values["override_float"] = H.dna.species.override_float
	species_appearance.values["stunmod"] = H.dna.species.stunmod
	species_appearance.values["speedmod"] = H.dna.species.speedmod - (H.has_status_effect(/datum/status_effect/debuff/harpy_flight) ? 0.3 : 0)
	for(var/datum/custom_descriptor_entry/D as anything in H.custom_descriptors)
		custom_descriptors += new /datum/z121_return_record(D, list("prefix_type", "content_text"))
	dna_values = new(H.dna, list("unique_enzymes", "uni_identity", "blood_type", "features", "body_markings", "current_body_size", "real_name", "stability", "scrambled"))
	physiology_values = new(H.physiology)
	armor_values = new(H.physiology.armor)
	var/datum/component/rot/rot = H.GetComponent(/datum/component/rot)
	if(rot)
		// 活着的死灵也可能已有腐败进度，不能把它当作本次死亡新增的尸体腐败清掉。
		rot_values = new(rot, list("amount", "last_process"))
		if(rot.last_process)
			rot_values.relative_times["last_process"] = rot.last_process - world.time
			rot_values.values -= "last_process"
	for(var/slot in H.dna.organ_dna)
		var/datum/organ_dna/D = H.dna.organ_dna[slot]
		if(istype(D))
			organ_dna[slot] = new /datum/z121_return_record(D)
	for(var/obj/item/bodypart/B as anything in H.bodyparts)
		limbs[B.body_zone] = new /datum/z121_return_record(B, z121_return_limb_fields() + list("dismemberable"))
		for(var/datum/bodypart_feature/F as anything in B.bodypart_features)
			if(z121_return_item_feature(F))
				continue
			features += list(list(B.body_zone, new /datum/z121_return_record(F)))
	for(var/obj/item/organ/O as anything in H.internal_organs)
		// 外露器官的颜色、图层和姿态也参与外貌，不能保留新器官的默认值。
		organs[O.slot] = new /datum/z121_return_record(O, z121_return_organ_fields() + list("color", "bodypart_layer", "wagging", "is_open", "beating"))
	for(var/datum/wound/W as anything in H.get_wounds())
		var/datum/z121_return_record/R = new(W)
		R.values["should_persist_effects"] = W.should_persist_effects
		wounds += list(list(W.bodypart_owner?.body_zone, R))
	var/obj/item/organ/brain/brain = H.getorganslot(ORGAN_SLOT_BRAIN)
	for(var/datum/brain_trauma/trauma as anything in brain?.traumas)
		traumas += new /datum/z121_return_record(trauma)
	for(var/datum/status_effect/E as anything in H.status_effects)
		if(z121_return_bodily_status(E))
			var/datum/z121_return_record/R = new(E)
			R.values["duration"] = E.duration == -1 ? -1 : max(0, E.duration - world.time)
			R.values["tick_interval"] = E.tick_interval == -1 ? -1 : max(0, E.tick_interval - world.time)
			statuses += R
	chem_temp = H.reagents.chem_temp
	for(var/datum/reagent/R as anything in H.reagents.reagent_list)
		reagents += new /datum/z121_return_record(R, list("volume", "data", "current_cycle", "metabolizing", "overdosed", "addiction_stage", "addiction_permanent"))
	addiction_tick = H.reagents.addiction_tick
	for(var/datum/reagent/R as anything in H.reagents.addiction_list)
		addictions += new /datum/z121_return_record(R, list("data", "current_cycle", "addiction_stage", "addiction_permanent"))
	traits = z121_return_copy(H.status_traits)
	// 装备来源只跟随现有实物，存档不持有装备实例，也不恢复旧装备的特性。
	z121_return_subtract_sources(traits, H.z121_return_equipment_traits())
	var/datum/skill_holder/skills = H.ensure_skills()
	known_skills = skills.known_skills.Copy()
	skill_experience = skills.skill_experience.Copy()
	profession_values = new(H)
	var/list/equipment_skills = equipment["skills"]
	for(var/datum/skill/skill as anything in equipment_skills)
		var/removed = min(skill_experience[skill] || 0, equipment_skills[skill])
		skill_experience[skill] = max(0, skill_experience[skill] - removed)
		known_skills[skill] = z121_return_skill_level(skill_experience[skill])
		profession_values.observed_experience[skill] = skill_experience[skill]
		profession_values.independent_experience[skill] = max(0, profession_values.independent_experience[skill] - removed)
	losses = list(H.getToxLoss(), H.getOxyLoss(), H.getCloneLoss(), H.getStaminaLoss())
	blood = H.get_blood_volume()
	saved_stress = H.oldstress
	for(var/event_type in H.stressors)
		var/datum/stressevent/event = H.stressors[event_type]
		// 七罪七德的心情期限跟随本局角色，不能恢复清晨的旧期限。
		if(istype(event, /datum/stressevent/z121_ethos))
			continue
		var/datum/z121_return_record/R = new(event, list("stressadd", "desc", "stacks", "max_stacks", "stressadd_per_extra_stack", "quality_modifier"))
		// 压力持续时间是数值字段，不是计时器编号；保存剩余进度，不重播事件。
		R.values["timer"] = event.timer
		R.relative_times["time_added"] = event.time_added - world.time
		stress_records += R

/datum/z121_return_snapshot/proc/find_destination()
	// 地块替换后重新按坐标查找，不检查密度、不搜索替代位置。
	return locate(saved_x, saved_y, saved_z)

// 复苏后只清除本次死亡新增的腐败；存档已有的腐败继续按原进度处理。
/datum/z121_return_snapshot/proc/restore_rot(mob/living/carbon/human/H)
	qdel(H.GetComponent(/datum/component/rot))
	if(rot_values)
		var/datum/component/rot/rot = H.AddComponent(rot_values.saved_type)
		rot_values.apply(rot)

/datum/z121_return_snapshot/proc/restore(mob/living/carbon/human/H, preparing = FALSE)
	var/list/source_map = list()
	source_map[body_ref] = REF(H)
	// 清理旧效果时仍使用旧数值，随后再恢复快照，避免移除效果时重复扣属性。
	for(var/datum/status_effect/E as anything in H.status_effects?.Copy())
		if(z121_return_bodily_status(E))
			qdel(E)
	for(var/datum/wound/W as anything in H.get_wounds())
		qdel(W)
	for(var/overlay_id in list("heatstroke", "heatexhaust", "frostbite", "hypothermia"))
		H.clear_fullscreen(overlay_id)
	H.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, rgb(136, 191, 255))
	H.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, rgb(67, 67, 67))
	H.reagents.clear_reagents()
	for(var/event_type in H.stressors)
		qdel(H.stressors[event_type])
	H.stressors = list()
	for(var/datum/z121_return_record/R as anything in stress_records)
		var/datum/stressevent/event = new R.saved_type
		R.apply(event)
		H.stressors[event.type] = event
	H.oldstress = saved_stress
	appearance_values.apply(H)
	if(H.dna.species.type != species_type)
		H.set_species(species_type, icon_update = FALSE)
	species_appearance.apply(H.dna.species)
	if(H.has_status_effect(/datum/status_effect/debuff/harpy_flight))
		H.dna.species.speedmod += 0.3
	var/current_flight = saved_native_flight || H.has_status_effect(/datum/status_effect/debuff/harpy_flight)
	H.setMovetype(current_flight ? (H.movement_type | FLYING) : (H.movement_type & ~FLYING))
	H.flying = !!current_flight
	dna_values.apply(H.dna)
	QDEL_LIST(H.custom_descriptors)
	H.custom_descriptors = list()
	for(var/datum/z121_return_record/R as anything in custom_descriptors)
		var/datum/custom_descriptor_entry/D = new
		R.apply(D)
		H.custom_descriptors += D
	H.dna.organ_dna = list()
	for(var/slot in organ_dna)
		var/datum/z121_return_record/R = organ_dna[slot]
		var/datum/organ_dna/D = new R.saved_type
		R.apply(D)
		H.dna.organ_dna[slot] = D
	restore_anatomy(H, source_map)
	for(var/list/entry as anything in wounds)
		var/datum/z121_return_record/R = entry[2]
		var/datum/wound/W = new R.saved_type
		R.apply(W)
		source_map[R.source_ref] = REF(W)
		// 直接重建已有伤口的归属；重播受伤回调会再次扣血、击晕甚至杀死角色。
		W.owner = H
		if(entry[1])
			var/obj/item/bodypart/B = H.get_bodypart(entry[1])
			W.bodypart_owner = B
			LAZYADD(B.wounds, W)
			B.bleeding += W.bleed_rate
			if(istype(W, /datum/wound/dislocation))
				if(B.body_zone == BODY_ZONE_R_LEG)
					H.add_movespeed_modifier(MOVESPEED_ID_DISLOCATION_RIGHT_LEG, multiplicative_slowdown = DISLOCATED_ADD_SLOWDOWN)
				if(B.body_zone == BODY_ZONE_L_LEG)
					H.add_movespeed_modifier(MOVESPEED_ID_DISLOCATION_LEFT_LEG, multiplicative_slowdown = DISLOCATED_ADD_SLOWDOWN)
			if(istype(W, /datum/wound/slime))
				H.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.3)
		else
			LAZYADD(H.simple_wounds, W)
			H.simple_bleeding += W.bleed_rate
		if(istype(W, /datum/wound/heatstroke))
			H.overlay_fullscreen("heatstroke", /atom/movable/screen/fullscreen/heatstroke)
		else if(istype(W, /datum/wound/heatexhaustion))
			H.overlay_fullscreen("heatexhaust", /atom/movable/screen/fullscreen/heatexhaust)
		else if(istype(W, /datum/wound/frostbite))
			H.overlay_fullscreen("frostbite", /atom/movable/screen/fullscreen/frostbite)
		else if(istype(W, /datum/wound/hypothermia))
			H.overlay_fullscreen("hypothermia", /atom/movable/screen/fullscreen/hypothermia)
		R.restore_timers(W)
	for(var/datum/z121_return_record/R as anything in reagents)
		H.reagents.add_reagent(R.saved_type, R.values["volume"], z121_return_copy(R.values["data"]), chem_temp, no_react = TRUE)
		var/datum/reagent/restored = H.reagents.has_reagent(R.saved_type)
		if(restored)
			R.apply(restored)
			if(restored.metabolizing)
				restored.on_mob_metabolize(H)
			source_map[R.source_ref] = REF(restored)
	H.reagents.chem_temp = chem_temp
	QDEL_LIST(H.reagents.addiction_list)
	H.reagents.addiction_list = list()
	H.reagents.addiction_tick = addiction_tick
	for(var/datum/z121_return_record/R as anything in addictions)
		var/datum/reagent/addiction = new R.saved_type
		R.apply(addiction)
		H.reagents.addiction_list += addiction
	for(var/datum/z121_return_record/R as anything in statuses)
		H.z121_return_effect_record = R
		var/datum/status_effect/E = new R.saved_type(list(H))
		H.z121_return_effect_record = null
		if(!QDELETED(E))
			source_map[R.source_ref] = REF(E)
	// 临时效果安装完成后覆盖保存的最终数值，保留其到期撤销逻辑。
	var/list/equipment = H.z121_return_equipment_stats()
	body_values.apply(H)
	H.z121_return_equipment_symptoms(null, TRUE)
	var/list/equipment_stats = equipment["stats"]
	for(var/stat in equipment_stats)
		z121_parallel_stat_delta(H, stat, equipment_stats[stat])
	var/list/equipment_indexes = equipment["indexes"]
	for(var/index in equipment_indexes)
		H.statindex[index] = z121_return_copy(equipment_indexes[index])
	appearance_values.apply(H)
	physiology_values.apply(H.physiology)
	armor_values.apply(H.physiology.armor)
	if(!preparing)
		profession_values.restore(H, source_map)
	restore_traits(H, source_map)
	for(var/datum/status_effect/fire_handler/F as anything in H.status_effects)
		F.cache_stacks()
		if(istype(F, /datum/status_effect/fire_handler/fire_stacks))
			var/datum/status_effect/fire_handler/fire_stacks/fire = F
			// 重建持续光源即可，不再次发送点燃事件或触发其旁支回调。
			if(fire.on_fire && fire.moblight_type && !fire.moblight)
				fire.moblight = new fire.moblight_type(H)
	H.setToxLoss(losses[1], FALSE, TRUE)
	// 核心的缺氧赋值仍会检查无敌标记，暂时解除以完整恢复保存的缺氧值。
	var/previous_status_flags = H.status_flags
	H.status_flags &= ~GODMODE
	H.setOxyLoss(losses[2], FALSE, TRUE)
	H.status_flags = previous_status_flags
	H.setCloneLoss(losses[3], FALSE, TRUE)
	H.setStaminaLoss(losses[4], FALSE, TRUE)
	H.set_blood_volume(blood)
	H.stam_regen_start_time = world.time + stamina_regen_delay
	body_values.restore_timers(H)
	var/datum/skill_holder/skills = H.ensure_skills()
	skills.known_skills = known_skills.Copy()
	skills.skill_experience = skill_experience.Copy()
	var/list/equipment_skills = equipment["skills"]
	for(var/datum/skill/skill as anything in equipment_skills)
		skills.skill_experience[skill] += equipment_skills[skill]
		skills.known_skills[skill] = z121_return_skill_level(skills.skill_experience[skill])
		var/datum/z121_profession_record/record = H.z121_profession
		if(record && !record.suspended)
			record.independent_experience[skill] += equipment_skills[skill]
			record.observed_experience[skill] = skills.skill_experience[skill]
	// 直接写回感知不会经过属性入口，视野派生值必须独立重算。
	H.see_override = initial(H.see_invisible) + H.STAPER / 3.25
	H.update_sight()
	H.update_fov_angles()
	H.dna.update_body_size()
	H.update_move_intent_slowdown()
	// 种族数值改回后，移动速度账本也必须更新，不能沿用回归前的旧修正。
	H.add_movespeed_modifier(MOVESPEED_ID_SPECIES, FALSE, 100, override = TRUE, multiplicative_slowdown = H.dna.species.speedmod, movetypes = H.has_status_effect(/datum/status_effect/debuff/harpy_flight) ? ALL : (~FLYING))
	H.update_movespeed(FALSE)
	H.update_energy_hud()
	H.update_stamina_hud()
	H.mark_zone_selector_hud_dirty()
	H.mark_pain_hud_dirty()
	// 直接还原伤害数值不会刷新挫伤、烧伤等级，必须重算后再重建贴图。
	// 按存档伤势生成外观，不能把清晨已有的伤痕一并清除。
	for(var/obj/item/bodypart/B as anything in H.bodyparts)
		var/datum/z121_return_record/R = limbs[B.body_zone]
		if(R)
			z121_return_restore_trait_sources(B, R.saved_traits, source_map)
		if(length(B.wounds) > 1)
			sortTim(B.wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
		B.update_bodypart_damage_state()
		B.invalidate_limb_cache()
	for(var/obj/item/organ/O as anything in H.internal_organs)
		var/datum/z121_return_record/R = organs[O.slot]
		if(R)
			z121_return_restore_trait_sources(O, R.saved_traits, source_map)
	H.body_overlay_cache_key = null
	H.damage_overlay_cache_key = null
	H.icon_render_key = null
	H.update_damage_overlays_real()
	return source_map

/datum/z121_return_snapshot/proc/restore_anatomy(mob/living/carbon/human/H, list/source_map)
	// 现存第二人格含有其他玩家，先移出器官生命周期，不能随换脑删除或重新招募。
	var/list/personalities = list()
	var/obj/item/organ/brain/previous_brain = H.getorganslot(ORGAN_SLOT_BRAIN)
	for(var/datum/brain_trauma/severe/split_personality/personality in previous_brain?.traumas.Copy())
		for(var/datum/z121_return_record/R as anything in traumas)
			if(R.saved_type == personality.type)
				previous_brain.traumas -= personality
				personality.brain = null
				LAZYADD(H.z121_return_held_traumas, personality)
				personalities[R.source_ref] = personality
				break
	// 保留类型相同的肢体与器官，避免无意义地拆手掉装备或转移大脑里的灵魂。
	for(var/obj/item/bodypart/B as anything in H.bodyparts.Copy())
		var/datum/z121_return_record/R = limbs[B.body_zone]
		if(R && B.type == R.saved_type)
			continue
		B.drop_limb(TRUE)
		for(var/obj/item/I in B)
			I.forceMove(get_turf(H))
		qdel(B)
	for(var/zone in limbs)
		var/datum/z121_return_record/R = limbs[zone]
		var/obj/item/bodypart/B = H.get_bodypart(zone)
		if(!B)
			B = new R.saved_type
			B.attach_limb(H, TRUE)
		R.apply(B)
		B.bleeding = 0
		R.restore_timers(B)
		// 当前衣物对应的外观随实物保留，不能从存档复制出内衣或装具。
		// 没有外观特征的肢体不会初始化此列表，按空列表处理，避免中断整个回归。
		for(var/datum/bodypart_feature/F as anything in B.bodypart_features?.Copy())
			if(!z121_return_item_feature(F))
				B.remove_bodypart_feature(F)
				qdel(F)
		source_map[R.source_ref] = REF(B)
	for(var/list/entry as anything in features)
		var/datum/z121_return_record/R = entry[2]
		var/datum/bodypart_feature/F = new R.saved_type
		R.apply(F)
		var/obj/item/bodypart/B = H.get_bodypart(entry[1])
		B.add_bodypart_feature(F)
	for(var/obj/item/organ/O as anything in H.internal_organs.Copy())
		var/datum/z121_return_record/R = organs[O.slot]
		if(R && R.saved_type == O.type)
			continue
		if(istype(O, /obj/item/organ/brain))
			var/obj/item/organ/brain/brain = O
			brain.Remove(H, special = TRUE, no_id_transfer = TRUE)
		else
			O.Remove(H, special = TRUE)
		qdel(O)
	for(var/slot in organs)
		var/datum/z121_return_record/R = organs[slot]
		var/obj/item/organ/O = H.getorganslot(slot)
		if(!O)
			O = new R.saved_type
			O.Insert(H, TRUE)
		R.apply(O)
		R.restore_timers(O)
		source_map[R.source_ref] = REF(O)
	var/obj/item/organ/brain/brain = H.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.original_body_ref = WEAKREF(H)
		for(var/datum/brain_trauma/old as anything in brain.traumas.Copy())
			qdel(old)
		for(var/datum/z121_return_record/R as anything in traumas)
			var/datum/brain_trauma/trauma = R.restore_trauma(H, brain, personalities[R.source_ref])
			source_map[R.source_ref] = REF(trauma)

/datum/z121_return_snapshot/proc/restore_traits(mob/living/carbon/human/H, list/source_map)
	var/list/restored_traits = z121_return_copy(traits)
	var/list/equipment_traits = H.z121_return_equipment_traits()
	for(var/trait in equipment_traits)
		var/list/sources = restored_traits[trait]
		if(!sources)
			sources = list()
			restored_traits[trait] = sources
		sources |= equipment_traits[trait]
	// 职位和议会惩戒属于当前世界进度，不能用清晨特性撤销罢免或恢复旧职位。
	for(var/trait in list(TRAIT_ALDERMAN, TRAIT_ALDERMAN_CENSURED))
		restored_traits -= trait
		if(H.status_traits?[trait])
			restored_traits[trait] = z121_return_copy(H.status_traits[trait])
	z121_return_restore_trait_sources(H, restored_traits, source_map)

/proc/z121_return_restore_trait_sources(datum/target, list/saved_sources, list/source_map)
	var/list/desired = z121_return_copy(saved_sources)
	for(var/trait in desired)
		var/list/sources = desired[trait]
		for(var/source in sources.Copy())
			if(source_map[source])
				sources -= source
				sources |= source_map[source]
	var/mob/living/carbon/human/H = ishuman(target) ? target : null
	var/previous_trait_update = H?.z121_return_changing_traits
	if(H)
		H.z121_return_changing_traits = TRUE
	try
		z121_return_apply_trait_sources(target, desired)
	catch(var/exception/error)
		if(H)
			H.z121_return_changing_traits = previous_trait_update
		throw error
	if(H)
		H.z121_return_changing_traits = previous_trait_update

/proc/z121_return_apply_trait_sources(datum/target, list/desired)
	// 按来源进行差异更新，触发标准增删信号，而不是直接覆盖特性表。
	for(var/trait in target.status_traits?.Copy())
		var/list/sources = target.status_traits[trait]
		var/list/wanted = desired[trait]
		for(var/source in sources.Copy())
			if(!(source in wanted))
				REMOVE_TRAIT(target, trait, source)
	for(var/trait in desired)
		for(var/source in desired[trait])
			ADD_TRAIT(target, trait, source)

/proc/z121_return_item_feature(datum/bodypart_feature/F)
	return istype(F, /datum/bodypart_feature/underwear) || istype(F, /datum/bodypart_feature/legwear) || istype(F, /datum/bodypart_feature/chastity)

/datum/z121_return_snapshot/Destroy()
	QDEL_NULL(body_values)
	QDEL_NULL(appearance_values)
	QDEL_NULL(species_appearance)
	QDEL_LIST(custom_descriptors)
	QDEL_NULL(dna_values)
	QDEL_NULL(physiology_values)
	QDEL_NULL(armor_values)
	QDEL_NULL(rot_values)
	QDEL_NULL(profession_values)
	for(var/list/records as anything in list(organ_dna, limbs, organs))
		for(var/key in records)
			qdel(records[key])
	for(var/list/entries as anything in list(wounds, features))
		for(var/list/entry as anything in entries)
			qdel(entry[2])
	QDEL_LIST(traumas)
	QDEL_LIST(statuses)
	QDEL_LIST(reagents)
	QDEL_LIST(addictions)
	QDEL_LIST(stress_records)
	return ..()

// 只回滚身体本身的异常；职业、施法冷却、任务与外部契约不能借读档刷新。
/proc/z121_return_bodily_status(datum/status_effect/E)
	if(istype(E, /datum/status_effect/mood))
		return TRUE
	if(istype(E, /datum/status_effect/buff/life_potential_burst) || istype(E, /datum/status_effect/buff/succubus_satisfaction) || istype(E, /datum/status_effect/buff/succubus_bite))
		return TRUE
	if(istype(E, /datum/status_effect/fire_handler))
		return TRUE
	if(istype(E, /datum/status_effect/incapacitating))
		return TRUE
	if(istype(E, /datum/status_effect/freon) || istype(E, /datum/status_effect/neck_slice) || istype(E, /datum/status_effect/spasms) || istype(E, /datum/status_effect/trance))
		return TRUE
	if(istype(E, /datum/status_effect/debuff))
		return !findtext("[E.type]", "cd") && !istype(E, /datum/status_effect/debuff/apostasy) && !findtext("[E.type]", "harpy_") && !findtext("[E.type]", "climbing") && !findtext("[E.type]", "enchantmenttriggered") && !findtext("[E.type]", "ritesexpended") && !istype(E, /datum/status_effect/debuff/yield_prompt) && !istype(E, /datum/status_effect/debuff/pomegranate_aura) && !istype(E, /datum/status_effect/debuff/divergence)
	var/static/list/bodily_buffs = list(/datum/status_effect/buff/drunk, /datum/status_effect/buff/murkwine, /datum/status_effect/buff/nocshine, /datum/status_effect/buff/abyss, /datum/status_effect/buff/fermented_crab, /datum/status_effect/buff/healing, /datum/status_effect/buff/originhealing, /datum/status_effect/buff/magicknowledge, /datum/status_effect/buff/magicstrength, /datum/status_effect/buff/magicspeed, /datum/status_effect/buff/magicwillpower, /datum/status_effect/buff/magicconstitution, /datum/status_effect/buff/magicperception, /datum/status_effect/buff/nocblessing, /datum/status_effect/buff/goodloving, /datum/status_effect/buff/massage, /datum/status_effect/buff/goodmassage, /datum/status_effect/buff/greatmassage, /datum/status_effect/buff/refocus, /datum/status_effect/buff/druqks, /datum/status_effect/buff/ozium, /datum/status_effect/buff/moondust, /datum/status_effect/buff/moondust_purest, /datum/status_effect/buff/herozium, /datum/status_effect/buff/starsugar, /datum/status_effect/buff/weed, /datum/status_effect/buff/vitae, /datum/status_effect/buff/snackbuff, /datum/status_effect/buff/greatsnackbuff, /datum/status_effect/buff/mealbuff, /datum/status_effect/buff/greatmealbuff, /datum/status_effect/buff/sweet, /datum/status_effect/buff/featherfall, /datum/status_effect/buff/darkvision, /datum/status_effect/buff/longstrider, /datum/status_effect/buff/magearmor, /datum/status_effect/buff/scalearmor, /datum/status_effect/buff/xray_vision, /datum/status_effect/buff/all_seeing_insight, /datum/status_effect/buff/moonlight_blessing, /datum/status_effect/buff/haste, /datum/status_effect/buff/accel)
	return is_type_in_list(E, bodily_buffs)
