/datum/sprite_accessory/ears
	abstract_type = /datum/sprite_accessory/ears
	icon = 'icons/mob/sprite_accessory/ears/ears.dmi'
	color_key_name = "Ears"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	var/can_flick = FALSE

/datum/sprite_accessory/ears/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!can_flick)
		return ..()
	var/obj/item/organ/ears/ear_organ = organ
	if(!owner || !ear_organ.is_flicking)
		return ..()
	if(ear_organ.is_flicking && can_flick)
		return "[icon_state]_flick"

/datum/sprite_accessory/ears/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEEARS)

/datum/sprite_accessory/ears/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/ears/big
	icon = 'icons/mob/sprite_accessory/ears/ears_big.dmi'

/datum/sprite_accessory/ears/cat
	name = "Cat"
	icon_state = "cat"
	extra_state = TRUE
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/ears/axolotl
	name = "美西螈"
	icon_state = "axolotl"

/datum/sprite_accessory/ears/bat
	name = "Bat"
	icon_state = "bat"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/bear
	name = "熊"
	icon_state = "bear"

/datum/sprite_accessory/ears/bigwolf
	name = "Big Wolf"
	icon_state = "bigwolf"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/bigwolf_inner
	name = "大狼（内耳）"
	icon_state = "bigwolf_inner"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")
	extra_state = TRUE

/datum/sprite_accessory/ears/bunny
	name = "兔子"
	icon_state = "bunny"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/bunny_perky
	name = "Bunny (Perky)"
	icon_state = "bunny_perky"
	color_keys = 3
	color_key_names = list("Ears", "Inner", "Tips")

/datum/sprite_accessory/ears/cat_big
	name = "猫（大）"
	icon_state = "catbig"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/cat_normal
	name = "猫（标准）"
	icon_state = "catnormal"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/cow
	name = "牛"
	icon_state = "cow"

/datum/sprite_accessory/ears/curled
	name = "卷角"
	icon_state = "horn"

/datum/sprite_accessory/ears/deer
	name = "Deer"
	icon_state = "deer"

/datum/sprite_accessory/ears/eevee
	name = "伊布"
	icon_state = "eevee"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/elf
	name = "精灵"
	icon_state = "elf"
	can_flick = TRUE

/datum/sprite_accessory/ears/elephant
	name = "象"
	icon_state = "elephant"

/datum/sprite_accessory/ears/fennec
	name = "耳廓狐"
	icon_state = "fennec"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/fish
	name = "鱼"
	icon_state = "fish"

/datum/sprite_accessory/ears/fox
	name = "狐狸"
	icon_state = "fox"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/vulp
	name = "维纳丁"
	icon_state = "vulp"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/husky
	name = "哈士奇"
	icon_state = "wolf"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/jellyfish
	name = "Jellyfish"
	icon_state = "jellyfish"

/datum/sprite_accessory/ears/kangaroo
	name = "袋鼠"
	icon_state = "kangaroo"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/lab
	name = "犬（长耳）"
	icon_state = "lab"

/datum/sprite_accessory/ears/murid
	name = "鼠族"
	icon_state = "murid"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/otie
	name = "奥图斯"
	icon_state = "otie"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/rabbit
	name = "家兔"
	icon_state = "rabbitlop"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/bunny_long
	name = "兔子（长耳）"
	icon_state = "bunnylong"
	color_keys = 2
	color_key_names = list("耳朵", "耳尖")

/datum/sprite_accessory/ears/big/rabbit_large
	name = "兔耳（大）"
	icon_state = "rabbit_large"
	color_keys = 3
	color_key_names = list("耳朵", "内耳", "耳尖")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/pede
	name = "蜈蚣王"
	icon_state = "pede"
	color_keys = 2
	color_key_names = list("耳朵", "细节")

/datum/sprite_accessory/ears/sergal
	name = "瑟伽尔"
	icon_state = "sergal"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/shark
	name = "Shark"
	icon_state = "shark"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/skunk
	name = "臭鼬"
	icon_state = "skunk"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/squirrel
	name = "松鼠"
	icon_state = "squirrel"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/wolf
	name = "狼"
	icon_state = "wolf"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/perky
	name = "Perky"
	icon_state = "perky"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/antenna_simple1
	name = "Insect antenna 1"
	icon_state = "antenna_simple1"

/datum/sprite_accessory/ears/antenna_simple2
	name = "Insect antenna 2"
	icon_state = "antenna_simple2"

/datum/sprite_accessory/ears/antenna_simple3
	name = "昆虫触角 3"
	icon_state = "antenna_simple3"

/datum/sprite_accessory/ears/antenna_simple4
	name = "昆虫触角 4"
	icon_state = "antenna_simple4"

/datum/sprite_accessory/ears/antenna_fuzzball1
	name = "绒球触角 1"
	icon_state = "antenna_fuzzball1"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/antenna_fuzzball2
	name = "Fuzzball antenna 2"
	icon_state = "antenna_fuzzball2"
	color_keys = 2
	color_key_names = list("Ears", "Inner")

/datum/sprite_accessory/ears/cobrahood
	name = "Cobra Hood"
	icon_state = "cobrahood"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/cobrahoodears
	name = "眼镜蛇颈罩（耳）"
	icon_state = "cobraears"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/miqote
	name = "猫魅族"
	icon_state = "miqote"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/lunasune
	name = "月阳"
	icon_state = "lunasune"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/sabresune
	name = "剑阳"
	icon_state = "sabresune"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")
	extra_state = TRUE

/datum/sprite_accessory/ears/possum
	name = "负鼠"
	icon_state = "possum"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/raccoon
	name = "浣熊"
	icon_state = "raccoon"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/mouse
	name = "老鼠"
	icon_state = "mouse"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")

/datum/sprite_accessory/ears/elf
	name = "精灵"
	icon = 'icons/mob/sprite_accessory/elf.dmi'
	icon_state = "elf"
	color_key_defaults = list(KEY_SKIN_COLOR)
	can_flick = TRUE

/datum/sprite_accessory/ears/elfw
	name = "精灵（木精灵）"
	icon = 'icons/mob/sprite_accessory/elf.dmi'
	icon_state = "elfw"
	color_key_defaults = list(KEY_SKIN_COLOR)
	can_flick = TRUE

/datum/sprite_accessory/ears/halforc
	name = "半兽人"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "halforc"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/goblin
	name = "哥布林"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "goblin"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/goblin_alt
	name = "Goblin Alt"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "goblinalt"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/goblin_small
	name = "哥布林（小）"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "goblinsmall"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/ears/big
	icon = 'icons/mob/sprite_accessory/ears/ears_big.dmi'

/datum/sprite_accessory/ears/big/rabbit_large
	name = "兔耳（大）"
	icon_state = "rabbit_large"
	color_keys = 3
	color_key_names = list("耳朵", "内耳", "耳尖")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/big/acrador_long
	icon_state = "acrador_long"
	name = "阿克拉多（长）"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/big/acrador_short
	icon_state = "acrador_short"
	name = "阿克拉多（短）"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/big/sandfox_large
	icon_state = "sandfox"
	name = "Sandfox"
	color_keys = 2
	color_key_names = list("Ears", "Inner")
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/lynx
	name = "猞猁"
	icon_state = "lynx"
	color_keys = 3
	color_key_names = list("耳朵", "内耳", "耳尖")
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER, BODY_ADJ_LAYER)

/datum/sprite_accessory/ears/shadekin
	name = "影族"
	icon_state = "m_ears_shadekin"
	color_keys = 2
	color_key_names = list("耳朵", "内耳")
	relevant_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/ears/four_ears
	name = "Four Ears"
	icon_state = "four_ears"
	color_keys = 2
	color_key_names = list("Ears", "Details")
	relevant_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/ears/shadekin/band_left
	name = "影族（左环）"
	icon_state = "m_ears_shadekinbandleft"

/datum/sprite_accessory/ears/shadekin/band_right
	name = "影族（右环）"
	icon_state = "m_ears_shadekinbandright"

/datum/sprite_accessory/ears/shadekin/fluffy
	name = "Shadekin (Fluffy)"
	icon_state = "m_ears_shadekinfluffy"

/datum/sprite_accessory/ears/shadekin/smooth
	name = "影族（光滑）"
	icon_state = "m_ears_shadekinsmooth"

///CONSTRUCT-GOLEM ACCESORIES, MADE OF METAL///
/datum/sprite_accessory/ears/dendorite
	name = "Dendorite Construct"
	icon_state = "dendorite"

/datum/sprite_accessory/ears/eoran
	name = "埃奥兰构装体"
	icon_state = "eoran"

/datum/sprite_accessory/ears/pestran
	name = "Pestran Construct"
	icon_state = "pestran"

/datum/sprite_accessory/ears/zorzor
	name = "佐尔戈娅"
	icon_state = "zorgoia"
	color_keys = 3
	color_key_names = list("耳朵", "内耳", "耳尖")
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER, BODY_ADJ_LAYER)
