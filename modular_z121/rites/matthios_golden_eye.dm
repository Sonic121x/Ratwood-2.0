// 黄金之眼收取法阵上的实物钱币，不访问账户，也不产生净收益。
/obj/structure/ritualcircle/sacrifice/matthios
	ritual_title = "马西奥斯的献祭仪式"
	sacrifice_rites = list("黄金之眼")
	new_rite_requirements = "价值三百玛门的普通金、银、铜硬币与一块银锭"
	new_rite_active_icon = "matthios_active"
	new_rite_reward_message = "马西奥斯收下了财富，赐我黄金之眼。我能精确鉴价；改信后这份能力将停用。"
	new_rite_chants = list("马西奥斯啊，我以财富叩响交易之门。", "收下这些硬币与白银，揭去价值上的伪装。", "愿我看清每一份财富，不再受虚妄之价蒙蔽。")

/obj/structure/ritualcircle/sacrifice/matthios/perform_sacrifice_rite(riteselection, mob/living/user)
	if(riteselection == "黄金之眼")
		return run_new_sacrifice(user)
	return ..()

/obj/structure/ritualcircle/sacrifice/matthios/build_new_offering(datum/z121_sacrifice_offering/offering)
	return offering.collect_items(/obj/item/ingot/silver) && offering.collect_coins(300)

/obj/structure/ritualcircle/sacrifice/matthios/new_rite_can_receive(mob/living/carbon/human/user)
	return ..() && !user.mind.z121_sacrifice_unlocks?.matthios_unlocked && !HAS_TRAIT(user, TRAIT_SEEPRICES)

/obj/structure/ritualcircle/sacrifice/matthios/grant_new_reward(mob/living/carbon/human/user)
	if(!user.mind.z121_sacrifice_unlocks)
		new /datum/z121_sacrifice_unlocks(user.mind)
	user.mind.z121_sacrifice_unlocks.unlock_matthios()
