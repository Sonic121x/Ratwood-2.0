#define CRYSTALHIDE_FILTER "crystalhide_glow"

/datum/status_effect/buff/crystalhide
	id = "crystalhide"
	alert_type = /atom/movable/screen/alert/status_effect/buff/crystalhide
	duration = -1
	var/outline_colour = "#3aa8ff"

/atom/movable/screen/alert/status_effect/buff/crystalhide
	name = "晶肤聚合心智"
	desc = "汇集世界线的杂讯，我的心智由此拓展。异己意识的低语与建议编码于全息边界之上。"

/datum/status_effect/buff/crystalhide/on_apply()
	. = ..()
	var/filter = owner.get_filter(CRYSTALHIDE_FILTER)
	if(!filter)
		owner.add_filter(CRYSTALHIDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))

/datum/status_effect/buff/crystalhide/on_remove()
	. = ..()
	owner.remove_filter(CRYSTALHIDE_FILTER)

#undef CRYSTALHIDE_FILTER
