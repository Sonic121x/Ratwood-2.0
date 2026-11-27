/// Bounty labels may be translated without changing the upstream switch values.
/proc/input_wretch_bounty_severity(mob/user)
	var/list/options = list(
		"轻罪" = "Misdeed",
		"伤人害命（+1 [get_stat_display_name(STATKEY_LCK)]）" = "Harm towards lyfe (+1 FOR)",
		"骇人暴行（全属性+1）" = "Horrific atrocities (+1 ALL STATS)"
	)
	var/choice = input(user, "你的罪行有多严重？", "悬赏金额") as anything in options
	return options[choice]

/proc/get_ancestral_blood_display(value)
	var/static/list/names = list("Rontz" = "隆兹石", "Saffira" = "蓝晶", "Gemerald" = "翠晶", "Toper" = "托珀石", "Amythortz" = "阿米索兹石")
	return names[value] || value

/proc/input_weapon_vow_display(mob/user, list/values)
	var/static/list/names = list("I still use weapons" = "我仍使用武器", "I forgo weapons" = "我放弃使用武器")
	var/list/options = list()
	for(var/value in values)
		options[names[value] || value] = value
	var/choice = input(user, "你是否已经放弃使用武器？", "你的决心有多坚定？") as anything in options
	return options[choice]

/proc/get_special_role_display(role)
	var/datum/antagonist/antag = GLOB.special_roles_rogue[role]
	return ispath(antag, /datum/antagonist) ? initial(antag.name) : role
