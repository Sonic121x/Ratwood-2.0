/datum/advclass/wretch/herald_of_progress
	name = "进步先驱"
	tutorial = "你的旋律带来关于未来的忧郁幻象。你的独白总被往昔的隐秘真相所打断。畏惧变革吧，然而明日的许诺终究会一一应验。你是进步的传令官，是那未来之事的预言者。谷地是一座舞台，而你是她的嗓音。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/herald_of_progress
	cmode_music = 'sound/music/combatheraldprogress.ogg'
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_DECEIVING_MEEKNESS, TRAIT_OVERTHERETIC)
	maximum_possible_slots = 1 // only one frontman
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN, //sneaky evil bard
		/datum/skill/misc/music = SKILL_LEVEL_LEGENDARY,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, 
	)
	subclass_stats = list(
		STATKEY_WIL = 4,
		STATKEY_CON = 2,
		STATKEY_SPD = 2,
	)
	subclass_stashed_items = list(
		"缝纫套件" = /obj/item/repair_kit,
	)

/datum/outfit/job/roguetown/wretch/herald_of_progress/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/roguehood/red
	mask = /obj/item/clothing/mask/rogue/lordmask/zizite
	cloak = /obj/item/clothing/cloak/raincloak/red
	neck = /obj/item/clothing/neck/roguetown/chaincoif/ 
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	r_hand = /obj/item/rogue/instrument/ztratocaster
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
	beltr  = /obj/item/rogueweapon/huntingknife/idagger/steel
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/lockpick = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot	= 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	
		)
	if(H.mind)
		H.set_patron(/datum/patron/inhumen/zizo)
		if(H.mind.current)
			H.mind.current.faction += "[H.name]_faction"
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.suppress_grants = TRUE
		C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/orison)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/lesser_heal)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blood_heal)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/tame_undead/miracle)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_formation/sotto_voce)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/command_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blink/staccato)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/the_division_bell)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/forzando)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/song/of_her_embrace)
		var/datum/inspiration/I = new /datum/inspiration(H)
		I.grant_inspiration(H, bard_tier = BARD_T3)
		H.set_blindness(0)
		wretch_select_bounty(H)

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE
	devotion_cost = 80
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/sotto_voce
	name = "自坟墓的呼唤"
	desc = "以一段可怖的低吟唤起一队心智简单的骷髅亡灵。"
	associated_skill = /datum/skill/misc/music
	miracle = TRUE
	devotion_cost = 80
	zizo_spell = TRUE
	recharge_time = 200 SECONDS
	sound = list('sound/magic/sottovoce.ogg')
	invocations = list("奏出一段脉动而可怖的旋律回路。")
	invocation_type = "emote"

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/sotto_voce/cast(list/targets, mob/living/user)
	if(!user.has_status_effect(/datum/status_effect/buff/playing_music))
		revert_cast()
		to_chat(user, span_warning("我必须正在演奏，才能呼唤亡者。"))
		return FALSE
	if(!user.is_holding_item_of_type(/obj/item/rogue/instrument))
		revert_cast()
		to_chat(user, span_warning("我手中必须拿着乐器，才能呼唤亡者。"))
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/tame_undead/miracle
	associated_skill = /datum/skill/misc/music
	miracle = TRUE
	devotion_cost = 100
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/blink/staccato
	name = "遁入虚空"
	associated_skill = /datum/skill/misc/music
	sound = list('sound/magic/heraldblink.ogg')
	invocations = list("尖啸出一个短促、尖锐的震撼和弦。")
	invocation_type = "emote"

/obj/effect/proc_holder/spell/invoked/blink/staccato/cast(list/targets, mob/living/user = usr)
	if(!user.has_status_effect(/datum/status_effect/buff/playing_music))
		revert_cast()
		to_chat(user, span_warning("我必须正在演奏，才能引导我的节奏。"))
		return FALSE
	if(!user.is_holding_item_of_type(/obj/item/rogue/instrument))
		revert_cast()
		to_chat(user, span_warning("我手中必须拿着乐器，才能引导我的节奏。"))
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/forzando
	name = "驾驭闪电"
	associated_skill = /datum/skill/misc/music
	projectile_type = /obj/projectile/magic/lightning/forzando
	sound = list('sound/magic/heraldzap.ogg')
	invocations = list("撕裂出一段电光般的叠句！")
	invocation_type = "emote"

/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/forzando/cast(list/targets, mob/living/user = usr)
	if(!user.has_status_effect(/datum/status_effect/buff/playing_music))
		revert_cast()
		to_chat(user, span_warning("我必须正在演奏，才能引导我的节奏。"))
		return
	if(!user.is_holding_item_of_type(/obj/item/rogue/instrument))
		revert_cast()
		to_chat(user, span_warning("我手中必须拿着乐器，才能引导我的节奏。"))
		return
	return ..()

/obj/projectile/magic/lightning/forzando
	bypass_antimagic = TRUE // it's not magic, it's music, so idc about anti magic

/obj/effect/proc_holder/spell/self/the_division_bell
	name = "分裂之钟"
	desc = "切换我的音乐是搅扰安逸者，还是抚慰不安者。"
	associated_skill = /datum/skill/misc/music
	recharge_time = 1 SECONDS
	chargetime = 0
	releasedrain = 0
	chargedrain = 0
	invocation_type = "none"
	antimagic_allowed = TRUE
	human_req = TRUE

/obj/effect/proc_holder/spell/self/the_division_bell/cast(list/targets, mob/living/carbon/human/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/herald_progress_harmony))
		user.remove_status_effect(/datum/status_effect/buff/herald_progress_harmony)
		to_chat(user, span_warning("我的音乐将揭示信徒与畏惧者的分野。"))
	else
		user.apply_status_effect(/datum/status_effect/buff/herald_progress_harmony)
		to_chat(user, span_notice("我的音乐将如寻常歌曲般抚慰人群。"))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/herald_progress_harmony
	name = "分裂之钟"
	desc = "我的演奏目前安抚着听众，而非加重无知者的负担。"
	icon_state = "buff"

/datum/status_effect/buff/herald_progress_harmony
	id = "herald_progress_harmony"
	alert_type = /atom/movable/screen/alert/status_effect/buff/herald_progress_harmony
	duration = -1

/obj/effect/proc_holder/spell/invoked/song/of_her_embrace
	name = "她的拥抱"
	desc = "一首独一无二而奇异的赞美诗，听来如同前所未闻之物。附近的骷髅全属性 +2，不论敌我，代价是自身 -2 体质。"
	invocations = list("奏出一段不谐而狂乱的旋律。")
	invocation_type = "emote"
	overlay_state = "dirge_t3_base"
	action_icon_state = "dirge_t3_base"

/obj/effect/proc_holder/spell/invoked/song/of_her_embrace/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		if(!user.is_holding_item_of_type(/obj/item/rogue/instrument))
			revert_cast()
			to_chat(user, span_warning("我手中必须拿着乐器，才能引导她的节奏！"))
			return
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/of_her_embrace)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("我必须正在演奏，才能引导她的节奏！"))
		return

/datum/status_effect/buff/playing_melody/of_her_embrace
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt1
	buff_to_apply = /datum/status_effect/buff/song/of_her_embrace

/datum/status_effect/buff/playing_melody/of_her_embrace/on_apply()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/debuff/of_her_embrace)

/datum/status_effect/buff/playing_melody/of_her_embrace/on_remove()
	owner.remove_status_effect(/datum/status_effect/debuff/of_her_embrace)
	return ..()

/datum/status_effect/buff/playing_melody/of_her_embrace/tick()
	var/mob/living/carbon/human/O = owner
	if(!O.inspiration)
		return
	new effect(get_turf(owner))
	pulse += 1
	if(pulse >= ticks_to_apply)
		pulse = 0
		O.energy_add(-12.5) 
		for(var/mob/living/L in hearers(10, owner))
			if(istype(L, /mob/living/simple_animal/hostile/rogue/skeleton) || istype(L, /mob/living/carbon/human/species/skeleton)) //sing for the necrodancer
				L.apply_status_effect(buff_to_apply)

/atom/movable/screen/alert/status_effect/buff/song/of_her_embrace
	name = "统御"
	desc = "强化的谐律在我骨骼中奔涌。我感到更强、更快、更敏锐。"
	icon_state = "buff"

/datum/status_effect/buff/song/of_her_embrace
	id = "ofherembrace"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/of_her_embrace
	duration = 15 SECONDS
	effectedstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_LCK = 2,
	)

/atom/movable/screen/alert/status_effect/debuff/of_her_embrace
	name = "符文之下"
	desc = "我自己的演奏被压制了，这是唤起她异象的代价。我感到自己的生机正被抽入这首赞美诗中。"
	icon_state = "debuff"

/datum/status_effect/debuff/of_her_embrace
	id = "ofherembracedebuff"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/of_her_embrace
	duration = -1
	effectedstats = list(STATKEY_CON = -2)
