/datum/decree/great_writ
	id = DECREE_GREAT_WRIT
	name = "费伦提亚大敕令"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "贵族免缴所有税款与罚款。"
	flavor_text = {"本《费伦提亚大诏》，于阿斯特拉塔的太阳之下宣告，以拉沃克斯为见证，规定：本地拥有头衔的贵族，其血脉蒙阿斯特拉塔恩典赐福，人身与地产皆免于税负与征收。无头衔者及暂居于此的外国贵族不享有此豁免，应与其他臣民一样向王室缴纳。

作为回报，王国贵族应承担武备之责，亲自率领家臣保卫王国，无论何时都响应王室的战争召集，并向王座献上血脉与誓言所要求的忠诚。

于十神见证之下，钤王室之印颁行。"}
	revoke_text = "%RULER%已废止《大敕令》。王国贵族须向王室献上鲜血与黄金，任何血统都不得以受福为由免于缴纳。"
	restore_text = "%RULER%已续订《大敕令》。王国贵族再次免于征税，得以用武力而非钱币为王国效力。"

/datum/decree/great_writ/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(100, 200)

/datum/decree/great_writ/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_NOBLE) && payer.social_rank >= SOCIAL_RANK_NOBLE && !HAS_TRAIT(payer, TRAIT_OUTLANDER))
		return TRUE
	return FALSE
