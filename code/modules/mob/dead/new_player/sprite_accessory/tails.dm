/datum/sprite_accessory/tail
	abstract_type = /datum/sprite_accessory/tail
	icon = 'icons/mob/sprite_accessory/tails/tails.dmi'
	color_key_name = "尾巴"
	relevant_layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)
	var/can_wag = FALSE

/datum/sprite_accessory/tail/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDETAIL)

/datum/sprite_accessory/tail/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_UNDIES, OFFSET_UNDIES_F)

/datum/sprite_accessory/tail/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!can_wag)
		return ..()
	var/obj/item/organ/tail/tail_organ = organ
	if(!owner || !tail_organ.wagging)
		return ..()
	return "[icon_state]_wagging"

#ifdef UNIT_TESTS

/datum/sprite_accessory/tail/unit_testing_icon_states(list/states)
	states += icon_state
	if(can_wag)
		states += "[icon_state]_wagging"

#endif

/datum/sprite_accessory/tail/cat
	name = "猫"
	icon_state = "cat"
	relevant_layers = list(BODY_FRONT_LAYER)
	can_wag = TRUE

/datum/sprite_accessory/tail/monkey
	name = "猴"
	icon_state = "monkey"

/datum/sprite_accessory/tail/axolotl
	name = "美西螈"
	icon_state = "axolotl"

/datum/sprite_accessory/tail/batl
	name = "蝙蝠（长）"
	icon_state = "batl"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")
	can_wag = TRUE

/datum/sprite_accessory/tail/bats
	name = "蝙蝠（短）"
	icon_state = "bats"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")
	can_wag = TRUE

/datum/sprite_accessory/tail/bee
	name = "蜜蜂"
	icon_state = "bee"
	color_keys = 2
	color_key_names = list("腹部", "条纹")

/datum/sprite_accessory/tail/catbig
	name = "猫（大）"
	icon_state = "catbig"
	can_wag = TRUE

/datum/sprite_accessory/tail/twocat
	name = "猫（双尾）"
	icon_state = "twocat"
	can_wag = TRUE

/datum/sprite_accessory/tail/corvid
	name = "鸦"
	icon_state = "crow"

/datum/sprite_accessory/tail/cow
	name = "牛"
	icon_state = "cow"

/datum/sprite_accessory/tail/data_shark
	name = "数据鲨"
	icon_state = "datashark"
	color_keys = 2
	color_key_names = list("尾巴", "霓虹")
	can_wag = TRUE

/datum/sprite_accessory/tail/eevee
	name = "伊布"
	icon_state = "eevee"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")
	can_wag = TRUE

/datum/sprite_accessory/tail/fennec
	name = "耳廓狐"
	icon_state = "fennec"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")
	can_wag = TRUE

/datum/sprite_accessory/tail/fish
	name = "鱼"
	icon_state = "fish"
	can_wag = TRUE

/datum/sprite_accessory/tail/fox
	name = "狐狸"
	icon_state = "fox"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")
	can_wag = TRUE

/datum/sprite_accessory/tail/fox2
	name = "狐狸 2"
	icon_state = "fox2"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")
	can_wag = TRUE

/datum/sprite_accessory/tail/hawk
	name = "鹰"
	icon_state = "hawk"

/datum/sprite_accessory/tail/horse
	name = "马"
	icon_state = "horse"
	can_wag = TRUE

/datum/sprite_accessory/tail/husky
	name = "哈士奇"
	icon_state = "husky"
	color_keys = 2
	color_key_names = list("尾巴", "内侧")
	can_wag = TRUE

/datum/sprite_accessory/tail/insect
	name = "昆虫"
	icon_state = "insect"

/datum/sprite_accessory/tail/kangaroo
	name = "袋鼠"
	icon_state = "kangaroo"

/datum/sprite_accessory/tail/kitsune
	name = "狐妖"
	icon_state = "kitsune"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")

/datum/sprite_accessory/tail/lab
	name = "拉布拉多"
	icon_state = "lab"
	can_wag = TRUE

/datum/sprite_accessory/tail/murid
	name = "鼠族"
	icon_state = "murid"

/datum/sprite_accessory/tail/orca
	name = "虎鲸"
	icon_state = "orca"

/datum/sprite_accessory/tail/otie
	name = "奥图斯"
	icon_state = "otie"
	can_wag = TRUE

/datum/sprite_accessory/tail/rabbit
	name = "兔子"
	icon_state = "rabbit"
	can_wag = TRUE

/datum/sprite_accessory/tail/redpanda
	name = "小熊猫"
	icon_state = "wah"
	color_keys = 2
	color_key_names = list("尾巴", "条纹")
	can_wag = TRUE

/datum/sprite_accessory/tail/pede
	name = "蜈蚣王"
	icon_state = "pede"
	color_keys = 3
	color_key_names = list("尾巴", "内侧", "细节")

/datum/sprite_accessory/tail/sergal
	name = "瑟伽尔"
	icon_state = "sergal"
	color_keys = 2
	color_key_names = list("尾巴", "内侧")

/datum/sprite_accessory/tail/shark
	name = "鲨鱼"
	icon_state = "shark"
	can_wag = TRUE

/datum/sprite_accessory/tail/shepherd
	name = "牧羊犬"
	icon_state = "shepherd"
	color_keys = 2
	color_key_names = list("尾巴", "内侧")
	can_wag = TRUE

/datum/sprite_accessory/tail/australian_shepherd
	name = "澳洲牧羊犬"
	icon_state = "australianshepherd"
	color_keys = 2
	color_key_names = list("尾巴", "内侧")
	can_wag = TRUE

/datum/sprite_accessory/tail/jackal
	name = "胡狼"
	icon_state = "jackal"
	color_keys = 3
	color_key_names = list("尾巴", "内侧", "条纹")

/datum/sprite_accessory/tail/skunk
	name = "臭鼬"
	icon_state = "skunk"
	color_keys = 3
	color_key_names = list("尾巴", "内侧", "条纹")

/datum/sprite_accessory/tail/stripe
	name = "条纹"
	icon_state = "stripe"
	color_keys = 2
	color_key_names = list("尾巴", "内侧")

/datum/sprite_accessory/tail/straighttail
	name = "直尾"
	icon_state = "straighttail"
	can_wag = TRUE

/datum/sprite_accessory/tail/squirrel
	name = "松鼠"
	icon_state = "squirrel"
	can_wag = TRUE

/datum/sprite_accessory/tail/tamamo_kitsune
	name = "玉藻狐尾"
	icon_state = "9sune"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")
	can_wag = TRUE

/datum/sprite_accessory/tail/tentacle
	name = "触手"
	icon_state = "tentacle"
	can_wag = TRUE

/datum/sprite_accessory/tail/tiger
	name = "虎"
	icon_state = "tiger"
	color_keys = 3
	color_key_names = list("尾巴", "尖端", "条纹")
	can_wag = TRUE

/datum/sprite_accessory/tail/wolf
	name = "狼"
	icon_state = "wolf"
	can_wag = TRUE

/datum/sprite_accessory/tail/guilmon
	name = "基尔兽"
	icon_state = "guilmon"
	can_wag = TRUE

/datum/sprite_accessory/tail/sharknofin
	name = "鲨鱼（无鳍）"
	icon_state = "sharknofin"
	can_wag = TRUE

/datum/sprite_accessory/tail/raptor
	name = "迅猛龙"
	icon_state = "raptor"
	color_keys = 3
	color_key_names = list("尾巴", "细节", "细节")

/datum/sprite_accessory/tail/lunasune
	name = "月阳"
	icon_state = "lunasune"
	can_wag = TRUE

/datum/sprite_accessory/tail/spade
	name = "魅魔铲尾"
	icon_state = "spade"

/datum/sprite_accessory/tail/leopard
	name = "豹"
	icon_state = "leopard"
	color_keys = 2
	color_key_names = list("尾巴", "斑点")
	can_wag = TRUE

/datum/sprite_accessory/tail/deer
	name = "鹿"
	icon_state = "deer"
	color_keys = 2
	color_key_names = list("尾巴", "内侧")

/datum/sprite_accessory/tail/raccoon
	name = "浣熊"
	icon_state = "raccoon"
	color_keys = 2
	color_key_names = list("尾巴", "条纹")
	can_wag = TRUE

/datum/sprite_accessory/tail/sabresune
	name = "剑阳"
	icon_state = "sabresune"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")

/datum/sprite_accessory/tail/lizard
	abstract_type = /datum/sprite_accessory/tail/lizard
	icon = 'icons/mob/sprite_accessory/tails/lizard.dmi'
	can_wag = TRUE

/datum/sprite_accessory/tail/lizard/smooth
	name = "光滑"
	icon_state = "smooth"

/datum/sprite_accessory/tail/lizard/dtiger
	name = "暗虎"
	icon_state = "dtiger"

/datum/sprite_accessory/tail/lizard/ltiger
	name = "亮虎"
	icon_state = "ltiger"

/datum/sprite_accessory/tail/lizard/spikes
	name = "棘刺"
	icon_state = "spikes"

/datum/sprite_accessory/tail/lizard/kobold
	name = "狗头人"
	icon_state = "kobold"

/datum/sprite_accessory/tail/tiefling
	name = "提夫林"
	icon = 'icons/mob/sprite_accessory/tails/tiefling.dmi'
	icon_state = "tiebtail"
	color_key_defaults = list(KEY_SKIN_COLOR)
	can_wag = TRUE

/datum/sprite_accessory/tail/tiefling/heart
	name = "魅魔"
	icon = 'icons/mob/sprite_accessory/tails/tiefling.dmi'
	icon_state = "hearttail"
	color_key_defaults = list(KEY_SKIN_COLOR)
	can_wag = TRUE

/datum/sprite_accessory/tail/tiefling/spade
	name = "铲形"
	icon = 'icons/mob/sprite_accessory/tails/tiefling.dmi'
	icon_state = "spade"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/tail/dullahan
	name = "亡魂"
	icon = 'icons/mob/sprite_accessory/tails/tiefling.dmi'
	icon_state = "tiebtail"
	color_key_defaults = list(KEY_SKIN_COLOR)
	can_wag = TRUE

/datum/sprite_accessory/tail/dullahan/heart
	name = "魅魔"
	icon = 'icons/mob/sprite_accessory/tails/tiefling.dmi'
	icon_state = "hearttail"
	color_key_defaults = list(KEY_SKIN_COLOR)
	can_wag = TRUE

/datum/sprite_accessory/tail/rattlesnake
	name = "响尾蛇"
	icon_state = "rattlesnake"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")
	can_wag = TRUE

/datum/sprite_accessory/tail/lynx
	name = "猞猁"
	icon_state = "lynx"
	color_keys = 2
	color_key_names = list("尾巴", "尖端")

/datum/sprite_accessory/tail/shadekin
	name = "影族"
	icon_state = "shadekin"
	can_wag = TRUE

/datum/sprite_accessory/tail/shadekin/short
	name = "影族（短）"
	icon_state = "shadekinshort"

/datum/sprite_accessory/tail/owl
	name = "枭"
	icon_state = "owl"
	
/datum/sprite_accessory/tail/pinecone
	name = "松果"
	icon_state = "expi"
	color_keys = 2
	color_key_names = list("上部", "尖端")

/datum/sprite_accessory/tail/forked_long
	name = "长分叉"
	icon_state = "forked_long"

/datum/sprite_accessory/tail/haven
	name = "避风港"
	icon_state = "haven"

/datum/sprite_accessory/tail/swallow
	name = "燕"
	icon_state = "swallow"

/datum/sprite_accessory/tail/zorzor
	name = "佐尔戈娅"
	icon_state = "zorgoia"
	color_keys = 3
	color_key_names = list("尾巴", "尾部绒毛", "尾部倒刺")

/datum/sprite_accessory/tail/scorpian
	icon = 'modular/icons/mob/tails/manticore_tail.dmi'
	name = "蝎尾"
	icon_state = "scorpian"
	color_keys = 2
	color_key_names = list("尾巴", "尾针")

/datum/sprite_accessory/tail/manticore
	icon = 'modular/icons/mob/tails/manticore_tail.dmi'
	name = "蝎狮"
	icon_state = "manticore"
	color_keys = 3
	color_key_names = list("尾巴", "内脏", "棘刺")
	can_wag = TRUE

//From Caustic Cove
/datum/sprite_accessory/tail/large_snake
	icon = 'modular_causticcove/icons/mob/tails/large_snake.dmi'
	name = "巨蛇"
	icon_state = "large_snake"
	color_keys = 2
	color_key_names = list("尾巴", "腹部")

/datum/sprite_accessory/tail/large_snake_plain
	icon = 'modular_causticcove/icons/mob/tails/large_snake.dmi'
	name = "巨蛇（素色）"
	icon_state = "large_snake_plain"

// Not caustic cove, i just wanted it at the bottom tee hee.
/datum/sprite_accessory/tail/tailmaw
	name = "尾口"
	icon_state = "tailmaw"

/datum/sprite_accessory/tail/tailmaw2
	name = "尾口（摇摆）"
	icon_state = "tailmaw2"
	can_wag = TRUE

/datum/sprite_accessory/tail/tailmaw2_head
	name = "尾口（彩色头部）"
	icon_state = "tailmawwag_head"
	color_keys = 2
	color_key_names = list("尾巴", "头部")
	can_wag = TRUE

/datum/sprite_accessory/tail/tailmaw2_stripes
	name = "尾口（条纹）"
	icon_state = "tailmawwag_striped"
	color_keys = 2
	color_key_names = list("尾巴", "条纹")
	can_wag = TRUE

/datum/sprite_accessory/tail/tailmaw2_headstripes
	name = "尾口（条纹-彩色头部）"
	icon_state = "tailmawwag_stripedhead"
	color_keys = 3
	color_key_names = list("尾巴", "条纹", "头部")
	can_wag = TRUE
