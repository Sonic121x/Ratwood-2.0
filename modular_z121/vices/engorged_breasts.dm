// ============================================================================
// modular_z121/vices/engorged_breasts.dm
// 自定义恶习（Custom Vice / 恶习）：涨奶 / Milk Engorgement
// ----------------------------------------------------------------------------
// 需求（为什么要做这个文件）：
//   实现一个全新的"涨奶（Milk Engorgement）"恶习，核心设定为：
//     "拥有此恶习的人每搁 40 分钟就需要挤一次奶，否则胸口胀痛、心情变差。"
//   即——拥有此恶习的角色会【持续泌乳】，每 40 分钟胸口必然胀满一次（心情 debuff + 意志 -2）；
//   只有及时把奶挤出来（用吸奶器、挤进容器、或被人吸出），胀痛才会缓解、心情恢复，
//   并且计时归零、40 分钟后再来一轮。
//
// 为什么这是一个"恶习（Vice）"而不是"美德（Virtue）"：
//   本游戏里玩家可选的"恶习/缺陷"是 /datum/charflaw 的子类（见
//   code/datums/character_flaw/_character_flaw.dm 与角色定制菜单
//   code/modules/client/vices_menu.dm 中的"恶习选择"区域）；/datum/virtue 是另一套
//   "美德"系统。需求要的是"Vice（恶习）"，故本恶习实现为 /datum/charflaw 的子类型。
//
// 合规性说明（为什么所有逻辑都放在本文件内）：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何
//   文件。本文件通过"继承已有基类、追加子类型 / 追加运行时登记"的方式接入引擎（属于
//   "追加"而非"修改"核心文件），不改动 modular_z121 之外的任何源文件。唯一需要触碰的
//   另一处是同在 modular_z121 内的 bootstrap/custom_bootstrap.dm，用于把本恶习登记进
//   "可选恶习列表"，详见文件末尾的登记说明。
//
// 为什么改成"固定 40 分钟定时"而非"按奶量阈值判定"：
//   旧实现靠"乳房当前奶量 milk_stored 是否涨到 80% 容量"触发涨奶、靠"奶量是否被挤回
//   40% 容量以下"判定缓解。这套"看奶量阈值"的做法有两个无法自愈的 bug：
//     · 胸太小：容量 milk_max = max(75, 罩杯*100) 很小，奶量很快填满；但一次手挤只能
//       挤出 max(罩杯,1) 单位、且旧实现每拍还在补奶，想把奶量压到 40% 以下十分困难，
//       于是 debuff 长时间解不掉。
//     · 血奶特质（TRAIT_NOHUNGER，如吸血鬼/亡灵等不死者）：这类角色的挤奶走"血→奶"
//       转化路径（milking.dm 的 try_blood_milking / 吸奶器的 milk_blood），根本不扣
//       milk_stored，奶量永远降不下去，debuff 也就永远解不掉。
//   因此改为【纯时间驱动】：每 40 分钟必触发一次涨奶；"挤没挤奶"只看"奶量有没有下降"
//   （血奶角色改看"血量有没有下降 / 烧伤有没有上升"），与容量大小、挤奶路径完全解耦，
//   上面两种 bug 一并消除。
//
// 为什么"是否挤过奶"这样判定（不再 hook 挤奶代码）：
//   · 普通角色：只要检测周期内 milk_stored 下降了，就认为挤过奶——游戏里一切挤奶手段
//     （手持容器挤奶 try_milking、吸奶器 milk_breasts、吸乳 suck_nipples）最终都只会做
//     同一件事：把 breasts.milk_stored 往下减。所以只需周期读 milk_stored 对比上一拍即可。
//   · 血奶角色（TRAIT_NOHUNGER）：挤奶扣的是 blood_volume（无血时改为烧伤 fireloss），
//     所以改看血量下降 / 烧伤上升。
//   判定只做"是否下降"，不设任何阈值——胸再小（一次只挤出 1 单位）也能立刻被感知到。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/charflaw                      恶习基类，提供 on_mob_creation/flaw_on_life/on_removal 钩子。
//   - /obj/item/organ/breasts              乳房器官（code/modules/surgery/organs/feature_organs/genitals.dm），
//                                           持有 lactating / milk_stored / milk_max 三个关键字段。
//   - /mob/living/carbon/human/has_breasts()  取乳房器官（无则返回 null，见 human.dm）。
//   - /datum/stressevent/vice              恶习类压力事件基类（code/datums/stress/negative_events.dm），表现心情变差。
//   - add_stress / remove_stress           压力事件的施加 / 移除接口（可安全重复调用）。
//   - /datum/status_effect/debuff          减益状态效果基类（含 effectedstats 自动加减属性 + HUD alert）。
//   - apply_status_effect / remove_status_effect  状态效果接口。
//   - STATKEY_WIL                          意志属性键（code/__DEFINES/mobs.dm）。
//   - GLOB.character_flaws                 角色定制界面"可选恶习"列表（用于登记本恶习）。
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
//   周期性地做"是否该涨奶 / 是否挤过奶"的判定。5 秒一次既让"挤奶→缓解"的反馈足够灵敏
//   （挤奶动作本身通常持续数秒），又不造成性能负担。
#define ENGORGEMENT_CHECK_INTERVAL (5 SECONDS)
// 为什么设"提醒冷却 = 2 分钟"：涨奶期间每隔约 2 分钟在右下角聊天框发一条身体不适的提示，
//   提醒玩家"该挤奶了"，又不至于每 5 秒检测一次就刷一条、把聊天框刷爆。
#define ENGORGEMENT_REMINDER_COOLDOWN (2 MINUTES)


// ----------------------------------------------------------------------------
// 恶习定义：涨奶（Milk Engorgement）
// 为什么直接继承 /datum/charflaw：涨奶是一种"被动持续生效"的性格缺陷——强迫泌乳、
//   靠 flaw_on_life 周期定时并判定是否挤过奶即可驱动全部逻辑，不需要主动技能/读条，
//   因此最基础的 /datum/charflaw 父类就足够。
// ----------------------------------------------------------------------------
/datum/charflaw/engorged_breasts
	name = "涨奶"                                                              // 角色定制菜单中显示的恶习名（Milk Engorgement）。
	// 为什么这样写描述：用第一人称讲清硬性机制——我会一直泌乳、每隔约 40 分钟胸口就胀满；
	//   不及时挤奶就会胀痛、心情变差。
	desc = "我的身体总在源源不断地泌乳，每隔一段时间胸口就会胀满发痛、心情低落。\
			只有及时把奶挤出来才能缓解，否则这份胀痛会一直缠着我。"

	// —— 周期性逻辑的节流与状态 ——
	var/last_check = 0                                                        // 上次执行"定时 / 判定挤奶"的世界时间（节流用）。
	// 为什么记录"下一次该涨奶的时间"：本恶习是纯时间驱动，用 next_engorge 记下一轮
	//   胀奶的时间戳；世界时间走到它即为"该挤奶了"。挤奶缓解后把它重置为 now+周期。
	var/next_engorge = 0                                                      // 下一次"该涨奶"的世界时间。
	// 为什么记录"当前是否涨奶"：用于区分"等待下一轮胀奶"与"正在胀奶、等挤奶缓解"两种状态。
	var/engorged = FALSE                                                      // 当前是否处于涨奶状态。
	// 为什么记录"上一拍的奶量"：判定普通角色"挤过奶"的依据——只要本拍奶量比上一拍少，就是挤过了。
	var/prev_milk_stored = 0                                                  // 上一拍检测时的奶量。
	// 为什么记录"上一拍的血量 / 烧伤"：血奶角色（TRAIT_NOHUNGER）挤奶扣血（无血则加烧伤），
	//   因此用"血量下降 / 烧伤上升"判定血奶角色"挤过奶"。
	var/prev_blood_volume = 0                                                 // 上一拍检测时的血量。
	var/prev_fireloss = 0                                                     // 上一拍检测时的烧伤。
	// 为什么记录"下次可发提醒的时间"：涨奶期间要周期性在右下角聊天框提醒玩家，但不能每次检测
	//   都发（会刷屏）；用独立冷却时间戳控制频率，约 2 分钟提醒一次。
	var/next_reminder = 0                                                     // 下一次允许在聊天框发"涨奶提醒"的世界时间。
	// 为什么记录"泌乳是否由本恶习强制开启"：角色可能本就处于泌乳（如怀孕/其它效果）。
	//   只有"确实是我们开启的"才在恶习移除时关掉，避免误关玩家原本就有的泌乳状态。
	var/forced_lactation = FALSE                                              // 泌乳状态是否由本恶习强制开启。


// ----------------------------------------------------------------------------
// 创建钩子：恶习刚挂到角色身上时
// 为什么重写 on_mob_creation：这是"恶习上身即刻生效"的标准入口。涨奶的前提是"有乳房且
//   处于泌乳状态"，所以这里做三件事：①若无乳房则本恶习无法生效，给玩家一句说明；
//   ②若有乳房，确保其进入泌乳（lactating=TRUE）并记下"这是我们开的"；③初始化定时与
//   检测基准（下一轮胀奶时间、当前奶量/血量/烧伤）。
// ----------------------------------------------------------------------------
/datum/charflaw/engorged_breasts/on_mob_creation(mob/user)
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

	// 初始化时间戳与检测基准：下一轮胀奶 = 现在 + 40 分钟；并记录当前奶量/血量/烧伤作为对比起点。
	next_engorge = world.time + ENGORGEMENT_PERIOD                             // 40 分钟后首次需要挤奶。
	prev_milk_stored = B.milk_stored                                           // 记录当前奶量作为对比基准。
	prev_blood_volume = H.get_blood_volume()                                         // 记录当前血量作为对比基准（血奶角色用）。
	prev_fireloss = H.getFireLoss()                                            // 记录当前烧伤作为对比基准（无血血奶角色用）。

	// 给玩家一段私密的"身体变化"提示，明确告知这份恶习已经生效（只有本人看得到）。
	to_chat(H, span_notice("我感到胸口沉甸甸的……身体开始止不住地泌乳。我得记住每隔一段时间就把奶挤出来，否则胸口会胀得难受。"))


// ----------------------------------------------------------------------------
// 核心驱动：每生命 tick 的处理
// 为什么重写 flaw_on_life：这是恶习系统提供的"周期性心跳"钩子（human/life.dm 对每个非
//   ephemeral 的已装备恶习调用），是实现"定时胀奶 + 判定是否挤过奶"的标准位置。
// ----------------------------------------------------------------------------
/datum/charflaw/engorged_breasts/flaw_on_life(mob/user)
	. = ..()                                                                   // 先跑基类逻辑。

	// 为什么做类型校验：flaw_on_life 形参是泛化 mob，做一次 ishuman 守门避免对非人类报错。
	if(!ishuman(user))                                                         // 持有者不是人类 ……
		return                                                                 // …… 跳过本次处理。
	var/mob/living/carbon/human/H = user                                       // 取得人类引用。

	// 为什么死亡时不处理：对尸体计较"涨不涨奶"既无意义，也会在错误时机打扰玩家。
	//   直接跳过，待其复活/转生后自然恢复处理。
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

	if(engorged)                                                               // —— 状态 A：当前正在涨奶 ——
		if(milked)                                                             // 本拍挤过奶 ……
			to_chat(H, span_notice("奶水被挤出来后，胸口的胀痛终于舒缓下来，心里也松快了。")) // 挤奶缓解时提示一次。
			clear_engorgement(H)                                               // …… 解除心情 debuff + 意志减益。
			engorged = FALSE                                                   // …… 退出涨奶状态。
			next_engorge = world.time + ENGORGEMENT_PERIOD                     // …… 计时归零，40 分钟后再来一轮。
		else                                                                   // 还没挤 ……
			apply_engorgement(H)                                               // …… 继续维持 / 刷新惩罚与提醒。
	else if(world.time >= next_engorge)                                        // —— 状态 B：还没涨奶，但已到时间 ——
		// 触发涨奶：普通角色补满奶量（保证有奶可挤）；血奶角色挤奶走血路、不依赖奶量，无需补奶。
		if(!blood_milk)                                                        // 普通角色 ……
			B.milk_stored = B.milk_max                                         // …… 把奶量补满，模拟"胀满"。
		engorged = TRUE                                                        // 进入涨奶状态。
		to_chat(H, span_warning("我的胸口胀得厉害……乳房又沉又痛，奶水快要溢出来了。得赶紧把奶挤出来。")) // 刚涨奶时提示一次。
		next_reminder = world.time + ENGORGEMENT_REMINDER_COOLDOWN             // 从此刻起隔一个冷却期再发周期性提醒，避免与刚涨奶的提示叠在一起。
		apply_engorgement(H)                                                   // 施加心情 debuff + 意志减益。

	// 更新检测基准（放在最后，确保本拍"补满奶量"不会被误判成下一拍的"挤过奶"）。
	prev_milk_stored = B.milk_stored                                           // 更新奶量基准。
	prev_blood_volume = H.get_blood_volume()                                         // 更新血量基准。
	prev_fireloss = H.getFireLoss()                                            // 更新烧伤基准。


// ----------------------------------------------------------------------------
// 施加 / 刷新涨奶惩罚：心情变差 + 意志 -2
// 为什么单独成 proc：把"施加惩罚"与"主流程/检测"解耦，逻辑清晰、便于复用与维护。
// 为什么可以反复调用：压力事件与状态效果都被设计为"可刷新"（add_stress 续期、debuff 的
//   重复 apply 仅续期），即便每次检测都调用本 proc 也不会叠加成多份惩罚，只会续期。
// ----------------------------------------------------------------------------
/datum/charflaw/engorged_breasts/proc/apply_engorgement(mob/living/carbon/human/H)
	if(!istype(H))                                                             // 防御式校验：无效持有者直接返回。
		return

	// 为什么用 add_stress：这是本游戏表现"心情/情绪恶化"的标准系统；恶习类压力事件
	//   /datum/stressevent/vice/engorged_breasts 会拉低心情，重复调用只续期不叠加。
	H.add_stress(/datum/stressevent/vice/engorged_breasts)                    // 施加 / 续期"涨奶"压力事件（心情变差）。

	// 意志 -2 减益（附带 HUD 提示）。为什么用 status_effect/debuff + effectedstats：
	//   与洁癖恶习同理——可逆的限时属性惩罚，涨奶时施加、挤奶缓解时由 clear 精确回收，
	//   且有 1~20 越界保护。重复 apply 只续期、不叠加多层 -2。
	H.apply_status_effect(/datum/status_effect/debuff/engorged_breasts)       // 施加 / 刷新意志 -2 减益。

	// 周期性提醒：涨奶持续期间，每隔约 2 分钟在右下角聊天框发一条身体不适的提示，
	// 强化"该挤奶了"的压迫感。为什么用 pick 随机句式：避免每次都一模一样、显得机械。
	if(world.time >= next_reminder)                                            // 已到下一次提醒时间 ……
		next_reminder = world.time + ENGORGEMENT_REMINDER_COOLDOWN             // …… 重置下一次提醒时间。
		to_chat(H, span_warning(pick(list(
			"胸口的胀痛一阵阵传来，奶水还在止不住地积攒，再不挤出来怕是要溢了……",
			"乳房沉甸甸地坠着，稍微一动就胀得发疼，我必须找个地方把奶挤出来。",
			"胀满的乳汁压得我坐立难安，胸前的衣料似乎都快要被打湿了……",
			"奶水在胸口越积越多，涨得我呼吸都不太顺畅，得赶紧挤掉才行。",
		))))


// ----------------------------------------------------------------------------
// 解除惩罚：恢复心情与意志
// 为什么单独成 proc：与施加惩罚对称，保证"挤奶缓解"时能干净彻底地撤销所有惩罚。
// 为什么调用方可无脑调用：remove_stress / remove_status_effect 对"本就不存在"的目标调用
//   是安全的（无副作用），因此即使一直没涨奶也可放心调用。
// ----------------------------------------------------------------------------
/datum/charflaw/engorged_breasts/proc/clear_engorgement(mob/living/carbon/human/H)
	if(!istype(H))                                                             // 防御式校验：无效持有者直接返回。
		return

	H.remove_stress(/datum/stressevent/vice/engorged_breasts)                 // 移除心情惩罚（对不存在的事件调用也安全）。
	H.remove_status_effect(/datum/status_effect/debuff/engorged_breasts)      // 移除意志减益（属性自动回正）。


// ----------------------------------------------------------------------------
// 卸载清理：当恶习被移除时彻底善后
// 为什么重写 on_removal：恶习可能中途被移除（管理员操作、转生等），此时必须撤销本恶习
//   施加的持续效果（压力事件 + 状态减益），并回收"我们强制开启的泌乳"，否则会留下
//   "恶习已没了、惩罚还在"的残留，污染玩家状态。
// 为什么只在 forced_lactation 时关闭泌乳：绝不误关玩家原本就有的泌乳（如怀孕），
//   最小副作用原则。
// ----------------------------------------------------------------------------
/datum/charflaw/engorged_breasts/on_removal(mob/user)
	. = ..()                                                                   // 先跑基类清理逻辑。
	if(!ishuman(user))                                                         // 非人类无需清理。
		return
	var/mob/living/carbon/human/H = user                                       // 取得人类引用。

	clear_engorgement(H)                                                       // 移除心情惩罚与意志减益，干净善后。

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
	// 为什么设较长 timer：本事件由 flaw_on_life 在"持续涨奶"期间反复 add_stress 续期，
	//   因此 timer 只需"略长于检测间隔"即可保证涨奶期间心情持续偏低；一旦挤奶缓解，
	//   clear 流程会立刻 remove_stress。设 2 分钟留足冗余，避免某拍漏检就瞬间掉档。
	timer = 2 MINUTES
	// 为什么 stressadd 取 4：中等强度负面心情——胀痛不适、坐立难安，但不像"饥荒/濒死"那样
	//   把人逼到崩溃，符合"涨奶"作为慢性负担的定位。
	stressadd = 4


// ----------------------------------------------------------------------------
// 状态效果减益：涨奶（意志 -2 的具体实现 + HUD 提示）
// 为什么继承 /datum/status_effect/debuff：debuff 基类内置 effectedstats 机制——施加时按表
//   扣减属性、移除/到期时自动精确回补（含 1~20 越界保护），是实现"可逆限时属性惩罚"的最稳方式。
// ----------------------------------------------------------------------------
/datum/status_effect/debuff/engorged_breasts
	id = "engorged_breasts"                                                    // 唯一标识，用于 has_status_effect / remove_status_effect 查询。
	// 为什么设 duration 而非永久：作为兜底——即便某些极端时序下 clear 流程没跑到，减益也
	//   会自然到期。正常情况下涨奶期间 flaw_on_life 会持续 apply 刷新（重复 apply 仅续期），
	//   挤奶缓解后立即被 remove。
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/engorged_breasts  // 关联 HUD 提示图标，让玩家直观看到自己正在涨奶。
	needs_processing = FALSE                                                   // 纯属性减益，无需每 tick 处理，省开销。
	// 为什么只减意志 -2：涨奶的持续胀痛令人分心、难以专注，体现为意志 -2；不附加其它属性
	//   变动，保证机制克制。effectedstats 的负值会被基类自动施加与回收。
	effectedstats = list(STATKEY_WIL = -2)                                     // 意志 -2（Willpower -2）。

// 为什么单独定义 alert：让被影响者在 HUD 上看到一个图标与悬浮说明，明确告知"为什么心情
//   变差、意志下降"（涨奶胀痛），并提示解法（挤奶），提升机制可见性与可理解性。
/atom/movable/screen/alert/status_effect/debuff/engorged_breasts
	name = "涨奶胀痛"                                                          // HUD 悬浮标题。
	desc = "我的乳房胀得发痛，奶水快要溢出来了（心情变差、意志 -2）。挤奶可以缓解。" // 悬浮说明：解释惩罚原因与解法。
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
	GLOB.character_flaws["涨奶"] = /datum/charflaw/engorged_breasts           // 把"涨奶"登记为一个可被玩家选择的恶习。


// ----------------------------------------------------------------------------
// #undef：清理本文件定义的临时宏，避免污染全局宏命名空间（与项目其它自定义文件写法一致）。
// ----------------------------------------------------------------------------
#undef ENGORGEMENT_PERIOD
#undef ENGORGEMENT_CHECK_INTERVAL
#undef ENGORGEMENT_REMINDER_COOLDOWN
