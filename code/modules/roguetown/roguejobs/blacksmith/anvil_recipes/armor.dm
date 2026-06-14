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
	name = "面甲, 铜"
	created_item = /obj/item/clothing/mask/rogue/facemask/copper
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/copper/bracers
	name = "臂甲, 铜"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/copper
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/copper/cap
	name = "札甲帽"
	created_item = /obj/item/clothing/head/roguetown/helmet/coppercap
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/copper/gorget
	name = "护颈, 铜"
	created_item = /obj/item/clothing/neck/roguetown/gorget/copper
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/copper/chest
	name = "护心甲, 铜"
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/copper
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

// BRONZE

/datum/anvil_recipe/armor/bronze/barbute
	name = "巴布塔盔，青铜 (+1 青铜，+1 熟皮)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bronze
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/bronze/murmillo
	name = "穆尔米洛式头盔，青铜 (+1 青铜，+1 毛皮)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/fur)
	created_item = /obj/item/clothing/head/roguetown/helmet/bronzegladiator
	display_category = ITEM_CAT_ARMOR_HELMETS
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/illyria
	name = "盔式头盔，青铜 (+1 熟皮)"
	additional_items = list( /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/bronze
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/bronze/protector
	name = "护心甲, 青铜 (+1 青铜, +1 熟皮)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/cuirass
	name = "胸甲, 青铜 (+1 青铜, +1 熟皮)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/halfplate
	name = "半套甲胄, 青铜 (+3 青铜, +1 熟皮, +1 毛皮)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/fullplate
	name = "全套甲胄, 青铜 (+3 青铜, +1 熟皮, +1 Fur)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES
	craftdiff = 3

/datum/anvil_recipe/armor/bronze/gorget
	name = "颈甲，青铜 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/neck/roguetown/gorget/bronze
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/bronze/bevor
	name = "护颏，青铜 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/neck/roguetown/bevor/bronze
	display_category = ITEM_CAT_ARMOR_NECK
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/bracers
	name = "臂铠，青铜 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/bronze
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/bronze/greaves
	name = "胫甲，青铜 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/bronze
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/bronze/skirt
	name = "链甲裙，青铜 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/bronze/mask
	name = "面具，青铜 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/duelist
	name = "决斗者护目镜，青铜"
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist/bronze
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/maskclassic
	name = "面具，华丽，青铜 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze/classic
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/mask
	name = "面具，青铜 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/mask/rogue/facemask/bronze
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/bronze/chainmail
	name = "锁子甲，青铜"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/hauberk
	name = "锁子铠，青铜 (+1 青铜)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/maillebracers
	name = "链甲臂铠，青铜"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain/bronze
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/bronze/maillegloves
	name = "链甲手套，青铜"
	created_item = /obj/item/clothing/gloves/roguetown/chain/bronze
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/bronze/maillecoif
	name = "链甲兜帽，青铜"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/bronze
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/bronze/scalemail
	name = "鳞甲，青铜 (+1 青铜，+1 熟皮)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale/bronze
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/bronze/mailleskirt
	name = "链甲裙，青铜"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/bronze
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/bronze/mailleboots
	name = "链甲靴，青铜"
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille/bronze
	display_category = ITEM_CAT_ARMOR_BOOTS
// DECREPIT/ANCIENT ALLOY

/datum/anvil_recipe/armor/ancient/barbute
	name = "Barbute, 古代 (+1 吉尔青铜)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ancient
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decrepit/barbute
	name = "Barbute, 衰朽 (+1 合金)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/ancient/savoyard
	name = "Savoyard, 古代 (+1 吉尔青铜)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decrepit/savoyard
	name = "Savoyard, 衰朽 (+1 合金)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/ancient/bascinet
	name = "尖顶盔, 古代 (+1 吉尔青铜)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = 	/obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decrepit/bascinet
	name = "尖顶盔, 衰朽 (+1 合金)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = 	/obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/ancient/helmetkettle
	name = "圆边盔, 古代"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/ancient
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/decrepit/helmetkettle
	name = "圆边盔, 衰朽"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/ancient/mask
	name = "面甲, 古代"
	created_item = /obj/item/clothing/mask/rogue/facemask/ancient
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/decrepit/mask
	name = "面甲, 衰朽"
	created_item = /obj/item/clothing/mask/rogue/facemask/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/ancient/coif
	name = "头巾甲, 古代"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/ancient
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/decrepit/coif
	name = "头巾甲, 衰朽"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/ancient/gorget
	name = "护喉, 古代"
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/decrepit/gorget
	name = "护喉, 衰朽"
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/ancient/cuirass
	name = "胸甲, 古代 (+1 吉尔青铜)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decrepit/cuirass
	name = "胸甲, 衰朽 (+1 合金)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/ancient/halfplate
	name = "半身板甲, 古代 (+1 胸甲, 古代, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/ancient, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/ancient
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decrepit/halfplate
	name = "半身板甲, 衰朽 (+1 胸甲, 衰朽, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/ancient/chainmail
	name = "锁子甲, 古代"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decrepit/chainmail
	name = "锁子甲, 衰朽"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/ancient/hauberk
	name = "长身锁子甲, 古代 (+1 吉尔青铜)"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient
	additional_items = list(/obj/item/ingot/gilbranze)
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/decrepit/hauberk
	name = "长身锁子甲, 衰朽 (+1 合金)"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit
	additional_items = list(/obj/item/ingot/decrepit)
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/ancient/bracers
	name = "臂甲, 古代"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/ancient
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/decrepit/bracers
	name = "臂甲, 衰朽"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/ancient/maillebracers
	name = "链甲臂铠, 古代"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain/ancient
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/decrepit/maillebracers
	name = "链甲臂铠, 衰朽"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/ancient/chaingaunts
	name = "锁甲手套, 古代"
	created_item = /obj/item/clothing/gloves/roguetown/chain/ancient
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/decrepit/chaingaunts
	name = "锁甲手套, 衰朽"
	created_item = /obj/item/clothing/gloves/roguetown/chain/ancient/decrepit
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/ancient/plategaunts
	name = "板甲手套, 古代"
	created_item = /obj/item/clothing/gloves/roguetown/plate/ancient
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/decrepit/plategaunts
	name = "板甲手套, 衰朽"
	created_item = /obj/item/clothing/gloves/roguetown/plate/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/ancient/plateboots
	name = "板甲靴, 古代"
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/ancient
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/decrepit/plateboots
	name = "板甲靴, 衰朽"
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/ancient/chainkilt
	name = "锁甲裙, 古代"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/decrepit/chainkilt
	name = "锁甲裙, 衰朽"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/ancient/platelegs
	name = "板甲腿甲, 古代 (+1 吉尔青铜)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/clothing/under/roguetown/platelegs/ancient
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/decrepit/platelegs
	name = "板甲腿甲, 衰朽 (+1 合金)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/clothing/under/roguetown/platelegs/ancient/decrepit
	display_category = ITEM_CAT_ARMOR_LEGS

// IRON

/datum/anvil_recipe/armor/iron/haubergeon
	name = "短身锁子甲, 铁"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/hauberk
	name = "长身锁子甲, 铁 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/chaincoif
	name = "锁甲头巾, 铁"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/iron
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/gorget
	name = "护喉, 铁"
	created_item = /obj/item/clothing/neck/roguetown/gorget
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/bevor
	name = "护颌, 铁"
	created_item = /obj/item/clothing/neck/roguetown/bevor/iron
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/breastplate
	name = "胸甲, 铁 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/wardenbrig
	name = "林地守卫札甲 (+1 林地守卫甲, +1 铁, +1 荒野精华)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/warden, /obj/item/ingot/iron, /obj/item/natural/cured/essence)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	i_type = "护甲"
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/wardenmeleehauberk
	name = "Forester's Hauberk (+1 Forester's Cuirass, +1 Essence of Wilderness, +1 Steel)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/warden/melee, /obj/item/natural/cured/essence, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/melee/upgraded
	i_type = "Armor"
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/halfplate
	name = "半身板甲, 铁 (+1 铁 胸甲, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/iron, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/fullplate
	name = "全身板甲, 铁 (+1 铁 半身板甲, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/iron, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/chainglove
	name = "锁甲手套, 铁 (x2)"
	created_item = /obj/item/clothing/gloves/roguetown/chain/iron
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/iron/plategauntlets
	name = "板甲手套, 铁"
	created_item = /obj/item/clothing/gloves/roguetown/plate/iron
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/iron/chainleg
	name = "锁甲腿甲, 铁"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/chainleg/kilt
	name = "锁甲裙, 铁"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/splintlegs
	name = "加条腿甲 (+1 皮裤)"
	additional_items = list(/obj/item/clothing/under/roguetown/trou/leather)//basically you just add a lot of iron bits to the pants
	created_item = /obj/item/clothing/under/roguetown/splintlegs/iron
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/platelegs
	name = "板甲腿甲, 铁 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/under/roguetown/platelegs/iron
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/iron/mask
	name = "面甲, 铁"
	created_item = /obj/item/clothing/mask/rogue/facemask
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/iron/mask/hound
	name = "Hound 面甲, 铁"
	created_item = /obj/item/clothing/mask/rogue/facemask/hound
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/iron/wildguard
	name = "Wild Guard, 铁"
	created_item = /obj/item/clothing/mask/rogue/wildguard
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/iron/duelist
	name = "Duelist Goggles, Iron"
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/iron/splintarms
	name = "Splinted 臂甲 (+1 皮臂甲)" //you modify the bracers to have splints and cover the arm way more
	additional_items = list(/obj/item/clothing/wrists/roguetown/bracers/leather)
	created_item = /obj/item/clothing/wrists/roguetown/splintarms/iron
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/iron/bracers
	name = "Plate 臂甲, 铁"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/iron
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/iron/jackchain
	name = "Jack Chain, 铁"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/iron/boot
	name = "轻型板甲靴, 铁"
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/iron/mailleboots
	name = "Maille Boots, Iron"
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille/iron
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/iron/skullcap
	name = "骷髅帽, 铁"
	created_item = /obj/item/clothing/head/roguetown/helmet/skullcap
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/kettle
	name = "圆边盔, 铁"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet
	name = "Sallet 头盔, 铁"
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/sallet/visor
	name = "面罩 Sallet, 铁 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/knighthelmet
	name = "骑士头盔, 铁 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/bucket
	name = "铁 桶盔 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/iron/studded
	name = "Studded 皮甲 (+ 皮甲)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/studdedbikini
	name = "Studded 皮胸衣 (+ 皮胸衣)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/leather)
	created_item = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/iron/helmethorned
	name = "Horned Helmet, 铁"
	created_item = /obj/item/clothing/head/roguetown/helmet/horned
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/studdedhood
	name = "铆钉皮兜帽"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/clothing/head/roguetown/helmet/leather/armorhood)
	created_item = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	display_category = ITEM_CAT_ARMOR_HELMETS

// STEEL

/datum/anvil_recipe/armor/steel/haubergeon
	name = "短身锁子甲, 钢"
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/chainkini
	name = "锁甲胸衣, 钢 (+1 布料)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/hauberk
	name = "长身锁子甲, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/halfplate
	name = "半身板甲, 钢 (+1 胸甲, 钢, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half,/obj/item/natural/hide/cured,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/halfplate/fluted
	name = "沟纹半身板甲，钢 (+1 沟纹胸甲，钢，+1 钢，+2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted, /obj/item/natural/hide/cured, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplate
	name = "全身板甲, 钢 (+1 半身板甲, 钢, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplate/fluted
	name = "沟纹全身板甲，钢 (+1 沟纹半身板甲，钢，+1 钢，+2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted, /obj/item/natural/hide/cured, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/platebikini
	name = "半身板甲 Corslet, 钢 (+1 胸甲, 钢, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/fullplatebikini
	name = "全身板甲 Corslet, 钢 (+1 半身板甲, 钢, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/bikini
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/coatplates
	name = "板片外衣, 钢 (+1 钢, +1 熟皮)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/lbrigandine
	name = "Light 札甲, 钢 (+1 布料)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	i_type = "护甲"
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/brigandine
	name = "札甲, 钢 (+1 钢, +2 布料)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/cloth, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/chaincoif
	name = "锁甲头巾, 钢"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/chainmantle
	name = "Chain Mantle, 钢"
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/fullchaincoif
	name = "Full 锁甲头巾, 钢 (+1 steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/neck/roguetown/chaincoif/full
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/chainglove
	name = "锁甲手套, 钢 (x2)"
	created_item = /obj/item/clothing/gloves/roguetown/chain
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/steel/plateglove
	name = "板甲手套, 钢"
	created_item = /obj/item/clothing/gloves/roguetown/plate
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/steel/chainlegs
	name = "锁甲腿甲, 钢"
	created_item = /obj/item/clothing/under/roguetown/chainlegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/chainlegs/kilt
	name = "锁甲裙, 钢"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/kilt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/chainskirt
	name = "锁甲裙, 钢"
	created_item = /obj/item/clothing/under/roguetown/chainlegs/skirt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/plateskirt
	name = "板甲垂裙, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/skirt
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/platelegs
	name = "板甲腿甲, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/under/roguetown/platelegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/cuirass
	name = "胸甲, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/lightcuirass
	name = "Fencing 胸甲, 钢 (+1 钢, +1 熟皮)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/cuirass/fluted
	name = "沟纹胸甲，钢 (+2 钢)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/scalemail
	name = "鳞甲, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/scale
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/steel/platebracer
	name = "Plate 臂甲, 钢"
	created_item = /obj/item/clothing/wrists/roguetown/bracers
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/steel/maillebracers
	name = "Chainsleeves, Steel"
	created_item = /obj/item/clothing/wrists/roguetown/bracers/chain
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/steel/helmetnasal
	name = "鼻护盔, 钢"
	created_item = /obj/item/clothing/head/roguetown/helmet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetwinged
	name = "翼盔, 钢"
	created_item = /obj/item/clothing/head/roguetown/helmet/winged
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetkettle
	name = "圆边盔, 钢"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/widehelmetkettle
	name = "Wide 圆边盔, 钢"
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/wide
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bevor
	name = "护颌, 钢"
	created_item = /obj/item/clothing/neck/roguetown/bevor
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/sgorget
	name = "护喉, 钢"
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/iron/cursed_collar
	name = "次级诅咒项圈"
	created_item = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/steel/helmetsall
	name = "Sallet, 钢"
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetsallv
	name = "面罩 Sallet, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "桶盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetpig
	name = "猪脸盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmethounskull
	name = "猎犬颅头盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bascinet
	name = "尖顶盔, 钢"
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/etruscanbascinet
	name = "伊特鲁斯卡n 尖顶盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetknight
	name = "骑士头盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetarmet
	name = "Armet 头盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/slittedkettle
	name = "开缝圆盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/savoyard
	name = "Savoyard 头盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/bogman
	name = "沼人头盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/barredhelm
	name = "栅栏盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/beakhelm
	name = "鸟喙盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/helmetvolf
	name = "狼面盔, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
	i_type = "护甲"
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/plateboot
	name = "板甲靴, 钢"
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/steel/mailleboots
	name = "Maille Boots, Steel"
	created_item = /obj/item/clothing/shoes/roguetown/boots/maille
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/anvil_recipe/armor/steel/mask
	name = "面甲, 钢"
	created_item = /obj/item/clothing/mask/rogue/facemask/steel
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/steel/mask/hound
	name = "猎犬面甲, 钢"
	created_item = /obj/item/clothing/mask/rogue/facemask/steel/hound
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/steel/duelist
	name = "决斗者护目镜, 钢"
	created_item = /obj/item/clothing/mask/rogue/spectacles/duelist/steel
	createditem_num = 2
	display_category = ITEM_CAT_ARMOR_MASKS

/datum/anvil_recipe/armor/steel/astratahelm
	name = "阿斯特拉塔头盔 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/abyssorhelm
	name = "阿比索尔头盔 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/necrahelm
	name = "内克拉 头盔（+1 钢锭）"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/nochelm
	name = "诺克头盔 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/dendorhelm
	name = "登多尔头盔 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/frogmouth
	name = "Froggemund 头盔, 钢 (+2 钢)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/steel/belt
	name = "板甲腰带, 钢"
	created_item = /obj/item/storage/belt/rogue/leather/steel

/datum/anvil_recipe/armor/steel/belt/tasset
	name = "垂裙板甲腰带, 钢"
	created_item = /obj/item/storage/belt/rogue/leather/steel/tasset

/datum/anvil_recipe/armor/steel/splintarms
	name = "札甲 臂甲 (+1 皮臂甲)"
	additional_items = list(/obj/item/clothing/wrists/roguetown/bracers/leather)
	created_item = /obj/item/clothing/wrists/roguetown/splintarms
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/steel/splintlegs
	name = "札甲腿甲 (+1 皮裤)"
	additional_items = list(/obj/item/clothing/under/roguetown/trou/leather)//basically you just add a lot of iron bits to the pants
	created_item = /obj/item/clothing/under/roguetown/splintlegs
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/steel/barding
	name = "赛加羚马铠, 链甲 (+1 钢)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/chain

/datum/anvil_recipe/armor/steel/barding/fogbeast
	name = "雾兽马铠, 链甲 (+1 钢)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_plate
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/fogbeast/chain

// HOLY STEEL

/datum/anvil_recipe/armor/holysteel/astratahelmtemplar
	name = "阿斯特拉塔圣殿头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/malumhelmtemplar
	name = "玛勒姆圣殿头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/malum
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/necrahelmtemplar
	name = "内克拉 圣殿头盔（+1 鞣制皮革）"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/pestrahelmtemplar
	name = "佩斯特拉圣殿头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/eorahelmtemplar
	name = "伊欧拉圣殿头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/eoran
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/astratahelm
	name = "阿斯特拉塔头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/abyssorhelm
	name = "阿比索尔头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/necrahelm
	name = "内克拉 头盔（+1 鞣制皮革）"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/nochelm
	name = "诺克头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/dendorhelm
	name = "登多尔头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/ravoxhelm
	name = "拉沃克斯头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/xylixhelm
	name = "赛利克斯头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/holysteel/eorahelm
	name = "伊欧拉头盔 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/sallet/eoran
	display_category = ITEM_CAT_ARMOR_HELMETS

// SILVER

/datum/anvil_recipe/armor/silver/belt
	name = "板甲腰带, 白银"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/storage/belt/rogue/leather/plaquesilver


// BLESSED SILVER

/datum/anvil_recipe/armor/blessedsilver/psychestplate
	name = "普赛顿式 胸板甲 (+1 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer/psydon
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psycuirass
	name = "普赛顿式 胸甲 (+2 熟皮, +1 祝福白银)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/armetpsy
	name = "普赛顿式 Armet 头盔"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/greatplumearmetpsy
	name = "普赛顿式大翎羽阿米特盔"
	category = "祝福白银"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/psy/greatplume

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy
	name = "普赛顿式 Sallet (+1 祝福白银)"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy
	name = "普赛顿式 桶盔 (+1 祝福白银)"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/helmvolfpsy
	name = "Psydonic Volfskulle Bascinet"
	category = "Blessed Silver"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/psydonic

/datum/anvil_recipe/armor/blessedsilver/helmetabso
	name = "普赛多尼亚n 圆锥盔 (+2 祝福白银)"
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/absolver
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate
	name = "普赛顿式 半身板甲 (+普赛顿式 胸甲, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psyfullplate
	name = "普赛顿式 全身板甲 (+普赛顿式 半身板甲, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt
	name = "普赛顿式 全身板甲, 长身锁子甲ed (+普赛顿式 长身锁子甲, +2 祝福白银, +2 熟皮)"
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
	name = "板甲腰带, 黄金"
	created_item = /obj/item/storage/belt/rogue/leather/plaquegold

/datum/anvil_recipe/armor/decorated/mask
	name = "面甲, 黄金"
	created_item = /obj/item/clothing/mask/rogue/facemask/goldmask
	display_category = ITEM_CAT_ARMOR_MASKS

// GOLD

/datum/anvil_recipe/armor/gold/armet
	name = "金色骑士盔 (+1 金，+2 丝绸)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gold
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/armetcrown
	name = "金色骑士盔，王室 (+1 金，+2 丝绸，+1 多佩尔石)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gold/king
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/helmet
	name = "金色巴布塔盔 (+1 金，+2 丝绸)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/helmetcrown
	name = "金色巴布塔盔，王室 (+1 金，+2 丝绸，+1 多佩尔石)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold/king
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/gold/gorget
	name = "金色颈甲 (+1 金，+2 丝绸)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/neck/roguetown/gorget/gold
	display_category = ITEM_CAT_ARMOR_NECK

/datum/anvil_recipe/armor/gold/cuirass
	name = "金色胸甲 (+2 金，+2 丝绸)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/gold/cuirasshero
	name = "金色胸甲，英雄 (+2 金，+2 丝绸，+1 牛脂)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/reagent_containers/food/snacks/tallow)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold/heroic
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/gold/bracers
	name = "金色臂铠 (+1 金，+2 丝绸)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/gold
	display_category = ITEM_CAT_ARMOR_BRACERS

/datum/anvil_recipe/armor/gold/greaves
	name = "金色胫甲 (+1 金，+2 丝绸)"
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/gold
	display_category = ITEM_CAT_ARMOR_BOOTS

// BLACKSTEEL

/datum/anvil_recipe/armor/blacksteel/cuirass
	name = "胸甲, 黑钢 (+1 黑钢)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/modern/platechest
	name = "全身板甲, 黑钢 (+1 半身板甲, 黑钢, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_halfplate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/modern/blacksteel_full_plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/halfplatechest
	name = "半身板甲, 黑钢 (+1 胸甲, 黑钢, +2 熟皮)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_halfplate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/ancienthalfplatechest
	name = "古代 黑钢 Half Plate Armor (+2 黑钢, +1 熟革)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_halfplate/ancient
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/modern/plategloves
	name = "板甲手套, 黑钢"
	created_item = /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/blacksteel/modern/platelegs
	name = "板甲腿甲, 黑钢 (+1 黑钢)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/blacksteel/modern/armet
	name = "Armet 头盔, 黑钢 (+1 黑钢)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blacksteel/modern/plateboots
	name = "板甲靴, 黑钢"
	created_item = /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots
	display_category = ITEM_CAT_ARMOR_BOOTS

// BLACKSTEEL, ANCIENT

/datum/anvil_recipe/armor/blacksteel/platechest
	name = "古代 黑钢 Plate Armor (+3 黑钢)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_full_plate
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/blacksteel/platelegs
	name = "古代 黑钢 板甲腿甲 (+1 黑钢)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/under/roguetown/platelegs/blacksteel
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/anvil_recipe/armor/blacksteel/bucket
	name = "古代 黑钢 桶盔 (+1 黑钢)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/roguetown/helmet/blacksteel/bucket
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/blacksteel/plategloves
	name = "古代 黑钢 板甲手套"
	created_item = /obj/item/clothing/gloves/roguetown/blacksteel/plategloves
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/blacksteel/plateboots
	name = "古代 黑钢 板甲靴"
	created_item = /obj/item/clothing/shoes/roguetown/boots/blacksteel/plateboots
	display_category = ITEM_CAT_ARMOR_BOOTS
