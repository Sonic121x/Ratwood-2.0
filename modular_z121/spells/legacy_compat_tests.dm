#ifdef UNIT_TESTS
/datum/unit_test/z121_spell_migration/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human/consistent)
	H.mind_initialize()
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
	H.mind.mage_aspect_config = list("major" = 1, "minor" = 1, "utilities" = 2, "mastery" = FALSE)
	H.mind.adjust_spellpoints(4)
	if(!H.mind.has_spell(/datum/action/cooldown/spell/learnspell))
		Fail("Legacy spell points must not hide the upstream aspect picker")
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/self/learnspell))
		Fail("Custom spell points must grant the legacy spell library")
	var/obj/effect/proc_holder/spell/self/learnspell/library = H.mind.get_spell(/obj/effect/proc_holder/spell/self/learnspell)
	var/list/data = library.ui_data(H)
	if(data["user_points"] != 4 || !length(data["spells"]))
		Fail("The custom spell library must expose the available points and spells")
	H.mind.used_spell_points = 4
	H.mind.check_learnspell()
	if(H.mind.has_spell(/obj/effect/proc_holder/spell/self/learnspell))
		Fail("Spending custom points must remove only the legacy learning action")
	if(!H.mind.has_spell(/datum/action/cooldown/spell/learnspell))
		Fail("Spending custom points must preserve the aspect learning action")
	H.mind.used_spell_points = 0
	H.mind.check_learnspell()
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/self/learnspell))
		Fail("Refunding custom points must restore the legacy learning action")
	for(var/spell_type in list(/datum/action/cooldown/spell/projectile/spitfire, /datum/action/cooldown/spell/projectile/soulshot, /datum/action/cooldown/spell/projectile/fireball))
		var/datum/action/cooldown/spell/S = spell_type
		if(!(initial(S.button_icon_state) in icon_states(initial(S.button_icon))))
			Fail("Localized spell [spell_type] has an invalid action icon")
	if(DisplayTimeText(610, chinese = TRUE) != "1分钟1秒")
		Fail("Existing Chinese duration callers must retain their named argument")

/datum/unit_test/z121_aspect_profession/Run()
	var/datum/advclass/C = allocate(/datum/advclass)
	C.applies_post_equipment = FALSE
	C.subclass_mage_aspects = list("major" = 1, "minor" = 1, "utilities" = 2, "mastery" = FALSE)
	C.age_mod = new /datum/class_age_mod/adv_mage
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human/consistent)
	H.mind_initialize()
	H.age = AGE_OLD
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
	C.equipme(H)
	if(H.mind.mage_aspect_config?["minor"] != 2 || H.mind.mage_aspect_config?["utilities"] != 5)
		Fail("Normal profession equipment must apply the upstream aspect config and age bonus")
	if(!H.mind.has_spell(/datum/action/cooldown/spell/learnspell))
		Fail("Normal profession equipment must grant the aspect picker")

	var/mob/living/carbon/human/P = allocate(/mob/living/carbon/human/consistent)
	P.mind_initialize()
	P.age = AGE_OLD
	ADD_TRAIT(P, TRAIT_ARCYNE, TRAIT_GENERIC)
	var/datum/action/cooldown/spell/independent = new /datum/action/cooldown/spell/message
	P.mind.AddSpell(independent)
	P.z121_profession = new(P, C)
	C.equipme(P)
	var/datum/z121_profession_record/R = P.z121_profession
	var/datum/action/cooldown/spell/utility = new /datum/action/cooldown/spell/mindlink
	utility.utility_learned = TRUE
	P.mind.AddSpell(utility)
	var/datum/magic_aspect/aspect = new /datum/magic_aspect/pyromancy
	if(!P.mind.attune_aspect(aspect))
		Fail("Parallel profession must be able to attune an upstream aspect")
	R.suspend(P)
	if(LAZYLEN(P.mind.mage_aspect_config) || LAZYLEN(P.mind.major_aspects) || (utility in P.mind.spell_list))
		Fail("Suspending a profession must detach its aspect configuration and utility spells")
	if(!(independent in P.mind.spell_list))
		Fail("Suspending a profession must preserve independently granted spells")
	R.resume(P)
	if(P.mind.mage_aspect_config?["minor"] != 2 || !(aspect in P.mind.major_aspects) || !(utility in P.mind.spell_list))
		Fail("Rolling back a profession change must restore aspects, age bonuses and the same utility spell")
	R.suspend(P)
	P.z121_profession = null
	R.dispose_suspended(P)
	if(!(independent in P.mind.spell_list) || !QDELETED(aspect) || !QDELETED(utility))
		Fail("Disposing an old profession must delete only its suspended abilities")
#endif
