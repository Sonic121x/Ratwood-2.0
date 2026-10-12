// 扩展现有检查链，同时覆盖正反两个选择顺序与旧版恶习。
/datum/preferences/check_vice_pick_conflict(vice_type, show_message = FALSE, mob/user = null)
	var/reason
	if(vice_type == /datum/charflaw/z121_sin/lust && !sexable)
		reason = "难餍之心需要开启成人功能。"
	if(vice_type == /datum/charflaw/z121_sin/lust && !(age in list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)))
		reason = "只有成年角色可以选择难餍之心。"
	if(vice_type == /datum/charflaw/z121_sin/gluttony && (TRAIT_NOHUNGER in pref_species.inherent_traits))
		reason = "无需进食的种族不能选择腹中空洞。"
	if(reason)
		if(show_message && user)
			to_chat(user, span_warning(reason))
		return TRUE
	return ..()

/datum/preferences/check_vice_vice_conflict(vice_type, list/selected_vices, show_message = FALSE, mob/user = null)
	var/list/pairs = list(
		list(/datum/charflaw/z121_sin/greed, /datum/charflaw/greedy),
		list(/datum/charflaw/z121_sin/lust, /datum/charflaw/addiction/lovefiend))
	for(var/list/pair in pairs)
		if((vice_type == pair[1] && (pair[2] in selected_vices)) || (vice_type == pair[2] && (pair[1] in selected_vices)))
			if(show_message && user)
				to_chat(user, span_warning("这两个恶习的需求重复，不能同时选择。"))
			return TRUE
	return ..()

// 菜单反向冲突检查使用实际的恶习槽位键，避免旧键漏掉已经选择的七罪。
/datum/preferences/check_pick_vice_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	for(var/i = 1 to 6)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice && (vice.type in pick?.incompatible_vices))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name]与恶习[vice.name]冲突！"))
			return TRUE
	return ..()

// 改变年龄或种族后，出生前再次校验，不能领取不生效恶习的特质点。
/datum/preferences/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, character_setup = FALSE, antagonist = FALSE, skip_normal_prefs = FALSE)
	for(var/i = 1 to 6)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(istype(vice, /datum/charflaw/z121_sin) && check_vice_pick_conflict(vice.type))
			vars["vice[i]"] = null
			to_chat(usr, span_warning("[vice.name]不符合当前角色条件，已从恶习选择中移除。"))
	if(istype(charflaw, /datum/charflaw/z121_sin) && check_vice_pick_conflict(charflaw.type))
		charflaw = null
	return ..()

