GLOBAL_LIST_EMPTY(mass_direct_intercepts)

/client/proc/mass_direct()
	set name = "指挥生物"
	set category = "-GameMaster-"
	if(holder)
		holder.mass_direct_mobs()

/datum/admins/proc/mass_direct_mobs(radius = 10, faction = null, command_mode = "move")
	if(!check_rights(R_ADMIN))
		return
	
	var/dat = {"<html><head>
		<style>
			body { font-family: Verdana, Arial, sans-serif; font-size: 13px; background: #f0f0f0; margin: 5px; }
			table { border-collapse: collapse; width: 100%; }
			td { background: #f8f8f8; padding: 2px; }
			tr.alt { background: #e8e8e8; }
			.options a { text-decoration: none; }
			select { font-family: inherit; font-size: 12px; }
		</style>
		<script type="text/javascript">
			function handle_dropdown(list) {
				var value = list.options\[list.selectedIndex\].value;
				if (value !== "") {
					if (value.indexOf("javascript:") === 0) {
						eval(value.substring(11)); // Execute JavaScript
					} else {
						location.href = value; // Navigate to URL
					}
				}
				list.selectedIndex = 0;
			}
		</script>
	</head><body>
	<b>指挥生物</b><br><br>
	<table>
		<tr><td>半径：</td><td><a href='byond://?src=[REF(src)];mass_direct=set_radius;radius=[radius];faction=[faction];command_mode=[command_mode];[HrefToken()]'>[radius]</a></td></tr>
		<tr class='alt'><td>阵营：</td><td>
			<form>
				<select name="faction" size="1" onchange="handle_dropdown(this)" onmouseclick="this.focus()">
					<option value selected>选择阵营</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=orcs;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "orcs" ? " selected" : ""]>兽人（orcs）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=undead;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "undead" ? " selected" : ""]>亡灵（undead）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=caves;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "caves" ? " selected" : ""]>洞穴（caves）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=wolfs;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "wolfs" ? " selected" : ""]>狼群（wolfs）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=rats;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "rats" ? " selected" : ""]>鼠群（rats）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=spiders;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "spiders" ? " selected" : ""]>蜘蛛（spiders）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=crabs;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "crabs" ? " selected" : ""]>螃蟹（crabs）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=deepone;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "deepone" ? " selected" : ""]>深潜者（deepone）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=infernal;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "infernal" ? " selected" : ""]>炼狱（infernal）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=dream;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "dream" ? " selected" : ""]>梦境（dream）</option>
					<option value="?src=[REF(src)];mass_direct=set_faction;faction=trolls;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction == "trolls" ? " selected" : ""]>巨魔（trolls）</option>
					<option value="?src=[REF(src)];mass_direct=custom_faction_input;radius=[radius];command_mode=[command_mode];[HrefToken()]"[faction && !(faction in list("orcs", "undead", "caves", "wolfs", "rats", "spiders", "crabs", "deepone", "infernal", "dream", "trolls")) ? " selected" : ""]>自定义……</option>
				</select>
			</form>
		</td></tr>
		<tr><td>指挥模式：</td><td>[list("move" = "移动", "attack" = "攻击", "follow" = "跟随", "passive" = "被动")[command_mode] || command_mode]</td></tr>"}
	
	var/list/nearby_mobs = list()
	if(faction)
		for(var/mob/living/M in range(radius, usr.loc))
			if(!M.client && M.faction && (faction in M.faction))
				nearby_mobs += M
		dat += "<tr class='alt'><td>找到的生物：</td><td>[nearby_mobs.len]</td></tr>"
	
	dat += "</table><br>"
	
	dat += "<a href='byond://?src=[REF(src)];mass_direct=refresh;radius=[radius];faction=[faction];command_mode=[command_mode];[HrefToken()]'><b>刷新</b></a><br><br>"
	
	dat += "<b>指挥模式：</b><br>"
	dat += "<a href='byond://?src=[REF(src)];mass_direct=set_command_mode;radius=[radius];faction=[faction];command_mode=move;[HrefToken()]'>[command_mode == "move" ? "<b>移动</b>" : "移动"]</a> | "
	dat += "<a href='byond://?src=[REF(src)];mass_direct=set_command_mode;radius=[radius];faction=[faction];command_mode=attack;[HrefToken()]'>[command_mode == "attack" ? "<b>攻击</b>" : "攻击"]</a> | "
	dat += "<a href='byond://?src=[REF(src)];mass_direct=set_command_mode;radius=[radius];faction=[faction];command_mode=follow;[HrefToken()]'>[command_mode == "follow" ? "<b>跟随</b>" : "跟随"]</a> | "
	dat += "<a href='byond://?src=[REF(src)];mass_direct=set_command_mode;radius=[radius];faction=[faction];command_mode=passive;[HrefToken()]'>[command_mode == "passive" ? "<b>被动</b>" : "被动"]</a><br><br>"
	
	if(faction)
		dat += "<a href='byond://?src=[REF(src)];mass_direct=begin_targeting;radius=[radius];faction=[faction];command_mode=[command_mode];[HrefToken()]'><b>开始指挥</b></a><br><br>"
		
		if(length(nearby_mobs) > 0)
			dat += "<b>附近属于 [faction] 阵营的生物：</b><br>"
			for(var/mob/living/M in nearby_mobs)
				var/mob_stance = "主动攻击"
				// If we're currently in Follow mode, reflect that explicitly
				if(command_mode == "follow")
					mob_stance = "跟随中"
				else
					// Otherwise, check passive status for different mob types
					if("neutral" in M.faction)
						mob_stance = "被动"
					else if(istype(M, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = M
						if(!isnull(H.mode) && H.aggressive == 0)
							mob_stance = "被动"
					else if(istype(M, /mob/living/carbon/human/species/skeleton/npc/summoned))
						var/mob/living/carbon/human/species/skeleton/npc/summoned/skel = M
						if(skel.aggressive == 0)
							mob_stance = "被动"
				dat += "[M.name] - [mob_stance]<br>"
		else
			dat += "<b>半径 [radius] 内未找到属于 [faction] 阵营的生物</b><br>"
	else
		dat += "<b>请选择阵营</b><br>"
	
	dat += "</body></html>"
	
	// Clean up any existing click intercept before opening window
	if(usr.client?.click_intercept && istype(usr.client.click_intercept, /datum/mass_direct_click_intercept))
		var/datum/mass_direct_click_intercept/old_intercept = usr.client.click_intercept
		old_intercept.cleanup()
	
	usr << browse(dat, "window=mass_direct;size=400x300;can_close=1;can_minimize=0")
	
	// Clean up any existing click intercept before opening window
	if(usr.client?.click_intercept && istype(usr.client.click_intercept, /datum/mass_direct_click_intercept))
		var/datum/mass_direct_click_intercept/old_intercept = usr.client.click_intercept
		old_intercept.cleanup()
	
	usr << browse(dat, "window=mass_direct;size=400x300;can_close=1;can_minimize=0")

/datum/admins/proc/mass_direct_handle_topic(href_list)
	if(!check_rights(R_ADMIN))
		return FALSE
	
	if(!href_list["mass_direct"])
		return FALSE
	
	var/radius = text2num(href_list["radius"]) || text2num(href_list["current_radius"]) || 20
	var/faction = href_list["faction"]
	var/command_mode = href_list["command_mode"] || "move"
	
	switch(href_list["mass_direct"])
		if("set_radius")
			var/new_radius = input("输入新半径（1-50）：", "设置半径", radius) as num|null
			if(new_radius)
				radius = clamp(new_radius, 1, 50)
		
		if("set_faction")
			var/new_faction = href_list["faction"]
			if(new_faction && new_faction != "")
				faction = new_faction
		
		if("custom_faction_input")
			var/custom_faction = input(usr, "输入自定义阵营标识：", "自定义阵营") as text|null
			if(custom_faction && custom_faction != "")
				faction = custom_faction
		
		if("set_custom_faction")
			var/custom_faction = href_list["faction"]
			if(custom_faction && custom_faction != "")
				faction = custom_faction
		
		if("set_command_mode")
			var/was_directing = usr.client?.click_intercept && istype(usr.client.click_intercept, /datum/mass_direct_click_intercept)
			command_mode = href_list["command_mode"]
			
			// If already directing, auto-start the new mode
			if(was_directing)
				if(!faction)
					to_chat(usr, span_warning("尚未选择阵营！"))
					mass_direct_mobs(radius, faction, command_mode)
					return TRUE
				
				var/instruction = ""
				switch(command_mode)
					if("move")
						instruction = "点击位置以指挥生物前往。右键点击停止指挥。"
					if("attack")
						instruction = "点击任意目标（生物、物体等）以命令生物攻击。右键点击停止指挥。"
					if("follow")
						instruction = "点击生物或自己以命令生物跟随。右键点击停止指挥。"
					if("passive")
						instruction = "点击任意位置，切换范围内所有 [faction] 阵营生物的被动／主动状态。右键点击停止指挥。"
				
				to_chat(usr, span_notice(instruction))
				var/datum/mass_direct_click_intercept/click_handler = new(usr.client, src, radius, faction, command_mode)
				usr.client.click_intercept = click_handler
				return TRUE
			// If already directing, auto-start the new mode
			if(usr.client?.click_intercept && istype(usr.client.click_intercept, /datum/mass_direct_click_intercept))
				if(!faction)
					to_chat(usr, span_warning("尚未选择阵营！"))
					mass_direct_mobs(radius, faction, command_mode)
					return TRUE
				
				var/instruction = ""
				switch(command_mode)
					if("move")
						instruction = "点击位置以指挥生物前往。右键点击停止指挥。"
					if("attack")
						instruction = "点击任意目标（生物、物体等）以命令生物攻击。右键点击停止指挥。"
					if("follow")
						instruction = "点击生物或自己以命令生物跟随。右键点击停止指挥。"
					if("passive")
						instruction = "点击任意位置，切换范围内所有 [faction] 阵营生物的被动／主动状态。右键点击停止指挥。"
				
				to_chat(usr, span_notice(instruction))
				var/datum/mass_direct_click_intercept/click_handler = new(usr.client, src, radius, faction, command_mode)
				usr.client.click_intercept = click_handler
				return TRUE
		
		if("begin_targeting")
			if(!faction)
				to_chat(usr, span_warning("尚未选择阵营！"))
				mass_direct_mobs(radius, faction, command_mode)
				return TRUE
			
			var/instruction = ""
			switch(command_mode)
				if("move")
					instruction = "点击位置以指挥生物前往。"
				if("attack")
					instruction = "点击任意目标（生物、物体等）以命令生物攻击。"
				if("follow")
					instruction = "点击生物或自己以命令生物跟随。"
				if("passive")
					instruction = "点击任意位置，切换范围内所有 [faction] 阵营生物的被动／主动状态。"
			
			to_chat(usr, span_notice(instruction))
			var/datum/mass_direct_click_intercept/click_handler = new(usr.client, src, radius, faction, command_mode)
			usr.client.click_intercept = click_handler
			return TRUE
		
		if("stop_targeting")
			if(usr.client?.click_intercept && istype(usr.client.click_intercept, /datum/mass_direct_click_intercept))
				var/datum/mass_direct_click_intercept/intercept = usr.client.click_intercept
				intercept.cleanup()
				to_chat(usr, span_notice("已停止指挥生物。"))
		
		if("refresh")
			// Just refresh the window
			pass()
	
	mass_direct_mobs(radius, faction, command_mode)
	return TRUE

/datum/mass_direct_click_intercept
	var/client/owner
	var/datum/admins/admin_datum
	var/radius
	var/faction
	var/command_mode
	var/atom/origin_loc
	var/list/active_attack_routines = list() // Track active attack routines for cleanup

/datum/mass_direct_click_intercept/New(client/C, datum/admins/A, R, F, CM = "move")
	owner = C
	admin_datum = A
	radius = R
	faction = F
	command_mode = CM
	origin_loc = C.mob
	owner.mouse_pointer_icon = 'icons/effects/mousemice/charge/default/100.dmi'
	
	// Monitor for window close
	GLOB.mass_direct_intercepts |= src

/datum/mass_direct_click_intercept/Destroy()
	GLOB.mass_direct_intercepts -= src
	// Don't call cleanup() here as it may have already been called and will try to qdel again
	if(owner && owner.click_intercept == src)
		owner.click_intercept = null
		owner.mouse_pointer_icon = null
		owner.mob.update_mouse_pointer()
	. = ..()

/datum/mass_direct_click_intercept/proc/restore_cursor()
	if(owner && owner.click_intercept == src)
		owner.mouse_pointer_icon = 'icons/effects/mousemice/charge/default/100.dmi'

/datum/mass_direct_click_intercept/proc/InterceptClickOn(user, params, atom/target)
	if(istype(target, /atom/movable/screen))
		return FALSE
	
	var/turf/T = get_turf(target)
	if(!T)
		return TRUE
	
	// Handle different command modes
	switch(command_mode)
		if("move")
			handle_move_command(user, T)
		if("attack")
			handle_attack_command(user, target, T)
		if("follow")
			handle_follow_command(user, target)
		if("passive")
			handle_passive_command(user, T)
	
	// Auto-cleanup after single command - but don't call qdel, just clean up references
	if(owner && owner.click_intercept == src)
		owner.click_intercept = null
		owner.mouse_pointer_icon = null
		owner.mob.update_mouse_pointer()
	to_chat(user, span_notice("命令已执行。"))
	
	return TRUE

/datum/mass_direct_click_intercept/proc/handle_move_command(mob/user, turf/T)
	var/count = 0
	var/skipped = 0
	
	for(var/mob/living/M in range(radius, origin_loc))
		if(M.client)
			continue
		if(!M.faction || !(faction in M.faction))
			continue
		if(M.stat == DEAD)
			continue // Skip dead mobs
		
		// Handle carbon skeletons (summoned type only)
		if(istype(M, /mob/living/carbon/human/species/skeleton/npc/summoned))
			var/mob/living/carbon/human/species/skeleton/npc/summoned/skel = M
			skel.set_command("move", T)
			count++
		// Handle simple mobs with AI controller
		else if(M.ai_controller && !istype(M, /mob/living/simple_animal/hostile))
			var/datum/ai_controller/ai = M.ai_controller
			// Stop any active attack routines
			if(M in active_attack_routines)
				active_attack_routines[M] = FALSE // Signal stop
				active_attack_routines -= M
			ai.CancelActions()
			ai.clear_blackboard_key(BB_FOLLOW_TARGET)
			ai.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			ai.clear_blackboard_key(BB_TRAVEL_DESTINATION)
			ai.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
			ai.set_blackboard_key(BB_TRAVEL_DESTINATION, T)
			// Ensure AI is active and processing
			if(ai.ai_status == AI_STATUS_OFF)
				ai.set_ai_status(AI_STATUS_ON)
			ai.PauseAi(0) // Unpause if paused
			count++
		// Handle simple animals without AI controller (use walk_to) OR hostile animals with AI that don't handle travel well
		else if(istype(M, /mob/living/simple_animal))
			var/mob/living/simple_animal/S = M
			// Stop any active attack routines
			if(S in active_attack_routines)
				active_attack_routines[S] = FALSE // Signal stop
				active_attack_routines -= S
			// For hostile animals with AI, turn off AI temporarily and use direct movement
			var/had_ai = FALSE
			if(S.ai_controller)
				S.ai_controller.set_ai_status(AI_STATUS_OFF)
				had_ai = TRUE
			// Stop current movement
			walk(S, 0)
			// Start custom movement routine that ensures reaching destination
			INVOKE_ASYNC(src, PROC_REF(handle_simple_movement), S, T, had_ai)
			count++
		// Handle old NPC AI system (carbon humans with mode variable)
		else if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!isnull(H.mode)) // Has old NPC AI system
				// Stop any active attack routines
				if(H in active_attack_routines)
					active_attack_routines[H] = FALSE // Signal stop
					active_attack_routines -= H
				// For movement, we set the turf as the target
				H.target = null
				H.clear_enemies()
				H.aggressive = 0 // Disable auto-retaliation
				H.wander = FALSE // Disable wandering
				H.start_pathing_to(T)
				H.mode = NPC_AI_IDLE // Stay idle, just follow the path
				H.handle_ai() // Ensure NPC starts processing
				count++
			else
				skipped++
		else
			// Other mob types not supported
			skipped++
	
	if(count > 0)
		to_chat(user, span_notice("已命令 [count] 个 [faction] 阵营的生物前往 [AREACOORD(T)]。"))
		if(skipped > 0)
			to_chat(user, span_warning("已跳过 [skipped] 个生物（使用旧版 NPC 人工智能，无法控制）。"))
		message_admins("[key_name_admin(user)] 命令 [count] 个 [faction] 阵营的生物前往 [AREACOORD(T)]。")
		log_admin("[key_name(user)] directed [count] [faction] mobs to [AREACOORD(T)].")
	else
		if(skipped > 0)
			to_chat(user, span_warning("找到了 [skipped] 个 [faction] 阵营的生物，但它们使用旧版 NPC 人工智能，无法控制！"))
		else
			to_chat(user, span_warning("半径 [radius] 内未找到属于 [faction] 阵营的生物！"))
	
	return TRUE

/datum/mass_direct_click_intercept/proc/handle_attack_command(mob/user, atom/target, turf/T)
	var/count = 0
	var/skipped = 0
	
	for(var/mob/living/M in range(radius, origin_loc))
		if(M.client)
			continue
		if(!M.faction || !(faction in M.faction))
			continue
		if(M.stat == DEAD)
			continue // Skip dead mobs
		if(M == target)
			continue
		
		// Handle carbon skeletons
		if(istype(M, /mob/living/carbon/human/species/skeleton/npc/summoned))
			var/mob/living/carbon/human/species/skeleton/npc/summoned/skel = M
			skel.set_command("attack", target)
			count++
		// Handle simple mobs with AI controller
		else if(M.ai_controller)
			var/datum/ai_controller/ai = M.ai_controller
			ai.CancelActions()
			ai.clear_blackboard_key(BB_FOLLOW_TARGET)
			ai.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			ai.clear_blackboard_key(BB_TRAVEL_DESTINATION)
			ai.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
			
			if(ismob(target))
				// Standard mob targeting (aligns with Commanded Undead)
				ai.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
			else
				// Object target: For simple animals, only set travel destination.
				// Their AI subtree /attack_obstacle_in_path will break doors/windows en route.
				ai.set_blackboard_key(BB_TRAVEL_DESTINATION, get_turf(target))
				if(!istype(M, /mob/living/simple_animal))
					// Non-simplemob with AI (e.g., modern carbon AI): assist with explicit attack routine
					active_attack_routines[M] = TRUE
					INVOKE_ASYNC(src, PROC_REF(handle_object_attack), M, target)
			count++
		// Handle old NPC AI system (carbon humans with mode variable)
		else if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!isnull(H.mode)) // Has old NPC AI system
				H.aggressive = 1 // Enable combat behavior
				H.wander = TRUE // Allow movement
				// Ensure no friend flag blocks attacking; clear friends
				H.friends = list()
				// For objects, set as target. For mobs, set as enemy
				if(ismob(target))
					// Manually set enemy status with proper value for should_target() check
					H.set_enemy(target, TRUE)
					H.retaliate(target) // Use built-in retaliate function
				else
					// For objects, set as direct target and enable attack mode
					H.target = target
					H.mode = NPC_AI_HUNT // Use HUNT mode for attacking
					// Track and start custom object attack routine for old NPC AI
					active_attack_routines[H] = TRUE
					INVOKE_ASYNC(src, PROC_REF(handle_old_npc_object_attack), H, target)
				H.handle_ai() // Ensure NPC starts processing
				count++
			else
				skipped++
		else
			skipped++
	
	if(count > 0)
		to_chat(user, span_notice("已命令 [count] 个 [faction] 阵营的生物攻击 [target]。"))
		if(skipped > 0)
			to_chat(user, span_warning("已跳过 [skipped] 个生物（使用旧版 NPC 人工智能，无法控制）。"))
		message_admins("[key_name_admin(user)] 命令 [count] 个 [faction] 阵营的生物攻击 [target]。")
		log_admin("[key_name(user)] directed [count] [faction] mobs to attack [target].")
	else
		if(skipped > 0)
			to_chat(user, span_warning("找到了 [skipped] 个 [faction] 阵营的生物，但它们使用旧版 NPC 人工智能，无法控制！"))
		else
			to_chat(user, span_warning("半径 [radius] 内未找到属于 [faction] 阵营的生物！"))
	
	// Refresh the window
	owner.mob << browse(null, "window=mass_direct")
	admin_datum.mass_direct_mobs(radius, faction, command_mode)
	
	restore_cursor() // Restore cursor after admin examine
	return TRUE

/datum/mass_direct_click_intercept/proc/handle_follow_command(mob/user, atom/target)
	if(!ismob(target))
		// Clicking anything but a mob: stop following for all selected mobs
		var/stopped = 0
		for(var/mob/living/M in range(radius, origin_loc))
			if(M.client)
				continue
			if(!M.faction || !(faction in M.faction))
				continue
			if(M.stat == DEAD)
				continue // Skip dead mobs
			// Handle carbon skeletons with commanded behavior
			if(istype(M, /mob/living/carbon/human/species/skeleton/npc/summoned))
				var/mob/living/carbon/human/species/skeleton/npc/summoned/skel = M
				skel.set_command("idle", null)
				walk(skel, 0)
				stopped++
			// Handle simple mobs with AI controller
			else if(M.ai_controller)
				var/datum/ai_controller/ai = M.ai_controller
				ai.CancelActions()
				ai.clear_blackboard_key(BB_FOLLOW_TARGET)
				ai.clear_blackboard_key(BB_TRAVEL_DESTINATION)
				ai.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				ai.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				walk(M, 0)
				stopped++
			// Handle simple animals without AI controller
			else if(istype(M, /mob/living/simple_animal))
				var/mob/living/simple_animal/S = M
				walk(S, 0)
				stopped++
			// Handle humanoids (old NPC AI or regular)
			else if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!isnull(H.mode))
					H.target = null
					H.clear_enemies()
					H.wander = FALSE
					H.mode = NPC_AI_IDLE
				walk(H, 0)
				stopped++
		// User feedback and refresh
		if(stopped > 0)
			to_chat(user, span_notice("已令 [stopped] 个 [faction] 阵营的生物停止跟随。"))
		else
			to_chat(user, span_warning("半径 [radius] 内没有可停止跟随的 [faction] 阵营生物。"))

		// Refresh window
		owner.mob << browse(null, "window=mass_direct")
		admin_datum.mass_direct_mobs(radius, faction, command_mode)

		restore_cursor() // Restore cursor after admin examine
		return TRUE
	
	var/mob/living/follow_target = target
	if(!follow_target || QDELETED(follow_target))
		to_chat(user, span_warning("跟随目标无效！"))
		return TRUE
	
	var/count = 0
	var/skipped = 0
	
	for(var/mob/living/M in range(radius, origin_loc))
		if(M.client)
			continue
		if(!M.faction || !(faction in M.faction))
			continue
		if(M.stat == DEAD)
			continue // Skip dead mobs
		if(M == follow_target)
			continue
		
		// Handle carbon skeletons
		if(istype(M, /mob/living/carbon/human/species/skeleton/npc/summoned))
			var/mob/living/carbon/human/species/skeleton/npc/summoned/skel = M
			skel.set_command("follow", follow_target)
			count++
		// Handle simple mobs with AI controller
		else if(M.ai_controller)
			var/datum/ai_controller/ai = M.ai_controller
			ai.CancelActions()
			ai.clear_blackboard_key(BB_FOLLOW_TARGET)
			ai.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			ai.clear_blackboard_key(BB_TRAVEL_DESTINATION)
			ai.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
			ai.set_blackboard_key(BB_FOLLOW_TARGET, follow_target)
			count++
		// Handle simple animals without AI controller
		else if(istype(M, /mob/living/simple_animal))
			var/mob/living/simple_animal/S = M
			// Stop any existing movement
			walk(S, 0)
			// Start following using simple walk_towards, but stop when close
			var/delay = 2
			if(istype(S, /mob/living/simple_animal/hostile) && S:move_to_delay)
				delay = S:move_to_delay
			if(get_dist(S, follow_target) > 2)
				walk_towards(S, follow_target, 0, delay)
			else
				walk(S, 0)
			count++
		// Handle old NPC AI system (carbon humans with mode variable)
		else if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!isnull(H.mode)) // Has old NPC AI system
				H.target = null // Clear attack target
				H.clear_enemies() // Clear enemies so they don't attack
				H.aggressive = 0 // Disable auto-retaliation
				H.wander = FALSE // Disable wandering
				if(ismob(follow_target))
					H.friends |= follow_target
				// Use walk_towards for simple following, but stop when close
				if(get_dist(H, follow_target) > 2)
					walk_towards(H, follow_target, 0, 2)
				else
					walk(H, 0)
				H.mode = NPC_AI_IDLE // Set to idle so it doesn't interfere
				count++
			else
				// Regular humanoid without old NPC AI - basic walk_towards, but stop when close
				walk(H, 0) // Stop any existing movement
				if(get_dist(H, follow_target) > 2)
					walk_towards(H, follow_target, 0, 2)
				else
					walk(H, 0)
				count++
		else
			skipped++
	
	if(count > 0)
		to_chat(user, span_notice("已命令 [count] 个 [faction] 阵营的生物跟随 [follow_target]。"))
		if(skipped > 0)
			to_chat(user, span_warning("已跳过 [skipped] 个生物（使用旧版 NPC 人工智能，无法控制）。"))
		message_admins("[key_name_admin(user)] 命令 [count] 个 [faction] 阵营的生物跟随 [follow_target]。")
		log_admin("[key_name(user)] directed [count] [faction] mobs to follow [follow_target].")
	else
		if(skipped > 0)
			to_chat(user, span_warning("找到了 [skipped] 个 [faction] 阵营的生物，但它们使用旧版 NPC 人工智能，无法控制！"))
		else
			to_chat(user, span_warning("半径 [radius] 内未找到属于 [faction] 阵营的生物！"))
	
	// Refresh the window
	owner.mob << browse(null, "window=mass_direct")
	admin_datum.mass_direct_mobs(radius, faction, command_mode)
	
	restore_cursor() // Restore cursor after admin examine
	return TRUE

/datum/mass_direct_click_intercept/proc/handle_passive_command(mob/user, turf/T)
	var/count = 0
	var/skipped = 0
	var/made_passive = 0
	var/made_active = 0
	
	// First pass - check if majority are passive to determine toggle direction
	var/total_mobs = 0
	var/passive_mobs = 0
	
	for(var/mob/living/M in range(radius, origin_loc))
		if(M.client)
			continue
		if(!M.faction || !(faction in M.faction))
			continue
		if(M.stat == DEAD)
			continue // Skip dead mobs
		total_mobs++
		
		// Check if mob is currently passive
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!isnull(H.mode) && H.aggressive == 0 && !H.wander)
				passive_mobs++
		else if(istype(M, /mob/living/simple_animal))
			// Simple animals are passive if they have "neutral" in faction
			if("neutral" in M.faction)
				passive_mobs++
		else if(M.ai_controller)
			// AI controller mobs are passive if they have "neutral" in faction
			if("neutral" in M.faction)
				passive_mobs++
		else if("neutral" in M.faction)
			passive_mobs++
	
	// If majority are passive, make them active. Otherwise make them passive
	var/make_active = (passive_mobs > total_mobs / 2)
	
	for(var/mob/living/M in range(radius, origin_loc))
		if(M.client)
			continue
		if(!M.faction || !(faction in M.faction))
			continue
		if(M.stat == DEAD)
			continue // Skip dead mobs
		
		// Handle carbon skeletons
		if(istype(M, /mob/living/carbon/human/species/skeleton/npc/summoned))
			var/mob/living/carbon/human/species/skeleton/npc/summoned/skel = M
			if(make_active)
				// Make skeleton active/aggressive
				skel.aggressive = 1
				made_active++
			else
				// Make skeleton passive
				skel.aggressive = 0
				skel.set_command("idle", null)
				made_passive++
			count++
		// Handle simple mobs with AI controller
		else if(M.ai_controller)
			var/datum/ai_controller/ai = M.ai_controller
			ai.CancelActions()
			ai.clear_blackboard_key(BB_FOLLOW_TARGET)
			ai.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			ai.clear_blackboard_key(BB_TRAVEL_DESTINATION)
			ai.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
			
			if(make_active)
				// Make active
				M.faction -= "neutral"
				made_active++
			else
				// Make passive
				if(!("neutral" in M.faction))
					M.faction += "neutral"
				made_passive++
			count++
		// Handle simple animals without AI controller
		else if(istype(M, /mob/living/simple_animal))
			var/mob/living/simple_animal/S = M
			if(make_active)
				// Make active
				S.faction -= "neutral"
				// Stop any passive walking
				walk(S, 0)
				made_active++
			else
				// Make passive
				if(!("neutral" in S.faction))
					S.faction += "neutral"
				// Stop any movement
				walk(S, 0)
				made_passive++
			count++
		// Handle old NPC AI system (carbon humans with mode variable)
		else if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!isnull(H.mode)) // Has old NPC AI system
				if(make_active)
					// Make active
					H.aggressive = 1
					H.wander = TRUE
					H.mode = NPC_AI_IDLE
					made_active++
				else
					// Make passive
					H.target = null
					H.clear_enemies()
					H.friends = list()
					H.aggressive = 0
					H.wander = FALSE
					H.mode = NPC_AI_IDLE
					H.clear_path()
					made_passive++
				count++
			else
				skipped++
		else
			skipped++
	
	if(count > 0)
		if(made_passive > 0)
			to_chat(user, span_notice("已将半径 [radius] 内 [made_passive] 个 [faction] 阵营的生物设为被动状态。"))
			message_admins("[key_name_admin(user)] 将 [made_passive] 个 [faction] 阵营的生物设为被动状态。")
			log_admin("[key_name(user)] made [made_passive] [faction] mobs passive.")
		if(made_active > 0)
			to_chat(user, span_notice("已将半径 [radius] 内 [made_active] 个 [faction] 阵营的生物设为主动状态。"))
			message_admins("[key_name_admin(user)] 将 [made_active] 个 [faction] 阵营的生物设为主动状态。")
			log_admin("[key_name(user)] made [made_active] [faction] mobs active.")
		if(skipped > 0)
			to_chat(user, span_warning("已跳过 [skipped] 个生物（无法控制）。"))
	else
		if(skipped > 0)
			to_chat(user, span_warning("找到了 [skipped] 个 [faction] 阵营的生物，但无法控制它们！"))
		else
			to_chat(user, span_warning("半径 [radius] 内未找到属于 [faction] 阵营的生物！"))
	
	// Refresh the window
	owner.mob << browse(null, "window=mass_direct")
	admin_datum.mass_direct_mobs(radius, faction, command_mode)
	
	restore_cursor() // Restore cursor after admin examine
	return TRUE

/datum/mass_direct_click_intercept/proc/cleanup()
	if(owner && owner.click_intercept == src)
		owner.click_intercept = null
		owner.mouse_pointer_icon = null
		owner.mob.update_mouse_pointer()
	// Don't call qdel here if we're already being destroyed
	if(!QDELETED(src))
		qdel(src)

// Find and set the best destructive intent for attacking objects
/datum/mass_direct_click_intercept/proc/set_destructive_intent(mob/living/attacker)
	if(!ismob(attacker))
		return
	
	// Check if mob has a weapon
	var/obj/item/weapon = attacker.get_active_held_item()
	if(weapon && weapon.gripped_intents)
		// Look for destructive intents like chop, cut, smash, bash
		var/list/destructive_types = list(
			"chop", "cut", "slash", "smash", "bash", "strike", "stab", "pierce"
		)
		
		for(var/intent_type in weapon.gripped_intents)
			if(istype(intent_type, /datum/intent))
				continue // Skip if it's already an instance
				
			// Check intent name for destructive keywords
			var/intent_name = "[intent_type]"
			for(var/keyword in destructive_types)
				if(findtext(intent_name, keyword))
					// Found a destructive intent, set it
					attacker.update_a_intents()
					// Find the intent in possible intents and set it
					for(var/datum/intent/possible_intent in attacker.possible_a_intents)
						if(istype(possible_intent, intent_type))
							attacker.used_intent = possible_intent
							return
	
	// No specific weapon intent found, try to use harm intent
	if(attacker.used_intent?.type != INTENT_HARM)
		for(var/datum/intent/possible_intent in attacker.possible_a_intents)
			if(possible_intent.type == INTENT_HARM)
				attacker.used_intent = possible_intent
				return

// Custom object attack routine for AI controlled mobs
/datum/mass_direct_click_intercept/proc/handle_object_attack(mob/living/attacker, atom/target)
	set waitfor = FALSE
	
	if(!attacker || QDELETED(attacker) || !target || QDELETED(target))
		active_attack_routines -= attacker
		return
	
	var/max_attempts = 100 // Prevent infinite loops
	var/attempts = 0
	
	while(attempts < max_attempts && attacker && !QDELETED(attacker) && target && !QDELETED(target) && active_attack_routines[attacker])
		// Check if mob is close enough to attack (adjacent or same tile)
		if(get_dist(attacker, target) <= 1)
			// Set the best destructive intent for the weapon
			set_destructive_intent(attacker)
			
			// Perform attack using proper damage method
			if(isliving(target))
				// Attack living targets normally
				attacker.UnarmedAttack(target)
			else
				// For objects, only use UnarmedAttack if humanoid has a weapon equipped
				if(istype(attacker, /mob/living/carbon))
					var/obj/item/weapon = attacker.get_active_held_item()
					if(weapon)
						// Has weapon - use UnarmedAttack to strike with weapon
						attacker.UnarmedAttack(target)
					else
						// No weapon - use attack_animal to bypass door opening
						target.attack_animal(attacker)
				else
					// For simple animals, use attack_animal
					target.attack_animal(attacker)
			
			// Small delay between attacks
			sleep(1 SECONDS)
		else
			// Move closer to target
			if(attacker.ai_controller)
				var/datum/ai_controller/ai = attacker.ai_controller
				ai.set_blackboard_key(BB_TRAVEL_DESTINATION, get_turf(target))
			
			// Wait a bit before checking again
			sleep(0.5 SECONDS)
		
		attempts++
		
		// Check if target is destroyed
		if(!target || QDELETED(target))
			break
			
		// Check if mob is no longer controllable
		if(!attacker.faction || !(faction in attacker.faction))
			break
	
	// Cleanup tracking when routine ends
	active_attack_routines -= attacker

// Custom object attack routine for old NPC AI mobs
/datum/mass_direct_click_intercept/proc/handle_old_npc_object_attack(mob/living/carbon/human/attacker, atom/target)
	set waitfor = FALSE
	
	if(!attacker || QDELETED(attacker) || !target || QDELETED(target))
		active_attack_routines -= attacker
		return
	
	var/max_attempts = 100 // Prevent infinite loops
	var/attempts = 0
	
	while(attempts < max_attempts && attacker && !QDELETED(attacker) && target && !QDELETED(target) && active_attack_routines[attacker])
		// Check if mob is close enough to attack (adjacent or same tile)
		if(get_dist(attacker, target) <= 1)
			// Set the best destructive intent for the weapon
			set_destructive_intent(attacker)
			
			// Perform attack using proper damage method
			if(isliving(target))
				// Attack living targets normally
				attacker.UnarmedAttack(target)
			else
				// For objects, only use UnarmedAttack if carbon mob has a weapon equipped
				var/obj/item/weapon = attacker.get_active_held_item()
				if(weapon)
					// Has weapon - use UnarmedAttack to strike with weapon
					attacker.UnarmedAttack(target)
				else
					// No weapon - use attack_animal to bypass door opening
					target.attack_animal(attacker)
			
			// Small delay between attacks
			sleep(1 SECONDS)
		else
			// Move closer to target using old NPC AI pathing
			attacker.start_pathing_to(get_turf(target))
			
			// Wait a bit before checking again
			sleep(0.5 SECONDS)
		
		attempts++
		
		// Check if target is destroyed
		if(!target || QDELETED(target))
			break
			
		// Check if mob is no longer controllable
		if(isnull(attacker.mode))
			break

	// Cleanup tracking when routine ends
	active_attack_routines -= attacker

// Monitor movement for mobs with AI - stop when destination reached and re-enable AI
/datum/mass_direct_click_intercept/proc/monitor_movement_ai(mob/living/simple_animal/S, turf/target_turf)
	set waitfor = FALSE
	
	if(!S || QDELETED(S) || !target_turf)
		return
	
	// Give the mob time to start moving
	sleep(30) // Wait 3 seconds before starting to monitor
	
	var/initial_dist = get_dist(S, target_turf)
	// If already very close, don't bother monitoring
	if(initial_dist <= 1)
		return
	
	var/max_checks = 1200 // Maximum time to monitor (2 minutes)
	var/checks = 0
	var/last_dist = initial_dist
	var/no_progress_count = 0
	
	while(checks < max_checks && S && !QDELETED(S))
		sleep(5) // Check every half second
		checks++
		
		var/current_dist = get_dist(S, target_turf)
		
		// If we're at the destination, stop
		if(current_dist <= 1)
			walk(S, 0)
			if(S.ai_controller)
				S.ai_controller.set_ai_status(AI_STATUS_ON)
			return
		
		// Check if the mob has made progress
		if(current_dist >= last_dist)
			no_progress_count++
			// Only stop if the mob hasn't made progress for a significant time (15 seconds)
			if(no_progress_count >= 30)
				walk(S, 0)
				if(S.ai_controller)
					S.ai_controller.set_ai_status(AI_STATUS_ON)
				return
		else
			no_progress_count = 0 // Reset counter if making progress
		
		last_dist = current_dist
	
	// Timeout reached - stop movement and restore AI
	if(S && !QDELETED(S))
		walk(S, 0)
		if(S.ai_controller)
			S.ai_controller.set_ai_status(AI_STATUS_ON)

// Monitor movement for mobs without AI - just stop when destination reached
/datum/mass_direct_click_intercept/proc/monitor_movement_basic(mob/living/simple_animal/S, turf/target_turf)
	set waitfor = FALSE
	
	if(!S || QDELETED(S) || !target_turf)
		return
	
	// Give the mob time to start moving
	sleep(30) // Wait 3 seconds before starting to monitor
	
	var/initial_dist = get_dist(S, target_turf)
	// If already very close, don't bother monitoring
	if(initial_dist <= 1)
		return
	
	var/max_checks = 1200 // Maximum time to monitor (2 minutes)
	var/checks = 0
	var/last_dist = initial_dist
	var/no_progress_count = 0
	
	while(checks < max_checks && S && !QDELETED(S))
		sleep(5) // Check every half second
		checks++
		
		var/current_dist = get_dist(S, target_turf)
		
		// If we're at the destination, stop
		if(current_dist <= 1)
			walk(S, 0)
			return
		
		// Check if the mob has made progress
		if(current_dist >= last_dist)
			no_progress_count++
			// Only stop if the mob hasn't made progress for a significant time (15 seconds)
			if(no_progress_count >= 30)
				walk(S, 0)
				return
		else
			no_progress_count = 0 // Reset counter if making progress
		
		last_dist = current_dist
	
	// Timeout reached - stop movement
	if(S && !QDELETED(S))
		walk(S, 0)

// Custom movement handler that ensures mobs reach their destination
/datum/mass_direct_click_intercept/proc/handle_simple_movement(mob/living/simple_animal/S, turf/target_turf, had_ai = FALSE)
	set waitfor = FALSE
	
	if(!S || QDELETED(S) || !target_turf)
		return
	
	var/initial_dist = get_dist(S, target_turf)
	if(initial_dist <= 1)
		if(had_ai && S.ai_controller)
			S.ai_controller.set_ai_status(AI_STATUS_ON)
		return
	
	// Get movement delay
	var/delay = 2
	if(istype(S, /mob/living/simple_animal/hostile) && S:move_to_delay)
		delay = S:move_to_delay
	
	var/max_time = 600 // 60 seconds maximum
	var/time_elapsed = 0
	var/stuck_time = 0
	var/last_dist = initial_dist
	
	// Main movement loop
	while(time_elapsed < max_time && S && !QDELETED(S))
		var/current_dist = get_dist(S, target_turf)
		
		// Check if we've reached the destination
		if(current_dist <= 1)
			walk(S, 0)
			if(had_ai && S.ai_controller)
				S.ai_controller.set_ai_status(AI_STATUS_ON)
			return
		
		// Try different movement approaches based on distance
		if(current_dist <= 3)
			// Close range - use walk_towards for precise movement
			walk(S, 0)
			walk_towards(S, target_turf, 0, delay)
		else
			// Long range - use walk_to for pathfinding
			walk(S, 0)
			walk_to(S, target_turf, 0, delay)
		
		// Wait and check progress
		sleep(50) // Wait 5 seconds
		time_elapsed += 5
		
		var/new_dist = get_dist(S, target_turf)
		
		// Check if making progress
		if(new_dist >= last_dist)
			stuck_time += 5
			// If stuck for 20 seconds, try alternative movement
			if(stuck_time >= 20)
				// Try walking in the general direction step by step
				var/dir_to_target = get_dir(S, target_turf)
				if(dir_to_target)
					walk(S, 0)
					walk(S, dir_to_target, delay)
					sleep(20) // Give it 2 seconds to move
					stuck_time = 0 // Reset stuck timer after manual intervention
		else
			stuck_time = 0 // Reset stuck timer if making progress
			last_dist = new_dist
	
	// Final cleanup
	if(S && !QDELETED(S))
		walk(S, 0)
		if(had_ai && S.ai_controller)
			S.ai_controller.set_ai_status(AI_STATUS_ON)
