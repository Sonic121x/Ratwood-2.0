// ============================================
// Augmentation Spell Status Effects
// Consolidated from buffs_debuffs/ spell files
// ============================================

// ---- HASTE ----

/atom/movable/screen/alert/status_effect/buff/attune_haste
	name = "协调：迅捷"
	desc = "我的四肢异常迅捷。（速度 +3，动作冷却 x0.85）"
	icon_state = "buff"

#define HASTE_FILTER "haste_glow"

/datum/status_effect/buff/attune_haste
	var/outline_colour ="#F0E68C" // Hopefully not TOO yellow
	id = "haste"
	alert_type = /atom/movable/screen/alert/status_effect/buff/attune_haste
	effectedstats = list(STATKEY_SPD = 3)
	duration = ATTUNE_BUFF_DURATION

/datum/status_effect/buff/attune_haste/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/attune_haste/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>协调：迅捷（速度 +3，动作冷却 x0.85）！</font>")
	var/filter = owner.get_filter(HASTE_FILTER)
	if (!filter)
		owner.add_filter(HASTE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("我的四肢以不可思议的速度动了起来。"))

/datum/status_effect/buff/attune_haste/on_remove()
	. = ..()
	owner.remove_filter(HASTE_FILTER)
	to_chat(owner, span_warning("我的身体又迟缓了下来……"))

#undef HASTE_FILTER

/datum/status_effect/buff/attune_haste/nextmove_modifier()
	return 0.85

// ---- GIANT'S STRENGTH ----

#define GIANTSSTRENGTH_FILTER "giantsstrength_glow"

/atom/movable/screen/alert/status_effect/buff/attune_giant
	name = "协调：巨人"
	desc = "我的肌肉得到了强化。（力量 +4）"
	icon_state = "buff"

/datum/status_effect/buff/attune_giant
	var/outline_colour ="#8B0000" // Different from strength potion cuz red = strong
	id = "giantstrength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/attune_giant
	effectedstats = list(STATKEY_STR = 4)
	duration = ATTUNE_BUFF_DURATION

/datum/status_effect/buff/attune_giant/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/attune_giant/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>协调：巨人（力量 +4）！</font>")
	var/filter = owner.get_filter(GIANTSSTRENGTH_FILTER)
	if (!filter)
		owner.add_filter(GIANTSSTRENGTH_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("我的肌肉正变得更加强壮。"))


/datum/status_effect/buff/attune_giant/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的力量正在渐渐消退……"))
	owner.remove_filter(GIANTSSTRENGTH_FILTER)

#undef GIANTSSTRENGTH_FILTER

// ---- HAWK'S EYES ----

#define HAWKSEYES_FILTER "hawkseyes_glow"

/atom/movable/screen/alert/status_effect/buff/attune_hawk
	name = "协调：鹰眼"
	desc = "我的视力变得敏锐。（力量 +1，感知 +4）"
	icon_state = "buff"

/datum/status_effect/buff/attune_hawk
	var/outline_colour ="#ffff00" // Same color as perception potion
	id = "hawkseyes"
	alert_type = /atom/movable/screen/alert/status_effect/buff/attune_hawk
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = 4)
	duration = ATTUNE_BUFF_DURATION
	exclusive_group = "augment_perception"
	exclusive_priority = 2 // supersedes Guidance

/datum/status_effect/buff/attune_hawk/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/attune_hawk/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>协调：鹰眼（力量 +1，感知 +4）！</font>")
	var/filter = owner.get_filter(HAWKSEYES_FILTER)
	if (!filter)
		owner.add_filter(HAWKSEYES_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("我的视力变得如鹰一般敏锐。"))


/datum/status_effect/buff/attune_hawk/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的视野重新变得模糊，失去了那份不自然的锐利。"))
	owner.remove_filter(HAWKSEYES_FILTER)

#undef HAWKSEYES_FILTER

// ---- GUIDANCE ----

#define GUIDANCE_FILTER "guidance_glow"

/atom/movable/screen/alert/status_effect/buff/guidance
	name = "指引术"
	desc = "奥术专注使我的感官更加敏锐。（感知 +3）"
	icon_state = "buff"

/datum/status_effect/buff/guidance
	var/outline_colour ="#f58e2d"
	id = "guidance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/guidance
	effectedstats = list(STATKEY_PER = 3)
	duration = STAT_BUFF_SELF_DURATION
	exclusive_group = "augment_perception"
	exclusive_priority = 1 // yields to Hawk's Eyes

/datum/status_effect/buff/guidance/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/guidance/on_apply()
	. = ..()
	if(!.)
		return
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>指引（感知 +3）！</font>")
	var/filter = owner.get_filter(GUIDANCE_FILTER)
	if (!filter)
		owner.add_filter(GUIDANCE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("奥术使我的感官更加敏锐。"))

/datum/status_effect/buff/guidance/on_remove()
	. = ..()
	owner.remove_filter(GUIDANCE_FILTER)
	if(rejected_by_exclusion)
		return
	to_chat(owner, span_warning("奥术赋予的清明从感官中消退。"))

#undef GUIDANCE_FILTER

// ---- FORTITUDE ----

/atom/movable/screen/alert/status_effect/buff/fortitude
	name = "坚韧术"
	desc = "我的体液更能抵御身体疲劳。（体力消耗 -15%）"
	icon_state = "buff"

#define FORTITUDE_FILTER "fortitude_glow"

/datum/status_effect/buff/fortitude
	var/outline_colour ="#008000" // Forest green to avoid le sparkle mage
	id = "fortitude"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortitude
	duration = STAT_BUFF_SELF_DURATION

/datum/status_effect/buff/fortitude/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/fortitude/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>坚韧（体力消耗 -15%）！</font>")
	var/filter = owner.get_filter(FORTITUDE_FILTER)
	if (!filter)
		owner.add_filter(FORTITUDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("我的身体感觉轻盈了许多......"))
	ADD_TRAIT(owner, TRAIT_FORTITUDE, MAGIC_TRAIT)

/datum/status_effect/buff/fortitude/on_remove()
	. = ..()
	owner.remove_filter(FORTITUDE_FILTER)
	to_chat(owner, span_warning("世界的重压再次落回了我的肩头。"))
	REMOVE_TRAIT(owner, TRAIT_FORTITUDE, MAGIC_TRAIT)

#undef FORTITUDE_FILTER

// ---- FEATHERFALL ----
// (alert + status effect originally in roguebuff.dm)

/atom/movable/screen/alert/status_effect/buff/featherfall
	name = "羽落术"
	desc = "我在一定程度上不易因高处坠落受伤。"
	icon_state = "buff"

/datum/status_effect/buff/featherfall
	id = "featherfall"
	alert_type = /atom/movable/screen/alert/status_effect/buff/featherfall
	duration = UTILITY_AOE_BUFF_DURATION

/datum/status_effect/buff/featherfall/on_apply()
	. = ..()
	to_chat(owner, span_warning("我感觉更轻了。"))
	ADD_TRAIT(owner, TRAIT_NOFALLDAMAGE2, MAGIC_TRAIT)

/datum/status_effect/buff/featherfall/on_remove()
	. = ..()
	to_chat(owner, span_warning("轻盈的感觉消散了。"))
	REMOVE_TRAIT(owner, TRAIT_NOFALLDAMAGE2, MAGIC_TRAIT)

// ---- DARKVISION ----
// (alert + status effect originally in roguebuff.dm)

/atom/movable/screen/alert/status_effect/buff/darkvision
	name = "黑暗视觉"
	desc = "我在黑暗中也能看清一些。"
	icon_state = "darkvision"

/datum/status_effect/buff/darkvision
	id = "darkvision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/darkvision
	duration = UTILITY_AOE_BUFF_DURATION

/datum/status_effect/buff/darkvision/on_apply(mob/living/new_owner)
	. = ..()
	to_chat(owner, span_warning("黑暗稍微退去了。"))
	ADD_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/datum/status_effect/buff/darkvision/on_remove()
	. = ..()
	to_chat(owner, span_warning("黑暗又恢复如常。"))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/nitevision
	name = "夜视"
	desc = "我能在黑暗中视物。"
	icon_state = "darkvision"

/datum/status_effect/buff/nitevision
	id = "nitevision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nitevision
	duration = UTILITY_AOE_BUFF_DURATION

/datum/status_effect/buff/nitevision/on_apply(mob/living/new_owner)
	. = ..()
	to_chat(owner, span_warning("黑暗退散了。"))
	ADD_TRAIT(owner, TRAIT_NITEVISION, MAGIC_TRAIT)

/datum/status_effect/buff/nitevision/on_remove()
	. = ..()
	to_chat(owner, span_warning("黑暗又恢复如常。"))
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, MAGIC_TRAIT)

// ---- IRON SKIN ----

#define IRON_SKIN_FILTER "iron_skin_glow"

/atom/movable/screen/alert/status_effect/buff/iron_skin
	name = "铁肤术"
	desc = "奥术钢铁碎片围绕着我的护甲，削弱袭来的攻击。"
	icon_state = "buff"

/datum/status_effect/buff/iron_skin
	var/outline_colour = "#708090"
	id = "iron_skin"
	alert_type = /atom/movable/screen/alert/status_effect/buff/iron_skin
	duration = STAT_BUFF_SELF_DURATION

/datum/status_effect/buff/iron_skin/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/iron_skin/on_apply()
	. = ..()
	var/filter = owner.get_filter(IRON_SKIN_FILTER)
	if(!filter)
		owner.add_filter(IRON_SKIN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))
	to_chat(owner, span_notice("奥术钢铁碎片围绕着我的护甲，削弱袭来的打击与攻击。"))

/datum/status_effect/buff/iron_skin/on_remove()
	. = ..()
	to_chat(owner, span_warning("铁壳片片剥落。"))
	owner.remove_filter(IRON_SKIN_FILTER)

#undef IRON_SKIN_FILTER

/datum/status_effect/buff/augury
	duration = AUGURY_DURATION
	exclusive_group = AUGURY_GROUP
	var/outline_colour = "#a980df"
	var/announce = ""

/datum/status_effect/buff/augury/on_creation(mob/living/new_owner, new_duration = null, ascended = FALSE)
	if(new_duration)
		duration = new_duration
	if(ascended)
		exclusive_group = null
	. = ..()

/datum/status_effect/buff/augury/on_apply()
	. = ..()
	if(!.)
		return
	if(announce)
		owner.balloon_alert_to_viewers("<font color='[outline_colour]'>[announce]</font>")
	if(!owner.get_filter("[id]_glow"))
		owner.add_filter("[id]_glow", 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))

/datum/status_effect/buff/augury/on_remove()
	. = ..()
	owner.remove_filter("[id]_glow")

// ---- Augury: Might ----

/atom/movable/screen/alert/status_effect/buff/augury_might
	name = "占卜：蛮力"
	desc = "奥术力量涌入我的肌肉。（力量 +3）"
	icon_state = "buff"

/datum/status_effect/buff/augury/might
	id = "augury_might"
	alert_type = /atom/movable/screen/alert/status_effect/buff/augury_might
	effectedstats = list(STATKEY_STR = 3)
	outline_colour = "#8B0000"
	announce = "蛮力（力量 +3）！"

// ---- Augury: Hawk's Mark ----

/atom/movable/screen/alert/status_effect/buff/augury_hawks_mark
	name = "占卜：鹰之印"
	desc = "奥术使我的瞄准更加精准。（感知 +3）"
	icon_state = "buff"

/datum/status_effect/buff/augury/hawks_mark
	id = "augury_hawks_mark"
	alert_type = /atom/movable/screen/alert/status_effect/buff/augury_hawks_mark
	effectedstats = list(STATKEY_PER = 3)
	outline_colour = "#ffff00"
	announce = "鹰之印（感知 +3）！"

// ---- Augury: Fleetness ----

/atom/movable/screen/alert/status_effect/buff/augury_fleetness
	name = "占卜：轻捷"
	desc = "我的四肢动作轻快。（速度 +2，动作冷却 x0.9）"
	icon_state = "buff"

/datum/status_effect/buff/augury/fleetness
	id = "augury_fleetness"
	alert_type = /atom/movable/screen/alert/status_effect/buff/augury_fleetness
	effectedstats = list(STATKEY_SPD = 2)
	outline_colour = "#F0E68C"
	announce = "轻捷（速度 +2）！"

/datum/status_effect/buff/augury/fleetness/nextmove_modifier()
	return 0.9

// ---- Augury: Second Wind ----

/atom/movable/screen/alert/status_effect/buff/augury_second_wind
	name = "占卜：重振"
	desc = "疲惫从我的肩头卸去。（体力消耗 -25%）"
	icon_state = "buff"

/datum/status_effect/buff/augury/second_wind
	id = "augury_second_wind"
	alert_type = /atom/movable/screen/alert/status_effect/buff/augury_second_wind
	outline_colour = "#008000"
	announce = "重振！"

/datum/status_effect/buff/augury/second_wind/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_FORTITUDE, "augury_second_wind")
	owner.stamina_add(-15)

/datum/status_effect/buff/augury/second_wind/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_FORTITUDE, "augury_second_wind")


/datum/status_effect/buff/empowered_strike/augury
	exclusive_group = AUGURY_GROUP

/datum/status_effect/buff/empowered_strike/augury/on_creation(mob/living/new_owner, new_duration, ascended = FALSE)
	if(ascended)
		exclusive_group = null
	return ..()

/datum/status_effect/buff/adrenaline_rush/augury
	exclusive_group = AUGURY_GROUP

/datum/status_effect/buff/adrenaline_rush/augury/on_creation(mob/living/new_owner, new_duration = null, ascended = FALSE)
	if(new_duration)
		duration = new_duration
	if(ascended)
		exclusive_group = null
	return ..()

/datum/status_effect/buff/adrenaline_rush/augury/on_apply()
	. = ..()
	if(!.)
		return
	owner.balloon_alert_to_viewers("<font color='#c62f2f'>奔涌！</font>")

/datum/status_effect/buff/iron_skin/augury
	exclusive_group = AUGURY_GROUP

/datum/status_effect/buff/iron_skin/augury/on_creation(mob/living/new_owner, new_duration = null, ascended = FALSE)
	if(ascended)
		exclusive_group = null
	return ..()

/datum/status_effect/buff/iron_skin/augury/on_apply()
	. = ..()
	if(!.)
		return
	owner.balloon_alert_to_viewers("<font color='#708090'>壁垒！</font>")

/atom/movable/screen/alert/status_effect/buff/second_chance
	name = "再度奋起"
	desc = "魔法韧性使我坚强——我能抵抗重创，也不再因疼痛踉跄。"
	icon_state = "buff"

/datum/status_effect/buff/second_chance
	id = "second_chance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/second_chance
	duration = 30 SECONDS

/datum/status_effect/buff/second_chance/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, MAGIC_TRAIT)

/datum/status_effect/buff/second_chance/on_remove()
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, MAGIC_TRAIT)
	. = ..()
