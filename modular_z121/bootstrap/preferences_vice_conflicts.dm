// 在模块内覆写创角冲突检查，直接读取实际字段，避免内部字段名被汉化后查找失败。
/datum/preferences/check_pick_vice_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	if(!pick || !length(pick.incompatible_vices))
		return FALSE
	for(var/datum/charflaw/vice in list(vice1, vice2, vice3, vice4, vice5, vice6))
		if(vice && (vice.type in pick.incompatible_vices))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name]与恶习[vice.name]冲突！"))
			return TRUE
	return FALSE
