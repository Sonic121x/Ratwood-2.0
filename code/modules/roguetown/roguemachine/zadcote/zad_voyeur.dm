// Zadcote scrying ("voyeur") - ported from Azure-Peak PR #7000
// (code/modules/roguetown/roguemachine/zadcote/zad_voyeur.dm).
// Ratwood deviations:
//  - /atom/movable/screen/alert/scryingeye does not exist in ES (AP defines it in
//    inquisitionrelics.dm alongside the blackmirror alert, which ES *does* have) - it is
//    defined at the bottom of this file instead. Its icon_state "scryingeye" may need to be
//    added to ES's screen-alert DMI; verify in Dream Maker.
//  - 'sound/magic/scryed_on.ogg' does not exist in ES's sound tree - substituted with
//    'sound/magic/marked.ogg' (closest existing "arcane eyes on you" cue).
//  - add_verb() helper does not exist in ES - plain `verbs +=` is used instead.
// Everything else (scry_ghost-style screye spawning, SSdroning kills, ManualFollow,
// reenter_corpse, ghostize_time, SStgui.on_transfer) exists 1:1 in ES - see
// /mob/proc/scry_ghost() in code/modules/mob/dead/observer/observer.dm.
/obj/item/roguemachine/zadcote/proc/begin_voyeur(datum/zadlink/link, mob/living/carbon/human/operator)
	if(!allows_voyeur)
		to_chat(operator, span_warning("这座扎德鸟舍不支持窥视联结。"))
		return FALSE
	if(!link || link.severed)
		to_chat(operator, span_warning("这条扎德鸟联结已被切断。"))
		return FALSE
	var/obj/item/zadcage/cage = link.resolve_cage()
	if(!cage)
		to_chat(operator, span_warning("这条扎德鸟联结没有绑定鸟笼。"))
		return FALSE
	if(voyeur_fund < ZAD_VOYEUR_COST_MAMMON)
		to_chat(operator, span_warning("扎德鸟舍的窥视资金已耗尽。投入玛门币后才能窥视。"))
		return FALSE
	voyeur_fund -= ZAD_VOYEUR_COST_MAMMON
	to_chat(operator, span_notice("你向扎德鸟舍低语。远方与之联结的扎德鸟躁动起来……（窥视资金剩余[voyeur_fund]m。）"))
	if(!do_after(operator, ZAD_VOYEUR_DOAFTER, target = src))
		voyeur_fund += ZAD_VOYEUR_COST_MAMMON
		return FALSE
	cage.start_voyeur(operator)
	return TRUE

/obj/item/zadcage/proc/start_voyeur(mob/living/carbon/human/operator)
	var/obj/item/roguemachine/zadcote/cote = resolve_cote()
	if(active_voyeur_screye)
		to_chat(operator, span_warning("已有他人正透过这只扎德鸟窥视，请等当前窥视结束。"))
		if(cote)
			cote.voyeur_fund += ZAD_VOYEUR_COST_MAMMON
		return
	if(!operator || !operator.key)
		if(cote)
			cote.voyeur_fund += ZAD_VOYEUR_COST_MAMMON
		return
	var/mob/holder = holder_mob()
	var/atom/movable/target = holder || src
	var/turf/cage_turf = get_turf(src)
	message_admins("ZAD VOYEUR: [operator.real_name] ([operator.ckey]) scryed via zadcage on [holder ? "[holder.real_name] ([holder.ckey])" : "the empty cage at [AREACOORD(cage_turf)]"]")
	log_game("ZAD VOYEUR: [operator.real_name] ([operator.ckey]) scryed via zadcage on [holder ? "[holder.real_name] ([holder.ckey])" : "the empty cage"]")
	var/atom/movable/broadcaster = visible_holder()
	var/source_desc
	if(broadcaster == src)
		source_desc = "[src]中的扎德鸟"
	else if(ismob(broadcaster))
		source_desc = "[broadcaster]身上的扎德鸟笼"
	else
		source_desc = "[broadcaster]"
	broadcaster.visible_message(span_notice("[source_desc]散发出诡异的蓝光。"))
	add_filter("zad_voyeur_glow", 2, list("type" = "outline", "size" = 1, "color" = "#4488ff"))
	set_light(2, 2, 2, l_color = "#1b7bf1")
	var/mob/dead/observer/screye/zadcote_voyeur/S = spawn_zad_screye(operator)
	if(!S)
		end_voyeur_visuals()
		if(cote)
			cote.voyeur_fund += ZAD_VOYEUR_COST_MAMMON
		return
	S.bonded_cage = WEAKREF(src)
	active_voyeur_screye = WEAKREF(S)
	if(holder)
		active_voyeur_holder = WEAKREF(holder)
	S.ManualFollow(target)
	operator.visible_message(span_danger("[operator]凝视着扎德鸟舍，双眼向上翻去。"))
	to_chat(S, span_notice("你正透过扎德鸟的双眼观察。点击IC选项卡中的<b>停止窥视</b>可提前返回；否则，联结将在[ZAD_VOYEUR_DURATION / (1 MINUTES)]分钟后自行断开。"))
	if(holder && holder.stat != DEAD && holder.stat != UNCONSCIOUS)
		holder.throw_alert("scryingeye", /atom/movable/screen/alert/scryingeye, override = TRUE)
		to_chat(holder, span_warning("你鸟笼中的扎德鸟躁动起来，你感到有一双眼睛正透过它窥视。"))
		holder.balloon_alert_to_viewers("<font color='#b388ff'>被窥视了！</font>")
		holder.playsound_local(holder, 'sound/magic/marked.ogg', 75, TRUE) // Ratwood deviation: AP plays 'sound/magic/scryed_on.ogg', which ES lacks
	voyeur_timer_id = addtimer(CALLBACK(src, PROC_REF(finish_voyeur)), ZAD_VOYEUR_DURATION, TIMER_STOPPABLE)

/obj/item/zadcage/proc/finish_voyeur()
	if(voyeur_timer_id)
		deltimer(voyeur_timer_id)
		voyeur_timer_id = null
	var/mob/dead/observer/screye/zadcote_voyeur/S = active_voyeur_screye?.resolve()
	var/mob/holder = active_voyeur_holder?.resolve()
	active_voyeur_screye = null
	active_voyeur_holder = null
	end_voyeur_visuals()
	if(holder)
		holder.clear_alert("scryingeye", TRUE)
	if(S && !QDELETED(S))
		S.bonded_cage = null
		S.reenter_corpse()

/obj/item/zadcage/proc/end_voyeur_visuals()
	remove_filter("zad_voyeur_glow")
	set_light(0)

/proc/spawn_zad_screye(mob/operator)
	if(!operator || !operator.key)
		return null
	if(operator.client)
		SSdroning.kill_rain(operator.client)
		SSdroning.kill_loop(operator.client)
		SSdroning.kill_droning(operator.client)
	operator.stop_sound_channel(CHANNEL_HEARTBEAT)
	var/mob/dead/observer/screye/zadcote_voyeur/ghost = new(operator)
	ghost.ghostize_time = world.time
	SStgui.on_transfer(operator, ghost)
	ghost.can_reenter_corpse = TRUE
	ghost.key = operator.key
	return ghost

/mob/dead/observer/screye/zadcote_voyeur
	name = "透过扎德鸟窥视"
	var/datum/weakref/bonded_cage

/mob/dead/observer/screye/zadcote_voyeur/Initialize(mapload)
	. = ..()
	verbs += /mob/dead/observer/screye/zadcote_voyeur/proc/end_zad_voyeur // Ratwood deviation: AP uses add_verb(), which ES lacks

/mob/dead/observer/screye/zadcote_voyeur/proc/end_zad_voyeur()
	set category = "IC"
	set name = "停止窥视"
	set desc = "结束扎德鸟窥视，返回你的身体。"
	var/obj/item/zadcage/cage = bonded_cage?.resolve()
	if(cage)
		cage.finish_voyeur()
	else
		reenter_corpse()

// Ratwood deviation: ported here from AP's inquisitionrelics.dm (ES's copy of that file only has
// the blackmirror alert). Icon state "scryingeye" must exist in the screen-alert DMI - flag
// for the user to confirm/add in Dream Maker.
/atom/movable/screen/alert/scryingeye
	name = "窥视之眼"
	desc = "我看见你了。"
	icon_state = "blackeye" // Ratwood lacks a dedicated scryingeye state; blackeye is the closest arcane-watcher icon
	timeout = 8 SECONDS
