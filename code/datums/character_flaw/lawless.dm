/datum/charflaw/lawless
	name = "无法无天"
	desc = "我一直觉得规矩更像建议而不是真正的规则，也早已恶名昭彰到脑袋上挂了悬赏。（若你的职业开局本就自带悬赏，再选这个缺陷会改为随机缺陷。）"
	configurable = TRUE
	var/face_known = "他们认得我的脸"
	var/bounty_poster = "司法厅"
	var/bounty_severity = "Misdeed"
	var/my_crime = ""

/datum/charflaw/lawless/proc/poster_options()
	return list("司法厅" = "[SSmapping.map_adjustment?.realm_name]司法厅", "Holy See" = "格伦泽尔霍夫特教廷", "Orthodoxy" = "奥塔瓦正教会")

/datum/charflaw/lawless/config_summary()
	return "<b>面容</b>: [face_known]<br><b>悬赏发布者</b>: [poster_options()[bounty_poster] || bounty_poster]<br><b>严重程度</b>: [get_update_choice_display(bounty_severity)]<br><b>罪名</b>: [my_crime || "冒犯王权之罪"]"

/datum/charflaw/lawless/save_config()
	return list("face_known" = face_known, "bounty_poster" = bounty_poster, "bounty_severity" = bounty_severity, "my_crime" = my_crime)

/datum/charflaw/lawless/load_config(list/data)
	if(!islist(data))
		return
	if(data["face_known"] in list("他们认得我的脸", "他们只知道我的体貌特征"))
		face_known = data["face_known"]
	if(data["bounty_poster"] in poster_options())
		bounty_poster = data["bounty_poster"]
	if(data["bounty_severity"] in list("轻罪", "伤人害命", "骇人暴行"))
		bounty_severity = data["bounty_severity"]
	my_crime = data["my_crime"]

/datum/charflaw/lawless/configure(mob/user)
	var/choice = tgui_input_list(user, "当局知道你的长相吗？", "暴露程度", list("他们认得我的脸", "他们只知道我的体貌特征"), face_known)
	if(choice)
		face_known = choice
	choice = input_translation_choice(user, "是谁悬赏缉拿你？", "悬赏发布者", poster_options())
	if(choice)
		bounty_poster = choice
	choice = tgui_input_list(user, "你的罪行有多严重？", "悬赏金额", list("轻罪", "伤人害命", "骇人暴行"), bounty_severity)
	if(choice)
		bounty_severity = choice
	var/crime = tgui_input_text(user, "你的罪名是什么？", "罪名", my_crime, 100)
	if(!isnull(crime))
		my_crime = crime

/datum/charflaw/lawless/on_mob_creation(mob/H)
	if(istype(H, /mob/living/carbon/human/dummy)) // DON'T TRY TO APPLY THIS FUCKING FLAW TO PREVIEW DUMMIES HOLY SHIT
		return
	addtimer(CALLBACK(src, PROC_REF(set_up), H), 30 SECONDS)

/datum/charflaw/lawless/proc/set_up(mob/living/carbon/human/H)
	if (has_bounty(H) || (H.job && H.job == "Wretch") || (H.advjob && H.advjob == "Wanted") || (H.job && H.job == "Bandit"))
		// no doubling up on this stuff, you just get a random flaw instead.
		var/list/flaws_without_random = GLOB.character_flaws.Copy()
		flaws_without_random -= "随机或无缺陷"
		var/datum/charflaw/our_new_flaw = GLOB.character_flaws[pick(flaws_without_random)]
		H.charflaw = new our_new_flaw()
		H.charflaw.on_mob_creation(H)
		to_chat(H, span_warning("无法无天带来的刺激已经不够了……命运将我的缺陷改写为：<b>[H.charflaw.name]</b>。"))
		return

	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(100, 200)
	switch(bounty_severity)
		if("轻罪")
			bounty_total = rand(50, 100)
		if("伤人害命")
			bounty_total = rand(100, 150)
		if("骇人暴行")
			bounty_total = rand(150, 200)
	var/poster_name = poster_options()[bounty_poster]
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime || "冒犯王权之罪", poster_name)
	if(HAS_TRAIT(H, TRAIT_NOBLE))
		REMOVE_TRAIT(H, TRAIT_NOBLE, JOB_TRAIT)
		REMOVE_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		REMOVE_TRAIT(H, TRAIT_NOBLE, ADVENTURER_TRAIT)
		ADD_TRAIT(H, TRAIT_DISGRACED_NOBLE, TRAIT_GENERIC)
		H.is_noble()
	if (face_known == "他们认得我的脸")
		if(bounty_poster == "司法厅")
			GLOB.outlawed_players += H.real_name
		else
			GLOB.excommunicated_players += H.real_name
	to_chat(H, span_notice("我的脑袋值上一笔玛门币……最好先避避风头。"))
