/datum/decree/golden_bull
	id = DECREE_GOLDEN_BULL
	name = "王田金玺诏书"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "市民与居民的税款及罚款最高按余额的25%计收，每日罚款上限为50m，人头税亦设上限。"
	flavor_text = {"本《王田金玺诏书》，于阿斯特拉塔的太阳之下钤印，以拉沃克斯为见证，记录谷地王室与财富创造者之间的古老契约。

以谷地大公之名，并由腐木谷名流与市民议会正式集会钤印，特此确认：议会同意自本年至永久，王室向市民征收的款项不得超过其神经锁账户的四分之一，每日罚金不得超过五十玛门币，每日人头税不得超过二十玛门币；此限额适用于和平、战争及紧急之时。除依本地法律外，不得超出这些界限对市民征税或剥夺其财富。

作为回报，谷地市民应每年提供预算，用于共同保卫王国，抵御海盗、匪徒及其他威胁和平的恶人；款项按成员财富募集，由市民自身议会分配。

若王室超出此批准的界限，或以其他方式违反特许状，市民便免除该义务，使王国知晓背弃财富创造者的代价。

钤王室之印颁行。"}
	revoke_text = "%RULER%已暂停《王田金玺诏书》。市民将全额承担王室征税，愤怒的商人也不再为王国的共同防务出资。"
	restore_text = "%RULER%已恢复《王田金玺诏书》。协约重新生效，市民再次为共同防务进贡。"

/datum/decree/golden_bull/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(40, 100)

/datum/decree/golden_bull/apply_rate_cap(mob/living/payer, tax_category, current_cap)
	if(!is_protected_by_bull(payer))
		return current_cap
	return min(current_cap, GOLDEN_BULL_BURGHER_CAP)

/// Per-stroke mammon ceiling for Bull-protected subjects. Combined with the realm's
/// one-fine-per-day rule this becomes an effective daily cap.
/datum/decree/golden_bull/apply_daily_fine_cap(mob/living/payer, current_remaining)
	if(!is_protected_by_bull(payer))
		return current_remaining
	return min(current_remaining, GOLDEN_BULL_DAILY_FINE_CAP)

/// Cap the Burgher poll-tax daily charge at GOLDEN_BULL_POLL_CAP.
/datum/decree/golden_bull/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	if(poll_category != POLL_TAX_CAT_BURGHER)
		return current_rate
	return min(current_rate, GOLDEN_BULL_POLL_CAP)

/// Returns TRUE if the payer is currently shielded by the Golden Bull.
/datum/decree/golden_bull/proc/is_protected_by_bull(mob/living/payer)
	if(!active)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_RESIDENT))
		return TRUE
	// Ratwood deviation: no GLOB.wanderer_positions - use the poll-tax adventurer roster.
	if(payer.job in list("Adventurer", "Court Agent", "Pilgrim"))
		return FALSE
	if(payer.job in GLOB.mercenary_positions)
		return FALSE
	return TRUE

