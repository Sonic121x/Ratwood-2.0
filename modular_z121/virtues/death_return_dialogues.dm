// 只接管持有本美德的人类遗言入口，其余角色继续使用原流程。
/mob/living/carbon/human/proc/z121_return_controller()
	if(!HAS_TRAIT(src, TRAIT_Z121_DEATH_RETURN))
		return null
	return mind?.GetComponent(/datum/component/z121_death_return)

/mob/living/carbon/human/proc/z121_return_dialogue_valid(datum/mind/original_mind, datum/component/z121_death_return/controller, generation)
	return !QDELETED(src) && !QDELETED(controller) && mind == original_mind && original_mind?.current == src && controller.enabled && controller.return_generation == generation && controller.state != Z121_RETURN_RUNNING

/mob/living/carbon/human/succumb(whispered as null, reaper as null)
	set hidden = TRUE
	var/datum/component/z121_death_return/controller = z121_return_controller()
	if(!controller || !controller.enabled)
		return ..()
	if(stat == DEAD || !reaper)
		return
	controller.check_condition()
	if(controller.state == Z121_RETURN_RUNNING)
		return
	if(!(InCritical() || health <= 0 || blood_volume < BLOOD_VOLUME_SURVIVE))
		return
	var/datum/mind/original_mind = mind
	var/generation = controller.return_generation
	log_message("濒死时放弃生命，当前生命值：[round(health, 0.1)]。", LOG_ATTACK)
	if(istype(loc, /turf/open/water) && !HAS_TRAIT(src, TRAIT_NOBREATH) && lying && client)
		record_round_statistic(STATS_PEOPLE_DROWNED)
	adjustOxyLoss(201)
	updatehealth()
	// 扣血已触发回归时不再打开窗口；旧窗口返回后也必须重新检查代号。
	if(!z121_return_dialogue_valid(original_mind, controller, generation))
		return
	var/word_input = stripped_input(src, "你的临终遗言是什么？若不想说可留空。", "临终遗言")
	if(!z121_return_dialogue_valid(original_mind, controller, generation))
		return
	if(word_input)
		say(word_input)
	if(z121_return_dialogue_valid(original_mind, controller, generation))
		death()

/mob/living/carbon/human/emote(act, m_type = null, message = null, intentional = FALSE, forced = FALSE, targetted = FALSE, custom_me = FALSE, animal = FALSE)
	var/datum/component/z121_death_return/controller = z121_return_controller()
	if(LOWER_TEXT(act) != "praysuicide" || !controller || !controller.enabled || custom_me)
		return ..()
	if((intentional || !forced) && world.time < next_emote)
		return
	controller.check_condition()
	if(controller.state == Z121_RETURN_RUNNING)
		return
	var/datum/mind/original_mind = mind
	var/generation = controller.return_generation
	to_chat(src, span_danger("我向主神祈求死亡……祂听到了我的祈求。"))
	var/lastmsg = message
	if(!lastmsg)
		lastmsg = stripped_input(src, "低声说出你的遗言：", "遗言")
	if(!lastmsg || !z121_return_dialogue_valid(original_mind, controller, generation))
		return FALSE
	whisper(lastmsg)
	if(!z121_return_dialogue_valid(original_mind, controller, generation))
		return FALSE
	suicide_log("求死祷告")
	sleep(5 SECONDS)
	// 不给回归后的身体补执行五秒前的求死请求。
	if(!z121_return_dialogue_valid(original_mind, controller, generation))
		return FALSE
	death()
	var/datum/emote/living/praysuicide/prayer
	next_emote = world.time + initial(prayer.mute_time)
	return TRUE
