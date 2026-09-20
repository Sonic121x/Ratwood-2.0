// 在实际歌曲授予入口登记实例，并让旧职业的未完成窗口失效。

/mob/living/carbon/human/picksongs()
	set name = "Fill Songbook"
	set category = "Inspiration"


	var/datum/inspiration/original_inspiration = inspiration
	var/datum/mind/original_mind = mind
	var/datum/z121_profession_record/R = z121_profession
	if(!original_inspiration)
		return

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

	var/choice = input(src, "Choose a song") as anything in choices

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking = FALSE
		return
	var/obj/effect/proc_holder/spell/invoked/song/item = choices[choice]

	if(!item)
		inspiration.is_picking = FALSE
		return
	var/confirmation = alert(src, "[item.desc]", "[item.name]", "Learn", "Cancel")

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking = FALSE
		return
	if(confirmation == "Cancel")
		inspiration.is_picking = FALSE
		return

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type == item.type)
			to_chat(src, span_warning("You already know this one!"))
			inspiration.is_picking = FALSE
			return
	var/obj/effect/proc_holder/spell/invoked/song/new_song = new item
	mind.AddSpell(new_song)
	R?.remember_bard_spell(src, new_song, FALSE)
	inspiration.songsbought += 1
	if(inspiration.songsbought >= inspiration.maxsongs)
		verbs -= /mob/living/carbon/human/proc/picksongs
	inspiration.is_picking = FALSE

/mob/living/carbon/human/pickrhythms()
	set name = "Choose Rhythms"
	set category = "Inspiration"

	var/datum/inspiration/original_inspiration = inspiration
	var/datum/mind/original_mind = mind
	var/datum/z121_profession_record/R = z121_profession
	if(!original_inspiration)
		return

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

	var/choice = input(src, "Choose a rhythm") as anything in choices

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking_rhythm = FALSE
		return
	var/obj/effect/proc_holder/spell/self/rhythm/item = choices[choice]

	if(!item)
		inspiration.is_picking_rhythm = FALSE
		return
	var/confirmation = alert(src, "[item.desc]", "[item.name]", "Learn", "Cancel")

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking_rhythm = FALSE
		return
	if(confirmation == "Cancel")
		inspiration.is_picking_rhythm = FALSE
		return

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking_rhythm = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in mind.spell_list)
		if(knownrhythm.type == item.type)
			to_chat(src, span_warning("You already know this rhythm!"))
			inspiration.is_picking_rhythm = FALSE
			return
	var/obj/effect/proc_holder/spell/self/rhythm/new_rhythm = new item
	mind.AddSpell(new_rhythm)
	R?.remember_bard_spell(src, new_rhythm, TRUE)
	inspiration.rhythmsbought += 1
	if(inspiration.rhythmsbought >= inspiration.maxrhythms)
		verbs -= /mob/living/carbon/human/proc/pickrhythms
	inspiration.is_picking_rhythm = FALSE

/mob/living/carbon/human/resetsongs()
	set name = "Reset Songbook"
	set category = "Inspiration"

	var/datum/inspiration/original_inspiration = inspiration
	var/datum/mind/original_mind = mind
	var/datum/z121_profession_record/R = z121_profession
	if(!original_inspiration)
		return

	if(!mind || !inspiration)
		return
	if(world.time < inspiration.next_song_reset)
		to_chat(src, span_warning("I need [DisplayTimeText(inspiration.next_song_reset - world.time)] before I can rewrite my songbook again."))
		return
	var/confirmation = alert(src, "Forget all chosen songs and choose them again?", "Reset Songbook", "Reset", "Cancel")

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		return
	if(confirmation == "Cancel")
		return

	var/list/spells_to_remove = list()
	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		return

	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type in GLOB.learnable_songs)
			if(!R || (WEAKREF(knownsong) in R.bard_spells))
				spells_to_remove += knownsong

	if(!spells_to_remove.len)
		to_chat(src, span_warning("I have no chosen songs to forget."))
		return

	for(var/obj/effect/proc_holder/spell/knownsong in spells_to_remove)
		if(R)
			mind.spell_list -= knownsong
			knownsong.action?.Remove(src)
			R.bard_spells -= WEAKREF(knownsong)
			qdel(knownsong)
		else
			mind.RemoveSpell(knownsong)

	inspiration.songsbought = R ? max(0, inspiration.songsbought - length(spells_to_remove)) : 0
	inspiration.next_song_reset = world.time + (2 MINUTES)
	verbs |= list(/mob/living/carbon/human/proc/picksongs)
	to_chat(src, span_notice("Memorized sheet music spils from my mind. I can choose my songs again."))

/mob/living/carbon/human/resetrhythms()
	set name = "Reset Rhythms"
	set category = "Inspiration"

	var/datum/inspiration/original_inspiration = inspiration
	var/datum/mind/original_mind = mind
	var/datum/z121_profession_record/R = z121_profession
	if(!original_inspiration)
		return

	if(!mind || !inspiration || inspiration.level < BARD_T2)
		return
	if(world.time < inspiration.next_rhythm_reset)
		to_chat(src, span_warning("I need [DisplayTimeText(inspiration.next_rhythm_reset - world.time)] before I can rewrite my rhythms again."))
		return
	var/confirmation = alert(src, "Forget all chosen rhythms and choose them again?", "Reset Rhythms", "Reset", "Cancel")

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		return
	if(confirmation == "Cancel")
		return

	var/list/spells_to_remove = list()
	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in mind.spell_list)
		if(knownrhythm.type in GLOB.learnable_rhythms)
			if(!R || (WEAKREF(knownrhythm) in R.bard_spells))
				spells_to_remove += knownrhythm

	if(!spells_to_remove.len)
		to_chat(src, span_warning("I have no chosen rhythms to forget."))
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in spells_to_remove)
		if(R)
			mind.spell_list -= knownrhythm
			knownrhythm.action?.Remove(src)
			R.bard_spells -= WEAKREF(knownrhythm)
			qdel(knownrhythm)
		else
			mind.RemoveSpell(knownrhythm)

	inspiration.rhythmsbought = R ? max(0, inspiration.rhythmsbought - length(spells_to_remove)) : 0
	if(inspiration.rhythm_tracker)
		if(inspiration.rhythm_tracker.decay_timer_id)
			deltimer(inspiration.rhythm_tracker.decay_timer_id)
			inspiration.rhythm_tracker.decay_timer_id = null
		inspiration.rhythm_tracker.greater_stacks = 0
		inspiration.rhythm_tracker.last_rhythm_type = 0
	inspiration.next_rhythm_reset = world.time + (2 MINUTES)
	verbs |= list(/mob/living/carbon/human/proc/pickrhythms)
	to_chat(src, span_notice("The harmonies escape me. I can choose my rhythms again."))
