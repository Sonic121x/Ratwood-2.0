#define IMMOLATION_FILTER "immolation_glow"
#undef IMMOLATION_FILTER
/obj/effect/proc_holder/spell/self/astratan_path
	name = "秩序之路"
	overlay_icon = 'icons/mob/actions/astratamiracles.dmi'
	action_icon = 'icons/mob/actions/astratamiracles.dmi'
	overlay_state = "order"
	desc = "阿斯特拉塔赐福你的心智，让你选择以 <b>她</b> 的哪种方式贯彻秩序。"
	miracle = TRUE
	devotion_cost = 100
	recharge_time = 10 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/self/astratan_path/cast(list/targets, mob/user)
	. = ..()
	var/choice = alert(user, "你要执掌哪一种武装神迹？", "承担神威", "圣枪", "圣矛")
	switch(choice)
		if("圣枪")
			if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue))//No stacking.
				revert_cast(user)
				return FALSE
			else
				user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue)
				if(user.mind?.has_spell(/obj/effect/proc_holder/spell/self/astratan_spear))//No, thanks.
					user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/astratan_spear)
		if("圣矛")
			if(user.mind?.has_spell(/obj/effect/proc_holder/spell/self/astratan_spear))//No stacking. Again. As funny as a dozen of these were.
				revert_cast(user)
				return FALSE
			else
				user.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/astratan_spear)
				if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue))//Nope.
					user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue)
		else
			revert_cast(user)
			return FALSE

//Summoning the spear.
/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue
	name = "烈焰长枪"
	desc = "造成伤害并点燃目标，对亡灵造成额外伤害。"
	overlay_icon = 'icons/mob/actions/astratamiracles.dmi'
	action_icon = 'icons/mob/actions/astratamiracles.dmi'
	overlay_state = "sacredflame"
	sound = 'sound/magic/bless.ogg'
	invocations = list("受烈火净化吧！")//Not so sacred.
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	miracle = TRUE
	devotion_cost = 75
	projectile_type = /obj/projectile/magic/astratablast
