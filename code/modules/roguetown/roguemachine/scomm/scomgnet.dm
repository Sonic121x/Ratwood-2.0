// INQUISITION SCOM RING
// This is effectively almost the same as the bandit ring. It tastes the blood of the user to ensure they are a member of the inquisition, as to not make it too spammable like an ss13 radio. In exchange, non inquisition cannot send messages on it.
// It is supposed to be hush-hush that the inquisition has scomstones, which is why they appear as regular signet rings. (This is also a convenient excuse to re-use sprites.)
// is a subtype of the signet ring rather than the matthian scomstone purely for tallowpot stuff
/obj/item/clothing/ring/signet/silver/inqscomm
	desc = "圣玛勒姆教团奉命为正教会设计一种通信工具，同时保留用红脂封缄信件的功能。经过三年不眠不休的劳作，他们造出了这件奥塔万技术的奇迹。愿你们的联络长久不绝。\n \
	侧面有一个按钮，让你忍不住想按下去。"
	slot_flags = ITEM_SLOT_RING|ITEM_SLOT_GLOVES
	muteinmouth = TRUE
	var/listening = TRUE
	var/speaking = TRUE
	sellprice = 150

/obj/item/clothing/ring/signet/silver/inqscomm/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src

/obj/item/clothing/ring/signet/silver/inqscomm/attack_right(mob/living/carbon/human/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚住或无法行动时，不能使用它！"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	to_chat(user, span_notice("我按下戒指侧面的按钮……"))
	if(!do_after(user, 1 SECONDS, FALSE, null, FALSE))
		to_chat(user, span_warning("戒指必须充分尝到我的血，才能传递消息。"))
		return
	user.set_blood_volume(max(user.get_blood_volume()-45, 0))
	user.fullscreen_redflash("redflash1")
	to_chat(user, span_warning("戒指刺破了我的手指！"))
	if(!HAS_TRAIT(user, TRAIT_INQUISITION) && !HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		src.say("血液未经授权！")
		playsound(src, 'sound/items/indexer_cursed.ogg', 50, FALSE, -1)
		return
	
	var/input_text = input(user, "输入要传递的消息：", "消息")
	if(input_text)
		var/usedcolor = user.voice_color
		if(user.voicecolor_override)
			usedcolor = user.voicecolor_override
		user.whisper(input_text)
		if(length(input_text) > 100)
			input_text = "<small>[input_text]</small>"
		for(var/obj/item/clothing/ring/signet/silver/inqscomm/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor)

/obj/item/clothing/ring/signet/silver/inqscomm/MiddleClick(mob/user)
	if(.)
		return
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚住或无法行动时，不能使用它！"))
		return
	if(!HAS_TRAIT(user, TRAIT_INQUISITION) && !HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, span_info("我将SCOM传讯印戒[speaking ? "解除静音" : "设为静音"]。"))

/obj/item/clothing/ring/signet/silver/inqscomm/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_INQUISITION) && !HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		listening = FALSE
		speaking = FALSE
	..()

/obj/item/clothing/ring/signet/silver/inqscomm/examine(mob/user)
	if(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		desc = "圣玛勒姆教团奉命为正教会设计一种通信工具，同时保留用红脂封缄信件的功能。经过三年不眠不休的劳作，他们造出了这件奥塔万技术的奇迹。愿你们的联络长久不绝。\n \
		侧面有一个按钮，让你忍不住想按下去。"
	else
		desc = "一枚受祝福的银戒指，上面刻有大主教的徽记。将其浸入熔化的红脂后，便可为宗教文书盖印密封。"
	. = ..()


/obj/item/clothing/ring/signet/silver/inqscomm/doStrip(mob/stripper, mob/owner)
	if(!HAS_TRAIT(stripper, TRAIT_INQUISITION) && !HAS_TRAIT(stripper, TRAIT_SCOMGNET_AUTHORIZED))
		listening = FALSE
		speaking = FALSE
	. = ..()

/obj/item/clothing/ring/signet/silver/inqscomm/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(!HAS_TRAIT(user, TRAIT_PURITAN))
		return
	if(HAS_TRAIT(target, TRAIT_INQUISITION) || HAS_TRAIT(target, TRAIT_SCOMGNET_AUTHORIZED))
		return
	if(target.wear_ring)
		to_chat(user, span_warning("[target]的无名指上不能戴着戒指！"))
		return
	user.visible_message(span_cult("[user]按了两下戒指侧面。戒指刺入皮肉，鲜血从伤口涌出……"))
	if(!do_after(user, 5 SECONDS) || target.wear_ring)
		return
	user.set_blood_volume(max(user.get_blood_volume()-45, 0))
	user.fullscreen_redflash("redflash2")
	if(!do_after(user, 5 SECONDS) || target.wear_ring)
		return
	user.visible_message(span_cult("[user]将染血的戒指套上[target]的手指，再次按了两下。戒指饮下[target]的鲜血，使之与[user]的血混合……"))
	target.fullscreen_redflash("redflash2")
	target.set_blood_volume(max(target.get_blood_volume()-45, 0))
	ADD_TRAIT(target, TRAIT_SCOMGNET_AUTHORIZED, TRAIT_GENERIC)
	src.listening = TRUE
	src.speaking = TRUE
	target.equip_to_slot(src, SLOT_RING) // has to be unsafe otherwise won't work on unconscious people... should be fine since i already check if ring is free..?

/obj/item/clothing/ring/signet/silver/inqscomm/Destroy()
	lose_hearing_sensitivity()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/clothing/ring/signet/silver/inqscomm/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/vo/mobs/rat/rat_life.ogg', 50, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null

/obj/item/clothing/ring/signet/silver/inqscomm/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, 0, I, , spans, message_language=language)
	else
		send_speech(message, 0, src, , spans, message_language=language)

/obj/item/clothing/ring/signet/silver/inqscomm/attack_self(mob/user) // is attack self as opposed to attack right.
	. = ..()
	if(tallowed)
		if(alert(user, "要刮掉红脂吗？", "印戒", "是", "否") != "否")
			tallowed = FALSE
			update_icon()

/obj/item/clothing/ring/signet/silver/inqscomm/g
	name = "金印戒"
	icon_state = "signet"
	sellprice = 195
	is_silver = FALSE

/obj/item/clothing/ring/signet/silver/inqscomm/g/examine(mob/user)
	if(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		desc = "圣玛勒姆教团奉命为正教会设计一种通信工具，同时保留用红脂封缄信件的功能。经过三年不眠不休的劳作，他们造出了这件奥塔万技术的奇迹。愿你们的联络长久不绝。\n \
		侧面有一个按钮，让你忍不住想按下去。"
	else
		desc = "一枚奢华的金戒指，上面刻有普赛顿的圣徽。将其浸入熔化的红脂后，便可为重要宗教文书盖印密封——比起教会或王室，审判所对此更为熟悉。"
	. = ..()
