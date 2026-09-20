// 藏匿物品实际领取时，将已确认的职业记录移交给物品实例。
/handle_special_items_retrieval(mob/user, atom/host_object)

	var/mob/living/carbon/human/H = ishuman(user) ? user : null
	var/datum/z121_profession_record/R = H?.z121_profession
	var/datum/mind/original_mind = user.mind
	if(user.mind && isliving(user))
		var/area/rogue/user_area = get_area(user)
		if(user_area?.no_special_item_retrieval)
			return
		if(user.mind.special_items && user.mind.special_items.len)
			var/item = input(user, "What will I take?", "STASH") as null|anything in user.mind.special_items
			if(user.mind != original_mind || (H && H.z121_profession != R))
				return
			if(item)
				if(user.Adjacent(host_object))
					if(user.mind.special_items[item])
						var/path2item = user.mind.special_items[item]
						user.mind.special_items -= item
						var/obj/item/I = new path2item(user.loc)
						if(R && R.stash[item] == path2item)
							R.stash -= item
							for(var/obj/item/owned as anything in list(I) | z121_parallel_item_tree(I))
								R.items |= WEAKREF(owned)


						var/is_loadout_item = FALSE
						var/keep_stats = FALSE
						if(user.client?.prefs)
							var/list/loadout_slots = list(
								"loadout", "loadout2", "loadout3", "loadout4", "loadout5",
								"loadout6", "loadout7", "loadout8", "loadout9", "loadout10",
							)
							for(var/slot in loadout_slots)
								var/datum/loadout_item/loadout_datum = user.client.prefs.vars[slot]
								if(loadout_datum && loadout_datum.path == path2item)
									is_loadout_item = TRUE
									keep_stats = loadout_datum.keep_loadout_stats
									break


						if(is_loadout_item && !keep_stats)

							I.loadout_item = TRUE


							if(I.desc)
								I.desc += " The overall look and feel of the item suggests this may be a mere reproduction."
							else
								I.desc = "The overall look and feel of the item suggests this may be a mere reproduction."


							I.sellprice = 0


							I.smeltresult = /obj/item/ash



							if(istype(I, /obj/item/clothing))
								var/obj/item/clothing/C = I
								var/has_armor = FALSE


								if(C.armor && istype(C.armor, /datum/armor))
									if(C.armor.blunt > 0 || C.armor.slash > 0 || C.armor.stab > 0 || C.armor.piercing > 0 || C.armor.fire > 0 || C.armor.acid > 0)
										has_armor = TRUE


								if(has_armor)

									C.prevent_crits = null

									if(C.armor_class != ARMOR_CLASS_NONE)
										C.armor_class = ARMOR_CLASS_LIGHT

									var/list/_baseArmor = ARMOR_MIND_PROTECTION
									var/_percent = rand(-10, 10)
									var/_scale = 1 + (_percent / 100)
									var/_ab = round(_baseArmor["blunt"] * _scale)
									var/_asl = round(_baseArmor["slash"] * _scale)
									var/_ast = round(_baseArmor["stab"] * _scale)
									var/_ap = round(_baseArmor["piercing"] * _scale)
									var/_af = round(_baseArmor["fire"] * _scale)
									var/_aa = round(_baseArmor["acid"] * _scale)
									C.armor = getArmor(_ab, _asl, _ast, _ap, _af, _aa, 0)

									var/_base_int = ARMOR_INT_CHEST_LIGHT_BASE
									var/_variance = round(_base_int * 0.1)
									C.max_integrity = _base_int + rand(-_variance, _variance)
									C.obj_integrity = C.max_integrity


							if(I.force > 0)
								I.force = round(I.force * 0.7)

							I.obj_integrity = I.max_integrity


							if(I.wdefense > 0)
								I.wdefense = round(I.wdefense * 0.5)


						var/dye = user.client?.prefs.resolve_loadout_to_color(path2item)
						if (dye)
							I.add_atom_colour(dye, FIXED_COLOUR_PRIORITY)
							I.update_icon()


						var/custom_name = user.client?.prefs.resolve_loadout_to_name(path2item)
						if (custom_name)
							I.original_name = I.name
							I.name = sanitize(custom_name)

							log_game("[key_name(user)] retrieved loadout item with custom name: '[custom_name]' (original: '[I.original_name]')")

						var/custom_desc = user.client?.prefs.resolve_loadout_to_desc(path2item)
						if (custom_desc)
							I.desc = html_encode(custom_desc)

						user.put_in_hands(I)


						if(isliving(user))
							var/mob/living/L = user
							L.update_inv_hands()
							L.update_icons()
