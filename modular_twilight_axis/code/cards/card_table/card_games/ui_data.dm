/datum/card_table_session/proc/build_card_data(list/cards, hidden = FALSE)
	var/list/out = list()
	for(var/i = 1, i <= cards.len, i++)
		var/list/card = cards[i]
		out += list(list(
			"index" = i,
			"label" = hidden ? "??" : card_table_card_label(card),
			"rank" = hidden ? "?" : card["rank"],
			"suit" = hidden ? "?" : card["suit"],
			"hidden" = hidden,
			"value" = hidden ? null : blackjack_card_nominal(card),
		))
	return out

/datum/card_table_session/proc/build_xylix_peek_cards(mob/user) as /list
	var/count = min(xylix_peek_count(user), deck.len)
	if(count <= 0)
		return list()
	var/list/cards = list()
	for(var/i = 1, i <= count, i++)
		cards += list(deck[i])
	return build_card_data(cards, FALSE)

/datum/card_table_session/proc/current_rules() as /list
	var/list/rules = list()
	switch(game_type)
		if(CARD_TABLE_GAME_BLACKJACK)
			rules += "目标：在不超过21点的前提下，尽可能接近21点。"
			rules += "要牌会抽取一张牌，停牌则锁定当前手牌。"
			rules += "庄家始终由一名玩家担任。[dealer_rotation_label()]。"
			switch(blackjack_variant)
				if(CARD_TABLE_BLACKJACK_GRON)
					rules += "格隆恩式：A计1点，J、Q、K计11点。"
				if(CARD_TABLE_BLACKJACK_VALORIA)
					rules += "瓦洛里亚式：A、J、Q、K均计10点。"
				if(CARD_TABLE_BLACKJACK_GRENZELHOFT)
					rules += "格伦泽尔霍夫特式：A计10点，但两张A合计21点；J、Q、K计10点。"
				if(CARD_TABLE_BLACKJACK_KAZENGUN)
					rules += "风郡式：A、J、Q、K均计1点。"
				else
					rules += "岩丘式：A计11点，但两张A合计21点；J、Q、K计10点。"
		if(CARD_TABLE_GAME_POKER)
			rules += "目标：组成最强的牌型。"
			rules += "下注：输入金额。若不高于当前注额，点击下注会过牌或跟注；若高于当前注额，则会加注。全押会押上所有筹码，弃牌则放弃手牌。"
			switch(poker_variant)
				if(CARD_TABLE_POKER_TEXAS)
					rules += "拉涅申式：每位玩家持2张牌，桌上有5张公共牌。"
				if(CARD_TABLE_POKER_OMAHA)
					rules += "瓦洛里亚式：每位玩家持4张牌，桌上有5张公共牌。"
				if(CARD_TABLE_POKER_STUD)
					rules += "吉萨式：每位玩家获得5张个人手牌，不可换牌。"
				else
					rules += "岩丘式：每位玩家获得5张牌，可换牌一次，每次一张。"
			rules += "庄家始终由一名玩家担任。[dealer_rotation_label()]。"
			if(poker_uses_community_cards())
				rules += "拉涅申式、瓦洛里亚式与吉萨式：每轮翻开一张公共牌，每次翻牌后开始新一轮下注。"
			else
				rules += "岩丘式：没有公共牌，只比较玩家手牌。"
	return rules

/datum/card_table_session/proc/build_ui_data(mob/user) as /list
	var/datum/card_table_player/me = player_for_user(user)
	var/list/player_rows = list()
	for(var/datum/card_table_player/player in players)
		var/list/player_row = player_public_data_for(player, me, user)
		var/show_hand = (stage == CARD_TABLE_STAGE_FINISHED || player == me)
		player_row["hand_value"] = (show_hand && game_type == CARD_TABLE_GAME_BLACKJACK) ? hand_value(player.hand) : null
		player_row["is_dealer"] = (player == dealer_player())
		player_rows += list(player_row)
	var/list/observer_rows = list()
	for(var/ckey in observers)
		var/mob/M = card_table_find_mob_by_ckey(ckey)
		observer_rows += M ? card_table_display_name(M) : ckey
	var/list/my_hand = me ? build_card_data(me.hand, FALSE) : list()
	var/datum/card_table_player/table_dealer = dealer_player()
	var/my_ckey = user ? user.ckey : null
	var/is_host = (me && player_index(me) == 1)
	var/xylix_level = xylix_tier(user)
	return list(
		"game_type" = game_type,
		"game_label" = game_label(),
		"poker_variant" = poker_variant,
		"poker_variant_label" = poker_variant_label(),
		"blackjack_variant" = blackjack_variant,
		"blackjack_variant_label" = blackjack_variant_label(),
		"dealer_rotates" = dealer_rotates,
		"dealer_rotation_label" = dealer_rotation_label(),
		"dealer_name" = table_dealer ? table_dealer.name : null,
		"rules" = current_rules(),
		"stage" = stage,
		"message" = message,
		"players" = player_rows,
		"observers" = observer_rows,
		"my_ckey" = my_ckey,
		"is_player" = !!me,
		"is_host" = is_host,
		"is_observer" = is_observer(user),
		"my_hand" = my_hand,
		"deck_count" = deck.len,
		"discard_count" = discard.len,
		"min_players" = min_players(),
		"max_players" = max_players(),
		"can_start" = (stage == CARD_TABLE_STAGE_LOBBY && is_host && game_type != CARD_TABLE_GAME_NONE && players.len >= min_players()),
		"can_pack" = can_pack(),
		"dealer_value" = (table_dealer && stage == CARD_TABLE_STAGE_FINISHED) ? hand_value(table_dealer.hand) : null,
		"community_cards" = (game_type == CARD_TABLE_GAME_POKER && poker_uses_community_cards()) ? build_card_data(community_cards, FALSE) : list(),
		"poker_turn" = (game_type == CARD_TABLE_GAME_POKER && stage == CARD_TABLE_STAGE_PLAYING && poker_current_player()) ? poker_current_player().name : null,
		"poker_current_bet" = (game_type == CARD_TABLE_GAME_POKER) ? poker_current_bet : 0,
		"poker_pot" = (game_type == CARD_TABLE_GAME_POKER) ? poker_pot : 0,
		"poker_betting_round" = (game_type == CARD_TABLE_GAME_POKER) ? poker_betting_round : 0,
		"blackjack_action_seq" = blackjack_action_seq,
		"blackjack_action_player_index" = blackjack_action_player_index,
		"blackjack_action_bust" = blackjack_action_bust,
		"my_value" = me ? hand_value(me.hand) : null,
		"xylix" = list(
			"enabled" = (stage == CARD_TABLE_STAGE_PLAYING && xylix_level >= CLERIC_T0),
			"tier" = xylix_level,
			"skill" = xylix_holy_skill(user),
			"caught_chance" = xylix_caught_chance(user),
			"can_choose" = xylix_can_choose_card(user),
			"cards" = build_xylix_peek_cards(user),
		),
	)
