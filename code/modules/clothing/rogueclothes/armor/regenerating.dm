// REGENERATING ARMOUR

#define COMBAT_TAG_DURATION 30 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating
	name = "再生护甲"
	desc = "抽象父类。若你能看到这个，请联系开发者。"
	icon_state = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	unenchantable = TRUE

	/// Feedback messages
	var/repairmsg_begin = "我的护甲开始缓缓修复受损……"
	var/repairmsg_continue = "我的护甲修复了部分损伤……"
	var/repairmsg_stop = "在猛攻之下，我的护甲停止修复了！"
	var/repairmsg_end = "我的护甲已重新绷紧，焕发新生！"

	/// Combat timer that prevents you from healing while taking damage
	var/combat_timer
	/// Recursive timer that slowly regenerates the armor
	var/reptimer
	/// Time taken for regeneration
	var/repair_time = 10 SECONDS
	/// If the armor regen is stopped by a combat tag
	var/combat_taggable = FALSE

/obj/item/clothing/suit/roguetown/armor/regenerating/equipped(mob/user, slot)
	. = ..()
	UnregisterSignal(user, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE))
	if(slot == SLOT_SHIRT || slot == SLOT_ARMOR)
		RegisterSignal(user, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE), PROC_REF(on_attacked_by))

/// Combat tag system, makes your skin stop regenning if you are attacked by anything
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/on_attacked_by(datum/source)
	SIGNAL_HANDLER
	if(!combat_taggable) // This means constant in-combat regen
		if(!reptimer && obj_integrity < max_integrity)
			reptimer = addtimer(CALLBACK(src, PROC_REF(begin_repair)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)
		return

	combat_timer = addtimer(CALLBACK(src, PROC_REF(begin_repair)), COMBAT_TAG_DURATION, TIMER_UNIQUE|TIMER_OVERRIDE)
	if(timeleft(reptimer))
		to_chat(loc, span_notice(repairmsg_stop))
	deltimer(reptimer)
	reptimer = null
	return

/// Start repairing the armor
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/begin_repair()
	to_chat(loc, span_notice(repairmsg_begin))
	armour_regen(skip_message = TRUE)

/// Recursive loop that fixes the armor
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/armour_regen(repair_percent = 0.2 * max_integrity, skip_message = FALSE)
	obj_integrity = min(obj_integrity + repair_percent, max_integrity)
	if(obj_broken)
		obj_fix(full_repair = FALSE)

	if(obj_integrity >= max_integrity)
		to_chat(loc, span_notice(repairmsg_end))
		deltimer(reptimer)
		reptimer = null
		return

	if(!skip_message)
		to_chat(loc, span_notice(repairmsg_continue))

	reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

// SKIN ARMOUR

/obj/item/clothing/suit/roguetown/armor/regenerating/skin
	name = "再生皮肤"
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	resistance_flags = FIRE_PROOF
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	flags_inv = null //Exposes the chest and-or breasts.
	surgery_cover = FALSE //Should permit surgery and other invasive processes.
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	armor = ARMOR_PADDED
	nudist_approved = TRUE

	repairmsg_begin = "我的皮肤开始缓缓修复受损……"
	repairmsg_continue = "我的皮肤修复了部分损伤……"
	repairmsg_stop = "在猛攻之下，我的皮肤停止修复了！"
	repairmsg_end = "我的皮肤重新绷紧，焕发新生！"

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest
	// Chest and body layers need different block sounds to equip together
	blocksound = SOFTHIT

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/disciple
	name = "门徒之肤"
	desc = "它远不只是一句誓言。 </br>'永世、普赛顿、阿多奈——熵、众生 \
	、神性。三位一体，  既为一，又为三；为众所知，却被时光遗忘。' < \
	/br>'一具尸体。  我正活在一具尸体上。祂便是世界，而世界正在 \
	腐烂。  天堂早已对我们关闭了大门。' </br>'然而，祂的孩子们 \
	仍在坚持；只要他们还在，我也必须坚持。  幸福必须靠战斗去争取。'"
	armor = ARMOR_PADDED
	repair_time = 20 SECONDS
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 50//350

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/disciple/equipped(mob/living/user, slot)
	. = ..()
	ADD_TRAIT(user, TRAIT_MONK_ROBE, TRAIT_GENERIC)
	to_chat(user, span_notice("HIS CHILDREN PERSIST; AND AS LONG AS THEY DO, SO MUST I!"))

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/disciple/dropped(mob/living/user)//we cant drop it, but whatever.
	..()
	REMOVE_TRAIT(user, TRAIT_MONK_ROBE, TRAIT_GENERIC)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/disciple
	name = "enduring chest"
	desc = "It's far more than just an oath. \
	YET THREE; KNOWN BY ALL, YET FORGOTTEN TO TYME.' </br>'A CORPSE. \
	I AM LIVING ON A FUCKING CORPSE. HE IS THE WORLD, AND THE WORLD IS ROTTING AWAY. \
	HEAVEN CLOSED ITS GATES TO US, LONG AGO.' </br>'YET, HIS CHILDREN PERSIST; AND AS LONG AS THEY DO, SO MUST I. \
	HAPPINESS MUST BE FOUGHT FOR.'"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST
	armor = ARMOR_LEATHER
	repair_time = 20 SECONDS
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 50//350

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/weak
	name = "坚韧皮肤"
	desc = "我的皮肤向来够硬，足以挡下大多数划伤与瘀伤，只要给它时间就会愈合。"
	armor = ARMOR_REGENERATING_WEAK
	max_integrity = 300
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	combat_taggable = TRUE

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/gladiator
	name = "斗坑淬炼的胸膛"//pit? hnnnnhhhffgggg
	desc = "你们还不尽兴吗？！"
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST
	blocksound = SOFTHIT
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER //defaults to a leather armor
	repair_time = 15 SECONDS//less armor and integ so faster regen

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/gladiator
	name = "斗坑淬炼的皮肤"
	desc = "你们还不尽兴吗？！"
	body_parts_covered = COVERAGE_FULL //everything but head and it's subzones (neck, skull, ears, eyes, nose, mouth)
	body_parts_inherent = COVERAGE_FULL
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM //defaults to a gambeson
	repair_time = 15 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/monk
	name = "trained skin"
	desc = "They say I've taken the first step on a path older than memory."
	body_parts_covered = COVERAGE_FULL //everything but head and it's subzones (neck, skull, ears, eyes, nose, mouth)
	body_parts_inherent = COVERAGE_FULL
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM //defaults to a gambeson
	repair_time = 15 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/monk
	name = "trained chest"
	desc = "I don't fully understand what those names mean yet, but I repeat them as I was taught."
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST
	blocksound = SOFTHIT
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	repair_time = 15 SECONDS//less armor and integ so faster regen

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/berzerker
	name = "unstoppable skin"
	desc = "I've endured enough. The onslaught has lost its meaning."
	armor = ARMOR_BRONZE//scary, but longer regen
	body_parts_covered = COVERAGE_FULL //everything but head and it's subzones (neck, skull, ears, eyes, nose, mouth)
	body_parts_inherent = COVERAGE_FULL
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	repair_time = 40 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/berzerker
	name = "unstoppable chest"
	desc = "The callouses could stop arrows! But only so many."
	armor = ARMOR_MAILLE//covers stabs
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL //Light steel maille.
	repair_time = 40 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/iconclast
	name = "gilded skin"
	desc = "The Many-Faced smiles on me. Wreath me in gold melted from crowns, let my skin shine radiant and glittering."
	armor = ARMOR_BRONZE
	blocksound = PLATEHIT
	body_parts_covered = COVERAGE_FULL //everything but head and it's subzones (neck, skull, ears, eyes, nose, mouth)
	body_parts_inherent = COVERAGE_FULL
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	repair_time = 40 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/iconoclast
	name = "gilded chest"
	desc = "The Many-Faced smiles on me. Shield my heart O' Matthios, cover my ribs with drake scales."
	armor = ARMOR_BRIGANDINE//neither bronze nor brig cover stab damage well, meaning nat armor icono has a chink in the armor
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL
	repair_time = 40 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/barbarian
	name = "hardened skin"
	desc = "Toughened from abuse. My mettle remains. Resting will restore it's strength."
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM //defaults to a gambeson
	repair_time = 15 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/barbarian
	name = "hardened chest"
	desc = "Toughened from abuse. My mettle remains. Resting will restore it's strength."
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST
	blocksound = SOFTHIT
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER //defaults to a leather armor
	repair_time = 15 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/bodybuilder//dedicated gachi-muchi armor
	name = "strongman's pride"
	desc = "Toughened from rigorous routine and mettle. A physique that could hold up the sky."
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER //A full-body leather armor.
	repair_time = 30 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/bodybuilder
	name = "strongman's pecs"
	desc = "Akin to marble hewn by the old Etruscan masters. The skin is pulled taut revealing intricate vascularity beneath."
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST
	blocksound = PLATEHIT//I HAVE BALLS OF STEEL
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER //defaults to a leather armor
	repair_time = 30 SECONDS//better armor, longer repair

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/ruma
	name = "bouhoi bujeog tattoos"
	desc = "A mystic style of tattoos adopted by the Ruma Clan, emulating a practice performed by warrior monks of the Xinyi Dynasty. They are your way of identifying fellow clan members, an sign of companionship and secretive brotherhood. These are styled into the shape of clouds, created by a mystical ink which shifts and moves in ripples like a pond to harden where your skin is struck. It's movement causes you to shudder."
	resistance_flags = FIRE_PROOF
	icon_state = "easttats"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	armor = ARMOR_LEATHER
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_race = NON_DWARVEN_RACE_TYPES
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	repair_time = 30 SECONDS

#undef COMBAT_TAG_DURATION

