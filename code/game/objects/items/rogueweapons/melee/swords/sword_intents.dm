// GENERIC
//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/sword/cut
	name = "劈砍"
	icon_state = "incut"
	attack_verb = list("切开", "挥砍")
	animname = "cut"
	blade_class = BCLASS_CUT
	chargetime = 0
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	swingdelay = 0
	damfactor = 1.1
	item_d_type = "slash"

/datum/intent/sword/cut/arming
	damfactor = 1.2
	clickcd = CLICK_CD_QUICK // Versatile, this create 26 EDPS instead of 20. But still easily beaten by the Sabre

/datum/intent/sword/cut/militia
	penfactor = PEN_LIGHT
	damfactor = 1.2
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE

/datum/intent/sword/cut/short
	clickcd = 9
	damfactor = 1

/datum/intent/sword/chop/militia
	penfactor = PEN_MEDIUM
	clickcd = CLICK_CD_CHARGED
	swingdelay = 0
	damfactor = 1.0
	no_early_release = TRUE

/datum/intent/sword/chop/heavy
	penfactor = PEN_MEDIUM
	swingdelay = 6
	damfactor = 1.3

/datum/intent/sword/thrust
	name = "刺击"
	icon_state = "instab"
	attack_verb = list("刺击")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_LIGHT
	chargetime = 0
	swingdelay = 0
	item_d_type = "stab"

/datum/intent/sword/thrust/short
	clickcd = CLICK_CD_FAST
	damfactor = 1.1
	penfactor = PEN_MEDIUM

/datum/intent/sword/thrust/arming
	clickcd = CLICK_CD_QUICK // Less than rapier
	penfactor = PEN_LIGHT

/datum/intent/sword/thrust/heavy
	name = "重刺"
	icon_state = "inlunge"
	penfactor = PEN_HEAVY
	damfactor = 1.3
	swingdelay = 0.9 SECONDS
	swingdelay_type = SWINGDELAY_PENALTY

/datum/intent/sword/thrust/long
	penfactor = PEN_LIGHT // Longsword thrust — same pen tier, higher base damage

/datum/intent/sword/thrust/long/deep
	name = "深突刺"
	icon_state = "inlunge"
	penfactor = PEN_MEDIUM
	damfactor = 1.2
	swingdelay = 0.6 SECONDS

/datum/intent/sword/thrust/long/deep/halfsword
	name = "深突刺"
	icon_state = "inlunge"
	penfactor = PEN_MEDIUM
	damfactor = 0.8
	swingdelay = 0.6 SECONDS

/datum/intent/sword/thrust/long/deep/halfsword/frei
	name = "深入突刺"
	desc = "越过对手的武器，精确刺向护甲缝隙，以杀伤对手而非破坏护甲为目的。出招时会暴露自身破绽。"
	icon_state = "inlunge"
	// Same as standard frei grip's deep lunge.
	penfactor = PEN_HEAVY
	swingdelay_type = SWINGDELAY_PENALTY
	intent_intdamage_factor = 0.5

/datum/intent/sword/thrust/long/halfsword
	name = "半剑突刺"
	icon_state = "inimpale"
	clickcd = CLICK_CD_CHARGED
	penfactor = PEN_HEAVY
	attack_verb = list("刺穿", "贯穿")
	damfactor = 1
	swingdelay = 1 SECONDS
	parriable_intent = FALSE
	dodgeable_intent = FALSE
	swingdelay_type = SWINGDELAY_CANCEL

/datum/intent/sword/thrust/long/halfsword/jab
	name = "快刺"
	icon_state = "instab"
	attack_verb = list("刺拳击打")
	penfactor = PEN_LIGHT
	damfactor = 0.8
	clickcd = CLICK_CD_QUICK
	swingdelay = 0
	dodgeable_intent = TRUE
	parriable_intent = TRUE
	swingdelay_type = SWINGDELAY_NORMAL

/datum/intent/sword/thrust/blunt
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	attack_verb = list("戳击", "戳刺")
	penfactor = PEN_NONE
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/sword/strike
	name = "柄击"
	icon_state = "instrike"
	attack_verb = list("打击")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = PEN_NONE
	swingdelay = 0
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/sword/strike/bash/mordhau
	damfactor = 0.8
	name = "反握锤击"
	icon_state = "inbash"
	attack_verb = list("猛砸", "敲击")

/datum/intent/sword/strike/bash/mordhau/smash
	name = "反握重砸"
	icon_state = "insmash"
	attack_verb = list("猛砸", "连续痛击", "重击")
	chargedrain = 1.8
	chargetime = 12
	damfactor = 1
	desc = "使出强力一击，击退并减速目标，击退距离随力量提升：力量达到 X 时击退一格，达到 XII 时击退两格。</br>力量低于 X 时无法造成击退或减速。</br>对同一目标施加此效果的间隔至少为五秒。</br>倒地目标的击退距离减半。</br>未完全蓄力时，最多击退一格。"
	var/maxrange = 2

/datum/intent/sword/strike/bash/mordhau/smash/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	var/chungus_khan_str = user.STASTR
	if(H.has_status_effect(/datum/status_effect/debuff/yeetcd))
		return // Recently knocked back, cannot be knocked back again yet
	if(chungus_khan_str < 10)
		return // Too weak to have any effect
	var/scaling = CLAMP((chungus_khan_str - 10), 1, maxrange)
	H.apply_status_effect(/datum/status_effect/debuff/yeetcd)
	H.Slowdown(scaling)
	// Copypasta from knockback proc cuz I don't want the math there
	var/knockback_tiles = scaling // 1 to 2 tiles based on strength
	if(H.resting)
		knockback_tiles = max(1, knockback_tiles / 2)
	if(user?.client?.chargedprog < 100)
		knockback_tiles = 1 // Minimal knockback on non-charged smash.
	var/turf/edge_target_turf = get_edge_target_turf(H, get_dir(user, H))
	if(istype(edge_target_turf))
		H.safe_throw_at(edge_target_turf, \
		knockback_tiles, \
		scaling, \
		user, \
		spin = FALSE, \
		force = H.move_force)

/datum/intent/sword/strike/penalty
	name = "钝面重挥"
	icon_state = "incut"
	swingdelay_type = SWINGDELAY_PENALTY
	swingdelay = 1 SECONDS
	damfactor = 1.3

/datum/intent/sword/strike/cancel
	name = "钝面缓挥"
	icon_state = "inchop"
	swingdelay_type = SWINGDELAY_CANCEL
	swingdelay = 1 SECONDS
	parriable_intent = FALSE
	dodgeable_intent = FALSE
	damfactor = 1.3

// Freifechter Longsword intents //
/datum/intent/sword/cut/master
	name = "正手斩"
	icon_state = "incutmaster"
	desc = "用剑的正刃攻击对手，穿透最轻薄的护甲，但对护甲本身的破坏力较弱。"
	attack_verb = list("娴熟地切开", "巧妙地割开", "灵巧地挥砍")
	// You do more damage to exposed areas than stabbing, but your damage to armor is slightly less effective than a normal longsword.
	// This effectively means you do 1.2x damage to flesh, but 0.9x damage to armor.
	damfactor = 1.2
	penfactor = PEN_LIGHT
	intent_intdamage_factor = 0.75

/datum/intent/sword/thrust/long/master
	name = "进步突刺"
	icon_state = "instabmaster"
	desc = "摆出长架势，向前进步时借整个上身之力突刺，充分发挥刺击的威力。"
	attack_verb =  list("熟练地刺穿", "巧妙地穿刺", "灵巧地刺击")
	// Your stabs are more effective at breaking heavy armor, and penetrating light armor like a rapier. But do less damage.
	// This effectively means you do 1.2x damage to armor, but 0.8x damage to flesh.
	penfactor = PEN_MEDIUM
	damfactor = 0.8
	intent_intdamage_factor = 1.5

/datum/intent/sword/chop/long/master
	name = "下劈斩"
	icon_state = "inchop"
	desc = "挥剑划出大弧，以正刃劈向对手，但也会暴露自身破绽。对盾牌的破坏力更强，甚至能穿透硬皮甲。"
	attack_verb = list("狂怒地砍击", "有力地劈开", "凶猛地劈砍")
	// This is almost x2 slower than a regular longsword's chop, giving the opponent more time to riposte you.
	// This however will penetrate all Light AC armor except for brigandine parts. Also does x2 damage to shields.
	penfactor = PEN_MEDIUM
	demolition_mod = 2.0
	swingdelay = 0.8 SECONDS
	clickcd = CLICK_CD_CHARGED

/datum/intent/sword/thrust/long/deep/master
	name = "深入突刺"
	icon_state = "inlunge"
	desc = "越过对手的武器，精确刺向护甲缝隙，以杀伤对手而非破坏护甲为目的。出招时会暴露自身破绽。"
	attack_verb = list("谨慎地穿刺", "精准地突刺", "准确地贯穿")
	// Stab someone directly. 50% damage to armor.
	// Best used like an estoc.
	penfactor = PEN_HEAVY
	swingdelay_type = SWINGDELAY_PENALTY
	damfactor = 1.1
	swingdelay = 0.6 SECONDS
	intent_intdamage_factor = 0.5

/datum/intent/effect/daze/longsword/clinch
	name = "贴身柄击"
	desc = "贴近对手，使其难以攻击，并用剑首猛撞其面部。极短时间内降低对手的力量与体质，使其更难挣脱擒拿。仅可单手施展，可攻击头部、颅骨、鼻子和嘴部。"
	icon_state = "inpunish"
	attack_verb = list("强行贴身横斩")
	target_parts = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE)
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	// This is dagger punch but with a longsword.
	damfactor = 0.5
	clickcd = 14
	recovery = 10
	swingdelay_type = SWINGDELAY_NORMAL
	intent_effect = /datum/status_effect/debuff/dazed/swipe

/datum/intent/sword/thrust/long/halfsword/frei
	name = "半剑式"
	icon_state = "inimpale"
	desc = "一手握住长剑未开刃的部分，以此借力，施展精准而有力的刺击，钻入板甲缝隙并穿透锁子甲。仅可采用半剑握法施展。"
	attack_verb = list("刺穿", "贯穿")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	// This does the exact same damage through steel armor as a normal longsword but can crit through armor.
	// You're going to be disappointed if you use it on anything without armor. 0.8x damage to unarmored body parts.
	penfactor = PEN_BSTEEL
	clickcd = CLICK_CD_MELEE
	swingdelay = 1.2 SECONDS
	damfactor = 1
	blade_class = BCLASS_PICK

	// If someone feels like reworking Freifechter for the 4th time, I suggest making this a RIGID swing intent
	dodgeable_intent = TRUE
	parriable_intent = TRUE
	swingdelay_type = SWINGDELAY_NORMAL

/datum/intent/sword/thrust/long/halfsword/lesser
	name = "半剑式慢刺"
	clickcd = CLICK_CD_CHARGED

/datum/intent/effect/daze/longsword
	name = "反握柄击"
	desc = "迅速翻转武器，用钝端猛砸对手的喉咙、嘴或鼻子，妨碍其呼吸。动作缓慢，受击会被打断，但造成的削弱持续较久。仅可采用高位架势施展。"
	attack_verb = list("娴熟地猛击")
	intent_effect = /datum/status_effect/debuff/dazed/longsword
	// Compared to regular daze, this attack is slower and requires you hit harder to reach zones.
	// The debuff is, however, -3 PER/INT instead of -2.
	target_parts = list(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_NECK)
	swingdelay = 15

/datum/intent/effect/daze/longsword2h
	name = "怒击突刺"
	desc = "以一记打击挡住对手的武器，顺势前进刺向其双眼，严重妨碍视力。仅可采用半剑握法施展，且只能瞄准眼睛。"
	attack_verb = list("娴熟地戳刺")
	intent_effect = /datum/status_effect/debuff/dazed/longsword2h
	target_parts = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	blade_class = BCLASS_STAB
	clickcd = 20
	swingdelay = 1 SECONDS
	swingdelay_type = SWINGDELAY_PENALTY //less scary but still debilitating debuff. you should be riposting against these on reaction if you can

// A weaker strike for sword with high damage so that it don't end up becoming better than mace
/datum/intent/sword/strike/bad
	damfactor = 0.5

/datum/intent/sword/chop
	name = "劈砍"
	icon_state = "inchop"
	attack_verb = list("砍击", "劈砍")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = PEN_LIGHT
	swingdelay = 8
	damfactor = 1.0
	item_d_type = "slash"

/datum/intent/sword/chop/short
	damfactor = 0.9

/datum/intent/sword/chop/shotel
	reach = 2

/datum/intent/sword/cut/light
	damfactor = 0.9

/datum/intent/sword/cut/long
	clickcd = CLICK_CD_QUICK // Longsword 2H cut — faster than default, no extra damage

/datum/intent/sword/chop/long
	damfactor = 1.2

// Falx sacrifices a bit of damage compared to sabre, but it is similarly fast
// And have a very slight demolition mod to make it better vs shield
/datum/intent/sword/cut/falx
	clickcd = CLICK_CD_FAST
	damfactor = 1.15
	demolition_mod = 1.25

// A heavier chop on slower speed
/datum/intent/sword/chop/falx
	penfactor = PEN_MEDIUM

// A heavy cut different from sabre's by emphasis on demolition mod
// But not as good as that of axe
/datum/intent/sword/cut/falx/heavy
	name = "重挥"
	icon_state = "inhack"
	blade_class = BCLASS_CHOP
	damfactor = 1.4
	penfactor = PEN_HEAVY
	demolition_mod = 3
	swingdelay = 1 SECONDS
	swingdelay_type = SWINGDELAY_CANCEL
	parriable_intent = FALSE
	dodgeable_intent = FALSE

/datum/intent/sword/cut/krieg
	damfactor = 1.2
	clickcd = CLICK_CD_QUICK

/datum/intent/sword/chop/sabre
	damfactor = 1.15
	penfactor = PEN_MEDIUM

/datum/intent/rend/krieg
	intent_intdamage_factor = 0.2

/datum/intent/sword/cut/rend
	name = "撕裂"
	icon_state = "inrend"
	attack_verb = list("撕裂", "劈开")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	reach = 1
	swingdelay = 15
	penfactor = PEN_NONE
	damfactor = 2.5
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.05
	demolition_mod = 0.05

/datum/intent/sword/cut/rend/messer
	name = "全力挥斩"
	icon_state = "inhack"
	desc = "将全部力量倾注于战刀锋刃的一次凶狠劈斩。对披甲敌人效果不佳，挥击时也会露出破绽。落空时的体力惩罚是精准一击的两倍，对方招架起来同样更加困难。"
	attack_verb = list("凶猛地劈砍", "不顾一切地斩开")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	reach = 1
	swingdelay = 1 SECONDS
	penfactor = PEN_NONE
	damfactor = 2
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE
	item_d_type = "slash"
	misscost = 20
	intent_intdamage_factor = 0.05
	demolition_mod = 0.05
	swingdelay_type = SWINGDELAY_PENALTY
	parriable_intent = FALSE

/datum/intent/sword/chop/cleave
	name = "震慑劈砍"
	icon_state = "incarve"
	attack_verb = list("劈开", "撕裂", "斩穿")
	chargedrain = 1.8
	chargetime = 12
	swingdelay = 0
	damfactor = 1.5
	intent_intdamage_factor = 1.3
	desc = "一次强力打击，会根据你的力量对目标造成击退与减速。击退量随你的力量提升，从 X（1 格）到 XIII（3 格）。</br>若你的力量低于 X，则无法造成任何击退或减速。</br>无法每 5 秒内对同一目标连续使用一次以上。</br>倒地目标的击退距离减半。</br>未完全蓄力时，击退最多只有 1 格。"
	var/maxrange = 3

/datum/intent/sword/chop/cleave/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	var/chungus_khan_str = user.STASTR
	if(H.has_status_effect(/datum/status_effect/debuff/yeetcd))
		return // Recently knocked back, cannot be knocked back again yet
	if(chungus_khan_str < 10)
		return // Too weak to have any effect
	var/scaling = CLAMP((chungus_khan_str - 10), 1, maxrange)
	H.apply_status_effect(/datum/status_effect/debuff/yeetcd)
	H.Slowdown(scaling)
	// Copypasta from knockback proc cuz I don't want the math there
	var/knockback_tiles = scaling // 1 to 4 tiles based on strength
	if(H.resting)
		knockback_tiles = max(1, knockback_tiles / 2)
	if(user?.client?.chargedprog < 100)
		knockback_tiles = 1 // Minimal knockback on non-charged smash.
	var/turf/edge_target_turf = get_edge_target_turf(H, get_dir(user, H))
	if(istype(edge_target_turf))
		H.safe_throw_at(edge_target_turf, \
		knockback_tiles, \
		scaling, \
		user, \
		spin = FALSE, \
		force = H.move_force)

/datum/intent/sword/chop/cleave/prewarning()
	if(mastermob)
		playsound(mastermob, pick('sound/combat/rend_start.ogg'), 100, FALSE)

/datum/intent/sword/chop/cleave/super
	name = "势不可挡之斩"
	penfactor = PEN_BSTEEL

// GREATSWORDS
/datum/intent/sword/cut/zwei
	reach = 2

/datum/intent/sword/cut/zwei/cleave
	name = "裂斩"
	icon_state = "incleave"
	desc = "一记劈斩，会连第一个目标身后的第二个目标一并斩开。"
	attack_verb = list("劈开", "斩穿")
	clickcd = CLICK_CD_HEAVY
	damfactor = 1.3
	reach = 1 // No!!
	cleave = /datum/cleave_pattern/forward_cleave

/datum/intent/sword/cut/zwei/sweep
	name = "横扫斩"
	icon_state = "insweep"
	desc = "一记沉重的横扫，会斩开身前的所有目标。"
	attack_verb = list("横扫", "横斩")
	reach = 1
	clickcd = CLICK_CD_MASSIVE
	cleave = /datum/cleave_pattern/horizontal_sweep

/datum/intent/sword/thrust/zwei
	reach = 2

// Zhanmadao
/datum/intent/sword/cut/zhanmadao
	reach = 2
	damfactor = 1.2 // For all purpose, this is basically the Naginata cut but on a sword
	penfactor = PEN_LIGHT // Good vs NPC with 1 pip slash??

/datum/intent/sword/cut/zhanmadao/sweep
	name = "横扫斩"
	icon_state = "insweep"
	desc = "一记沉重的横扫，会斩开身前的所有目标。"
	attack_verb = list("横扫", "横斩")
	reach = 1
	damfactor = 1.2 // Let's see if increased damage would make it good
	clickcd = CLICK_CD_MASSIVE
	cleave = /datum/cleave_pattern/horizontal_sweep

/datum/intent/sword/thrust/zhanmadao
	reach = 2
	penfactor = PEN_LIGHT // It is called ZHANMADAO not PENMANDAO for a reason
	damfactor = 0.8

// ESTOC

/datum/intent/sword/thrust/estoc
	name = "突刺"
	penfactor = PEN_HEAVY	// Penetrates mail/plate at same-tier 20%. Estoc's purpose — point blank, telegraphed.
	damfactor = 1.2
	swingdelay = 0.5 SECONDS

/datum/intent/sword/thrust/estoc/lunge
	name = "突进"
	icon_state = "inlance"
	attack_verb = list("突进刺击")
	penfactor = PEN_LIGHT	// Fast attrition thrust — light pen, no swingdelay, quick clickcd.
	damfactor = 1.1
	swingdelay = 0
	clickcd = CLICK_CD_QUICK
	reach = 2

/datum/intent/sword/lunge
	name = "突进"
	icon_state = "inimpale"
	attack_verb = list("突进刺击")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	reach = 2
	damfactor = 1.3	//Zwei will still deal ~7-10 more damage at the same range, depending on user's STR.
	swingdelay = 8

//Banded iron sword intents
/datum/intent/sword/chop/powerstrike
	name = "强力一击"
	desc = "将九磅重的铁剑向后抡起，再猛然砸向敌人，造成毁灭性打击……前提是能够命中。维持蓄势会消耗体力。"
	attack_verb = list("全力猛击")
	chargetime = 7
	swingdelay = 9
	penfactor = PEN_MEDIUM
	chargedrain = 1.2

/datum/intent/sword/cut/short/banded
	name = "乱舞"
	desc = "毫无章法地疯狂挥剑，造成固定伤害。"
	clickcd = 6		//Faster than a sabre
	damfactor = 2.17	//Base damage of 15
