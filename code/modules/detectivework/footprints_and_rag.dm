
/obj/item/clothing/gloves
	var/transfer_blood = 0


/obj/item/reagent_containers/glass/rag
	name = "湿抹布"
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	item_flags = NOBLUDGEON
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 5
	spillable = FALSE

/obj/item/reagent_containers/glass/rag/suicide_act(mob/user)
	user.visible_message(span_suicide("[user]正用[src.name]捂住自己的口鼻！看起来是想自杀！"))
	return (OXYLOSS)

/obj/item/reagent_containers/glass/rag/afterattack(atom/A as obj|turf|area, mob/user,proximity)
	. = ..()
	if(!proximity)
		return
	if(iscarbon(A) && A.reagents && reagents.total_volume)
		var/mob/living/carbon/C = A
		var/reagentlist = pretty_string_from_reagent_list(reagents)
		var/log_object = "containing [reagentlist]"
		if(user.used_intent.type == INTENT_HARM && !C.is_mouth_covered())
			reagents.trans_to(C, reagents.total_volume, transfered_by = user, method = INGEST)
			C.visible_message(span_danger("[user]用[src]捂住了[C]的口鼻！"), span_danger("[user]用[src]捂住了我的口鼻！"), span_hear("我听到一阵挣扎声和含糊的惊叫。"))
			log_combat(user, C, "smothered", src, log_object)
		else
			reagents.reaction(C, TOUCH)
			reagents.clear_reagents()
			C.visible_message(span_notice("[user]用[src]碰了碰[C]。"))
			log_combat(user, C, "touched", src, log_object)

	else if(istype(A) && (src in user))
		user.visible_message(span_notice("[user]开始用[src]擦拭[A]！"), span_notice("我开始用[src]擦拭[A]..."))
		if(do_after(user,30, target = A))
			user.visible_message(span_notice("[user]擦完了[A]！"), span_notice("我擦完了[A]。"))
			SEND_SIGNAL(A, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
