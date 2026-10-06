/datum/vote/endround
	name = "endround"
	default_message = "投票决定是否结束本轮。"
	winner_method = VOTE_WINNER_METHOD_SIMPLE

/datum/vote/endround/New()
	. = ..()
	default_choices = list(
		"继续游戏",
		"结束本轮"
	)

/datum/vote/endround/finalize_vote(winning_option)
	if(winning_option == "继续游戏")
		log_game("LOG VOTE: CONTINUE PLAYING AT [REALTIMEOFDAY]")
		GLOB.round_timer = world.time + ROUND_EXTENSION_TIME
		return

	log_game("LOG VOTE: ROUNDVOTEEND [REALTIMEOFDAY]")

	to_chat(world, "<font color='purple'>[ROUND_END_TIME_VERBAL]</font>")

	SSgamemode.roundvoteend = TRUE
	SSgamemode.round_ends_at = world.time + ROUND_END_TIME

	world.TgsAnnounceVoteEndRound()

/datum/vote/endround/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// endround votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "只有管理员可以发起结束本轮的投票。"
