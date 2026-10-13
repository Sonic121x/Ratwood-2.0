// 配方只读共享，进度与容器属于每份食材。
/datum/z121_cuisine_preparation_recipe
	var/base_type
	var/trigger_type
	var/trigger_kind = "food"
	var/trigger_amount = 0
	var/trigger_time = 3 SECONDS
	var/requires_knowledge = TRUE
	var/keeps_bowl = FALSE
	var/prep_name
	var/prep_icon
	var/prep_cooked = FALSE
	var/result_type
	var/list/steps

GLOBAL_LIST_INIT(z121_cuisine_recipes, z121_build_cuisine_recipes())

/proc/z121_build_cuisine_recipes()
	. = list()
	for(var/path in subtypesof(/datum/z121_cuisine_preparation_recipe))
		var/datum/z121_cuisine_preparation_recipe/R = new path()
		if(R.base_type)
			.[path] = R

/obj/item/reagent_containers/food/snacks
	var/z121_cuisine_prep_busy = FALSE
	var/z121_requires_bowl = FALSE

/proc/z121_cuisine_fresh(obj/item/reagent_containers/food/snacks/F)
	return !QDELETED(F) && !F.bitecount && F.reagents?.total_volume && F.can_craft_with() && F.eat_effect != /datum/status_effect/debuff/burnedfood && (!F.rotprocess || F.warming >= -F.rotprocess)

/proc/z121_cuisine_table_check(mob/living/user, obj/item/reagent_containers/food/snacks/B, obj/item/I, knowledge = TRUE)
	if(QDELETED(user) || user.stat || user.cmode || (knowledge && !HAS_TRAIT(user, TRAIT_Z121_CUISINE)) || QDELETED(I) || !z121_cuisine_fresh(B))
		return FALSE
	if(!isturf(B.loc) || !user.Adjacent(B) || user.get_active_held_item() != I || !(locate(/obj/structure/table) in B.loc))
		return FALSE
	if(B.z121_requires_bowl)
		var/obj/item/reagent_containers/glass/bowl/bowl = B.trash
		if(!istype(bowl) || QDELETED(bowl) || bowl.loc != B || bowl.reagents.total_volume)
			return FALSE
	return TRUE

/proc/z121_cuisine_ingredient_check(obj/item/I, requirement, kind, amount)
	if(QDELETED(I))
		return FALSE
	switch(kind)
		if("reagent")
			if(istype(I, /obj/item/reagent_containers/food/snacks) && !z121_cuisine_fresh(I))
				return FALSE
			return I.reagents?.has_reagent(requirement, amount)
		if("tool")
			return istype(I, requirement)
		if("bowl")
			return istype(I, /obj/item/reagent_containers/glass/bowl) && !I.reagents?.total_volume
		if("food")
			return I.type == requirement && istype(I, /obj/item/reagent_containers/food/snacks) && z121_cuisine_fresh(I)
	return FALSE

// 保留污染、剩余保质时间和实际使用的碗；阶段转换不能恢复腐败食材。
/proc/z121_cuisine_transfer(obj/item/reagent_containers/food/snacks/F, obj/item/reagent_containers/food/snacks/into, normalize = FALSE)
	if(normalize)
		F.reagents.remove_reagent(/datum/reagent/consumable/nutriment, F.reagents.total_volume)
	into.reagents.maximum_volume += F.reagents.total_volume
	F.reagents.trans_to(into, F.reagents.total_volume)
	if(F.rotprocess && into.rotprocess)
		into.warming = min(into.warming, F.warming + F.rotprocess - into.rotprocess)
	if(istype(F.trash, /obj/item/reagent_containers/glass/bowl))
		var/obj/item/reagent_containers/glass/bowl/B = F.trash
		F.trash = null
		if(into.z121_requires_bowl)
			B.forceMove(into)
			into.trash = B
		else
			B.forceMove(get_turf(into))

/obj/item/proc/z121_start_valid(atom/A, mob/living/user, datum/z121_cuisine_preparation_recipe/R)
	if(QDELETED(A) || A.type != R.base_type || A == src)
		return FALSE
	if(!z121_cuisine_table_check(user, A, src, R.requires_knowledge))
		return FALSE
	if(istype(A, /obj/item/reagent_containers/food/snacks/rogue))
		var/obj/item/reagent_containers/food/snacks/rogue/F = A
		if(F.active_recipe)
			return FALSE
	return z121_cuisine_ingredient_check(src, R.trigger_type, R.trigger_kind, R.trigger_amount)

/obj/item/proc/z121_start_cuisine(atom/A, mob/living/user)
	if(QDELETED(A) || !isliving(user) || user.cmode)
		return FALSE
	var/datum/z121_cuisine_preparation_recipe/R
	for(var/path in GLOB.z121_cuisine_recipes)
		var/datum/z121_cuisine_preparation_recipe/candidate = GLOB.z121_cuisine_recipes[path]
		if(A.type != candidate.base_type)
			continue
		if(candidate.trigger_kind == "reagent")
			if(!reagents?.has_reagent(candidate.trigger_type))
				continue
		else if(candidate.trigger_kind == "food" ? type != candidate.trigger_type : !istype(src, candidate.trigger_type))
			continue
		R = candidate
		break
	if(!R)
		return FALSE
	var/obj/item/reagent_containers/food/snacks/B = A
	if(B.z121_cuisine_prep_busy || user.doing)
		return TRUE
	if(!z121_start_valid(A, user, R))
		to_chat(user, span_warning("[R.requires_knowledge && !HAS_TRAIT(user, TRAIT_Z121_CUISINE) ? "你尚不熟悉这道菜的做法。" : "还不能动手：食材须新鲜完整，桌边的配料与餐具也得备齐。"]"))
		return TRUE
	B.z121_cuisine_prep_busy = TRUE
	var/success = do_after(user, get_cooking_do_time(user, R.trigger_time), target = B, extra_checks = CALLBACK(src, PROC_REF(z121_start_valid), B, user, R))
	if(!QDELETED(B))
		B.z121_cuisine_prep_busy = FALSE
	if(!success || !z121_start_valid(B, user, R))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/P = new(B.loc)
	P.preparation_recipe = R
	P.name = R.prep_name
	P.icon_state = R.prep_icon
	P.z121_requires_bowl = R.keeps_bowl
	if(R.prep_cooked)
		P.eat_effect = null
	if(R.trigger_kind == "bowl")
		if(!user.transferItemToLoc(src, P))
			qdel(P)
			return TRUE
		P.trash = src
	else if(R.trigger_kind == "reagent")
		reagents.remove_reagent(R.trigger_type, R.trigger_amount)
	z121_cuisine_transfer(B, P)
	qdel(B)
	if(R.trigger_kind == "food")
		z121_cuisine_transfer(src, P)
		qdel(src)
	if(user.mind)
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
	var/list/next = R.steps[1]
	to_chat(user, span_notice("你将[P.name]备好，接着还需[next["text"]]。"))
	return TRUE

// 仅处理新增起手组合，其他原版交互继续交给父过程。
/obj/item/kitchen/rollingpin/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user)

/obj/item/rogueweapon/huntingknife/cleaver/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user)

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user)

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user)

/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage
	name = "待加工的食材"
	desc = "放在桌上，按照食谱继续处理。"
	icon = 'modular_z121/icon/food.dmi'
	experimental_inhand = TRUE
	rotprocess = SHELFLIFE_SHORT
	eat_effect = /datum/status_effect/debuff/uncookedfood
	faretype = FARE_IMPOVERISHED
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	cooktime = 0
	cooked_type = null
	fried_type = null
	deep_fried_type = null

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/attackby(obj/item/I, mob/living/user, params)
	if(!user.cmode && I.z121_start_cuisine(src, user))
		return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/heating_act(atom/A)
	return

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/MiddleClick(mob/user)
	to_chat(user, span_notice("食材还未料理妥当，接下来的做法可查阅《庖厨食典》。"))

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage
	name = "尚未配齐的信义食材"
	desc = "食材铺在一处，还等着添入余下的配料。"
	icon_state = "raw_noodles"
	list_reagents = list()
	var/datum/z121_cuisine_preparation_recipe/preparation_recipe
	var/preparation_step = 1

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/examine(mob/user)
	. = ..()
	if(preparation_recipe)
		var/list/step = preparation_recipe.steps[preparation_step]
		. += span_notice("接下来还需[step["text"]]。")

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/proc/step_valid(mob/living/user, obj/item/I)
	if(QDELETED(src) || !preparation_recipe || !z121_cuisine_table_check(user, src, I, preparation_recipe.requires_knowledge))
		return FALSE
	var/list/step = preparation_recipe.steps[preparation_step]
	return z121_cuisine_ingredient_check(I, step["item"], step["kind"], step["amount"])

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_preparation/attackby(obj/item/I, mob/living/user, params)
	if(user.cmode)
		return ..()
	if(!preparation_recipe || z121_cuisine_prep_busy || user.doing)
		return TRUE
	var/list/step = preparation_recipe.steps[preparation_step]
	if(!step_valid(user, I))
		to_chat(user, span_warning("[preparation_recipe.requires_knowledge && !HAS_TRAIT(user, TRAIT_Z121_CUISINE) ? "你尚不熟悉这道菜的做法。" : "还不能动手：食材须新鲜完整，配料与餐具也得在桌边备齐。"]"))
		return TRUE
	z121_cuisine_prep_busy = TRUE
	var/success = do_after(user, get_cooking_do_time(user, step["time"]), target = src, extra_checks = CALLBACK(src, PROC_REF(step_valid), user, I))
	if(QDELETED(src))
		return TRUE
	z121_cuisine_prep_busy = FALSE
	if(!success || !step_valid(user, I))
		return TRUE
	if(step["kind"] == "reagent")
		I.reagents.remove_reagent(step["item"], step["amount"])
	else if(step["kind"] == "food")
		z121_cuisine_transfer(I, src)
		qdel(I)
	if(step["icon"])
		icon_state = step["icon"]
	if(step["name"])
		name = step["name"]
	if(user.mind)
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
	preparation_step++
	if(preparation_step <= length(preparation_recipe.steps))
		var/list/next = preparation_recipe.steps[preparation_step]
		to_chat(user, span_notice("你料理好了手边的食材，接着还需[next["text"]]。"))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/R = new preparation_recipe.result_type(loc)
	z121_cuisine_transfer(src, R, TRUE)
	to_chat(user, span_nicegreen("你备好了[R.name]。"))
	qdel(src)
	return TRUE
