/datum/mob_descriptor/age
	name = "年龄"
	slot = MOB_DESCRIPTOR_SLOT_AGE
	verbage = "%LOOK%"

/datum/mob_descriptor/age/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	return TRUE

/datum/mob_descriptor/age/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	if(H.age == AGE_OLD)
		return "年迈"
	else if (H.age == AGE_MIDDLEAGED)
		return "中年"
	else
		return "成年"

/datum/mob_descriptor/penis
	name = "阴茎"
	slot = MOB_DESCRIPTOR_SLOT_PENIS
	verbage = "有着"
	show_obscured = TRUE
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/penis/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/penis/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/penis/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	var/adjective
	var/arousal_modifier
	switch(penis.penis_size)
		if(1)
			adjective = "小巧的"
		if(2)
			adjective = "普通的"
		if(3)
			adjective = "硕大的"
	if(H.sexcon)
		switch(H.sexcon.arousal)
			if(80 to INFINITY)
				arousal_modifier = "，正在剧烈搏动"
			if(50 to 80)
				arousal_modifier = "，胀硬而渗液"
			if(20 to 50)
				arousal_modifier = "，绷紧并微微抽搐"
			else
				arousal_modifier = "，柔软而松弛"
	else
		arousal_modifier = "，柔软而松弛"
	var/used_name
	if(penis.erect_state != ERECT_STATE_HARD && penis.sheath_type != SHEATH_TYPE_NONE)
		switch(penis.sheath_type)
			if(SHEATH_TYPE_NORMAL)
				if(penis.penis_size == 3)
					used_name = "肥厚的鞘皮"
				else if(penis.penis_size == 1)
					used_name = "瘦小的鞘皮"
				else
					used_name = "鞘皮"
			if(SHEATH_TYPE_SLIT)
				used_name = "生殖裂缝"
	else
		used_name = "[adjective] [penis.name][arousal_modifier]"
	var/branded = ""
	var/brand_text = ""
	if(length(penis.branded_writing))
		brand_text = penis.branded_writing
		if(penis.enslavement_mark)
			brand_text = "[brand_text], 一个所有权的标记"
	else if(penis.enslavement_mark)
		brand_text = "一个所有权的标记"
	if(length(brand_text))
		branded = ",烙有<span style='font-size:150%;'>[span_boldwarning(brand_text)]</span>"
	var/base_description = "[used_name][branded]"
	var/obj/item/organ/testicles/testes = H.getorganslot(ORGAN_SLOT_TESTICLES)
	if(testes && penis.sheath_type != SHEATH_TYPE_SLIT)
		return base_description
	var/datum/mob_descriptor/pubes/pubes_descriptor = MOB_DESCRIPTOR(/datum/mob_descriptor/pubes)
	return pubes_descriptor.append_to_genital_description(base_description, H, watcher)

/datum/mob_descriptor/testicles
	name = "睾丸"
	slot = MOB_DESCRIPTOR_SLOT_TESTICLES
	verbage = "有着"
	show_obscured = TRUE
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/testicles/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/testicles/testes = H.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	if(penis && penis.sheath_type == SHEATH_TYPE_SLIT) //If our penis hides in a slit, dont describe testicles
		return FALSE
	if(!testes)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/testicles/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/testicles/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/testicles/testes = H.getorganslot(ORGAN_SLOT_TESTICLES)
	var/adjective
	switch(testes.ball_size)
		if(1)
			adjective = "一对小巧的"
		if(2)
			adjective = "一对普通的"
		if(3)
			adjective = "一对硕大的"
	var/branded = ""
	var/brand_text = ""
	if(length(testes.branded_writing))
		brand_text = testes.branded_writing
		if(testes.enslavement_mark)
			brand_text = "[brand_text],一个所有权的标记"
	else if(testes.enslavement_mark)
		brand_text = "一个所有权的标记"
	if(length(brand_text))
		branded = ",烙有<span style='font-size:125%;'>[span_boldwarning(brand_text)]</span>"
	var/base_description = "[adjective]睾丸[branded]"
	var/datum/mob_descriptor/pubes/pubes_descriptor = MOB_DESCRIPTOR(/datum/mob_descriptor/pubes)
	return pubes_descriptor.append_to_genital_description(base_description, H, watcher)

/datum/mob_descriptor/vagina
	name = "阴道"
	slot = MOB_DESCRIPTOR_SLOT_VAGINA
	verbage = "有着"
	show_obscured = TRUE
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/vagina/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	if(!vagina)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/vagina/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/vagina/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	var/vagina_type
	var/arousal_modifier
	switch(vagina.accessory_type)
		if(/datum/sprite_accessory/vagina/human)
			vagina_type = "普通阴道"
		if(/datum/sprite_accessory/vagina/hairy)
			vagina_type = "多毛阴道"
		if(/datum/sprite_accessory/vagina/trimmed)
			vagina_type = "修整过的阴道"
		if(/datum/sprite_accessory/vagina/spade)
			vagina_type = "铲形阴道"
		if(/datum/sprite_accessory/vagina/furred)
			vagina_type = "覆毛阴道"
		if(/datum/sprite_accessory/vagina/gaping)
			vagina_type = "张开的阴道"
		if(/datum/sprite_accessory/vagina/cloaca)
			vagina_type = "泄殖腔"
	switch(H.sexcon.arousal)
		if(80 to INFINITY)
			arousal_modifier = "，正因情动而汩汩泛湿"
		if(50 to 80)
			arousal_modifier = "，正因情动而变得滑润"
		if(20 to 50)
			arousal_modifier = "，正因情动而湿润"
	var/branded = ""
	var/brand_text = ""
	if(length(vagina.branded_writing))
		brand_text = vagina.branded_writing
		if(vagina.enslavement_mark)
			brand_text = "[brand_text],一个所有权的标记"
	else if(vagina.enslavement_mark)
		brand_text = "一个所有权的标记"
	if(length(brand_text))
		branded = ",烙有<span style='font-size:125%;'>[span_boldwarning(brand_text)]</span>"
	var/base_description = "a [vagina_type][arousal_modifier][branded]"
	if(H.getorganslot(ORGAN_SLOT_PENIS) || H.getorganslot(ORGAN_SLOT_TESTICLES))
		return base_description
	var/datum/mob_descriptor/pubes/pubes_descriptor = MOB_DESCRIPTOR(/datum/mob_descriptor/pubes)
	return pubes_descriptor.append_to_genital_description(base_description, H, watcher)

/datum/mob_descriptor/breasts
	name = "乳房"
	slot = MOB_DESCRIPTOR_SLOT_BREASTS
	verbage = "有着"
	show_obscured = TRUE
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/breasts/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!breasts)
		return FALSE
	if(H.underwear && H.underwear.covers_breasts)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_CHEST))
		return FALSE
	return TRUE

/datum/mob_descriptor/breasts/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	var/adjective
	switch(breasts.breast_size)
		if(0)
			adjective = "平坦的胸膛"
		if(1)
			adjective = "一对纤小的"
		if(2)
			adjective = "一对小巧的"
		if(3)
			adjective = "一对中等的"
		if(4)
			adjective = "一对丰满的"
		if(5)
			adjective = "一对丰硕的"
		if(6)
			adjective = "一对沉甸甸的"
		if(7)
			adjective = "一对巨大的"
		if(8)
			adjective = "一对夸张丰满的"
		if(9)
			adjective = "一对过于夸张的"
		if(10)
			adjective = "一对压弯脊背的"
		if(11)
			adjective = "一对遮住腹部的"
		if(12)
			adjective = "一对有躯干般大小的"
	var/branded = ""
	var/brand_text = ""
	if(length(breasts.branded_writing))
		brand_text = breasts.branded_writing
		if(breasts.enslavement_mark)
			brand_text = "[brand_text],一个所有权的标记"
	else if(breasts.enslavement_mark)
		brand_text = "一个所有权的标记"
	if(length(brand_text))
		branded = ",烙有<span style='font-size:125%;'>[span_boldwarning(brand_text)]</span>"
	if(breasts.breast_size == 0)
		return "[adjective][branded]"
	return "[adjective]乳房[branded]"

/datum/mob_descriptor/pubes
	name = "阴毛"
	slot = MOB_DESCRIPTOR_SLOT_PUBES
	verbage = "has"
	show_obscured = TRUE

/datum/mob_descriptor/pubes/proc/get_pubes_feature(mob/living/carbon/human/H)
	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return
	var/datum/bodypart_feature/pubes/feature = H.get_bodypart_feature_of_slot(BODYPART_FEATURE_PUBES)
	return feature

/datum/mob_descriptor/pubes/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/datum/bodypart_feature/pubes/feature = get_pubes_feature(H)
	if(!feature?.accessory_type)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return is_human_part_visible(H, HIDEJUMPSUIT|HIDECROTCH)

/datum/mob_descriptor/pubes/can_user_see(mob/living/described, mob/user)
	var/datum/preferences/viewer_preferences = user?.client?.prefs
	return !viewer_preferences || viewer_preferences.pubes

/datum/mob_descriptor/pubes/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/pubes/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/datum/bodypart_feature/pubes/feature = get_pubes_feature(H)
	if(!feature?.accessory_type)
		return
	var/material_description = feature.get_description_name()
	var/list/accessory_colors = color_string_to_list(feature.accessory_colors)
	var/description_color = LAZYACCESS(accessory_colors, 1)
	if(description_color && user_allows_descriptor_color(watcher))
		description_color = sanitize_hexcolor(description_color, 6, TRUE, "#FFFFFF")
		material_description = "<span style='color:[description_color]'>[material_description]</span>"
	var/adjective
	switch(feature.accessory_type)
		if(/datum/sprite_accessory/pubes/hairy)
			adjective = "一丛浓密的[material_description]"
		if(/datum/sprite_accessory/pubes/trim)
			adjective = "[material_description]修剪得整整齐齐，只有些许杂乱短茬"
		if(/datum/sprite_accessory/pubes/strip)
			adjective = "[material_description]剃得精光，只留下一道诱人的细条"
		if(/datum/sprite_accessory/pubes/heart)
			adjective = "一丛心形的[material_description]"
		if(/datum/sprite_accessory/pubes/extreme)
			adjective = "一片杂乱茂盛的[material_description]丛林"
		if(/datum/sprite_accessory/pubes/cross)
			adjective = "[material_description]剃成了普赛圣十字的形状"
		else//someone add more bush sprites but they forget to set the examine text? Just default to our descriptor name.
			adjective ="[material_description]"
	return "[adjective]"

/// The genital descriptor calling this proc already owns the visibility check.
/datum/mob_descriptor/pubes/proc/append_to_genital_description(base_description, mob/living/carbon/human/H, mob/watcher)
	if(!base_description)
		return base_description
	if(!can_user_see(H, watcher))
		return base_description
	var/pubes_description = get_description_for_watcher(H, watcher)
	if(!pubes_description)
		return base_description
	return "[base_description],周围衬着[pubes_description]"//we use pube_description and not just adjective so we can have the colors seperate

/datum/mob_descriptor/pits
	name = "腋毛"
	slot = MOB_DESCRIPTOR_SLOT_PITS
	verbage = "has"
	show_obscured = TRUE

/datum/mob_descriptor/pits/proc/get_pits_feature(mob/living/carbon/human/H)
	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return
	var/datum/bodypart_feature/pits/feature = H.get_bodypart_feature_of_slot(BODYPART_FEATURE_PITS)
	return feature

/datum/mob_descriptor/pits/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/datum/bodypart_feature/pits/feature = get_pits_feature(H)
	if(!feature?.accessory_type)
		return FALSE
	if(H.underwear && H.underwear.covers_breasts)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_CHEST))
		return FALSE
	return is_human_part_visible(H, HIDEBOOB|HIDEJUMPSUIT)

/datum/mob_descriptor/pits/can_user_see(mob/living/described, mob/user)
	var/datum/preferences/viewer_preferences = user?.client?.prefs
	return !viewer_preferences || viewer_preferences.pits

/datum/mob_descriptor/pits/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/pits/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/datum/bodypart_feature/pits/feature = get_pits_feature(H)
	if(!feature?.accessory_type)
		return
	var/material_description = feature.get_description_name()
	var/list/accessory_colors = color_string_to_list(feature.accessory_colors)
	var/description_color = LAZYACCESS(accessory_colors, 1)
	if(description_color && user_allows_descriptor_color(watcher))
		description_color = sanitize_hexcolor(description_color, 6, TRUE, "#FFFFFF")
		material_description = "<span style='color:[description_color]'>[material_description]</span>"
	var/adjective
	switch(feature.accessory_type)
		if(/datum/sprite_accessory/pits/trim)
			adjective = "一小撮修剪整齐、扎人的"
		if(/datum/sprite_accessory/pits/moderate)
			adjective = "几缕稀疏的"
		if(/datum/sprite_accessory/pits/hairy)
			adjective = "一丛茂密的"
		if(/datum/sprite_accessory/pits/extreme)
			adjective = "一片完全未经打理的丛林般的"
		else
			adjective = "一茬普通的"
	return "[adjective] [material_description]"
