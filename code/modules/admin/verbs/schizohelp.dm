GLOBAL_LIST_EMPTY_TYPED(schizohelps, /datum/schizohelp)

/mob
	COOLDOWN_DECLARE(schizohelp_cooldown)

/mob/proc/schizohelp(msg as text)
	if(!msg)
		return
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	to_chat(src, span_info("<i>我向导师们请教……</i>\n[msg]"))
	var/datum/schizohelp/ticket = new(src)
	var/display_name = get_schizo_name()
	var/message = span_info("<i>[display_name]正在冥想……</i>\n[msg]")
	var/message_admins = span_info("<i>[display_name]（[key || "无账号"]）[ADMIN_FLW(src)] [ADMIN_SM(src)] 正在冥想……</i>\n[msg]")
	for(var/client/voice in (GLOB.clients - client))
		if(!(voice.prefs.toggles & SCHIZO_VOICE) || check_rights_for(voice, R_ADMIN))
			continue
		var/answer_button = span_info("(<a href='?src=[voice];schizohelp=[REF(ticket)];'>回应</a>)")
		to_chat(voice, "[message] [answer_button]")

	for(var/client/admin in GLOB.admins)
		if(!(admin.prefs.chat_toggles & CHAT_PRAYER))
			continue
		var/answer_button = span_info("(<a href='?src=[admin];schizohelp=[REF(ticket)];'>回应</a>)")
		to_chat(admin, type = MESSAGE_TYPE_PRAYER, html = "[message_admins] [answer_button]")
	COOLDOWN_START(src, schizohelp_cooldown, 1 MINUTES)
	// Comes out as... GAME: MENTOR HELP: GreedyPelican42/(Lord Featherton the Great) asked : How do I fly?
	log_game("MENTOR HELP: [key_name(src)] asked : [msg]")

/mob/proc/get_schizo_name()
	var/static/list/possible_adjectives = list(
		"犹豫的",
		"怀疑的",
		"困惑的",
		"歇斯底里的",
		"不安定的",
		"迟疑的",
		"忐忑的",
	)
	var/static/list/possible_nouns = list(
		"愚人",
		"狂人",
		"糊涂虫",
		"疯子",
		"呆子",
		"傻瓜",
	)
	/// generate a consistent but anonymous name
	var/static/fumbling_seed = text2num(GLOB.rogue_round_id)
	var/md5_num = text2num(md5(real_name || src.name))
	var/adjective = possible_adjectives[(md5_num % length(possible_adjectives)) + 1]
	var/noun = possible_nouns[(round(md5_num * noise_hash(md5_num, fumbling_seed)) % length(possible_nouns)) + 1]
	return "[adjective] [noun]"

/client/proc/answer_schizohelp(datum/schizohelp/schizo)
	if(QDELETED(schizo))
		to_chat(src, span_warning("这次冥想已经无法回应了……"))
		return
	if(schizo.owner == src.mob)
		to_chat(src, span_warning("我不能回应自己的冥想！"))
		return
	var/answer = input("回应这次冥想……", "心中之声")
	if(!answer || QDELETED(schizo))
		return
	schizo.answer_schizo(answer, src.mob)

/datum/schizohelp
	/// Guy who made this schizohelp "ticket"
	var/mob/owner
	/// Answers we got so far, indexed by client key
	var/list/answers = list()
	/// How many answers we can get at maximum
	var/max_answers = 5
	/// How much time we have to be answered
	var/timeout = 5 MINUTES

/datum/schizohelp/New(mob/owner)
	. = ..()
	if(owner)
		src.owner = owner
		RegisterSignal(owner, COMSIG_QDELETING, PROC_REF(owner_qdeleted))
	GLOB.schizohelps += src
	if(timeout)
		QDEL_IN(src, timeout)
	
/datum/schizohelp/Destroy(force)
	. = ..()
	owner = null
	answers = null
	GLOB.schizohelps -= src

/datum/schizohelp/proc/answer_schizo(answer, mob/voice)
	if(QDELETED(src) || !voice.client)
		return
	answer = copytext(sanitize(answer), 1, MAX_MESSAGE_LEN)
	to_chat(owner, "<i>我的脑海中响起一个声音……\n<b>[answer]</i></b>")

	for(var/client/listener in (GLOB.clients - owner.client))
		if(listener in GLOB.admins)
			if(!(listener.prefs.chat_toggles & CHAT_PRAYER))
				continue
			to_chat(listener, span_info("<i>[voice]（[voice.key || "无账号"]）[ADMIN_FLW(owner)] [ADMIN_SM(owner)] 回应了 [owner]（[owner.key || "无账号"]）的 [ADMIN_FLW(owner)] [ADMIN_SM(owner)] 冥想：</i>\n[answer]"))
		else
			if(!(listener.prefs.toggles & SCHIZO_VOICE))
				continue
			to_chat(listener, span_info("有人回应：<i>[answer]</i>"))
	// Comes out to GAME: MENTOR HELP: GilbertRobert1337/(Generic Bandito) answered CluelessSherlock01/(Greatest Detective)'s medition : You can look for footsteps by right clicking the eyeball HUD.
	log_game("MENTOR HELP: [key_name(voice)] answered [key_name(owner)]'s meditation : [answer]")
	answers[voice.key] = answer
	if(length(answers) >= max_answers)
		qdel(src)

/datum/schizohelp/proc/owner_qdeleted(mob/source)
	if(QDELETED(src))
		return
	UnregisterSignal(owner, COMSIG_QDELETING)
	qdel(src)
