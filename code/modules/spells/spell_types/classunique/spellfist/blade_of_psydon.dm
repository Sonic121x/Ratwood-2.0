/datum/action/cooldown/spell/blade_of_psydon
	source_aspect = /datum/magic_aspect/pseudo/spellfist
	button_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	name = "普赛顿之刃"
	desc = "刀刃这一高等概念的具现。据说它源自诺克的智慧宝库，每次施放都只是祂所珍藏完美兵器的拙劣摹本。\n\n\
	数百年前，纳莱迪的智者瑜伽师前往塔里凯亚学习魔剑之道，完善奥术召刃术，在需要锋刃之时为普赛顿之拳赋予刀剑……"
	button_icon_state = "boundkatar"
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_SUMMON

	charge_required = FALSE
	cooldown_time = 1 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/drawmessage = "我想象那柄由奥术知识锻造、锋刃完美的兵器。\
	心眼能感知它，却总差一线。我扯下它的影子，一件粗劣的仿品，却依然堪称神兵…… "
	var/dropmessage = "松开手，我看着刀刃失去形体；没有我的能量将其锚定于世，它无法保持稳定……"
	var/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon/summoned_blade

/datum/action/cooldown/spell/blade_of_psydon/Destroy()
	if(summoned_blade && !QDELETED(summoned_blade))
		UnregisterSignal(summoned_blade, COMSIG_PARENT_QDELETING)
		QDEL_NULL(summoned_blade)
	return ..()

/datum/action/cooldown/spell/blade_of_psydon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/user = owner
	if(!istype(user))
		return FALSE

	if(summoned_blade && !QDELETED(summoned_blade))
		qdel(summoned_blade)
		to_chat(user, span_notice("[dropmessage]"))
		return FALSE

	summoned_blade = new(user)
	summoned_blade.attached_spell = null
	RegisterSignal(summoned_blade, COMSIG_PARENT_QDELETING, PROC_REF(on_blade_destroyed))
	if(!user.put_in_hands(summoned_blade))
		qdel(summoned_blade)
		if(user.get_num_arms() <= 0)
			to_chat(user, span_warning("我没有能用的手！"))
		else
			to_chat(user, span_warning("我双手都满了！"))
		return FALSE
	to_chat(user, span_notice("[drawmessage]"))
	return TRUE

/datum/action/cooldown/spell/blade_of_psydon/proc/on_blade_destroyed(datum/source)
	SIGNAL_HANDLER
	summoned_blade = null

/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon
	name = "\improper 奥术拳剑"
	desc = "这柄半透明、泛着虹彩的利刃脉动着，蓝色奥术能量流淌于晶莹表面……"
	catchphrase = null
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "katar_bound"
	charges = 20
	force = 24
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_HUGE
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 999
	max_integrity = 50
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 0
	wbalance = WBALANCE_SWIFT
	can_parry = TRUE

/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon/attack_self()
	qdel(src)
