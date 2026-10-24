/obj/effect/proc_holder/spell/invoked/fortitude
	name = "坚韧术"
	desc = "使身心机能更能承受肉体疲劳。(-30% 耐力消耗)"
	cost = 3 // Reducing stamina cost is INSANE so it cost the same as before adjustment to 3x spellpoint basis.
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "fortitude"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("赐我坚韧。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/fortitude/cast(list/targets, mob/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return

	var/mob/living/spelltarget = A
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget != user)
		user.visible_message("[user]低声念诵咒文，[spelltarget]短暂泛起绿色光辉。")
		to_chat(user, span_notice("借由他人作为媒介，我的法术持续时间翻倍了。"))
		spelltarget.apply_status_effect(/datum/status_effect/buff/fortitude/other)
	else
		user.visible_message("[user]低声念诵咒文，身上短暂泛起绿色光辉。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/fortitude)

	return TRUE

#define FORTITUDE_FILTER "fortitude_glow"
/datum/status_effect/buff/fortitude/other
	duration = 3 MINUTES
