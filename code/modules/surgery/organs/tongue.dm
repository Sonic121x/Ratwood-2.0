/obj/item/organ/tongue
	name = "舌头"
	desc = ""
	icon_state = "tonguenormal"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb = list("舔舐", "涂满口水", "扇打", "舌吻", "用舌头戳")
	var/list/languages_possible
	var/say_mod = null
	var/taste_sensitivity = 15 // lower is more sensitive.
	var/modifies_speech = FALSE
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/common,
		/datum/language/dwarvish,
		/datum/language/elvish,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/beast,
		/datum/language/orcish,
		/datum/language/draconic,
		/datum/language/thievescant,
		/datum/language/canilunzt,
		/datum/language/grenzelhoftian,
		/datum/language/kazengunese,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/hammerholdian,
		/datum/language/aavnic,
		/datum/language/abyssal,
		/datum/language/merar,
		/datum/language/undead
	))

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_base

/obj/item/organ/tongue/proc/handle_speech(datum/source, list/speech_args)
	return

/obj/item/organ/tongue/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = say_mod
	if(modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.UnregisterSignal(M, COMSIG_MOB_SAY)
	for(var/datum/wound/facial/tongue/tongue_wound in M.get_wounds())
		qdel(tongue_wound)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_tongue_noise_verbs()

/obj/item/organ/tongue/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = initial(M.dna.species.say_mod)
	UnregisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.RegisterSignal(M, COMSIG_MOB_SAY, TYPE_PROC_REF(/mob/living/carbon, handle_tongueless_speech))
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_tongue_noise_verbs()

/obj/item/organ/tongue/could_speak_in_language(datum/language/dt)
	return is_type_in_typecache(dt, languages_possible)

/obj/item/organ/tongue/construct
	name = "构装体舌头"
	desc = "一条野兽的舌头，经人工技艺保存，根部嵌有晶体。它看起来毫无生气……"
	icon_state = "tongue-con"
	say_mod = "噼啪作响地说"
	taste_sensitivity = 30 //It's dead, jim.

/obj/item/organ/tongue/lizard
	name = "分叉舌"
	desc = ""
	icon_state = "tonguelizard"
	say_mod = "嘶嘶地说"
	taste_sensitivity = 10 // combined nose + tongue, extra sensitive
//	modifies_speech = TRUE
/*
/obj/item/organ/tongue/lizard/handle_speech(datum/source, list/speech_args)
	var/static/regex/lizard_hiss = new("s+", "g")
	var/static/regex/lizard_hiSS = new("S+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace(message, "sss")
		message = lizard_hiSS.Replace(message, "SSS")
	speech_args[SPEECH_MESSAGE] = message
*/
/obj/item/organ/tongue/fly
	name = "喙管"
	desc = ""
	icon_state = "tonguefly"
	say_mod = "嗡嗡地说"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	modifies_speech = TRUE

/obj/item/organ/tongue/fly/handle_speech(datum/source, list/speech_args)
	var/static/regex/fly_buzz = new("z+", "g")
	var/static/regex/fly_buZZ = new("Z+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = fly_buzz.Replace(message, "zzz")
		message = fly_buZZ.Replace(message, "ZZZ")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/abductor
	name = "超语言矩阵"
	desc = ""
	icon_state = "tongueayylmao"
	say_mod = "叽里咕噜地说"
	taste_sensitivity = 101 // ayys cannot taste anything.
	modifies_speech = TRUE
	var/mothership

/obj/item/organ/tongue/abductor/attack_self(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(!istype(T))
		return

	if(T.mothership == mothership)
		to_chat(H, span_notice("[src]已经调谐到与我相同的频道。"))

	H.visible_message(span_notice("[H]将[src]握在手中，凝神片刻。"), span_notice("我尝试调整[src]的调谐频道。"))
	if(do_after(H, delay=15, target=src))
		to_chat(H, span_notice("我将[src]调谐到自己的频道。"))
		mothership = T.mothership

/obj/item/organ/tongue/abductor/examine(mob/M)
	. = ..()
	if(HAS_TRAIT(M, TRAIT_ABDUCTOR_TRAINING) || HAS_TRAIT(M.mind, TRAIT_ABDUCTOR_TRAINING) || isobserver(M))
		if(!mothership)
			. += span_notice("它尚未调谐到任何母舰。")
		else
			. += span_notice("它已调谐至[mothership]。")

/obj/item/organ/tongue/abductor/handle_speech(datum/source, list/speech_args)
	//Hacks
	var/message = speech_args[SPEECH_MESSAGE]
	var/mob/living/carbon/human/user = usr
	var/rendered = span_abductor("<b>[user.real_name]:</b> [message]")
	user.log_talk(message, LOG_SAY, tag="abductor")
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
		if(!istype(T))
			continue
		if(mothership == T.mothership)
			to_chat(H, rendered)

	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")

	speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/tongue/zombie
	name = "腐烂的舌头"
	desc = ""
	icon_state = "tonguezombie"
	say_mod = "呻吟着说"
	modifies_speech = TRUE
	taste_sensitivity = 32

/obj/item/organ/tongue/zombie/handle_speech(datum/source, list/speech_args)
	var/list/message_list = splittext(speech_args[SPEECH_MESSAGE], " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, length(inserttext) - 2) == "..."))
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("脑子", "脑子", "脑——子——", "脑——子——啊")]...")

	speech_args[SPEECH_MESSAGE] = jointext(message_list, " ")

/obj/item/organ/tongue/alien
	name = "异星舌头"
	desc = ""
	icon_state = "tonguexeno"
	say_mod = "嘶嘶地说"
	taste_sensitivity = 10 // LIZARDS ARE ALIENS CONFIRMED
	modifies_speech = TRUE // not really, they just hiss
	var/static/list/languages_possible_alien = typecacheof(list(
		/datum/language/xenocommon,
		/datum/language/common,
		/datum/language/draconic))

/obj/item/organ/tongue/alien/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_alien

/obj/item/organ/tongue/alien/handle_speech(datum/source, list/speech_args)
	playsound(owner, "hiss", 25, TRUE, TRUE)

/obj/item/organ/tongue/bone
	name = "骨质\"舌头\""
	desc = ""
	icon_state = "tonguebone"
	say_mod = "咯咯作响地说"
	attack_verb = list("咬", "磕牙", "啃咬", "用牙齿刮", "用骨头敲")
	taste_sensitivity = 101 // skeletons cannot taste anything
	modifies_speech = TRUE
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list("sans", "papyrus")

/obj/item/organ/tongue/bone/Initialize(mapload)
	. = ..()
	phomeme_type = pick(phomeme_types)

/obj/item/organ/tongue/bone/handle_speech(datum/source, list/speech_args)
	if (chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	switch(phomeme_type)
		if("sans")
			speech_args[SPEECH_SPANS] |= SPAN_SANS
		if("papyrus")
			speech_args[SPEECH_SPANS] |= SPAN_PAPYRUS

/obj/item/organ/tongue/bone/plasmaman
	name = "等离子骨质\"舌头\""
	desc = ""
	icon_state = "tongueplasma"
	modifies_speech = FALSE

/obj/item/organ/tongue/robot
	name = "机械发声器"
	desc = ""
	status = ORGAN_ROBOTIC
	icon_state = "tonguerobot"
	say_mod = "陈述道"
	attack_verb = list("哔哔鸣叫", "嘟嘟鸣叫")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue

/obj/item/organ/tongue/robot/can_speak_in_language(datum/language/dt)
	return TRUE // THE MAGIC OF ELECTRONICS

/obj/item/organ/tongue/robot/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/tongue/snail
	name = "蜗牛舌"
	modifies_speech = TRUE

/obj/item/organ/tongue/snail/handle_speech(datum/source, list/speech_args)
	var/new_message
	var/message = speech_args[SPEECH_MESSAGE]
	for(var/i in 1 to length(message))
		if(findtext("ABCDEFGHIJKLMNOPWRSTUVWXYZabcdefghijklmnopqrstuvwxyz", message[i])) //Im open to suggestions
			new_message += message[i] + message[i] + message[i] //aaalllsssooo ooopppeeennn tttooo sssuuuggggggeeessstttiiiooonsss
		else
			new_message += message[i]
	speech_args[SPEECH_MESSAGE] = new_message

/obj/item/organ/tongue/wild_tongue
	name = "野兽舌头"

/obj/item/organ/tongue/moth
	name = "蛾舌"
	say_mod = "扑簌作响地说"

/obj/item/organ/tongue/lamia_forked
	name = "分叉舌"
	desc = "一条如蛇信般分叉的舌头。嘶嘶。"
	icon_state = "tonguelizard"
	say_mod = "嘶嘶地说"
	taste_sensitivity = 5
	modifies_speech = TRUE

/obj/item/organ/tongue/lamia_forked/handle_speech(datum/source, list/speech_args)
	var/static/regex/lizard_hiss = new("s+", "g")
	var/static/regex/lizard_hiSS = new("S+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace(message, "sss")
		message = lizard_hiSS.Replace(message, "Sss")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/harpy
	name = "鸟舌"
	desc = "啾啾啾啾啾！！"
	icon_state = "tongue-con"
	say_mod = "啾啾地说"
	taste_sensitivity = 5
	modifies_speech = FALSE
