/obj/effect/proc_holder/spell/invoked/mirror_transform  // Changed from targeted to invoked
	name = "镜变术"
	desc = "暂时赋予你借助镜子改变外貌的能力。"
	clothes_req = FALSE
	charge_type = "recharge"
	associated_skill = /datum/skill/magic/arcane
	cost = 1 // Trash spell
	xp_gain = TRUE
	// Fix invoked spell variables
	releasedrain = 35
	chargedrain = 1  // Fixed from chargeddrain to chargedrain
	chargetime = 10
	recharge_time = 300 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1
	invocations = list("镜中改形。")
	invocation_type = "whisper"
	hide_charge_effect = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/wind
	overlay_state = "mirror"

/obj/effect/proc_holder/spell/invoked/mirror_transform/cast(list/targets, mob/user)  // Changed to match invoked spell pattern
	if(!isliving(targets[1]))
		return
	var/mob/living/carbon/human/H = targets[1]
	if(!istype(H))
		return

	ADD_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	H.visible_message(span_notice("[H] 的镜中倒影短暂地摇曳了一下。"), span_notice("我感觉自己与镜面建立起了一丝联系……"))

	addtimer(CALLBACK(src, PROC_REF(remove_mirror_magic), H), 5 MINUTES)
	return TRUE  // Return TRUE for successful cast

/obj/effect/proc_holder/spell/invoked/mirror_transform/proc/remove_mirror_magic(mob/living/carbon/human/H)
	if(!QDELETED(H))
		REMOVE_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
		to_chat(H, span_warning("我与镜面的联系消散了。"))
