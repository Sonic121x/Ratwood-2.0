#define EQUALIZED_GLOW "equalizer glow"

// T0: Determine the net mammon value of target

/obj/effect/proc_holder/spell/invoked/appraise
	name = "鉴价"
	desc = "告诉你某人身上携带了多少玛门，以及神经锁里存了多少。"
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "appraise"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/invoked/appraise/secular
	name = "世俗鉴价"
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "appraise"
	range = 2
	associated_skill = /datum/skill/misc/reading // idk reading is like Accounting right
	miracle = FALSE
	devotion_cost = 0 //Merchants are not clerics


/obj/effect/proc_holder/spell/invoked/appraise/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_DECEIVING_MEEKNESS) && target != user)
			to_chat(user, "<font color='yellow'>我看不出来......</font>")
			if(prob(50 + ((target.STAPER - 10) * 10)))
				to_chat(target, span_warning("有一双窥探的眼睛落在了我身上......"))
			return
		var/mammonsonperson = get_mammons_in_atom(target)
		var/mammonsinbank = SStreasury.bank_accounts[target] ? SStreasury.bank_accounts[target] : 0
		var/totalvalue = mammonsinbank + mammonsonperson
		to_chat(user, ("<font color='yellow'>[target]身上带着[mammonsonperson]枚mammon，神经锁中存有[mammonsinbank]枚，总计[totalvalue]枚mammon。</font>"))

// T1 - Take value of item in hand, apply that as healing. Destroys item.

/obj/effect/proc_holder/spell/invoked/transact
	name = "交易"
	desc = "献祭你手中的一件物品，为自己施加一个持续治疗，其强度取决于物品价值。"
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "transact"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 20


/obj/effect/proc_holder/spell/invoked/transact/cast(list/targets, mob/living/user)
	. = ..()
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item)
		to_chat(user, span_info("我需要有价值的东西，才能完成这笔交易......"))
		return
	var/helditemvalue = held_item.get_real_price()
	if(!helditemvalue)
		to_chat(user, span_info("这东西毫无价值，在这样的交易中派不上用场。"))
		return
	if(helditemvalue<10)
		to_chat(user, span_info("这东西价值太低，在这样的交易中派不上用场。"))
		return
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			target.visible_message(span_info("[target]微微一颤，神迹随之消散。"), span_notice("一股迟钝的暖意在我心中升起，却又如来时一般迅速消退。"))
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		user.visible_message(span_notice("交易已经完成，[target]沐浴在强化之中！"))
		to_chat(user, "<font color='yellow'>[held_item]突然在空气中燃尽，我的交易被接受了。</font>")
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/datum/status_effect/buff/healing/heal_effect = C.apply_status_effect(/datum/status_effect/buff/healing)
			heal_effect.healing_on_tick = helditemvalue/2
			playsound(user, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			qdel(held_item)
		else
			target.adjustBruteLoss(helditemvalue/2)
			target.adjustFireLoss(helditemvalue/2)
			playsound(user, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			qdel(held_item)
		return TRUE
	revert_cast()
	return FALSE

// T2 We're going to debuff a targets stats = to the difference between us and them in total stats.

/obj/effect/proc_holder/spell/invoked/equalize
	name = "均衡"
	desc = "与你的目标建立一种稍向自己倾斜的平衡。从他们身上汲取力量、速度与体质。"
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "equalize"
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeascendant
	sound = 'sound/magic/swap.ogg'
	chargedrain = 0
	chargetime = 50
	releasedrain = 60
	no_early_release = TRUE
	antimagic_allowed = TRUE
	movement_interrupt = FALSE
	recharge_time = 2 MINUTES
	range = 4


/obj/effect/proc_holder/spell/invoked/equalize/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/target = targets[1]
		target.apply_status_effect(/datum/status_effect/debuff/equalizedebuff)
		user.apply_status_effect(/datum/status_effect/buff/equalizebuff)
		return TRUE
	revert_cast()
	return FALSE


// buff
/datum/status_effect/buff/equalizebuff
	id = "equalize"
	alert_type = /atom/movable/screen/alert/status_effect/buff/equalized
	effectedstats = list(STATKEY_STR = 2, STATKEY_CON = 2, STATKEY_SPD = 2)
	duration = 1 MINUTES
	var/outline_colour = "#FFD700"


/atom/movable/screen/alert/status_effect/buff/equalized
	name = "均衡"
	desc = "天平被巧妙地轻轻按住，平衡已然建立。"

/datum/status_effect/buff/equalizebuff/on_apply()
	. = ..()
	owner.add_filter(EQUALIZED_GLOW, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/buff/equalizebuff/on_remove()
	. = ..()
	owner.remove_filter(EQUALIZED_GLOW)
	to_chat(owner, "<font color='yellow'>我的联结消退了，被夺走的火焰回到了他们身上。</font>")


// debuff
/datum/status_effect/debuff/equalizedebuff
	id = "equalize"
	alert_type = /atom/movable/screen/alert/status_effect/buff/equalized
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_SPD = -2)
	duration = 1 MINUTES
	var/outline_colour = "#FFD700"

/atom/movable/screen/alert/status_effect/debuff/equalized
	name = "均衡"
	desc = "我的火焰被夺走了！"

/datum/status_effect/debuff/equalizedebuff/on_apply()
	. = ..()
	owner.add_filter(EQUALIZED_GLOW, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/debuff/equalizedebuff/on_remove()
	. = ..()
	owner.remove_filter(EQUALIZED_GLOW)
	to_chat(owner, "<font color='yellow'>我的火焰回来了！</font>")



//T3 COUNT WEALTH, HURT TARGET/APPLY EFFECTS BASED ON AMOUNT OF WEALTH. AT 500+, OLD STYLE CHURNS THE TARGET.

/obj/effect/proc_holder/spell/invoked/churnwealthy
	name = "财富碾磨"
	desc = "以目标贪欲的重量反噬其身，财富越多，造成的伤害与附加效果越强。"
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "churn_wealthy"
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeascendant
	chargedrain = 0
	chargetime = 50
	releasedrain = 90
	no_early_release = TRUE
	antimagic_allowed = TRUE
	movement_interrupt = FALSE
	recharge_time = 2 MINUTES
	range = 4


/obj/effect/proc_holder/spell/invoked/churnwealthy/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/target = targets[1]

		if(user.z != target.z) //Stopping no-interaction snipes
			to_chat(user, "<font color='yellow'>自由之神要求我在同一层地面上直面[target]，方可完成交易。</font>")
			revert_cast()
			return
		var/mammonsonperson = get_mammons_in_atom(target)
		var/mammonsinbank = SStreasury.bank_accounts[target]
		var/totalvalue = mammonsinbank + mammonsonperson
		if(HAS_TRAIT(target, TRAIT_NOBLE))
			totalvalue += 101 // We're ALWAYS going to do a medium level smite minimum to nobles.
		if(totalvalue <=10)
			to_chat(user, "<font color='yellow'>[target]并无财富可供反噬。</font>")
			revert_cast()
			return
		if(totalvalue <=30)
			user.say("财富化作祸殃！")
			target.visible_message(span_danger("[target]被圣光灼烧！"), span_userdanger("我感到自己的财富重压正在灼烧我的灵魂！"))
			target.adjustFireLoss(30)
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <=60)
			user.say("财富化作祸殃！")
			target.visible_message(span_danger("[target]被圣光灼烧！"), span_userdanger("我感到自己的财富重压正在灼烧我的灵魂！"))
			target.adjustFireLoss(60)
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <=100)
			user.say("财富化作祸殃！")
			target.visible_message(span_danger("[target]被圣光灼烧！"), span_userdanger("我感到自己的财富重压正在灼烧我的灵魂！"))
			target.adjustFireLoss(80)
			target.Stun(20)
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <=200)
			user.say("自由之神降下斥责！")
			target.visible_message(span_danger("[target]被圣光灼烧！"), span_userdanger("我感到财富的重压正在撕扯我的灵魂！"))
			target.adjustFireLoss(100)
			target.adjust_fire_stacks(7, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.Stun(20)
			target.ignite_mob()
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <=500)
			user.say("自由之神降下斥责！")
			target.visible_message(span_danger("[target]被圣光灼烧！"), span_userdanger("我感到财富的重压正在撕扯我的灵魂！"))
			target.adjustFireLoss(120)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			target.Stun(40)
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <= 1000)
			target.visible_message(span_danger("[target]遭受圣光神罚！"), span_userdanger("我感到财富的重压正将我的灵魂生生撕裂！"))
			user.say("你的最后一笔交易！自由之神斥退你！！")
			target.Stun(60)
			target.emote("agony")
			target.adjustFireLoss(140)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			return
		if(totalvalue >=1001) //THE POWER OF MY STAND: 'EXPLODE AND DIE INSTANTLY'
			target.visible_message(span_danger("[target]的皮肤开始骇人地剥落并燃烧，亮得宛如熔化的金属！"), span_userdanger("我的四肢在痛苦中燃烧......"))
			user.say("无可计量的财富，迎来你的最终交易！！")
			target.Stun(80)
			target.emote("agony")
			target.adjustFireLoss(50)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			sleep(80)

			target.visible_message(span_danger("[target]的肢体撕裂成金币与宝石！"), span_userdanger("财富。力量。我最后所见，是一张龙口将我撕成两半。我的脏腑尽化金银。"))
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			playsound(user, 'sound/magic/whiteflame.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			new /obj/item/roguecoin/silver/pile(target.loc)
			new /obj/item/roguecoin/gold/pile(target.loc)
			new /obj/item/roguegem/random(target.loc)
			new /obj/item/roguegem/random(target.loc)

			var/list/possible_limbs = list()
			for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
				var/obj/item/bodypart/limb = target.get_bodypart(zone)
				if(limb)
					possible_limbs += limb
				var/limbs_to_gib = min(rand(1, 4), possible_limbs.len)
				for(var/limb_index in 1 to limbs_to_gib)
					var/obj/item/bodypart/selected_limb = pick(possible_limbs)
					possible_limbs -= selected_limb
					if(selected_limb?.drop_limb())
						var/turf/limb_turf = get_turf(selected_limb) || get_turf(target) || target.drop_location()
						if(limb_turf)
							new /obj/effect/decal/cleanable/blood/gibs/limb(limb_turf)

			return

/// - MATTHIOS REVIVAL - ///


/obj/effect/proc_holder/spell/invoked/resurrect/matthios
	name = "Rekindled Exchange"
	desc = "Revives the target by invoking a deal with Matthios. In exchange for their lyfe returned, they will be placed\
	in a lasting debt to Him. Any coins within their hands will be spent paying off said debt. Blood for gold."
	debuff_type = /datum/status_effect/debuff/debt_indicator
	alt_required_items = list()
	required_items = list()
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	recharge_time = 2 MINUTES //Anastasis Equivalent
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/matthios


#define NOBLE_MULTIPLIER 2.5

/datum/component/debt_collector
	var/debt_remaining = 0
	/// There's a couple instances where on_equip() is called twice incorrectly. I'm applying a small cooldown to prevent abuse of this...
	COOLDOWN_DECLARE(next_payment_time)
/datum/component/debt_collector/Initialize(start_debt = 200)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/human = parent
	if(HAS_TRAIT(human, TRAIT_NOBLE))
		debt_remaining = start_debt * NOBLE_MULTIPLIER
	else
		debt_remaining = start_debt
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/component/debt_collector/proc/on_equip(mob/living/carbon/human/human, obj/item/equipped_item, slot)
	SIGNAL_HANDLER

	if(slot != ITEM_SLOT_HANDS)
		return

	if(world.time < next_payment_time)
		return

	// Set the cooldown immediately to "lock" this tick
	next_payment_time = world.time + 1

	// Only interact with standard currency, so no marques or psila
	if(istype(equipped_item, /obj/item/roguecoin/gold) || istype(equipped_item, /obj/item/roguecoin/silver) || istype(equipped_item, /obj/item/roguecoin/copper) || istype(equipped_item, /obj/item/roguecoin/gilbranze))
		addtimer(CALLBACK(src, PROC_REF(process_payment), human, equipped_item), 1)

/datum/component/debt_collector/proc/process_payment(mob/living/carbon/human/human, obj/item/roguecoin/coin)
	var/total_real_value = coin.get_real_price()
	if(debt_remaining <= 0)
		clear_debt(human)
		return

	if(total_real_value > debt_remaining)
		var/refund_budget = total_real_value - debt_remaining
		refund_budget = max(0, floor(refund_budget))
		to_chat(human, span_warning("A golden hand claims [coin] and manifest the remainder."))

		qdel(coin)
		// We need a delay to stop the old coin pile from merging with the refund prematurely. Delay one tick :D
		// I love coin code!!
		spawn(1)
			var/obj/structure/roguemachine/temp_ref = new /obj/structure/roguemachine()
			temp_ref.budget2change(refund_budget, human)
			qdel(temp_ref)

		debt_remaining = 0
		clear_debt(human)

	else
		debt_remaining -= total_real_value
		to_chat(human, span_warning("As you grasp [coin], [total_real_value] worth of debt vanishes. Remaining: [debt_remaining]."))
		playsound(human, 'sound/foley/coins1.ogg', 50, TRUE)
		qdel(coin)
		if(debt_remaining <= 0)
			clear_debt(human)

/datum/component/debt_collector/proc/clear_debt(mob/living/carbon/human/human)
	to_chat(human, span_nicegreen("The weight of your debt has lifted!"))
	human.remove_status_effect(/datum/status_effect/debuff/debt_indicator)
	qdel(src)

#undef NOBLE_MULTIPLIER

/atom/movable/screen/alert/status_effect/debuff/debt_indicator
	name = "Indentured Spirit"
	desc = "A spiritual debt weighs heavy on your soul, sapping your vitality. Standard coins you touch are consumed to appease Matthios."
	icon_state = "pom_regret"

/atom/movable/screen/alert/status_effect/debuff/debt_indicator/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"

	// Find the component to show the live debt count
	var/datum/component/debt_collector/DC = user.GetComponent(/datum/component/debt_collector)
	if(DC)
		inspec += "<br><span class='boldwarning'>Current Debt: [DC.debt_remaining] mammon.</span>"

	// Stat penalties logic from the base proc
	for(var/S in attached_effect?.effectedstats)
		if(attached_effect.effectedstats[S] > 0)
			inspec += "<br><span class='purple'>[S]</span> \Roman [attached_effect.effectedstats[S]]"
		else if(attached_effect.effectedstats[S] < 0)
			var/newnum = attached_effect.effectedstats[S] * -1
			inspec += "<br><span class='danger'>[S]</span> \Roman [newnum]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/datum/status_effect/debuff/debt_indicator
	id = "debt_indicator"
	// You should pay off the debt!
	duration = 45 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/debt_indicator
	effectedstats = list(
		STATKEY_STR = -2,
		STATKEY_PER = -4,
		STATKEY_CON = -2
	)

/datum/status_effect/debuff/debt_indicator/on_apply()
	. = ..()
	owner.AddComponent(/datum/component/debt_collector, 200)
	to_chat(owner, span_userdanger("A cold, crushing weight settles over your limbs... you are indentured."))

/datum/status_effect/debuff/debt_indicator/on_remove()
	. = ..()
	to_chat(owner, span_nicegreen("The crushing weight lifts from your soul. You are free!"))
