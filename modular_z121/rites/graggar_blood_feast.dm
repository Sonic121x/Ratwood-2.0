// 血星狂宴以体质为代价换取短时攻势，三颗心脏必须是互不重复的离体有机器官。
/obj/structure/ritualcircle/sacrifice/graggar
	ritual_title = "格拉加尔的献祭仪式"
	sacrifice_rites = list("血星狂宴")
	new_rite_effect = /datum/status_effect/z121_sacrifice_blessing/graggar_feast
	new_rite_requirements = "三颗离体有机心脏与一颗红宝石，不接受构装体核心"
	new_rite_active_icon = "graggar_active"
	new_rite_reward_message = "血星的饥渴降临于我：五分钟内力量增加三点、速度增加一点，体质降低两点。"
	new_rite_chants = list("格拉加尔啊，见证这三颗离体之心。", "我将心脏与赤红宝石献于血星，换取狂宴的力量。", "让我的攻势更加凶猛，纵使肉体因此脆弱。")

/obj/structure/ritualcircle/sacrifice/graggar/perform_sacrifice_rite(riteselection, mob/living/user)
	if(riteselection == "血星狂宴")
		return run_new_sacrifice(user)
	return ..()

/obj/structure/ritualcircle/sacrifice/graggar/build_new_offering(datum/z121_sacrifice_offering/offering)
	return offering.collect_items(/obj/item/organ/heart, 3, organic_hearts = TRUE) && offering.collect_items(/obj/item/roguegem/ruby)

/datum/status_effect/z121_sacrifice_blessing/graggar_feast
	id = "z121_graggar_feast"
	duration = 5 MINUTES
	required_patron = /datum/patron/inhumen/graggar
	effectedstats = list(STATKEY_STR = 3, STATKEY_SPD = 1, STATKEY_CON = -2)
	alert_type = /atom/movable/screen/alert/status_effect/z121_graggar_feast

/atom/movable/screen/alert/status_effect/z121_graggar_feast
	name = "血星狂宴"
	desc = "五分钟内力量增加三点、速度增加一点，体质降低两点。死亡或改信后收益与代价一同消失。"
	icon_state = "call_to_arms"
