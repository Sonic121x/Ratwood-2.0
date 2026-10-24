/datum/action/cooldown/spell/mirror_transform
	name = "镜变术"
	desc = "暂时赋予你借助镜子改变外貌的能力。"
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "mirror"
	sound = 'sound/magic/whiteflame.ogg'

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("镜中改形。")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = 3
	charge_sound = null
	cooldown_time = 300 SECONDS

	associated_skill = /datum/skill/magic/arcane
	point_cost = 1
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/mirror_transform/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = cast_on
	if(!istype(H))
		return FALSE

	ADD_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	H.visible_message(span_notice("[H] 的镜中倒影短暂地摇曳了一下。"), span_notice("我感觉自己与镜面建立起了一丝联系……"))

	addtimer(CALLBACK(src, PROC_REF(remove_mirror_magic), H), 5 MINUTES)
	return TRUE

/datum/action/cooldown/spell/mirror_transform/proc/remove_mirror_magic(mob/living/carbon/human/H)
	if(!QDELETED(H))
		REMOVE_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
		to_chat(H, span_warning("我与镜面的联系消散了。"))

/proc/perform_mirror_transform(mob/living/carbon/human/H)
	if (!H)
		return
	var/should_update = FALSE
	var/list/choices = list("饰物", "乳房数量", "乳房大小", "耳朵", "耳朵第一颜色", "耳朵第二颜色", "眼睛颜色", "肤色", "肤色 2", "肤色 3", "面部毛发样式", "面部毛发颜色", "面部细节", "发型", "头发主色", "头发次要渐变", "头发次要原色", "头发第三渐变", "头发第三染色", "角", "角的颜色", "阴茎", "阴茎大小", "尾巴", "尾巴第一颜色", "尾巴第二颜色", "尾巴第三颜色", "吻部", "吻部第一颜色", "吻部第二颜色", "吻部第三颜色", "绒毛", "绒毛第一颜色", "绒毛第二颜色", "睾丸", "睾丸大小", "阴道", "翅膀", "翅膀颜色")
	if(HAS_TRAIT(H, TRAIT_EDIT_DESCRIPTORS))
		choices += "外观描述"
	var/chosen = input(H, "要改变什么？", "外貌") as null|anything in choices

	if(!chosen)
		return

	switch(chosen)
		if("发型")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_hairstyles = list()
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				valid_hairstyles[hair.name] = hair_type

			var/new_style = input(H, "选择发型", "发型调整") as null|anything in valid_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color

						if(istype(current_hair, /datum/bodypart_feature/hair/head))
							hair_entry.natural_gradient = current_hair.natural_gradient
							hair_entry.natural_color = current_hair.natural_color
							if(hasvar(current_hair, "hair_dye_gradient"))
								hair_entry.dye_gradient = current_hair.hair_dye_gradient
							if(hasvar(current_hair, "hair_dye_color"))
								hair_entry.dye_color = current_hair.hair_dye_color

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)

						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						H.update_hair()
						should_update = TRUE

		if("头发主色")
			var/new_hair_color = color_pick_sanitized(H, "选择头发颜色", "头发主色", H.hair_color)
			if(new_hair_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()
					hair_entry.hair_color = sanitize_hexcolor(new_hair_color, 6, TRUE)

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/bodypart_feature/hair/head/new_hair = new()

						new_hair.set_accessory_type(current_hair.accessory_type, null, H)

						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						H.hair_color = hair_entry.hair_color
						H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)

						H.dna.species.handle_body(H)
						H.update_body()
						H.update_hair()
						H.update_body_parts()
						should_update = TRUE

		if("面部毛发颜色")
			var/new_facial_hair_color = color_pick_sanitized(H, "选择面部毛发颜色", "面部毛发颜色", H.facial_hair_color)
			if(new_facial_hair_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)

					var/datum/customizer_entry/hair/facial/facial_entry = new()

					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						facial_entry.hair_color = sanitize_hexcolor(new_facial_hair_color, 6, TRUE)
						facial_entry.accessory_type = current_facial.accessory_type

						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(current_facial.accessory_type, null, H)
						facial_choice.customize_feature(new_facial, H, null, facial_entry)

						H.facial_hair_color = facial_entry.hair_color
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						should_update = TRUE

		if("眼睛颜色")
			var/new_eye_color = color_pick_sanitized(H, "选择眼睛颜色", "眼睛颜色", H.eye_color)
			if(new_eye_color)
				new_eye_color = sanitize_hexcolor(new_eye_color, 6, TRUE)
				var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.Remove(H)
					eyes.eye_color = new_eye_color
					eyes.Insert(H, TRUE, FALSE)
				H.eye_color = new_eye_color
				H.dna.features["eye_color"] = new_eye_color
				H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				H.update_body_parts()
				should_update = TRUE

		if("肤色")
			var/old_skintone = H.dna.species.use_skintones ? H.skin_tone : H.dna.features["mcolor"]
			var/new_skin_color = color_pick_sanitized(H, "选择你的肤色", "肤色", old_skintone)
			if(new_skin_color)
				if(H.dna.species.use_skintones)
					H.skin_tone = sanitize_hexcolor(new_skin_color, 6, FALSE)
				else
					H.dna.features["mcolor"] = sanitize_hexcolor(new_skin_color, 6, TRUE)
				H.update_body_parts()
				should_update = TRUE

		if("肤色 2")
			var/new_skin_color = color_pick_sanitized(H, "选择你的肤色", "肤色", H.dna.features["mcolor2"])
			if(new_skin_color)
				H.dna.features["mcolor2"] = sanitize_hexcolor(new_skin_color, 6, TRUE)
			H.update_body_parts()
			should_update = TRUE

		if("肤色 3")
			var/new_skin_color = color_pick_sanitized(H, "选择你的肤色", "肤色", H.dna.features["mcolor3"])
			if(new_skin_color)
				H.dna.features["mcolor3"] = sanitize_hexcolor(new_skin_color, 6, TRUE)
			H.update_body_parts()
			should_update = TRUE

		if("头发次要渐变")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type

			var/new_style = input(H, "选择自然渐变", "头发次要自然渐变") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = valid_gradients[new_style]
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("头发次要原色")
			var/new_gradient_color = color_pick_sanitized(H, "选择你的自然渐变色", "头发次要自然渐变色", H.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("头发第三渐变")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type

			var/new_style = input(H, "选择染色渐变", "头发第三染色渐变") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = valid_gradients[new_style]
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("头发第三染色")
			var/new_gradient_color = color_pick_sanitized(H, "选择头发第三渐变色", "头发第三渐变色", H.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("面部毛发样式")
			var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
			var/list/valid_facial_hairstyles = list()
			for(var/facial_type in facial_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/facial/facial = new facial_type()
				valid_facial_hairstyles[facial.name] = facial_type

			var/new_style = input(H, "选择面部毛发样式", "毛发调整") as null|anything in valid_facial_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						var/datum/customizer_entry/hair/facial/facial_entry = new()
						facial_entry.hair_color = current_facial.hair_color

						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)

						facial_choice.customize_feature(new_facial, H, null, facial_entry)

						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						H.update_hair()
						should_update = TRUE

		if("饰物")
			var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
			var/list/valid_accessories = list("无")
			for(var/accessory_type in accessory_choice.sprite_accessories)
				var/datum/sprite_accessory/accessory/acc = new accessory_type()
				valid_accessories[acc.name] = accessory_type

			var/new_style = input(H, "选择饰品", "饰品调整") as null|anything in valid_accessories
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
						head.remove_bodypart_feature(old_acc)
						break

					if(new_style != "无")
						var/datum/bodypart_feature/accessory/accessory_feature = new()
						accessory_feature.set_accessory_type(valid_accessories[new_style], H.hair_color, H)
						head.add_bodypart_feature(accessory_feature)
					should_update = TRUE

		if("面部细节")
			var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
			var/list/valid_details = list("无")
			for(var/detail_type in face_choice.sprite_accessories)
				var/datum/sprite_accessory/face_detail/detail = new detail_type()
				valid_details[detail.name] = detail_type

			var/new_detail = input(H, "选择面部细节", "面部细节") as null|anything in valid_details
			if(new_detail)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					for(var/datum/bodypart_feature/face_detail/old_detail in head.bodypart_features)
						head.remove_bodypart_feature(old_detail)
						break

					if(new_detail != "无")
						var/datum/bodypart_feature/face_detail/detail_feature = new()
						detail_feature.set_accessory_type(valid_details[new_detail], H.hair_color, H)
						head.add_bodypart_feature(detail_feature)
					should_update = TRUE

		if("阴茎")
			var/list/valid_penis_types = list("无")
			for(var/penis_path in subtypesof(/datum/sprite_accessory/penis))
				var/datum/sprite_accessory/penis/penis = new penis_path()
				valid_penis_types[penis.name] = penis_path

			var/new_style = input(H, "选择阴茎样式", "阴茎调整") as null|anything in valid_penis_types
			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
					if(penis)
						penis.Remove(H)
						qdel(penis)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
					if(!penis)
						penis = new()
						penis.Insert(H, TRUE, FALSE)
					penis.accessory_type = valid_penis_types[new_style]
					var/datum/sprite_accessory/penis/penis_type = SPRITE_ACCESSORY(penis.accessory_type)
					penis.accessory_colors = penis_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("睾丸")
			var/list/valid_testicle_types = list("无")
			for(var/testicle_path in subtypesof(/datum/sprite_accessory/testicles))
				var/datum/sprite_accessory/testicles/testicles = new testicle_path()
				valid_testicle_types[testicles.name] = testicle_path

			var/new_style = input(H, "选择睾丸样式", "睾丸调整") as null|anything in valid_testicle_types
			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
					if(testicles)
						testicles.Remove(H)
						qdel(testicles)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
					if(!testicles)
						testicles = new()
						testicles.Insert(H, TRUE, FALSE)
					testicles.accessory_type = valid_testicle_types[new_style]
					var/datum/sprite_accessory/testicles/testicles_type = SPRITE_ACCESSORY(testicles.accessory_type)
					testicles_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("乳房数量")
			var/list/valid_breast_types = list("无")
			for(var/breast_path in subtypesof(/datum/sprite_accessory/breasts))
				var/datum/sprite_accessory/breasts/breasts = new breast_path()
				valid_breast_types[breasts.name] = breast_path

			var/new_style = input(H, "选择胸部样式", "胸部调整") as null|anything in valid_breast_types

			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
					if(breasts)
						breasts.Remove(H)
						qdel(breasts)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
					if(!breasts)
						breasts = new()
						breasts.Insert(H, TRUE, FALSE)

					breasts.accessory_type = valid_breast_types[new_style]
					var/datum/sprite_accessory/breasts/breasts_type = SPRITE_ACCESSORY(breasts.accessory_type)
					breasts.accessory_colors = breasts_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("阴道")
			var/list/valid_vagina_types = list("none", "human", "hairy", "spade", "furred", "gaping", "cloaca")
			var/new_style = input(H, "选择阴道样式", "阴道调整") as null|anything in valid_vagina_types

			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
					if(vagina)
						vagina.Remove(H)
						qdel(vagina)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
					if(!vagina)
						vagina = new()
						vagina.Insert(H, TRUE, FALSE)
					vagina.accessory_type = valid_vagina_types[new_style]

					var/new_color = color_pick_sanitized(H, "选择你的阴部颜色", "Vagina Color", vagina.color || H.dna.features["mcolor"])
					if(new_color)
						vagina.color = sanitize_hexcolor(new_color, 6, TRUE)
					else
						var/datum/sprite_accessory/vagina/vag_type = SPRITE_ACCESSORY(vagina.accessory_type)
						vagina.color = vag_type.get_default_colors(color_key_source_list_from_carbon(H))

					H.update_body()
					should_update = TRUE

		if("乳房大小")
			var/list/breast_sizes = list("平坦", "轻微", "小巧", "适中", "丰满", "丰盈", "沉重", "巨大", "堆涌", "夸张")
			var/new_size = input(H, "选择胸部大小", "胸部大小") as null|anything in breast_sizes
			if(new_size)
				var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
				if(breasts)
					var/size_num
					switch(new_size)
						if("平坦")
							size_num = 0
						if("轻微")
							size_num = 1
						if("小巧")
							size_num = 2
						if("适中")
							size_num = 3
						if("丰满")
							size_num = 4
						if("丰盈")
							size_num = 5
						if("沉重")
							size_num = 6
						if("巨大")
							size_num = 7
						if("堆涌")
							size_num = 8
						if("夸张")
							size_num = 9

					breasts.breast_size = size_num
					H.update_body()
					should_update = TRUE

		if("阴茎大小")
			var/list/penis_sizes = list("small", "average", "large")
			var/new_size = input(H, "选择阴茎大小", "阴茎大小") as null|anything in penis_sizes
			if(new_size)
				var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
				if(penis)
					var/size_num
					switch(new_size)
						if("小")
							size_num = 1
						if("中")
							size_num = 2
						if("大")
							size_num = 3

					penis.penis_size = size_num
					H.update_body()
					should_update = TRUE

		if("睾丸大小")
			var/list/testicle_sizes = list("小", "中", "大")
			var/new_size = input(H, "选择睾丸大小", "睾丸大小") as null|anything in testicle_sizes
			if(new_size)
				var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
				if(testicles)
					var/size_num
					switch(new_size)
						if("小")
							size_num = 1
						if("中")
							size_num = 2
						if("大")
							size_num = 3

					testicles.ball_size = size_num
					H.update_body()
					should_update = TRUE

		if("尾巴")
			var/list/valid_tails = list("无")
			for(var/tail_path in subtypesof(/datum/sprite_accessory/tail))
				var/datum/sprite_accessory/tail/tail = new tail_path()
				valid_tails[tail.name] = tail_path

			var/new_style = input(H, "选择尾巴", "尾巴调整") as null|anything in valid_tails
			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(tail)
						tail.Remove(H)
						qdel(tail)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(!tail)
						tail = new /obj/item/organ/tail/anthro()
						tail.Insert(H, TRUE, FALSE)
					tail.accessory_type = valid_tails[new_style]
					var/datum/sprite_accessory/tail/tail_type = SPRITE_ACCESSORY(tail.accessory_type)
					tail.accessory_colors = tail_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("尾巴第一颜色")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/new_color = color_pick_sanitized(H, "选择你的尾巴主色", "尾巴第一颜色", "#FFFFFF")
				if(new_color)
					tail.Remove(H)
					var/list/colors = list()
					if(tail.accessory_colors)
						colors = color_string_to_list(tail.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有尾巴！"))

		if("尾巴第二颜色")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/new_color = color_pick_sanitized(H, "选择你的尾巴副色", "尾巴第二颜色", "#FFFFFF")
				if(new_color)
					tail.Remove(H)
					var/list/colors = list()
					if(tail.accessory_colors)
						colors = color_string_to_list(tail.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
					colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color2"] = colors[2]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有尾巴！"))

		if("尾巴第三颜色")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/new_color = color_pick_sanitized(H, "选择尾巴第三颜色", "尾巴第三颜色", "#FFFFFF")
				if(new_color)
					tail.Remove(H)
					var/list/colors = list()
					if(tail.accessory_colors)
						colors = color_string_to_list(tail.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
					colors[3] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color2"] = colors[3]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有尾巴！"))

		if("吻部")
			var/list/valid_snouts = list("无")
			for(var/snout_path in subtypesof(/datum/sprite_accessory/snout))
				var/datum/sprite_accessory/snout/snout = new snout_path()
				valid_snouts[snout.name] = snout_path

			var/new_style = input(H, "选择吻部", "吻部调整") as null|anything in valid_snouts
			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/snout/snout = H.getorganslot(ORGAN_SLOT_SNOUT)
					if(snout)
						snout.Remove(H)
						qdel(snout)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/snout/snout = H.getorganslot(ORGAN_SLOT_SNOUT)
					if(!snout)
						snout = new /obj/item/organ/snout/anthro()
						snout.Insert(H, TRUE, FALSE)
					snout.accessory_type = valid_snouts[new_style]
					var/datum/sprite_accessory/snout/snout_type = SPRITE_ACCESSORY(snout.accessory_type)
					snout.accessory_colors = snout_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("吻部第一颜色")
			var/obj/item/organ/snout/snout = H.getorganslot(ORGAN_SLOT_SNOUT)
			if(snout)
				var/new_color = color_pick_sanitized(H, "选择吻部第一颜色", "吻部第一颜色", "#FFFFFF")
				if(new_color)
					snout.Remove(H)
					var/list/colors = list()
					if(snout.accessory_colors)
						colors = color_string_to_list(snout.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					snout.accessory_colors = color_list_to_string(colors)
					snout.Insert(H, TRUE, FALSE)
					H.dna.features["snout_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有吻部！"))

		if("吻部第二颜色")
			var/obj/item/organ/snout/snout = H.getorganslot(ORGAN_SLOT_SNOUT)
			if(snout)
				var/new_color = color_pick_sanitized(H, "选择吻部第二颜色", "吻部第二颜色", "#FFFFFF")
				if(new_color)
					snout.Remove(H)
					var/list/colors = list()
					if(snout.accessory_colors)
						colors = color_string_to_list(snout.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
					colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					snout.accessory_colors = color_list_to_string(colors)
					snout.Insert(H, TRUE, FALSE)
					H.dna.features["snout_color2"] = colors[2]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有吻部！"))

		if("吻部第三颜色")
			var/obj/item/organ/snout/snout = H.getorganslot(ORGAN_SLOT_SNOUT)
			if(snout)
				var/new_color = color_pick_sanitized(H, "选择吻部第三颜色", "吻部第三颜色", "#FFFFFF")
				if(new_color)
					snout.Remove(H)
					var/list/colors = list()
					if(snout.accessory_colors)
						colors = color_string_to_list(snout.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
					colors[3] = sanitize_hexcolor(new_color, 6, TRUE)
					snout.accessory_colors = color_list_to_string(colors)
					snout.Insert(H, TRUE, FALSE)
					H.dna.features["snout_color2"] = colors[3]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有吻部！"))

		if("绒毛")
			var/list/valid_neck_features = list("无")
			for(var/neck_feature_path in subtypesof(/datum/sprite_accessory/neck_feature))
				var/datum/sprite_accessory/neck_feature/neck_feature = new neck_feature_path()
				valid_neck_features[neck_feature.name] = neck_feature_path

			var/new_style = input(H, "选择绒毛样式", "绒毛自定义") as null|anything in valid_neck_features
			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/neck_feature/neck_feature = H.getorganslot(ORGAN_SLOT_NECK_FEATURE)
					if(neck_feature)
						neck_feature.Remove(H)
						qdel(neck_feature)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/neck_feature/neck_feature = H.getorganslot(ORGAN_SLOT_NECK_FEATURE)
					if(!neck_feature)
						neck_feature = new /obj/item/organ/neck_feature/anthro_fluff()
						neck_feature.Insert(H, TRUE, FALSE)
					neck_feature.accessory_type = valid_neck_features[new_style]
					var/datum/sprite_accessory/neck_feature/neck_feature_type = SPRITE_ACCESSORY(neck_feature.accessory_type)
					neck_feature.accessory_colors = neck_feature_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("绒毛第一颜色")
			var/obj/item/organ/neck_feature/neck_feature = H.getorganslot(ORGAN_SLOT_NECK_FEATURE)
			if(neck_feature)
				var/new_color = color_pick_sanitized(H, "选择颈部特征第一颜色", "颈部特征第一颜色", "#FFFFFF")
				if(new_color)
					neck_feature.Remove(H)
					var/list/colors = list()
					if(neck_feature.accessory_colors)
						colors = color_string_to_list(neck_feature.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					neck_feature.accessory_colors = color_list_to_string(colors)
					neck_feature.Insert(H, TRUE, FALSE)
					H.dna.features["neck_feature_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("你没有绒毛！"))

		if("绒毛第二颜色")
			var/obj/item/organ/neck_feature/neck_feature = H.getorganslot(ORGAN_SLOT_NECK_FEATURE)
			if(neck_feature)
				var/new_color = color_pick_sanitized(H, "选择颈部特征第二颜色", "颈部特征第二颜色", "#FFFFFF")
				if(new_color)
					neck_feature.Remove(H)
					var/list/colors = list()
					if(neck_feature.accessory_colors)
						colors = color_string_to_list(neck_feature.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					neck_feature.accessory_colors = color_list_to_string(colors)
					neck_feature.Insert(H, TRUE, FALSE)
					H.dna.features["neck_feature_color2"] = colors[2]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("你没有绒毛！"))

		if("耳朵")
			var/list/valid_ears = list("无")
			for(var/ears_path in subtypesof(/datum/sprite_accessory/ears))
				var/datum/sprite_accessory/ears/ears = new ears_path()
				valid_ears[ears.name] = ears_path

			var/new_style = input(H, "选择耳朵", "耳朵调整") as null|anything in valid_ears
			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
					if(ears)
						ears.Remove(H)
						qdel(ears)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
					if(!ears)
						ears = new /obj/item/organ/ears()
						ears.Insert(H, TRUE, FALSE)
					ears.accessory_type = valid_ears[new_style]
					var/datum/sprite_accessory/ears/ears_type = SPRITE_ACCESSORY(ears.accessory_type)
					ears.accessory_colors = ears_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("耳朵第一颜色")
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/new_color = color_pick_sanitized(H, "选择你的耳朵主色", "耳朵第一颜色", "#FFFFFF")
				if(new_color)
					ears.Remove(H)
					var/list/colors = list()
					if(ears.accessory_colors)
						colors = color_string_to_list(ears.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(colors)
					ears.Insert(H, TRUE, FALSE)
					H.dna.features["ears_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有耳朵！"))

		if("耳朵第二颜色")
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/new_color = color_pick_sanitized(H, "选择你的耳朵副色", "耳朵第二颜色", "#FFFFFF")
				if(new_color)
					ears.Remove(H)
					var/list/colors = list()
					if(ears.accessory_colors)
						colors = color_string_to_list(ears.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(colors)
					ears.Insert(H, TRUE, FALSE)
					H.dna.features["ears_color2"] = colors[2]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("你没有耳朵！"))

		if("角")
			var/list/valid_horns = list("无")
			for(var/horns_path in subtypesof(/datum/sprite_accessory/horns))
				var/datum/sprite_accessory/horns/horns = new horns_path()
				valid_horns[horns.name] = horns_path

			var/new_style = input(H, "选择角", "角调整") as null|anything in valid_horns
			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
					if(horns)
						horns.Remove(H)
						qdel(horns)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
					if(!horns)
						horns = new /obj/item/organ/horns()
						horns.Insert(H, TRUE, FALSE)
					horns.accessory_type = valid_horns[new_style]
					var/datum/sprite_accessory/horns/horns_type = SPRITE_ACCESSORY(horns.accessory_type)
					horns.accessory_colors = horns_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("角的颜色")
			var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
			if(horns)
				var/new_color = color_pick_sanitized(H, "选择你的耳朵主色", "耳朵第一颜色", "#FFFFFF")
				if(new_color)
					horns.Remove(H)
					var/list/colors = list()
					if(horns.accessory_colors)
						colors = color_string_to_list(horns.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					horns.accessory_colors = color_list_to_string(colors)
					horns.Insert(H, TRUE, FALSE)
					H.dna.features["horns_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有角！"))

		if("翅膀")
			var/list/valid_wings = list("无")
			for(var/wings_path in subtypesof(/datum/sprite_accessory/wings))
				var/datum/sprite_accessory/wings/wings = new wings_path()
				valid_wings[wings.name] = wings_path

			var/new_style = input(H, "选择翅膀", "翅膀调整") as null|anything in valid_wings
			if(new_style)
				if(new_style == "无")
					var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
					if(wings)
						wings.Remove(H)
						qdel(wings)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
					if(!wings)
						wings = new /obj/item/organ/wings()
						wings.Insert(H, TRUE, FALSE)
					wings.accessory_type = valid_wings[new_style]
					var/datum/sprite_accessory/wings/wings_type = SPRITE_ACCESSORY(wings.accessory_type)
					wings.accessory_colors = wings_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("翅膀颜色")
			var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
			if(wings)
				var/new_color = color_pick_sanitized(H, "选择你的翅膀主色", "Wing Color One", "#FFFFFF")
				if(new_color)
					wings.Remove(H)
					var/list/colors = list()
					if(wings.accessory_colors)
						colors = color_string_to_list(wings.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					wings.accessory_colors = color_list_to_string(colors)
					wings.Insert(H, TRUE, FALSE)
					H.dna.features["wings_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("我没有翅膀！"))

		if("外观描述")
			var/list/species_choices = H.dna.species.descriptor_choices
			if(!length(species_choices))
				to_chat(H, span_warning("你的种族没有可修改的标准描述。"))
				return
			var/list/choice_map = list()
			for(var/path in species_choices)
				var/datum/descriptor_choice/C = DESCRIPTOR_CHOICE(path)
				choice_map[C.name] = path
			var/choice_name = input(H, "你想描述哪项特征？", "标准描述") as null|anything in choice_map
			if(!choice_name)
				return
			var/choice_type = choice_map[choice_name]
			var/datum/descriptor_choice/chosen_datum = DESCRIPTOR_CHOICE(choice_type)
			var/list/picklist = list()
			for(var/desc_type in chosen_datum.descriptors)
				var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
				if(descriptor)
					picklist[descriptor.name] = desc_type
			var/picked_name = input(H, "为[choice_name]选择新描述：", "描述自己") as null|anything in picklist
			if(picked_name)
				for(var/old_path in picklist)
					H.remove_mob_descriptor(picklist[old_path])
				H.add_mob_descriptor(picklist[picked_name])
				should_update = TRUE

	if(should_update)
		H.update_hair()
		H.update_body()
		H.update_body_parts()
