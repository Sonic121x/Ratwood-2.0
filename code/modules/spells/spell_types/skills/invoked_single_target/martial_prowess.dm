/obj/effect/proc_holder/spell/self/martial_prowess
	name = "收徒传艺"
	desc = "收一人为弟子，使其武器技能能够突破专家等级。此能力每日恢复一次使用次数。"
	overlay_state = "craft_buff"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	antimagic_allowed = TRUE
	var/charges = 1

/obj/effect/proc_holder/spell/self/martial_prowess/cast(mob/user = usr)
	. = ..()
	if(charges < 1)
		to_chat(user, span_warning("我暂时还不能再收一名弟子。"))
		revert_cast()
		return
	if(charges == 1)
		to_chat(user, span_notice("我还能收[charges]名弟子。"))
	else
		to_chat(user, span_notice("我还能收[charges]名弟子。"))
	var/list/nearbypeople = list()
	for(var/mob/living/carbon/human/potential_proteges in (view(1)))
		if(potential_proteges.job != "Veteran" && !potential_proteges.cmode) //prevent using in combat
			nearbypeople += potential_proteges
		var/target = input(user, "选择要收为弟子的人") as null|anything in nearbypeople
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/trainee = target
			if(!trainee)
				revert_cast()
				return
			if(trainee == user)
				revert_cast()
				return
			if(!trainee.mind)
				revert_cast()
				return
			if(HAS_TRAIT(trainee, TRAIT_MARTIAL_PROWESS))
				to_chat(user, span_warning("对方已经接受过指导！"))
				revert_cast()
				return

			to_chat(user, span_notice("我提出传授武艺。"))
			var/prompt = alert(trainee, "[user.name]希望收你为弟子，使你的武艺能够突破专家等级。你愿意吗？", "老兵的弟子", "拜师学艺", "我拒绝")
			if(prompt == "我拒绝")
				to_chat(user, span_warning("对方拒绝了我的提议。"))
				return
			to_chat(user, span_greentext("对方愿意接受我的指导！"))
			to_chat(trainee, span_greentext("有了[user.name]的指导，我对学习和精通兵器更有信心了！"))
			ADD_TRAIT(trainee, TRAIT_MARTIAL_PROWESS, TRAIT_GENERIC)
			charges--
