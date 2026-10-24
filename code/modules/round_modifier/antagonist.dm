/datum/round_modifier/low_bandits
	name = "少量自由民"
	desc = "一些自由民来了。"
	cost = 1
	min_chaos = 1
	job_slots = list("Bandit" = 4)

/datum/round_modifier/medium_bandits
	name = "中量自由民"
	desc = "自由民来了。"
	cost = 2
	weight = 30
	min_chaos = 2
	incompatible = list(/datum/round_modifier/low_bandits)
	job_slots = list("Bandit" = 7)

/datum/round_modifier/low_gnolls
	name = "少量豺狼人"
	desc = "一群血兽中的残兵败将。"
	cost = 1
	weight = 20
	job_slots = list("Gnoll" = 2)

/datum/round_modifier/medium_gnolls
	name = "中量豺狼人"
	desc = "一群血兽。"
	cost = 2
	min_chaos = 1
	incompatible = list(/datum/round_modifier/low_gnolls)
	job_slots = list("Gnoll" = 4)

/datum/round_modifier/high_gnolls
	name = "大量豺狼人"
	desc = "血兽蜂拥而至！血腥之星狂笑着！"
	cost = 4
	min_chaos = 2
	incompatible = list(/datum/round_modifier/low_gnolls, /datum/round_modifier/medium_gnolls)
	job_slots = list("Gnoll" = 6)

/datum/round_modifier/high_wretches
	name = "大量弃民"
	desc = "异端如瘟疫般在人心中蔓延！"
	cost = 4
	min_chaos = 3
	job_slots = list("Wretch" = 5)

/datum/round_modifier/high_bandits
	name = "大量自由民"
	desc = "自由民大举来袭。"
	cost = 4
	weight = 15
	min_chaos = 3
	incompatible = list(/datum/round_modifier/medium_bandits, /datum/round_modifier/low_bandits)
	job_slots = list("Bandit" = 10)

/*
/datum/round_modifier/werewolf
	name = "维尔沃夫"
	desc = "Men don the skin of wolves in darkling night."
	cost = 6
	weight = 5
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/werewolf)
*/

/datum/round_modifier/vampire
	name = "吸血鬼"
	desc = "阿斯特拉塔受诅咒的子嗣正在荼毒大地！"
	cost = 4
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/masquerade)

/datum/round_modifier/vampirelord
	name = "吸血鬼领主"
	desc = "致敬！致敬！跪倒在那混账暴君面前！"
	cost = 8
	weight = 5
	min_chaos = 3
	villain_events = list(/datum/round_event_control/antagonist/solo/vampires)

/datum/round_modifier/assassin
	name = "刺客"
	desc = "当心！黑暗中藏着利刃！"
	cost = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/assassins)

/datum/round_modifier/rebel
	name = "起义"
	desc = "卑贱之人竟妄图自治！"
	cost = 2
	min_chaos = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/rebel)

/datum/round_modifier/dreamwalker
	name = "梦行者"
	desc = "阿比索尔在沉眠中躁动。"
	cost = 2
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/dreamwalker)

/*
/datum/round_modifier/lich
	name = "巫妖"
	desc = "死者步调一致地向前进军！"
	cost = 6
	weight = 6
	min_chaos = 3
	villain_events = list(/datum/round_event_control/antagonist/solo/lich)
*/
