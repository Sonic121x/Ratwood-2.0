// 禁忌启封只解锁一份专属法术，不改写其他途径学会的死灵术。
/obj/structure/ritualcircle/sacrifice/zizo
	ritual_title = "齐佐的献祭仪式"
	sacrifice_rites = list("禁忌启封")
	new_rite_requirements = "两件符文遗物、一颗奥尼克萨黑宝石与一份含至少五单位命髓的灵辉"
	new_rite_active_icon = "zizo_active"
	new_rite_reward_message = "齐佐启封了禁忌知识。我已学会唤起尸鬼，但它们不会对我友善；改信后这份能力将停用。"
	new_rite_chants = list("齐佐啊，我愿叩开被封禁的知识之门。", "收下遗物、黑石与命髓，让死者听见我的呼唤。", "愿停滞被打破，愿禁忌在我的心中启封。")

/obj/structure/ritualcircle/sacrifice/zizo/perform_sacrifice_rite(riteselection, mob/living/user)
	if(riteselection == "禁忌启封")
		return run_new_sacrifice(user)
	return ..()

/obj/structure/ritualcircle/sacrifice/zizo/build_new_offering(datum/z121_sacrifice_offering/offering)
	return offering.collect_items(/obj/item/magic/artifact, 2) && offering.collect_items(/obj/item/roguegem/onyxa) && offering.collect_items(/obj/item/reagent_containers/lux, lux_vitae = TRUE)

/obj/structure/ritualcircle/sacrifice/zizo/new_rite_can_receive(mob/living/carbon/human/user)
	return ..() && !user.mind.z121_sacrifice_unlocks?.zizo_unlocked && !user.mind.has_spell(/obj/effect/proc_holder/spell/invoked/raise_deadite)

/obj/structure/ritualcircle/sacrifice/zizo/grant_new_reward(mob/living/carbon/human/user)
	if(!user.mind.z121_sacrifice_unlocks)
		new /datum/z121_sacrifice_unlocks(user.mind)
	user.mind.z121_sacrifice_unlocks.unlock_zizo()
