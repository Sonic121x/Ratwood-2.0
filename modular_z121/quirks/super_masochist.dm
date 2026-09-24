// 特性键直接作为游戏内特性列表的标题，显示与效果共用同一个身份标记。
#define TRAIT_Z121_SUPER_MASOCHIST "超级受虐狂"

// 超级受虐狂作为创角特质收录，复用原恶习，仅改变流血与剧痛带来的心情。
/datum/quirk/super_masochist
	name = "超级受虐狂"
	desc = "命运递来的荆棘，我总比旁人握得更紧。殷红沿指缝滑落时，喧嚣便远了；那些过分平静的日子，反倒叫我无处安放自己。"
	triumph_cost = 0
	point_cost = 1
	added_traits = list(TRAIT_Z121_SUPER_MASOCHIST)
	custom_text = "旁人急于抚平的痕迹，于我却像一封久候的回信。待它们渐渐褪去，那份无人应答的空缺便又悄然归来。"

/datum/quirk/super_masochist/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(!istype(recipient))
		return

	// 多恶习列表会取代旧式单恶习的生命处理，先保留旧实例，避免原恶习停止生效。
	if(!length(recipient.vices) && recipient.charflaw)
		LAZYADD(recipient.vices, recipient.charflaw)
	var/datum/charflaw/addiction/masochist/vice = recipient.get_flaw(/datum/charflaw/addiction/masochist)
	if(!vice)
		vice = new /datum/charflaw/addiction/masochist()
		LAZYADD(recipient.vices, vice)
		vice.on_mob_creation(recipient)
	else
		// 旧式引用可能尚未进入多恶习列表；合并同一实例，不重置渴求计时。
		LAZYOR(recipient.vices, vice)
	// 转换已有心情前先授予正式特性；常规特质流程再次授予同源特性不会重复叠加。
	ADD_TRAIT(recipient, TRAIT_Z121_SUPER_MASOCHIST, TRAIT_VIRTUE)

	// 中途获得特质时转换已有负面事件，保留其剩余时间。
	for(var/event_type in list(/datum/stressevent/bleeding, /datum/stressevent/painmax))
		var/datum/stressevent/old_event = recipient.get_stress_event(event_type)
		if(old_event)
			var/datum/stressevent/new_event = recipient.add_stress(event_type)
			new_event.time_added = old_event.time_added

// 仅在人类层级适配，其他心情继续交给原有的刷新与叠加流程。
/mob/living/carbon/human/add_stress(event_type)
	if(HAS_TRAIT(src, TRAIT_Z121_SUPER_MASOCHIST))
		switch(event_type)
			if(/datum/stressevent/bleeding)
				stressors -= event_type
				event_type = /datum/stressevent/bleeding/z121_super_masochist
			if(/datum/stressevent/painmax)
				stressors -= event_type
				event_type = /datum/stressevent/painmax/z121_super_masochist
	return ..(event_type)

// 原调用方仍使用原事件路径；止血时必须同步移除对应的正面事件。
/mob/living/carbon/human/remove_stress(event_type)
	if(HAS_TRAIT(src, TRAIT_Z121_SUPER_MASOCHIST))
		switch(event_type)
			if(/datum/stressevent/bleeding)
				..(event_type)
				event_type = /datum/stressevent/bleeding/z121_super_masochist
			if(/datum/stressevent/painmax)
				..(event_type)
				event_type = /datum/stressevent/painmax/z121_super_masochist
	return ..(event_type)

// 继承原事件的持续时间与叠加上限，单独放行此特质，绕开原受虐狂的心情免疫。
/datum/stressevent/bleeding/z121_super_masochist
	stressadd = -2
	desc = span_green("流淌的鲜血让我感到愉悦。")

/datum/stressevent/bleeding/z121_super_masochist/can_apply(mob/living/user)
	var/mob/living/carbon/human/recipient = user
	return istype(recipient) && HAS_TRAIT(recipient, TRAIT_Z121_SUPER_MASOCHIST)

/datum/stressevent/painmax/z121_super_masochist
	stressadd = -2
	desc = span_green("强烈的疼痛让我心满意足。")

/datum/stressevent/painmax/z121_super_masochist/can_apply(mob/living/user)
	var/mob/living/carbon/human/recipient = user
	return istype(recipient) && HAS_TRAIT(recipient, TRAIT_Z121_SUPER_MASOCHIST)

// 启动时登记到玩家特性自检面板读取的表，保留含蓄的角色口吻。
/proc/register_z121_super_masochist_trait()
	GLOB.roguetraits[TRAIT_Z121_SUPER_MASOCHIST] = span_info("命运递来的荆棘，我总比旁人握得更紧。殷红沿指缝滑落时，喧嚣便远了；那些过分平静的日子，反倒叫我无处安放自己。")
