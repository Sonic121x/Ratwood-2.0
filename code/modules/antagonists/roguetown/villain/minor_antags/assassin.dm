// Assassin, cultist of graggar. Normally found as a drifter.
/datum/antagonist/assassin
	name = "刺客"
	roundend_category = "刺客"
	antagpanel_category = "刺客"
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "assassin"
	show_name_in_check_antagonists = TRUE
	confess_lines = list(
		"我的信条即是鲜血！",
		"匕首告诉了我该杀谁！",
		"死亡就是我的信仰！",
		"黑暗之日指引着我的手！",
	)
	antag_flags = FLAG_FAKE_ANTAG

	var/traits_assassin = list(
		TRAIT_ASSASSIN,
		TRAIT_NOSTINK,
		TRAIT_STEELHEARTED,
	)

/datum/antagonist/assassin/on_gain()
	owner.current.cmode_music = list('sound/music/cmode/antag/combat_assassin.ogg')
	for(var/trait in traits_assassin)
		ADD_TRAIT(owner.current, trait, TRAIT_GENERIC)
	owner.current.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT)
	owner.current.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT)
	owner.current.set_patron(/datum/patron/inhumen/graggar)
	to_chat(owner.current, "<span class='danger'>直到现在我都伪装得很好，但现在该让 格拉加尔 的猎物灭亡了。我必须去取回我藏起来的匕首。</span>")
	new /datum/antag_setup(owner.current)
	return ..()

/mob/living/carbon/human/proc/who_targets() // Verb for the assassin to remember their targets.
	set name = "回想目标"
	set category = "格拉加尔"
	if(!mind)
		return
	mind.recall_targets(src)

/mob/living/carbon/human/proc/draw_graggar_sigil()
	set name = "Draw Blood Sigil"
	set category = "Graggar"
	if(incapacitated() || stat >= UNCONSCIOUS)
		return
	if(!get_bleed_rate())
		to_chat(src, span_danger("I must be bleeding to draw this."))
		return
	var/turf/T = get_turf(src)
	if(locate(/obj/effect/decal/cleanable/graggar_sigil) in T)
		to_chat(src, span_warning("There is already a sigil here."))
		return
	if(!do_after(src, 5 SECONDS, src))
		return
	playsound(src, 'sound/items/write.ogg', 100)
	new /obj/effect/decal/cleanable/graggar_sigil(T)

/obj/effect/decal/cleanable/graggar_sigil
	name = "bloody sigil"
	desc = "A crude sigil created with smeared blood."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "graggar_active"

/obj/effect/decal/cleanable/graggar_sigil/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!istype(user) || !HAS_TRAIT(user, TRAIT_ASSASSIN))
		return
	var/turf/T = get_turf(src)
	var/choice = input(user, "Which rite?", "Graggar") as null|anything in list("Profane Dagger")
	if(choice == "Profane Dagger")
		var/obj/item/rogueweapon/huntingknife/dagger = locate() in T
		var/obj/item/organ/organ = locate() in T
		if(!dagger || istype(dagger, /obj/item/rogueweapon/huntingknife/idagger/steel/profane))
			to_chat(user, span_warning("The ritual needs: Any knife, any organ."))
			return
		if(!organ)
			to_chat(user, span_warning("The ritual needs: Any knife, any organ."))
			return
		if(!do_after(user, 3 SECONDS, src))
			return
		qdel(dagger)
		qdel(organ)
		new /obj/item/rogueweapon/huntingknife/idagger/steel/profane(T)
		playsound(T, 'sound/magic/soulsteal.ogg', 100)

/datum/antagonist/assassin/on_removal()
	if(owner.current)
		for(var/trait in traits_assassin)
			REMOVE_TRAIT(owner.current, trait, TRAIT_GENERIC)
	if(!silent && owner.current)
		to_chat(owner.current,"<span class='danger'>我脑海中的血红迷雾正在消散。我不再是[name]了！</span>")
	return ..()

/datum/antagonist/assassin/on_life(mob/user)
	if(!user)
		return
	var/mob/living/carbon/human/H = user
	H.verbs |= /mob/living/carbon/human/proc/who_targets
	H.verbs |= /mob/living/carbon/human/proc/draw_graggar_sigil

/datum/antagonist/assassin/roundend_report()
	var/traitorwin = FALSE
	for(var/obj/item/I in owner.current) // Check to see if the Assassin has their profane dagger on them, and then check the souls contained therein.
		if(istype(I, /obj/item/rogueweapon/huntingknife/idagger/steel/profane))
			for(var/mob/dead/observer/profane/A in I) // Each trapped soul is announced to the server
				if(A)
					to_chat(world, "[A.name] 已被 [owner.name] 献给 格拉加尔 夺走。<span class='greentext'>诅咒降临！</span>")
					traitorwin = TRUE

	if(!considered_alive(owner))
		traitorwin = FALSE

	if(traitorwin)
		to_chat(world, "<span class='greentext'>[name] [owner.name] 凯旋了！</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, "<span class='redtext'>[name] [owner.name] 失败了！</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)
