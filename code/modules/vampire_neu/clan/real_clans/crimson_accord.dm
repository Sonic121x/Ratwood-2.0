/// Banu Haqim from Temu.
/datum/clan/crimson_fang
	name = "绯红之牙"
	desc = "其他血族常将绯红之牙视为危险的刺客与噬魂者，但他们其实是守护者、战士和学者，致力于远离血族与凡俗世界的政治纷争。"
	curse = "鲜血成瘾。"
	clanicon = "presence"
	clane_covens = list(
		/datum/coven/celerity,
		/datum/coven/obfuscate,
		/datum/coven/quietus
	)
	covens_to_select = 0

/datum/clan/crimson_fang/get_frenzy_messages()
	return list(
		"[span_danger("瘾欲")]在我血管中尖叫，我的自制力逐渐崩溃。",
		"我立下的一切誓言，都被渴求[span_danger("鲜血")]的咆哮淹没。",
		"即使我哀求双手停下，它们仍记得如何[span_danger("杀戮")]。",
		"战士的冷静支离破碎，内心的[span_userdanger("瘾君子")]只想饱餐一顿。",
		"猩红的[span_danger("渴望")]淹没了我，胜过任何誓言。",
	)
