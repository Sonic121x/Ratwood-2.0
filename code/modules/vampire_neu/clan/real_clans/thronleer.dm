
/datum/clan_leader/thronleer
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform
	)
	lord_title = "Elder"

/datum/clan/thronleer
	name = "索隆里尔家族"
	desc = "索隆里尔家族隐秘而恪守传统，偏爱仪式、隐微手段与诡计。"
	curse = "灵魂虚弱。"
	clanicon = "bloodheal"
	blood_preference = BLOOD_PREFERENCE_FANCY
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/demonic,
	)
	leader = /datum/clan_leader/thronleer
	covens_to_select = 0

/datum/clan/thronleer/get_blood_preference_string()
	return "经调制的血液"

/datum/clan/thronleer/get_downside_string()
	return "在战斗中较为虚弱"

/datum/clan/thronleer/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)

/datum/clan/thronleer/get_frenzy_messages()
	return list(
		"我虚弱的灵魂崩裂了，[span_danger("兽性")]从每道裂隙中涌出。",
		"仪式与克制[span_danger("离我而去")]，只剩赤裸的渴望。",
		"家族珍视的从容如[span_danger("流水")]般从我指间滑落。",
		"某种卑劣而饥饿的东西如今[span_userdanger("披上了我的面孔")]。",
		"传统无法约束它——这份[span_danger("饥饿")]比任何家族都更加古老。",
	)
