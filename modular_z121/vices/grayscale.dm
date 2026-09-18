// 灰度人：外观去色、渐进情感麻木，以及每段直接性接触一次的传播判定。
#define Z121_GRAYSCALE_FILTER "z121_grayscale"
#define Z121_GRAYSCALE_TRAIT_SOURCE "z121_grayscale"
#define Z121_GRAYSCALE_STAGE_TIME (10 MINUTES)
#define Z121_GRAYSCALE_CONTACT_GAP (60 SECONDS)

GLOBAL_DATUM(grayscale_transmission, /datum/grayscale_transmission)

/datum/charflaw/grayscale
	name = "灰度人"
	desc = "不知是哪位神祇忘了替我着色，还是坟墓里的灰爬进了我的血。肌肤、衣裳，连经我手的东西都只剩下死灰。欢愉与悲恸也正一点点褪去，终将连恐惧都不再留下。若有人贪恋这具躯壳的余温，愿十神保佑——别让这份苍白也留在他身上。"
	point_value = 1

/datum/charflaw/grayscale/on_mob_creation(mob/user)
	if(ishuman(user))
		user.AddComponent(/datum/component/grayscale)

/datum/charflaw/grayscale/apply_post_equipment(mob/user)
	if(!ishuman(user))
		return
	var/datum/component/grayscale/symptoms = user.AddComponent(/datum/component/grayscale)
	symptoms.gray_equipment()

/datum/charflaw/grayscale/flaw_on_life(mob/user)
	var/datum/component/grayscale/symptoms = user.GetComponent(/datum/component/grayscale)
	symptoms?.update_stage()

/datum/charflaw/grayscale/on_removal(mob/user)
	var/datum/component/grayscale/symptoms = user.GetComponent(/datum/component/grayscale)
	qdel(symptoms)

/mob/living/carbon/human
	var/grayscale_mood_multiplier = 1
	/// 仅保存引用字符串和时间戳，避免接触记录阻止已删除的伴侣被回收。
	var/list/grayscale_contacts

// 人类类型原本没有覆写此过程；先保留父类的压力结算，再缩放情绪影响。
/mob/living/carbon/human/get_stress_amount()
	return ..() * grayscale_mood_multiplier

// 创角与描述预览共用假人池；归还假人前必须清理灰度状态，避免污染下一位玩家。
// 界面已经取得独立的外观快照，因此清理不会改变当前玩家已经生成的灰色预览。
/mob/living/carbon/human/dummy/wipe_state()
	var/datum/component/grayscale/symptoms = GetComponent(/datum/component/grayscale)
	qdel(symptoms)
	remove_filter(Z121_GRAYSCALE_FILTER)
	grayscale_mood_multiplier = 1
	grayscale_contacts = null
	REMOVE_TRAIT(src, TRAIT_NOMOOD, Z121_GRAYSCALE_TRAIT_SOURCE)

	// 只回收本缺陷的实例，同时处理多缺陷列表与旧式单缺陷引用。
	var/list/grayscale_vices = list()
	for(var/datum/charflaw/grayscale/vice in vices)
		grayscale_vices |= vice
	if(istype(charflaw, /datum/charflaw/grayscale))
		grayscale_vices |= charflaw
		charflaw = null
	for(var/datum/charflaw/grayscale/vice in grayscale_vices)
		if(length(vices))
			vices -= vice
		qdel(vice)
	// 保留原有装备删除和外观叠层清理，预览中灰化的衣物也随之回收。
	return ..()

/datum/component/grayscale
	// 重复挂载时直接复用，避免临时组件销毁时清掉现有滤镜与情绪状态。
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/started_at
	var/stage = 0
	var/next_equipment_check = 0

/datum/component/grayscale/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	started_at = world.time
	var/mob/living/carbon/human/owner = parent
	owner.add_filter(Z121_GRAYSCALE_FILTER, 100, color_matrix_filter(color_matrix_saturation(0)))
	gray_equipment()
	to_chat(owner, span_warning("色彩从我的身体和衣物上褪去。我的情感也将一点点沉入灰白之中……"))

/datum/component/grayscale/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(on_item_entered))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_item_equipped))
	RegisterSignal(parent, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_touch))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/grayscale/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_ENTERED, COMSIG_ITEM_EQUIPPED, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_PARENT_EXAMINE))

/datum/component/grayscale/Destroy(force, silent)
	var/mob/living/carbon/human/owner = parent
	if(istype(owner))
		owner.remove_filter(Z121_GRAYSCALE_FILTER)
		owner.grayscale_mood_multiplier = 1
		REMOVE_TRAIT(owner, TRAIT_NOMOOD, Z121_GRAYSCALE_TRAIT_SOURCE)
		if(!QDELETED(owner))
			// 销毁过程不可等待；由角色回调刷新心情，避免界面或表情阻塞销毁链。
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, update_stress)), 0)
	return ..()

/datum/component/grayscale/proc/gray_equipment()
	var/mob/living/carbon/human/owner = parent
	for(var/obj/item/item in owner.get_equipped_items(TRUE) + owner.held_items)
		gray_item(item)

/datum/component/grayscale/proc/gray_item(obj/item/item)
	if(!istype(item) || QDELETED(item) || item.z121_grayscaled)
		return
	if(istype(item, /obj/item/chair))
		item.AddComponent(/datum/component/z121_grayscale_chair)
		return
	item.z121_apply_grayscale()

/obj/item/proc/z121_apply_grayscale()
	if(z121_grayscaled)
		return
	z121_grayscaled = TRUE
	// 物品栏和地面图标直接读取物品颜色，必须同时处理本体的染色。
	color = z121_grayscale_color(color)
	// 将外观叠层一起处理，确保单独染色的细节也褪为灰阶。
	appearance_flags |= KEEP_TOGETHER
	add_filter(Z121_GRAYSCALE_FILTER, 100, color_matrix_filter(color_matrix_saturation(0)))
	// 已穿戴的物品不会因增加滤镜而重建外观，首次灰化时需要主动刷新。
	update_slot_icon()
	if(ismob(loc))
		var/mob/holder = loc
		holder.update_inv_hands()

// 椅子拿起和放置时会替换对象；沿用原有组件转移流程保存永久灰化状态。
/datum/component/z121_grayscale_chair
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	can_transfer = TRUE

/datum/component/z121_grayscale_chair/Initialize()
	return apply_grayscale()

/datum/component/z121_grayscale_chair/PostTransfer()
	return apply_grayscale()

/datum/component/z121_grayscale_chair/proc/apply_grayscale()
	if(istype(parent, /obj/item/chair))
		var/obj/item/chair/chair_item = parent
		chair_item.z121_apply_grayscale()
		return
	if(!istype(parent, /obj/structure/chair))
		return COMPONENT_INCOMPATIBLE
	var/obj/structure/chair/chair_structure = parent
	chair_structure.color = z121_grayscale_color(chair_structure.color)
	chair_structure.appearance_flags |= KEEP_TOGETHER
	chair_structure.add_filter(Z121_GRAYSCALE_FILTER, 100, color_matrix_filter(color_matrix_saturation(0)))

/obj/structure/chair/update_atom_colour()
	. = ..()
	if(GetComponent(/datum/component/z121_grayscale_chair))
		color = z121_grayscale_color(color)

// 椅子的特殊手持图直接混合贴图，不继承物品滤镜，也不能用 Blend 处理颜色矩阵。
/obj/item/chair/getmoboverlay(tag, prop, behind = FALSE, mirrored = FALSE)
	if(!z121_grayscaled)
		return ..()
	var/original_color = color
	color = null
	if(force_reupdate_inhand)
		has_behind_state = null
	// 单独生成本次手持图，避免把灰色贴图写入所有同类物品共用的缓存。
	var/icon/onmob = generateonmob(tag, prop, behind, mirrored)
	color = original_color
	if(onmob)
		onmob.MapColors(arglist(z121_grayscale_color(original_color)))
	return onmob

/obj/item
	/// 永久灰化状态独立保存，不以是否存在渲染滤镜判断。
	var/z121_grayscaled = FALSE

// 随机紧身裤初始化、染缸染色等都会重新结算颜色，结算后仍须保持灰阶。
// 父类的颜色优先级列表保留原染色，灰化仅作用于最终显示颜色。
/obj/item/update_atom_colour()
	. = ..()
	if(z121_grayscaled)
		color = z121_grayscale_color(color)

// 穿戴图由原始贴图和颜色重新生成，不会自动继承物品本身的滤镜。
// 在衣物子类型上扩展父类构图，保留种族裁剪、染色细节与原有叠层。
/obj/item/clothing/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female = FALSE, customi = null, sleeveindex, boobed_overlay = FALSE, icon/clip_mask = null)
	var/mutable_appearance/worn = ..()
	if(worn && z121_grayscaled)
		z121_gray_worn_appearance(worn)
	return worn

// 裤腿和衣袖是独立外观，不经过衣物主体的构图过程，必须分别去色。
/mob/living/carbon/human/get_sleeves_layer(obj/item/item, sleeveindex, layer2use)
	. = ..()
	if(!item?.z121_grayscaled)
		return
	for(var/mutable_appearance/sleeve as anything in .)
		z121_gray_worn_appearance(sleeve)

/proc/z121_gray_worn_appearance(mutable_appearance/worn)
	worn.appearance_flags |= KEEP_TOGETHER
	// 穿戴外观会被视野等系统再次复制，不能只依赖附加滤镜。
	// 将原染色与去色合并到最终颜色矩阵，避免紧身裤和裤腿重新带上原色。
	worn.color = z121_grayscale_color(worn.color)

/proc/z121_grayscale_color(original_color)
	var/list/original_matrix = original_color
	if(!islist(original_matrix))
		original_matrix = color_matrix_identity()
		if(istext(original_color))
			var/list/channels = rgb2num(original_color)
			original_matrix[1] = channels[1] / 255
			original_matrix[6] = channels[2] / 255
			original_matrix[11] = channels[3] / 255
			if(length(channels) >= 4)
				original_matrix[16] = channels[4] / 255
	// 先按原色着色，再转为灰阶；保留明暗、透明度和已有裁剪滤镜。
	return color_matrix_multiply(original_matrix, color_matrix_saturation(0))

/datum/component/grayscale/proc/on_item_entered(datum/source, atom/movable/item, atom/old_location)
	SIGNAL_HANDLER
	gray_item(item)

/datum/component/grayscale/proc/on_item_equipped(datum/source, obj/item/item, slot)
	SIGNAL_HANDLER
	gray_item(item)

/datum/component/grayscale/proc/on_touch(datum/source, atom/target, proximity)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = parent
	if(proximity && owner.Adjacent(target))
		if(istype(target, /obj/structure/chair))
			target.AddComponent(/datum/component/z121_grayscale_chair)
		else
			gray_item(target)

/datum/component/grayscale/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("[parent]的身体与衣物泛着不自然的灰白，仿佛失去了所有色彩。")

/datum/component/grayscale/proc/update_stage()
	// 补齐直接赋予装备、绕过装备信号的情况；已灰化物品不重复刷新。
	if(world.time >= next_equipment_check)
		next_equipment_check = world.time + 3 SECONDS
		gray_equipment()
	var/new_stage = clamp(round((world.time - started_at) / Z121_GRAYSCALE_STAGE_TIME), 0, 3)
	if(new_stage == stage)
		return
	stage = new_stage
	var/mob/living/carbon/human/owner = parent
	owner.grayscale_mood_multiplier = (3 - stage) / 3
	switch(stage)
		if(1)
			to_chat(owner, span_warning("喜悦与悲伤变得遥远。我的心仿佛隔着一层薄雾。"))
		if(2)
			to_chat(owner, span_warning("那些曾令我欢欣或痛苦的事，如今只剩下微弱的回声。"))
		if(3)
			ADD_TRAIT(owner, TRAIT_NOMOOD, Z121_GRAYSCALE_TRAIT_SOURCE)
			to_chat(owner, span_notice("我已感受不到喜悦，也感受不到悲伤。心中只剩下一片寂静的灰白。"))
	owner.update_stress()

/// 局内感染不替换已有缺陷，也不补发创角点数。
/proc/infect_grayscale(mob/living/carbon/human/recipient)
	if(!istype(recipient) || QDELETED(recipient) || recipient.stat == DEAD || recipient.has_flaw(/datum/charflaw/grayscale))
		return FALSE
	var/datum/charflaw/grayscale/vice = new
	vice.point_value = 0
	// 切换到多缺陷列表时，保留旧式单缺陷的生命周期处理。
	if(!length(recipient.vices) && recipient.charflaw)
		recipient.vices = list(recipient.charflaw)
	LAZYADD(recipient.vices, vice)
	vice.on_mob_creation(recipient)
	vice.apply_post_equipment(recipient)
	return TRUE

/// 统一监听所有人类，覆盖感染者主动接触健康角色的情况。
/datum/grayscale_transmission

/datum/grayscale_transmission/proc/register()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_mob_created))
	for(var/mob/living/carbon/human/human in GLOB.human_list)
		watch_human(human)

/datum/grayscale_transmission/proc/on_mob_created(datum/source, mob/created)
	SIGNAL_HANDLER
	if(ishuman(created))
		watch_human(created)

/datum/grayscale_transmission/proc/watch_human(mob/living/carbon/human/human)
	RegisterSignal(human, COMSIG_CARBON_SEX_ACTION_RECEIVED, PROC_REF(on_contact))

/datum/grayscale_transmission/proc/on_contact(mob/living/carbon/human/receiver, mob/living/carbon/human/actor, datum/sex_controller/controller, datum/sex_action/action, receiver_part, giving, arousal, pain, applied_force, applied_speed)
	SIGNAL_HANDLER
	if(!controller || controller.user != actor || !action || controller.current_action != action.type)
		return
	if(receiver != actor && receiver != controller.target)
		return
	// 部分动作先向主动方发送信号，另一位参与者应从控制器的目标读取。
	handle_contact(actor, controller.target, action)

/datum/grayscale_transmission/proc/is_direct_contact(datum/sex_action/action)
	if(!action || action.solo || action.ranged_los_action)
		return FALSE
	// 明确列出直接性接触，排除玩具、隔衣抚摸、亲吻及其他菜单动作。
	var/static/list/contact_types = typecacheof(list(
		/datum/sex_action/anal_sex,
		/datum/sex_action/anal_ride_sex,
		/datum/sex_action/vaginal_sex,
		/datum/sex_action/vaginal_ride_sex,
		/datum/sex_action/throat_sex,
		/datum/sex_action/slit_sex,
		/datum/sex_action/double_penetration_sex,
		/datum/sex_action/blowjob,
		/datum/sex_action/cunnilingus,
		/datum/sex_action/rimming,
		/datum/sex_action/suck_balls,
		/datum/sex_action/suck_nipples,
		/datum/sex_action/crotch_nuzzle,
		/datum/sex_action/masturbate_penis_other,
		/datum/sex_action/masturbate_other_vagina,
		/datum/sex_action/masturbate_other_vagina_finger,
		/datum/sex_action/masturbate_other_anus,
		/datum/sex_action/masturbate_other_breasts,
		/datum/sex_action/frotting,
		/datum/sex_action/scissoring,
		/datum/sex_action/titjob,
		/datum/sex_action/thighjob,
		/datum/sex_action/buttjob,
		/datum/sex_action/footjob,
		/datum/sex_action/tailjob,
		/datum/sex_action/tailpegging_anal,
		/datum/sex_action/tailpegging_vaginal,
		/datum/sex_action/knot_grinding,
		/datum/sex_action/facesitting_anal,
		/datum/sex_action/facesitting_vaginal,
		/datum/sex_action/force_blowjob,
		/datum/sex_action/force_cunnilingus,
		/datum/sex_action/force_rimming,
		/datum/sex_action/force_suck_nipples,
		/datum/sex_action/force_crotch_nuzzle,
		/datum/sex_action/force_milk_genitals,
		/datum/sex_action/force_titjob,
		/datum/sex_action/force_thighjob,
		/datum/sex_action/force_footjob,
	))
	return is_type_in_typecache(action, contact_types)

/datum/grayscale_transmission/proc/handle_contact(mob/living/carbon/human/actor, mob/living/carbon/human/partner, datum/sex_action/action)
	if(!istype(actor) || !istype(partner) || QDELETED(actor) || QDELETED(partner) || actor == partner)
		return FALSE
	if(actor.stat == DEAD || partner.stat == DEAD || !actor.Adjacent(partner) || !is_direct_contact(action))
		return FALSE
	var/actor_infected = !!actor.GetComponent(/datum/component/grayscale)
	var/partner_infected = !!partner.GetComponent(/datum/component/grayscale)
	if(actor_infected == partner_infected)
		return FALSE
	var/last_contact = actor.grayscale_contacts?[REF(partner)]
	// 即使不重新判定也刷新接触时间，长时间持续互动始终只算一次。
	record_contact(actor, partner)
	record_contact(partner, actor)
	if(!isnull(last_contact) && world.time - last_contact < Z121_GRAYSCALE_CONTACT_GAP)
		return FALSE
	if(!roll_infection())
		return FALSE
	return infect_grayscale(actor_infected ? partner : actor)

/datum/grayscale_transmission/proc/record_contact(mob/living/carbon/human/human, mob/living/carbon/human/partner)
	LAZYINITLIST(human.grayscale_contacts)
	for(var/key in human.grayscale_contacts)
		if(world.time - human.grayscale_contacts[key] >= Z121_GRAYSCALE_CONTACT_GAP)
			human.grayscale_contacts -= key
	human.grayscale_contacts[REF(partner)] = world.time

// 每段连续互动仅调用一次，传播概率固定为百分之十。
/datum/grayscale_transmission/proc/roll_infection()
	return prob(10)

/proc/register_grayscale_vice()
	GLOB.character_flaws["灰度人"] = /datum/charflaw/grayscale
	if(!GLOB.grayscale_transmission)
		GLOB.grayscale_transmission = new
		GLOB.grayscale_transmission.register()

#undef Z121_GRAYSCALE_FILTER
#undef Z121_GRAYSCALE_TRAIT_SOURCE
#undef Z121_GRAYSCALE_STAGE_TIME
#undef Z121_GRAYSCALE_CONTACT_GAP
