/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "哭泣着。"
	emote_type = EMOTE_AUDIBLE
	needs_emotion = TRUE

/mob/living/carbon/human/verb/emote_cry()
	set name = "Cry"
	set category = "Noises"

	emote("cry", intentional = TRUE)

/datum/emote/living/carbon/human/cry/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "发出声音，泪水顺着脸颊流下。"


/datum/emote/living/carbon/human/sexmoanlight
	key = "sexmoanlight"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	needs_emotion = TRUE

/datum/emote/living/carbon/human/sexmoanlight/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "发出一声轻响。"

/datum/emote/living/carbon/human/sexmoanhvy
	key = "sexmoanhvy"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	needs_emotion = TRUE

/datum/emote/living/carbon/human/sexmoanhvy/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "发出一声轻响。"

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "挑了挑眉。"
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_eyebrow()
	set name = "Raise Eyebrow"
	set category = "Emotes"

	emote("eyebrow", intentional = TRUE)

/datum/emote/living/carbon/human/psst
	key = "psst"
	key_third_person = "pssts"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/mob/living/carbon/human/verb/emote_psst()
	set name = "Psst"
	set category = "Noises"

	emote("psst", intentional = TRUE)

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "嘟囔着抱怨。"
	message_muffled = "发出闷闷的抱怨声。"
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_grumble()
	set name = "Grumble"
	set category = "Noises"

	emote("grumble", intentional = TRUE)

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "自己握了握双手。"
	message_param = "和%t握了握手。"
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE


/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "含糊地低语着。"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "脸色一瞬间变得苍白。"

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "举起一只手。"
	restraint_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "敬了个礼。"
	message_param = "向%t敬了个礼。"
	restraint_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "耸了耸肩。"

/datum/emote/living/carbon/human/wag
	key = "wag"

/mob/living/carbon/human/verb/emote_wag()
	set name = "Wag"
	set category = "Emotes"

	emote("wag")

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(!H.dna.species.is_wagging_tail(H))
		H.visible_message(span_biginfo("<span style='color:#[H.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[H]</b></span><span style='color: #c9c1ba;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>摇着尾巴。</span>"), runechat_message = "摇着尾巴")
		H.dna.species.start_wagging_tail(H)
	else
		H.visible_message(span_biginfo("<span style='color:#[H.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[H]</b></span></span><span style='color: #c9c1ba;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>不再摇尾巴。</span>"), runechat_message = "不再摇尾巴")
		H.dna.species.stop_wagging_tail(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna && H.dna.species && H.dna.species.can_wag_tail(user)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.dna.species.is_wagging_tail(H))
		. = null

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "拍打着翅膀。"

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	if(!ishuman(user))
		return FALSE
	// Allow even if they can't toggle (they'll just flap)
	return TRUE

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/datum/species/S = H.dna?.species
	if(!S)
		return ..()
	if(S.can_toggle_wings(H))
		var/now_open = S.toggle_wings(H)
		if(now_open)
			message = "舒展开双翼。"
		else
			message = "收拢了双翼。"
		return ..()

	if(!H.wings_force_open)
		H.wings_force_open = TRUE
		message = "舒展开双翼。"
	else
		H.wings_force_open = FALSE
		message = "收拢了双翼。"
	H.update_body_parts(TRUE)
	return ..()

/mob/living/carbon/human/var/tmp/wings_force_open

/mob/living/carbon/human/proc/OpenWings()
	var/obj/item/organ/wings/W = getorganslot(ORGAN_SLOT_WINGS)
	if(W && W.can_open && !W.is_open)
		W.is_open = TRUE
		update_body_parts(TRUE)

/mob/living/carbon/human/proc/CloseWings()
	var/obj/item/organ/wings/W = getorganslot(ORGAN_SLOT_WINGS)
	if(W && W.can_open && W.is_open)
		W.is_open = FALSE
		update_body_parts(TRUE)

// FEEL EMOTE VERB
/mob/living/carbon/human/verb/emote_feel()
	set name = "Feel (Desire/Dread)"
	set category = "Emotes"

	var/list/options = list("渴望", "恐惧")
	var/choice = input(src, "你想表达什么感受？", "感受") as null|anything in options
	if(!choice) return

	var/list/degrees = list("轻微", "中等", "强烈")
	var/degree = input(src, "选择程度：", "程度") as null|anything in degrees
	if(!degree) return

	if(choice == "渴望")
		var/desire = input(src, "你渴望什么？", "渴望") as null|text
		if(isnull(desire)) return
		var/message = "你[degree == "轻微" ? "有点" : degree == "中等" ? "很" : "迫切地"]想帮助[src.real_name]实现愿望：[desire]"
		if(!length(message) || copytext_char(message, length_char(message)) != "。")
			message += "。"
		for(var/mob/living/carbon/human/H in viewers(src, null))
			if(HAS_TRAIT(H, TRAIT_EMPATH))
				to_chat(H, "<span style='color: white; font-style: italic; text-shadow: 0 0 6px #fff, 0 0 12px #fff;'>[message]</span>")
		to_chat(src, "我渴望[desire]。")
		return

	if(choice == "恐惧")
		var/dread = input(src, "你在恐惧什么？", "恐惧") as null|text
		if(isnull(dread)) return
		var/message = "想到[dread]，你[degree == "轻微" ? "略感不安" : degree == "中等" ? "忧心忡忡" : "恐惧不已"]。"
		if(!length(message) || copytext_char(message, length_char(message)) != "。")
			message += "。"
		for(var/mob/living/carbon/human/H in viewers(src, null))
			if(HAS_TRAIT(H, TRAIT_EMPATH))
				to_chat(H, "<span style='color: #ff4444; font-weight: bold;'>[message]</span>")
		to_chat(src, "想到[dread]，我忧心忡忡。")
		return

/datum/emote/living/carbon/human/wingsfly
	key = "wingsfly"

/datum/emote/living/carbon/human/wingsfly/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(H.has_status_effect(/datum/status_effect/debuff/harpy_flight))
		H.visible_message(
			span_biginfo("<span style='color:#[H.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[H]</b></span></span><span style='color: #c9c1ba;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>展开双翼，准备起飞！</span>"),
			runechat_message = "展开双翼！"
		)
	else
		H.visible_message(
			span_biginfo("<span style='color:#[H.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[H]</b></span></span><span style='color: #c9c1ba;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>落回地面，不再拍打翅膀！</span>"),
			runechat_message = "不再拍打翅膀！"
		)
