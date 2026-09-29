/// The pear of anguish actions are uniquely locked behind both partners having extreme ERP toggled.
/// Observers do not see the flavor text spans for these actions unless they have extreme ERP toggled.
/datum/sex_action/manticore_pear_anal
	parent_type = /datum/sex_action/tailmaw/pear
	name = "痛苦之梨（肛门）"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS
	user_sex_part = SEX_PART_TAIL_MAW
	wound_type = /datum/wound/fracture/groin

/datum/sex_action/manticore_pear_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.visible_message(span_userdanger("[user]将闭合的尾苞抵住[target]的肛缘，相互咬合的板片彼此摩擦，以残忍而刻意缓慢的速度强行挤入。"), ignored_mobs = excluded)
	playsound(target, 'sound/misc/mat/insert (1).ogg', 35, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_pear_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.sexcon_action_message(span_userdanger("[user]的尾苞开始在[target]的肛内绽开，骨质板片伴着吱嘎摩擦声张开，将[target]的内部撑得远超血肉所能承受的极限。[target]的尖叫中，夹杂着体内深处某物破裂的湿响。"), ignored_mobs = excluded)
	playsound(target, 'sound/combat/fracture/fracturewet (1).ogg', 40, TRUE, ignore_walls = FALSE)
	target.apply_status_effect(/datum/status_effect/knot_gaped)
	user.visible_message(span_userdanger("[user]将[user.p_their()]尾巴从[target]遭到摧残的后穴中猛然扯出，板片伴着湿润的碎裂声闭合，留下一片大张、脱垂的狼藉。"), ignored_mobs = excluded)
