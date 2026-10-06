/datum/decree/guild_charter_of_arms
	id = DECREE_GUILD_CHARTER_OF_ARMS
	name = "武备行会宪章"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "雇佣兵的人头税上限为15m；行会每日向市民誓约基金进贡。"
	flavor_text = {"本《武装行会特许状》，于拉沃克斯旗帜之下，由谷地王室与武装行会订立，规定：王室承认行会为获得特许的外国团体，自理内部事务，仅向自己的队长负责。其立誓效力的雇佣兵，除最低人头税外，不承担普通征收。

王室不要求行会立誓效忠，亦不欠其服务。王室不得干涉行会承接的契约，并应保障其成员携带武器、酌情参与私人战争的权利，前提是不扰乱王国和平，且不得承接海盗、劫掠或直接威胁王室利益的契约。

为回报此地位，行会财库从成员处收取费用，每日向市民公约基金进贡，以示善意、贡献王国共同财富，并作为武装者与拉沃克斯的使者在此施行正义。若发现法外之徒穿戴行会标志，行会不为其负责，王室可不受阻碍地对该人执行司法。

钤王室之印与行会之记颁行。"}
	revoke_text = "%RULER%已暂停《武备行会宪章》。谷地雇佣兵现须全额承担王室的常规征税；在协约续订之前，行会停止向誓约基金进贡。"
	restore_text = "%RULER%已重申《武备行会宪章》。行会恢复获认可的地位，并重新向誓约基金进贡。"

/datum/decree/guild_charter_of_arms/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(30, 80)

/// Returns TRUE if the payer is a chartered mercenary under this charter.
/datum/decree/guild_charter_of_arms/proc/is_protected(mob/living/payer)
	if(!active || !payer)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	// Ratwood deviation: match the poll-tax mercenary roster, not a single title.
	return (payer.job in GLOB.mercenary_positions)

/datum/decree/guild_charter_of_arms/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	if(poll_category != POLL_TAX_CAT_MERCENARY)
		return current_rate
	if(!is_protected(payer))
		return current_rate
	return min(current_rate, GUILD_CHARTER_OF_ARMS_POLL_CAP)
