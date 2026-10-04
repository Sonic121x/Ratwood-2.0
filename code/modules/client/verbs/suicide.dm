/mob/var/suiciding = 0

/mob/proc/set_suicide(suicide_state)
	suiciding = suicide_state
	if(suicide_state)
		GLOB.suicided_mob_list += src
	else
		GLOB.suicided_mob_list -= src

/mob/living/carbon/set_suicide(suicide_state) //you thought that box trick was pretty clever, didn't you? well now hardmode is on, boyo.
	. = ..()
	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		B.suicided = suicide_state

/mob/living/silicon/robot/set_suicide(suicide_state)
	. = ..()

/mob/living/carbon/human/verb/suicide()
	set hidden = 1
	if(!usr.client.holder)
		return
	if(!canSuicide())
		return
	var/oldkey = ckey
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(ckey != oldkey)
		return
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE) //need to be called before calling suicide_act as fuck knows what suicide_act will do with your suicider
		var/obj/item/held_item = get_active_held_item()
		if(held_item)
			var/damagetype = held_item.suicide_act(src)
			if(damagetype)
				if(damagetype & SHAME)
					adjustStaminaLoss(200)
					set_suicide(FALSE)
					return

				if(damagetype & MANUAL_SUICIDE_NONLETHAL) //Make sure to call the necessary procs if it does kill later
					set_suicide(FALSE)
					return

				suicide_log()

				var/damage_mod = 0
				for(var/T in list(BRUTELOSS, FIRELOSS, TOXLOSS, OXYLOSS))
					damage_mod += (T & damagetype) ? 1 : 0
				damage_mod = max(1, damage_mod)

				//Do 200 damage divided by the number of damage types applied.
				if(damagetype & BRUTELOSS)
					adjustBruteLoss(200/damage_mod)

				if(damagetype & FIRELOSS)
					adjustFireLoss(200/damage_mod)

				if(damagetype & TOXLOSS)
					adjustToxLoss(200/damage_mod)

				if(damagetype & OXYLOSS)
					adjustOxyLoss(200/damage_mod)

				if(damagetype & MANUAL_SUICIDE)	//Assume the object will handle the death.
					return

				//If something went wrong, just do normal oxyloss
				if(!(damagetype & (BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS) ))
					adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

				death(FALSE)

				return

		var/suicide_message

		if(used_intent.type == INTENT_DISARM)
			suicide_message = pick("[src]试图将自己的头从肩上推掉！看起来是想自杀。", \
								"[src]正把拇指按进自己的眼窝！看起来是想自杀。", \
								"[src]正撕扯自己的双臂，试图将其扯断！看起来是想自杀。")//heheh get it?
		if(used_intent.type == INTENT_GRAB)
			suicide_message = pick("[src]试图扯掉自己的头！看起来是想自杀。", \
									"[src]正用力掐住自己的脖子！看起来是想自杀。", \
									"[src]正将自己的眼睛从眼窝中扯出来！看起来是想自杀。")
		if(used_intent.type == INTENT_HELP)
			suicide_message = pick("[src]正死命地抱紧自己！看起来是想自杀。", \
									"[src]正拼命地与自己击掌！看起来是想自杀。", \
									"[src]兴奋得快要没命了！看起来是想自杀。")
		else
			suicide_message = pick("[src]试图咬断自己的舌头！看起来是想自杀。", \
								"[src]正把拇指戳进自己的眼窝！看起来是想自杀。", \
								"[src]正扭转自己的脖子！看起来是想自杀。", \
								"[src]正屏住呼吸！看起来是想自杀。")

		visible_message(span_danger("[suicide_message]"), span_danger("[suicide_message]"))

		suicide_log()

		adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)

/mob/living/brain/verb/suicide()
	set hidden = 1
	if(!usr.client.holder)
		return
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE)
		visible_message(span_danger("[src]的大脑正变得迟钝，逐渐失去生机。[p_they(TRUE)]似乎已经失去了活下去的意愿。"), \
						span_danger("[src]的大脑正变得迟钝，逐渐失去生机。[p_they(TRUE)]似乎已经失去了活下去的意愿。"))

		suicide_log()

		death(FALSE)

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("你确定要自杀吗？", "确认自杀", "是", "否")
	if(!canSuicide())
		return
	if(confirm == "是")
		set_suicide(TRUE)
		visible_message(span_danger("[src]正在关闭电源，似乎是想自杀。"), \
				span_danger("[src]正在关闭电源，似乎是想自杀。"))

		suicide_log()

		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("你确定要自杀吗？", "确认自杀", "是", "否")
	if(!canSuicide())
		return
	if(confirm == "是")
		set_suicide(TRUE)
		visible_message(span_danger("[src]正在关闭电源，似乎是想自杀。"), \
				span_danger("[src]正在关闭电源，似乎是想自杀。"))

		suicide_log()

		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)

/mob/living/silicon/pai/verb/suicide()
	set hidden = 1
	var/confirm = alert("你确定要自杀吗？", "确认自杀", "是", "否")
	if(confirm == "是")
		var/turf/T = get_turf(src.loc)
		T.visible_message(
			span_notice("[src]的屏幕上闪过一条消息：\"正在清除核心文件。请获取新人格以继续使用 pAI 设备功能。\""),
			null,
			span_notice("[src]发出电子哔声。")
		)

		suicide_log()

		death(FALSE)
	else
		to_chat(src, "已取消自杀。")

/mob/living/simple_animal/verb/suicide()
	set hidden = 1
	if(!usr.client.holder)
		return
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE)
		visible_message(span_danger("[src]开始倒下，似乎已失去活下去的意愿。"), \
						span_danger("[src]开始倒下，似乎已失去活下去的意愿。"))

		suicide_log()

		death(FALSE)

/mob/living/proc/suicide_log(method)
	log_message("committed suicide as [src.type][method ? " ([method])" : ""]", LOG_ATTACK)

/mob/living/carbon/human/suicide_log(method)
	log_message("(job: [src.job ? "[src.job]" : "None"]) committed suicide[method ? " ([method])" : ""]", LOG_ATTACK)

/mob/living/proc/canSuicide()
	switch(stat)
		if(CONSCIOUS)
			return TRUE
		if(SOFT_CRIT)
			to_chat(src, span_warning("我无法在濒危状态下自杀！"))
		if(UNCONSCIOUS)
			to_chat(src, span_warning("我得保持清醒才能自杀！"))
		if(DEAD)
			to_chat(src, span_warning("你已经死了！"))
	return

/mob/living/carbon/canSuicide()
	if(!..())
		return
	if(!(mobility_flags & MOBILITY_USE))	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
		to_chat(src, span_warning("我无法在不能行动时自杀！((不过你可以输入 Ghost 来脱离身体。))"))
		return
	return TRUE
