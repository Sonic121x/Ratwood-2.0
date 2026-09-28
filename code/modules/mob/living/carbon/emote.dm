/datum/emote/living/carbon
	mob_type_allowed_typecache = list(/mob/living/carbon)

/datum/emote/living/carbon/deathgurgle
	key = "deathgurgle"
	key_third_person = ""
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	vary = TRUE
	message = "咽下了最后一口气。"
	message_simple =  "软倒了。"
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/airguitar
	key = "airguitar"
	message = "拨弄着一把看不见的鲁特琴。"
	restraint_check = TRUE

/datum/emote/living/carbon/blink
	key = "blink"
	key_third_person = "blinks"
	message = "眨了眨眼。"

/datum/emote/living/carbon/blink_r
	key = "blink_r"
	message = "快速眨着眼睛。"

/datum/emote/living/carbon/clap
	key = "clap"
	key_third_person = "claps"
	message = "鼓起掌来。"
	muzzle_ignore = TRUE
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/mob/living/carbon/human/verb/emote_clap()
	set name = "Clap"
	set category = "Noises"

	emote("clap", intentional = TRUE)

/datum/emote/living/carbon/slowclap
	key = "slowclap"
	key_third_person = "claps"
	message = "慢慢地鼓着掌。"
	muzzle_ignore = TRUE
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_slowclap()
	set name = "Slow clap"
	set category = "Noises"

	emote("slowclap", intentional = TRUE)

/datum/emote/living/carbon/clap1
	key = "clap1"
	key_third_person = "claps"
	message = "拍了一下双手。"
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	restraint_check = TRUE

/mob/living/carbon/human/verb/emote_clap1()
	set name = "Clap once"
	set category = "Noises"

	emote("clap1", intentional = TRUE)

/datum/emote/living/moan
	key = "moan"
	key_third_person = "moans"
	message = "呻吟着。"
	message_mime = "做出呻吟的样子！"
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_moan()
	set name = "Moan"
	set category = "Noises"

	emote("moan")

/datum/emote/living/carbon/sign/select_param(mob/user, params)
	. = ..()
	if(!isnum(text2num(params)))
		return message

/datum/emote/living/carbon/sign/signal
	key = "signal"
	key_third_person = "signals"
	message_param = "竖起了%t根手指。"
	mob_type_allowed_typecache = list(/mob/living/carbon/human)
	restraint_check = TRUE

/datum/emote/living/carbon/wink
	key = "wink"
	key_third_person = "winks"
	message = "眨了一下单眼。"
