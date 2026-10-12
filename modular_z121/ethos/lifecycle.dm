// 人类核心不发送通用意识变化信号，在状态真正变化时同步角色时钟。
/mob/living/carbon/human
	var/z121_ethos_birth_ready = FALSE

// 随机恶习也经过这条出生完成入口；装备、出身及种族技能全部结算后才锁定。
/datum/job/clamp_stats(mob/living/carbon/human/character)
	. = ..()
	character.z121_ethos_birth_ready = TRUE
	var/datum/z121_ethos/R = character.z121_get_ethos()
	if(R)
		R.envy_ready = TRUE
		R.lock_envy_skill()

/mob/living/carbon/human/update_stat()
	var/old_stat = stat
	. = ..()
	if(stat != old_stat && z121_ethos_body && !z121_ethos_body.cleaning)
		z121_ethos_body.on_consciousness_changed()

/mob/living/carbon/human/set_resting(rest, silent = TRUE)
	var/old_resting = resting
	. = ..()
	if(old_resting != resting)
		if(z121_ethos_body)
			z121_ethos_body.sloth_rest = 0
			z121_ethos_body.wrath_rest = 0

/client/toggle_ERP()
	var/mob/living/carbon/human/H = ishuman(mob) ? mob : null
	var/datum/z121_ethos/R = H?.z121_get_ethos()
	R?.sample_activity()
	. = ..()
	if(R)
		R.adult_was_enabled = R.adult_enabled()
		R.sync_effects()

// 菜单反向冲突检查使用实际的恶习槽位键，避免旧键漏掉已经选择的七罪。
/datum/preferences/check_pick_vice_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	for(var/i = 1 to 6)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice && (vice.type in pick?.incompatible_vices))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name]与恶习[vice.name]冲突！"))
			return TRUE
	return ..()

// 改变年龄或种族后，出生前再次校验，不能领取不生效恶习的特质点。
/datum/preferences/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, character_setup = FALSE, antagonist = FALSE, skip_normal_prefs = FALSE)
	for(var/i = 1 to 6)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(istype(vice, /datum/charflaw/z121_sin) && check_vice_pick_conflict(vice.type))
			vars["vice[i]"] = null
			to_chat(usr, span_warning("[vice.name]不符合当前角色条件，已从恶习选择中移除。"))
	if(istype(charflaw, /datum/charflaw/z121_sin) && check_vice_pick_conflict(charflaw.type))
		charflaw = null
	return ..()
