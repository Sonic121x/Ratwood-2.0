/datum/artificer_recipe/z121_internal_distiller
	name = "腔内蒸馏装置"
	i_type = "医疗装置"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/organ/z121_internal_distiller
	appro_skill = /datum/skill/craft/engineering
	skill_level = SKILL_LEVEL_JOURNEYMAN
	hammers_per_item = 5
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/ingot/copper, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/alch/coaldust, /obj/item/alch/coaldust)

/datum/artificer_recipe/z121_internal_distiller/New(obj/item/workpiece)
	..()
	parent = workpiece
	additional_items = additional_items.Copy()

/datum/artificer_recipe/z121_internal_distiller/z121_can_craft(mob/user, feedback = FALSE)
	if(!..())
		return FALSE
	if(!user || user.get_skill_level(appro_skill) < skill_level)
		if(user && feedback)
			to_chat(user, span_warning("制作腔内蒸馏装置需要熟练级工程技艺。"))
		return FALSE
	if(needed_item == /obj/item/reagent_containers/glass/bottle/alchemical)
		var/obj/item/reagent_containers/glass/bottle/alchemical/bottle = user.get_active_held_item()
		if(istype(bottle) && bottle.reagents?.total_volume)
			if(feedback)
				to_chat(user, span_warning("必须使用已经倒空的炼金瓶。"))
			return FALSE
	return TRUE

// 逐项取出需求，保留两份煤尘；完成时自行产出，避免通用工匠台额外创建展示用实体。
/datum/artificer_recipe/z121_internal_distiller/advance(obj/item/tool, mob/living/user)
	if(!z121_can_craft(user, TRUE))
		return
	var/obj/item/workpiece = parent
	if(QDELETED(workpiece) || !istype(workpiece.loc, /obj/machinery/artificer_table))
		return
	var/obj/machinery/artificer_table/table = workpiece.loc
	if(!table.z121_recipe_context_valid(user, workpiece) || workpiece.artrecipe != src || !user.is_holding(tool))
		return
	if(hammers_per_item > 0)
		var/skill = user.get_skill_level(appro_skill)
		var/hammer_progress = skill >= SKILL_LEVEL_LEGENDARY ? 3 : (skill >= SKILL_LEVEL_EXPERT ? 2 : 1)
		hammers_per_item = max(0, hammers_per_item - hammer_progress)
		user.visible_message(span_notice("[user]敲打着蒸馏装置的铜制外壳。"))
		return
	if(needed_item)
		return
	if(length(additional_items))
		hammered = TRUE
		needed_item = additional_items[1]
		additional_items.Cut(1, 2)
		to_chat(user, span_info("现在该加入[initial(needed_item.name)]了。"))
		return
	new created_item(get_turf(table))
	user.visible_message(span_notice("[user]完成了一件腔内蒸馏装置。"))
	user.log_message("在工匠台制作了腔内蒸馏装置。", LOG_GAME)
	user.mind?.add_sleep_experience(appro_skill, user.STAINT * skill_level * 5)
	qdel(workpiece)

// 专用手术只处理这一个槽位，不改变普通胸部器官手术的锯骨要求。
/datum/surgery_step/z121_distiller_insert
	name = "植入腔内蒸馏装置"
	time = 6.4 SECONDS
	implements = list(/obj/item/organ/z121_internal_distiller = 80)
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living/carbon/human)
	surgery_flags = SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/z121_distiller_insert/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	return ..() && !target.getorganslot("腔内蒸馏装置")

/datum/surgery_step/z121_distiller_insert/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始将[tool]固定在[target]的胸腔内……"), span_notice("[user]开始将[tool]固定在[target]的胸腔内。"), span_notice("[user]正在处理[target]的胸部切口。"))
	return TRUE

/datum/surgery_step/z121_distiller_insert/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(QDELETED(tool) || user.get_active_held_item() != tool || !can_do_step(user, target, target_zone, tool, intent))
		return FALSE
	var/obj/item/organ/z121_internal_distiller/distiller = tool
	if(distiller.owner || !user.temporarilyRemoveItemFromInventory(distiller))
		return FALSE
	distiller.Insert(target)
	if(distiller.owner != target)
		user.put_in_hands(distiller)
		return FALSE
	display_results(user, target, span_notice("我将蒸馏装置稳稳固定在[target]的胸腔内。"), span_notice("[user]将蒸馏装置固定在[target]的胸腔内。"), span_notice("[user]完成了[target]胸腔内的装置固定。"))
	log_combat(user, target, "植入了腔内蒸馏装置")
	return TRUE

/datum/surgery_step/z121_distiller_remove
	name = "摘除腔内蒸馏装置"
	time = 6.4 SECONDS
	implements = list(TOOL_HEMOSTAT = 80, TOOL_IMPROVISED_HEMOSTAT = 70)
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living/carbon/human)
	required_organs = list("腔内蒸馏装置")
	surgery_flags = SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/z121_distiller_remove/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("我开始松开[target]胸腔内蒸馏装置的固定带……"), span_notice("[user]开始松开[target]胸腔内蒸馏装置的固定带。"), span_notice("[user]正在处理[target]的胸部切口。"))
	return TRUE

/datum/surgery_step/z121_distiller_remove/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(QDELETED(tool) || user.get_active_held_item() != tool || !can_do_step(user, target, target_zone, tool, intent))
		return FALSE
	var/obj/item/organ/z121_internal_distiller/distiller = target.getorganslot("腔内蒸馏装置")
	distiller.Remove(target)
	distiller.forceMove(target.drop_location())
	user.put_in_hands(distiller)
	display_results(user, target, span_notice("我从[target]的胸腔内取出了蒸馏装置。"), span_notice("[user]从[target]的胸腔内取出了蒸馏装置。"), span_notice("[user]从[target]的胸部切口取出了一件铜制装置。"))
	log_combat(user, target, "摘除了腔内蒸馏装置")
	return TRUE
