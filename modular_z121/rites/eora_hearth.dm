// 炉边温情只治疗现有血肉伤势，同一目标不能同时叠加多位主持者的光环。
/obj/structure/ritualcircle/sacrifice/eora
	ritual_title = "伊欧拉的献祭仪式"
	sacrifice_rites = list("炉边温情")
	new_rite_effect = /datum/status_effect/z121_sacrifice_blessing/eora_hearth
	new_rite_requirements = "三朵罂粟花与一颗萨菲拉蓝宝石"
	new_rite_active_icon = "eora_active"
	new_rite_reward_message = "伊欧拉赐下十分钟炉边温情：我与身旁安宁之人的血肉伤势将逐渐平复。"
	new_rite_chants = list("伊欧拉啊，愿这束鲜花为你绽放。", "请收下这颗澄澈的宝石，守护炉边的温情。", "让平静相聚的人们，在你的怀抱中抚平创伤。")

/obj/structure/ritualcircle/sacrifice/eora/perform_sacrifice_rite(riteselection, mob/living/user)
	if(riteselection == "炉边温情")
		return run_new_sacrifice(user)
	return ..()

/obj/structure/ritualcircle/sacrifice/eora/build_new_offering(datum/z121_sacrifice_offering/offering)
	return offering.collect_items(/obj/item/reagent_containers/food/snacks/grown/rogue/poppy, 3) && offering.collect_items(/obj/item/roguegem/violet)

/mob/living/carbon/human
	var/z121_next_hearth_heal = 0

/datum/status_effect/z121_sacrifice_blessing/eora_hearth
	id = "z121_eora_hearth"
	duration = 10 MINUTES
	required_patron = /datum/patron/divine/eora
	alert_type = /atom/movable/screen/alert/status_effect/z121_eora_hearth

/datum/status_effect/z121_sacrifice_blessing/eora_hearth/tick()
	if(!holder_valid())
		qdel(src)
		return
	if(owner.stat != CONSCIOUS || owner.cmode || !isturf(owner.loc))
		return
	var/list/targets = view(2, owner)
	targets |= owner
	for(var/mob/living/carbon/human/target in targets)
		if(QDELETED(target) || target.stat != CONSCIOUS || target.cmode || target.z != owner.z || !isturf(target.loc) || world.time < target.z121_next_hearth_heal)
			continue
		target.z121_next_hearth_heal = world.time + 5 SECONDS
		target.heal_overall_damage(1, 1)

/atom/movable/screen/alert/status_effect/z121_eora_hearth
	name = "炉边温情"
	desc = "十分钟内，清醒且不在战斗姿态时，每五秒治疗同层可见两格内安宁之人的一点钝伤与烧伤。多个光环不会叠加。死亡或改信后消失。"
	icon_state = "stressvg"
