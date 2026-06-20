/obj/item/rogueweapon/surgery
	name = "手术工具"
	desc = "会撕裂你内脏的东西。"
	icon = 'icons/roguetown/items/surgery.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	force = 12
	throwforce = 12
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	max_blade_int = 200
	max_integrity = 175
	thrown_bclass = BCLASS_CUT
	associated_skill = /datum/skill/combat/knives
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = null

	grid_width = 32
	grid_height = 64

/obj/item/rogueweapon/surgery/Initialize(mapload)
	. = ..()
	item_flags |= SURGICAL_TOOL //let's not stab patients for fun

/obj/item/rogueweapon/surgery/scalpel
	name = "手术刀"
	desc = "用于在病患肉体上进行精准切割的工具。"
	icon_state = "scalpel"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	tool_behaviour = TOOL_SCALPEL
	smeltresult = null

/obj/item/rogueweapon/surgery/saw
	name = "骨锯"
	desc = "用于切骨的工具。"
	icon_state = "bonesaw"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	force = 16
	throwforce = 16
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_CHOP
	tool_behaviour = TOOL_SAW
	smeltresult = null

/obj/item/rogueweapon/surgery/hemostat
	name = "手术钳"
	desc = "用于夹持软组织的工具。"
	icon_state = "forceps"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_HEMOSTAT
	smeltresult = null

/obj/item/rogueweapon/surgery/hemostat/first //Three different types now to allow multiple surgical sites at once.
	name = "\improper 塔尔西斯钳"

/obj/item/rogueweapon/surgery/hemostat/second
	name = "\improper 西斯拉特钳"

/obj/item/rogueweapon/surgery/hemostat/third
	name = "\improper 梅德拉钳"

/obj/item/rogueweapon/surgery/retractor
	name = "扩张器"
	desc = "用于撑开组织以进行手术操作的工具。"
	icon_state = "speculum"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	tool_behaviour = TOOL_RETRACTOR
	smeltresult = null

/obj/item/rogueweapon/surgery/bonesetter
	name = "骨钳"
	desc = "用于夹持硬组织的工具。"
	icon_state = "bonesetter"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_BONESETTER
	smeltresult = null

/obj/item/rogueweapon/surgery/cautery
	name = "烙铁"
	desc = "用于烧灼伤口的工具。使用前先加热。"
	icon_state = "cauteryiron"
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	force = 18
	throwforce = 18
	wdefense = 3
	wbalance = WBALANCE_HEAVY	//huh?
	associated_skill = /datum/skill/combat/maces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	/// Timer to cool down
	var/cool_timer
	/// Whether or not we are heated up
	var/heated = FALSE
	smeltresult = null

/obj/item/rogueweapon/surgery/cautery/examine(mob/user)
	. = ..()
	if(heated)
		. += span_warning("尖端摸起来很烫。")

/obj/item/rogueweapon/surgery/cautery/update_icon_state()
	. = ..()
	icon_state = initial(icon_state)
	if(heated)
		icon_state = "[initial(icon_state)]_hot"

/obj/item/rogueweapon/surgery/cautery/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	var/heating = 0
	if(istype(A, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/forge = A
		if(forge.on)
			heating = 20
	if(heating)
		user.visible_message(span_info("[user]加热了[src]。"))
		fire_act(heating)
		return TRUE
	return ..()

/obj/item/rogueweapon/surgery/cautery/fire_act(added, maxstacks)
	. = ..()
	if(!heated)
		playsound(src, 'sound/items/firelight.ogg', 100, vary = TRUE)
	update_heated(TRUE)
	if(cool_timer)
		deltimer(cool_timer)
	cool_timer = addtimer(CALLBACK(src, PROC_REF(update_heated), FALSE), added SECONDS, TIMER_STOPPABLE)

/obj/item/rogueweapon/surgery/cautery/get_temperature()
	if(heated)
		return FIRE_MINIMUM_TEMPERATURE_TO_SPREAD
	return ..()

/obj/item/rogueweapon/surgery/cautery/proc/update_heated(new_heated)
	heated = new_heated
	if(heated)
		damtype = BURN
		tool_behaviour = TOOL_CAUTERY
	else
		damtype = BRUTE
		tool_behaviour = null
	update_icon()

/obj/item/rogueweapon/surgery/cautery/branding
	name = "烙印铁"
	desc = "在肉体上留下铭文的烙铁。使用前先加热。"
	icon_state = "brandingiron"
	possible_item_intents = list(/datum/intent/use)
	var/setbranding = null
	var/branding_damage = 20
	var/branding_low_quality = FALSE
	var/branding_count = 0

/obj/item/rogueweapon/surgery/cautery/branding/slave
	name = "奴隶烙印铁"
	desc = "用于在失物上标记所有权。使用前先加热。"

/obj/item/rogueweapon/surgery/cautery/branding/crude
	name = "粗糙烙印棍"
	desc = "由煤炭、绳子和一根棍子制成。看起来在断裂之前至少能给自己烙印两次。使用前先加热。"
	icon_state = "brandingiron_crude"
	branding_damage = 10
	branding_low_quality = TRUE
	branding_count = 2

/obj/item/rogueweapon/surgery/cautery/branding/examine(mob/user)
	. = ..()
	if(!setbranding || !length(setbranding))
		. += span_warning("尚未设置烙印符号。")
	else
		. += span_warning("它将印下[setbranding]。")

/obj/item/rogueweapon/surgery/cautery/branding/attack_self(mob/living/user)
	. = ..()
	if(!istype(user))
		return
	if(!user.cmode)
		if(heated)
			to_chat(user, span_warning("太烫了，无法更换符号！"))
			return
		var/inputty = stripped_input(user, "你想设置什么烙印？\n例如：一幅小型的劳斯头部图画", "输入烙印描述", null, 64)
		if(inputty)
			setbranding = inputty
			to_chat(user, span_warning("我更换了[!branding_low_quality ? "铁制" : "煤炭"]尖端，它将印下[setbranding]。"))
		else
			setbranding = null
	..()

/obj/item/rogueweapon/surgery/cautery/branding/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	if(!heated)
		return ..()
	if(!setbranding || !length(setbranding))
		to_chat(user, span_warning("没有可烙印的内容，先添加一些标记再使用。"))
		return TRUE
	if(!A || !ishuman(A))
		to_chat(user, span_warning("我无法烙印\the [A]。"))
		return TRUE
	var/mob/living/carbon/target = A
	if(!istype(target))
		to_chat(user, span_warning("我无法烙印\the [A]。"))
		return TRUE
	var/branding_self = user == target
	if(!branding_self)
		if(branding_low_quality && (target.stat == CONSCIOUS)) // we can only brand ourselves OR the other character must be unconscious
			to_chat(user, span_warning("[target.p_they(TRUE)]动得太厉害了，我没法给[target.p_them()]烙印！"))
			return TRUE
		user.visible_message(span_warning("[user]缓缓地将\the [src]伸向[A]。"))
		to_chat(target, span_userdanger("[user]正试图用\the [src]烙印我！"))
	else
		user.visible_message(span_warning("[user]缓缓地将\the [src]对准自己。"))

	log_combat(user, target, "Branding attempt: \"[setbranding]\"")
	var/branding_delay = HAS_TRAIT(user, TRAIT_DUNGEONMASTER) ? 5 SECONDS : (HAS_TRAIT(user, TRAIT_KNOWNCRIMINAL) ? 7 SECONDS : 12 SECONDS) // criminals/dungeoneer burn faster, while non-criminals and towners take the longest time
	if(branding_low_quality) // take longer for low quality branding tool
		branding_delay += 5 SECONDS
	if(!do_after(user, branding_delay, target = A))
		log_combat(user, target, "Branding aborted: \"[setbranding]\"")
		return TRUE
	if(!user.Adjacent(target) || user.stat >= UNCONSCIOUS)
		return TRUE
	if(!get_location_accessible(target, user.zone_selected))
		to_chat(user, span_warning("衣物遮挡了[LOWER_TEXT(parse_zone(user.zone_selected))]部位。"))
		if(!branding_self)
			to_chat(target, span_userdanger("[user]把\the [src]移开了。"))
		return TRUE
	var/check_zone = check_zone(user.zone_selected)
	var/obj/item/bodypart/branding_part = target.get_bodypart(check_zone)
	if(!branding_part) //missing limb
		to_chat(user, span_warning("不幸的是，那里什么都没有。"))
		if(!branding_self)
			to_chat(target, span_userdanger("[user]把\the [src]移开了。"))
		return TRUE

	var/description_recoil = target.stat < UNCONSCIOUS ? pick("缩了一下", "扭动了一下", "挣扎了一下", "痛苦不已") : "静静地躺着"
	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN) // if targeting the groin, handle marking buttocks and genitals instead of a single chest zone
		var/answer = tgui_alert(user, "你想烙印什么部位？", "请在[DisplayTimeText(100)]内回答！", list("臀部", "裆部", "取消"), 100)
		if(!answer || answer == "取消")
			to_chat(user, span_warning("我把\the [src]移开了。"))
			if(!branding_self)
				to_chat(target, span_userdanger("[user]把\the [src]移开了。"))
			return TRUE
		if(answer == "臀部")
			var/obj/item/bodypart/chest/buttocks = branding_part
			if(QDELETED(buttocks) || !user.Adjacent(target) || !istype(buttocks)) // body part no longer exists/moved away
				return TRUE
			if(length(buttocks.branded_writing_on_buttocks))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			buttocks.branded_writing_on_buttocks = setbranding
		else // ask if they want to brand genitals
			var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
			var/obj/item/organ/vagina/vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
			var/obj/item/organ/testicles/testes = target.getorganslot(ORGAN_SLOT_TESTICLES)
			var/list/available_loins = list()
			if(penis && penis.is_visible())
				available_loins += "阴茎"
			if(vagina && vagina.is_visible())
				available_loins += "阴部"
			if(testes && testes.is_visible() && testes.ball_size >= DEFAULT_TESTICLES_SIZE && !(penis && penis.sheath_type == SHEATH_TYPE_SLIT)) // only allow balls to be branded if average or bigger (slit types have internal balls)
				available_loins += "睾丸"
			if(length(available_loins) < 1)
				to_chat(user, span_warning("我看不到任何值得我烙印的胯部。"))
				return TRUE
			available_loins += "取消"
			answer = tgui_alert(user, "你想烙印什么部位？", "请在[DisplayTimeText(100)]内回答！", available_loins, 100)
			if(!answer || answer == "取消")
				to_chat(user, span_warning("我把\the [src]移开了。"))
				if(!branding_self)
					to_chat(target, span_userdanger("[user]把\the [src]移开了。"))
				return TRUE
			switch(answer)
				if("阴茎")
					if(QDELETED(penis) || !user.Adjacent(target)) // body part no longer exists/moved away
						return TRUE
					if(length(penis.branded_writing))
						to_chat(user, span_warning("我在现有印记上重新烙印。"))
					penis.branded_writing = setbranding
				if("阴部")
					if(QDELETED(vagina) || !user.Adjacent(target)) // body part no longer exists/moved away
						return TRUE
					if(length(vagina.branded_writing))
						to_chat(user, span_warning("我在现有印记上重新烙印。"))
					vagina.branded_writing = setbranding
				if("睾丸")
					if(QDELETED(testes) || !user.Adjacent(target)) // body part no longer exists/moved away
						return TRUE
					if(length(testes.branded_writing))
						to_chat(user, span_warning("我在现有印记上重新烙印。"))
					testes.branded_writing = setbranding
		user.visible_message(span_info("[target] [description_recoil]，\the [src]灼烧着[target.p_their()]的[LOWER_TEXT(answer)]！新烙印显示出[span_boldwarning(setbranding)]。"))
		if(!QDELETED(branding_part) && istype(branding_part)) // if targeted body part still exists, apply damage
			target.apply_damage(branding_damage, BURN, branding_part)
		if(!branding_self)
			target.Knockdown(10)
		to_chat(target, span_userdanger("你被烙印了！"))
	else if(check_zone == BODY_ZONE_HEAD) // targeting head
		var/answer = tgui_alert(user, "你想烙印什么部位？", "请在[DisplayTimeText(100)]内回答！", list("头部", "嘴部", "颈部", "取消"), 100)
		if(!answer || answer == "取消")
			to_chat(user, span_warning("我把\the [src]移开了。"))
			if(!branding_self)
				to_chat(target, span_userdanger("[user]把\the [src]移开了。"))
			return TRUE
		if(QDELETED(branding_part) || !istype(branding_part) || !user.Adjacent(target)) // body part no longer exists/moved away
			return TRUE
		switch(answer)
			if("嘴部")
				user.visible_message(span_info("[target] [description_recoil]，\the [src]烧烙在[target.p_their()]的嘴唇上！烙印留下了一道无法辨认的烧伤。"))
				target.apply_status_effect(/datum/status_effect/mouth_branded)
				target.apply_damage(branding_damage, BURN, branding_part)
				if(!branding_self)
					target.Knockdown(20)
				to_chat(target, span_userdanger("你的嘴唇被烧焦了！"))
			if("颈部")
				var/obj/item/bodypart/head/neck = branding_part
				if(QDELETED(neck) || !istype(neck)) // body part no longer exists
					return TRUE
				if(length(neck.branded_writing_on_neck))
					to_chat(user, span_warning("我在现有印记上重新烙印。"))
				user.visible_message(span_info("[target] [description_recoil]，\the [src]烧烙在[target.p_their()]的脖子上！新烙印显示出[span_boldwarning(setbranding)]。"))
				neck.branded_writing_on_neck = setbranding
				target.apply_damage(branding_damage, BURN, neck)
				if(!branding_self)
					target.Knockdown(10)
				to_chat(target, span_userdanger("你被烙印了！"))
			if("头部")
				if(length(branding_part.branded_writing))
					to_chat(user, span_warning("我在现有印记上重新烙印。"))
				user.visible_message(span_info("[target] [description_recoil]，\the [src]烧烙在[target.p_their()]的[branding_part.name]上！新烙印显示出[span_boldwarning(setbranding)]。"))
				branding_part.branded_writing = setbranding
				target.apply_damage(branding_damage, BURN, branding_part)
				to_chat(target, span_userdanger("你被烙印了！"))
	else
		var/obj/item/organ/breasts/tits = null
		if(check_zone == BODY_ZONE_CHEST) // targeting chest, check if target has breasts
			tits = target.getorganslot(ORGAN_SLOT_BREASTS)
			if(tits && !tits.is_visible()) // not shown, don't allow to be targeted
				tits = null
		var/answer
		if(tits) // tits are avaialble, show as choice
			answer = tgui_alert(user, "给Ta烙印吗？", "请在[DisplayTimeText(100)]内回答！", list(capitalize(branding_part.name), "胸部", "取消"), 100)
		else
			answer = tgui_alert(user, "给Ta的[LOWER_TEXT(branding_part.name)]烙印吗？", "请在[DisplayTimeText(100)]内回答！", list("是", "取消"), 100)
		if(!answer || answer == "取消")
			to_chat(user, span_warning("我把\the [src]移开了。"))
			if(!branding_self)
				to_chat(target, span_userdanger("[user]把\the [src]移开了。"))
			return TRUE
		if(QDELETED(branding_part) || !istype(branding_part) || !user.Adjacent(target)) // body part no longer exists/moved away
			return TRUE
		if(answer == "胸部")
			if(QDELETED(tits) || !istype(tits)) // tits don't exist anymore
				return TRUE
			if(length(tits.branded_writing))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			user.visible_message(span_info("[target] [description_recoil]，\the [src]烧烙在[target.p_their()]的乳房上！新烙印显示出[span_boldwarning(setbranding)]。"))
			tits.branded_writing = setbranding
		else // generic body part
			if(length(branding_part.branded_writing))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			user.visible_message(span_info("[target] [description_recoil]，\the [src]烧烙在[target.p_their()]的[branding_part.name]上！新烙印显示出[span_boldwarning(setbranding)]。"))
			branding_part.branded_writing = setbranding
		target.apply_damage(branding_damage, BURN, branding_part)
		to_chat(target, span_userdanger("你被烙印了！"))

	target.emote(prob(50) ? "painscream" : "scream", forced = TRUE)
	target.Stun(40)
	target.flash_fullscreen("redflash2")
	playsound(src.loc, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 5)
	update_heated(FALSE)
	if(cool_timer)
		deltimer(cool_timer)
	log_combat(user, target, "Branded successful: \"[setbranding]\"")
	if(branding_count > 0)
		branding_count--
		if(branding_count == 0)
			to_chat(user, span_warning("\The [src]在你手中断裂了，它坏了！"))
			playsound(user, 'sound/items/seedextract.ogg', 100, FALSE)
			qdel(src)
	return TRUE

/datum/status_effect/mouth_branded
	id = "mouth_branded"
	duration = 2 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/mouth_branded

/atom/movable/screen/alert/status_effect/mouth_branded
	name = "烧伤的嘴"
	desc = "我感觉不到我的嘴唇了！"

/datum/status_effect/mouth_branded/on_apply()
	ADD_TRAIT(owner, TRAIT_GARGLE_SPEECH, "mouth_branded")
	to_chat(owner, span_warning("我的嘴……烧起来了！"))
	return ..()

/datum/status_effect/mouth_branded/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, "mouth_branded")
	if(owner.stat == CONSCIOUS)
		to_chat(owner, span_userdanger("我几乎又能感觉到嘴唇了。"))

/obj/item/rogueweapon/surgery/hammer
	name = "检查锤"
	desc = "用于检查病人反应并诊断病情的小锤。"
	icon_state = "kneehammer"
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike, /datum/intent/mace/smash)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	force = 10
	throwforce = 8
	wdefense = 3
	wbalance = -1
	associated_skill = /datum/skill/combat/maces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT

/obj/item/rogueweapon/surgery/hammer/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
	if(medskill < SKILL_LEVEL_NOVICE)
		return ..()
	if(ishuman(A))
		if(A == user)
			user.visible_message("<span class='info'>[user]开始用小锤子敲打自己。</span>")
		else
			user.visible_message("<span class='info'>[user]开始用小锤子敲打[A]。</span>")
		if(do_after(user, ((medskill > SKILL_LEVEL_EXPERT) ? 1 SECONDS : 2.5 SECONDS), target = A))
			A.visible_message("<span class='info'>锤击后[A]的膝盖弹跳了一下！</span>")
			if(prob(1))
				playsound(user, 'sound/misc/bonk.ogg', 100, FALSE, -1)
			var/mob/living/carbon/human/human_target = A
			human_target.check_for_injuries(user)
	return ..()

////////////////////
//Improvised Tools//
////////////////////

//All are subtypes of the regular tools with worse behavior success chances.
/obj/item/rogueweapon/surgery/saw/improv
	name = "简易骨锯"
	desc = "用于切骨的粗糙工具。不如真正的骨锯那样顺畅。"
	icon_state = "bonesaw_wood"
	force = 12
	throwforce = 12
	wdefense = 3
	wbalance = 1
	tool_behaviour = TOOL_SAW
	sharpness = IS_BLUNT

/obj/item/rogueweapon/surgery/hemostat/improv
	name = "简易夹具"
	desc = "用于夹持软组织的工具。比金属件差但总比没有好。"
	icon_state = "forceps_wood"
	tool_behaviour = TOOL_IMPROVISED_HEMOSTAT

/obj/item/rogueweapon/surgery/retractor/improv
	name = "简易扩张器"
	desc = "一种试探性地撑开组织以进行手术操作的工具。"
	icon_state = "speculum_wood"
	wdefense = 3
	wbalance = 1
	tool_behaviour = TOOL_IMPROVISED_RETRACTOR

/obj/item/rogueweapon/surgery/scalpel/improv
	name = "简易手术刀"
	desc = "粗糙的石刀，能切割但精确度堪忧。"
	icon_state = "scalpel_wood"
	force = 8
	throwforce = 8
	wdefense = 2
	wbalance = 1
	tool_behaviour = TOOL_IMPROVISED_SCALPEL
	sharpness = IS_SHARP
