/datum/crafting_recipe/roguetown/sewing
	abstract_type = /datum/crafting_recipe/roguetown/sewing
	display_category = ITEM_CAT_GARMENT_COMMON
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	subtype_reqs = TRUE		//For subtypes of fur

/* craftdif of 0 */

/datum/crafting_recipe/roguetown/sewing/headband
	name = "头带"
	result = list(/obj/item/clothing/head/roguetown/headband)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/allwrappings
	name = "布裹带"
	result = list(/obj/item/clothing/wrists/roguetown/allwrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/peasantcap
	name = "帽子"
	result = list(/obj/item/clothing/head/roguetown/armingcap)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/apron_waist
	name = "围裙"
	result = list(/obj/item/clothing/cloak/apron/waist)
	reqs = list(/obj/item/natural/cloth = 3) // 3 because it thas a storage, but it really just a apron.
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/apron/blacksmith
	name = "皮围裙"
	result = list(/obj/item/clothing/cloak/apron/blacksmith)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/rags
	name = "破布"
	result = list(/obj/item/clothing/suit/roguetown/shirt/rags)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/burial_shroud
	display_category = ITEM_CAT_TAILOR_MISC
	name = "裹尸布"
	result = list(/obj/item/burial_shroud)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/loincloth
	name = "兜裆布"
	result = list(/obj/item/clothing/under/roguetown/loincloth)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/brownloincloth
	name = "棕色兜裆布"
	result = list(/obj/item/clothing/under/roguetown/loincloth/brown)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/linedanklet
	display_category = ITEM_CAT_ARMOR_BOOTS
	name = "布衬脚环"
	result = list(/obj/item/clothing/shoes/roguetown/boots/clothlinedanklets)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/necramask
	name = "死者面具，重新组装"
	result = list(/obj/item/clothing/head/roguetown/necramask)
	reqs = list(/obj/item/clothing/head/roguetown/necrahood = 1,
				/obj/item/natural/bone = 1)
	craftdiff = 0
	display_category = ITEM_CAT_CLOTH_MASK

/* craftdif of 1 */

/datum/crafting_recipe/roguetown/sewing/clothgloves
	display_category = ITEM_CAT_ARMOR_GLOVES
	name = "露指手套"
	result = list(/obj/item/clothing/gloves/roguetown/fingerless)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/clothbedsheet
	display_category = ITEM_CAT_TAILOR_MISC
	name = "床单，布质"
	result = list(/obj/item/bedsheet/rogue/cloth)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/fabricbedsheet // cloth bedsheet's fancier looking cousin
	display_category = ITEM_CAT_TAILOR_MISC
	name = "床单，织物"
	result = list(/obj/item/bedsheet/rogue/fabric)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/doublefabricbedsheet
	display_category = ITEM_CAT_TAILOR_MISC
	name = "床单，双层织物"
	result = list(/obj/item/bedsheet/rogue/fabric_double)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/brimmed
	name = "宽沿帽"
	result = list(/obj/item/clothing/head/roguetown/brimmed)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/tunic
	name = "束衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/tunic/white)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/lowcut_shirt
	name = "低胸束腰衫"
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1)
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/noblecoat
	display_category = ITEM_CAT_GARMENT_FINE
	name = "华丽外套"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	reqs = list(/obj/item/natural/cloth = 3,
			/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/shadowshirt
	display_category = ITEM_CAT_GARMENT_FINE
	name = "丝质衬衣"
	result = /obj/item/clothing/suit/roguetown/shirt/shadowshirt
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/clothshirt
	name = "衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/clothtrou
	name = "工作裤"
	result = list(/obj/item/clothing/under/roguetown/trou)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/longcoat
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "长外套"
	result = list(/obj/item/clothing/suit/roguetown/armor/longcoat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/workervest
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "条纹束衣"
	result = list(/obj/item/clothing/suit/roguetown/armor/workervest)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/tights
	name = "紧身裤"
	result = list(/obj/item/clothing/under/roguetown/tights/random)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/Reyepatch
	display_category = ITEM_CAT_CLOTH_MASK
	name = "右眼眼罩"
	result = list(/obj/item/clothing/mask/rogue/eyepatch)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/Leyepatch
	display_category = ITEM_CAT_CLOTH_MASK
	name = "左眼眼罩"
	result = list(/obj/item/clothing/mask/rogue/eyepatch/left)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/knitcap
	name = "针织帽"
	result = list(/obj/item/clothing/head/roguetown/knitcap)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/strawhat
	name = "草帽"
	result = list(/obj/item/clothing/head/roguetown/strawhat)
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/sack
	display_category = ITEM_CAT_CLOTH_MASK
	name = "麻袋兜帽"
	result = list(/obj/item/clothing/head/roguetown/menacing)
	reqs = list(/obj/item/natural/cloth = 3,)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/paddedmask
	name = "软垫面罩"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/facemask/padded)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/basichood
	name = "兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/lgambeson
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "轻型棉甲"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/light)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/clothblindfold
	display_category = ITEM_CAT_CLOTH_MASK
	name = "蒙眼布"
	result = list(/obj/item/clothing/mask/rogue/blindfold)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/duelmask
	display_category = ITEM_CAT_CLOTH_MASK
	name = "决斗者面具"
	result = list(/obj/item/clothing/mask/rogue/duelmask)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/paddedcoif
	name = "加衬护头巾"
	result = list(/obj/item/clothing/neck/roguetown/coif/padded)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/woolencollar
	name = "羊毛领"
	category = "护头巾"
	result = list(/obj/item/clothing/neck/roguetown/collar/woolen)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/gbandages
	name = "绑带，需手套"
	result = list(/obj/item/clothing/gloves/roguetown/bandages)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/scarf
	name = "围巾，需1份纤维、1块布料"
	result = list(/obj/item/clothing/head/roguetown/scarf)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/breechclothbelt
	name = "缠腰布腰带"
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/breechclothbeltalt
	name = "缠腰布腰带，黑色"
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/breechclothbeltimprovised
	name = "缠腰布腰带，简易"
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth)
	tools = list(/obj/item/rogueweapon/huntingknife)
	reqs = list(
		/obj/item/clothing/cloak/tabard = 1,
		/obj/item/storage/belt/rogue/leather = 1
	)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/breechclothbeltaltimprovised
	name = "缠腰布腰带，黑色，简易"
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt)
	tools = list(/obj/item/rogueweapon/huntingknife)
	reqs = list(
		/obj/item/clothing/cloak/tabard = 1,
		/obj/item/storage/belt/rogue/leather/black = 1
	)
	craftdiff = 1

/* craftdif of 2+ */

/datum/crafting_recipe/roguetown/sewing/wrappings
	display_category = ITEM_CAT_ARMOR_BRACERS
	name = "太阳裹带"
	result = list(/obj/item/clothing/wrists/roguetown/wrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nocwrappings
	display_category = ITEM_CAT_ARMOR_BRACERS
	name = "月亮裹带"
	result = list(/obj/item/clothing/wrists/roguetown/nocwrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nunveil
	display_category = ITEM_CAT_CLOTH_MASK
	name = "修女面纱"
	result = list(/obj/item/clothing/head/roguetown/nun)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nunhabit
	name = "修女服"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/nun)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/necramask
	display_category = ITEM_CAT_CLOTH_MASK
	name = "死者面具"
	result = list(/obj/item/clothing/head/roguetown/necramask)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/bone = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/gweightedbandagesalt
	name = "绑带制成加重绑带，需手套"
	result = list(/obj/item/clothing/gloves/roguetown/bandages/weighted)
	reqs = list(/obj/item/clothing/gloves/roguetown/bandages = 1,
				/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bandage
	name = "缝纺绑带"
	result = list(/obj/item/natural/cloth/bandage)
	reqs = list(/obj/item/natural/silk = 2,
				/obj/item/natural/cloth = 1)

/datum/crafting_recipe/roguetown/sewing/gweightedbandages
	name = "加重绑带，需手套"
	result = list(/obj/item/clothing/gloves/roguetown/bandages/weighted)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/clothpaddedfootwraps
	name = "衬垫裹脚布"
	category = "Boots"
	result = list(/obj/item/clothing/shoes/roguetown/boots/footwraps/padded)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/coif
	display_category = ITEM_CAT_ARMOR_NECK
	name = "护头巾"
	result = list(/obj/item/clothing/neck/roguetown/coif)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/tabard
	name = "战袍"
	result = list(/obj/item/clothing/cloak/tabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/whitetabard
	name = "另一款战袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard
	name = "罩袍"
	result = list(/obj/item/clothing/cloak/stabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/abyssortemplartabard
	name = "战袍，阿比索尔圣殿骑士"
	result = list(/obj/item/clothing/cloak/abyssortabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/psydon
	name = "战袍，普赛顿"
	result = list(/obj/item/clothing/cloak/templar/psydon)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/psydon
	name = "战袍，普赛顿 正统派"
	result = list(/obj/item/clothing/cloak/psydontabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/astrata
	name = "战袍，阿斯特拉塔"
	result = list(/obj/item/clothing/cloak/templar/astrata)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/noc
	name = "战袍，诺克"
	result = list(/obj/item/clothing/cloak/templar/noc)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/dendor
	name = "战袍，登多尔"
	result = list(/obj/item/clothing/cloak/templar/dendor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/necra
	name = "战袍，内克拉"
	result = list(/obj/item/clothing/cloak/templar/necra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/abyssor
	name = "战袍，阿比索尔"
	result = list(/obj/item/clothing/cloak/templar/abyssor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/malum
	name = "战袍，玛勒姆"
	result = list(/obj/item/clothing/cloak/templar/malum)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/eora
	name = "战袍，伊欧拉"
	result = list(/obj/item/clothing/cloak/templar/eora)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/pestra
	name = "战袍，佩斯特拉圣殿骑士"
	result = list(/obj/item/clothing/cloak/templar/pestra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/pestran
	name = "战袍，佩斯特拉"
	result = list(/obj/item/clothing/cloak/templar/pestran)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/ravox
	name = "战袍，拉沃克斯"
	result = list(/obj/item/clothing/cloak/cleric/ravox)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/ravoxtemplar
	name = "战袍，拉沃克斯圣殿骑士"
	result = list(/obj/item/clothing/cloak/templar/ravox)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/ravoxgorget
	name = "拉沃克斯护颈"
	result = list(/obj/item/clothing/head/roguetown/roguehood/ravoxgorget)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/xylix
	name = "战袍，赛利克斯"
	result = list(/obj/item/clothing/cloak/templar/xylix)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/xylixian
	name = "战袍，赛利克斯圣殿骑士"
	result = list(/obj/item/clothing/cloak/templar/xylixian)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard/guard
	name = "罩袍，卫兵"
	result = list(/obj/item/clothing/cloak/stabard/guard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard/bog
	name = "罩袍，沼泽"
	result = list(/obj/item/clothing/cloak/stabard/bog)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard/guardhood
	name = "卫兵兜帽"
	result = list(/obj/item/clothing/cloak/stabard/guardhood)

/datum/crafting_recipe/roguetown/sewing/poncho
	name = "布制披衫"
	result = /obj/item/clothing/cloak/poncho
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/robe
	name = "长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/basiceast
	name = "简式道袍"
	result = list(/obj/item/clothing/suit/roguetown/armor/basiceast)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/decorative_mentorsuit
	name = "装饰性导师道袍"
	result = list(/obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit/decorative)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/decorative_captainrobe
	name = "装饰性花纹长袍"
	result = list(/obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe/decorative)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/jesterchest
	name = "小丑上衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/jester)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/jesterhead
	name = "小丑帽"
	result = list(/obj/item/clothing/head/roguetown/jester)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/jingle_bells = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/jestershoes
	name = "小丑鞋"
	result = list(/obj/item/clothing/shoes/roguetown/jester)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/jingle_bells = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/bardress
	name = "酒吧连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/stockdress
	name = "简约连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

//datum/crafting_recipe/roguetown/sewing/Bladress
//	name = "black dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/black)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

//datum/crafting_recipe/roguetown/sewing/Bludress
//	name = "blue dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

//datum/crafting_recipe/roguetown/sewing/Purdress
//	name = "purple dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/slitdress
	name = "开叉连衣裙"
	category = "连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/slit)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/fancyhat
	display_category = ITEM_CAT_GARMENT_FINE
	name = "华丽帽子"
	result = list(/obj/item/clothing/head/roguetown/fancyhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/gambeson
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "绗缝护甲衣"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/armingjacket
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "武装短衣"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/paddedcap
	display_category = ITEM_CAT_ARMOR_HELMETS
	name = "衬垫帽"
	result = /obj/item/clothing/head/roguetown/paddedcap
	reqs = list(/obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/bardhat
	name = "吟游诗人帽"
	result = list(/obj/item/clothing/head/roguetown/bardhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/bucklehat
	name = "折帽"
	result = list(/obj/item/clothing/head/roguetown/bucklehat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/puritanhat
	name = "清教徒扣带帽"
	result = list(/obj/item/clothing/head/roguetown/puritan)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/nurseveil
	name = "护士面纱"
	result = list(/obj/item/clothing/head/roguetown/veiled)
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1
	)
	craftdiff = 2
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/archer
	name = "弓箭手帽"
	result = list(/obj/item/clothing/head/roguetown/archercap)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/duelist
	name = "决斗者帽"
	result = list(/obj/item/clothing/head/roguetown/duelhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/witchhat
	name = "女巫帽"
	result = list(/obj/item/clothing/head/roguetown/witchhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/hgambeson
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "加衬棉甲"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/monkwraps
	name = "加衬臂裹带"
	result = list(/obj/item/clothing/wrists/roguetown/bracers/cloth/monk)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/monkheadband
	name = "加衬头带"
	result = list(/obj/item/clothing/head/roguetown/headband/monk)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/heavypadded
	name = "重型加衬护头巾"
	result = list(/obj/item/clothing/neck/roguetown/coif/heavypadding)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/hgambeson/fencer
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "加垫击剑衬衣"
	result = /obj/item/clothing/suit/roguetown/shirt/freifechter
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/silk = 2)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/chaperon
	name = "风帽"
	result = list(/obj/item/clothing/head/roguetown/chaperon)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/chaperon/noble
	display_category = ITEM_CAT_GARMENT_FINE
	name = "贵族风帽"
	result = list(/obj/item/clothing/head/roguetown/chaperon/noble)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/jupon
	name = "无袖短罩袍"
	result = list(/obj/item/clothing/cloak/stabard/surcoat)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/cotehardie
	name = "修身外套"
	result = list(/obj/item/clothing/cloak/cotehardie)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/armordress
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "加衬连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/armor/armordress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/ragmask
	display_category = ITEM_CAT_CLOTH_MASK
	name = "破布面罩"
	result = list(/obj/item/clothing/mask/rogue/ragmask)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0
	sellprice = 3

/datum/crafting_recipe/roguetown/sewing/cape
	name = "斗篷"
	result = list(/obj/item/clothing/cloak/cape)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/sexydress
	name = "透纱连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 3)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/wizhatblue
	name = "蓝色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatred
	name = "红色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat/red)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatyellow
	name = "黄色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat/yellow)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatgreen
	name = "绿色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat/green)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatblack
	name = "黑色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat/black)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/cape/desert
	name = "沙漠斗篷"
	result = list(/obj/item/clothing/cloak/cape/crusader)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/cape/rider
	name = "骑手斗篷"
	result = list(/obj/item/clothing/cloak/half/rider)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/cape/half
	name = "短斗篷"
	result = list(/obj/item/clothing/cloak/half)
	reqs = list(/obj/item/natural/silk = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undervestments
	name = "内礼服"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/priest)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/keffiyeh
	name = "库菲耶"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/hijab
	name = "希贾布"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal/hijab)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/heavyhood
	name = "重型兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/royalgown
	display_category = ITEM_CAT_GARMENT_FINE
	name = "皇家礼袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 45

/datum/crafting_recipe/roguetown/sewing/royaldress
	display_category = ITEM_CAT_GARMENT_FINE
	name = "无瑕礼裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal/princess)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/royalshirt
	display_category = ITEM_CAT_GARMENT_FINE
	name = "镀金礼服衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal/prince)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/regalrobes
	display_category = ITEM_CAT_GARMENT_FINE
	name = "皇家丝袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/vampire)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/grenzelshirt
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "格伦泽尔霍夫特胯衫"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/silktunic
	display_category = ITEM_CAT_GARMENT_FINE
	name = "精美丝质束衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/silkdress
	display_category = ITEM_CAT_GARMENT_FINE
	name = "精美丝质连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/velvetdress
	name = "天鹅绒连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/velvet)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/nobledress
	name = "贵族连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/noble)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 35

///Ported Steward and Hand sprites from vanderlin///
/datum/crafting_recipe/roguetown/sewing/stewarddress
	name = "华丽深色连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/steward)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/stewardtailcoat
	name = "华丽深色燕尾服"
	result = list(/obj/item/clothing/suit/roguetown/shirt/coat/steward)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/handcoat
	name = "贵族外套"
	result = list(/obj/item/clothing/suit/roguetown/shirt/coat/hand)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 40

/datum/crafting_recipe/roguetown/sewing/fancyshirt

	name= "贵族衬衫"
	result = list(/obj/item/clothing/suit/roguetown/shirt/noble/hand)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 45

/datum/crafting_recipe/roguetown/sewing/archivist
	name = "学者长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/archivist)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/apothshirt
	name = "药剂师衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/apothshirt)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/artificer
	name = "修补匠短上衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/winterdress
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "冬装连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/armor/armordress/winterdress)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/winterdress_light
	name = "御寒连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/winterdress_light)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/skirt
	name = "裙子"
	result = list(/obj/item/clothing/under/roguetown/skirt)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/sailorspants
	name = "水手裤"
	result = list(/obj/item/clothing/under/roguetown/tights/sailor)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/sailorshirt_colored
	name = "可染色条纹衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/colored)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/grenzelpants
	name = "格伦泽尔霍夫特的蓬裤"
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/shadowpants
	display_category = ITEM_CAT_GARMENT_FINE
	name = "丝质紧身裤"
	result = list(/obj/item/clothing/under/roguetown/trou/shadowpants)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 18

/datum/crafting_recipe/roguetown/sewing/apothpants
	name = "药剂师裤子"
	result = list(/obj/item/clothing/under/roguetown/trou/apothecary)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/royalsleeves
	display_category = ITEM_CAT_ARMOR_BRACERS
	name = "皇家护袖"
	result = list(/obj/item/clothing/wrists/roguetown/royalsleeves)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 19

/datum/crafting_recipe/roguetown/sewing/nemes
	name = "尼梅斯头巾"
	result = list(/obj/item/clothing/head/roguetown/headdress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/hatfur
	name = "皮毛帽"
	result = list(/obj/item/clothing/head/roguetown/hatfur)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/shawl
	name = "披巾"
	result = list(/obj/item/clothing/head/roguetown/shawl)
	reqs = list(/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/grenzelhat
	name = "格伦泽尔霍夫特的帽子"
	result = list(/obj/item/clothing/head/roguetown/grenzelhofthat)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/articap
	name = "工匠帽"
	result = list(/obj/item/clothing/head/roguetown/articap)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/lordlycloak
	display_category = ITEM_CAT_GARMENT_FINE
	name = "贵胄斗篷"
	result = list(/obj/item/clothing/cloak/lordcloak)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/fur = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 35

/datum/crafting_recipe/roguetown/sewing/naledisash
	name = "圣师绶带"
	result = list(/obj/item/clothing/cloak/hierophant)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/ladycloak
	display_category = ITEM_CAT_GARMENT_FINE
	name = "淑女短斗篷"
	result = list(/obj/item/clothing/cloak/lordcloak/ladycloak)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/furovercoat
	display_category = ITEM_CAT_GARMENT_FINE
	name = "毛皮大衣"
	result = list(/obj/item/clothing/cloak/black_cloak)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 22

/datum/crafting_recipe/roguetown/sewing/guildedjacket
	name = "商人短衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/merchant)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 19

/datum/crafting_recipe/roguetown/sewing/buttonedlongcoat
	name = "瘫疫外套"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/physician)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/desertgown
	name = "圣师坎迪斯袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/hierophant)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 17

/datum/crafting_recipe/roguetown/sewing/halfrobe
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "圣师披巾"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/monkrobe
	name = "教宗卡巴袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/pointfex)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/otavangambeson
	display_category = ITEM_CAT_ARMOR_LIGHT
	name = "奥塔万棉甲"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan)
	reqs = list(/obj/item/natural/cloth = 5,
				/obj/item/natural/silk = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/sleevelessrobephys
	name = "医师长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/phys)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/sleevelessrobefeld
	name = "军医长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/feld)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/hoodphys
	name = "医师兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/phys)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/hoodfeld
	name = "军医兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/feld)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/weddingdress
	display_category = ITEM_CAT_GARMENT_FINE
	name = "婚礼丝质连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 40

/datum/crafting_recipe/roguetown/sewing/silkydress
	display_category = ITEM_CAT_GARMENT_FINE
	name = "柔缎长裙"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 3)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 50

/datum/crafting_recipe/roguetown/sewing/weaving/springgown
	display_category = ITEM_CAT_GARMENT_FINE
	name = "春日礼裙"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 6
	sellprice = 85

/datum/crafting_recipe/roguetown/sewing/weaving/summergown
	display_category = ITEM_CAT_GARMENT_FINE
	name = "夏日礼裙"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	reqs = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3)
	craftdiff = 6
	sellprice = 70

/datum/crafting_recipe/roguetown/sewing/weaving/fallgown
	display_category = ITEM_CAT_GARMENT_FINE
	name = "秋日礼裙"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown
	reqs = list(/obj/item/natural/fibers = 3,
				/obj/item/natural/silk = 2,
				/obj/item/natural/cloth = 2)
	craftdiff = 6
	sellprice = 75

/datum/crafting_recipe/roguetown/sewing/weaving/wintergown
	display_category = ITEM_CAT_GARMENT_FINE
	name = "冬日礼裙"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	reqs = list(/obj/item/natural/fibers = 3,
				/obj/item/natural/silk = 2,
				/obj/item/natural/fur = 1)
	craftdiff = 6
	sellprice = 90

/datum/crafting_recipe/roguetown/sewing/exoticsilkbra
	display_category = ITEM_CAT_GARMENT_FINE
	name = "异域丝质胸衣"
	result = list (/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/anklets
	display_category = ITEM_CAT_ARMOR_BOOTS
	name = "异域丝质脚环"
	result = list (/obj/item/clothing/shoes/roguetown/anklets)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/exoticsilkbelt
	display_category = ITEM_CAT_ARMOR_BELTS
	name = "异域丝质腰带"
	result = list (/obj/item/storage/belt/rogue/leather/exoticsilkbelt)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/exoticsilkmask
	display_category = ITEM_CAT_CLOTH_MASK
	name = "异域丝质面罩"
	result = list (/obj/item/clothing/mask/rogue/exoticsilkmask)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/strapless_dress
	name = "无肩带连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/strapless_dress_alt
	name = "另一款抹胸连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

// -- Caparisons
/datum/crafting_recipe/roguetown/sewing/caparison
	name = "鞍饰毯"
	result = list(/obj/item/caparison)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/caparison/psy
	name = "普赛顿鞍饰毯"
	result = list(/obj/item/caparison/psy)

/datum/crafting_recipe/roguetown/sewing/caparison/astrata
	name = "阿斯特拉塔鞍饰毯"
	result = list(/obj/item/caparison/astrata)

/datum/crafting_recipe/roguetown/sewing/caparison/eora
	name = "伊欧拉鞍饰毯"
	result = list(/obj/item/caparison/eora)

/datum/crafting_recipe/roguetown/sewing/caparison/fogbeast
	name = "雾兽鞍饰毯"
	result = list(/obj/item/caparison/fogbeast)

// -- Barding
/datum/crafting_recipe/roguetown/sewing/barding
	name = "赛加羚衬垫坐骑甲"
	category = "Misc"
	result = list(/obj/item/clothing/barding)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/barding/fogbeast
	name = "雾兽衬垫坐骑甲"
	result = list(/obj/item/clothing/barding/fogbeast)

/datum/crafting_recipe/roguetown/sewing/paperparasol
	name = "纸伞"
	result = list(/obj/item/rogueweapon/mace/parasol)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/paper/scroll = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/spellsingerrobes
	display_category = ITEM_CAT_GARMENT_FINE
	name = "咒歌者长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/spellsingerhat
	display_category = ITEM_CAT_GARMENT_FINE
	name = "咒歌者帽"
	result = list(/obj/item/clothing/head/roguetown/spellcasterhat)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/beekeeper
	display_category = ITEM_CAT_CLOTH_MASK
	name = "养蜂人兜帽"
	result = list(/obj/item/clothing/head/roguetown/beekeeper)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 4)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bandithood
	name = "自由之人兜帽"
	result = list(/obj/item/clothing/head/roguetown/menacing/bandit)
	reqs = list(/obj/item/natural/cloth = 1)

/datum/crafting_recipe/roguetown/sewing/shroudwhite
	name = "白色罩巾"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shroudwhite)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/surgicalbag
	display_category = ITEM_CAT_TAILOR_MISC
	name = "外科包"
	result = list(/obj/item/storage/belt/rogue/surgery_bag/empty)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/surgcollar
	display_category = ITEM_CAT_ARMOR_NECK
	name = "外科颈圈"
	result = list(/obj/item/clothing/neck/roguetown/collar/surgcollar)
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/battleskirt
	name = "布质军裙"
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/fauldedbelt
	name = "带甲片的腰带"
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/faulds)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/reinforced_hood
	name = "加固兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/reinforced)
	reqs = list(
		/obj/item/clothing/head/roguetown/roguehood = 1,
		/obj/item/natural/cloth = 6,
		/obj/item/natural/silk = 1,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/fineparasol
	name = "精美阳伞"
	result = list(/obj/item/rogueweapon/mace/parasol/noble)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 4,
				/obj/item/paper/scroll = 2)
	craftdiff = 5
	sellprice = 45

// Maid Clothes //
/datum/crafting_recipe/roguetown/sewing/maidband
	name = "女仆头带"
	result = list(/obj/item/clothing/head/roguetown/maidband)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/servantdress
	name = "侍者连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/maid/servant)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/maidapron
	name = "女仆围裙"
	result = /obj/item/clothing/cloak/apron/maid
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/formalshirt
	display_category = ITEM_CAT_GARMENT_FINE
	name = "正装衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/formal)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/trousershorts
	name = "短裤"
	result = list(/obj/item/clothing/under/roguetown/trou/formal/shorts)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/maiddress
	name = "女仆装"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/maid)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/tailcoat
	display_category = ITEM_CAT_ARMOR_LIGHT
	name =  "燕尾服"
	result = list(/obj/item/clothing/armor/gambeson/tailcoat)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/formaltrousers
	display_category = ITEM_CAT_GARMENT_FINE
	name = "正装裤"
	result = list(/obj/item/clothing/under/roguetown/trou/formal)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/cloak_absolutionistrobe_black
	name = "blessed robe"
	result = /obj/item/clothing/cloak/absolutionistrobe/black
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_apron_waist_maid
	name = "maid apron"
	result = /obj/item/clothing/cloak/apron/waist/maid
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_bishop
	name = "bishop cape"
	result = /obj/item/clothing/cloak/bishop
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/cloak_cape_inquisitorgold
	name = "golden order cloak"
	result = /obj/item/clothing/cloak/cape/inquisitorgold
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_cape_inquisitorsilver
	name = "silver order cloak"
	result = /obj/item/clothing/cloak/cape/inquisitorsilver
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_etrcape
	name = "wanderer's cape"
	result = /obj/item/clothing/cloak/etrcape
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/cloak_half_duelcape
	name = "duelist cape"
	result = /obj/item/clothing/cloak/half/duelcape
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/cloak_half_shadowcloak_spymaster
	name = "hand's cloak"
	result = /obj/item/clothing/cloak/half/shadowcloak/spymaster
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/cloak_poncho_fancycoat
	name = "fancy coat"
	result = /obj/item/clothing/cloak/poncho/fancycoat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/cloak_poncho_fancycoat_trimmed
	name = "trimmed fancy coat"
	result = /obj/item/clothing/cloak/poncho/fancycoat/trimmed
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/cloak_rangercloak
	name = "ranger cloak"
	result = /obj/item/clothing/cloak/rangercloak
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_sash
	name = "sash"
	result = /obj/item/clothing/cloak/sash
	reqs = list(/obj/item/natural/cloth = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 0
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_sash_dupatta
	name = "dupatta"
	result = /obj/item/clothing/cloak/sash/dupatta
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_scaledcloak
	name = "scaled cloak"
	result = /obj/item/clothing/cloak/scaledcloak
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_scout
	name = "scout cloak"
	result = /obj/item/clothing/cloak/scout
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_sheriff
	name = "sheriff's cloak"
	result = /obj/item/clothing/cloak/sheriff
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_sleevedtabard
	name = "sleeved tabard"
	result = /obj/item/clothing/cloak/sleevedtabard
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_psydontabard_black
	name = "blessed tabard"
	result = /obj/item/clothing/cloak/tabard/psydontabard/black
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_psydontabard_white
	name = "traditional tabard"
	result = /obj/item/clothing/cloak/tabard/psydontabard/white
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_psydontabard_white_alt
	name = "opened traditional tabard"
	result = /obj/item/clothing/cloak/tabard/psydontabard/white/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader
	name = "surcoat of the golden order"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_astrata
	name = "surcoat of the golden order (astrata)"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/astrata
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_bsteel
	name = "surcoat of the blacksteel order"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/bsteel
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_heavy
	name = "overvestments"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/heavy
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_t
	name = "surcoat of the silver order"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/t
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_t_astrata
	name = "surcoat of the silver order (astrata)"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_t_see
	name = "surcoat of the silver order (see)"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/t/see
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_see
	name = "surcoat of the golden order (see)"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/see
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_surcoat_short
	name = "short jupon"
	result = /obj/item/clothing/cloak/tabard/stabard/surcoat/short
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_toga
	name = "toga"
	result = /obj/item/clothing/cloak/tabard/toga
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_toga_alt
	name = "bared toga"
	result = /obj/item/clothing/cloak/tabard/toga/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_toga_dress
	name = "toga (dress)"
	result = /obj/item/clothing/cloak/tabard/toga/dress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_toga_dress_alt
	name = "bared toga (alt)"
	result = /obj/item/clothing/cloak/tabard/toga/dress/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_templar_astratancleric
	name = "astratan cloak"
	result = /obj/item/clothing/cloak/templar/astratancleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_templar_astratancleric_grey
	name = "frayed cloak"
	result = /obj/item/clothing/cloak/templar/astratancleric/grey
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_templar_eoran_alt
	name = "eoran tabard"
	result = /obj/item/clothing/cloak/templar/eoran/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_templar_necrancleric
	name = "necran cloak"
	result = /obj/item/clothing/cloak/templar/necrancleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_templar_ravoxcleric
	name = "justice cloak"
	result = /obj/item/clothing/cloak/templar/ravoxcleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_templar_see_alt
	name = "see templar tabard"
	result = /obj/item/clothing/cloak/templar/see_alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_templar_seecleric
	name = "see devotee tabard"
	result = /obj/item/clothing/cloak/templar/seecleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_desert
	name = "desert cloak"
	result = /obj/item/clothing/cloak/desert
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/cloak_elven
	name = "elven cloak"
	result = /obj/item/clothing/cloak/elven
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/cloak_elven_short
	name = "elven shortcloak"
	result = /obj/item/clothing/cloak/elven/short
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/cloak_scarf
	name = "scarf"
	result = /obj/item/clothing/cloak/scarf
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_antlers
	name = "old antlers"
	result = /obj/item/clothing/head/roguetown/antlers
	reqs = list(/obj/item/natural/bone = 2, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_courtphysician
	name = "sanguine hat"
	result = /obj/item/clothing/head/roguetown/courtphysician
	reqs = list( /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_courtphysician_female
	name = "sanguine cap"
	result = /obj/item/clothing/head/roguetown/courtphysician/female
	reqs = list( /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_deserthood
	name = "desert hood"
	result = /obj/item/clothing/head/roguetown/deserthood
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_doublehennin
	name = "dual hennin"
	result = /obj/item/clothing/head/roguetown/doublehennin
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_duelhat_etrhat
	name = "wanderer's hat"
	result = /obj/item/clothing/head/roguetown/duelhat/etrhat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/head_roguetown_duelhat_etrusca
	name = "etruscan duelist hat"
	result = /obj/item/clothing/head/roguetown/duelhat/etrusca
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/head_roguetown_durag
	name = "durag"
	result = /obj/item/clothing/head/roguetown/durag
	reqs = list(/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 0
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_eaststrawhat
	name = "worn rice hat"
	result = /obj/item/clothing/head/roguetown/eaststrawhat
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_explorerhat
	name = "explorer's hat"
	result = /obj/item/clothing/head/roguetown/explorerhat
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_flamboyant
	name = "flamboyant hat"
	result = /obj/item/clothing/head/roguetown/flamboyant
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/head_roguetown_flotsam
	name = "flotsam bonnet"
	result = /obj/item/clothing/head/roguetown/flotsam
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_gasa
	name = "gasa"
	result = /obj/item/clothing/head/roguetown/gasa
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_hscarf
	name = "head scarf"
	result = /obj/item/clothing/head/roguetown/hscarf
	reqs = list(/obj/item/natural/silk = 4)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_longveil
	name = "long veil"
	result = /obj/item/clothing/head/roguetown/longveil
	reqs = list(/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 0
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_maidhead
	name = "maid headdress"
	result = /obj/item/clothing/head/roguetown/maidhead
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_menacing_executioner
	name = "executioners hood"
	result = /obj/item/clothing/head/roguetown/menacing/executioner
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_nightcap
	name = "nitecap"
	result = /obj/item/clothing/head/roguetown/nightcap
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_nun_hood
	name = "nun hood"
	result = /obj/item/clothing/head/roguetown/nun_hood
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_onhelm_tw_d_horns
	name = "horns helmkleinod"
	result = /obj/item/clothing/head/roguetown/onhelm/tw_d_horns
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_roguehood_bishop
	name = "bishop hood"
	result = /obj/item/clothing/head/roguetown/roguehood/bishop
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/head_roguetown_roguehood_burgerhood
	name = "noble hood"
	result = /obj/item/clothing/head/roguetown/roguehood/burgerhood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_roningasa
	name = "roningasa"
	result = /obj/item/clothing/head/roguetown/roningasa
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_sandogasa
	name = "sandogasa"
	result = /obj/item/clothing/head/roguetown/sandogasa
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_stewardtophat
	name = "top hat"
	result = /obj/item/clothing/head/roguetown/stewardtophat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/head_roguetown_tiyon
	name = "tiyon"
	result = /obj/item/clothing/head/roguetown/tiyon
	reqs = list(/obj/item/natural/cloth = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 0
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_torioigasa
	name = "torioigasa"
	result = /obj/item/clothing/head/roguetown/torioigasa
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_elven_hat
	name = "elven burka"
	result = /obj/item/clothing/head/roguetown/elven_hat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/head_roguetown_hammerhold_hat
	name = "kokoshnik"
	result = /obj/item/clothing/head/roguetown/hammerhold_hat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/head_roguetown_hammerhold_hat_peasant
	name = "hammerhold hat"
	result = /obj/item/clothing/head/roguetown/hammerhold_hat/peasant
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/head_roguetown_veiledhat
	name = "veiled hat"
	result = /obj/item/clothing/head/roguetown/veiledhat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/mask_rogue_blindfold_psydon
	name = "blessed blindfold"
	result = /obj/item/clothing/mask/rogue/blindfold/psydon
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/mask_rogue_eyepatch_fake
	name = "eyepatch"
	result = /obj/item/clothing/mask/rogue/eyepatch/fake
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/mask_rogue_eyepatch_left_fake
	name = "eyepatch (fake)"
	result = /obj/item/clothing/mask/rogue/eyepatch/left/fake
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/mask_rogue_faceveil
	name = "simple veil"
	result = /obj/item/clothing/mask/rogue/faceveil
	reqs = list(/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 0
	display_category = ITEM_CAT_CLOTH_MASK

/datum/crafting_recipe/roguetown/sewing/mask_rogue_physician_feld
	name = "feldsher's mask"
	result = /obj/item/clothing/mask/rogue/physician/feld
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/bouquet/calendula = 1, /obj/item/natural/bone = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_CLOTH_MASK

/datum/crafting_recipe/roguetown/sewing/mask_rogue_physician_phys
	name = "physicker's mask"
	result = /obj/item/clothing/mask/rogue/physician/phys
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/bouquet/calendula = 1, /obj/item/natural/bone = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_CLOTH_MASK

/datum/crafting_recipe/roguetown/sewing/mask_rogue_shepherd_shadowmask_spymaster
	name = "hand's halfmask"
	result = /obj/item/clothing/mask/rogue/shepherd/shadowmask/spymaster
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/neck_roguetown_collar_fur
	name = "fur collar"
	result = /obj/item/clothing/neck/roguetown/collar/fur
	reqs = list(/obj/item/natural/fur = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/neck_roguetown_cravat
	name = "cravat"
	result = /obj/item/clothing/neck/roguetown/cravat
	reqs = list(/obj/item/natural/cloth = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/neck_roguetown_ruffle
	name = "ruffled collar"
	result = /obj/item/clothing/neck/roguetown/ruffle
	reqs = list(/obj/item/natural/cloth = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_courtphysician
	name = "sanguine vest"
	result = /obj/item/clothing/suit/roguetown/shirt/courtphysician
	reqs = list( /obj/item/natural/silk = 3 )
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_courtphysician_female
	name = "sanguine blouse"
	result = /obj/item/clothing/suit/roguetown/shirt/courtphysician/female
	reqs = list( /obj/item/natural/silk = 3 )
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_desertbra
	name = "desert bra"
	result = /obj/item/clothing/suit/roguetown/shirt/desertbra
	reqs = list(/obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_blue
	name = "light blue dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/blue
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_etrdress
	name = "low-cut dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_etrdress2
	name = "embroidered dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress2
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_etrdress3
	name = "strapless gown"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress3
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_green
	name = "light green dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/green
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_maidfancy
	name = "valorian maid dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/maidfancy
	reqs = list( /obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2 )
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_nightgown
	name = "nightgown"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/nightgown
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_saree
	name = "saree"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/saree
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_silkdress_bishop
	name = "bishop's cassock"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/bishop
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_tavern
	name = "tavern dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/tavern
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_explorer
	name = "explorer's vest"
	result = /obj/item/clothing/suit/roguetown/shirt/explorer
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_fancyjacket
	name = "fancy jacket"
	result = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_fancyjacket_triumph_padded
	name = "dark jacket"
	result = /obj/item/clothing/suit/roguetown/shirt/fancyjacket/triumph_padded
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_haori
	name = "haori"
	result = /obj/item/clothing/suit/roguetown/shirt/haori
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_kamishimo
	name = "kamishimo"
	result = /obj/item/clothing/suit/roguetown/shirt/kamishimo
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_kazengun_jacket
	name = "kazengun jacket"
	result = /obj/item/clothing/suit/roguetown/shirt/kazengun_jacket
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_kimono
	name = "kimono"
	result = /obj/item/clothing/suit/roguetown/shirt/kimono
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_kimono2
	name = "long sleeved kimono"
	result = /obj/item/clothing/suit/roguetown/shirt/kimono2
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_abyssor_leader
	name = "sylveric robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_abyssor_painter
	name = "rainfall robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_abyssor_painter_sea
	name = "sea robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_bared
	name = "bared robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/bared
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_eora_resprite
	name = "eoran robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_eora_resprite_pink
	name = "eoran robe (pink)"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite/pink
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_hag
	name = "hedge robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/hag
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_leopard
	name = "leopard robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/leopard
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_leopard_alt
	name = "open leopard robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/leopard/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_nun_dress
	name = "nun dress"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/nun_dress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_silkbra
	name = "giltsilk bra"
	result = /obj/item/clothing/suit/roguetown/shirt/silkbra
	reqs = list(/obj/item/natural/silk = 5)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 6
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_elven
	name = "elven suit"
	result = /obj/item/clothing/suit/roguetown/shirt/elven
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_elven_coat
	name = "elven coat"
	result = /obj/item/clothing/suit/roguetown/shirt/elven/coat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_elven_coat_alt
	name = "elven furcoat"
	result = /obj/item/clothing/suit/roguetown/shirt/elven/coat/alt
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_hammerhold
	name = "hammerhold shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/hammerhold
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_hammerhold_coat
	name = "noble coat"
	result = /obj/item/clothing/suit/roguetown/shirt/hammerhold/coat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_undershirt_etrdoublet
	name = "doublet"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/etrdoublet
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_yoroihitatare
	name = "yoroihitatare"
	result = /obj/item/clothing/suit/roguetown/shirt/yoroihitatare
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/under_roguetown_loincloth_deprived
	name = "large loincloth"
	result = /obj/item/clothing/under/roguetown/loincloth/deprived
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/under_roguetown_skirt_courtphysician
	name = "sanguine skirt"
	result = /obj/item/clothing/under/roguetown/skirt/courtphysician
	reqs = list( /obj/item/natural/silk = 3 )
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 3
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/under_roguetown_skirt_desert
	name = "desert skirt"
	result = /obj/item/clothing/under/roguetown/skirt/desert
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/under_roguetown_skirt_formal
	name = "knee-high skirt"
	result = /obj/item/clothing/under/roguetown/skirt/formal
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/under_roguetown_skirt_short
	name = "short skirt"
	result = /obj/item/clothing/under/roguetown/skirt/short
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/under_roguetown_tights_dhoti
	name = "dhoti"
	result = /obj/item/clothing/under/roguetown/tights/dhoti
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/under_roguetown_tights_hose
	name = "cloth hosen"
	result = /obj/item/clothing/under/roguetown/tights/hose
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 1
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/sewing/belt_rogue_leather_battleskirt_loincloth
	name = "cloth loincloth"
	result = /obj/item/storage/belt/rogue/leather/battleskirt/loincloth
	reqs = list( /obj/item/natural/cloth = 3, /obj/item/natural/hide/cured = 1 )
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_BELTS

/datum/crafting_recipe/roguetown/sewing/belt_rogue_leather_beltshawl
	name = "belt shawl"
	result = /obj/item/storage/belt/rogue/leather/beltshawl
	reqs = list( /obj/item/natural/cloth = 3 )
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_BELTS

/datum/crafting_recipe/roguetown/sewing/belt_rogue_leather_sash_maid
	name = "cloth sash"
	result = /obj/item/storage/belt/rogue/leather/sash/maid
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_BELTS
