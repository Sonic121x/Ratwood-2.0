// 管理员法术独立登记，不并入公共法术池，避免被普通学习或随机授法机制选中。
GLOBAL_LIST_INIT(z121_admin_learnable_spells, list(
	/obj/effect/proc_holder/spell/invoked/heal_pristine/greater,
	/obj/effect/proc_holder/spell/invoked/adminkill,
	/obj/effect/proc_holder/spell/invoked/adminheal,
	/obj/effect/proc_holder/spell/invoked/blink/adminblink,
	/obj/effect/proc_holder/spell/invoked/mimicry/copy,
))

// 沿用上游施法入口和界面，仅在模块内适配法术数据与学习请求。
// 同类型覆盖中的 ..() 会先执行上一份实现，学习请求必须只在本入口处理一次。
/obj/effect/proc_holder/spell/self/learnspell/ui_data(mob/user)
	var/list/data = list("user_points" = 0, "spells" = list())
	if(QDELETED(user) || QDELETED(user.mind))
		return data

	var/datum/mind/learner = user.mind
	var/points_avail = max(0, learner.spell_points - learner.used_spell_points)
	data["user_points"] = points_avail

	var/user_spell_tier = get_user_spell_tier(user)
	var/user_evil = get_user_evilness(user)
	var/is_admin = check_rights_for(user.client, R_ADMIN)
	var/list/known_spells = list()
	for(var/obj/effect/proc_holder/spell/known in learner.spell_list)
		known_spells[known.type] = TRUE

	// 普通自定义法术已在启动时加入公共池；此处只复制列表，不修改共享法术池。
	var/list/spell_choices = GLOB.learnable_spells.Copy()
	if(is_admin)
		spell_choices |= GLOB.z121_admin_learnable_spells
	var/list/seen_spells = list()
	var/list/spells_data = list()

	for(var/spell_path in spell_choices)
		if(!ispath(spell_path, /obj/effect/proc_holder/spell) || seen_spells[spell_path])
			continue
		seen_spells[spell_path] = TRUE
		var/is_admin_spell = (spell_path in GLOB.z121_admin_learnable_spells)
		// 专属限制优先，即使未来误将管理员法术登记到公共池，也不向普通玩家展示。
		if(is_admin_spell && !is_admin)
			continue

		var/obj/effect/proc_holder/spell/S = spell_path
		var/spell_tier = initial(S.spell_tier)
		var/zizo_req = initial(S.zizo_spell)
		var/cost = initial(S.cost)
		var/is_known = !isnull(known_spells[spell_path])
		var/tier_locked = !is_admin_spell && (spell_tier > user_spell_tier)
		var/evil_locked = !is_admin_spell && (zizo_req > user_evil)
		var/can_afford = (!is_known && !tier_locked && !evil_locked && (points_avail >= cost))
		var/img64 = spell_icon_cache[spell_path]
		if(!img64)
			var/icon_file = initial(S.action_icon) || 'icons/mob/actions/roguespells.dmi'
			var/icon_state_str = initial(S.overlay_state) || initial(S.action_icon_state)
			var/list/valid_states = icon_states(icon_file)

			var/icon/final_icon = null
			if(icon_state_str && (icon_state_str in valid_states))
				final_icon = icon(icon_file, icon_state_str, SOUTH, 1)
			else
				final_icon = icon('icons/mob/actions/roguespells.dmi', "spell", SOUTH, 1)

			if(final_icon)
				try
					var/generated = icon2base64(final_icon)
					img64 = generated ? generated : "blank"
				catch
					img64 = "blank"
			else
				img64 = "blank"

			spell_icon_cache[spell_path] = img64

		spells_data += list(list(
			"name" = initial(S.name) || "Unknown Spell",
			"desc" = initial(S.desc) || "",
			"cost" = cost,
			"tier" = spell_tier,
			"path" = "[spell_path]",
			"school" = initial(S.school) || "generic",
			"range" = initial(S.range),
			"charge_time" = initial(S.chargetime) / 10,
			"cooldown" = initial(S.recharge_time) / 10,
			"fatigue" = initial(S.releasedrain),
			"img64" = img64,
			"is_known" = is_known,
			"can_afford" = can_afford,
			"tier_locked" = tier_locked,
			"evil_locked" = evil_locked
		))

	data["spells"] = spells_data
	return data

/obj/effect/proc_holder/spell/self/learnspell/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	// 保留基础界面的交互检查与信号，不调用会提前完成购买的上一份学习实现。
	SHOULD_CALL_PARENT(FALSE)
	SEND_SIGNAL(src, COMSIG_UI_ACT, usr, action, params)
	if(!ui || ui.status != UI_INTERACTIVE || ui.user != usr)
		return TRUE

	var/mob/living/user = usr
	if(!istype(user) || QDELETED(user) || QDELETED(user.mind))
		return TRUE
	if(action != "learn")
		return TRUE

	var/path_text = params["path"]
	if(!istext(path_text))
		return TRUE
	var/spell_path = text2path(path_text)
	if(!ispath(spell_path, /obj/effect/proc_holder/spell))
		return TRUE

	// 每次请求均重新检查权限，不能依赖打开界面时的权限或前端按钮状态。
	var/is_admin_spell = (spell_path in GLOB.z121_admin_learnable_spells)
	if(is_admin_spell)
		if(!check_rights_for(user.client, R_ADMIN))
			to_chat(user, span_warning("只有管理员可以学习这道法术。"))
			return TRUE
	else if(!(spell_path in GLOB.learnable_spells))
		return TRUE

	var/datum/mind/learner = user.mind
	for(var/obj/effect/proc_holder/spell/known in learner.spell_list)
		if(known.type == spell_path)
			to_chat(user, span_warning("You already know this spell!"))
			return TRUE

	var/obj/effect/proc_holder/spell/S = spell_path
	var/cost = initial(S.cost)
	// 管理员只对专属法术豁免等级与邪恶条件，普通法术仍遵守原有规则。
	if(!is_admin_spell)
		if(initial(S.spell_tier) > get_user_spell_tier(user))
			to_chat(user, span_warning("This spell requires a higher tier of arcane power!"))
			return TRUE
		if(initial(S.zizo_spell) > get_user_evilness(user))
			to_chat(user, span_warning("You lack the forbidden knowledge for this spell."))
			return TRUE

	var/points_avail = learner.spell_points - learner.used_spell_points
	if(cost > points_avail)
		to_chat(user, span_warning("You do not have enough weave points!"))
		return TRUE

	learner.used_spell_points += cost
	var/obj/effect/proc_holder/spell/new_spell = new spell_path()
	new_spell.refundable = TRUE
	learner.AddSpell(new_spell)
	// 记录本次职业资金消费；不改变原有学习权限与界面。
	z121_parallel_purchase(user, new_spell, cost)
	to_chat(user, span_notice("You have woven <b>[initial(S.name)]</b> into your mind!"))
	// 保留上游在点数耗尽时移除学习法术的定时处理。
	addtimer(CALLBACK(learner, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
	return TRUE
