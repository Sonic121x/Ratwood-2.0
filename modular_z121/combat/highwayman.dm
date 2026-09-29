// 武技只附着持有者自己的武器；激活、命中和冷却分别结算。
#define Z121_HW_CUT "cut"
#define Z121_HW_VEIN "vein"
#define Z121_HW_DUEL "duel"
#define Z121_HW_FLAWS "flaws"
#define Z121_HW_CLOSE "close"
#define Z121_HW_SWEEP "sweep"
#define Z121_HW_AIM "aim"

/mob/living/carbon/human
	var/datum/component/z121_highwayman/z121_highwayman

/obj/item
	var/datum/component/z121_highwayman_weapon/z121_highwayman_weapon

// 只检查真正穿戴的衣物，不把手持、背负或腰间携带的护甲算作穿戴。
/proc/z121_highwayman_armor_allowed(mob/living/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	for(var/obj/item/clothing/C in list(H.wear_armor, H.wear_shirt, H.wear_pants, H.head, H.wear_mask, H.wear_neck, H.gloves, H.shoes, H.cloak, H.wear_wrists, H.wear_ring, H.glasses, H.ears))
		if(C.armor_class >= ARMOR_CLASS_MEDIUM)
			return FALSE
	return TRUE

/datum/component/z121_highwayman
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/human/fighter
	var/list/techniques = list()
	var/list/prepared_weapons = list()
	var/datum/action/z121_highwayman_manage/management
	var/stance = 0
	var/selecting = FALSE
	var/selection_complete = FALSE
	var/attacking = FALSE
	var/lunging = FALSE

/datum/component/z121_highwayman/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	fighter = parent
	fighter.z121_highwayman = src
	management = new
	management.Grant(fighter)
	RegisterSignal(parent, COMSIG_MOB_CLICKON, PROC_REF(on_click))
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_death))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipment_changed))
	START_PROCESSING(SSfastprocess, src)
	addtimer(CALLBACK(src, PROC_REF(choose_techniques)), 1)

/datum/component/z121_highwayman/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	clear_prepared()
	for(var/datum/action/z121_highwayman/A as anything in techniques)
		qdel(A)
	techniques.Cut()
	QDEL_NULL(management)
	if(fighter?.z121_highwayman == src)
		fighter.z121_highwayman = null
	fighter = null
	return ..()

/datum/component/z121_highwayman/process()
	enforce_armor()
	for(var/datum/action/z121_highwayman/A as anything in techniques)
		A.UpdateButtonIcon()
	management?.UpdateButtonIcon()

/datum/component/z121_highwayman/proc/on_equipment_changed()
	SIGNAL_HANDLER
	enforce_armor()

/datum/component/z121_highwayman/proc/enforce_armor()
	if(z121_highwayman_armor_allowed(fighter))
		return TRUE
	var/had_effect = length(prepared_weapons) || fighter?.has_status_effect(/datum/status_effect/z121_highwayman_counter) || fighter?.has_status_effect(/datum/status_effect/z121_highwayman_flaws)
	clear_prepared()
	fighter?.remove_status_effect(/datum/status_effect/z121_highwayman_counter)
	fighter?.remove_status_effect(/datum/status_effect/z121_highwayman_flaws)
	if(had_effect)
		to_chat(fighter, span_warning("中甲或重甲妨碍施展武技，待发招式与临时增益已解除。"))
	return FALSE

/datum/component/z121_highwayman/proc/choose_techniques()
	set waitfor = FALSE
	if(selecting || selection_complete || !fighter?.client || fighter.stat == DEAD)
		return
	selecting = TRUE
	var/list/options = list(
		"邪恶切割" = /datum/action/z121_highwayman/cut,
		"切开血管" = /datum/action/z121_highwayman/vein,
		"决斗突刺" = /datum/action/z121_highwayman/duel,
		"破绽百出" = /datum/action/z121_highwayman/flaws,
	)
	for(var/datum/action/z121_highwayman/A as anything in techniques)
		options -= A.name
	while(length(techniques) < 3)
		var/choice = input(fighter, "选择一项武技（[length(techniques)]/3）。完成后不能更换；取消后可点击收势按钮继续。", "拦路悍匪") as null|anything in options
		if(QDELETED(src) || QDELETED(fighter))
			return
		if(!choice || fighter.stat == DEAD)
			selecting = FALSE
			return
		grant_technique(options[choice])
		options -= choice
	options = list("抵近射击" = /datum/action/z121_highwayman/close, "霰弹轰扫" = /datum/action/z121_highwayman/sweep, "精确打击" = /datum/action/z121_highwayman/aim)
	var/choice = input(fighter, "选择一项火枪终结技。完成后不能更换。", "拦路悍匪") as null|anything in options
	if(QDELETED(src) || QDELETED(fighter))
		return
	if(choice && fighter.stat != DEAD)
		grant_technique(options[choice])
		selection_complete = TRUE
	selecting = FALSE

/datum/component/z121_highwayman/proc/grant_technique(action_type)
	var/datum/action/z121_highwayman/A = new action_type
	techniques += A
	A.Grant(fighter)

/datum/component/z121_highwayman/proc/clear_prepared()
	for(var/datum/component/z121_highwayman_weapon/W as anything in prepared_weapons.Copy())
		qdel(W)
	prepared_weapons.Cut()

/datum/component/z121_highwayman/proc/on_death()
	SIGNAL_HANDLER
	clear_prepared()
	stance = 0
	fighter.remove_status_effect(/datum/status_effect/z121_highwayman_counter)
	fighter.remove_status_effect(/datum/status_effect/z121_highwayman_flaws)

/datum/component/z121_highwayman/proc/reset_minor_cooldowns()
	for(var/datum/action/z121_highwayman/A as anything in techniques)
		if(!A.finisher)
			A.ready_at = 0
			A.UpdateButtonIcon()

/datum/component/z121_highwayman/proc/valid_melee_weapon(obj/item/I)
	if(!I || !(istype(I, /obj/item/rogueweapon) || istype(I, /obj/item/gun)))
		return FALSE
	if(!I.force || (I.item_flags & (ABSTRACT|NOBLUDGEON)) || istype(I, /obj/item/rogueweapon/werewolf_claw))
		return FALSE
	if(I.associated_skill == /datum/skill/combat/unarmed)
		return FALSE
	return TRUE

// 突刺只在实际攻击点击时移位，检查通行，不使用穿墙传送。
/datum/component/z121_highwayman/proc/on_click(datum/source, atom/target, params)
	SIGNAL_HANDLER
	if(lunging)
		return COMSIG_MOB_CANCEL_CLICKON
	if(!enforce_armor())
		return
	var/obj/item/I = fighter.get_active_held_item()
	var/datum/component/z121_highwayman_weapon/W = I?.z121_highwayman_weapon
	if(!W || W.controller != src || W.skill_id != Z121_HW_DUEL || !isliving(target) || target == fighter)
		return
	var/list/modifiers = params2list(params)
	if(!modifiers["left"] || modifiers["shift"] || modifiers["ctrl"] || modifiers["alt"] || modifiers["middle"])
		return
	if(!fighter.cmode || fighter.used_intent?.tranged || fighter.used_intent?.no_attack || fighter.incapacitated() || fighter.next_move > world.time || attacking)
		return
	if((fighter.active_hand_index == 1 && fighter.next_lmove > world.time) || (fighter.active_hand_index != 1 && fighter.next_rmove > world.time))
		return
	var/mob/living/victim = target
	if(victim.stat == DEAD || get_dist(fighter, victim) > 3 || fighter.z != victim.z)
		return
	if(fighter.Adjacent(victim))
		return
	if(!(fighter.mobility_flags & MOBILITY_MOVE) || fighter.pulledby || fighter.buckled || fighter.has_status_effect(/datum/status_effect/z121_highwayman_counter))
		return COMSIG_MOB_CANCEL_CLICKON
	var/list/path = find_lunge_path(victim)
	if(!length(path))
		to_chat(fighter, span_warning("没有可供突进的通路。"))
		return COMSIG_MOB_CANCEL_CLICKON
	// 移动可能触发会等待的碰撞、挟持攻击或表情，不能在信号回调中同步执行。
	lunging = TRUE
	INVOKE_ASYNC(src, PROC_REF(lunge_and_attack), victim, I, W, fighter.used_intent, path, params, fighter.next_click)
	return COMSIG_MOB_CANCEL_CLICKON

/datum/component/z121_highwayman/proc/lunge_and_attack(mob/living/victim, obj/item/weapon, datum/component/z121_highwayman_weapon/preparation, datum/intent/intent, list/path, params, click_time)
	var/reached_target = advance_lunge(victim, weapon, preparation, intent, path, click_time)
	lunging = FALSE
	if(!reached_target || QDELETED(src) || QDELETED(fighter))
		return
	// 原点击已被取消；仅接续这一次点击，仍由原生流程检查蓄力、冷却和攻击条件。
	var/saved_next_click = fighter.next_click
	fighter.next_click = world.time - 1
	fighter.ClickOn(victim, params)
	if(!QDELETED(fighter))
		fighter.next_click = max(fighter.next_click, saved_next_click)

/datum/component/z121_highwayman/proc/advance_lunge(mob/living/victim, obj/item/weapon, datum/component/z121_highwayman_weapon/preparation, datum/intent/intent, list/path, click_time)
	for(var/turf/T as anything in path)
		// 每步重新检查，防止等待期间换武器、换甲或新点击后继续旧突刺。
		if(!can_continue_lunge(victim, weapon, preparation, intent, click_time))
			return FALSE
		var/turf/origin = get_turf(fighter)
		if(get_dist(origin, T) != 1 || !z121_highwayman_clear_step(origin, T, fighter))
			return FALSE
		if(!fighter.Move(T, get_dir(fighter, T)))
			return FALSE
	return can_continue_lunge(victim, weapon, preparation, intent, click_time) && fighter.Adjacent(victim)

/datum/component/z121_highwayman/proc/can_continue_lunge(mob/living/victim, obj/item/weapon, datum/component/z121_highwayman_weapon/preparation, datum/intent/intent, click_time)
	if(QDELETED(src) || QDELETED(fighter) || QDELETED(victim) || QDELETED(weapon) || QDELETED(preparation))
		return FALSE
	if(fighter.next_click != click_time || fighter.get_active_held_item() != weapon || weapon.z121_highwayman_weapon != preparation || preparation.controller != src || fighter.used_intent != intent)
		return FALSE
	if(!enforce_armor() || !fighter.cmode || fighter.incapacitated() || fighter.restrained() || fighter.in_throw_mode || fighter.next_move > world.time || attacking)
		return FALSE
	if(victim.stat == DEAD || fighter.z != victim.z || !(fighter.mobility_flags & MOBILITY_MOVE) || fighter.pulledby || fighter.buckled || fighter.has_status_effect(/datum/status_effect/z121_highwayman_counter))
		return FALSE
	return TRUE

/datum/component/z121_highwayman/proc/find_lunge_path(mob/living/target)
	var/turf/start = get_turf(fighter)
	var/list/queue = list(start)
	var/list/routes = list()
	routes[start] = list()
	for(var/index = 1; index <= length(queue); index++)
		var/turf/current = queue[index]
		var/list/route = routes[current]
		if(get_dist(current, target) <= 1 && current != get_turf(target))
			return route
		if(length(route) >= 3)
			continue
		for(var/direction in GLOB.alldirs)
			var/turf/next = get_step(current, direction)
			if(!next || (next in routes) || next == get_turf(target) || !z121_highwayman_clear_step(current, next, fighter))
				continue
			routes[next] = route + next
			queue += next
	return null

/proc/z121_highwayman_clear_step(turf/origin, turf/destination, atom/movable/mover)
	if(!origin || !destination || origin.z != destination.z || destination.density)
		return FALSE
	for(var/atom/movable/A in destination)
		if(A != mover && A.density)
			return FALSE
	// 斜向不能从两堵墙之间穿角。
	if(origin.x != destination.x && origin.y != destination.y)
		if(!z121_highwayman_clear_step(origin, locate(destination.x, origin.y, origin.z), mover) || !z121_highwayman_clear_step(origin, locate(origin.x, destination.y, origin.z), mover))
			return FALSE
	return TRUE

/datum/action/z121_highwayman
	icon_icon = 'modular_z121/icon/custompell.dmi'
	button_icon_state = "spell"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	var/skill_id
	var/finisher = FALSE
	var/cooldown = 9 SECONDS
	var/ready_at = 0

/datum/action/z121_highwayman/IsAvailable()
	if(!..() || !ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	return H.z121_highwayman?.selection_complete && world.time >= ready_at && !HAS_TRAIT(H, TRAIT_PACIFISM) && z121_highwayman_armor_allowed(H)

/datum/action/z121_highwayman/New()
	desc += " 穿戴中甲或重甲时禁用，换装会清除待发招式和临时增益。"
	..()

/datum/action/z121_highwayman/UpdateButtonIcon(status_only = FALSE, force = FALSE)
	. = ..()
	if(button)
		button.maptext = world.time < ready_at ? MAPTEXT("[ceil((ready_at - world.time) / 10)]") : ""

/datum/action/z121_highwayman/Trigger()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!H.z121_highwayman?.enforce_armor())
			to_chat(H, span_warning("穿戴中甲或重甲时无法施展武技。"))
			return FALSE
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/component/z121_highwayman/C = H.z121_highwayman
	var/obj/item/I = H.get_active_held_item()
	if(!I || I.z121_highwayman_weapon)
		to_chat(H, span_warning("请主手持握武器；已有武技时，先命中或收势。"))
		return FALSE
	if(finisher)
		if(!istype(I, /obj/item/gun/ballistic/z121_millicombat_pistol) || C.stance < 3)
			to_chat(H, span_warning("终结技需要主手持握米莉康巴特手枪，并拥有三层架势。"))
			return FALSE
		var/obj/item/gun/ballistic/z121_millicombat_pistol/G = I
		if(G.operating || G.firing || G.firing_stage)
			to_chat(H, span_warning("枪械正在操作中。"))
			return FALSE
	else if(!C.valid_melee_weapon(I) || H.used_intent?.tranged || H.used_intent?.unarmed || H.used_intent?.no_attack)
		to_chat(H, span_warning("这项武技需要主手持握实体武器，并选用近战攻击方式。"))
		return FALSE
	var/datum/component/z121_highwayman_weapon/W = I.AddComponent(/datum/component/z121_highwayman_weapon, C, src)
	if(!istype(W))
		return FALSE
	if(finisher)
		C.stance -= 3
		var/obj/item/gun/ballistic/z121_millicombat_pistol/G = I
		G.z121_highwayman_load()
	else
		C.stance = min(3, C.stance + 1)
		ready_at = world.time + cooldown
	to_chat(H, span_notice("你将「[name]」备于[I]。架势：[C.stance]/3。"))
	H.update_action_buttons()
	return TRUE

/datum/action/z121_highwayman/cut
	name = "邪恶切割"
	desc = "瞬间准备下一击：无视格挡，命中后在普攻之外追加30点无视护甲的锐伤。仍可闪避；冷却9秒。"
	skill_id = Z121_HW_CUT
	button_icon_state = "evilcut"

/datum/action/z121_highwayman/vein
	name = "切开血管"
	desc = "瞬间准备下一击：命中后保留普攻，并无视护甲添加静脉伤口。流血率5，不自行凝血，同部位不叠加；冷却9秒。"
	skill_id = Z121_HW_VEIN
	button_icon_state = "Bloodvessel"

/datum/action/z121_highwayman/duel
	name = "决斗突刺"
	desc = "瞬间准备下一击：攻击3格内目标时先突进，命中后获得最长3秒的原地反击。冷却9秒。"
	skill_id = Z121_HW_DUEL
	button_icon_state = "DuelThrust"

/datum/action/z121_highwayman/flaws
	name = "破绽百出"
	desc = "瞬间准备下一击：命中后40秒内武器普攻伤害与招架概率乘1.3；不增强技能附伤或枪伤。冷却60秒。"
	skill_id = Z121_HW_FLAWS
	button_icon_state = "FullofFlaws"
	cooldown = 60 SECONDS

/datum/action/z121_highwayman/close
	name = "抵近射击"
	desc = "消耗三层架势，为手枪准备终结弹。命中相邻目标造成100%枪伤并缴械，自己后退最多两格；刷新小技能冷却。"
	skill_id = Z121_HW_CLOSE
	button_icon_state = "Shooting"
	finisher = TRUE

/datum/action/z121_highwayman/sweep
	name = "霰弹轰扫"
	desc = "消耗三层架势，为手枪准备终结弹。最远3格，命中点周围3×3内除自己外的活体受到80%枪伤并失衡3秒；刷新小技能冷却。"
	skill_id = Z121_HW_SWEEP
	button_icon_state = "ShotgunSweep"
	finisher = TRUE

/datum/action/z121_highwayman/aim
	name = "精确打击"
	desc = "消耗三层架势，为手枪准备终结弹。最远8格，命中造成150%枪伤，受护甲影响；刷新小技能冷却。"
	skill_id = Z121_HW_AIM
	button_icon_state = "PrecisionStrike"
	finisher = TRUE

/datum/action/z121_highwayman_manage
	name = "收势"
	desc = "查看架势；取消主手武器的待触发技能，不退还冷却或架势。尚未选齐技能时继续选择。"
	icon_icon = 'modular_z121/icon/custompell.dmi'
	button_icon_state = "spell0"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/z121_highwayman_manage/UpdateButtonIcon(status_only = FALSE, force = FALSE)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(button && istype(H))
		button.maptext = MAPTEXT("[H.z121_highwayman?.stance]/3")

/datum/action/z121_highwayman_manage/Trigger()
	if(!..() || !ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/component/z121_highwayman/C = H.z121_highwayman
	if(!C)
		return FALSE
	if(!C.selection_complete)
		C.choose_techniques()
		return TRUE
	var/obj/item/I = H.get_active_held_item()
	if(I?.z121_highwayman_weapon?.controller == C)
		qdel(I.z121_highwayman_weapon)
		to_chat(H, span_notice("你收起了武器上的待发招式。"))
	to_chat(H, span_info("当前架势：[C.stance]/3。"))
	return TRUE

/datum/component/z121_highwayman_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/component/z121_highwayman/controller
	var/datum/action/z121_highwayman/technique
	var/skill_id
	var/finisher = FALSE
	var/datum/weakref/flying_bullet
	var/obj/item/ammo_casing/z121_generated_round

/datum/component/z121_highwayman_weapon/Initialize(datum/component/z121_highwayman/C, datum/action/z121_highwayman/A)
	if(!isitem(parent) || !C || !A)
		return COMPONENT_INCOMPATIBLE
	controller = C
	technique = A
	skill_id = A.skill_id
	finisher = A.finisher
	var/obj/item/I = parent
	I.z121_highwayman_weapon = src
	C.prepared_weapons += src
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/z121_highwayman_weapon/Destroy()
	var/obj/item/I = parent
	if(I?.z121_highwayman_weapon == src)
		I.z121_highwayman_weapon = null
	controller?.prepared_weapons.Remove(src)
	// 免费补出的弹丸只属于此次武技，取消或转交时不留下物资。
	if(!QDELETED(z121_generated_round))
		if(istype(I, /obj/item/gun/ballistic/z121_millicombat_pistol))
			var/obj/item/gun/ballistic/z121_millicombat_pistol/G = I
			if(G.chambered == z121_generated_round)
				G.chambered = null
				G.gunpowder = FALSE
		qdel(z121_generated_round)
		I?.update_icon()
	controller = null
	technique = null
	flying_bullet = null
	z121_generated_round = null
	return ..()

/datum/component/z121_highwayman_weapon/proc/on_drop()
	SIGNAL_HANDLER
	qdel(src)

/datum/component/z121_highwayman_weapon/proc/on_move()
	SIGNAL_HANDLER
	var/obj/item/I = parent
	if(I.loc != controller?.fighter)
		qdel(src)

/datum/component/z121_highwayman_weapon/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(user == controller?.fighter)
		examine_list += span_info("你在此武器上备好了「[technique.name]」，命中活体后触发。")

/obj/item/proc/z121_highwayman_cut_ready(mob/living/user)
	return z121_highwayman_weapon?.skill_id == Z121_HW_CUT && z121_highwayman_weapon.controller?.fighter == user && z121_highwayman_armor_allowed(user)

/obj/item/proc/z121_highwayman_landed(mob/living/user, mob/living/victim, zone)
	var/datum/component/z121_highwayman_weapon/W = z121_highwayman_weapon
	if(!W || W.finisher || W.controller?.fighter != user || !user.is_holding(src) || victim == user || QDELETED(victim) || !W.controller.enforce_armor())
		return
	var/skill = W.skill_id
	qdel(W)
	switch(skill)
		if(Z121_HW_CUT)
			z121_highwayman_true_damage(user, victim, 30, BRUTE, zone, TRUE)
		if(Z121_HW_VEIN)
			if(iscarbon(victim))
				var/mob/living/carbon/C = victim
				var/obj/item/bodypart/B = C.get_bodypart(check_zone(zone))
				if(B && !B.has_wound(/datum/wound/slash/vein))
					B.add_wound(/datum/wound/slash/vein)
			else if(!victim.has_wound(/datum/wound/slash/vein))
				victim.simple_add_wound(/datum/wound/slash/vein)
		if(Z121_HW_DUEL)
			user.apply_status_effect(/datum/status_effect/z121_highwayman_counter)
		if(Z121_HW_FLAWS)
			user.apply_status_effect(/datum/status_effect/z121_highwayman_flaws)
	log_combat(user, victim, "武技命中", src, skill)

// 真伤直接进入部位损伤，绕过物理护甲但保留无敌保护及正常死亡处理。
/proc/z121_highwayman_true_damage(mob/living/user, mob/living/victim, amount, damage_type, zone, sharp = FALSE)
	if(QDELETED(victim) || amount <= 0 || (victim.status_flags & GODMODE))
		return
	if(iscarbon(victim) && (damage_type == BRUTE || damage_type == BURN))
		var/mob/living/carbon/C = victim
		var/obj/item/bodypart/B = C.get_bodypart(check_zone(zone))
		if(!B)
			B = C.get_bodypart(BODY_ZONE_CHEST)
		if(B)
			B.receive_damage(damage_type == BRUTE ? amount : 0, damage_type == BURN ? amount : 0)
			if(sharp)
				B.bodypart_attacked_by(BCLASS_CUT, amount, user, B.body_zone, crit_message = TRUE)
			C.updatehealth()
			return
	victim.apply_damage(amount, damage_type, zone, blocked = 0, forced = TRUE)

/datum/status_effect/z121_highwayman_flaws
	id = "z121_highwayman_flaws"
	duration = 40 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/z121_highwayman_flaws

/datum/status_effect/z121_highwayman_flaws/on_apply()
	if(!z121_highwayman_armor_allowed(owner))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/z121_highwayman_flaws
	name = "破绽百出"
	desc = "武器普通近战伤害和招架概率乘1.3；技能附伤与枪伤不变。"
	icon = 'modular_z121/icon/custompell.dmi'
	icon_state = "FullofFlaws"
