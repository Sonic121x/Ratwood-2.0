/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	name = "苹果片"
	icon = 'modular/Neu_Food/icons/raw/raw_fruit.dmi'
	icon_state = "apple_sliced"
	desc = "切得整整齐齐的苹果片，吃起来更方便，甚至还显得挺讲究。"
	faretype = FARE_FINE
	tastes = list("清甜苹果味" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced
	name = "南瓜片"
	icon = 'modular/Neu_Food/icons/raw/raw_fruit.dmi'
	icon_state = "pumpkin_sliced"
	desc = "切得整整齐齐的南瓜片，通常还是先煮熟再吃比较好。"
	faretype = FARE_POOR
	tastes = list("生南瓜味" = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	rotprocess = SHELFLIFE_LONG

//

/obj/item/reagent_containers/food/snacks/grown/apple/gold
	seed = null //Ungrowable(?). Can be changed if someone wishes.
	name = "仙馔"
	desc = "金苹果，换个名字罢了。你能在金苹果的表面看见自己的倒影，托着它的指尖还会泛起一阵惬意的酥麻。"
	icon_state = "gapple"
	sellprice = 55 //Unsellable to the Hordemaster, but barterable as raw wealth - otherwise.
	faretype = FARE_FINE
	tastes = list("神圣脆甜味" = 1)
	trash = /obj/item/trash/gapplecore
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold
	slices_num = 3
	rotprocess = null
	eat_effect = /datum/status_effect/buff/snackbuff
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS, /datum/reagent/medicine/stronghealth = 12)

/obj/item/reagent_containers/food/snacks/grown/apple/gold/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 155, "size" = 1))

/obj/item/reagent_containers/food/snacks/grown/apple/gold/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/matthios)
			. += span_rose("来自天国的果实，相传是马西奥斯带着阿斯特拉塔的神火逃离时，壮着胆子摘下的。吃下它不光美味无比，还能帮我愈合那些不大不小的伤口。")

/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold
	name = "仙馔切片"
	icon_state = "gapple_sliced"
	desc = "一只金苹果，被分成完美对称的三份。奢华从未如此甜蜜可口！"
	faretype = FARE_LAVISH
	rotprocess = null
	tastes = list("一丝神性甜美" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS, /datum/reagent/medicine/stronghealth = 6)

/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 155, "size" = 1))

/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/matthios)
			. += span_rose("来自天国的果实切片，相传是马西奥斯带着阿斯特拉塔的神火逃离时，壮着胆子摘下的。吃下它不光美味无比，还能帮我愈合那些不大不小的伤口。")

/obj/item/trash/gapplecore
	name = "去核的仙馔"
	desc = "嘿，谁把灯关了？我还以为盛宴才刚刚开始呢！"
	icon_state = "gapplecore"
	icon = 'icons/roguetown/items/produce.dmi'

/obj/item/trash/gapplecore/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 77, "size" = 1))

/obj/item/trash/gapplecore/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/matthios)
			. += span_rose("天国果实的残骸，相传是马西奥斯带着阿斯特拉塔的神火逃离时，壮着胆子摘下的。据说这种果实比任何食物都更能让凡人恢复精神、愈合伤口。</br>我还能通过与藏宝大师和那些最虔诚的贪婪之徒讨价还价，弄到更多。")

/obj/item/reagent_containers/food/snacks/grown/apple/gold/On_Consume(mob/living/eater)
	..()
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!(H.real_name in bitten_names))
			bitten_names += H.real_name

/obj/item/reagent_containers/food/snacks/grown/apple/gold/blockproj(mob/living/carbon/human/H)

	if(prob(98))
		H.visible_message(span_notice("[H]被金苹果救了一命！"))
		H.dropItemToGround(H.head)
		return 1
	else
		H.dropItemToGround(H.head)
		return 0

/obj/item/reagent_containers/food/snacks/grown/apple/gold/equipped(mob/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head == src)

			equippedloc = H.loc
			START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/grown/apple/gold/process()
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.head == src)
			if(equippedloc != H.loc)
				H.dropItemToGround(H.head)

//
