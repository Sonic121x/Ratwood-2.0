/datum/preferences/proc/open_loadout_menu(mob/user, slot = 1)
	if(!user || !user.client)
		return
	
	// Redirect to unified character customization menu
	if(!loadout_menu)
		loadout_menu = new(src)
	loadout_menu.ui_interact(user)
	loadout_menu.current_slot = slot

/datum/preferences/proc/generate_loadout_html(mob/user)
	var/total_triumphs = usr.get_triumphs()
	var/spent_triumphs = 0
	
	// Calculate spent triumphs
	for(var/i = 1 to 10)
		var/datum/loadout_item/loadout_slot = vars["loadout[i == 1 ? "" : "[i]"]"]
		if(loadout_slot && loadout_slot.triumph_cost)
			spent_triumphs += loadout_slot.triumph_cost
	
	var/remaining_triumphs = total_triumphs - spent_triumphs
	
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<style>
			body {
				font-family: Verdana, Arial, sans-serif;
				background: #1C0000;
				color: #e3c06f;
				margin: 0;
				padding: 20px;
			}
			.header {
				text-align: center;
				padding: 15px;
				background: rgba(0, 0, 0, 0.4);
				border: 1px solid #e3c06f;
				margin-bottom: 20px;
			}
			.header h1 {
				margin: 0;
				color: #e3c06f;
				font-size: 1.5em;
			}
			.triumph-counter {
				font-size: 1em;
				margin-top: 10px;
			}
			.triumph-available {
				color: #4CAF50;
			}
			.triumph-spent {
				color: #ff9800;
			}
			.loadout-grid {
				display: grid;
				grid-template-columns: repeat(2, 1fr);
				gap: 15px;
				padding: 20px;
			}
			.loadout-slot {
				background: rgba(0, 0, 0, 0.4);
				border: 1px solid #444;
				padding: 15px;
			}
			.loadout-slot:hover {
				border-color: #e3c06f;
			}
			.slot-header {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 10px;
				padding-bottom: 10px;
				border-bottom: 1px solid #444;
			}
			.slot-number {
				font-weight: bold;
				color: #e3c06f;
			}
			.slot-cost {
				background: #e3c06f;
				color: #1C0000;
				padding: 2px 8px;
				font-size: 0.9em;
				font-weight: bold;
			}
			.item-display {
				display: flex;
				align-items: center;
				margin-bottom: 10px;
			}
			.item-icon {
				width: 64px;
				height: 64px;
				background: rgba(0,0,0,0.6);
				border: 1px solid #444;
				margin-right: 15px;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			.item-icon img {
				max-width: 60px;
				max-height: 60px;
			}
			.item-info {
				flex: 1;
			}
			.item-name {
				font-weight: bold;
				color: #e3c06f;
				margin-bottom: 5px;
			}
			.item-desc {
				font-size: 0.85em;
				color: #999;
			}
			.btn {
				padding: 6px 12px;
				border: 1px solid #444;
				background: rgba(0, 0, 0, 0.4);
				color: #e3c06f;
				cursor: pointer;
				font-family: Verdana, Arial, sans-serif;
				font-size: 0.85em;
				text-decoration: none;
				display: inline-block;
				margin: 2px;
			}
			.btn:hover {
				background: rgba(227, 192, 111, 0.2);
				border-color: #e3c06f;
			}
			.btn-select {
				background: rgba(76, 175, 80, 0.3);
				border-color: #4CAF50;
				color: #4CAF50;
			}
			.btn-select:hover {
				background: rgba(76, 175, 80, 0.5);
			}
			.btn-clear {
				background: rgba(244, 67, 54, 0.3);
				border-color: #f44336;
				color: #f44336;
			}
			.btn-clear:hover {
				background: rgba(244, 67, 54, 0.5);
			}
			.btn-customize {
				background: rgba(33, 150, 243, 0.3);
				border-color: #2196F3;
				color: #2196F3;
			}
			.btn-customize:hover {
				background: rgba(33, 150, 243, 0.5);
			}
			.btn-color {
				background: rgba(156, 39, 176, 0.3);
				border-color: #9C27B0;
				color: #9C27B0;
			}
			.btn-color:hover {
				background: rgba(156, 39, 176, 0.5);
			}
			.empty-slot {
				text-align: center;
				padding: 20px;
				color: #666;
				font-style: italic;
			}
			.custom-text {
				margin-top: 5px;
				font-size: 0.8em;
				color: #888;
			}
			.actions {
				margin-top: 10px;
				display: flex;
				flex-wrap: wrap;
				gap: 5px;
			}
			.info-box {
				background: rgba(227, 192, 111, 0.1);
				border: 1px solid #e3c06f;
				padding: 15px;
				margin: 15px 0;
				border-radius: 4px;
				color: #e3c06f;
			}
			.info-box h3 {
				margin: 0 0 10px 0;
				color: #e3c06f;
				font-size: 1.1em;
			}
			.info-box p {
				margin: 5px 0;
				font-size: 0.9em;
				color: #ccc;
			}
		</style>
		<body>
			<div class="header">
				<h1>⚔ 配装选择 ⚔</h1>
				<div class="triumph-counter">
					<span class="triumph-available">可用凯旋点: [remaining_triumphs]</span> |
					<span class="triumph-spent">已用: [spent_triumphs]</span> /
					<span>总计: [total_triumphs]</span>
				</div>
			</div>
			
			<div class="info-box">
				<h3>⚠ 配装物品调整 ⚠</h3>
				<p><b>护甲与头盔:</b> 护甲值降低90% • 移除防重伤效果</p>
				<p><b>武器:</b> 伤害降低25%</p>
				<p><b>所有物品:</b> 售价设为0</p>
			</div>
			
			<div class="loadout-grid">
	"}
	
	// Generate 10 loadout slots
	for(var/i = 1 to 10)
		var/slot_var = i == 1 ? "loadout" : "loadout[i]"
		var/datum/loadout_item/current_item = vars[slot_var]
		var/custom_name = vars["loadout_[i]_name"]
		var/custom_desc = vars["loadout_[i]_desc"]
		var/item_color = vars["loadout_[i]_hex"]
		
		html += "<div class='loadout-slot'>"
		html += "<div class='slot-header'>"
		html += "<span class='slot-number'>栏位 [i]</span>"
		
		if(current_item && current_item.triumph_cost)
			html += "<span class='slot-cost'>[current_item.triumph_cost]凯旋点</span>"
		
		html += "</div>"
		
		if(current_item)
			// Item is selected
			var/obj/item/sample = current_item.path
			var/icon_file = initial(sample.icon)
			var/icon_state = initial(sample.icon_state)
			var/item_desc = initial(sample.desc)
			
			html += "<div class='item-display'>"
			html += "<div class='item-icon'>"
			
			// Use the item's icon with caching
			if(icon_file && icon_state)
				var/cache_key = "[icon_file]_[icon_state]"
				if(!(cache_key in GLOB.cached_loadout_icons))
					if(GLOB.cached_loadout_icons.len >= MAX_ICON_CACHE_SIZE)
						GLOB.cached_loadout_icons.Cut(1, 50)
					GLOB.cached_loadout_icons[cache_key] = icon(icon_file, icon_state)
				user << browse_rsc(GLOB.cached_loadout_icons[cache_key], "loadout_icon_[i].png")
				html += "<img src='loadout_icon_[i].png' />"
			
			html += "</div>"
			html += "<div class='item-info'>"
			html += "<div class='item-name'>[custom_name ? custom_name : current_item.name]</div>"
			html += "<div class='item-desc'>[custom_desc ? custom_desc : (item_desc ? item_desc : current_item.desc)]</div>"
			
			if(custom_name || custom_desc)
				html += "<div class='custom-text'>✎ 已自定义</div>"
			
			if(item_color)
				html += "<div class='custom-text' style='color:[item_color]'>● 颜色: [item_color]</div>"
			
			html += "</div>"
			html += "</div>"
			
			html += "<div class='actions'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];loadout_action=change;slot=[i]'>更换物品</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[src];loadout_action=rename;slot=[i]'>重命名</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[src];loadout_action=describe;slot=[i]'>描述</a>"
			html += "<a class='btn btn-color' href='byond://?src=\ref[src];loadout_action=color;slot=[i]'>颜色</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[src];loadout_action=clear;slot=[i]'>清除</a>"
			html += "</div>"
		else
			// Empty slot
			html += "<div class='empty-slot'>"
			html += "空栏位<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];loadout_action=select;slot=[i]'>选择物品</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
			</div>
		</body>
		</html>
	"}
	
	return html

// Old Topic handler removed - now handled in vices_menu.dm
