// 自定义动作使用上游的蓄力、资源与冷却流程，效果实现留在各自文件中。
/datum/action/cooldown/spell/z121
	var/miracle = FALSE
	var/xp_gain = FALSE
	var/gesture_required = FALSE
	var/cooldown_min = 0
	var/is_cdr_exempt = FALSE
	var/z121_effect_failed = FALSE
	var/z121_casting = FALSE
	var/z121_selecting = FALSE

/datum/action/cooldown/spell/z121/self
	click_to_activate = FALSE
	charge_required = FALSE

/datum/action/cooldown/spell/z121/invoked
	click_to_activate = TRUE

/datum/action/cooldown/spell/z121/invoked/projectile
	parent_type = /datum/action/cooldown/spell/projectile

/datum/action/cooldown/spell/z121/targeted/conjure_item
	parent_type = /datum/action/cooldown/spell/z121/self
	var/item_type

/datum/action/cooldown/spell/z121/targeted/conjure_item/proc/make_item()
	return new item_type

/datum/action/cooldown/spell/z121/Activate(atom/target)
	if(z121_casting)
		return FALSE
	z121_casting = TRUE
	z121_effect_failed = FALSE
	. = ..()
	if(!QDELETED(src))
		z121_casting = FALSE

/datum/action/cooldown/spell/z121/can_cast_spell(feedback = TRUE)
	if(!..())
		return FALSE
	if(gesture_required && ishuman(owner))
		var/mob/living/carbon/human/caster = owner
		if(caster.handcuffed || !caster.has_active_hand())
			return FALSE
	return TRUE

/datum/action/cooldown/spell/z121/get_adjusted_cooldown()
	if(is_cdr_exempt)
		return cooldown_time
	return max(cooldown_min, ..())

/datum/action/cooldown/spell/z121/proc/z121_ready(mob/user, silent = FALSE)
	return user == owner && world.time >= next_use_time

/datum/action/cooldown/spell/z121/proc/z121_check(skipcharge, mob/user)
	return user == owner && IsAvailable(TRUE) && z121_ready(user)

/datum/action/cooldown/spell/z121/proc/z121_cancel(mob/user)
	z121_effect_failed = TRUE
	return FALSE

/datum/action/cooldown/spell/z121/proc/z121_choose_targets(mob/user)
	if(user != owner)
		return FALSE
	return PreActivate(user)

/datum/action/cooldown/spell/z121/proc/z121_cast_selected(list/targets, recharge = TRUE, mob/user)
	if(!z121_check(TRUE, user))
		return FALSE
	return Activate(length(targets) ? targets[1] : owner)

/datum/action/cooldown/spell/z121/proc/z121_deactivate(mob/user)
	unset_click_ability(user)

/datum/action/cooldown/spell/z121/proc/z121_update_icon()
	build_all_button_icons()

/datum/action/cooldown/spell/z121/cast(atom/cast_on)
	..()
	. = z121_apply(cast_on)
	return !z121_effect_failed && (isnull(.) || . != FALSE)

/datum/action/cooldown/spell/z121/proc/z121_apply(atom/cast_on)
	return TRUE

/datum/action/cooldown/spell/z121/proc/get_charge_time(mob/user)
	return charge_time

/datum/action/cooldown/spell/z121/self/Trigger(trigger_flags)
	if(!owner || z121_casting || z121_selecting || !z121_check(TRUE, owner))
		return FALSE
	z121_selecting = TRUE
	. = z121_choose_targets(owner)
	if(!QDELETED(src))
		z121_selecting = FALSE

// 所有直接调用动作的入口仍须复核持有者与资源；失败时尚未扣费。
/datum/action/cooldown/spell/z121/before_cast(atom/cast_on)
	if(!owner || !IsAvailable(TRUE) || !z121_ready(owner))
		return SPELL_CANCEL_CAST
	return ..()

// 零蓄力法术不注册鼠标蓄力处理，也不触发上游的缺失蓄力时间诊断。
/datum/action/cooldown/spell/z121/New(Target)
	if(charge_time <= 0)
		charge_required = FALSE
	return ..()
