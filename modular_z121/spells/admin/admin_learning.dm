// 管理员法术独立登记，不并入公共法术池，避免被普通学习或随机授法机制选中。
GLOBAL_LIST_INIT(z121_admin_learnable_spells, list(
	/obj/effect/proc_holder/spell/invoked/heal_pristine/greater,
	/obj/effect/proc_holder/spell/invoked/adminkill,
	/obj/effect/proc_holder/spell/invoked/adminheal,
	/obj/effect/proc_holder/spell/invoked/blink/adminblink,
	/obj/effect/proc_holder/spell/invoked/mimicry/copy,
))

// 在模块内覆盖学习入口，保留公共法术的资格、排序和退款规则。
/obj/effect/proc_holder/spell/self/learnspell/cast(list/targets, mob/user = usr)
	if(!user?.mind)
		return FALSE
	// 同类型覆盖不能调用上一个学习实现，否则会连续弹出两次菜单；保留基础施法通知和统计。
	SEND_SIGNAL(user, COMSIG_MOB_CAST_SPELL)
	record_featured_object_stat(FEATURED_STATS_SPELLS, name)
	var/datum/mind/learner = user.mind
	var/user_spell_tier = get_user_spell_tier(user)
	var/user_evil = get_user_evilness(user)
	var/is_admin = check_rights_for(user.client, R_ADMIN)
	var/list/spell_choices = GLOB.learnable_spells.Copy()
	if(is_admin)
		spell_choices |= GLOB.z121_admin_learnable_spells

	var/list/known_spell_types = list()
	for(var/obj/effect/proc_holder/spell/knownspell in learner.spell_list)
		known_spell_types[knownspell.type] = TRUE

	var/list/learnable = list()
	for(var/spell_path in spell_choices)
		var/obj/effect/proc_holder/spell/spell_item = spell_path
		if(spell_path in GLOB.z121_admin_learnable_spells)
			if(!is_admin)
				continue
		else
			if(spell_item.spell_tier > user_spell_tier || spell_item.zizo_spell > user_evil)
				continue
		if(known_spell_types[spell_path])
			continue
		learnable += spell_path

	sortTim(learnable, GLOBAL_PROC_REF(cmp_spell_cost_asc))
	var/list/choices = list()
	for(var/spell_path in learnable)
		var/obj/effect/proc_holder/spell/spell_item = spell_path
		choices["[spell_item.name]: [spell_item.cost]"] = spell_path

	var/choice = input(user, "选择一个法术，剩余点数：[learner.spell_points - learner.used_spell_points]") as null|anything in choices
	var/obj/effect/proc_holder/spell/item = choices[choice]
	if(!item)
		return
	if(alert(user, "[item.desc]", "[item.name]", "学习", "取消") != "学习")
		return

	// 输入窗口会等待玩家操作，扣点前重新核对身份、权限和已学列表。
	if(QDELETED(user) || QDELETED(learner) || user.mind != learner)
		return FALSE
	if((item in GLOB.z121_admin_learnable_spells) && !check_rights_for(user.client, R_ADMIN))
		to_chat(user, span_warning("只有管理员可以学习这道法术。"))
		return FALSE
	for(var/obj/effect/proc_holder/spell/knownspell in learner.spell_list)
		if(knownspell.type == item)
			to_chat(user, span_warning("你已经学会这个了！"))
			return FALSE
	if(item.cost > learner.spell_points - learner.used_spell_points)
		to_chat(user, span_warning("你的经验不足，无法创造新的法术。"))
		return FALSE

	learner.used_spell_points += item.cost
	var/obj/effect/proc_holder/spell/new_spell = new item
	new_spell.refundable = TRUE
	learner.AddSpell(new_spell)
	addtimer(CALLBACK(learner, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
	return TRUE
