// 角色冷却倍率属于当前身体；默认值不改变原有法术冷却。
/mob/living
	var/z121_spell_cooldown_multiplier = 1

/mob/living/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, z121_spell_cooldown_multiplier))
		if(!isnum(var_value) || var_value < 0)
			return FALSE
	return ..()

/obj/effect/proc_holder/spell
	// 保存缩放前的输入，防止重复启动时把本轮倍率再次乘入。
	var/z121_cooldown_input
	var/z121_cooldown_output
	var/z121_cooldown_unscaled
	var/z121_cooldown_round_multiplier = 1
	var/z121_cooldown_pending = FALSE
	var/z121_cooldown_running = FALSE

// 次数制、免减免法术及独立冷却法术不参与管理员倍率计算。
/obj/effect/proc_holder/spell/proc/z121_custom_cooldown_allowed()
	if(charge_type != "recharge" || is_cdr_exempt)
		return FALSE
	if(istype(src, /obj/effect/proc_holder/spell/self/wish_spell) || istype(src, /obj/effect/proc_holder/spell/invoked/resurrect) || istype(src, /obj/effect/proc_holder/spell/invoked/revive) || istype(src, /obj/effect/proc_holder/spell/invoked/evil_resurrect) || istype(src, /obj/effect/proc_holder/spell/invoked/bless_food))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/proc/z121_user_cooldown_multiplier(mob/living/user)
	if(!istype(user) || !isnum(user.z121_spell_cooldown_multiplier) || user.z121_spell_cooldown_multiplier < 0)
		return 1
	return user.z121_spell_cooldown_multiplier

// 只有通过施法检查并消耗冷却时，才记录下一轮倍率。
/obj/effect/proc_holder/spell/cast_check(skipcharge, mob/user = usr)
	. = ..()
	if(. && !skipcharge && z121_custom_cooldown_allowed())
		z121_cooldown_round_multiplier = z121_user_cooldown_multiplier(user)
		z121_cooldown_pending = TRUE
		z121_cooldown_running = FALSE

/obj/effect/proc_holder/spell/start_recharge()
	if(!z121_custom_cooldown_allowed())
		return ..()
	// 冷却中的再次选中不能重算剩余时间，也不能更换本轮倍率。
	if(z121_cooldown_running && !z121_cooldown_pending && charge_counter < recharge_time)
		return
	var/mob/living/user = ranged_ability_user || action?.owner
	var/new_round = z121_cooldown_pending
	// 上一轮为零冷却时，成功施法后的零计数仍然代表新一轮。
	var/ready = !new_round && charge_counter >= recharge_time
	var/multiplier = new_round ? z121_cooldown_round_multiplier : z121_user_cooldown_multiplier(user)
	// 默认倍率且没有历史缩放时，完整保留原有启动逻辑。
	if(multiplier == 1 && isnull(z121_cooldown_output))
		. = ..()
		if(new_round)
			z121_cooldown_pending = FALSE
			z121_cooldown_running = TRUE
		return
	// 外部逻辑直接修改冷却值时，以新的数值作为输入。
	if(!isnull(z121_cooldown_output) && recharge_time == z121_cooldown_output)
		recharge_time = z121_cooldown_input
	if(ready)
		charge_counter = recharge_time
	z121_cooldown_input = recharge_time
	. = ..()
	z121_cooldown_unscaled = recharge_time
	recharge_time *= multiplier
	z121_cooldown_output = recharge_time
	if(ready)
		charge_counter = recharge_time
	if(new_round)
		z121_cooldown_pending = FALSE
		z121_cooldown_running = TRUE
		if(recharge_time == 0)
			finish_recharge()

/obj/effect/proc_holder/spell/calculate_cooldown(mob/living/user)
	. = ..()
	if(!z121_custom_cooldown_allowed())
		return
	// 已开始的冷却显示本轮数值；VV 修改只影响下一轮。
	if(z121_cooldown_running && charge_counter < recharge_time)
		return recharge_time
	var/multiplier = z121_user_cooldown_multiplier(user)
	if(multiplier == 1 && isnull(z121_cooldown_output))
		return
	// 与原生启动逻辑一致：神术仍经过实际启动时的智力计算。
	var/base = isnull(z121_cooldown_output) || recharge_time != z121_cooldown_output ? recharge_time : z121_cooldown_input
	if(user)
		if(user.STAINT > 10)
			base = initial(recharge_time) * (1 - (min(user.STAINT, 15) - 10) * 0.05)
		else if(user.STAINT < 10)
			base = initial(recharge_time) * (1 + (10 - user.STAINT) * 0.05)
		if(HAS_TRAIT(user, TRAIT_LEYLINE_HASTE))
			base *= 0.75
	return base * multiplier
