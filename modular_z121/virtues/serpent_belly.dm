// 蛇腹者：能力属于身体，腹部容器负责消化、语音隔离和释放时的清理。
/datum/virtue/utility/serpent_belly
	name = "蛇腹者（-9）"
	desc = "蛇蜕去旧皮，你却将它的饥饿留在了血肉里。你的喉腹懂得一种古老的进食方式，连尚未止息的心跳，也能藏进温热的黑暗。"
	triumph_cost = 9
	custom_text = "获得【吞入】与【吐出】。须握牢近旁的活人，耐心完成吞咽；疼痛或脱手都会令你前功尽弃。腹中仅容一人，金铁之物会伤及内里。短暂的安宁过后，灼痛便会逐渐侵蚀其中的血肉，直至只剩随身遗物被呕出。隔着腹壁，唯有你听得清那些话语。困于其中的人仍可【抵抗】，力气越大，越有望挣得一线生机。"

/datum/virtue/utility/serpent_belly/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(istype(recipient))
		recipient.AddComponent(/datum/component/z121_serpent_belly)

// 优先采用明确的熔炼材质；骨、木、陶器等非金属产物不会因修理技能而误判。
/proc/z121_serpent_metal_equipment(obj/item/item)
	// 这些非金属戒指继承了金属戒指的修理属性，须按明确材质排除。
	if(is_type_in_list(item, list(/obj/item/clothing/ring/jade, /obj/item/clothing/ring/coral, /obj/item/clothing/ring/onyxa, /obj/item/clothing/ring/shell, /obj/item/clothing/ring/amber, /obj/item/clothing/ring/turq, /obj/item/clothing/ring/rose, /obj/item/clothing/ring/chitin, /obj/item/clothing/ring/opal)))
		return FALSE
	if(item.is_silver)
		return TRUE
	if(item.smeltresult)
		return ispath(item.smeltresult, /obj/item/ingot) && !ispath(item.smeltresult, /obj/item/ingot/component)
	return !item.sewrepair && (item.anvilrepair == /datum/skill/craft/armorsmithing || item.anvilrepair == /datum/skill/craft/blacksmithing)

/datum/component/z121_serpent_belly
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/obj/effect/z121_serpent_stomach/stomach
	var/obj/effect/proc_holder/spell/self/z121_serpent_swallow/swallow_spell
	var/obj/effect/proc_holder/spell/self/z121_serpent_release/release_spell
	var/channeling = FALSE
	var/interrupted = FALSE
	var/list/damage_snapshot
	var/mob/living/carbon/human/channel_target
	var/list/channel_grabs = list()

/datum/component/z121_serpent_belly/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/host = parent
	swallow_spell = new
	release_spell = new
	host.AddSpell(swallow_spell)
	host.AddSpell(release_spell)
	ADD_TRAIT(host, "蛇腹者", REF(src))
	GLOB.roguetraits["蛇腹者"] = span_info("我的饥饿有着蛇的耐性。只要握牢眼前之人，便能慢慢将其纳入腹中；但金铁难咽，疼痛亦会打断这份耐心。腹中装不下第二个人，也未必困得住一双有力的手。若愿放还，尚可将其吐出。")
	RegisterSignal(host, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING), PROC_REF(on_host_lost))

/datum/component/z121_serpent_belly/Destroy()
	interrupted = TRUE
	clear_channel_signals()
	QDEL_NULL(stomach)
	if(parent)
		var/mob/host = parent
		UnregisterSignal(host, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_HEALTH_UPDATE))
		REMOVE_TRAIT(host, "蛇腹者", REF(src))
		host.mob_spell_list -= swallow_spell
		host.mob_spell_list -= release_spell
	QDEL_NULL(swallow_spell)
	QDEL_NULL(release_spell)
	damage_snapshot = null
	return ..()

/datum/component/z121_serpent_belly/proc/on_host_lost()
	SIGNAL_HANDLER
	interrupted = TRUE
	QDEL_NULL(stomach)

// 检查具体抓取物，而不是仅凭拖拽变量；优先吞入当前手中的目标。
/datum/component/z121_serpent_belly/proc/grabbed_target()
	var/mob/living/carbon/human/host = parent
	var/obj/item/grabbing/active_grab = host.get_active_held_item()
	if(istype(active_grab) && ishuman(active_grab.grabbed))
		return active_grab.grabbed
	for(var/obj/item/grabbing/grab in host.held_items)
		if(ishuman(grab.grabbed))
			return grab.grabbed
	return null

/datum/component/z121_serpent_belly/proc/can_swallow(mob/living/carbon/human/target)
	var/mob/living/carbon/human/host = parent
	if(QDELETED(host) || QDELETED(target) || !istype(target) || target == host || stomach)
		return FALSE
	if(host.incapacitated() || host.stat == DEAD || target.stat == DEAD)
		return FALSE
	// 双方必须在地面，防止嵌套吞入和跨容器抓取；固定在家具上时须先解除固定。
	if(!isturf(host.loc) || !isturf(target.loc) || !host.Adjacent(target) || target.buckled || length(target.buckled_mobs))
		return FALSE
	var/datum/component/z121_serpent_belly/other = target.GetComponent(/datum/component/z121_serpent_belly)
	if(other?.stomach)
		return FALSE
	for(var/obj/item/grabbing/grab in host.held_items)
		if(!QDELETED(grab) && grab.grabbee == host && grab.grabbed == target)
			return TRUE
	return FALSE

// 分别记录每个肢体和器官，避免总生命值未变或不同伤害相互抵消而漏判。
/datum/component/z121_serpent_belly/proc/read_damage()
	var/mob/living/carbon/human/host = parent
	var/list/result = list("氧气" = host.getOxyLoss(), "毒素" = host.getToxLoss(), "克隆" = host.getCloneLoss())
	for(var/obj/item/bodypart/part in host.bodyparts)
		result["[REF(part)]蛮力"] = part.brute_dam
		result["[REF(part)]灼烧"] = part.burn_dam
	for(var/obj/item/organ/organ in host.internal_organs)
		result[REF(organ)] = organ.damage
	return result

/datum/component/z121_serpent_belly/proc/on_health_update()
	SIGNAL_HANDLER
	if(!channeling || interrupted || QDELETED(parent))
		return
	var/list/current = read_damage()
	for(var/key in current)
		if(current[key] > damage_snapshot[key])
			interrupted = TRUE
			break
	damage_snapshot = current

/datum/component/z121_serpent_belly/proc/channel_valid(mob/living/carbon/human/target)
	if(QDELETED(src) || !channeling || interrupted || !can_swallow(target))
		return FALSE
	on_health_update()
	return !interrupted

// 抓取断开或离开相邻范围时立刻锁定失败，不能同一轮内重新抓住来续上读条。
/datum/component/z121_serpent_belly/proc/on_channel_move()
	SIGNAL_HANDLER
	if(channeling && !can_swallow(channel_target))
		interrupted = TRUE

/datum/component/z121_serpent_belly/proc/on_grab_deleted(datum/source)
	SIGNAL_HANDLER
	channel_grabs -= source
	if(channeling && !length(channel_grabs))
		interrupted = TRUE

/datum/component/z121_serpent_belly/proc/clear_channel_signals()
	if(parent)
		UnregisterSignal(parent, list(COMSIG_LIVING_HEALTH_UPDATE, COMSIG_MOVABLE_MOVED))
	if(channel_target)
		UnregisterSignal(channel_target, COMSIG_MOVABLE_MOVED)
	for(var/obj/item/grabbing/grab as anything in channel_grabs)
		UnregisterSignal(grab, COMSIG_QDELETING)
	channel_grabs.Cut()
	channel_target = null

/datum/component/z121_serpent_belly/proc/swallow()
	var/mob/living/carbon/human/host = parent
	if(channeling)
		to_chat(host, span_warning("喉间尚未咽尽，我分不出余力。"))
		return FALSE
	var/mob/living/carbon/human/target = grabbed_target()
	if(!can_swallow(target) || host.doing)
		to_chat(host, span_warning("眼下还不成……我须先空出腹中，将近旁之人握牢；彼此都得脱离座椅、坐骑或藏身之处。"))
		return FALSE
	channeling = TRUE
	interrupted = FALSE
	channel_target = target
	damage_snapshot = read_damage()
	RegisterSignal(host, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))
	RegisterSignal(host, COMSIG_MOVABLE_MOVED, PROC_REF(on_channel_move))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_channel_move))
	for(var/obj/item/grabbing/grab in host.held_items)
		if(grab.grabbed == target)
			channel_grabs += grab
			RegisterSignal(grab, COMSIG_QDELETING, PROC_REF(on_grab_deleted))
	host.visible_message(span_warning("[host]攥住[target]，下颌缓缓张开，显出骇人的幅度……"))
	to_chat(target, span_userdanger("[host]的唇齿正一点点迫近……趁还来得及，我得挣开这双手，或让疼痛迫使其松口！"))
	log_combat(host, target, "开始吞入")
	// do_mob 使用固定时间，不受施法速度、技能或超魔的引导倍率影响。
	var/completed = do_mob(host, target, 40 SECONDS, extra_checks = CALLBACK(src, PROC_REF(channel_valid), target))
	if(QDELETED(src))
		return FALSE
	completed = completed && channel_valid(target)
	channeling = FALSE
	damage_snapshot = null
	clear_channel_signals()
	if(!completed)
		if(!QDELETED(host))
			to_chat(host, span_warning("吞咽的节律乱了，喉间骤然一紧。这番工夫算是白费了。"))
		return FALSE
	var/metal = FALSE
	for(var/obj/item/item in target.get_equipped_items(include_pockets = FALSE, include_beltslots = FALSE))
		// 背部挂载武器、嘴里叼着的物品不算穿戴装备。
		if(item == target.backr || item == target.backl || item == target.mouth)
			continue
		if(z121_serpent_metal_equipment(item))
			metal = TRUE
			break
	stomach = new(host, src)
	// 解除双方与外界的抓取，避免腹中人把地面目标一并拖入或被旧抓取拉出。
	host.stop_pulling()
	target.stop_pulling()
	for(var/obj/item/grabbing/grab as anything in target.grabbedby?.Copy())
		qdel(grab)
	stomach.admit(target)
	host.visible_message(span_warning("[target]的身影终于消失在[host]唇齿之间，只余喉间最后一次缓慢的起伏。"))
	log_combat(host, target, "吞入")
	if(metal)
		to_chat(host, span_userdanger("坚硬的金铁刮过内里，一阵锐痛猛地绞住了我的腹部！"))
		host.adjustBruteLoss(20)
	return TRUE

/obj/effect/z121_serpent_stomach
	name = "蛇腹"
	desc = "温热的黑暗紧贴着四肢，周遭随呼吸缓缓收拢。若还有力气，便仍有抵抗的余地。"
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/datum/component/z121_serpent_belly/controller
	var/mob/living/carbon/human/host
	var/mob/living/carbon/human/captive
	var/turf/last_turf
	var/digestion_timer
	var/next_struggle = 0
	var/cleaning_up = FALSE
	var/list/death_anatomy

/obj/effect/z121_serpent_stomach/Initialize(mapload, datum/component/z121_serpent_belly/new_controller)
	. = ..()
	controller = new_controller
	host = loc
	last_turf = get_turf(host)
	RegisterSignal(host, COMSIG_MOVABLE_MOVED, PROC_REF(on_host_moved))

/obj/effect/z121_serpent_stomach/proc/on_host_moved()
	SIGNAL_HANDLER
	var/turf/current = get_turf(host)
	if(current)
		last_turf = current

/obj/effect/z121_serpent_stomach/proc/admit(mob/living/carbon/human/target)
	captive = target
	// 本项目的呼吸只对地面污染、土坑和裹尸布施加环境伤害；本容器不引入窒息。
	target.forceMove(src)
	RegisterSignal(target, COMSIG_MOB_SAY, PROC_REF(on_speech))
	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(on_captive_death))
	RegisterSignal(target, COMSIG_QDELETING, PROC_REF(on_captive_deleted))
	digestion_timer = addtimer(CALLBACK(src, PROC_REF(digest_tick)), 60 SECONDS, TIMER_STOPPABLE)
	to_chat(target, span_userdanger("光亮在身后合拢，温热而狭窄的黑暗裹住了我。此刻尚算平静，却不知能维持多久……我还能【抵抗】，试着撑开这层束缚；若要呼救，恐怕也只有吞下我的那个人听得清。"))

// 普通移动不会直接走出容器；外部 forceMove 仍可救出目标。
/obj/effect/z121_serpent_stomach/relaymove(mob/user, direction)
	return

// 脱下、丢弃的物品留在腹内，随吐出统一移到地面。
/obj/effect/z121_serpent_stomach/AllowDrop()
	return TRUE

/obj/effect/z121_serpent_stomach/container_resist(mob/living/user)
	// 抵抗入口已经设置 next_move，不能再次用 can_resist 否决这次合法操作。
	if(user != captive || cleaning_up || user.incapacitated(ignore_restraints = TRUE, ignore_stasis = TRUE))
		return
	if(world.time < next_struggle)
		to_chat(user, span_warning("方才那阵挣动还未平息，我得缓一缓，才能再使上力气。"))
		return
	next_struggle = world.time + 10 SECONDS
	var/chance = clamp(captive.STASTR * 2, 5, 60)
	to_chat(host, span_warning("腹中忽然传来一阵顶撞，有人在里面拼命撑动！"))
	if(prob(chance))
		to_chat(user, span_notice("我拼尽力气一撑，四周的挤压终于松动了！"))
		log_combat(user, host, "挣扎逃出蛇腹")
		qdel(src)
	else
		to_chat(user, span_warning("手脚徒劳地撑动了一阵，四周依旧紧紧裹着我。"))

// 提前截获，普通广播、气泡及普通无线电转发都不会接触到原文。
/obj/effect/z121_serpent_stomach/proc/on_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER
	if(speaker != captive || cleaning_up)
		return
	var/message = speech_args[SPEECH_MESSAGE]
	speech_args[SPEECH_MESSAGE] = null
	if(!length(message) || !speaker.can_speak_vocal(message))
		return
	var/datum/language/language = speech_args[SPEECH_LANGUAGE]
	if(language && (initial(language.flags) & SIGNLANG))
		to_chat(speaker, span_warning("我在黑暗中比划，却没有一双眼睛能看见。"))
		return
	to_chat(speaker, span_notice("我向外唤道：“[message]”"))
	host.show_message(span_notice("隔着自己的血肉，我听见腹中传来话语：“[message]”"), MSG_AUDIBLE)
	var/hearing_range = speech_args[SPEECH_MODE] == MODE_WHISPER || speaker.InCritical() ? 1 : 7
	for(var/mob/listener in get_hearers_in_view(hearing_range, host))
		if(listener == host || listener == speaker)
			continue
		listener.show_message(span_notice("一阵闷闷的咕哝声隐约传来，像是隔着厚布的人语，嗓音与字句都模糊难辨。"), MSG_AUDIBLE)

/obj/effect/z121_serpent_stomach/proc/digest_tick()
	digestion_timer = null
	if(cleaning_up || QDELETED(captive) || captive.loc != src)
		qdel(src)
		return
	if(captive.stat == DEAD)
		consume_body()
		return
	to_chat(captive, span_userdanger("原先的温热变作灼痛，湿黏的刺疼又一次漫过皮肤！"))
	// 直接增加身体灼烧伤害，不进行穿戴护甲检定，也不制造火焰或燃烧装备。
	captive.adjustFireLoss(10)
	if(QDELETED(src) || cleaning_up)
		return
	if(captive.stat == DEAD)
		consume_body()
	else
		digestion_timer = addtimer(CALLBACK(src, PROC_REF(digest_tick)), 10 SECONDS, TIMER_STOPPABLE)

/obj/effect/z121_serpent_stomach/proc/on_captive_death()
	SIGNAL_HANDLER
	// 记录属于此人的身体部件，兼容外部碎尸流程随后把部件移出身体的情况。
	death_anatomy = captive.bodyparts.Copy() | captive.internal_organs
	// 等死亡流程退出后再删除身体，避免在死亡信号分发中销毁角色。
	addtimer(CALLBACK(src, PROC_REF(consume_body)), 0)

/obj/effect/z121_serpent_stomach/proc/on_captive_deleted()
	SIGNAL_HANDLER
	// 外部删除角色时也先救出其物品，不接管外部的角色删除操作。
	save_items()
	unregister_captive()
	captive = null
	// 角色仍在自己的删除信号内，等其移出容器后再删除容器，避免递归删除同一角色。
	addtimer(CALLBACK(src, PROC_REF(dispose)), 0)

/obj/effect/z121_serpent_stomach/proc/dispose()
	qdel(src)

/obj/effect/z121_serpent_stomach/proc/save_items()
	if(!captive)
		return
	captive.spill_embedded_objects()
	// 装备先走正常脱卸逻辑，强制保留不可主动丢弃的装备；背包内容随包保留。
	var/list/equipment = captive.get_equipped_items(TRUE) | captive.held_items
	for(var/obj/item/item in equipment)
		if(!QDELETED(item) && !istype(item, /obj/item/grabbing))
			captive.transferItemToLoc(item, src, force = TRUE)
	for(var/obj/item/item in captive.contents.Copy())
		if(istype(item, /obj/item/bodypart) || istype(item, /obj/item/organ) || istype(item, /obj/item/grabbing))
			continue
		item.forceMove(src)

/obj/effect/z121_serpent_stomach/proc/consume_body()
	if(cleaning_up || QDELETED(captive) || captive.loc != src || captive.stat != DEAD)
		return
	cleaning_up = TRUE
	dispose_body()
	qdel(src)

/obj/effect/z121_serpent_stomach/proc/dispose_body()
	var/mob/living/carbon/human/body = captive
	save_items()
	unregister_captive()
	captive = null
	log_combat(host, body, "消化腹中死者")
	to_chat(host, span_notice("腹中最后一丝属于他人的动静也散尽了。只余咽不下的身外之物，随着一阵干呕被送回外间。"))
	// 普通删除会处理幽灵与心智，不调用会生成灰烬或残肢的 dust、gib。
	qdel(body)

/obj/effect/z121_serpent_stomach/proc/unregister_captive()
	if(captive)
		UnregisterSignal(captive, list(COMSIG_MOB_SAY, COMSIG_LIVING_DEATH, COMSIG_QDELETING))

/obj/effect/z121_serpent_stomach/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == captive && !cleaning_up)
		unregister_captive()
		captive = null
		qdel(src)

/obj/effect/z121_serpent_stomach/Destroy()
	cleaning_up = TRUE
	if(digestion_timer)
		deltimer(digestion_timer)
		digestion_timer = null
	// 死亡与吐出恰在同一帧发生时，不能抢在消化回调前把尸体吐出。
	if(!QDELETED(captive) && captive?.loc == src && captive.stat == DEAD)
		dispose_body()
	unregister_captive()
	var/turf/destination = get_turf(host)
	if(!destination)
		destination = last_turf
	if(captive && !QDELETED(captive) && captive.loc == src)
		to_chat(captive, span_notice("一阵翻涌将我推了出来，紧裹四肢的束缚终于退去。"))
		if(host && !QDELETED(host))
			host.visible_message(span_warning("[host]俯身一阵干呕，腹中的人随着翻涌重新显出身形。"))
	// 外部碎尸留下的本人生理部件也被消化；其他人的器官战利品不在此清单内。
	for(var/obj/item/remains as anything in death_anatomy)
		if(QDELETED(remains))
			continue
		if(istype(remains, /obj/item/bodypart))
			var/obj/item/bodypart/part = remains
			for(var/obj/item/embedded as anything in part.embedded_objects?.Copy())
				part.remove_embedded_object(embedded)
		qdel(remains)
	death_anatomy = null
	// 所有散落物品也必须移出，避免父类递归删除容器内容。
	for(var/atom/movable/content as anything in contents.Copy())
		content.forceMove(destination)
	if(host)
		UnregisterSignal(host, COMSIG_MOVABLE_MOVED)
	if(controller?.stomach == src)
		controller.stomach = null
	captive = null
	host = null
	controller = null
	return ..()

/obj/effect/proc_holder/spell/self/z121_serpent_swallow
	name = "吞入"
	desc = "握牢近旁之人，缓缓将其纳入腹中。此事需要耐心，疼痛与脱手都足以打断吞咽。腹中仅容一人；双手各有所握时，先顾当前手中的那一位。"
	human_req = TRUE
	antimagic_allowed = TRUE
	associated_skill = null
	recharge_time = 1 SECONDS
	overlay_state = "bloodsteal"

/obj/effect/proc_holder/spell/self/z121_serpent_swallow/cast(list/targets, mob/living/carbon/human/user = usr)
	var/datum/component/z121_serpent_belly/ability = user.GetComponent(/datum/component/z121_serpent_belly)
	if(!ability?.swallow())
		if(!QDELETED(src) && !QDELETED(user))
			revert_cast(user)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/z121_serpent_release
	name = "吐出"
	desc = "松开腹中的桎梏，将困于其中的人与随身之物一并放还。"
	human_req = TRUE
	antimagic_allowed = TRUE
	associated_skill = null
	recharge_time = 1 SECONDS
	overlay_state = "fetch"

/obj/effect/proc_holder/spell/self/z121_serpent_release/cast(list/targets, mob/living/carbon/human/user = usr)
	var/datum/component/z121_serpent_belly/ability = user.GetComponent(/datum/component/z121_serpent_belly)
	if(!ability?.stomach)
		to_chat(user, span_warning("腹中空空，只有饥饿回应着我。"))
		revert_cast(user)
		return FALSE
	qdel(ability.stomach)
	return TRUE
