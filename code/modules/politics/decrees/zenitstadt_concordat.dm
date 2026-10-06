/datum/decree/zenitstadt_concordat
	id = DECREE_ZENITSTADT_CONCORDAT
	name = "天顶城协约"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "教会神职人员与获认定的信仰恩主免缴所有税款。"
	flavor_text = {"本《天顶城教约》，蒙十神恩典、以拉沃克斯为见证立誓，规定：谷地教会受十神祝圣、沐阿斯特拉塔之光，应在这片土地维护诸神的和平，昼夜祈求王国安宁繁荣，以适当的圣礼与供奉维系十神恩眷，向教内同道收取什一税，庇护贫困受压迫者，并设立自己的圣堂骑士团，使王国共同防御不致匮乏。

作为回报，谷地教会神职人员作为诸神的神圣使者、立誓侍奉十神之人，其人身与信仰产业皆免于税负与征收；除与十神教会依法商议外，王室不得干涉教会内部纪律。

于十神见证之下，钤王室之印颁行。"}
	revoke_text = "%RULER%已撤销《天顶城协约》。教会的财富应服务于王国的共同福祉，至于究竟是谁背叛了谁，就让十神裁决。"
	restore_text = "%RULER%已重申《天顶城协约》。王室不再干涉教会世俗财富的处置。"

/datum/decree/zenitstadt_concordat/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(50, 120)

/datum/decree/zenitstadt_concordat/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(payer.job in GLOB.church_positions)
		return TRUE
	if(HAS_TRAIT(payer, TRAIT_AGENT_CHURCH))
		return TRUE
	return FALSE
