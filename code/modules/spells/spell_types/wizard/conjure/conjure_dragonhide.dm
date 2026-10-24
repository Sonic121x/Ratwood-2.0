#define DRAGONHIDE_FILTER "dragonhide_glow"

/datum/status_effect/buff/dragonhide
	id = "dragonscaled"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dragonhide
	duration = -1
	var/outline_colour = "#c23d09"

/atom/movable/screen/alert/status_effect/buff/dragonhide
	name = "龙鳞护体"
	desc = "龙鳞为我挡住了最猛烈的火焰。"

/datum/status_effect/buff/dragonhide/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_FIRE_RESIST, TRAIT_GENERIC)
	var/filter = owner.get_filter(DRAGONHIDE_FILTER)
	if (!filter)
		owner.add_filter(DRAGONHIDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/dragonhide/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_FIRE_RESIST, TRAIT_GENERIC)
	owner.remove_filter(DRAGONHIDE_FILTER)

#undef DRAGONHIDE_FILTER

/datum/status_effect/buff/dragonhide/astrata
	id = "asbestine"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dragonhide/astrata
	duration = 2 MINUTES
	outline_colour = "#9B7439"

/atom/movable/screen/alert/status_effect/buff/dragonhide/astrata
	name = "不燃斗篷"
	desc = "沐浴于她的光辉，火焰无法侵扰我！"
