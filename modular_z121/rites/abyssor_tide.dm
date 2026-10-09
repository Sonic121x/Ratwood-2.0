// 深潮洗礼必须在水域旁举行，恢复效果也只在水中发生。
/obj/structure/ritualcircle/sacrifice/abyssor
	ritual_title = "阿比索尔的献祭仪式"
	sacrifice_rites = list("深潮洗礼")
	new_rite_effect = /datum/status_effect/z121_sacrifice_blessing/abyssor_tide
	new_rite_requirements = "一颗珍珠与一颗心石，且法阵两格内须有水域"
	new_rite_active_icon = "abyssor_active"
	new_rite_reward_message = "深潮洗礼将伴随我十五分钟：我能在水下呼吸，水流亦会逐渐洗去毒伤与窒息。"
	new_rite_chants = list("阿比索尔啊，请听潮水中的呼唤。", "我将珍珠与心石归还深海，愿你的梦接纳我。", "让纯净之潮洗去毒与窒息，赐我水中的呼吸。")

/obj/structure/ritualcircle/sacrifice/abyssor/perform_sacrifice_rite(riteselection, mob/living/user)
	if(riteselection == "深潮洗礼")
		return run_new_sacrifice(user)
	return ..()

/obj/structure/ritualcircle/sacrifice/abyssor/build_new_offering(datum/z121_sacrifice_offering/offering)
	return offering.collect_items(/obj/item/pearl) && offering.collect_items(/obj/item/roguegem/coral)

/obj/structure/ritualcircle/sacrifice/abyssor/new_rite_environment_valid()
	var/turf/altar = get_turf(src)
	if(!altar)
		return FALSE
	for(var/turf/open/water/water in range(2, altar))
		if(water.z == altar.z)
			return TRUE
	return FALSE

/datum/status_effect/z121_sacrifice_blessing/abyssor_tide
	id = "z121_abyssor_tide"
	duration = 15 MINUTES
	required_patron = /datum/patron/divine/abyssor
	alert_type = /atom/movable/screen/alert/status_effect/z121_abyssor_tide

/datum/status_effect/z121_sacrifice_blessing/abyssor_tide/on_apply()
	. = ..()
	if(.)
		ADD_TRAIT(owner, TRAIT_WATERBREATHING, id)

/datum/status_effect/z121_sacrifice_blessing/abyssor_tide/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_WATERBREATHING, id)
	return ..()

/datum/status_effect/z121_sacrifice_blessing/abyssor_tide/tick()
	if(!holder_valid())
		qdel(src)
		return
	if(owner.stat == CONSCIOUS && istype(owner.loc, /turf/open/water))
		owner.adjustToxLoss(-1)
		owner.adjustOxyLoss(-2)

/atom/movable/screen/alert/status_effect/z121_abyssor_tide
	name = "深潮洗礼"
	desc = "十五分钟内能够水下呼吸；清醒且位于水域时，每五秒恢复一点毒伤与两点窒息伤。死亡或改信后消失。"
	icon_state = "stressvg"
