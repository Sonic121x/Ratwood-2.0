#define CHOICE_RESTART "重启回合"
#define CHOICE_CONTINUE "继续游戏"

/datum/vote/restart_vote
	name = "Restart"
	default_choices = list(
		CHOICE_RESTART,
		CHOICE_CONTINUE,
	)
	default_message = "投票决定是否重启当前回合。 \
		仅在没有处于活动状态的管理员在线时生效。"

/// This proc checks to see if any admins are online for the purposes of this vote to see if it can pass. Returns TRUE if there are valid admins online (Has +SERVER and is not AFK), FALSE otherwise.
/datum/vote/restart_vote/proc/admins_present()
	for(var/client/online_admin as anything in GLOB.admins)
		if(online_admin.is_afk() || !check_rights_for(online_admin, R_SERVER))
			continue

		return TRUE

	return FALSE

/datum/vote/restart_vote/toggle_votable()
	CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))

/datum/vote/restart_vote/is_config_enabled()
	return CONFIG_GET(flag/allow_vote_restart)

/datum/vote/restart_vote/create_vote(mob/vote_creator)
	. = ..()
	if(!.)
		return
	if(!admins_present())
		return
	async_alert_about_admins(vote_creator)

/datum/vote/restart_vote/proc/async_alert_about_admins(mob/vote_creator)
	set waitfor = FALSE
	tgui_alert(vote_creator, "提醒：由于有处于活动状态的管理员在线， \
		无论本次投票结果如何，回合都不会自动重启。")

/datum/vote/restart_vote/get_vote_result(list/non_voters)
	if(!CONFIG_GET(flag/default_no_vote))
		// Default no votes will add non-voters to "Continue Playing"
		choices[CHOICE_CONTINUE] += length(non_voters)

	return ..()

/datum/vote/restart_vote/finalize_vote(winning_option)
	if(winning_option == CHOICE_CONTINUE)
		return

	if(winning_option == CHOICE_RESTART)
		if(admins_present())
			to_chat(world, span_boldannounce("提醒：有处于活动状态的管理员在线，重启投票不会自动重启服务器。"))
			message_admins("A restart vote has passed, but there are active admins on with +SERVER, so it has been canceled. If you wish, you may restart the server.")
			return

		// If there was a previous map vote, we revert the change.
		if(!isnull(SSmap_vote.next_map_config))
			log_game("The next map has been reset due to successful restart vote.")
			send_to_playing_players(span_boldannounce("由于重启投票通过，下一回合的地图已重置。"))
			SSmap_vote.revert_next_map()

		SSticker.force_ending = 1
		log_game("End round forced by successful restart vote.")
		return

	CRASH("[type] wasn't passed a valid winning choice. (Got: [winning_option || "null"])")

#undef CHOICE_RESTART
#undef CHOICE_CONTINUE
