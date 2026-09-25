/obj/item/organ/wings
	name = "翅膀"
	desc = "一对翅膀。它们也许能让你飞起来……至少还能扑腾几下。"
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_WINGS
	///Whether the wings should grant flight on insertion.
	var/unconditional_flight
	///What species get flights thanks to those wings. Important for moth wings
	var/list/flight_for_species
	///Whether a wing can be opened by the *wing emote. The sprite use a "_open" suffix, before their layer
	var/can_open
	///Whether an openable wing is currently opened
	var/is_open
	///Whether the owner of wings has flight thanks to the wings
	var/granted_flight

	icon = 'icons/mob/sprite_accessory/wings/wings_64x32.dmi'
	icon_state = "harpyfolded_FRONT"

	var/wings_color
	var/wing_natural_gradient
	var/wing_natural_color
	var/wing_dye_gradient
	var/wing_dye_color

/obj/item/organ/wings/bodypart_overlays(mutable_appearance/standing)
	add_gradient_overlay(standing, wing_natural_gradient, wing_natural_color)
	add_gradient_overlay(standing, wing_dye_gradient, wing_dye_color)

/obj/item/organ/wings/proc/add_gradient_overlay(mutable_appearance/standing, gradient_type, gradient_color)
	if(gradient_type == /datum/hair_gradient/none || isnull(gradient_type))
		return
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type) // In the case of wings we need to get gradient size too
	var/datum/hair_gradient/gradient = HAIR_GRADIENT(gradient_type)
	var/icon/gradient_icon = icon(accessory.gradient_icon, gradient.icon_state)
	if(accessory.pixel_x > 0)
		gradient_icon.Shift(NORTH, accessory.pixel_x, wrap = TRUE)
	else if(accessory.pixel_x < 0)
		gradient_icon.Shift(SOUTH, abs(accessory.pixel_x), wrap = TRUE)
	var/layered_icon_state = accessory.icon_state
	var/layer_suffix = accessory.get_layer_suffix(-(standing.layer))
	if(layer_suffix)
		layered_icon_state = accessory.icon_state + "_[layer_suffix]"
	var/icon/hair_icon = icon(accessory.icon, layered_icon_state)
	gradient_icon.Blend(hair_icon, ICON_ADD)
	var/mutable_appearance/gradient_appearance = mutable_appearance(gradient_icon)
	gradient_appearance.color = gradient_color
	standing.overlays += gradient_appearance

/obj/item/organ/wings/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_tongue_noise_verbs()

/obj/item/organ/wings/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_tongue_noise_verbs()

//TODO: Well you know what this flight stuff is a bit complicated and hardcoded, this is enough for now

/obj/item/organ/wings/moth
	name = "弗卢维安翅膀"
	desc = "一对毛茸茸的蛾翼。"
	flight_for_species = list("moth")

/obj/item/organ/wings/dracon
	name = "龙裔翅膀"
	desc = "一对威风凛凛的龙裔翅膀。"
//	flight_for_species = list("dracon") we'll revisit this later it's probably moth sprite only


/obj/item/organ/wings/anthro
	name = "兽裔翅膀"

/obj/item/organ/wings/flight
	unconditional_flight = TRUE
	can_open = TRUE

/obj/item/organ/wings/flight/angel
	name = "天使翅膀"
	desc = "一对华丽的羽翼。看起来足够强壮，能带你飞上天空。"

/obj/item/organ/wings/flight/dragon
	name = "龙翼"
	desc = "一对骇人的膜翼。看起来足够强壮，能带你飞上天空。"

/obj/item/organ/wings/flight/megamoth
	name = "巨蛾翅膀"
	desc = "一对大得吓人的毛绒翅膀。看起来足够强壮，能带你飞上天空。"

/obj/item/organ/wings/flight/night_kin
	name = "吸血鬼翅膀"
	accessory_type = /datum/sprite_accessory/wings/large/gargoyle
	/// Flight datum
	var/datum/action/item_action/organ_action/use/flight/fly

/obj/item/organ/wings/harpy // we could... make it an arm subtype... but im lazy!
	name = "哈比翅膀"
	desc = "啊，多想再次飞翔，感受风的吹拂……"
	should_regenerate = TRUE
	var/list/nullspace_items = list()

/obj/item/organ/wings/harpy/Insert(mob/living/carbon/human/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(M.mind)
		if(isharpy(M))
			M.mind.AddSpell(new /obj/effect/proc_holder/spell/self/harpy_flight)
			src.nullspace_items += new /obj/item/rogueweapon/huntingknife/idagger/harpy_talons
			M.skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/harpy_skin
		else
			to_chat(M, span_bloody("我是有翅膀了，没错……可这玩意儿到底他妈怎么用？！！"))

/obj/item/organ/wings/harpy/Remove(mob/living/carbon/human/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(M.mind)
		M.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/harpy_flight)

/obj/effect/proc_holder/spell/self/harpy_flight
	name = "哈比飞行"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	overlay_state = "zad"
	movement_interrupt = FALSE
	associated_skill = null
	antimagic_allowed = TRUE
	ignore_cockblock = TRUE
	recharge_time = 5
	miracle = FALSE
	var/baseline_stamina_cost = 9
	var/list/swoop_sound = list(
		'sound/foley/footsteps/flight_sounds/swooping1.ogg',
		'sound/foley/footsteps/flight_sounds/swooping2.ogg',
		'sound/foley/footsteps/flight_sounds/swooping3.ogg'
	)

/obj/effect/proc_holder/spell/self/harpy_flight/cast(mob/living/carbon/human/user)
	var/harpy_AC = user.highest_ac_worn()
	if(harpy_AC != ARMOR_CLASS_NONE)
		to_chat(user, span_bloody("护甲太沉，压得我飞不起来！！")) // LIGHT ON YO FEET SOULJA
		return
	if(user.buckled)
		to_chat(user, span_bloody("我被这样固定着……根本飞不起来！！"))
		return
	if(user.pulledby)
		to_chat(user, span_bloody("有人<b>抓着我</b>，这样根本飞不起来！</br>太残忍了！！"))
		return

	if(user.has_status_effect(/datum/status_effect/debuff/harpy_flight))
		to_chat(user, span_bloody("哇，又回到地上了！这感觉……真古怪！！")) // sad emoji
		user.remove_status_effect(/datum/status_effect/debuff/harpy_flight)
		playsound(user, pick(swoop_sound), 100)
		user.emote("wingsfly", forced = TRUE)
		return

	if(!(user.mobility_flags & MOBILITY_STAND))
		to_chat(user, span_bloody("我这样失去平衡，根本飞不起来！啊啊！！"))
		return
	if(user.restrained(ignore_grab = FALSE))
		to_chat(user, span_bloody("锁链束缚了我的自由！！"))

	if(HAS_TRAIT(user, TRAIT_INFINITE_STAMINA))
		to_chat(user, span_bloody("我精力太旺盛，控制不住自己的飞行！</br>啊啊！！"))
		user.Knockdown(10)
		return

	user.visible_message(span_notice("[user]准备起飞。"))
	if(!move_after(user, 3 SECONDS, target = user))
		return

	var/athletics_skill = max(user.get_skill_level(/datum/skill/misc/athletics), SKILL_LEVEL_NOVICE)
	var/stamina_cost_final = round((baseline_stamina_cost - athletics_skill), 1)
	user.apply_status_effect(/datum/status_effect/debuff/harpy_flight, stamina_cost_final)
	playsound(user, pick(swoop_sound), 100)
	user.emote("wingsfly", forced = TRUE)
	if(prob(1)) // somebody, call saint jiub!!
		playsound(user, 'sound/foley/footsteps/flight_sounds/cliffracer.ogg', 100)
