/datum/decree/magna_carta
	id = DECREE_MAGNA_CARTA
	name = "大宪章"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "取消王室的所有征税与人头税，保留罚款。王室仅收取自愿进贡。"
	active = FALSE
	flavor_text = {"蒙阿斯特拉塔恩典，谷地%RULER%、王田、黑林与盐镇伯爵、玫瑰林、%REGION_ROCKHILL%与愚沼宗主、荒凉海岸、北堡与赤心保护者、十神捍卫者%RULER_NAME%，向其大主教、祭司、圣堂武士、审判官、公爵、王子、配偶、首相、总管、议员、书记员、元帅、骑士、军士、武装侍从、守卫、扈从、宫廷法师、档案员、药剂师、首席医师、商人、旅店老板、浴场主人、行会成员、市民、居民、农夫、农人、厨师、酒保、浴女、仆役、土之子、雇佣兵、冒险者、朝圣者，以及一切官员与忠诚臣民致以问候。

兹告天下：为我等灵魂的安康、王国的共同福祉、十神的荣耀、神圣教会的兴隆，以及王国秩序的完善，我等恩准谷地每一位臣民，无论等级、身份或出身，其人身、地产、货物、劳作、职业及所用器具，皆不承担任何税款、征收、关税或其他财政负担，无论以钱币还是实物缴纳。

作为回报，谷地臣民应在心中记念王室，于合宜之时赞扬其名，并在良心促使、天候允许之时，各按自己认为适宜的数额与时间奉上收入。

钤本年%RULER%%RULER_NAME%之印颁行，后世当以此记念其人。"}
	revoke_text = "诸位听令。蒙阿斯特拉塔恩典，谷地%RULER%、王田、黑林与盐镇伯爵、玫瑰林、%REGION_ROCKHILL%与愚沼宗主、荒凉海岸、北堡与赤心保护者、十神捍卫者%RULER_NAME%，今日废止《大宪章》。王国臣民恢复原有财政义务，王室收入亦相应恢复。此事应载入记录，以示%RULER_NAME%的重新裁定。"
	// restore_text intentionally unset - broadcast_state_change is overridden below so that
	// restoring the Carta reads the full charter aloud, ruler's name and all. That's the joke.
	/// Pre-Carta tax rates, snapshotted the first time the charter is restored so that
	/// revoking it can hand the Crown's revenue back "in kind." Null until first restore.
	var/list/saved_tax_rates = null
	/// Pre-Carta poll tax rates, snapshotted alongside saved_tax_rates.
	var/list/saved_poll_rates = null

/datum/decree/magna_carta/roll_initial_year()
	return CALENDAR_EPOCH_YEAR

/datum/decree/magna_carta/on_restore()
	. = ..()
	// Snapshot the current rates BEFORE zeroing so on_revoke() can restore them. Only take
	// the snapshot once - a second restore (after a revoke) must not clobber the real rates
	// with the already-zeroed values, and on_revoke() clears the snapshot when it hands back.
	if(isnull(saved_tax_rates))
		saved_tax_rates = list(
			TAX_CATEGORY_CONTRACT_LEVY = SStreasury.tax_rates[TAX_CATEGORY_CONTRACT_LEVY],
			TAX_CATEGORY_HEADEATER_LEVY = SStreasury.tax_rates[TAX_CATEGORY_HEADEATER_LEVY],
			TAX_CATEGORY_IMPORT_TARIFF = SStreasury.tax_rates[TAX_CATEGORY_IMPORT_TARIFF],
			TAX_CATEGORY_EXPORT_DUTY = SStreasury.tax_rates[TAX_CATEGORY_EXPORT_DUTY],
		)
	if(isnull(saved_poll_rates))
		saved_poll_rates = SStreasury.poll_tax_rates.Copy()
	SStreasury.tax_rates[TAX_CATEGORY_CONTRACT_LEVY] = 0
	SStreasury.tax_rates[TAX_CATEGORY_HEADEATER_LEVY] = 0
	SStreasury.tax_rates[TAX_CATEGORY_IMPORT_TARIFF] = 0
	SStreasury.tax_rates[TAX_CATEGORY_EXPORT_DUTY] = 0
	// Fines stay at their configured rate - the Crown can still punish.
	for(var/category in SStreasury.poll_tax_rates)
		SStreasury.poll_tax_rates[category] = 0

/datum/decree/magna_carta/on_revoke()
	. = ..()
	// Restore the rates the Crown levied before the Carta zeroed them - "revenue restored in kind."
	if(!isnull(saved_tax_rates))
		for(var/category in saved_tax_rates)
			SStreasury.tax_rates[category] = saved_tax_rates[category]
		saved_tax_rates = null
	if(!isnull(saved_poll_rates))
		for(var/category in saved_poll_rates)
			SStreasury.poll_tax_rates[category] = saved_poll_rates[category]
		saved_poll_rates = null

/datum/decree/magna_carta/broadcast_state_change()
	if(!active)
		return ..()
	var/body = get_display_flavor_text()
	if(!body)
		return ..()
	priority_announce(body, "BY LORDLY MERCY", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)
