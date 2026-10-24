/proc/z121_is_dragon_wildshape_eligible(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return FALSE
	if(!istype(H.patron, /datum/patron/divine/dendor))
		return FALSE
	if(H.job != "Druid" && H.advjob != "Druid")
		return FALSE
	return TRUE

// 这个解锁后的法术继续沿用原版 wildshape 流程，避免破坏转移心智、
// 信仰值共享和现有的变形清理逻辑。
/datum/action/cooldown/spell/z121/self/dragon_wildshape
	name = "荒野形态-龙"
	desc = "以登多尔赐下的龙魂化作巨龙之姿。再次施放可解除变形。"
	button_icon_state = "tamebeast"
	hold_drain = 0
	charge_time = 0
	cooldown_time = 45 SECONDS
	cooldown_min = 50
	invocations = list("树父啊，唤醒我体内的巨龙！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 120
	miracle = TRUE

/datum/action/cooldown/spell/z121/self/dragon_wildshape/z121_apply(atom/cast_on)
	var/mob/living/carbon/human/user = owner
	if(!user)
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/submissive))
		to_chat(user, span_warning("你的意志过于破碎，无法唤醒龙魂。"))
		z121_cancel()
		return FALSE

	if(istype(user, /mob/living/carbon/human/species/wildshape))
		user.wildshape_untransform()
		return FALSE

	if(!z121_is_dragon_wildshape_eligible(user))
		to_chat(user, span_warning("只有已经完成龙魂觉醒的登多尔德鲁伊才能使用这一形态。"))
		z121_cancel()
		return FALSE

	return TRUE

// 新版动作先结算本体的虔诚与冷却，再进入会转移心智的变形流程。
/datum/action/cooldown/spell/z121/self/dragon_wildshape/after_cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(QDELETED(user) || !z121_is_dragon_wildshape_eligible(user))
		return
	user.Stun(30)
	user.Knockdown(30)
	INVOKE_ASYNC(user, TYPE_PROC_REF(/mob/living/carbon/human, wildshape_transformation), /mob/living/carbon/human/species/wildshape/dendor_dragon)

/mob/living/carbon/human/species/wildshape/dendor_dragon
	name = "巨龙"
	race = /datum/species/shapedragon
	footstep_type = FOOTSTEP_MOB_HEAVY
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/dragon_scale
	wildshape_icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
	wildshape_icon_state = "dragon"

/mob/living/carbon/human/species/wildshape/dendor_dragon/death(gibbed, nocutscene = FALSE)
	wildshape_untransform(TRUE, gibbed)

/mob/living/carbon/human/species/wildshape/dendor_dragon/buckle_mob(mob/living/target, force = TRUE, check_loc = TRUE, lying_buckle = FALSE, hands_needed = 0, target_hands_needed = 0)
	. = ..(target, force, check_loc, lying_buckle, hands_needed, target_hands_needed)

/mob/living/carbon/human/species/wildshape/dendor_dragon/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)

		// 相比敌对龙模板做了下调，保证形态足够强力但不会直接替代 Boss 级单位。
		src.STASTR = 18
		src.STACON = 17
		src.STAWIL = 15
		src.STAPER = 13
		src.STASPD = 9
		src.STAINT = 5

		AddSpell(new /datum/action/cooldown/spell/z121/self/dragontalons)
		faction += "dragons"
		if(src.client?.prefs?.wildshape_name)
			real_name = "巨龙 ([stored_mob.real_name])"
		else
			real_name = "巨龙"

/datum/species/shapedragon
	name = "巨龙"
	id = "shapedragon"
	// 已解锁的龙形不参与普通随机种族变化。
	changesource_flags = MIRROR_BADMIN
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_STRONGBITE,
		TRAIT_STEELHEARTED,
		TRAIT_BREADY,
		TRAIT_ORGAN_EATER,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER,
		TRAIT_PIERCEIMMUNE,
		TRAIT_LONGSTRIDER,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_BIGGUY,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_NOFIRE,
		TRAIT_NIGHT_VISION,
		TRAIT_BASHDOORS,
		TRAIT_TOXIMMUNE,
		TRAIT_NOBREATH,
		TRAIT_BLOODLOSS_IMMUNE,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0, 2), OFFSET_HANDS_F = list(0, 2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
	)
	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shapedragon/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/vw/aggro (1).ogg', 'sound/vo/mobs/vw/aggro (2).ogg'), 80, TRUE, -1)

/datum/species/shapedragon/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "dragon"
	H.pixel_x = -32
	H.pixel_y = -16
	H.update_damage_overlays()
	return TRUE

/datum/species/shapedragon/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/shapedragon/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

/obj/item/clothing/suit/roguetown/armor/skin_armor/dragon_scale
	slot_flags = null
	name = "龙鳞"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 240
	item_flags = DROPDEL

/datum/intent/simple/dragon_talons
	name = "龙爪"
	clickcd = 10
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("爪击", "猛撕", "撕裂")
	animname = "cut"
	hitsound = "genslash"
	penfactor = PEN_LIGHT
	dodgeable_intent = TRUE
	parriable_intent = TRUE
	miss_text = "划破空气！"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/obj/item/rogueweapon/dragon_talon
	name = "龙爪"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/misc32.dmi'
	max_blade_int = 800
	max_integrity = 800
	force = 30
	wdefense = 8
	blade_dulling = DULLING_SHAFT_WOOD
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = list('sound/vo/mobs/vw/aggro (1).ogg', 'sound/vo/mobs/vw/aggro (2).ogg')
	possible_item_intents = list(/datum/intent/simple/dragon_talons, /datum/intent/claw/lunge/iron, /datum/intent/claw/rend, /datum/intent/mace/smash)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/dragon_talon/right
	icon_state = "claw_r"

/obj/item/rogueweapon/dragon_talon/left
	icon_state = "claw_l"

/obj/item/rogueweapon/dragon_talon/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/item/rogueweapon/dragon_talon/attack_self(mob/living/user)
	var/obj/item/rogueweapon/dragon_talon/active = user.get_active_held_item()
	var/obj/item/rogueweapon/dragon_talon/inactive = user.get_inactive_held_item()
	if(active)
		user.dropItemToGround(active, TRUE)
	if(inactive && inactive != active)
		user.dropItemToGround(inactive, TRUE)

/datum/action/cooldown/spell/z121/self/dragontalons
	name = "龙爪"
	desc = "伸出或收回你的龙爪。"
	button_icon_state = "claws"
	spell_requirements = NONE
	cooldown_time = 20
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	var/extended = FALSE

/datum/action/cooldown/spell/z121/self/dragontalons/z121_apply(atom/cast_on)
	var/mob/living/user = owner
	var/obj/item/rogueweapon/dragon_talon/left/l
	var/obj/item/rogueweapon/dragon_talon/right/r
	var/active = user.get_active_held_item()
	var/inactive = user.get_inactive_held_item()

	if(istype(active, /obj/item/rogueweapon/dragon_talon) || istype(inactive, /obj/item/rogueweapon/dragon_talon))
		if(istype(active, /obj/item/rogueweapon/dragon_talon))
			user.dropItemToGround(active, TRUE)
		if(istype(inactive, /obj/item/rogueweapon/dragon_talon) && inactive != active)
			user.dropItemToGround(inactive, TRUE)
		to_chat(user, span_notice("你的龙爪收了回去。"))
		extended = FALSE
	else
		l = new(user, 1)
		r = new(user, 2)
		user.put_in_hands(l, TRUE, FALSE, TRUE)
		user.put_in_hands(r, TRUE, FALSE, TRUE)
		to_chat(user, span_notice("你的龙爪伸了出来。"))
		extended = TRUE
