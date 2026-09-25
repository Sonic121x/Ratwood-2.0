/obj/item/organ/eyes
	name = "眼睛"
	icon_state = "eyeball"
	desc = ""
	zone = BODY_ZONE_PRECISE_R_EYE
	slot = ORGAN_SLOT_EYES
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY
	maxHealth = 0.5 * STANDARD_ORGAN_THRESHOLD		//half the normal health max since we go blind at 30, a permanent blindness at 50 therefore makes sense unless medicine is administered
	high_threshold = 0.3 * STANDARD_ORGAN_THRESHOLD	//threshold at 30
	low_threshold = 0.2 * STANDARD_ORGAN_THRESHOLD	//threshold at 20

	low_threshold_passed = span_info("远处的物体开始变得有些模糊。")
	high_threshold_passed = span_info("眼前的一切都变得模糊不清。")
	now_failing = span_warning("黑暗笼罩了我，我的双眼失明了！")
	now_fixed = span_info("我再次看得见颜色和轮廓了。")
	high_threshold_cleared = span_info("我的视力恢复到勉强能看清东西的程度了。")
	low_threshold_cleared = span_info("我的视力完全恢复了。")

	organ_dna_type = /datum/organ_dna/eyes
	accessory_type = /datum/sprite_accessory/eyes/humanoid
	accessory_colors = "#FFFFFF#FFFFFF"
	visible_organ = TRUE

	var/sight_flags = 0
	var/see_in_dark = 8
	var/tint = 0
	var/eye_icon_state = "eyes"
	var/flash_protect = FLASH_PROTECTION_NONE
	var/see_invisible = SEE_INVISIBLE_LIVING
	var/lighting_alpha
	var/no_glasses
	var/damaged	= FALSE	//damaged indicates that our eyes are undergoing some level of negative effect

	var/eye_color = "#FFFFFF"
	var/heterochromia = FALSE
	var/second_color = "#FFFFFF"


/obj/item/organ/eyes/update_overlays()
	. = ..()
	if(eye_color && (icon_state == "eyeball"))
		var/mutable_appearance/iris_overlay = mutable_appearance(src.icon, "eyeball-iris")
		iris_overlay.color = "#" + eye_color
		. += iris_overlay


/obj/item/organ/eyes/update_accessory_colors()
	var/list/colors_list = list()
	colors_list += eye_color
	if(heterochromia)
		colors_list += second_color
	else
		colors_list += eye_color
	accessory_colors = color_list_to_string(colors_list)

/obj/item/organ/eyes/imprint_organ_dna(datum/organ_dna/organ_dna)
	. = ..()
	var/datum/organ_dna/eyes/eyes_dna = organ_dna
	eyes_dna.eye_color = eye_color
	eyes_dna.heterochromia = heterochromia
	eyes_dna.second_color = second_color

/obj/item/organ/eyes/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE, initialising)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/HMN = owner
		if(eye_color)
			HMN.eye_color = eye_color
			HMN.regenerate_icons()
		else
			eye_color = HMN.eye_color
		if(HAS_TRAIT(HMN, TRAIT_NIGHT_VISION) && !lighting_alpha)
			lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
	for(var/datum/wound/facial/eyes/eye_wound in M.get_wounds())
		qdel(eye_wound)
	M.update_tint()
	owner.update_sight()
	if(M.has_dna() && ishuman(M))
		M.dna.species.handle_body(M) //updates eye icon

/obj/item/organ/eyes/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	if(ishuman(M) && eye_color)
		var/mob/living/carbon/human/HMN = M
		HMN.regenerate_icons()
	M.cure_blind(EYE_DAMAGE)
	M.cure_nearsighted(EYE_DAMAGE)
	M.set_blindness(0)
	M.set_blurriness(0)
	M.update_sight()

/obj/item/organ/eyes/on_life()
	..()
	var/mob/living/carbon/C = owner
	//since we can repair fully damaged eyes, check if healing has occurred
	if((organ_flags & ORGAN_FAILING) && (damage < maxHealth))
		organ_flags &= ~ORGAN_FAILING
		C.cure_blind(EYE_DAMAGE)
	//various degrees of "oh fuck my eyes", from "point a laser at my eye" to "staring at the Sun" intensities
	if(damage > 20)
		damaged = TRUE
		if((organ_flags & ORGAN_FAILING))
			C.become_blind(EYE_DAMAGE)
		else if(damage > 30)
			C.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, 2)
		else
			C.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, 1)
	//called once since we don't want to keep clearing the screen of eye damage for people who are below 20 damage
	else if(damaged)
		damaged = FALSE
		C.clear_fullscreen("eye_damage")
	return


/obj/item/organ/eyes/night_vision
	name = "暗影眼"
	desc = ""
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/night_vision = TRUE

/obj/item/organ/eyes/night_vision/ui_action_click()
	sight_flags = initial(sight_flags)
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			sight_flags &= ~SEE_BLACKNESS
	owner.update_sight()


/obj/item/organ/eyes/night_vision/argonian
	name = "西塞亚眼睛"
	desc = ""

/obj/item/organ/eyes/night_vision/alien
	name = "异星眼睛"
	desc = ""
	sight_flags = SEE_MOBS

/obj/item/organ/eyes/night_vision/zombie
	name = "亡灵眼睛"
	desc = ""

/obj/item/organ/eyes/construct
	name = "构装体眼睛"
	desc = "某种野兽的眼睛，经人工技艺保存，背面嵌有魔石。似乎适合装进构装体的头部。"
	icon_state = "eyeball-con"

/obj/item/organ/eyes/night_vision/zombie/on_life()
	. = ..()
	if (!(owner.mob_biotypes & MOB_UNDEAD))
		if (prob(10))
			owner.adjustToxLoss(0.2)

/obj/item/organ/eyes/night_vision/werewolf
	name = "月光眼"
	desc = ""

/obj/item/organ/eyes/night_vision/nightmare
	name = "燃烧的赤眼"
	desc = ""
	icon_state = "burning_eyes"

/obj/item/organ/eyes/night_vision/wild_goblin
	name = "野生哥布林眼睛"
	desc = "这双通红的眼珠，曾在这片土地的阴暗之处目睹过怎样的疯狂？"
	icon_state = "burning_eyes"

/obj/item/organ/eyes/night_vision/wild_goblin/on_life()
	. = ..()
	if (!isgoblinp(owner))
		if (prob(10))
			owner.adjustToxLoss(5)
			applyOrganDamage(5)
			owner.blur_eyes(3)
			if(prob(50))
				to_chat(owner, span_red("我的双眼灼痛，浑身酸疼。"))

/obj/item/organ/eyes/night_vision/mushroom
	name = "真菌眼"
	desc = ""

/obj/item/organ/eyes/night_vision/vampire/ui_action_click()
	sight_flags = initial(sight_flags)
	var/atom/movable/screen/plane_master/weather_plane = usr.hud_used?.plane_masters?["[WEATHER_EFFECT_PLANE]"]
	switch(lighting_alpha)
		if(LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
			weather_plane?.alpha = 225
		if(LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
			weather_plane?.alpha = 200
		if(LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
			weather_plane?.alpha = 170
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			weather_plane?.alpha = 255
			sight_flags &= ~SEE_BLACKNESS
	owner.update_sight()
	update_vampire_sight()

/obj/item/organ/eyes/night_vision/vampire/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE, initialising)
	. = ..()
	update_vampire_sight()

/obj/item/organ/eyes/night_vision/vampire/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	vampire_sight?.disable()

/obj/item/organ/eyes/elf
	name = "精灵眼睛"
	desc = ""
	see_in_dark = 4
	lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT

/obj/item/organ/eyes/halfelf
	name = "半精灵眼睛"
	desc = ""
	see_in_dark = 3
	lighting_alpha = LIGHTING_PLANE_ALPHA_LESSER_NV_TRAIT

/obj/item/organ/eyes/goblin
	name = "哥布林眼睛"
	desc = ""
	see_in_dark = 15
	lighting_alpha = 200

///Robotic

/obj/item/organ/eyes/robotic
	name = "机械眼"
	icon_state = "cybernetic_eyeballs"
	desc = ""
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/eyes/robotic/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	if(prob(10 * severity))
		return
	to_chat(owner, span_warning("静电干扰模糊了我的视野！"))
	owner.flash_act(visual = 1)

/obj/item/organ/eyes/robotic/xray
	name = "\improper X射线眼"
	desc = ""
	eye_color = "000"
	see_in_dark = 8
	sight_flags = SEE_MOBS | SEE_OBJS | SEE_TURFS

/obj/item/organ/eyes/robotic/thermals
	name = "热成像眼"
	desc = ""
	eye_color = "FC0"
	sight_flags = SEE_MOBS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	flash_protect = FLASH_PROTECTION_SENSITIVE
	see_in_dark = 8

/obj/item/organ/eyes/robotic/flashlight
	name = "照明眼"
	desc = ""
	eye_color ="fee5a3"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight_eyes"
	flash_protect = FLASH_PROTECTION_WELDER
	tint = INFINITY
	var/obj/item/flashlight/eyelight/eye

// Welding shield implant
/obj/item/organ/eyes/robotic/shield
	name = "屏蔽型机械眼"
	desc = ""
	flash_protect = FLASH_PROTECTION_WELDER

/obj/item/organ/eyes/robotic/shield/emp_act(severity)
	return

#define RGB2EYECOLORSTRING(definitionvar) ("[copytext(definitionvar,2,3)][copytext(definitionvar,4,5)][copytext(definitionvar,6,7)]")

/obj/item/organ/eyes/robotic/glow
	name = "高亮度眼睛"
	desc = ""
	eye_color = "000"
	actions_types = list(/datum/action/item_action/organ_action/use, /datum/action/item_action/organ_action/toggle)
	var/current_color_string = "#ffffff"
	var/active = FALSE
	var/max_light_beam_distance = 5
	var/light_beam_distance = 5
	var/light_object_range = 1
	var/light_object_power = 2
	var/list/obj/effect/abstract/eye_lighting/eye_lighting
	var/obj/effect/abstract/eye_lighting/on_mob
	var/image/mob_overlay
	var/datum/component/mobhook

/obj/item/organ/eyes/robotic/glow/Initialize(mapload)
	. = ..()
	mob_overlay = image('icons/mob/human_face.dmi', "eyes_glow_gs")

/obj/item/organ/eyes/robotic/glow/Destroy()
	terminate_effects()
	. = ..()

/obj/item/organ/eyes/robotic/glow/Remove(mob/living/carbon/M, special = FALSE)
	terminate_effects()
	. = ..()

/obj/item/organ/eyes/robotic/glow/proc/terminate_effects()
	if(owner && active)
		deactivate()
	active = FALSE
	clear_visuals(TRUE)
	STOP_PROCESSING(SSfastprocess, src)

/obj/item/organ/eyes/robotic/glow/ui_action_click(owner, action)
	if(istype(action, /datum/action/item_action/organ_action/toggle))
		toggle_active()
	else if(istype(action, /datum/action/item_action/organ_action/use))
		prompt_for_controls(owner)

/obj/item/organ/eyes/robotic/glow/proc/toggle_active()
	if(active)
		deactivate()
	else
		activate()

/obj/item/organ/eyes/robotic/glow/proc/prompt_for_controls(mob/user)
	var/C = input(owner, "选择颜色", "选择颜色", "#ffffff") as color|null
	if(!C || QDELETED(src) || QDELETED(user) || QDELETED(owner) || owner != user)
		return
	var/range = input(user, "输入距离（0 - [max_light_beam_distance]）", "选择距离", 0) as null|num

	set_distance(CLAMP(range, 0, max_light_beam_distance))
	assume_rgb(C)

/obj/item/organ/eyes/robotic/glow/proc/assume_rgb(newcolor)
	current_color_string = newcolor
	eye_color = RGB2EYECOLORSTRING(current_color_string)
	sync_light_effects()
	cycle_mob_overlay()
	if(!QDELETED(owner) && ishuman(owner))		//Other carbon mobs don't have eye color.
		owner.dna.species.handle_body(owner)

/obj/item/organ/eyes/robotic/glow/proc/cycle_mob_overlay()
	remove_mob_overlay()
	mob_overlay.color = current_color_string
	add_mob_overlay()

/obj/item/organ/eyes/robotic/glow/proc/add_mob_overlay()
	if(!QDELETED(owner))
		owner.add_overlay(mob_overlay)

/obj/item/organ/eyes/robotic/glow/proc/remove_mob_overlay()
	if(!QDELETED(owner))
		owner.cut_overlay(mob_overlay)

/obj/item/organ/eyes/robotic/glow/emp_act()
	. = ..()
	if(!active || . & EMP_PROTECT_SELF)
		return
	deactivate(silent = TRUE)

/obj/item/organ/eyes/robotic/glow/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE)
	. = ..()
	RegisterSignal(M, COMSIG_ATOM_DIR_CHANGE, PROC_REF(update_visuals))

/obj/item/organ/eyes/robotic/glow/Remove(mob/living/carbon/M, special = FALSE)
	. = ..()
	UnregisterSignal(M, COMSIG_ATOM_DIR_CHANGE)

/obj/item/organ/eyes/robotic/glow/Destroy()
	QDEL_NULL(mobhook) // mobhook is not our component
	return ..()

/obj/item/organ/eyes/robotic/glow/proc/activate(silent = FALSE)
	start_visuals()
	if(!silent)
		to_chat(owner, span_warning("我的[src]咔嗒一响，发出嗡鸣，随后射出一道光束！"))
	active = TRUE
	cycle_mob_overlay()

/obj/item/organ/eyes/robotic/glow/proc/deactivate(silent = FALSE)
	clear_visuals()
	if(!silent)
		to_chat(owner, span_warning("我的[src]熄灭了！"))
	active = FALSE
	remove_mob_overlay()

/obj/item/organ/eyes/robotic/glow/proc/update_visuals(datum/source, olddir, newdir)
	if((LAZYLEN(eye_lighting) < light_beam_distance) || !on_mob)
		regenerate_light_effects()
	var/turf/scanfrom = get_turf(owner)
	var/scandir = owner.dir
	if (newdir && scandir != newdir) // COMSIG_ATOM_DIR_CHANGE happens before the dir change, but with a reference to the new direction.
		scandir = newdir
	if(!istype(scanfrom))
		clear_visuals()
	var/turf/scanning = scanfrom
	var/stop = FALSE
	on_mob.forceMove(scanning)
	for(var/i in 1 to light_beam_distance)
		scanning = get_step(scanning, scandir)
		if(scanning.opacity || (scanning.opaque_atom_count > 0))
			stop = TRUE
		var/obj/effect/abstract/eye_lighting/L = LAZYACCESS(eye_lighting, i)
		if(stop)
			L.forceMove(src)
		else
			L.forceMove(scanning)

/obj/item/organ/eyes/robotic/glow/proc/clear_visuals(delete_everything = FALSE)
	if(delete_everything)
		QDEL_LIST(eye_lighting)
		QDEL_NULL(on_mob)
	else
		for(var/i in eye_lighting)
			var/obj/effect/abstract/eye_lighting/L = i
			L.forceMove(src)
		if(!QDELETED(on_mob))
			on_mob.forceMove(src)

/obj/item/organ/eyes/robotic/glow/proc/start_visuals()
	if(!islist(eye_lighting))
		regenerate_light_effects()
	if((eye_lighting.len < light_beam_distance) || !on_mob)
		regenerate_light_effects()
	sync_light_effects()
	update_visuals()

/obj/item/organ/eyes/robotic/glow/proc/set_distance(dist)
	light_beam_distance = dist
	regenerate_light_effects()

/obj/item/organ/eyes/robotic/glow/proc/regenerate_light_effects()
	clear_visuals(TRUE)
	on_mob = new (src, light_object_range, light_object_power, current_color_string, LIGHT_ATTACHED)
	for(var/i in 1 to light_beam_distance)
		LAZYADD(eye_lighting, new /obj/effect/abstract/eye_lighting(src, light_object_range, light_object_power, current_color_string))
	sync_light_effects()


/obj/item/organ/eyes/robotic/glow/proc/sync_light_effects()
	for(var/I in eye_lighting)
		var/obj/effect/abstract/eye_lighting/L = I
		L.set_light(light_object_range, light_inner_range, light_object_power, l_color =  current_color_string)
	if(on_mob)
		on_mob.set_light(1, 1, 1, l_color = current_color_string)

/obj/effect/abstract/eye_lighting
	var/obj/item/organ/eyes/robotic/glow/parent

/obj/effect/abstract/eye_lighting/Initialize(mapload)
	. = ..()
	parent = loc
	if(!istype(parent))
		return INITIALIZE_HINT_QDEL

/obj/item/organ/eyes/moth
	name = "弗卢维安眼睛"
	desc = ""
	flash_protect = FLASH_PROTECTION_SENSITIVE
	accessory_type = /datum/sprite_accessory/eyes/moth
	eye_color = "000000"
	second_color = "000000"

/obj/item/organ/eyes/snail
	name = "蜗牛眼睛"
	desc = ""
	eye_icon_state = "snail_eyes"
	icon_state = "snail_eyeballs"


/proc/set_eye_color(mob/living/carbon/mob, color_one, color_two)
	var/obj/item/organ/eyes/eyes = mob.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	if(color_one)
		eyes.eye_color = color_one
	if(color_two)
		eyes.second_color = color_two
	eyes.update_accessory_colors()
	if(eyes.owner)
		eyes.owner.update_body_parts(TRUE)

/obj/item/organ/eyes/t1
	name = "诺克学者之眼"
	desc = "过去，蒙赐这样的双眼是许多学徒的荣耀——这证明你已寻得知识……"
	icon_state = "burning_eyes"
	eye_color = "#24128a"
	see_in_dark = 4

/obj/item/organ/eyes/t2
	name = "登多尔祝福之眼"
	desc = "这双眼睛能让你看清猎物……愿你蒙福，猎人……"
	color = "#c2ae40"
	eye_color = "#864896"
	see_in_dark = 5

/obj/item/organ/eyes/t3
	name = "内克拉诅咒之眼"
	desc = "从她的一只猎犬身上偷来的双眼……"
	icon_state = "burning_eyes"
	color = "#c2ae40"
	eye_color = "#3c6696"
	see_in_dark = 10


/obj/item/organ/eyes/t1/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t1eyes)

/obj/item/organ/eyes/t1/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M && M.has_status_effect(/datum/status_effect/buff/t1eyes))
		M.remove_status_effect(/datum/status_effect/buff/t1eyes)


/obj/item/organ/eyes/t2/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t2eyes)

/obj/item/organ/eyes/t2/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M && M.has_status_effect(/datum/status_effect/buff/t2eyes))
		M.remove_status_effect(/datum/status_effect/buff/t2eyes)


/obj/item/organ/eyes/t3/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t3eyes)

/obj/item/organ/eyes/t3/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M && M.has_status_effect(/datum/status_effect/buff/t3eyes))
		M.remove_status_effect(/datum/status_effect/buff/t3eyes)


/datum/status_effect/buff/t1eyes
	id = "t1eyes"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t1eyes
	effectedstats = list(STATKEY_INT = 2, STATKEY_LCK = 2)

/atom/movable/screen/alert/status_effect/buff/t1eyes
	name = "学者之眼"
	desc = "知识也在凝视着你。"

/datum/status_effect/buff/t2eyes
	id = "t2eyes"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t2eyes
	effectedstats = list(STATKEY_PER = 2, STATKEY_SPD = 1)

/atom/movable/screen/alert/status_effect/buff/t2eyes
	name = "登多尔祝福之眼"
	desc = "狩猎的视野更加清晰。"

/datum/status_effect/buff/t3eyes
	id = "t3eyes"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t3eyes
	effectedstats = list(STATKEY_WIL = 1, STATKEY_CON = 1, STATKEY_STR = 1)

/atom/movable/screen/alert/status_effect/buff/t3eyes
	name = "内克拉诅咒之眼"
	desc = "某个被窃取之物如今正透过你凝视世界。"
