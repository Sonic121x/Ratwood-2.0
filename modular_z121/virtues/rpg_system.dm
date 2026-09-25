// ============================================================================
// modular_z121/virtues/rpg_system.dm
// 自定义美德（Custom Virtue）：RPG 系统 / RPG System
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的美德"RPG 系统"。设定上：你是一名"世界旅人"，带着只属于旅人的
//   作弊外挂降临此世——在你眼里，这个世界不过是一款无比真实的 RPG 游戏。
//   该美德会为持有者打开一个专属的"系统面板"：
//     · 击杀怪物可以赚取【系统积分】；
//     · 积分可以在系统商店里兑换各种 物品 / 装备 / 武器 / 消耗品；
//     · 甚至可以用积分直接强化技能（提升技能等级）与属性（提升六维 / 幸运）。
//
//   需求拆解：
//     · 名称：RPG System / RPG 系统
//     · 消耗：99 点凯旋点数（triumph_cost = 99）
//     · 赋予一个"独一无二的系统界面"（玩家可主动呼出的动词 / 菜单）
//     · 击杀怪物 → 获得积分
//     · 积分 → 兑换 物品 / 装备 / 武器 / 消耗品
//     · 积分 → 强化技能、强化属性
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何
//   游戏逻辑文件；TGUI 前端允许放在对应界面目录。本文件通过"向已有类型追加子类型 / 组件 / 动词（verb）"的方式接入引擎，不修改
//   任何核心文件，因此完全满足约束。
//   （向核心类型 /mob/living/carbon/human 追加一个 proc/verb，以及向核心类型追加组件，
//     都属于"追加子类型内容"而非"编辑核心文件"——这与本目录既有做法一致，例如
//     life_potential.dm 向核心类型挂组件、genius.dm 追加 proc 重写。）
//
// 为什么用"组件 + 动词"而不是"在美德 datum 单例上直接做"：
//   GLOB.virtues 里的美德 datum 是所有玩家共享的"模板单例"，不能把"某个人的积分 / 信号
//   监听"挂到它身上（会串号）。组件实例与具体的 recipient 一一绑定，能正确地存储这名玩家
//   的积分、注册 / 反注册信号，并在宿主消失时自动清理，是承载"每名玩家独立系统数据"的正解。
//
// 击杀归属（kill attribution）如何判定：
//   引擎里每个 mob 被攻击时都会写入 lastattacker_weakref（见 species.dm 近战 / 远程攻击、
//   simple_animal/animal_defense.dm 等处），它弱引用"最后一个攻击者"。当怪物死亡时，
//   /mob/living/death() 会发出 COMSIG_LIVING_DEATH 信号（death.dm:128）。因此：
//     · 我们给"系统持有者附近的怪物"挂一个一次性的"击杀监听组件"，监听其 COMSIG_LIVING_DEATH；
//     · 怪物一死，就解析它的 lastattacker_weakref，若凶手是持有【RPG 系统】特性的人类，
//       就给那名凶手发放积分。
//   这样无论玩家用近战 / 远程 / 法术哪种方式击杀，归属都准确（都依赖统一的 lastattacker）。
//
// 为什么用"轮询附近怪物并挂监听组件"而不是"重写怪物的 death()"：
//   核心在 /mob/living/death() 之外的多个子类型（hostile/death、rogue/death……）都重写了
//   death()。在 modular 文件里重定义某个已被定义的 death() 路径，会让 ..() 落到父级、跳过
//   核心同名重写的本体（掉落物 / 清理逻辑），破坏所有该类怪物——风险极大且影响全局（连非本
//   美德玩家杀的怪也受影响）。改为"信号 + 组件"则零侵入：不替换任何行为，只是旁听死亡事件。
//   而要给怪物挂上监听，又没有"全局怪物死亡信号"可用，故由持有者的驱动组件每个处理周期扫描
//   自己视野内的敌对怪物，给它们补挂一次性监听组件（组件 UNIQUE 去重，重复扫描不会叠加）。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/virtue                          美德基类（modular_azurepeak/_virtue.dm）
//   - /datum/component                       组件基类（承载每名玩家的系统数据与信号）
//   - COMSIG_LIVING_DEATH                     生命体死亡信号（code/__DEFINES/components.dm:327）
//   - lastattacker_weakref                    被攻击者记录的"最后攻击者"弱引用（living_defines.dm:12）
//   - SSprocessing / START_PROCESSING / process(delta_time)  处理子系统（周期性扫描视野）
//   - /mob/proc/adjust_triumphs(n, FALSE)     调整凯旋点数（年龄/种族等不符时退款；本美德无门槛）
//   - /mob/living/proc/change_stat(key, amt)  调整属性（内部自带 1~20 越界保护）
//   - /mob/living/proc/get_stat(stat)         读取当前属性值（用于"满级不再扣费"判断）
//   - /mob/proc/get_skill_level(skill)        读取当前技能等级（用于"满级不再扣费"判断）
//   - /mob/proc/adjust_skillrank(skill, amt)  提升技能等级（内部按经验上限封顶到传奇）
//   - /mob/proc/put_in_hands(I)               把兑换出的物品塞进手里（失败则留在脚下地块）
//   - GLOB.roguetraits                        玩家"特性自检面板"读取的全局特性说明表
//   - ADD_TRAIT / HAS_TRAIT / TRAIT_VIRTUE    特性增删与美德来源标签
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）；
//       特性的玩家可见登记由 bootstrap/custom_bootstrap.dm 调用 register_rpg_system_trait() 完成。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：RPG 系统
// 为什么要定义：用一个唯一字符串标识"持有 RPG 系统"的人，便于本文件（击杀监听组件、
//   动词）通过 HAS_TRAIT 判断身份，也作为 ADD_TRAIT 的来源标签使用。
// 为什么用"RPG系统"这个可读串作为特性值（而非英文 slug）：
//   引擎的玩家"特性自检面板"会直接把"特性字符串本身"当作标题显示给玩家（参见
//   life_potential.dm / genius.dm 对该机制的说明，以及 TRAIT_NOPAIN 的值"无痛"）。
//   写成可读名"RPG系统"，玩家点开特性列表时就能看到一个体面的标题。该串在本项目中唯一。
// ----------------------------------------------------------------------------
#define TRAIT_RPG_SYSTEM "RPG系统"

// 本美德的凯旋点数消耗：99 点。需求明确为"消耗 99 点"。
// 单列为常量，便于将来平衡性调整只改这一处。
#define RPG_SYSTEM_TRIUMPH_COST 99

// 击杀监听组件每"巡检"一次的范围（以持有者为中心的视野格数）。
// 为什么是 9：略大于默认视野（7），确保玩家屏幕内（含边缘）正在交战的怪物都能被及时挂上监听。
#define RPG_SYSTEM_SCAN_RANGE 9

// 击杀积分的换算：默认为怪物最大生命值 maxHealth 的 20%，越强的怪给得越多。
// 为什么按 maxHealth：simple_animal 系怪物普遍带 maxHealth，且它与"怪物强度"高度相关，
//   是最稳妥、对所有怪物都可用的强度近似指标（无需为每种怪单独配表）。
// 为什么是 0.2（20%）：需求明确"击杀获得的积分 = 怪物最大生命值的 20%"。例如 100 血的怪给 20 分，
//   200 血的怪给 40 分。单列为常量，平衡只改这一处。
// 注：部分"类人怪物"（NPC，属 /mob/living/carbon/human 子类型）不走这个比例，而是按
//   get_fixed_kill_rewards() 里登记的"固定积分"给分（见下方击杀监听组件）。
#define RPG_SYSTEM_POINTS_PER_MAXHP 0.2
// 单次击杀的保底积分：纯粹用于兜底——防止极低血量怪物经 round() 后算出 0 分（"杀了像没收益"）。
//   故仅设为 1（最低限度的非零保证），不破坏"积分=10% 最大生命值"的基本设定。
#define RPG_SYSTEM_MIN_KILL_POINTS 1

// 强化属性的"基础单价系数"（积分）。实际花费 = 基础系数 × 当前属性值。
// 为什么按当前值线性递增：需求要求"属性越高，强化所需积分越多"——属性越接近上限越珍贵，
//   单价随当前值水涨船高，能自然形成"前期易、后期贵"的成长曲线。
// 系数为 90：10→11 需 900，15→16 需 1350，19→20 需 1710 积分。
#define RPG_SYSTEM_STAT_COST_BASE 90
// 强化技能的"基础单价系数"（积分）。实际花费 = 基础系数 ×（目标等级）=（当前等级+1）。
// 为什么按目标等级递增：同理，技能越高升级越贵——越往传奇越珍贵。
// 系数为 540：0→1 需 540，2→3 需 1620，5→6 需 3240 积分。
#define RPG_SYSTEM_SKILL_COST_BASE 540

// 特性按普通、强力、超模三档定价；目录与结算共用这些价格。
#define RPG_SYSTEM_TRAIT_COST 2500
#define RPG_SYSTEM_TRAIT_STRONG_COST 10000
#define RPG_SYSTEM_TRAIT_OVERPOWERED_COST 99999
#define RPG_SYSTEM_SPELL_POINT_COST 3000
// 单次材料兑换上限，界面提示和服务端校验共用。
#define RPG_SYSTEM_MATERIAL_MAX_QUANTITY 50
// 通过本系统购买特性时使用的 ADD_TRAIT 来源标签：统一、可识别，便于将来需要时统一清理；
//   不复用 TRAIT_VIRTUE / TRAIT_GENERIC 等其它来源，避免与别处授予的同名特性互相干扰。
#define RPG_SYSTEM_TRAIT_SOURCE "rpg_system_purchase"


// ----------------------------------------------------------------------------
// 美德定义：RPG 系统
// 为什么归入 /datum/virtue/utility 分支：与 life_potential / genius 等"效用型"美德一致；
//   作为 /datum/virtue 子类型，会被 subtypesof() 自动收录进 GLOB.virtues
//   （见 code/__HELPERS/global_lists.dm），无需手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/utility/rpg_system
	// 菜单中显示的美德名。
	name = "RPG系统（-99）"
	// 角色内描述（in-character）：呼应"世界旅人 + 作弊外挂 + 此世即超真实 RPG"的设定。
	desc = "你是来自异界的旅人，持有只属于世界旅人的作弊外挂。对你而言，这个世界不过是一款无比真实的 RPG 游戏。"
	// custom_text 用机制语言把硬性规则讲清楚，避免玩家误解。
	// 为什么单列：desc 偏角色口吻，这里写明"系统面板、击杀得分、积分商店、强化技能 / 属性"。
	custom_text = "获得【RPG系统】特性：\n\
	你会获得一个独一无二的【系统面板】（在指令栏的 IC 分类下呼出「打开RPG系统」）。\n\
	击杀怪物可赚取【系统积分】，积分可在系统商店中兑换 武器 / 装备 / 消耗品 / 材料 / 魔法物品，\n\
	也可直接用于强化你的技能等级与六维属性。"
	// 消耗 99 点凯旋点数。基类 New() 会自动把"Costs 99 TRIUMPH"追加到 desc。
	// check_triumphs() 会在 apply_virtue 流程开头校验并扣除，点数不足则不授予。
	triumph_cost = RPG_SYSTEM_TRIUMPH_COST
	// 为什么"不"用 added_traits 授予 TRAIT_RPG_SYSTEM：
	//   apply_virtue 的调用顺序是 apply_to_human() 先于 handle_traits()。若走 added_traits，
	//   即便我们在 apply_to_human 里因"宿主无效"等原因想中止授予，紧随其后的 handle_traits()
	//   仍会把标签无条件加回，导致"有标签却没有挂上系统组件 / 动词"的不一致。
	//   因此改为在 apply_to_human 校验通过后，手动 ADD_TRAIT，使"标签 = 系统真正就绪"严格一致。

// apply_to_human：美德被赋予人物时调用。负责：校验宿主 → 授予特性 → 挂系统组件 → 授予呼出动词。
/datum/virtue/utility/rpg_system/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御性检查：没有有效人物（极端时序下可能为 null）就直接返回，避免空引用。
	//   本美德无种族 / 年龄 / 性别门槛，所以这里不退款（点数本就该为"获得系统"而花）；
	//   仅在"连个有效人类宿主都没有"的异常情况下安静中止。
	if(!istype(recipient))
		return

	// 通过校验：手动授予"身份标签"，来源标记 TRAIT_VIRTUE（与引擎美德特性约定一致，便于统一清理）。
	//   击杀监听组件正是靠 HAS_TRAIT(killer, TRAIT_RPG_SYSTEM) 来判断"这名凶手是否系统持有者"。
	ADD_TRAIT(recipient, TRAIT_RPG_SYSTEM, TRAIT_VIRTUE)

	// 挂载驱动组件：它承载这名玩家的积分、并周期性给附近怪物补挂"击杀监听"。
	//   组件 UNIQUE 去重，重复赋予不会叠加。AddComponent 返回实例，便于后续即时反馈。
	recipient.AddComponent(/datum/component/rpg_system)

	// 授予"呼出系统面板"的动词。为什么用 verbs +=：这是本项目授予主动能力的既定做法
	//   （参见 modular_azurepeak/virtues/combat.dm）。动词面向 /mob/living/carbon/human，
	//   只有持有者会拥有它；动词内部还会再次校验特性，双保险。
	recipient.verbs += /mob/living/carbon/human/proc/open_rpg_system

	// 给出醒目反馈，让玩家立刻知道"系统已绑定、如何呼出"，否则纯被动机制对玩家不直观。
	to_chat(recipient, span_nicegreen("【系统提示】绑定成功。欢迎来到这个世界，旅人。\
		击杀怪物可赚取系统积分；在指令栏 IC 分类下选择「打开RPG系统」即可呼出你的专属面板。"))


// ============================================================================
// 驱动组件：RPG 系统（挂在持有者身上）
// 为什么用组件：组件天然与宿主 mob 绑定，提供 Initialize / Destroy 生命周期钩子，能干净地
//   持有"这名玩家的积分"、启动 / 停止周期处理，并在宿主消失时自动清理，避免悬空状态。
// ============================================================================
/datum/component/rpg_system
	// 唯一组件：同一 mob 上只允许一个实例，重复 AddComponent 会被丢弃，杜绝重复扫描 / 双份积分。
	dupe_mode = COMPONENT_DUPE_UNIQUE
	// 这名玩家当前的系统积分。所有发放（击杀）与扣除（兑换）都读写此字段，是玩家独立的存档位。
	var/points = 0
	// 分类保存在组件中；购买只刷新数据，不重新打开窗口。
	var/current_tab = "weapon"
	// 防止物品初始化等可能让出执行权的过程重入扣费。
	var/purchase_busy = FALSE

// Initialize：组件创建时调用，负责类型校验与启动周期扫描。
/datum/component/rpg_system/Initialize()
	. = ..()
	// 系统面板与积分商店面向人类玩家；挂到非人类身上没有意义，返回 INCOMPATIBLE 让引擎丢弃。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	// 启动周期处理：之后每个处理周期都会调用 process()，由它扫描视野内怪物并补挂击杀监听。
	//   为什么用 SSprocessing：它是通用的低频处理子系统，适合这种"周期性轻量巡检"的需求。
	START_PROCESSING(SSprocessing, src)

// Destroy：组件被销毁（宿主死亡删除 / 被移除）时调用，停止周期处理，避免悬空回调。
//   特性标签来源是 TRAIT_VIRTUE，其生命周期由美德系统管理，这里不重复处理以免冲突。
/datum/component/rpg_system/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	SStgui.close_uis(src)
	return ..()

// process：每个处理周期执行一次，扫描宿主视野内"算作怪物"的目标，给它们补挂一次性击杀监听组件。
//   两类目标会被盯上：
//     1) 敌对 simple_animal（/mob/living/simple_animal/hostile）——本游戏的"怪物"主体，按生命值比例给分；
//     2) 固定积分名单里的"类人怪物"（NPC，属 /mob/living/carbon/human 子类型）——按固定积分给分。
//   普通牲畜 / 其他玩家不在两类之内，不会被挂监听、也就不会错误给分。
/datum/component/rpg_system/process(delta_time)
	// 防御：宿主异常（已删除 / 非人类）直接返回，等待 Destroy 收尾。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent
	// 死亡或离线的持有者不再巡检：尸体 / 空壳不会去打怪，省去无谓扫描。
	if(host.stat == DEAD || !host.client)
		return
	// 遍历以宿主为中心、RPG_SYSTEM_SCAN_RANGE 格内的所有活体。给"算作怪物"的目标补挂监听
	//   （UNIQUE 去重：已挂过的会被自动丢弃，不会叠加 / 重复给分）。
	for(var/mob/living/target in range(RPG_SYSTEM_SCAN_RANGE, host))
		// 跳过自己与已死目标：自己不该被监听；尸体没有"击杀"价值。
		if(target == host || target.stat == DEAD)
			continue
		// 判定是否"算作怪物"：① 可给分的 simple_animal（非友善生物）；或 ② 固定积分名单上的类人怪物。
		//   为什么 ② 先用 ishuman 短路再查固定名单：固定名单里全是 /mob/living/carbon/human 子类型，
		//   非人类目标不可能命中，先 ishuman 过滤可省去对一大堆生物逐一跑名单匹配的开销。
		var/is_monster = is_rewardable_beast(target)
		if(!is_monster && ishuman(target) && get_fixed_reward(target) > 0)
			is_monster = TRUE
		if(is_monster)
			target.AddComponent(/datum/component/rpg_kill_watcher)

// ----------------------------------------------------------------------------
// 固定积分名单：特定"类人怪物"（NPC）按这里登记的固定分值给分，不走 maxHealth 比例。
// 为什么要单列：这些 NPC 都是 /mob/living/carbon/human 子类型，没有 simple_animal 的 maxHealth
//   强度语义，且设计上希望按"怪物种类"给固定奖励（例如疯骑士固定 200、流浪汉固定 30），
//   故用一张"类型路径 => 固定积分"的表来配置。
// 安全性：表里登记的都是 npc 目录下的 NPC 专用 mob 子类型，玩家角色是基类 /mob/living/carbon/human
//   （种族经 DNA 设定，并非这些子类型实例），因此 istype 匹配绝不会命中真实玩家，杜绝"杀玩家给分"。
// ----------------------------------------------------------------------------
/datum/component/rpg_system/proc/get_fixed_kill_rewards()
	// 静态缓存：表内容恒定，首次构建后复用，避免每次调用都重建列表。
	var/static/list/rewards
	if(!rewards)
		rewards = list(
			/mob/living/carbon/human/species/human/northern/highwayman = 80,                 // 拦路强盗
			/mob/living/carbon/human/species/human/northern/militia = 50,                     // 民兵
			/mob/living/carbon/human/species/human/northern/bog_deserters = 40,               // 沼泽逃兵
			/mob/living/carbon/human/species/human/northern/bum = 30,                         // 流浪汉
			/mob/living/carbon/human/species/human/northern/searaider = 80,                   // 海上劫掠者
			/mob/living/carbon/human/species/human/northern/thief = 60,                       // 窃贼
			/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter = 200, // 疯魔寻宝者
			/mob/living/carbon/human/species/human/northern/deranged_knight = 200,            // 癫狂骑士
			/mob/living/carbon/human/species/skeleton = 30,                                   // 骷髅（基础）
			/mob/living/carbon/human/species/skeleton/npc/bogguard = 40,                      // 沼泽骷髅卫
			/mob/living/carbon/human/species/skeleton/npc/summoned = 30,                      // 召唤骷髅
			/mob/living/carbon/human/species/dwarfskeleton = 30,                              // 矮人骷髅
			/mob/living/carbon/human/species/npc/deadite = 50,                                // 亡者
			/mob/living/carbon/human/species/elf/dark/drowraider = 120,                       // 卓尔劫掠者
			/mob/living/carbon/human/species/orc = 120,                                       // 兽人
			/mob/living/carbon/human/species/goblin = 40,                                     // 哥布林
			/mob/living/carbon/human/species/lizardfolk/psy_vault_guard = 200,                // 蜥蜴人秘库守卫
			/mob/living/carbon/human/species/construct/metal/zizoconstruct = 100,             // 兹佐金属构装体
		)
	return rewards

// get_fixed_reward：取某个目标的"固定积分"。命中名单返回其分值，否则返回 0。
//   匹配规则：取名单中"目标 istype 命中、且最具体（最深子类型）"的那条。
//   为什么取最具体：例如骷髅基类登记 30、其子类型 bogguard 登记 40——一只 bogguard 同时
//   istype 命中两条，应按更具体的 bogguard（40）给分；而未单独登记的其它骷髅子类型则回落到基类 30。
/datum/component/rpg_system/proc/get_fixed_reward(mob/living/victim)
	if(!isliving(victim))
		return 0
	var/list/rewards = get_fixed_kill_rewards()
	var/best_type    // 已找到的最具体匹配类型
	for(var/mob_type in rewards)
		if(!istype(victim, mob_type))
			continue
		// 同一目标的所有命中项都在其类型继承链上、彼此为父子关系：若新命中项是当前最优项的
		//   子类型（ispath(新, 旧) 为真），说明它更具体，取而代之。
		if(!best_type || ispath(mob_type, best_type))
			best_type = mob_type
	return best_type ? rewards[best_type] : 0

// ----------------------------------------------------------------------------
// 友善生物名单：simple_animal 目录里"友善 / 不该给分"的生物类型族。
// 需求："击杀 simple_animal 目录下的生物给分，但友善生物除外。"
//   引擎把友善生物集中放在 simple_animal/friendly/ 目录，但它们的类型路径各不相同（宠物在
//   /pet 下、家畜雏类 / 虫豸直接挂在 simple_animal 下），故这里按"类型族"逐一登记。
//   注意：friendly/ 目录里少数其实是 /hostile 子类型（山羊 / 毒蛇 / 蜥蜴等），它们是会反击的
//   野生 / 牲畜，按"战斗 / 可猎杀生物"对待——不在本友善名单内，照常给分。
//   另：roguetown 实际使用的农场牲畜是 rogue/farm 下的 /hostile/retaliate/rogue/* 类型（与此处
//   的原版 /cow、/chicken 路径不同），它们不属"友善"目录、会反击，故也照常给分（可猎杀取肉）。
/datum/component/rpg_system/proc/get_friendly_beast_types()
	// 静态缓存：名单恒定，首次构建后复用。
	var/static/list/friendlies
	if(!friendlies)
		friendlies = list(
			/mob/living/simple_animal/pet,            // 宠物总族：猫 / 狗 / 狐 / 魔宠 等
			/mob/living/simple_animal/butterfly,      // 蝴蝶
			/mob/living/simple_animal/cockroach,      // 蟑螂
			/mob/living/simple_animal/mouse,          // 老鼠
			/mob/living/simple_animal/cow,            // 原版奶牛（友善）
			/mob/living/simple_animal/chick,          // 雏鸡
			/mob/living/simple_animal/chicken,        // 原版母鸡（友善）
			/mob/living/simple_animal/grenchensnacker,// 格兰琴零嘴兽（友善）
		)
	return friendlies

// is_rewardable_beast：判断某生物是否"可给分的 simple_animal 怪物"。
//   规则：是 /mob/living/simple_animal 子类型，且不属于任何"友善生物"类型族。
//   渲染挂载（process）与死亡结算（on_monster_death）共用本判定，保证两处口径一致。
/datum/component/rpg_system/proc/is_rewardable_beast(mob/living/target)
	// 必须是 simple_animal（本需求只针对该目录下的生物）。
	if(!istype(target, /mob/living/simple_animal))
		return FALSE
	// 命中任一友善类型族即排除（友善生物不给分）。
	for(var/friendly_type in get_friendly_beast_types())
		if(istype(target, friendly_type))
			return FALSE
	return TRUE

// award_points：给这名玩家发放击杀积分（由击杀监听组件在确认归属后调用）。
//   单独成 proc 而非外部直接改字段：集中处理"累加 + 反馈"，将来要做积分上限 / 音效也只改这里。
/datum/component/rpg_system/proc/award_points(amount, mob/living/victim)
	// 防御：非正数发放无意义，直接忽略，避免出现"杀怪倒扣分"之类的异常。
	if(amount <= 0)
		return
	// 防御：宿主必须仍是有效人类才发放与播报（极端时序下可能正在被删除）。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent
	// 累加积分。这是玩家的核心成长资源，兑换时再从这里扣除。
	points += amount
	// 即时反馈：用"系统提示"的口吻播报本次收益与当前总积分，强化 RPG 升级打怪的爽感。
	//   victim?.name 做空安全：即使受害者已被 gib / 清理，也不会空引用。
	to_chat(host, span_green("【系统提示】击败了 [victim ? victim.name : "一只怪物"]，获得 [amount] 系统积分。（当前积分：[points]）"))


// ============================================================================
// 击杀监听组件：挂在"系统持有者附近的怪物"身上，一次性旁听其死亡并结算归属
// 为什么独立成组件：它要绑定到"怪物"而非玩家，监听怪物自己的 COMSIG_LIVING_DEATH。
//   组件能在怪物删除时自动清理信号，且 UNIQUE 保证同一只怪只挂一份监听（多名系统玩家围殴
//   同一只怪也只需一份监听，最终按 lastattacker 把分发给真正的最后一击者）。
// ============================================================================
/datum/component/rpg_kill_watcher
	// 唯一组件：同一只怪只允许一个监听实例，重复 AddComponent 会被丢弃。
	dupe_mode = COMPONENT_DUPE_UNIQUE
	// 是否已结算过本次击杀。为什么需要：death() 理论上可能在异常路径被多次触发，
	//   用这个一次性闸门确保"一只怪最多只给一次分"，杜绝刷分。
	var/rewarded = FALSE

// Initialize：监听组件创建时调用，校验宿主为活体并注册死亡信号。
/datum/component/rpg_kill_watcher/Initialize()
	. = ..()
	// 挂到任意活体上即可（敌对 simple_animal 或固定积分名单上的类人 NPC）；非活体无死亡可言，丢弃之。
	//   具体"算不算给分目标"在 process() 挂载时已筛过，这里只需保证宿主是 /mob/living 能发出死亡信号。
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	// 监听宿主（怪物）的死亡信号。引擎在 /mob/living/death() 末尾发出 COMSIG_LIVING_DEATH
	//   （death.dm:128），无论该怪是哪种子类型、其 death() 是否被重写，最终都会 ..() 到这里，
	//   因此监听它能可靠捕获"任何方式造成的死亡"。
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_monster_death))

// on_monster_death：怪物死亡信号回调，负责"解析最后攻击者 → 校验系统持有者 → 发放积分"。
// 为什么标 SIGNAL_HANDLER：信号回调是同步调用，绝不能 sleep。本过程只做弱引用解析、特性
//   判断、积分发放与一次 to_chat，全程不阻塞，符合 SIGNAL_HANDLER 约束。
/datum/component/rpg_kill_watcher/proc/on_monster_death(datum/source, gibbed)
	SIGNAL_HANDLER
	// 一次性闸门：已结算过就直接返回，确保一只怪只给一次分。
	if(rewarded)
		return
	// 防御：宿主必须仍是有效怪物，否则无法读取它的 lastattacker。
	if(!isliving(parent))
		return
	var/mob/living/victim = parent
	// 解析"最后攻击者"。lastattacker_weakref 是弱引用：凶手若已登出 / 被删除，resolve() 返回 null。
	//   为什么用弱引用而非直接存指针：避免怪物因持有凶手强引用而妨碍其被垃圾回收（引擎设计如此）。
	var/mob/living/carbon/human/killer = victim.lastattacker_weakref?.resolve()
	// 必须是"持有 RPG 系统特性的人类"才结算：排除被环境 / 其它怪 / 非系统玩家打死的情况。
	if(!ishuman(killer) || !HAS_TRAIT(killer, TRAIT_RPG_SYSTEM))
		return
	// 取出凶手身上的系统驱动组件（积分存放处）。理论上系统持有者必然挂有该组件；
	//   做空安全判断，万一缺失则安静放弃，绝不空引用。
	var/datum/component/rpg_system/system = killer.GetComponent(/datum/component/rpg_system)
	if(!system)
		return
	// 置一次性闸门：先标记已结算，再发放，避免极端重入下的重复给分。
	rewarded = TRUE
	// 计算本次积分：优先查"固定积分名单"（特定类人怪物给固定分）；否则按 simple_animal 的
	//   最大生命值比例发放。两者都不命中（例如普通玩家 / 牲畜被打死）则不发分。
	var/gain = 0
	// ① 固定积分名单（类人 NPC 怪物）。
	var/fixed = system.get_fixed_reward(victim)
	if(fixed > 0)
		gain = fixed
	// ② 可给分的 simple_animal（非友善生物）：按最大生命值比例给分，并设保底，使强怪多给、弱怪也不至于没收益。
	//   用 system.is_rewardable_beast 复核（该 proc 定义在驱动组件上），确保即便友善生物意外被挂上监听
	//   也不会给分（口径与 process 一致）。
	else if(system.is_rewardable_beast(victim))
		var/mob/living/simple_animal/beast = victim
		gain = max(RPG_SYSTEM_MIN_KILL_POINTS, round(beast.maxHealth * RPG_SYSTEM_POINTS_PER_MAXHP))
	// 两类都不是 → 不在给分范围（杜绝"杀玩家 / 杀牲畜也给分"），安静返回。
	if(gain <= 0)
		return
	// 委托驱动组件统一发放积分并播报反馈。
	system.award_points(gain, victim)




// 系统入口保持不变，后续交互由同一个 TGUI 窗口处理。
/mob/living/carbon/human/proc/open_rpg_system()
	set name = "打开RPG系统"
	set category = "IC"
	if(!HAS_TRAIT(src, TRAIT_RPG_SYSTEM))
		to_chat(src, span_warning("【系统提示】你并未绑定任何系统。"))
		return
	var/datum/component/rpg_system/system = GetComponent(/datum/component/rpg_system)
	if(!system)
		to_chat(src, span_warning("【系统提示】系统尚未就绪，请稍后再试。"))
		return
	system.open_interface(src)

/datum/component/rpg_system/proc/can_use_system(mob/user)
	return user && ishuman(parent) && user == parent && user.client && user.stat != DEAD && HAS_TRAIT(user, TRAIT_RPG_SYSTEM)

/datum/component/rpg_system/proc/open_interface(mob/living/carbon/human/user)
	if(can_use_system(user))
		ui_interact(user)

/datum/component/rpg_system/ui_state(mob/user)
	return GLOB.self_state

/datum/component/rpg_system/ui_status(mob/user, datum/ui_state/state)
	if(!can_use_system(user))
		return UI_CLOSE
	return ..()

/datum/component/rpg_system/ui_interact(mob/user, datum/tgui/ui)
	if(!can_use_system(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RpgSystem", "RPG 系统")
		ui.open()

/datum/component/rpg_system/proc/get_tabs()
	return list(
		"weapon" = "武器",
		"equipment" = "装备",
		"consumable" = "消耗品",
		"material" = "材料",
		"magic" = "魔法物品",
		"delicacy" = "美食",
		"artifact" = "神器",
		"trait" = "特性",
		"stat" = "强化属性",
		"skill" = "强化技能",
		"quests" = "冒险任务",
	)

// 价格、奖励和禁用原因均由服务端给出；编号始终对应未筛选的目录。
/datum/component/rpg_system/ui_data(mob/user)
	var/list/data = list()
	if(!can_use_system(user))
		return data
	var/mob/living/carbon/human/host = user
	data["points"] = points
	data["spell_points"] = host.mind ? max(0, host.mind.spell_points - host.mind.used_spell_points) : 0
	data["current_tab"] = current_tab
	data["busy"] = purchase_busy
	var/datum/component/rpg_journal/journal = get_journal()
	journal.refresh_day()
	data["daily"] = journal.get_ui_data(host)
	data["busy"] = purchase_busy || journal.busy
	var/list/tabs = list()
	var/list/tab_names = get_tabs()
	for(var/tab_id in tab_names)
		tabs += list(list("id" = tab_id, "name" = tab_names[tab_id]))
	data["tabs"] = tabs
	var/list/rows = list()
	var/index = 0
	switch(current_tab)
		if("trait")
			for(var/list/entry in get_trait_catalog())
				index++
				var/list/row = entry.Copy()
				row["id"] = index
				row["action"] = "buy_trait"
				row["blocked_reason"] = HAS_TRAIT(host, entry["trait"]) ? "已拥有" : null
				row -= "trait"
				rows += list(row)
		if("stat", "skill")
			var/is_skill = current_tab == "skill"
			var/list/defs = is_skill ? get_skill_defs() : get_attribute_defs()
			for(var/display in defs)
				index++
				var/current_value = is_skill ? host.get_skill_level(defs[display]) : host.get_stat(defs[display])
				var/at_limit = current_value >= (is_skill ? SKILL_LEVEL_LEGENDARY : 20)
				rows += list(list(
					"id" = index,
					"name" = display,
					"description" = is_skill ? "技能越高，强化所需积分越多；最高为传奇（6级）。" : "属性越高，强化所需积分越多；最高为20。",
					"current" = current_value,
					"cost" = at_limit ? 0 : (is_skill ? skill_upgrade_cost(current_value) : stat_upgrade_cost(current_value)),
					"action" = is_skill ? "enhance_skill" : "enhance_stat",
					"blocked_reason" = (is_skill && !host.mind) ? "意识尚不稳定" : (at_limit ? "已满级" : null),
				))
		else
			var/list/catalog = get_catalog_for_tab(current_tab)
			for(var/display in catalog)
				index++
				var/list/entry = catalog[display]
				var/obj/item/item_type = entry[2]
				rows += list(list(
					"id" = index,
					"name" = display,
					"description" = html_decode(GLOB.html_tags.Replace(initial(item_type.desc), "")),
					"cost" = entry[1],
					"action" = "buy_item",
					"max_quantity" = current_tab == "material" ? RPG_SYSTEM_MATERIAL_MAX_QUANTITY : 1,
				))
			if(current_tab == "magic")
				rows.Insert(1, list(list(
					"id" = 0,
					"name" = "法术点 +1",
					"description" = "直接获得1法术点，无奥术技能门槛。首次获得时同步开放学习法术，并授予尚未掌握的戏法术。",
					"cost" = RPG_SYSTEM_SPELL_POINT_COST,
					"action" = "buy_spell_point",
					"blocked_reason" = host.mind ? null : "意识尚不稳定",
				)))
	for(var/list/row in rows)
		if(!row["blocked_reason"] && points < row["cost"])
			row["blocked_reason"] = "积分不足"
	data["rows"] = rows
	return data

// 所有购买操作共用身份检查与重入保护；不接受客户端传入的价格或物品路径。
/datum/component/rpg_system/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ui || ui.user != usr || !can_use_system(usr) || purchase_busy)
		return
	var/datum/component/rpg_journal/journal = get_journal()
	if(journal.busy)
		return
	if(action in list("check_in", "quest_accept", "quest_submit", "quest_abandon", "quest_track", "quest_untrack"))
		return journal.handle_action(src, usr, action, params)
	if(action == "tab")
		var/list/tabs = get_tabs()
		if(params["tab"] in tabs)
			current_tab = params["tab"]
			return TRUE
		return
	if(params["tab"] != current_tab)
		return
	var/index = params["id"]
	if(action != "buy_spell_point" && (!isnum(index) || index != round(index) || index < 1))
		return
	purchase_busy = TRUE
	switch(action)
		if("buy_item")
			do_buy_item(usr, current_tab, index, ("quantity" in params) ? params["quantity"] : 1)
		if("buy_trait")
			if(current_tab == "trait")
				do_buy_trait(usr, index)
		if("enhance_stat")
			if(current_tab == "stat")
				do_enhance_attribute(usr, index)
		if("enhance_skill")
			if(current_tab == "skill")
				do_enhance_skill(usr, index)
		if("buy_spell_point")
			if(current_tab == "magic")
				do_buy_spell_point(usr)
	purchase_busy = FALSE
	return TRUE

/datum/component/rpg_system/proc/do_buy_spell_point(mob/living/carbon/human/user)
	if(!can_use_system(user) || !user.mind)
		return
	if(points < RPG_SYSTEM_SPELL_POINT_COST)
		to_chat(user, span_warning("【系统提示】积分不足，需要 [RPG_SYSTEM_SPELL_POINT_COST] 积分。"))
		return
	points -= RPG_SYSTEM_SPELL_POINT_COST
	user.mind.adjust_spellpoints(1)
	playsound(user, 'sound/misc/click.ogg', 50, FALSE)


// 输入目录始终保留基准单价；每次生成新目录，避免刷新界面时重复涨价。
/proc/z121_rpg_price_catalog(list/base_catalog, multiplier, list/fixed_types)
	var/list/catalog = list()
	for(var/display in base_catalog)
		var/list/entry = base_catalog[display]
		var/cost = (entry[2] in fixed_types) ? entry[1] : CEILING(entry[1] * multiplier, 1)
		catalog["[display]（[cost]积分）"] = list(cost, entry[2])
	return catalog

// 按保证产量分摊最终原料成本，再加两成加工费；不折算概率副产物。
/proc/z121_rpg_processed_material_cost(ingredient_cost, output_count = 1)
	return CEILING(ingredient_cost * 6 / (output_count * 5), 1)

/datum/component/rpg_system/proc/get_weapon_catalog()
	return z121_rpg_weapon_catalog()

// 纯商品目录供管理员面板复用，不创建积分组件或任务监听。
/proc/z121_rpg_weapon_catalog()
	return z121_rpg_price_catalog(list(
		"狩猎刀" = list(40, /obj/item/rogueweapon/huntingknife),                    // 轻便短刀，便宜的入门武器
		"铁剑"   = list(80, /obj/item/rogueweapon/sword/iron),                      // 入门级单手剑
		"长矛"  = list(110, /obj/item/rogueweapon/spear),                          // 长柄武器，攻击距离更远
		"长剑"  = list(140, /obj/item/rogueweapon/sword/long),                     // 更长、伤害更高的剑
		"钢锤"  = list(160, /obj/item/rogueweapon/mace/steel),                     // 钝击武器，破甲见长
		"战斧"  = list(180, /obj/item/rogueweapon/stoneaxe/battle),                // 重型斧，高伤害
		"三叉戟"= list(210, /obj/item/rogueweapon/spear/trident),                  // 高级长柄武器
		"弩"    = list(240, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow), // 远程武器（需自备弩矢）
		"投石索"= list(90, /obj/item/gun/ballistic/revolver/grenadelauncher/sling),      // 廉价远程武器（需自备弹丸）
		"弓"   = list(200, /obj/item/gun/ballistic/revolver/grenadelauncher/bow),        // 远程武器（需自备箭矢）
		"弯刀"  = list(150, /obj/item/rogueweapon/sword/falx),                     // 法尔克斯弯刀，劈砍见长
		"短棍"   = list(50, /obj/item/rogueweapon/mace/cudgel),                     // 廉价钝器，入门近战
		"重锤"  = list(260, /obj/item/rogueweapon/mace/goden),                     // 戈登大棒，重型钝击
		"戟"    = list(280, /obj/item/rogueweapon/halberd),                        // 长柄重武器，攻防兼备
		"连枷"  = list(170, /obj/item/rogueweapon/flail),                          // 链锤，无视格挡角度
		"刺剑"  = list(220, /obj/item/rogueweapon/estoc),                          // 重型刺剑，破甲穿刺
		"木棍"   = list(25, /obj/item/rogueweapon/mace/woodclub),                   // 最廉价的钝器
		"短剑"   = list(70, /obj/item/rogueweapon/sword/short),                     // 轻便单手短剑
		"草叉"   = list(70, /obj/item/rogueweapon/pitchfork),                       // 长柄农具，可作刺击武器
		"鞭子"   = list(90, /obj/item/rogueweapon/whip),                            // 长鞭，远距离软兵
		"镐"     = list(60, /obj/item/rogueweapon/pick),                            // 矿镐，亦可作刺击武器
		"铁锤"   = list(90, /obj/item/rogueweapon/hammer/iron),                     // 铁锻锤，钝击 / 打铁两用
		"巨剑"  = list(300, /obj/item/rogueweapon/greatsword),                     // 双手巨剑，高伤害重武器
	), 2)


/datum/component/rpg_system/proc/get_equipment_catalog()
	return z121_rpg_equipment_catalog()

/proc/z121_rpg_equipment_catalog()
	return z121_rpg_price_catalog(list(
		"兜帽"     = list(30, /obj/item/clothing/head/roguetown/roguehood),        // 兜帽，遮风蔽脸
		"长靴"     = list(40, /obj/item/clothing/shoes/roguetown/boots),           // 基础脚部护具
		"腰包"     = list(40, /obj/item/storage/belt/rogue/pouch),                 // 腰间小袋，扩充携带空间
		"皮护腕"   = list(50, /obj/item/clothing/wrists/roguetown/bracers/leather), // 轻型皮护腕
		"火把"     = list(50, /obj/item/flashlight/flare/torch),                   // 照明工具（黑暗中作战必备）
		"锁链手套" = list(60, /obj/item/clothing/gloves/roguetown/chain),          // 手部护具
		"护腕"     = list(70, /obj/item/clothing/wrists/roguetown/bracers),        // 金属护腕，护住前臂
		"木盾"     = list(70, /obj/item/rogueweapon/shield/wood),                  // 入门盾牌，格挡攻击
		"锁甲头巾" = list(80, /obj/item/clothing/neck/roguetown/coif),             // 锁甲头巾，护住头颈
		"皮盔"     = list(55, /obj/item/clothing/head/roguetown/helmet/leather),    // 轻型皮制头盔
		"头盔"     = list(90, /obj/item/clothing/head/roguetown/helmet),           // 头部护具
		"皮背心"   = list(70, /obj/item/clothing/suit/roguetown/armor/leather/vest), // 轻型皮背心
		"皮甲"    = list(100, /obj/item/clothing/suit/roguetown/armor/leather),   // 基础躯干护甲
		"水壶盔"  = list(110, /obj/item/clothing/head/roguetown/helmet/kettle),   // 宽檐铁盔，遮挡上方
		"铁盾"    = list(150, /obj/item/rogueweapon/shield/iron),                 // 中级盾牌，格挡更强
		"轻型半盔"= list(150, /obj/item/clothing/head/roguetown/helmet/sallet),   // 半罩式骑士盔
		"厚棉甲"  = list(130, /obj/item/clothing/suit/roguetown/armor/gambeson),  // 软质护甲，缓冲钝击
		"板甲手套"= list(140, /obj/item/clothing/gloves/roguetown/plate),         // 重型手部护具
		"重型头盔"= list(170, /obj/item/clothing/head/roguetown/helmet/heavy),    // 重型头部护具
		"面甲盔"  = list(185, /obj/item/clothing/head/roguetown/helmet/bascinet), // 带面甲的骑士盔
		"镶嵌甲"  = list(240, /obj/item/clothing/suit/roguetown/armor/brigandine), // 镶钉皮甲，防护与灵活兼顾
		"背包"     = list(50, /obj/item/storage/backpack/rogue/backpack),          // 背负容器，扩充携带空间
		"提灯"     = list(60, /obj/item/flashlight/flare/torch/lantern),           // 可持续照明的提灯
		"塔盾"    = list(220, /obj/item/rogueweapon/shield/tower),                // 大型塔盾，防护面积最大
		"锁子甲"  = list(200, /obj/item/clothing/suit/roguetown/armor/chainmail), // 中级躯干护甲
		"板甲"    = list(320, /obj/item/clothing/suit/roguetown/armor/plate),     // 高级躯干护甲，防护最强
	), 2)


/datum/component/rpg_system/proc/get_consumable_catalog()
	return z121_rpg_consumable_catalog()

/proc/z121_rpg_consumable_catalog()
	return z121_rpg_price_catalog(list(
		"清水"     = list(10, /obj/item/reagent_containers/glass/bottle/rogue/water),      // 解渴的廉价补给
		"箭矢"      = list(6, /obj/item/ammo_casing/caseless/rogue/arrow),                  // 弓用弹药
		"石箭"      = list(7, /obj/item/ammo_casing/caseless/rogue/arrow/stone),            // 石制弓用弹药
		"弩矢"      = list(8, /obj/item/ammo_casing/caseless/rogue/bolt),                   // 弩用弹药
		"铁箭"     = list(12, /obj/item/ammo_casing/caseless/rogue/arrow/iron),            // 更锋利的弓用弹药
		"钢箭"     = list(20, /obj/item/ammo_casing/caseless/rogue/arrow/steel),           // 钢制弓用弹药，穿透更强
		"啤酒"     = list(15, /obj/item/reagent_containers/glass/bottle/rogue/beer),         // 廉价酒水
		"绷带"     = list(25, /obj/item/natural/cloth/bandage),                            // 包扎止血
		"面包"     = list(30, /obj/item/reagent_containers/food/snacks/rogue/bread),       // 充饥的食物
		"葡萄酒"   = list(25, /obj/item/reagent_containers/glass/bottle/rogue/wine),          // 提神的酒水
		"体力药水" = list(50, /obj/item/reagent_containers/glass/bottle/rogue/stampot),       // 恢复体力
		"治疗药水" = list(60, /obj/item/reagent_containers/glass/bottle/rogue/healthpot),     // 回血
		"魔力药水" = list(60, /obj/item/reagent_containers/glass/bottle/rogue/manapot),       // 回蓝
		"解毒剂"   = list(70, /obj/item/reagent_containers/glass/bottle/rogue/antidote),      // 解除中毒
		"强效体力药水" = list(100, /obj/item/reagent_containers/glass/bottle/rogue/strongstampot),  // 大量恢复体力
		"强效治疗药水" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/healthpotnew), // 强力回血
		"强效魔力药水" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/strongmanapot),  // 大量回蓝
		"强效解毒剂"   = list(140, /obj/item/reagent_containers/glass/bottle/rogue/strong_antidote), // 强力解毒
		// —— 本模块自定义炼金药水（成品瓶，即用型）——
		"温酒"       = list(40, /obj/item/reagent_containers/glass/bottle/rogue/warm_wine),           // 驱寒温酒
		"催乳剂"     = list(50, /obj/item/reagent_containers/glass/bottle/rogue/lactation_enhancer),  // 加速泌乳恢复
		"克林卡特"   = list(60, /obj/item/reagent_containers/glass/bottle/rogue/klinkat),             // 精炼酒基药剂
		"血之补剂"   = list(70, /obj/item/reagent_containers/glass/bottle/rogue/blood_tonic),         // 补血
		"暖心酒剂"   = list(80, /obj/item/reagent_containers/glass/bottle/rogue/heart_tonic),         // 暖身暖心
		"媚药"       = list(80, /obj/item/reagent_containers/glass/bottle/rogue/aphrodisiac),         // 强效催情
		"精力药剂"   = list(90, /obj/item/reagent_containers/glass/bottle/rogue/vigor_potion),        // 短时振奋精力
		"驱兽药水"  = list(100, /obj/item/reagent_containers/glass/bottle/rogue/monster_repel),      // 令野兽退避
		"万能修复溶剂" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/universal_repair), // 修复物品损耗
		"变性药水"  = list(120, /obj/item/reagent_containers/glass/bottle/rogue/gender_swap),        // 改变生理性别
		"隐身药水"  = list(150, /obj/item/reagent_containers/glass/bottle/rogue/invisibility),       // 短时隐形
		"飞行药水"  = list(180, /obj/item/reagent_containers/glass/bottle/rogue/flying),             // 短时飞行
		// 补齐模组药水成品；原瓶装量和药效保持不变。
		"荧光药水" = list(80, /obj/item/reagent_containers/glass/bottle/rogue/luminescent_potion),
		"防蚂蟥药水" = list(80, /obj/item/reagent_containers/glass/bottle/rogue/anti_leech),
		"愚人药水" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/idiot_potion),
		"虚弱药水" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/weakness_potion),
		"怠惰药水" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/sloth_potion),
		"禁欲药水" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/forced_chastity),
		"丰盈药水" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/enlargement),
		"硬化药剂" = list(150, /obj/item/reagent_containers/glass/bottle/rogue/hardened_potion),
		"防腐皂" = list(150, /obj/item/anticorruption_soap),
		"麻痹毒药" = list(200, /obj/item/reagent_containers/glass/bottle/rogue/paralytic_poison),
		"复原药剂" = list(200, /obj/item/reagent_containers/glass/bottle/rogue/restorative_potion),
		"回忆药剂" = list(300, /obj/item/reagent_containers/glass/bottle/rogue/memory_potion),
		"身体再生药剂" = list(500, /obj/item/reagent_containers/glass/bottle/rogue/bodily_regeneration),
		"停滞药水" = list(1000, /obj/item/reagent_containers/glass/bottle/rogue/stasis_potion),
		// 灵辉炼金配方的四十八单位复活灵药，用于复活椅。
		"复活灵药（48u）" = list(2000, /obj/item/reagent_containers/glass/bottle/frankenbrew),
	), 1.5, list(/obj/item/reagent_containers/glass/bottle/frankenbrew, /obj/item/reagent_containers/glass/bottle/rogue/stasis_potion))


/datum/component/rpg_system/proc/get_material_catalog()
	return z121_rpg_material_catalog()

/proc/z121_rpg_material_catalog()
	// 基础材料先按普通材料倍率定价，加工品引用这些最终单价。
	var/stone_cost = CEILING(5 * 1.5, 1)
	var/tin_cost = CEILING(18 * 1.5, 1)
	var/copper_cost = CEILING(22 * 1.5, 1)
	var/iron_cost = CEILING(28 * 1.5, 1)
	var/silver_cost = CEILING(55 * 1.5, 1)
	var/gold_cost = CEILING(70 * 1.5, 1)
	var/coal_cost = 15
	var/bone_cost = 15
	var/sinew_cost = 20
	var/manabloom_cost = 40
	var/infernal_ash_cost = 60
	var/fae_dust_cost = 60
	var/elemental_mote_cost = 60
	// 大熔炉：三铜一锡出四青铜；三铁一煤出四钢；三钢一银出两黑钢。
	var/bronze_cost = z121_rpg_processed_material_cost(copper_cost * 3 + tin_cost, 4)
	var/steel_cost = z121_rpg_processed_material_cost(iron_cost * 3 + coal_cost, 4)
	var/blacksteel_cost = z121_rpg_processed_material_cost(steel_cost * 3 + silver_cost, 2)
	// 魔力结晶消耗四十五单位药剂；从消耗品目录获取五十单位成品瓶的最终售价。
	var/manapot_cost
	var/list/consumables = z121_rpg_consumable_catalog()
	for(var/display in consumables)
		var/list/entry = consumables[display]
		if(entry[2] == /obj/item/reagent_containers/glass/bottle/rogue/manapot)
			manapot_cost = entry[1]
			break
	// 以下全部是最终单价，统一生成带价格的名称，不再叠加分类倍率。
	return z121_rpg_price_catalog(list(
		"灰烬" = list(CEILING(4 * 1.5, 1), /obj/item/ash),
		"石块" = list(stone_cost, /obj/item/natural/stone),
		"木材" = list(CEILING(8 * 1.5, 1), /obj/item/grown/log/tree/small),
		"布料" = list(CEILING(10 * 1.5, 1), /obj/item/natural/cloth),
		"玻璃" = list(CEILING(12 * 1.5, 1), /obj/item/natural/glass),
		"鞣制皮革" = list(CEILING(16 * 1.5, 1), /obj/item/natural/hide/cured),
		"锡锭" = list(tin_cost, /obj/item/ingot/tin),
		"铜锭" = list(copper_cost, /obj/item/ingot/copper),
		"铁锭" = list(iron_cost, /obj/item/ingot/iron),
		"青铜锭" = list(bronze_cost, /obj/item/ingot/bronze),
		"绿宝石" = list(CEILING(40 * 1.5, 1), /obj/item/roguegem/green),
		"黄宝石" = list(CEILING(45 * 1.5, 1), /obj/item/roguegem/yellow),
		"钢锭" = list(steel_cost, /obj/item/ingot/steel),
		"银锭" = list(silver_cost, /obj/item/ingot/silver),
		"蓝宝石" = list(CEILING(60 * 1.5, 1), /obj/item/roguegem/blue),
		"金锭" = list(gold_cost, /obj/item/ingot/gold),
		"紫宝石" = list(CEILING(70 * 1.5, 1), /obj/item/roguegem/violet),
		"黑钢锭" = list(blacksteel_cost, /obj/item/ingot/blacksteel),
		"红宝石" = list(CEILING(100 * 1.5, 1), /obj/item/roguegem/ruby),
		"钻石" = list(CEILING(150 * 1.5, 1), /obj/item/roguegem/diamond),
		"煤炭" = list(coal_cost, /obj/item/rogueore/coal),
		"天然骨头" = list(bone_cost, /obj/item/natural/bone),
		"肌腱" = list(sinew_cost, /obj/item/alch/sinew),
		"内脏" = list(z121_rpg_processed_material_cost(sinew_cost), /obj/item/alch/viscera),
		"石粉" = list(z121_rpg_processed_material_cost(stone_cost), /obj/item/alch/stonedust),
		"煤尘" = list(z121_rpg_processed_material_cost(coal_cost), /obj/item/alch/coaldust),
		"骨粉" = list(z121_rpg_processed_material_cost(bone_cost), /obj/item/alch/bonemeal),
		"铁粉" = list(z121_rpg_processed_material_cost(iron_cost), /obj/item/alch/irondust),
		"银粉" = list(z121_rpg_processed_material_cost(silver_cost), /obj/item/alch/silverdust),
		"金粉" = list(z121_rpg_processed_material_cost(gold_cost), /obj/item/alch/golddust),
		"魔力花粉" = list(z121_rpg_processed_material_cost(manabloom_cost), /obj/item/alch/manabloompowder),
		"颠茄" = list(25, /obj/item/alch/atropa),
		"洋甘菊" = list(25, /obj/item/alch/matricaria),
		"聚合草" = list(25, /obj/item/alch/symphitum),
		"蒲公英" = list(25, /obj/item/alch/taraxacum),
		"小米草" = list(25, /obj/item/alch/euphrasia),
		"重楼" = list(25, /obj/item/alch/paris),
		"金盏花" = list(25, /obj/item/alch/calendula),
		"薄荷" = list(25, /obj/item/alch/mentha),
		"荨麻" = list(25, /obj/item/alch/urtica),
		"鼠尾草" = list(25, /obj/item/alch/salvia),
		"金丝桃" = list(25, /obj/item/alch/hypericum),
		"圣蓟" = list(25, /obj/item/alch/benedictus),
		"缬草" = list(25, /obj/item/alch/valeriana),
		"艾蒿" = list(25, /obj/item/alch/artemisia),
		"玫瑰" = list(25, /obj/item/alch/rosa),
		"黑曜石碎片" = list(30, /obj/item/magic/obsidian),
		"魔力花" = list(manabloom_cost, /obj/item/reagent_containers/food/snacks/grown/manabloom),
		"炼狱灰烬" = list(infernal_ash_cost, /obj/item/magic/infernal/ash),
		"仙灵粉尘" = list(fae_dust_cost, /obj/item/magic/fae/dust),
		"元素微尘" = list(elemental_mote_cost, /obj/item/magic/elemental/mote),
		"结晶化魔力" = list(z121_rpg_processed_material_cost(manapot_cost * 45 / 50), /obj/item/magic/manacrystal),
		"地脉碎晶" = list(150, /obj/item/magic/leyline),
		"奥能融块" = list(z121_rpg_processed_material_cost(infernal_ash_cost + fae_dust_cost + elemental_mote_cost), /obj/item/magic/melded/t1),
	), 1)


/datum/component/rpg_system/proc/get_magic_catalog()
	return z121_rpg_magic_catalog()

/proc/z121_rpg_magic_catalog()
	return z121_rpg_price_catalog(list(
		"见习传送卷轴" = list(90, /obj/item/teleportation_scroll/apprentice),               // 入门级一次性魔法传送
		"圣徽"       = list(120, /obj/item/clothing/neck/roguetown/psicross),              // 神圣符号，可引导秘法
		"传送卷轴"   = list(150, /obj/item/teleportation_scroll),                          // 一次性魔法传送
		"魔法戒指"   = list(200, /obj/item/clothing/ring/active),                          // 可激活的魔法戒指
		// —— 附魔卷轴（对"物品"施加特殊附魔：手持卷轴点击目标物品即可附魔，不是教人法术）——
		//   T1 基础附魔
		"附魔·伐木"   = list(150, /obj/item/enchantmentscroll/basic/woodcut),     // 给斧子附魔：高效伐木
		"附魔·采矿"   = list(150, /obj/item/enchantmentscroll/basic/mining),      // 给镐子附魔：高效采矿
		"附魔·显照"   = list(170, /obj/item/enchantmentscroll/basic/revealing),   // 给物品附魔：光源照明范围翻倍
		"附魔·恒光"   = list(180, /obj/item/enchantmentscroll/basic/light),       // 给武器 / 衣物附魔：自身发光
		"附魔·幸运"   = list(200, /obj/item/enchantmentscroll/basic/xylix),       // 给衣物附魔：赐予幸运
		"附魔·储物"   = list(240, /obj/item/enchantmentscroll/basic/holding),     // 给容器附魔：容量翻倍
		//   T2 高级附魔
		"附魔·长步"   = list(240, /obj/item/enchantmentscroll/superior/trekk),       // 给鞋 / 戒指附魔：沼泽中行走自如
		"附魔·蛛行"   = list(250, /obj/item/enchantmentscroll/superior/climbing),    // 给衣物附魔：攀爬陡壁
		"附魔·夜视"   = list(250, /obj/item/enchantmentscroll/superior/nightvision), // 给衣物附魔：黑暗中视物
		"附魔·锻造"   = list(250, /obj/item/enchantmentscroll/superior/smithing),    // 给锤子附魔：打铁更有效
		"附魔·巧手"   = list(260, /obj/item/enchantmentscroll/superior/thievery),    // 给手套 / 戒指附魔：偷窃撬锁
		"附魔·羽步"   = list(280, /obj/item/enchantmentscroll/superior/featherstep), // 给鞋 / 戒指附魔：加速且脚步无声
		"附魔·抗火"   = list(280, /obj/item/enchantmentscroll/superior/fireresist),  // 给衣物附魔：不会被点燃
		"附魔·坚不可摧" = list(300, /obj/item/enchantmentscroll/superior/unbreaking), // 给武器 / 衣物附魔：更耐用
		//   T3 强力附魔
		"附魔·武器召回" = list(420, /obj/item/enchantmentscroll/greater/returningweapon), // 给戒指 / 项链 / 手套附魔：召回武器
		"附魔·神射"   = list(440, /obj/item/enchantmentscroll/greater/sharpshooter), // 给戒指、圣徽、手套或护腕附魔：提升远程武器技能
		"附魔·愈合"   = list(450, /obj/item/enchantmentscroll/greater/woundclosing), // 给戒指附魔：定期闭合伤口
		"附魔·霜幕"   = list(460, /obj/item/enchantmentscroll/greater/frostveil),   // 给武器 / 护甲附魔：减速敌人
		"附魔·闪电"   = list(480, /obj/item/enchantmentscroll/greater/lightning),   // 给武器附魔：命中电击
		"附魔·凤凰守卫" = list(480, /obj/item/enchantmentscroll/greater/phoenixguard), // 给衣物附魔：反伤点燃来犯者
		"附魔·吸血"   = list(500, /obj/item/enchantmentscroll/greater/lifesteal),   // 给武器附魔：命中回血
		"附魔·虚空"   = list(520, /obj/item/enchantmentscroll/greater/voidtouched), // 给武器附魔：将敌人短暂拽入虚空
		//   T4 神话附魔
		"附魔·荆棘诅咒" = list(700, /obj/item/enchantmentscroll/mythic/briars),     // 给武器附魔：伤害大增但反噬自身
		"附魔·地狱火焰" = list(750, /obj/item/enchantmentscroll/mythic/infernalflame), // 给武器 / 衣物附魔：命中点燃
		"附魔·冰冻"   = list(780, /obj/item/enchantmentscroll/mythic/freeze),      // 给武器 / 衣物附魔：命中冻结
		"附魔·时间回溯" = list(800, /obj/item/enchantmentscroll/mythic/rewind),     // 给武器 / 衣物附魔：受击后回溯位置
		"附魔·混沌风暴" = list(850, /obj/item/enchantmentscroll/mythic/chaos_storm), // 给武器附魔：随机混沌效果
		"月光大剑"   = list(600, /obj/item/rogueweapon/greatsword/moonlight_greatsword),   // 本模块自定义：高级魔法巨剑
	), 2)


/datum/component/rpg_system/proc/get_delicacy_catalog()
	return z121_rpg_delicacy_catalog()

/proc/z121_rpg_delicacy_catalog()
	return z121_rpg_price_catalog(list(
		"饼干"     = list(35, /obj/item/reagent_containers/food/snacks/rogue/biscuit),        // 饼干，烤好的成品点心（cookie 图标缺失，改用图标确实存在的 biscuit）
		"奶酪"     = list(40, /obj/item/reagent_containers/food/snacks/rogue/cheese),         // 奶酪，成品乳制珍品
		"蜂蜜"     = list(45, /obj/item/reagent_containers/food/snacks/rogue/honey),          // 蜂蜜，成品甘味珍品
		"奶酪三明治" = list(50, /obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese), // 奶酪三明治，成品餐食（基类 sandwich 无图标，改用有图标的奶酪子类型）
		"熟酿蛋"   = list(55, /obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked), // 熟酿蛋，烹好的成品菜
		"果馅卷"   = list(80, /obj/item/reagent_containers/food/snacks/rogue/strudel),        // 果馅卷，烤好的成品酥点
		"糖渍果馅卷" = list(95, /obj/item/reagent_containers/food/snacks/rogue/strudel/sugar), // 糖渍果馅卷，成品甜点
		"红酒"     = list(70, /obj/item/reagent_containers/glass/bottle/rogue/redwine),       // 红葡萄酒，餐桌佳酿
		"白葡萄酒" = list(70, /obj/item/reagent_containers/glass/bottle/rogue/whitewine),     // 白葡萄酒，清爽佳酿
		"肉派"     = list(90, /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat),  // 烤好的肉馅大派，成品硬菜
		"蟹肉派"  = list(110, /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab), // 烤好的蟹肉派，成品珍馐
		"精灵红酒"= list(150, /obj/item/reagent_containers/glass/bottle/rogue/elfred),       // 精灵红酒，名贵佳酿
		"精灵蓝酒"= list(160, /obj/item/reagent_containers/glass/bottle/rogue/elfblue),      // 精灵蓝酒，名贵佳酿
		"仙馐蜂蜜"= list(200, /obj/item/reagent_containers/food/snacks/rogue/honey/ambrosia), // 仙馐蜂蜜，传说级成品珍馐
		// —— 珍馐（品质 5 / FARE_LAVISH 的成品美食；图标均已核验存在）——
		//   蛋糕类甜点
		"苹果蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/applecake),
		"苹果坚果蛋糕" = list(110, /obj/item/reagent_containers/food/snacks/rogue/applenutcake),
		"浆果蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/berrycake),
		"黑莓蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/blackberrycake),
		"覆盆子蛋糕" = list(110, /obj/item/reagent_containers/food/snacks/rogue/raspberrycake),
		"草莓蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/strawberrycake),
		"胡萝卜蛋糕" = list(110, /obj/item/reagent_containers/food/snacks/rogue/carrotcake),
		"柠檬蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/lemoncake),
		"青柠蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/limecake),
		"橘子蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/tangerinecake),
		"薄荷蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/menthacake),
		"石果蛋糕"   = list(110, /obj/item/reagent_containers/food/snacks/rogue/rocknutcake),
		"和平蛋糕"   = list(120, /obj/item/reagent_containers/food/snacks/rogue/peacecake),
		"兹班图蛋糕" = list(120, /obj/item/reagent_containers/food/snacks/rogue/hcake),
		//   肉食硬菜
		"嫩炸鸟排"   = list(150, /obj/item/reagent_containers/food/snacks/rogue/meat/chickentender),
		"炸肉排"     = list(150, /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel),
		"香料烤禽"   = list(150, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced),
		"黄油烤禽"   = list(150, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter),
		"公爵烤禽"   = list(180, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal),
		"公爵牛排"   = list(180, /obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal),
		//   饭食套餐
		"鸡蛋奶酪饭" = list(120, /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese),
		"牛肉饭套餐" = list(130, /obj/item/reagent_containers/food/snacks/rogue/ricebeefcar),
		"猪肉饭套餐" = list(130, /obj/item/reagent_containers/food/snacks/rogue/riceporkcuc),
		"禽肉饭套餐" = list(130, /obj/item/reagent_containers/food/snacks/rogue/ricebirdcar),
		"虾仁饭套餐" = list(140, /obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar),
		//   其它成品珍馐
		"鳗鱼冻"     = list(120, /obj/item/reagent_containers/food/snacks/rogue/jelliedeel),
		"奶酪酿茄子" = list(120, /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese),
		"铁锤堡式早餐" = list(130, /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold),
		// —— 佳酿（品质 ≥ 3 的名贵酒水；elfblue 已在上方列出）——
		"风郡清酒"   = list(130, /obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake),
		"风郡烧酎"   = list(140, /obj/item/reagent_containers/glass/bottle/rogue/beer/kgunshochu),
		"药酒"       = list(130, /obj/item/reagent_containers/glass/bottle/rogue/beer/yaojiu),
		"蛇酒"       = list(150, /obj/item/reagent_containers/glass/bottle/rogue/beer/shejiu),
	), 1.5)


/datum/component/rpg_system/proc/get_artifact_catalog()
	return z121_rpg_artifact_catalog()

/proc/z121_rpg_artifact_catalog()
	return z121_rpg_price_catalog(list(
		"阿斯特拉塔护符" = list(150, /obj/item/clothing/neck/roguetown/psicross/astrata),  // 太阳女神 阿斯特拉塔 的圣徽
		"诺克护符"       = list(150, /obj/item/clothing/neck/roguetown/psicross/noc),      // 求知之神 诺克 的圣徽
		"阿比索尔护符"   = list(150, /obj/item/clothing/neck/roguetown/psicross/abyssor),  // 深海之神 阿比索尔 的圣徽
		"邓多尔护符"     = list(150, /obj/item/clothing/neck/roguetown/psicross/dendor),   // 自然之神 邓多尔 的圣徽
		"奈克拉护符"     = list(150, /obj/item/clothing/neck/roguetown/psicross/necra),    // 死亡之神 奈克拉 的圣徽
		"佩斯特拉护符"   = list(150, /obj/item/clothing/neck/roguetown/psicross/pestra),   // 医疗之神 佩斯特拉 的圣徽
		"拉沃克斯护符"   = list(150, /obj/item/clothing/neck/roguetown/psicross/ravox),    // 战争 / 正义之神 拉沃克斯 的圣徽
		"玛卢姆护符"     = list(150, /obj/item/clothing/neck/roguetown/psicross/malum),    // 创造 / 火 之神 玛卢姆 的圣徽
		"埃奥拉护符"     = list(150, /obj/item/clothing/neck/roguetown/psicross/eora),     // 羁绊之神 埃奥拉 的圣徽
		"希利克斯护符"   = list(150, /obj/item/clothing/neck/roguetown/psicross/xylix),    // 戏谑之神 希利克斯 的圣徽
		"圣印护符"       = list(220, /obj/item/clothing/neck/roguetown/psicross/undivided), // 圣座信物，地位与恩典的象征
		"受祝银制圣徽"   = list(350, /obj/item/clothing/neck/roguetown/psicross/silver/astrata), // 受祝的银制 阿斯特拉塔 圣物（高阶神器）
		// 与激进派教士的神明神器表保持一致，佩斯特拉的三件分别出售。
		"阿斯特拉塔·星辰" = list(10000, /obj/item/artifact/astrata_star),
		"诺克·命匣" = list(10000, /obj/item/artefact/noc_phylactery),
		"登多尔·无尽之管" = list(10000, /obj/item/artefact/dendor_hose),
		"阿比索尔·深渊钓竿" = list(10000, /obj/item/fishingrod/abyssoid),
		"拉沃克斯·透镜" = list(10000, /obj/item/artifact/ravox_lens),
		"内克拉·香炉" = list(10000, /obj/item/artefact/necra_censer),
		"赛利克斯·手套" = list(10000, /obj/item/clothing/gloves/xylix),
		"佩斯特拉·手术工具" = list(10000, /obj/item/rogueweapon/surgery/multitool),
		"佩斯特拉·缝合针" = list(10000, /obj/item/needle/pestra),
		"佩斯特拉·圣蛭" = list(10000, /obj/item/natural/worms/leech/cheele),
		"玛勒姆·神锤" = list(10000, /obj/item/rogueweapon/hammer/artefact/malum),
		"伊欧拉·圣心" = list(10000, /obj/item/artefact/eora_heart),
	), 2, list(/obj/item/artifact/astrata_star, /obj/item/artefact/noc_phylactery, /obj/item/artefact/dendor_hose, /obj/item/fishingrod/abyssoid, /obj/item/artifact/ravox_lens, /obj/item/artefact/necra_censer, /obj/item/clothing/gloves/xylix, /obj/item/rogueweapon/surgery/multitool, /obj/item/needle/pestra, /obj/item/natural/worms/leech/cheele, /obj/item/rogueweapon/hammer/artefact/malum, /obj/item/artefact/eora_heart))


/datum/component/rpg_system/proc/get_catalog_for_tab(tab)
	switch(tab)
		if("weapon")
			return get_weapon_catalog()
		if("equipment")
			return get_equipment_catalog()
		if("consumable")
			return get_consumable_catalog()
		if("material")
			return get_material_catalog()
		if("magic")
			return get_magic_catalog()
		if("delicacy")
			return get_delicacy_catalog()
		if("artifact")
			return get_artifact_catalog()
	// 未知页签：返回空表，调用方据此显示"暂无商品"，绝不空引用。
	return list()


/datum/component/rpg_system/proc/do_buy_item(mob/living/carbon/human/user, tab, index, quantity = 1)
	// 防御：宿主状态校验（点击时玩家可能已死亡 / 离线）。
	if(!can_use_system(user))
		return
	// 数量只接受有限范围内的整数；其它商品仍只能一次购买一件。
	var/max_quantity = tab == "material" ? RPG_SYSTEM_MATERIAL_MAX_QUANTITY : 1
	if(!isnum(quantity) || quantity != round(quantity) || quantity < 1 || quantity > max_quantity)
		to_chat(user, span_warning("【系统提示】兑换数量必须为1至[max_quantity]的整数。"))
		return
	var/list/catalog = get_catalog_for_tab(tab)
	// 行号健壮性校验：必须落在 [1, 目录长度] 内，越界一律忽略（防伪造参数）。
	if(!LAZYLEN(catalog) || !isnum(index) || index != round(index) || index < 1 || index > catalog.len)
		return
	// 按插入序取出第 index 个键，再取其 (价格, 类型路径)。
	var/catalog_key = catalog[index]   // BYOND 关联列表按下标取到的是"键"
	var/list/entry = catalog[catalog_key]
	if(!islist(entry) || entry.len < 2)
		to_chat(user, span_warning("【系统提示】该商品配置异常，兑换失败。"))
		return
	var/unit_cost = entry[1]
	if(!isnum(unit_cost) || unit_cost <= 0)
		to_chat(user, span_warning("【系统提示】该商品价格异常，兑换失败。"))
		return
	var/cost = unit_cost * quantity // 单价与总价均从服务端目录计算。
	var/item_path = entry[2] // 该商品的物品类型路径
	// 积分校验：不足则明确告知差额，不扣分、不发货（界面禁用按钮之外，服务端仍重新校验）。
	if(points < cost)
		to_chat(user, span_warning("【系统提示】积分不足。需要 [cost]，你只有 [points]。"))
		return
	// 类型路径健壮性校验：必须是 /obj/item 的子类型才生成，杜绝因配置笔误生成出奇怪的东西。
	if(!ispath(item_path, /obj/item))
		to_chat(user, span_warning("【系统提示】该商品配置异常（无效物品），兑换失败。"))
		return
	var/turf/delivery_turf = get_turf(user)
	if(!delivery_turf)
		to_chat(user, span_warning("【系统提示】当前位置无法接收物品，未扣除积分。"))
		return
	// 先扣费，再发货。先扣费可避免"发货成功但扣费抛错"导致的白嫖；即便物品最终落在脚下也算发货成功。
	points -= cost
	var/return_generation = z121_return_generation
	if(tab == "material")
		deliver_material_batch(user, item_path, quantity, cost, return_generation)
		return
	// 非材料商品保留单件发货方式。
	var/obj/item/bought = new item_path(delivery_turf)
	if(QDELETED(src) || return_generation != z121_return_generation)
		return
	if(QDELETED(bought))
		points += cost
		to_chat(user, span_warning("【系统提示】物品生成失败，积分已退还。"))
		return
	user.put_in_hands(bought)
	// 兑换结果通过界面与音效反馈，连续购买不向聊天栏刷屏。
	playsound(user, 'sound/misc/click.ogg', 50, FALSE) // 复用引擎已有音效，给一个轻量的"到账"反馈，无需新增音频资源。


// 暂存物品不进入地图，整批生成成功之前不可被玩家取走。
/obj/effect/rpg_purchase_staging
	name = "材料兑换暂存"
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/rpg_purchase_staging/Destroy()
	// 连初始化抛错、尚未来得及记入清单的物品也一并回收。
	for(var/atom/movable/item in contents)
		qdel(item)
	return ..()

/datum/component/rpg_system/proc/deliver_material_batch(mob/living/carbon/human/user, item_path, quantity, cost, return_generation)
	var/obj/effect/rpg_purchase_staging/staging = new
	var/list/bought_items = list()
	var/failed = FALSE
	try
		for(var/i in 1 to quantity)
			if(QDELETED(src) || return_generation != z121_return_generation || !can_use_system(user) || QDELETED(staging))
				failed = TRUE
				break
			var/obj/item/bought = new item_path(staging)
			if(!QDELETED(bought))
				bought_items += bought
			if(QDELETED(bought) || bought.loc != staging)
				failed = TRUE
				break
		// 构造过程可能让出执行权，发货前再次校验整批物品与角色状态。
		if(!failed)
			for(var/obj/item/bought in bought_items)
				if(QDELETED(bought) || bought.loc != staging)
					failed = TRUE
					break
		if(!failed && bought_items.len == quantity)
			for(var/obj/item/bought in bought_items)
				if(QDELETED(src) || return_generation != z121_return_generation || !can_use_system(user) || !get_turf(user) || QDELETED(bought))
					failed = TRUE
					break
				user.put_in_hands(bought)
		else
			failed = TRUE
	catch(var/exception/error)
		failed = TRUE
		stack_trace("RPG材料批量兑换失败：[error]")
	// 最后一件物品的装备信号也可能触发死亡回溯，不能遗漏这次校验。
	if(QDELETED(src) || return_generation != z121_return_generation || !can_use_system(user))
		failed = TRUE
	if(failed)
		for(var/obj/item/bought in bought_items)
			if(!QDELETED(bought))
				qdel(bought)
	qdel(staging)
	// 回溯已经恢复了积分快照，旧事务不得向新世代退款或继续发货。
	if(QDELETED(src) || return_generation != z121_return_generation)
		return
	if(failed)
		points += cost
		if(!QDELETED(user))
			to_chat(user, span_warning("【系统提示】材料兑换未完成，本次积分已退还。"))
		return
	playsound(user, 'sound/misc/click.ogg', 50, FALSE)


/datum/component/rpg_system/proc/stat_upgrade_cost(current_value)
	// 防御：把入参夹到合法属性区间 [1,20]，避免异常值算出负价 / 离谱价。
	current_value = clamp(current_value, 1, 20)
	return RPG_SYSTEM_STAT_COST_BASE * current_value


/datum/component/rpg_system/proc/skill_upgrade_cost(current_level)
	// 防御：把入参夹到合法等级区间 [0,6]，避免异常值算出负价 / 离谱价。
	current_level = clamp(current_level, 0, SKILL_LEVEL_LEGENDARY)
	return RPG_SYSTEM_SKILL_COST_BASE * (current_level + 1)


/datum/component/rpg_system/proc/get_attribute_defs()
	return list(
		"力量 STR" = STATKEY_STR,
		"感知 PER" = STATKEY_PER,
		"智力 INT" = STATKEY_INT,
		"体质 CON" = STATKEY_CON,
		"意志 WIL" = STATKEY_WIL,
		"速度 SPD" = STATKEY_SPD,
		"幸运 LCK" = STATKEY_LCK,
	)


/datum/component/rpg_system/proc/do_enhance_attribute(mob/living/carbon/human/user, index)
	// 防御：宿主状态校验。
	if(!can_use_system(user))
		return
	var/list/defs = get_attribute_defs()
	// 行号健壮性校验：越界忽略（防伪造参数）。
	if(!isnum(index) || index != round(index) || index < 1 || index > defs.len)
		return
	var/display = defs[index]   // 第 index 个键即"展示名"
	var/stat_key = defs[display] // 其对应的属性键
	// 以"此刻真实值"为准定价与封顶，杜绝差价 / 越界。
	var/cur = user.get_stat(stat_key)
	// 满级校验：已达 20 则不扣费（否则 change_stat 会把加成吞进 BUF，等于白花积分）。
	if(cur >= 20)
		to_chat(user, span_warning("【系统提示】[display] 已达上限（20），无法继续强化。"))
		return
	var/cost = stat_upgrade_cost(cur) // 本次升级的实际花费（随当前值递增）
	// 积分校验：不足则提示，不扣分（界面禁用按钮之外，服务端仍重新校验）。
	if(points < cost)
		to_chat(user, span_warning("【系统提示】积分不足。需要 [cost]，你只有 [points]。"))
		return
	// 扣费并 +1。change_stat 内部自带 1~20 封顶，这里再叠一层 get_stat 预检，双保险不浪费积分。
	points -= cost
	user.change_stat(stat_key, 1)
	// 强化后的属性与剩余积分由界面显示。
	playsound(user, 'sound/misc/click.ogg', 50, FALSE)


/datum/component/rpg_system/proc/get_skill_defs()
	return list(
		// —— 战斗：近战 ——
		"剑术"     = /datum/skill/combat/swords,
		"匕首"     = /datum/skill/combat/knives,
		"斧术"     = /datum/skill/combat/axes,
		"长柄"     = /datum/skill/combat/polearms,
		"钝器"     = /datum/skill/combat/maces,
		"鞭索"     = /datum/skill/combat/whipsflails,   // 鞭 / 连枷类
		"徒手"     = /datum/skill/combat/unarmed,
		"摔角"     = /datum/skill/combat/wrestling,
		"盾防"     = /datum/skill/combat/shields,
		// —— 战斗：远程 ——
		"弓术"     = /datum/skill/combat/bows,
		"弩术"     = /datum/skill/combat/crossbows,
		"投石"     = /datum/skill/combat/slings,
		"火器"     = /datum/skill/combat/firearms,
		// —— 杂项：运动 / 生活 / 社交 ——
		"运动"     = /datum/skill/misc/athletics,
		"攀爬"     = /datum/skill/misc/climbing,
		"游泳"     = /datum/skill/misc/swimming,
		"阅读"     = /datum/skill/misc/reading,
		"医术"     = /datum/skill/misc/medicine,
		"潜行"     = /datum/skill/misc/sneaking,
		"偷窃"     = /datum/skill/misc/stealing,
		"撬锁"     = /datum/skill/misc/lockpicking,
		"骑术"     = /datum/skill/misc/riding,
		"音乐"     = /datum/skill/misc/music,
		"追踪"     = /datum/skill/misc/tracking,
		// —— 劳作：采集 / 生产 ——
		"耕作"     = /datum/skill/labor/farming,
		"采矿"     = /datum/skill/labor/mining,
		"捕鱼"     = /datum/skill/labor/fishing,
		"屠宰"     = /datum/skill/labor/butchering,
		"伐木"     = /datum/skill/labor/lumberjacking,
		// —— 工艺：锻造 / 制作 ——
		"工艺"     = /datum/skill/craft/crafting,
		"锻造武器" = /datum/skill/craft/weaponsmithing,
		"锻造护甲" = /datum/skill/craft/armorsmithing,
		"铁匠"     = /datum/skill/craft/blacksmithing,
		"冶炼"     = /datum/skill/craft/smelting,
		"木工"     = /datum/skill/craft/carpentry,
		"石工"     = /datum/skill/craft/masonry,
		"工程"     = /datum/skill/craft/engineering,
		"烹饪"     = /datum/skill/craft/cooking,
		"缝纫"     = /datum/skill/craft/sewing,
		"制革"     = /datum/skill/craft/tanning,
		"制陶"     = /datum/skill/craft/ceramics,
		"炼金"     = /datum/skill/craft/alchemy,
		// —— 魔法 ——（血魔法按需求不开放强化，故不列入）
		"神圣魔法" = /datum/skill/magic/holy,
		"奥术"     = /datum/skill/magic/arcane,
		"德鲁伊魔法" = /datum/skill/magic/druidic,
	)


/datum/component/rpg_system/proc/do_enhance_skill(mob/living/carbon/human/user, index)
	// 防御：宿主状态校验；并且强化技能依赖 mind，无 mind 则中止。
	if(!can_use_system(user))
		return
	if(!user.mind)
		to_chat(user, span_warning("【系统提示】你的意识尚不稳定，暂时无法强化技能。"))
		return
	var/list/defs = get_skill_defs()
	// 行号健壮性校验：越界忽略（防伪造参数）。
	if(!isnum(index) || index != round(index) || index < 1 || index > defs.len)
		return
	var/display = defs[index]   // 第 index 个键即"展示名"
	var/skill_path = defs[display] // 其对应的技能类型路径
	// 类型路径健壮性校验：必须是 /datum/skill 子类型，杜绝配置笔误。
	if(!ispath(skill_path, /datum/skill))
		to_chat(user, span_warning("【系统提示】该技能配置异常，强化失败。"))
		return
	// 以"此刻真实等级"为准定价与封顶，杜绝差价 / 越界。
	var/lvl = user.get_skill_level(skill_path)
	// 满级校验：已达传奇（6）则不扣费（否则 adjust_skillrank 不会再升，等于白花积分）。
	if(lvl >= SKILL_LEVEL_LEGENDARY)
		to_chat(user, span_warning("【系统提示】[display] 已达传奇等级，无法继续强化。"))
		return
	var/cost = skill_upgrade_cost(lvl) // 本次升级的实际花费（随当前等级递增）
	// 积分校验：不足则提示，不扣分。
	if(points < cost)
		to_chat(user, span_warning("【系统提示】积分不足。需要 [cost]，你只有 [points]。"))
		return
	// 扣费并提升 1 级。adjust_skillrank 内部按经验阈值封顶到传奇，安全。
	points -= cost
	user.adjust_skillrank(skill_path, 1, TRUE) // 静默强化，结果与余额由界面显示。
	playsound(user, 'sound/misc/click.ogg', 50, FALSE)


// 每条记录显式指定价格档位；不自动开放职业身份、负面状态或整套美德。
// 不上架尚无实际减速豁免效果的忽略减速，以及禁售的反反制咒。
/datum/component/rpg_system/proc/get_trait_catalog()
	var/static/list/catalog
	if(!catalog)
		catalog = list(
			list("trait" = TRAIT_MEDIUMARMOR, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_HEAVYARMOR, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_DODGEEXPERT, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_MAGEARMOR, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_CRITICAL_RESISTANCE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_PSYDONIAN_GRIT, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_STRONGBITE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_STRONGKICK, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_CIVILIZEDBARBARIAN, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_TAVERN_FIGHTER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_SHARPER_BLADES, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NOFALLDAMAGE2, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_SHOCKIMMUNE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_EXTREME_TEMPERATURE_IMMUNE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_WATERBREATHING, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_LEECHIMMUNE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_DRUNK_HEALING, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_BETTER_SLEEP, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_ZJUMP, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_LEAPER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_SEEPRICES, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_PERFECT_TRACKER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_INTELLECTUAL, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_NOSTINK, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_GOODLOVER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_NOPAIN, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NOPAINSTUN, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_HARDDISMEMBER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_DUALWIELDER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_COMBAT_AWARE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_HOLYWARRIOR, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ASSASSIN, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_GRABIMMUNE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NATURALARMOR, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_HARDSHELL, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_BREADY, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_DECEIVING_MEEKNESS, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NUTCRACKER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_BASHDOORS, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_SCALEARMOR, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ADRENALINE_RUSH, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_REGROW_LIMBS, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_VENOMOUS, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NOBREATH, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_TOXIMMUNE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NOHUNGER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ZOMBIE_IMMUNE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_KNEESTINGER_IMMUNITY, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ROT_EATER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ORGAN_EATER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_CRACKHEAD, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_SEA_DRINKER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NASTY_EATER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_WILD_EATER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_DARKVISION, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ZIZOSIGHT, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NOCSIGHT, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_KEENEARS, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_EXTEROCEPTION, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SOUL_EXAMINE, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_HERETIC_SEER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_JUSTICARSIGHT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_MATTHIOS_EYES, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_EMPATH, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_LIGHT_STEP, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_SLEUTH, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_WOODWALKER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_WEBWALK, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_LONGSTRIDER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_EQUESTRIAN, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_MEDICINE_EXPERT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_ALCHEMY_EXPERT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SMITHING_EXPERT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SEWING_EXPERT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SURVIVAL_EXPERT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_HOMESTEAD_EXPERT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SELF_SUSTENANCE, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_FUSILIER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_MASTER_CARPENTER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_MASTER_MASON, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_TRAINED_SMITH, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_KAZENGUNITE_SMITH, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_DWARF_REPAIR, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SQUIRE_REPAIR, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_FORGEBLESSED, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_DYES, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_GOODWRITER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SEEDKNOW, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_CAUTIOUS_FISHER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_GRAVEROBBER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_GOODTRAINER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_OUTDOORSMAN, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_WILDERNESSGUIDE, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_WOODSMAN, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_GUARDSMAN, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_RITUALIST, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_CICERONE, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_HUMEN_INGENUITY, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_BLACKBAGGER, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ENGINEERING_GOGGLES, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_ARCYNE_T1, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_ARCYNE_T2, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_ARCYNE_T3, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_ARCYNE_T4, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_MIRROR_MAGIC, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_RESONANCE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_XYLIX_DEVOTEE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_FASTSLEEP, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_STEELHEARTED, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_BEAUTIFUL, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_APRICITY, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ABYSSOR_SWIM, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_XYLIX, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_TOLERANT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SILVER_BLESSED, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_BOMBER_EXPERT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_RAW_EATER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_UNDERDARK_CHEF, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_DWARVEN_CHEF, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_GOSSIPER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_MARTIAL_PROWESS, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_SELF_AWARE, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_DEATHSIGHT, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_LEGENDARY_ALCHEMIST, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_EFFICIENT_WEAVER, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_PRETTY, "cost" = RPG_SYSTEM_TRAIT_COST, "tier" = "普通"),
			list("trait" = TRAIT_JOURNEYS_END, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_BLOOD_RESISTANCE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_ANTISCRYING, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_WATERLOVING, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_CURSE_RESIST, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_THROWINGARM, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_SENTINELOFWITS, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_STRENGTH_UNCAPPED, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_UNCAPPED_SPEED, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_IGNOREDAMAGESLOWDOWN, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_NOFALLDAMAGE1, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_FORTITUDE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_GUIDANCE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_LEYLINE_HASTE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_SPELL_DISPERSION, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_EORAN_CALM, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_EORAN_SERENE, "cost" = RPG_SYSTEM_TRAIT_STRONG_COST, "tier" = "强力"),
			list("trait" = TRAIT_INFINITE_STAMINA, "cost" = RPG_SYSTEM_TRAIT_OVERPOWERED_COST, "tier" = "超模"),
			list("trait" = TRAIT_INFINITE_ENERGY, "cost" = RPG_SYSTEM_TRAIT_OVERPOWERED_COST, "tier" = "超模"),
		)
		// 使用中文显示名覆盖底层英文键。
		var/list/names = list(
			TRAIT_EFFICIENT_WEAVER = "高效织工",
			TRAIT_FORTITUDE = "坚毅",
			TRAIT_GUIDANCE = "指引",
		)
		// 商店说明按实际效果补充条件，避免直接沿用角色背景描述。
		// 部分全局说明登记在宏定义之前，键名并非实际特性值，需在此显式补齐。
		var/list/descriptions = list(
			TRAIT_HOLYWARRIOR = "身处圣地区域时，力量、感知、智力、体质、意志、速度与幸运各提高2点；离开圣地后失效。",
			TRAIT_BASHDOORS = "可撞击破坏上锁的门，也能直接敲击损坏窗户；仍需造成足够伤害才能破坏。",
			TRAIT_REGROW_LIMBS = "睡眠时可再生缺失的手臂或腿。每条肢体要求营养高于250，并消耗250营养；不能再生头部或器官。",
			TRAIT_EXTEROCEPTION = "观察他人时，可以看出对方的饥饿与口渴状况。",
			TRAIT_FASTSLEEP = "满足入睡条件时更快入睡；不直接提高睡眠时的恢复量。",
			TRAIT_IGNOREDAMAGESLOWDOWN = "免除生命值下降造成的地面移动与悬浮移动减速；护甲、负重和地形等其他减速仍然有效。",
			TRAIT_LEGENDARY_ALCHEMIST = "能辨认药草种子；检查炼金原料时，直接显示其适合制作的药剂及亲和度，而非仅显示气味。",
			TRAIT_NATURALARMOR = "免受踩踏铁蒺藜等尖锐物造成的伤害与麻痹；不提供通用的劈砍或穿刺抗性。",
			TRAIT_HARDSHELL = "攻击有玩家控制的目标时，将对方的招架成功率上限限制为70%；不降低自己的招架能力。",
			TRAIT_TRAINED_SMITH = "用锤子修复护甲护层时，无需把护甲放在指定修理设施上；材料等其他修理条件仍然适用。",
			TRAIT_DWARF_REPAIR = "解锁矮人武器与护甲的铁砧锻造配方；仍需满足对应材料与技能要求。",
			TRAIT_MEDICINE_EXPERT = "允许将医术训练至传奇；不直接提高当前技能等级。",
			TRAIT_ALCHEMY_EXPERT = "允许将炼金术训练至传奇，并能识别部分炼金物品的信息；不直接提高当前技能等级。",
			TRAIT_SMITHING_EXPERT = "允许将武器锻造、护甲锻造、铁匠、冶炼、工程、采矿、石工与陶艺训练至传奇；不直接提高当前技能等级。",
			TRAIT_SEWING_EXPERT = "允许将缝纫、皮革工艺与屠宰训练至传奇；不直接提高当前技能等级。",
			TRAIT_SURVIVAL_EXPERT = "允许将烹饪、钓鱼、屠宰与皮革工艺训练至传奇，缝纫训练至熟练工；不直接提高当前技能等级。",
			TRAIT_HOMESTEAD_EXPERT = "允许将耕作、采矿、烹饪、钓鱼、屠宰、伐木、石工与陶艺训练至传奇，缝纫与皮革工艺训练至熟练工；不直接提高当前技能等级。",
			TRAIT_SELF_SUSTENANCE = "允许将受此特性限制的多项制造与劳作技能训练至熟练工，并允许部分装备修理；不提高炼金术上限，也不直接提高当前技能等级。",
			TRAIT_MARTIAL_PROWESS = "允许将适用的战斗技能从专家继续训练至传奇；火器仍需火枪手特性，不直接提高当前技能等级。",
			TRAIT_FORTITUDE = "耐力消耗减少30%，并相应减少这部分消耗带来的精力损失；不提高资源上限。",
			TRAIT_STRENGTH_UNCAPPED = "使用武器攻击时，力量超过软上限的部分不再受到收益衰减；不直接增加力量，也不改变属性兑换上限。",
			TRAIT_UNCAPPED_SPEED = "提高速度属性能够带来的移动加速上限，使较高速度继续发挥作用；不直接增加速度属性。",
			TRAIT_NOFALLDAMAGE1 = "免受不超过两层的坠落冲击伤害，但落地后仍会短暂停步，并由奔跑切换为行走。更高处坠落仍会受伤。",
			TRAIT_NOFALLDAMAGE2 = "免受坠落落地时的冲击伤害，不受坠落层数限制。",
			TRAIT_ARCYNE_T1 = "允许学习最高一阶的奥术法术；不直接授予法术、法术点或技能等级。已有更高阶训练时不会叠加。",
			TRAIT_ARCYNE_T2 = "允许学习最高二阶的奥术法术，包含较低阶法术；不直接授予法术、法术点或技能等级。已有更高阶训练时不会叠加。",
			TRAIT_ARCYNE_T3 = "允许学习最高三阶的奥术法术，包含较低阶法术；不直接授予法术、法术点或技能等级。已有更高阶训练时不会叠加。",
			TRAIT_ARCYNE_T4 = "允许学习最高四阶的奥术法术，包含较低阶法术；不直接授予法术、法术点或技能等级。",
			TRAIT_MIRROR_MAGIC = "可借助镜子或水面改变发型、颜色等外观；不改变种族、属性或技能。",
			TRAIT_RESONANCE = "施放「奇迹」时，强化自身周围两格视野内的碳基生物；厌恶亡灵的信仰会改为灼伤其中的亡灵。兑换此特性不会授予奇迹法术。",
			TRAIT_LEYLINE_HASTE = "法术的蓄力时间与冷却时间缩短25%。",
			TRAIT_SPELL_DISPERSION = "自身的抗魔效果不再阻止施法；此特性本身不提供魔法护盾或法术免疫。",
			TRAIT_EFFICIENT_WEAVER = "织布时每份布料只需1份纤维。",
			TRAIT_WATERLOVING = "冷水降温时，体温不会因此降至正常体温以下。",
			TRAIT_CURSE_RESIST = "减轻神明诅咒的效果。",
			TRAIT_INFINITE_STAMINA = "不知疲倦：耐力消耗不再累积，精力也不再因常规消耗而减少。",
			TRAIT_INFINITE_ENERGY = "无尽精力：精力持续保持充足，但仍会累积耐力消耗。",
		)
		for(var/list/entry in catalog)
			var/trait = entry["trait"]
			entry["name"] = names[trait] ? names[trait] : trait
			var/description = GLOB.roguetraits[trait]
			entry["description"] = descriptions[trait] ? descriptions[trait] : (description ? html_decode(GLOB.html_tags.Replace(description, "")) : "获得此特性，保留其原有生效条件。")
		// 首次初始化时按价格稳定排序，同价保留原序；展示与结算共用排序后的编号。
		sortTim(catalog, GLOBAL_PROC_REF(cmp_rpg_trait_cost))
	return catalog

/proc/cmp_rpg_trait_cost(list/first, list/second)
	return first["cost"] - second["cost"]

/datum/component/rpg_system/proc/do_buy_trait(mob/living/carbon/human/user, index)
	if(!can_use_system(user))
		return
	var/list/catalog = get_trait_catalog()
	if(!isnum(index) || index != round(index) || index < 1 || index > catalog.len)
		return
	var/list/entry = catalog[index]
	var/trait = entry["trait"]
	var/display = entry["name"]
	var/cost = entry["cost"]
	if(HAS_TRAIT(user, trait))
		to_chat(user, span_warning("【系统提示】你已拥有【[display]】，无需重复兑换。"))
		return
	if(points < cost)
		to_chat(user, span_warning("【系统提示】积分不足。需要 [cost]，你只有 [points]。"))
		return
	points -= cost
	ADD_TRAIT(user, trait, RPG_SYSTEM_TRAIT_SOURCE)
	// 移动效果有缓存，购买后立即重算，无需再受伤或切换步态。
	if(trait == TRAIT_UNCAPPED_SPEED)
		user.update_move_intent_slowdown()
	if(trait == TRAIT_IGNOREDAMAGESLOWDOWN)
		user.updatehealth()
	// 无限资源不能将购买前耗尽的状态永久冻结，首次购买时同步恢复资源。
	if(trait == TRAIT_INFINITE_STAMINA || trait == TRAIT_INFINITE_ENERGY)
		if(trait == TRAIT_INFINITE_STAMINA)
			user.stamina = 0
		user.update_energy()
		user.energy = user.max_energy
		user.update_energy_hud()
		user.update_stamina_hud()
	playsound(user, 'sound/misc/click.ogg', 50, FALSE)


/proc/register_rpg_system_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常情况下安静跳过，绝不新建脱钩的"假表"。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」，第一人称、span_info 样式，与表中其它条目风格一致。
	//   幂等：重复调用只是覆盖同一个键，二次启动也安全。
	GLOB.roguetraits[TRAIT_RPG_SYSTEM] = span_info("我是世界旅人，持有只属于旅人的系统外挂：\
		击杀怪物可赚取系统积分，积分能兑换 武器 / 装备 / 消耗品 / 材料 / 魔法物品，也能强化我的技能与属性。")


// 清理本文件使用的内部价格与规则常量；系统特性键保留供模块调用。
#undef RPG_SYSTEM_TRIUMPH_COST
#undef RPG_SYSTEM_SCAN_RANGE
#undef RPG_SYSTEM_POINTS_PER_MAXHP
#undef RPG_SYSTEM_MIN_KILL_POINTS
#undef RPG_SYSTEM_STAT_COST_BASE
#undef RPG_SYSTEM_SKILL_COST_BASE
#undef RPG_SYSTEM_TRAIT_COST
#undef RPG_SYSTEM_TRAIT_STRONG_COST
#undef RPG_SYSTEM_TRAIT_OVERPOWERED_COST
#undef RPG_SYSTEM_SPELL_POINT_COST
#undef RPG_SYSTEM_MATERIAL_MAX_QUANTITY
#undef RPG_SYSTEM_TRAIT_SOURCE
