/datum/hair_gradient
	abstract_type = /datum/hair_gradient
	var/name
	var/icon = 'icons/mob/sprite_accessory/hair/hair_gradients32x32.dmi'
	var/icon_state

/datum/hair_gradient/none
	name = "None"
	icon = null
	icon_state = null

/datum/hair_gradient/fadeup
	name = "上渐变"
	icon_state = "fadeup"

/datum/hair_gradient/fadedown
	name = "下渐变"
	icon_state = "fadedown"

/datum/hair_gradient/vertical_split
	name = "Vertical Split"
	icon_state = "vsplit"

/datum/hair_gradient/_split
	name = "Horizontal Split"
	icon_state = "bottomflat"

/datum/hair_gradient/reflected
	name = "镜像"
	icon_state = "reflected_high"

/datum/hair_gradient/reflected_inverse
	name = "反向镜像"
	icon_state = "reflected_inverse_high"

/datum/hair_gradient/wavy
	name = "波浪"
	icon_state = "wavy"

/datum/hair_gradient/long_fade_up
	name = "Long Fade Up"
	icon_state = "long_fade_up"

/datum/hair_gradient/long_fade_down
	name = "长下渐变"
	icon_state = "long_fade_down"

/datum/hair_gradient/short_fade_up
	name = "Short Fade Up"
	icon_state = "short_fade_up"

/datum/hair_gradient/short_fade_down
	name = "短下渐变"
	icon_state = "short_fade_down"

/datum/hair_gradient/wavy_spike
	name = "Spiked Wavy"
	icon_state = "wavy_spiked"

/datum/hair_gradient/streaks
	name = "条纹"
	icon_state = "streaks"
