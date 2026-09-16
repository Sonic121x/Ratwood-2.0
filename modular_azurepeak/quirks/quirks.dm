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
	name = "嗅觉失灵"
	desc = "我的鼻子对腐朽的气味毫无知觉。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就嗅觉失灵，它不会生效！"
	added_traits = list(TRAIT_NOSTINK)
	incompatible_traits = list(TRAIT_NOSTINK)

/datum/quirk/disgracednoble
	name = "失势贵族"
	desc = "很久以前，我也曾是某个贵族家族的后裔... 如今我只是一介平民，而我的姓氏反倒成了耻辱的源头。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就出身贵族，它不会生效！"
	added_traits = list(TRAIT_DISGRACED_NOBLE)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/dwarvenchef
	name = "矮人厨师"
	desc = "曾有个矮人教过我，如何从黄油面团里切出标准的椒盐卷饼。"
	custom_text = "让你能从黄油面团中切出椒盐卷饼。"
	warning_text = "如果你本就是矮人，该特质不会生效！"
	added_traits = list(TRAIT_DWARVEN_CHEF)

/datum/quirk/empath
	name = "共情者"
	desc = "我能察觉出他人何时正身陷痛苦。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就能共情他人，它不会生效！"
	added_traits = list(TRAIT_EMPATH)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_traits = list(TRAIT_EMPATH)

/datum/quirk/fabledlover
	name = "传奇情人"
	desc = "能与我同床，是一种幸运。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就是传奇情人，它不会生效！"
	point_cost = 2
	added_traits = list(TRAIT_GOODLOVER)
	incompatible_virtues = list(/datum/virtue/utility/socialite, /datum/virtue/utility/performer)
	incompatible_traits = list(TRAIT_GOODLOVER)

/datum/quirk/gossiper
	name = "包打听"
	desc = "尽管我出身低微，我却习惯与贵族们周旋厮混，打探他们的秘密。"
	custom_text = "让你能查看贵族间的流言。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就是贵族，它不会生效！"
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

/datum/quirk/redolent/apply_to_human(mob/living/carbon/human/recipient)
	recipient.redolent_scent_type = recipient.client?.prefs?.redolent_type || "Neutral"
	recipient.redolent_scent = recipient.client?.prefs?.redolent_scent || ""

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
	to_chat(src, span_notice("I scrub the stink away. I should stay fresh for a while."))

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
	var/scent_text = html_encode(scent || "an unusual scent")
	switch(scent_type)
		if("Gross")
			return span_greentext("They reek of [scent_text].")
		if("Pleasant")
			return "<span style='color:#FFB6C1'>They smell of [scent_text].</span>"
	return "<span style='color:#d8cf8a'>They smell of [scent_text].</span>"

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
					to_chat(nearby, "<span class='warning' style='color:#48c75a'>Something nearby reeks.</span>")
					nearby.add_stress(/datum/stressevent/stinky_aura)
			if("Neutral")
				if(!nearby.has_stress_event(/datum/stressevent/prominent_scent))
					to_chat(nearby, "<span class='warning' style='color:#d8cf8a'>There's a prominent scent in the air.</span>")
					nearby.add_stress(/datum/stressevent/prominent_scent)
			if("Pleasant")
				if(!nearby.has_stress_event(/datum/stressevent/pleasant_scent))
					to_chat(nearby, "<span class='warning' style='color:#ffb6c1'>A pleasant scent drifts through the air.</span>")
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
	desc = "无论是凭出身、刀剑还是头脑，我身上都流着贵族的血，虽说只是一支无衔的低阶旁支。我机灵地藏起了一笔可观的财富，还有一件家传宝物。"
	custom_text = "该特质授予你「低阶贵族」身份，这意味着你仍受《大敕令》与人头税的约束。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就是贵族，它不会生效！"
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
	name = "相貌讨喜"
	desc = "我算不上什么绝色美人，但人们似乎还挺乐意看我的脸。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就是美人，它不会生效！"
	point_cost = 2
	added_traits = list(TRAIT_PRETTY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly)
	incompatible_traits = list(TRAIT_BEAUTIFUL)

/datum/quirk/rawdiet
	name = "生食癖"
	desc = "不论是出于异于常人的身体构造，还是单纯有着古怪的耐受，我都能像吃寻常饭食一样吃生肉与未烹煮的食物。"
	custom_text = "让你能吃生肉与未烹煮的食物而不中毒。腐烂的食物、内脏与脏水仍会让你中毒。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就拥有异于常人的代谢，它不会生效！"
	point_cost = 2
	added_traits = list(TRAIT_RAW_EATER)
	incompatible_virtues = list(/datum/virtue/utility/feral_appetite)
	incompatible_traits = list(TRAIT_NASTY_EATER, TRAIT_ORGAN_EATER, TRAIT_WILD_EATER)

/datum/quirk/roughlover
	name = "粗暴情人"
	desc = "若我动了真意，我在床笫之间便会是个凶暴的伴侣，足以一并折断对方的骨盆与意志。"
	warning_text = "该特质不消耗点数；如果你扮演的角色本就是床笫间的凶器，它不会生效！"
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
	name = "Unsettling"
	desc = "My appearance is deeply unsettling to most. There's something profoundly wrong about my features."
	point_cost = 1
	added_traits = list(TRAIT_UNSETTLING)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly, /datum/quirk/pretty)

/datum/quirk/selfaware
	name = "Self Aware"
	desc = "I've always been conscious about how hurt my body can get."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already has self aware!"
	added_traits = list(TRAIT_SELF_AWARE)
	incompatible_traits = list(TRAIT_SELF_AWARE)
