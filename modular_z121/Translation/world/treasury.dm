// Match the actual fund so a character can share an institution's name.
/datum/fund/proc/get_institution_display_name()
	if(src == SStreasury.discretionary_fund)
		return "王室金库"
	if(src == SStreasury.burgher_pledge_fund)
		return "市民认捐"
	if(src == SStreasury.church_fund)
		return "教会基金"
	if(src == SStreasury.merchant_fund)
		return "商人基金"
	if(src == SStreasury.bathhouse_fund)
		return "浴场基金"
	if(src == SStreasury.innkeeper_fund)
		return "酒馆收入"
	return null

/datum/treasury_entry
	var/from_fund_label
	var/to_fund_label

/datum/treasury_entry/proc/set_fund_display_names(datum/fund/from_fund, datum/fund/to_fund)
	from_fund_label = from_fund?.get_institution_display_name()
	to_fund_label = to_fund?.get_institution_display_name()

/datum/treasury_entry/proc/get_reason_display()
	if(!reason)
		return ""
	if(kind == "mint" && dd_hasprefix_case(reason, "NERVELOCK deposit by "))
		return "[copytext(reason, length("NERVELOCK deposit by ") + 1)]通过神经锁存款"
	if(kind == "burn" && dd_hasprefix_case(reason, "NERVELOCK withdraw by "))
		return "[copytext(reason, length("NERVELOCK withdraw by ") + 1)]通过神经锁取款"
	if(kind != "transfer" || !endswith(reason, ")"))
		return reason
	var/open_paren = findtextEx(reason, " (")
	if(!open_paren)
		return reason
	var/category = copytext(reason, 1, open_paren)
	var/detail = copytext(reason, open_paren + 2, -1)
	if(category == "Poll Tax" || category == "Poll Subsidy")
		var/class_label = (detail in SStreasury.poll_tax_rates) ? SStreasury.get_poll_tax_category_pretty_name(detail) : detail
		return "[category == "Poll Tax" ? "人头税" : "人头补贴"]（[class_label]）"
	if(category == "Poll Tax advance" && endswith(detail, " days"))
		return "预缴人头税（[copytext(detail, 1, -length(" days"))] 天）"
	if(category in SStreasury.tax_rates)
		if(category == TAX_CATEGORY_CONTRACT_LEVY && detail == "Blockade defense")
			detail = "封锁防御"
		return "[SStreasury.get_tax_category_pretty_name(category)]（[detail]）"
	return reason
