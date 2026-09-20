// 保留每日两次解绑界面，使用具体实例退款；旧职业窗口不能处理新职业账目。
/obj/item/book/spellbook/change_spells(mob/user = usr)
	var/datum/mind/user_mind = user?.mind
	if(!user_mind)
		return
	if(user_mind.has_changed_spell)
		to_chat(user, span_warning("I have already unbinded my spells today!"))
		return
	var/mob/living/carbon/human/H = ishuman(user) ? user : null
	var/datum/z121_profession_record/R = H?.z121_profession
	var/list/resettable_spells = list()
	for(var/obj/effect/proc_holder/spell/S as anything in user_mind.spell_list)
		if(S.refundable && S.cost > 0)
			var/label = "[S.name]: [S.cost]"
			while(label in resettable_spells)
				label += " *"
			resettable_spells[label] = S
	if(!length(resettable_spells))
		to_chat(user, span_warning("I have no spells to unbind!"))
		return
	user_mind.has_changed_spell = TRUE
	var/unlearn_success = FALSE
	for(var/i in 1 to 2)
		var/choice = input(user, "Choose up to two spells to unbind. Cancel both to not use up your daily unbinding.") as null|anything in resettable_spells
		if(QDELETED(user) || user.mind != user_mind || !user.client || (H && H.z121_profession != R))
			break
		var/obj/effect/proc_holder/spell/S = resettable_spells[choice]
		if(QDELETED(S) || !(S in user_mind.spell_list))
			break
		var/list/payment = R?.purchases[WEAKREF(S)]
		var/refund = payment ? payment[2] : S.cost
		if(user_mind.used_spell_points < refund)
			to_chat(user, span_warning("法术点账目与退款记录不一致，已保留该法术。"))
			break
		user_mind.spell_list -= S
		S.action?.Remove(user)
		// 有职业账目的实例由删除信号统一结算；其他法术沿用原退款额度。
		if(!payment)
			user_mind.used_spell_points -= refund
		qdel(S)
		unlearn_success = TRUE
		resettable_spells -= choice
		user_mind.check_learnspell()
	if(!unlearn_success)
		user_mind.has_changed_spell = FALSE
