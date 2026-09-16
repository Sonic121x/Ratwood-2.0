/datum/sex_action/force_suck_nipples
	name = "强迫对方吮吸乳头"
	require_grab = TRUE
	stamina_cost = 1.0
	user_sex_part = SEX_PART_BREASTS
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/force_suck_nipples/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]强按着[target]的脑袋，让其吞含并吮吸[user.p_their()]乳头！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/force_suck_nipples/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]强迫[target]吮吸[user.p_their()]乳头。"))
	user.sexcon.oralcourse_noise(target)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)

	user.sexcon.perform_sex_action(target, 0, 7, FALSE)
	if(!user.sexcon.considered_limp())
		user.sexcon.perform_deepthroat_oxyloss(target, 0.6)
	target.sexcon.handle_passive_ejaculation()

	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	var/milk_to_add = min(max(breasts.breast_size, 1), breasts.milk_stored)
	if(breasts.lactating && milk_to_add > 0 && prob(25))
		target.reagents.add_reagent(/datum/reagent/consumable/milk, milk_to_add)
		breasts.milk_stored -= milk_to_add
		to_chat(target, span_notice("我尝到了奶味。"))
		to_chat(user, span_notice("我能感觉到乳头渗出了乳汁。"))

/datum/sex_action/force_suck_nipples/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]乳头从[target]嘴里抽了出来。"))

/datum/sex_action/force_suck_nipples/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
