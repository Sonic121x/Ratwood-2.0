// 管理员专属法术只在权限检查通过后向该管理员展示。
GLOBAL_LIST_INIT(z121_admin_learnable_spells, list(
	/datum/action/cooldown/spell/z121/invoked/heal_pristine/greater,
	/datum/action/cooldown/spell/z121/invoked/adminkill,
	/datum/action/cooldown/spell/z121/invoked/adminheal,
	/datum/action/cooldown/spell/blink/z121_admin,
	/datum/action/cooldown/spell/z121/invoked/mimicry/copy,
))

/proc/z121_custom_spell_tier(datum/mind/learner)
	var/list/config = learner?.mage_aspect_config
	if(config?["mastery"])
		return 4
	if(config?["major"] > 0)
		return 3
	if(config?["minor"] > 0 || config?["z121_arcane_archer"])
		return 2
	return config?["utilities"] > 0 ? 1 : 0

/proc/z121_can_learn_custom(mob/user, spell_path)
	if(spell_path in GLOB.z121_admin_learnable_spells)
		return user?.client && check_rights_for(user.client, R_ADMIN)
	if(!(spell_path in GLOB.custom_learnable_spells))
		return TRUE
	var/datum/action/cooldown/spell/S = spell_path
	return user?.mind && initial(S.spell_tier) <= z121_custom_spell_tier(user.mind) && initial(S.zizo_spell) <= get_user_evilness(user)

/datum/aspect_picker/build_utility_list()
	. = ..()
	if(owner?.client && check_rights_for(owner.client, R_ADMIN))
		for(var/path in GLOB.z121_admin_learnable_spells)
			. += list(build_spell_entry(path))
	var/list/entries = .
	for(var/list/entry as anything in entries.Copy())
		if(!z121_can_learn_custom(owner, text2path(entry["path"])))
			. -= list(entry)

/datum/aspect_picker/ui_act(action, list/params)
	if(!z121_valid_learner())
		return TRUE
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.is_void_clone())
			to_chat(H, span_warning("虚空分身无法学习或调整法术。"))
			return TRUE
	// 自定义法术只能消耗实用额度，不能伪装成法相选项绕过限制。
	if(action == "pointbuy_toggle" || action == "choice_toggle")
		var/path = text2path(params["spell_path"])
		if((path in GLOB.custom_learnable_spells) || (path in GLOB.z121_admin_learnable_spells))
			return TRUE
	if(action == "utility_toggle")
		var/path = text2path(params["spell_path"])
		if(!(path in (GLOB.utility_spells | GLOB.z121_admin_learnable_spells)) || !z121_can_learn_custom(owner, path))
			return TRUE
	return ..()

/datum/aspect_picker/perform_confirm(max_majors, max_minors_resolved)
	if(!z121_valid_learner() || z121_learner.z121_confirming_picker)
		return
	if(!owner?.mind)
		return
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.is_void_clone())
			return
	for(var/aspect_text in pointbuy_selections)
		for(var/spell_text in pointbuy_selections[aspect_text])
			var/path = text2path(spell_text)
			if((path in GLOB.custom_learnable_spells) || (path in GLOB.z121_admin_learnable_spells))
				return
	for(var/aspect_text in staged_choices)
		var/path = text2path(staged_choices[aspect_text])
		if((path in GLOB.custom_learnable_spells) || (path in GLOB.z121_admin_learnable_spells))
			return
	for(var/path_text in staged_utilities)
		var/path = text2path(path_text)
		if(!(path in (GLOB.utility_spells | GLOB.z121_admin_learnable_spells)) || !z121_can_learn_custom(owner, path))
			to_chat(owner, span_warning("我的学习资格已改变，请重新选择法术。"))
			return
	z121_learner.z121_confirming_picker = src
	. = ..()
	if(z121_learner?.z121_confirming_picker == src)
		z121_learner.z121_confirming_picker = null


// 学习窗口绑定打开时的心智、职业记录与额度对象，切换后的旧窗口不能继续授法。
/datum/aspect_picker
	var/datum/mind/z121_learner
	var/datum/z121_profession_record/z121_profession
	var/list/z121_config

/datum/aspect_picker/New(mob/living/new_owner, setup = TRUE, list/aspect_config)
	. = ..()
	z121_learner = new_owner?.mind
	z121_config = z121_learner?.mage_aspect_config
	if(ishuman(new_owner))
		var/mob/living/carbon/human/H = new_owner
		z121_profession = H.z121_profession

/datum/aspect_picker/proc/z121_valid_learner()
	if(!owner || owner.mind != z121_learner || z121_learner.current != owner || z121_learner.mage_aspect_config != z121_config)
		return FALSE
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.z121_profession != z121_profession || H.is_void_clone())
			return FALSE
	return TRUE

/datum/mind
	var/datum/aspect_picker/z121_confirming_picker

/datum/mind/AddSpell(datum/spell_or_action, mob/living/user)
	if(istype(spell_or_action, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_or_action
		if(z121_confirming_picker && !(S in spell_list))
			if(!z121_confirming_picker.z121_valid_learner() || !z121_can_learn_custom(current, S.type))
				qdel(S)
				return
	return ..()

// 专属法术不进入公共池，但管理员实际学习后仍占用实用额度。
/datum/mind/get_utility_points_spent(list/exclude_path_strs)
	. = ..()
	for(var/path in GLOB.z121_admin_learnable_spells)
		if((path in GLOB.utility_spells) || ("[path]" in exclude_path_strs))
			continue
		if(is_utility_learned(path))
			. += get_spell_point_cost(path)

/datum/aspect_picker/ui_data(mob/user)
	. = ..()
	if(!islist(.) || !owner?.mind)
		return
	var/list/data = .
	for(var/path in GLOB.z121_admin_learnable_spells)
		if(!owner.mind.has_spell(path))
			continue
		data["known_utilities"] |= "[path]"
		if(!owner.mind.is_utility_learned(path))
			data["given_utilities"] |= "[path]"
