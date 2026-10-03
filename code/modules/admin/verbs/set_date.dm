/client/proc/cmd_admin_set_ic_date()
	set category = "Admin.Special"
	set name = "设置角色日期"

	if(!check_rights(R_ADMIN))
		return

	var/choice = alert(src, "要进行什么操作？", "角色日期覆盖", "设置自定义日期", "清除覆盖")

	if(!choice || choice == "清除覆盖")
		if(GLOB.date_override_enabled)
			GLOB.date_override_enabled = FALSE
			GLOB.date_override_offset = 0
			log_admin("[key_name(usr)] cleared the IC date override")
			message_admins(span_adminnotice("[key_name_admin(usr)]清除了角色日期覆盖。当前日期：[get_current_ic_date_as_string()]"))
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Set IC Date - Clear")
		return

	if(choice == "设置自定义日期")
		var/month_names = list(
			"1 - 普赛初升月（三月）",
			"2 - 伊欧拉月（四月）",
			"3 - 登多尔月（五月）",
			"4 - 阿斯特拉塔月（六月）",
			"5 - 赛利克斯月（七月）",
			"6 - 玛勒姆月（八月）",
			"7 - 赛昂落月（九月）",
			"8 - 佩斯特拉月（十月）",
			"9 - 内克拉月（十一月）",
			"10 - 诺克月（十二月）",
			"11 - 阿比索尔月（一月）",
			"12 - 拉沃克斯月（二月）"
		)

		var/month_choice = input(src, "选择月份：", "设置角色日期 - 月份") as null|anything in month_names
		if(!month_choice)
			return

		var/target_month = text2num(copytext(month_choice, 1, 3))

		var/target_day = input(src, "输入本月日期（1-28）：", "设置角色日期 - 日期", 1) as num|null
		if(isnull(target_day))
			return

		target_day = clamp(round(target_day), 1, 28)

		var/round_id = text2num(GLOB.round_id) || 0
		var/current_days_since_epoch = (round_id) * CALENDAR_DAYS_IN_WEEK + (GLOB.dayspassed - 1)
		var/current_day_of_year = MODULUS(current_days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1

		var/target_day_of_year = (target_month - 1) * CALENDAR_DAYS_IN_MONTH + target_day
		var/offset = target_day_of_year - current_day_of_year

		GLOB.date_override_enabled = TRUE
		GLOB.date_override_day = target_day
		GLOB.date_override_month = target_month
		GLOB.date_override_offset = offset

		log_admin("[key_name(usr)] set IC date override to [target_day]/[target_month] (offset: [offset] days)")
		message_admins(span_adminnotice("[key_name_admin(usr)]设置了角色日期覆盖。新日期：[get_current_ic_date_as_string()]，时间：[get_current_ic_time_as_string()]"))
		to_chat(src, span_notice("角色日期已设为：[get_current_ic_date_as_string()]"))
		to_chat(src, span_notice("日期会随着日子流逝自然推进。"))
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Set IC Date")
