// modular_z121 自定义奥术法术：恢复如初
// 仅在 modular_z121 内实现，不改动主线法术逻辑。

/obj/effect/proc_holder/spell/invoked/restore_pristine
	name = "恢复如初"
	desc = "通过精湛的魔法技艺让物品或建筑受到的损伤像是时光倒流一般恢复。"
	cost = 4
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	recharge_time = 5 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "restore_pristine"
	invocations = list("恢复如初！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 7
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/invoked/restore_pristine/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isobj(target_atom) || isliving(target_atom))
		to_chat(user, span_warning("恢复如初只能对物品或建筑施放。"))
		revert_cast()
		return FALSE

	var/obj/target_obj = target_atom
	var/arcane_level = max(user.get_skill_level(/datum/skill/magic/arcane), 0)
	if(arcane_level <= 0)
		to_chat(user, span_warning("我对这道回溯魔法的理解还远远不够。"))
		revert_cast()
		return FALSE
	if(!can_restore_target(target_obj, arcane_level))
		to_chat(user, span_warning("[target_obj] 眼下没有任何可供回溯的损伤。"))
		revert_cast()
		return FALSE

	var/restored_any = FALSE
	var/restore_ratio = get_restore_ratio(arcane_level)

	// 奥术 5 级及以上会先把被磨损的最大值回溯到初始值，再直接补满当前值。
	if(arcane_level >= 5)
		restored_any |= restore_maximums(target_obj)
		restored_any |= restore_integrity(target_obj, null, user)
		if(isitem(target_obj))
			var/obj/item/target_item = target_obj
			restored_any |= restore_blade(target_item, null, user)
	else
		restored_any |= restore_integrity(target_obj, restore_ratio, user)
		if(isitem(target_obj))
			var/obj/item/target_item = target_obj
			restored_any |= restore_blade(target_item, restore_ratio, user)

	if(!restored_any)
		to_chat(user, span_warning("[target_obj] 上没有可被恢复如初扭转的损伤。"))
		revert_cast()
		return FALSE

	playsound(get_turf(target_obj), 'sound/magic/whiteflame.ogg', 80, TRUE)
	user.visible_message(span_notice("[user] 朝着 [target_obj] 念出古老咒言，丝丝裂痕与磨损竟像倒流的时光一般自行愈合。"))
	to_chat(user, span_notice("我将 [target_obj] 受到的损伤逆转回更完好的状态。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/can_restore_target(obj/target_obj, arcane_level)
	var/initial_max_integrity = initial(target_obj.max_integrity)
	if(target_obj.max_integrity)
		if(target_obj.obj_integrity < target_obj.max_integrity)
			return TRUE
	if(arcane_level >= 5 && initial_max_integrity > target_obj.max_integrity)
		return TRUE
	if(isitem(target_obj))
		var/obj/item/target_item = target_obj
		var/initial_max_blade = initial(target_item.max_blade_int)
		if(target_item.max_blade_int)
			if(target_item.blade_int < target_item.max_blade_int)
				return TRUE
		if(arcane_level >= 5 && initial_max_blade > target_item.max_blade_int)
			return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/get_restore_ratio(arcane_level)
	if(arcane_level == 1)
		return 0.10
	if(arcane_level == 2)
		return 0.20
	if(arcane_level == 3)
		return 0.40
	if(arcane_level == 4)
		return 0.80
	if(arcane_level >= 5)
		return 1
	return 0

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/restore_maximums(obj/target_obj)
	var/restored_any = FALSE
	var/initial_max_integrity = initial(target_obj.max_integrity)
	if(initial_max_integrity > target_obj.max_integrity)
		target_obj.max_integrity = initial_max_integrity
		restored_any = TRUE

	if(isitem(target_obj))
		var/obj/item/target_item = target_obj
		var/initial_max_blade = initial(target_item.max_blade_int)
		if(initial_max_blade > target_item.max_blade_int)
			target_item.max_blade_int = initial_max_blade
			restored_any = TRUE

	return restored_any

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/restore_integrity(obj/target_obj, restore_ratio, mob/living/user)
	if(!target_obj.max_integrity)
		return FALSE

	// 记录施法前目标是否已处于“碎裂/损坏”状态。
	// 护甲碎裂(obj_break)时会先把自身防御(armor)备份到 original_armor 再把防御清零，
	// 只有通过 obj_fix() 解除碎裂时才会用 original_armor 把防御还原回来。
	var/was_broken = target_obj.obj_broken
	var/old_integrity = target_obj.obj_integrity

	// 恢复耐久：restore_ratio 为 null 表示直接补满，否则按比例修复。
	if(isnull(restore_ratio))
		target_obj.obj_integrity = target_obj.max_integrity
	else
		if(restore_ratio <= 0)
			return FALSE
		var/repair_amount = max(1, round(target_obj.max_integrity * restore_ratio))
		target_obj.obj_integrity = min(target_obj.obj_integrity + repair_amount, target_obj.max_integrity)

	// 耐久没有任何提升，说明本次没有可修复的损伤。
	if(target_obj.obj_integrity <= old_integrity)
		return FALSE

	// 目标若为物品，后续需要额外处理 shoddy_repair / 覆盖部位 / 破损贴图等逻辑。
	var/obj/item/target_item = null
	if(isitem(target_obj))
		target_item = target_obj

	var/full_repaired = (target_obj.obj_integrity >= target_obj.max_integrity)

	// 耐久补满时，清除“劣质修补”痕迹并修复被剥落的护甲覆盖部位。
	// 顺序很关键：必须先清除 shoddy_repair 再调用下方的 obj_fix()，
	// 否则 /obj/item/obj_fix() 检测到劣质修补会把耐久强制压回 60%，导致无法真正修满。
	if(full_repaired && target_item)
		if(target_item.shoddy_repair)
			target_item.shoddy_repair = FALSE
		if(target_item.body_parts_covered_dynamic != target_item.body_parts_covered)
			target_item.repair_coverage()

	// 只有“施法前已碎裂”的物品才需要调用 obj_fix() 来解除碎裂状态。
	// 这是修复“护甲失去防御力”bug 的关键：
	// /obj/item/clothing/obj_fix() 会用 original_armor 覆盖 armor，
	// 而 original_armor 只在碎裂(obj_break)时才会被备份；
	// 若对从未碎裂的护甲调用 obj_fix()，armor 会被置空，护甲将彻底失去防御力。
	if(was_broken)
		var/fix_threshold = target_obj.integrity_failure ? (target_obj.integrity_failure * target_obj.max_integrity) : 1
		if(target_obj.obj_integrity > fix_threshold)
			// full_repair 传参：耐久未补满时传 FALSE，只解除碎裂、不强制拉满耐久；
			// 耐久已补满时传 TRUE 做完整修复（此时 shoddy_repair 已被清除，不会被压回 60%）。
			target_obj.obj_fix(user, full_repaired)

	// 耐久未补满时刷新破损外观贴图。
	if(!full_repaired && target_item)
		target_item.update_damaged_state()

	return TRUE

/obj/effect/proc_holder/spell/invoked/restore_pristine/proc/restore_blade(obj/item/target_item, restore_ratio, mob/living/user)
	if(!target_item.max_blade_int)
		return FALSE

	var/old_blade_int = target_item.blade_int
	if(isnull(restore_ratio))
		target_item.blade_int = target_item.max_blade_int
	else
		if(restore_ratio <= 0)
			return FALSE
		// 这里不走 add_bintegrity()，避免被 TRAIT_SHARPER_BLADES 额外放大恢复量。
		var/blade_amount = max(1, round(target_item.max_blade_int * restore_ratio))
		var/old_ratio = target_item.blade_int / target_item.max_blade_int
		target_item.blade_int = min(target_item.blade_int + blade_amount, target_item.max_blade_int)
		var/new_ratio = target_item.blade_int / target_item.max_blade_int

		if(user)
			if(old_ratio < SHARPNESS_TIER2_THRESHOLD && new_ratio > SHARPNESS_TIER2_THRESHOLD)
				to_chat(user, span_info("<b>崩口</b>被磨平了。刃口恢复了些许平整。"))
			if(old_ratio < SHARPNESS_TIER1_THRESHOLD && new_ratio > SHARPNESS_TIER1_THRESHOLD)
				to_chat(user, span_info("<b>缺口</b>消失了。刃口如今又恢复到了往日的锋利。"))

	return target_item.blade_int > old_blade_int
