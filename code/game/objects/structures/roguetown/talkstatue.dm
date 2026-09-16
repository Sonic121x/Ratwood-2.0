/*
Talking statues. A means of giving communication to certain spheres
(Church, Mercenaries) without overloading them into the SCOM ecosystem.

Ideally, these machines will encourage gathering in a "centralized" area.
Hopefully they are more useful than just writing a letter via HERMES.

Mercenary statue: see talkstatue_mercenary.dm (legacy merc plumbing,
chat-delivered messaging, Topic handlers for register/response links) and
talkstatue_tgui.dm (the real player-facing TGUI: ui_state/ui_interact/ui_data/ui_act).
*/

/obj/structure/roguemachine/talkstatue
	name = "会说话的雕像"
	desc = "别映射这一个！去映射其它那些！"
	icon = 'icons/roguetown/misc/economy_machines.dmi' // carries the mercstatue sprite from upstream
	icon_state = "mercstatue"
	density = FALSE
	anchored = TRUE
	max_integrity = 0

/obj/structure/roguemachine/talkstatue/mercenary
	name = "佣兵雕像"
	desc = "一名吉尔青铜战士自收容他们的石钟中破壁而出；异邦的衣着，石质的犄角，致命金属铸就的利爪。对一个不属于此时此地的骄傲战士而言，这正是最完美的汇聚之处。"
	var/static/list/mercenary_status = list()
	var/static/list/pending_registrations = list()
	var/static/list/pending_message_links = list()
	var/static/list/pending_broadcast_responses = list()
	var/static/list/pending_direct_responses = list()
	var/static/list/sender_cooldowns = list()
	var/static/list/adventurer_status = list()
	var/static/list/wretch_status = list()
	var/message_char_limit = 300
	var/response_timeout = 2 MINUTES
	var/single_cooldown = 10 MINUTES
	var/broadcast_cooldown_time = 20 MINUTES
	var/static/response_id_counter = 0

/obj/structure/roguemachine/talkstatue/church
	name = "教堂雕像"
	desc = "一尊受祝福的石像，散发着神圣的气息。"
	icon_state = "goldvendor" //TODO: Get proper sprite

/obj/structure/roguemachine/talkstatue/church/Initialize(mapload)
	. = ..()
	if(SSroguemachine.church_statue == null)
		SSroguemachine.church_statue = src

/obj/structure/roguemachine/talkstatue/church/Destroy()
	if(SSroguemachine.church_statue == src)
		SSroguemachine.church_statue = null
	return ..()
