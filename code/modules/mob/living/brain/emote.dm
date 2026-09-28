/datum/emote/brain
	mob_type_allowed_typecache = list(/mob/living/brain)
	mob_type_blacklist_typecache = list()

/datum/emote/brain/can_run_emote(mob/user, status_check = TRUE, intentional)
	. = ..()
	var/mob/living/brain/B = user
	if(!istype(B))
		return FALSE

/datum/emote/brain/alarm
	key = "alarm"
	message = "发出警报。"
	emote_type = EMOTE_AUDIBLE

/datum/emote/brain/alert
	key = "alert"
	message = "发出焦急的声音。"
	emote_type = EMOTE_AUDIBLE

/datum/emote/brain/flash
	key = "flash"
	message = "闪烁着灯光。"

/datum/emote/brain/notice
	key = "notice"
	message = "发出响亮的提示音。"
	emote_type = EMOTE_AUDIBLE

/datum/emote/brain/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "吹着口哨。"
	emote_type = EMOTE_AUDIBLE
