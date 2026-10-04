/datum/coven/eora
	name = "伊奥拉之拥"
	desc = "受爱情、家庭与艺术女神祝福，这些吸血鬼发展出了巩固羁绊、激发美感与治愈心灵创伤的能力。"
	icon_state = "eora"
	power_type = /datum/coven_power/eora
	max_level = 4

/datum/coven_power/eora
	name = "Eora power name"
	desc = "Eora power description"

//EMPATHIC BOND
/datum/coven_power/eora/empathic_bond
	name = "共情羁绊"
	desc = "触碰他人以感知其情绪与当前需求，让你短暂地迷恋对方。"

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 1

	cooldown_length = 10 SECONDS

/datum/coven_power/eora/empathic_bond/activate(mob/living/target)
	. = ..()
	if(!.)
		return
	if(!ishuman(target))
		to_chat(owner, span_warning("你只能感知其他人的情绪。"))
		return

	var/mob/living/carbon/human/victim = target

	// Generate emotional state based on character's current condition
	var/list/emotions = list()
	var/list/needs = list()

	if(victim.getBruteLoss() > 20 || victim.getFireLoss() > 20)
		emotions += "疼痛"
		needs += "治疗"
	if(victim.getToxLoss() > 20)
		emotions += "病痛"
		needs += "净化"
	if(victim.getOxyLoss() > 20)
		emotions += "疲惫"
		needs += "休息"
	if(victim.nutrition < 200)
		emotions += "饥饿"
		needs += "食物"
	if(victim.getOrganLoss(ORGAN_SLOT_BRAIN) > 20)
		emotions += "困惑"
		needs += "清晰的思绪"

	// Add some randomized emotional states
	var/list/possible_emotions = list("孤独", "满足", "焦虑", "希望", "悲伤", "喜悦", "恐惧", "爱意", "愤怒", "平静")
	emotions += pick(possible_emotions)

	var/list/possible_needs = list("陪伴", "理解", "安全", "目标", "接纳", "创意表达")
	needs += pick(possible_needs)

	var/emotion_text = english_list(emotions)
	var/needs_text = english_list(needs)

	to_chat(owner, span_notice("你感知到[victim]的情绪：[emotion_text]。对方似乎需要：[needs_text]。"))
	to_chat(victim, span_info("你感到[owner]对你的内心了如指掌，清晰得令人惊讶。"))
	owner.AddComponent(/datum/component/empathic_obsession, victim, 2 MINUTES)

//ARTISTIC INSPIRATION
/datum/coven_power/eora/artistic_inspiration
	name = "艺术灵感"
	desc = "以神圣的创造力启迪他人，提升其艺术能力并改善心情。"

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 3

	cooldown_length = 30 SECONDS
	duration_length = 5 MINUTES

/datum/coven_power/eora/artistic_inspiration/activate(mob/living/target)
	. = ..()
	if(!.)
		return
	if(!ishuman(target))
		to_chat(owner, span_warning("只有人类才能接受艺术灵感。"))
		return

	var/mob/living/carbon/human/inspired = target

	to_chat(owner, span_notice("你向[inspired]低语，传授神圣的灵感。"))
	to_chat(inspired, span_purple("你感到创造的力量涌遍全身，无数艺术构想在脑海中翻腾！"))
	target.heal_overall_damage(30, 30)
	target.mind?.sleep_adv?.retained_dust += 200
	target.mind?.sleep_adv?.grant_inspiration_xp(2)

	// Boost mood and give temporary creative buff do this for now until we add some form of creation quality outside of blacksmithing
	target.add_stress(/datum/stressevent/artistic_inspiration)

	//the base class already schedules deactivation off duration_length - do not double it up

/datum/coven_power/eora/artistic_inspiration/deactivate(atom/target, direct = FALSE)
	. = ..()
	if(ismob(target))
		to_chat(target, span_info("神圣的灵感消退了，但那份记忆仍然留存。"))

//FAMILIAL BOND
/datum/coven_power/eora/familial_bond
	name = "亲情羁绊"
	desc = "在两人之间建立暂时的心灵联系，让他们感知彼此的位置与安危。"

	level = 3
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 5

	cooldown_length = 60 SECONDS
	duration_length = 10 MINUTES

/datum/coven_power/eora/familial_bond/activate(mob/living/target)
	. = ..()
	if(!.)
		return
	if(!ishuman(target))
		to_chat(owner, span_warning("你只能与其他人建立羁绊。"))
		return

	var/mob/living/carbon/human/bonded = target

	// Get second target
	var/mob/living/carbon/human/second_target = input(owner, "你想让[bonded]与谁建立羁绊？") as null|mob in (oviewers(5, owner) - bonded)
	if(!second_target || !ishuman(second_target))
		to_chat(owner, span_warning("你需要第二个人才能建立亲情羁绊。"))
		return

	to_chat(owner, span_notice("你在[bonded]与[second_target]之间编织了一道心灵联系。"))
	to_chat(bonded, span_purple("你感到与[second_target]之间形成了一份温暖的联系，仿佛对方就是家人。"))
	to_chat(second_target, span_purple("你感到与[bonded]之间形成了一份温暖的联系，仿佛对方就是家人。"))

	// Store the bond information
	bonded.AddComponent(/datum/component/familial_bond, second_target, duration_length)
	second_target.AddComponent(/datum/component/familial_bond, bonded, duration_length)

//BEAUTY'S RESTORATION
/datum/coven_power/eora/beautys_restoration
	name = "容貌修复"
	desc = "引导伊奥拉的力量，恢复容貌并治愈毁容的创伤。"

	level = 4
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_LIVING | TARGET_HUMAN | TARGET_SELF
	range = 1

	cooldown_length = 90 SECONDS

/datum/coven_power/eora/beautys_restoration/activate(mob/living/target)
	. = ..()
	if(!.)
		return
	if(!ishuman(target))
		to_chat(owner, span_warning("你只能为人恢复容貌。"))
		return

	var/mob/living/carbon/human/patient = target

	to_chat(owner, span_notice("你将伊奥拉的修复之力引导进[patient]体内。"))
	to_chat(patient, span_purple("你感到神圣的力量流遍全身，恢复了你天生的美貌！"))

	// Visual effect
	patient.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/restoration_overlay = mutable_appearance('icons/effects/clan.dmi', "dementation", -MUTATIONS_LAYER)
	patient.overlays_standing[MUTATIONS_LAYER] = restoration_overlay
	patient.apply_overlay(MUTATIONS_LAYER)

	// Heal brute and burn damage (representing restoration of beauty)
	patient.heal_overall_damage(60, 60)

	patient.add_stress(/datum/stressevent/artistic_inspiration_minor)

	addtimer(CALLBACK(src, PROC_REF(clear_restoration_overlay), patient), 3 SECONDS)
	owner.AddComponent(/datum/component/empathic_obsession, patient, 5 MINUTES)

/datum/coven_power/eora/beautys_restoration/proc/clear_restoration_overlay(mob/living/carbon/human/target)
	target?.remove_overlay(MUTATIONS_LAYER)

/datum/coven_power/eora/beautys_restoration/deactivate(atom/target, direct = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/patient = target
		patient.remove_overlay(MUTATIONS_LAYER)

/datum/stressevent/artistic_inspiration
	desc = span_love("神圣的灵感激励着我，去创造美好的事物！")
	stressadd = -3
	timer = 5 MINUTES
	quality_modifier = 3

/datum/stressevent/artistic_inspiration_minor
	desc = span_love("我感到……灵感涌现！")
	stressadd = -1
	timer = 2 MINUTES
	quality_modifier = 1

