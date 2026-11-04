#define RAGE_FILTER "rage_aura"

/proc/get_buff_value(mob/living/L)
	var/brute = L.getBruteLoss()
	var/burn = L.getFireLoss()
	var/ragedmgbuff = 0
	if(!HAS_TRAIT (L, TRAIT_RAGE)) //anyone without the trait is locked to small rage
		return 0
	if(brute + burn > 10) //early trigger, basically if you take PEN attacks
		ragedmgbuff = 1
	if(brute + burn > 75) //fight's been going on for a while, probably took some hits
		ragedmgbuff = 2
	if(brute + burn > 160) //getting close to being crit
		ragedmgbuff = 3
	return ragedmgbuff

/obj/effect/proc_holder/spell/self/rage
	name = "狂怒"
	desc = "伤痛点燃怒火，让他们也尝尝苦头——伤得越重，怒火越盛！"
	antimagic_allowed = TRUE
	clothes_req = FALSE
	recharge_time = 1 MINUTES
	invocations = list("陷入了暴怒！")
	overlay_state = "bcry"
	invocation_type = "emote"

/obj/effect/proc_holder/spell/self/rage/cast(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	user.apply_status_effect(/datum/status_effect/buff/rage)
	if(get_buff_value(user) >= 1)
		user.apply_status_effect(/datum/status_effect/buff/adrenaline_rush) //15 seconds of no bleed, stamina restore, minor buff
	if(get_buff_value(user) >= 2)
		user.apply_status_effect(/datum/status_effect/buff/rage_stamina)
	if(get_buff_value(user) >= 3)
		user.apply_status_effect(/datum/status_effect/buff/berserk_rush)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/rage
	name = "狂怒"
	desc = "你们惹怒我了！"
	icon_state = "buff"

/datum/status_effect/buff/rage
	id = "rage"
	examine_text = "<font color='red'>SUBJECTPRONOUN正口吐白沫！</font>"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rage
	effectedstats = list(STATKEY_STR = 2) //higher base, less boring stat scaling
	duration = 45 SECONDS
	var/ragebuff = 0
	var/outline_colour = "#ca0000"

/datum/status_effect/buff/rage/on_apply()
	. = ..()
	if(.)
		var/filter = owner.get_filter(RAGE_FILTER)
		if(!filter)
			owner.add_filter(RAGE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 120, "size" = 1))
		owner.emote("rage", forced = TRUE)
		to_chat(owner, span_notice("痛苦助长我的怒火，我的身体已准备好战斗！"))
		playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)

/datum/status_effect/buff/rage/on_remove()
	. = ..()
	owner.remove_filter(RAGE_FILTER)
	to_chat(owner, span_warning("怒火平息了。"))

/atom/movable/screen/alert/status_effect/buff/rage_stamina
	name = "怒火激涌"
	desc = "愤怒驱散了我的疲惫！"
	icon_state = "buff"

/datum/status_effect/buff/rage_stamina
	id = "rage stamina"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rage_stamina
	duration = 15 SECONDS
	var/healing_on_tick = 5

/datum/status_effect/buff/rage_stamina/tick()
	var/stamheal = healing_on_tick
	owner.energy_add(stamheal)

/datum/status_effect/buff/berserk_rush
	id = "berserk rush"
	alert_type = /atom/movable/screen/alert/status_effect/buff/berserk_rush
	effectedstats = list(STATKEY_CON = 2)
	duration = 45 SECONDS

/atom/movable/screen/alert/status_effect/buff/berserk_rush
	name = "势不可挡！"
	desc = "别想阻止我，我正打得痛快！"
	icon_state = "buff"

/datum/status_effect/buff/berserk_rush/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_HARDDISMEMBER, INNATE_TRAIT) //limbs still get disabled by damage
	ADD_TRAIT(owner, TRAIT_STRONGKICK, INNATE_TRAIT)//anti-dorpal insurance

/datum/status_effect/buff/berserk_rush/on_remove()
	. = ..()
	clear_berserk_rush()

/datum/status_effect/buff/berserk_rush/proc/clear_berserk_rush()
	REMOVE_TRAIT(owner, TRAIT_HARDDISMEMBER, INNATE_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_STRONGKICK, INNATE_TRAIT)

#undef RAGE_FILTER
