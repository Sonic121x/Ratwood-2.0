/datum/sex_action/manticore_pear_vaginal
	parent_type = /datum/sex_action/tailmaw/pear
	name = "痛苦之梨（阴道）"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT
	user_sex_part = SEX_PART_TAIL_MAW
	wound_type = /datum/wound/cbt

/datum/sex_action/manticore_pear_vaginal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.visible_message(span_userdanger("[user]将闭合的尾苞探入[target]双腿之间，相互咬合的板片抵住[target]的穴口，随后伴着令人作呕的摩擦强行挤入。"), ignored_mobs = excluded)
	playsound(target, 'sound/misc/mat/insert (1).ogg', 35, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_pear_vaginal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.sexcon_action_message(span_userdanger("尾苞在[target]体内绽开，板片无情地张开，将内壁撑到了远超承受能力的程度。体内深处有什么撕裂了，血肉撕扯的湿响被[target]痛苦的尖叫淹没。"), ignored_mobs = excluded)
	playsound(target, 'sound/combat/fracture/fracturewet (1).ogg', 40, TRUE, ignore_walls = FALSE)
	user.visible_message(span_userdanger("[user]将[user.p_their()]尾巴从[target]遭到蹂躏的阴穴中扯出，板片伴着碎裂声折拢，拖带出鲜血与组织。"), ignored_mobs = excluded)
