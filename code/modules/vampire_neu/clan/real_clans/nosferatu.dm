/datum/sprite_accessory/ears/nosferatu
	icon_state = "nosferatu"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/clan_leader/nosferatu
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/rat
	)
	lord_title = "Nosferatu"

/datum/clan/nosferatu
	name = "鼠裔氏族"
	desc = "鼠裔氏族的诅咒显露于外。初拥令他们的身体扭曲畸变，他们潜伏于各座城市的边缘，充当间谍与情报掮客。借助动物和超自然的隐匿能力，没有什么能逃过这些所谓“下水道老鼠”的眼睛。"
	curse = "暴露血族身份的外貌。"
	clanicon = "melpominee"
	leader = /datum/clan_leader/nosferatu
	clane_covens = list(
		/datum/coven/potence,
		/datum/coven/quietus,
		/datum/coven/obfuscate,
	)
	blood_preference = BLOOD_PREFERENCE_RATS | BLOOD_PREFERENCE_DEAD | BLOOD_PREFERENCE_KIN
	extra_clan_traits = list(
		TRAIT_KEENEARS,
	)
	covens_to_select = 0

/datum/clan/nosferatu/get_downside_string()
	return "面目可憎，且受阳光折磨"

/datum/clan/nosferatu/get_blood_preference_string()
	return "血族、死者与害兽的血液"

/datum/clan/nosferatu/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	. = ..()

	if(is_vampire)
		H.ventcrawler = VENTCRAWLER_ALWAYS //someone might add vents

/datum/clan/nosferatu/on_lose(mob/living/carbon/human/vampire)
	. = ..()
	vampire.ventcrawler = initial(vampire.ventcrawler)

	var/datum/component/hideous_face/face_comp = vampire.GetComponent(/datum/component/hideous_face)
	if(face_comp)
		qdel(face_comp)

/datum/clan/nosferatu/apply_clan_components(mob/living/carbon/human/H)
	pass()
	H.AddComponent(/datum/component/sunlight_vulnerability, damage = 2, drain = 2)
	H.AddComponent(/datum/component/vampire_disguise/nosferatu)
	H.AddComponent(/datum/component/hideous_face, CALLBACK(src, PROC_REF(face_seen)))

/datum/clan/nosferatu/apply_vampire_look(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
	ears?.set_accessory_type(/datum/sprite_accessory/ears/nosferatu)

/datum/clan/nosferatu/remove_vampire_look(mob/living/carbon/human/H)
	return

/datum/clan/nosferatu/proc/face_seen(mob/living/carbon/human/nosferatu)
	nosferatu.AdjustMasquerade(-1)

/datum/clan/nosferatu/get_frenzy_messages()
	return list(
		"我皮肤下的东西[span_danger("露出了獠牙")]，我再也藏不住它。",
		"隐匿多年，兽性却要将我拖进[span_danger("光亮")]中进食。",
		"我扭曲的身躯竭力伸向他们，耐心被[span_danger("啃噬殆尽")]。",
		"我显露于外的怪物[span_userdanger("想要挣脱束缚")]。",
		"每一分下水道中养成的本能都在尖叫，催我扼住喉咙并[span_danger("痛饮")]。",
	)
