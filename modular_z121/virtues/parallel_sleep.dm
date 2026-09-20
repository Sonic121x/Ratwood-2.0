// 睡眠修改保留引擎原逻辑，只把查询限定为普通睡眠来源。

/mob/living/carbon/human/Sleeping(amount, updating = TRUE, ignore_canstun = FALSE)
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = has_status_effect(STATUS_EFFECT_SLEEPING)
		if(S)
			S.duration = max(world.time + amount, S.duration)
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
		return S

/mob/living/carbon/human/SetSleeping(amount, updating = TRUE, ignore_canstun = FALSE)
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = has_status_effect(STATUS_EFFECT_SLEEPING)
		if(amount <= 0)
			if(S)
				qdel(S)
		else if(S)
			S.duration = world.time + amount
		else
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
		return S

/mob/living/carbon/human/AdjustSleeping(amount, updating = TRUE, ignore_canstun = FALSE)
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = has_status_effect(STATUS_EFFECT_SLEEPING)
		if(S)
			S.duration += amount
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
		return S
