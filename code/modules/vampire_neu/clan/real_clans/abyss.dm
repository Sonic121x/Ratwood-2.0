/// Baali from aliexpress
/datum/clan/abyss
	name = "深渊之子"
	desc = "深渊之子是崇拜古老恶魔的血族血脉。由于与邪秽之物亲近，他们在教会面前极为脆弱。"
	curse = "畏惧信仰。"
	clanicon = "daimonion"
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/demonic,
	)
	covens_to_select = 0

/datum/clan/abyss/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	. = ..()
	H.faction |= "Abyss"
	H.AddElement(/datum/element/holy_weakness)

/datum/clan/abyss/on_lose(mob/living/carbon/human/vampire)
	. = ..()
	vampire.faction -= "Abyss"
	vampire.RemoveElement(/datum/element/holy_weakness)

/datum/clan/abyss/get_downside_string()
	return "在阳光下或十神面前燃烧"

/datum/clan/abyss/get_frenzy_messages()
	return list(
		"古老恶魔低语着，给我的唯一指引便是[span_danger("鲜血")]。",
		"某种[span_danger("古老")]之物在我胸中舒展开来，邪恶而饥饿。",
		"我崇拜的黑暗借我伸出触手，它要[span_danger("进食")]。",
		"我的庇护者在深渊中蠢动——它们要我[span_userdanger("撕裂并痛饮")]。",
		"信仰与理智[span_danger("燃烧殆尽")]，只剩下黑暗的食欲。",
	)
