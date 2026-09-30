// 账号专属赠礼：登录派发器在客户端绑定后调用，直接赠送积分及三种成长点。
/mob/living/carbon/human/proc/grant_kukuling_perks()
	// 账号名已由引擎归一化；仅为尚未持有系统的角色授予，避免重连重置积分。
	if(ckey != "kukuling" || HAS_TRAIT(src, TRAIT_RPG_SYSTEM))
		return
	var/datum/virtue/utility/rpg_system/granted = GLOB.virtues[/datum/virtue/utility/rpg_system]
	if(!granted)
		return
	// 直接授予美德效果，沿用原特例绕过凯旋点门槛。
	granted.apply_to_human(src)
	var/datum/component/rpg_system/system = GetComponent(/datum/component/rpg_system)
	if(system)
		// 管理员赠礼不经过经验奖励入口，保留已有等级和经验。
		system.points = max(system.points, 99999999)
		var/datum/component/rpg_journal/journal = system.get_journal()
		journal.rpg_attribute_points += 999
		journal.rpg_skill_points += 999
		journal.rpg_trait_points += 999
		SStgui.update_uis(system)
		to_chat(src, span_nicegreen("【系统提示】检测到世界管理员权限，系统积分已补足至至少 99999999，并赠予 999 属性点、999 技能点、999 特性点；本次赠礼不增加经验。"))
