/datum/sprite_accessory/face_detail
	icon = 'icons/mob/sprite_accessory/face_detail.dmi'
	layer = BODY_LAYER
	default_colors = list("FFFFFF")
	color_disabled = TRUE

/datum/sprite_accessory/face_detail/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEFACE)

/datum/sprite_accessory/face_detail/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/face_detail/brows
	name = "浓眉"
	icon_state = "brows"
	layer = BODY_LAYER
	default_colors =  null
	color_key_defaults = list(KEY_HAIR_COLOR)
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/brows/dark
	name = "深色眉毛"
	icon_state = "darkbrows"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/scar
	name = "疤痕"
	icon_state = "scar"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/scart
	name = "疤痕 2"
	layer = BODY_LAYER
	icon_state = "scar2"

/datum/sprite_accessory/face_detail/slashedeye_r
	name = "割伤的眼（右）"
	icon_state = "slashedeye_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/slashedeye_r
	name = "割伤的眼（右）"
	icon_state = "slashedeye_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/slashedeye_l
	name = "割伤的眼（左）"
	icon_state = "slashedeye_l"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/mangled
	name = "撕裂的下颌"
	icon_state = "mangled"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/tattoo_lips
	name = "纹身（唇）"
	icon_state = "tattoo_lips"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/tattoo_eye_r
	name = "纹身（右眼）"
	icon_state = "tattoo_eye_r"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/tattoo_eye_l
	name = "纹身（左眼）"
	icon_state = "tattoo_eye_l"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/tattoo_eye_both
	name = "纹身（双眼）"
	icon_state = "tattoo_eye_both"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/burnface_r
	name = "烧伤（右）"
	icon_state = "burnface_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/burnface_l
	name = "烧伤（左）"
	icon_state = "burnface_l"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/burneye_r
	name = "灼伤的眼（右）"
	icon_state = "burneye_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/burneye_l
	name = "灼伤的眼（左）"
	icon_state = "burneye_l"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/deadeye_r
	name = "死眼（右）"
	icon_state = "deadeye_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/deadeye_l
	name = "死眼（左）"
	icon_state = "deadeye_l"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/scarhead
	name = "疤痕头颅"
	icon_state = "scarhead"
	layer = BODY_LAYER

/datum/sprite_accessory/accessory
	icon = 'icons/mob/sprite_accessory/accessory.dmi'
	default_colors = list("FFFFFF")
	color_disabled = TRUE

/datum/sprite_accessory/accessory/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEFACE)

/datum/sprite_accessory/accessory/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/accessory/earrings
	name = "耳环（金）"
	icon_state = "earrings"
	layer = BODY_FRONT_LAYER

/datum/sprite_accessory/accessory/earrings/sil
	name = "耳环（可染色）"
	icon_state = "earrings_sil"
	layer = BODY_FRONT_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/accessory/earrings/em
	name = "耳环（E）"
	icon_state = "earrings_em"
	layer = BODY_FRONT_LAYER

/datum/sprite_accessory/accessory/eyepierce
	name = "穿孔眉（左）"
	icon_state = "eyepierce"
	layer = BODY_FRONT_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/accessory/eyepierce/alt
	name = "穿孔眉（右）"
	icon_state = "eyepiercealt"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/accessory/choker
	name = "颈环"
	icon_state = "choker"
	layer = BODY_LAYER

/datum/sprite_accessory/accessory/chokere
	name = "颈环（E）"
	icon_state = "chokere"
	layer = BODY_LAYER

/datum/sprite_accessory/accessory/harlequin
	name = "丑角"
	icon_state = "harlequin"
	layer = BODY_LAYER

/datum/sprite_accessory/accessory/warpaint
	name = "战纹"
	icon_state = "warpaint"
	layer = BODY_FRONT_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/accessory/eyesocket
	name = "眼窝"
	icon_state = "eyesocket"
	layer = BODY_FRONT_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/accessory/eyeliner
	name = "眼线"
	icon_state = "eyeliner"
	layer = BODY_FRONT_LAYER
	color_disabled = FALSE
