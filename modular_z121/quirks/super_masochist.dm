// 特性键直接作为游戏内特性列表的标题，显示与效果共用同一个身份标记。
#define TRAIT_Z121_SUPER_MASOCHIST "超级受虐狂"

// 超级受虐狂作为创角特质收录，复用原恶习，并按当前疼痛程度获得不同的心情增益。
/datum/quirk/super_masochist
	name = "超级受虐狂"
	desc = "命运递来的荆棘，我总比旁人握得更紧。殷红沿指缝滑落时，喧嚣便远了；那些过分平静的日子，反倒叫我无处安放自己。"
	triumph_cost = 0
	point_cost = 1
	added_traits = list(TRAIT_Z121_SUPER_MASOCHIST)
	custom_text = "细微的刺痒如低语，深重的痛楚便成了歌。旁人急于抚平的痕迹，于我却像一封久候的回信；待它们渐渐褪去，那份无人应答的空缺便又悄然归来。"

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

	// 中途获得特质时保留流血心情的剩余时间，疼痛则按当前感受重新计算。
	var/datum/stressevent/old_bleeding = recipient.get_stress_event(/datum/stressevent/bleeding)
	if(old_bleeding)
		var/datum/stressevent/new_bleeding = recipient.add_stress(/datum/stressevent/bleeding)
		new_bleeding.time_added = old_bleeding.time_added
	recipient.z121_update_masochist_pain_mood()

// 在原有心情结算之前刷新疼痛档位，使轻微疼痛、缓解和消失都不依赖剧痛事件。
/mob/living/carbon/human/update_stress()
	if(HAS_TRAIT(src, TRAIT_Z121_SUPER_MASOCHIST) || has_stress_event(/datum/stressevent/z121_masochist_pain))
		z121_update_masochist_pain_mood()
	return ..()

/mob/living/carbon/human/proc/z121_update_masochist_pain_mood()
	if(!HAS_TRAIT(src, TRAIT_Z121_SUPER_MASOCHIST) || stat != CONSCIOUS || HAS_TRAIT(src, TRAIT_NOPAIN) || HAS_TRAIT(src, TRAIT_NOMOOD))
		remove_stress(/datum/stressevent/z121_masochist_pain)
		return
	// 清除获得特质之前留下的剧痛负面心情，避免正负两项同时结算。
	stressors -= /datum/stressevent/painmax
	var/current_pain = get_complex_pain()
	if(current_pain <= 0)
		remove_stress(/datum/stressevent/z121_masochist_pain)
		return

	// 与原版剧痛判定使用同一耐受算法，并计入受虐狂与肾上腺素的影响。
	var/current_threshold = HAS_TRAIT(src, TRAIT_ADRENALINE_RUSH) ? ((STAWIL + 5) * 10) : (STAWIL * 10)
	if(has_flaw(/datum/charflaw/addiction/masochist))
		current_threshold += 10
	var/pain_ratio = current_pain / max(1, current_threshold)
	var/pain_bonus
	var/pain_text
	if(pain_ratio < 0.25)
		pain_bonus = 1
		pain_text = "一缕细微的刺痛，像有人轻轻叩响心门。"
	else if(pain_ratio < 0.5)
		pain_bonus = 2
		pain_text = "隐隐的痛意在肌肤下盘桓，心头的躁动渐渐安静。"
	else if(pain_ratio < 0.8)
		pain_bonus = 3
		pain_text = "一阵阵痛楚漫过身体，我在熟悉的节律中沉醉。"
	else if(pain_ratio < 1)
		pain_bonus = 4
		pain_text = "痛意深深攥住了我，周遭的喧嚣却终于远去。"
	else
		pain_bonus = 5
		pain_text = "痛楚淹没了一切，那份长久的空缺终于被填满。"

	// 始终复用同一个心情实例，升降档只替换数值与文本，不累积不同档位。
	var/datum/stressevent/pain_mood = add_stress(/datum/stressevent/z121_masochist_pain)
	if(pain_mood)
		pain_mood.stressadd = -pain_bonus
		pain_mood.desc = span_green(pain_text)
	return pain_mood

// 仅在人类层级适配，其他心情继续交给原有的刷新与叠加流程。
/mob/living/carbon/human/add_stress(event_type)
	if(HAS_TRAIT(src, TRAIT_Z121_SUPER_MASOCHIST))
		switch(event_type)
			if(/datum/stressevent/bleeding)
				stressors -= event_type
				event_type = /datum/stressevent/bleeding/z121_super_masochist
			if(/datum/stressevent/painmax)
				stressors -= event_type
				return z121_update_masochist_pain_mood()
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
				event_type = /datum/stressevent/z121_masochist_pain
	return ..(event_type)

// 继承原事件的持续时间与叠加上限，单独放行此特质，绕开原受虐狂的心情免疫。
/datum/stressevent/bleeding/z121_super_masochist
	stressadd = -2
	desc = span_green("流淌的鲜血让我感到愉悦。")

/datum/stressevent/bleeding/z121_super_masochist/can_apply(mob/living/user)
	var/mob/living/carbon/human/recipient = user
	return istype(recipient) && HAS_TRAIT(recipient, TRAIT_Z121_SUPER_MASOCHIST)

// 心情随当前疼痛刷新；停止感到疼痛时主动移除，计时仅作为未刷新时的兜底。
/datum/stressevent/z121_masochist_pain
	timer = 1 MINUTES
	stressadd = -1
	desc = span_green("一缕细微的刺痛，像有人轻轻叩响心门。")

/datum/stressevent/z121_masochist_pain/can_apply(mob/living/user)
	var/mob/living/carbon/human/recipient = user
	return istype(recipient) && HAS_TRAIT(recipient, TRAIT_Z121_SUPER_MASOCHIST) && recipient.stat == CONSCIOUS && !HAS_TRAIT(recipient, TRAIT_NOPAIN) && !HAS_TRAIT(recipient, TRAIT_NOMOOD)

// 启动时登记到玩家特性自检面板读取的表，保留含蓄的角色口吻。
/proc/register_z121_super_masochist_trait()
	GLOB.roguetraits[TRAIT_Z121_SUPER_MASOCHIST] = span_info("命运递来的荆棘，我总比旁人握得更紧。殷红沿指缝滑落时，喧嚣便远了；那些过分平静的日子，反倒叫我无处安放自己。")
