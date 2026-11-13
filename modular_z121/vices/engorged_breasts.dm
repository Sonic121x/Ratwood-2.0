// ============================================================================
// modular_z121/vices/engorged_breasts.dm
// 自定义恶习（Custom Vice / 恶习）：涨奶 / Milk Engorgement
// ----------------------------------------------------------------------------
// 需求（为什么要做这个文件）：
//   实现一个全新的"涨奶（Milk Engorgement）"恶习，核心设定为：
//     "拥有此恶习的人每隔一段时间就需要挤一次奶，否则胸口胀痛、心情变差。"
//   即——拥有此恶习的角色会【持续泌乳】，周期到达时胸口胀满（心情 debuff + 意志/速度减益）；
//   只有及时把奶挤出来（用吸奶器、挤进容器、或被人吸出），胀痛才会缓解、心情恢复，
//   并且计时归零，再过一轮才会再次发胀。
//
// 为什么做成"成瘾（addiction）"而不是普通恶习：
//   旧实现是"到点必定进入涨奶状态"，玩家无法通过提前、定期挤奶来规避 debuff——
//   时间一到就已经在扣属性了，只能事后补救。这与醉酒/烟瘾/色欲等成瘾恶习的体验不一致：
//   成瘾类恶习的核心是"定期满足即可避免 debuff"，满足的手段由玩家自己安排节奏。
//   因此本恶习改为继承 /datum/charflaw/addiction，复用基类的计时 / 压力事件 / 减益框架：
//     · 基类 flaw_on_life 在 next_sate 到达前不施加任何惩罚（sated = TRUE）；
//     · 到点后进入"未满足"（sated = FALSE），开始叠加心情压力事件与属性减益；
//     · 调用 sate_addiction() 后立刻撤销惩罚，并把 next_sate 重置为 now + time。
//   这样一来"定期挤奶"本身就等于"满足成瘾"，玩家可以靠规律挤奶把 debuff 完全挡在门外。
//
// 为什么用"奶量下降"来判定满足成瘾（对应 sate_addiction 的调用）：
//   游戏里一切挤奶手段（手持容器挤奶 try_milking、吸奶器 milk_breasts、吸乳 suck_nipples）
//   最终都只会做同一件事：把 breasts.milk_stored 往下减。因此只需在周期检测中对比上一拍的
//   奶量，只要发现下降就认为"刚挤过奶"，调用 sate_addiction() 满足成瘾。
//   · 血奶角色（TRAIT_NOHUNGER）：挤奶扣的是 blood_volume（无血时改为烧伤 fireloss），
//     所以改看血量下降 / 烧伤上升。
//   检测只做"是否下降"，不设阈值——胸再小（一次只挤出 1 单位）也能被感知到。
//
// 关于判定精度：
//   自然泌乳每生命 tick 只补 0.15 单位（HUNGER_FACTOR），而一次挤奶至少拿走 1 单位，
//   所以 5 秒一次的采样窗口内，挤奶造成的"净下降"一定大于自然回补量，不会被回补掩盖。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/charflaw/addiction           成瘾恶习基类，提供 sated / next_sate / time /
//                                         sate_addiction / stress_event / debuff 框架。
//   - /mob/living/carbon/human/sate_addiction(type)  满足成瘾：撤销压力与减益、重置计时。
//   - /obj/item/organ/breasts             乳房器官，持有 lactating / milk_stored / milk_max。
//   - /mob/living/carbon/human/has_breasts()  取乳房器官（无则返回 null，见 human.dm）。
//   - /datum/stressevent/vice             恶习类压力事件基类，表现心情变差。
//   - /datum/status_effect/debuff         减益状态效果基类（effectedstats 自动加减属性）。
//   - STATKEY_WIL / STATKEY_SPD           意志 / 速度属性键（code/__DEFINES/mobs.dm）。
//   - GLOB.character_flaws                角色定制界面"可选恶习"列表（用于登记本恶习）。
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）。
// ============================================================================


// ----------------------------------------------------------------------------
// 可调参数（#define）。集中放在文件顶部，便于统一调节节奏，并在文件末尾 #undef，
// 避免污染全局宏命名空间（与本项目其它自定义恶习/法术文件的写法保持一致）。
// ----------------------------------------------------------------------------
// 为什么设"周期 = 40 分钟"：需求原文就是"每搁 40 分钟需要挤奶"，作为固定的胀奶节奏。
//   由于触发不再依赖奶量，任何罩杯、任何血奶/普通体质的角色节奏完全一致。
#define ENGORGEMENT_PERIOD (40 MINUTES)
// 为什么设"检测节流 = 5 秒"：flaw_on_life 每个生命 tick 都被调用（非常频繁），而这里只需
//   周期性地做"是否挤过奶"的判定。5 秒一次既让"挤奶→满足成瘾"的反馈足够灵敏
//   （挤奶动作本身通常持续数秒），又不造成性能负担。
#define ENGORGEMENT_CHECK_INTERVAL (5 SECONDS)


// ----------------------------------------------------------------------------
// 恶习定义：涨奶（Milk Engorgement）
// 为什么继承 /datum/charflaw/addiction：复用成瘾系统"到点未满足才惩罚、满足即撤销、
//   满足后重新计时"的完整框架，本恶习只需额外负责 ①强制泌乳 ②把"奶量下降"翻译成
//   一次 sate_addiction() 调用。
// ----------------------------------------------------------------------------
/datum/charflaw/addiction/engorged_breasts
	name = "涨奶"                                                              // 角色定制菜单中显示的恶习名（Milk Engorgement）。
	// 为什么这样写描述：用第一人称讲清硬性机制——我会一直泌乳、隔一段时间胸口就胀满；
	//   只要定期把奶挤出来就能避免胀痛，否则心情变差、意志和速度下降。
	desc = "我的身体总在源源不断地泌乳，隔一段时间胸口就会胀满发痛、心情低落。\
			只要定期把奶挤出来就能保持舒坦，否则这份胀痛会一直缠着我，让我心神不宁、步履发沉。"

	// —— 成瘾框架参数 ——
	// 为什么显式声明 time：基类 New() 会把 time 随机成 6~60 分钟；本恶习要求固定 40 分钟，
	//   因此这里声明固定值，并在 New() 中覆盖随机化逻辑（见下）。
	time = ENGORGEMENT_PERIOD
	needsate_text = "胸口涨得发疼……奶水快要溢出来了，我得赶紧把奶挤出来。"   // 到点未满足时的一次性提示。
	sated_text = "奶水被挤出来后，胸口的胀痛终于舒缓下来，心里也松快了。"     // 满足成瘾时的一次性提示。
	stress_event = /datum/stressevent/vice/engorged_breasts                    // 未满足期间的心情压力事件。
	debuff = /datum/status_effect/debuff/engorged_breasts                      // 未满足期间的意志/速度减益。

	// —— "是否挤过奶"的检测状态 ——
	var/last_check = 0                                                        // 上次执行"是否挤过奶"检测的世界时间（节流用）。
	// 为什么记录"上一拍的奶量"：判定普通角色"挤过奶"的依据——只要本拍奶量比上一拍少，就是挤过了。
	var/prev_milk_stored = 0                                                  // 上一拍检测时的奶量。
	// 为什么记录"上一拍的血量 / 烧伤"：血奶角色（TRAIT_NOHUNGER）挤奶扣血（无血则加烧伤），
	//   因此用"血量下降 / 烧伤上升"判定血奶角色"挤过奶"。
	var/prev_blood_volume = 0                                                 // 上一拍检测时的血量。
	var/prev_fireloss = 0                                                     // 上一拍检测时的烧伤。
	// 为什么记录"泌乳是否由本恶习强制开启"：角色可能本就处于泌乳（如怀孕/其它效果）。
	//   只有"确实是我们开启的"才在恶习移除时关掉，避免误关玩家原本就有的泌乳状态。
	var/forced_lactation = FALSE                                              // 泌乳状态是否由本恶习强制开启。


// ----------------------------------------------------------------------------
// 构造：固定 40 分钟周期
// 为什么重写 New：基类 addiction/New() 会把 time 随机成 6~60 分钟并据此设置 next_sate。
//   涨奶的节奏必须是固定的 40 分钟，所以这里不调用基类 New（避免被随机化覆盖），
//   直接用固定的 time 设置首次满足期限。
// ----------------------------------------------------------------------------
/datum/charflaw/addiction/engorged_breasts/New()
	next_sate = world.time + time                                             // 首次 40 分钟后才需要挤奶。


// ----------------------------------------------------------------------------
// 创建钩子：恶习刚挂到角色身上时
// 为什么重写 on_mob_creation：涨奶的前提是"有乳房且处于泌乳状态"，所以这里做三件事：
//   ①若无乳房则本恶习无法生效，给玩家一句说明；②若有乳房，确保其进入泌乳
//   （lactating=TRUE）并记下"这是我们开的"；③初始化检测基准（当前奶量/血量/烧伤）。
// ----------------------------------------------------------------------------
/datum/charflaw/addiction/engorged_breasts/on_mob_creation(mob/user)
	. = ..()                                                                   // 先跑基类逻辑（当前为空实现，保留以兼容未来扩展）。

	// 为什么做类型校验：恶习理论上只挂在人类身上，on_mob_creation 形参是泛化 mob；
	//   ishuman 守门可避免对非人类执行人类专属逻辑而报错（健壮性）。
	if(!ishuman(user))                                                         // 持有者不是人类 ……
		return                                                                 // …… 直接返回，本恶习不生效。
	var/mob/living/carbon/human/H = user                                       // 取得人类引用。

	var/obj/item/organ/breasts/B = H.has_breasts()                             // 取得乳房器官（无则 null）。
	// 为什么没有乳房要明确说明：涨奶的一切机制都建立在"有乳房且能泌乳"之上；
	//   无乳房者选择此恶习等于选了空气，必须当场告知，避免玩家疑惑"为什么没效果"。
	if(!B)                                                                     // 没有乳房器官 ……
		to_chat(H, span_warning("我没有乳房，涨奶的恶习对我不起作用。"))          // …… 告知玩家本恶习无法生效。
		return                                                                 // …… 直接返回。

	// 为什么先判 !B.lactating 再开泌乳：若角色本就因怀孕/其它效果在泌乳，则不必重复开启，
	//   也不应记为我们开的（否则移除时会误关别人的泌乳）。只有"原本没在泌乳"才强制开启并标记。
	if(!B.lactating)                                                           // 原本不在泌乳 ……
		B.lactating = TRUE                                                     // …… 强制开启泌乳。
		forced_lactation = TRUE                                                // …… 记录"这是我们开启的"，移除时据此回收。

	// 初始化检测基准：记录当前奶量/血量/烧伤作为对比起点。
	prev_milk_stored = B.milk_stored                                           // 记录当前奶量作为对比基准。
	prev_blood_volume = H.get_blood_volume()                                   // 记录当前血量作为对比基准（血奶角色用）。
	prev_fireloss = H.getFireLoss()                                            // 记录当前烧伤作为对比基准（无血血奶角色用）。

	// 给玩家一段私密的"身体变化"提示，明确告知这份恶习已经生效（只有本人看得到）。
	to_chat(H, span_notice("我感到胸口沉甸甸的……身体开始止不住地泌乳。只要我定期把奶挤出来，胸口就不会胀得难受。"))


// ----------------------------------------------------------------------------
// 核心驱动：每生命 tick 的处理
// 为什么重写 flaw_on_life：这是恶习系统提供的"周期性心跳"钩子（human/life.dm 对每个非
//   ephemeral 的已装备恶习调用），是实现"到点涨奶 + 判定是否挤过奶"的标准位置。
// ----------------------------------------------------------------------------
/datum/charflaw/addiction/engorged_breasts/flaw_on_life(mob/user)
	// 为什么做类型校验：flaw_on_life 形参是泛化 mob，做一次 ishuman 守门避免对非人类报错。
	if(!ishuman(user))                                                         // 持有者不是人类 ……
		return                                                                 // …… 跳过本次处理。
	var/mob/living/carbon/human/H = user                                       // 取得人类引用。

	// 为什么死亡时不处理：对尸体计较"涨不涨奶"既无意义，也会在错误时机打扰玩家。
	if(H.stat == DEAD)                                                         // 持有者已死亡 ……
		return                                                                 // …… 跳过。

	var/obj/item/organ/breasts/B = H.has_breasts()                             // 取得乳房器官（无则 null）。
	// 为什么无乳房 / 构装体直接跳过：构装体(如金属构装/亡灵)通常没有可泌乳的乳房，
	//   也没有"涨奶"一说（与吸奶器 milk_breasts 的 construct 判定一致），一并跳过。
	if(!B || H.construct)                                                      // 没有乳房，或是构装体 ……
		return                                                                 // …… 跳过本次处理。

	// 兜底维持泌乳：理论上 on_mob_creation 已开启，但中途可能有其它系统把它关掉；
	//   涨奶是持续性缺陷，必须保证泌乳常驻，发现缺失就补回。
	if(!B.lactating)                                                           // 泌乳状态被意外关闭 ……
		B.lactating = TRUE                                                     // …… 兜底重新开启。

	// 先跑基类成瘾逻辑：到 next_sate 后进入未满足状态（压力事件 + 意志/速度减益），
	//   在 next_sate 之前则不施加任何惩罚。这是"定期挤奶即可规避 debuff"的关键。
	var/was_sated = sated                                                      // 记录调用前的满足状态，用于识别"刚进入未满足"。
	. = ..()                                                                   // 基类逻辑：计时、施加/撤销成瘾惩罚。

	// 刚进入"未满足"状态时把乳房补满，模拟"憋了 40 分钟、奶水胀满"。
	//   为什么只在普通角色上补：血奶角色（TRAIT_NOHUNGER）挤奶走血路，不依赖 milk_stored。
	//   补满后同步检测基准，避免这次"补满"影响后续的"奶量下降"判定。
	if(was_sated && !sated && !HAS_TRAIT(H, TRAIT_NOHUNGER))                   // 本 tick 刚由满足转为未满足 ……
		B.milk_stored = B.milk_max                                             // …… 把奶量补满，模拟胀奶。
		prev_milk_stored = B.milk_stored                                       // …… 同步基准，防止误判。

	// 节流：未到检测间隔就直接返回，省去频繁的判定。
	if(world.time < last_check + ENGORGEMENT_CHECK_INTERVAL)                   // 距上次检测还不到设定间隔 ……
		return                                                                 // …… 本 tick 不做实际检测。
	last_check = world.time                                                    // 记录本次检测时间，作为下次节流基准。

	// 区分体质：血奶角色（TRAIT_NOHUNGER）挤奶走"血→奶"转化路径，判定口径不同。
	var/blood_milk = HAS_TRAIT(H, TRAIT_NOHUNGER)                              // 是否"血奶"体质（无饥不死者）。

	// —— 判定"是否挤过奶"：只看数值是否下降，不设阈值 ——
	// 为什么这样判定：普通角色挤奶 = milk_stored 下降；血奶角色挤奶 = 血量下降（无血时
	//   改为烧伤上升）。不设阈值，因此胸再小（一次只挤出 1 单位）也能立刻被感知到。
	var/milked = FALSE                                                         // 本拍是否检测到"挤过奶"。
	if(!blood_milk)                                                            // 普通角色 ……
		milked = (B.milk_stored < prev_milk_stored)                            // …… 奶量下降即视为挤过。
	else                                                                       // 血奶角色 ……
		milked = (H.get_blood_volume() < prev_blood_volume) || (H.getFireLoss() > prev_fireloss) // …… 血量下降或烧伤上升即视为挤过。

	// 检测到挤奶就满足成瘾：撤销压力事件与减益、把下一次胀奶推迟 40 分钟。
	//   为什么无论当前是否 sated 都调用：基类的 sate_addiction 是幂等的，已满足时只会
	//   静默重置计时——这正好实现"提前、定期挤奶，让 debuff 永远轮不到出现"。
	if(milked)                                                                 // 本次检测到挤过奶 ……
		H.sate_addiction(/datum/charflaw/addiction/engorged_breasts)           // …… 满足成瘾（撤销惩罚 + 计时归零）。

	// 更新检测基准（放在最后，确保本次的判定结果不会污染下一次）。
	prev_milk_stored = B.milk_stored                                           // 更新奶量基准。
	prev_blood_volume = H.get_blood_volume()                                   // 更新血量基准。
	prev_fireloss = H.getFireLoss()                                            // 更新烧伤基准。


// ----------------------------------------------------------------------------
// 卸载清理：当恶习被移除时彻底善后
// 为什么重写 on_removal：成瘾基类只清理压力事件与减益，本恶习还额外"强制开启了泌乳"，
//   必须一并回收，否则会留下"恶习已没了、还在泌乳"的残留。
// 为什么只在 forced_lactation 时关闭泌乳：绝不误关玩家原本就有的泌乳（如怀孕），
//   最小副作用原则。
// ----------------------------------------------------------------------------
/datum/charflaw/addiction/engorged_breasts/on_removal(mob/user)
	. = ..()                                                                   // 先跑基类清理逻辑（移除压力事件与减益）。
	if(!ishuman(user))                                                         // 非人类无需清理。
		return
	var/mob/living/carbon/human/H = user                                       // 取得人类引用。

	// 回收"我们强制开启的泌乳"。
	if(forced_lactation)                                                       // 泌乳确实由本恶习开启 ……
		var/obj/item/organ/breasts/B = H.has_breasts()                         // 重新取得乳房器官。
		if(B && B.lactating)                                                   // 器官还在且仍在泌乳 ……
			B.lactating = FALSE                                                // …… 关闭泌乳。
		forced_lactation = FALSE                                               // 复位标记，防止重复回收。


// ============================================================================
// 心情事件定义（表现"心情变差"）
// ----------------------------------------------------------------------------
// 为什么继承 /datum/stressevent/vice：本游戏把"恶习未被满足导致的心情恶化"统一表示为
//   /datum/stressevent/vice 的子类，继承它即可复用整套"压力 -> 心情下降"的机制。
// ----------------------------------------------------------------------------
/datum/stressevent/vice/engorged_breasts
	// 为什么覆写 desc：给本压力事件一段贴合"涨奶"主题的心理独白，让玩家在心情面板里
	//   看到具体原因（胸口胀痛），而不是泛化的恶习文案。list 形式与基类一致。
	desc = list(span_boldred("我的乳房胀得发痛，奶水快要溢出来了……"), span_boldred("我得赶紧把奶挤出来。"))
	// 为什么设较长 timer：本事件由基类 flaw_on_life 在"未满足"期间反复 add_stress 续期，
	//   因此 timer 只需"略长于检测间隔"即可保证未满足期间心情持续偏低；一旦挤奶满足，
	//   sate_addiction 会立刻 remove_stress。设 2 分钟留足冗余，避免某拍漏检就瞬间掉档。
	timer = 2 MINUTES
	// 为什么 stressadd 取 4：中等强度负面心情——胀痛不适、坐立难安，但不像"饥荒/濒死"那样
	//   把人逼到崩溃，符合"涨奶"作为慢性负担的定位。
	stressadd = 4


// ----------------------------------------------------------------------------
// 状态效果减益：涨奶（意志 -1、速度 -1 的具体实现 + HUD 提示）
// 为什么继承 /datum/status_effect/debuff：debuff 基类内置 effectedstats 机制——施加时按表
//   扣减属性、移除/到期时自动精确回补（含 1~20 越界保护），是实现"可逆限时属性惩罚"的最稳方式。
// 为什么改成 -1 意志 -1 速度（而不是旧版的 -2 意志）：-2 意志叠加在其它成瘾/恶习上惩罚过重；
//   拆成意志与速度各 -1 既减轻总值，又用"步履发沉"呼应胸口坠胀的身体负担。
// ----------------------------------------------------------------------------
/datum/status_effect/debuff/engorged_breasts
	id = "engorged_breasts"                                                    // 唯一标识，用于 has_status_effect / remove_status_effect 查询。
	// 为什么设 duration 而非永久：作为兜底——即便某些极端时序下 remove 流程没跑到，减益也
	//   会自然到期。正常情况下未满足期间基类 flaw_on_life 会持续 apply 刷新（重复 apply 仅续期），
	//   挤奶满足后由 sate_addiction 立即 remove。
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/engorged_breasts  // 关联 HUD 提示图标，让玩家直观看到自己正在涨奶。
	needs_processing = FALSE                                                   // 纯属性减益，无需每 tick 处理，省开销。
	// 意志 -1、速度 -1：胀痛令人分心、难以专注（意志），胸口坠胀让人步履发沉（速度）。
	effectedstats = list(STATKEY_WIL = -1, STATKEY_SPD = -1)                   // 意志 -1、速度 -1。
	// 为什么 status_type 用刷新：未满足期间每 tick 都会重复 apply，刷新式可避免重复施加/叠层。
	status_type = STATUS_EFFECT_REFRESH

// 为什么单独定义 alert：让被影响者在 HUD 上看到一个图标与悬浮说明，明确告知"为什么心情
//   变差、属性下降"（涨奶胀痛），并提示解法（挤奶），提升机制可见性与可理解性。
/atom/movable/screen/alert/status_effect/debuff/engorged_breasts
	name = "涨奶胀痛"                                                          // HUD 悬浮标题。
	desc = "我的乳房胀得发痛，奶水快要溢出来了（心情变差、意志 -1、速度 -1）。挤奶可以缓解。" // 悬浮说明：解释惩罚原因与解法。
	icon = 'modular_z121/icon/engorged_breasts.dmi'                            // 状态效果图标：涨奶专用图标（engorged state）。
	icon_state = "engorged"                                                     // 图标态名，对应 dmi 内的 "engorged"。


// ----------------------------------------------------------------------------
// 登记：把"涨奶"加入角色定制界面的"可选恶习"列表
// 为什么需要登记：玩家在创角界面能选到的恶习来自 GLOB.character_flaws（见
//   code/datums/character_flaw/_character_flaw.dm 的 GLOBAL_LIST_INIT 与
//   code/modules/client/vices_menu.dm 的恶习选择区）。该列表是硬编码的，而我们不能修改
//   modular_z121 之外的核心文件，因此改为"运行时追加"。
// 为什么 GLOB.charflaw_singletons 无需手动登记：code/__HELPERS/global_lists.dm 会自动为
//   /datum/charflaw 的【所有子类型】建立单例（subtypesof 遍历），本恶习会被自动纳入，
//   因此只需补登"可选列表"GLOB.character_flaws 即可。
// 为什么提供独立 proc：把"登记动作"封装起来，由同在 modular_z121 内的
//   bootstrap/custom_bootstrap.dm 在其 Initialize 中调用（那是本项目的统一启动钩子，执行
//   时机晚于全局列表初始化，追加安全）。这样登记逻辑与恶习定义同处一文件、内聚清晰。
// ----------------------------------------------------------------------------
/proc/register_engorged_breasts_vice()
	// 防御式校验：确保可选恶习列表已就绪且类型正确，避免异常初始化时序下报错。
	if(!islist(GLOB.character_flaws))                                          // 可选恶习列表尚未就绪 ……
		return                                                                 // …… 放弃登记（交由后续重试/启动流程兜底）。
	// 以"显示名 -> 类型路径"的约定登记（与 vices_menu.dm 的读取方式一致）。
	GLOB.character_flaws["涨奶"] = /datum/charflaw/addiction/engorged_breasts  // 把"涨奶"登记为一个可被玩家选择的成瘾恶习。


// ----------------------------------------------------------------------------
// #undef：清理本文件定义的临时宏，避免污染全局宏命名空间（与项目其它自定义文件写法一致）。
// ----------------------------------------------------------------------------
#undef ENGORGEMENT_PERIOD
#undef ENGORGEMENT_CHECK_INTERVAL
