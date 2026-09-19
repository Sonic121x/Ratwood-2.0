/datum/sprite_accessory/snout
	abstract_type = /datum/sprite_accessory/snout
	icon = 'icons/mob/sprite_accessory/snouts/snouts.dmi'
	color_key_name = "吻部"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/snout/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDESNOUT)

/datum/sprite_accessory/snout/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/snout/cat
	name = "猫"
	icon_state = "cat"

/datum/sprite_accessory/snout/sharp
	name = "尖"
	icon_state = "sharp"

/datum/sprite_accessory/snout/sharpdualcolor
	name = "尖-双色"
	icon_state = "m_snout_sharp"
	color_keys = 2
	color_key_names = list("吻部", "下颚")

/datum/sprite_accessory/snout/round
	name = "圆"
	icon_state = "round"

/datum/sprite_accessory/snout/rounddualcolor
	name = "圆-双色"
	icon_state = "m_snout_round"
	color_keys = 2
	color_key_names = list("吻部", "下颚")

/datum/sprite_accessory/snout/sharplight
	name = "尖+浅色"
	icon_state = "sharplight"

/datum/sprite_accessory/snout/sharplightdualcolor
	name = "尖+浅色-双色"
	icon_state = "m_snout_sharplight"
	color_keys = 2
	color_key_names = list("吻部", "下颚")

/datum/sprite_accessory/snout/roundlight
	name = "圆+浅色"
	icon_state = "roundlight"

/datum/sprite_accessory/snout/roundlightdualcolor
	name = "圆+浅色-双色"
	icon_state = "m_snout_roundlight"
	color_keys = 2
	color_key_names = list("吻部", "下颚")

/datum/sprite_accessory/snout/vulp
	name = "维纳丁双色"
	icon_state = "vulp"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/shark
	name = "鲨鱼"
	icon_state = "shark"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/bird
	name = "鸟喙"
	icon_state = "bird"
	color_keys = 3
	color_key_names = list("喙", "细节", "顶部")

/datum/sprite_accessory/snout/bigbeak
	name = "大喙"
	icon_state = "bigbeak"

/datum/sprite_accessory/snout/bigbeakshort
	name = "大喙（短）"
	icon_state = "bigbeakshort"

/datum/sprite_accessory/snout/slimbeak
	name = "细喙"
	icon_state = "slimbeak"

/datum/sprite_accessory/snout/slimbeakshort
	name = "细喙（短）"
	icon_state = "slimbeakshort"

/datum/sprite_accessory/snout/slimbeakalt
	name = "细喙（变体）"
	icon_state = "slimbeakalt"

/datum/sprite_accessory/snout/hookbeak
	name = "钩喙"
	icon_state = "hookbeak"

/datum/sprite_accessory/snout/hookbeakbig
	name = "钩喙（大）"
	icon_state = "hookbeakbig"

/datum/sprite_accessory/snout/bug
	name = "虫"
	icon_state = "bug"
	color_keys = 2
	color_key_names = list("吻部", "眼睛")

/datum/sprite_accessory/snout/elephant
	name = "象"
	icon_state = "elephant"
	color_keys = 2
	color_key_names = list("吻部", "角")

/datum/sprite_accessory/snout/husky
	name = "哈士奇"
	icon_state = "husky"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/rhino
	name = "角"
	icon_state = "rhino"
	color_keys = 3
	color_key_names = list("吻部", "细节", "细节")

/datum/sprite_accessory/snout/bovine
	name = "牛"
	icon_state = "bovine"
	color_keys = 3
	color_key_names = list("吻部", "细节", "细节")

/datum/sprite_accessory/snout/rodent
	name = "啮齿"
	icon_state = "rodent"

/datum/sprite_accessory/snout/lcanid
	name = "哺乳类（长）"
	icon_state = "lcanid"

/datum/sprite_accessory/snout/lcanidalt
	name = "哺乳类（长-变体）"
	icon_state = "lcanidalt"

/datum/sprite_accessory/snout/lcanidstriped
	name = "哺乳类（长-条纹）"
	icon_state = "lcanidstripe"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/lcanidstripedalt
	name = "哺乳类（长-条纹-变体）"
	icon_state = "lcanidstripealt"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/scanid
	name = "哺乳类（短）"
	icon_state = "scanid"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/scanidalt
	name = "哺乳类（短-变体）"
	icon_state = "scanidalt"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/scanidalt2
	name = "哺乳类（短-变体 2）"
	icon_state = "scanidalt2"

/datum/sprite_accessory/snout/scanidalt3
	name = "哺乳类（短-变体 3）"
	icon_state = "scanidalt3"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/tajaran
	name = "塔加兰（标准）"
	icon_state = "ntajaran"

/datum/sprite_accessory/snout/wolf
	name = "哺乳类（厚）"
	icon_state = "wolf"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/wolfalt
	name = "哺乳类（厚-变体）"
	icon_state = "wolfalt"

/datum/sprite_accessory/snout/otie
	name = "奥提"
	icon_state = "otie"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/otiesmile
	name = "奥提（微笑）"
	icon_state = "otiesmile"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/pede
	name = "蜈蚣王"
	icon_state = "pede"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/sergal
	name = "瑟伽尔"
	icon_state = "sergal"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/toucan
	name = "巨嘴鸟"
	icon_state = "toucan"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/redpanda
	name = "瓦库恩"
	icon_state = "wah"
	color_keys = 3
	color_key_names = list("吻部", "细节", "细节")

/datum/sprite_accessory/snout/redpandaalt
	name = "瓦库恩（变体）"
	icon_state = "wahalt"
	color_keys = 2
	color_key_names = list("吻部", "细节")

/datum/sprite_accessory/snout/sbeak
	name = "鸦喙"
	icon_state = "corvid"

/datum/sprite_accessory/snout/rat
	name = "鼠"
	icon_state = "rat"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/stubby
	name = "短粗"
	icon_state = "stubby"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/alienlizard
	name = "异星蜥蜴"
	icon_state = "alienlizard"

/datum/sprite_accessory/snout/alienlizardteeth
	name = "异星蜥蜴（带齿）"
	icon_state = "alienlizardteeth"
	extra_state = TRUE

/datum/sprite_accessory/snout/skulldog
	name = "骷髅犬"
	icon_state = "skulldog"
	extra_state = TRUE
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/hanubus
	name = "阿努比斯"
	icon_state = "hanubus"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/hpanda
	name = "熊猫"
	icon_state = "hpanda"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/hjackal
	name = "胡狼"
	icon_state = "hjackal"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/hspots
	name = "鬣狗"
	icon_state = "hspots"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/hhorse
	name = "马"
	icon_state = "hhorse"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/hzebra
	name = "斑马"
	icon_state = "hzebra"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/******************************************
**************** Snouts *******************
*************but higher up*****************/

/datum/sprite_accessory/snout/front
	abstract_type = /datum/sprite_accessory/snout/front
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/snout/front/sharp
	name = "尖（顶部）"
	icon_state = "fsharp"

/datum/sprite_accessory/snout/front/round
	name = "圆（顶部）"
	icon_state = "fround"

/datum/sprite_accessory/snout/front/sharplight
	name = "尖+浅色（顶部）"
	icon_state = "fsharplight"

/datum/sprite_accessory/snout/front/roundlight
	name = "圆+浅色（顶部）"
	icon_state = "froundlight"

/datum/sprite_accessory/snout/front/bird
	name = "鸟喙（顶部）"
	icon_state = "fbird"
	color_keys = 3
	color_key_names = list("喙", "细节", "顶部")

/datum/sprite_accessory/snout/front/bigbeak
	name = "大喙（顶部）"
	icon_state = "fbigbeak"

/datum/sprite_accessory/snout/front/bug
	name = "虫（顶部）"
	icon_state = "fbug"
	color_keys = 2
	color_key_names = list("吻部", "眼睛")

/datum/sprite_accessory/snout/front/elephant
	name = "象（顶部）"
	icon_state = "felephant"
	color_keys = 2
	color_key_names = list("吻部", "角")

/datum/sprite_accessory/snout/front/rhino
	name = "角（顶部）"
	icon_state = "frhino"
	color_keys = 3
	color_key_names = list("吻部", "细节", "细节")

/datum/sprite_accessory/snout/front/bovine
	name = "牛（顶部）"
	icon_state = "fbovine"
	color_keys = 3
	color_key_names = list("吻部", "细节", "细节")

/datum/sprite_accessory/snout/front/husky
	name = "哈士奇（顶部）"
	icon_state = "fhusky"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/lcanid
	name = "哺乳类（长）（顶部）"
	icon_state = "flcanid"

/datum/sprite_accessory/snout/front/lcanidalt
	name = "哺乳类（长-变体）（顶部）"
	icon_state = "flcanidalt"

/datum/sprite_accessory/snout/front/lcanidstriped
	name = "哺乳类（长-条纹）（顶部）"
	icon_state = "flcanidstripe"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/lcanidstripedalt
	name = "哺乳类（长-条纹-变体）（顶部）"
	icon_state = "flcanidstripealt"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/scanid
	name = "哺乳类（短）（顶部）"
	icon_state = "fscanid"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/scanidalt
	name = "哺乳类（短-变体）（顶部）"
	icon_state = "fscanidalt"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/scanidalt2
	name = "哺乳类（短-变体 2）（顶部）"
	icon_state = "fscanidalt2"

/datum/sprite_accessory/snout/front/scanidalt3
	name = "哺乳类（短-变体 3）（顶部）"
	icon_state = "fscanidalt3"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/wolf
	name = "哺乳类（厚）（顶部）"
	icon_state = "fwolf"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/wolfalt
	name = "哺乳类（厚-变体）（顶部）"
	icon_state = "fwolfalt"

/datum/sprite_accessory/snout/front/otie
	name = "奥提（顶部）"
	icon_state = "fotie"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/otiesmile
	name = "奥提（微笑）（顶部）"
	icon_state = "fotiesmile"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/rodent
	name = "啮齿（顶部）"
	icon_state = "frodent"

/datum/sprite_accessory/snout/front/pede
	name = "蜈蚣王（顶部）"
	icon_state = "fpede"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/sergal
	name = "瑟伽尔（顶部）"
	icon_state = "fsergal"
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/datum/sprite_accessory/snout/front/toucan
	name = "巨嘴鸟（顶部）"
	icon_state = "ftoucan"
	color_keys = 2
	color_key_names = list("细节", "喙")

/datum/sprite_accessory/snout/front/redpanda
	name = "瓦库恩（顶部）"
	icon_state = "fwah"
	color_keys = 3
	color_key_names = list("吻部", "细节", "细节")

/datum/sprite_accessory/snout/front/redpandaalt
	name = "瓦库恩（变体）（顶部）"
	icon_state = "fwahalt"
	color_keys = 2
	color_key_names = list("吻部", "细节")

/datum/sprite_accessory/snout/front/skulldog
	name = "骷髅犬（顶部）"
	icon_state = "fskulldog"
	extra_state = TRUE
	color_keys = 2
	color_key_names = list("吻部", "内侧")

/*
---- azure snouts below this ----
*/

/datum/sprite_accessory/snout/shortnosed
	name = "短鼻"
	icon_state = "shortnosed"
	color_keys = 2
	color_key_names = list("吻部", "鼻子")

/datum/sprite_accessory/snout/stubby
	name = "短粗"
	icon_state = "stubby"
	color_keys = 2
	color_key_names = list("面具", "吻部")

/datum/sprite_accessory/snout/stubbyalt
	name = "短粗（变体）"
	icon_state = "stubbyalt"
	color_keys = 2
	color_key_names = list("吻部", "鼻子")

///CONSTRUCT-GOLEM ACCESORIES, MADE OF METAL///
/datum/sprite_accessory/snout/front/malum1
	name = "玛勒姆 1"
	icon_state = "malum1"

/datum/sprite_accessory/snout/front/malum2
	name = "玛勒姆 2"
	icon_state = "malum2"

/datum/sprite_accessory/snout/front/necran
	name = "内克拉"
	icon_state = "necran"

/datum/sprite_accessory/snout/front/abbysorian
	name = "阿比索尔"
	icon_state = "abbysorian"

/datum/sprite_accessory/snout/front/dendorite
	name = "登多尔"
	icon_state = "dendorite"

/datum/sprite_accessory/snout/front/pestran
	name = "佩斯特拉"
	icon_state = "pestran"

/datum/sprite_accessory/snout/front/ravoxian
	name = "拉沃克斯"
	icon_state = "ravoxian"

/datum/sprite_accessory/snout/front/eoran
	name = "伊欧拉"
	icon_state = "eoran"

/datum/sprite_accessory/snout/front/comedy1
	name = "喜剧 1"
	icon_state = "comedy1"

/datum/sprite_accessory/snout/front/comedy2
	name = "喜剧 2"
	icon_state = "comedy2"

/datum/sprite_accessory/snout/front/drama1
	name = "悲剧 1"
	icon_state = "drama1"

/datum/sprite_accessory/snout/front/drama2
	name = "悲剧 2"
	icon_state = "drama2"

/datum/sprite_accessory/snout/front/noccite
	name = "诺克石"
	icon_state = "noccite"
