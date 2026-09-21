// 蛇腹者：能力属于身体，腹部容器负责消化、语音隔离和释放时的清理。
/datum/virtue/utility/serpent_belly
	name = "蛇腹者（-9）"
	desc = "蛇蜕去旧皮，你却将它的饥饿留在了血肉里。你的喉腹懂得一种古老的进食方式，连尚未止息的心跳，也能藏进温热的黑暗。"
	triumph_cost = 9
	custom_text = "获得【吞入】与【吐出】。握牢近旁的血肉，耐心完成吞咽；越是庞大的猎物，越难下咽，也越令步履沉重。腹中仅容一具躯体，金铁会伤及内里，腐败与死灵亦会留下恶浊。饥饿随着血肉消融而平息，放还的躯体却未必完好。隔着腹壁，唯有你听得清其中的话语；尚有余力者仍可【抵抗】。"

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

// 采用引擎体型，不凭物种名称猜测大小；首次消化时另行保存这份系数。
/proc/z121_serpent_size(mob/living/prey)
	var/factor = 1
	switch(prey.mob_size)
		if(MOB_SIZE_TINY)
			factor = 0.25
		if(MOB_SIZE_SMALL)
			factor = 0.5
		if(MOB_SIZE_LARGE to INFINITY)
			factor = 2
	if(HAS_TRAIT(prey, TRAIT_BIGGUY))
		factor *= 1.25
	return factor

// 账本在离腹后保留，只有在外真正治愈并恢复消融部位才开始新的周期。
/datum/component/z121_serpent_digestion
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/size_factor
	var/digested_time = 0
	var/nutrition_spent = 0
	var/settled_stages = 0
	var/list/dissolved_zones = list()
	var/player_owned = FALSE
	var/inside = TRUE
	var/recovery_seen = FALSE
	var/list/recovery_snapshot
	var/recovery_timer

/datum/component/z121_serpent_digestion/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	size_factor = z121_serpent_size(parent)
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_player_login))
	RegisterSignal(parent, list(COMSIG_LIVING_HEALTH_UPDATE, COMSIG_MOVABLE_MOVED), PROC_REF(queue_recovery_check))
	has_player_owner()

/datum/component/z121_serpent_digestion/Destroy()
	if(parent)
		UnregisterSignal(parent, list(COMSIG_MOB_CLIENT_LOGIN, COMSIG_LIVING_HEALTH_UPDATE, COMSIG_MOVABLE_MOVED))
	if(recovery_timer)
		deltimer(recovery_timer)
	return ..()

/datum/component/z121_serpent_digestion/proc/on_player_login()
	SIGNAL_HANDLER
	player_owned = TRUE

/datum/component/z121_serpent_digestion/proc/has_player_owner()
	var/mob/living/prey = parent
	if(prey.client || prey.ckey || prey.mind?.key)
		player_owned = TRUE
	if(iscarbon(prey))
		var/mob/living/carbon/body = prey
		if(body.last_mind?.key)
			player_owned = TRUE
	return player_owned

/datum/component/z121_serpent_digestion/proc/progress()
	return clamp(digested_time / ((5 MINUTES) * size_factor), 0, 1)

/datum/component/z121_serpent_digestion/proc/read_recovery()
	var/mob/living/prey = parent
	var/list/state = list("蛮力" = prey.getBruteLoss(), "灼烧" = prey.getFireLoss(), "毒素" = prey.getToxLoss(), "氧气" = prey.getOxyLoss(), "克隆" = prey.getCloneLoss())
	for(var/datum/wound/wound as anything in prey.get_wounds())
		state["伤口[REF(wound)]"] = max(1, wound.whp)
	if(iscarbon(prey))
		var/mob/living/carbon/body = prey
		for(var/obj/item/organ/organ as anything in body.internal_organs)
			state["器官[organ.slot]"] = organ.damage
		for(var/zone in dissolved_zones)
			state["缺失[zone]"] = !body.get_bodypart(zone)
	return state

/datum/component/z121_serpent_digestion/proc/leave_belly()
	inside = FALSE
	recovery_seen = FALSE
	recovery_snapshot = read_recovery()

/datum/component/z121_serpent_digestion/proc/queue_recovery_check()
	SIGNAL_HANDLER
	if(inside || !digested_time)
		return
	// 每次变化都留痕，但只在本轮治疗结束后判定；同一拍先受伤再治好也不丢失依据。
	observe_recovery()
	if(recovery_timer)
		return
	// 等治疗、断肢和器官更新调用栈完成，不在半更新状态中重置。
	recovery_timer = addtimer(CALLBACK(src, PROC_REF(check_recovery)), 0, TIMER_STOPPABLE)

/datum/component/z121_serpent_digestion/proc/observe_recovery()
	var/list/current = read_recovery()
	for(var/key in recovery_snapshot)
		if(recovery_snapshot[key] > current[key])
			recovery_seen = TRUE
	recovery_snapshot = current
	return current

/datum/component/z121_serpent_digestion/proc/check_recovery(explicit_treatment = FALSE)
	if(recovery_timer)
		deltimer(recovery_timer)
		recovery_timer = null
	var/mob/living/prey = parent
	if(inside || QDELETED(prey) || istype(prey.loc, /obj/effect/z121_serpent_stomach) || !digested_time)
		return
	var/list/current = observe_recovery()
	recovery_seen ||= explicit_treatment
	if(!recovery_seen || prey.stat == DEAD)
		return
	for(var/key in current)
		if(current[key] > 0)
			return
	digested_time = 0
	nutrition_spent = 0
	settled_stages = 0
	dissolved_zones.Cut()
	size_factor = z121_serpent_size(prey)
	recovery_seen = FALSE
	to_chat(prey, span_notice("那些留在血肉深处的侵蚀终于平息了，我的躯体重新归于完整。"))

// 完整治疗可能在上层继续恢复器官或肢体，因此仍延后核实最终身体状态。
/mob/living/fully_heal(admin_revive = FALSE, break_restraints = FALSE)
	. = ..()
	var/datum/component/z121_serpent_digestion/digestion = GetComponent(/datum/component/z121_serpent_digestion)
	if(digestion && !digestion.inside)
		digestion.recovery_seen = TRUE
		digestion.queue_recovery_check()

/datum/wound/heal_wound(heal_amount)
	var/mob/living/patient = owner ? owner : bodypart_owner?.owner
	. = ..()
	if(patient && . > 0)
		var/datum/component/z121_serpent_digestion/digestion = patient.GetComponent(/datum/component/z121_serpent_digestion)
		if(digestion && !digestion.inside)
			digestion.recovery_seen = TRUE
		digestion?.queue_recovery_check()

/obj/item/bodypart/attach_limb(mob/living/carbon/patient, special)
	. = ..()
	var/datum/component/z121_serpent_digestion/digestion = patient?.GetComponent(/datum/component/z121_serpent_digestion)
	digestion?.queue_recovery_check()

// 器官自然恢复不一定触发整个人物的生命值更新，也需要在结算后核实。
/obj/item/organ/applyOrganDamage(d, maximum = maxHealth)
	. = ..()
	var/datum/component/z121_serpent_digestion/digestion = owner?.GetComponent(/datum/component/z121_serpent_digestion)
	digestion?.queue_recovery_check()

/datum/component/z121_serpent_digestion/proc/settle_limbs()
	var/mob/living/prey = parent
	var/stages = min(4, FLOOR(progress() * 5, 1))
	var/new_stages = stages - settled_stages
	// 先记账，断肢或伤害导致死亡、移动时不能重入结算。
	settled_stages = max(settled_stages, stages)
	if(new_stages <= 0 || QDELETED(prey))
		return
	if(!iscarbon(prey))
		prey.adjustFireLoss(prey.maxHealth * 0.2 * new_stages, forced = TRUE)
		return
	var/mob/living/carbon/body = prey
	for(var/zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		if(new_stages <= 0)
			break
		if(zone in dissolved_zones)
			continue
		var/obj/item/bodypart/part = body.get_bodypart(zone)
		if(!part)
			continue
		dissolved_zones += zone
		new_stages--
		// 正常断肢会释放手持物、相关衣物、绷带和嵌入物；肢体本身不留下。
		part.drop_limb()
		if(!QDELETED(part))
			qdel(part)
	to_chat(prey, span_userdanger("外间的光亮再度落下，我却再也找不回那些已被黑暗蚀去的血肉。"))

/datum/component/z121_serpent_belly
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/obj/effect/z121_serpent_stomach/stomach
	var/obj/effect/proc_holder/spell/self/z121_serpent_swallow/swallow_spell
	var/obj/effect/proc_holder/spell/self/z121_serpent_release/release_spell
	var/channeling = FALSE
	var/interrupted = FALSE
	var/list/damage_snapshot
	var/mob/living/channel_target
	var/list/channel_grabs = list()
	var/channel_size
	var/channel_big
	var/releasing = FALSE
	var/datum/z121_serpent_audio/action_audio

/datum/component/z121_serpent_belly/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/host = parent
	swallow_spell = new
	release_spell = new
	host.AddSpell(swallow_spell)
	host.AddSpell(release_spell)
	ADD_TRAIT(host, "蛇腹者", REF(src))
	GLOB.roguetraits["蛇腹者"] = span_info("我的饥饿有着蛇的耐性。握牢血肉，便能慢慢将其纳入腹中；庞然之物难咽，金铁与腐败更会留下苦楚。腹中只有一份余地，也未必困得住尚有力气的猎物。若愿放还，须稍稍停步，任喉腹翻涌。")
	RegisterSignal(host, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING), PROC_REF(on_host_lost))

/datum/component/z121_serpent_belly/Destroy()
	interrupted = TRUE
	QDEL_NULL(action_audio)
	clear_channel_signals()
	if(stomach)
		stomach.silent_release = TRUE
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
	QDEL_NULL(action_audio)
	QDEL_NULL(stomach)

// 检查具体抓取物，而不是仅凭拖拽变量；优先吞入当前手中的目标。
/datum/component/z121_serpent_belly/proc/grabbed_target()
	var/mob/living/carbon/human/host = parent
	var/obj/item/grabbing/active_grab = host.get_active_held_item()
	if(istype(active_grab) && isliving(active_grab.grabbed))
		return active_grab.grabbed
	for(var/obj/item/grabbing/grab in host.held_items)
		if(isliving(grab.grabbed))
			return grab.grabbed
	return null

/datum/component/z121_serpent_belly/proc/can_swallow(mob/living/target)
	var/mob/living/carbon/human/host = parent
	if(QDELETED(host) || QDELETED(target) || !istype(target) || target == host || stomach)
		return FALSE
	if(host.incapacitated() || host.stat == DEAD)
		return FALSE
	if(!(target.mob_biotypes & (MOB_ORGANIC | MOB_UNDEAD)) || (target.mob_biotypes & MOB_SPIRIT) || target.incorporeal_move || isconstruct(target))
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

/datum/component/z121_serpent_belly/proc/channel_valid(mob/living/target)
	if(QDELETED(src) || !channeling || interrupted || !can_swallow(target))
		return FALSE
	if(target.mob_size != channel_size || !!HAS_TRAIT(target, TRAIT_BIGGUY) != channel_big)
		interrupted = TRUE
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
	if(channeling || releasing)
		to_chat(host, span_warning("喉间尚未咽尽，我分不出余力。"))
		return FALSE
	var/mob/living/target = grabbed_target()
	if(!can_swallow(target) || host.doing)
		to_chat(host, span_warning("眼下还不成……我须先空出腹中，握牢近旁的血肉；彼此都得脱离座椅、坐骑或藏身之处。"))
		return FALSE
	channeling = TRUE
	interrupted = FALSE
	channel_target = target
	channel_size = target.mob_size
	channel_big = !!HAS_TRAIT(target, TRAIT_BIGGUY)
	var/factor = z121_serpent_size(target)
	damage_snapshot = read_damage()
	RegisterSignal(host, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))
	RegisterSignal(host, COMSIG_MOVABLE_MOVED, PROC_REF(on_channel_move))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_channel_move))
	for(var/obj/item/grabbing/grab in host.held_items)
		if(grab.grabbed == target)
			channel_grabs += grab
			RegisterSignal(grab, COMSIG_QDELETING, PROC_REF(on_grab_deleted))
	swallow_message(host, target, factor, "开始")
	action_audio = new(host, factor, TRUE)
	log_combat(host, target, "开始吞入")
	// do_mob 使用固定时间，不受施法速度、技能或超魔的引导倍率影响。
	var/completed = do_mob(host, target, (40 SECONDS) * factor, extra_checks = CALLBACK(src, PROC_REF(channel_valid), target))
	if(QDELETED(src))
		return FALSE
	completed = completed && channel_valid(target)
	channeling = FALSE
	damage_snapshot = null
	clear_channel_signals()
	QDEL_NULL(action_audio)
	if(!completed)
		if(!QDELETED(host))
			swallow_message(host, target, factor, "中断")
		return FALSE
	var/metal = FALSE
	for(var/obj/item/item in target.get_equipped_items(include_pockets = FALSE, include_beltslots = FALSE))
		// 背部挂载武器、嘴里叼着的物品不算穿戴装备。
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			if(item == human_target.backr || item == human_target.backl || item == human_target.mouth)
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
	swallow_message(host, target, factor, "完成")
	playsound(host, pick('sound/vo/gulp.ogg', 'sound/vo/gulp2.ogg'), z121_serpent_volume(factor), TRUE)
	log_combat(host, target, "吞入")
	if(metal)
		to_chat(host, span_userdanger("坚硬的金铁刮过内里，一阵锐痛猛地绞住了我的腹部！"))
		host.adjustBruteLoss(20)
	return TRUE

/datum/component/z121_serpent_belly/proc/swallow_message(mob/living/host, mob/living/target, factor, phase)
	var/size_index = factor <= 0.3125 ? 1 : factor <= 0.625 ? 2 : factor <= 1.25 ? 3 : 4
	var/list/outside
	var/list/inside
	switch(phase)
		if("开始")
			outside = list("[host]将[target]拢近唇边，喉间轻轻一动……", "[host]张开唇齿，将[target]缓缓纳入口中……", "[host]攥紧[target]，下颌缓缓张开，喉颈随吞咽起伏……", "[host]竭力张开下颌，绷紧身躯，艰难地一点点吞咽[target]……")
			inside = list("我将这小小的躯体拢近唇边，慢慢收拢喉间。", "我张开唇齿，缓缓容下眼前的躯体。", "我稳住手中的重量，任喉颈随着吞咽起伏。", "这份重量撑得下颌发紧，我绷紧身躯，艰难地一点点吞咽。")
		if("完成")
			outside = list("[host]轻轻收拢唇齿，[target]已不见踪影。", "随着[host]喉间一阵起伏，[target]终于消失在唇齿之间。", "[host]缓缓咽下最后一口，腹部随之鼓起，再看不见[target]的身影。", "[host]沉重地吐出一口气，绷紧的腹部低低坠起，[target]终于被完全容下。")
			inside = list("喉间一松，那点分量已悄然落下。", "最后一阵吞咽过去，腹中多了一份温沉的重量。", "我终于收拢唇齿，腹中的分量随着呼吸起伏。", "我艰难地咽尽，沉重的分量坠在腹中，连迈步也费力起来。")
		else
			outside = list("[host]喉间轻轻一滞，停下了吞咽。", "[host]忽然松开唇齿，吞咽的节律断了。", "[host]喉颈骤然绷紧，未竟的吞咽被迫停下。", "[host]身躯猛地一颤，再也维持不住那艰难的吞咽。")
			inside = list("喉间一滞，这一口没能咽下。", "唇齿不由得松开，我须重新稳住吞咽。", "喉间骤然绞紧，这番工夫算是白费了。", "我再也撑不住这份重量，艰难的吞咽戛然而止。")
	host.visible_message(span_warning(outside[size_index]), span_notice(inside[size_index]), ignored_mobs = target ? list(target) : null)
	if(!QDELETED(target) && target.stat != DEAD)
		if(phase == "开始")
			var/list/prey_text = list("唇齿的阴影将我笼住，我须趁隙挣脱！", "迫近的唇齿正缓缓收拢，我得赶快挣开！", "下颌在眼前骇人地张开，我得挣开抓握，或让疼痛迫使其松口！", "那艰难的吞咽正一点点将我拖近，我得趁束缚尚未合拢挣脱！")
			to_chat(target, span_userdanger(prey_text[size_index]))
		else if(phase == "中断")
			to_chat(target, span_notice("迫近的唇齿终于退开，这场吞咽停下了。"))

/datum/component/z121_serpent_belly/proc/on_release_move()
	SIGNAL_HANDLER
	interrupted = TRUE

/datum/component/z121_serpent_belly/proc/release_valid(obj/effect/z121_serpent_stomach/expected, mob/living/prey)
	var/mob/living/host = parent
	return !QDELETED(src) && !interrupted && !QDELETED(host) && !host.incapacitated() && host.stat != DEAD && stomach == expected && !QDELETED(expected) && expected.captive == prey && !QDELETED(prey) && prey.loc == expected

/datum/component/z121_serpent_belly/proc/release()
	var/mob/living/host = parent
	if(channeling || releasing || host.doing || host.incapacitated())
		return FALSE
	if(!stomach)
		to_chat(host, span_warning("腹中空空，只有饥饿回应着我。"))
		return FALSE
	if(!stomach.captive)
		QDEL_NULL(stomach)
		return TRUE
	var/obj/effect/z121_serpent_stomach/expected = stomach
	var/mob/living/prey = expected.captive
	expected.advance_progress()
	var/mass = expected.remaining_mass()
	var/delay = max(1 SECONDS, (4 SECONDS) * mass)
	releasing = TRUE
	interrupted = FALSE
	RegisterSignal(host, COMSIG_MOVABLE_MOVED, PROC_REF(on_release_move))
	expected.release_message(mass, FALSE)
	expected.release_sound_mass = mass
	action_audio = new(host, mass, FALSE)
	// 固定时长，不检查受伤或换手，也不受通用动作的速度倍率影响。
	var/end_time = world.time + delay
	var/start_time = world.time
	var/datum/progressbar/bar = new(host, delay, host)
	host.doing = TRUE
	var/completed = TRUE
	while(world.time < end_time)
		stoplag(1)
		if(QDELETED(src) || !release_valid(expected, prey) || !host.doing)
			completed = FALSE
			break
		bar.update(world.time - start_time)
	if(!QDELETED(host))
		host.doing = FALSE
	qdel(bar)
	if(QDELETED(src))
		return FALSE
	completed = completed && release_valid(expected, prey)
	UnregisterSignal(host, COMSIG_MOVABLE_MOVED)
	releasing = FALSE
	QDEL_NULL(action_audio)
	if(!completed)
		if(!QDELETED(host) && stomach == expected)
			to_chat(host, span_warning("翻涌卡在喉间，我得停稳身子，重新顺过这口气。"))
		return FALSE
	qdel(expected)
	return TRUE

/obj/effect/z121_serpent_stomach
	name = "蛇腹"
	desc = "温热的黑暗紧贴着躯体，周遭随呼吸缓缓收拢。若还有力气，便仍有抵抗的余地。"
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/datum/component/z121_serpent_belly/controller
	var/mob/living/carbon/human/host
	var/mob/living/captive
	var/datum/component/z121_serpent_digestion/digestion
	var/turf/last_turf
	var/digestion_timer
	var/last_progress_time
	var/next_burn
	var/next_effect
	var/next_struggle = 0
	var/next_auto_struggle
	var/last_stage = 0
	var/cleaning_up = FALSE
	var/releasing_captive = FALSE
	var/image/progress_image
	var/client/progress_client
	var/datum/component/rot/held_rot
	var/saved_del_on_death
	var/saved_can_have_ai
	var/saved_automated_movement
	var/saved_ai_status
	var/saved_human_mode
	var/datum/ai_controller/held_ai
	var/saved_ai_pause
	var/release_sound_mass
	var/silent_release = FALSE

/obj/effect/z121_serpent_stomach/Initialize(mapload, datum/component/z121_serpent_belly/new_controller)
	. = ..()
	controller = new_controller
	host = loc
	last_turf = get_turf(host)
	RegisterSignal(host, COMSIG_MOVABLE_MOVED, PROC_REF(on_host_moved))
	RegisterSignal(host, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(host, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	RegisterSignal(host, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))

/obj/effect/z121_serpent_stomach/proc/on_host_moved()
	SIGNAL_HANDLER
	var/turf/current = get_turf(host)
	if(current)
		last_turf = current

/obj/effect/z121_serpent_stomach/proc/admit(mob/living/target)
	captive = target
	digestion = target.GetComponent(/datum/component/z121_serpent_digestion)
	if(!digestion)
		digestion = target.AddComponent(/datum/component/z121_serpent_digestion)
	else
		digestion.check_recovery()
	if(!digestion.digested_time)
		digestion.size_factor = z121_serpent_size(target)
	digestion.inside = TRUE
	last_progress_time = world.time
	next_burn = world.time + 60 SECONDS
	next_effect = world.time + 10 SECONDS
	next_auto_struggle = world.time + 10 SECONDS
	last_stage = FLOOR(digestion.progress() * 5, 1)
	// 不施加失能或窒息；仅暂停外部寻路、战斗与会提前销毁尸体的流程。
	pause_ai()
	RegisterSignal(target, COMSIG_COMPONENT_ADDED, PROC_REF(on_component_added))
	RegisterSignal(target, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(block_move))
	RegisterSignal(target, COMSIG_MOB_SAY, PROC_REF(on_speech))
	RegisterSignal(target, COMSIG_QDELETING, PROC_REF(on_captive_deleted))
	capture_rot(target.GetComponent(/datum/component/rot))
	target.forceMove(src)
	progress_image = image('icons/effects/progessbar.dmi', host, "prog_bar_0", HUD_LAYER)
	progress_image.plane = ABOVE_HUD_PLANE
	progress_image.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	progress_image.pixel_y = 40
	update_presentation()
	schedule_tick()
	if(target.stat != DEAD)
		to_chat(target, span_userdanger("光亮在身后合拢，温热而狭窄的黑暗裹住了我……我还能【抵抗】，试着撑开束缚；若要呼救，恐怕也只有吞下我的那个人听得清。"))

/obj/effect/z121_serpent_stomach/proc/block_move()
	SIGNAL_HANDLER
	// 普通移动和自动寻路不能走出腹部；强制传送不经过此信号。
	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/obj/effect/z121_serpent_stomach/relaymove(mob/user, direction)
	return

/obj/effect/z121_serpent_stomach/AllowDrop()
	return TRUE

/obj/effect/z121_serpent_stomach/proc/remaining_mass()
	return digestion ? digestion.size_factor * (1 - digestion.progress()) : 0

/obj/effect/z121_serpent_stomach/proc/advance_progress()
	if(QDELETED(captive) || !digestion)
		return
	var/elapsed = max(0, world.time - last_progress_time)
	last_progress_time = world.time
	digestion.digested_time = min((5 MINUTES) * digestion.size_factor, digestion.digested_time + elapsed)
	var/earned = 500 * digestion.size_factor * digestion.progress()
	var/gain = max(0, earned - digestion.nutrition_spent)
	// 即使宿主已饱腹或正在死亡，猎物提供的这一份营养也已经消耗。
	digestion.nutrition_spent = earned
	if(!QDELETED(host) && host.stat != DEAD && gain > 0)
		host.adjust_nutrition(gain)

/obj/effect/z121_serpent_stomach/proc/on_login()
	SIGNAL_HANDLER
	update_presentation()

/obj/effect/z121_serpent_stomach/proc/on_logout()
	SIGNAL_HANDLER
	if(progress_client)
		progress_client.images -= progress_image
	progress_client = null

/obj/effect/z121_serpent_stomach/proc/update_presentation()
	if(QDELETED(host) || !digestion || cleaning_up)
		return
	host.add_movespeed_modifier("z121_serpent_belly", multiplicative_slowdown = remaining_mass(), override = TRUE)
	if(progress_client != host.client)
		if(progress_client)
			progress_client.images -= progress_image
		progress_client = host.client
	if(progress_image)
		progress_image.icon_state = "prog_bar_[FLOOR(digestion.progress() * 100, 5)]"
		if(progress_client)
			progress_client.images |= progress_image

/obj/effect/z121_serpent_stomach/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(cleaning_up || !captive)
		return
	var/mass = remaining_mass()
	var/description
	if(mass <= 0.25)
		description = "腹部少许隆起。"
	else if(mass <= 0.5)
		description = "腹部微微鼓起。"
	else if(mass <= 1)
		description = "腹部明显鼓胀。"
	else
		description = "腹部沉重地坠起。"
	examine_list += span_notice(description)

/obj/effect/z121_serpent_stomach/proc/release_message(mass, completed)
	if(QDELETED(host))
		return
	if(!completed)
		if(mass <= 0.25)
			host.visible_message(span_warning("[host]稍稍低头，喉间泛起一阵轻微的干呕。"), span_notice("我停住脚步，缓缓松开喉间。"))
		else if(mass <= 1)
			host.visible_message(span_warning("[host]俯下身，随着一口浊息缓缓收紧腹部……"), span_notice("我俯身顺气，任腹中的重量缓缓上涌。"))
		else
			host.visible_message(span_warning("[host]撑住身躯，鼓胀的腹部一阵阵收缩，喉间传来沉重的干呕……"), span_notice("我稳住这份沉重的分量，等待翻涌越过喉间。"))
	else
		if(mass <= 0.25)
			host.visible_message(span_warning("[host]轻轻一呕，将腹中之物送回外间。"))
		else if(mass <= 1)
			host.visible_message(span_warning("[host]俯身一阵干呕，腹中的躯体随着翻涌重新显出形状。"))
		else
			host.visible_message(span_warning("[host]的腹部剧烈收缩，终于将沉重的躯体艰难地吐了出来。"))

/obj/effect/z121_serpent_stomach/container_resist(mob/living/user)
	// 抵抗入口已经设置 next_move，不能再次用 can_resist 否决合法操作。
	if(user != captive || cleaning_up || user.stat == DEAD || user.incapacitated(ignore_restraints = TRUE, ignore_stasis = TRUE))
		return
	if(world.time < next_struggle)
		to_chat(user, span_warning("方才那阵挣动还未平息，我得缓一缓，才能再使上力气。"))
		return
	next_struggle = world.time + 10 SECONDS
	to_chat(host, span_warning("腹中忽然传来一阵顶撞，仿佛有什么正竭力撑开束缚！"))
	if(prob(clamp(captive.STASTR * 2, 5, 60)))
		to_chat(user, span_notice("我拼尽力气一撑，四周的挤压终于松动了！"))
		log_combat(user, host, "挣扎逃出蛇腹")
		qdel(src)
	else
		to_chat(user, span_warning("一阵徒劳的挣动过后，四周依旧紧紧裹着我。"))

// 在正常广播前截获，原文不进入普通广播、气泡及普通无线电转发。
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
		listener.show_message(span_notice("一阵闷闷的咕哝声隐约传来，嗓音与字句都模糊难辨。"), MSG_AUDIBLE)

/obj/effect/z121_serpent_stomach/proc/pause_ai()
	if(istype(captive, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = captive
		saved_del_on_death = animal.del_on_death
		saved_can_have_ai = animal.can_have_ai
		saved_automated_movement = animal.stop_automated_movement
		saved_ai_status = animal.AIStatus
		animal.del_on_death = FALSE
		animal.toggle_ai(AI_OFF)
		SSnpcpool.currentrun -= animal
		animal.can_have_ai = FALSE
		animal.stop_automated_movement = TRUE
	if(ishuman(captive))
		var/mob/living/carbon/human/human = captive
		saved_human_mode = human.mode
		human.mode = NPC_AI_OFF
		human.clear_path()
		STOP_PROCESSING(SShumannpc, human)
		SShumannpc.currentrun -= human
	held_ai = captive.ai_controller
	if(held_ai)
		saved_ai_pause = held_ai.paused_until
		held_ai.paused_until = INFINITY
		held_ai.CancelActions()
	walk(captive, 0)

/obj/effect/z121_serpent_stomach/proc/restore_ai()
	if(QDELETED(captive))
		return
	if(istype(captive, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = captive
		animal.del_on_death = saved_del_on_death
		animal.can_have_ai = saved_can_have_ai
		animal.stop_automated_movement = saved_automated_movement
		animal.toggle_ai(saved_ai_status)
	if(ishuman(captive))
		var/mob/living/carbon/human/human = captive
		human.mode = saved_human_mode
		if(human.mode != NPC_AI_OFF && human.stat != DEAD)
			human.handle_ai()
	if(!QDELETED(held_ai))
		if(held_ai.paused_until == INFINITY)
			held_ai.paused_until = saved_ai_pause
		held_ai.reset_ai_status()
	held_ai = null

/obj/effect/z121_serpent_stomach/proc/on_component_added(datum/source, datum/component/added)
	SIGNAL_HANDLER
	if(istype(added, /datum/component/rot))
		capture_rot(added)

/obj/effect/z121_serpent_stomach/proc/capture_rot(datum/component/rot/rot)
	if(QDELETED(rot) || held_rot == rot)
		return
	held_rot = rot
	// 保留原组件与累计时间，暂停可能化灰的处理；释放后仍由原组件接管。
	STOP_PROCESSING(SSroguerot, rot)
	SSroguerot.currentrun -= rot
	if(!rot.last_process)
		rot.last_process = world.time
	if(rot.soundloop)
		rot.soundloop.stop()

/obj/effect/z121_serpent_stomach/proc/advance_rot()
	if(QDELETED(held_rot))
		held_rot = null
		return
	var/elapsed = max(0, world.time - held_rot.last_process)
	held_rot.last_process = world.time
	if(captive.stat != DEAD)
		return
	held_rot.amount += elapsed
	if(iscarbon(captive))
		var/mob/living/carbon/body = captive
		if(has_world_trait(/datum/world_trait/pestra_mercy))
			held_rot.amount -= elapsed * 0.5
		var/area/area = get_area(body)
		if(HAS_TRAIT(body, TRAIT_DNR) || isconstruct(body) || istype(area, /area/rogue/indoors/town) || istype(area, /area/rogue/indoors/deathsedge))
			return
		if(held_rot.amount > 20 MINUTES)
			var/changed = FALSE
			for(var/obj/item/bodypart/part in body.bodyparts)
				if(part.is_organic_limb() && !part.skeletonized && !part.rotted)
					part.rotted = TRUE
					changed = TRUE
			if(changed)
				body.apply_status_effect(/datum/status_effect/debuff/rotted_zombie)
				body.update_body()

/obj/effect/z121_serpent_stomach/proc/is_tainted()
	if(captive.mob_biotypes & MOB_UNDEAD)
		return TRUE
	if(captive.stat != DEAD)
		return FALSE
	if(iscarbon(captive))
		var/mob/living/carbon/body = captive
		for(var/obj/item/bodypart/part in body.bodyparts)
			if(part.rotted)
				return TRUE
		return FALSE
	return held_rot && held_rot.amount > 15 MINUTES

/obj/effect/z121_serpent_stomach/proc/schedule_tick()
	var/remaining = (5 MINUTES) * digestion.size_factor - digestion.digested_time
	digestion_timer = addtimer(CALLBACK(src, PROC_REF(digest_tick)), max(1, min(1 SECONDS, remaining)), TIMER_STOPPABLE)

/obj/effect/z121_serpent_stomach/proc/digest_tick()
	digestion_timer = null
	if(cleaning_up || QDELETED(captive) || captive.loc != src)
		qdel(src)
		return
	advance_progress()
	advance_rot()
	// 每十秒结算腐食，与灼烧及消化完成分开；宿主可能因此死亡并销毁容器。
	if(world.time >= next_effect)
		next_effect += 10 SECONDS
		if(is_tainted() && !HAS_TRAIT(host, TRAIT_ROT_EATER) && !HAS_TRAIT(host, TRAIT_NASTY_EATER))
			host.adjustToxLoss(2)
			if(QDELETED(src) || cleaning_up)
				return
	if(digestion.progress() >= 1)
		consume_body()
		return
	if(world.time >= next_burn)
		next_burn += 10 SECONDS
		if(captive.stat != DEAD)
			to_chat(captive, span_userdanger("原先的温热变作灼痛，湿黏的刺疼又一次漫过皮肤！"))
			captive.adjustFireLoss(10)
			if(QDELETED(src) || cleaning_up || QDELETED(captive))
				return
	var/stage = FLOOR(digestion.progress() * 5, 1)
	if(stage > last_stage)
		last_stage = stage
		if(captive.stat != DEAD)
			to_chat(captive, span_userdanger("黑暗更深地侵入血肉，躯体边缘传来的感觉正一点点变得陌生。"))
	update_presentation()
	if(world.time >= next_auto_struggle)
		next_auto_struggle += 10 SECONDS
		// 无账号的非玩家心智仍可自动挣扎；玩家掉线或离魂后不自动接管。
		if(!digestion.has_player_owner() && captive.stat != DEAD)
			container_resist(captive)
			if(QDELETED(src) || cleaning_up)
				return
	schedule_tick()

/obj/effect/z121_serpent_stomach/proc/save_items()
	if(!captive)
		return
	captive.spill_embedded_objects()
	var/list/equipment = list()
	equipment |= captive.get_equipped_items(TRUE)
	equipment |= captive.held_items
	for(var/obj/item/item in equipment)
		if(!QDELETED(item) && !istype(item, /obj/item/grabbing))
			captive.transferItemToLoc(item, src, force = TRUE)
	var/list/anatomy = list()
	if(iscarbon(captive))
		var/mob/living/carbon/body = captive
		anatomy |= body.bodyparts
		anatomy |= body.internal_organs
	for(var/obj/item/item in captive.contents.Copy())
		if(item in anatomy || istype(item, /obj/item/grabbing))
			continue
		item.forceMove(src)

/obj/effect/z121_serpent_stomach/proc/consume_body()
	if(cleaning_up || QDELETED(captive) || captive.loc != src)
		return
	cleaning_up = TRUE
	dispose_body()
	qdel(src)

/obj/effect/z121_serpent_stomach/proc/dispose_body()
	var/mob/living/body = captive
	var/list/anatomy = list()
	if(iscarbon(body))
		var/mob/living/carbon/carbon_body = body
		anatomy |= carbon_body.bodyparts
		anatomy |= carbon_body.internal_organs
	// 先取下装备再结束生命，保留物品并让角色正常进入死亡、幽灵流程。
	save_items()
	if(body.stat != DEAD)
		body.death()
	if(QDELETED(body))
		return
	save_items()
	unregister_captive()
	captive = null
	digestion = null
	log_combat(host, body, "完全消化腹中生物")
	to_chat(host, span_notice("腹中的分量终于散尽，饥饿暂且沉寂。只余咽不下的身外之物，随着一阵干呕被送回外间。"))
	if(controller)
		QDEL_NULL(controller.action_audio)
	if(!silent_release && !QDELETED(host) && host.stat != DEAD)
		playsound(host, 'sound/vo/vomit_2.ogg', 25, TRUE)
	// 不调用产生灰烬或残肢的碎尸接口；正常删除负责处理心智与幽灵。
	qdel(body)
	for(var/obj/item/remains as anything in anatomy)
		if(!QDELETED(remains))
			qdel(remains)

/obj/effect/z121_serpent_stomach/proc/on_captive_deleted()
	SIGNAL_HANDLER
	// 外部删除只保全物品，不补发尚未消化的营养，也不递归删除正在销毁的角色。
	save_items()
	unregister_captive()
	captive = null
	digestion = null
	addtimer(CALLBACK(src, PROC_REF(dispose)), 0)

/obj/effect/z121_serpent_stomach/proc/dispose()
	qdel(src)

/obj/effect/z121_serpent_stomach/proc/unregister_captive()
	if(captive)
		UnregisterSignal(captive, list(COMSIG_MOB_SAY, COMSIG_QDELETING, COMSIG_COMPONENT_ADDED, COMSIG_MOVABLE_PRE_MOVE))

/obj/effect/z121_serpent_stomach/proc/finish_release()
	if(QDELETED(captive) || releasing_captive)
		return
	releasing_captive = TRUE
	advance_rot()
	// 保持死亡自动删除关闭，直到本次肢体或比例伤害结算结束。
	digestion?.settle_limbs()
	digestion?.leave_belly()
	if(!QDELETED(captive))
		restore_ai()
		if(!QDELETED(held_rot))
			held_rot.last_process = world.time
			START_PROCESSING(SSroguerot, held_rot)
	held_rot = null
	unregister_captive()

/obj/effect/z121_serpent_stomach/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == captive && !cleaning_up && !releasing_captive)
		advance_progress()
		finish_release()
		captive = null
		digestion = null
		qdel(src)

/obj/effect/z121_serpent_stomach/Destroy()
	cleaning_up = TRUE
	if(controller)
		QDEL_NULL(controller.action_audio)
	if(digestion_timer)
		deltimer(digestion_timer)
		digestion_timer = null
	on_logout()
	QDEL_NULL(progress_image)
	if(host)
		host.remove_movespeed_modifier("z121_serpent_belly")
		UnregisterSignal(host, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_EXAMINE, COMSIG_MOB_CLIENT_LOGIN, COMSIG_MOB_LOGOUT))
	var/turf/destination = get_turf(host)
	if(!destination)
		destination = last_turf
	if(!QDELETED(captive))
		advance_progress()
		if(digestion && digestion.progress() >= 1 && captive.loc == src)
			dispose_body()
		else
			var/mass = remaining_mass()
			finish_release()
			if(!QDELETED(captive) && captive.loc == src)
				release_message(mass, TRUE)
				if(!silent_release && !QDELETED(host) && host.stat != DEAD)
					playsound(host, 'sound/vo/vomit_2.ogg', z121_serpent_volume(isnull(release_sound_mass) ? mass : release_sound_mass), TRUE)
				to_chat(captive, span_notice("一阵翻涌将我推向外间，紧裹躯体的束缚终于退去。"))
	// 包括尸体和散落物品，全部移出后才允许父类清理容器。
	for(var/atom/movable/content as anything in contents.Copy())
		content.forceMove(destination)
	if(controller?.stomach == src)
		controller.stomach = null
	captive = null
	digestion = null
	held_rot = null
	held_ai = null
	host = null
	controller = null
	return ..()

/obj/effect/proc_holder/spell/self/z121_serpent_swallow
	name = "吞入"
	desc = "握牢近旁的血肉，缓缓将其纳入腹中。庞大的猎物更难下咽，疼痛与脱手足以打断吞咽。腹中仅有一份余地；双手各有所握时，先顾当前手中的猎物。"
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
	desc = "稍稍停步，松开腹中的桎梏，任翻涌将其中的躯体与身外之物送回外间。余下的分量越沉，越难顺过这口气。"
	human_req = TRUE
	antimagic_allowed = TRUE
	associated_skill = null
	recharge_time = 1 SECONDS
	overlay_state = "fetch"

/obj/effect/proc_holder/spell/self/z121_serpent_release/cast(list/targets, mob/living/carbon/human/user = usr)
	var/datum/component/z121_serpent_belly/ability = user.GetComponent(/datum/component/z121_serpent_belly)
	if(!ability?.release())
		if(!QDELETED(src) && !QDELETED(user))
			revert_cast(user)
		return FALSE
	return TRUE

// 动作音独占声道，中断时只停止本次动作，不影响环境或其他角色的声音。
/proc/z121_serpent_volume(mass)
	return mass <= 0.3125 ? 25 : mass <= 0.625 ? 35 : mass <= 1.25 ? 45 : 55

/datum/z121_serpent_audio
	var/datum/weakref/source_ref
	var/channel
	var/timer
	var/volume
	var/swallowing
	var/first_play = TRUE

/datum/z121_serpent_audio/New(mob/living/source, mass, is_swallowing)
	. = ..()
	source_ref = WEAKREF(source)
	channel = SSsounds.reserve_sound_channel(src)
	volume = z121_serpent_volume(mass)
	swallowing = is_swallowing
	play()

/datum/z121_serpent_audio/proc/play()
	timer = null
	var/mob/living/source = source_ref.resolve()
	if(QDELETED(source) || source.stat == DEAD)
		qdel(src)
		return
	playsound(source, swallowing ? pick('sound/vo/gulp.ogg', 'sound/vo/gulp2.ogg') : 'sound/vo/vomit.ogg', first_play ? volume : max(15, volume - 10), TRUE, channel = channel)
	first_play = FALSE
	if(swallowing)
		timer = addtimer(CALLBACK(src, PROC_REF(play)), 5 SECONDS, TIMER_STOPPABLE)

/datum/z121_serpent_audio/Destroy()
	if(timer)
		deltimer(timer)
	if(channel)
		for(var/client/listener in GLOB.clients)
			listener.mob?.stop_sound_channel(channel)
		SSsounds.free_datum_channels(src)
	source_ref = null
	return ..()

#include "serpent_belly_magic.dm"
