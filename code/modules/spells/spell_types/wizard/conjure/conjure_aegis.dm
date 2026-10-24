/datum/action/cooldown/spell/conjure_aegis
	name = "奥术神盾"
	desc = "将奥术之盾投射至副手。它响应奥术武装的修习，而非盾阵训练；在被解除、击碎或脱手前持续存在。空出副手再次施放可重新召出。"
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "conjure_aegis"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 150

	invocations = list("盾牌，凝聚！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 5 SECONDS
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 120 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/rogueweapon/shield/arcyne_aegis/conjured_aegis
	var/aegis_type = /obj/item/rogueweapon/shield/arcyne_aegis

/datum/action/cooldown/spell/conjure_aegis/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/offhand = H.get_inactive_held_item()
	if(offhand && offhand != conjured_aegis)
		to_chat(H, span_warning("必须空出副手才能投射神盾！"))
		return FALSE
	if(conjured_aegis && !QDELETED(conjured_aegis))
		conjured_aegis.visible_message(span_warning("[conjured_aegis]闪烁着消散了！"))
		qdel(conjured_aegis)
	var/obj/item/rogueweapon/shield/arcyne_aegis/S = new aegis_type(H.drop_location())
	S.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE, FALSE, H, src)
	if(!H.put_in_inactive_hand(S))
		qdel(S)
		to_chat(H, span_warning("我未能在副手召出神盾。"))
		return FALSE
	conjured_aegis = S
	H.visible_message(span_notice("[H]投射出一面闪烁的奥术盾牌！"))
	return TRUE

/datum/action/cooldown/spell/conjure_aegis/Destroy()
	if(conjured_aegis && !QDELETED(conjured_aegis))
		qdel(conjured_aegis)
	conjured_aegis = null
	return ..()

/obj/item/rogueweapon/shield/arcyne_aegis
	name = "奥术神盾"
	desc = "罕见的奥术能量团，投射于施法者面前。刀剑及近战武器缓慢而稳健的动作能轻易穿透它，触及后方脆弱的法师。"
	icon = 'icons/roguetown/weapons/prismatic_weapons64.dmi'
	icon_state = "moonlight_shield"
	pixel_x = -16
	bigboy = TRUE
	force = 15
	wdefense = 10
	coverage = 30
	max_integrity = 220
	special = null
	unenchantable = TRUE
	sellprice = 0
	static_price = TRUE
	parrysound = list('sound/combat/parry/shield/magicshield (1).ogg', 'sound/combat/parry/shield/magicshield (2).ogg', 'sound/combat/parry/shield/magicshield (3).ogg')
	associated_skill = /datum/skill/combat/arcyne

/obj/item/rogueweapon/shield/arcyne_aegis/obj_break(damage_flag)
	. = ..()
	if(!QDELETED(src))
		visible_message(span_warning("[src]碎裂了！"))
		playsound(get_turf(src), 'sound/magic/magic_nulled.ogg', 80)
		qdel(src)
