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

/datum/quirk/ovipositor
	name = "卵生"
	desc = "我的种族通过产卵繁殖。受孕会使我体内充满卵。若我有阴茎，我会在射精时把卵注入伴侣体内。"
	point_cost = 0
	added_traits = list(TRAIT_OVIPOSITOR)
	// there MUSTN'T be egg-laying humens. I shan't stand for it !
	allowed_species = list(/datum/species/anthromorph, /datum/species/kobold, /datum/species/harpy, /datum/species/akula, /datum/species/anthromorphsmall, /datum/species/lamia, /datum/species/arachnid, /datum/species/dullahan, /datum/species/ooze, /datum/species/moth)

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
	var/scent_type = REDOLENT_SMELL_NEUTRAL
	var/scent = ""

/datum/quirk/redolent/apply_to_human(mob/living/carbon/human/recipient)
	var/datum/status_effect/redolent/strong_smell = recipient.apply_status_effect(/datum/status_effect/redolent)
	strong_smell.redolent_scent_type = scent_type
	strong_smell.redolent_scent = scent
	if(!length(scent))
		strong_smell.redolent_scent = get_default_redolent_scent(scent_type)

/datum/quirk/redolent/config_summary()
	return "<b>[get_update_choice_display(scent_type)]</b>：[scent || get_default_redolent_scent(scent_type)]"

/datum/quirk/redolent/save_config()
	return list("scent_type" = scent_type, "scent" = scent)

/datum/quirk/redolent/load_config(list/data, savefile/S)
	if(islist(data))
		scent_type = data["scent_type"]
		scent = data["scent"]
	// ppl will get pissed if they have 2 rewrite their stink text
	else if(S)
		S["redolent_type"] >> scent_type
		S["redolent_scent"] >> scent
		if(isnull(scent_type))
			S["malodorous_type"] >> scent_type
			S["malodorous_scent"] >> scent
	if(scent_type in list("Positive", "舒适", "正常", "恶心")) // 自定义修改：读取旧存档时还原气味类型的内部键
		scent_type = scent_type == "恶心" ? REDOLENT_SMELL_BAD : (scent_type == "正常" ? REDOLENT_SMELL_NEUTRAL : REDOLENT_SMELL_GOOD)
	if(!(scent_type in REDOLENT_SMELLS))
		scent_type = REDOLENT_SMELL_NEUTRAL
	if(isnull(scent))
		scent = ""

/datum/quirk/redolent/configure(mob/user)
	var/new_scent_type = input_translation_choice(user, "选择他人对你气味的感受：", "体味浓郁", REDOLENT_SMELLS)
	if(!new_scent_type)
		return
	var/scent_action = input_translation_choice(user, "描述气味：", "体味浓郁", list("Describe scent", "Use default"))
	if(!scent_action)
		return
	var/new_scent = get_default_redolent_scent(new_scent_type)
	if(scent_action == "Describe scent")
		var/leadin = "他们身上有一股气味："
		if(new_scent_type == REDOLENT_SMELL_BAD)
			leadin = "他们散发着："
		new_scent = tgui_input_text(user, "描述气味：", "体味浓郁", scent, max_length = 100, multiline = TRUE, preview_leadin = leadin)
		if(isnull(new_scent))
			return
		if(!length(trim(new_scent)))
			new_scent = get_default_redolent_scent(new_scent_type)
	scent_type = new_scent_type
	scent = new_scent
	to_chat(user, span_notice("已将我的体味设置为[get_update_choice_display(scent_type)]。"))

/datum/quirk/redolent/proc/get_default_redolent_scent(scent_type)
	switch(scent_type)
		if(REDOLENT_SMELL_GOOD)
			return "野花和清洁的雨"
		if(REDOLENT_SMELL_NEUTRAL)
			return "土地与汗水"
		if(REDOLENT_SMELL_BAD)
			return "腐烂的肉和酸汗"

/datum/status_effect/redolent
	id = "redolent"
	duration = 999 MINUTES
	alert_type = null

	/// How others perceive our scent
	var/redolent_scent_type = REDOLENT_SMELL_NEUTRAL
	/// Player-written description of our scent.
	var/redolent_scent = null
	/// If the smell is currently suppressed
	COOLDOWN_DECLARE(smell_suppressed)
	/// Cooldown before we emit another scent to people around
	COOLDOWN_DECLARE(emit_scent)

/datum/status_effect/redolent/process(wait)
	. = ..()
	if(!COOLDOWN_FINISHED(src, smell_suppressed))
		return
	emit_smell()

/// Temporarily suppressed the status and particle effects for a time after being cleaned
/datum/status_effect/redolent/proc/on_wash(mob/cleaner)
	if(cleaner == owner)
		to_chat(owner, span_notice("我洗去了身上的臭味，应该能清爽一阵子了。"))
	else
		to_chat(cleaner, span_notice("我洗掉他们的臭味，但他们很快又会再次发臭。"))
		to_chat(owner, span_notice("[cleaner] 给我洗了个正经的澡。我的气味会被抑制一段时间。"))

	COOLDOWN_START(src, smell_suppressed, 30 MINUTES)

/datum/status_effect/redolent/proc/get_examine_text()
	if(!COOLDOWN_FINISHED(src, smell_suppressed)) // Means they have been washed so not currently stinky
		return
	var/scent_text = "一股异样的气味"
	if(!isnull(redolent_scent))
		scent_text = html_encode(redolent_scent)
	switch(redolent_scent_type)
		if(REDOLENT_SMELL_GOOD)
			return "<span style='color:#FFB6C1'>他们闻起来像 [scent_text].</span>"
		if(REDOLENT_SMELL_NEUTRAL)
			return "<span style='color:#d8cf8a'>他们闻起来像 [scent_text].</span>"
		if(REDOLENT_SMELL_BAD)
			return span_greentext("他们散发着[scent_text]的气味。")

/// Called by process, emits our scent
/datum/status_effect/redolent/proc/emit_smell()
	if(!COOLDOWN_FINISHED(src, emit_scent))
		return
	COOLDOWN_START(src, emit_scent, 30 SECONDS)

	// Emits the visual effect
	switch(redolent_scent_type)
		if(REDOLENT_SMELL_GOOD)
			new /obj/effect/temp_visual/pleasant_scent(get_turf(owner))
		if(REDOLENT_SMELL_BAD)
			new /obj/effect/temp_visual/flies(get_turf(owner))

	// Emits a stench in an AOE
	for(var/mob/living/nearby in view(2, owner))
		if(nearby == owner) // Immune to your own stench
			continue
		if(nearby.stat) // Unconscious can't smell
			continue
		if(HAS_TRAIT(nearby, TRAIT_MISSING_NOSE)) // No nose
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOSTINK)) // Numb to smells
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOBREATH)) // Can't breath / Holding breath
			continue
		switch(redolent_scent_type)
			if(REDOLENT_SMELL_GOOD)
				if(!nearby.has_stress_event(/datum/stressevent/pleasant_scent))
					to_chat(nearby, "<span class='warning' style='color:#ffb6c1'>一股怡人的香气在空气中飘荡。</span>")
					nearby.add_stress(/datum/stressevent/pleasant_scent)
			if(REDOLENT_SMELL_NEUTRAL)
				if(!nearby.has_stress_event(/datum/stressevent/prominent_scent))
					to_chat(nearby, "<span class='warning' style='color:#d8cf8a'>空气中有一股显著的气味。</span>")
					nearby.add_stress(/datum/stressevent/prominent_scent)
			if(REDOLENT_SMELL_BAD)
				if(!nearby.has_stress_event(/datum/stressevent/stinky_aura))
					to_chat(nearby, "<span class='warning' style='color:#48c75a'>附近有东西发臭。</span>")
					nearby.add_stress(/datum/stressevent/stinky_aura)

/// Applies our stench to someone else
/datum/status_effect/redolent/proc/apply_on_contact(mob/living/carbon/human/target)
	if(!COOLDOWN_FINISHED(src, smell_suppressed)) // Can't spread a smell we don't have
		return
	// Step 1: Check to see if they have OUR smell
	for(var/datum/status_effect/redolent/stinky_contact/stink_to_check in target.has_status_effect_list(/datum/status_effect/redolent/stinky_contact))
		if(stink_to_check.redolent_scent == redolent_scent) // Check if they have our custom string
			// If they do, we refresh their smell
			stink_to_check.refresh()
			return

	// Step 2: Apply our smell if they don't already have ours
	var/datum/status_effect/redolent/stinky_contact/applied_smell = target.apply_status_effect(/datum/status_effect/redolent/stinky_contact)
	applied_smell.redolent_scent_type = redolent_scent_type
	applied_smell.redolent_scent = redolent_scent
	applied_smell.notify_new_stinker()
	// Yes, this means a person can smell of many things at once

/datum/status_effect/redolent/stinky_contact // Temporary subtype. Works the same as normal, except it can be washed away and expire
	id = "stinky_contact"
	duration = 15 MINUTES
	tick_interval = 5 SECONDS
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/status_effect/debuff/stinky_contact // Fancy alert letting you know you've become a stinker

/// Lets the smelly person that they have now become smelly
/datum/status_effect/redolent/stinky_contact/proc/notify_new_stinker()
	switch(redolent_scent_type)
		if(REDOLENT_SMELL_GOOD)
			to_chat(owner, span_notice("我现在分享别人的宜人香味！"))
		if(REDOLENT_SMELL_NEUTRAL)
			to_chat(owner, span_notice("我现在身上有别人的味道……"))
		if(REDOLENT_SMELL_BAD)
			to_chat(owner, span_warning("我现在浑身都是别人的臭味……恶心……"))

/datum/status_effect/redolent/stinky_contact/on_wash(mob/cleaner)
	if(cleaner == owner)
		to_chat(owner, span_notice("我擦掉了气味..."))
	else
		to_chat(cleaner, span_notice("我洗掉他们的气味。"))
		to_chat(owner, span_notice("[cleaner] 给了我一次彻底的清洗，我不再被气味所玷污。"))
	qdel(src)

/datum/status_effect/redolent/stinky_contact/on_remove()
	to_chat(owner, span_notice("挥之不去的香味终于从我身上消散了。"))
	return ..()

/atom/movable/screen/alert/status_effect/debuff/stinky_contact
	name = "麝香味的"
	desc = "某人的臭味传染到我身上了。我应该可以洗掉它，或者等它过去。"
	icon_state = "debuff"

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
