/datum/anvil_recipe/weapons
	abstract_type = /datum/anvil_recipe/weapons
	appro_skill = /datum/skill/craft/weaponsmithing  // inheritance yay !!
	i_type = "武器"

/datum/anvil_recipe/weapons/ancient
	abstract_type = /datum/anvil_recipe/weapons/ancient
	req_bar = /obj/item/ingot/gilbranze
	craftdiff = SKILL_LEVEL_JOURNEYMAN // Steel equivalence

/datum/anvil_recipe/weapons/decrepit
	abstract_type = /datum/anvil_recipe/weapons/decrepit
	req_bar = /obj/item/ingot/decrepit
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/weapons/copper
	abstract_type = /datum/anvil_recipe/weapons/copper
	req_bar = /obj/item/ingot/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/weapons/bronze
	abstract_type = /datum/anvil_recipe/weapons/bronze
	req_bar = /obj/item/ingot/bronze
	craftdiff = SKILL_LEVEL_NOVICE //Situationally better than iron, but far more limited in terms of recipes and availability.

/datum/anvil_recipe/weapons/iron
	abstract_type = /datum/anvil_recipe/weapons/iron
	req_bar = /obj/item/ingot/iron
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/weapons/steel
	abstract_type = /datum/anvil_recipe/weapons/steel
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/weapons/decorated
	abstract_type = /datum/anvil_recipe/weapons/decorated
	craftdiff = SKILL_LEVEL_EXPERT
	req_bar = /obj/item/ingot/gold

/datum/anvil_recipe/weapons/silver
	abstract_type = /datum/anvil_recipe/weapons/
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/weapons/psy
	abstract_type = /datum/anvil_recipe/weapons/psy
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/holysteel
	abstract_type = /datum/anvil_recipe/weapons/holysteel
	req_bar = /obj/item/ingot/steelholy
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/blacksteel
	abstract_type = /datum/anvil_recipe/weapons/blacksteel
	req_bar = /obj/item/ingot/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/gold
	abstract_type = /datum/anvil_recipe/weapons/gold
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_LEGENDARY

// DECREPIT/ANCIENT ALLOY

/datum/anvil_recipe/weapons/ancient/flail/
	name = "远古连枷"
	created_item = /obj/item/rogueweapon/flail/sflail/ancient
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/decrepit/flail
	name = "破旧连枷"
	created_item = /obj/item/rogueweapon/flail/sflail/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/ancient/dagger
	name = "远古匕首"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/decrepit/dagger
	name = "破旧匕首"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/ancient/knuckles
	name = "远古指虎"
	created_item = /obj/item/rogueweapon/knuckles/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decrepit/knuckles
	name = "破旧指虎"
	created_item = /obj/item/rogueweapon/knuckles/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/ancient/shortsword
	name = "远古短剑"
	created_item = /obj/item/rogueweapon/sword/short/ancient
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decrepit/shortsword
	name = "破旧短剑"
	created_item = /obj/item/rogueweapon/sword/short/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/ancient/gladius
	name = "罗马式远古短剑"
	created_item = /obj/item/rogueweapon/sword/short/gladius/ancient
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decrepit/gladius
	name = "罗马式破旧短剑"
	created_item = /obj/item/rogueweapon/sword/short/gladius/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/ancient/khopesh
	name = "远古寇派什弯剑"
	created_item = /obj/item/rogueweapon/sword/sabre/ancient
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decrepit/khopesh
	name = "破旧寇派什弯剑"
	created_item = /obj/item/rogueweapon/sword/sabre/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/ancient/handaxe
	name = "远古斧"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/decrepit/handaxe
	name = "破旧斧"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/ancient/mace
	name = "远古钉头锤"
	created_item = /obj/item/rogueweapon/mace/steel/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decrepit/mace
	name = "破旧钉头锤"
	created_item = /obj/item/rogueweapon/mace/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/ancient/warhammer
	name = "远古战锤"
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decrepit/warhammer
	name = "破旧战锤"
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/ancient/tossblade
	name = "远古投刃 ×4"
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/decrepit/tossblade
	name = "残破投刃 ×4"
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient/decrepit
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/ancient/gsw
	name = "远古大剑，另需2块吉尔青铜锭"
	created_item = /obj/item/rogueweapon/greatsword/ancient
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze)
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decrepit/gsw
	name = "朽败大剑，另需2块朽败锭"
	created_item = /obj/item/rogueweapon/greatsword/ancient/decrepit
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/ingot/decrepit)
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/ancient/bardiche
	name = "远古长柄战斧，另需1根小原木、1块铁锭"
	created_item = /obj/item/rogueweapon/halberd/bardiche/ancient
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/decrepit/bardiche
	name = "朽败长柄战斧，另需1根小原木、1块铁锭"
	created_item = /obj/item/rogueweapon/halberd/bardiche/ancient/decrepit
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/ancient/grandmace
	name = "远古巨型钉头锤，另需1块吉尔青铜锭、1根小原木"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decrepit/grandmace
	name = "破旧巨型钉头锤，另需1块朽败锭、1根小原木"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/ancient/spear
	name = "远古长矛，另需1根小原木"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/ancient
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/decrepit/spear
	name = "朽败长矛，另需1根小原木"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/ancient/javelin
	name = "远古标枪 ×2，另需1根小原木"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/decrepit/javelin
	name = "破旧标枪 ×2，另需1根小原木"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient/decrepit
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO
// COPPER

/datum/anvil_recipe/weapons/copper/caxe
	name = "铜手斧，另需1块铜锭"
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/copper
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "铜棒，另需1根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel/copper
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/copper/cdagger
	name = "铜刀 ×2"
	created_item = /obj/item/rogueweapon/huntingknife/copper
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/copper/cmesser
	name = "铜猎剑"
	created_item = /obj/item/rogueweapon/sword/short/messer/copper
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/copper/cspears
	name = "铜矛 ×2，另需1根小原木"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/stone/copper
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/copper/crhomphaia
	name = "铜罗姆法亚弯剑，另需1块铜锭"
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia/copper
	display_category = ITEM_CAT_WEAPONS_SWORDS

// BRONZE

/datum/anvil_recipe/weapons/bronze/katar
	name = "青铜拳刃"
	created_item = /obj/item/rogueweapon/katar/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/axegauntlet
	name = "阿尔贝洛斯"
	created_item = /obj/item/rogueweapon/katar/bronze/gladiator
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "青铜指虎"
	created_item = /obj/item/rogueweapon/knuckles/bronzeknuckles
	display_category = ITEM_CAT_WEAPONS_MACES
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/bronze/gladius
	name = "短剑"
	created_item = /obj/item/rogueweapon/sword/short/gladius
	display_category = ITEM_CAT_WEAPONS_SWORDS
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/sword
	name = "青铜单手剑"
	created_item = /obj/item/rogueweapon/sword/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/sabre
	name = "寇派什弯刀"
	created_item = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/axe
	name = "青铜斧"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/bronze/doubleaxe
	name = "双头青铜斧，另需1块青铜锭"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronze/double
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/bronze/mace
	name = "青铜钉头锤"
	created_item = /obj/item/rogueweapon/mace/bronze
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/bronze/flail
	name = "青铜连枷"
	created_item = /obj/item/rogueweapon/flail/bronze
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/bronze/dagger
	name = "青铜匕首"
	created_item = /obj/item/rogueweapon/huntingknife/bronze
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/bronze/combatknife
	name = "西德阿姆，另需1块青铜锭"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/huntingknife/combat/bronze
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/bronze/falchion
	name = "科皮斯，另需1块青铜锭"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/sword/falchion/militia/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/messer
	name = "马凯拉短剑，另需1块青铜锭"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/sword/short/messer/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/battleaxe
	name = "青铜战斧，另需1块青铜锭"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/bronze/battlemace
	name = "青铜战棍，另需1块青铜锭"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/mace/warhammer/bronze
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/bronze/whip
	name = "青铜鞭，另需3张鞣制皮革"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/whip/bronze
	display_category = ITEM_CAT_WEAPONS_FLAILS
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/bronze/urumi
	name = "青铜软剑，另需1块青铜锭"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/whip/urumi/bronze
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/bronze/broadsword
	name = "斯帕塔长剑，另需1块青铜锭、1根小原木"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/broadsword/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/greatkhopesh
	name = "阿波菲斯，另需1块青铜锭、1根小原木"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/greatkhopesh
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/spear
	name = "青铜矛，另需1块青铜锭、1根小原木"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/bronze/spearwinged
	name = "青铜翼矛，另需1块青铜锭、1根小原木"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze/winged
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/greataxe
	name = "青铜巨斧，另需1块青铜锭、1根小原木"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/bronze
	display_category = ITEM_CAT_WEAPONS_AXES
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/javelin
	name = "青铜标枪 ×2，另需1根小原木"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item =  /obj/item/ammo_casing/caseless/rogue/javelin/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 2

/datum/anvil_recipe/weapons/bronze/trident
	name = "青铜三叉戟，另需1块青铜锭、1根小原木"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trident
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	craftdiff = 2

// IRON

/datum/anvil_recipe/weapons/iron/sword
	name = "铁单手剑"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/swordshort
	name = "铁短剑"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/messer
	name = "猎剑"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/messer/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/broadsword
	name = "阔剑，另需1块铁锭、1根小原木"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/broadsword

/datum/anvil_recipe/weapons/iron/shotel
	name = "铁索特尔弯刀，另需1块铁锭"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/shotel/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/sabre
	name = "铁军刀"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/sabre/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/urumi
	name = "铁软剑，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/whip/urumi/iron
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/dagger
	name = "铁匕首"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger
	createditem_num = 1
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/iron/flail
	name = "铁连枷"
	created_item = /obj/item/rogueweapon/flail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/huntknife
	name = "猎刀"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife
	createditem_num = 1
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/greatsword
	name = "铁制大剑，另需2块钢锭"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/claymore
	name = "克莱摩大剑，另需2块铁锭"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/zwei
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/handaxe
	name = "手斧，另需1根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/axe
	name = "伐木斧，另需1根木棍"
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/greataxe
	name = "巨斧，另需1块铁锭、1根小原木"
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/cudgel
	name = "警棍，另需1根木棍"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/mace
	name = "钉头锤，另需1根木棍"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/warhammer
	name = "战锤，另需1根木棍"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/spear
	name = "长矛，另需1根小原木"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/bardiche
	name = "长柄战斧，另需1块铁锭、1根小原木"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/bardiche
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/lucerne
	name = "卢塞恩锤，另需1块铁锭、1根小原木"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak/lucerne
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/polemace
	name = "古登达格棒，另需1根小原木"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/tossblade
	name = "铁制投刃 ×4"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/iron/javelin
	name = "铁标枪 ×2，另需1根小原木"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/iron/claws
	name = "铁猎犬爪，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/handclaw
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/iron/maul
	name = "大槌，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/mace/maul
	craftdiff = 4
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/peasantwarflail
	name = "民兵长连枷，另需1块铁锭、2根小原木"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/flail/peasantwarflail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/maciejowski
	name = "马切约夫斯基猎刀，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/falchion/militia
	display_category = ITEM_CAT_WEAPONS_SWORDS

/// STEEL WEAPONS
/datum/anvil_recipe/weapons/steel/dagger
	name = "钢匕首"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel
	createditem_num = 1
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/daggerparrying
	name = "钢制格挡匕首，另需1块钢锭"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/daggerrondel
	name = "圆盘匕首，另需1块钢锭"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/daggerkukri
	name = "库克里匕首，另需1块钢锭"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/kukri
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/daggerkris
	name = "波刃匕首，另需1块钢锭"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/kris
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/combatknife
	name = "赛克斯短刀"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/combat
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/combatknifemesser
	name = "战斗短刀，另需1块钢锭"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/combat/messer
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/katar
	name = "拳刃"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/punchdagger
	name = "冲拳匕首"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar/punchdagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/steelknuckle
	name = "钢指虎"
	created_item = /obj/item/rogueweapon/knuckles
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/hurlbat
	name = "投掷斧"
	req_blade = /obj/item/blade/steel_axe
	created_item = /obj/item/rogueweapon/stoneaxe/hurlbat
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/rapier
	name = "刺剑"
	created_item = /obj/item/rogueweapon/sword/rapier
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/cutlass
	name = "短弯刀"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/cutlass
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/swordshort
	name = "钢短剑"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/falchion
	name = "法刀"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/falchion
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/messer
	name = "钢猎剑"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/messer
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/sword
	name = "单手剑"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/saber
	name = "军刀"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/shamshir
	name = "沙姆希尔弯刀"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/shamshir
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/shashka
	name = "阿夫尼克的沙什卡"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/steppesman
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/flail
	name = "铁连枷"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/flail/sflail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/steel/peasantwarflail
	name = "巨型连枷，另需1块钢锭、2根小原木"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/flail/peasantwarflail/steel
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/steel/longsword
	name = "长剑，另需1块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/broadsword
	name = "钢制阔剑，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/broadsword/steel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/shalal
	name = "沙拉尔弯刀，另需1块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/marlin
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/shotel
	name = "钢索特尔弯刀，另需1块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/shotel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/urumi
	name = "软剑，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/whip/urumi
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "训练剑，另需1块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "训练剑，另需1块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/kriegmesser
	name = "双手大刀，另需1块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "战斧，另需1块钢锭"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/battle
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/mace
	name = "钢钉头锤，另需1块钢锭"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "钢战锤，另需1块钢锭"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/greatsword
	name = "大剑，另需2块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/flamb
	name = "钢制焰形剑，另需2块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/estoc
	name = "穿甲刺剑，另需1块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/estoc
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/axe
	name = "钢斧，另需1根木棍"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/woodcutter
	name = "伐木工斧，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/pulaski
	name = "普拉斯基斧，另需1根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/pick
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/greataxe
	name = "钢巨斧，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/greataxe/doublehead
	name = "双头钢巨斧，另需2块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel/doublehead
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/billhook
	name = "钩镰枪，另需1根小原木"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/billhook
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/halberd
	name = "戟斧，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "钢制卢塞恩锤，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/grandmace
	name = "巨型钉头锤，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/partizan
	name = "帕提赞长戟，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/partizan
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/boarspear
	name = "猎猪矛，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/boar
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/lance
	name = "骑枪，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/lance
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/tossblade
	name = "钢制投刃 ×4"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/javelin
	name = "钢标枪 ×2，另需1根小原木"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/steel/fishspear
	name = "渔叉，另需1块钢锭、1根小原木"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/fishspear
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/rhomphaia
	name = "罗姆法亚弯剑，另需1块钢锭"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/falx
	name = "法尔克斯弯刀"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/falx
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/claws
	name = "钢螳螂爪，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/handclaw/steel
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/maul
	name = "巨槌，另需2块钢锭"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/maul/grand
	craftdiff = 5
	display_category = ITEM_CAT_WEAPONS_MACES

/// UPGRADED WEAPONS

// GOLD

/datum/anvil_recipe/weapons/decorated/sword
	name = "华饰单手剑，另需1把单手剑"
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/saber
	name = "装饰军刀，另需1把军刀"
	additional_items = list(/obj/item/rogueweapon/sword/sabre)
	created_item = /obj/item/rogueweapon/sword/sabre/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/rapier
	name = "装饰刺剑，另需1把刺剑"
	additional_items = list(/obj/item/rogueweapon/sword/rapier)
	created_item = /obj/item/rogueweapon/sword/rapier/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/longsword
	name = "华饰长剑，另需1把长剑"
	additional_items = list(/obj/item/rogueweapon/sword/long)
	created_item = /obj/item/rogueweapon/sword/long/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/gladius
	name = "华丽短罗马剑，另需1把短剑"
	additional_items = list(/obj/item/rogueweapon/sword/short/gladius)
	created_item = /obj/item/rogueweapon/sword/short/gladius/decorated
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/warclub
	name = "装饰青铜战棍，另需1把青铜战棍"
	additional_items = list(/obj/item/rogueweapon/mace/warhammer/bronze)
	created_item = /obj/item/rogueweapon/mace/warhammer/bronze/decorated
	display_category = ITEM_CAT_WEAPONS_MACES
/datum/anvil_recipe/weapons/decorated/axe
	name = "装饰斧，另需1把钢斧"
	additional_items = list(/obj/item/rogueweapon/stoneaxe/woodcut/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/decorated

/datum/anvil_recipe/weapons/decorated/swordsil
	name = "华丽银制卡德加剑，另需1把白银单手剑"
	additional_items = list(/obj/item/rogueweapon/sword/silver)
	created_item = /obj/item/rogueweapon/sword/silver/decorated

/datum/anvil_recipe/weapons/decorated/macesil
	name = "装饰钉头锤，另需1把白银钉头锤"
	additional_items = list(/obj/item/rogueweapon/mace/steel/silver)
	created_item = /obj/item/rogueweapon/mace/steel/silver/decorated

// GOLD

/datum/anvil_recipe/weapons/gold/arming
	name = "黄金单手剑，另需2块金锭、2块丝绸"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/gold

/datum/anvil_recipe/weapons/gold/mace
	name = "黄金钉头锤，另需2块金锭、2块丝绸"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/mace/gold

/datum/anvil_recipe/weapons/gold/shield
	name = "黄金盾，另需3块金锭、1张毛皮"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/fur)
	created_item = /obj/item/rogueweapon/shield/tower/metal/gold

/datum/anvil_recipe/weapons/gold/kingarming
	name = "王室黄金单手剑，另需2块金锭、2块丝绸、1颗多佩尔石"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/roguegem/diamond)
	created_item = /obj/item/rogueweapon/sword/gold/king

/datum/anvil_recipe/weapons/gold/kingmace
	name = "皇家黄金钉头锤，另需2块金锭、2块丝绸、1颗多佩尔石"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/roguegem/diamond)
	created_item = /obj/item/rogueweapon/mace/gold/king

/datum/anvil_recipe/weapons/gold/kingshield
	name = "王室黄金盾，另需3块金锭、1张毛皮、1颗多佩尔石"
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/fur, /obj/item/roguegem/diamond)
	created_item = /obj/item/rogueweapon/shield/tower/metal/gold/king

// SILVER

/datum/anvil_recipe/weapons/silver/elfsaber
	name = "精灵军刀，另需1块金锭"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/rogueweapon/sword/sabre/elf
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/elfdagger
	name = "精灵匕首，另需1块银锭"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/silver/dagger
	name = "银匕首"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/silver/shortsword
	name = "白银短剑"
	created_item = /obj/item/rogueweapon/sword/short/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/sword
	name = "白银单手剑，另需1块银锭"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/sword
	name = "白银刺剑，另需1块银锭"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/rapier/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/longsword
	name = "白银长剑，另需2块银锭、1根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/broadsword
	name = "白银阔剑，另需2块银锭、1根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/exec
	name = "银制行刑剑，另需2块银锭、1根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/exe/silver

/datum/anvil_recipe/weapons/silver/waraxe
	name = "白银战斧，另需2块银锭、1根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/silver
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/silver/poleaxe
	name = "白银长柄斧，另需2块银锭、2根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/silver
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/silver/mace
	name = "白银钉头锤，另需1块银锭"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/mace/steel/silver
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/silver/warhammer
	name = "白银战锤，另需1块银锭、1根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/silver
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/silver/quarterstaff
	name = "银头长杖，另需1块银锭、3根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/woodstaff/quarterstaff/silver
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/silver/spear
	name = "银矛，另需1块银锭、3根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/silver
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/silver/morningstar
	name = "白银晨星连枷，另需1块银锭、1条锁链"
	additional_items = list(/obj/item/ingot/silver, /obj/item/rope/chain)
	created_item = /obj/item/rogueweapon/flail/sflail/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/peasantwarflail
	name = "白银巨型连枷，另需2块银锭、2根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/flail/peasantwarflail/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/whip
	name = "银鞭，另需1条皮鞭"
	additional_items = list(/obj/item/rogueweapon/whip)
	created_item = /obj/item/rogueweapon/whip/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/urumi
	name = "银软剑，另需1块银锭"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/whip/urumi/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/tossblade
	name = "银制投刃，另需1块银锭"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/silver
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/silver/javelin
	name = "白银标枪，另需1块银锭、1根小原木"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/silver
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO


/// SHIELDS

/datum/anvil_recipe/weapons/iron/towershield
	name = "塔盾，另需1根小原木"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shield/tower
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "鸢盾，另需1块钢锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/ancient/shield
	name = "远古盾，另需1块吉尔青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/ancient
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/decrepit/shield
	name = "破旧盾，另需1块朽败锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/ancient/shield
	name = "古旧圆盾，另需1块吉尔青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/rogueweapon/shield/gilbranze
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/decrepit/shield
	name = "朽败圆盾，另需1块朽败锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/rogueweapon/shield/gilbranze/decrepit
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/ancient/shield
	name = "古旧巨圆盾，另需1块吉尔青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/gilbranze/great
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/decrepit/shield
	name = "朽败巨圆盾，另需1块朽败锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/ingot/decrepit, /obj/item/ingot/decrepit, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/gilbranze/great/decrepit
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/steel/buckler
	name = "小圆盾，另需1块钢锭"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/shield/buckler
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/ancient/buckler
	name = "远古小圆盾，另需1块吉尔青铜锭"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/rogueweapon/shield/buckler/ancient
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/decrepit/buckler
	name = "破旧的小圆盾，另需1块吉尔青铜锭"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/rogueweapon/shield/buckler/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/iron/roundshield
	name = "铁盾，另需1块铁锭"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/shield/iron
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/bronze/bronzeshield
	name = "霍普隆盾，另需1块青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/bronze

/datum/anvil_recipe/weapons/bronze/bronzegreatshield
	name = "霍普隆巨盾，另需2块青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/bronze/great
	craftdiff = 2

// CROSSBOW

/datum/anvil_recipe/weapons/steel/xbow
	name = "十字弩，另需1根小原木、1份纤维"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/natural/fibers)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	display_category = ITEM_CAT_ENG_COMBAT

/datum/anvil_recipe/weapons/iron/bolts
	name = "弩矢 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/ancient/bolts
	name = "远古弩矢 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/ancient
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/decrepit/bolts
	name = "破旧弩矢 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/decrepit
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/iron/bluntbolts
	name = "训练弩矢 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/blunt
	createditem_num = 10
	i_type = "弹药"
	craftdiff = 1
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/iron/heavybluntbolts
	name = "重型钝头弩矢 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/bronze/bolts
	name = "青铜弩矢 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/bronze/bolts
	name = "青铜弩矢 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "弹药"

// BOW

/datum/anvil_recipe/weapons/iron/arrows
	name = "铁阔头箭 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/steel/arrows
	name = "钢锥头箭 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/ancient/arrows
	name = "远古锥头箭 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/decrepit/arrows
	name = "破旧阔头箭 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/bronze/arrows
	name = "青铜飞箭 ×10，另需2根木棍"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "弹药"

// SLING

/datum/anvil_recipe/weapons/iron/slingbullets
	name = "铁制投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/steel/slingbullets
	name = "钢制投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/steel
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/bronze/slingbullets
	name = "青铜投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	display_category = ITEM_CAT_WEAPONS_AMMO
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/silver/slingbullets
	name = "银制投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/silver
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/psy/slingbullets
	name = "祝圣银制投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/silverblessed
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/holysteel/slingbullets
	name = "神圣钢制投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/steelblessed
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/ancient/slingbullets
	name = "远古投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/decrepit/slingbullets
	name = "破旧投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/decrepit
	createditem_num = 10
	i_type = "弹药"
	display_category = ITEM_CAT_WEAPONS_AMMO

// UNIQUE

/datum/anvil_recipe/weapons/iron/execution
	name = "行刑长剑，另需2块铁锭"
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/exe
	craftdiff = 4
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/valuables/iron/rawheapofiron
	name = "生铁堆，另需4块铁矿石"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/rogueore/iron, /obj/item/rogueore/iron, /obj/item/rogueore/iron, /obj/item/rogueore/iron)
	created_item = /obj/item/ingot/component/heapofrawiron
	appro_skill = /datum/skill/craft/weaponsmithing
	craftdiff = 5
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/valuables/iron/berserkswordgrip
	name = "狂战士之剑的剑柄，另需1把行刑剑、2根小原木、2张鞣制皮革"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/rogueweapon/sword/long/exe, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/ingot/component/berserkswordgrip
	appro_skill = /datum/skill/craft/weaponsmithing
	craftdiff = 5
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/valuables/iron/berserkswordblade
	name = "狂战士之剑的剑刃，另需4块铁锭、1份生铁堆"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/component/heapofrawiron)
	created_item = /obj/item/ingot/component/berserkswordblade
	appro_skill = /datum/skill/craft/weaponsmithing
	craftdiff = 5
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/valuables/iron/berserksword
	name = "狂战士之剑，另需1件狂战士之剑的剑刃"
	req_bar = /obj/item/ingot/component/berserkswordgrip
	additional_items = list(/obj/item/ingot/component/berserkswordblade)
	created_item = /obj/item/rogueweapon/sword/long/exe/berserk
	appro_skill = /datum/skill/craft/weaponsmithing
	craftdiff = 5
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/valuables/iron/berserkswordalt
	name = "狂战士之剑，另需1件狂战士之剑的剑柄"
	req_bar = /obj/item/ingot/component/berserkswordblade
	additional_items = list(/obj/item/ingot/component/berserkswordgrip)
	created_item = /obj/item/rogueweapon/sword/long/exe/berserk
	appro_skill = /datum/skill/craft/weaponsmithing
	craftdiff = 5
	display_category = ITEM_CAT_WEAPONS_SWORDS

// BLACKSTEEL

/datum/anvil_recipe/weapons/blacksteel/arming
	name = "黑钢单手剑，另需1块黑钢锭、1颗蓝晶、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/violet, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/decsword
	name = "黑钢华饰单手剑，另需1把单手剑、1颗蓝晶、1块金锭、1块丝绸"
	additional_items = list(/obj/item/rogueweapon/sword, /obj/item/ingot/gold, /obj/item/roguegem/violet, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/decorated/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/longword
	name = "黑钢长剑，另需2块黑钢锭、1颗蓝晶、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/violet, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/long/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/flamberge
	name = "黑钢焰形剑，另需3块黑钢锭、1颗隆兹石、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/rapier
	name = "黑钢刺剑，另需1块黑钢锭、1颗翠晶、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/green, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/rapier/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/messer
	name = "黑钢猎剑，另需1块黑钢锭、1颗隆兹石、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/short/messer/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/lance
	name = "黑钢骑枪，另需2块黑钢锭、1颗翠晶、1根小原木、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/green, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/spear/lance/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/blacksteel/halberd
	name = "黑钢戟，另需3块黑钢锭、1颗石英、1根小原木、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/blue, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/halberd/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/blacksteel/Lucerne
	name = "黑钢卢塞恩锤，另需3块黑钢锭、1颗托珀石、1根小原木、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/yellow, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/eaglebeak/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/blacksteel/mace
	name = "黑钢钉头锤，另需2块黑钢锭、1颗托珀石、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/yellow, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/mace/blacksteel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/blacksteel/warhammer
	name = "黑钢战锤，另需2块黑钢锭、1颗托珀石、1根木棍"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/yellow, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer/blacksteel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/blacksteel/knuckles
	name = "黑钢指虎，另需1颗多佩尔石、1块丝绸"
	additional_items = list(/obj/item/roguegem/diamond, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/knuckles/blacksteel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/blacksteel/hurlbat
	name = "黑钢投战斧，另需1块丝绸"
	additional_items = list(/obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/stoneaxe/hurlbat/blacksteel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/blacksteel/axe
	name = "黑钢战斧，另需2块黑钢锭、1颗托珀石、1块丝绸、1根木棍"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/yellow, /obj/item/natural/silk, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/battle/blacksteel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/blacksteel/greataxe
	name = "黑钢巨斧，另需3块黑钢锭、1颗隆兹石、1根小原木、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/greataxe/blacksteel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/blacksteel/whip
	name = "黑钢鞭，另需1颗蓝晶、1条皮鞭、1块丝绸"
	additional_items = list(/obj/item/roguegem/violet, /obj/item/rogueweapon/whip, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/whip/blacksteel
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/blacksteel/urumi
	name = "黑钢软剑，另需1块黑钢锭、1颗蓝晶、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/violet, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/whip/urumi/blacksteel
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/blacksteel/flail
	name = "黑钢连枷，另需2块黑钢锭、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/flail/blacksteel
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/blacksteel/peasantwarflail
	name = "黑钢巨型连枷，另需2块黑钢锭、1根小原木、1颗隆兹石"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/flail/peasantwarflail/blacksteel
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/blacksteel/dagger
	name = "黑钢匕首，另需1颗隆兹石、1块丝绸"
	additional_items = list(/obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/blacksteel
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/blacksteel/misericorde
	name = "黑钢穿甲匕首，另需1块黑钢锭、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/blacksteel/heavy
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/blacksteel/tossblades
	name = "黑钢投刃 ×3，另需1块丝绸"
	additional_items = list(/obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/blacksteel
	createditem_num = 3
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/blacksteel/javelins
	name = "黑钢标枪 ×2，另需1块黑钢锭、1根小原木、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/blacksteel
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/blacksteel/bolts
	name = "黑钢弩矢 ×5，另需1根木棍、1块丝绸"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/natural/silk)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/blacksteel
	createditem_num = 5
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/blacksteel/arrows
	name = "黑钢箭 ×5，另需2根木棍、1块丝绸"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick, /obj/item/natural/silk)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/blacksteel
	createditem_num = 5
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/blacksteel/slingbullet
	name = "黑钢投石弹 ×10"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/blacksteel
	createditem_num = 10
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/blacksteel/shield
	name = "黑钢盾，另需2块黑钢锭、1颗隆兹石、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/shield/tower/metal/blacksteel
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/blacksteel/handclaws
	name = "黑钢鹰爪，另需1块黑钢锭、1颗多佩尔石、1块丝绸"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/diamond, /obj/item/natural/silk)//unarmed chuds get fucked
	created_item = /obj/item/rogueweapon/handclaw/blacksteel
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/blacksteel/quarterstaff
	name = "黑钢长杖，另需1块黑钢锭、3根小原木"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/blacksteel/spear
	name = "黑钢长矛，另需1块黑钢锭、1颗翠晶、2根小原木"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/green, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

//Church Weapons forged from Holy Steel

// HOLY STEEL

/datum/anvil_recipe/weapons/holysteel/church_longsword
	name = "圣座长剑"
	created_item = /obj/item/rogueweapon/sword/long/church
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/holysteel/church_spear
	name = "圣座长矛，另需1块圣钢锭"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/spear/holysee
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/holysteel/decasword
	name = "长剑，另需1块圣钢锭"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/sword/long/undivided
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/holysteel/decashield
	name = "圣座塔盾，另需1块圣钢锭"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/shield/tower/holysee
	display_category = ITEM_CAT_WEAPONS_SHIELDS

// BLESSED SILVER

/datum/anvil_recipe/weapons/psy/axe
	name = "普赛顿战斧，另需1块祝圣银锭、1根木棍"
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/psy/poleaxe
	name = "普赛顿长柄斧，另需2块祝圣银锭、1根小原木"
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/psy
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/psy/mace
	name = "普赛顿巨型钉头锤，另需1块祝圣银锭、1根小原木"
	created_item = /obj/item/rogueweapon/mace/goden/psy
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/psy/spear
	name = "普赛顿银矛，另需1块祝圣银锭、1根小原木"
	created_item = /obj/item/rogueweapon/spear/psyspear
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/psy/dagger
	name = "普赛顿匕首"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/psy/shortsword
	name = "普赛顿短剑"
	created_item = /obj/item/rogueweapon/sword/short/psy
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/psy/katar
	name = "普赛顿拳刃"
	created_item = /obj/item/rogueweapon/katar/psydon
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/psy/knuckles
	name = "普赛顿指虎"
	created_item = /obj/item/rogueweapon/knuckles/psydon
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/psy/cudgel
	name = "普赛顿手锤"
	created_item = /obj/item/rogueweapon/mace/cudgel/psy
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/psy/halberd
	name = "普赛顿戟斧，另需2块祝圣银锭、1根小原木"
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/psy/gsword
	name = "普赛顿大剑，另需2块祝圣银锭"
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/psy/sword
	name = "普赛顿长剑，另需1块祝圣银锭"
	created_item = /obj/item/rogueweapon/sword/long/psysword
	additional_items = list(/obj/item/ingot/silverblessed)
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/psy/exesword
	name = "普赛顿行刑剑，另需1块祝圣银锭"
	created_item = /obj/item/rogueweapon/sword/long/exe/psy
	additional_items = list(/obj/item/ingot/silverblessed)

/datum/anvil_recipe/weapons/psy/whip
	name = "普赛顿长鞭，另需3张鞣制皮革"
	created_item = /obj/item/rogueweapon/whip/psywhip_lesser
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/psy/urumi
	name = "普赛顿软剑，另需2块祝圣银锭"
	created_item = /obj/item/rogueweapon/whip/urumi/silver/psydonic
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)//3 blades so 1 more buillion over non-psydonite silver urumi
	display_category = ITEM_CAT_WEAPONS_FLAILS

/// BLESSED SILVER, BULLION VARIANTS - FALLBACK
//cutting out the duplicate variables so it's more clear what these subtypes actually do
/datum/anvil_recipe/weapons/psy/axe/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/poleaxe/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/mace/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/spear/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/dagger/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/shortsword/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/katar/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/knuckles/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/cudgel/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/halberd/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/gsword/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/sword/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/exesword/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/whip/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/urumi/inq
	req_bar = /obj/item/ingot/silverblessed/bullion
