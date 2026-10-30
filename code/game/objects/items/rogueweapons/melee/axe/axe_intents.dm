//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/axe/cut
	name = "劈砍"
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("切开", "挥砍")
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	animname = "cut"
	penfactor = PEN_LIGHT
	damfactor = 1.3
	demolition_mod = 2.5
	clickcd = CLICK_CD_CHARGED // Shield DPS: 10 / 1.4 = 8.9. Will out DPS sword no matter what.
	chargetime = 0
	item_d_type = "slash"

/datum/intent/axe/chop
	name = "砍劈"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("砍击", "劈砍")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = PEN_MEDIUM
	damfactor = 1.5
	demolition_mod = 2.5
	swingdelay = 0.8 SECONDS
	swingdelay_type = SWINGDELAY_PENALTY
	clickcd = CLICK_CD_CHARGED // Effective Shield DPS: 25 / 2.4 = 10.4
	item_d_type = "slash"

/datum/intent/axe/thrust
	name = "尖端突刺"
	animname = "stab"
	icon_state = "instab"
	warnie = "mobwarning"
	penfactor = PEN_MEDIUM
	clickcd = CLICK_CD_CHARGED
	damfactor = 0.9
	item_d_type = "stab"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	blade_class = BCLASS_STAB
	attack_verb = list("突刺")

/datum/intent/axe/rangedthrust
	name = "突刺"
	blade_class = BCLASS_STAB
	attack_verb = list("突刺")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	clickcd = CLICK_CD_CHARGED
	recovery = 30
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_MEDIUM
	item_d_type = "stab"
	desc = "全力刺出戟斧的尖刺。只有在完全伸展、相距恰好两格时才能刺穿护甲，收招时也会使你露出破绽。"
	swingdelay = 8
	swingdelay_type = SWINGDELAY_PENALTY
	effective_range = 2
	effective_range_type = EFF_RANGE_EXACT

/datum/intent/axe/chop/heavy
	name = "劈砍"
	icon_state = "inhack"
	penfactor = PEN_BSTEEL
	damfactor = 1.5
	swingdelay = 1 SECONDS
	
	dodgeable_intent = FALSE
	parriable_intent = FALSE
	swingdelay_type = SWINGDELAY_CANCEL

/datum/intent/axe/chop/scythe
	reach = 2

/datum/intent/axe/chop/stone
	penfactor = PEN_NONE

/datum/intent/axe/chop/halberd
	damfactor = 1.3
	reach = 2

/datum/intent/axe/cut/long
	reach = 2
	damfactor = 1
	demolition_mod = 1

/datum/intent/axe/cut/long/dolabra
	demolition_mod = 3

/datum/intent/axe/cut/long/dolabra/pioneer
	demolition_mod = 4.5

/datum/intent/axe/cut/long/bronze
	damfactor = 1.1
	demolition_mod = 1.3

/datum/intent/axe/chop/long
	reach = 2
	damfactor = 1.2
	demolition_mod = 1.5

/datum/intent/axe/chop/long/woodcutter
	reach = 2
	demolition_mod = 3
/datum/intent/axe/chop/long/woodcutter/pioneer
	demolition_mod = 4.5

/datum/intent/axe/bash
	name = "猛砸"
	icon_state = "inbash"
	attack_verb = list("猛砸", "敲击")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = PEN_NONE
	swingdelay = 5
	damfactor = NONBLUNT_BLUNT_DAMFACTOR //Not a real blunt weapon, so less damage.
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/axe/bash/battle
	name = "重砸"
	damfactor = 0.8 //Buttstrokes, in essence. +20% damage over the standard variant.

/datum/intent/axe/bash/dolabra
	demolition_mod = 3

/datum/intent/axe/bash/dolabra/pioneer
	demolition_mod = 4.5
