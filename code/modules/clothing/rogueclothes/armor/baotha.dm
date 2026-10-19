
/obj/item/clothing/suit/roguetown/armor/plate/baotha
	name = "巴奥莎胸甲"
	desc = "肌肉线条夸张的胸甲。强大的巴奥莎魔法守护着甲片间若隐若现的裸露肌肤。"
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	icon_state = "baothachest"
	item_state = "baothachest"
	// armor = ARMOR_ASCENDANT//seems all other of these use more default values so I'll follow the format
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	// peel_threshold = 5	//-Any- weapon will require 5 peel hits to peel coverage off of this armor.

/obj/item/clothing/suit/roguetown/armor/plate/baotha/Initialize(mapload)
	. = ..()
	// ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "护甲")
	// AddComponent(/datum/component/item_equipped_movement_rustle, null)

// /obj/item/clothing/suit/roguetown/armor/plate/baotha/dropped(mob/living/carbon/human/user)
// 	. = ..()
// 	if(QDELETED(src))
// 		return
// 	qdel(src)

/obj/item/clothing/under/roguetown/platelegs/baotha
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "巴奥莎腿甲"
	desc = "强大的巴奥莎魔法守护着甲片间若隐若现的裸露肌肤。"
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	icon_state = "baotha_legs"
	armor = ARMOR_PLATE_BSTEEL
	body_parts_covered = LEGS|GROIN

/obj/item/clothing/under/roguetown/platelegs/baotha/Initialize(mapload)
	. = ..()
	// ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "护甲")
	// AddComponent(/datum/component/item_equipped_movement_rustle, null)

// /obj/item/clothing/under/roguetown/platelegs/baotha/dropped(mob/living/carbon/human/user)
// 	. = ..()
// 	if(QDELETED(src))
// 		return
// 	qdel(src)

// /obj/item/clothing/under/roguetown/platelegs/baotha/Initialize(mapload)
// 	. = ..()
// 	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)

/obj/item/clothing/wrists/roguetown/bracers/baotha
	name = "巴奥莎臂甲"
	desc = "镀金臂甲，保护双臂。"
	body_parts_covered = ARMS
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	icon_state = "baothabracers"
	item_state = "baothabracers"
	sleeved = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	alternate_worn_layer = WRISTS_LAYER
	max_integrity = ARMOR_INT_SIDE_ANTAG
	unequip_delay_self = 2 SECONDS

/obj/item/clothing/wrists/roguetown/bracers/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "护臂")

/obj/item/clothing/suit/roguetown/armor/leather/studded/baotha
	name = "巴奥莎束带"
	desc = "黑色皮革紧缠肌肤，冰冷铆钉陷入其间，留下痕迹。"
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	icon_state = "baothashirt"
	item_state = "baothashirt"
	armor = ARMOR_LEATHER
	sleeved = null
	body_parts_covered =  CHEST | GROIN | VITALS | LEGS | ARMS |NECK | HANDS | FEET
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	armor_class = ARMOR_CLASS_LIGHT
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	cold_protection = CHEST | LEGS | ARMS
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	alternate_worn_layer = PANTS_LAYER+1

/obj/item/clothing/suit/roguetown/armor/leather/studded/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "束带")

/obj/item/clothing/head/roguetown/helmet/heavy/baotha
	name = "欲望之盔"
	desc = "凝望汝之美貌，而后绝望。"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha64.dmi'
	icon_state = "baothahelmet"
	item_state = "baothahelmet"
	bloody_icon = 'icons/effects/blood64.dmi'
	max_integrity = ARMOR_INT_HELMET_ANTAG
	worn_x_dimension = 32
	worn_y_dimension = 48
	bloody_icon = 'icons/effects/blood64.dmi'
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "面甲")

/datum/outfit/job/roguetown/baothaarmor/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/baotha
	shirt = /obj/item/clothing/suit/roguetown/armor/leather/studded/baotha
	pants = /obj/item/clothing/under/roguetown/platelegs/baotha
	wrists = /obj/item/clothing/wrists/roguetown/bracers/baotha
	head = /obj/item/clothing/head/roguetown/helmet/heavy/baotha
	belt = /obj/item/storage/belt/rogue/leather/plaquegold/baotha
	gloves = /obj/item/clothing/gloves/roguetown/chain/baotha
	shoes = /obj/item/clothing/shoes/roguetown/anklets/baotha
	neck = /obj/item/clothing/neck/roguetown/gorget/boatha
	backr = /obj/item/storage/backpack/rogue/satchel/short
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending/lesser)


/obj/item/storage/belt/rogue/leather/plaquegold/baotha
	name = "巴奥莎胯链"
	desc = "巴奥莎魔法让你的装备稳妥贴身，又不遮挡风景。"
	icon = 'icons/roguetown/clothing/feet.dmi'
	icon_state = "anklets"
	color = "#9c7373"
	item_flags = DROPDEL
	mob_overlay_icon = null

/obj/item/storage/belt/rogue/leather/plaquegold/baotha/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/gloves/roguetown/chain/baotha
	name = "巴奥莎腕环"
	desc = "强大的巴奥莎魔法守护着下方裸露的肌肤。"
	icon = 'icons/roguetown/clothing/feet.dmi'
	icon_state = "anklets"
	color = "#9c7373"
	item_flags = DROPDEL
	mob_overlay_icon = null
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_SIDE_ANTAG
	equip_delay_self = 0.5 SECONDS
	unequip_delay_self = 2.5 SECONDS

/obj/item/clothing/gloves/roguetown/chain/baotha/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

// /obj/item/clothing/shoes/roguetown/boots/armor/baotha
// 	name = "巴欧萨踝环"
// 	desc = "强大的巴欧萨魔法守护着下方裸露的肌肤。"
// 	icon = 'icons/roguetown/clothing/feet.dmi'
// 	icon_state = "anklets"
// 	mob_overlay_icon = null
// 	armor = ARMOR_ASCENDANT
// 	max_integrity = ARMOR_INT_SIDE_ANTAG
// 	is_barefoot = TRUE

// /obj/item/clothing/shoes/roguetown/boots/armor/baotha/Initialize(mapload)
// 	. = ..()
// 	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

// /obj/item/clothing/shoes/roguetown/boots/armor/baotha/dropped(mob/living/carbon/human/user)
// 	. = ..()
// 	if(QDELETED(src))
// 		return
// 	qdel(src)

/obj/item/clothing/shoes/roguetown/anklets/baotha
	name = "巴奥莎踝环"
	desc = "强大的巴奥莎魔法守护着下方裸露的肌肤。"
	color = "#9c7373"
	item_flags = DROPDEL
// 	mob_overlay_icon = null
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_SIDE_ANTAG
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/shoes/roguetown/anklets/baotha/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/gorget/boatha
	name = "黑钢项圈"
	desc = "臣服于黑暗。"
	icon_state = "iwolfcollaralt"
	item_flags = DROPDEL
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_SIDE_ANTAG

/obj/item/clothing/neck/roguetown/gorget/boatha/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/rogueweapon/whip/baotha
	name = "完美苦痛"
	desc = "邪恶，邪恶，邪恶。"
	icon_state = "baotha_whip"
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish, /datum/intent/dagger/sucker_punch) // sucker as a little flavor and bonus.
	unenchantable = TRUE
	force = 25
	minstr = 8

/obj/item/rogueweapon/whip/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "鞭")

/obj/item/clothing/head/roguetown/helmet/light/baotha
	name = "蜜惑萨雷特盔"
	desc = "一种违背常理的美，却又不同于你曾见过的任何美丽之物……"
	icon_state = "baothahelm"
	item_state = "baothahelm"
	body_parts_covered = HEAD | HAIR | EARS | MOUTH | EYES
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_HELMET_ANTAG - 300 //Halved durability, compared to traditional Ascendant-tier armor.
	smeltresult = null

/obj/item/clothing/head/roguetown/helmet/light/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "HELMET")

/obj/item/clothing/neck/roguetown/coif/baotha
	name = "蜜惑面纱"
	desc = "臣服于黑暗……"
	icon_state = "baothacoif"
	item_state = "baothacoif"
	item_flags = DROPDEL
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	body_parts_covered = NECK | HAIR | EARS | HEAD | NOSE
	armor_class = ARMOR_CLASS_LIGHT
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	color = null
	smeltresult = null

/obj/item/clothing/neck/roguetown/coif/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "VEIL")
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/cloth_wipe (1).ogg', null, (UPD_HEAD|UPD_MASK|UPD_NECK))
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/baotha
	name = "蜜惑板甲"
	desc = "一件轻巧的板甲。强大的巴奥莎魔法保护着裸露的血肉，使甲胄更为轻盈，代价则是较低的耐久……"
	icon_state = "baothaplate"
	item_state = "baothaplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG - 350 //Halved durability, compared to traditional Ascendant-tier armor.
	armor_class = ARMOR_CLASS_LIGHT //The big, big thing.
	color = null
	body_parts_covered = COVERAGE_FULL
	smeltresult = null

/obj/item/clothing/suit/roguetown/armor/plate/fluted/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "护甲")

/obj/item/clothing/suit/roguetown/armor/gambeson/baotha
	name = "蜜惑法衣"
	desc = "一件灌注巴奥莎魔法的织衣，却仍露着身体的要害……仿佛在欢迎刀刃带来的痛苦与欢愉……"
	icon_state = "baothagamb"
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_PADDED
	color = null
	item_flags = DROPDEL
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	armor_class = ARMOR_CLASS_LIGHT
	resistance_flags = FIRE_PROOF
	body_parts_covered = CHEST | GROIN | ARMS
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	smeltresult = null

/obj/item/clothing/suit/roguetown/armor/gambeson/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "VESTMENTS")
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)


/obj/item/clothing/wrists/roguetown/bracers/leather/baotha
	name = "蜜惑腕饰"
	desc = "镀金臂甲，保护双臂。"
	icon_state = "baothabracers"
	armor = ARMOR_PADDED
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	smeltresult = null

/obj/item/clothing/wrists/roguetown/bracers/leather/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "BRACERS")

/obj/item/clothing/under/roguetown/baotha/skirt
	name = "蜜惑甲裙"
	desc = "以自身灵辉编织，结合强大的巴奥莎魔法，化作一条时髦而不失防护力的裙装。"
	armor = ARMOR_PADDED
	icon_state = "baothaskirt"
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	body_parts_covered = GROIN | LEGS
	smeltresult = null

/obj/item/clothing/under/roguetown/baotha/skirt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "SKIRT")

/obj/item/clothing/gloves/roguetown/plate/baotha
	name = "蜜惑护手"
	desc = "强大的巴奥莎魔法交织成网，保护柔嫩双手下的血肉……"
	icon_state = "baothagloves"
	item_state = "baothagloves"
	max_integrity = ARMOR_INT_SIDE_ANTAG - 150
	armor_class = ARMOR_CLASS_LIGHT
	smeltresult = null

/obj/item/clothing/gloves/roguetown/plate/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "GLOVES")

/obj/item/clothing/shoes/roguetown/boots/armor/baotha
	name = "蜜惑高跟鞋"
	desc = "巴奥莎魔法缠绕裸露的血肉，塑成一双高跟鞋，保护下方柔嫩的肌肤……"
	icon_state = "baothaboots"
	item_state = "baothaboots"
	max_integrity = ARMOR_INT_SIDE_ANTAG - 150
	armor_class = ARMOR_CLASS_LIGHT
	smeltresult = null

/obj/item/clothing/shoes/roguetown/boots/armor/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "BOOTS")

/obj/item/clothing/shoes/roguetown/boots/armor/baotha/ComponentInitialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_HEELS, 2)
	stepnoise_flag = STEPNOISE_HEELS // This will prevent default footstep noise from being made by the heels (sounds odd)

/datum/outfit/job/roguetown/baothalightarmor/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/baotha
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/baotha
	pants = /obj/item/clothing/under/roguetown/baotha/skirt
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/baotha
	head = /obj/item/clothing/head/roguetown/helmet/light/baotha
	gloves = /obj/item/clothing/gloves/roguetown/plate/baotha
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/baotha
	neck = /obj/item/clothing/neck/roguetown/coif/baotha
	backr = /obj/item/storage/backpack/rogue/satchel/short
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending/lesser)
