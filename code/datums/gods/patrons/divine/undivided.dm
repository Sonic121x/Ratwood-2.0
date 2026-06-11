/datum/patron/divine/undivided
	name = "Undivided"
	domain = "太阳、月亮、大地、正义、自由、海洋、创造、灵感、死亡、腐朽、爱、治愈与生命。"
	desc = "这是一个联合的万神殿，坚定地与黑暗对抗。THE TEN 向凡人赐下教诲与恩惠。其主要崇拜方式，是兼修并敬奉 THE TEN，从每一位神祇身上汲取教训。这是 Grenzelhoft Holy See 的主要神学。"
	worshippers = "Holy See 教士、THE TEN 的实用主义者"
	virtues = "节制、虔诚、谨慎"
	sins = "顽固、鲁莽、狂热"
	mob_traits = list()
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI, // ONLY Lower miracles of other lists. A much more varied utility miracle list, and a much wider selection. Also, our generic miracles(Lesser heal + Divine blast for acolytes) are better. But no specialization makes a lower level list. We're going to exclude Abyssor.
					/obj/effect/proc_holder/spell/self/astrata_gaze				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/darkvision/miracle	= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/bless_food            = CLERIC_T1,
					/obj/effect/proc_holder/spell/self/divine_strike			= CLERIC_T2,
					/obj/effect/proc_holder/spell/targeted/blesscrop			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/avert					= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/infestation			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/mockery				= CLERIC_T3, // you'll have to be a real xylix templar to get this pretty decent combat debuff, sorry.
					/obj/effect/proc_holder/spell/invoked/conjure_tool			= CLERIC_T3,
//					/obj/effect/proc_holder/spell/invoked/resurrect/undivided	= CLERIC_T4
	)
	confess_lines = list(
		"神圣十角将庇护我的灵魂！",
		"我侍奉这光辉的万神殿！",
		"THE TEN 永恒长存，直到永远！",
	)
	storyteller = null
	disabled_patron = TRUE//Disabled for lore reasons on RW

/datum/patron/divine/undivided/can_pray(mob/living/follower)
	. = ..()
	// Undivided - More restricted, needs to be within range of a pantheon cross or the church itself.
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("那座被亵渎的 psycross 打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE

/datum/patron/divine/undivided/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("一圈神圣之力拂过了 [target]！") // we're always good.
	*message_self = ("我正沐浴在神圣之力中！")

	*conditional_buff = TRUE
	*situational_bonus = 2
