/obj/item/clothing/gloves/roguetown/elven_gloves
	name = "染纹精灵手套"
	desc = "内里衬着柔软而活着的叶片与泥土。它们很容易吸走湿气。"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfhand"
	item_state = "welfhand"
	armor = ARMOR_BLACKOAK //Resistant to blunt and stab, super weak to slash.
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_IRON
	smeltresult = /obj/item/rogueore/coal
	anvilrepair = /datum/skill/craft/carpentry
	sewrepair = FALSE
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/// Dendor ritual variant of the woad elven gloves — grown from the Treefather's sanctified root.
/obj/item/clothing/gloves/roguetown/elven_gloves/druidic
	name = "受祝德鲁伊手套"
	desc = "由受树父祝福滋养的根须编织而成的护手。活木能吸收冲击，并减轻本会撕裂血肉的劈砍。"
	armor = list("blunt" = 100, "slash" = 65, "stab" = 130, "piercing" = 20, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/roguetown/elven_gloves/druidic/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/gloves/roguetown/elven_gloves/druidic/pickup(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type == /datum/patron/divine/dendor)
		return
	H.electrocute_act(30, src)
	H.mob_timers["kneestinger"] = world.time
	to_chat(H, span_warning("[name] 拒绝了我的握持，唯有树父的信徒才配承受这份恩赐！"))

/obj/item/clothing/gloves/roguetown/bandages
	name = "缠手绷带"
	desc = "厚织绷带缠在双手上。它会吸收掌心汗水、强化你的拳头，并保护指关节不被打飞的牙齿割伤。"
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon_state = "clothwraps"
	item_state = "clothwraps"
	armor = ARMOR_PADDED_BAD //Light padding — worse than leather gloves, but offers some cushioning.
	max_integrity = 200
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/cloth
	unarmed_bonus = 3 //Light armor with good durability and a flat unarmed damage bonus. Loadout-selectable.
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/bandages/weighted
	name = "配重缠手"
	desc = "厚织绷带缠在双手上，并配有加垫指节配重。它会吸收掌心汗水、强化你的拳头，并保护指关节不被打飞的牙齿割伤。"
	unarmed_bonus = 5 //Craftable. Given to non-specialized Monks and other certain subclasses.

/obj/item/clothing/gloves/roguetown/bandages/pugilist
	name = "搏击缠手"
	desc = "厚织绷带缠在双手上，并配有合金指节配重。它会吸收掌心汗水、强化你的拳头，并保护指关节不被打飞的牙齿割伤。"
	unarmed_bonus = 7 //Non-craftable. Restricted to Monks who've specialized in unarmed combat, and nothing else.

// Knuckledusters — high damage, low durability gloves. +12 bonus but only 100 integrity vs bandages' 200.
/obj/item/clothing/gloves/roguetown/knuckles
	name = "钢制指虎"
	desc = "一副模样凶狠的钢制指虎。"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "steelknuckle"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	w_class = WEIGHT_CLASS_SMALL
	armor = ARMOR_PADDED_BAD
	max_integrity = 100 //Small metal pieces — fragile under sustained parrying.
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	unarmed_bonus = 12

/obj/item/clothing/gloves/roguetown/knuckles/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("可像护腕一样进行徒手招架。招架时会损失耐久。")

/obj/item/clothing/gloves/roguetown/knuckles/bronze
	name = "青铜指虎"
	desc = "一副模样凶狠的青铜指虎。比钢制版本略重，是一件扎实的防御选择，只是没那么趁手。"
	icon_state = "bronzeknuckle"
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/gloves/roguetown/knuckles/psydon
	name = "普赛顿式指虎"
	desc = "一件简朴的杀器，以钢与银的神圣混合物铸成，末端收为三个残桩——普赛顿之冠——足以将异端的衣甲砸成碎片。"
	icon_state = "psyknuckle"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/clothing/gloves/roguetown/knuckles/psydon/old
	name = "坚忍指虎"
	desc = "一件简朴的杀器，以钢与银的神圣混合物铸成，其神圣祝福早已褪去。你即是祂的武器，无需畏惧永世。"
	icon_state = "psyknuckle"
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/clothing/gloves/roguetown/knuckles/psydon/old/ComponentInitialize()
	return

/obj/item/clothing/gloves/roguetown/knuckles/decrepit
	name = "衰朽指虎"
	desc = "一套以远古金属制成的指虎，永世的掌控正使其形体枯萎。"
	icon_state = "aknuckle"
	max_integrity = 50 //Extra fragile — ancient and degraded.
	smeltresult = /obj/item/ingot/aaslag
	unarmed_bonus = 4

/obj/item/clothing/gloves/roguetown/knuckles/ancient
	name = "远古指虎"
	desc = "一套以远古金属制成的指虎，永世的掌控已从其形体上解除。"
	icon_state = "aknuckle"
	smeltresult = /obj/item/ingot/aaslag
	unarmed_bonus = 6

/obj/item/clothing/gloves/roguetown/knuckles/eora
	name = "亲密抚触"
	desc = "有些时候，需要一种更亲密的方式。"
	icon_state = "eoraknuckle"
	max_integrity = 150

/obj/item/clothing/gloves/roguetown/knuckles/blacksteel
	name = "黑钢指虎"
	desc = "接招吧，尝尝痛楚的滋味！"
	icon_state = "bsknuckledusters"
	max_integrity = 200
	unarmed_bonus = 12
	smeltresult = /obj/item/ingot/blacksteel
