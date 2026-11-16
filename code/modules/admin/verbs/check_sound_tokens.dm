/**
 * Reports active sound tokens and sound-channel reservations.
 *
 * Uses SSsounds.using_channels_by_datum, where every token registers its reserved channel, so no
 * separate token registry is needed.
 */
/client/proc/check_sound_tokens()
	set category = "调试"
	set name = "检查声音令牌"
	if(!check_rights(R_DEBUG))
		return

	if(!SSsounds)
		to_chat(usr, span_warning("SSsounds 不存在。"))
		return

	var/list/output = list()

	var/pool_total = SSsounds.using_channels_max - SSsounds.random_channels_min
	var/reserved_now = SSsounds.using_channels_max - SSsounds.channel_reserve_high
	var/reservable_left = SSsounds.channel_reserve_high - SSsounds.random_channels_min
	var/pct = pool_total ? round((reserved_now / pool_total) * 100, 0.1) : 0

	output += "<h2>通道池</h2>"
	output += "<table border='1' cellpadding='3'>"
	output += "<tr><td>可预留通道池</td><td><b>[pool_total]</b>（通道 [SSsounds.random_channels_min + 1]-[SSsounds.using_channels_max]）</td></tr>"
	output += "<tr><td>当前已预留</td><td><b>[reserved_now]</b>（[pct]%）</td></tr>"
	output += "<tr><td>仍可预留</td><td><b>[reservable_left]</b></td></tr>"
	output += "<tr><td>channel_reserve_high</td><td>[SSsounds.channel_reserve_high]</td></tr>"
	output += "<tr><td>channel_random_low</td><td>[SSsounds.channel_random_low] <i>（单次 playsound 的循环位置，不预留通道）</i></td></tr>"
	output += "</table>"
	if(reservable_left < 100)
		output += "<p><b style='color:red'>剩余通道不足 100 个。通道池耗尽后将无法创建令牌，乐器和音乐盒会开始播放失败。</b></p>"

	var/list/tokens = list()
	var/list/other_holders = list()
	for(var/holder in SSsounds.using_channels_by_datum)
		if(istype(holder, /datum/sound_token))
			tokens += holder
		else
			other_holders += holder

	var/list/by_type = list()
	var/total_listeners = 0
	for(var/datum/sound_token/token as anything in tokens)
		var/type_key = "[token.source ? token.source.type : "(source gone)"]"
		by_type[type_key] = (by_type[type_key] || 0) + 1
		total_listeners += length(token.listeners)

	output += "<h2>活动令牌：[length(tokens)]</h2>"
	output += "<p>所有令牌共占用听者槽位：<b>[total_listeners]</b>"
	output += " &mdash; 平均每个令牌 [length(tokens) ? round(total_listeners / length(tokens), 0.01) : 0] 名听者。<br>"
	output += "<i>没有听者的令牌仍占用通道和网格信号。延迟创建机制旨在避免大量此类无效占用。</i></p>"

	output += "<h3>按声源类型汇总</h3><table border='1' cellpadding='3'><tr><th>声源类型</th><th>令牌数</th></tr>"
	for(var/type_key in by_type)
		output += "<tr><td>[type_key == "(source gone)" ? "（声源已消失）" : type_key]</td><td align='right'><b>[by_type[type_key]]</b></td></tr>"
	output += "</table>"

	output += "<h3>令牌明细</h3>"
	output += "<table border='1' cellpadding='3'><tr>"
	output += "<th>声源</th><th>位置</th><th>通道</th><th>范围</th><th>音量</th><th>听者</th><th>循环</th><th>遵循乐器偏好</th><th>网格单元</th><th>已持续（秒）</th><th>音频</th></tr>"
	for(var/datum/sound_token/token as anything in tokens)
		var/turf/token_turf = get_turf(token.source)
		var/where = token_turf ? "[get_area_name(token_turf)] ([token_turf.x],[token_turf.y],[token_turf.z])" : "<i>空空间</i>"
		var/listener_count = length(token.listeners)
		var/age = token.start_time ? round((REALTIMEOFDAY - token.start_time) / 10, 0.1) : "?"
		var/soundfile = token.sound ? "[token.sound.file]" : "<i>无</i>"
		var/row_style = listener_count ? "" : " style='color:#888'"
		output += "<tr[row_style]>"
		output += "<td>[token.source ? "[token.source]" : "<i>已消失</i>"]</td>"
		output += "<td>[where]</td>"
		output += "<td align='right'>[token.sound_channel]</td>"
		output += "<td align='right'>[token.range]</td>"
		output += "<td align='right'>[token.volume]</td>"
		output += "<td align='right'><b>[listener_count]</b></td>"
		output += "<td>[token.repeating ? "是" : "否"]</td>"
		output += "<td>[token.respect_instrument_pref ? "是" : "否"]</td>"
		output += "<td align='right'>[length(token.cell_trackers)]</td>"
		output += "<td align='right'>[age]</td>"
		output += "<td>[soundfile]</td>"
		output += "</tr>"
	output += "</table>"

	output += "<h2>其他通道持有者：[length(other_holders)]</h2>"
	if(length(other_holders))
		output += "<table border='1' cellpadding='3'><tr><th>持有者</th><th>类型</th><th>通道</th></tr>"
		for(var/holder in other_holders)
			var/list/held = SSsounds.using_channels_by_datum[holder]
			output += "<tr><td>[holder]</td><td>[istype(holder, /datum) ? "[holder:type]" : "（非 datum）"]</td><td>[length(held)] : [held ? jointext(held, ", ") : ""]</td></tr>"
		output += "</table>"
	else
		output += "<p><i>无</i></p>"

	output += "<h2>SSsound_tokens</h2>"
	if(SSsound_tokens)
		output += "<table border='1' cellpadding='3'>"
		output += "<tr><td>等待位置刷新的客户端</td><td><b>[length(SSsound_tokens.clients_needing_update)]</b></td></tr>"
		output += "<tr><td>本轮积压任务</td><td>[length(SSsound_tokens.currentrun)]</td></tr>"
		output += "</table>"
		output += "<p><i>队列使用幂等标记，每次子系统运行时处理一次；无论移动多快，客户端每刻最多刷新一次。持续的大量积压说明听者更新请求超过了子系统的处理能力。</i></p>"
	else
		output += "<p><i>SSsound_tokens 不存在。</i></p>"

	output += "<h2>你的令牌通道</h2>"
	if(SSsound_tokens)
		var/queued_for_update = SSsound_tokens.clients_needing_update[src] || (src in SSsound_tokens.currentrun)
		output += "<p>你的位置刷新已入队：[queued_for_update ? "是" : "否"]</p>"
	output += "<table border='1' cellpadding='3'><tr><th>声源</th><th>声源地块</th><th>通道</th><th>距离</th><th>服务端静音</th><th>已开始</th><th>客户端播放状态及进度</th></tr>"
	var/own_token_count = 0
	var/list/client_sounds_by_channel = list()
	// SoundQuery reports no volume, and its status carries only SOUND_PAUSED, so mute and volume are
	// known from the server side alone
	var/list/queried_sounds = src.SoundQuery()
	for(var/sound/client_sound as anything in queried_sounds)
		client_sounds_by_channel["[client_sound.channel]"] = client_sound
	for(var/datum/sound_token/token as anything in tokens)
		if(isnull(token.listeners[mob]))
			continue
		own_token_count++
		var/turf/source_turf = get_turf(token.source)
		var/turf/listener_turf = get_turf(mob)
		var/distance = (source_turf && listener_turf) ? round(get_dist_euclidean(source_turf, listener_turf), 0.1) : "无地块"
		var/sound/client_sound = client_sounds_by_channel["[token.sound_channel]"]
		var/source_name = html_encode("[token.source]")
		var/source_coords = source_turf ? "[source_turf.x],[source_turf.y],[source_turf.z]" : "无"
		var/server_muted = (token.listeners[mob] & SOUND_MUTE) ? "是" : "否"
		var/started = LAZYACCESS(token.started_listeners, mob) ? "是" : "否"
		var/client_state = "未播放"
		if(client_sound)
			client_state = "播放中，[round(client_sound.offset, 0.1)] / [round(client_sound.len, 0.1)] 秒"
		output += "<tr><td>[source_name]</td><td>[source_coords]</td><td>[token.sound_channel]</td><td>[distance] / [token.range]</td><td>[server_muted]</td><td>[started]</td><td>[client_state]</td></tr>"
	output += "</table>"
	if(!own_token_count)
		output += "<p>当前没有令牌将你的角色列为听者。</p>"

	output += "<h3>客户端正在播放的池内通道</h3>"
	output += "<p><i>没有持有者表示该声音是随机通道上的单次音效。</i></p>"
	output += "<table border='1' cellpadding='3'><tr><th>通道</th><th>文件</th><th>进度</th><th>循环</th><th>服务端持有者</th></tr>"
	for(var/sound/queried_sound as anything in queried_sounds)
		if(queried_sound.channel <= SSsounds.random_channels_min || queried_sound.channel > SSsounds.using_channels_max)
			continue
		var/holder = SSsounds.using_channels["[queried_sound.channel]"]
		var/sound_file = html_encode("[queried_sound.file]")
		var/holder_name = holder ? html_encode("[holder]") : "无"
		output += "<tr><td>[queried_sound.channel]</td><td>[sound_file]</td><td>[round(queried_sound.offset, 0.1)] / [round(queried_sound.len, 0.1)] 秒</td><td>[queried_sound.repeat]</td><td>[holder_name]</td></tr>"
	output += "</table>"

	var/datum/browser/browser = new(usr, "check_sound_tokens", "声音令牌与通道", 900, 700)
	browser.set_content(jointext(output, ""))
	browser.open()
