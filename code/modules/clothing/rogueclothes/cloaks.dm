/obj/item/clothing/cloak
	name = "斗篷"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_CLOAK
	desc = "既能为你遮风挡雨，也能向旁人隐藏身份。"
	edelay_type = 1
	equip_delay_self = 10
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE //Vrell - AFAIK, all cloaks are cloth ATM. Technically semi-less future-proof, but it removes a line of code from every subtype, which is worth it IMO.
	experimental_inhand = FALSE
	color = null
	allowed_sex = list(MALE, FEMALE)

	grid_width = 64
	grid_height = 64
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

//////////////////////////
/// TABARD
////////////////////////

/obj/item/clothing/cloak/tabard
	name = "罩袍"
	desc = "一种为骑士准备的长款外罩。"
	icon_state = "tabard"
	item_state = "tabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/picked
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak
	var/overarmor = TRUE

/obj/item/clothing/cloak/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("鼠标中键点击斗篷可调整其图层，使其能显示在任何已穿戴护甲的上方或下方。")

/obj/item/clothing/cloak/MiddleClick(mob/user)
	overarmor = !overarmor

	var/restored_layer = initial(alternate_worn_layer) || TABARD_LAYER
	alternate_worn_layer = overarmor ? restored_layer : UNDER_ARMOR_LAYER

	var/where = "护甲下"
	if(overarmor)
		where = (restored_layer == CLOAK_BEHIND_LAYER) ? "身后" : "护甲外"
	to_chat(user, span_info("我将[src]穿戴在[where]。"))

	user.update_inv_cloak()
	user.update_inv_armor()
	user.update_inv_back()

/obj/item/clothing/cloak/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

/obj/item/clothing/cloak/tabard/black
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/abyssortabard
	name = "阿比索尔信徒罩袍"
	desc = "阿比索尔虔诚信徒所穿的罩袍。"
	icon_state = "abyssortabard"
	item_state = "abyssortabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/reformtabard
	name = "改革派罩袍"
	desc = "黑底白色普赛十字。它属于那些仍在哀悼、却敢于在无尽悲伤中继续活下去的人。愿我们对祂的追忆抚平仍在流血的心。"
	icon_state = "reformtabard"
	item_state = "reformtabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/psydontabard
	name = "普赛顿罩袍"
	desc = "普赛顿门徒所穿的罩袍。精致的刺绣自豪地彰显着普赛十字。"
	icon_state = "psydontabard"
	item_state = "psydontabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/open_wear = FALSE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/psydontabard/alt
	name = "敞开的普赛顿罩袍"
	desc = "普赛顿门徒所穿的罩袍，衣襟被翻开，露出其坚忍不屈的内里。"
	body_parts_covered = GROIN
	icon_state = "psydontabardalt"
	item_state = "psydontabardalt"
	flags_inv = HIDECROTCH
	open_wear = TRUE

/obj/item/clothing/cloak/psydontabard/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "敞开的普赛顿罩袍"
			desc = "普赛顿门徒所穿的罩袍，衣襟被翻开，露出其坚忍不屈的内里。"
			body_parts_covered = GROIN
			icon_state = "psydontabardalt"
			item_state = "psydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH // BARE YOUR CHEST, NOT YOUR WEEN!
			to_chat(usr, span_warning("现在以激进方式穿着！"))
		if(TRUE)
			name = "普赛顿罩袍"
			desc = "普赛顿门徒所穿的罩袍。精致的刺绣自豪地彰显着普赛十字。"
			body_parts_covered = CHEST|GROIN
			icon_state = "psydontabard"
			item_state = "psydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("现在以正常方式穿着！"))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/tabard/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("无", "徽记", "分割", "四分", "方格", "菱纹")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	var/symbol_chosen = FALSE
	if(design == "徽记")
		design = null
		design = input(user, "选择一个徽记。","罩袍样式") as null|anything in list("圣杯","普赛顿之印","和平之印","齐佐之印","小恶魔","骷髅","蜘蛛","箭头")
		if(!design)
			return
		design = "_[list("圣杯" = "chalice", "普赛顿之印" = "psy", "和平之印" = "peace", "齐佐之印" = "z", "小恶魔" = "imp", "骷髅" = "skull", "蜘蛛" = "widow", "箭头" = "arrow")[design]]"
		symbol_chosen = TRUE
	var/colorone = input(user, "选择主色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
	if(!colorone)
		return
	var/colortwo
	if(design != "无")
		colortwo = input(user, "选择副色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
		if(!colortwo)
			return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design != "无")
		detail_tag = design
	switch(design)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	boobed_detail = !symbol_chosen
	color = clothing_color2hex(colorone)
	if(colortwo)
		detail_color = clothing_color2hex(colortwo)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		boobed_detail = initial(boobed_detail)
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/knight
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/tabard/knight/attack_right(mob/user)
	return

/obj/item/clothing/cloak/tabard/knight/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/knight/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/tabard/crusader
	detail_tag = "_psy"
	detail_color = CLOTHING_RED
	boobed_detail = FALSE

/obj/item/clothing/cloak/tabard/crusader/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/tabard/crusader/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("默认", "金十字", "杰鲁亚", "黑金", "黑白")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "金十字")
		detail_color = "#b5b004"
	if(design == "杰鲁亚")
		detail_color = "#b5b004"
		color = "#249589"
	if(design == "黑金")
		detail_color = CLOTHING_YELLOW
		color = CLOTHING_BLACK
	if(design == "黑白")
		detail_color = CLOTHING_WHITE
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/crusader/tief
	color = CLOTHING_RED
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/crusader/astrata
	color = "#9B7538"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/crusader/ravox
	color = CLOTHING_RED
	detail_color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/crusader/malum
	color = CLOTHING_RED
	detail_color = CLOTHING_YELLOW

/obj/item/clothing/cloak/tabard/crusader/abyssor
	color = "#373f69"
	detail_color = "#974305"

/obj/item/clothing/cloak/tabard/crusader/dendor
	color = "#4B5637"
	detail_color = "#3D1D1C"

/obj/item/clothing/cloak/tabard/crusader/necra
	color = "#222223"
	detail_color = "#CACBC5"

/obj/item/clothing/cloak/tabard/crusader/pestra
	color = CLOTHING_WHITE
	detail_color = CLOTHING_GREEN

/obj/item/clothing/cloak/tabard/crusader/noc
	color = "#2C2231"
	detail_color = "#9AB0B0"

/obj/item/clothing/cloak/tabard/crusader/psydon
	color = CLOTHING_BLACK
	detail_color = CLOTHING_WHITE

//Eora content from Stonekeep

/obj/item/clothing/cloak/tabard/crusader/eora
	color = "#4D1E49"
	detail_color = "#A95650"


/obj/item/clothing/cloak/tabard/crusader/tief/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("默认", "红黑", "黑红")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "红黑")
		detail_color = CLOTHING_BLACK
		color = CLOTHING_RED
	if(design == "黑红")
		detail_color = CLOTHING_RED
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/retinue
	desc = "带有领主纹章配色的罩袍。"
	color = CLOTHING_AZURE
	detail_tag = "_quad"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/retinue/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "选择一种样式。","罩袍样式") as null|anything in list("分割", "四分", "方格", "菱纹")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/retinue/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/retinue/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/tabard/retinue/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/tabard/retinue/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/tabard/retinue/captain //Because of his other snowflake cloak we can't actually use the naming normally.
	name = "队长罩袍"

/obj/item/clothing/cloak/tabard/retinue/baronycloak
	desc = "带有男爵纹章配色的罩袍。"

/obj/item/clothing/cloak/tabard/retinue/baronycloak/Initialize(mapload)
	. = ..()
	GLOB.lordcolor -= src
	if(GLOB.baronprimary)
		baronycolor(GLOB.baronprimary,GLOB.baronsecondary)
	GLOB.baronycolor += src

/obj/item/clothing/cloak/tabard/retinue/baronycloak/lordcolor(primary,secondary)
	return //ignores the ducal scheme, only the barony one applies

/obj/item/clothing/cloak/tabard/retinue/baronycloak/baronycolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/tabard/retinue/baronycloak/Destroy()
	GLOB.baronycolor -= src
	return ..()

//////////////////////////
/// SOLDIER TABARD
////////////////////////

/obj/item/clothing/cloak/stabard
	name = "士兵罩袍"
	desc = "士兵们常穿的一种外罩衣物。"
	icon_state = "stabard"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/picked
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/stabard/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("无","分割", "四分", "方格", "菱纹")
	if(!design)
		return
	var/colorone = input(user, "选择主色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
	if(!colorone)
		return
	var/colortwo
	if(design != "无")
		colortwo = input(user, "选择副色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
		if(!colortwo)
			return
	if(world.time > (the_time + 30 SECONDS))
		return
	switch(design)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	color = clothing_color2hex(colorone)
	if(colortwo)
		detail_color = clothing_color2hex(colortwo)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		boobed_detail = initial(boobed_detail)
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/guard
	name = "守卫罩袍"
	desc = "带有领主纹章配色的罩袍。"
	color = CLOTHING_AZURE
	detail_tag = "_spl"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/stabard/guard/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "选择一种样式。","罩袍样式") as null|anything in list("分割", "四分", "方格", "菱纹")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/guard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/stabard/guard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/stabard/guard/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/stabard/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/stabard/bog
	name = "沼民罩袍"
	desc = "一件以沼泽伟大守护者那荣耀绿色染成的罩袍。" // THE BOG DESERVES A BETTER DESCRIPTION!
	color = CLOTHING_GREEN
	detail_color = CLOTHING_DARK_GREEN

/obj/item/clothing/cloak/stabard/grenzelhoft
	name = "格伦泽尔霍夫特佣兵罩袍"
	desc = "一件采用格伦泽尔霍夫特帝国佣兵公会配色的罩袍。"
	color = CLOTHING_YELLOW
	detail_color = CLOTHING_RED
	detail_tag = "_box"

/obj/item/clothing/cloak/stabard/dungeon
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/stabard/dungeon/attack_right(mob/user)
	return

/obj/item/clothing/cloak/stabard/mercenary
	detail_tag = "_quad"

/obj/item/clothing/cloak/stabard/mercenary/Initialize(mapload)
	. = ..()
	detail_tag = pick("_quad", "_spl", "_box", "_dim")
	color = clothing_color2hex(pick(CLOTHING_COLOR_NAMES))
	detail_color = clothing_color2hex(pick(CLOTHING_COLOR_NAMES))
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

//////////////////////////
/// SURCOATS
////////////////////////

/obj/item/clothing/cloak/stabard/surcoat
	name = "战袍"
	icon_state = "surcoat"

/obj/item/clothing/cloak/stabard/surcoat/bailiff
	color = "#641E16"

/obj/item/clothing/cloak/stabard/surcoat/councillor
	color = "#2d2d2d"

/obj/item/clothing/cloak/stabard/surcoat/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("无","分割", "四分", "方格", "菱纹")
	if(!design)
		return
	var/colorone = input(user, "选择主色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
	if(!colorone)
		return
	var/colortwo
	if(design != "无")
		colortwo = input(user, "选择副色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
		if(!colortwo)
			return
	if(world.time > (the_time + 30 SECONDS))
		return
	switch(design)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	color = clothing_color2hex(colorone)
	if(colortwo)
		detail_color = clothing_color2hex(colortwo)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/surcoat/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/stabard/surcoat/guard
	desc = "带有领主纹章配色的战袍。"
	color = CLOTHING_AZURE
	detail_tag = "_quad"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/stabard/surcoat/guard/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "选择一种样式。","罩袍样式") as null|anything in list("分割", "四分", "方格", "菱纹")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/surcoat/guard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/stabard/surcoat/guard/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/stabard/surcoat/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/stabard/black
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/lordcloak
	name = "领主斗篷"
	desc = "饰有白鼬毛边，代代相传。"
	icon_state = "lord_cloak"
	item_state = "lord_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
//	allowed_sex = list(MALE)
	detail_tag = "_det"
	detail_color = CLOTHING_AZURE
	cold_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/lordcloak/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/lordcloak/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/lordcloak/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/lordcloak/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/lordcloak/baronycloak
	name = "男爵领斗篷"
	desc = "一件采用低镇男爵领纹章配色的斗篷。"

/obj/item/clothing/cloak/lordcloak/baronycloak/lordcolor(primary,secondary)
	return //ignores the ducal scheme, only the barony one applies

/obj/item/clothing/cloak/lordcloak/baronycloak/baronycolor(primary,secondary)
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/lordcloak/baronycloak/Initialize(mapload)
	. = ..()
	GLOB.lordcolor -= src
	if(GLOB.baronprimary)
		baronycolor(GLOB.baronprimary,GLOB.baronsecondary)
	GLOB.baronycolor += src

/obj/item/clothing/cloak/lordcloak/baronycloak/Destroy()
	GLOB.baronycolor -= src
	return ..()

/obj/item/clothing/cloak/darkcloak
	name = "黑斗篷"
	desc = "它能温暖你的皮肉，却温暖不了你冰冷死寂的心。"
	icon_state = "dark_cloak"
	item_state = "dark_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	allowed_race = NON_DWARVEN_RACE_TYPES
	salvage_result = /obj/item/natural/fur
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/darkcloak/bear
	name = "恐熊斗篷"
	desc = "由最上等、最暖和的熊皮制成。它或许比你的命还值钱。"
	icon_state = "bear_cloak"
	item_state = "bear_cloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = CLOTHED_RACES_TYPES
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 3
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/darkcloak/bear/light
	name = "轻型恐熊斗篷"
	icon_state = "bbear_cloak"
	item_state = "bbear_cloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 3

/obj/item/clothing/cloak/darkcloak/bear/wardenmaster
	name = "守林总长战利斗篷"
	desc = "由最强壮、最凶猛的黑色恐熊毛皮制成。作为杰出猎手的标志，它以下城区男爵的胸针扣合。"
	sellprice = 80
	color = "#99a39d"

/obj/item/clothing/cloak/darkcloak/minotaur
	name = "牛头怪斗篷"
	desc = "牛头怪毛皮与稻草被粗糙地缝成一件长披肩。"
	icon_state = "mino"
	item_state = "mino"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 4

/obj/item/clothing/cloak/darkcloak/minotaur/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/apron/maid
	name = "女仆围裙"
	desc = "宅邸管事穿的荷叶边围裙，上面有能放小东西的口袋。"
	detail_color = "_detail"
	slot_flags = ITEM_SLOT_ARMOR | ITEM_SLOT_CLOAK
	detail_color = CLOTHING_BLACK
	icon_state = "maidapron"
	item_state = "maidapron"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	boobed = FALSE
	grid_width = 64
	grid_height = 64

/obj/item/clothing/cloak/apron
	name = "围裙"
	desc = "许多工坊工人都会使用的围裙。"
	icon_state = "apron"
	item_state = "apron"
	color = "#c9c3bd"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	allowed_race = CLOTHED_RACES_TYPES
	flags_inv = HIDECROTCH|HIDEBOOB
	hiked_base_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	hiked_overlay_icon = 'icons/roguetown/clothing/onmob/hiked/hiked_cloaks.dmi'
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX
	dropshrink = null

/obj/item/clothing/cloak/apron/blacksmith
	name = "皮围裙"
	desc = "由锻冶金属、操作熔炉之人使用的皮围裙。"
	icon_state = "leather_apron"
	item_state = "leather_apron"
	body_parts_covered = CHEST|GROIN
	armor = ARMOR_CLOTHING
	boobed = TRUE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/cloak/apron/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/apron/waist
	name = "腰围裙"
	desc = "一条系在腰间的简便围裙，方便干活时使用。"
	color = "#c9c3bd" //default spawns are less eye-searingly white
	icon_state = "waistpron"
	item_state = "waistpron"
	body_parts_covered = GROIN
	boobed = FALSE
	flags_inv = HIDECROTCH

/obj/item/clothing/cloak/apron/waist/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/apron/waist/bar
	color = "#251f1d"


/obj/item/clothing/cloak/apron/cook
	name = "厨师围裙"
	desc = "一条专门用来彰显厨师有多干净的围裙。"
	icon_state = "aproncook"
	item_state = "aproncook"
	body_parts_covered = GROIN
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	boobed = FALSE

/*
/obj/item/clothing/cloak/apron/waist/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 1

/obj/item/clothing/cloak/apron/waist/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	CP.on_attack_hand(CP, user)
	return TRUE*/

/obj/item/clothing/cloak/raincloak
	name = "雨披"
	desc = "这件能帮你抵挡雨天。"
	icon_state = "rain_cloak"
	item_state = "rain_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	hoodtype = /obj/item/clothing/head/hooded/rainhood
	toggle_icon_state = FALSE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/cloak/raincloak/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/raincloak/mortus
	desc = "死亡始终笼罩着你。"
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/raincloak/brown
	color = CLOTHING_BROWN
	sellprice = 25

/obj/item/clothing/cloak/raincloak/green
	color = CLOTHING_GREEN

/obj/item/clothing/cloak/raincloak/blue
	color = CLOTHING_BLUE

/obj/item/clothing/cloak/raincloak/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/raincloak/drab
	color = CLOTHING_DRAB
/obj/item/clothing/cloak/raincloak/darkdrab
	color = CLOTHING_DARKDRAB

/obj/item/clothing/cloak/raincloak/white
	color = CLOTHING_WHITE

/obj/item/clothing/head/hooded/rainhood
	name = "兜帽"
	desc = "它既能替我遮挡风雨，也能掩住我的身份。"
	icon_state = "rain_hood"
	item_state = "rain_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
/obj/item/clothing/cloak/raincloak/furcloak
	name = "毛皮斗篷"
	desc = "这件华美斗篷由兽皮制成，十分柔软而温暖。"
	icon_state = "furgrey"
	inhand_mod = FALSE
	hoodtype = /obj/item/clothing/head/hooded/rainhood/furhood
	salvage_result = /obj/item/natural/fur
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/raincloak/furcloak/crafted/Initialize(mapload)
	. = ..()
	if(prob(50))
		color = pick("#685542","#66564d")

/obj/item/clothing/cloak/raincloak/furcloak/brown
	color = "#685542"

/obj/item/clothing/cloak/raincloak/furcloak/black
	color = "#2b292e"

/obj/item/clothing/cloak/raincloak/furcloak/darkgreen
	color = "#264d26"

/obj/item/clothing/cloak/raincloak/furcloak/woad
	name = "靛纹斗篷"
	desc = "一件以靛蓝染色的毛皮斗篷，既保暖又带着浓厚的林地风格。"
	color = "#597fb9"

/obj/item/clothing/head/hooded/rainhood/furhood
	icon_state = "fur_hood"
	block2add = FOV_BEHIND
	cold_protection = HEAD
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/lepoardcloak
	name = "豹皮斗篷"
	desc = "这件华贵斗篷由豹皮制成，唯有最富有、最显赫之人才配穿戴。"
	icon_state = "lepoardcape"
	inhand_mod = FALSE
	salvage_result = /obj/item/natural/fur
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/cape
	name = "披风"
	desc = "一件美丽而飘逸的披风。可惜太容易被植被挂住。"
	icon_state = "cape"
	item_state = "cape"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/cape/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/cape/knight
	color = CLOTHING_WHITE

/obj/item/clothing/cloak/cape/guard
	color = CLOTHING_AZURE

/obj/item/clothing/cloak/cape/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/cape/guard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/cape/guard/lordcolor(primary,secondary)
	color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
/obj/item/clothing/cloak/cape/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()


/obj/item/clothing/cloak/cape/puritan
	icon_state = "puritan_cape"
	allowed_race = CLOTHED_RACES_TYPES
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/cloak/cape/archivist
	icon_state = "puritan_cape"
	color = CLOTHING_BLACK
	allowed_race = CLOTHED_RACES_TYPES

/obj/item/clothing/cloak/cape/inquisitor
	name = "仲裁者斗篷"
	desc = "奥塔瓦仲裁者所披的斗篷，他们是宗教裁判所中的一种战士祭司。 \
	正如它的主人一样，这件斗篷多半也见过一些骇人的景象。"
	icon_state = "inquisitor_cloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/cape/rogue
	name = "盗贼披风"
	icon_state = "roguecape"
	item_state = "roguecape"

/obj/item/clothing/cloak/cape/hood
	name = "连兜帽披风"
	icon_state = "hoodcape"
	item_state = "hoodcape"

/obj/item/clothing/cloak/chasuble
	name = "祭披"
	desc = ""
	icon_state = "chasuble"
	body_parts_covered = CHEST|GROIN|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES


/obj/item/clothing/cloak/stole
	name = "圣带"
	desc = ""
	icon_state = "stole_gold"
	item_state = "stole_gold"
	sleeved = null
	sleevetype = null
	body_parts_covered = null
	flags_inv = null
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/stole/red
	icon_state = "stole_red"
	item_state = "stole_red"

/obj/item/clothing/cloak/stole/purple
	icon_state = "stole_purple"

/obj/item/clothing/cloak/black_cloak
	name = "黑色斗篷"
	desc = "黑得深沉的斗篷，仿佛会把整个人都藏进阴影里。"
	icon_state = "black_cloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES
	sellprice = 50
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/cloak/heartfelt
	name = "心念斗篷"
	desc = ""
	icon_state = "heartfelt_cloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES
	sellprice = 50
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/undivided
	name = "教廷斗篷"
	desc = "教廷的象征。终末之日已近在眼前，羔羊啊。你仍要执着于希望吗？"
	icon_state = "seecloak"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK

//don't make a subtype of this unless you can account for it flipping side to side when you right click
/obj/item/clothing/cloak/half
	name = "半斗篷"
	desc = ""
	icon_state = "halfcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	color = CLOTHING_BLACK
	flags_inv = null
	var/flipped = FALSE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/cloak/half/attack_right(mob/user)
	if(!flipped)
		icon_state += "_rev"
		flipped = TRUE
	else
		icon_state = initial(icon_state)
		flipped = FALSE
	user.regenerate_icons()

/obj/item/clothing/cloak/half/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/half/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/half/orange
	color = CLOTHING_ORANGE

/obj/item/clothing/cloak/half/rider
	name = "骑手斗篷"
	icon_state = "guardcloak"
	color = CLOTHING_AZURE
	allowed_race = NON_DWARVEN_RACE_TYPES
	inhand_mod = FALSE

/obj/item/clothing/cloak/half/rider/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/half/vet
	name = "城镇守卫斗篷"
	icon_state = "guardcloak"
	color = CLOTHING_AZURE
	allowed_race = NON_DWARVEN_RACE_TYPES
	inhand_mod = FALSE

/obj/item/clothing/cloak/half/vet/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/half/vet/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/shadowcloak
	name = "潜猎者斗篷"
	desc = "一件厚实的皮斗篷，以镀金别针扣住，上面刻着大公家徽。这是忠诚侍从的标志。"
	icon_state = "shadowcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/cloak/shadowcloak/vanguard
	name = "先锋斗篷"
	desc = "一件深色斗篷，以低镇男爵的胸针扣合。由先锋所穿戴"

/obj/item/clothing/cloak/thief_cloak
	name = "无赖披巾"
	desc = "一条用廉价扣件固定的简单披巾。实用好使，只是布料粗糙而且已经磨旧。"
	icon_state = "thiefcloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	color = CLOTHING_ORANGE

/obj/item/clothing/cloak/thief_cloak/yoruku
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/templar

/obj/item/clothing/cloak/templar/psydon
	name = "普赛顿罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有普赛顿的标志。"
	icon_state = "tabard_weeping"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/astrata
	name = "阿斯特拉塔罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有阿斯特拉塔的标志。"
	icon_state = "tabard_astrata_alt"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/noc
	name = "诺克罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有诺克的标志。"
	icon_state = "tabard_noc"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/dendor
	name = "登多尔罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有登多尔的标志。"
	icon_state = "tabard_dendor"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/necra
	name = "内克拉罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有内克拉的标志。"
	icon_state = "tabard_necra"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/abyssor
	name = "阿比索尔罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有阿比索尔的标志。"
	icon_state = "tabard_abyssor"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/malum
	name = "玛勒姆罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有玛勒姆的标志。"
	icon_state = "tabard_malum"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/volfmantle
	name = "沃尔夫披肩"
	desc = "用被猎杀沃尔夫的皮与头制成的温暖斗篷。如果这都不算身份象征，那就没什么算了。"
	icon_state = "volfpelt"
	item_state = "volfpelt"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX
	dropshrink = null

/obj/item/clothing/cloak/volfmantle/shoulderpad
	name = "板甲护肩"
	desc = "一件沉重的金属护肩，意在震慑他人，使其心生臣服。"
	icon_state = "metalshoulderpad"
	item_state = "metalshoulderpad"
	slot_flags = ITEM_SLOT_CLOAK
	salvage_result = /obj/item/ingot/steel
	cold_protection = ARM_RIGHT

/obj/item/clothing/cloak/volfmantle/shoulderpad/leather
	name = "皮革护肩"
	desc = "一副皮革护肩，能让佩戴者显得更加魁梧而威严。"
	icon_state = "leathershoulderpad"
	item_state = "leathershoulderpad"
	slot_flags = ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/hide/cured
	cold_protection = ARM_LEFT | ARM_RIGHT

/obj/item/clothing/cloak/volfmantle/shoulderpad/lightleather
	name = "轻型皮革护肩"
	desc = "一副用于保护肩膀的小巧皮垫。"
	icon_state = "lightleathershoulderpad"
	item_state = "lightleathershoulderpad"
	slot_flags = ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/hide/cured
	cold_protection = ARM_LEFT | ARM_RIGHT

/obj/item/clothing/cloak/wickercloak
	name = "柳枝斗篷"
	desc = "用泥巴、树枝和纤维临时搭成的斗篷。"
	icon_state = "wicker_cloak"
	item_state = "wicker_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 2
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/tribal
	name = "部族毛皮"
	desc = "一张随意硝制过的怪物皮，披在身体或护甲外侧，可额外御寒。就是有点扎人。"
	icon_state = "tribal"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	body_parts_covered = CHEST|GROIN|VITALS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	boobed = FALSE
	sellprice = 10
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX
	dropshrink = null

/obj/item/clothing/cloak/lordcloak/ladycloak
	name = "淑女短斗篷"
	desc = "短小精致的淑女斗篷，既得体又能衬出高贵气质。"
	icon_state = "shortcloak"
	item_state = "shortcloak"
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	cold_protection = ARM_LEFT | ARM_RIGHT

/obj/item/clothing/cloak/matron
	name = "主母斗篷"
	desc = "只有最刻薄的老妪才会费心去穿的斗篷。"
	icon_state = "matroncloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon ='icons/roguetown/clothing/onmob/cloaks.dmi'
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/battlenun
	name = "修女法衣"
	desc = "贞洁、正直，对恶人绝不留情。"
	icon_state = "battlenun"
	item_state = "battlenun"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/templar/eora
	name = "伊欧拉罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有伊欧拉的标志。"
	icon_state = "tabard_eora"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/pestra
	name = "佩斯特拉罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有佩斯特拉的标志。"
	icon_state = "tabard_pestra"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/cleric/ravox
	name = "拉沃克斯罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有拉沃克斯的标志。"
	icon_state = "tabard_ravox"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/ravox
	name = "正义罩袍"
	desc = "带护颈的内甲法衣，由拉沃克斯圣殿骑士穿戴。"
	icon_state = "justicetabard"
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK|ITEM_SLOT_MASK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/xylix
	name = "赛利克斯罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有赛利克斯的标志。"
	icon_state = "tabard_xylix"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/cape/blkknight
	name = "黑骑士披风"
	icon_state = "bkcape"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX


/obj/item/clothing/head/roguetown/helmet/heavy/blkknight
	name = "黑钢头盔"
	icon_state = "bkhelm"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]装到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/natural/cloth) && !altdetail_tag)
		var/choicealt = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]装到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = GLOB.colorlist[choicealt]
		altdetail_tag = "_detailalt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)


/obj/item/clothing/cloak/tabard/blkknight
	name = "血绶带"
	icon_state = "bksash"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	dropshrink = null

/obj/item/clothing/under/roguetown/platelegs/blk
	name = "黑钢腿甲"
	icon_state = "bklegs"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/gloves/roguetown/plate/blk
	name = "黑钢臂铠"
	icon_state = "bkgloves"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/suit/roguetown/armor/plate/blkknight
	slot_flags = ITEM_SLOT_ARMOR
	name = "黑钢板甲"
	desc = "一件以黑钢打造的厚重板甲，足以让穿戴者看起来如灾厄降临。"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	icon_state = "bkarmor"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/shoes/roguetown/boots/armor/blkknight
	name = "黑钢战靴"
	icon_state = "bkboots"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

//Short hoods for guards

/obj/item/clothing/cloak/stabard/guardhood
	name = "守卫兜帽"
	desc = "带有领主纹章配色的兜帽。"
	color = CLOTHING_AZURE
	detail_tag = "_spl"
	detail_color = CLOTHING_WHITE
	icon_state = "guard_hood"
	item_state = "guard_hood"
	body_parts_covered = CHEST

/obj/item/clothing/cloak/stabard/guardhood/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "选择一种样式。","罩袍样式") as null|anything in list("分割")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("分割")
			detail_tag = "_spl"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/guardhood/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/stabard/guardhood/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/stabard/guardhood/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/stabard/guardhood/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/stabard/guardhood/elder
	name = "长老兜帽"

/obj/item/clothing/cloak/hierophant
	name = "大祭司绶带"
	icon_state = "naledisash"
	item_state = "naledisash"
	desc = "一条柔软布带，传统上用于束紧过于宽松的袋子，但在如今更多只是一种时尚宣言。"
	color = null
	detail_color = null
	detail_tag = "_detail"
	naledicolor = TRUE

/obj/item/clothing/cloak/hierophant/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/hierophant/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/stabard/grenzelmage
	name = "格伦泽尔霍夫特法师披肩"
	desc = "一件时髦的披肩，常见于天穹学院的法师穿着。"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	detail_tag = "_spl"
	icon_state = "guard_hood" // The same as the guard hood however to break it from using the lords colors it has been given its own item path
	item_state = "guard_hood"
	body_parts_covered = CHEST

/obj/item/clothing/cloak/wardencloak
	name = "守林人斗篷"
	desc = "谷地森林守林人所穿的斗篷。它以低镇男爵的胸针扣合。"
	icon_state = "wardencloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection =  CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/poachercloak
	name = "风化守林人斗篷"
	desc = "一件破旧的斗篷，曾经为穿戴者保暖避雨，如今只能勉强让血别溅到衣服上。"
	icon_state = "poachercloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE

/obj/item/clothing/cloak/graggar
	name = "凶暴斗篷"
	desc = "这腐败世界里唯一真正推动万物的力量就是暴力。去成为它的掌控者，而不是牺牲品。"
	icon_state = "graggarcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection =  CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "斗篷", "撕碎")

/obj/item/clothing/cloak/forrestercloak
	name = "林地卫手斗篷"
	desc = "山谷黑橡守林者所穿的斗篷。"
	icon_state = "forestcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	resistance_flags = FIRE_PROOF
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection =  CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/forrestercloak/snow
	name = "雪斗篷"
	desc = "一件能在山中严寒与山谷湿气里保持身体温暖的斗篷。"
	icon_state = "snowcloak"
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT

/// Dendor ritual reward variant of the forrester cloak — hallowed by the Treefather.
/obj/item/clothing/cloak/forrestercloak/blessed
	name = "赐福林地卫手斗篷"
	desc = "一件受树父仪式祝圣的林地卫手斗篷。活木纤维编织在布料之中，仿佛与森林静谧的生命一同呼吸。"
	color = "#73c47a"

/obj/item/clothing/cloak/forrestercloak/blessed/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/cloak/forrestercloak/blessed/pickup(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type == /datum/patron/divine/dendor)
		return
	H.electrocute_act(30, src)
	H.mob_timers["kneestinger"] = world.time
	to_chat(H, span_warning("[name]拒绝了我的触碰，唯有树父的信徒才配承此赠礼！"))

/obj/item/clothing/cloak/poncho
	name = "布制披衫"
	desc = "一种通常披在上半身的宽松衣物。没人真正说得清它最初来自哪种文化。"
	icon_state = "poncho"
	item_state = "poncho"
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	color = CLOTHING_WHITE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE

//eastern update

/obj/item/clothing/cloak/eastcloak1
	name = "斩云者斗篷"
	desc = "一件带白色云纹的棕色斗篷。有些人会认出这是一种古老的军事象征。"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	icon_state = "eastcloak1"
	item_state = "eastcloak1"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/eastcloak2
	name = "皮斗篷"
	desc = "一件棕色斗篷，没什么特别之处。"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	icon_state = "eastcloak2"
	item_state = "eastcloak2"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/psyaltrist
	name = "诗班长圣带"
	desc = "一条丝质圣带，绣有银饰花纹，背后还藏有暗袋，可披在圣歌卷轴外。它是奥塔瓦大教堂诗班领袖学成后的传统装束，也是其身份象征。"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	icon_state = "psaltertabard"
	item_state = "psaltertabard"
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/ordinatorcape
	name = "训令官披风"
	desc = "一件飘逸的红披风，配有纹饰华美的钢制肩甲。为持久而造。为坚忍而造。为生存而造。"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "ordinatorcape"
	item_state = "ordinatorcape"
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/absolutionistrobe
	name = "赦罪者长袍"
	desc = "宽恕他们的痛苦。宽恕他们的渴望。如同普赛顿一般地生存。"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "absolutionistrobe"
	item_state = "absolutionistrobe"
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/cotehardie
	name = "修身外套"
	desc = "也被称作科特哈迪：一种无论平民还是贵族都会穿的长袖外衣，男女皆宜，四季可用。脱下时，里面装着的东西不会掉出来。"
	color = "#586849"
	icon_state = "cotehardie"
	item_state = "cotehardie"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN|ARMS
	boobed = TRUE
	slot_flags = ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	detail_tag = "_detail"
	detail_color = "#36241f"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "cotehardie"
	nodismemsleeves = FALSE

/obj/item/clothing/cloak/cotehardie/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/captain
	name = "队长披风"
	desc = "一件绣有山谷金色纹章的披风。"
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleevetype = "shirt"
	icon_state = "capcloak"
	detail_tag = "_detail"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	detail_color = "#39404d"
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/captain/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary, GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/knight/guard/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/captain/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/kazengun
	name = "阵羽织"
	desc = "一种简朴的东境战袍，在这片遥远战场上用来分辨敌我。"
	icon_state = "kazenguncoat"
	item_state = "kazenguncoat"
	detail_tag = "_detail"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	color = "#FFFFFF"
	detail_color = "#FFFFFF"

/obj/item/clothing/cloak/kazengun/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/duelistcape
	name = "决斗者披风"
	desc = "决斗者偏爱的一种短披风。"
	icon_state = "duelistcape"
	item_state = "duelistcape"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600
	dropshrink = null

/obj/item/clothing/cloak/citywatch
	name = "城巡披风"
	desc = "一件体面的披风，彰显着某种都市权威。"
	icon = 'icons/roguetown/clothing/licensed-infraredbaron/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/licensed-infraredbaron/onmob/cloaks.dmi'
	icon_state = "citywatch_cape"
	item_state = "citywatch_cape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/citywatchcaptain
	name = "城巡队长斗篷"
	desc = "一件极为体面的斗篷，彰显着更上一层的都市权威。"
	icon_state = "sheriffcloak"
	item_state = "sheriffcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK

/obj/item/clothing/cloak/absolutionistrobe/black
	nodismemsleeves = TRUE
	name = "blessed robe"
	desc = "Weep for what was lost. Pray for those who may yet be saved. Endure, in His name."
	icon_state = "blackabsolutionistrobe"
	item_state = "blackabsolutionistrobe"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/apron/waist/maid
	name = "maid apron"
	desc = "A fancy, somewhat short apron usually worn by servants."
	body_parts_covered = null
	icon_state = "maidapron"
	item_state = "maidapron"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/maids.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/maids.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/maids.dmi'

/obj/item/clothing/cloak/bandolier
	name = "bandolier"
	desc = "A sash that's pelted with pouches, perfect for carrying plenty of pint-sized pieces. </br>'Hail to the King, baby.'"
	color = null
	icon_state = "bandolier"
	item_state = "bandolier"
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/hide/cured
	grid_width = 64
	grid_height = 96
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/bandolier/inq
	name = "inquisitorial bandolier"
	desc = "A masterworked leather bandolier, lined with silvered fittings and sturdy loops for the tools of inquiry. Every strap serves a purpose; every buckle stands ready for the next hunt."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "inqbandolier"
	item_state = "inqbandolier"

/obj/item/clothing/cloak/bishop
	name = "bishop cape"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "bishop_cape"
	item_state = "bishop_cape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = TRUE

/obj/item/clothing/cloak/bishop/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/cape/inquisitorgold
	nodismemsleeves = TRUE
	name = "golden order cloak"
	desc = "A time honored cloak inlaid with golden threading, the stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity."
	icon_state = "inquisitor_cloak"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "inquisitor"
	color = null

/obj/item/clothing/cloak/cape/inquisitorsilver
	nodismemsleeves = TRUE
	name = "silver order cloak"
	desc = "A time honored cloak inlaid with silver threading, the stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, creechers, and the ever-looming threat of the Archdevil's return."
	icon_state = "sinquisitor_cloak"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "inquisitor"
	color = null

/obj/item/clothing/cloak/etrcape
	name = "wanderer's cape"
	desc = "A stylish raincoat that protects you from the rain and makes you look great"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "etrcape"
	item_state = "etrcape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = FALSE
	color = null
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/half/duelcape
	boobed = TRUE
	name = "duelist cape"
	desc = "A flamboyant red duelists cape that is sure to catch the eye."
	icon_state = "duelistcape"
	item_state = "duelistcape"
	color = CLOTHING_SCARLET
	nodismemsleeves = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_GOLD_METALLIC
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES
	inhand_mod = FALSE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/half/duelcape/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/half/duelcape/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/half/duelcape/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/half/shadowcloak
	boobed = TRUE
	inhand_mod = TRUE
	nodismemsleeves = TRUE
	sleevetype = "shirt"
	name = "stalker cloak"
	desc = "A heavy leather cloak held together by a gilded pin, depicting the Grand Duke's house. The sign of a faithful servant."
	icon_state = "shadowcloak"
	color = null
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/half/shadowcloak/spymaster
	name = "hand's cloak"
	desc = "Crafted not for warmth, but to complete an imposing silhouette. It is tailored to shroud both the hilt of a hidden blade and the true intentions of its wearer from prying eyes."
	icon_state = "handcloak"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/poncho/fancycoat
	sleevetype = "poncho"
	name = "fancy coat"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin but it does look fancy."
	icon_state = "fancycoat"
	item_state = "fancycoat"
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	nodismemsleeves = TRUE
	color = CLOTHING_WHITE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/poncho/fancycoat/trimmed
	name = "trimmed fancy coat"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin but it does look fancy. This one has been trimmed to show ones legs. How scandalous."
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	icon_state = "noblecoattrimmed"
	item_state = "noblecoattrimmed"

/obj/item/clothing/cloak/rangercloak
	name = "ranger cloak"
	desc = "A traditionally elven cloak said to help blend in with the woods."
	icon_state = "ranger"
	item_state = "ranger"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	resistance_flags = FIRE_PROOF
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/rosa
	name = "regal cloak"
	desc = "A finely crafted cloak of silk adorned with rosas."
	icon_state = "rosacloak7"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/cloak/rosa/two
	name = "courtly cloak"
	icon_state = "rosacloak8"

/obj/item/clothing/cloak/sash
	name = "sash"
	desc = "A large sash that can be draped across one's torso."
	icon_state = "sash"
	item_state = "sash"
	boobed = FALSE
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_BACK_R|ITEM_SLOT_BACK_L|ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/sash/dupatta
	name = "dupatta"
	desc = "A regional variant of the humble sash, loosely fit to fight against the Ranesheni heat."
	icon_state = "dupatta"
	item_state = "dupatta"
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	altdetail_tag = "_detailalt"
	altdetail_color = CLOTHING_WHITE
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/sash/dupatta/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/sash/dupatta/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/cloak/scaledcloak
	name = "scaled cloak"
	desc = "A light cloak covered in shimmering metal scales. Beautiful even if too light to protect it's wearer from more than other travel cloaks."
	icon_state = "scalecloak"
	item_state = "scalecloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	boobed = FALSE
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_BACK_R|ITEM_SLOT_BACK_L
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	detail_tag = "_detail"
	detail_color = "#405996"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/scout
	name = "scout cloak"
	desc = "A weathered cape cut short at the flank."
	icon_state = "scout_cloak"
	item_state = "scout_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/sheriff
	name = "sheriff's cloak"
	desc = "A cloak-cape embroidered with the silver heraldry of the watch."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/citywatch_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/citywatch_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/citywatch_armor.dmi'
	icon_state = "sheriffcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER

/obj/item/clothing/cloak/sleevedtabard
	name = "sleeved tabard"
	desc = "A tabard with a light sleeve and pauldron sewn on, it lacks the explicit detailing of other tabards in exchange."
	color = null
	boobed = TRUE
	icon_state = "halfsurcoat"
	item_state = "halfsurcoat"
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/psydontabard
	name = "psydonian tabard"
	desc = "A tabard worn by the adherents of the Holy Psydonic Inquisition. Delicate stitchwork professes the psycross with pride."
	color = null
	icon_state = "psydontabard"
	item_state = "psydontabard"
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	custom_design = TRUE
	var/open_wear = FALSE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/psydontabard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this cloak allows for it to be dynamically worn as a traditional tabard, or as a sleeveless robe that partially exposes the chest.")

/obj/item/clothing/cloak/tabard/psydontabard/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/psydontabard/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened psydonian tabard"
			desc = "A tabard worn by the adherents of the Holy Psydonic Inquisition, peeled back to reveal its enduring innards."
			body_parts_covered = GROIN
			icon_state = "psydontabardalt"
			item_state = "psydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("ENDURING, like the MARTYRS who'll guide the faithful-and-pious to PARADISE."))
		if(TRUE)
			name = "psydonian tabard"
			desc = "A tabard worn by the adherents of the Holy Psydonic Inquisition. Delicate stitchwork professes the psycross with pride."
			body_parts_covered = CHEST|GROIN
			icon_state = "psydontabard"
			item_state = "psydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("VEILED, like the CORPSES who've been shepherded by your steel to the AFTERLYFE."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/psydontabard/black
	name = "blessed tabard"
	desc = "A tabard worn by the worshippers of Psydon. A funeral shroud for the paradise that could've been, and a solemn vow to continue the struggle towards salvation."
	icon_state = "blackpsydontabard"
	item_state = "blackpsydontabard"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/psydontabard/black/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/psydontabard/black/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened blessed tabard"
			desc = "A tabard worn by the worshippers of Psydon, peeled back to reveal its mourning innards."
			body_parts_covered = GROIN
			icon_state = "blackpsydontabardalt"
			item_state = "blackpsydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back the threaded burlap, baring your heart to Psydonia's eyes."))
		if(TRUE)
			name = "blessed tabard"
			desc = "A tabard worn by the worshippers of Psydon. A funeral shroud for the paradise that could've been, and a solemn vow to continue the struggle towards salvation."
			body_parts_covered = CHEST|GROIN
			icon_state = "blackpsydontabard"
			item_state = "blackpsydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You cloak yourself in the threaded burlap, veiling your heart from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/psydontabard/white
	name = "traditional tabard"
	desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a sleeveless garment that harks back to the ancient yils of the Holy Inquisition."
	icon_state = "whitepsydontabard"
	item_state = "whitepsydontabard"
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	custom_design = TRUE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/psydontabard/white/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this cloak allows for it to be dynamically worn as a traditional tabard, or as a sleeveless robe that partially exposes the chest.")

/obj/item/clothing/cloak/tabard/psydontabard/white/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/psydontabard/white/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened traditional tabard"
			desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a bared sleeveless garment that harks back to the ancient yils of the Holy Inquisition."
			body_parts_covered = GROIN
			icon_state = "whitepsydontabardalt"
			item_state = "whitepsydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back the threaded cloth, baring your heart to Psydonia's eyes."))
		if(TRUE)
			name = "traditional tabard"
			desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a sleeveless garment that harks back to the ancient yils of the Holy Inquisition."
			body_parts_covered = CHEST|GROIN
			icon_state = "whitepsydontabard"
			item_state = "whitepsydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You cloak yourself in the threaded cloth, veiling your heart from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/psydontabard/white/alt
	name = "opened traditional tabard"
	desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a bared sleeveless garment that harks back to the ancient yils of the Holy Inquisition."
	body_parts_covered = GROIN
	icon_state = "whitepsydontabardalt"
	item_state = "whitepsydontabardalt"
	flags_inv = HIDECROTCH
	open_wear = TRUE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/stabard
	name = "surcoat"
	desc = "An outer garment commonly worn by soldiers."
	icon_state = "stabard"
	boobed = TRUE
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/detailed/tabards.dmi'
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/stabard/crusader
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlaid with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bears the psicruciformic sigil of the Psydonic and Necran \
	orders."
	icon_state = "crusader_surcoat"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/crusader.dmi'
	sleeved = null
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/stabard/crusader/astrata
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlaid with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bears the duocruciformic sigil of the Astratan and Ravoxian \
	orders."
	icon_state = "acrusader_surcoat"

/obj/item/clothing/cloak/tabard/stabard/crusader/bsteel
	name = "surcoat of the blacksteel order"
	desc = "A venerated surcoat, inlaid with blacksteel threading. The stitchwork tethers it to the Blacksteel Order; an ancient faith-militance whose roots trace \
	all the way back to Psydonia's first crusaders. Uniquely welcoming to both Psydonic and Tennite patroneers, and irreversibly valorant against the dreaded \
	Avantyne Legion. </br>'Happiness must be fought for, lest all hope perish from the face of this world.'"
	icon_state = "crusader_surcoatb3"

/obj/item/clothing/cloak/tabard/stabard/crusader/heavy
	name = "overvestments"
	desc = "A heavy surcoat that offers complete modesty and protection against the weather, but leaves the thinner-framed with sorer shoulders. Commonly seen upon \
	the bods of paladin-errants, priests, and pilgrims across Psydonia's more intemperate climates."
	icon_state = "priest_surcoat"

/obj/item/clothing/cloak/tabard/stabard/crusader/t
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlaid with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bears the psicruciformic sigil of the Psydonic and Necran \
	orders."
	icon_state = "crusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlaid with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bears the duocruciformic sigil of the Astratan and Ravoxian \
	orders."
	icon_state = "acrusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/t/see
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlaid with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bears the unicruciform sigil of the See and Erranteer \
	orders."
	icon_state = "ucrusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/see
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlaid with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bears the unicruciform sigil of the See and Erranteer \
	orders."
	icon_state = "ucrusader_surcoat"

/obj/item/clothing/cloak/tabard/stabard/surcoat
	name = "jupon"
	icon_state = "surcoat"
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/stabard/surcoat/short
	name = "short jupon"
	icon_state = "surcoat_short"
	body_parts_covered = CHEST
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/toga
	name = "toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
	icon_state = "toga"
	item_state = "toga"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	boobed = FALSE
	custom_design = FALSE
	color = "#FFFFFF"
	detail_tag = "_detail"
	detail_color = "#FAC55C"
	var/open_wear = FALSE

/obj/item/clothing/cloak/tabard/toga/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this cloak allows for it to be dynamically worn traditionally, or with a side pulled down that partially exposes the chest.")

/obj/item/clothing/cloak/tabard/toga/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/toga/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "bared toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity, bared open to reveal what's beneath."
			body_parts_covered = GROIN
			icon_state = "togaalt"
			item_state = "togaalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back a sleeve, baring what lies beneath to Psydonia's eyes."))
		if(TRUE)
			name = "toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
			body_parts_covered = CHEST|GROIN
			icon_state = "toga"
			item_state = "toga"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You pull up your sleeve, veiling what lies beneath from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/toga/alt
	name = "bared toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity, bared open to reveal what's beneath."
	icon_state = "togaalt"
	item_state = "togaalt"
	flags_inv = HIDECROTCH
	body_parts_covered = GROIN
	open_wear = TRUE

/obj/item/clothing/cloak/tabard/toga/dress
	name = "toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
	icon_state = "togadress"
	item_state = "togadress"
	boobed = TRUE
	open_wear = FALSE

/obj/item/clothing/cloak/tabard/toga/dress/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "bared toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity, bared open to reveal what's beneath."
			body_parts_covered = GROIN
			icon_state = "togadressalt"
			item_state = "togadressalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back a strap, baring what lies beneath to Psydonia's eyes."))
		if(TRUE)
			name = "toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
			body_parts_covered = CHEST|GROIN
			icon_state = "togadress"
			item_state = "togadress"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You pull up your strap, veiling what lies beneath from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/toga/dress/alt
	name = "bared toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity, bared open to reveal what's beneath."
	icon_state = "togadressalt"
	item_state = "togadressalt"
	flags_inv = HIDECROTCH
	body_parts_covered = GROIN
	open_wear = TRUE

/obj/item/clothing/cloak/templar/astratancleric
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	name = "astratan cloak"
	desc = "A golden-colored cloak with frayed edges, bearing the radiant hues of Astrata. It marks the wearer as a beacon of light amidst the chaos of battle."
	icon_state = "astrataclerictabard"
	sleevetype = "shirt"
	boobed = FALSE
	resistance_flags = FIRE_PROOF
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/astratancleric/grey
	name = "frayed cloak"
	desc = "A flowing cloak with frayed edges, cut in the style of Astratan clergy. Its plain cloth takes dye readily."
	icon_state = "greyastrataclerictabard"
	resistance_flags = FLAMMABLE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/eoran/alt
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "tabard_blue"
	item_state = "tabard_blue"
	var/eora_colors = list("Blue Tabard", "Pink Tabard")
	var/picked = FALSE
	var/eora_final_icon = null

/obj/item/clothing/cloak/templar/eoran/alt/attack_right(mob/user)
	..()
	if(!picked)
		var/choiceC = input(user, "Choose a color.", "Eora colors") as anything in eora_colors
		if(choiceC == "Blue Tabard")
			icon_state = "tabard_blue"
			item_state = "tabard_blue"
			eora_final_icon = "tabard_blue"
		if(choiceC == "Pink Tabard")
			icon_state = "tabard_pink"
			item_state = "tabard_pink"
			eora_final_icon = "tabard_pink"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
		if(alert("Are you pleased with your tabard?", "Tabard", "Yes", "No") != "Yes")
			icon_state = "tabard_blue"
			item_state = "tabard_blue"
			eora_final_icon = "tabard_blue"
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_cloak()
			update_icon()
			return
		picked = TRUE

/obj/item/clothing/cloak/templar/eoran/alt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/cloak/templar/eoran/alt/equipped(mob/user, slot)
	. = ..()
	if(eora_final_icon)
		icon_state = eora_final_icon
		item_state = eora_final_icon
		update_icon()

/obj/item/clothing/cloak/templar/eoran/alt/dropped(mob/user, slot)
	. = ..()
	if(eora_final_icon)
		icon_state = eora_final_icon
		item_state = eora_final_icon
		update_icon()

/obj/item/clothing/cloak/templar/necrancleric
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	name = "necran cloak"
	desc = "A dark, battle-worn cloak secured with a silver buckle. Marked with the somber symbols of Necra, its frayed hem bears testament to endless skirmishes with death."
	icon_state = "necraclerictabard"
	boobed = FALSE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/ravoxcleric
	name = "justice cloak"
	desc = "A tattered red tabard dyed in the bold colors of Ravox. Its striking crimson fabric stands out on the front lines, signaling unyielding judgment."
	icon_state = "justiceclerictabard"
	boobed = FALSE
	body_parts_covered = CHEST|GROIN
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK|ITEM_SLOT_MASK
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/templar/see_alt
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "see templar tabard"
	desc = "The refuge of the TEN upon my back. A united House, standing eternal against the encroaching darkness."
	icon_state = "seetabardalt"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/seecleric
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "see devotee tabard"
	desc = "The refuge of the TEN upon my back. A united Pantheon, to carry the light amongst the ever-present darkness that looms ahead."
	icon_state = "tenclerictabard"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/desert
	name = "desert cloak"
	desc = "This one will help against the dusty weather."
	color = CLOTHING_PURPLE
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "desert_cloak"
	item_state = "desert_cloak"
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	hoodtype = /obj/item/clothing/head/hooded/desert_hood
	toggle_icon_state = FALSE
	detail_tag = "_detail"
	detail_color = CLOTHING_YARROW

/obj/item/clothing/cloak/desert/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/desert/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/elven
	name = "elven cloak"
	desc = "It is said that this design might predate the War in Heaven and the consequient fall of the ancient Elven Empire."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "cape"
	item_state = "cape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = TRUE
	var/elven_colors = list("Blue Cloak", "Red Cloak", "Blue Furcloak", "Red Furcloak")
	var/picked = FALSE

/obj/item/clothing/cloak/elven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/elven/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a style.", "Elven styles") as anything in elven_colors
		picked = TRUE
		switch(choice)
			if("Blue Cloak")
				detail_tag = "_blue"
			if("Red Cloak")
				detail_tag = "_red"
			if("Blue Furcloak")
				detail_tag = "_blue_alt"
			if("Red Furcloak")
				detail_tag = "_red_alt"
			if("Blue Short Cloak")
				detail_tag = "_blue"
			if("Red Short Cloak")
				detail_tag = "_red"
			if("Blue Short Furcloak")
				detail_tag = "_blue_alt"
			if("Red Short Furcloak")
				detail_tag = "_red_alt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			update_icon()

/obj/item/clothing/cloak/elven/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/cloak/elven/short
	name = "elven shortcloak"
	icon_state = "cape_short"
	item_state = "cape_short"
	elven_colors = list("Blue Short Cloak", "Red Short Cloak", "Blue Short Furcloak", "Red Short Furcloak")

/obj/item/clothing/cloak/scarf
	name = "scarf"
	desc = "A long piece of cloth, meant to be worn around one's neck, Keeps you warm even under colder winds."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "scarf"
	item_state = "scarf"
	inhand_mod = TRUE
	var/elven_colors = list("blue", "black", "green", "beige", "brown", "white")
	var/picked = FALSE

/obj/item/clothing/cloak/scarf/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			update_icon()

/obj/item/clothing/cloak/scarf/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/head/hooded/desert_hood
	name = "desert cloak hood"
	desc = "This one will shelter me from the sand."
	icon_state = "desert_hood"
	item_state = "desert_hood"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEHAIR
	detail_tag = "_detail"

/obj/item/clothing/head/hooded/desert_hood/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/head/hooded/desert_hood/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
