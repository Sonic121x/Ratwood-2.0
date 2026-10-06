/datum/keybinding/dsay
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("U")
	name = "DSAY"
	full_name = "亡者聊天"
	description = "幽灵使用的聊天频道。"

/datum/keybinding/dsay/down(client/user)
	user.get_dead_say()
	return TRUE


/client/proc/get_dead_say()
	if (!isobserver(mob) && !holder)
		to_chat(src, span_danger("只有幽灵才能使用亡者聊天！"))
		return

	var/msg = input(src, null, "dsay \"text\"") as text|null

	if (isnull(msg))
		return

	do_dsay(msg)


/client/verb/dsay()
	set name = "DSAY"
	set desc = "亡者聊天，仅幽灵可见的角色外聊天。"
	set category = "OOC"

	get_dead_say()


/client/proc/do_dsay(msg as text)
	if(!mob)
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>禁止宣传其他服务器。</B>")
			log_admin("[key_name(src)] has attempted to advertise in DSAY: [msg]")
			return

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(src, span_danger("管理员暂时禁用了发言。"))
		return

	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, span_danger("无法使用亡者聊天（DSAY）：你已被暂时禁言。"))
		return

	if(is_banned_from(ckey, "Deadchat"))
		to_chat(src, span_danger("无法使用亡者聊天（DSAY）：你已被永久禁言。"))
		return

	if(handle_spam_prevention(msg, MUTE_DEADCHAT))
		return

	if(!(prefs.chat_toggles & CHAT_DSAY))
		to_chat(src, span_danger("你已屏蔽亡者聊天（DSAY）。"))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	mob.log_talk(msg, LOG_DSAY)

	if(!msg)
		return

	var/rank_name
	var/player_name = mob.name
	var/deadbarks = pick("哀鸣", "呻吟", "抱怨", "呜咽")
	var/adjectives = pick("阴森的", "幽灵般的", "虚幻的", "诡异的")

	if(src in GLOB.admins)
		rank_name = holder.rank
		if(holder.fakekey)
			rank_name = pick(strings("admin_nicknames.json", "ranks", "config"))
			player_name = pick(strings("admin_nicknames.json", "names", "config"))
	if(ckey in GLOB.anonymize)
		player_name = "[adjectives]旁观者"

	for(var/mob/M in GLOB.player_list)
		if(!(M.client.prefs.chat_toggles & CHAT_DSAY))
			continue

		var/prefix = "DSAY: "
		if(M.client in GLOB.admins)
			prefix += "([mob.ckey]) <A href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(mob)]]'>\[PP\]</font></a>"

		var/rendered = span_gamedeadsay("<span class='prefix'>[prefix]</span> <span class='name'>[rank_name ? "([rank_name])" : ""][player_name]</span> [deadbarks], <span class='message'>\"[emoji_parse(msg)]\"</span>")
		if(isobserver(M) || (M.client in GLOB.admins))
			to_chat(M, rendered)
