/obj/effect/proc_holder/spell/invoked/firewalker
	name = "踏火者"
	overlay_state = "firewalk"
	desc = "凝视跃动的火焰，与它一同起舞！\n\
	你脚下的地面将燃烧起来！"
	cost = 4
	xp_gain = TRUE
	releasedrain = 30
	chargedrain = 1
	chargetime = 0.5 SECONDS
	recharge_time = 45 SECONDS
	warnie = "spellwarning"
	spell_tier = 3
	invocations = list("烈焰，起舞。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	human_req = TRUE // Combat spell

/obj/effect/proc_holder/spell/invoked/firewalker/cast(list/targets, mob/living/user = usr)
	. = ..()
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	user.visible_message("[user]低念咒语，脚下的地面顿时燃起咆哮的烈焰！")
	user.apply_status_effect(/datum/status_effect/buff/firewalker)

	return TRUE

#define FIREWALKER_FILTER "firewalker_glow"

/atom/movable/screen/alert/status_effect/buff/firewalker
	name = "烈焰光环"
	desc = "我脚下的地面正在燃烧！"
	icon_state = "fire"

/datum/status_effect/buff/firewalker
	id = "fireaura"
	alert_type = /atom/movable/screen/alert/status_effect/buff/firewalker
	effectedstats = list(STATKEY_SPD = -1)
	examine_text = span_warning("正在烈火中起舞！！")
	duration = 5 SECONDS
	var/outline_colour ="#f96d1bff"

/datum/status_effect/buff/firewalker/on_apply()
	. = ..()

	var/filter = owner.get_filter(FIREWALKER_FILTER)
	if(!filter)
		owner.add_filter(FIREWALKER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 80, "size" = 1))

/datum/status_effect/buff/firewalker/tick(seconds_between_ticks)
	for(var/turf/nearby_turf as anything in RANGE_TURFS(2, owner))
		new /obj/effect/hotspot(nearby_turf, null, null, 1)

/datum/status_effect/buff/firewalker/on_remove()
	. = ..()
	to_chat(owner, span_warning("我脚下的火焰消退了。"))
	owner.remove_filter(FIREWALKER_FILTER)

#undef FIREWALKER_FILTER
