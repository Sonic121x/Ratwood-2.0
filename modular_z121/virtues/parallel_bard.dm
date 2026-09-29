// 在实际歌曲授予入口登记实例，并让旧职业的未完成窗口失效。
// 同类型覆盖沿用核心过程的中文动作名称与分类，避免重复设置元数据。

/mob/living/carbon/human/picksongs()


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

	var/choice = input(src, "选择一首歌曲") as anything in choices

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking = FALSE
		return
	var/obj/effect/proc_holder/spell/invoked/song/item = choices[choice]

	if(!item)
		inspiration.is_picking = FALSE
		return
	var/confirmation = alert(src, "[item.desc]", "[item.name]", "学习", "取消")

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking = FALSE
		return
	if(confirmation == "取消")
		inspiration.is_picking = FALSE
		return

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type == item.type)
			to_chat(src, span_warning("你已经学会这首歌了！"))
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

	var/choice = input(src, "选择一种节奏") as anything in choices

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking_rhythm = FALSE
		return
	var/obj/effect/proc_holder/spell/self/rhythm/item = choices[choice]

	if(!item)
		inspiration.is_picking_rhythm = FALSE
		return
	var/confirmation = alert(src, "[item.desc]", "[item.name]", "学习", "取消")

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking_rhythm = FALSE
		return
	if(confirmation == "取消")
		inspiration.is_picking_rhythm = FALSE
		return

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		if(!QDELETED(original_inspiration))
			original_inspiration.is_picking_rhythm = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in mind.spell_list)
		if(knownrhythm.type == item.type)
			to_chat(src, span_warning("你已经学会这种节奏了！"))
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

	var/datum/inspiration/original_inspiration = inspiration
	var/datum/mind/original_mind = mind
	var/datum/z121_profession_record/R = z121_profession
	if(!original_inspiration)
		return

	if(!mind || !inspiration)
		return
	if(world.time < inspiration.next_song_reset)
		to_chat(src, span_warning("我还需要等[DisplayTimeText(inspiration.next_song_reset - world.time)]才能再次改写歌本。"))
		return
	var/confirmation = alert(src, "忘记所有已选歌曲并重新选择？", "重选歌曲", "重选", "取消")

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		return
	if(confirmation == "取消")
		return

	var/list/spells_to_remove = list()
	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		return

	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type in GLOB.learnable_songs)
			if(!R || (WEAKREF(knownsong) in R.bard_spells))
				spells_to_remove += knownsong

	if(!spells_to_remove.len)
		to_chat(src, span_warning("我没有可遗忘的已选歌曲。"))
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
	to_chat(src, span_notice("记住的乐谱从我脑海中流逝。我可以重新选择歌曲了。"))

/mob/living/carbon/human/resetrhythms()

	var/datum/inspiration/original_inspiration = inspiration
	var/datum/mind/original_mind = mind
	var/datum/z121_profession_record/R = z121_profession
	if(!original_inspiration)
		return

	if(!mind || !inspiration || inspiration.level < BARD_T2)
		return
	if(world.time < inspiration.next_rhythm_reset)
		to_chat(src, span_warning("我还需要等[DisplayTimeText(inspiration.next_rhythm_reset - world.time)]才能再次改写节奏。"))
		return
	var/confirmation = alert(src, "忘记所有已选节奏并重新选择？", "重选节奏", "重选", "取消")

	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		return
	if(confirmation == "取消")
		return

	var/list/spells_to_remove = list()
	if(QDELETED(original_inspiration) || inspiration != original_inspiration || mind != original_mind || !client || (R && (QDELETED(R) || R != z121_profession)))
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in mind.spell_list)
		if(knownrhythm.type in GLOB.learnable_rhythms)
			if(!R || (WEAKREF(knownrhythm) in R.bard_spells))
				spells_to_remove += knownrhythm

	if(!spells_to_remove.len)
		to_chat(src, span_warning("我没有可遗忘的已选节奏。"))
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
	to_chat(src, span_notice("那些和声从我脑海中消散。我可以重新选择节奏了。"))
