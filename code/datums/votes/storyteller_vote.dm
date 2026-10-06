/datum/vote/chaos
	name = "chaos"
	default_message = "为回合类型投票。冒险模式会禁用反派，并将冒险者人数加倍。"
	default_choices = list("冒险", "混乱")
	count_method = VOTE_COUNT_METHOD_SINGLE
	winner_method = VOTE_WINNER_METHOD_SIMPLE

/datum/vote/chaos/finalize_vote(winning_option)
	SSgamemode.chaos_vote_result(winning_option == "冒险" ? "Adventure" : "Chaos")

/datum/vote/chaos/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// Storyteller votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "只有管理员可以发起自定义投票。"
