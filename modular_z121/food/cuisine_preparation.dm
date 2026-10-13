// 以食材互相点击开始备料，不向通用制作菜单登记配方。
/datum/z121_cuisine_preparation_recipe
	var/base_type
	var/trigger_type
	var/consume_trigger = TRUE
	var/prep_name
	var/start_text
	var/result_type
	var/list/steps
	var/list/step_text

/datum/z121_cuisine_preparation_recipe/spring_roll
	base_type = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	trigger_type = /obj/item/kitchen/rollingpin
	consume_trigger = FALSE
	prep_name = "待包馅的春卷皮"
	start_text = "你将小面团擀成薄薄的春卷皮。"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/spring_roll
	steps = list(/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced, /obj/item/reagent_containers/food/snacks/grown/carrot)
	step_text = list("加入一份卷心菜丝", "加入一根胡萝卜，包卷收口")

/datum/z121_cuisine_preparation_recipe/hotpot
	base_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	prep_name = "待配菜的狼肉"
	start_text = "你将两份生狼肉整理成一份火锅肉料。"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/hotpot
	steps = list(/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove)
	step_text = list("加入一份卷心菜丝", "加入一份洋葱片", "加入一份蒜瓣，拌匀配料")

/datum/z121_cuisine_preparation_recipe/dongpo
	base_type = /obj/item/reagent_containers/food/snacks/rogue/meat/pork_belly
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	prep_name = "待腌制的五花肉"
	start_text = "你将蒜瓣揉入五花肉，准备调配腌汁。"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/dongpo
	steps = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/consumable/ethanol/ricewine = 10)
	step_text = list("加入五单位糖", "加入十单位米酒，揉匀腌汁")

/datum/z121_cuisine_preparation_recipe/noodles
	base_type = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	trigger_type = /obj/item/rogueweapon/huntingknife/cleaver
	consume_trigger = FALSE
	prep_name = "待配菜的刀削面片"
	start_text = "你用菜刀将小面团削成宽薄不一的面片。"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/noodles
	steps = list(/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced)
	step_text = list("加入一份卷心菜丝", "加入一份洋葱片，整理面料")

/datum/z121_cuisine_preparation_recipe/meat_bun
	base_type = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	prep_name = "待调馅的肉包面坯"
	start_text = "你将碎肉糜铺在面坯中央，准备调馅。"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/meat_bun
	steps = list(/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced)
	step_text = list("加入一份洋葱片，捏褶收口")

/datum/z121_cuisine_preparation_recipe/vegetable_bun
	base_type = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	trigger_type = /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	prep_name = "待调馅的菜包面坯"
	start_text = "你将卷心菜丝铺在面坯中央，准备调馅。"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/vegetable_bun
	steps = list(/obj/item/reagent_containers/food/snacks/grown/carrot)
	step_text = list("加入一根胡萝卜，捏褶收口")

/obj/item/reagent_containers/food/snacks/rogue
	var/z121_cuisine_prep_busy = FALSE

/proc/z121_cuisine_fresh(obj/item/reagent_containers/food/snacks/F)
	return !QDELETED(F) && !F.bitecount && F.reagents?.total_volume && F.can_craft_with() && F.eat_effect != /datum/status_effect/debuff/burnedfood

/proc/z121_cuisine_table_check(mob/living/user, obj/item/reagent_containers/food/snacks/B, obj/item/I, check_food = FALSE)
	if(QDELETED(user) || user.stat || !HAS_TRAIT(user, TRAIT_Z121_CUISINE) || QDELETED(I) || !z121_cuisine_fresh(B))
		return FALSE
	if(!isturf(B.loc) || !user.Adjacent(B) || user.get_active_held_item() != I || !(locate(/obj/structure/table) in B.loc))
		return FALSE
	if(check_food && (!istype(I, /obj/item/reagent_containers/food/snacks) || !z121_cuisine_fresh(I)))
		return FALSE
	return TRUE

// 消耗食材时保留其试剂与剩余保质时间，不能靠反复加工洗掉污染或腐败。
/proc/z121_cuisine_absorb(obj/item/reagent_containers/food/snacks/F, obj/item/reagent_containers/food/snacks/into)
	into.reagents.maximum_volume += F.reagents.total_volume
	F.reagents.trans_to(into, F.reagents.total_volume)
	if(F.rotprocess)
		into.warming = min(into.warming, F.warming + F.rotprocess - into.rotprocess)
	qdel(F)

/obj/item/proc/z121_start_cuisine(atom/A, mob/living/user, recipe_path)
	var/datum/z121_cuisine_preparation_recipe/R = new recipe_path
	if(QDELETED(A) || A == src || A.type != R.base_type || !istype(src, R.trigger_type) || user.cmode)
		qdel(R)
		return FALSE
	// 肉类的熟食子类型不能被误当成生肉开新配方。
	if(R.consume_trigger && type != R.trigger_type)
		qdel(R)
		return FALSE
	var/obj/item/reagent_containers/food/snacks/rogue/B = A
	if(B.active_recipe || B.cooked_type && B.current_step > 1)
		qdel(R)
		return FALSE
	if(B.z121_cuisine_prep_busy || user.doing)
		qdel(R)
		return TRUE
	if(!z121_cuisine_table_check(user, B, src, R.consume_trigger))
		to_chat(user, span_warning("你需要美食知识，将新鲜完整的食材放在桌上，再手持工具或配料加工。"))
		qdel(R)
		return TRUE
	B.z121_cuisine_prep_busy = TRUE
	var/success = do_after(user, get_cooking_do_time(user, 3 SECONDS), target = B, extra_checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(z121_cuisine_table_check), user, B, src, R.consume_trigger))
	if(!QDELETED(B))
		B.z121_cuisine_prep_busy = FALSE
	if(!success || !z121_cuisine_table_check(user, B, src, R.consume_trigger))
		qdel(R)
		return TRUE
	var/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/P = new(B.loc)
	P.preparation_recipe = R
	P.name = R.prep_name
	P.icon = B.icon
	P.icon_state = B.icon_state
	if(R.consume_trigger)
		P.add_ingredient_overlay(src)
	to_chat(user, span_notice("[R.start_text]下一步：[R.step_text[1]]。"))
	add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
	z121_cuisine_absorb(B, P)
	if(R.consume_trigger)
		z121_cuisine_absorb(src, P)
	return TRUE

// 仅拦截新增配方的起手组合，其余点击继续进入原版食物与工具交互。
/obj/item/kitchen/rollingpin/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user, /datum/z121_cuisine_preparation_recipe/spring_roll)

/obj/item/rogueweapon/huntingknife/cleaver/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user, /datum/z121_cuisine_preparation_recipe/noodles)

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user, /datum/z121_cuisine_preparation_recipe/hotpot)

/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user, /datum/z121_cuisine_preparation_recipe/dongpo)

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user, /datum/z121_cuisine_preparation_recipe/meat_bun)

/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user, /datum/z121_cuisine_preparation_recipe/vegetable_bun)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation
	name = "尚未配齐的中式食材"
	desc = "放在桌上，按次序逐项加入配料。检视可以查看下一步。"
	icon = 'modular_z121/icon/food.dmi'
	icon_state = "raw_noodles"
	experimental_inhand = TRUE
	list_reagents = list()
	rotprocess = SHELFLIFE_SHORT
	eat_effect = /datum/status_effect/debuff/uncookedfood
	faretype = FARE_IMPOVERISHED
	cooktime = 0
	var/datum/z121_cuisine_preparation_recipe/preparation_recipe
	var/preparation_step = 1

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/examine(mob/user)
	. = ..()
	if(preparation_recipe)
		. += span_notice("下一步：[preparation_recipe.step_text[preparation_step]]。需在桌上加工，并掌握美食知识。")

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/proc/add_ingredient_overlay(obj/item/I)
	var/mutable_appearance/ingredient = mutable_appearance(I.icon, I.icon_state)
	ingredient.transform = matrix() * 0.5
	ingredient.pixel_x = (length(overlays) % 2) ? 6 : -6
	ingredient.pixel_y = length(overlays) < 2 ? 6 : -6
	add_overlay(ingredient)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/proc/step_valid(mob/living/user, obj/item/I)
	if(QDELETED(src) || !preparation_recipe || !z121_cuisine_table_check(user, src, I))
		return FALSE
	var/requirement = preparation_recipe.steps[preparation_step]
	if(ispath(requirement, /datum/reagent))
		return I.reagents?.has_reagent(requirement, preparation_recipe.steps[requirement])
	return I.type == requirement && z121_cuisine_fresh(I)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/attackby(obj/item/I, mob/living/user, params)
	if(user.cmode)
		return ..()
	if(!preparation_recipe || z121_cuisine_prep_busy || user.doing)
		return TRUE
	if(!step_valid(user, I))
		to_chat(user, span_warning("请将新鲜完整的食材放在桌上，由掌握美食知识的人操作。下一步：[preparation_recipe.step_text[preparation_step]]。"))
		return TRUE
	z121_cuisine_prep_busy = TRUE
	var/success = do_after(user, get_cooking_do_time(user, 3 SECONDS), target = src, extra_checks = CALLBACK(src, PROC_REF(step_valid), user, I))
	if(QDELETED(src))
		return TRUE
	z121_cuisine_prep_busy = FALSE
	if(!success || !step_valid(user, I))
		return TRUE
	var/requirement = preparation_recipe.steps[preparation_step]
	if(ispath(requirement, /datum/reagent))
		// 腌料只扣除规定的试剂，容器及其中其他液体留在手中。
		I.reagents.remove_reagent(requirement, preparation_recipe.steps[requirement])
	else
		add_ingredient_overlay(I)
		z121_cuisine_absorb(I, src)
	add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
	preparation_step++
	if(preparation_step <= length(preparation_recipe.steps))
		to_chat(user, span_notice("配料已加入。下一步：[preparation_recipe.step_text[preparation_step]]。"))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/R = new preparation_recipe.result_type(loc)
	R.warming = warming
	// 半成品仍只提供生食营养，污染和额外调味则跟随食材保留。
	reagents.remove_reagent(/datum/reagent/consumable/nutriment, reagents.total_volume)
	R.reagents.maximum_volume += reagents.total_volume
	reagents.trans_to(R, reagents.total_volume)
	to_chat(user, span_nicegreen("你完成了[R.name]的备料，可以下锅了。"))
	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/Destroy()
	QDEL_NULL(preparation_recipe)
	return ..()
