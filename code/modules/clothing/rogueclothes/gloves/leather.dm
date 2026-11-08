// Because no one fucking know about inheritance in this bleak codebase.
/obj/item/clothing/gloves/roguetown/leather
	name = "皮手套"
	desc = "由结实皮革制成的手套。几乎没什么防护，但总比没有强。"
	icon_state = "leather_gloves"
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_SIDE_LEATHER
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	unarmed_bonus = 1
	color = "#66584c"
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_MAGEDEXTERITY)

/obj/item/clothing/gloves/roguetown/leather/black
	color = CLOTHING_BLACK

/obj/item/clothing/gloves/roguetown/fingerless
	name = "露指手套"
	desc = "能吸收掌心汗水的布手套，同时让手指保持自由，便于精细操作。"
	icon_state = "fingerless_gloves"
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	nudist_approved = TRUE

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
	name = "露指手套"
	desc = "能吸收掌心汗水的布手套，同时让手指保持自由，便于精细操作。"
	icon_state = "shadowgloves"
	allowed_race = NON_DWARVEN_RACE_TYPES
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	name = "露指手套"
	desc = "能吸收掌心汗水的布手套，同时让手指保持自由，便于精细操作。"
	icon_state = "shadowgloves"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/gloves/roguetown/fingerless_leather
	name = "露指皮手套"
	desc = "一副深受博学法师、锁匠、劳工与烟民喜爱的防护手套，相比普通手套，更能保持手部的灵活性。"
	icon_state = "roguegloves"
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_CLOTH
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/fingerless_leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_MAGEDEXTERITY)

/obj/item/clothing/gloves/roguetown/otavan
	name = "奥塔万皮手套"
	desc = "一副沉重的奥塔万皮手套，常为击剑手所用，以品质著称。"
	icon_state = "fencergloves"
	item_state = "fencergloves"
	armor = ARMOR_MAILLE
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	allowed_race = NON_DWARVEN_RACE_TYPES
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/otavan/inqgloves
	name = "宗审庭皮手套"
	desc = "大师级工艺的皮手套，以轻薄锁甲层加固。左手袖口垂着一串小念珠，温柔提醒着即便是宗审官也受祂权威约束。"
	icon_state = "inqgloves"
	item_state = "inqgloves"
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/otavan/psygloves
	name = "赛顿皮手套"
	desc = "厚实的皮质连指手套，缝线严密、袖口收束，以保护祂子民的手掌不被刺穿。"
	armor = ARMOR_LEATHER
	icon_state = "psydongloves"
	item_state = "psydongloves"
	salvage_result = /obj/item/natural/hide/cured
	allowed_race = ALL_RACES_TYPES

// Eastern gloves
/obj/item/clothing/gloves/roguetown/eastgloves1
	name = "黑手套"
	desc = "剑士常用的利落手套。"
	icon_state = "eastgloves1"
	item_state = "eastgloves1"
	armor = ARMOR_LEATHER
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

/obj/item/clothing/gloves/roguetown/eastgloves2
	name = "时髦手套"
	desc = "异乡帮派常戴的奇特手套。"
	icon_state = "eastgloves2"
	item_state = "eastgloves2"
	armor = ARMOR_LEATHER
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

/obj/item/clothing/gloves/roguetown/leather/horsey
	name = "手臂束具"
	desc = "用于双臂的加固皮革绑带。"
	icon_state = "harms"
	item_state = "harms"
	slot_flags = ITEM_SLOT_GLOVES|ITEM_SLOT_HANDS
	body_parts_covered = HANDS|ARMS
	// sleeved = FALSE
	color = null

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster
	name = "执政之手的手套"
	desc = "柔韧的丝绸，指尖开口，确保动作绝对精准。"
	icon_state = "handgloves"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/gloves.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/gloves.dmi'

/obj/item/clothing/gloves/roguetown/rosa
	name = "象牙白手套"
	desc = "以丝绸与皮革精制的手套。"
	icon_state = "rosagloves1"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/rosa/eight
	name = "宫廷手套"
	icon_state = "rosagloves8"

/obj/item/clothing/gloves/roguetown/rosa/five
	name = "墨黑手套"
	icon_state = "rosagloves5"

/obj/item/clothing/gloves/roguetown/rosa/four
	name = "曜黑手套"
	icon_state = "rosagloves4"

/obj/item/clothing/gloves/roguetown/rosa/nine
	name = "王室手套"
	icon_state = "rosagloves9"

/obj/item/clothing/gloves/roguetown/rosa/seven
	name = "华贵手套"
	icon_state = "rosagloves7"

/obj/item/clothing/gloves/roguetown/rosa/six
	name = "栗红手套"
	icon_state = "rosagloves6"

/obj/item/clothing/gloves/roguetown/rosa/ten
	name = "庄重手套"
	icon_state = "rosagloves10"

/obj/item/clothing/gloves/roguetown/rosa/three
	name = "银饰手套"
	icon_state = "rosagloves3"
