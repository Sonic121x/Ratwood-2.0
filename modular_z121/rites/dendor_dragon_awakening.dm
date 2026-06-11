/proc/z121_find_dragon_rite_voidstone(mob/living/carbon/human/H)
	if(!H)
		return null
	var/obj/item/magic/voidstone/active_voidstone = H.get_active_held_item()
	if(istype(active_voidstone))
		return active_voidstone
	var/obj/item/magic/voidstone/inactive_voidstone = H.get_inactive_held_item()
	if(istype(inactive_voidstone))
		return inactive_voidstone
	return null

// This custom Dendor rune is spawned by the modular_z121 chalk override so the dragon rite
// is isolated from the base Azure Peak implementation.
/obj/structure/ritualcircle/dendor/z121_dragon_awakening
	bestialrites = list("Rite of the Lesser Wolf", "Borrowed Madness", "Spider Kinship", "龙魂觉醒")

/obj/structure/ritualcircle/dendor/z121_dragon_awakening/attack_hand(mob/living/user)
	// Do not call the immediate Dendor parent attack_hand(): it would open the original rite
	// menu first and swallow the custom option before this subtype can handle it.
	if(!allow_dreamwalkers && HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user, span_danger("Only the rune of stirring calls to me now..."))
		return
	if((user.patron?.type) != /datum/patron/divine/dendor)
		to_chat(user, span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user, span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return

	var/list/available_rites = bestialrites

	var/riteselection = input(user, "Rituals of Beasts", src) as null|anything in available_rites
	switch(riteselection)
		if("Rite of the Lesser Wolf")
			if(do_after(user, 50))
				user.say("RRRGH GRRRHHHG GRRRRRHH!!")
				playsound(loc, 'sound/vo/mobs/vw/idle (1).ogg', 100, FALSE, -1)
				if(do_after(user, 50))
					user.say("GRRRR GRRRRHHHH!!")
					playsound(loc, 'sound/vo/mobs/vw/idle (4).ogg', 100, FALSE, -1)
					if(do_after(user, 50))
						loc.visible_message(span_warning("[user] snaps and snarls at the rune. Drool runs down their lip..."))
						playsound(loc, 'sound/vo/mobs/vw/bark (1).ogg', 100, FALSE, -1)
						if(do_after(user, 30))
							icon_state = "dendor_active"
							loc.visible_message(span_warning("[user] snaps their head upward, they let out a howl!"))
							playsound(loc, 'sound/vo/mobs/wwolf/howl (2).ogg', 100, FALSE, -1)
							lesserwolf(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "dendor_chalky"
		if("Borrowed Madness")
			if(do_after(user, 50))
				user.say("I pray for strength...")
				playsound(loc, 'sound/vo/mobs/vw/idle (1).ogg', 100, FALSE, -1)
				if(do_after(user, 50))
					user.say("I pray for pain...")
					playsound(loc, 'sound/vo/mobs/vw/idle (4).ogg', 100, FALSE, -1)
					if(do_after(user, 50))
						loc.visible_message(span_warning("[user] produces an eerie sound as they titter quietly, softly weeping. Their body twitches ever so slightly..."))
						playsound(loc, 'sound/vo/mobs/vw/bark (1).ogg', 100, FALSE, -1)
						if(do_after(user, 30))
							icon_state = "dendor_active"
							loc.visible_message(span_warning("[user] suddenly snaps their head upward, letting out a twisted howl!"))
							playsound(loc, 'sound/vo/mobs/wwolf/howl (2).ogg', 100, FALSE, -1)
							borrowedmadness(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "dendor_chalky"
		if("Spider Kinship")
			if(do_after(user, 50))
				user.say("I call to the ruthless wilds,")
				playsound(loc, 'sound/vo/mobs/spider/idle (1).ogg', 100, FALSE, -1)
				if(do_after(user, 50))
					user.say("... grant me an agile form of your dominion..!")
					playsound(loc, 'sound/vo/mobs/spider/idle (3).ogg', 100, FALSE, -1)
					if(do_after(user, 30))
						icon_state = "dendor_active"
						loc.visible_message(span_warning("[user] seizes up, suddenly covered in a mess of silky webs, which then slough away into a sticky pile!"))
						playsound(loc, 'sound/vo/mobs/spider/pain.ogg', 100, FALSE, -1)
						spiderkinship(src)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						spawn(120)
							icon_state = "dendor_chalky"
		if("龙魂觉醒")
			var/mob/living/carbon/human/druid_user = user
			if(!istype(druid_user))
				to_chat(user, span_warning("Only mortals of flesh may awaken the dragon soul."))
				return
			if(!z121_is_dragon_wildshape_eligible(druid_user))
				to_chat(druid_user, span_warning("Only Dendor's druids who already walk the Beast Form path may awaken the dragon soul."))
				return
			if(druid_user.mind?.has_spell(/obj/effect/proc_holder/spell/self/wildshape/dragon))
				to_chat(druid_user, span_notice("The dragon soul already burns within me."))
				return
			if(!z121_find_dragon_rite_voidstone(druid_user))
				to_chat(druid_user, span_warning("I must hold a voidstone to feed the rite."))
				return
			if(do_after(druid_user, 50))
				druid_user.say("Treefather, hear me...")
				playsound(loc, 'sound/vo/mobs/vw/idle (2).ogg', 100, FALSE, -1)
				if(do_after(druid_user, 50))
					druid_user.say("... let fang, scale, and ancient flame answer my prayer!")
					playsound(loc, 'sound/magic/fireball.ogg', 100, FALSE, -1)
					if(do_after(druid_user, 50))
						var/obj/item/magic/voidstone/offering = z121_find_dragon_rite_voidstone(druid_user)
						if(!offering)
							to_chat(druid_user, span_warning("The rite sputters out without a voidstone offering."))
							return
						icon_state = "dendor_active"
						loc.visible_message(span_warning("[druid_user] presses a voidstone into the rune as a bestial heat rolls through the grove!"))
						playsound(loc, 'sound/magic/fireball.ogg', 100, FALSE, -1)
						dragon_soul_awakening(druid_user, offering)
						druid_user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						spawn(120)
							icon_state = "dendor_chalky"

/obj/structure/ritualcircle/dendor/z121_dragon_awakening/proc/dragon_soul_awakening(mob/living/carbon/human/target, obj/item/magic/voidstone/offering)
	if(QDELETED(target) || !target.mind || QDELETED(offering))
		return FALSE
	if(target.mind.has_spell(/obj/effect/proc_holder/spell/self/wildshape/dragon))
		to_chat(target, span_notice("The dragon soul already burns within me."))
		return FALSE

	// Consume the rite's material after the channel succeeds so failed attempts do not waste it.
	qdel(offering)

	var/obj/effect/proc_holder/spell/self/wildshape/dragon/new_spell = new
	target.mind.AddSpell(new_spell, target)
	to_chat(target, span_notice("A draconic shape coils through my spirit. I can now invoke 荒野形态-龙."))
	target.flash_fullscreen("redflash3")
	target.emote("agony")
	return TRUE
