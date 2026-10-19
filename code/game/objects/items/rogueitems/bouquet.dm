// BOUQUETS & FLOWER CROWNS

/obj/item/bouquet
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = ""
	item_state = ""

	grid_width = 32
	grid_height = 64
	dropshrink = 0.9

/obj/item/bouquet/rosa
	name = "玫瑰花束"
	desc = "被细绳束起的爱意。"
	item_state = "bouquet_rosa"
	icon_state = "bouquet_rosa"

/obj/item/bouquet/salvia
	name = "鼠尾草花束"
	desc = ""
	item_state = "bouquet_salvia"
	icon_state = "bouquet_salvia"

/obj/item/bouquet/matricaria
	name = "洋甘菊花束"
	desc = ""
	item_state = "bouquet_matricaria"
	icon_state = "bouquet_matricaria"

/obj/item/bouquet/calendula
	name = "金盏花花束"
	desc = ""
	item_state = "bouquet_calendula"
	icon_state = "bouquet_calendula"

/obj/item/flowercrown
	name = ""
	desc = ""
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	alternate_worn_layer  = 8.9 //On top of helmet
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = null
	icon_state = ""
	item_state = ""
	experimental_inhand = FALSE
	dropshrink = 0.9

	grid_width = 64
	grid_height = 32

/obj/item/flowercrown/rosa
	name = "玫瑰花冠"
	desc = ""
	item_state = "rosa_crown"
	icon_state = "rosa_crown"

/obj/item/flowercrown/matricaria
	name = "洋甘菊花冠"
	item_state = "matricaria_crown"
	icon_state = "matricaria_crown"

/obj/item/flowercrown/calendula
	name = "金盏花花冠"
	item_state = "calendula_crown"
	icon_state = "calendula_crown"

/obj/item/flowercrown/manabloom
	name = "法绽花花冠"
	desc = "一顶由法绽花编成的花冠，常由想要 \
	加深奥术感应的人佩戴；年轻学徒和日渐衰弱的老法师都很喜爱它。"
	item_state = "manabloom_crown"
	icon_state = "manabloom_crown"

/obj/item/flowercrown/salvia
	name = "鼠尾草花冠"
	item_state = "salvia_crown"
	icon_state = "salvia_crown"

/obj/item/flowercrown/rosa/thorns
	name = "带刺玫瑰花冠"
	desc = "美丽即痛苦，苦难亦美丽。"
	item_state = "rosecirclet"
	icon_state = "rosecirclet"

/obj/item/flowercrown/rosa/thorns/pickup(mob/living/user)
	. = ..()
	to_chat(user, span_warning ("尖刺扎着我，却让我感到愉悦。"))
	user.adjustBruteLoss(4)

/obj/item/flowercrown/rosa/dyecrown
	name = "花冠"
	desc = "一顶简单的花冠，似乎很容易染色。"
	item_state = "flower"
	icon_state = "flower"
	color = "#FFFFFF"
	detail_color = "#ffffff"
	detail_tag = "_detail"

/obj/item/flowercrown/rosa/dyecrown/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
