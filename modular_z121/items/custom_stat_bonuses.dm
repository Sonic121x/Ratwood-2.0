// 属性加成属于物品实例；七项均为零时不创建组件。
/obj/item
	var/z121_bonus_strength = 0
	var/z121_bonus_perception = 0
	var/z121_bonus_intelligence = 0
	var/z121_bonus_constitution = 0
	var/z121_bonus_willpower = 0
	var/z121_bonus_speed = 0
	var/z121_bonus_luck = 0
	var/z121_stat_bonus_mode = "手持或佩戴"

/obj/item/proc/z121_stat_bonus_values()
	return list(
		STATKEY_STR = z121_bonus_strength,
		STATKEY_PER = z121_bonus_perception,
		STATKEY_INT = z121_bonus_intelligence,
		STATKEY_CON = z121_bonus_constitution,
		STATKEY_WIL = z121_bonus_willpower,
		STATKEY_SPD = z121_bonus_speed,
		STATKEY_LCK = z121_bonus_luck,
	)

/obj/item/vv_edit_var(var_name, var_value)
	var/is_bonus = var_name in list("z121_bonus_strength", "z121_bonus_perception", "z121_bonus_intelligence", "z121_bonus_constitution", "z121_bonus_willpower", "z121_bonus_speed", "z121_bonus_luck")
	var/is_mode = var_name == NAMEOF(src, z121_stat_bonus_mode)
	if(is_bonus && (!isnum(var_value) || var_value != round(var_value)))
		return FALSE
	if(is_mode && !(var_value in list("仅手持", "仅佩戴", "手持或佩戴")))
		return FALSE
	. = ..()
	if(!. || (!is_bonus && !is_mode))
		return
	var/datum/component/z121_item_stat_bonuses/bonuses = GetComponent(/datum/component/z121_item_stat_bonuses)
	var/list/values = z121_stat_bonus_values()
	var/has_bonus = FALSE
	for(var/stat_key in values)
		if(values[stat_key])
			has_bonus = TRUE
			break
	if(!has_bonus)
		if(bonuses)
			qdel(bonuses)
	else if(bonuses)
		bonuses.refresh()
	else
		AddComponent(/datum/component/z121_item_stat_bonuses)

/datum/component/z121_item_stat_bonuses
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/holder
	var/list/applied_bonuses = list()
	var/refresh_queued = FALSE

/datum/component/z121_item_stat_bonuses/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/z121_item_stat_bonuses/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_parent_deleted))
	refresh()

/datum/component/z121_item_stat_bonuses/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	clear_bonuses()

/datum/component/z121_item_stat_bonuses/Destroy(force = FALSE, silent = FALSE)
	clear_bonuses()
	return ..()

// 每项属性拥有独立来源，只撤销本件物品登记的加成。
/datum/component/z121_item_stat_bonuses/proc/source_key(stat_key)
	return "z121_item_stat_[REF(src)]_[stat_key]"

/datum/component/z121_item_stat_bonuses/proc/clear_bonuses()
	if(holder)
		UnregisterSignal(holder, COMSIG_QDELETING)
		if(!QDELETED(holder))
			for(var/stat_key in applied_bonuses)
				holder.change_stat(stat_key, 0, source_key(stat_key))
	holder = null
	applied_bonuses.Cut()

// 仅检查实际手持和装备槽，容器内部、口袋及束缚槽不生效。
/datum/component/z121_item_stat_bonuses/proc/eligible_holder()
	var/obj/item/item = parent
	if(QDELETED(item) || !isliving(item.loc))
		return null
	var/mob/living/user = item.loc
	if(QDELETED(user))
		return null
	if(user.is_holding(item))
		return item.z121_stat_bonus_mode != "仅佩戴" ? user : null
	if(item.z121_stat_bonus_mode == "仅手持")
		return null
	for(var/slot in list(SLOT_BACK, SLOT_BACK_L, SLOT_BACK_R, SLOT_BELT, SLOT_BELT_L, SLOT_BELT_R, SLOT_CLOAK, SLOT_HEAD, SLOT_MOUTH, SLOT_WEAR_MASK, SLOT_NECK, SLOT_GLOVES, SLOT_RING, SLOT_WRISTS, SLOT_ARMOR, SLOT_SHIRT, SLOT_SHOES, SLOT_PANTS, SLOT_GLASSES))
		if(user.get_item_by_slot(slot) == item)
			return user
	return null

/datum/component/z121_item_stat_bonuses/proc/refresh()
	var/mob/living/new_holder = eligible_holder()
	if(new_holder != holder)
		clear_bonuses()
		holder = new_holder
		if(holder)
			RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_deleted))
	if(!holder)
		return
	var/obj/item/item = parent
	var/list/values = item.z121_stat_bonus_values()
	for(var/stat_key in values)
		var/amount = values[stat_key]
		if(!isnum(amount) || amount != round(amount))
			amount = 0
		if(amount == (applied_bonuses[stat_key] || 0))
			continue
		holder.change_stat(stat_key, 0, source_key(stat_key))
		if(amount)
			holder.change_stat(stat_key, amount, source_key(stat_key))
			applied_bonuses[stat_key] = amount
		else
			applied_bonuses -= stat_key

// 装备信号可能早于最后的槽位更新，延后一刻补做核对。
/datum/component/z121_item_stat_bonuses/proc/queue_refresh()
	if(refresh_queued)
		return
	refresh_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(deferred_refresh)), 0)

/datum/component/z121_item_stat_bonuses/proc/deferred_refresh()
	refresh_queued = FALSE
	refresh()

/datum/component/z121_item_stat_bonuses/proc/on_equipped()
	SIGNAL_HANDLER
	refresh()
	queue_refresh()

/datum/component/z121_item_stat_bonuses/proc/on_dropped()
	SIGNAL_HANDLER
	clear_bonuses()
	queue_refresh()

/datum/component/z121_item_stat_bonuses/proc/on_moved()
	SIGNAL_HANDLER
	refresh()
	queue_refresh()

/datum/component/z121_item_stat_bonuses/proc/on_parent_deleted()
	SIGNAL_HANDLER
	clear_bonuses()

/datum/component/z121_item_stat_bonuses/proc/on_holder_deleted()
	SIGNAL_HANDLER
	clear_bonuses()
