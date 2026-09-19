/datum/sprite_accessory/frills
	abstract_type = /datum/sprite_accessory/frills
	icon = 'icons/mob/sprite_accessory/frills/frills.dmi'
	color_key_name = "颈褶"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/frills/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEEARS|HIDEHAIR)

/datum/sprite_accessory/frills/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/frills/simple
	name = "简约"
	icon_state = "simple"

/datum/sprite_accessory/frills/simpledualcolor
	name = "简约-双色"
	icon_state = "m_frills_simple"
	color_keys = 2
	color_key_names = list("外层", "内层")

/datum/sprite_accessory/frills/short
	name = "短"
	icon_state = "short"

/datum/sprite_accessory/frills/shortdualcolor
	name = "短-双色"
	icon_state = "m_frills_short"
	color_keys = 2
	color_key_names = list("外层", "内层")

/datum/sprite_accessory/frills/aquatic
	name = "Aquatic"
	icon_state = "aqua"

/datum/sprite_accessory/frills/aquaticdualcolor
	name = "水生-双色"
	icon_state = "m_frills_aqua"
	color_keys = 2
	color_key_names = list("外层", "内层")

/datum/sprite_accessory/frills/divinity
	name = "神性"
	icon_state = "divinity"

/datum/sprite_accessory/frills/horns
	name = "角"
	icon_state = "horns"

/datum/sprite_accessory/frills/horns_double
	name = "双角"
	icon_state = "hornsdouble"

/datum/sprite_accessory/frills/big
	name = "Big"
	icon_state = "big"

/datum/sprite_accessory/frills/cobrahood
	name = "眼镜蛇颈罩"
	icon_state = "cobrahood"
	color_keys = 2
	color_key_names = list("颈罩", "内层")

/datum/sprite_accessory/frills/cobrahood_ears
	name = "眼镜蛇颈罩（耳）"
	icon_state = "cobraears"
	color_keys = 2
	color_key_names = list("颈罩", "内层")

/datum/sprite_accessory/frills/split
	name = "分叉"
	icon_state = "split"

/datum/sprite_accessory/frills/split_big
	name = "分叉（大）"
	icon_state = "split_big"

/datum/sprite_accessory/frills/split_slim
	name = "分叉（细）"
	icon_state = "split_slim"

/datum/sprite_accessory/frills/earlike
	name = "耳状"
	icon_state = "earlike"
	color_keys = 2
	color_key_names = list("外层", "内层")

/datum/sprite_accessory/frills/earlike_thick
	name = "Earlike (Thick)"
	icon_state = "earlike_thick"

/datum/sprite_accessory/frills/earlike_angled
	name = "耳状（斜角）"
	icon_state = "earlike_angled"
