// 储物术：固定保存一个手持物品实体，再次施法取出；不提供背包界面。
#define STORAGE_MANA_COST 1
#define STORAGE_RESOURCE_COST 3
#define STORAGE_CHANNEL_TIME (0.5 SECONDS)
#define STORAGE_COOLDOWN (1 SECONDS)

// 放在 nullspace，避免成为角色物品栏中的可交互容器；由法术负责释放和销毁。
/obj/effect/z121_spell_storage
	name = "魔法储物空间"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = 0

/obj/effect/proc_holder/spell/self/storage_spell
	name = "储物术"
	desc = "将当前手中的一件物品存入魔法空间，再次施法取出。最多保存一件，不限体积；不能存入背包等物品容器，但可以存入药瓶、水袋等液体容器。取出时若双手已满，物品会落在脚下。"
	school = "conjuration"
	spell_tier = 1
	cost = STORAGE_MANA_COST
	releasedrain = STORAGE_RESOURCE_COST
	chargedrain = 0
	chargetime = STORAGE_CHANNEL_TIME
	recharge_time = STORAGE_COOLDOWN
	cooldown_min = STORAGE_COOLDOWN
	charge_type = "recharge"
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "storage"
	invocations = list("为我开辟一方储物之境！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE
	miracle = FALSE
	xp_gain = TRUE
	sound = null

	var/obj/effect/z121_spell_storage/storage_space
	var/obj/item/stored_item
	var/datum/weakref/last_caster
	var/turf/last_storage_turf
	// 在引导期间锁定操作，防止重复点击或换物后存入另一个目标。
	var/storage_busy = FALSE
	var/retrieving_item = FALSE
	var/obj/item/pending_item
	var/mob/pending_user

/obj/effect/proc_holder/spell/self/storage_spell/Destroy()
	var/turf/destination = get_turf(action?.owner)
	if(!destination)
		destination = get_turf(last_caster?.resolve())
	if(!destination)
		destination = last_storage_turf
	if(!QDELETED(storage_space))
		// 先释放实际留在空间内的物品，绝不召回已被外部移动的物品。
		for(var/obj/item/item in storage_space.contents.Copy())
			item.forceMove(destination)
		QDEL_NULL(storage_space)
	stored_item = null
	pending_item = null
	pending_user = null
	last_caster = null
	last_storage_turf = null
	return ..()

/obj/effect/proc_holder/spell/self/storage_spell/Click()
	if(storage_busy)
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/self/storage_spell/proc/current_stored_item()
	if(QDELETED(stored_item) || QDELETED(storage_space) || stored_item.loc != storage_space)
		stored_item = null
	return stored_item

/obj/effect/proc_holder/spell/self/storage_spell/proc/storage_rejection(obj/item/item, mob/user)
	if(QDELETED(item))
		return "当前手中没有可以存入的物品。"
	if(item.loc != user || user.get_active_held_item() != item)
		return "只能存入当前手中拿着的那件物品。"
	if(item.item_flags & (ABSTRACT | DROPDEL))
		return "这件物品无法存入储物之境。"
	if(istype(item, /obj/item/storage) || item.GetComponent(/datum/component/storage) || istype(item, /obj/item/void_cube))
		return "储物术不能存入物品容器，只能存入普通物品或液体容器。"
	if(!user.canUnEquip(item, FALSE))
		return "这件物品无法脱手。"
	return null

/obj/effect/proc_holder/spell/self/storage_spell/proc/clear_storage_cast()
	pending_item = null
	pending_user = null
	retrieving_item = FALSE
	storage_busy = FALSE

/obj/effect/proc_holder/spell/self/storage_spell/choose_targets(mob/user = usr)
	if(storage_busy)
		return
	if(QDELETED(user))
		revert_cast(user)
		return

	var/obj/item/item = current_stored_item()
	var/retrieving = !!item
	if(!retrieving)
		item = user.get_active_held_item()
		var/reason = storage_rejection(item, user)
		if(reason)
			to_chat(user, span_warning(reason))
			revert_cast(user)
			return

	storage_busy = TRUE
	retrieving_item = retrieving
	pending_item = item
	pending_user = user
	last_caster = WEAKREF(user)
	var/turf/caster_turf = get_turf(user)
	if(caster_turf)
		last_storage_turf = caster_turf

	invocation(user)
	var/cast_time = get_chargetime()
	if(cast_time > 0)
		user.visible_message(
			span_warning("[user] 屈指轻引，周身魔力如细线般缠绕、编织……"),
			span_notice("我开始以魔力开启储物之境，只需一瞬……")
		)
		var/completed = do_after(user, cast_time, target = user, progress = TRUE)
		if(QDELETED(src))
			return
		if(!completed)
			to_chat(user, span_warning("魔力的丝线散开了，物品未能存取。"))
			revert_cast(user)
			clear_storage_cast()
			return

	// 咒文已在引导开始时念出；继续使用 perform 结算消耗、冷却和奥术联动。
	var/list/original_invocations = invocations
	var/original_invocation_type = invocation_type
	invocations = null
	invocation_type = "none"
	if(!perform(null, user = user) && !QDELETED(src))
		revert_cast(user)
	if(QDELETED(src))
		return
	invocations = original_invocations
	invocation_type = original_invocation_type
	clear_storage_cast()

/obj/effect/proc_holder/spell/self/storage_spell/cast(list/targets, mob/living/user = usr)
	if(QDELETED(user) || !storage_busy || pending_user != user || user.incapacitated())
		revert_cast(user)
		return FALSE
	var/turf/caster_turf = get_turf(user)
	if(!caster_turf)
		to_chat(user, span_warning("这里无法稳定地开启储物之境。"))
		revert_cast(user)
		return FALSE
	last_caster = WEAKREF(user)
	last_storage_turf = caster_turf

	var/obj/item/item = pending_item
	var/obj/item/current_item = current_stored_item()
	if(retrieving_item)
		if(QDELETED(item) || current_item != item)
			to_chat(user, span_warning("原先存放的物品已经不在储物之境中。"))
			revert_cast(user)
			return FALSE
		stored_item = null
		if(user.put_in_hands(item))
			to_chat(user, span_green("我从储物之境中取出了[item]。"))
		else
			to_chat(user, span_notice("我的双手已满或无法接住物品，[item]从储物之境落在脚下。"))
	else
		if(current_item || (!QDELETED(storage_space) && length(storage_space.contents)))
			to_chat(user, span_warning("储物之境已经有物品，无法再存入第二件。"))
			revert_cast(user)
			return FALSE
		var/reason = storage_rejection(item, user)
		if(reason)
			to_chat(user, span_warning(reason))
			revert_cast(user)
			return FALSE
		if(QDELETED(storage_space))
			storage_space = new(null)
		if(!user.transferItemToLoc(item, storage_space) || QDELETED(item) || item.loc != storage_space)
			to_chat(user, span_warning("这件物品未能存入储物之境。"))
			revert_cast(user)
			return FALSE
		stored_item = item
		to_chat(user, span_green("我将[item]存入了储物之境，再次施法即可取出。"))

	..()
	playsound(caster_turf, 'sound/foley/equip/rummaging-01.ogg', 50, TRUE)
	user.visible_message(span_notice("[user] 指间魔力翻涌，一道幽微的储物之隙随即合拢。"))
	return TRUE

#undef STORAGE_MANA_COST
#undef STORAGE_RESOURCE_COST
#undef STORAGE_CHANNEL_TIME
#undef STORAGE_COOLDOWN
