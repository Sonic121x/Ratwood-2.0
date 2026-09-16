/datum/intent/spell
	name = "法术"
	tranged = 1
	chargedrain = 0
	chargetime = 0
	warnie = "aimwarn"
	warnoffset = 0

/datum/intent/spell/can_charge()
	var/obj/effect/proc_holder/spell/spell_ability = mastermob.ranged_ability
	if(istype(spell_ability) && !spell_ability.charge_check(mastermob, TRUE))
		to_chat(mastermob, span_warning("这个法术还需要时间充能！"))
		return FALSE
	return TRUE

/datum/intent/spell/on_mmb(atom/target, mob/living/user, params)
	if(!user.ranged_ability?.InterceptClickOn(user, params, target)) // Returns true on success, returns FALSE on fail to cast
		user.stop_attack()
		return
	user.changeNext_move(clickcd)
