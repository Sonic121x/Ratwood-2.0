/mob/living/proc/add_mob_descriptor(descriptor_type)
	if(!mob_descriptors)
		mob_descriptors = list()
	if(descriptor_type in mob_descriptors)
		return
	mob_descriptors += descriptor_type

/mob/living/proc/remove_mob_descriptor(descriptor_type)
	if(!mob_descriptors)
		return
	mob_descriptors -= descriptor_type
	if(!length(mob_descriptors))
		mob_descriptors = null

/mob/living/proc/get_descriptor_type(desired_type)
	for(var/datum/mob_descriptor/descriptor as anything in mob_descriptors)
		if(ispath(descriptor, desired_type))
			return MOB_DESCRIPTOR(descriptor)

/mob/living/proc/clear_mob_descriptors()
	mob_descriptors = null

/mob/living/proc/get_mob_descriptors(is_obscured, mob/watcher)
	var/list/descriptors = list()
	if(mob_descriptors)
		descriptors += mob_descriptors
	var/list/extras = get_extra_mob_descriptors()
	if(extras)
		descriptors += extras
	var/list/passed_descriptors = list()
	for(var/desc_type in descriptors)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
		if(is_obscured && !descriptor.show_obscured)
			continue
		if(!descriptor.can_describe(src))
			continue
		if(!descriptor.can_user_see(src, watcher))
			continue
		passed_descriptors += desc_type
	return passed_descriptors

/mob/living/proc/get_mob_descriptors_unknown(is_obscured, mob/watcher)
	var/list/descriptors = list()
	if(mob_descriptors)
		descriptors += mob_descriptors
	var/list/extras = get_extra_mob_descriptors()
	if(extras)
		descriptors += extras
	var/list/passed_descriptors = list()
	for(var/desc_type in descriptors)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
		if(!descriptor.can_describe(src))
			continue
		if(!descriptor.can_user_see(src, watcher))
			continue
		passed_descriptors += desc_type
	return passed_descriptors

/mob/living/proc/get_extra_mob_descriptors()
	return list(
		/datum/mob_descriptor/age,
		/datum/mob_descriptor/penis,
		/datum/mob_descriptor/testicles,
		/datum/mob_descriptor/breasts,
		/datum/mob_descriptor/vagina,
		/datum/mob_descriptor/pits,
		)

/mob/living/proc/get_descriptor_of_slot(descriptor_slot, list/descs)
	for(var/descriptor_type in descs)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(descriptor_type)
		if(descriptor.slot != descriptor_slot)
			continue
		return descriptor_type
	return null

/mob/living/proc/get_descriptor_slot_list(list/slots, list/descriptors)
	var/list/descs = list()
	var/list/desc_copy = descriptors.Copy()
	for(var/slot in slots)
		var/desc_type = get_descriptor_of_slot(slot, desc_copy)
		if(!desc_type)
			continue
		desc_copy -= desc_type
		descs += desc_type
	if(descs.len != slots.len)
		return null
	return descs

/proc/build_cool_description(list/descriptors, mob/living/described, mob/watcher)
	var/list/lines = list()
	var/list/desc_copy = descriptors.Copy()

	var/first_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_HEIGHT, MOB_DESCRIPTOR_SLOT_BODY, MOB_DESCRIPTOR_SLOT_STATURE, MOB_DESCRIPTOR_SLOT_FACE_SHAPE, MOB_DESCRIPTOR_SLOT_FACE_EXPRESSION), "你看到一位%DESC3%，身形%DESC1%、体态%DESC2%，面部特征为%DESC4%，带着%DESC5%。", watcher)
	if(first_line)
		lines += first_line

	var/second_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_AGE, MOB_DESCRIPTOR_SLOT_SKIN, MOB_DESCRIPTOR_SLOT_VOICE), "%THEY%%DESC1%，%DESC2%，%DESC3%。", watcher)
	if(second_line)
		lines += second_line

	var/third_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY%%DESC1%，且%DESC2%。", watcher)
	if(third_line)
		lines += third_line

	var/fourth_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY%%DESC1%，且%DESC2%。", watcher)
	if(fourth_line)
		lines += fourth_line

	var/fifth = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PENIS, MOB_DESCRIPTOR_SLOT_TESTICLES), "%THEY%%DESC1%，还%DESC2%。", watcher)
	if(fifth)
		lines += fifth

	var/sixth = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_BREASTS, MOB_DESCRIPTOR_SLOT_VAGINA), "%THEY%%DESC1%，还%DESC2%。", watcher)
	if(sixth)
		lines += sixth

	var/pits_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PITS), "%THEY%%DESC1%。", watcher)
	if(pits_line)
		lines += pits_line

	/// Print the remaining ones in seperate lines
	for(var/descriptor_type in desc_copy)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(descriptor_type)
		lines += treat_mob_descriptor_string(descriptor.get_standalone_text(described, watcher), described)

	return lines

/proc/build_cool_description_unknown(list/descriptors, mob/living/described, mob/watcher)
	var/list/lines = list()
	var/list/desc_copy = descriptors.Copy()

	var/first_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_HEIGHT, MOB_DESCRIPTOR_SLOT_BODY, MOB_DESCRIPTOR_SLOT_STATURE), "你看到一位%DESC3%，身形%DESC1%、体态%DESC2%。", watcher)
	if(first_line)
		lines += first_line

	var/second_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_VOICE), "%THEY%%DESC1%。", watcher)
	if(second_line)
		lines += second_line

	var/third_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY%%DESC1%，且%DESC2%。", watcher)
	if(third_line)
		lines += third_line

	var/fourth_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY%%DESC1%，且%DESC2%。", watcher)
	if(fourth_line)
		lines += fourth_line

	var/fifth = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PENIS, MOB_DESCRIPTOR_SLOT_TESTICLES), "%THEY%%DESC1%，还%DESC2%。", watcher)
	if(fifth)
		lines += fifth

	var/sixth = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_BREASTS, MOB_DESCRIPTOR_SLOT_VAGINA), "%THEY%%DESC1%，还%DESC2%。", watcher)
	if(sixth)
		lines += sixth

	var/pits_line = build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PITS), "%THEY%%DESC1%。", watcher)
	if(pits_line)
		lines += pits_line

	for(var/descriptor_type in desc_copy)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(descriptor_type)
		if(descriptor.show_obscured)
			lines += treat_mob_descriptor_string(descriptor.get_standalone_text(described, watcher), described)

	return lines

/proc/build_coalesce_description(list/descriptors, mob/living/described, list/slots, string, mob/watcher)
	var/list/descs = described.get_descriptor_slot_list(slots, descriptors)
	if(!descs)
		return
	var/list/used_verbage = list()
	descriptors -= descs
	for(var/i in 1 to descs.len)
		var/desc_type = descs[i]
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
		string = replacetext(string, "%DESC[i]%", descriptor.get_coalesce_text(described, null, watcher))
		var/used_verb = descriptor.get_verbage(described)
		if(used_verb)
			used_verbage |= used_verb
	string = treat_mob_descriptor_string(string, described)
	return string

/proc/build_coalesce_description_nofluff(list/descriptors, mob/living/described, list/slots, string)
	var/list/descs = described.get_descriptor_slot_list(slots, descriptors)
	if(!descs)
		return
	var/list/used_verbage = list()
	descriptors -= descs
	for(var/i in 1 to descs.len)
		var/desc_type = descs[i]
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
		string = replacetext(string, "%DESC[i]%", descriptor.get_coalesce_text_nofluff(described))
		var/used_verb = descriptor.get_verbage(described)
		if(used_verb)
			used_verbage |= used_verb
	string = treat_mob_descriptor_string(string, described)
	return string

/proc/treat_mob_descriptor_string(string, mob/living/described)
	var/they_replace
	if(described.gender == MALE)
		they_replace = "他"
	else
		they_replace = "她"
	var/man_replace
	if(described.gender == MALE)
		man_replace = "男人"
	else
		man_replace = "女人"
	var/him_replace
	if(described.gender == MALE)
		him_replace = "他"
	else
		him_replace = "她"
	// LETHALSTONE EDIT: pronoun support
	if (described.pronouns)
		switch (described.pronouns)
			if (HE_HIM)
				they_replace = "他"
				man_replace = "男人"
				him_replace = "他"
			if (HE_HIM_F)
				they_replace = "他"
				man_replace = "男人"
				him_replace = "他"
			if (SHE_HER)
				they_replace = "她"
				man_replace = "女人"
				him_replace = "她"
			if (SHE_HER_M)
				they_replace = "她"
				man_replace = "女人"
				him_replace = "她"
			if (THEY_THEM)
				they_replace = "他们"
				man_replace = "人"
				him_replace = "他们"
			if (THEY_THEM_F)
				they_replace = "他们"
				man_replace = "人"
				him_replace = "他们"
			if (IT_ITS)
				they_replace = "它"
				man_replace = "生物"
				him_replace = "它"
	// LETHALSTONE EDIT END
	string = replacetext(string, "%THEY%", they_replace)
	if(they_replace == "他们")
		string = replacetext(string, "%HAVE%", "有着")
		string = replacetext(string, "%ARE%", "")
		string = replacetext(string, "%LOOK%", "看起来")
		string = replacetext(string, "%SPEAK%", "有着")
	else
		string = replacetext(string, "%HAVE%", "有着")
		string = replacetext(string, "%ARE%", "")
		string = replacetext(string, "%LOOK%", "看起来")
		string = replacetext(string, "%SPEAK%", "有着")
	string = replacetext(string, "%MAN%", man_replace)
	string = replacetext(string, "%HIM%", him_replace)
	string = capitalize(string)
	return string
