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
	name = "Dead Nose"
	desc = "My nose is numb to the smell of decay."
	added_traits = list(TRAIT_NOSTINK)
	incompatible_traits = list(TRAIT_NOSTINK)

/datum/quirk/disgracednoble
	name = "Disgraced Noble"
	desc = "I was a scion of a noble house... long ago. Now I am a commoner, and my family name is a source of shame."
	added_traits = list(TRAIT_DISGRACED_NOBLE)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/dwarvenchef
	name = "矮人厨师"
	desc = "曾有个矮人教过我，如何从黄油面团里切出标准的椒盐卷饼。"
	custom_text = "让你能从黄油面团中切出椒盐卷饼。"
	warning_text = "如果你本就是矮人，该特质不会生效！"
	added_traits = list(TRAIT_DWARVEN_CHEF)

/datum/quirk/empath
	name = "Empath"
	desc = "I can notice when people are in pain."
	added_traits = list(TRAIT_EMPATH)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_traits = list(TRAIT_EMPATH)

/datum/quirk/fabledlover
	name = "Fabled Lover"
	desc = "It's a lucky thing to share my bed."
	point_cost = 2
	added_traits = list(TRAIT_GOODLOVER)
	incompatible_virtues = list(/datum/virtue/utility/socialite, /datum/virtue/utility/performer)
	incompatible_traits = list(TRAIT_GOODLOVER)

/datum/quirk/gossiper
	name = "Gossiper"
	desc = "Despite my lowborn blood, I've made a habit out of brushing shoulders with the nobility and learning their secrets."
	custom_text = "Lets you view noble gossip."
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
	name = "Trilingual"
	desc = "Through education, travel, or circumstance, I have picked up a third language."
	custom_text = "Start with one extra language of your choice."
	configurable = TRUE
	incompatible_quirks = list(/datum/quirk/quadrilingual)
	var/language

/datum/quirk/linguist/apply_to_human(mob/living/carbon/human/recipient)
	if(ispath(language, /datum/language))
		recipient.grant_language(language)

/datum/quirk/linguist/config_summary()
	if(!ispath(language, /datum/language))
		return "<b>Language</b>: None chosen"
	var/datum/language/L = language
	return "<b>Language</b>: [initial(L.name)]"

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
	choices -= "None"
	var/choice = tgui_input_list(user, "Choose Language:", "Linguist", choices)
	if(choice)
		language = choices[choice]

/datum/quirk/quadrilingual
	name = "Quadrilingual"
	desc = "I have an abundance of experience with different languages!"
	custom_text = "Start with two extra languages of your choice."
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
		return "<b>Languages</b>: None chosen"
	return "<b>Languages</b>: [names.Join(", ")]"

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
		choices -= "None"
		for(var/language_name in choices.Copy())
			if(choices[language_name] in chosen)
				choices -= language_name
		var/choice = tgui_input_list(user, "Choose language [i] of 2:", "Quadrilingual", choices)
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
			return "rotting meat and sour sweat"
		if("Pleasant")
			return "wildflowers and clean rain"
	return "earth and sweat"

/datum/quirk/redolent/config_summary()
	return "<b>[scent_type]</b>: [scent || default_scent(scent_type)]"

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
	var/new_scent_type = tgui_input_list(user, "Choose how others perceive your scent:", "Redolent", list("Gross", "Neutral", "Pleasant"))
	if(!new_scent_type)
		return
	var/scent_action = tgui_input_list(user, "Describe the scent:", "Redolent", list("Describe scent", "Use default"))
	if(!scent_action)
		return
	var/new_scent = default_scent(new_scent_type)
	if(scent_action == "Describe scent")
		var/leadin = "They smell of"
		if(new_scent_type == "Gross")
			leadin = "They reek of"
		new_scent = tgui_input_text(user, "Describe the scent:", "Redolent", scent, max_length = 100, multiline = TRUE, preview_leadin = leadin)
		if(isnull(new_scent))
			return
		if(!length(trim(new_scent)))
			new_scent = default_scent(new_scent_type)
	scent_type = new_scent_type
	scent = new_scent
	to_chat(user, span_notice("Set my Redolent scent to [scent_type]."))

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
	name = "Noble"
	desc = "By birth, blade or brain, I carry noble blood, if only a minor and untitled line of it. I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	custom_text = "This quirk grants you MINOR nobility, meaning you are still subjected to the Great Writ and poll tax."
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
	name = "Pretty"
	desc = "I'm no great beauty, but people seem to like looking at my face well enough."
	point_cost = 2
	added_traits = list(TRAIT_PRETTY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly)
	incompatible_traits = list(TRAIT_BEAUTIFUL)

/datum/quirk/rawdiet
	name = "Raw Diet"
	desc = "Be it from unnatural anatomy or simply a bizarre tolerance, I can eat raw meat and uncooked food as if it were natural."
	custom_text = "Lets you eat raw meat and uncooked food without getting poisoned. Rotten food, organs, and dirty water will still poison you."
	point_cost = 2
	added_traits = list(TRAIT_RAW_EATER)
	incompatible_virtues = list(/datum/virtue/utility/feral_appetite)
	incompatible_traits = list(TRAIT_NASTY_EATER, TRAIT_ORGAN_EATER, TRAIT_WILD_EATER)

/datum/quirk/roughlover
	name = "Rough Lover"
	desc = "With strong intent, I am a violent partner in bed. Breaking pelvis and spirit alike."
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
	name = "Tolerant"
	desc = "Whether fostered through travel or care, you just don't see an issue with certain folks."
	custom_text = "Prevents you from experiencing negative stress events or examine text when looking at select species and origins."
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
	name = "Self Aware"
	desc = "I've always been conscious about how hurt my body can get."
	added_traits = list(TRAIT_SELF_AWARE)
	incompatible_traits = list(TRAIT_SELF_AWARE)
