//鼠木编辑 - 治疗面板状态与操作
/datum/admins/proc/render_z121_heal_panel_conditions(mob/living/carbon/human/H)
	if(!check_rights(R_ADMIN, FALSE))
		return ""
	var/remaining_stamina = max(H.max_stamina - H.stamina, 0)
	var/heal_href = "?_src_=holder;[HrefToken()];target=[REF(H)];heal_action=z121_vitals;z121_vitals_action="
	var/body = "<b>耐力（绿条）：</b><A href='[heal_href]set_stamina' title='调整当前耐力'>[round(remaining_stamina, 0.1)]</A> / [round(H.max_stamina, 0.1)] | <A href='[heal_href]clear_fatigue'>恢复</A> <A href='[heal_href]condition_help;condition=stamina' title='耐力说明'>?</A><br>"
	body += "<b>精力（蓝条）：</b><A href='[heal_href]set_energy' title='调整当前精力'>[round(H.energy, 0.1)]</A> / [round(H.max_energy, 0.1)] | <A href='[heal_href]restore_energy'>恢复</A> <A href='[heal_href]condition_help;condition=energy' title='精力说明'>?</A><br>"
	body += "<b>累积疲劳：</b><A href='[heal_href]set_fatigue' title='调整累积疲劳'>[round(H.stamina, 0.1)]</A> / [round(H.max_stamina, 0.1)] <A href='[heal_href]condition_help;condition=fatigue' title='累积疲劳说明'>?</A><br>"

	var/sleep_deprivation = "无"
	if(H.has_status_effect(/datum/status_effect/debuff/sleepytime/t3))
		sleep_deprivation = "精疲力竭（3/3）"
	else if(H.has_status_effect(/datum/status_effect/debuff/sleepytime/t2))
		sleep_deprivation = "疲惫（2/3）"
	else if(H.has_status_effect(/datum/status_effect/debuff/sleepytime))
		sleep_deprivation = "疲倦（1/3）"
	body += "<b>缺觉状态：</b><A href='[heal_href]set_sleep_deprivation' title='设置缺觉等级'>[sleep_deprivation]</A> | <A href='[heal_href]clear_sleep_deprivation'>消除</A> | <A href='[heal_href]award_sleep'>消除（获取技能点）</A> <A href='[heal_href]condition_help;condition=sleep' title='缺觉状态说明'>?</A><br>"
	return "[body]<br>"

/datum/admins/proc/handle_z121_heal_panel_conditions(mob/living/carbon/human/H, list/href_list)
	if(!check_rights(R_ADMIN))
		return
	var/action = href_list["z121_vitals_action"]
	switch(action)
		if("restore_energy", "clear_fatigue", "clear_sleep_deprivation")
			var/description
			var/admin_notice
			switch(action)
				if("restore_energy")
					H.energy = H.max_energy
					H.update_energy_hud()
					description = "restored the energy of"
					admin_notice = "恢复了 [key_name_admin(H)] 的精力"
				if("clear_fatigue")
					H.stamina_reset()
					H.update_stamina_hud()
					description = "cleared the physical fatigue of"
					admin_notice = "清空了 [key_name_admin(H)] 的累积疲劳"
				if("clear_sleep_deprivation")
					H.remove_sleep_depravation(TRUE)
					description = "cleared the sleep deprivation of"
					admin_notice = "清除了 [key_name_admin(H)] 的缺觉减益"
			message_admins("[key_name_admin(usr)] [admin_notice]。")
			log_admin("[key_name(usr)] [description] [key_name(H)].")
			show_heal_panel(H)

		if("set_stamina", "set_energy", "set_fatigue", "set_sleep_deprivation", "award_sleep")
			edit_heal_panel_condition(H, action)

		if("condition_help")
			switch(href_list["condition"])
				if("stamina")
					to_chat(usr, span_notice("<b>耐力：</b>绿条显示剩余耐力，等于耐力上限减去累积疲劳。耐力上限是精力上限的十分之一。"))
				if("energy")
					to_chat(usr, span_notice("<b>精力：</b>蓝条越满，绿条恢复越快。基础每次恢复量约等于 10 + 40 × 蓝条比例：空蓝 10、半蓝 30、满蓝 50。缺觉、攀爬等会改变实际恢复量。"))
				if("fatigue")
					to_chat(usr, span_notice("<b>累积疲劳：</b>体力活动增加疲劳时，通常也会消耗同等数值的精力。累积疲劳越高，当前绿条越少。休息时系统降低疲劳，疲劳下降本身不会扣蓝。面板直接改疲劳只会改绿条。"))
				if("sleep")
					to_chat(usr, span_notice("<b>缺觉状态：</b>疲倦、疲惫、精疲力竭是三档缺觉。第二档和第三档的绿条恢复量分别乘以 0.8 和 0.7。「消除（获取技能点）」逐档结算睡眠奖励。"))

/datum/admins/proc/edit_heal_panel_condition(mob/living/carbon/human/H, action)
	var/static/list/sleep_statuses = list(
		/datum/status_effect/debuff/sleepytime,
		/datum/status_effect/debuff/sleepytime/t2,
		/datum/status_effect/debuff/sleepytime/t3,
	)
	var/static/list/sleep_stressors = list(
		/datum/stressevent/sleepytime,
		/datum/stressevent/sleepytimet2,
		/datum/stressevent/sleepytimet3,
	)
	var/sleep_tier = 0
	for(var/tier in 1 to length(sleep_statuses))
		if(H.has_status_effect(sleep_statuses[tier]))
			sleep_tier = tier

	if(action == "award_sleep")
		if(!sleep_tier || !H.mind?.sleep_adv || H.health <= 0 || H.stat == DEAD)
			to_chat(usr, span_warning("目标须存活、生命值大于 0、有缺觉状态且可结算睡眠。"))
			return
		var/datum/sleep_adv/sleep_adv = H.mind.sleep_adv
		if(HAS_TRAIT(H, TRAIT_CURSE_ABYSSOR))
			to_chat(usr, span_warning("目标受阿比索尔诅咒，无法结算睡眠奖励。可用「消除」单独清除缺觉。"))
			return
		var/settled_tiers = 0
		for(var/tier in 1 to sleep_tier)
			H.remove_sleep_depravation()
			// A second immediate cycle has no samples. Use a neutral average.
			if(!sleep_adv.stress_cycles)
				sleep_adv.stress_cycles = 1
			var/previous_cycle = sleep_adv.sleep_adv_cycle
			sleep_adv.advance_cycle()
			if(sleep_adv.sleep_adv_cycle > previous_cycle)
				settled_tiers++
		H.last_sleep = world.time
		message_admins("[key_name_admin(usr)] 为 [key_name_admin(H)] 消除了缺觉并结算了 [settled_tiers] 档睡眠奖励。")
		log_admin("[key_name(usr)] cleared sleep deprivation and awarded [settled_tiers] sleep cycles to [key_name(H)].")
		show_heal_panel(H)
		return

	var/label
	var/current
	var/prompt
	switch(action)
		if("set_stamina")
			label = "耐力"
			current = max(H.max_stamina - H.stamina, 0)
		if("set_energy")
			label = "精力"
			current = H.energy
		if("set_fatigue")
			label = "累积疲劳"
			current = H.stamina
		if("set_sleep_deprivation")
			label = "缺觉等级"
			current = sleep_tier
			prompt = "0 无，1 疲倦，2 疲惫，3 精疲力竭"
	var/value = input(usr, prompt ? prompt : "设置[label]", label, round(current, 0.1)) as num|null
	if(isnull(value) || QDELETED(H) || usr.client?.holder != src || !check_rights(R_ADMIN))
		return
	switch(action)
		if("set_stamina", "set_fatigue")
			value = clamp(value, 0, H.max_stamina)
			H.stamina = action == "set_stamina" ? H.max_stamina - value : value
			H.last_fatigued = world.time
			H.update_stamina_hud()
		if("set_energy")
			value = clamp(value, 0, H.max_energy)
			H.energy = value
			if(!value && H.m_intent == MOVE_INTENT_RUN)
				H.toggle_rogmove_intent(MOVE_INTENT_WALK)
			H.update_energy_hud()
		if("set_sleep_deprivation")
			value = clamp(round(value), 0, length(sleep_statuses))
			if(value && H.has_status_effect(/datum/status_effect/debuff/zizo_exhaustion))
				to_chat(usr, span_warning("请先解除齐佐的疲惫诅咒。"))
				return
			H.remove_sleep_depravation(TRUE)
			if(value)
				H.apply_status_effect(sleep_statuses[value])
				if(!HAS_TRAIT(H, TRAIT_NIGHT_OWL))
					H.add_stress(sleep_stressors[value])
	message_admins("[key_name_admin(usr)] 将 [key_name_admin(H)] 的[label]设为 [value]。")
	log_admin("[key_name(usr)] set [action] to [value] for [key_name(H)].")
	show_heal_panel(H)
//鼠木编辑 - 治疗面板状态与操作结束
