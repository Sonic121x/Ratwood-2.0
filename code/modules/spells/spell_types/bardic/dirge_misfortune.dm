
/obj/effect/proc_holder/spell/invoked/song/dirge_fortune
	name = "厄运挽歌"
	desc = "奏出一曲降下厄运的哀歌。附近不属于听众的人会受到 `-2 LUCK`。"
	invocations = list("奏起世间最悲伤的曲子。周围的一切仿佛都郁郁寡欢。") 
	invocation_type = "emote"
	overlay_state = "dirge_t1_base"
	action_icon_state = "dirge_t1_base"
	sound = list('sound/magic/debuffroll.ogg')

/obj/effect/proc_holder/spell/invoked/song/dirge_fortune/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_dirge/misfortune)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("我必须先演奏起来，才能影响我的听众！"))
		return





/datum/status_effect/buff/playing_dirge/misfortune
	effect = /obj/effect/temp_visual/songs/inspiration_dirget1
	debuff_to_apply = /datum/status_effect/debuff/song/dirge_misfortune

/datum/status_effect/debuff/song/dirge_misfortune
	id = "dirge_misfortune"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/dirge_misfortune
	effectedstats = list(STATKEY_LCK = -2)
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/song/dirge_misfortune
	name = "厄运挽歌"
	desc = "我仿佛感到苍天在背后嘲笑我。这乐曲提醒着我，我的一生何其短暂而渺小。"
	icon_state = "restrained"
