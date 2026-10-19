/datum/sprite_accessory/antenna
	abstract_type = /datum/sprite_accessory/antenna
	color_key_name = "触角"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/antenna/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEEARS)

/datum/sprite_accessory/antenna/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/antenna/moth
	abstract_type = /datum/sprite_accessory/antenna/moth
	icon = 'icons/mob/sprite_accessory/antenna/moth_antenna.dmi'
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	default_colors = list("#FFFFFF")

/datum/sprite_accessory/antenna/moth/plain
	name = "素色"
	icon_state = "plain"

/datum/sprite_accessory/antenna/moth/reddish
	name = "淡红"
	icon_state = "reddish"

/datum/sprite_accessory/antenna/moth/royal
	name = "皇家"
	icon_state = "royal"

/datum/sprite_accessory/antenna/moth/gothic
	name = "哥特"
	icon_state = "gothic"

/datum/sprite_accessory/antenna/moth/whitefly
	name = "白蝇"
	icon_state = "whitefly"

/datum/sprite_accessory/antenna/moth/lovers
	name = "恋人"
	icon_state = "lovers"

/datum/sprite_accessory/antenna/moth/burnt_off
	name = "烧焦"
	icon_state = "burnt_off"

/datum/sprite_accessory/antenna/moth/firewatch
	name = "火警瞭望"
	icon_state = "firewatch"

/datum/sprite_accessory/antenna/moth/deathhead
	name = "骷髅天蛾"
	icon_state = "deathhead"

/datum/sprite_accessory/antenna/moth/poison
	name = "毒纹"
	icon_state = "poison"

/datum/sprite_accessory/antenna/moth/ragged
	name = "残破"
	icon_state = "ragged"

/datum/sprite_accessory/antenna/moth/moonfly
	name = "月蛾"
	icon_state = "moonfly"

/datum/sprite_accessory/antenna/moth/oakworm
	name = "橡木蚕"
	icon_state = "oakworm"

/datum/sprite_accessory/antenna/moth/jungle
	name = "丛林"
	icon_state = "jungle"

/datum/sprite_accessory/antenna/moth/witchwing
	name = "巫翼"
	icon_state = "witchwing"

/datum/sprite_accessory/antenna/moth/regal
	name = "王者"
	icon_state = "regal"

/datum/sprite_accessory/antenna/moth/mothra
	name = "摩斯拉"
	icon_state = "mothra"
