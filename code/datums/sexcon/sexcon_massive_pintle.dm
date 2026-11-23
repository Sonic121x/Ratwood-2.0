// Massive pintle extras: insertion failure and receiver thoughts during penetration.

GLOBAL_LIST_INIT(massive_pintle_lines, list(
	"好大……我都能感觉到它顶到胃里了……",
	"这东西到底是怎么塞进来的？",
	"太满了……我都没法思考了……",
	"它快把我撑开了……",
	"我以后怕是没法再适应别人了……",
))

GLOBAL_LIST_INIT(massive_pintle_panic_lines, list(
	"操操操——这东西要弄死我！",
	"太大了太大了太大了！",
	"我要被劈成两半了！",
	"神啊，它顶到我的内脏里了！",
	"我受不了了，我受不了了！",
	"它要从我嘴里顶出来了！",
	"我就要这么死了！",
))

GLOBAL_LIST_INIT(massive_pintle_mouth_lines, list(
	"我喘不过气了……它一直顶到我喉咙里……",
	"我的下巴要脱臼了……",
	"太粗了，我连咽都咽不下去……",
	"我都能感觉到它顶到胸口了……",
))

GLOBAL_LIST_INIT(massive_pintle_mouth_panic_lines, list(
	"它顶进我肺里了！",
	"喘不上气喘不上气喘不上气！",
	"我的下巴要断了！",
	"我要被它噎死了！",
))

/// Describes the holes in a sex part bitfield, e.g. "cunt and ass".
/proc/sex_part_orifice_name(part)
	var/list/names = list()
	if(part & SEX_PART_CUNT)
		names += "阴道"
	if(part & SEX_PART_ANUS)
		names += "肛门"
	if(part & SEX_PART_SLIT_SHEATH)
		names += "裂鞘"
	if(part & SEX_PART_JAWS)
		names += "嘴"
	return english_list(names, nothing_text = "身体", and_text = "和", comma_text = "、")

/// For action between us and our target: whoever a massive pintle is going into, or null.
/// The receiver is the target when our cock goes in, or us when we ride or suck theirs.
/datum/sex_controller/proc/get_massive_pintle_receiver(datum/sex_action/action)
	if(!action || !target || target == user)
		return null
	if(action.is_cock_penetration())
		var/obj/item/organ/penis/pintle = user.getorganslot(ORGAN_SLOT_PENIS)
		return pintle?.massive ? target : null
	if(action.is_cock_penetration(cock_on_target = TRUE))
		var/obj/item/organ/penis/pintle = target.getorganslot(ORGAN_SLOT_PENIS)
		return pintle?.massive ? user : null
	return null

/// TRUE if anyone near us is riding or sucking our cock right now.
/datum/sex_controller/proc/is_pintle_occupied()
	var/list/nearby = range(1, user)
	if(!isturf(user.loc))
		nearby |= user.loc.contents
	for(var/mob/living/carbon/human/partner in nearby)
		if(partner == user)
			continue
		var/datum/sex_action/their_act = partner.sexcon?.get_action_towards(user)
		if(their_act?.is_cock_penetration(cock_on_target = TRUE))
			return TRUE
	return FALSE

/// The receiver's sex part used by action, given who the receiver is.
/datum/sex_controller/proc/get_receiver_part(datum/sex_action/action, mob/living/carbon/human/receiver)
	return receiver == target ? action.target_sex_part : action.user_sex_part

/// Rolls whether a massive pintle fails to fit when action starts. Returns TRUE and shows the messages on a fail.
/datum/sex_controller/proc/try_massive_insertion_fail(datum/sex_action/action)
	var/mob/living/carbon/human/receiver = get_massive_pintle_receiver(action)
	if(!receiver)
		return FALSE
	// Already knotted together: it's inside, so it clearly fits.
	var/mob/living/carbon/human/owner = receiver == target ? user : target
	if(owner.sexcon.knotted_status == KNOTTED_AS_TOP && owner.sexcon.knotted_recipient == receiver)
		return FALSE
	if(!prob(MASSIVE_PENIS_INSERT_FAIL_CHANCE))
		return FALSE
	var/orifice = sex_part_orifice_name(get_receiver_part(action, receiver))
	var/cock_word = action.uses_both_cocks ? "双根肉茎" : "肉茎"
	var/vision = do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE
	if(receiver == target)
		user.visible_message(span_warning("[user]想把那根巨大的[cock_word]硬塞进[target]的[orifice]，可它实在太大了！"), vision_distance = vision)
	else
		user.visible_message(span_warning("[user]想把[target]那根巨大的[cock_word]纳入自己的[orifice]，可它实在太大了！"), vision_distance = vision)
	to_chat(receiver, span_warning("塞不进去……！"))
	log_combat(user, target, "因巨根过大，无法开始互动：[action.name]")
	return TRUE

/// Each thrust, maybe gives the receiver of a massive pintle a private thought. The pool depends on our force and on whether it's their mouth.
/datum/sex_controller/proc/massive_pintle_receiver_line(datum/sex_action/action)
	var/mob/living/carbon/human/receiver = get_massive_pintle_receiver(action)
	if(!receiver)
		return
	// If we're riding/sucking and our partner is also thrusting a massive pintle into us, let their loop roll the lines so we don't get them twice.
	if(receiver == user)
		var/datum/sex_controller/partner_sexcon = target.sexcon
		if(partner_sexcon?.get_massive_pintle_receiver(partner_sexcon.get_action_towards(user)) == user)
			return
	var/panic = force >= SEX_FORCE_HIGH
	if(!prob(panic ? MASSIVE_PENIS_PANIC_LINE_CHANCE : MASSIVE_PENIS_LINE_CHANCE))
		return
	var/mouth = get_receiver_part(action, receiver) & SEX_PART_JAWS
	if(panic)
		to_chat(receiver, span_boldwarning(pick(mouth ? GLOB.massive_pintle_mouth_panic_lines : GLOB.massive_pintle_panic_lines)))
	else
		to_chat(receiver, span_love(pick(mouth ? GLOB.massive_pintle_mouth_lines : GLOB.massive_pintle_lines)))
