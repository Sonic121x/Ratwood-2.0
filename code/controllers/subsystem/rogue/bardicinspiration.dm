// Bardic Inspo time - Datum/definition setup

#define BARD_T1 1
#define BARD_T2 2
#define BARD_T3 3
#define BARD_RESET_COOLDOWN 2 MINUTES

GLOBAL_LIST_INIT(learnable_songs, (list(/obj/effect/proc_holder/spell/invoked/song/dirge_fortune,
		/obj/effect/proc_holder/spell/invoked/song/discordant_dirge,
		/obj/effect/proc_holder/spell/invoked/song/furtive_fortissimo,
		/obj/effect/proc_holder/spell/invoked/song/intellectual_interval,
		/obj/effect/proc_holder/spell/invoked/song/resolute_refrain,
		/obj/effect/proc_holder/spell/invoked/song/recovery_song,
		/obj/effect/proc_holder/spell/invoked/song/fervor_song,
		/obj/effect/proc_holder/spell/invoked/song/pestilent_piedpiper,
		/obj/effect/proc_holder/spell/invoked/song/rejuvenation_song,
		/obj/effect/proc_holder/spell/invoked/song/accelakathist,
		)
))

GLOBAL_LIST_INIT(learnable_rhythms, (list(/obj/effect/proc_holder/spell/self/rhythm/resonating,
		/obj/effect/proc_holder/spell/self/rhythm/concussive,
		/obj/effect/proc_holder/spell/self/rhythm/regenerating,
		/obj/effect/proc_holder/spell/self/rhythm/malaise,
		)
))


/datum/inspiration
	var/mob/living/carbon/human/holder
	var/level = BARD_T1
	var/maxaudience = 2
	var/list/audience = list()
	var/maxsongs = BARD_T1 + 1
	var/songsbought = 0
	var/maxrhythms = 0
	var/rhythmsbought = 0
	var/datum/rhythm_tracker/rhythm_tracker
	var/is_picking = FALSE // mutex
	var/is_picking_rhythm = FALSE
	var/next_song_reset = 0
	var/next_rhythm_reset = 0

/datum/inspiration/Destroy(force)
	. = ..()
	holder?.inspiration = null
	holder = null
	QDEL_NULL(rhythm_tracker)
	STOP_PROCESSING(SSobj, src)



/mob/living/carbon/human/proc/in_audience(mob/living/carbon/human/audiencee)
	if(!src.mind)
		return FALSE
	if(!src.inspiration)
		return FALSE
		
	if(audiencee in src.inspiration.audience)
		return TRUE
	else
		return FALSE


/datum/inspiration/proc/grant_inspiration(mob/living/carbon/human/H, bard_tier)
	if(!H || !H.mind)
		return
	level = bard_tier
	maxaudience = 2*bard_tier
	maxsongs = bard_tier + 2
	if(bard_tier >= BARD_T2)
		maxrhythms = bard_tier
		if(!rhythm_tracker)
			rhythm_tracker = new
		H.verbs += list(/mob/living/carbon/human/proc/pickrhythms, /mob/living/carbon/human/proc/resetrhythms)
	if(bard_tier >= BARD_T3 && !H.mind.has_spell(/obj/effect/proc_holder/spell/self/crescendo))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/crescendo)
	H.verbs += list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs, /mob/living/carbon/human/proc/resetsongs)

/datum/inspiration/proc/toggle_audience_member(mob/living/carbon/human/target)
	if(!holder || !target)
		return FALSE
	if(target in audience)
		audience -= target
		to_chat(holder, span_notice("我停止为[target.real_name]演奏。"))
		target.balloon_alert(holder, "已移出听众名单")
		return TRUE
	if(audience.len >= maxaudience)
		to_chat(holder, span_warning("我的听众不能超过[maxaudience]人！"))
		return FALSE
	audience |= target
	to_chat(holder, span_notice("我开始为[target.real_name]演奏。"))
	target.balloon_alert(holder, "已加入听众名单")
	return TRUE

/mob/living/carbon/human/proc/setaudience()
	set name = "选择听众"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	if(inspiration.audience.len >= inspiration.maxaudience)
		to_chat(src, "我的听众不能超过[inspiration.maxaudience]人！")
		return FALSE
	var/list/folksnearby = list()
	for(var/mob/living/carbon/human/folks in view(7, loc))
		if(!src.in_audience(folks))
			folksnearby += folks

	if(!folksnearby)
		return
	var/target = tgui_input_list(src, "你要为谁演奏？", "选择听众", folksnearby)
	if(target)
		inspiration.audience |= target


	return TRUE


/mob/living/carbon/human/proc/clearaudience()
	set name = "清空听众"
	set category = "Inspiration"
	if(!inspiration)
		return FALSE
	if(src.has_status_effect(/datum/status_effect/buff/playing_music)) // cant clear while playing
		return
	inspiration.audience = list()

	return TRUE


/mob/living/carbon/human/proc/checkaudience()
	set name = "查看听众"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	var/text = ""
	for(var/mob/living/carbon/human/folks in inspiration.audience)
		text += "[folks.real_name], "
	if(!text)
		return
	to_chat(src, "我的听众有：[text]")

	return TRUE
	

/datum/inspiration/New(mob/living/carbon/human/holder)
	. = ..()
	src.holder = holder
	holder?.inspiration = src
	ADD_TRAIT(holder, INSPIRING_MUSICIAN, "inspiration")


/mob/living/carbon/human/proc/picksongs()
	set name = "填写歌本"
	set category = "Inspiration"


	if(!mind)
		return
	if(inspiration.is_picking)
		return
	inspiration.is_picking = TRUE

	var/list/songs = GLOB.learnable_songs
	var/list/choices = list()

	for(var/i = 1, i <= songs.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = songs[i]
		choices["[spell_item.name]"] = spell_item

	var/choice = input("选择一首歌曲") as anything in choices
	var/obj/effect/proc_holder/spell/invoked/song/item = choices[choice]

	if(!item)
		inspiration.is_picking = FALSE
		return     // user canceled;
	if(alert(src, "[item.desc]", "[item.name]", "学习", "取消") == "取消") //gives a preview of the spell's description to let people know what a spell does
		inspiration.is_picking = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type == item.type)
			to_chat(src, span_warning("你已经学会这首歌了！"))
			inspiration.is_picking = FALSE
			return
	var/obj/effect/proc_holder/spell/invoked/song/new_song = new item
	mind.AddSpell(new_song)
	inspiration.songsbought += 1
	if(inspiration.songsbought >= inspiration.maxsongs)
		verbs -= /mob/living/carbon/human/proc/picksongs
	inspiration.is_picking = FALSE

/mob/living/carbon/human/proc/resetsongs()
	set name = "重选歌曲"
	set category = "Inspiration"

	if(!mind || !inspiration)
		return
	if(world.time < inspiration.next_song_reset)
		to_chat(src, span_warning("我还需要等[DisplayTimeText(inspiration.next_song_reset - world.time)]才能再次改写歌本。"))
		return
	if(alert(src, "忘记所有已选歌曲并重新选择？", "重选歌曲", "重选", "取消") == "取消")
		return

	var/list/spells_to_remove = list()
	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type in GLOB.learnable_songs)
			spells_to_remove += knownsong

	if(!spells_to_remove.len)
		to_chat(src, span_warning("我没有可遗忘的已选歌曲。"))
		return

	for(var/obj/effect/proc_holder/spell/knownsong in spells_to_remove)
		mind.RemoveSpell(knownsong)

	inspiration.songsbought = 0
	inspiration.next_song_reset = world.time + BARD_RESET_COOLDOWN
	verbs |= list(/mob/living/carbon/human/proc/picksongs)
	to_chat(src, span_notice("记住的乐谱从我脑海中流逝。我可以重新选择歌曲了。"))

/mob/living/carbon/human/proc/pickrhythms()
	set name = "选择节奏"
	set category = "Inspiration"

	if(!mind)
		return
	if(!inspiration || inspiration.level < BARD_T2)
		return
	if(inspiration.is_picking_rhythm)
		return
	if(inspiration.rhythmsbought >= inspiration.maxrhythms)
		verbs -= /mob/living/carbon/human/proc/pickrhythms
		return
	inspiration.is_picking_rhythm = TRUE

	var/list/choices = list()
	for(var/i = 1, i <= GLOB.learnable_rhythms.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = GLOB.learnable_rhythms[i]
		choices["[spell_item.name]"] = spell_item

	var/choice = input("选择一种节奏") as anything in choices
	var/obj/effect/proc_holder/spell/self/rhythm/item = choices[choice]

	if(!item)
		inspiration.is_picking_rhythm = FALSE
		return
	if(alert(src, "[item.desc]", "[item.name]", "学习", "取消") == "取消")
		inspiration.is_picking_rhythm = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in mind.spell_list)
		if(knownrhythm.type == item.type)
			to_chat(src, span_warning("你已经学会这种节奏了！"))
			inspiration.is_picking_rhythm = FALSE
			return
	var/obj/effect/proc_holder/spell/self/rhythm/new_rhythm = new item
	mind.AddSpell(new_rhythm)
	inspiration.rhythmsbought += 1
	if(inspiration.rhythmsbought >= inspiration.maxrhythms)
		verbs -= /mob/living/carbon/human/proc/pickrhythms
	inspiration.is_picking_rhythm = FALSE

/mob/living/carbon/human/proc/resetrhythms()
	set name = "重选节奏"
	set category = "Inspiration"

	if(!mind || !inspiration || inspiration.level < BARD_T2)
		return
	if(world.time < inspiration.next_rhythm_reset)
		to_chat(src, span_warning("我还需要等[DisplayTimeText(inspiration.next_rhythm_reset - world.time)]才能再次改写节奏。"))
		return
	if(alert(src, "忘记所有已选节奏并重新选择？", "重选节奏", "重选", "取消") == "取消")
		return

	var/list/spells_to_remove = list()
	for(var/obj/effect/proc_holder/spell/knownrhythm in mind.spell_list)
		if(knownrhythm.type in GLOB.learnable_rhythms)
			spells_to_remove += knownrhythm

	if(!spells_to_remove.len)
		to_chat(src, span_warning("我没有可遗忘的已选节奏。"))
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in spells_to_remove)
		mind.RemoveSpell(knownrhythm)

	inspiration.rhythmsbought = 0
	if(inspiration.rhythm_tracker)
		if(inspiration.rhythm_tracker.decay_timer_id)
			deltimer(inspiration.rhythm_tracker.decay_timer_id)
			inspiration.rhythm_tracker.decay_timer_id = null
		inspiration.rhythm_tracker.greater_stacks = 0
		inspiration.rhythm_tracker.last_rhythm_type = 0
	inspiration.next_rhythm_reset = world.time + BARD_RESET_COOLDOWN
	verbs |= list(/mob/living/carbon/human/proc/pickrhythms)
	to_chat(src, span_notice("那些和声从我脑海中消散。我可以重新选择节奏了。"))

/mob/living/carbon/human/MiddleClickOn(atom/A, params)
	// if we're holding an instrument and have inspiration with no other intents active, we'll add them to our inspiration audience, if possible
	if(!mmb_intent && inspiration && A != src && isliving(A))
		if(istype(get_active_held_item(), /obj/item/rogue/instrument))
			if(get_dist(src, A) > 7 || A.loc.z != src.loc.z) // cheap quick dist test instead of calling hearers
				to_chat(src, span_warning("[A]离得太远，我无法将其加入听众名单。"))
				return
			inspiration.toggle_audience_member(A)
			return
	return ..()

#undef BARD_RESET_COOLDOWN
