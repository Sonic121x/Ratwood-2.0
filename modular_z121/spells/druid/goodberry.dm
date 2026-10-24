// 复制登多尔原有奇迹表，交由现有职业授予和晋阶机制处理神莓术。
/datum/patron/divine/dendor/New()
	. = ..()
	miracles = miracles.Copy()
	miracles[/datum/action/cooldown/spell/z121/self/goodberry] = CLERIC_T1

/datum/action/cooldown/spell/z121/self/goodberry
	name = "神莓术"
	desc = "好吃的莓果，新鲜的莓果，多汁的莓果，要不要来一个？"
	spell_tier = 1
	miracle = TRUE
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 50
	charge_time = 3 SECONDS
	cooldown_time = 12 MINUTES
	cooldown_min = 12 MINUTES
	is_cdr_exempt = TRUE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	associated_skill = /datum/skill/magic/holy
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "spell0"
	var/channeling = FALSE
	var/mob/living/carbon/human/channeling_user

// 直接叠加现有图集中的完整莓果，卷轴底图沿用模块已有图标，不另存图标文件。
/datum/action/cooldown/spell/z121/self/goodberry/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(!button_icon || !button_icon_state || (!force && current_button.active_overlay_icon_state == button_icon_state))
		return
	. = ..()
	current_button.add_overlay(mutable_appearance('icons/roguetown/items/produce.dmi', "berries", layer = current_button.layer + 0.2))
	var/mutable_appearance/berry_fruit = mutable_appearance('icons/roguetown/items/produce.dmi', "berriesc5", layer = current_button.layer + 0.3)
	berry_fruit.color = GLOB.berrycolors["good"] ? GLOB.berrycolors["good"] : "#6a6699"
	current_button.add_overlay(berry_fruit)

/datum/action/cooldown/spell/z121/self/goodberry/Trigger(trigger_flags)
	// 冷却或引导中的重复点击不能触发父类的失败返还路径。
	if(channeling || !ishuman(owner) || !z121_ready(owner))
		return FALSE
	return ..()

/datum/action/cooldown/spell/z121/self/goodberry/z121_ready(mob/user, silent = FALSE)
	// 完成引导时只豁免本次已经预留的冷却，仍由父类复查其他施法条件。
	if(channeling && user == channeling_user)
		return TRUE
	return ..()

/datum/action/cooldown/spell/z121/self/goodberry/z121_apply(atom/cast_on)
	var/mob/user = owner
	if(channeling)
		return FALSE
	if(!ishuman(user) || !user.mind)
		cancel_goodberry_cast(user)
		return FALSE

	var/mob/living/carbon/human/caster = user
	var/datum/mind/casting_mind = caster.mind
	var/datum/devotion/casting_devotion = caster.devotion
	var/client/casting_client = caster.client
	channeling = TRUE
	channeling_user = caster

	to_chat(caster, span_notice("我向登多尔祈求一颗新鲜的莓果……"))
	// 抵消通用动作速度系数，实际引导保持三秒，仍保留动作中断检查。
	var/channel_delay = charge_time / max(0.01, caster.do_after_coefficent())
	var/success = do_after(caster, channel_delay, target = caster, progress = TRUE, extra_checks = CALLBACK(src, PROC_REF(can_continue_goodberry), caster, casting_mind, casting_devotion, casting_client))
	if(QDELETED(src))
		return FALSE
	if(!success || !can_continue_goodberry(caster, casting_mind, casting_devotion, casting_client) || !z121_check(TRUE, caster))
		if(!QDELETED(caster))
			to_chat(caster, span_warning("我的祈求被打断了，莓果未能成形。"))
		cancel_goodberry_cast(caster)
		return FALSE

	. = ..()
	var/berry_type = /obj/item/reagent_containers/food/snacks/grown/berries/rogue
	if(prob(clamp(20 - caster.STALUC, 0, 100)))
		berry_type = /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison
	var/obj/item/reagent_containers/food/snacks/grown/berries/rogue/berry = new berry_type(get_turf(caster))
	if(caster.put_in_hands(berry))
		to_chat(caster, span_notice("一颗新鲜的杰克莓在我手中成形。"))
	else
		to_chat(caster, span_notice("我的双手已满，新鲜的杰克莓落到了脚边。"))

	channeling = FALSE
	channeling_user = null
	return TRUE

/datum/action/cooldown/spell/z121/self/goodberry/proc/can_continue_goodberry(mob/living/carbon/human/caster, datum/mind/casting_mind, datum/devotion/casting_devotion, client/casting_client)
	if(QDELETED(src) || QDELETED(caster) || QDELETED(casting_mind) || QDELETED(casting_devotion))
		return FALSE
	if(!casting_client || caster.client != casting_client || caster.stat != CONSCIOUS || !get_turf(caster))
		return FALSE
	if(caster.mind != casting_mind || caster.devotion != casting_devotion)
		return FALSE
	if(!(src in casting_mind.spell_list) && !(src in caster.mob_spell_list))
		return FALSE
	return can_cast_spell(TRUE) && check_cost()

/datum/action/cooldown/spell/z121/self/goodberry/proc/cancel_goodberry_cast(mob/user)
	channeling = FALSE
	channeling_user = null
	if(!QDELETED(user))
		z121_cancel(user)
	else
		reset_spell_cooldown()
