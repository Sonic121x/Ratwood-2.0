/datum/card_table_session/proc/set_game(new_game, mob/user)
	if(stage != CARD_TABLE_STAGE_LOBBY)
		return FALSE
	var/datum/card_table_player/requester = player_for_user(user)
	if(!requester || player_index(requester) != 1)
		return FALSE
	if(new_game != CARD_TABLE_GAME_BLACKJACK && new_game != CARD_TABLE_GAME_POKER)
		return FALSE
	if(players.len > max_players_for_game(new_game))
		to_chat(user, span_warning("牌桌上的玩家人数超过了这个游戏的上限。"))
		return FALSE
	game_type = new_game
	if(!dealer_index && players.len)
		dealer_index = 1
	dealer_rounds = 0
	message = "[card_table_display_name(user)]选择游戏：[game_label()]。"
	return TRUE

/datum/card_table_session/proc/set_poker_variant(new_variant, mob/user)
	if(stage != CARD_TABLE_STAGE_LOBBY || game_type != CARD_TABLE_GAME_POKER)
		return FALSE
	var/datum/card_table_player/requester = player_for_user(user)
	if(!requester || player_index(requester) != 1)
		return FALSE
	if(new_variant != CARD_TABLE_POKER_DRAW && new_variant != CARD_TABLE_POKER_TEXAS && new_variant != CARD_TABLE_POKER_OMAHA && new_variant != CARD_TABLE_POKER_STUD)
		return FALSE
	poker_variant = new_variant
	message = "[card_table_display_name(user)]选择规则：[poker_variant_label()]。"
	return TRUE

/datum/card_table_session/proc/set_blackjack_variant(new_variant, mob/user)
	if(stage != CARD_TABLE_STAGE_LOBBY || game_type != CARD_TABLE_GAME_BLACKJACK)
		return FALSE
	var/datum/card_table_player/requester = player_for_user(user)
	if(!requester || player_index(requester) != 1)
		return FALSE
	if(new_variant != CARD_TABLE_BLACKJACK_GRON && new_variant != CARD_TABLE_BLACKJACK_VALORIA && new_variant != CARD_TABLE_BLACKJACK_AZURE && new_variant != CARD_TABLE_BLACKJACK_GRENZELHOFT && new_variant != CARD_TABLE_BLACKJACK_KAZENGUN)
		return FALSE
	blackjack_variant = new_variant
	message = "[card_table_display_name(user)]选择规则：[blackjack_variant_label()]。"
	return TRUE

/datum/card_table_session/proc/set_dealer_rotation(rotates, mob/user)
	if(stage != CARD_TABLE_STAGE_LOBBY || (game_type != CARD_TABLE_GAME_BLACKJACK && game_type != CARD_TABLE_GAME_POKER))
		return FALSE
	var/datum/card_table_player/requester = player_for_user(user)
	if(!requester || player_index(requester) != 1)
		return FALSE
	dealer_rotates = text2num("[rotates]") ? TRUE : FALSE
	if(!dealer_rotates && players.len)
		dealer_index = 1
	else if(!dealer_index && players.len)
		dealer_index = 1
	message = "[card_table_display_name(user)]选择模式：[dealer_rotation_label()]。"
	return TRUE

/datum/card_table_session/proc/dealer_player() as /datum/card_table_player
	if(dealer_index < 1 || dealer_index > players.len)
		return null
	var/datum/card_table_player/player = players[dealer_index]
	return player_is_active(player) ? player : null

/datum/card_table_session/proc/join_player(mob/user)
	if(!user || !user.ckey || stage != CARD_TABLE_STAGE_LOBBY)
		return FALSE
	if(player_for_user(user))
		return FALSE
	if(players.len >= max_players())
		to_chat(user, span_warning("没有空余玩家座位。"))
		return FALSE
	observers -= user.ckey
	var/datum/card_table_player/player = new()
	player.ckey = user.ckey
	player.name = card_table_display_name(user)
	players += player
	if(!dealer_index && (game_type == CARD_TABLE_GAME_BLACKJACK || game_type == CARD_TABLE_GAME_POKER))
		dealer_index = players.len
	message = "[player.name]入座参赛。"
	return TRUE

/datum/card_table_session/proc/join_observer(mob/user)
	if(!user || !user.ckey)
		return FALSE
	release_user(user, TRUE)
	if(!(user.ckey in observers))
		observers += user.ckey
	message = "[card_table_display_name(user)]开始观战。"
	return TRUE

/// Removes a ckey from the table. Returns TRUE if anything changed.
/datum/card_table_session/proc/remove_ckey(ckey)
	var/changed = FALSE
	for(var/i = players.len, i >= 1, i--)
		var/datum/card_table_player/player = players[i]
		if(player.ckey == ckey)
			if(stage == CARD_TABLE_STAGE_LOBBY)
				if(i == dealer_index)
					dealer_index = 0
				else if(i < dealer_index)
					dealer_index--
				players.Cut(i, i + 1)
			else
				player.left = TRUE
				player.result = "Left"
			changed = TRUE
	if(ckey in observers)
		observers -= ckey
		changed = TRUE
	return changed

/datum/card_table_session/proc/after_player_left()
	if(stage != CARD_TABLE_STAGE_LOBBY && has_spirit_opponent() && active_real_players_count() < 1)
		stage = CARD_TABLE_STAGE_FINISHED
		message = "游戏结束：牌桌上已无活着的玩家。"
	if(stage != CARD_TABLE_STAGE_LOBBY && active_players_count() < min_players())
		stage = CARD_TABLE_STAGE_FINISHED
		message = "游戏结束：有效玩家人数不足。"
	clamp_turns()

/datum/card_table_session/proc/release_user(mob/user, silent = FALSE)
	if(!user || !user.ckey)
		return FALSE
	var/changed = remove_ckey(user.ckey)
	if(changed)
		if(!silent)
			message = "[card_table_display_name(user)]离开牌桌。"
		after_player_left()
	return changed

/datum/card_table_session/proc/release_ckey(ckey, reason)
	if(!ckey)
		return FALSE
	var/name = ckey
	for(var/datum/card_table_player/player in players)
		if(player.ckey == ckey)
			name = player.name
	var/changed = remove_ckey(ckey)
	if(changed)
		var/reason_text = reason ? " ([reason])" : ""
		message = "[name]离开牌桌[reason_text]。"
		after_player_left()
	return changed

/datum/card_table_session/proc/check_player_ranges()
	if(!owner)
		return
	for(var/datum/card_table_player/player in players.Copy())
		if(player.left || player.is_spirit)
			continue
		var/mob/M = card_table_find_mob_by_ckey(player.ckey)
		var/dist = M ? get_dist(M, owner) : null
		if(!M || isnull(dist) || dist > CARD_TABLE_LEAVE_RANGE)
			release_ckey(player.ckey, "距离过远")

/datum/card_table_session/proc/clamp_turns()
	if(!players.len || dealer_index > players.len)
		dealer_index = 0

/datum/card_table_session/proc/advance_dealer()
	if(!players.len)
		dealer_index = 0
		return
	var/start_index = dealer_index + 1
	if(start_index < 1 || start_index > players.len)
		start_index = 1
	for(var/offset = 0, offset < players.len, offset++)
		var/check_index = start_index + offset
		while(check_index > players.len)
			check_index -= players.len
		var/datum/card_table_player/player = players[check_index]
		if(player_is_active(player))
			dealer_index = check_index
			return
	dealer_index = 0

/datum/card_table_session/proc/draw_one()
	if(!deck.len)
		return null
	var/list/card = deck[1]
	deck.Cut(1, 2)
	return card

/datum/card_table_session/proc/deal_to(datum/card_table_player/player, amount)
	if(!player)
		return
	for(var/i = 1, i <= amount, i++)
		var/list/card = draw_one()
		if(!card)
			return
		player.hand += list(card)
