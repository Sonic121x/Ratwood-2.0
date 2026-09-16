/obj/item/quest_writ/towner
	name = "镇民契约卷轴"
	desc = "由镇中居民签发的契约。\
	交予冒险者后，他们可无视冒险团人数要求接取此契约。将其钉于大契约台账之上， \
	它便会静候任何愿意签名之人"
	base_icon_state = "scroll_quest"

/obj/item/quest_writ/towner/attack_self(mob/user)
	if(!assigned_quest)
		return ..()
	var/datum/quest/Q = assigned_quest
	if(!Q.quest_receiver_reference)
		if(Q.quest_giver_name && Q.quest_giver_name == user.real_name)
			to_chat(user, span_warning("你不能领取由你自己签发的契约。请将其交付他人之手。"))
			return
		if(!SStreasury.has_account(user))
			to_chat(user, span_warning("查无账户记录——领取契约前请先在神经锁处登记。"))
			return
		if(!Q.can_claim(user))
			to_chat(user, span_warning(Q.claim_failure_reason(user)))
			return
		var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
		if(!landmark || !Q.materialize(landmark))
			to_chat(user, span_warning("奇怪。此契约似乎没有可用的地标！"))
			return
		Q.materialized = TRUE
		Q.on_claim(user)
		log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type] (hand-delivered)")
		update_quest_text()
	opened = TRUE
	update_icon_state()
	refresh_compass(user)
	ui_interact(user)
