/obj/item/hunting_map
	name = "皱巴巴的地图"
	desc = "一张粗略标绘动物迁徙路线与栖息地点的草图。"
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "hunt_map"
	w_class = WEIGHT_CLASS_TINY
	/// Category this map forces
	var/datum/hunting_category/target_category = /datum/hunting_category/low_tier
	/// Skill-based success chances (0-6)
	var/list/skill_chances = list(0, 0, 0, 0, 0, 0, 0)
	/// How much the chance drops per use (0.1 = 10%)
	var/degradation_rate = 0
	/// Current degradation multiplier (1.0 = 100% effectiveness)
	var/current_potency = 1.0
	/// Hard limit on uses
	var/uses_left = -1

/obj/item/hunting_map/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("对新鲜的土堆使用这张地图，可以提高找到图中所记猎物的概率。")
	. += span_info("部分地图的效果取决于狩猎技能，也可能随使用而降低，最终破损。")

/obj/item/hunting_map/afterattack(obj/effect/hunting_track/target, mob/user, proximity)
	if(!proximity || !istype(target))
		return

	if(target.trail_depth > 0 || target.track_revealed)
		to_chat(user, span_warning("这条踪迹已经失去线索或开始追踪了。你必须对新鲜的土堆使用地图。"))
		return

	if(target.hunt_category)
		to_chat(user, span_warning("这条踪迹已经辨认过了。"))
		return

	if(target.influence_attempted)
		to_chat(user, span_warning("这条踪迹已经对照地图确认过最佳路线了。"))
		return

	user.visible_message(span_notice("[user]一边查阅[src]，一边检查地面。"), \
		span_notice("你将泥土中的痕迹与[src]上的标记相互对照..."))

	if(!do_after(user, 3 SECONDS, target = target))
		return

	var/skill = user.get_skill_level(/datum/skill/misc/hunting)
	var/base_chance = skill_chances[skill + 1]
	var/final_chance = base_chance * current_potency

	if(prob(final_chance))
		target.secret_map_influence = target_category
	target.influence_attempted = TRUE
	to_chat(user, span_info("你对这条踪迹的去向多了几分把握。"))

	// Handle Degradation
	if(degradation_rate > 0)
		current_potency = max(0, current_potency - degradation_rate)
		if(current_potency <= 0)
			to_chat(user, span_danger("[src]已经完全无法辨认，散成了碎片。"))
			qdel(src)
			return

	// Handle Use Limit
	if(uses_left > 0)
		uses_left--
		if(uses_left <= 0)
			to_chat(user, span_danger("[src]因反复使用而破成了无用的纸屑。"))
			qdel(src)

/obj/item/hunting_map/white_stag
	name = "白鹿传说"
	desc = "一张用受祝福的银墨精细绘制的神秘地图，据说记录了巨型白鹿的行踪。只有最出色的猎人才能将其与动物踪迹相互对照，正确解读其中的线索。"
	target_category = /datum/hunting_category/white_stag
	skill_chances = list(1, 1, 5, 10, 14, 18, 20)
	degradation_rate = 0.1 // 10% drop per use
	uses_left = 3

/obj/item/hunting_map/white_stag/debug
	skill_chances = list(100, 100, 100, 100, 100, 100, 100)
	uses_left = 1
	degradation_rate = 0

/obj/item/hunting_map/boars
	name = "野猪踪迹图"
	desc = "一张标明近期野猪袭击地点的简易地图，熟练的猎人很容易看懂。"
	target_category = /datum/hunting_category/boars
	skill_chances = list(20, 30, 40, 50, 70, 90, 100)
	degradation_rate = 0
	uses_left = 5
