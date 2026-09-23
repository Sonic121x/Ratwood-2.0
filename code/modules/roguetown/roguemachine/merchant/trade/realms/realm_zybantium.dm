/datum/foreign_realm/zybantium
	id = REALM_ZYBANTIUM
	name = "兹班图"
	roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Thalassa", "Abyssoros", "Khimaira", "Eos", "Aetos",
		"Astrateios", "Anemos", "Galene", "Drakon", "Pelagos",
		"Astraios", "Noctaios", "Korax", "Boreas", "Aigle",
	)
	captain_first_names = list(
		"Eumelos", "Kallias", "Damaskios", "Hieron", "Polyphron",
		"Andronikos", "Doros", "Aram", "Vartan", "Niyaz",
		"Helike", "Anthousa", "Korinna", "Astrateia", "Nairi",
	)
	captain_last_names = list(
		"Khariotes", "Pelasgos", "Anaktor", "Phaleron", "Abyssoreios",
		"of Chorodiaki", "Vrdaqnani", "Nshkor", "Müccevbey", "Sayyari",
	)
	ship_types = list(
		list("name" = "阿卡提翁轻帆船", "tonnage" = 40, "weight" = 15),
		list("name" = "德罗蒙战船", "tonnage" = 130, "weight" = 35),
		list("name" = "双层桨战船", "tonnage" = 300, "weight" = 30),
			list("name" = "潘菲洛斯战船", "tonnage" = 600, "weight" = 20),
	)
	city_tags = list(
		"Zybantium", "Chorodiaki", "Müccevkabher", "Nshkormh", "Vrdaqnan",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ONION, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/hcake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/garlickbass, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/menthacake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_jamtallow, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/tangerine_wine),
		list("recipe" = /datum/brewing_recipe/mead),
		list("recipe" = /datum/brewing_recipe/liquor),
		list("recipe" = /datum/brewing_recipe/aqua_vitae),
		list("recipe" = /datum/brewing_recipe/limoncello),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/amber,
		/datum/supply_pack/rogue/gems/coral,
		/datum/supply_pack/rogue/food/pepper,
		/datum/supply_pack/rogue/zybantine/janissary_kit,
		/datum/supply_pack/rogue/zybantine/desert_rider_kit,
		/datum/supply_pack/rogue/zybantine/megarmach_coat,
		/datum/supply_pack/rogue/zybantine/paddedgambeson,
		/datum/supply_pack/rogue/zybantine/gambeson,
		/datum/supply_pack/rogue/zybantine/zybtrou,
		/datum/supply_pack/rogue/zybantine/tower_shield,
		/datum/supply_pack/rogue/zybantine/shamshir,
		/datum/supply_pack/rogue/zybantine/shalal_saber,
		/datum/supply_pack/rogue/zybantine/navaja,
		/datum/supply_pack/rogue/zybantine/grand_mace,
		/datum/supply_pack/rogue/zybantine/spear,
		/datum/supply_pack/rogue/zybantine/whip,
		/datum/supply_pack/rogue/zybantine/recurve_bow,
		/datum/supply_pack/rogue/zybantine/javelins,
		/datum/supply_pack/rogue/zybantine/headscarf,
		/datum/supply_pack/rogue/zybantine/shalal_hood,
		/datum/supply_pack/rogue/zybantine/shalal_scarf,
		/datum/supply_pack/rogue/zybantine/copper_gorget,
		/datum/supply_pack/rogue/zybantine/copper_facemask,
		/datum/supply_pack/rogue/zybantine/copper_bracers,
		/datum/supply_pack/rogue/zybantine/shalal_slippers,
		/datum/supply_pack/rogue/zybantine/shalal_belt,
		/datum/supply_pack/rogue/zybantine/gladius,
		/datum/supply_pack/rogue/zybantine/makhaira,
	)
	hail_lines = list(
		"奉至尊之名，获为特许状盖印的埃米尔准许，兹班图向商行管事问好。我的货舱远道而来，莫让它闲置。",
		"科罗迪亚基的丝绸，穆杰夫卡赫尔的糖和蓝晶，恩什科姆的酒，弗尔达克南几何师的作品。一个帝国，四份货单，谢赫的文书们对我可真有耐心。",
		"算账前，先陪我坐坐。在兹班图，没人同陌生人做买卖——先喝，再吃，最后才数钱。你的待客之道，会和你的价钱一样令人记忆长久。",
		"听见后甲板的笛声了吗？我的大副来自穆杰夫卡赫尔，讨价还价若不合拍子，她可不干。她说赛利克斯眷顾她。我发现曲子越快，她砍价越狠。",
		"你们有毛皮、木材和铁；而普赛顿——愿祂的记忆受颂扬——并未把这些大量留在我们的大陆。所以我们出海，这道算术比你我都古老。",
		"我的表亲是当地的谢赫，每顿晚饭都不忘提醒我。可现在我在你们码头，他还坐在自家餐桌旁。说说看，谁才真正见过世界？",
		"祖母教我，不曾与人独处交谈，就算不上了解他。谈完明面上的价钱，便下舱陪我喝一杯吧。真正的数字藏在那里。",
		"弗尔达克南的埃米尔派了一名禁卫军上船，维持船员间的和睦。他做到了，办法是陪两个人跳舞，再陪第三个喝酒。我会在报告里表扬他。",
		"第三货舱有个苦修士，自看见你们的海角便一直旋转。他说居奈的刀还在天上转，他也必须转。别理他，及时付我钱就行。",
		"船首坐着弗尔达克南家族的一位几何师，借阿斯特拉塔的第一缕光为人看手相。他不收钱，收问题，一问换一看，概不例外。他出海传授所学，趁苦修士诸家还愿意委托他工作。带着真诚的问题来，他不会拒绝；奉承他，他也不会拒绝，但答案你恐怕不会喜欢。",
		"为漫长的内陆商队旅程备些盐腌鲭鱼和鲱鱼，再来几箱各式冰鲜鱼。内陆的谢赫们从未见过海，我的合伙人会把海带到他们面前。"
	)
