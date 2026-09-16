/obj/item/reagent_containers/food/snacks/rogue/meat/saiga/cooked
	name = "鹿肉排"
	desc = "森林的馈赠，精工细切。这是熟练猎人的专利，而非农夫所能染指。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "steak"
	eat_effect = null
	faretype = FARE_FINE
	tastes = list("森林鹿肉香" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs/cooked
	name = "多汁鹿肋排"
	desc = "贵族禁止平民染指的肉。它渗出诱人的油脂，让人得以长久抵御饥饿的啃噬。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ribs"
	eat_effect = null
	faretype = FARE_FINE
	tastes = list("森林鹿肉香" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins/cooked
	name = "嫩鹿里脊"
	desc = "肉质鲜嫩，一挤便渗出诱人的肉汁。这是最上等的鹿肉部位之一，深受贵族珍视。技艺精湛的屠夫收获了他们的回报。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "loin"
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_LAVISH
	tastes = list("森林里脊香" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked
	name = "鹿肉上等排"
	desc = "如同艺术一般从野兽身上取下的肉。一份配得上王室的佳肴，一口下去仿佛回到了那片森林，与那头赛加羚羊对视。常被戏称为“偷猎者的末日”。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ossobuco"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("森林丰饶" = 1)
	bitesize = 6
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked
	name = "恶臭鹿肉排"
	desc = "烹煮对气味只有微不足道的改善，臭味反而更刺鼻了。最好不要招来什么食尸鬼。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "steak_z"
	eat_effect = /datum/status_effect/debuff/rotfood
	faretype = FARE_POOR
	tastes = list("污泥与尘垢" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null
	cooked_smell = /datum/pollutant/food/rotten_meat

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z/cooked
	name = "腐臭鹿肋排"
	desc = "骨头一碰就碎，肉质却还不错。佩斯特拉的僧侣从不拒绝享用这份受佩斯特拉祝福的肉。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ribs_z"
	eat_effect = /datum/status_effect/debuff/rotfood
	faretype = FARE_POOR
	tastes = list("污泥与尘垢" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null
	cooked_smell = /datum/pollutant/food/rotten_meat

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z/cooked
	name = "腐坏鹿里脊"
	desc = "烹煮后肉质稍微紧实了一些。表面鲜嫩，内核坚韧。凡人勉强能接受吃这东西的想法。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "loin_z"
	// Tender enough to eat without puking
	eat_effect = null
	faretype = FARE_POOR
	tastes = list("污泥与尘垢" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null
	cooked_smell = /datum/pollutant/food/rotten_meat

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z/cooked
	name = "异味鹿肉上等排"
	desc = "看到如此上等的肉被亡灵玷污，真是……令人遗憾的景象。但也许……万一它的味道和真品一样好呢？想必不会有贵族因为你想尝尝这无生气的野味就砍你的头。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ossobuco_z"
	// Tender enough to eat without puking
	eat_effect = null
	faretype = FARE_NEUTRAL
	tastes = list("污泥与尘垢" = 1)
	bitesize = 6
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null
	cooked_smell = /datum/pollutant/food/rotten_meat

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w/cooked
	name = "皇家鹿肉排"
	desc = "活该，你这傲慢的畜生。追逐男人女人，戏弄他们。现在你只是被大卸八块，烹煮殆尽，安静了。啊……"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "steak_w"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("艰难岁月" = 1)
	bitesize = 8
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_AND_HALF_MEALS)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w/cooked
	name = "皇家鹿肋排"
	desc = "比黑钢还要坚韧的肋骨，预示着强大的力量。它既是烹饪的精品，也是一场盛宴，足以供养许多人。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ribs_w"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("纯粹意志" = 1)
	bitesize = 10
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_AND_HALF_MEALS)
	volume = 100
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w/cooked
	name = "皇家鹿里脊"
	desc = "指尖一按便会留下凹痕，稍等片刻又令人满意地恢复原状。这野兽或许不会流血，但油脂的缺席无损于它天堂般的美味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "loin_w"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("登多尔的怒火" = 1)
	bitesize = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_AND_HALF_MEALS)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w/cooked
	name = "皇家鹿肉上等排"
	desc = "同类相残，只为获得雄鹿的力量。撕开它，夺走它神话般的力量。即使没有嗅觉的人也能感受到它的香气。看上一眼，便能尝到一丝滋味。这是登多尔天使的圣肉，它不在乎你的躯体如何，这肉本身便诉说着传说。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ossobuco_w"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("决意" = 1)
	bitesize = 15
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FIVE_MEALS)
	volume = 100
	fried_type = null
	cooked_type = null
