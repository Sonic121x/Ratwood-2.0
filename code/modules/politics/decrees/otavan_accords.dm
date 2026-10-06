/datum/decree/otavan_accords
	id = DECREE_OTAVAN_ACCORDS
	name = "奥塔瓦协定"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "审判庭成员免缴所有税款。"
	flavor_text = {"奉十神之名，于全能众生之父注视之下，兹告天下：神圣奥塔瓦审判庭，作为立誓侍奉普赛顿者与正统教义的使者，应在这片土地警戒异端，保护谷地公国免受侵害，并向国家的领袖与人民提供忠告。特此授予审判庭审判外国人、因严重异端罪被公国制裁或宣布为法外之徒者，以及依王室或宫廷命令移交者的权利。准许神圣审判庭协助本地合法权力机关审理臣民，但贵族必须由王室审判。

作为回报，审判庭成员作为条约认可的外来信众，其人身与履职器具皆免于税负与征收；除在主教或议会面前提出合法理由外，王室不得妨碍其神圣职责。

于普赛顿与十神见证之下，钤王室之印颁行。"}
	revoke_text = "%RULER%已废止《奥塔瓦协定》。审判庭不再享有条约保护，而奥塔瓦绝不会轻易容忍这般侮辱。"
	restore_text = "%RULER%已重申《奥塔瓦协定》。神圣奥塔瓦审判庭恢复清除此地异端的职责，不受王室干涉。"

/datum/decree/otavan_accords/roll_initial_year()
	return 1492 // Canonical year

/datum/decree/otavan_accords/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(payer.job in GLOB.inquisition_positions)
		return TRUE
	return FALSE
