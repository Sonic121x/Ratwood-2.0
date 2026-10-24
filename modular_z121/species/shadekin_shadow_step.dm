// 暗影穿行使用新版目标选择与蓄力动作，仅允许闪现到阴影中的空地。

/datum/action/cooldown/spell/z121/invoked/shadow_step
	// name：能力按钮与提示中显示的名称。
	name = "暗影穿行"
	// desc：能力说明，明确"只能瞬移到阴影中"的限制，便于玩家理解失败原因。
	desc = "化身黑烟，瞬移到一片笼罩在阴影中的地块。强光之地无法落脚。"
	// primary_resource_cost：施放消耗的"耐力/魔力"释放值；设为较低值，因其为轻量级位移能力。
	primary_resource_cost = 15
	// hold_drain：蓄力期间每 tick 的持续消耗。
	hold_drain = 1
	// charge_time：蓄力时长。瞬移应当迅捷，故仅 0.5 秒。
	charge_time = 0.5 SECONDS
	// cooldown_time：冷却时间，防止无限连续瞬移。
	cooldown_time = 8 SECONDS
	// 施法资格要求人形，符合暗影裔的种族结构。
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	// spell_tier：能力强度分级，定为 1（基础种族能力）。
	spell_tier = 1
	// button_icon：按钮图标来源；复用 modular_z121 既有的自定义法术图标表，避免引入新资源。
	button_icon = 'modular_z121/icon/custompell.dmi'
	// button_icon_state：按钮覆盖状态，使用通用"闪现"覆盖样式。
	button_icon_state = "blink"
	// invocations：施放时的吟唱台词（中文主题化）。
	invocations = list("循影而行……")
	// invocation_type：吟唱方式，"whisper"低语更契合暗影刺客气质。
	invocation_type = "whisper"
	// spell_color/glow_intensity：施放时角色的微光颜色与强度，使用暗色奥术光。
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	// cast_range：可瞬移的最大格数；7 格是 RT 中一个屏幕半径量级的合理距离。
	cast_range = 7
	// miracle：是否为神迹（神职奇迹）。本能力是种族先天能力，非神迹。
	miracle = FALSE
	// sound：施放音效，使用通用瞬移音。
	sound = 'sound/magic/swap.ogg'
	// 阴影阈值：目标地块光照值(0=全暗,1=全亮)必须 < 此值才允许落脚，实现"只能瞬移进阴影"。
	var/shadow_threshold = 0.5

// 为什么覆盖 cast：这里实现真正的瞬移逻辑与全部错误处理。targets[1] 是玩家点中的目标 atom。
/datum/action/cooldown/spell/z121/invoked/shadow_step/z121_apply(atom/cast_on)
	var/list/targets = list(cast_on)
	var/mob/living/user = owner
	// 错误处理①：无目标（点空/越界）。回滚施放并提示。
	if(!length(targets) || !targets[1])
		to_chat(user, span_warning("我没有锁定任何落脚之处。"))
		z121_cancel()
		return FALSE

	// 取被点中目标所在地块作为目标地块（无论点中的是地块还是地块上的物体）。
	var/turf/target_turf = get_turf(targets[1])
	// 取施法者当前地块，用于距离与有效性校验。
	var/turf/user_turf = get_turf(user)

	// 错误处理②：地块解析失败（目标或自身不在任何地块上，如处于异常容器中）。
	if(!isturf(target_turf) || !isturf(user_turf))
		to_chat(user, span_warning("此地的阴影太过混乱，无法穿行。"))
		z121_cancel()
		return FALSE

	// 错误处理③：超出射程。invoked 基类通常已限制点选范围，这里再次校验以防绕过。
	if(get_dist(user_turf, target_turf) > cast_range)
		to_chat(user, span_warning("那片阴影太遥远了，我无法企及。"))
		z121_cancel()
		return FALSE

	// 错误处理④：目标地块为实心（墙/封闭地块），无法落脚，否则会卡进墙体。
	if(target_turf.density)
		to_chat(user, span_warning("我无法穿行到坚实的障碍物之中。"))
		z121_cancel()
		return FALSE

	// 错误处理⑤：目标地块被标记为禁止瞬移（地图/事件保护区）。
	if(target_turf.teleport_restricted)
		to_chat(user, span_warning("一股力量阻止我闪现到那里。"))
		z121_cancel()
		return FALSE

	// 错误处理⑥：核心机制——目标必须处于阴影中。光照过亮则拒绝，体现"暗影裔只能遁入阴影"。
	if(target_turf.get_lumcount() >= shadow_threshold)
		to_chat(user, span_warning("那里光线太亮，没有足够的阴影供我藏身。"))
		z121_cancel()
		return FALSE

	// 错误处理⑦：反魔法检查。若施法者受反魔法压制则瞬移失败（do 'self' 检查自身携带的反魔法）。
	if(user.anti_magic_check(magic = TRUE, self = TRUE))
		to_chat(user, span_warning("一股反魔法的力量扼住了我的暗影之力。"))
		z121_cancel()
		return FALSE

	// 若施法者被固定（绑在床/椅等），先解除固定再瞬移，避免位移异常。
	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)

	// 在出发地块生成"消散"特效，并播放音效——表现化为黑烟离开。
	new /obj/effect/temp_visual/wizard/out(user_turf)
	playsound(user_turf, sound, 50, TRUE)

	// 执行真正的瞬移：走 RT 的 do_teleport 标准管线（带魔法频道，便于被反瞬移/反魔法系统拦截）。
	// 若失败（被某系统拦截）则回滚并提示，确保不会"消耗冷却却没动"。
	if(!do_teleport(user, target_turf, forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC))
		to_chat(user, span_warning("暗影穿行失败了，某种力量将我挡了回来。"))
		z121_cancel()
		return FALSE

	// 在落脚地块生成"现身"特效并再次播放音效——表现自阴影中重新凝聚。
	new /obj/effect/temp_visual/wizard(target_turf)
	playsound(target_turf, sound, 50, TRUE)

	// 给出旁观与自身的反馈文本，强化"鬼魅般闪现"的观感。
	user.visible_message(
		span_warning("[user] 的身形骤然化作一缕黑烟，转瞬间消失，又在不远处的阴影中重新凝聚！"),
		span_notice("我循着阴影的脉络穿行，于幽暗之间重现身形。"),
	)
	// 返回 TRUE 表示施放成功，由基类据此进入冷却。
	return TRUE
