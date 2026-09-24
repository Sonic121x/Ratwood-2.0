/obj/item/clothing/head/roguetown/helmet/heavy
	name = "巴布塔盔"
	desc = "一顶朴素的头盔，面甲呈 Y 字形。"
	body_parts_covered = FULL_HEAD
	icon_state = "barbute"
	item_state = "barbute"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PICK)
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	armor_class = ARMOR_CLASS_MEDIUM	//Not a wearing requirement. check_armor_skill() ignores the head slot, this only feeds highest_ac_worn().

/obj/item/clothing/head/roguetown/helmet/heavy/ComponentInitialize()
	..()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/heavy/bronze
	name = "青铜巴布塔盔"
	desc = "一顶青铜大盔，其护鼻与护颊板让佩戴者的面容笼罩在黑暗中。往昔的英雄早已逝去， \
	但他们的血脉仍流淌在普赛多尼亚子民的体内；你也不例外。在它的盔顶插上一根羽毛， \
	便可自豪地展示你的效忠。"
	body_parts_covered = FULL_HEAD
	icon_state = "bronzebarbute"
	item_state = "bronzebarbute"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = ARMOR_BRONZE
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/bronze
	max_integrity = ARMOR_INT_HELMET_HEAVY_BRONZE
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 1

/obj/item/clothing/head/roguetown/helmet/heavy/bronze/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/bronze/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/ancient
	name = "远古巴布塔盔"
	desc = "抛光的吉尔青铜板片经锻打制成带面甲的头盔。齐佐号令野心，而野心号令牺牲；让这些支离破碎的军团士兵再度崛起，为那些蒙昧蠢货洒下鲜血。盔缘顶端盘踞着一个螺旋形插孔，等待羽饰插入。"
	icon_state = "ancientbarbute"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/head/roguetown/helmet/heavy/ancient/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/ancient/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/ancient/decrepit
	name = "破旧巴布塔盔"
	desc = "磨损的青铜板被锻打成一顶带面甲的头盔。弯曲的护板上满是刮痕与凹陷，那是数百年失修风化留下的痕迹。盔缘上还挂着残破羽饰留下的短茬。"
	max_integrity = ARMOR_INT_HELMET_HEAVY_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/head/roguetown/helmet/heavy/ancient/decrepit/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/ancient/decrepit/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/kabuto
	name = "胴丸盔"
	desc = "一顶风钢岩钢板盔，以黑钢与金边装饰，令人联想到高贵与力量。通常会与面具或护口一同佩戴。"
	flags_inv = HIDEEARS
	flags_cover = null
	icon_state = "kazengunheavyhelm"

/obj/item/clothing/head/roguetown/helmet/heavy/guard
	name = "钢萨伏依盔"
	desc = "一顶面容狰狞的头盔。"
	icon_state = "steelsavoyard"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient
	name = "远古萨伏依盔"
	desc = "打磨光亮的吉尔青铜护板塑成堡垒般的大盔。普赛顿彗星的灼目光芒仿佛永远烙进了这份合金之中，让人得以瞥见普赛顿沉眠、齐佐苏醒之前那个早已腐朽的旧世界。"
	icon_state = "ancientsavoyard"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient/decrepit
	name = "破旧萨伏依盔"
	desc = "磨损的青铜板被塑成一具带透气缝的头匣。它散发着腐臭的粪腥味，每一次艰难而吃力的呼吸都夹杂着剥落的金属屑。"
	max_integrity = ARMOR_INT_HELMET_HEAVY_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman
	name = "钢沼民头盔"
	desc = "一顶面甲雕成咆哮地精模样的头盔。它曾由沼民佩戴，如今已是古老腐木谷留下的遗物。"
	icon_state = "guardhelm"

/obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	name = "栅栏头盔"
	desc = "一顶以牺牲视野为代价，换取良好面部防护的头盔。"
	icon_state = "gatehelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/beakhelm
	name = "鸟喙头盔"
	desc = "一顶古怪的球形头盔，带有鸟喙般的面罩。"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	icon_state = "beakhelmet"
	item_state = "beakhelmet"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold
	name = "黄金头盔"
	desc = "一顶华美的巴布塔盔，以纯金精工锻造而成。其护鼻上刻有神圣印记，内侧衬着一顶丝制武装帽。 \
	即便在绝对的黑暗中，抛光的面甲表面也闪烁着灌注的阳光。"
	icon_state = "goldbarbute"
	armor = ARMOR_INDESTRUCTIBLE //Renders its wearer completely invulnerable to damage. The caveat is, however..
	max_integrity = ARMOR_INT_SIDE_GOLD // ..is that it's extraordinarily fragile. To note, this is lower than even Decrepit-tier armor.
	armor_class = ARMOR_CLASS_HEAVY //Ceremonial. Heavy is the head that bears the burden.
	anvilrepair = null
	smeltresult = /obj/item/ingot/gold
	smelt_bar_num = 1 //Prevents resmelting to easily recreate.
	grid_height = 96 //Prevents 'armorstacking'. That, and it's like.. carrying a golden watermelon.
	grid_width = 96
	unenchantable = TRUE

/obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold/king
	name = "王室黄金头盔"
	desc = "一顶华美的巴布塔盔，以纯金精工锻造而成。其护鼻上刻有神圣印记，内侧衬着一顶丝制武装帽。 \
	额上那顶缀饰王冠昭示着权威，无论其来路不正，还是名正言顺。"
	icon_state = "goldbarbute_crown"
	max_integrity = ARMOR_INT_SIDE_GOLDPLUS // Doubled integrity.
	unenchantable = TRUE

/obj/item/clothing/head/roguetown/helmet/heavy/knight
	name = "骑士头盔"
	desc = "一顶贵族间当下流行款式的高贵骑士头盔。插上一根羽毛，展示你的家族或效忠色彩。"
	icon_state = "knight"
	item_state = "knight"
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/knight/black
	color = CLOTHING_GREY

/obj/item/clothing/head/roguetown/helmet/heavy/knight/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/knight/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient
	name = "古老盆盔"
	desc = "一顶由打磨过的吉尔青铜制成的古老重盔。没有比看到一位早已屈服于不死邪恶势力的崇高骑士更令人心惊胆颤的景象了。插上一根羽毛，展示你的家族或效忠色彩。"
	icon_state = "ancientknight"
	item_state = "ancientknight"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient/decrepit
	name = "破旧盆盔"
	desc = "一顶由磨损青铜制成的残破重盔。每当你试着上下掀动它那半生锈的面罩时，配件都会发出刺耳的吱呀声。插上一根羽毛，展示你的家族或效忠色彩。"
	max_integrity = ARMOR_INT_HELMET_HEAVY_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate
	name = "drow cavalier helm"
	desc = "A greathelm commonly worn by Underdark spider-jockies. The golden wings convey both a feminine elegance and martriarchal tyranny.\
	While lacking an adjustable visor, the winged halo and accompanying plumage can detach from the helm and be worn seperately."
	item_state = "gildeddrowhelm"
	icon_state = "gildeddrowhelm"
	adjustable = CAN_CADJUST
	emote_environment = 3
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES|MOUTH

/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate/ComponentInitialize()
	..()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS), null, 'sound/items/visor.ogg', null, UPD_HEAD)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate/attackby(obj/item/W, mob/living/user, params)
	..()
	if(!(istype(W, /obj/item/natural/feather) && !detail_tag))
		return
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	user.transferItemToLoc(W, src, FALSE, FALSE)
	detail_color = COLOR_WHITE
	detail_tag = "_detail"
	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/fluted
	name = "褶纹阿米特盔"
	desc = "一顶带面罩的华美钢制大盔，可保护整个头部。虽然厚重，但褶纹设计很适合延长骑士间的堂堂对决。插上一根羽毛，展示你的家族或效忠色彩。"

/obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	name = "铁骑士头盔"
	icon_state = "iknight"
	desc = "一顶由铁打造的高贵骑士头盔。"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON

/obj/item/clothing/head/roguetown/helmet/heavy/knight/gold
	name = "黄金骑士阿米特盔"
	desc = "一顶华美的阿米特盔，以纯金精工锻造而成。其面甲上布满六芒形的神圣印记刻纹，内侧衬着一顶丝制武装帽。 \
	即便在绝对的黑暗中，抛光的面甲表面也闪烁着灌注的阳光。"
	icon_state = "goldknight"
	armor = ARMOR_INDESTRUCTIBLE //Renders its wearer completely invulnerable to damage. The caveat is, however..
	max_integrity = ARMOR_INT_SIDE_GOLD // ..is that it's extraordinarily fragile. To note, this is lower than even Decrepit-tier armor.
	armor_class = ARMOR_CLASS_HEAVY //Ceremonial. Heavy is the head that bears the burden.
	anvilrepair = null
	smeltresult = /obj/item/ingot/gold
	smelt_bar_num = 1 //Prevents resmelting to easily recreate.
	grid_height = 96 //Prevents 'armorstacking'. That, and it's like.. carrying a golden watermelon.
	grid_width = 96
	unenchantable = TRUE
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/gold/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "大羽饰") as anything in GLOB.colorlist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/knight/gold/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/gold/king
	name = "王室黄金阿米特盔"
	desc = "一顶华美的阿米特盔，以纯金精工锻造而成。其面甲上布满六芒形的神圣印记刻纹，内侧衬着一顶丝制武装帽。 \
	额上那顶缀饰王冠昭示着权威，无论其来路不正，还是名正言顺。"
	icon_state = "goldknight_crown"
	max_integrity = ARMOR_INT_SIDE_GOLDPLUS // Doubled integrity.
	unenchantable = TRUE

/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
	name = "开缝锅盔"
	desc = "一顶向下延展以覆盖面部的加固锅盔，能完全保护佩戴者，但会限制视野。与护颚搭配尤佳。"
	icon_state = "skettle"
	item_state = "skettle"
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	adjustable = CANT_CADJUST

/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/natural/cloth) && !altdetail_tag)
		var/choicealt = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = GLOB.colorlist[choicealt]
		altdetail_tag = "_detailalt"
		if(choicealt in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
	name = "阿米特盔"
	desc = "神圣的羔羊、牺牲的英雄、受祝的痴人，普赛顿仍在。你愿作为人类的骑士与祂一同坚守，还是在诱惑面前崩溃？"
	icon_state = "armet"

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/natural/cloth) && !altdetail_tag)
		var/choicealt = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = GLOB.colorlist[choicealt]
		altdetail_tag = "_detailalt"
		if(choicealt in GLOB.pridelist)
			altdetail_tag = "_detailaltp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()


/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted
	name = "带吻部阿米特盔"
	icon_state = "armet_s"

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/iron
	name = "铁制阿米特盔"
	desc = "神圣的羔羊、献身的英雄、蒙福的愚者——普赛顿始终坚忍。你会作为人类的骑士，与祂一同坚持，还是在诱惑面前崩溃？"
	icon_state = "iarmet"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/iron/snouted
	name = "带吻部铁制阿米特盔"
	icon_state = "iarmet_s"


/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold
	name = "金色头盔"
	icon_state = "topfhelm_gold"
	item_state = "topfhelm_gold"
	desc = "一顶覆盖整个头部的头盔，上面刻有拉沃克斯的纹饰。勇气。正义。永不屈服。"

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/ravox/attackby(obj/item/W, mob/living/user, params)
	return

/obj/item/clothing/head/roguetown/helmet/heavy/bucket
	name = "桶盔"
	desc = "一顶覆盖整个头部的头盔，提供极佳的防护。"
	icon_state = "topfhelm"
	item_state = "topfhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		if(choice in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
	name = "赛利克斯头盔"
	desc = "我起舞，我歌唱！我愿做你的丑角！"
	icon_state = "xylixhelmet"
	item_state = "xylixhelmet"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS, 2)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
	name = "阿斯特拉塔头盔"
	desc = "侍奉阿斯特拉塔的圣殿武士常戴的一种头盔。长子之光将永远在它的冠饰中闪耀。"
	icon_state = "astratahelm"
	item_state = "astratahelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/astratahelm/visor
	name = "羽饰阿斯特拉塔头盔"
	desc = "一顶饰有巨大黑色羽饰的头盔。秩序将引导你的手。出击要稳，落击要准。无人能够质疑你的意志。"
	icon_state = "astratahelm_plume"
	item_state = "astratahelm_plume"
	adjustable = CAN_CADJUST

/obj/item/clothing/head/roguetown/helmet/heavy/astratahelm/visor/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute
	name = "普赛顿式巴布塔盔"
	desc = "一顶仪式用巴布塔盔，精工锻造而成，用以象征普赛顿的神圣权威。圣玛勒姆教团的工匠将这副多叉圣容雕进了多得超乎你想象的雕像之中。"
	icon_state = "psydonbarbute"
	item_state = "psydonbarbute"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -5,"sy" = -3,"nx" = 0,"ny" = 0,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.32,"sx" = -3,"sy" = -8,"nx" = 6,"ny" = -8,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"nturn" = 180,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 1,"sflip" = 0,"wflip" = 0,"eflip" = 8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
	name = "普赛顿式阿米特盔"
	desc = "一顶华美的头盔，其面罩被黑钢锁链束缚封闭。圣伊欧拉教团常以鲜花装饰这些阿米特盔，不仅把它当作佳人或家人赠予的幸运象征，也将其视作“幸福必须靠战斗争取”的鲜明提醒。"
	icon_state = "psydonarmet"
	item_state = "psydonarmet"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -5,"sy" = -3,"nx" = 0,"ny" = 0,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.32,"sx" = -3,"sy" = -8,"nx" = 6,"ny" = -8,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"nturn" = 180,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 1,"sflip" = 0,"wflip" = 0,"eflip" = 8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		if(choice in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/natural/feather) && !altdetail_tag)
		var/choicealt = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = GLOB.colorlist[choicealt]
		altdetail_tag = "_detailalt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/psy/greatplume
	name = "带大羽饰的普赛顿式阿米特盔"
	desc = "一顶华美的头盔，其面罩被黑钢锁链束缚封闭。圣伊欧拉教团常以鲜花装饰这些阿米特盔， \
	不仅把它当作佳人或家人赠予的幸运象征，也将其视作“幸福必须靠战斗争取”的鲜明提醒。 \
	这顶阿米特盔的冠饰插孔更为宽大，可以容纳大羽饰。"
	icon_state = "psyknight"
	item_state = "psyknight"
	worn_x_dimension = 64
	worn_y_dimension = 64
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	smeltresult = /obj/item/ingot/silver
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	smelt_bar_num = 1

/obj/item/clothing/head/roguetown/helmet/heavy/knight/iron/greatplume/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "大羽饰") as anything in GLOB.colorlist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/knight/iron/greatplume/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)


/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm
	name = "审判官头盔"
	desc = "这是一名格伦泽尔霍夫特铁匠提出的设计，他是圣阿比索尔的狂热信徒，建议以圣殿武士大盔为基础改造，而事实证明它确实值得采用：一具带细狭视缝的钢铁头匣，视野比外表看上去清晰得多。污秽之徒终将溺死在你替他们带去的鲜血里。"
	icon_state = "ordinatorhelm"
	item_state = "ordinatorhelm"
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	var/plumed = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather))
		user.visible_message(span_warning("[user]开始用[W]为[src]制作羽饰。"))
		if(do_after(user, 4 SECONDS))
			var/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume/P = new /obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(P)
			P.obj_integrity = src.obj_integrity
			qdel(src)
			qdel(W)
		else
			user.visible_message(span_warning("[user]停止为[src]制作羽饰。"))
		return

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume
	icon_state = "ordinatorhelmplume"
	item_state = "ordinatorhelmplume"

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/natural/feather))
		return
	..()

/obj/item/clothing/head/roguetown/helmet/heavy/absolver
	name = "普赛顿式锥形盔"
	desc = "这顶诡秘头盔的造型取自圣佩斯特拉教团所戴的圣容，它让佩戴者得以提醒异端：恐惧并不是那么容易失去的情绪。即便是死者，也可能重新学会品尝恐惧。"
	icon_state = "absolutionisthelm"
	item_state = "absolutionisthelm"
	emote_environment = 3
	body_parts_covered = FULL_HEAD|NECK
	block2add = FOV_RIGHT|FOV_LEFT
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL + ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY // Worst vision. Yes.
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	smeltresult = /obj/item/ingot/silver
	armor_class = null	//Needs no armor class, unique absolver gear.

/obj/item/clothing/head/roguetown/helmet/heavy/psybucket
	name = "普赛顿式桶盔"
	desc = "这是一种由圣阿斯特拉塔与圣拉沃克斯旗下持刃武装佩戴的久经考验之作。钢铁包覆你的头颅，而迎敌时显露的祂之十字则会提醒他们：你将坚持到他们坠入虚无。唯有那时，你才得安息。"
	icon_state = "psybucket"
	item_state = "psybucket"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/psybucket/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		if(choice in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/clothing/head/roguetown/veiled) && !altdetail_tag)
		var/choicealt = input(user, "选择一种颜色。", "面纱") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = GLOB.colorlist[choicealt]
		altdetail_tag = "_detailalt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/psybucket/update_icon()
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

/obj/item/clothing/head/roguetown/helmet/heavy/psysallet
	name = "普赛顿式萨雷特盔"
	desc = "一顶煮革帽，上覆钢制冠饰，并以祂的十字覆面。无需畏惧，祂会为你指明道路，也会见证你的每一次重击都落得精准。"
	icon_state = "psysallet"
	item_state = "psysallet"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/nochelm
	name = "诺克头盔"
	desc = "侍奉诺克的圣殿武士常戴的一种头盔。没有夜便没有昼；没有诺克，黑暗时刻里便不会有光。"
	icon_state = "nochelm"
	item_state = "nochelm"
	emote_environment = 3
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/nochelm/snouted
	name = "带吻部诺克头盔"
	desc = "侍奉诺克的圣殿武士常戴的一种头盔，其盔檐前伸以安放吻部。没有夜便没有昼；没有诺克，黑暗时刻里便不会有光。"
	icon_state = "nochelm_s"
	item_state = "nochelm_s"

/obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
	name = "内克拉头盔"
	desc = "侍奉内克拉的圣殿武士常戴的一种头盔。愿它骸骨般的轮廓提醒你，人生唯一注定之事便是死亡。"
	icon_state = "necrahelm"
	item_state = "necrahelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/necrahelm/hooded
	name = "兜帽内克拉头盔"
	desc = "它如佩戴者的面容般阴沉肃穆。因为他们知晓此生唯一的真理，故其职责亦神圣无比。终有一死的，不止是他们，也包括你。"
	icon_state = "necrahelm_hooded"
	item_state = "necrahelm_hooded"
	adjustable = CAN_CADJUST

/obj/item/clothing/head/roguetown/helmet/heavy/necrahelm/hooded/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
	name = "登多尔头盔"
	desc = "侍奉登多尔的圣殿武士常戴的一种头盔。它伸出的部分几乎像树枝一般。只要在大地之中扎根，你便永不会被撼动。"
	icon_state = "dendorhelm"
	item_state = "dendorhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
	name = "阿比索尔圣殿头盔"
	desc = "侍奉阿比索尔的圣殿武士常戴的一种头盔。它以狰狞的甲壳类圣容唤起海洋的意象。"
	icon_state = "abyssorgreathelm"
	item_state = "abyssorgreathelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
	name = "正义之鹰盔"
	desc = "这顶头盔为致敬拉沃克斯而锻造，饰有风格化的鹰首圣容，象征不屈的裁决与神圣的警戒。它空洞的双眼所见的不只是敌人，更是每一桩行为背后的真相。"
	icon_state = "ravoxhelmet"
	item_state = "ravoxhelmet"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/ravox_visor
	name = "羽饰拉沃克斯头盔"
	desc = "一顶饰有巨大红色羽饰的头盔。终有一日，他们会明白你才是山谷真正的裁正者。"
	icon_state = "ravoxhelm"
	item_state = "ravoxhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	adjustable = CAN_CADJUST

/obj/item/clothing/head/roguetown/helmet/heavy/ravox_visor/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate
	name = "沃尔夫面甲头盔"
	desc = "一顶带沃尔夫式面罩的钢制盆盔，可保护头部、耳朵、眼睛、鼻子与口部。"
	icon_state = "volfplate"
	item_state = "volfplate"
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	armor_class = null	//Needs no armor class, snowflake merc gear.

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/puritan
	name = "沃尔夫头骨盆盔"
	desc = "一顶带狰狞面罩的钢制盆盔，可保护整个头部与面部。它模仿可怖夜兽的模样，足以震慑征召兵，也足以激励猎人。"

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
	name = "沃尔夫头骨盆盔"
	desc = "一顶带狰狞面罩的钢制盆盔，可保护整个头部与面部。正如它所模仿的夜兽一般，这顶头盔的獠牙也闪烁着足以撕裂血肉的锋芒。"
	armor_class = ARMOR_CLASS_LIGHT //Pseudoantagonist-exclusive. Gives them an edge over traditional pugilists and barbarians.
	var/active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)
		to_chat(user, span_red("盆盔的面罩发出颤响，你的下颌也随之因共生般的冲动而绷紧……"))
	return

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)
	to_chat(user, span_red("……就这样，盆盔的面罩再度沉寂下来，你下颌那股古怪的压迫感也随之消退了。"))

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/psydonic
	name = "普赛顿式沃尔夫头骨盆盔"
	desc = "奥塔万对通用沃尔夫头骨盆盔的复刻之作。比起口套，它的防护性无疑要好得多。"
	icon_state = "psyhelm_s"
	item_state = "psyhelm_s"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x40/head.dmi'
	worn_x_dimension = 32
	worn_y_dimension = 40
	adjustable = CANT_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/psydonic/ComponentInitialize()
	return	//deliberately skips the parent's adjustable_clothing, this visor doesn't lift

/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
	name = "林纹精灵头盔"
	desc = "由交织的木质躯干拼构而成，靠古老歌谣维系生机，如今则为战争与轻蔑而扭曲成形。"
	body_parts_covered = FULL_HEAD | NECK
	armor = ARMOR_BLACKOAK //Resistant to blunt & stab, but very weak to slash.
	prevent_crits = list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PICK)
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfhead"
	item_state = "welfhead"
	block2add = FOV_BEHIND
	bloody_icon = 'icons/effects/blood64.dmi'
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	smeltresult = /obj/item/rogueore/coal
	anvilrepair = /datum/skill/craft/carpentry
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON // Weaker than usual because it is good vs blunt and stab
	blocksound = SOFTHIT
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/// Dendor ritual variant of the woad elven helm — forged by the Treefather's Nature's Temper blessing.
/// Offers superior stab resistance and meaningful slash defence compared to the standard elven helm.
/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/druidic
	name = "祝圣德鲁伊头盔"
	desc = "一顶生长于登多尔圣林深处的头盔，经古老树液与仪式之火淬炼而坚硬。它能偏转利刃与刺击，但技艺高超的挥砍者仍可能找到破绽。"
	armor = list("blunt" = 100, "slash" = 65, "stab" = 130, "piercing" = 40, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/druidic/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))
/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/druidic/pickup(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type == /datum/patron/divine/dendor)
		return
	H.electrocute_act(30, src)
	H.mob_timers["kneestinger"] = world.time
	to_chat(H, span_warning("[name]抗拒了我的触碰，唯有树父的忠诚信徒才配承受这份礼物！"))

/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/light
	name = "林纹精灵巴布塔盔"
	desc = "一顶由交织木质拼构而成的头盔，靠古老歌谣维系生机，并冠以永不凋零的鲜活枝叶。它比那顶更厚实的同类更轻盈、更柔韧，会随佩戴者的意志弯折，从未真正与活着的林地断绝联系。"
	body_parts_covered = HEAD|HAIR|NOSE|EARS|NECK
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfheadalt"
	item_state = "welfheadalt"
	block2add = null
	max_integrity = ARMOR_INT_HELMET_IRON
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth
	name = "蛙嘴盔"
	desc = "一顶高耸而威严的蛙嘴式头盔，在山谷的高地上颇为流行。它不仅覆盖整个头部与面部，还连颈部一并保护。可加上一块布料来展示你的家族或效忠色彩。"
	icon_state = "frogmouth"
	item_state = "frogmouth"
	emote_environment = 3
	body_parts_inherent = HEAD|NECK // can't peel off the solid plate bottom portion of the helm
	body_parts_covered = FULL_HEAD|NECK
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	block2add = FOV_RIGHT|FOV_LEFT
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL + ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY // Worst vision. Yes.
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		if(choice in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/clothing/head/roguetown/veiled) && !altdetail_tag)
		var/choicealt = input(user, "选择一种颜色。", "面纱") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = GLOB.colorlist[choicealt]
		altdetail_tag = "_detailalt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
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

/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/zizo
	name = "阿凡泰因蛙嘴盔"
	desc = "一顶以阿凡泰因锻造的重型蛙嘴盔。宽阔的视缝带来了在此类头盔中少见的实用视野。它自不可知的边缘被呼唤而来。以她之名。"
	icon_state = "zizofrogmouth"
	item_state = "zizofrogmouth"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	armor = ARMOR_ASCENDANT
	peel_threshold = 5

/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "HELMET")

/obj/item/clothing/head/roguetown/helmet/heavy/matthios
	name = "鎏金圣容"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	desc = "闪耀之物，未必皆为黄金，"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	icon_state = "matthioshelm"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	armor = ARMOR_ASCENDANT

/obj/item/clothing/head/roguetown/helmet/heavy/graggar
	name = "凶暴头盔"
	desc = "一顶粗犷的头盔，其中翻涌着与推动这个世界运转同样的暴烈之力。"
	icon_state = "graggarplatehelm"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	armor = ARMOR_ASCENDANT
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	var/active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "HELM", "RENDERED ASUNDER")

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/helmet/heavy/matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "VISAGE")

/obj/item/clothing/head/roguetown/helmet/heavy/zizo
	name = "阿凡泰因巴布塔盔"
	desc = "一顶阿凡泰因巴布塔盔。这一顶配有可调节面罩。它自不可知的边缘被呼唤而来。以她之名。"
	adjustable = CAN_CADJUST
	icon_state = "zizobarbute"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	peel_threshold = 5
	armor = ARMOR_ASCENDANT

/obj/item/clothing/head/roguetown/helmet/heavy/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "HELMET")

/obj/item/clothing/head/roguetown/helmet/heavy/zizo/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/knight/zizo
	name = "阿凡泰因盆盔"
	desc = "一顶暗钢盆盔，始终被诡异的赤红薄雾自后方映亮。凝视深渊 \
	太久……</br>‎<font color='FF0000'>……就会有东西回望你。</font>"
	adjustable = CANT_CADJUST
	icon_state = "zizobascinet"
	item_state = "zizobascinet"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	peel_threshold = 5
	armor = ARMOR_ASCENDANT

/obj/item/clothing/head/roguetown/helmet/heavy/knight/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "HELMET")

/obj/item/clothing/head/roguetown/helmet/heavy/knight/zizo/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/zizo
	name = "阿凡泰因沃尔夫面甲盆盔"
	desc = "一份末日的判决，一只致命的寄生物；不洁的阿凡泰因细丝蠕行穿过钢铁，欲造出 \
	更伟大的东西。进步是痛苦的过程，无论对血肉还是对金属而言。"
	adjustable = CAN_CADJUST
	icon_state = "volfplate_avantyne"
	item_state = "volfplate_avantyne"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	armor = ARMOR_ASCENDANT
	peel_threshold = 5
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor_class = ARMOR_CLASS_MEDIUM
	
/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "HELMET")

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/zizo/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	name = "铁桶盔"
	desc = "一顶覆盖整个头部的头盔，防护良好，但呼吸会变得格外艰难。"
	icon_state = "ironplate"
	item_state = "ironplate"
	emote_environment = 3
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/captain
	name = "队长头盔"
	desc = "一顶优雅的巴布塔盔，装配着贵族风格的金边与抛光金属。"
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	icon_state = "capbarbute"
	armor = ARMOR_CUIRASS // Unique armor, uniquely good value coverage.
	adjustable = CAN_CADJUST
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/captain/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/captain/sallet
	name = "队长带吻部萨雷特盔"
	desc = "一顶优雅的萨雷特盔，装配着贵族风格的金边与抛光金属。其护颚前伸成口鼻状。"
	icon_state = "capsallet_s"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR

/obj/item/clothing/head/roguetown/helmet/heavy/captain/bascinet
	name = "队长带吻部盆盔"
	desc = "一顶优雅的盆盔，装配着贵族风格的金边与抛光金属。其面罩收窄成口鼻状。"
	icon_state = "capbascinet_s"

/obj/item/clothing/head/roguetown/helmet/heavy/mimic
	name = "贪婪之象征"
	desc = "一颗形似藏宝箱的怪物头颅。据说普赛多尼亚的拟形怪顶着这副面容，作为贪婪之罪的羞耻象征。每一个时代似乎都被人类的贪欲所玷污。对毫无世俗欲求之人——比如我——而言，这纯属胡言！"
	icon = 'icons/roguetown/clothing/special/mimichead.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/mimichead.dmi'
	icon_state = "mimichead"
	armor = list("blunt" = 100, "slash" = 65, "stab" = 130, "piercing" = 40, "fire" = 0, "acid" = 0)//druid helmet stats, seems fitting cause it's magic wood
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	blocksound = list('sound/vo/mobs/mimic/mimic_attack1.ogg','sound/vo/mobs/mimic/mimic_attack2.ogg','sound/vo/mobs/mimic/mimic_attack3.ogg')
	break_sound = 'sound/vo/mobs/mimic/mimic_death.ogg'
	anvilrepair = /datum/skill/craft/carpentry // is magic mimic chest wood or something
	smeltresult = /obj/item/rogueore/coal
	var/active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/mimic/equipped(mob/living/user, slot)
	. = ..()
	if(slot != SLOT_HEAD)
		return
	active_item = TRUE
	to_chat(user, span_hypnophrase("死去的拟形怪血肉裹住你的头颅，滑腻、冰冷而潮湿。野兽的饥渴涌上你身，你感到饥饿与消瘦，仿佛有什么抽干了你的体质；然而取而代之的，是一股啃噬不休的贪婪欲念，以及足以餍足它的幸运。"))
	user.change_stat(STATKEY_LCK, 5)
	user.change_stat(STATKEY_CON, -5)

/obj/item/clothing/head/roguetown/helmet/heavy/mimic/dropped(mob/living/user)
	. = ..()
	if(!active_item)
		return
	to_chat(user, span_hypnophrase("那具邪恶的尸骸伴着一声黏腻的闷响剥落下来。你的头颅湿漉漉的，覆满那生物亮滑的黏液……你感到自己的活力回来了！"))
	user.change_stat(STATKEY_LCK, -5)
	user.change_stat(STATKEY_CON, 5)
	active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/jar
	name = "陶罐"
	desc = "倒扣在头上刚好合缝的陶罐。侧面敲出了一个小孔以便视物，虽说视野很差。"
	icon = 'icons/roguetown/clothing/special/jar.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/jar.dmi'
	icon_state = "jar"
	armor = list("blunt" = 10, "slash" = 80, "stab" = 100, "piercing" = 100, "fire" = 100, "acid" = 0)//UNBREAKABLE ALEXANDER
	blocksound = list('sound/combat/hits/onstone/wallhit.ogg')
	break_sound = 'sound/foley/glassbreak.ogg'
	max_integrity = ARMOR_INT_HELMET_CLOTH//actually very breakable
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	anvilrepair = /datum/skill/craft/ceramics
	smeltresult = /obj/item/natural/brick//why not
	block2add = FOV_RIGHT|FOV_LEFT//I CANT SEE SHIT
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/helmet/heavy/jar/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_THROWINGARM, REF(src))

/obj/item/clothing/head/roguetown/helmet/heavy/jar/dropped(mob/living/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_THROWINGARM, REF(src))
