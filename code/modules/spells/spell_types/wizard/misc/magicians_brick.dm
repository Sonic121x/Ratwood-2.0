/datum/action/cooldown/spell/magicians_brick
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "魔法砖"
	desc = "在你手中召唤一块魔法砖。它的力量与你的智力成正比。这块砖会一直存在，\n\
	直到召唤出新的砖块或法术被遗忘。"
	fluff_desc = "最古老的魔法之一，可能是在魔法石之后发明的（现在被认为已经过时）。它是少数被认为对反魔法防御完全无效的魔法之一，大概是因为一块砖头实在太平凡了，以至于魔法本身都拒绝被视为魔法，即使它真的是魔法。"
	button_icon_state = "magicians_brick"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("瓦尔塔雷姆！")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/rogueweapon/conjured_brick = null

/datum/action/cooldown/spell/magicians_brick/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(src.conjured_brick)
		qdel(conjured_brick)
	var/obj/item/rogueweapon/R = new /obj/item/rogueweapon/magicbrick(user.drop_location())
	R.AddComponent(/datum/component/conjured_item, null, FALSE, user, src)

	if(user.STAINT > 10)
		var/int_scaling = user.STAINT - 10
		R.force = R.force + int_scaling
		R.throwforce = R.throwforce + int_scaling * 2 // 2x scaling for throwing. Let's go.
		R.name = "魔法砖 +[int_scaling]"
	user.put_in_hands(R)
	src.conjured_brick = R
	return TRUE

/obj/item/rogueweapon/magicbrick
	name = "魔法砖"
	desc = "由奥术能量形成的砖块。不是实际的砖，不能用于建筑。可以作为非常致命的近战和投掷武器。被认为是施法用的工具。"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybrickcook"
	dropshrink = 0.75
	force = 15 // Copy pasted from real brick + 1 for neat number
	throwforce = 20 // +2 from real brick for neat scaling
	throw_speed = 4
	armor_penetration = PEN_NONE // It is a BRICK
	wdefense = 0
	wbalance = WBALANCE_NORMAL
	max_integrity = 50 // Don't parry with it lol
	slot_flags = ITEM_SLOT_MOUTH
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_refund = IMPLEMENT_REFUND_LESSER
	possible_item_intents = list(/datum/intent/mace/strike) // Not giving it smash so it don't become competetive with conjure weapon (as a melee weapon)
	associated_skill = /datum/skill/combat/arcyne // what could go wrong...
	hitsound = list('sound/combat/hits/blunt/brick.ogg')
