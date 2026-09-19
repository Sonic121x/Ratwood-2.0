// 超魔只改变一次奥术施放；额度属于人物，倍率随该次法术的效果传递。
#define Z121_META_SILENT "谨慎施法"
#define Z121_META_QUICK "反射施法"
#define Z121_META_POWER "强效施法"
#define Z121_META_EXTEND "延长施法"

/datum/virtue/combat/metamagic
	name = "超魔专长（-16）"
	desc = "咒文于你，早已不是不可更易的律令。在诺克垂照的长夜里，你听见了音节之间的寂静，也窥见了符文尚未闭合的缝隙。如今，你能将咒言藏入心念，催促迟滞的魔力，或让将散的余韵久久徘徊。只是凡人的心神，终究承不起无休止的改写。"
	triumph_cost = 16
	custom_text = "获得 IC 指令【超魔专长】：持续开启一种超魔。谨慎施法免除念咒，反射施法使引导减半，强效施法使伤害与数值治疗翻倍，延长施法使有限持续效果翻倍。仅影响掌握的法师奥术。四种超魔共享每日额度，上限等于当前奥术等级；游戏清晨恢复并关闭模式。成功施放适用法术扣一次，中断、取消、失败或不适用不扣次数。"

/datum/virtue/combat/metamagic/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(istype(recipient))
		recipient.AddComponent(/datum/component/z121_metamagic)

/datum/component/z121_metamagic
	// 重复授予直接复用已有组件，不能创建会在销毁时移除人物指令的临时组件。
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/mode
	var/used = 0
	var/day_serial = 0
	var/last_dawn_day
	var/datum/z121_metamagic_cast/pending

/datum/component/z121_metamagic/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	last_dawn_day = GLOB.dayspassed

/datum/component/z121_metamagic/RegisterWithParent()
	. = ..()
	var/mob/living/carbon/human/host = parent
	ensure_menu_verb()
	RegisterSignal(host, COMSIG_MOB_DAWNED, PROC_REF(on_dawn))
	RegisterSignal(host, COMSIG_MOB_LOGIN, PROC_REF(on_login))
	ADD_TRAIT(host, "超魔专长", REF(src))
	GLOB.roguetraits["超魔专长"] = span_info("我能改写奥术的吟唱、引导、威力或余韵。IC 中的超魔专长指令可选择方式并查看今日余力。")

/datum/component/z121_metamagic/Destroy(force = FALSE, silent = FALSE)
	// 人物销毁时组件可能被强制清理，仍须释放尚未完成的施法预留。
	if(pending)
		pending.finish(FALSE)
		pending = null
	return ..()

/datum/component/z121_metamagic/UnregisterFromParent()
	if(pending)
		pending.finish(FALSE)
	if(parent)
		var/mob/host = parent
		// 已有另一份有效组件接管时，不能移除它仍然需要的共享指令。
		if(!host.GetComponent(/datum/component/z121_metamagic))
			host.verbs -= /mob/living/carbon/human/proc/z121_metamagic_menu
		REMOVE_TRAIT(host, "超魔专长", REF(src))
		UnregisterSignal(host, list(COMSIG_MOB_DAWNED, COMSIG_MOB_LOGIN))
	return ..()

/datum/component/z121_metamagic/InheritComponent(datum/component/new_component, i_am_original)
	. = ..()
	if(i_am_original)
		ensure_menu_verb()

/datum/component/z121_metamagic/proc/ensure_menu_verb()
	if(QDELETED(parent))
		return
	var/mob/living/carbon/human/host = parent
	var/menu_verb = /mob/living/carbon/human/proc/z121_metamagic_menu
	// 使用项目主动能力既有的添加方式，只修复指令，不触碰模式与每日消耗。
	if(!(menu_verb in host.verbs))
		host.verbs += menu_verb

/datum/component/z121_metamagic/proc/on_login()
	SIGNAL_HANDLER
	// 开局接管身体或断线重连后补齐入口，人物原有额度保持不变。
	ensure_menu_verb()

/datum/component/z121_metamagic/proc/remaining()
	var/mob/living/host = parent
	return max(0, clamp(host.get_skill_level(/datum/skill/magic/arcane), 0, 6) - used - (pending && pending.day_serial == day_serial ? 1 : 0))

/datum/component/z121_metamagic/proc/on_dawn()
	SIGNAL_HANDLER
	if(last_dawn_day == GLOB.dayspassed)
		return
	last_dawn_day = GLOB.dayspassed
	day_serial++
	used = 0
	mode = null
	to_chat(parent, span_notice("晨光拂去心神的倦意。我的超魔余力已经恢复，须重新选择要编织的手法。"))

/datum/component/z121_metamagic/proc/select_mode()
	var/mob/living/carbon/human/host = parent
	if(!pending && !remaining())
		mode = null
	if(pending)
		to_chat(host, span_warning("我须先完成或中断眼下的施法，才能更换超魔手法。"))
		return
	var/choice = input(host, "当前：[mode || "关闭"]\n今日剩余：[remaining()] / [clamp(host.get_skill_level(/datum/skill/magic/arcane), 0, 6)]\n谨慎施法：免除发声与念咒。\n反射施法：实际引导时间减半。\n强效施法：伤害与数值治疗翻倍。\n延长施法：有限持续效果翻倍。\n四种方式共享每日额度，清晨恢复后须重新开启。\n无适用效果的法术仍按普通方式施放，不消耗超魔次数。", "超魔专长") as null|anything in list("关闭", Z121_META_SILENT, Z121_META_QUICK, Z121_META_POWER, Z121_META_EXTEND)
	if(!choice || QDELETED(src) || QDELETED(host) || pending)
		return
	if(choice != "关闭" && !remaining())
		mode = null
		to_chat(host, span_warning("我的奥术造诣或今日余力尚不足以改写咒文。"))
		return
	mode = choice == "关闭" ? null : choice
	// 已选中的鼠标施法意图缓存了引导时间和吟唱音，切换时同步缓存。
	var/obj/effect/proc_holder/spell/spell = host.ranged_ability
	if(istype(spell))
		spell.z121_sync_intent(host)
	to_chat(host, span_notice("超魔专长：[mode || "关闭"]。今日剩余 [remaining()] 次。"))

/mob/living/carbon/human/proc/z121_metamagic_menu()
	set name = "超魔专长"
	set category = "IC"
	set hidden = FALSE
	var/datum/component/z121_metamagic/controller = GetComponent(/datum/component/z121_metamagic)
	controller?.select_mode()

/datum/z121_metamagic_cast
	var/datum/component/z121_metamagic/controller
	var/obj/effect/proc_holder/spell/spell
	var/mob/living/caster
	var/mode
	var/day_serial
	var/finished = FALSE
	var/executing = FALSE
	var/deferred = FALSE
	var/applied = FALSE
	var/failed = FALSE

/datum/z121_metamagic_cast/New(datum/component/z121_metamagic/new_controller, obj/effect/proc_holder/spell/new_spell, mob/living/new_caster)
	controller = new_controller
	spell = new_spell
	caster = new_caster
	mode = controller.mode
	day_serial = controller.day_serial
	controller.pending = src
	spell.z121_metamagic_cast = src

/datum/z121_metamagic_cast/proc/finish(success)
	if(finished)
		return
	success = success && !failed
	finished = TRUE
	if(controller && !QDELETED(controller))
		if(success && applied && day_serial == controller.day_serial)
			controller.used++
		if(controller.pending == src)
			controller.pending = null
		if(!controller.remaining())
			controller.mode = null
		if(success && applied && !QDELETED(caster))
			to_chat(caster, span_notice("[mode]已随咒文成形。今日超魔剩余 [controller.remaining()] 次。"))
	if(spell && !QDELETED(spell))
		if(spell.z121_metamagic_cast == src)
			spell.z121_metamagic_cast = null
		spell.z121_meta_power = 1
		spell.z121_meta_duration = 1
		spell.z121_sync_intent(caster)
	controller = null
	spell = null
	caster = null
	qdel(src)

// 效果实例只携带倍率，不依赖施法者之后的模式、技能或剩余次数。
/datum
	var/z121_meta_power = 1
	var/z121_meta_duration = 1

/datum/proc/z121_power(amount)
	return amount * z121_meta_power

/datum/proc/z121_duration(amount)
	return amount > 0 ? amount * z121_meta_duration : amount

/obj/effect/proc_holder/spell
	var/datum/z121_metamagic_cast/z121_metamagic_cast
	var/z121_meta_has_power = FALSE
	var/z121_meta_has_duration = FALSE
	var/z121_meta_custom_channel = FALSE

/obj/effect/proc_holder/spell/proc/z121_is_arcane(mob/living/user)
	if(!user?.mind || !(src in user.mind.spell_list) || miracle || associated_skill != /datum/skill/magic/arcane)
		return FALSE
	// 精确登记学习目录，避免把继承了默认奥术技能的种族或物品能力也算作法术。
	return (type in GLOB.learnable_spells) || (type in GLOB.custom_learnable_spells) || istype(src, /obj/effect/proc_holder/spell/targeted/touch/prestidigitation) || type == /obj/effect/proc_holder/spell/invoked/heal_pristine/greater || type == /obj/effect/proc_holder/spell/self/harmless_dismemberment_select

/obj/effect/proc_holder/spell/proc/z121_mode(mob/living/user)
	if(z121_metamagic_cast && !z121_metamagic_cast.finished)
		return z121_metamagic_cast.mode
	if(!z121_is_arcane(user))
		return null
	var/datum/component/z121_metamagic/controller = user.GetComponent(/datum/component/z121_metamagic)
	if(QDELETED(controller) || controller.pending)
		return null
	if(!controller.remaining())
		controller.mode = null
		return null
	return controller.mode

/obj/effect/proc_holder/spell/proc/z121_supports(mode)
	switch(mode)
		if(Z121_META_SILENT)
			return invocation_type == "shout" || invocation_type == "whisper" || length(charge_invocation)
		if(Z121_META_QUICK)
			return chargetime > 0 || z121_meta_custom_channel
		if(Z121_META_POWER)
			return z121_meta_has_power
		if(Z121_META_EXTEND)
			return z121_meta_has_duration
	return FALSE

/obj/effect/proc_holder/spell/proc/z121_begin(mob/living/user)
	if(z121_metamagic_cast)
		return z121_metamagic_cast
	var/selected_mode = z121_mode(user)
	if(!z121_supports(selected_mode))
		return null
	var/datum/component/z121_metamagic/controller = user.GetComponent(/datum/component/z121_metamagic)
	var/datum/z121_metamagic_cast/casting = new(controller, src, user)
	z121_meta_power = selected_mode == Z121_META_POWER ? 2 : 1
	z121_meta_duration = selected_mode == Z121_META_EXTEND ? 2 : 1
	return casting

/obj/effect/proc_holder/spell/proc/z121_silent(mob/living/user)
	return z121_mode(user) == Z121_META_SILENT && (z121_metamagic_cast || z121_supports(Z121_META_SILENT))

/obj/effect/proc_holder/spell/proc/z121_channel(amount, mob/living/user)
	if(z121_mode(user) == Z121_META_QUICK && amount > 0)
		if(z121_metamagic_cast)
			z121_metamagic_cast.applied = TRUE
		return amount * 0.5
	return amount

/obj/effect/proc_holder/spell/proc/z121_sync_intent(mob/living/user)
	if(QDELETED(user) || user.ranged_ability != src || !istype(user.mmb_intent, /datum/intent/spell))
		return
	user.mmb_intent.chargetime = get_chargetime()
	user.mmb_intent.charge_invocation = z121_silent(user) ? null : charge_invocation
	// 只抑制吟唱循环，风声等非人声法术音效仍然保留。
	var/vocal_loop = chargedloop in list(/datum/looping_sound/invokegen, /datum/looping_sound/invokefire, /datum/looping_sound/invokelightning, /datum/looping_sound/invokeascendant)
	var/wanted_loop = z121_silent(user) && vocal_loop ? null : chargedloop
	var/datum/looping_sound/old_loop = user.mmb_intent.chargedloop
	if(istype(old_loop) && old_loop.type != wanted_loop)
		if(user.curplaying == user.mmb_intent)
			user.curplaying.on_mouse_up()
		qdel(old_loop)
		user.mmb_intent.chargedloop = wanted_loop
	else if(!istype(old_loop))
		user.mmb_intent.chargedloop = wanted_loop
	user.mmb_intent.update_chargeloop()

// 在检查入口短暂移除发声要求，而不改变人物的哑巴特性或其他施法限制。
/obj/effect/proc_holder/spell/can_cast(mob/user = usr)
	if(z121_metamagic_cast && z121_metamagic_cast.caster != user)
		return FALSE
	var/old_invocation = invocation_type
	if(z121_silent(user))
		invocation_type = "none"
	. = ..()
	invocation_type = old_invocation

/obj/effect/proc_holder/spell/cast_check(skipcharge, mob/user = usr)
	if(z121_metamagic_cast && z121_metamagic_cast.caster != user)
		return FALSE
	var/old_invocation = invocation_type
	if(z121_silent(user))
		invocation_type = "none"
	. = ..()
	invocation_type = old_invocation

/obj/effect/proc_holder/spell/invocation(mob/user = usr)
	if(z121_silent(user))
		if(z121_metamagic_cast)
			z121_metamagic_cast.applied = TRUE
		return
	return ..()

/obj/effect/proc_holder/spell/calculate_chargetime(mob/living/user)
	return z121_channel(..(), user)

/obj/effect/proc_holder/spell/get_chargetime()
	. = ..()
	if(!ranged_ability_user)
		return z121_channel(., z121_metamagic_cast?.caster || action?.owner)

/datum/intent/spell/get_chargetime()
	var/obj/effect/proc_holder/spell/spell = mastermob?.ranged_ability
	if(istype(spell))
		return spell.get_chargetime()
	return ..()

/datum/intent/spell/on_charge_start()
	var/obj/effect/proc_holder/spell/spell = mastermob?.ranged_ability
	if(istype(spell))
		spell.z121_begin(mastermob)
		spell.z121_sync_intent(mastermob)
	return ..()

/obj/effect/proc_holder/spell/Click()
	if(z121_metamagic_cast?.executing)
		return FALSE
	var/datum/z121_metamagic_cast/casting = z121_begin(usr)
	if(casting)
		casting.executing = TRUE
	. = ..()
	if(casting && !QDELETED(casting) && !casting.finished && !casting.deferred)
		casting.finish(FALSE)

/obj/effect/proc_holder/spell/invoked/InterceptClickOn(mob/living/caller, params, atom/target)
	if(z121_metamagic_cast?.executing)
		return FALSE
	var/list/modifiers = params2list(params)
	if(!modifiers["middle"])
		return ..()
	var/datum/z121_metamagic_cast/casting = z121_begin(caller)
	if(casting)
		casting.executing = TRUE
	. = ..()
	if(casting && !QDELETED(casting) && !casting.finished)
		casting.finish(FALSE)

/obj/effect/proc_holder/spell/perform(list/targets, recharge = TRUE, mob/user = usr)
	if(z121_metamagic_cast && z121_metamagic_cast.caster != user)
		return FALSE
	var/datum/z121_metamagic_cast/casting = z121_metamagic_cast || z121_begin(user)
	if(casting)
		casting.executing = TRUE
	. = ..()
	if(casting && !QDELETED(casting) && !casting.deferred)
		casting.finish(!!.)

/mob/stop_attack(message = FALSE)
	. = ..()
	var/datum/component/z121_metamagic/controller = GetComponent(/datum/component/z121_metamagic)
	if(controller?.pending && !controller.pending.executing)
		controller.pending.finish(FALSE)

// 有些旧法术退款后仍返回父过程的成功值，以退款入口作为失败的最终凭据。
/obj/effect/proc_holder/spell/revert_cast(mob/user = usr)
	if(z121_metamagic_cast)
		z121_metamagic_cast.failed = TRUE
	return ..()

/obj/effect/proc_holder/spell/deactivate(mob/living/user)
	if(z121_metamagic_cast && !z121_metamagic_cast.executing)
		z121_metamagic_cast.finish(FALSE)
	return ..()

/obj/effect/proc_holder/spell/Destroy()
	z121_metamagic_cast?.finish(FALSE)
	return ..()

// 以下三个分支沿用原类型和学习目录；接口均为本模块新增，不要求核心文件配合。
#include "metamagic_effects.dm"
#include "metamagic_adapters.dm"

#undef Z121_META_SILENT
#undef Z121_META_QUICK
#undef Z121_META_POWER
#undef Z121_META_EXTEND
