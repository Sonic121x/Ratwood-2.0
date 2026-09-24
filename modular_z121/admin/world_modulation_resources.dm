// 覆盖值属于身体；未设置的角色继续使用原有生命循环。
/mob/living/carbon/human
	var/z121_world_max_stamina
	var/z121_world_max_energy
	var/z121_world_max_devotion
	var/z121_world_stamina_rate = 1
	var/z121_world_energy_rate = 1
	var/z121_world_devotion_rate = 1
	var/z121_world_miracles = "default"
	var/z121_world_restoring_energy = FALSE

/mob/living/carbon/human/update_energy()
	if(isnull(z121_world_max_energy) && z121_world_energy_rate == 1)
		return ..()
	max_energy = isnull(z121_world_max_energy) ? (STAWIL + get_skill_level(/datum/skill/misc/athletics) / 2) * 100 : z121_world_max_energy
	if(cmode && !HAS_TRAIT(src, TRAIT_BREADY))
		energy_add(-2)
	if(HAS_TRAIT(src, TRAIT_INFINITE_ENERGY))
		energy = max_energy
	if(HAS_TRAIT(src, TRAIT_BREADY))
		energy_add(4 * z121_world_energy_rate)

/mob/living/carbon/human/update_stamina()
	if(isnull(z121_world_max_stamina) && z121_world_stamina_rate == 1)
		return ..()
	max_stamina = isnull(z121_world_max_stamina) ? max_energy / 10 : z121_world_max_stamina
	var/delay = 20
	if(HAS_TRAIT(src, TRAIT_APRICITY))
		switch(GLOB.tod)
			if("day", "dawn")
				delay = 13
			if("night", "dusk")
				delay = 16
	if(world.time > last_fatigued + delay && z121_world_stamina_rate > 0)
		var/added = round(-10 + (energy / max_energy * -40))
		if(climbing)
			added = 0
		if(bodytemperature > BODYTEMP_HEAT_LEVEL_ONE_MAX)
			added = round(added * 0.5, 1)
		if(HAS_TRAIT(src, TRAIT_MISSING_NOSE))
			added = round(added * 0.5, 1)
		if(HAS_TRAIT(src, TRAIT_MONK_ROBE))
			added = round(added * 1.25, 1)
		if(stamina >= 1)
			stamina_add(added * z121_world_stamina_rate)
		else
			stamina = 0
	update_stamina_hud()

// 仅在原生休息恢复调用期间缩放正向能量，药剂与法术不进入此范围。
/mob/living/carbon/human/handle_sleep()
	if(z121_world_energy_rate == 1)
		return ..()
	var/previous = z121_world_restoring_energy
	z121_world_restoring_energy = TRUE
	try
		. = ..()
	catch(var/exception/error)
		z121_world_restoring_energy = previous
		throw error
	z121_world_restoring_energy = previous

/mob/living/carbon/human/energy_add(added)
	if(added > 0 && z121_world_restoring_energy)
		added *= z121_world_energy_rate
	return ..(added)

/datum/devotion
	var/z121_world_original_max
	var/z121_world_applied_max

// 保存外部系统最近写入的原生上限，恢复默认时不丢弃职业变化。
/datum/devotion/proc/z121_world_sync_max()
	if(!holder)
		return
	if(!isnull(holder.z121_world_max_devotion))
		if(isnull(z121_world_applied_max) || max_devotion != z121_world_applied_max)
			z121_world_original_max = max_devotion
		max_devotion = holder.z121_world_max_devotion
		z121_world_applied_max = max_devotion
	else if(!isnull(z121_world_applied_max))
		if(max_devotion == z121_world_applied_max)
			max_devotion = z121_world_original_max
		z121_world_applied_max = null
		z121_world_original_max = null
	else
		return
	devotion = clamp(devotion, 0, max_devotion)

/datum/devotion/process()
	z121_world_sync_max()
	if(!passive_devotion_gain && !passive_progression_gain)
		return PROCESS_KILL
	var/multiplier = 1
	if(holder?.mind)
		multiplier += holder.get_skill_level(/datum/skill/magic/holy) / SKILL_LEVEL_LEGENDARY
	var/rate = holder ? holder.z121_world_devotion_rate : 1
	update_devotion(passive_devotion_gain * multiplier * rate, passive_progression_gain * multiplier, silent = TRUE)

/datum/devotion/check_devotion(obj/effect/proc_holder/spell/spell)
	z121_world_sync_max()
	if(holder?.z121_world_miracles == "deny")
		return FALSE
	return devotion >= spell.devotion_cost

// 管理员创建的容器不绑定职业奖励，也不自动发放神祇法术或特性。
/datum/devotion/z121_world
	suppress_grants = TRUE
	passive_devotion_gain = CLERIC_REGEN_WEAK

/datum/devotion/z121_world/New(mob/living/carbon/human/user)
	..(user, GLOB.patronlist[/datum/patron/godless])
	START_PROCESSING(SSobj, src)
	update_devotion(0, 0, TRUE)

/datum/z121_world_modulation/proc/resource_data(mob/user)
	if(!ishuman(user))
		return list("available" = FALSE, "reason" = "体力、能量与奇迹资源需要当前控制人形角色。")
	var/mob/living/carbon/human/H = user
	H.devotion?.z121_world_sync_max()
	return list(
		"available" = TRUE,
		"miracles" = H.z121_world_miracles,
		"has_devotion" = !!H.devotion,
		"has_mind" = !!H.mind,
		"points" = H.mind ? max(0, H.mind.spell_points - H.mind.used_spell_points) : 0,
		"used_points" = H.mind?.used_spell_points || 0,
		"rows" = list(
			list("id" = "stamina", "name" = "体力", "current" = max(0, H.max_stamina - H.stamina), "maximum" = H.max_stamina, "custom" = !isnull(H.z121_world_max_stamina), "rate" = H.z121_world_stamina_rate, "enabled" = TRUE),
			list("id" = "energy", "name" = "能量", "current" = H.energy, "maximum" = H.max_energy, "custom" = !isnull(H.z121_world_max_energy), "rate" = H.z121_world_energy_rate, "enabled" = TRUE),
			list("id" = "devotion", "name" = "奇迹值（虔诚）", "current" = H.devotion?.devotion || 0, "maximum" = H.devotion?.max_devotion || 0, "custom" = !isnull(H.z121_world_max_devotion), "rate" = H.z121_world_devotion_rate, "enabled" = !!H.devotion),
		),
	)

/datum/z121_world_modulation/proc/set_resource(mob/user, action, list/params)
	if(!ishuman(user))
		notice = "此功能需要当前控制人形角色。"
		return
	var/mob/living/carbon/human/H = user
	if(action == "miracles")
		var/mode = params["value"]
		if(!(mode in list("default", "allow", "deny")))
			return
		H.z121_world_miracles = mode
		if(mode == "allow" && !H.devotion)
			new /datum/devotion/z121_world(H)
		else if(mode == "default" && istype(H.devotion, /datum/devotion/z121_world))
			QDEL_NULL(H.devotion)
		notice = "奇迹权限已更新，已拥有的奇迹仍然保留。"
		audit("奇迹权限 → [mode]")
		return
	var/value = params["value"]
	if(action == "spell_points")
		if(!H.mind)
			notice = "当前角色没有心智，不能调整法术点。"
			return
		if(!isnum(value) || !(value >= 0 && value <= 1000000) || value != round(value))
			return
		H.mind.spell_points = H.mind.used_spell_points + value
		H.mind.check_learnspell()
		notice = "可用法术点已设为 [value]。"
		audit(notice)
		return
	var/id = params["id"]
	if(!(id in list("stamina", "energy", "devotion")) || (id == "devotion" && !H.devotion))
		return
	if(action == "resource_rate")
		if(!isnum(value) || !(value >= 0 && value <= 1000000))
			return
		H.vars["z121_world_[id]_rate"] = value
		notice = "自然恢复倍率已设为 [value]。"
	else if(action in list("resource_max", "resource_reset"))
		if(action == "resource_max" && (!isnum(value) || !(value >= 1 && value <= 1000000) || value != round(value)))
			return
		var/remaining_stamina = max(0, H.max_stamina - H.stamina)
		H.vars["z121_world_max_[id]"] = action == "resource_reset" ? null : value
		if(action == "resource_reset")
			H.vars["z121_world_[id]_rate"] = 1
		H.max_energy = isnull(H.z121_world_max_energy) ? (H.STAWIL + H.get_skill_level(/datum/skill/misc/athletics) / 2) * 100 : H.z121_world_max_energy
		H.energy = clamp(H.energy, 0, H.max_energy)
		H.max_stamina = isnull(H.z121_world_max_stamina) ? H.max_energy / 10 : H.z121_world_max_stamina
		H.stamina = H.max_stamina - min(remaining_stamina, H.max_stamina)
		H.update_energy_hud()
		H.update_stamina_hud()
		H.devotion?.update_devotion(0, 0, TRUE)
		notice = action == "resource_reset" ? "已恢复原生上限与恢复倍率。" : "资源上限已设为 [value]。"
	else
		return
	audit("修改自身资源 [id]：[notice]")

// 保留原生虔诚与晋升流程，只在结算前落实身体的资源上限。
/datum/devotion/update_devotion(dev_amt, prog_amt, silent = FALSE)
	z121_world_sync_max()
	devotion = clamp(devotion + dev_amt, 0, max_devotion)
	holder?.hud_used?.bloodpool?.name = "Devotion: [devotion]"
	holder?.hud_used?.bloodpool?.desc = "Devotion: [devotion]/[max_devotion]"
	if(devotion <= 0)
		holder?.hud_used?.bloodpool?.set_value(0, 1 SECONDS)
	else
		holder?.hud_used?.bloodpool?.set_value((100 / (max_devotion / devotion)) / 100, 1 SECONDS)

	if((devotion >= max_devotion) && !silent)
		to_chat(holder, span_warning("I have reached the limit of my devotion..."))
	if(!prog_amt)
		return TRUE
	progression = clamp(progression + prog_amt, 0, max_progression)
	switch(level)
		if(CLERIC_T0)
			if(progression >= CLERIC_REQ_1)
				level = CLERIC_T1
		if(CLERIC_T1)
			if(progression >= CLERIC_REQ_2)
				level = CLERIC_T2
		if(CLERIC_T2)
			if(progression >= CLERIC_REQ_3)
				level = CLERIC_T3
		if(CLERIC_T3)
			if(progression >= CLERIC_REQ_4)
				level = CLERIC_T4
	if(!holder?.mind)
		return FALSE
	if(level != last_level)
		try_add_spells(silent = silent)
		last_level = level
	return TRUE
