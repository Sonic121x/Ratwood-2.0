// 菜单会暂停执行；每次返回都核对原工作件，避免把选择应用到被替换的材料上。
/obj/machinery/artificer_table/proc/z121_recipe_context_valid(mob/user, obj/item/workpiece)
	return !QDELETED(src) && !QDELETED(user) && !QDELETED(workpiece) && material == workpiece && workpiece.loc == src && user.Adjacent(src) && !user.incapacitated()

// 覆写原菜单以按操作者过滤权限，不临时删改全局配方列表。
/obj/machinery/artificer_table/choose_recipe(mob/user)
	var/obj/item/workpiece = material
	if(!z121_recipe_context_valid(user, workpiece) || workpiece.artrecipe)
		return FALSE
	var/list/valid_types = list()
	for(var/datum/artificer_recipe/recipe in GLOB.artificer_recipes)
		if(recipe.required_item && istype(workpiece, recipe.required_item) && recipe.z121_can_craft(user))
			valid_types |= recipe.i_type
	if(!length(valid_types))
		return FALSE
	var/category = input(user, "选择制作分类", "工匠台") as null|anything in valid_types
	if(!category || !z121_recipe_context_valid(user, workpiece) || workpiece.artrecipe)
		return FALSE
	var/list/available_recipes = list()
	for(var/datum/artificer_recipe/recipe in GLOB.artificer_recipes)
		if(recipe.i_type == category && recipe.required_item && istype(workpiece, recipe.required_item) && recipe.z121_can_craft(user))
			available_recipes += recipe
	if(!length(available_recipes))
		return FALSE
	var/datum/artificer_recipe/chosen = input(user, "选择制作物品", "工匠台") as null|anything in sortNames(available_recipes.Copy())
	if(!chosen || !z121_recipe_context_valid(user, workpiece) || workpiece.artrecipe)
		return FALSE
	if(!(chosen in available_recipes) || !chosen.required_item || !istype(workpiece, chosen.required_item) || !chosen.z121_can_craft(user, TRUE))
		return FALSE
	workpiece.artrecipe = new chosen.type(workpiece)
	return TRUE

// 原工匠台在消耗材料与产出前没有可拦截的信号，故在模块内保留其流程并插入权限检查。
/obj/machinery/artificer_table/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/natural/wood/plank) || istype(I, /obj/item/ingot) || istype(I, /obj/item/rogueore) || istype(I, /obj/item/storage/backpack/rogue/satchel))
		if(!material)
			I.forceMove(src)
			material = I
			update_icon()
			return
	if(istype(I, /obj/item/rogueweapon/hammer))
		user.changeNext_move(CLICK_CD_RAPID)
		if(!material)
			return
		if(!material.artrecipe)
			if(!choose_recipe(user))
				return
		// 同一次检查覆盖敲击、低技能失败判定和最终产出，拒绝时不损耗工作件。
		if(!z121_recipe_context_valid(user, material) || !user.is_holding(I) || !material.artrecipe?.z121_can_craft(user, TRUE))
			return
		if(material.artrecipe.hammered || material.artrecipe.progress == 100)
			playsound(src, 'sound/combat/hits/onmetal/sheet (2).ogg', 100, TRUE)
			shake_camera(user, 1, 1)
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_turf(src)
		S.set_up(1, 1, front)
		S.start()
		var/skill = user.get_skill_level(material.artrecipe.appro_skill)
		if(material.artrecipe.progress == 100)
			if(islist(material.artrecipe.created_item))
				var/list/L = material.artrecipe.created_item
				for(var/IT in L)
					new IT(get_turf(src))
			else
				new material.artrecipe.created_item(get_turf(src))
			var/obj/item/created_item_instance = new(material.artrecipe.created_item)
			user.visible_message(span_info("[user]制作出了[created_item_instance.name]。"))
			user.log_message("crafted [english_list(islist(material.artrecipe.created_item) ? material.artrecipe.created_item : list(material.artrecipe.created_item))] at [src] ([material.artrecipe.type])", LOG_GAME)
			user.mind.add_sleep_experience(material.artrecipe.appro_skill, (user.STAINT * (material.artrecipe.skill_level * 5)))
			qdel(material)
			material = null
			update_icon()
			return
		// 维持原有难度规则：技能不足仍可尝试，只承担原有制作失败概率。
		if(skill < material.artrecipe.skill_level)
			if(prob(max(0, 25 - user.goodluck(2) - (skill * 2))))
				to_chat(user, span_warning("你的技艺不足，损坏了这件工作件。"))
				playsound(src, 'sound/combat/hits/onwood/destroyfurniture.ogg', 100, FALSE)
				user.mind.add_sleep_experience(material.artrecipe.appro_skill, (user.STAINT * material.artrecipe.skill_level))
				qdel(material)
				material = null
				return
		if(!material.artrecipe.hammered)
			playsound(src, pick('sound/combat/hits/onwood/fence_hit1.ogg', 'sound/combat/hits/onwood/fence_hit2.ogg', 'sound/combat/hits/onwood/fence_hit3.ogg'), 100, FALSE)
			material.artrecipe.advance(I, user)
		return
	if(material && material.artrecipe && material.artrecipe.hammered && istype(I, material.artrecipe.needed_item))
		// 必须在调用追加材料和删除物品之前检查，防止无权限者接手半成品。
		if(!z121_recipe_context_valid(user, material) || !user.is_holding(I) || !material.artrecipe.z121_can_craft(user, TRUE))
			return
		material.artrecipe.item_added(user)
		qdel(I)
		return
	// 保留父级交互及其信号，虚空魔方的齿轮基底仍从这里接入。
	return ..()
