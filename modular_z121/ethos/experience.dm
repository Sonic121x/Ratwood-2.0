// 所有制作、劳动类正向经验统一结算，不追踪行为来源。
/mob/living/carbon/human/proc/z121_ethos_experience(skill, amount)
	if(amount <= 0 || !z121_get_ethos()?.virtues["diligence"])
		return amount
	var/datum/skill/S = GetSkillRef(skill)
	return (istype(S, /datum/skill/craft) || istype(S, /datum/skill/labor)) ? amount * 1.2 : amount

// 低等级经验会转交人类入口，只有直接记入睡眠经验的分支在这里结算。
/datum/sleep_adv/add_sleep_experience(skill, amt, silent = FALSE)
	var/mob/living/carbon/human/H = ishuman(mind?.current) ? mind.current : null
	if(!H || (H.get_skill_level(skill) < SKILL_LEVEL_APPRENTICE && !is_considered_sleeping()))
		return ..()
	return ..(skill, H.z121_genius_experience(H.z121_ethos_experience(skill, amt)), silent)
