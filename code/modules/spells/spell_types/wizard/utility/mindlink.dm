/datum/action/cooldown/spell/mindlink
	button_icon = 'icons/mob/actions/mage_utilities.dmi'
	name = "心灵链接"
	desc = "与盟友建立持续三分钟的心灵联结。在讯息前输入 ,m 即可传心交流。"
	button_icon_state = "mindlink"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("心念相连。")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 2 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 3 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 3

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/mindlink/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/list/possible_targets = list()
	if(user.mind.known_people.len)
		for(var/people in user.mind.known_people)
			possible_targets += people
	else
		to_chat(user, span_warning("没有我认识的人可供建立心灵链接！"))
		return FALSE

	possible_targets = sortList(possible_targets)

	if(user.client)
		possible_targets = list(user.real_name) + possible_targets

	user.emote("me", 1, "的眼中短暂闪过超凡的光芒。", TRUE, custom_me = TRUE)

	var/first_target_name = tgui_input_list(user, "选择第一个链接对象", "心灵链接", possible_targets)

	if(!first_target_name)
		return FALSE

	var/mob/living/first_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == first_target_name)
			first_target = HL

	possible_targets -= first_target_name

	var/second_target_name = tgui_input_list(user, "选择第二个链接对象", "心灵链接", possible_targets)

	if(!second_target_name)
		return FALSE

	var/mob/living/second_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == second_target_name)
			second_target = HL

	for(var/datum/mindlink/ML in GLOB.mindlinks)
		if(ML)
			if(ML.owner == first_target || ML.target == first_target || ML.owner == second_target || ML.target == second_target)
				to_chat(user, span_warning("其中一个目标已经与他人建立了心灵联结！"))
				return FALSE

	user.visible_message(span_notice("[user]轻触太阳穴，凝神专注......"), span_notice("我在[first_target]与[second_target]之间建立起一道心灵连接......"))

	// Create the mindlink
	var/datum/mindlink/link = new(first_target, second_target)
	GLOB.mindlinks += link

	to_chat(first_target, span_notice("你与[second_target]建立了心灵联结！在讯息前输入 ,m 可传心交流，输入 ,mst 可断开联结。"))
	to_chat(second_target, span_notice("你与[first_target]建立了心灵联结！在讯息前输入 ,m 可传心交流，输入 ,mst 可断开联结。"))

	addtimer(CALLBACK(src, PROC_REF(break_link), link), 3 MINUTES)
	return TRUE

/datum/action/cooldown/spell/mindlink/proc/break_link(datum/mindlink/link)
	if(!link)
		return

	to_chat(link.owner, span_notice("你与[link.target]之间的心灵链接逐渐消散......"))
	to_chat(link.target, span_notice("你与[link.owner]之间的心灵链接逐渐消散......"))

	GLOB.mindlinks -= link
	qdel(link)
