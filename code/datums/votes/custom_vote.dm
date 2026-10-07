/// The max amount of options someone can have in a custom vote.
#define MAX_CUSTOM_VOTE_OPTIONS 10

/datum/vote/custom_vote
	name = "Custom"
	default_message = "点击这里发起自定义投票。"

// Custom votes ares always accessible.
/datum/vote/custom_vote/is_accessible_vote()
	return TRUE

/datum/vote/custom_vote/reset()
	default_choices = null
	override_question = null
	count_method = VOTE_COUNT_METHOD_SINGLE
	return ..()

/datum/vote/custom_vote/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// Custom votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "只有管理员可以发起自定义投票。"

/datum/vote/custom_vote/create_vote(mob/vote_creator)
	var/custom_count_method = tgui_input_list(
		user = vote_creator,
		message = "使用单选还是多选？",
		title = "Choice Method",
		items = list("单选", "多选"),
		default = "单选",
	)
	switch(custom_count_method)
		if("单选")
			count_method = VOTE_COUNT_METHOD_SINGLE
		if("多选")
			count_method = VOTE_COUNT_METHOD_MULTI
		if(null)
			return FALSE
		else
			stack_trace("Got '[custom_count_method]' in create_vote() for custom voting.")
			to_chat(vote_creator, span_boldwarning("未知的选项选择方式，请联系开发者。"))
			return FALSE

	var/custom_win_method = tgui_input_list(
		user = vote_creator,
		message = "如何确定投票胜出选项？",
		title = "Winner Method",
		items = list("最高票数", "按票数加权随机", "不选出胜出项"),
		default = "最高票数",
	)
	switch(custom_win_method)
		if("最高票数")
			winner_method = VOTE_WINNER_METHOD_SIMPLE
		if("按票数加权随机")
			winner_method = VOTE_WINNER_METHOD_WEIGHTED_RANDOM
		if("不选出胜出项")
			winner_method = VOTE_WINNER_METHOD_NONE
		if(null)
			return FALSE
		else
			stack_trace("Got '[custom_win_method]' in create_vote() for custom voting.")
			to_chat(vote_creator, span_boldwarning("未知的胜出判定方式，请联系开发者。"))
			return FALSE

	var/display_stats = tgui_alert(
		vote_creator,
		"是否公开投票统计？",
		"显示投票统计？",
		list("是", "否"),
	)

	if(isnull(display_stats))
		return FALSE
	display_statistics = display_stats == "是"

	override_question = tgui_input_text(vote_creator, "此次投票的主题是什么？", "自定义投票")
	if(!override_question)
		return FALSE

	default_choices = list()
	for(var/i in 1 to MAX_CUSTOM_VOTE_OPTIONS)
		var/option = tgui_input_text(vote_creator, "输入一个选项，或点击取消以结束。最多 [MAX_CUSTOM_VOTE_OPTIONS] 项。", "选项", max_length = MAX_NAME_LEN)
		if(!vote_creator?.client)
			return FALSE
		if(!option)
			break

		default_choices += capitalize(option)

	if(!length(default_choices))
		return FALSE
	// Sanity for all the tgui input stalling we are doing
	if(isnull(vote_creator.client?.holder))
		return FALSE

	return ..()

/datum/vote/custom_vote/initiate_vote(initiator, duration)
	. = ..()
	. += "\n[override_question]"

#undef MAX_CUSTOM_VOTE_OPTIONS
