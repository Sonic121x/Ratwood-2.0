/datum/action/cooldown/spell/conjure_spectacles
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "召唤眼镜"
	desc = "在手中召出自选的幻象眼镜。\n\
	召出新的眼镜或解除法术绑定时，原眼镜会消失。\n\
	与真正的眼镜不同，它们不提供特殊能力或视野。"
	button_icon_state = "conjspect"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("驱散目盲！") // I'm blind!
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 0
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/clothing/mask/rogue/spectacles/conjured_spectacles = null

	var/list/spectacles = list(
		"眼镜" = /obj/item/clothing/mask/rogue/spectacles,
		"诺克遮光镜" = /obj/item/clothing/mask/rogue/spectacles/inq_lesser_summoned,
		"金眼镜" = /obj/item/clothing/mask/rogue/spectacles/golden_lesser_summoned,
		"银单片眼镜" = /obj/item/clothing/mask/rogue/spectacles/monocle,
		"烟色缟玛瑙眼镜" = /obj/item/clothing/mask/rogue/spectacles/onyxa_lesser_summoned,
		"精致眼镜" = /obj/item/clothing/mask/rogue/spectacles/fancy,
		"精致染色眼镜" = /obj/item/clothing/mask/rogue/spectacles/fancy/dark,
	)

/datum/action/cooldown/spell/conjure_spectacles/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/spectacles_choice = input(user, "选择一种眼镜", "召唤眼镜") as anything in spectacles
	if(!spectacles_choice)
		return
	if(src.conjured_spectacles)
		qdel(src.conjured_spectacles)
	spectacles_choice = spectacles[spectacles_choice]

	var/obj/item/clothing/mask/rogue/spectacles/R = new spectacles_choice(user.drop_location())
	if(!QDELETED(R))
		R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE, FALSE, user, src)
	user.put_in_hands(R)
	src.conjured_spectacles = R
	R.sellprice = 0
	return TRUE

/obj/item/clothing/mask/rogue/spectacles/inq_lesser_summoned
	name = "召唤的诺克遮光镜"
	icon_state = "bglasses"
	desc = "诺克选民与奥塔瓦正教之间的争论已持续多年。\n\
	无人真正知道这种眼镜最初是谁创造的。\n\
	但至少有一点确定：它们相当时髦。"

// Smokey onyxa spectacles summonable lesser varient - with no mechanical effects (seperate cause my third-eye senses potental for the original varient)
// ALso because your specs aren't the authentic real-deal, its funnier to have them visably a knockoff varient.

/obj/item/clothing/mask/rogue/spectacles/onyxa_lesser_summoned
	name = "召唤的烟色缟玛瑙眼镜"
	icon_state = "sglasses"
	desc = "死亡已经来到你的小镇，治安官。你可以置之不理，也可以帮我阻止它。" //KEEPING IT, ITS PEAK SIRE

// Golden spectacles summonable lesser varient - with no mechanical effects

/obj/item/clothing/mask/rogue/spectacles/golden_lesser_summoned
	name = "召唤的金眼镜"
	icon_state = "goggles"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/armorsmithing
	adjustable = CAN_CADJUST
	var/active_item = FALSE

/obj/item/clothing/mask/rogue/spectacles/golden_lesser_summoned/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask
