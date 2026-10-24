/datum/action/cooldown/spell/lesser_knock
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "次级开锁术"
	desc = "一道简单法术，将奥术聚为开锁工具。若将其用在门之外的东西上，法术就会消散。"
	button_icon_state = "knock"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("微启其锁。")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/lesser_knock/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/obj/item/melee/touch_attack/lesserknock/lockpick = new(user.drop_location())
	user.put_in_hands(lockpick)
	to_chat(user, span_notice("我准备施展一个小小的奥术咒法。"))
	return TRUE

/obj/item/melee/touch_attack/lesserknock
	name = "幽光撬锁针"
	desc = "一根微微发光的撬锁针，仿佛由奥术的奥秘勉强维系成形。想令其消散，只要把它用在门之外的东西上即可。"
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#3FBAFD" // spooky magic blue color that's also used by presti
	picklvl = 0.99
	max_integrity = 30
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF

/obj/item/melee/touch_attack/lesserknock/attack_self()
	qdel(src)
