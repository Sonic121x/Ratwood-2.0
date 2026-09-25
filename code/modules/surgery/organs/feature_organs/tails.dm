/obj/item/organ/tail
	name = "尾巴"
	desc = "一条被切下的尾巴。你从什么东西身上割下来的？"
	icon_state = "severedtail"
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TAIL
	var/can_wag = TRUE
	var/wagging = FALSE

/obj/item/organ/tail/cat
	name = "猫尾"
	desc = "一条被切下的猫尾。现在谁还摇得起来？"
	accessory_type = /datum/sprite_accessory/tail/catbig

/obj/item/organ/tail/lizard
	name = "西塞亚尾巴"
	desc = "一条被切下的蜥蜴尾巴。不用说，某个憎恨蜥蜴的家伙正为此洋洋得意。"
	color = "#116611"
	accessory_type = /datum/sprite_accessory/tail/lizard/smooth

/obj/item/organ/tail/lizard/fake
	name = "人造蜥蜴尾巴"
	desc = "一条人造的断蜥尾，由合成血肉制成。大概不能用来泡蜥蜴酒。"

/obj/item/organ/tail/monkey
	name = "猴尾"
	desc = "一条被切下的猴尾。看起来不像香蕉。"
	icon_state = "severedmonkeytail"
	accessory_type = /datum/sprite_accessory/tail/monkey

/obj/item/organ/tail/anthro
	name = "兽裔尾巴"

/obj/item/organ/tail/lupian
	name = "卢皮安尾巴"

/obj/item/organ/tail/avali
	name = "阿瓦利尾巴"

/obj/item/organ/tail/vulpkanin
	name = "维纳丁尾巴"
	accessory_type = /datum/sprite_accessory/tail/fox
	accessory_colors = "#fc8803#fff8f0"

/obj/item/organ/tail/tajaran
	name = "塔巴西尾巴"

/obj/item/organ/tail/vox
	name = "沃克斯尾巴"

/obj/item/organ/tail/synth
	name = "合成尾巴"

/obj/item/organ/tail/xeno
	name = "异形尾巴"

/obj/item/organ/tail/tiefling
	name = "提夫林尾巴"
	accessory_type =  /datum/sprite_accessory/tail/tiefling

/obj/item/organ/tail/dullahan
	name = "亡魂尾巴"
	accessory_type =  /datum/sprite_accessory/tail/dullahan

/obj/item/organ/tail/akula
	name = "阿克西安尾巴"
	accessory_type =  /datum/sprite_accessory/tail/shark

/obj/item/organ/tail/lizard
	name = "西塞亚尾巴"
	desc = ""
	color = "#116611"
	accessory_type =  /datum/sprite_accessory/tail/lizard/smooth

/obj/item/organ/tail/kobold
	name = "狗头人尾巴"
	desc = ""
	color = "#116611"
	accessory_type =  /datum/sprite_accessory/tail/lizard/kobold

/obj/item/organ/tail/harpy
	name = "哈比尾羽"
	desc = "为什么？"
