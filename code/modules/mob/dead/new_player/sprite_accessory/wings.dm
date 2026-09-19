/datum/sprite_accessory/wings
	abstract_type = /datum/sprite_accessory/wings
	icon = 'icons/mob/sprite_accessory/wings/wings.dmi'
	color_key_name = "翅膀"
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	/// Whether the sprite accessory has states for open wings (With an "_open" suffix).
	var/can_open = FALSE

/datum/sprite_accessory/wings/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BACK, OFFSET_BACK_F)

/datum/sprite_accessory/wings/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!owner || !can_open)
		return ..()
	var/obj/item/organ/wings/wings_organ = owner.getorganslot(ORGAN_SLOT_WINGS)
	if(wings_organ && wings_organ.is_open)
		return "[icon_state]_open"
	// Cosmetic fallback: mob variable set by emote if no open-capable organ
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.wings_force_open)
			return "[icon_state]_open"
	return ..()

#ifdef UNIT_TESTS

/datum/sprite_accessory/wings/unit_testing_icon_states(list/states)
	states += icon_state
	if(can_open)
		states += "[icon_state]_open"

#endif

/datum/sprite_accessory/wings/bee
	name = "蜜蜂"
	icon_state = "bee"

/datum/sprite_accessory/wings/fairy
	name = "妖精"
	icon_state = "fairy"

/datum/sprite_accessory/wings/feathery
	name = "羽毛"
	icon_state = "feathery"

/datum/sprite_accessory/wings/bat
	name = "蝙蝠"
	icon_state = "bat"

/datum/sprite_accessory/wings/featheryv2
	name = "羽毛 v2"
	icon_state = "featheryv2"

/datum/sprite_accessory/wings/dragon/clipped
	name = "断翼龙"
	icon_state = "clipped"

/datum/sprite_accessory/wings/moth
	abstract_type = /datum/sprite_accessory/wings/moth
	icon = 'icons/mob/sprite_accessory/wings/moth_wings.dmi'
	default_colors = list("#FFFFFF")

/datum/sprite_accessory/wings/moth/plain
	name = "素色"
	icon_state = "plain"

/datum/sprite_accessory/wings/moth/monarch
	name = "帝王"
	icon_state = "monarch"

/datum/sprite_accessory/wings/moth/luna
	name = "月神"
	icon_state = "luna"

/datum/sprite_accessory/wings/moth/atlas
	name = "阿特拉斯"
	icon_state = "atlas"

/datum/sprite_accessory/wings/moth/reddish
	name = "淡红"
	icon_state = "redish"

/datum/sprite_accessory/wings/moth/royal
	name = "皇家"
	icon_state = "royal"

/datum/sprite_accessory/wings/moth/gothic
	name = "哥特"
	icon_state = "gothic"

/datum/sprite_accessory/wings/moth/lovers
	name = "恋人"
	icon_state = "lovers"

/datum/sprite_accessory/wings/moth/whitefly
	name = "白蝇"
	icon_state = "whitefly"

/datum/sprite_accessory/wings/moth/punished
	name = "烧焦"
	icon_state = "burnt_off"

/datum/sprite_accessory/wings/moth/firewatch
	name = "火警瞭望"
	icon_state = "firewatch"

/datum/sprite_accessory/wings/moth/deathhead
	name = "骷髅天蛾"
	icon_state = "deathhead"

/datum/sprite_accessory/wings/moth/poison
	name = "毒纹"
	icon_state = "poison"

/datum/sprite_accessory/wings/moth/ragged
	name = "残破"
	icon_state = "ragged"

/datum/sprite_accessory/wings/moth/moonfly
	name = "月蛾"
	icon_state = "moonfly"

/datum/sprite_accessory/wings/moth/snow
	name = "雪"
	icon_state = "snow"

/datum/sprite_accessory/wings/moth/oakworm
	name = "橡木蚕"
	icon_state = "oakworm"

/datum/sprite_accessory/wings/moth/jungle
	name = "丛林"
	icon_state = "jungle"

/datum/sprite_accessory/wings/moth/witchwing
	name = "巫翼"
	icon_state = "witchwing"

/datum/sprite_accessory/wings/moth/rosy
	name = "玫瑰"
	icon_state = "rosy"

/datum/sprite_accessory/wings/moth/featherful
	name = "丰羽"
	icon_state = "featherful"

/datum/sprite_accessory/wings/moth/brown
	name = "褐色"
	icon_state = "brown"

/datum/sprite_accessory/wings/moth/plasmafire
	name = "等离子火"
	icon_state = "plasmafire"

/datum/sprite_accessory/wings/wide
	abstract_type = /datum/sprite_accessory/wings/wide
	icon = 'icons/mob/sprite_accessory/wings/wings_wide.dmi'
	gradient_icon = 'icons/mob/sprite_accessory/hair/hair_gradients45x34.dmi'
	pixel_x = -7

/datum/sprite_accessory/wings/wide/succubus
	name = "魅魔"
	icon_state = "succubus"
	extra_state = TRUE

/datum/sprite_accessory/wings/wide/dragon_synth
	name = "龙（合成变体）"
	icon_state = "dragonsynth"

/datum/sprite_accessory/wings/wide/dragon_alt1
	name = "龙（变体 1）"
	icon_state = "dragonalt1"

/datum/sprite_accessory/wings/wide/dragon_alt2
	name = "龙（变体 2）"
	icon_state = "dragonalt2"

/datum/sprite_accessory/wings/wide/harpywings
	name = "鹰身女妖"
	icon_state = "harpy"

/datum/sprite_accessory/wings/wide/harpywingsalt1
	name = "鹰身女妖（变体 1）"
	icon_state = "harpyalt"

/datum/sprite_accessory/wings/wide/harpywingsalt2
	name = "鹰身女妖（蝙蝠）"
	icon_state = "harpybat"

/datum/sprite_accessory/wings/wide/harpywings_top
	name = "鹰身女妖（顶部）"
	icon_state = "harpy_top"
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/wings/wide/harpywingsalt1_top
	name = "鹰身女妖（变体 1）（顶部）"
	icon_state = "harpyalt_top"
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/wings/wide/harpywingsalt2_top
	name = "鹰身女妖（蝙蝠）（顶部）"
	icon_state = "harpybat_top"
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/wings/wide/low_wings
	name = "低位翅膀"
	icon_state = "low"

/datum/sprite_accessory/wings/wide/low_wings_top
	name = "低位翅膀（顶部）"
	icon_state = "low_top"

/datum/sprite_accessory/wings/wide/spider
	name = "蛛腿"
	icon_state = "spider_legs"

/datum/sprite_accessory/wings/wide/robowing
	name = "机械龙翼"
	icon_state = "robowing"

/datum/sprite_accessory/wings/huge
	abstract_type = /datum/sprite_accessory/wings/huge
	icon = 'icons/mob/sprite_accessory/wings/wings_huge.dmi'
	gradient_icon = 'icons/mob/sprite_accessory/hair/hair_gradients96x34.dmi'
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	pixel_x = -32
	can_open = TRUE

/datum/sprite_accessory/wings/huge/angel
	name = "天使"
	icon_state = "angel"

/datum/sprite_accessory/wings/huge/dragon
	name = "龙"
	icon_state = "dragon"
	color_keys = 2
	color_key_names = list("主色", "翼膜")

/datum/sprite_accessory/wings/huge/megamoth
	name = "巨型蛾"
	icon_state = "megamoth"

/datum/sprite_accessory/wings/huge/mothra
	name = "摩斯拉"
	icon_state = "mothra"

/datum/sprite_accessory/wings/huge/skeleton
	name = "骸骨"
	icon_state = "skele"

/datum/sprite_accessory/wings/huge/robotic
	name = "机械"
	icon_state = "robotic"

/datum/sprite_accessory/wings/large
	abstract_type = /datum/sprite_accessory/wings/large
	icon = 'icons/mob/sprite_accessory/wings/wings_64x32.dmi'
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	pixel_x = -16
	gradient_icon = 'icons/mob/sprite_accessory/hair/hair_gradients64x32.dmi'

/datum/sprite_accessory/wings/large/harpyswept
	name = "鹰身女妖（后掠）"
	icon_state = "harpys"

/datum/sprite_accessory/wings/large/harpyswept_alt
	name = "鹰身女妖（后掠-变体）"
	icon_state = "harpys_alt"

/datum/sprite_accessory/wings/large/harpyfluff
	name = "鹰身女妖（绒毛）"
	icon_state = "harpyfluff"

/datum/sprite_accessory/wings/large/harpyfolded
	name = "鹰身女妖（收拢）"
	icon_state = "harpyfolded"

/datum/sprite_accessory/wings/large/harpyowl
	name = "鹰身女妖（枭）"
	icon_state = "harpyowl"

/datum/sprite_accessory/wings/large/harpybat_alt
	name = "鹰身女妖（蝙蝠-变体）"
	icon_state = "harpybat_alt"

/datum/sprite_accessory/wings/large/gargoyle
	name = "石像鬼"
	icon_state = "gargoyle"
