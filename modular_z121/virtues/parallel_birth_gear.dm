// 服装发放边界：职业物品登记先于所有后置出生奖励。
/datum/outfit/job/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/datum/z121_profession_record/R = (!visualsOnly && H.z121_profession?.capturing_birth) ? H.z121_profession : null
	var/list/before_verbs = R ? H.verbs.Copy() : null
	pre_equip(H, visualsOnly)
	if(R)
		H.z121_birth_finish_systems(R, before_verbs)
	var/list/before_items = R ? z121_parallel_item_tree(H) : null


	handle_silver_weakness(H)


	if(uniform)
		H.equip_to_slot_or_del(new pants(H),SLOT_PANTS, TRUE)
	if(suit)
		H.equip_to_slot_or_del(new suit(H),SLOT_ARMOR, TRUE)
	if(back)
		H.equip_to_slot_or_del(new back(H),SLOT_BACK, TRUE)
	if(belt)
		H.equip_to_slot_or_del(new belt(H),SLOT_BELT, TRUE)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),SLOT_GLOVES, TRUE)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),SLOT_SHOES, TRUE)
	if(head)
		H.equip_to_slot_or_del(new head(H),SLOT_HEAD, TRUE)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),SLOT_WEAR_MASK, TRUE)
	if(neck)
		H.equip_to_slot_or_del(new neck(H),SLOT_NECK, TRUE)
	if(ears)
		H.equip_to_slot_or_del(new ears(H),SLOT_WEAR_MASK, TRUE)
	if(glasses)
		H.equip_to_slot_or_del(new glasses(H),SLOT_GLASSES, TRUE)
	if(id)
		H.equip_to_slot_or_del(new id(H),SLOT_RING, TRUE)
	if(wrists)
		H.equip_to_slot_or_del(new wrists(H),SLOT_WRISTS, TRUE)
	if(suit_store)
		H.equip_to_slot_or_del(new suit_store(H),SLOT_S_STORE, TRUE)
	if(cloak)
		H.equip_to_slot_or_del(new cloak(H),SLOT_CLOAK, TRUE)
	if(beltl)
		H.equip_to_slot_or_del(new beltl(H),SLOT_BELT_L, TRUE)
	if(beltr)
		H.equip_to_slot_or_del(new beltr(H),SLOT_BELT_R, TRUE)
	if(backr)
		H.equip_to_slot_or_del(new backr(H),SLOT_BACK_R, TRUE)
	if(backl)
		H.equip_to_slot_or_del(new backl(H),SLOT_BACK_L, TRUE)
	if(mouth)
		H.equip_to_slot_or_del(new mouth(H),SLOT_MOUTH, TRUE)
	if(pants)
		H.equip_to_slot_or_del(new pants(H),SLOT_PANTS, TRUE)
	if(armor)
		H.equip_to_slot_or_del(new armor(H),SLOT_ARMOR, TRUE)
	if(shirt)
		H.equip_to_slot_or_del(new shirt(H),SLOT_SHIRT, TRUE)
	if(accessory)
		var/obj/item/clothing/under/U = H.wear_pants
		if(U)
			U.attach_accessory(new accessory(H))
		else
			WARNING("Unable to equip accessory [accessory] in outfit [name]. No uniform present!")

	if(!visualsOnly)
		if(l_hand)
			H.put_in_hands(new l_hand(get_turf(H)), FALSE, forced = TRUE)
		if(r_hand)
			testing("PIH")
			H.put_in_hands(new r_hand(get_turf(H)), FALSE, forced = TRUE)

	if(!visualsOnly)
		if(l_pocket)
			H.equip_to_slot_or_del(new l_pocket(H),SLOT_L_STORE, TRUE)
		if(r_pocket)
			H.equip_to_slot_or_del(new r_pocket(H),SLOT_R_STORE, TRUE)







		if(backpack_contents && !visualsOnly)
			for(var/path in backpack_contents)
				var/number = backpack_contents[path]
				if(!isnum(number))
					number = 1
				for(var/i in 1 to number)
					var/obj/item/new_item = new path(H)
					var/obj/item/item = H.get_item_by_slot(SLOT_BACK_L)
					if(!item)
						item = H.get_item_by_slot(SLOT_BACK_R)
					if(!item || !SEND_SIGNAL(item, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
						item = H.get_item_by_slot(SLOT_BACK_R)
						if(!item || !SEND_SIGNAL(item, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
							item = H.get_item_by_slot(SLOT_BELT)
							if(!item || !SEND_SIGNAL(item, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
								addtimer(CALLBACK(src, PROC_REF(move_storage), new_item, H.loc), 3 SECONDS)

	if(R)
		for(var/obj/item/I as anything in z121_parallel_item_tree(H) - before_items)
			R.items |= WEAKREF(I)
	post_equip(H, visualsOnly)

	if(istype(H.patron))
		H.patron.post_equip(H)

	if(!visualsOnly)
		apply_fingerprints(H)

	H.class_equip_finished = TRUE
	H.update_body()
	return TRUE
