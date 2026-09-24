// 账号专属赠礼：登录派发器在客户端绑定后调用，恢复原有 RPG 系统与积分授予规则。
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
		system.points = 99999999
		to_chat(src, span_nicegreen("【系统提示】检测到世界管理员权限，已为你注入 99999999 系统积分。"))
