/datum/patron/inhumen/zizo
	name = "Zizo"
	domain = "死灵术、进步、腐朽、左道魔法"
	desc = "神首本是凡间的雪精灵 Zinoviya，被她神圣的父亲 PSYDON 所遗弃。当她发现自己被剥夺神位后，便击倒了 PSYDON 并亲自夺取了神性，使世界坠入腐朽再临的第二次降世。把世界焚成灰烬，再将其重新塑造。"
	worshippers = "死灵法师、癫狂法师、不死者"
	virtues = "进步、不死、野心"
	sins = "无知、停滞、谦卑"
	mob_traits = list(TRAIT_CABAL, TRAIT_ZIZOSIGHT)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/zizo_snuff						= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/profane/miracle 	= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/tame_undead/miracle			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/rituos/miracle 				= CLERIC_T3,
					/obj/effect/proc_holder/spell/targeted/touch/lacrima				= CLERIC_T3,
	)
	confess_lines = list(
		"赞美 ZIZO！",
		"ZIZO 万岁！",
		"ZIZO 即为女王！",
	)
	storyteller = /datum/storyteller/zizo

/datum/patron/inhumen/zizo/post_equip(mob/living/pious)
	. = ..()
	if(ishuman(pious))
		var/mob/living/carbon/human/human = pious
		var/datum/devotion/pious_devotion = human.devotion
		if(pious_devotion?.level >= CLERIC_T2)
			pious.grant_language(/datum/language/undead)

// When the sun is blotted out, zchurch, bad-cross, or ritual chalk
/datum/patron/inhumen/zizo/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/indoors/shelter/mountains))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("那座遭诅咒的 psycross 打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer near a grave.
	for(var/obj/structure/closet/dirthole/grave/G in view(4, get_turf(follower)))
		return TRUE
	// Allows prayer during the sun being blotted from the sky.
	if(hasomen(OMEN_SUNSTEAL))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/zizo in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Zizo 听见我的祈祷，我必须身处被遗弃者的教堂、倒置的 psycross 附近、站在绘好的 Zizite 符记上，或趁太阳被遮蔽天穹之时祈祷！"))
	return FALSE

/datum/patron/inhumen/zizo/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("生命活力正被抽向 [target]！")
	*message_self = span_notice("我周围的生气正在褪去，而我得到了修复！")

	var/bonus = 0

	for(var/obj/item/natural/bone/bone in oview(5, user))
		bonus += 0.5

	for(var/obj/item/natural/bundle/bone/bone in oview(5, user))
		bonus += (bone.amount * 0.5)

	if(!bonus)
		return

	*conditional_buff = TRUE
	*situational_bonus = min(bonus, 5)
