// 使用独立槽位与独立储液器，不占用胃，也不把成品加入宿主血液中的试剂容器。
/obj/item/organ/z121_internal_distiller
	name = "腔内蒸馏装置"
	desc = "以皮革固定带包裹的铜制蒸馏罐，盘管通向胸前的小阀门。植入胸腔后，可将吞入的材料制成饮品，每单位成品消耗一点血量，最多储存二百四十单位同种饮品。"
	icon = 'modular_z121/icon/item.dmi'
	icon_state = "internal_distiller"
	zone = BODY_ZONE_CHEST
	slot = "腔内蒸馏装置"
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC
	var/datum/z121_distiller_recipe/selected_recipe
	var/datum/z121_distiller_recipe/pending_recipe
	var/batch_timer
	var/last_recipe_name

/obj/item/organ/z121_internal_distiller/Initialize(mapload)
	. = ..()
	create_reagents(240, NO_REACT)

/obj/item/organ/z121_internal_distiller/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	if(!ishuman(M) || M.getorganslot(slot))
		return
	. = ..()
	if(owner != M)
		return
	RegisterSignal(M, COMSIG_LIVING_DEATH, PROC_REF(on_host_death))
	RegisterSignal(M, COMSIG_MOB_LOGIN, PROC_REF(grant_verbs))
	grant_verbs()

/obj/item/organ/z121_internal_distiller/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	var/mob/living/carbon/previous_owner = owner
	if(previous_owner)
		UnregisterSignal(previous_owner, list(COMSIG_LIVING_DEATH, COMSIG_MOB_LOGIN))
		previous_owner.verbs -= list(/mob/living/carbon/human/proc/z121_choose_distiller_recipe, /mob/living/carbon/human/proc/z121_swallow_distiller_material)
		if(pending_recipe)
			to_chat(previous_owner, span_warning("蒸馏装置已被摘除，尚未完成的原料随之报废。"))
	cancel_batch()
	return ..()

/obj/item/organ/z121_internal_distiller/Destroy()
	cancel_batch()
	selected_recipe = null
	return ..()

/obj/item/organ/z121_internal_distiller/proc/grant_verbs()
	SIGNAL_HANDLER
	if(owner)
		owner.verbs |= list(/mob/living/carbon/human/proc/z121_choose_distiller_recipe, /mob/living/carbon/human/proc/z121_swallow_distiller_material)

/obj/item/organ/z121_internal_distiller/proc/on_host_death()
	SIGNAL_HANDLER
	cancel_batch()

/obj/item/organ/z121_internal_distiller/proc/cancel_batch()
	if(batch_timer)
		deltimer(batch_timer)
		batch_timer = null
	pending_recipe = null

/obj/item/organ/z121_internal_distiller/examine(mob/user)
	. = ..()
	. += span_info("储液量：[reagents.total_volume]／240单位。[pending_recipe ? "正在制作[pending_recipe.name]。" : "装置处于空闲状态。"]")
	if(reagents.total_volume)
		var/datum/reagent/stored = reagents.reagent_list[1]
		. += span_info("罐内装着[stored.name]。")

/obj/item/organ/z121_internal_distiller/proc/usable_by(mob/living/carbon/human/user)
	if(QDELETED(user) || user != owner || user.getorganslot(slot) != src)
		return FALSE
	if(user.incapacitated())
		to_chat(user, span_warning("我现在无法操作胸腔里的蒸馏装置。"))
		return FALSE
	if(organ_flags & ORGAN_FAILING)
		to_chat(user, span_warning("胸腔里的蒸馏装置已经损坏。"))
		return FALSE
	return TRUE

/obj/item/organ/z121_internal_distiller/proc/choose_recipe(mob/living/carbon/human/user)
	if(!usable_by(user))
		return
	var/list/recipes = z121_distiller_recipes()
	var/list/categories = list("基础茶饮", "初阶酿造", "二段蒸馏", "杂项")
	var/category = input(user, "选择配方分类。储液量：[reagents.total_volume]／240单位。", "蒸馏配方") as null|anything in categories
	if(!category || !usable_by(user))
		return
	var/list/options = list()
	for(var/recipe_name in recipes)
		var/datum/z121_distiller_recipe/recipe = recipes[recipe_name]
		if(recipe.category == category)
			options[recipe.name] = recipe
	var/chosen = input(user, "选择下一批的配方。当前选择：[selected_recipe ? selected_recipe.name : "无"]。", "蒸馏配方") as null|anything in options
	if(!chosen || !usable_by(user))
		return
	selected_recipe = options[chosen]
	to_chat(user, span_info("已选择[selected_recipe.name]。原料：[selected_recipe.material_description()]。制作耗时15秒，产出[selected_recipe.output_amount]单位，消耗[selected_recipe.output_amount]点血量。"))
	if(pending_recipe)
		to_chat(user, span_info("当前批次仍在制作[pending_recipe.name]，新配方将在下一批使用。"))

/obj/item/organ/z121_internal_distiller/proc/swallow_material(mob/living/carbon/human/user)
	if(!usable_by(user))
		return
	if(pending_recipe)
		to_chat(user, span_warning("上一批饮品还没有制作完成。"))
		return
	var/datum/z121_distiller_recipe/recipe = selected_recipe
	if(!recipe)
		to_chat(user, span_warning("我还没有选择蒸馏配方。"))
		return
	if(reagents.total_volume + recipe.output_amount > reagents.maximum_volume)
		to_chat(user, span_warning("罐内没有足够容纳这一整批饮品的空间。"))
		return
	if(reagents.total_volume)
		var/datum/reagent/stored = reagents.reagent_list[1]
		if(length(reagents.reagent_list) != 1 || stored.type != recipe.output_reagent)
			to_chat(user, span_warning("罐内还有其他饮品，必须先取空才能制作[recipe.name]。"))
			return
	if((NOBLOOD in user.dna?.species?.species_traits) || user.get_blood_volume() - recipe.output_amount < BLOOD_VOLUME_NORMAL * 0.6)
		to_chat(user, span_warning("我的血量不足，无法安全制作这一批饮品。"))
		return
	var/obj/item/material = user.get_active_held_item()
	if(QDELETED(material))
		to_chat(user, span_warning("我需要把符合配方的材料拿在主动手中。"))
		return
	if(recipe.input_amount)
		var/obj/item/reagent_containers/glass/container = material
		if(!istype(container) || container.closed || !container.spillable || !container.is_drainable())
			to_chat(user, span_warning("我需要拿着盛有对应原料的开口容器。"))
			return
		var/matched_reagent
		for(var/reagent_path in recipe.input_reagents)
			if(container.reagents.get_reagent_amount(reagent_path) >= recipe.input_amount)
				matched_reagent = reagent_path
				break
		if(!matched_reagent)
			to_chat(user, span_warning("容器中的对应原料不足。需要：[recipe.material_description()]。"))
			return
		container.reagents.remove_reagent(matched_reagent, recipe.input_amount, TRUE)
		user.visible_message(span_notice("[user]将[container]中的一口原料饮入了胸腔里的蒸馏装置。"), span_notice("我将[recipe.input_amount]单位原料吞入胸腔里的蒸馏装置。"))
	else
		if(!(material.type in recipe.input_items))
			to_chat(user, span_warning("手上的材料不符合配方。需要：[recipe.material_description()]。"))
			return
		if(!user.temporarilyRemoveItemFromInventory(material))
			to_chat(user, span_warning("我无法松开手上的材料。"))
			return
		user.visible_message(span_notice("[user]将[material]整个吞入了胸腔里的蒸馏装置。"), span_notice("我将[material]整个吞入了胸腔里的蒸馏装置。"))
		qdel(material)
	// 先锁定批次并登记定时器，再扣血；血量变化触发其他能力时也能正确取消制作。
	pending_recipe = recipe
	batch_timer = addtimer(CALLBACK(src, PROC_REF(finish_batch)), 15 SECONDS, TIMER_STOPPABLE)
	user.adjust_blood_volume(-recipe.output_amount)
	to_chat(user, span_info("胸腔里的盘管微微发热，开始制作[recipe.name]。"))

/obj/item/organ/z121_internal_distiller/proc/finish_batch()
	batch_timer = null
	var/datum/z121_distiller_recipe/recipe = pending_recipe
	pending_recipe = null
	if(!recipe || !owner || owner.stat == DEAD || owner.getorganslot(slot) != src || (organ_flags & ORGAN_FAILING))
		return
	reagents.add_reagent(recipe.output_reagent, recipe.output_amount)
	last_recipe_name = recipe.name
	to_chat(owner, span_notice("胸腔里的蒸馏装置完成了[recipe.output_amount]单位[recipe.name]。现有[reagents.total_volume]／240单位饮品。"))

/obj/item/organ/z121_internal_distiller/proc/dispense(mob/living/carbon/human/user, obj/item/reagent_containers/glass/container)
	if(!usable_by(user) || !user.is_holding(container))
		return
	if(!get_location_accessible(user, BODY_ZONE_CHEST))
		to_chat(user, span_warning("衣物遮住了胸前的取液阀门。"))
		return
	if(container.closed || !container.spillable || !container.is_refillable())
		to_chat(user, span_warning("我需要一个已经打开、可以装液体的容器。"))
		return
	if(!reagents.total_volume)
		to_chat(user, span_warning("蒸馏罐里还没有可取出的饮品。"))
		return
	if(container.reagents.holder_full())
		to_chat(user, span_warning("[container]已经满了。"))
		return
	var/datum/reagent/stored = reagents.reagent_list[1]
	var/drink_name = stored.name
	var/transferred = reagents.trans_to(container, container.amount_per_transfer_from_this, transfered_by = user)
	if(!transferred)
		return
	user.visible_message(span_notice("[user]打开胸前的阀门，将[drink_name]注入[container]。"), span_notice("我从胸前的阀门取出了[transferred]单位[drink_name]。"))
	for(var/mob/living/nearby in get_hearers_in_view(4, user))
		to_chat(nearby, span_notice("[last_recipe_name ? last_recipe_name : drink_name]那无法忽视的香气直冲我的鼻腔。"))

/mob/living/carbon/human/proc/z121_choose_distiller_recipe()
	set name = "蒸馏配方"
	set category = "IC"
	set desc = "选择胸腔蒸馏装置下一批饮品的配方。"
	set hidden = FALSE
	var/obj/item/organ/z121_internal_distiller/distiller = getorganslot("腔内蒸馏装置")
	distiller?.choose_recipe(src)

/mob/living/carbon/human/proc/z121_swallow_distiller_material()
	set name = "吞入材料"
	set category = "IC"
	set desc = "把主动手中的配方材料吞入胸腔蒸馏装置。"
	set hidden = FALSE
	var/obj/item/organ/z121_internal_distiller/distiller = getorganslot("腔内蒸馏装置")
	distiller?.swallow_material(src)

// 在容器进入普通交互前处理取酒；其他目标和身体部位沿用原有逻辑。
/obj/item/reagent_containers/glass/pre_attack(atom/target, mob/living/user, params)
	if(target == user && ishuman(user) && user.zone_selected == BODY_ZONE_CHEST && user.used_intent?.type == INTENT_FILL)
		var/mob/living/carbon/human/host = user
		var/obj/item/organ/z121_internal_distiller/distiller = host.getorganslot("腔内蒸馏装置")
		if(distiller)
			distiller.dispense(host, src)
			return TRUE
	return ..()
