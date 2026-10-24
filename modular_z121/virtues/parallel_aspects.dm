// Track aspect grants separately from legacy spell-point purchases.
/datum/z121_profession_record
	var/owns_aspect_config = FALSE
	var/setting_up_aspects = FALSE
	var/list/previous_aspect_config
	var/list/previous_major_aspects
	var/list/previous_minor_aspects
	var/previous_aspect_resets = 0
	var/list/saved_aspect_config
	var/list/saved_major_aspects
	var/list/saved_minor_aspects
	var/saved_aspect_resets = 0

/mob/living/carbon/human/proc/z121_birth_aspects(list/config)
	if(!mind)
		return
	if(z121_profession)
		z121_profession.setup_aspects(src, config)
	else
		mind.setup_mage_aspects(config)

/datum/z121_profession_record/proc/setup_aspects(mob/living/carbon/human/H, list/config)
	if(!owns_aspect_config)
		previous_aspect_config = H.mind.mage_aspect_config?.Copy()
		previous_major_aspects = H.mind.major_aspects?.Copy()
		previous_minor_aspects = H.mind.minor_aspects?.Copy()
		previous_aspect_resets = H.mind.aspect_resets_used
		owns_aspect_config = TRUE
	var/list/before = H.mind.spell_list.Copy()
	setting_up_aspects = TRUE
	H.mind.setup_mage_aspects(config, FALSE)
	setting_up_aspects = FALSE
	add_trait(H, TRAIT_LEYLINE_ATTUNEMENT)
	for(var/datum/S as anything in H.mind.spell_list - before)
		remember_spell(S)

// Outfits that grant aspects directly must use the same birth ownership record.
/datum/mind/setup_mage_aspects(list/config, grant_attunement = TRUE)
	var/mob/living/carbon/human/H = current
	if(istype(H) && H.z121_profession?.capturing_birth && !H.z121_profession.setting_up_aspects)
		return H.z121_profession.setup_aspects(H, config)
	return ..()

/datum/mind/AddSpell(datum/spell_or_action, mob/living/user)
	var/was_present = (spell_or_action in spell_list)
	. = ..()
	if(was_present || QDELETED(spell_or_action) || !(spell_or_action in spell_list))
		return
	var/mob/living/carbon/human/H = current
	if(!istype(H))
		return
	var/datum/z121_profession_record/R = H.z121_profession
	if(!R?.owns_aspect_config || R.suspended)
		return
	var/list/post_spells = mage_aspect_config?["post_aspect_spells"]
	if(spell_or_action.type in post_spells)
		R.remember_spell(spell_or_action)
	if(istype(spell_or_action, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_or_action
		if(S.source_aspect || S.utility_learned || istype(S, /datum/action/cooldown/spell/learnspell) || istype(S, /datum/action/cooldown/spell/conjure_arcyne_ward) || istype(S, /datum/action/cooldown/spell/touch/prestidigitation))
			R.remember_spell(S)

/datum/z121_profession_record/proc/suspend_aspects(mob/living/carbon/human/H)
	if(!owns_aspect_config)
		return
	saved_aspect_config = H.mind.mage_aspect_config
	saved_major_aspects = H.mind.major_aspects
	saved_minor_aspects = H.mind.minor_aspects
	saved_aspect_resets = H.mind.aspect_resets_used
	H.mind.mage_aspect_config = previous_aspect_config
	H.mind.major_aspects = previous_major_aspects
	H.mind.minor_aspects = previous_minor_aspects
	H.mind.aspect_resets_used = previous_aspect_resets

/datum/z121_profession_record/proc/resume_aspects(mob/living/carbon/human/H)
	if(!owns_aspect_config)
		return
	H.mind.mage_aspect_config = saved_aspect_config
	H.mind.major_aspects = saved_major_aspects
	H.mind.minor_aspects = saved_minor_aspects
	H.mind.aspect_resets_used = saved_aspect_resets

/datum/z121_profession_record/proc/dispose_aspects()
	for(var/datum/magic_aspect/A in saved_major_aspects)
		if(!(A in previous_major_aspects))
			qdel(A)
	for(var/datum/magic_aspect/A in saved_minor_aspects)
		if(!(A in previous_minor_aspects))
			qdel(A)

/mob/living/carbon/human/proc/z121_birth_age_mod(datum/class_age_mod/modifier, datum/z121_profession_record/record = z121_profession)
	if(!record)
		return modifier.apply_age_mod(src)
	if(age != modifier.target_age)
		return
	for(var/stat in modifier.stat_mods)
		record.add_stat(src, stat, modifier.stat_mods[stat])
	for(var/skill in modifier.skill_mods)
		record.add_skill(src, skill, modifier.skill_mods[skill], TRUE)
	for(var/trait in modifier.traits_added)
		record.add_trait(src, trait)
	if(LAZYLEN(mind?.mage_aspect_config))
		mind.mage_aspect_config["minor"] += modifier.minor_mod
		mind.mage_aspect_config["utilities"] += modifier.utility_mod
		if(modifier.minor_mod || modifier.utility_mod)
			mind.check_learnspell()
