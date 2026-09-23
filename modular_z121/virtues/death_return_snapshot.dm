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

/datum/z121_return_record/New(datum/source, list/fields)
	saved_type = source.type
	source_ref = REF(source)
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

/datum/z121_return_record/proc/apply(datum/target)
	for(var/field in values)
		if(field in target.vars)
			target.vars[field] = z121_return_copy(values[field])

// 肢体与器官字段显式列出，避免覆盖位置、拥有者、处理队列或缓存引用。
/proc/z121_return_limb_fields()
	return list("body_zone", "aux_zone", "held_index", "status", "disabled", "brute_dam", "burn_dam", "stamina_dam", "max_stamina_damage", "max_damage", "max_pain_damage", "cremation_progress", "brute_reduction", "burn_reduction", "skin_tone", "body_gender", "species_id", "species_color", "mutation_color", "species_icon", "use_digitigrade", "should_draw_gender", "should_draw_greyscale", "no_update", "rotted", "skeletonized", "fingers", "organ_slowdown", "is_prosthetic", "limb_material", "markings", "aux_markings", "brainkill", "hair_color", "hairstyle", "hair_alpha", "facial_hair_color", "facial_hairstyle", "lip_style", "lip_color", "branded_writing_on_neck", "unlimited_bleeding", "two_stage_death", "grievously_wounded", "branded_writing", "enslavement_mark", "brand_owner_name")

/proc/z121_return_organ_fields()
	return list("name", "slot", "zone", "zone_checked", "organ_flags", "maxHealth", "damage", "prev_damage", "healing_factor", "decay_factor", "low_threshold", "high_threshold", "low_threshold_passed", "high_threshold_passed", "now_failing", "now_fixed", "high_threshold_cleared", "low_threshold_cleared", "accessory_type", "accessory_colors", "visible_organ", "bodypart_icon", "bodypart_icon_state", "enslavement_mark", "brand_owner_name", "brain_death", "suicided", "damage_delta", "beat", "heartattack", "eye_color", "heterochromia", "second_color", "sight_flags", "see_in_dark", "eye_blind", "eye_damage", "penis_size", "functional", "sheath_type", "ball_size", "virility", "breast_size", "lactating", "milk_max", "fertility", "wings_color", "wing_natural_gradient", "wing_natural_color", "wing_dye_gradient", "wing_dye_color")

/proc/z121_return_body_fields()
	return list("gender", "age", "hair_color", "hairstyle", "facial_hair_color", "facial_hairstyle", "eye_color", "voice_color", "voice_pitch", "detail_color", "skin_tone", "lip_style", "lip_color", "shavelevel", "has_stubble", "socks", "accessory", "detail", "marking", "resize", "health", "max_stamina", "maxHealth", "crit_threshold", "nutrition", "hydration", "bodytemperature", "stamina", "energy", "max_energy", "drunkenness", "druggy", "hallucination", "dizziness", "drowsyness", "jitteriness", "stuttering", "slurring", "confused", "disgust", "losebreath", "breath_tick", "silent", "eye_blind", "eye_blurry", "fire_stacks", "on_fire", "STASTR", "STAPER", "STAINT", "STACON", "STAWIL", "STASPD", "STALUC", "BUFSTR", "BUFPER", "BUFINT", "BUFCON", "BUFEND", "BUFSPE", "BUFLUC", "statbuf", "statindex")

/datum/z121_return_snapshot
	var/body_ref
	var/saved_x
	var/saved_y
	var/saved_z
	var/species_type
	var/datum/z121_return_record/body_values
	var/datum/z121_return_record/dna_values
	var/datum/z121_return_record/physiology_values
	var/datum/z121_return_record/armor_values
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
	var/rpg_present = FALSE
	var/rpg_points = 0

/datum/z121_return_snapshot/New(mob/living/carbon/human/H)
	body_ref = REF(H)
	var/turf/T = get_turf(H)
	saved_x = T.x
	saved_y = T.y
	saved_z = T.z
	species_type = H.dna.species.type
	body_values = new(H, z121_return_body_fields())
	dna_values = new(H.dna, list("unique_enzymes", "uni_identity", "blood_type", "features", "body_markings", "current_body_size", "real_name", "stability", "scrambled"))
	physiology_values = new(H.physiology)
	armor_values = new(H.physiology.armor)
	for(var/slot in H.dna.organ_dna)
		var/datum/organ_dna/D = H.dna.organ_dna[slot]
		if(istype(D))
			organ_dna[slot] = new /datum/z121_return_record(D)
	for(var/obj/item/bodypart/B as anything in H.bodyparts)
		limbs[B.body_zone] = new /datum/z121_return_record(B, z121_return_limb_fields())
		for(var/datum/bodypart_feature/F as anything in B.bodypart_features)
			features += list(list(B.body_zone, new /datum/z121_return_record(F)))
	for(var/obj/item/organ/O as anything in H.internal_organs)
		organs[O.slot] = new /datum/z121_return_record(O, z121_return_organ_fields())
	for(var/datum/wound/W as anything in H.get_wounds())
		wounds += list(list(W.bodypart_owner?.body_zone, new /datum/z121_return_record(W)))
	var/obj/item/organ/brain/brain = H.getorganslot(ORGAN_SLOT_BRAIN)
	for(var/datum/brain_trauma/trauma as anything in brain?.traumas)
		traumas += new /datum/z121_return_record(trauma)
	for(var/datum/status_effect/E as anything in H.status_effects)
		if(z121_return_bodily_status(E))
			var/datum/z121_return_record/R = new(E)
			R.values["duration"] = E.duration == -1 ? -1 : max(0, E.duration - world.time)
			R.values["tick_interval"] = max(0, E.tick_interval - world.time)
			statuses += R
	chem_temp = H.reagents.chem_temp
	for(var/datum/reagent/R as anything in H.reagents.reagent_list)
		reagents += new /datum/z121_return_record(R, list("volume", "data", "current_cycle", "metabolizing", "overdosed", "addiction_stage", "addiction_permanent"))
	addiction_tick = H.reagents.addiction_tick
	for(var/datum/reagent/R as anything in H.reagents.addiction_list)
		addictions += new /datum/z121_return_record(R, list("data", "current_cycle", "addiction_stage", "addiction_permanent"))
	traits = z121_return_copy(H.status_traits)
	var/datum/skill_holder/skills = H.ensure_skills()
	known_skills = skills.known_skills.Copy()
	skill_experience = skills.skill_experience.Copy()
	losses = list(H.getToxLoss(), H.getOxyLoss(), H.getCloneLoss(), H.getStaminaLoss())
	blood = H.get_blood_volume()
	var/datum/component/rpg_system/system = H.GetComponent(/datum/component/rpg_system)
	rpg_present = !!system
	if(system)
		rpg_points = system.points

/datum/z121_return_snapshot/proc/find_destination(mob/living/carbon/human/H)
	var/turf/origin = locate(saved_x, saved_y, saved_z)
	if(z121_return_open_turf(origin, H))
		return origin
	// 逐圈搜索同层最近的可进入地块；坐标对应的地块被替换仍可正常定位。
	for(var/radius in 1 to max(world.maxx, world.maxy))
		for(var/px in max(1, saved_x - radius) to min(world.maxx, saved_x + radius))
			for(var/py in list(saved_y - radius, saved_y + radius))
				var/turf/T = locate(px, py, saved_z)
				if(z121_return_open_turf(T, H))
					return T
		for(var/py in max(1, saved_y - radius + 1) to min(world.maxy, saved_y + radius - 1))
			for(var/px in list(saved_x - radius, saved_x + radius))
				var/turf/T = locate(px, py, saved_z)
				if(z121_return_open_turf(T, H))
					return T
	return null

/proc/z121_return_open_turf(turf/T, mob/living/H)
	if(!istype(T, /turf/open) || istype(T, /turf/open/transparent/openspace) || T.density)
		return FALSE
	for(var/atom/movable/A in T)
		if(A != H && A.density)
			return FALSE
	return TRUE

/datum/z121_return_snapshot/proc/restore(mob/living/carbon/human/H)
	var/list/source_map = list()
	source_map[body_ref] = REF(H)
	// 清理旧效果时仍使用旧数值，随后再恢复快照，避免移除效果时重复扣属性。
	for(var/datum/status_effect/E as anything in H.status_effects?.Copy())
		if(z121_return_bodily_status(E))
			qdel(E)
	for(var/datum/wound/W as anything in H.get_wounds())
		qdel(W)
	H.reagents.clear_reagents()
	if(H.dna.species.type != species_type)
		H.set_species(species_type, icon_update = FALSE)
	dna_values.apply(H.dna)
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
		if(entry[1])
			W.apply_to_bodypart(H.get_bodypart(entry[1]), silent = TRUE)
		else
			W.apply_to_mob(H, silent = TRUE)
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
		var/datum/status_effect/E = H.apply_status_effect(R.saved_type, R.values["duration"])
		if(!QDELETED(E))
			R.apply(E)
			if(E.duration != -1)
				E.duration += world.time
			E.tick_interval += world.time
			source_map[R.source_ref] = REF(E)
	// 临时效果安装完成后覆盖保存的最终数值，保留其到期撤销逻辑。
	body_values.apply(H)
	physiology_values.apply(H.physiology)
	armor_values.apply(H.physiology.armor)
	restore_traits(H, source_map)
	H.setToxLoss(losses[1], FALSE, TRUE)
	// 核心的缺氧赋值仍会检查无敌标记，暂时解除以完整恢复保存的缺氧值。
	var/previous_status_flags = H.status_flags
	H.status_flags &= ~GODMODE
	H.setOxyLoss(losses[2], FALSE, TRUE)
	H.status_flags = previous_status_flags
	H.setCloneLoss(losses[3], FALSE, TRUE)
	H.setStaminaLoss(losses[4], FALSE, TRUE)
	H.set_blood_volume(blood)
	var/datum/skill_holder/skills = H.ensure_skills()
	skills.known_skills = known_skills.Copy()
	skills.skill_experience = skill_experience.Copy()
	restore_rpg(H)
	H.dna.update_body_size()
	H.update_move_intent_slowdown()
	H.update_movespeed(FALSE)
	H.update_energy_hud()
	H.update_stamina_hud()
	H.mark_zone_selector_hud_dirty()
	H.mark_pain_hud_dirty()

/datum/z121_return_snapshot/proc/restore_anatomy(mob/living/carbon/human/H, list/source_map)
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
		B.bodypart_features = list()
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
		source_map[R.source_ref] = REF(O)
	var/obj/item/organ/brain/brain = H.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.original_body_ref = WEAKREF(H)
		for(var/datum/brain_trauma/old as anything in brain.traumas.Copy())
			qdel(old)
		for(var/datum/z121_return_record/R as anything in traumas)
			var/datum/brain_trauma/trauma = new R.saved_type
			R.apply(trauma)
			brain.gain_trauma(trauma, trauma.resilience)
			source_map[R.source_ref] = REF(trauma)

/datum/z121_return_snapshot/proc/restore_traits(mob/living/carbon/human/H, list/source_map)
	var/list/desired = z121_return_copy(traits)
	for(var/trait in desired)
		var/list/sources = desired[trait]
		for(var/source in sources.Copy())
			if(source_map[source])
				sources -= source
				sources |= source_map[source]
	// 按来源进行差异更新，触发标准增删信号，而不是直接覆盖特性表。
	for(var/trait in H.status_traits?.Copy())
		var/list/sources = H.status_traits[trait]
		var/list/wanted = desired[trait]
		for(var/source in sources.Copy())
			if(!(source in wanted))
				REMOVE_TRAIT(H, trait, source)
	for(var/trait in desired)
		for(var/source in desired[trait])
			ADD_TRAIT(H, trait, source)

/datum/z121_return_snapshot/proc/restore_rpg(mob/living/carbon/human/H)
	var/datum/component/rpg_system/system = H.GetComponent(/datum/component/rpg_system)
	if(rpg_present)
		if(!system)
			system = H.AddComponent(/datum/component/rpg_system)
		system.z121_return_generation++
		system.points = rpg_points
		H.verbs |= /mob/living/carbon/human/proc/open_rpg_system
		SStgui.update_uis(system)
	else if(system)
		qdel(system)
		H.verbs -= /mob/living/carbon/human/proc/open_rpg_system

/datum/z121_return_snapshot/Destroy()
	QDEL_NULL(body_values)
	QDEL_NULL(dna_values)
	QDEL_NULL(physiology_values)
	QDEL_NULL(armor_values)
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
	return ..()

// 只回滚身体本身的异常；职业、施法冷却、任务与外部契约不能借读档刷新。
/proc/z121_return_bodily_status(datum/status_effect/E)
	if(istype(E, /datum/status_effect/incapacitating))
		return TRUE
	if(istype(E, /datum/status_effect/freon) || istype(E, /datum/status_effect/neck_slice) || istype(E, /datum/status_effect/spasms) || istype(E, /datum/status_effect/trance))
		return TRUE
	if(istype(E, /datum/status_effect/debuff))
		return !findtext("[E.type]", "cd") && !istype(E, /datum/status_effect/debuff/apostasy) && !findtext("[E.type]", "harpy_") && !findtext("[E.type]", "climbing") && !findtext("[E.type]", "enchantmenttriggered") && !findtext("[E.type]", "ritesexpended") && !istype(E, /datum/status_effect/debuff/yield_prompt) && !istype(E, /datum/status_effect/debuff/pomegranate_aura) && !istype(E, /datum/status_effect/debuff/divergence)
	var/static/list/bodily_buffs = list(/datum/status_effect/buff/druqks, /datum/status_effect/buff/ozium, /datum/status_effect/buff/moondust, /datum/status_effect/buff/moondust_purest, /datum/status_effect/buff/herozium, /datum/status_effect/buff/starsugar, /datum/status_effect/buff/weed, /datum/status_effect/buff/vitae, /datum/status_effect/buff/snackbuff, /datum/status_effect/buff/greatsnackbuff, /datum/status_effect/buff/mealbuff, /datum/status_effect/buff/greatmealbuff, /datum/status_effect/buff/sweet, /datum/status_effect/buff/featherfall, /datum/status_effect/buff/darkvision, /datum/status_effect/buff/longstrider, /datum/status_effect/buff/magearmor, /datum/status_effect/buff/scalearmor, /datum/status_effect/buff/magic_flight, /datum/status_effect/buff/xray_vision, /datum/status_effect/buff/all_seeing_insight, /datum/status_effect/buff/moonlight_blessing, /datum/status_effect/buff/haste, /datum/status_effect/buff/accel)
	return is_type_in_list(E, bodily_buffs)

// 正在生成的商店物品不得在读档后给新余额退款或送入回归后的手中。
/datum/component/rpg_system
	var/z121_return_generation = 0

// 迁移的是当前日志实例，不恢复清晨的任务进度或每日领取资格。
/datum/component/rpg_journal/PostTransfer()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	QDEL_NULL(tracker)
