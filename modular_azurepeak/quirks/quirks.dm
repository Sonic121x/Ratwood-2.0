// Quirks are mostly for flavor or provide very little (or focused on roleplay) benefits.
// At best they should be very minor conveniences as a reward for leaning into vices.
// The baseline point_cost is one.

/datum/quirk/acquiredtastes
	name = "另类癖好"
	desc = "虽说我的口味有些不正统，但我总备着些小玩意儿，随时能招待客人。"
	custom_text = "该特质会在你的藏匿物中添加一个袋子，里面装着各式情趣器具，以及一小瓶余烬酒。"
	added_stashed_items = list("情趣器具袋" = /obj/item/storage/roguebag/fetish)

/datum/quirk/annoyingface
	name = "惹人厌的脸"
	desc = "我身负诅咒，嗓音与相貌都古怪得很。"
	point_cost = 0
	added_traits = list(TRAIT_COMICSANS)

/datum/quirk/deadnose
	name = "腐臭不觉"
	desc = "我的鼻子对腐败的气味毫无感觉。"
	added_traits = list(TRAIT_NOSTINK)
	incompatible_traits = list(TRAIT_NOSTINK)

/datum/quirk/disgracednoble
	name = "蒙羞贵族"
	desc = "很久以前……我曾是贵族后裔。如今我已沦为平民，家族姓氏也成了耻辱的来源。"
	added_traits = list(TRAIT_DISGRACED_NOBLE)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/dwarvenchef
	name = "矮人厨师"
	desc = "曾有个矮人教过我，如何从黄油面团里切出标准的椒盐卷饼。"
	custom_text = "让你能从黄油面团中切出椒盐卷饼。"
	warning_text = "如果你本就是矮人，该特质不会生效！"
	added_traits = list(TRAIT_DWARVEN_CHEF)

/datum/quirk/empath
	name = "善解人意"
	desc = "我能察觉他人的痛苦。"
	added_traits = list(TRAIT_EMPATH)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_traits = list(TRAIT_EMPATH)

/datum/quirk/fabledlover
	name = "传奇情人"
	desc = "与我同床共枕是一件幸运的事。"
	point_cost = 2
	added_traits = list(TRAIT_GOODLOVER)
	incompatible_virtues = list(/datum/virtue/utility/socialite, /datum/virtue/utility/performer)
	incompatible_traits = list(TRAIT_GOODLOVER)

/datum/quirk/gossiper
	name = "好事者"
	desc = "虽出身卑微，我却惯于与贵族往来，探听他们的秘密。"
	custom_text = "允许阅读贵族秘闻。"
	point_cost = 2
	added_traits = list(TRAIT_GOSSIPER)
	incompatible_virtues = list(/datum/virtue/utility/tracker)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/hobbyistmusician
	name = "业余乐手"
	desc = "这些年来我玩过些音乐，还给自己藏了一件乐器。"
	custom_text = "附带一件由你挑选的藏匿乐器。你在出生之后再选择具体乐器。"
	added_skills = list(list(/datum/skill/misc/music, 1, 6))

/datum/quirk/hobbyistmusician/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/customization_trait, pick_stashed_instrument), recipient), 50)

/datum/quirk/linguist
	name = "通晓三语"
	desc = "通过求学、旅行或机缘巧合，我学会了第三种语言。"
	custom_text = "开局额外掌握一种自选语言。"
	configurable = TRUE
	incompatible_quirks = list(/datum/quirk/quadrilingual)
	var/language

/datum/quirk/linguist/apply_to_human(mob/living/carbon/human/recipient)
	if(ispath(language, /datum/language))
		recipient.grant_language(language)

/datum/quirk/linguist/config_summary()
	if(!ispath(language, /datum/language))
		return "<b>语言</b>：尚未选择"
	var/datum/language/L = language
	return "<b>语言</b>：[initial(L.name)]"

/datum/quirk/linguist/save_config()
	return list("language" = language)

/datum/quirk/linguist/load_config(list/data, savefile/S)
	if(islist(data))
		language = string_to_typepath(data["language"])

/datum/quirk/linguist/configure(mob/user)
	var/datum/preferences/prefs = user.client?.prefs
	if(!prefs)
		return
	var/list/choices = prefs.get_language_choices()
	choices -= "无"
	var/choice = tgui_input_list(user, "选择语言：", "语言学者", choices)
	if(choice)
		language = choices[choice]

/datum/quirk/quadrilingual
	name = "通晓四语"
	desc = "我有着丰富的多语言经验！"
	custom_text = "开局额外掌握两种自选语言。"
	point_cost = 2
	configurable = TRUE
	incompatible_quirks = list(/datum/quirk/linguist)
	var/list/languages = list()

/datum/quirk/quadrilingual/apply_to_human(mob/living/carbon/human/recipient)
	for(var/language in languages)
		recipient.grant_language(language)

/datum/quirk/quadrilingual/config_summary()
	var/list/names = list()
	for(var/datum/language/L as anything in languages)
		names += initial(L.name)
	if(!length(names))
		return "<b>语言</b>：尚未选择"
	return "<b>语言</b>：[names.Join("、")]"

/datum/quirk/quadrilingual/save_config()
	return list("languages" = languages)

/datum/quirk/quadrilingual/load_config(list/data, savefile/S)
	languages = list()
	if(!islist(data) || !islist(data["languages"]))
		return
	for(var/language in data["languages"])
		var/language_path = string_to_typepath(language)
		if(ispath(language_path, /datum/language) && !(language_path in languages))
			languages += language_path

/datum/quirk/quadrilingual/configure(mob/user)
	var/datum/preferences/prefs = user.client?.prefs
	if(!prefs)
		return
	var/list/chosen = list()
	for(var/i in 1 to 2)
		var/list/choices = prefs.get_language_choices()
		choices -= "无"
		for(var/language_name in choices.Copy())
			if(choices[language_name] in chosen)
				choices -= language_name
		var/choice = tgui_input_list(user, "选择第 [i] 种语言（共2种）：", "通晓四语", choices)
		if(!choice)
			return
		chosen += choices[choice]
	languages = chosen

/datum/quirk/largeframe
	name = "骨架宽大"
	desc = "我天生就比大多数人长得高大。不过我的力量与耐力，却配不上这副身板。"
	custom_text = "该特质会增大你的角色贴图尺寸。与巨人美德不兼容。"
	point_cost = 3
	incompatible_virtues = list(/datum/virtue/size/giant)

/datum/quirk/largeframe/apply_to_human(mob/living/carbon/human/recipient)
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()

/datum/quirk/redolent
	name = "体味浓郁"
	desc = "我的体味浓重而独特。若不定期沐浴，旁人便会有所察觉……"
	point_cost = 1
	added_traits = list(TRAIT_REDOLENT)
	configurable = TRUE
	var/scent_type = "Neutral"
	var/scent = ""

/datum/quirk/redolent/apply_to_human(mob/living/carbon/human/recipient)
	recipient.redolent_scent_type = scent_type
	recipient.redolent_scent = scent

/datum/quirk/redolent/proc/default_scent(type)
	switch(type)
		if("Gross")
			return "腐肉与酸汗"
		if("Pleasant")
			return "野花与清新的雨水"
	return "泥土与汗水"

/datum/quirk/redolent/config_summary()
	return "<b>[get_update_choice_display(scent_type)]</b>：[scent || default_scent(scent_type)]"

/datum/quirk/redolent/save_config()
	return list("type" = scent_type, "scent" = scent)

/datum/quirk/redolent/load_config(list/data, savefile/S)
	if(islist(data))
		scent_type = data["type"]
		scent = data["scent"]
	// ppl will get pissed if they have 2 rewrite their stink text
	else if(S)
		S["redolent_type"] >> scent_type
		S["redolent_scent"] >> scent
		if(isnull(scent_type))
			S["malodorous_type"] >> scent_type
			S["malodorous_scent"] >> scent
	if(scent_type == "Positive")
		scent_type = "Pleasant"
	if(!(scent_type in list("Gross", "Neutral", "Pleasant")))
		scent_type = "Neutral"
	if(isnull(scent))
		scent = ""

/datum/quirk/redolent/configure(mob/user)
	var/new_scent_type = input_translation_choice(user, "选择他人对你气味的感受：", "体味浓郁", list("Gross", "Neutral", "Pleasant"))
	if(!new_scent_type)
		return
	var/scent_action = input_translation_choice(user, "描述气味：", "体味浓郁", list("Describe scent", "Use default"))
	if(!scent_action)
		return
	var/new_scent = default_scent(new_scent_type)
	if(scent_action == "Describe scent")
		var/leadin = "他们身上有一股气味："
		if(new_scent_type == "Gross")
			leadin = "他们身上散发着臭味："
		new_scent = tgui_input_text(user, "描述气味：", "体味浓郁", scent, max_length = 100, multiline = TRUE, preview_leadin = leadin)
		if(isnull(new_scent))
			return
		if(!length(trim(new_scent)))
			new_scent = default_scent(new_scent_type)
	scent_type = new_scent_type
	scent = new_scent
	to_chat(user, span_notice("已将我的体味设置为[get_update_choice_display(scent_type)]。"))

// Redolent scent state and behavior. This is purely quirk-driven now: the quirk applies
// TRAIT_REDOLENT, the mob holds the scent state, and life.dm drives handle_redolent_scent().
/mob/living/carbon/human
	/// How others perceive our scent: "Gross", "Neutral" or "Pleasant".
	var/redolent_scent_type = "Neutral"
	/// Player-written description of our scent.
	var/redolent_scent = ""
	/// Bathing suppresses our scent until this world.time.
	var/redolent_suppressed_until = 0
	/// The last time our scent aura pulsed.
	var/redolent_last_aura_tick = 0

/mob/living/carbon/human/proc/is_redolent_reeking()
	return HAS_TRAIT(src, TRAIT_REDOLENT) && world.time >= redolent_suppressed_until

/mob/living/carbon/human/proc/redolent_on_bath()
	redolent_suppressed_until = world.time + 30 MINUTES
	remove_status_effect(/datum/status_effect/debuff/redolent_stink)
	to_chat(src, span_notice("我洗去了身上的臭味，应该能清爽一阵子了。"))

/mob/living/carbon/human/proc/redolent_apply_contact_stink(mob/living/carbon/human/target)
	target.apply_status_effect(/datum/status_effect/debuff/stinky_contact, redolent_scent_type, redolent_scent)

/mob/living/carbon/human/proc/handle_redolent_scent()
	var/should_reek = is_redolent_reeking() && can_smell()

	if(should_reek && mind?.antag_datums)
		for(var/datum/antagonist/D in mind.antag_datums)
			if(istype(D, /datum/antagonist/vampire/lord) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie) || istype(D, /datum/antagonist/lich))
				should_reek = FALSE
				break

	if(should_reek && redolent_scent_type != "Pleasant")
		apply_status_effect(/datum/status_effect/debuff/redolent_stink)
	else
		remove_status_effect(/datum/status_effect/debuff/redolent_stink)

	if(!should_reek)
		return
	if(world.time < redolent_last_aura_tick + redolent_aura_tick_delay(redolent_scent_type))
		return
	redolent_last_aura_tick = world.time
	redolent_visual_effect(src, redolent_scent_type)
	redolent_stink_aura(src, redolent_scent_type)

/proc/redolent_aura_tick_delay(scent_type)
	return 30 SECONDS

/proc/redolent_examine_text(scent_type, scent)
	var/scent_text = html_encode(scent || "一股异样的气味")
	switch(scent_type)
		if("Gross")
			return span_greentext("对方身上散发着刺鼻的气味：[scent_text]。")
		if("Pleasant")
			return "<span style='color:#FFB6C1'>对方身上散发着[scent_text]。</span>"
	return "<span style='color:#d8cf8a'>对方身上散发着[scent_text]。</span>"

/proc/redolent_visual_effect(mob/living/carbon/human/H, scent_type)
	switch(scent_type)
		if("Gross")
			new /obj/effect/temp_visual/flies(get_turf(H))
		if("Pleasant")
			new /obj/effect/temp_visual/pleasant_scent(get_turf(H))

/proc/redolent_stink_aura(mob/living/carbon/human/H, scent_type)
	for(var/mob/living/nearby in view(2, H))
		if(nearby == H)
			continue
		if(nearby.stat)
			continue
		if(!nearby.can_smell())
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOSTINK))
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOBREATH))
			continue
		switch(scent_type)
			if("Gross")
				if(!nearby.has_stress_event(/datum/stressevent/stinky_aura))
					to_chat(nearby, "<span class='warning' style='color:#48c75a'>附近有什么东西散发着恶臭。</span>")
					nearby.add_stress(/datum/stressevent/stinky_aura)
			if("Neutral")
				if(!nearby.has_stress_event(/datum/stressevent/prominent_scent))
					to_chat(nearby, "<span class='warning' style='color:#d8cf8a'>空气中弥漫着一股浓重的气味。</span>")
					nearby.add_stress(/datum/stressevent/prominent_scent)
			if("Pleasant")
				if(!nearby.has_stress_event(/datum/stressevent/pleasant_scent))
					to_chat(nearby, "<span class='warning' style='color:#ffb6c1'>一股怡人的香气在空气中飘荡。</span>")
					nearby.add_stress(/datum/stressevent/pleasant_scent)

/datum/quirk/hunted
	name = "豺狼人的猎物"
	desc = "不知出于何种原因，我被认定成了值得格拉加尔的勇士们追猎的目标。无论走到哪里，我都能听见他们的狞笑。"
	warning_text = "<span style='font-size:120%;'>该特质会促使豺狼人来追杀你！</span><br>\
	你可能会在此过程中丧命！"
	point_cost = 0
	added_traits = list(TRAIT_GNOLL_HUNTED)
	var/attempts_left = 10

// I genuinely couldn't tell you why this needs to be a thing, but it existed when hunted was a vice.
// Therefore, we're keeping the behavior now that it's a quirk.
/datum/quirk/hunted/apply_to_human(mob/living/carbon/human/recipient)
	log_hunted_pick(recipient)

/datum/quirk/hunted/proc/log_hunted_pick(mob/living/carbon/human/H)
	if(!H.name) // The vice version of hunted used Life() for its timing, so deleted mobs would automatically stop timing.
		if(attempts_left <= 0) // We're not riding off of that anymore, so let's have it give up after ten attemps a la Lawless.
			return
		attempts_left--
		addtimer(CALLBACK(src, PROC_REF(log_hunted_pick), H), 1 SECONDS)
		return
	log_hunted("[H.ckey] playing as [H.name] had the hunted trait by quirk.")

/datum/quirk/assassintarget
	name = "追杀目标"
	desc = "我过去所做的某件事让我成了靶子。我总是提心吊胆，时时回头张望。"
	warning_text = "<span style='font-size:120%;'>该特质会促使刺客来追杀你！</span><br>\
	你可能会在此过程中被永久杀死，且毫无冲突升级的余地！"
	point_cost = 0
	added_traits = list(TRAIT_ASSASSIN_TARGET)

/datum/quirk/nightowl
	name = "夜猫子"
	desc = "比起他的另一半，我一向更偏爱诺克。"
	added_traits = list(TRAIT_NIGHT_OWL)

// Gives minor nobility, but what is a minor noble anyways?
// If we were being realistic then only the grand duke and baron would be real nobles.
// I guess we're saying that real nobility is people who are recognized by Astrata??????????
// Who fucking cares, bro.
/datum/quirk/noble
	name = "贵族"
	desc = "凭借出身、武艺或才智，我跻身贵族之列，尽管只是无爵位的旁支。我巧妙地藏好了一笔可观的钱财和一件传家宝。"
	custom_text = "此怪癖赋予你低等贵族身份；你仍须遵守大宪章并缴纳人头税。"
	point_cost = 4
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list(
	"传家护符" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
	"丰厚的钱袋" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch
	)
	incompatible_vices = list(/datum/charflaw/lawless)
	incompatible_quirks = list(/datum/quirk/disgracednoble, /datum/quirk/gossiper)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/noble/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15
	recipient.social_rank = max(recipient.social_rank, SOCIAL_RANK_MINOR_NOBLE)

/datum/quirk/outdoorsy
	name = "亲近野外"
	desc = "我在荒野中的经验，让我能像睡床铺一样，在树枝之类的地方安然入睡。"
	custom_text = "这并不会让树枝变成有效的床铺，也不会让你能在树枝上行走，只是说你可以在上面轻松入睡。"
	added_traits = list(TRAIT_OUTDOORSMAN)
	incompatible_virtues = list(/datum/virtue/utility/woodwalker)

/datum/quirk/pretty
	name = "清秀"
	desc = "我算不上绝世美人，但人们似乎很乐意多看我几眼。"
	point_cost = 2
	added_traits = list(TRAIT_PRETTY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly)
	incompatible_traits = list(TRAIT_BEAUTIFUL)

/datum/quirk/rawdiet
	name = "生食习性"
	desc = "不论是身体构造异于常人，还是耐受力格外奇怪，我都能若无其事地吃下生肉与未烹熟的食物。"
	custom_text = "食用生肉与未烹熟的食物不会中毒。腐坏食物、内脏和脏水仍会使你中毒。"
	point_cost = 2
	added_traits = list(TRAIT_RAW_EATER)
	incompatible_virtues = list(/datum/virtue/utility/feral_appetite)
	incompatible_traits = list(TRAIT_NASTY_EATER, TRAIT_ORGAN_EATER, TRAIT_WILD_EATER)

/datum/quirk/roughlover
	name = "粗暴情人"
	desc = "当我意图强烈时，我会成为床上粗暴的伴侣，连骨盆与意志都能一并摧折。"
	point_cost = 2
	added_traits = list(TRAIT_DEATHBYSNUSNU)
	incompatible_traits = list(TRAIT_DEATHBYSNUSNU)

/datum/quirk/scarred
	name = "满脸疤痕"
	desc = "我的脸上布满可怖的疤痕，让人很难辨认我的身份，但并非完全无从辨认。"
	point_cost = 0
	added_traits = list(TRAIT_SCARRED)

/datum/quirk/secondvoice
	name = "第二副嗓音"
	desc = "无论是出自表演、行骗，还是出于某种想以诡异方式改变自己的需求，你获得了第二副完美的嗓音。你可以随时在两者之间切换。"
	custom_text = "解锁新的「记忆」页签，其中会有设置与更换嗓音的选项。"
	incompatible_vices = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)

/datum/quirk/secondvoice/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/changevoice
	recipient.verbs += /mob/living/carbon/human/proc/swapvoice

/datum/quirk/tolerant
	name = "宽容"
	desc = "无论源于游历还是关怀，你都不觉得某些族群有什么问题。"
	custom_text = "观察某些种族或出身的人时，不会产生负面压力或歧视性打量文本。"
	point_cost = 0
	added_traits = list(TRAIT_TOLERANT)

/datum/quirk/ugly
	name = "丑陋"
	desc = "我的面容丑陋不堪，谁看见我都会心生厌恶。"
	point_cost = 0
	added_traits = list(TRAIT_UNSEEMLY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)

/datum/quirk/underdarkchef
	name = "幽暗地域厨师"
	desc = "我从幽暗地域学到了几手烹饪的秘法。蛛肉可比你想的要百搭得多。"
	custom_text = "让你能制作以蛛肉为材料的菜谱。"
	warning_text = "如果你本就是卓尔，该特质不会生效！"
	added_traits = list(TRAIT_UNDERDARK_CHEF)

/datum/quirk/unsettling
	name = "令人不安"
	desc = "我的外表让大多数人深感不安。我的面容有种极其不对劲的感觉。"
	point_cost = 1
	added_traits = list(TRAIT_UNSETTLING)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly, /datum/quirk/pretty)

/datum/quirk/selfaware
	name = "自知伤势"
	desc = "我始终清楚自己的身体伤得有多重。"
	added_traits = list(TRAIT_SELF_AWARE)
	incompatible_traits = list(TRAIT_SELF_AWARE)
