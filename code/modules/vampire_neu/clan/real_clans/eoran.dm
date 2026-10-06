/// Toreador from Temu.
/datum/clan_leader/eoran
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/cabbit,
	)
	lord_title = "Elder"

/datum/clan/eoran
	name = "维塔贝拉家族"
	desc = "伊欧拉被你对艺术与美的不懈追求打动，为你受诅咒的血脉赐下祝福。然而，祂的赞赏让祂忽略了你本性中更阴暗的部分：扭曲的爱情观，以及妄自尊大的幻想。 "
	curse = "沉迷虚荣，渴望被爱"
	clanicon = "eoran"
	blood_preference = BLOOD_PREFERENCE_ALL
	extra_clan_traits = list(
		TRAIT_BEAUTIFUL,
		TRAIT_EMPATH,
		TRAIT_EXTEROCEPTION,
	)

	clane_covens = list(
		/datum/coven/presence,
		/datum/coven/eora,
		/datum/coven/siren
	)
	leader = /datum/clan_leader/eoran
	covens_to_select = 0

/datum/clan/eoran/get_blood_preference_string()
	return "普通血液，以及所爱之人的血液"

/datum/clan/eoran/get_downside_string()
	return "你是完美的，没有任何弱点。"

/datum/clan/eoran/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)

/datum/clan/eoran/get_frenzy_messages()
	return list(
		"他们的美让我[span_danger("疯狂")]——我要占有它，将它饮尽。",
		"被崇拜还不够。野兽想要他们[span_danger("毁坏")]，并属于我。",
		"我的镇定如瓷器般碎裂，某种[span_danger("丑恶")]之物从裂隙中咧嘴而笑。",
		"伊欧拉的馈赠变质为[span_userdanger("执念")]；我必须占有对方的一切。",
		"虚荣与[span_danger("饥渴")]交织，直到我再也分不清它们。",
	)
