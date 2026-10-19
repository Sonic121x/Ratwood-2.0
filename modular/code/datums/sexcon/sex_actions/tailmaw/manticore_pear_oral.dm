/datum/sex_action/manticore_pear_oral
	parent_type = /datum/sex_action/tailmaw/pear
	name = "痛苦之梨（口腔）"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_JAWS
	user_sex_part = SEX_PART_TAIL_MAW
	wound_type = /datum/wound/fracture/mouth
	wound_zone = BODY_ZONE_HEAD

/datum/sex_action/manticore_pear_oral/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.visible_message(span_userdanger("[user]将闭合的尾苞强行挤过[target]的嘴唇，带棱的板片刮过牙齿与牙龈，深入[target]的口腔。"), ignored_mobs = excluded)
	playsound(target, 'sound/misc/mat/insert (1).ogg', 35, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_pear_oral/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return
	var/list/excluded = get_extreme_content_excluded_mobs(target)
	user.sexcon_action_message(span_userdanger("[target]口中的尾苞开始绽开，骨质板片以令人煎熬的缓慢速度撬开，将[target]的下颌越撑越大，直到关节咔哒作响，牙齿撞在坚硬的甲壳上碎裂。"), ignored_mobs = excluded)
	playsound(target, 'sound/combat/fracture/fracturewet (1).ogg', 40, TRUE, ignore_walls = FALSE)
	target.apply_status_effect(/datum/status_effect/jaw_gaped)
	user.visible_message(span_userdanger("[user]将[user.p_their()]尾巴从[target]被毁坏的口腔中猛然扯出，板片折拢，带出松脱的牙齿和鲜血，让[target]的下颌以令人作呕的角度垂挂着。"), ignored_mobs = excluded)
