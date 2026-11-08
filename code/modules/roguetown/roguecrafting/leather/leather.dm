/datum/crafting_recipe/roguetown/leather
	abstract_type = /datum/crafting_recipe/roguetown/leather
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	subtype_reqs = TRUE		//Makes it so fur-subtypes work. Basically if anything is just 'obj/item/natural/fur' - it'll take any fur. If it specifies 'natural/fur/direbear' - it will still require direbear.
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/bedroll
	name = "卷起的铺盖卷"
	result = /obj/item/bedroll
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)
	tools = list(/obj/item/needle)
	verbage_simple = "制作"
	verbage = "制作"
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/peltbedsheet
	name = "床单，皮毛"
	result = /obj/item/bedsheet/rogue/pelt
	reqs = list(/obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 1
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/doublepeltbedsheet
	name = "双人床单，皮毛"
	result = /obj/item/bedsheet/rogue/double_pelt
	reqs = list(/obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 2)
	tools = list(/obj/item/needle)
	craftdiff = 1
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/corset
	name = "束身衣"
	result = /obj/item/clothing/suit/roguetown/armor/corset
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	sellprice = 15
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/gloves
	name = "皮手套"
	result = list(/obj/item/clothing/gloves/roguetown/leather,
	/obj/item/clothing/gloves/roguetown/leather)
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 10
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/crafting_recipe/roguetown/leather/heavygloves
	name = "重型皮手套"
	result = /obj/item/clothing/gloves/roguetown/angle
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 20
	craftdiff = 3
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/crafting_recipe/roguetown/leather/fingerless_leather_gloves
	name = "露指皮手套"
	result = /obj/item/clothing/gloves/roguetown/fingerless_leather
	reqs = list(
		/obj/item/natural/hide/cured = 1
		)
	sellprice = 20
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/crafting_recipe/roguetown/leather/bandana
	name = "皮头巾"
	result = /obj/item/clothing/head/roguetown/helmet/bandana
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 27
	craftdiff = 0
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/crafting_recipe/roguetown/leather/tricorn
	name = "皮三角帽"
	result = /obj/item/clothing/head/roguetown/helmet/tricorn
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 27
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/crafting_recipe/roguetown/leather/hood
	name = "皮兜帽"
	result = /obj/item/clothing/head/roguetown/roguehood
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 26
	craftdiff = 1
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/crafting_recipe/roguetown/leather/vest
	name = "皮背心"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 1
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/bikini
	name = "皮胸衣"
	result = /obj/item/clothing/suit/roguetown/armor/leather/bikini
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 26
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/hidebikini
	name = "兽皮胸衣"
	result = /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 1)
	sellprice = 26
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/cloak
	name = "雨披"
	result = /obj/item/clothing/cloak/raincloak/brown
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/apron/blacksmith
	name = "皮围裙"
	result = /obj/item/clothing/cloak/apron/blacksmith
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/cloakfur
	name = "毛皮斗篷"
	result = /obj/item/clothing/cloak/raincloak/furcloak/crafted
	reqs = list(/obj/item/natural/hide/cured = 1,/obj/item/natural/fur = 2)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/obj/item/clothing/cloak/raincloak/furcloak/crafted
	sellprice = 55

/datum/crafting_recipe/roguetown/leather/papakha
	name = "帕帕哈帽"
	result = /obj/item/clothing/head/roguetown/papakha/crafted
	reqs = list(/obj/item/natural/fur = 1, /obj/item/natural/fibers = 2)
	craftdiff = 1
	display_category = ITEM_CAT_ARMOR_HELMETS

/obj/item/clothing/head/roguetown/papakha/crafted
	sellprice = 10

/datum/crafting_recipe/roguetown/leather/saddle
	name = "鞍具"
	result = /obj/item/natural/saddle
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/whip
	name = "皮鞭"
	result = /obj/item/rogueweapon/whip
	reqs = list(/obj/item/natural/hide/cured = 2,/obj/item/natural/stone = 1)
	sellprice = 39
	craftdiff = 1
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/crafting_recipe/roguetown/leather/drum
	name = "鼓"
	result = /obj/item/rogue/instrument/drum
	reqs = list(/obj/item/natural/hide/cured = 2,/obj/item/grown/log/tree/small = 1)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/vest/sailor
	name = "水手夹克"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 1
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/darkcloak
	name = "暗色披风"
	result = list(/obj/item/clothing/cloak/darkcloak)
	reqs = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 5
	sellprice = 80
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/bearcloak
	name = "恐熊披风"
	result = list(/obj/item/clothing/cloak/darkcloak/bear)
	reqs = list(/obj/item/natural/fur/direbear = 1,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4
	sellprice = 80
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/lightbearcloak
	name = "轻型恐熊披风"
	result = list(/obj/item/clothing/cloak/darkcloak/bear/light)
	reqs = list(/obj/item/natural/fur/direbear = 1,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4
	sellprice = 80
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/leathertights
	name = "皮紧身裤"
	result = list(/obj/item/clothing/under/roguetown/trou/leathertights)
	reqs = list(/obj/item/natural/hide/cured = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	name = "皮制牵绳"
	result = /obj/item/leash/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	always_availible = TRUE
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/skillbook
	name = "未完成的技能书"
	result = /obj/item/skillbook/unfinished
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/paper = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	structurecraft = null//surely it's possible to stitch a book and paper together without a drying rack...
	craftdiff = 1
	always_availible = TRUE
	display_category = ITEM_CAT_BOOK_WRIT

/datum/crafting_recipe/roguetown/leather/doctormask
	name = "瘟疫面具"
	result = /obj/item/clothing/mask/rogue/physician
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/bone = 1)
	craftdiff = 2
	display_category = ITEM_CAT_CLOTH_MASK

/datum/crafting_recipe/roguetown/leather/leathermask
	name = "软垫皮面罩"
	display_category = ITEM_CAT_ARMOR_MASKS
	result = /obj/item/clothing/mask/rogue/facemask/leather
	reqs = list(/obj/item/natural/hide/cured = 2)
	tools = list(/obj/item/needle)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/cloak_bandolier
	name = "斜挎带"
	result = /obj/item/clothing/cloak/bandolier
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/rope = 1)
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/cloak_bandolier_inq
	name = "审判庭斜挎带"
	result = /obj/item/clothing/cloak/bandolier/inq
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_fingerless_shadowgloves_spymaster
	name = "执政之手的手套"
	result = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa
	name = "象牙白手套"
	result = /obj/item/clothing/gloves/roguetown/rosa
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_eight
	name = "宫廷手套"
	result = /obj/item/clothing/gloves/roguetown/rosa/eight
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_five
	name = "墨黑手套"
	result = /obj/item/clothing/gloves/roguetown/rosa/five
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_four
	name = "曜黑手套"
	result = /obj/item/clothing/gloves/roguetown/rosa/four
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_nine
	name = "王室手套"
	result = /obj/item/clothing/gloves/roguetown/rosa/nine
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_seven
	name = "华贵手套"
	result = /obj/item/clothing/gloves/roguetown/rosa/seven
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_six
	name = "栗红手套"
	result = /obj/item/clothing/gloves/roguetown/rosa/six
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_ten
	name = "庄重手套"
	result = /obj/item/clothing/gloves/roguetown/rosa/ten
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_three
	name = "银饰手套"
	result = /obj/item/clothing/gloves/roguetown/rosa/three
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/head_roguetown_headband_fur
	name = "毛皮头带"
	result = /obj/item/clothing/head/roguetown/headband/fur
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_boots_hammerhold_boots
	name = "铁锤堡靴"
	result = /obj/item/clothing/shoes/roguetown/boots/hammerhold_boots
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_courtphysician
	name = "绯红皮鞋"
	result = /obj/item/clothing/shoes/roguetown/courtphysician
	reqs = list( /obj/item/natural/hide/cured = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 3
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_courtphysician_female
	name = "绯红高跟鞋"
	result = /obj/item/clothing/shoes/roguetown/courtphysician/female
	reqs = list( /obj/item/natural/hide/cured = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 3
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_hammerhold_shoes
	name = "铁锤堡鞋"
	result = /obj/item/clothing/shoes/roguetown/hammerhold_shoes
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa
	name = "象牙白鞋"
	result = /obj/item/clothing/shoes/roguetown/rosa
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_eight
	name = "宫廷鞋"
	result = /obj/item/clothing/shoes/roguetown/rosa/eight
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_five
	name = "墨黑鞋"
	result = /obj/item/clothing/shoes/roguetown/rosa/five
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_four
	name = "曜黑鞋"
	result = /obj/item/clothing/shoes/roguetown/rosa/four
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_nine
	name = "王室鞋"
	result = /obj/item/clothing/shoes/roguetown/rosa/nine
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_seven
	name = "华贵鞋"
	result = /obj/item/clothing/shoes/roguetown/rosa/seven
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_ten
	name = "庄重鞋"
	result = /obj/item/clothing/shoes/roguetown/rosa/ten
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_three
	name = "银饰鞋"
	result = /obj/item/clothing/shoes/roguetown/rosa/three
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat
	name = "华贵外套"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat
	reqs = list( /obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat_four
	name = "庄重外套"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/four
	reqs = list( /obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat_two
	name = "宫廷外套"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/two
	reqs = list( /obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_belthooks
	name = "腰带挂钩"
	result = /obj/item/storage/belt/rogue/leather/belthooks
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_hammerhold_sash
	name = "铁锤堡腰带"
	result = /obj/item/storage/belt/rogue/leather/hammerhold_sash
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_iron
	name = "铁片腰带"
	result = /obj/item/storage/belt/rogue/leather/iron
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON
