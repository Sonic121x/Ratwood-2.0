/obj/item/reagent_containers/food/snacks/rogue/meat/saiga
	name = "鹿肉"
	desc = "一份标准的生鹿肉，刚从野兽身上割下。只有那些聪明地躲开人类的最强壮赛加羚羊，才出产真正的鹿肉。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "steak"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga/cooked
	ingredient_size = 4
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs
	name = "鹿肋排"
	desc = "某种鹿科动物的肋排。多肉且顶饱，常被平民视为真正的盛宴珍馐，尽管林间的猎物本不该由农夫染指。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "ribs"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs/cooked
	ingredient_size = 4
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins
	name = "鹿腰肉"
	desc = "鹿科动物的腰肉，是鹿肉中最柔嫩的部位，常为上层阶级所垂涎。只有技艺娴熟的屠夫才有机会在不毁掉肉质的前提下把它完整剔下。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "loin"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins/cooked
	ingredient_size = 4
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime
	name = "鹿肉上等切块"
	desc = "由技艺娴熟的屠夫处理的鹿肉上等切块。不仅柔嫩，还极其顶饱。堪配公爵的一餐，常惹他人艳羡。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "ossobuco"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked
	ingredient_size = 4
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z
	name = "尸鬼鹿肉"
	desc = "亡灵身上仍带着血肉，坚韧耐嚼。这是需要慢慢习惯的味道。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "steak_z"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked
	ingredient_size = 4
	// Already rotten.
	rotprocess = null
	eat_effect = /datum/status_effect/debuff/rotfood

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z
	name = "尸鬼鹿肋排"
	desc = "一大块沉甸甸的亡灵血肉。顶饱，却难以下咽，不过对走投无路的人来说仍是一场盛宴。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "ribs_z"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z/cooked
	ingredient_size = 4
	rotprocess = null
	eat_effect = /datum/status_effect/debuff/rotfood

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z
	name = "尸鬼鹿腰肉"
	desc = "在某些圈子里，腐肉被视为珍馐。咬一口吧，不死之躯只会让这柔嫩的肉更加多汁，就像过熟的果子。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "loin_z"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z/cooked
	ingredient_size = 4
	rotprocess = null
	eat_effect = /datum/status_effect/debuff/rotfood

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z
	name = "尸鬼鹿肉上等切块"
	desc = "连死亡都无法阻止这生物献出它最上等的切块。就连莱克们见了，恐怕也会觉得血肉胜过鲜血。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "ossobuco_z"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z/cooked
	ingredient_size = 4
	rotprocess = null
	eat_effect = /datum/status_effect/debuff/rotfood

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w
	name = "苍白鹿肉"
	desc = "雄鹿曾翩翩起舞，如今它成了除登多尔信徒外所有人都喜欢的样子——死去、静止、美味。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "steak_w"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w/cooked
	ingredient_size = 4
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w
	name = "苍白鹿肋排"
	desc = "比黑钢还坚硬的肋骨，附着的肉呢？堪比仙馔。哦，若能分得那野兽的一分气力该多好。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "ribs_w"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w/cooked
	ingredient_size = 4
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w
	name = "苍白鹿腰肉"
	desc = "轻轻一碰就能在这肉上按出凹痕，柔嫩得不可思议。只消看上一眼，那画面便会深深刻进你的脑海。你一定要尝尝它。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "loin_w"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w/cooked
	ingredient_size = 4
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w
	name = "苍白鹿肉上等切块"
	desc = "仅仅是为这雄鹿血肉的传说，就曾引发过无数冲突。据说它能赋予难以想象的力量。没有舌头的人也能品尝它，没有呼吸的人也能嗅到它——因为登多尔的疯狂没有止境。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat_saiga.dmi'
	icon_state = "ossobuco_w"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w/cooked
	ingredient_size = 4
	rotprocess = null
