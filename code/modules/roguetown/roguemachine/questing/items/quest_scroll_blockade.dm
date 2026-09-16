/proc/format_blockade_time(deciseconds)
	if(deciseconds <= 0)
		return "0:00"
	var/total_seconds = round(deciseconds / 10)
	var/minutes = round(total_seconds / 60)
	var/seconds = total_seconds % 60
	return "[minutes]:[seconds < 10 ? "0[seconds]" : "[seconds]"]"

/obj/item/quest_writ/blockade
	name = "封锁防御契约"
	desc = "一份要求解除封锁的契约文书\
	持契者须前往被封锁的地区，接连击退三波 \
	来袭者——每一波都须在十五分钟内覆灭，总管亦可在 \
	持契者耗时过久、尚未抵达封锁之前将其召回。将本文书交给某人]即可开启该契约；将其钉于大契约台账之上， \
	则须凑足三人的冒险团方可领取。封锁现场每多一人（至多六人），都会招来更多敌人与更多奖赏。 \
	若匪徒正坐拥窃来的王室钱币，破除封锁将夺取其窖藏，并由王室以「追回赃物」之名课税。"
	icon_state = "scroll_quest_info"
	base_icon_state = "scroll_quest"
	var/last_arrival_check = 0

/obj/item/quest_writ/blockade/attack_self(mob/user)
	if(!assigned_quest)
		return ..()
	var/datum/quest/kill/blockade_defense/Q = assigned_quest
	if(!Q.quest_receiver_reference)
		if(!Q.can_claim(user))
			to_chat(user, span_warning(Q.claim_failure_reason(user)))
			return
		if(!SStreasury.has_account(user))
			to_chat(user, span_warning("查无账户记录——领取契约前请先在神经锁处登记，否则将无钱袋可支付予你。"))
			return
		Q.quest_receiver_reference = WEAKREF(user)
		Q.quest_receiver_name = user.real_name
		to_chat(user, span_notice("你接下了封锁契约。前往标记区域——你抵达之时，各波攻势便会开始。"))
		var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
		if(landmark)
			Q.materialize(landmark)
			Q.materialized = TRUE
		update_quest_text()
	opened = TRUE
	update_icon_state()
	refresh_compass(user)
	ui_interact(user)

/obj/item/quest_writ/blockade/process()
	. = ..()
	var/datum/quest/kill/blockade_defense/Q = assigned_quest
	if(!Q)
		return
	if(!Q.armed)
		return
	if(world.time < last_arrival_check + (5 SECONDS))
		return
	last_arrival_check = world.time
	var/mob/bearer = Q.quest_receiver_reference?.resolve()
	if(!bearer)
		return
	var/atom/loc_chain = src.loc
	var/found_bearer = FALSE
	while(loc_chain)
		if(loc_chain == bearer)
			found_bearer = TRUE
			break
		if(isturf(loc_chain))
			break
		loc_chain = loc_chain.loc
	if(!found_bearer)
		return
	Q.check_arrival(bearer)
