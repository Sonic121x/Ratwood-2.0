//LIGHT ARMOR//
/obj/item/clothing/suit/roguetown/armor/chainmail
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "锁子短甲"
	desc = "钢制锁子甲衫。箭矢和小匕首会直接穿过它的缝隙。"
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS
	icon_state = "haubergeon"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	blocksound = CHAINHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_LIGHT //Experimental change; leave unlisted for now? Offers a weight-class advantage over the otherwise-superior hauberk. We'll see how it goes.
	material_category = ARMOR_MAT_CHAINMAIL

/obj/item/clothing/suit/roguetown/armor/chainmail/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_MAGEDEXTERITY)

/obj/item/clothing/suit/roguetown/armor/chainmail/iron
	icon_state = "ihaubergeon"
	name = "铁制锁子短甲"
	desc = "由沉重铁环制成的锁甲背心。总比没有强。"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/chainmail/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle)

/obj/item/clothing/suit/roguetown/armor/chainmail/bronze
	icon_state = "bhaubergeon"
	name = "青铜锁子短甲"
	desc = "由数百个相互咬合的青铜环制成的锁甲衫。灵活防护的价值—— \
	 尤其在板甲问世之前的数个世纪里——使任何形式的锁子甲 \
	都成为相当昂贵的商品； 其价值甚至等同于自身重量的黄金。"
	armor = ARMOR_BRONZE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_BRONZE
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	name = "远古锁子短甲"
	desc = "抛光的吉尔青铜环与丝绸交织成短式锁甲衣。百万人的死亡成就了齐佐的升格；若还需再有百万人赴死才能完成她的伟业，那便如此。"
	icon_state = "ancientchain"
	smeltresult = /obj/item/ingot/aaslag
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_CHAINMAIL

/obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	name = "破败锁子短甲"
	desc = "磨损的青铜环与腐烂皮革交织成短式锁甲衣。环链间有一道裂口，皮革沾着黑色污渍，那是数个世纪前致命创伤留下的痕迹。"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	anvilrepair = null

//MEDIUM ARMOR//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "锁子甲"
	desc = "更长的钢制锁子甲，连腿部也能保护，不过依然挡不住箭矢。"
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	icon_state = "hauberk"
	item_state = "hauberk"
	armor = ARMOR_MAILLE
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	name = "铁制锁子甲"
	desc = "更长的铁制锁子甲，连腿部也能保护，不过依然挡不住箭矢。"
	icon_state = "ihauberk"
	item_state = "ihauberk"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze
	name = "青铜锁子甲"
	desc = "一件青铜锁甲衣，袖部覆盖双臂与双腿。在古时，这样的护身甲胄在各方面都被视 \
	为无可匹敌； 它轻得足以让训练有素的战士行动自如，却仍能挡下箭矢与刀剑。"
	icon_state = "bhauberk"
	item_state = "bhauberk"
	armor = ARMOR_BRONZE
	smeltresult = /obj/item/ingot/bronze
	max_integrity = ARMOR_INT_CHEST_MEDIUM_BRONZE

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo
	name = "阿凡泰因锁甲袍"
	desc = "<font color='A50021'>而在基座之上，浮现出这样几行字：<i>「吾名齐佐，万后之后：」</i></font>"
	icon_state = "zizohauberk"
	item_state = "zizohauberk"
	armor = ARMOR_PLATE_BSTEEL
	armor_class = ARMOR_CLASS_MEDIUM
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL + 50
	chunkcolor = "#363030"
	material_category = ARMOR_MAT_CHAINMAIL

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "护甲")

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient
	name = "远古锁子甲"
	desc = "抛光的吉尔青铜环与丝绸交织成带袖锁甲衣。让无生者自腐朽中归来，将他们抬升至昔日不可企及的高度；那便是齐佐显现于世的意志。"
	icon_state = "ancienthauberk"
	smeltresult = /obj/item/ingot/aaslag
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_CHAINMAIL

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit
	name = "破败锁子甲"
	desc = "磨损的青铜环与腐烂皮革交织成带袖锁甲衣。曾经是圣骑士的武装法衣，如今却成了齐佐不死军团枯槁的披幕。"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate
	slot_flags = ITEM_SLOT_ARMOR
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_PLATE
	name = "普赛顿锁子甲"
	desc = "精美的钢制胸甲，以受祝银饰出沟槽纹，穿在厚重锁子甲之上。虽然它面对箭矢与弩矢时略显无力，但这些层层相扣的防护极擅抵御非人利爪与战斧的打击。 </br>'..邪恶的知识，以及将普赛多尼亚的希望扛在肩上的重负..' </br>... </br>若再添一些受祝银并请铁匠协助，我就能把这件锁子甲改造成一套全身板甲。"
	icon_state = "ornatehauberk"
	item_state = "ornatehauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON
	smeltresult = /obj/item/ingot/silverblessed
	is_silver = TRUE

/obj/item/clothing/suit/roguetown/armor/chainmail/bikini
	name = "锁子甲胸衣"	// corslet, from the old French 'cors' or bodice, with the diminutive 'let', used to describe lightweight military armor since 1500. Chosen here to replace 'bikini', an extreme anachronism.
	desc = "献给胆大者，以轻盈之姿换取锁甲的防护。"
	icon_state = "chainkini"
	item_state = "chainkini"
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES
	body_parts_covered = COVERAGE_TORSO
	armor_class = ARMOR_CLASS_LIGHT //placed in the medium category to keep it with its parent obj

/obj/item/clothing/suit/roguetown/armor/chainmail/bikini/bronze
	name = "青铜锁子甲胸衣"
	desc = "一件由青铜环编成的锁子甲胸衣。"
	icon_state = "bchainkini"
	item_state = "bchainkini"
	armor = ARMOR_BRONZE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_BRONZE
	smeltresult = /obj/item/ingot/bronze


/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	name = "plate-and-maille"
	desc = "A maille-aketon of steel, comfortably fitted beneath a matching cuirass. Best paired with a padded arming jacket \
	and a lovely goblet of wine, sourced straight from the Duke's private reserves."
	slot_flags = ITEM_SLOT_ARMOR
	icon_state = "cuirasshauberk"
	item_state = "cuirasshauberk"
	armor_class = ARMOR_CLASS_HEAVY // Prevents slot-stoackage by those who aren't already specialzed in wearing plate armor.
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT // To note, this is about 450 INT, or +150 over regular hauberk and -50 under regular plate.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient/decrepit
	name = "decrepit plate-and-maille"
	desc = "Frayed bronze rings and rotting leather, woven together to form a sleeved maille-atekon; one that's been uncomfortably \
	tucked beneath a matching cuirass. Such are the last remains of those who've dared to march against the undying legions, be it \
	yils or centuries prior."
	icon_state = "ancientcuirasshauberk"
	item_state = "ancientcuirasshauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_DECREPITLIGHT // 200 INT.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient
	name = "ancient plate-and-maille"
	desc = "Polished gilbranze rings and silk, woven together to form a sleeved maille-atekon; one that's been uncomfortably tucked \
	beneath a matching cuirass. It eminates an unfamiliar sensation, rarely seen amongst rot-and-undeath - elegance. In the worlds to \
	come, do you suppose Her death knights would bear such a mantle?"
	icon_state = "ancientcuirasshauberk"
	item_state = "ancientcuirasshauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted
	slot_flags = ITEM_SLOT_ARMOR
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_PLATE
	name = "fluted plate-and-maille"
	desc = "A beautiful steel cuirass, decorated with fluting and worn atop thick chainmaille. While it falters against \
	arrows and bolts, these interlinked layers are superb at warding off the blows of swords and axes."
	icon_state = "ornatehauberk"
	item_state = "ornatehauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated
	name = "decorated plate-and-maille"
	desc = "A maille-aketon of steel, comfortably fitted beneath a decorated cuirass. Best paired with a gilded dress shirt \
	and a tankard of Valmora Blue, chilled atop the rocks of a conquered fief."
	slot_flags = ITEM_SLOT_ARMOR
	icon_state = "gildedhauberk"
	item_state = "gildedhauberk"
	armor_class = ARMOR_CLASS_HEAVY
	max_integrity = ARMOR_INT_CHEST_PLATE_STEELLIGHT
	smeltresult = /obj/item/ingot/gold

///////// CRAFTING DATUMS FOR MAILLED CUIRASS /////////

/datum/crafting_recipe/roguetown/blacksmith/mailledhauberk
	name = "layer a steel cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half = 1,
				/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Straight-forward. Note that this is a copy of Draganfrukt's helmet-and-hat combination system, which also has the slight caveat..
	req_table = TRUE //..of resetting the durability of both items, when crafted and uncrafted. This check helps to reduce a lot of potential cheese, but should be tweaked later.

/datum/crafting_recipe/roguetown/survival/ancientmailledhauberk
	name = "layer an ancient cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half/ancient = 1,
				/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient = 1)
	craftdiff = 0 //Note that its Decrepit-tier variant is intended to largely be used by mobs and not players; hence, the lack of a crafting recipe.
	req_table = TRUE //If someone wants to add that in post, hwoever, I don't mind. You can easily do so by copy-pasting the format, here.

/datum/crafting_recipe/roguetown/survival/flutedmailledhauberk
	name = "layer a fluted cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted = 1,
				/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Note that its Decrepit-tier variant is intended to largely be used by mobs and not players; hence, the lack of a crafting recipe.
	req_table = TRUE //If someone wants to add that in post, hwoever, I don't mind. You can easily do so by copy-pasting the format, here.

/datum/crafting_recipe/roguetown/survival/ornatemailledhauberk
	name = "layer a psydonic cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate = 1,
				/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Note that its Decrepit-tier variant is intended to largely be used by mobs and not players; hence, the lack of a crafting recipe.
	req_table = TRUE //If someone wants to add that in post, hwoever, I don't mind. You can easily do so by copy-pasting the format, here.

/datum/crafting_recipe/roguetown/survival/decoratedmailledhauberk
	name = "layer a decorated cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted/decorated = 1,
				/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0 //Note that its Decrepit-tier variant is intended to largely be used by mobs and not players; hence, the lack of a crafting recipe.
	req_table = TRUE //If someone wants to add that in post, hwoever, I don't mind. You can easily do so by copy-pasting the format, here.
