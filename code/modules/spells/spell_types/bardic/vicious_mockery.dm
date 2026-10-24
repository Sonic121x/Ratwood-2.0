#define MOCKERY_STACKS_MAX 2
#define MOCKERY_STACK_DURATION 30 SECONDS
#define MOCKERY_STAT_PER_STACK -1 // Each stack applies this to STR, SPD, INT, WIL
#define MOCKERY_COOLDOWN 20 SECONDS

GLOBAL_LIST_INIT(mockery_insults, list(
	"你就这点能耐？",
	"我祖母都比你能打！",
	"练习木人都比你更会还手！",
	"你是想打疼我？鲁特琴弦弹一下都比这疼！",
	"你打起架来像个奶农！",
	"阁下，我对你嗤之以鼻！",
	"连你的影子都替你丢脸！",
	"你挥起武器，像酒馆里喝到最后一杯的醉鬼！",
	"你母亲是只鼠人，你父亲一身杰克莓味！",
	"等大魔鬼要回他的屁股，你拿什么当脸？！",
	"你该找个铁匠——看来你还没备好斗智的家伙！",
	"练了多少回，才练得这么烂？！",
	"要借我的眼镜吗？过来拿啊！",
))

// ---- Vicious Mockery Projectile Spell ----

/datum/action/cooldown/spell/projectile/vicious_mockery
	source_aspect = /datum/magic_aspect/pseudo/bardic
	name = "恶毒嘲弄"
	desc = "以带着旋律的辱骂攻击目标。最多叠加两层，逐渐降低其属性。"
	button_icon = 'icons/mob/actions/xylixmiracles.dmi'
	button_icon_state = "mockery"
	spell_color = GLOW_COLOR_BARDIC
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/mockery_note
	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	cooldown_time = MOCKERY_COOLDOWN

	associated_skill = /datum/skill/misc/music
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/projectile/vicious_mockery/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return
	H.say(pick(GLOB.mockery_insults), forced = "spell", language = /datum/language/common)
	. = ..()

// ---- Mockery Projectile ----

/obj/projectile/magic/mockery_note
	name = "恶毒音符"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "mockery_note"
	damage = 0
	nodamage = TRUE
	speed = 1
	range = 8
	hitsound = 'sound/magic/mockery.ogg'
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE

/obj/projectile/magic/mockery_note/on_hit(target, blocked = FALSE)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check(TRUE, TRUE))
			visible_message(span_warning("[src]触及[target]时消散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(!M.can_hear())
			visible_message(span_warning("辱骂落入了聋耳！"))
			qdel(src)
			return BULLET_ACT_BLOCK
		if(out_of_effective_range())
			return
		// Stack the debuff
		var/datum/status_effect/debuff/mockery_stack/existing = M.has_status_effect(/datum/status_effect/debuff/mockery_stack)
		if(existing)
			existing.add_stack()
		else
			M.apply_status_effect(/datum/status_effect/debuff/mockery_stack)
		if(firer)
			SEND_SIGNAL(firer, COMSIG_VICIOUSLY_MOCKED, target)
		playsound(get_turf(target), hitsound, 60, TRUE)
	return ..()

// ---- Stacking Mockery Debuff ----

/datum/status_effect/debuff/mockery_stack
	id = "mockery_stack"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/mockery_stack
	duration = MOCKERY_STACK_DURATION
	var/stacks = 1

/atom/movable/screen/alert/status_effect/debuff/mockery_stack
	name = "恶毒嘲弄"
	desc = "<span class='warning'>那吟游诗人的话比利刃还伤人！</span>\n"

/datum/status_effect/debuff/mockery_stack/on_apply()
	. = ..()
	apply_stack_effects()
	owner.balloon_alert_to_viewers("遭到嘲讽（x[stacks]）")
	owner.visible_message(
		span_warning("[owner]因嘲讽而退缩！"),
		span_userdanger("吟游诗人的话刺痛了我——我无法专注！"))

/datum/status_effect/debuff/mockery_stack/proc/add_stack()
	remove_stack_effects()
	stacks = min(stacks + 1, MOCKERY_STACKS_MAX)
	refresh()
	apply_stack_effects()
	owner.balloon_alert_to_viewers("遭到嘲讽（x[stacks]）")
	if(stacks >= MOCKERY_STACKS_MAX)
		to_chat(owner, span_userdanger("嘲讽越来越扎心——我几乎无法清醒思考！"))
	update_alert()

/datum/status_effect/debuff/mockery_stack/proc/apply_stack_effects()
	if(!owner)
		return
	var/penalty = stacks * MOCKERY_STAT_PER_STACK
	effectedstats = list(STATKEY_STR = penalty, STATKEY_SPD = penalty, STATKEY_INT = penalty, STATKEY_WIL = penalty)
	for(var/statkey in effectedstats)
		owner.change_stat(statkey, effectedstats[statkey])

/datum/status_effect/debuff/mockery_stack/proc/remove_stack_effects()
	if(!owner || !effectedstats)
		return
	for(var/statkey in effectedstats)
		owner.change_stat(statkey, -effectedstats[statkey])

/datum/status_effect/debuff/mockery_stack/proc/update_alert()
	if(!linked_alert)
		return
	linked_alert.name = "恶毒嘲讽（[stacks]/[MOCKERY_STACKS_MAX]）"

/datum/status_effect/debuff/mockery_stack/on_remove()
	to_chat(owner, span_info("嘲讽带来的刺痛消退了。"))
	. = ..()

#undef MOCKERY_STACKS_MAX
#undef MOCKERY_STACK_DURATION
#undef MOCKERY_STAT_PER_STACK
#undef MOCKERY_COOLDOWN
