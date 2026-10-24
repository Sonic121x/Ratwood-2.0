/obj/effect/proc_holder/spell/invoked/haste
	name = "加速术"
	desc = "令目标获得魔法加速效果。(+5 速度，0.85 倍行动冷却)"
	cost = 4
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "haste" // Temporary icon from RW
	spell_tier = 2
	invocations = list("迅捷加诸其身！")
	invocation_type = "shout" // I mean, it is fast
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/haste/cast(list/targets, mob/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return

	var/mob/living/spelltarget = A
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget != user)
		user.visible_message("[user]低声念诵咒文，[spelltarget]短暂泛起黄色光辉。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/haste, 2 MINUTES)
		to_chat(user, span_notice("借由他人作为媒介，我的法术持续时间翻倍了。"))
	else
		user.visible_message("[user]低声念诵咒文，身上短暂泛起黄色光辉。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/haste, 1 MINUTES)

	return TRUE

#define HASTE_FILTER "haste_glow"
#undef HASTE_FILTER
