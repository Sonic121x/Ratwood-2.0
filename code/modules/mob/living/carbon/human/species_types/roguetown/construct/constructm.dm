/mob/living/carbon/human/species/construct/metal
	race = /datum/species/construct/metal
	construct = 1

/datum/species/construct/metal
	name = "Metal Construct"
	id = "constructm"
	desc = "<b>金属构装体</b><br>\
	工艺巅顶之作，金属构装体正如其名——完全由凡人之手打造。他们并非血肉之躯，而是冰冷的金属与奥术的结晶。据说构装体起源于齐佐的造物，他们来自遥远的南方虚空——一座伟大的工艺之城，那里居住着唯一能够理解构装体制造之法的技匠。出于某种原因，近来他们开始走出虚空。共鸣虹吸之子。<br>\
	(+1 意志, -2 速度)<br>\
	(失眠症, 无需进食, 无血液。)"

	construct = 1
	skin_tone_wording = "材质"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,NOBLOOD)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = 1
	possible_ages = ALL_AGES_LIST
	skinned_type = /obj/item/ingot/steel
	disliked_food = NONE
	liked_food = NONE
	inherent_traits = list(
		TRAIT_NOHUNGER,
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_NOBREATH,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_TOXIMMUNE,
		TRAIT_NOSLEEP,
		TRAIT_NOMETABOLISM,
		TRAIT_NOPAIN,
		)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mcom.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fcom.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_BREASTS = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		OFFSET_BREASTS_F = list(0,-1), \
		)
	race_bonus = list(STAT_WILLPOWER = 1, STAT_SPEED = -2)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/construct,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/construct,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/construct,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/construct,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/construct,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/construct,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/construct,
		)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/crest,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/ears/demihuman,
		/datum/customizer/organ/horns/demihuman,
		/datum/customizer/organ/tail/demihuman,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/construct_plating_light,
		/datum/body_marking_set/construct_plating_medium,
		/datum/body_marking_set/construct_plating_heavy,
		)
	body_markings = list(
		/datum/body_marking/eyeliner,
		/datum/body_marking/tall_eyes,
		/datum/body_marking/outer_tall_eyes,
		/datum/body_marking/blank_face,
		/datum/body_marking/plain,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/construct_plating_light,
		/datum/body_marking/construct_plating_medium,
		/datum/body_marking/construct_plating_heavy,
		/datum/body_marking/construct_head_standard,
		/datum/body_marking/construct_head_round,
		/datum/body_marking/construct_standard_eyes,
		/datum/body_marking/construct_visor_eyes,
		/datum/body_marking/construct_psyclops_eye,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly,
		/datum/body_marking/waist,
		/datum/body_marking/diagonal_eyes,
		/datum/body_marking/wide_eyes,
		/datum/body_marking/stripes,
	)

	restricted_virtues = list(/datum/virtue/utility/deathless)
	restricted_quirks = list(/datum/quirk/noble)

/datum/species/construct/metal/check_roundstart_eligible()
	return TRUE

/datum/species/construct/metal/get_skin_list()
	return list(
		"Brass" = CONSTRUCT_BRASS,
		"Iron" = CONSTRUCT_IRON,
		"Steel" = CONSTRUCT_STEEL,
		"Bronze" = CONSTRUCT_BRONZE,
		"Toper" = CONSTRUCT_TOPER,
		"Coal" = CONSTRUCT_COAL,
		"Cobalt" = CONSTRUCT_COBALT,
		"Granite" = CONSTRUCT_GRANITE,
		"Jade" = CONSTRUCT_JADE,
		"Amythortz" = CONSTRUCT_AMETHYST,
		"Silver" = CONSTRUCT_SILVER,
		"Coral" = CONSTRUCT_CORAL,
		"Gold" = CONSTRUCT_GOLD,
		"Limestone" = CONSTRUCT_LIMESTONE,
		"Copper" = CONSTRUCT_COPPER,
		"Rust" = CONSTRUCT_RUST,
		"Obsidian" = CONSTRUCT_OBSIDIAN,
		"Lapis" = CONSTRUCT_LAPIS,
		"Basalt" = CONSTRUCT_BASALT
	)

/datum/species/construct/metal/get_hairc_list()
	return sortList(list(

	"black - midnight" = "1d1b2b",

	"red - blood" = "822b2b"

	))

/datum/species/construct/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.construct = TRUE

/datum/species/construct/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.construct = FALSE


//construct upgrade item so they can gain skills
/obj/item/construct_skill_core
	icon = 'icons/roguetown/items/misc.dmi'
	name = "构装体技能拓展器"
	desc = "一组围绕铜杆连接的齿轮。植入构装体头部后，可使其技能突破原有设计的限制。"
	icon_state = "construct_upgrade"
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = /obj/item/ingot/bronze
	///allow construct to use it on themselves without skill reqs, exclusively used for the black market ver
	var/self_usable = FALSE
	///to avoid situations where the dialog box is open but you click the golem again with it
	var/in_use = FALSE 

/obj/item/construct_skill_core/blackmarket
	name = "改装构装体技能拓展器"
	desc = "一组围绕铜杆连接的齿轮。植入魔像头部后，可使其技能突破原有设计的限制。这个似乎经过专门改装，让魔像能够自行使用。"
	self_usable = TRUE

/obj/item/construct_skill_core/examine(mob/user)
	. = ..()
	if(in_use)
		. += span_warning("它正在旋转，发出嗡嗡声。")

/obj/item/construct_skill_core/attack(mob/living/T, mob/U)
	if(!ishuman(U))
		return
	var/mob/living/user = U
	if(!ishuman(T))
		to_chat(user, span_warning("[T]不是构装体，使用它不会有效果。"))
		return

	var/mob/living/carbon/human/M = T
	if(!M.construct)
		if(user == M)
			to_chat(user, span_warning("我不是构装体，使用它不会有效果。"))//Golems can't upgrade themselves anyway, but I think it's at least somewhat useful to say something when an organic tries to use it on themselves
		else
			to_chat(user, span_warning("[M]不是构装体，使用它不会有效果。"))
		return
	if(user.construct && !self_usable)
		to_chat(user, span_warning("我无法改造构装体，必须请别人帮忙。"))//Golems NEED to ask organics to modify them.
		return
	if(user.get_skill_level(/datum/skill/craft/engineering) < 3 && !self_usable) //need to be at least level 3 skill level in engineering to use this
		to_chat(user, span_warning("我摆弄着[src]，试图将其正确植入[M]体内，但我的技术还不够娴熟。"))
		return
	if(in_use)
		to_chat(user, span_warning("还不行——[src]仍在运转。"))
		return

	var/list/learnable_skills = list()
	var/list/skill_datums = list()
	if(!M.mind)
		return
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill = GetSkillRef(skill_type)
		if(skill in M.skills?.known_skills)
			if(M?.mind?.sleep_adv.enough_sleep_xp_to_advance(skill_type, 1))
				LAZYADD(learnable_skills, skill)//we need the actual names of the skill_types so the dialog boxes say "Skill" rather than the type path
				LAZYADD(skill_datums,skill_type)//hold the skill datums so we can reference them later to use in our leveling up procs

	if(!length(learnable_skills))//don't waste the core if we can't use it
		to_chat(user, span_warning("[M]没有可以提升的技能。"))
		return

	in_use = TRUE
	smeltresult = null //edge case where you'd fully activate it and then smelt it before the golem selects their skill to level, I like denying the smelt more than denying the skill up
	var/time_to_upgrade = 130
	time_to_upgrade -= (user.get_skill_level(/datum/skill/craft/engineering) * 10)//starts at 10 seconds normally, reduced by 1 second per each engineering skill level above 3

	user.visible_message(span_notice("[user]将[src]抵在[M]的头部。"), span_notice("我开始将[src]植入[M]的头部。"))
	if(!do_mob(user, M, time_to_upgrade))
		disable()
		return

	var/skill_choice = input(M, "提升自己的技能。","技能") as null|anything in learnable_skills
	if(!skill_choice)
		return
	for(var/real_skill in skill_datums)//really ugly but I can't think of a way to implement this to show the skill names properly in the dialog box. real_skill is the actual datum for the skill rather than the "Skill" string
		if(skill_choice == GetSkillRef(real_skill))
			if(!M?.mind?.sleep_adv.enough_sleep_xp_to_advance(real_skill, 1))//this should only ever happen if you try and install two knowledge cores at the same time for the same skill, which we don't want to happen
				user.visible_message(span_notice("[src]在[user]手中嘶响后停了下来。"), span_notice("[src]嘶响后恢复了静止状态。"))
				disable()
				return
			M.mind.sleep_adv.adjust_sleep_xp(real_skill, -M.mind.sleep_adv.get_requried_sleep_xp_for_skill(real_skill, 1))
			M.adjust_skillrank(real_skill, 1, FALSE)
			//GLOB.scarlet_round_stats[STATS_SKILLS_DREAMED]++ //up for debate whether golems gaining skills like this should count
			M.visible_message(span_notice("[M]吸收了[src]。"), span_notice("我将[src]吸收入体内，技艺更加精进。"))
			if(M.get_skill_level(real_skill) >= 4)//if our skill is now expert or more, gain a triumph
				to_chat(M, span_boldgreen("在[LOWER_TEXT(skill_choice)]方面获得如此精湛的造诣，堪称真正的凯旋。"))
				M.adjust_triumphs(1)
			M.allmig_reward++//we also need to do this for RCP and endround triumphs- it's the closest thing Golems have to sleeping.
			qdel(src)
			return
		else //if you click "cancel" in the dialog
			user.visible_message(span_notice("[src]在[user]手中停止运转。"), span_notice("[src]关闭了。也许[M]还不想提升技能？"))
			disable()
			return

/obj/item/construct_skill_core/proc/disable() //reset it to inactive mode to be paired later on
	in_use = FALSE
	smeltresult = /obj/item/ingot/bronze
	
