// 每项属性使用独立状态，移除时只撤销本项加成。
/datum/status_effect/z121_ethos
	duration = -1
	tick_interval = -1
	needs_processing = FALSE
	alert_type = null

/datum/status_effect/z121_ethos/lust
	id = "z121_ethos_lust"
	effectedstats = list(STATKEY_PER = -1)

/datum/status_effect/z121_ethos/wrath
	id = "z121_ethos_wrath"
	effectedstats = list(STATKEY_PER = -1)

/datum/status_effect/z121_ethos/sloth
	id = "z121_ethos_sloth"
	effectedstats = list(STATKEY_SPD = -1)

/datum/status_effect/z121_ethos/humility
	id = "z121_ethos_humility"
	effectedstats = list(STATKEY_INT = 1)

/datum/status_effect/z121_ethos/chastity
	id = "z121_ethos_chastity"
	effectedstats = list(STATKEY_WIL = 1)

/datum/stressevent/z121_ethos
	timer = INFINITY
	max_stacks = 1

/datum/stressevent/z121_ethos/pride
	stressadd = 3
	desc = "倒地的狼狈令我难以忍受。"

/datum/stressevent/z121_ethos/greed
	stressadd = 3
	desc = "钱囊太轻，我无法安心。"

/datum/stressevent/z121_ethos/envy
	timer = 3 MINUTES
	stressadd = 3
	desc = "他人的光芒刺痛了我。"

/datum/stressevent/z121_ethos/gluttony
	stressadd = 3
	desc = "我还没有吃够。"

/datum/stressevent/z121_ethos/charity
	timer = 3 MINUTES
	stressadd = -2
	desc = "分享使人充实。"

/datum/stressevent/z121_ethos/kindness
	timer = 3 MINUTES
	stressadd = -2
	desc = "我照料了他人。"

/datum/stressevent/z121_ethos/temperance
	stressadd = -2
	desc = "适量即可，我很满足。"

/datum/stressevent/z121_ethos/patience
	stressadd = -2
	desc = "我躺下休息，让心绪慢慢平静。"

