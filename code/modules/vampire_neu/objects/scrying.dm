/obj/structure/vampire/scryingorb // Method of spying on the town
	name = "夜之眼"
	icon_state = "scrying"

/obj/structure/vampire/scryingorb/attack_hand(mob/living/carbon/human/user)
	if(user?.mind.has_antag_datum(/datum/antagonist/vampire/lord))
		user.visible_message("<font color='red'>[user]的双眼变成暗红色，正向[src]注入意识。</font>", "<font color='red'>我开始将意识注入捕食者之眼。</font>")
		if(do_after(user, 6 SECONDS, src))
			user.scry(can_reenter_corpse = 1, force_respawn = FALSE)
	else
		to_chat(user, span_warning("我没有使用它的力量！"))

/mob/dead/observer/rogue/arcaneeye
	sight = 0
	see_in_dark = 2
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER

	misting = 0
	var/mob/living/carbon/human/vampirelord = null
	icon_state = "arcaneeye"
	draw_icon = FALSE
	hud_type = /datum/hud/eye

/mob/dead/observer/rogue/arcaneeye/proc/scry_tele()
	set category = "Arcane Eye"
	set name = "Teleport"
	set desc= "传送至某处"
	set hidden = 0

	if(!isobserver(usr))
		to_chat(usr, span_warning("你并非奥术之眼！"))
		return
	var/list/filtered = list()
	for(var/V in GLOB.sortedAreas)
		var/area/A = V
		if(!A.hidden)
			filtered += A
	var/area/thearea  = input("选择要传送到的区域", "传送") as null|anything in filtered

	if(!thearea)
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		to_chat(usr, span_warning("没有可用的区域。"))
		return

	usr.forceMove(pick(L))

/mob/dead/observer/rogue/arcaneeye/Initialize(mapload)
	. = ..()
	set_invisibility(GLOB.observer_default_invisibility)
	verbs += list(
		/mob/dead/observer/rogue/arcaneeye/proc/scry_tele,
		/mob/dead/observer/rogue/arcaneeye/proc/cancel_scry,
		/mob/dead/observer/rogue/arcaneeye/proc/eye_down,
		/mob/dead/observer/rogue/arcaneeye/proc/eye_up,
		/mob/dead/observer/rogue/arcaneeye/proc/vampire_telepathy)
	name = "奥术之眼"
	grant_all_languages()

/mob/dead/observer/rogue/arcaneeye/proc/cancel_scry()
	set category = "Arcane Eye"
	set name = "Cancel Eye"
	set desc= "返回躯体"

	if(vampirelord)
		vampirelord.ckey = ckey
		qdel(src)
	else
		to_chat(src, "我的躯体已被摧毁！我被困住了！")

/mob/dead/observer/rogue/arcaneeye/Crossed(mob/living/L)
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/V = L
		var/holyskill = V.get_skill_level(/datum/skill/magic/holy)
		var/magicskill = V.get_skill_level(/datum/skill/magic/arcane)
		if(magicskill >= 2)
			to_chat(V, "<font color='red'>你周围的空气中隐隐笼罩着古老而异样的魔法。</font>")
			return
		if(holyskill >= 2)
			to_chat(V, "<font color='red'>你周围的空气中隐隐笼罩着古老而邪恶的魔法。</font>")
			return
		if(prob(20))
			to_chat(V, "<font color='red'>你感觉有人，或是什么东西，正在注视你。</font>")
			return

/mob/dead/observer/rogue/arcaneeye/proc/vampire_telepathy()
	set name = "Telepathy"
	set category = "Arcane Eye"

	var/msg = sanitize(input("发送一条消息。", "传讯") as text|null)
	if(!msg)
		return
	for(var/datum/mind/V in SSmapping.retainer.vampires)
		to_chat(V, span_boldnotice("来自[src.real_name]的消息：[msg]"))
	for(var/datum/mind/D in SSmapping.retainer.death_knights)
		to_chat(D, span_boldnotice("来自[src.real_name]的消息：[msg]"))
	for(var/mob/dead/observer/rogue/arcaneeye/A in GLOB.mob_list)
		to_chat(A, span_boldnotice("来自[src.real_name]的消息：[msg]"))

/mob/dead/observer/rogue/arcaneeye/proc/eye_up()
	set category = "Arcane Eye"
	set name = "Move Up"

	if(zMove(UP, TRUE))
		to_chat(src, span_notice("我向上移动。"))

/mob/dead/observer/rogue/arcaneeye/proc/eye_down()
	set category = "Arcane Eye"
	set name = "Move Down"

	if(zMove(DOWN, TRUE))
		to_chat(src, span_notice("我向下移动。"))

/mob/dead/observer/rogue/arcaneeye/Move(NewLoc, direct)
	if(world.time < next_gmove)
		return
	next_gmove = world.time + 3

	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own
	var/oldloc = loc

	if(NewLoc)
		forceMove(NewLoc)
	else
		forceMove(get_turf(src))  //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--

	Moved(oldloc, direct)

/mob/proc/scry(can_reenter_corpse = 1, force_respawn = FALSE, drawskip)
	stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
	var/mob/dead/observer/rogue/arcaneeye/eye = new(src)	// Transfer safety to observer spawning proc.
	SStgui.on_transfer(src, eye) // Transfer NanoUIs.
	eye.can_reenter_corpse = can_reenter_corpse
	eye.vampirelord = src
	eye.ghostize_time = world.time
	eye.key = key
	return eye
