/obj/effect/proc_holder/spell/targeted/transfix_neu
	name = "摄心"
	overlay_state = "transfix"

	associated_skill = /datum/skill/magic/blood

	range = 7
	chargetime = 0
	releasedrain = 100
	recharge_time = 15 SECONDS

	/// Ignore crosses and give a different message
	var/powerful = FALSE
	/// Willpower divisor from INT
	var/int_divisor = 3.3
	/// Faces of blood die
	var/blood_dice = 9
	/// Faces of will die
	var/will_dice = 6

	var/transfix_msg

/obj/effect/proc_holder/spell/targeted/transfix_neu/choose_targets(mob/user = usr)
	var/list/selection = list()
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, usr))
		if(!target.mind || target.stat != CONSCIOUS)
			continue
		if(target.is_immune_to_vampire_domination())
			continue
		selection += target

	if(!selection.len)
		revert_cast(user)
		return

	perform(selection, user=user)

/obj/effect/proc_holder/spell/targeted/transfix_neu/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, span_warning("附近没有凡人……"))
		revert_cast(user)
		return

	transfix_msg = input(user, "安抚他们，支配他们。开口吧，他们便会屈服。", "摄心") as message|null
	if(!transfix_msg || length(transfix_msg) < 10)
		to_chat(user, span_userdanger("这还不足以俘获他们的心智！"))
		revert_cast()
		return

	if(!powerful)
		var/mob/selected = input(user, "要俘获哪个凡人的心智？", "摄心") as null|anything in targets
		if(QDELETED(src) || QDELETED(user) || QDELETED(selected))
			revert_cast(user)
			return
		targets = list(selected)

	var/bloodskill = user.get_skill_level(/datum/skill/magic/blood)
	var/bloodroll = roll(bloodskill, blood_dice)
	user.say(transfix_msg, forced = "spell ([name])")
	if(powerful)
		user.visible_message("<font color='red'>[user]向外释放意志，双眼泛起骇人的红光！</font>")

	for(var/mob/living/carbon/human/target as anything in targets)
		var/current_will_dice = will_dice + (target.cmode ? 1 : 0)
		var/willpower = round(target.STAINT / int_divisor, 1)
		var/willroll = roll(willpower, current_will_dice)

		// If the vampire failed badly
		var/knowledgable = (willroll - bloodroll) >= 3

		if(!powerful)
			for(var/obj/item/clothing/neck/roguetown/psicross/silver/I in target.contents) //Subpath fix.
				var/extra = "！"
				if(knowledgable)
					extra = "，我感知到施法者是[user]！"
				to_chat(target, "<font color='white'>银制普赛圣十字闪耀着光芒，保护我免受邪秽魔法侵袭[extra]</font>")
				to_chat(user, span_userdanger("[target]持有我的克星！我因此无法俘获对方的心智！"))
				break

		if(bloodroll >= willroll)
			target.drowsyness = min(target.drowsyness + 50, 150)
			switch(target.drowsyness)
				if(0 to 50)
					to_chat(target, "你感觉心智仿佛被一层帷幕笼罩。")
					to_chat(user, "[target]的心防稍稍松动了。")
					target.Slowdown(20)
				if(51 to 90)
					to_chat(target, "强烈的困倦袭来，你的眼皮不由自主地合上。")
					to_chat(user, "[target]已经撑不了多久了。")
					target.eyesclosed = TRUE
					target.become_blind("eyelids")
					if(target.hud_used)
						for(var/atom/movable/screen/eye_intent/eyet in target.hud_used.static_inventory)
							eyet.update_icon(target)
					target.Slowdown(50)
				if(91 to INFINITY)
					to_chat(target, span_userdanger("你再也无法承受。双腿一软，你坠入了梦境。"))
					to_chat(user, "[target]现在归我了。")
					target.eyesclosed = TRUE
					target.become_blind("eyelids")
					if(target.hud_used)
						for(var/atom/movable/screen/eye_intent/eyet in target.hud_used.static_inventory)
							eyet.update_icon(target)
					target.Slowdown(50)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, Sleeping), 1 MINUTES), 5 SECONDS)
			continue

		if(!powerful)
			var/holypower = target.get_skill_level(/datum/skill/magic/holy)
			var/magicpower = round(target.get_skill_level(/datum/skill/magic/arcane) * 0.6, 1)
			var/roll = roll(1 + holypower + magicpower, 5)
			if(roll > bloodroll)
				to_chat(target, "我感觉这邪秽魔法来自[user]。我应该对其施展魔法或神迹。")

		to_chat(user, span_userdanger("我没能俘获[target]的心智！"))
		to_chat(target, span_userdanger("这个地方有些不对劲。"))
