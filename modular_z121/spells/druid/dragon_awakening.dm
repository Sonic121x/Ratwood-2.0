// 觉醒法术是巨龙荒野形态的新一次性解锁路径。
/proc/z121_find_dragon_voidstone(mob/living/carbon/human/H)
	if(!H)
		return null
	var/obj/item/magic/voidstone/active_voidstone = H.get_active_held_item()
	if(istype(active_voidstone))
		return active_voidstone
	var/obj/item/magic/voidstone/inactive_voidstone = H.get_inactive_held_item()
	if(istype(inactive_voidstone))
		return inactive_voidstone
	return null

/obj/effect/proc_holder/spell/self/dragon_soul_awakening
	name = "龙魂觉醒"
	desc = "握持一枚虚空石，花费一分钟唤醒体内的龙魂。成功后此法术会消失。"
	overlay_state = "tamebeast"
	clothes_req = FALSE
	human_req = FALSE
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	cooldown_min = 0
	invocations = list("树父啊，让龙魂自我体内苏醒！")
	invocation_type = "shout"
	action_icon_state = "shapeshift"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 0
	miracle = FALSE

/obj/effect/proc_holder/spell/self/dragon_soul_awakening/cast(list/targets, mob/living/carbon/human/user = usr)
	. = ..()
	if(!user)
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/submissive))
		to_chat(user, span_warning("你的意志过于破碎，无法唤醒龙魂。"))
		revert_cast()
		return FALSE

	if(!z121_is_dragon_wildshape_eligible(user))
		to_chat(user, span_warning("只有登多尔的德鲁伊才能唤醒龙魂。"))
		revert_cast()
		return FALSE

	if(user.mind?.has_spell(/obj/effect/proc_holder/spell/self/wildshape/dragon, TRUE))
		to_chat(user, span_notice("龙魂早已在我体内燃烧。"))
		user.mind?.RemoveSpell(src)
		return FALSE

	if(!z121_find_dragon_voidstone(user))
		to_chat(user, span_warning("我必须手持一枚虚空石来唤醒龙魂。"))
		revert_cast()
		return FALSE

	user.visible_message(
		span_notice("[user] 开始借助虚空石唤醒体内的龙族之魂。"),
		span_notice("你开始唤醒龙魂。请在整整一分钟内始终握住虚空石。")
	)
	playsound(get_turf(user), 'sound/magic/fireball.ogg', 70, TRUE, -1)

	if(!do_after(user, 1 MINUTES))
		to_chat(user, span_warning("在龙魂完全苏醒前，你的专注被打断了。"))
		revert_cast()
		return FALSE

	var/obj/item/magic/voidstone/offering = z121_find_dragon_voidstone(user)
	if(!offering)
		to_chat(user, span_warning("由于你已经没有握着虚空石，觉醒失败了。"))
		revert_cast()
		return FALSE

	if(user.mind?.has_spell(/obj/effect/proc_holder/spell/self/wildshape/dragon, TRUE))
		to_chat(user, span_notice("龙魂早已在我体内燃烧。"))
		user.mind?.RemoveSpell(src)
		return FALSE

	qdel(offering)
	user.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/wildshape/dragon, user)
	to_chat(user, span_notice("一股巨龙之形缠绕上我的灵魂。我现在可以施放荒野形态-龙了。"))
	user.flash_fullscreen("redflash3")
	user.emote("agony")
	user.mind?.RemoveSpell(src)
	return TRUE

// 在不修改基础职业文件的前提下，为德鲁伊出生时补发一次性觉醒法术。
/datum/job/roguetown/druid/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	if(!H.mind)
		return
	if(H.mind.has_spell(/obj/effect/proc_holder/spell/self/wildshape/dragon, TRUE))
		return
	if(H.mind.has_spell(/obj/effect/proc_holder/spell/self/dragon_soul_awakening, TRUE))
		return

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/dragon_soul_awakening, H)
