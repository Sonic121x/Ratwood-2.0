// -------------- CHOCOLATE -----------------
/obj/item/reagent_containers/food/snacks/chocolate
	name = "巧克力锭"
	desc = "一块不可思议地奢靡的软糖，以亚马逊的可可豆与格伦泽尔的赛加羚羊奶制成。两国间近期的一项贸易协定，\
	让这种曾经昂贵的珍馐变成了许多人稍许负担得起的零嘴。\
	</br>在一次涉及卢皮安贵族与一盒巧克力的不幸外交事件之后，人们也发现巧克力对一些登多尔的子嗣而言，\
	可以充当强效的"情绪调节剂"。\
	</br>看起来可以用匕首从中间分成两半。"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "chocolate"
	bitesize = 4
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/chocolate/slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("糖分浓郁的醇厚" = 1)
	faretype = FARE_LAVISH
	rotprocess = null
	eat_effect = /datum/status_effect/buff/sweet
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/chocolate/On_Consume(mob/living/eater)
	if(islupian(eater) || isvulp(eater))
		to_chat(eater, span_warning("这巧克力尝起来美味极了，但我的胃却在剧烈翻腾！"))
		if(iscarbon(eater))
			var/mob/living/carbon/C = eater
			C.add_nausea(120) // enough to trigger vomiting
		eater.adjustToxLoss(5)
	return ..()

/obj/item/reagent_containers/food/snacks/chocolate/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/chocolatedry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/chocolate/slice
	name = "半块巧克力锭"
	desc = "不可思议地奢靡的半块软糖，以亚马逊的可可豆与格伦泽尔的赛加羚羊奶制成。两国间近期的一项贸易协定，\
	让这种曾经昂贵的珍馐变成了许多人稍许负担得起的零嘴。\
	</br>在一次涉及卢皮安贵族与一盒巧克力的不幸外交事件之后，人们也发现巧克力对一些登多尔的子嗣而言，\
	可以充当强效的"情绪调节剂"。\
	</br>与南瓜香料混合并投入锅中，能煮出一壶妙不可言的热饮。"
	bitesize = 3 //Sharing is caring!
	icon_state = "chocolatehalf"
	slices_num = null
	slice_path = null

/obj/item/reagent_containers/food/snacks/jamtallow
	name = "黑莓果酱条"
	desc = "一块黑莓酱化的锭块，只配得上最上等的面包片。它在召唤你用合适的餐具来切分它。"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "jamtallow6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	faretype = FARE_POOR //Slightly better than eating a whole log of butter on your lonesome. Slightly.
	slice_path = /obj/item/reagent_containers/food/snacks/jamtallowslice
	slices_num = 6
	slice_batch = FALSE
	bitesize = 6
	slice_sound = TRUE
	tastes = list("黏稠的美味" = 1, "淡淡的酸涩" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/jamtallow/update_icon()
	if(slices_num)
		icon_state = "jamtallow[slices_num]"
	else
		icon_state = "jamtallow_slice"

/obj/item/reagent_containers/food/snacks/jamtallow/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 5
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/jamtallowslice
	name = "黑莓果酱条片"
	desc = "一份果酱般的天堂，带着与费伦提亚清晨天空相同的色泽。它渴望的不是被独自享用，而是配上一片面包——最好是黄油面团烤制的，或烤过的。"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "jamtallow_slice"
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("黏稠的美味" = 1, "淡淡的酸涩" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/marmalade
	name = "柑橘果酱条"
	desc = "一块柑橘酱化的锭块，只配得上最上等的面包片。它在召唤你用合适的餐具来切分它。"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "marmalade6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	faretype = FARE_POOR //Slightly better than eating a whole log of butter on your lonesome. Slightly.
	slice_path = /obj/item/reagent_containers/food/snacks/marmaladeslice
	slices_num = 6
	slice_batch = FALSE
	bitesize = 6
	slice_sound = TRUE
	tastes = list("黏稠的美味" = 1, "淡淡的甜酸" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/marmalade/update_icon()
	if(slices_num)
		icon_state = "marmalade[slices_num]"
	else
		icon_state = "marmalade_slice"

/obj/item/reagent_containers/food/snacks/marmalade/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 5
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/marmaladeslice
	name = "柑橘果酱条片"
	desc = "一份果酱般的天堂，带着与费伦提亚黄昏海洋相同的色泽。它渴望的不是被独自享用，而是配上一片面包——最好是黄油面团烤制的，或烤过的。"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "marmalade_slice"
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("黏稠的美味" = 1, "淡淡的甜酸" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/caramel
	name = "焦糖脆粒"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "caramel3"
	desc = "板油炸糖后凝成的玻璃般碎块，普赛多尼亚最睿智慈祥的长者们常把它们分给年轻人。"
	faretype = FARE_FINE
	fried_type = null
	bitesize = 3
	slice_path = null
	tastes = list("浓郁的糖甜" = 1, "舌尖久久不散的甜味" = 1)
	w_class = WEIGHT_CLASS_TINY
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/caramel/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "caramel2"
	if(bitecount == 2)
		icon_state = "caramel1"

/obj/item/reagent_containers/food/snacks/dragee
	name = "糖衣果仁"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "dragee3"
	desc = "板油炸坚果凝成的玻璃般小块，裹着糖衣，掺入草药药剂。这类小粒在普赛多尼亚的年轻人中颇受欢迎——\
	既是奖励奥塔瓦孩童记住经文的奖品，也是治疗童年小病的良药。"
	faretype = FARE_LAVISH
	fried_type = null
	bitesize = 3
	slice_path = null
	tastes = list("坚果般的糖甜" = 1, "舌尖久久不散的草本暖意" = 1)
	w_class = WEIGHT_CLASS_TINY
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL, /datum/reagent/medicine/healthpot = 5) //Very light medicinal effect, equivalent to half of a vial when fully eaten. Yum!
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/dragee/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "dragee2"
	if(bitecount == 2)
		icon_state = "dragee1"

//SUGARSHAPES!!!
/obj/item/reagent_containers/food/snacks/grown/sugarshape
	name = "糖塑"
	desc = "一堆被塑成装饰形状的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "sugarmound"
	fried_type = null
	slice_path = null
	rotprocess = null
	faretype = FARE_POOR
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("满口糖味" = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/sugar
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/grown/sugarshape/dmark
	name = "公爵印记糖塑"
	desc = "一堆被塑成带有费伦提亚徽记之装饰印记的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/dmark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/smark
	name = "骷髅印记糖塑"
	desc = "一堆被塑成装饰性骷髅印记的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/smark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/amark
	name = "圣堂印记糖塑"
	desc = "一堆被塑成带有教会徽记之装饰印记的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/amark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/zmark
	name = "齐佐印记糖塑"
	desc = "一堆被塑成带有齐佐徽记之装饰印记的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/zmark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/pmark
	name = "普赛顿印记糖塑"
	desc = "一堆被塑成带有普赛顿徽记之装饰印记的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/pmark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/hmark
	name = "爱心印记糖塑"
	desc = "一堆被塑成装饰性爱心印记的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/hmark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuer
	name = "王室雕像糖塑"
	desc = "一堆被塑成装饰性王室人物的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/statuer

/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuek
	name = "骑士雕像糖塑"
	desc = "一堆被塑成装饰性骑士的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/statuek

/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuey
	name = "自耕农雕像糖塑"
	desc = "一堆被塑成装饰性自耕农的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/statuey

/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuel
	name = "领主雕像糖塑"
	desc = "一堆被塑成装饰性领主的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/statuel

/obj/item/reagent_containers/food/snacks/grown/sugarshape/arch
	name = "拱门糖塑"
	desc = "一堆被塑成装饰性拱门的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/arch

/obj/item/reagent_containers/food/snacks/grown/sugarshape/archway
	name = "拱道糖塑"
	desc = "一堆被塑成装饰性拱道的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/archway

/obj/item/reagent_containers/food/snacks/grown/sugarshape/tower
	name = "塔楼糖塑"
	desc = "一堆被塑成装饰性塔楼的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/tower

/obj/item/reagent_containers/food/snacks/grown/sugarshape/towers
	name = "小塔糖塑"
	desc = "一堆被塑成装饰性小塔楼的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/towers

/obj/item/reagent_containers/food/snacks/grown/sugarshape/castle
	name = "城堡糖塑"
	desc = "一堆被塑成装饰性城堡的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/castle

/obj/item/reagent_containers/food/snacks/grown/sugarshape/flag
	name = "旗帜糖塑"
	desc = "一堆被塑成装饰性旗帜的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/flag

/obj/item/reagent_containers/food/snacks/grown/sugarshape/house
	name = "房屋糖塑"
	desc = "一堆被塑成装饰性房屋的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/house

/obj/item/reagent_containers/food/snacks/grown/sugarshape/tree
	name = "树木糖塑"
	desc = "一堆被塑成装饰性树木的糖。它渴望在烤炉的热力下完工，或被重新磨回糖粉。"
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/tree

/obj/item/reagent_containers/food/snacks/sugarstatue
	name = "糖玻璃雕像"
	desc = "一件精心雕琢、模仿雕像的糖玻璃装饰品。美味得仿佛王者加冕！"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "sugarstatue"
	fried_type = null
	slice_path = null
	rotprocess = null
	faretype = FARE_FINE
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("脆生生的糖玻璃" = 1)
	sellprice = 15
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/sugarstatue/dmark
	name = "公爵糖玻璃印记"
	desc = "一件精心雕琢、模仿费伦提亚王室徽记的糖玻璃装饰品。美味得尊贵非凡！"
	icon_state = "sugarstatuemarkd"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/smark
	name = "骷髅糖玻璃印记"
	desc = "一件精心雕琢、模仿喋喋不休之骷髅面容的糖玻璃装饰品。美味得仿佛死神亲临！"
	icon_state = "sugarstatuemarks"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/amark
	name = "圣堂糖玻璃印记"
	desc = "一件精心雕琢、模仿教会徽记的糖玻璃装饰品。美味得圣洁无比！"
	icon_state = "sugarstatuemarka"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/zmark
	name = "齐佐糖玻璃印记"
	desc = "一件精心雕琢、模仿齐佐徽记的糖玻璃装饰品。美味得仿佛罪孽深重！"
	icon_state = "sugarstatuemarkz"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/pmark
	name = "普赛顿糖玻璃印记"
	desc = "一件精心雕琢、模仿普赛顿徽记的糖玻璃装饰品。美味得恒久弥新！"
	icon_state = "sugarstatuemarkp"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/hmark
	name = "爱心糖玻璃印记"
	desc = "一件精心雕琢、模仿诗篇中爱心模样的糖玻璃装饰品。美味得惹人怜爱！"
	icon_state = "sugarstatuemarkh"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/statuer
	name = "王室糖玻璃雕像"
	desc = "一件精心雕琢、模仿王室成员的糖玻璃装饰品。美味得专横跋扈！"
	icon_state = "sugarstatuequeen"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/statuek
	name = "骑士糖玻璃雕像"
	desc = "一件精心雕琢、模仿身披闪亮铠甲之骑士的糖玻璃装饰品。美味得侠义凛然！"
	icon_state = "sugarstatueknight"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/statuel
	name = "领主糖玻璃雕像"
	desc = "一件精心雕琢、模仿头戴王冠之领主的糖玻璃装饰品。美味得高贵无比！"
	icon_state = "sugarstatue"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/statuey
	name = "自耕农糖玻璃雕像"
	desc = "一件精心雕琢、模仿身披斗篷之自耕农的糖玻璃装饰品。美味得恪尽职守！"
	icon_state = "sugarstatueyeoman"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/arch
	name = "糖玻璃拱门"
	desc = "一件精心雕琢、模仿可衔接拱桥的糖玻璃装饰品。美味得仿佛石匠杰作！"
	icon_state = "sugarstatuearch"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/archway
	name = "糖玻璃拱道"
	desc = "一件精心雕琢、模仿双塔拱道的糖玻璃装饰品。美味得气势恢宏！"
	icon_state = "sugarstatuearchway"
	bitesize = 4

/obj/item/reagent_containers/food/snacks/sugarstatue/tower
	name = "糖玻璃塔楼"
	desc = "一件精心雕琢、模仿塔楼的糖玻璃装饰品。美味得雉堞俨然！"
	icon_state = "sugarstatuetower"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/towers
	name = "小糖玻璃塔楼"
	desc = "一件精心雕琢、模仿小塔楼的糖玻璃装饰品。美味得壁垒森严！"
	icon_state = "sugarstatuesmalltower"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/castle
	name = "糖玻璃城堡"
	desc = "一件精心雕琢、模仿主堡的糖玻璃装饰品。美味得固若金汤！"
	icon_state = "sugarstatuecastle"
	bitesize = 4

/obj/item/reagent_containers/food/snacks/sugarstatue/flag
	name = "糖玻璃旗帜"
	desc = "一件精心雕琢、模仿迎风旗帜的糖玻璃装饰品。美味得装饰感十足！"
	icon_state = "sugarstatueflag"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/house
	name = "糖玻璃房屋"
	desc = "一件精心雕琢、模仿简朴居所的糖玻璃装饰品。美味得温馨惬意！"
	icon_state = "sugarstatuehouse"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/tree
	name = "糖玻璃树木"
	desc = "一件精心雕琢、模仿繁茂树木的糖玻璃装饰品。美味得自然天成！"
	icon_state = "sugarstatuetree"
	bitesize = 3
