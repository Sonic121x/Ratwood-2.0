/datum/anvil_recipe/armor
	abstract_type = /datum/anvil_recipe/armor
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "护甲"

// Material parent classes - same skill level as weapons
/datum/anvil_recipe/armor/ancient
	abstract_type = /datum/anvil_recipe/armor/ancient
	req_bar = /obj/item/ingot/gilbranze
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/armor/decrepit
	abstract_type = /datum/anvil_recipe/armor/decrepit
	req_bar = /obj/item/ingot/decrepit
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/armor/copper
	abstract_type = /datum/anvil_recipe/armor/copper
	req_bar = /obj/item/ingot/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/armor/bronze
	abstract_type = /datum/anvil_recipe/armor/bronze
	req_bar = /obj/item/ingot/bronze
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/armor/decorated
	abstract_type = /datum/anvil_recipe/armor/decorated
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/armor/iron
	abstract_type = /datum/anvil_recipe/armor/iron
	req_bar = /obj/item/ingot/iron
	req_blade = /obj/item/blade/iron_plate
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/armor/steel
	abstract_type = /datum/anvil_recipe/armor/steel
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/armor/silver
	abstract_type = /datum/anvil_recipe/armor/silver
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/armor/holysteel
	abstract_type = /datum/anvil_recipe/armor/holysteel
	req_bar = /obj/item/ingot/steelholy
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/armor/blessedsilver
	abstract_type = /datum/anvil_recipe/armor/blessedsilver
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/armor/blacksteel
	abstract_type = /datum/anvil_recipe/armor/blacksteel
	req_bar = /obj/item/ingot/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/armor/blacksteel/modern
	abstract_type = /datum/anvil_recipe/armor/blacksteel/modern
	req_bar = /obj/item/ingot/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/armor/gold
	abstract_type = /datum/anvil_recipe/armor/gold
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_LEGENDARY

//For the sake of keeping the code modular with the introduction of new metals, each recipe has had it's main resource added to it's datum
//This way, we can avoid having to name things in strange ways and can simply have iron/cuirass, stee/cuirass, blacksteel/cuirass->
//-> and not messy names like ibreastplate and hplate


// COPPER

/datum/anvil_recipe/armor/copper/mask
	name = "铜面具"
	created_item = /obj/item/clothing/mask/rogue/facemask/copper
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/copper/bracers
	name = "铜臂甲"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/copper
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/copper/cap
	name = "札甲帽"
	created_item = /obj/item/clothing/head/roguetown/helmet/coppercap
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/copper/gorget
	name = "护颈"
	created_item = /obj/item/clothing/neck/roguetown/gorget/copper
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/copper/chest
	name = "护心甲"
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/copper
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

// BRONZE

/datum/anvil_recipe/armor/bronze/barbute
	name = "青铜巴尔布特盔，另需1块青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bronze
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/bronze/murmillo
	name = "青铜穆尔米洛盔，另需1块青铜锭、1张毛皮"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/fur)
	created_item = /obj/item/clothing/head/roguetown/helmet/bronzegladiator
	display_category = ITEM_CAT_ARMOR_HELMETS
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/illyria
	name = "青铜伊利里亚头盔，另需1张鞣制皮革"
	additional_items = list( /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/bronze
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/bronze/protector
	name = "青铜护心甲，另需1块青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/cuirass
	name = "青铜胸甲，另需1块青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/halfplate
	name = "青铜全装甲组件，另需3块青铜锭、1张鞣制皮革、1张毛皮"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/fullplate
	name = "青铜全装板甲，另需3块青铜锭、1张鞣制皮革、1张毛皮"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 3

/datum/anvil_recipe/armor/bronze/gorget
	name = "青铜护颈，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/neck/roguetown/gorget/bronze
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/bronze/bevor
	name = "青铜护喉甲，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/neck/roguetown/bevor/bronze
	display_category = ITEM_CAT_ARMOR_NECK
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/bracers
	name = "青铜护腕，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/bronze
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/bronze/greaves
	name = "青铜胫甲，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/bronze
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/bronze/skirt
	name = "青铜锁甲裙，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/under/roguetown/chainlegs/skirt/bronze
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/bronze/mask
	name = "青铜面具，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/duelist
	name = "青铜制决斗者护目镜 ×2"
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist/bronze
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/maskclassic
	name = "青铜死亡面具，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze/classic
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/mask
	name = "青铜面具，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/chainmail
	name = "青铜锁子短甲"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/hauberk
	name = "青铜锁子甲，另需1块青铜锭"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/maillebracers
	name = "青铜锁链袖套"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain/bronze
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/bronze/maillegloves
	name = "青铜锁甲护手"
	created_item = /obj/item/clothing/gloves/roguetown/chain/bronze
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/bronze/maillecoif
	name = "青铜锁链护头巾"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/bronze
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/bronze/scalemail
	name = "青铜鳞甲，另需1块青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/mailleskirt
	name = "青铜链甲裙"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/bronze
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/bronze/mailleboots
	name = "青铜链甲靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille/bronze
	display_category = ITEM_CAT_ARMOR_BOOTS
// DECREPIT/ANCIENT ALLOY

/datum/anvil_recipe/armor/ancient/barbute
	name = "远古巴尔布特盔，另需1块吉尔青铜锭"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ancient
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decrepit/barbute
	name = "破旧巴尔布特盔，另需1块朽败锭"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/ancient/savoyard
	name = "远古萨伏依盔，另需1块吉尔青铜锭"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decrepit/savoyard
	name = "破旧萨伏依盔，另需1块朽败锭"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/ancient/bascinet
	name = "古老盆盔，另需1块吉尔青铜锭"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = 	/obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decrepit/bascinet
	name = "破旧盆盔，另需1块朽败锭"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = 	/obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/ancient/helmetkettle
	name = "古老的锅盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/ancient
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decrepit/helmetkettle
	name = "破旧的锅盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/ancient/mask
	name = "远古面具"
	created_item = /obj/item/clothing/mask/rogue/facemask/ancient
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/decrepit/mask
	name = "破旧面具"
	created_item = /obj/item/clothing/mask/rogue/facemask/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/ancient/coif
	name = "远古护头巾"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/ancient
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/decrepit/coif
	name = "破旧护头巾"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/ancient/gorget
	name = "远古护喉"
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/decrepit/gorget
	name = "破旧护喉"
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/ancient/cuirass
	name = "远古胸甲，另需1块吉尔青铜锭"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decrepit/cuirass
	name = "破败胸甲，另需1块朽败锭"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/ancient/halfplate
	name = "远古半身板甲，另需1件远古胸甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/ancient, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/ancient
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decrepit/halfplate
	name = "破败半身板甲，另需1件破败胸甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/ancient/chainmail
	name = "远古锁子短甲"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decrepit/chainmail
	name = "破败锁子短甲"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/ancient/hauberk
	name = "远古锁子甲，另需1块吉尔青铜锭"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient
	additional_items = list(/obj/item/ingot/gilbranze)
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decrepit/hauberk
	name = "破败锁子甲，另需1块朽败锭"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit
	additional_items = list(/obj/item/ingot/decrepit)
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/ancient/bracers
	name = "远古臂甲"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/ancient
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/decrepit/bracers
	name = "残破臂甲"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/ancient/maillebracers
	name = "远古锁链袖套"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain/ancient
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/decrepit/maillebracers
	name = "破旧锁链袖套"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/ancient/chaingaunts
	name = "远古锁子护手 ×2"
	created_item = /obj/item/clothing/gloves/roguetown/chain/ancient
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/decrepit/chaingaunts
	name = "破败锁子护手 ×2"
	created_item = /obj/item/clothing/gloves/roguetown/chain/ancient/decrepit
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/ancient/plategaunts
	name = "远古板甲护手"
	created_item = /obj/item/clothing/gloves/roguetown/plate/ancient
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/decrepit/plategaunts
	name = "破败板甲护手"
	created_item = /obj/item/clothing/gloves/roguetown/plate/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/ancient/plateboots
	name = "远古战靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/ancient
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/decrepit/plateboots
	name = "残破战靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/ancient/chainkilt
	name = "远古锁甲裙铠"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/decrepit/chainkilt
	name = "残破锁甲裙铠"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/ancient/platelegs
	name = "远古板甲腿铠，另需1块吉尔青铜锭"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/clothing/under/roguetown/platelegs/ancient
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/decrepit/platelegs
	name = "残破板甲腿铠，另需1块朽败锭"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/clothing/under/roguetown/platelegs/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_LEGS

// IRON

/datum/anvil_recipe/armor/iron/haubergeon
	name = "铁制锁子短甲"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/hauberk
	name = "铁制锁子甲，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/chaincoif
	name = "铁锁链护头巾"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/iron
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/gorget
	name = "护喉"
	created_item = /obj/item/clothing/neck/roguetown/gorget
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/bevor
	name = "铁护颚"
	created_item = /obj/item/clothing/neck/roguetown/bevor/iron
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/breastplate
	name = "铁胸甲，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/wardenbrig
	name = "林地守卫布里甘丁甲，另需1件林地守卫甲、1块铁锭、1份荒野精华"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/warden, /obj/item/ingot/iron, /obj/item/natural/cured/essence)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	i_type = "护甲"
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/wardenmeleehauberk
	name = "护林人锁子甲，另需1件护林人胸甲、1份荒野精华、1块钢锭"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/warden/melee, /obj/item/natural/cured/essence, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/melee/upgraded
	i_type = "护甲"
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/halfplate
	name = "铁制半身板甲，另需1件铁胸甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/iron, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/fullplate
	name = "铁制板甲，另需1件铁制半身板甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/iron, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/chainglove
	name = "铁制锁甲护手 ×2"
	created_item = /obj/item/clothing/gloves/roguetown/chain/iron
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/iron/plategauntlets
	name = "铁制板甲护手"
	created_item = /obj/item/clothing/gloves/roguetown/plate/iron
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/iron/chainleg
	name = "铁制锁甲腿铠"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/chainleg/kilt
	name = "铁制锁甲裙铠"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/splintlegs
	name = "拼铁护腿，另需1条皮裤"
	additional_items = list(/obj/item/clothing/under/roguetown/trou/leather)//basically you just add a lot of iron bits to the pants
	created_item = /obj/item/clothing/under/roguetown/splintlegs/iron
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/platelegs
	name = "铁制板甲腿铠，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/under/roguetown/platelegs/iron
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/mask
	name = "铁面具"
	created_item = /obj/item/clothing/mask/rogue/facemask
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/iron/mask/hound
	name = "猎犬面具"
	created_item = /obj/item/clothing/mask/rogue/facemask/hound
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/iron/wildguard
	name = "荒野守卫"
	created_item = /obj/item/clothing/mask/rogue/wildguard
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/iron/duelist
	name = "铁制决斗者护目镜 ×2"
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/iron/splintarms
	name = "拼铁臂甲，另需1件皮臂甲" //you modify the bracers to have splints and cover the arm way more
	additional_items = list(/obj/item/clothing/wrists/roguetown/bracers/leather)
	created_item = /obj/item/clothing/wrists/roguetown/splintarms/iron
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/iron/bracers
	name = "铁臂甲"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/iron
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/iron/boot
	name = "铁板靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/iron/mailleboots
	name = "铁链甲靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille/iron
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/iron/skullcap
	name = "骷髅帽"
	created_item = /obj/item/clothing/head/roguetown/helmet/skullcap
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/kettle
	name = "铁锅盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet
	name = "铁萨勒盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet/visor
	name = "铁带面罩萨勒盔，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet/visor_snouted
	name = "带吻部面罩铁制萨雷特盔，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron/snouted

/datum/anvil_recipe/armor/iron/helmetroundface
	name = "铁制圆面盆盔，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetroundface_snouted
	name = "带吻部铁制圆面盆盔，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/iron/snouted
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetarmet
	name = "铁制阿米特盔，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/helmetarmet_snouted
	name = "带吻部铁制阿米特盔，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/iron/snouted
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/knighthelmet
	name = "铁骑士头盔，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/bucket
	name = "铁桶盔，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/studded
	name = "铆钉皮甲，另需1件皮甲"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/studdedbikini
	name = "铆钉皮胸衣，另需1件皮甲"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/helmethorned
	name = "角饰帽"
	created_item = /obj/item/clothing/head/roguetown/helmet/horned
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/studdedhood
	name = "铆钉皮革兜帽"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/clothing/head/roguetown/helmet/leather/armorhood)
	created_item = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	display_category = ITEM_CAT_ARMOR_HELMETS

// STEEL

/datum/anvil_recipe/armor/steel/haubergeon
	name = "锁子短甲"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/chainkini
	name = "锁子甲胸衣，另需1块布料"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/hauberk
	name = "锁子甲，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/halfplate
	name = "钢制半身板甲，另需1件钢胸甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half,/obj/item/natural/hide/cured,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/halfplate/fluted
	name = "沟槽半身板甲，另需1件沟槽胸甲、1块钢锭、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted, /obj/item/natural/hide/cured, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplate
	name = "板甲，另需1件钢制半身板甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplate/fluted
	name = "沟槽板甲，另需1件沟槽半身板甲、1块钢锭、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted, /obj/item/natural/hide/cured, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/platebikini
	name = "半身板甲胸衣，另需1件钢胸甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplatebikini
	name = "全板甲胸衣，另需1件钢制半身板甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/coatplates
	name = "板片外衣，另需1块钢锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/lbrigandine
	name = "轻型板甲衣，另需1块布料"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	i_type = "护甲"
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/brigandine
	name = "板甲衣，另需1块钢锭、2块布料"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/cloth, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/chaincoif
	name = "锁链护头巾"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/chainmantle
	name = "锁链披肩"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/fullchaincoif
	name = "全覆式锁链护头巾，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/full
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/chainglove
	name = "锁链护手 ×2"
	created_item = /obj/item/clothing/gloves/roguetown/chain
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/steel/plateglove
	name = "板甲护手"
	created_item = /obj/item/clothing/gloves/roguetown/plate
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/steel/chainlegs
	name = "钢制锁甲腿铠"
	created_item = /obj/item/clothing/under/roguetown/chainlegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/chainlegs/kilt
	name = "钢制锁甲裙铠"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/chainskirt
	name = "钢制锁甲裙"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/skirt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/plateskirt
	name = "钢制垂腿甲，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/skirt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/platelegs
	name = "钢制板甲腿铠，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/under/roguetown/platelegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/cuirass
	name = "钢胸甲，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/lightcuirass
	name = "击剑手胸甲，另需1块钢锭、1张鞣制皮革"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/cuirass/fluted
	name = "沟槽胸甲，另需2块钢锭"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/scalemail
	name = "鳞甲，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/platebracer
	name = "臂甲"
	created_item = /obj/item/clothing/wrists/roguetown/bracers
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/steel/maillebracers
	name = "锁链袖套"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/steel/jackchain
	name = "护臂链条"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/steel/helmetnasal
	name = "简易头盔"
	created_item = /obj/item/clothing/head/roguetown/helmet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetwinged
	name = "翼饰帽"
	created_item = /obj/item/clothing/head/roguetown/helmet/winged
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetkettle
	name = "锅盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/widehelmetkettle
	name = "宽檐锅盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/wide
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bevor
	name = "护颚"
	created_item = /obj/item/clothing/neck/roguetown/bevor
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/sgorget
	name = "钢护喉"
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/cursed_collar
	name = "次级诅咒颈圈"
	created_item = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/helmetsall
	name = "萨雷特盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetsallv
	name = "带面罩萨勒盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetsallv_snouted
	name = "带吻部面罩萨雷特盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "桶盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetpig
	name = "猪面盆盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmethounskull
	name = "犬首盆盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetroundface
	name = "圆面盆盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetroundface_snouted
	name = "带吻部圆面盆盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bascinet
	name = "盆盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/etruscanbascinet
	name = "伊特鲁斯卡盆盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetknight
	name = "骑士头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetarmet
	name = "阿米特盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetarmet_snouted
	name = "带吻部阿米特盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/slittedkettle
	name = "开缝锅盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/savoyard
	name = "钢萨伏依盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bogman
	name = "钢沼民头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/barredhelm
	name = "栅栏头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/beakhelm
	name = "鸟喙头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetvolf
	name = "沃尔夫面甲头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
	i_type = "护甲"
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/plateboot
	name = "板甲靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/steel/mailleboots
	name = "链甲靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/steel/mask
	name = "钢面具"
	created_item = /obj/item/clothing/mask/rogue/facemask/steel
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/steel/mask/hound
	name = "钢猎犬面具"
	created_item = /obj/item/clothing/mask/rogue/facemask/steel/hound
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/steel/duelist
	name = "钢制决斗者护目镜 ×2"
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist/steel
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/steel/astratahelm
	name = "阿斯特拉塔头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/abyssorhelm
	name = "阿比索尔圣殿头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/necrahelm
	name = "内克拉头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/nochelm
	name = "诺克头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/dendorhelm
	name = "登多尔头盔，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/frogmouth
	name = "蛙嘴盔，另需2块钢锭"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/belt
	name = "钢腰带"
	created_item = /obj/item/storage/belt/rogue/leather/steel

/datum/anvil_recipe/armor/steel/belt/tasset
	name = "腿甲腰带"
	created_item = /obj/item/storage/belt/rogue/leather/steel/tasset

/datum/anvil_recipe/armor/steel/splintarms
	name = "板条护臂，另需1件皮臂甲"
	additional_items = list(/obj/item/clothing/wrists/roguetown/bracers/leather)
	created_item = /obj/item/clothing/wrists/roguetown/splintarms
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/steel/splintlegs
	name = "板条腿铠，另需1条皮裤"
	additional_items = list(/obj/item/clothing/under/roguetown/trou/leather)//basically you just add a lot of iron bits to the pants
	created_item = /obj/item/clothing/under/roguetown/splintlegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/barding
	name = "赛加羚锁子兽甲，另需1块钢锭"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/chain

/datum/anvil_recipe/armor/steel/barding/fogbeast
	name = "雾兽锁子兽甲，另需1块钢锭"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/fogbeast/chain

// HOLY STEEL

/datum/anvil_recipe/armor/holysteel/astratahelmtemplar
	name = "阿斯特拉塔头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/malumhelmtemplar
	name = "玛勒姆之盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/malum
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/necrahelmtemplar
	name = "内克拉头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/pestrahelmtemplar
	name = "佩斯特拉头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/eorahelmtemplar
	name = "伊欧拉头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/eoran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/astratahelm
	name = "阿斯特拉塔头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/abyssorhelm
	name = "阿比索尔圣殿头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/necrahelm
	name = "内克拉头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/nochelm
	name = "诺克头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/nochelm_snouted
	name = "带吻部诺克头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm/snouted
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/dendorhelm
	name = "登多尔头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/ravoxhelm
	name = "正义之鹰盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/xylixhelm
	name = "赛利克斯头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/eorahelm
	name = "伊欧拉头盔，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/eoran
	display_category = ITEM_CAT_ARMOR_HELMETS

// SILVER

/datum/anvil_recipe/armor/silver/belt
	name = "银饰牌腰带"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/storage/belt/rogue/leather/plaquesilver


// BLESSED SILVER

/datum/anvil_recipe/armor/blessedsilver/psychestplate
	name = "普赛顿胸甲，另需1张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer/psydon
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psycuirass
	name = "普赛顿胸甲，另需2张鞣制皮革、1块祝圣银锭"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/armetpsy
	name = "普赛顿式阿米特盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/greatplumearmetpsy
	name = "带大羽饰的普赛顿式阿米特盔"
	category = "祝福白银"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/psy/greatplume

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy
	name = "普赛顿式萨雷特盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy
	name = "普赛顿式桶盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmvolfpsy
	name = "普赛顿式沃尔夫头骨盆盔"
	category = "祝福白银"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/psydonic

/datum/anvil_recipe/armor/blessedsilver/helmetabso
	name = "普赛顿式锥形盔，另需2块祝圣银锭"
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/absolver
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate
	name = "普赛顿半身板甲，另需1件普赛顿胸甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psyfullplate
	name = "普赛顿板甲，另需1件普赛顿半身板甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt
	name = "普赛顿板甲，另需1件普赛顿锁子甲、2块祝圣银锭、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

// BLESSED SILVER BULLION

/datum/anvil_recipe/armor/blessedsilver/psychestplate/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/psycuirass/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/armetpsy/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/greatplumearmetpsy/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/helmvolfpsy/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/helmetabso/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/psyfullplate/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

// DECORATED

/datum/anvil_recipe/armor/decorated/belt
	name = "饰牌腰带"
	created_item = /obj/item/storage/belt/rogue/leather/plaquegold

/datum/anvil_recipe/armor/decorated/mask
	name = "黄金面具"
	created_item = /obj/item/clothing/mask/rogue/facemask/goldmask
	display_category = ITEM_CAT_ARMOR_MASKS

// GOLD

/datum/anvil_recipe/armor/gold/armet
	name = "黄金骑士阿米特盔，另需1块金锭、2块丝绸"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gold
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/armetcrown
	name = "王室黄金阿米特盔，另需1块金锭、2块丝绸、1颗多佩尔石"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gold/king
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/helmet
	name = "黄金头盔，另需1块金锭、2块丝绸"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/helmetcrown
	name = "王室黄金头盔，另需1块金锭、2块丝绸、1颗多佩尔石"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold/king
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/gorget
	name = "黄金护喉，另需1块金锭、2块丝绸"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/neck/roguetown/gorget/gold
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/gold/cuirass
	name = "金色胸甲，另需2块金锭、2块丝绸"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/gold/cuirasshero
	name = "金色英雄胸甲，另需2块金锭、2块丝绸、1份牛脂"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/reagent_containers/food/snacks/tallow)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold/heroic
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/gold/bracers
	name = "黄金臂甲，另需1块金锭、2块丝绸"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/gold
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/gold/greaves
	name = "金色胫甲，另需1块金锭、2块丝绸"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/gold
	display_category = ITEM_CAT_ARMOR_BOOTS

// BLACKSTEEL

/datum/anvil_recipe/armor/blacksteel/cuirass
	name = "黑钢胸甲，另需1块黑钢锭"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/modern/platechest
	name = "黑钢板甲，另需1件黑钢半身板甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_halfplate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/modern/blacksteel_full_plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/halfplatechest
	name = "黑钢半身板甲，另需1件黑钢胸甲、2张鞣制皮革"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_halfplate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/ancienthalfplatechest
	name = "黑钢半身板甲，另需2块黑钢锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_halfplate/ancient
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/modern/plategloves
	name = "黑钢板甲护手"
	created_item = /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/blacksteel/modern/platelegs
	name = "黑钢板甲腿铠，另需1块黑钢锭"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/blacksteel/modern/armet
	name = "黑钢阿米特盔，另需1块黑钢锭"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blacksteel/modern/plateboots
	name = "黑钢板甲靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots
	display_category = ITEM_CAT_ARMOR_BOOTS

// BLACKSTEEL, ANCIENT

/datum/anvil_recipe/armor/blacksteel/platechest
	name = "远古黑钢板甲，另需3块黑钢锭"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_full_plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/platelegs
	name = "远古黑钢板甲腿铠，另需1块黑钢锭"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/blacksteel
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/blacksteel/bucket
	name = "黑钢桶盔，另需1块黑钢锭"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/blacksteel/bucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blacksteel/plategloves
	name = "远古黑钢板甲护手"
	created_item = /obj/item/clothing/gloves/roguetown/blacksteel/plategloves
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/blacksteel/plateboots
	name = "远古黑钢板甲靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/blacksteel/plateboots
	display_category = ITEM_CAT_ARMOR_BOOTS
