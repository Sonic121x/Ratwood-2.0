/obj/effect/proc_holder/spell/invoked/guidance
	name = "引导术"
	overlay_state = "guidance"
	desc = "令施术者出手更为精准，在战斗中受奥术幸运眷顾。(+20% 破开格挡/闪避几率，+20% 格挡/闪避几率)"
	cost = 2
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	invocations = list("指引我吧。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/guidance/cast(list/targets, mob/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return

	var/mob/living/spelltarget = A
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget != user)
		user.visible_message("[user]低声念诵咒文，[spelltarget]短暂泛起橙色光辉。")
		to_chat(user, span_notice("借由他人作为媒介，我的法术持续时间翻倍了。"))
		spelltarget.apply_status_effect(/datum/status_effect/buff/guidance/other)
	else
		user.visible_message("[user]低声念诵咒文，身上短暂泛起橙色光辉。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/guidance)

	return TRUE

#define GUIDANCE_FILTER "guidance_glow"
/datum/status_effect/buff/guidance/other
	duration = 3 MINUTES

#undef GUIDANCE_FILTER
