/datum/treasury_entry
	var/world_time
	var/kind
	var/from_name
	var/to_name
	var/amount
	var/currency
	var/reason

/datum/treasury_entry/New(entry_kind, datum/fund/from_fund, datum/fund/to_fund, entry_amount, entry_reason, from_label)
	. = ..()
	world_time = world.time
	kind = entry_kind
	amount = entry_amount
	reason = entry_reason
	from_name = from_fund ? from_fund.name : (from_label || "void")
	to_name = to_fund ? to_fund.name : "void"
	var/datum/fund/source = from_fund || to_fund
	currency = source?.currency

/datum/treasury_entry/proc/format()
	var/suffix = reason ? " ([reason])" : ""
	switch(kind)
		if("mint")
			return "向[to_name]入账+[amount][suffix]"
		if("burn")
			return "从[from_name]扣款-[amount][suffix]"
		if("transfer")
			return "从[from_name]向[to_name]转账[amount][suffix]"
	return "[kind == "micro" ? "零星汇款" : kind] [amount][suffix]"
