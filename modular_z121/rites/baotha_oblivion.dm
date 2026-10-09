// 祭品只扣除试剂，不调用饮用流程，不额外触发成瘾或药物代谢。
/obj/structure/ritualcircle/sacrifice/baotha
	ritual_title = "巴奥莎的献祭仪式"
	sacrifice_rites = list("忘忧圣宴")
	new_rite_effect = /datum/status_effect/z121_sacrifice_blessing/baotha_feast
	new_rite_requirements = "容器内合计五十单位葡萄酒与五单位星糖，接受普通、红、白葡萄酒"
	new_rite_active_icon = "baotha_active"
	new_rite_reward_message = "巴奥莎赐下十分钟忘忧圣宴：痛楚远去，幸运增加一点，意志降低两点。"
	new_rite_chants = list("巴奥莎啊，请赴这场忘忧的圣宴。", "我献上葡萄酒与星糖，愿苦痛在杯中沉睡。", "让好运伴随我，纵使清醒的意志因此消退。")

/obj/structure/ritualcircle/sacrifice/baotha/perform_sacrifice_rite(riteselection, mob/living/user)
	if(riteselection == "忘忧圣宴")
		return run_new_sacrifice(user)
	return ..()

/obj/structure/ritualcircle/sacrifice/baotha/build_new_offering(datum/z121_sacrifice_offering/offering)
	return offering.collect_reagents(list(/datum/reagent/consumable/ethanol/wine, /datum/reagent/consumable/ethanol/redwine, /datum/reagent/consumable/ethanol/whitewine), 50) && offering.collect_reagents(list(/datum/reagent/starsugar), 5)

/datum/status_effect/z121_sacrifice_blessing/baotha_feast
	id = "z121_baotha_feast"
	duration = 10 MINUTES
	required_patron = /datum/patron/inhumen/baotha
	effectedstats = list(STATKEY_LCK = 1, STATKEY_WIL = -2)
	alert_type = /atom/movable/screen/alert/status_effect/z121_baotha_feast

/datum/status_effect/z121_sacrifice_blessing/baotha_feast/on_apply()
	. = ..()
	if(.)
		ADD_TRAIT(owner, TRAIT_NOPAIN, id)

/datum/status_effect/z121_sacrifice_blessing/baotha_feast/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_NOPAIN, id)
	return ..()

/atom/movable/screen/alert/status_effect/z121_baotha_feast
	name = "忘忧圣宴"
	desc = "十分钟内不再感到疼痛，幸运增加一点，意志降低两点。死亡或改信后消失。"
	icon_state = "joy"
