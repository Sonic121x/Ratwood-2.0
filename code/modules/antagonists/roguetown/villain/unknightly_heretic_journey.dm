/datum/antagonist/ukj_dark_itinerant
	name = "黑暗行者"
	roundend_category = "黑暗行者"
	antagpanel_category = "Dark Itinerant"
	job_rank = ROLE_DARK_ITINERANT
	confess_lines = list(
		"普赛顿就是造物伪神！",
		"十神都是一无是处的懦夫！",
		"十神都是骗子！",
	)
	rogue_enabled = TRUE

/datum/antagonist/ukj_dark_itinerant/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	if(!istype(H.patron, /datum/patron/inhumen))
		H.set_patron(/datum/patron/inhumen/zizo)//If you're not of the Inhumen before? You are now!
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.faction = list("undead")
			to_chat(owner, span_danger("永远都不够。苍白女士在下方低语，而我必将回应。"))
		if(/datum/patron/inhumen/matthios)
			to_chat(owner, span_danger("没有领主能支配我。千面者在阴影中低语，而我必将夺回应得之物。"))
		if(/datum/patron/inhumen/baotha)
			to_chat(owner, span_danger("何必压抑自己的欲望？放纵之女甜蜜地低语，而我必将回应。"))
		if(/datum/patron/inhumen/graggar)
			to_chat(owner, span_danger("弱者生来就是为了被征服。缚血之星嘶吼着渴求鲜血，而我必将掀起浩劫。"))

/datum/antagonist/ukj_dark_itinerant/varlet
	name = "扈从"
	roundend_category = "扈从"
	antagpanel_category = "Varlet"

/datum/antagonist/ukj_dark_itinerant/dark_chaplain
	name = "传道者"
	roundend_category = "传道者"
	antagpanel_category = "Wordbearer"
