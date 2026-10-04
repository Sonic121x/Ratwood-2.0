// 恐怖之钟：在空旷场地召唤怪物，或启动格拉加尔试炼。
// 每座钟的两种模式共用每日一次机会，随游戏黎明刷新；普通召唤仍延迟十秒。
#define TERROR_CLOCK_CLEAR_RANGE 6
#define TERROR_CLOCK_SUMMON_RANGE 5
#define TERROR_CLOCK_SUMMON_DELAY (10 SECONDS)
#define TERROR_CLOCK_MAX_MONSTERS 10
#define TERROR_CLOCK_BOSS_CATEGORY "梦魇"
#define TERROR_CLOCK_BOSS_MAX 2
#define TERROR_CLOCK_TRIAL_LABEL "格拉加尔的凝视"
#define TERROR_CLOCK_PURGE_RANGE 10
// 仅普通召唤进行整批翻倍判定，惩罚队伍保持固定数量。
#define TERROR_CLOCK_DOUBLE_CHANCE 10
#define TERROR_CLOCK_GRAGGAR_DOUBLE_CHANCE 25
#define TERROR_CLOCK_PUNISHMENT_AMOUNT 8

// 摧毁惩罚按职业顺序生成，空位不足时也尽早形成混编，不读取试炼配置。
GLOBAL_LIST_INIT(terror_clock_punishment_roster, list(
	/mob/living/carbon/human/species/human/northern/terror_clock_hunter,
	/mob/living/carbon/human/species/human/northern/terror_clock_hunter/archer,
	/mob/living/carbon/human/species/human/northern/terror_clock_hunter/mage,
	/mob/living/carbon/human/species/human/northern/terror_clock_hunter/priest,
	/mob/living/carbon/human/species/human/northern/terror_clock_hunter,
	/mob/living/carbon/human/species/human/northern/terror_clock_hunter/archer,
	/mob/living/carbon/human/species/human/northern/terror_clock_hunter,
	/mob/living/carbon/human/species/human/northern/terror_clock_hunter,
))

// 分类与怪物类型保持原有配置；人形怪物自行完成延迟装备初始化。
GLOBAL_LIST_INIT(terror_clock_roster, list(
	"野兽" = list(
		"恶狼" = /mob/living/simple_animal/hostile/retaliate/rogue/wolf,
		"赤狐" = /mob/living/simple_animal/hostile/retaliate/rogue/fox,
		"野猪" = /mob/living/simple_animal/hostile/retaliate/rogue/swine,
		"公山羊" = /mob/living/simple_animal/hostile/retaliate/rogue/goatmale,
		"公牛" = /mob/living/simple_animal/hostile/retaliate/rogue/bull,
		"母牛" = /mob/living/simple_animal/hostile/retaliate/rogue/cow,
		"野猫" = /mob/living/simple_animal/hostile/retaliate/rogue/cat,
		"母鸡" = /mob/living/simple_animal/hostile/retaliate/rogue/chicken,
		"赛加羚羊" = /mob/living/simple_animal/hostile/retaliate/rogue/saiga,
		"巨熊" = /mob/living/simple_animal/hostile/retaliate/rogue/direbear,
		"山猫" = /mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat,
		"獾" = /mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger,
		"浣熊" = /mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon,
		"母山羊" = /mob/living/simple_animal/hostile/retaliate/rogue/goat,
		"兔蟹" = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit,
	),
	"怪物" = list(
		"巨鼠" = /mob/living/simple_animal/hostile/retaliate/rogue/bigrat,
		"巨型甲虫" = /mob/living/simple_animal/hostile/retaliate/rogue/beetle,
		"泥蟹" = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab,
		"岩石蜘蛛" = /mob/living/simple_animal/hostile/retaliate/rogue/spider/rock,
		"蜘蛛德莱厄" = /mob/living/simple_animal/hostile/retaliate/rogue/drider,
		"无头骑士" = /mob/living/simple_animal/hostile/retaliate/rogue/headless,
		"拉弥亚" = /mob/living/simple_animal/hostile/retaliate/rogue/lamia,
		"苔背兽" = /mob/living/simple_animal/hostile/retaliate/rogue/mossback,
		"巨鼹" = /mob/living/simple_animal/hostile/retaliate/rogue/mole,
		"不死之狼" = /mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead,
		"巨魔" = /mob/living/simple_animal/hostile/retaliate/rogue/troll,
		"蜂蛛" = /mob/living/simple_animal/hostile/retaliate/rogue/spider,
		"斯卡拉克斯蜘蛛" = /mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated,
		"洞穴巨魔" = /mob/living/simple_animal/hostile/retaliate/rogue/troll/cave,
		"沼泽巨魔" = /mob/living/simple_animal/hostile/retaliate/rogue/troll/bog,
		"持斧巨魔" = /mob/living/simple_animal/hostile/retaliate/rogue/troll/axe,
		"泥沼爬蛛" = /mob/living/simple_animal/hostile/retaliate/rogue/mirespider,
		"暴怒泥沼爬蛛" = /mob/living/simple_animal/hostile/retaliate/rogue/mirespider/angry,
		"死灵赛加羚" = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead,
		"弗雷滕西斯" = /mob/living/simple_animal/hostile/retaliate/rogue/bigrat/gethsmane,
		"拖拽者" = /mob/living/simple_animal/hostile/rogue/dragger,
		"血肉傀儡" = /mob/living/simple_animal/hostile/rogue/dragger/flesh,
		"小型梦魇魔" = /mob/living/simple_animal/hostile/rogue/dreamfiend/unbound,
	),
	"人形" = list(
		"兽人" = /mob/living/simple_animal/hostile/retaliate/rogue/orc,
		"兽人长矛兵" = /mob/living/simple_animal/hostile/retaliate/rogue/orc/spear,
		"兽人弓手" = /mob/living/simple_animal/hostile/retaliate/rogue/orc/ranged,
		"兽人劫掠者" = /mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder,
		"兽人蹂躏者" = /mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/ravager,
		"骷髅" = /mob/living/simple_animal/hostile/rogue/skeleton,
		"骷髅斧兵" = /mob/living/simple_animal/hostile/rogue/skeleton/axe,
		"骷髅矛兵" = /mob/living/simple_animal/hostile/rogue/skeleton/spear,
		"骷髅卫兵" = /mob/living/simple_animal/hostile/rogue/skeleton/guard,
		"骷髅弓手" = /mob/living/simple_animal/hostile/rogue/skeleton/bow,
		"哥布林" = /mob/living/carbon/human/species/goblin/npc,
		"洞穴哥布林" = /mob/living/carbon/human/species/goblin/npc/cave,
		"地狱哥布林" = /mob/living/carbon/human/species/goblin/npc/hell,
		"海哥布林" = /mob/living/carbon/human/species/goblin/npc/sea,
		"月哥布林" = /mob/living/carbon/human/species/goblin/npc/moon,
		"蜥蜴人狱卒" = /mob/living/carbon/human/species/lizardfolk/psy_vault_guard/ambush,
		"拦路强盗" = /mob/living/carbon/human/species/human/northern/highwayman,
		"沼泽逃兵" = /mob/living/carbon/human/species/human/northern/bog_deserters,
		"盗贼" = /mob/living/carbon/human/species/human/northern/thief,
		"海上劫掠者" = /mob/living/carbon/human/species/human/northern/searaider,
		"癫狂寻宝者" = /mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter,
		"癫狂骑士" = /mob/living/carbon/human/species/human/northern/deranged_knight,
		"卓尔劫掠者" = /mob/living/carbon/human/species/elf/dark/drowraider,
	),
	"梦魇" = list(
		"炎之原初体" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire,
		"水之原初体" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/water,
		"风之原初体" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/air,
		"地狱犬" = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,
		"恶鬼" = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend,
		"大型梦魇魔" = /mob/living/simple_animal/hostile/rogue/dreamfiend/major/unbound,
		"远古梦魇魔" = /mob/living/simple_animal/hostile/rogue/dreamfiend/ancient/unbound,
	),
))

/obj/structure/terror_clock
	name = "恐怖之钟"
	desc = "一座散发着不祥气息的落地钟。传说敲响它便能召唤令人胆寒的怪物浪潮，使用时务必慎之又慎。"
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "churchbell"
	// 将九十六像素贴图的中心对齐实际所在地块。
	pixel_x = -32
	density = TRUE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 200
	integrity_failure = 0.5
	break_sound = "glassbreak"
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	// 倒计时和生成期间锁定普通召唤，试炼由独立控制器占用。
	var/summoning = FALSE
	var/datum/glaggar_challenge/active_challenge
	// 记录最近启动的游戏日；空值表示这座钟尚未使用，游戏首日也能正常启动。
	var/last_used_day = null
	// 先登记再处理摧毁，避免重入或重复回调生成多批惩罚怪物。
	var/destruction_punishment_triggered = FALSE
	// 仅在当前攻击结算期间保存来源，不把后续无来源的环境伤害归给旧攻击者。
	var/mob/damage_attacker

/obj/structure/terror_clock/attacked_by(obj/item/I, mob/living/user)
	var/mob/previous_attacker = damage_attacker
	damage_attacker = user
	. = ..()
	if(!QDELETED(src))
		damage_attacker = previous_attacker

/obj/structure/terror_clock/attack_generic(mob/user, damage_amount = 0, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, armor_penetration = 0)
	var/mob/previous_attacker = damage_attacker
	damage_attacker = user
	. = ..()
	if(!QDELETED(src))
		damage_attacker = previous_attacker

/obj/structure/terror_clock/bullet_act(obj/projectile/P)
	var/mob/previous_attacker = damage_attacker
	damage_attacker = ismob(P.firer) ? P.firer : null
	. = ..()
	if(!QDELETED(src))
		damage_attacker = previous_attacker

/obj/structure/terror_clock/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	var/mob/previous_attacker = damage_attacker
	damage_attacker = throwingdatum?.thrower
	. = ..()
	if(!QDELETED(src))
		damage_attacker = previous_attacker

// 钟没有单独的损坏贴图，沿用父类的完整性处理。
/obj/structure/terror_clock/obj_break(damage_flag)
	..()

// 仅完全摧毁触发；不挂接通用删除回调，管理员删除和地图清理不会产生惩罚。
/obj/structure/terror_clock/obj_destruction(damage_flag)
	if(QDELETED(src) || obj_destroyed || destruction_punishment_triggered)
		return
	destruction_punishment_triggered = TRUE
	obj_destroyed = TRUE
	summoning = FALSE
	var/turf/center = get_turf(src)
	var/mob/living/destroyer = isliving(damage_attacker) ? damage_attacker : null
	var/spawned = 0
	// 先终止旧试炼并拆除壁垒，惩罚怪物不登记进旧控制器，避免被随后清理。
	if(!QDELETED(active_challenge))
		active_challenge.abort_challenge("恐怖之钟被彻底摧毁了。")
	active_challenge = null
	if(center)
		playsound(center, 'sound/misc/demon_attack1.ogg', 100, FALSE, extrarange = 14)
		visible_message(span_danger("[src]在崩裂中发出骇人的嘶吼，恶意从残骸中涌出！"))
		// 绕过每日次数和整片净空要求，但每个落点仍需安全且未被占用。
		var/list/spawn_turfs = get_valid_spawn_turfs(center)
		for(var/i in 1 to TERROR_CLOCK_PUNISHMENT_AMOUNT)
			var/turf/target = terror_clock_take_safe_turf(spawn_turfs)
			if(!target)
				break
			var/mob_type = GLOB.terror_clock_punishment_roster[i]
			var/mob/living/carbon/human/species/human/northern/terror_clock_hunter/M = new mob_type(target)
			if(QDELETED(M))
				continue
			M.preferred_victim = WEAKREF(destroyer)
			terror_clock_awaken_mob(M)
			spawned++
		if(spawned)
			visible_message(span_danger("钟的毁灭招来了报复——[spawned] 名敌人出现在周围！"))
			if(spawned < TERROR_CLOCK_PUNISHMENT_AMOUNT)
				visible_message(span_warning("惩罚原本将招来 [TERROR_CLOCK_PUNISHMENT_AMOUNT] 名敌人，但因安全空位不足或生成失败，仅有 [spawned] 名现身。"))
		else
			visible_message(span_warning("恐怖的嘶吼渐渐消散——没有可用的安全落点或敌人生成失败，惩罚召唤落空了。"))
	// 完全未生成敌人时才诅咒摧毁者，部分生成不追加惩罚，也不触发试炼的传送流程。
	if(!spawned && !QDELETED(destroyer))
		destroyer.apply_status_effect(/datum/status_effect/glaggar_curse)
		to_chat(destroyer, span_danger("惩罚召唤未能成形，格拉加尔的怒火转而降临到摧毁恐怖之钟的你身上！你受到了格拉加尔的诅咒！"))
	// 保留父类的残骸、燃烧或酸蚀处理，不使用会清除地面物品的敲钟流程。
	return ..()

// 每次菜单返回及最终提交都重新校验；这里不等待，也不消耗冷却。
/obj/structure/terror_clock/proc/can_activate(mob/living/user)
	if(QDELETED(user))
		return FALSE
	if(QDELETED(src))
		to_chat(user, span_warning("恐怖之钟已不存在，操作取消。"))
		return FALSE
	if(user.stat == DEAD || user.incapacitated())
		to_chat(user, span_warning("你现在无法敲响恐怖之钟。"))
		return FALSE
	var/turf/clock_turf = get_turf(src)
	var/turf/user_turf = get_turf(user)
	if(!clock_turf || !user_turf || clock_turf.z != user_turf.z || !Adjacent(user))
		to_chat(user, span_warning("你必须靠近恐怖之钟才能操作，召唤已取消。"))
		return FALSE
	if(obj_broken || obj_destroyed)
		to_chat(user, span_warning("这座钟已经损毁，无法敲响。"))
		return FALSE
	if(summoning)
		to_chat(user, span_warning("钟声仍在回荡，无法再次敲响。"))
		return FALSE
	if(active_challenge)
		to_chat(user, span_warning("格拉加尔的试炼正在进行，此钟暂时无法使用。"))
		return FALSE
	if(!isnull(last_used_day) && GLOB.dayspassed <= last_used_day)
		to_chat(user, span_warning("这座恐怖之钟今日已经使用过了，请等到下一次黎明再来。"))
		return FALSE
	var/atom/obstruction = get_blocking_building()
	if(obstruction)
		to_chat(user, span_warning("附近 [TERROR_CLOCK_CLEAR_RANGE] 格范围内存在建筑（[obstruction.name]），钟无法运作。请在空旷处使用。"))
		return FALSE
	var/ground_error = terror_clock_ground_error(clock_turf)
	if(ground_error)
		to_chat(user, span_warning(ground_error))
		return FALSE
	return TRUE

/obj/structure/terror_clock/attack_hand(mob/user)
	if(!isliving(user))
		return ..()
	var/mob/living/L = user
	if(!can_activate(L))
		return
	L.changeNext_move(CLICK_CD_MELEE)
	var/list/top_choices = GLOB.terror_clock_roster.Copy()
	top_choices[TERROR_CLOCK_TRIAL_LABEL] = null
	var/category = tgui_input_list(L, "你要召唤何种类别的存在？", "恐怖之钟", top_choices)
	if(isnull(category) || QDELETED(src) || !can_activate(L))
		return
	if(category == TERROR_CLOCK_TRIAL_LABEL)
		start_glaggar_challenge(L)
		return
	var/list/species_list = GLOB.terror_clock_roster[category]
	if(!islist(species_list) || !length(species_list))
		to_chat(L, span_warning("这个类别中没有可召唤的存在，召唤失败。"))
		return
	var/choice = tgui_input_list(L, "选择具体的[category]种类：", "恐怖之钟", species_list)
	if(isnull(choice) || QDELETED(src) || !can_activate(L))
		return
	var/mob_type = species_list[choice]
	if(!ispath(mob_type, /mob/living))
		to_chat(L, span_warning("无法识别所选的存在，召唤失败。"))
		return
	var/max_amount = (category == TERROR_CLOCK_BOSS_CATEGORY) ? TERROR_CLOCK_BOSS_MAX : TERROR_CLOCK_MAX_MONSTERS
	var/amount = tgui_input_number(L, "要召唤多少只？（最多 [max_amount] 只）", "恐怖之钟", 1, max_amount, 1)
	if(isnull(amount))
		return
	amount = clamp(round(amount), 1, max_amount)
	// 最后一次校验后立即占用，避免其他预先打开的菜单绕过互斥与冷却。
	if(QDELETED(src) || !can_activate(L))
		return
	summoning = TRUE
	last_used_day = GLOB.dayspassed
	ring_bell()
	visible_message(span_danger("[src]发出一声低沉的轰鸣，空气中弥漫开令人胆寒的气息……"))
	to_chat(L, span_danger("你敲响了恐怖之钟。[TERROR_CLOCK_SUMMON_DELAY / 10] 秒后，怪物将会降临。"))
	addtimer(CALLBACK(src, PROC_REF(do_summon), mob_type, amount, L), TERROR_CLOCK_SUMMON_DELAY)

/obj/structure/terror_clock/proc/start_glaggar_challenge(mob/living/user)
	if(!can_activate(user))
		return
	var/datum/glaggar_challenge/challenge = new()
	active_challenge = challenge
	if(!challenge.start(src, user))
		active_challenge = null
		return
	last_used_day = GLOB.dayspassed

// 保留原有净空规则：封闭地块和钟以外的结构均会阻止启动。
/obj/structure/terror_clock/proc/get_blocking_building()
	for(var/turf/closed/wall_turf in range(TERROR_CLOCK_CLEAR_RANGE, src))
		return wall_turf
	for(var/obj/structure/found in range(TERROR_CLOCK_CLEAR_RANGE, src))
		if(found != src)
			return found
	return null

// 只判断地面本身，不把钟、玩家或试炼壁垒当成地面缺失。
/proc/terror_clock_ground_turf(turf/T)
	// 本仓库的深坑属于悬空地块，虚空使用冥界地板类型；旧太空宏指向不存在的类型。
	if(!T || !isopenturf(T) || T.density || isgroundlessturf(T) || istype(T, /turf/open/floor/rogue/underworld/space))
		return FALSE
	return TRUE

// 建造、启动和延迟刷怪共用完整场地检查，外环也必须有地面，避免悬空小平台通过净空校验。
/proc/terror_clock_ground_error(turf/center)
	if(!center)
		return "恐怖之钟没有有效的放置地点。"
	var/turf_count = 0
	for(var/turf/T in range(TERROR_CLOCK_CLEAR_RANGE, center))
		if(!terror_clock_ground_turf(T))
			return "恐怖之钟周围 [TERROR_CLOCK_CLEAR_RANGE] 格范围内必须有完整的安全地面，不能包含悬空、水域、熔岩或虚空。"
		turf_count++
	// 地图边缘会截断范围，也不能被误判成完整场地。
	if(turf_count != (2 * TERROR_CLOCK_CLEAR_RANGE + 1) ** 2)
		return "恐怖之钟距离地图边缘太近，周围必须留出完整的 [TERROR_CLOCK_CLEAR_RANGE] 格场地。"
	return null

// 刷怪和传送还需检查实体占用；忽略参数仅用于检查角色自己脚下的位置。
/proc/terror_clock_safe_turf(turf/T, atom/movable/ignored)
	if(!terror_clock_ground_turf(T))
		return FALSE
	for(var/atom/movable/AM in T)
		if(AM == ignored || QDELETED(AM))
			continue
		if(AM.density || isliving(AM))
			return FALSE
	return TRUE

// 不放回抽取，并在使用前剔除已经被占用或变得危险的地块。
/proc/terror_clock_take_safe_turf(list/candidates)
	while(length(candidates))
		var/turf/T = pick_n_take(candidates)
		if(terror_clock_safe_turf(T))
			return T
	return null

/obj/structure/terror_clock/proc/get_valid_spawn_turfs(turf/center)
	var/list/valid = list()
	if(!center)
		center = get_turf(src)
	if(!center)
		return valid
	for(var/turf/T in range(TERROR_CLOCK_SUMMON_RANGE, center))
		if(T != center && terror_clock_safe_turf(T))
			valid += T
	return valid

// 启动成功后不再要求使用者留在原地，但钟损坏时仍然中止召唤。
/obj/structure/terror_clock/proc/do_summon(mob_type, amount, mob/living/user)
	if(QDELETED(src) || obj_broken || obj_destroyed || active_challenge || !ispath(mob_type, /mob/living))
		summoning = FALSE
		return
	// 倒计时内地板可能被拆除，不能仅从残留的小块地面中挑选出生点。
	var/ground_error = terror_clock_ground_error(get_turf(src))
	if(ground_error)
		visible_message(span_warning("[src]的召唤中止：[ground_error]"))
		summoning = FALSE
		return
	// 倒计时结束后读取当前讲述者；每批仅判定一次，不影响试炼及摧毁惩罚。
	var/double_chance = istype(SSgamemode?.current_storyteller, /datum/storyteller/graggar) ? TERROR_CLOCK_GRAGGAR_DOUBLE_CHANCE : TERROR_CLOCK_DOUBLE_CHANCE
	var/target_amount = amount
	if(prob(double_chance))
		target_amount *= 2
		visible_message(span_danger("[src]的余音骤然扭曲——这次召唤的怪物数量翻倍了！"))
	var/list/spawn_turfs = get_valid_spawn_turfs()
	var/spawned = 0
	for(var/i in 1 to target_amount)
		var/turf/target = terror_clock_take_safe_turf(spawn_turfs)
		if(!target)
			break
		var/mob/living/M = new mob_type(target)
		if(QDELETED(M))
			continue
		terror_clock_awaken_mob(M)
		spawned++
	if(spawned)
		visible_message(span_danger("伴随着[src]最后的余音，[spawned] 只怪物凭空浮现，獠牙毕露！"))
		if(spawned < target_amount && !QDELETED(user))
			to_chat(user, span_warning("本次选择了 [amount] 只怪物，最终应召唤 [target_amount] 只，实际仅生成 [spawned] 只；其余因安全空位不足或生成失败而取消。"))
		ring_bell()
	else
		visible_message(span_warning("[src]的钟声归于沉寂——没有可用的安全空地或怪物生成失败，召唤落空了。"))
	summoning = FALSE

// 保留原有钟声及范围清场行为。
/obj/structure/terror_clock/proc/ring_bell()
	playsound(src, 'sound/misc/bell.ogg', 100, FALSE, extrarange = 7)
	purge_surroundings()

// 仅删除无玩家归属的尸体、可清理污迹和未固定的地面物品。
/obj/structure/terror_clock/proc/purge_surroundings()
	for(var/atom/movable/AM in range(TERROR_CLOCK_PURGE_RANGE, src))
		if(isliving(AM))
			var/mob/living/M = AM
			if(M.stat != DEAD)
				continue
			if(M.ckey || (M.mind && M.mind.key))
				continue
			qdel(M)
			continue
		if(istype(AM, /obj/effect/decal/cleanable))
			qdel(AM)
			continue
		if(isitem(AM))
			var/obj/item/I = AM
			if(!isturf(I.loc) || I.anchored)
				continue
			qdel(I)

// 仅调整本次生成的实例，不改变地图上的动物或原生类型默认值。
/proc/terror_clock_awaken_mob(mob/living/M)
	if(QDELETED(M))
		return
	if(istype(M, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = M
		// 反击型动物的敌人列表初始为空，仅开启处理循环仍无法主动索敌。
		if(istype(H, /mob/living/simple_animal/hostile/retaliate))
			var/mob/living/simple_animal/hostile/retaliate/R = H
			R.aggressive = TRUE
		H.toggle_ai(AI_ON)
		H.FindTarget()
		return
	// 人形怪物使用独立的处理模式；保留各物种原有技能和移动策略。
	if(ishuman(M))
		var/mob/living/carbon/human/HN = M
		if(HN.mode == NPC_AI_OFF)
			HN.mode = NPC_AI_IDLE

// 清理局部宏，避免影响后续编译的文件。
#undef TERROR_CLOCK_CLEAR_RANGE
#undef TERROR_CLOCK_SUMMON_RANGE
#undef TERROR_CLOCK_SUMMON_DELAY
#undef TERROR_CLOCK_MAX_MONSTERS
#undef TERROR_CLOCK_BOSS_CATEGORY
#undef TERROR_CLOCK_BOSS_MAX
#undef TERROR_CLOCK_TRIAL_LABEL
#undef TERROR_CLOCK_PURGE_RANGE
#undef TERROR_CLOCK_DOUBLE_CHANCE
#undef TERROR_CLOCK_GRAGGAR_DOUBLE_CHANCE
#undef TERROR_CLOCK_PUNISHMENT_AMOUNT
