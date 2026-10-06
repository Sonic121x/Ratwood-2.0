/datum/vote/map_vote
	name = "Map"
	default_message = "为下一回合的地图投票！"
	count_method = VOTE_COUNT_METHOD_SINGLE
	winner_method = VOTE_WINNER_METHOD_SIMPLE
	display_statistics = TRUE

/datum/vote/map_vote/New()
	. = ..()
	default_choices = SSmap_vote.get_valid_map_vote_choices()

/datum/vote/map_vote/create_vote(mob/vote_creator)
	default_choices = SSmap_vote.get_valid_map_vote_choices()
	. = ..()
	if(!.)
		return FALSE

	if(length(choices) == 1) // Only one choice, no need to vote. Let's just auto-rotate it to the only remaining map because it would just happen anyways.
		var/datum/map_config/change_me_out = global.config.maplist[choices[1]]
		finalize_vote(choices[1])// voted by not voting, very sad.
		to_chat(world, span_boldannounce("由于只有一张可选地图，已跳过地图投票。 \
			地图已更改为[change_me_out.map_name]。"))
		return FALSE
	if(length(choices) == 0)
		to_chat(world, span_boldannounce("已发起地图投票，但没有可选地图！ \
			请玩家联系管理员，管理员联系开发人员。"))
		return FALSE

	return TRUE

/datum/vote/map_vote/toggle_votable()
	CONFIG_SET(flag/allow_vote_map, !CONFIG_GET(flag/allow_vote_map))

/datum/vote/map_vote/is_config_enabled()
	return CONFIG_GET(flag/allow_vote_map)

/datum/vote/map_vote/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .

	if(SSmap_vote.next_map_config)
		return "下一回合的地图已经选定。"

	// The below case will be caught in create_vote() if the vote is being forced
	// This ensures proper map rotation if there aren't enough votable maps for whatever reason
	if(forced)
		return VOTE_AVAILABLE

	var/list/new_choices = SSmap_vote.get_valid_map_vote_choices()
	var/num_choices = length(new_choices)
	if(num_choices <= 1)
		return "[num_choices == 1 ? "只有一张可选地图" : "没有可选地图"]。"

	return VOTE_AVAILABLE

/datum/vote/map_vote/get_vote_result(list/non_voters)
	// Even if we have default no vote off,
	// if our default map is null for some reason, we shouldn't continue
	if(CONFIG_GET(flag/default_no_vote))
		return ..()

	for(var/non_voter_ckey in non_voters)
		var/client/non_voter_client = non_voters[non_voter_ckey]

		var/their_preferred_map = non_voter_client?.prefs?.preferred_map

		// No preferred map = abstain
		if(isnull(their_preferred_map))
			continue

		if(their_preferred_map in choices)
			choices[their_preferred_map] += 1
			choices_by_ckey[non_voter_ckey] = their_preferred_map

	return ..()

/datum/vote/map_vote/get_result_text(list/all_winners, real_winner, list/non_voters)
	var/title_text

	if(override_question)
		title_text = span_bold(override_question)
	else
		title_text = span_bold("地图投票")

	var/returned_text = "胜出方式：票数最多者胜出"

	var/total_votes = 0
	for(var/map in choices)
		total_votes += choices[map]

	if(total_votes <= 0)
		return span_bold("投票结果：无人投票，未选出获选地图！")

	returned_text += "\n"
	returned_text += "\n总票数：[total_votes]"

	if(display_statistics)
		returned_text += "\n\n结果："

		for(var/map in choices)
			var/direct_votes = choices[map]

			// How many of this map's voters are carrying a pity bonus in,
			// and how much, purely for admin/player visibility.
			var/bonus_voters = 0
			var/total_bonus_weight = 0

			for(var/ckey in choices_by_ckey)
				if(choices_by_ckey[ckey] != map)
					continue
				var/bonus = SSmap_vote.get_bonus_for(ckey, map)
				if(bonus > 0)
					bonus_voters++
					total_bonus_weight += bonus

			var/text = "[span_bold(map)]：[direct_votes]票"
			if(bonus_voters)
				text += "（[bonus_voters]位再次投票的玩家提供了[total_bonus_weight]张额外票数）"

			returned_text += "\n[text]"

	return fieldset_block(title_text, returned_text, "boxed_message purple_box")

/datum/vote/map_vote/finalize_vote(winning_option)
	SSmap_vote.finalize_map_vote(src)
