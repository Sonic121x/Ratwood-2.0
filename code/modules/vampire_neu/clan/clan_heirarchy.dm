/datum/clan_hierarchy_node
	var/name = "职位"
	var/desc = "氏族层级中的一个职位"
	var/mob/living/carbon/human/assigned_member
	var/datum/clan_hierarchy_node/superior // Who this position reports to
	var/list/datum/clan_hierarchy_node/subordinates = list() // Who reports to this position
	var/rank_level = 0 // 0 = leader, higher numbers = lower ranks
	var/max_subordinates = 5 // Maximum number of direct reports
	var/can_assign_positions = FALSE // Can this position create/assign sub-positions
	var/position_color = "#ffffff"
	var/node_x = 0
	var/node_y = 0
	var/mutable_appearance/cloned_look

/datum/clan_hierarchy_node/New(position_name, position_desc, level = 1)
	name = position_name
	desc = position_desc
	rank_level = level
	..()

/datum/clan_hierarchy_node/proc/assign_member(mob/living/carbon/human/member)
	if(!member || !member.clan)
		return FALSE

	if(member.clan_position)
		member.clan_position.remove_member()

	assigned_member = member
	member.clan_position = src
	var/old_dir = member?.dir
	member?.dir = SOUTH
	cloned_look = member?.appearance
	member?.dir = old_dir
	member.clan.grant_hierarchy_actions(member)
	return TRUE

/datum/clan_hierarchy_node/proc/remove_member()
	if(assigned_member)
		for(var/datum/action/clan_hierarchy/action in assigned_member.actions)
			action.Remove(assigned_member)
		assigned_member.clan_position = null
		assigned_member = null
	cloned_look = null

/datum/clan_hierarchy_node/proc/add_subordinate(datum/clan_hierarchy_node/subordinate)
	if(!subordinate || subordinates.len >= max_subordinates)
		return FALSE

	subordinates += subordinate
	subordinate.superior = src
	return TRUE

/datum/clan_hierarchy_node/proc/remove_subordinate(datum/clan_hierarchy_node/subordinate)
	subordinates -= subordinate
	subordinate.superior = null

/datum/clan_hierarchy_node/proc/get_all_subordinates()
	var/list/all_subs = list()
	for(var/datum/clan_hierarchy_node/sub in subordinates)
		all_subs += sub
		all_subs += sub.get_all_subordinates()
	return all_subs

/datum/clan_hierarchy_node/proc/get_all_superiors()
	var/list/all_sups = list()
	if(superior)
		all_sups += superior
		all_sups += superior.get_all_superiors()
	return all_sups

/datum/clan_hierarchy_node/proc/get_subordinates_at_depth(depth = 1)
	if(depth <= 0)
		return list(src)

	var/list/result = list()
	if(depth == 1)
		return subordinates.Copy()

	for(var/datum/clan_hierarchy_node/sub in subordinates)
		result += sub.get_subordinates_at_depth(depth - 1)
	return result

/datum/clan_hierarchy_node/proc/get_hierarchy_root()
	if(!superior)
		return src
	return superior.get_hierarchy_root()

/datum/clan_hierarchy_node/proc/get_total_subordinate_count()
	var/count = subordinates.len
	for(var/datum/clan_hierarchy_node/sub in subordinates)
		count += sub.get_total_subordinate_count()
	return count

/datum/clan_hierarchy_node/proc/is_superior_to(datum/clan_hierarchy_node/other)
	if(!other)
		return FALSE
	var/list/other_superiors = other.get_all_superiors()
	return (src in other_superiors)

/datum/clan_hierarchy_node/proc/is_subordinate_to(datum/clan_hierarchy_node/other)
	if(!other)
		return FALSE
	var/list/other_subordinates = other.get_all_subordinates()
	return (src in other_subordinates)


/datum/action/clan_hierarchy
	check_flags = NONE
	background_icon_state = "spell"
	button_icon_state = "command"
	var/cooldown = 0
	var/cooldown_time = 100
	var/sound/activation_sound

/datum/action/clan_hierarchy/IsAvailable()
	if(cooldown > world.time)
		return FALSE

	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/user = owner
	if(!user.clan || !user.clan_position)
		return FALSE

	return TRUE

/datum/action/clan_hierarchy/proc/start_cooldown()
	cooldown = world.time + cooldown_time

// Command Subordinate Action
/datum/action/clan_hierarchy/command_subordinate
	name = "命令下属"
	desc = "通过心灵感应向一名下属下达命令。"
	button_icon_state = "command"
	cooldown_time = 100

/datum/action/clan_hierarchy/command_subordinate/IsAvailable()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/user = owner
	var/list/all_subordinates = user.clan_position.get_all_subordinates()

	// Check if we have any subordinates
	for(var/datum/clan_hierarchy_node/sub in all_subordinates)
		if(sub.assigned_member)
			return TRUE

	return FALSE

/datum/action/clan_hierarchy/command_subordinate/Trigger(trigger_flags)
	. = ..()

	var/mob/living/carbon/human/user = owner
	var/list/valid_targets = list()

	// Get all subordinates in the clan
	var/list/all_subordinates = user.clan_position.get_all_subordinates()
	for(var/datum/clan_hierarchy_node/sub in all_subordinates)
		if(sub.assigned_member)
			valid_targets += sub.assigned_member

	if(!length(valid_targets))
		to_chat(user, "<span class='warning'>你没有下属！</span>")
		return

	var/mob/living/carbon/human/target = input(user, "选择要命令的下属：", "命令下属") as null|anything in valid_targets

	if(!target || !target.clan_position || !user.clan_position.is_superior_to(target.clan_position))
		to_chat(user, "<span class='warning'>目标无效！</span>")
		return

	var/command = sanitize(input(user, "你的命令是什么？", "命令") as text|null)

	if(!command || length(command) > 200)
		to_chat(user, "<span class='warning'>命令无效！</span>")
		return

	start_cooldown()

	// Send the command
	to_chat(user, "<span class='notice'>你通过心灵感应向[target.real_name]下令：\"[command]\"</span>")
	to_chat(target, "<span class='userdanger'><b>[user.real_name]通过心灵感应向你下令：</b>\"[command]\"</span>")

	// Play sound to target
	//playsound(target, 'sound/magic/whisper.ogg', 30, TRUE)


/obj/effect/temp_visual/vamp_teleport
	icon = 'icons/effects/clan.dmi'
	icon_state = "rune_teleport"
	duration = 2 SECONDS

/obj/effect/temp_visual/vamp_summon
	icon = 'icons/effects/clan.dmi'
	icon_state = "teleport"
	duration = 2 SECONDS

/obj/effect/temp_visual/vamp_summon/end
	icon_state = "teleport_trigger"

// Summon Subordinate Action
/datum/action/clan_hierarchy/summon_subordinate
	name = "召来下属"
	desc = "命令一名下属立即来到你所在的位置。"
	button_icon_state = "summon"
	cooldown_time = 300

/datum/action/clan_hierarchy/summon_subordinate/IsAvailable()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/user = owner

	// Only allow for positions that can assign others
	if(!user.clan_position.can_assign_positions)
		return FALSE

	var/list/all_subordinates = user.clan_position.get_all_subordinates()
	for(var/datum/clan_hierarchy_node/sub in all_subordinates)
		if(sub.assigned_member && (sub.assigned_member in view(world.view, user)))
			return TRUE

	return FALSE

/datum/action/clan_hierarchy/summon_subordinate/Trigger(trigger_flags)
	. = ..()

	var/mob/living/carbon/human/user = owner
	var/list/valid_targets = list()

	// Get all subordinates in view
	var/list/all_subordinates = user.clan_position.get_all_subordinates()
	for(var/datum/clan_hierarchy_node/sub in all_subordinates)
		if((sub.assigned_member && sub.assigned_member) in view(world.view, user))
			valid_targets += sub.assigned_member

	if(!length(valid_targets))
		to_chat(user, "<span class='warning'>范围内没有下属！</span>")
		return

	var/mob/living/carbon/human/target = input(user, "选择要召来的下属：", "召来下属") as null|anything in valid_targets

	if(!target || !target.clan_position || !user.clan_position.is_superior_to(target.clan_position))
		to_chat(user, "<span class='warning'>目标无效！</span>")
		return

	start_cooldown()

	//playsound(user, 'sound/magic/summon.ogg', 50, TRUE)

	target.Immobilize(1.5 SECONDS)
	new /obj/effect/temp_visual/vamp_summon (get_turf(target))
	new /obj/effect/temp_visual/vamp_summon/end (get_turf(user))
	addtimer(CALLBACK(src, PROC_REF(finish_teleport), user, target, get_turf(user)), 1.5 SECONDS)

/datum/action/clan_hierarchy/summon_subordinate/proc/finish_teleport(mob/living/user, mob/living/target, turf/target_turf)
	// Teleport subordinate to user
	if(target_turf)
		new /obj/effect/temp_visual/vamp_teleport(get_turf(target))
		target.forceMove(target_turf)

		// Messages
		to_chat(user, "<span class='notice'>你将[target.real_name]召到了自己身边。</span>")
		to_chat(target, "<span class='userdanger'>你被迫来到[user.real_name]面前！</span>")

		// Announce to nearby clan members
		for(var/mob/living/carbon/human/observer in view(7, user))
			if(observer.clan == user.clan && observer != user && observer != target)
				to_chat(observer, "<span class='info'>[user.real_name]召来了[target.real_name]。</span>")

// Mass Command Action
/datum/action/clan_hierarchy/mass_command
	name = "集体号令"
	desc = "通过心灵感应向所有下属发送消息。"
	button_icon_state = "mass_command"
	cooldown_time = 600

/datum/action/clan_hierarchy/mass_command/IsAvailable()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/user = owner

	// Only allow for positions that can assign others or clan leader
	if(!user.clan_position.can_assign_positions && user.clan_position.rank_level > 0)
		return FALSE

	var/list/all_subordinates = user.clan_position.get_all_subordinates()
	for(var/datum/clan_hierarchy_node/sub in all_subordinates)
		if(sub.assigned_member)
			return TRUE

	return FALSE

/datum/action/clan_hierarchy/mass_command/Trigger(trigger_flags)
	. = ..()

	var/mob/living/carbon/human/user = owner
	var/list/all_subordinates = user.clan_position.get_all_subordinates()
	var/list/valid_targets = list()

	for(var/datum/clan_hierarchy_node/sub in all_subordinates)
		if(sub.assigned_member)
			valid_targets += sub.assigned_member

	if(!length(valid_targets))
		to_chat(user, "<span class='warning'>你没有下属！</span>")
		return

	var/command = sanitize(input(user, "你要向所有下属下达什么命令？", "集体号令") as text|null)

	if(!command || length(command) > 300)
		to_chat(user, "<span class='warning'>命令无效！</span>")
		return

	start_cooldown()

	// Send to all subordinates
	to_chat(user, "<span class='notice'>你向[length(valid_targets)]名下属下达了集体号令：\"[command]\"</span>")

	for(var/mob/living/carbon/human/target in valid_targets)
		to_chat(target, "<span class='userdanger'><b>[user.real_name]向所有下属下令：</b>\"[command]\"</span>")
		//playsound(target, 'sound/magic/whisper.ogg', 30, TRUE)

// Locate Subordinate Action
/datum/action/clan_hierarchy/locate_subordinate
	name = "感知下属"
	desc = "感知下属所在的位置。"
	button_icon_state = "locate"
	cooldown_time = 200

/datum/action/clan_hierarchy/locate_subordinate/IsAvailable()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/user = owner
	var/list/all_subordinates = user.clan_position.get_all_subordinates()

	for(var/datum/clan_hierarchy_node/sub in all_subordinates)
		if(sub.assigned_member)
			return TRUE

	return FALSE

/datum/action/clan_hierarchy/locate_subordinate/Trigger(trigger_flags)
	. = ..()

	var/mob/living/carbon/human/user = owner
	var/list/all_subordinates = user.clan_position.get_all_subordinates()
	var/list/location_info = list()

	for(var/datum/clan_hierarchy_node/sub in all_subordinates)
		if(sub.assigned_member)
			var/mob/living/carbon/human/target = sub.assigned_member
			var/turf/target_turf = get_turf(target)
			if(is_in_zweb(user.z, target_turf.z))
				var/dist = get_dist_3d(user, target_turf)
				location_info += "[target.real_name] ([sub.name]) [(dist > 20 ? "远处" : "附近")])"

	if(!length(location_info))
		to_chat(user, "<span class='warning'>你没有可供感知的下属！</span>")
		return

	start_cooldown()

	to_chat(user, "<span class='notice'><b>下属位置：</b></span>")
	for(var/info in location_info)
		to_chat(user, "<span class='info'>[info]</span>")
