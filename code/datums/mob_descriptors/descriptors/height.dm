/datum/mob_descriptor/height
	abstract_type = /datum/mob_descriptor/height
	slot = MOB_DESCRIPTOR_SLOT_HEIGHT
	show_obscured = TRUE

/datum/mob_descriptor/height/moderate
	name = "中等"
	prefix = ""

/datum/mob_descriptor/height/middling
	name = "不上不下"
	prefix = ""

/datum/mob_descriptor/height/tall
	name = "高挑"
	prefix = ""

/datum/mob_descriptor/height/short
	name = "矮小"
	prefix = ""

/datum/mob_descriptor/height/towering
	name = "高耸"
	prefix = ""

/datum/mob_descriptor/height/giant
	name = "巨人般"
	prefix = ""

/datum/mob_descriptor/height/tiny
	name = "娇小"
	prefix = ""

/datum/mob_descriptor/height/giant
	name = "巨人般"
	prefix = ""

/datum/mob_descriptor/height/custom
	name = "自定义身高"
	custom_index = 7

/datum/mob_descriptor/height/custom/can_describe(mob/living/described)
	return length(described.custom_descriptors) >= custom_index

/datum/mob_descriptor/height/custom/get_description(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	return entry.content_text

/datum/mob_descriptor/height/custom/get_pre_string(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	switch(entry.prefix_type)
		if(CUSTOM_PREFIX_HAS_A)
			return "a "
		if(CUSTOM_PREFIX_HAS_AN)
			return "an "
	return null
