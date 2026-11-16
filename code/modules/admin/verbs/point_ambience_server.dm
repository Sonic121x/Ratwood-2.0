/// The window the next report measures from
GLOBAL_DATUM(point_ambience_server_window, /datum/point_ambience_server_window)

/// The counts at the start of a window, which a report subtracts from the current ones
/datum/point_ambience_server_window
	var/time
	var/list/counts

/datum/point_ambience_server_window/New()
	time = world.time
	counts = point_ambience_server_counts()
	SSpoint_ambience.metrics.queue_wait_window_max = 0

/**
 * Reports point ambience activity and timed work since the selected window began.
 *
 * Reads existing subsystem counters without enabling additional instrumentation. The first
 * invocation starts a window. Later reports can keep, restart or clear it.
 *
 * Timing covers phases of fire(). Inline movement services, movement-hook bookkeeping and
 * source-index changes outside fire() are not included.
 */
/client/proc/point_ambience_server()
	set category = "调试"
	set name = "局部环境音服务器统计"
	if(!check_rights(R_DEBUG))
		return
	var/datum/point_ambience_server_window/window = GLOB.point_ambience_server_window
	if(!window)
		if(alert_sound_display("记录起点，此后每次运行都会报告从起点至今的统计。不会启用额外功能：子系统本就记录这些计数，保留统计窗口不增加开销。", "局部环境音服务器统计", "Start", "Cancel") != "Start")
			return
		GLOB.point_ambience_server_window = new
		to_chat(src, span_notice("局部环境音服务器统计：<b>已记录起点。</b>未启用额外功能。清除可关闭统计窗口。再次运行此指令可查看从现在开始的统计。"))
		return
	var/seconds = (world.time - window.time) / 10
	if(seconds < 10)
		to_chat(src, span_warning("局部环境音服务器统计：距起点仅 [round(seconds)] 秒，请再等一会儿。"))
		return
	if(SSpoint_ambience.started_at > window.time)
		GLOB.point_ambience_server_window = new
		to_chat(src, span_warning("局部环境音服务器统计：记录起点后子系统曾重启。现已从当前时刻重新开始统计。"))
		return
	to_chat(src, point_ambience_server_report(window))
	switch(alert_sound_display("保留：继续从原起点统计，统计时段持续增长。\n重新开始：从现在起开启新的统计时段。\n清除：关闭统计窗口，直到有人再次运行此指令。\n\n无论如何选择，都不会启用额外功能：子系统本就记录这些计数。", "局部环境音服务器统计", "Keep", "Restart", "Clear"))
		if("Restart")
			GLOB.point_ambience_server_window = new
			to_chat(src, span_notice("局部环境音服务器统计：已记录新的起点。"))
		if("Clear")
			GLOB.point_ambience_server_window = null
			to_chat(src, span_notice("局部环境音服务器统计：<b>已清除。</b>下次运行会记录新的起点。"))

/// Every count a report reads, by name
/proc/point_ambience_server_counts()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	return list(
		"drain_usage" = ambience.metrics.drain_usage,
		"walk_usage" = ambience.metrics.walk_usage,
		"fade_usage" = ambience.metrics.fade_usage,
		"door_usage" = ambience.metrics.door_usage,
		"steps" = ambience.metrics.moves_total,
		"moving" = ambience.metrics.drain_services + ambience.metrics.move_services,
		"drains" = ambience.metrics.drains,
		"skipped" = ambience.metrics.standing_skipped,
		"cached" = ambience.metrics.standing_walk_hits,
		"walked" = ambience.metrics.standing_walk_miss_turf + ambience.metrics.standing_walk_miss_version + ambience.metrics.standing_walk_miss_volume,
		"ranked" = ambience.metrics.services_ranked,
		"silent" = ambience.metrics.moving_silent,
		"sends" = ambience.metrics.sends_total,
		"checks" = ambience.metrics.occlusion_checks_total,
		"blocked" = ambience.metrics.runner_up_silenced,
		"waited" = ambience.metrics.queue_wait_total,
		"served" = ambience.metrics.queue_served,
		"deferred" = ambience.metrics.queue_deferred_ticks,
		"paused" = ambience.metrics.drain_paused,
		"dropped" = ambience.metrics.services_dropped_tick_usage + ambience.metrics.services_dropped_budget,
		"fade_packets" = ambience.metrics.fade_packets,
		"hits" = ambience.metrics.tile_cache_hits,
		"misses" = ambience.metrics.tile_cache_misses,
		"index" = ambience.metrics.index_changes,
		"doors" = ambience.metrics.door_changes,
		"reserved" = ambience.metrics.door_listeners_marked,
		"speed" = ambience.metrics.speed_silences,
		"muted_refused" = ambience.metrics.muted_services_refused,
		"river_fill_rebuilds" = ambience.river_fill.rebuilds,
		"river_fill_usage" = ambience.metrics.river_fill_usage,
		"drain_size_drains" = ambience.metrics.drain_size_drains.Copy(),
		"drain_size_services_total" = ambience.metrics.drain_size_services_total.Copy(),
	)

/proc/point_ambience_server_report(datum/point_ambience_server_window/window)
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	var/list/now = point_ambience_server_counts()
	var/list/was = window.counts
	var/list/delta = list()
	for(var/key in now)
		if(!islist(now[key]))
			delta[key] = now[key] - was[key]
	var/seconds = max((world.time - window.time) / 10, 1)
	var/listening = 0
	var/muted = 0
	var/moving_now = 0
	for(var/client/listener_client as anything in GLOB.clients)
		if(!listener_client.mob || isobserver(listener_client.mob) || isnewplayer(listener_client.mob))
			continue
		if(listener_client.point_ambience.silenced)
			muted++
			continue
		listening++
		if(!isnull(listener_client.point_ambience.last_move) && world.time - listener_client.point_ambience.last_move < 2 SECONDS)
			moving_now++
	var/drain_ms = TICK_DELTA_TO_MS(delta["drain_usage"]) / seconds
	var/walk_ms = TICK_DELTA_TO_MS(delta["walk_usage"]) / seconds
	var/fade_ms = TICK_DELTA_TO_MS(delta["fade_usage"]) / seconds
	var/door_ms = TICK_DELTA_TO_MS(delta["door_usage"]) / seconds
	var/river_fill_ms = TICK_DELTA_TO_MS(delta["river_fill_usage"]) / seconds
	var/total_ms = drain_ms + walk_ms + fade_ms + door_ms + river_fill_ms
	var/ranked = delta["ranked"]
	var/checks = delta["checks"]
	var/list/drain_size_drains = now["drain_size_drains"]
	var/list/drain_size_services_total = now["drain_size_services_total"]
	var/list/was_drains = was["drain_size_drains"]
	var/list/was_services = was["drain_size_services_total"]
	var/batched_services = 0
	var/list/shares = list()
	for(var/i in 1 to length(drain_size_services_total))
		batched_services += drain_size_services_total[i] - was_services[i]
	var/static/list/batch_names = list("1", "2", "3-4", "5-8", "9+")
	var/batch_drain_total = 0
	for(var/i in 1 to length(drain_size_services_total))
		batch_drain_total += drain_size_drains[i] - was_drains[i]
		shares += "[batch_names[i]] [round((drain_size_services_total[i] - was_services[i]) / max(batched_services, 1) * 100)]%"
	var/lookups = delta["hits"] + delta["misses"]
	var/list/lines = list()
	lines += "<b>局部环境音服务器统计</b>，[round(seconds)] 秒，[listening] 人收听，[muted] 人静音，[moving_now] 人正在移动，平均每人每秒 [round(delta["steps"] / seconds / max(listening, 1), 0.01)] 步"
	lines += "静音：[muted] 名玩家主动关闭声音 | 到达静音玩家的处理请求 [delta["muted_refused"]]"
	lines += "开销（毫秒/秒）：[round(total_ms, 0.001)] | 出队 [round(drain_ms, 0.001)] | 静止检查 [round(walk_ms, 0.001)] | 渐变 [round(fade_ms, 0.001)] | 门 [round(door_ms, 0.001)] | 河声填充 [round(river_fill_ms, 0.001)] | 占服务器时间 [round(total_ms / 10, 0.01)]%[ambience.use_queue ? "" : " | 队列已关闭，开销不含移动更新"]"
	lines += "处理次数/秒：移动 [round(delta["moving"] / seconds, 0.01)] | 静止检查跳过 [round(delta["skipped"] / seconds, 0.01)]，缓存命中 [round(delta["cached"] / seconds, 0.01)]，遍历 [round(delta["walked"] / seconds, 0.01)]"
	lines += "移动时无声：[round(delta["silent"] / max(delta["moving"], 1) * 100, 0.1)]%，[round(delta["silent"] / seconds, 0.01)] 次/秒"
	lines += "每次声源排序更新：发送 [round(delta["sends"] / max(ranked, 1), 0.01)] | 墙体检查 [round(checks / max(ranked, 1), 0.01)] | 阻挡率 [round(delta["blocked"] / max(checks, 1) * 100, 0.1)]%"
	lines += "批量处理：每秒出队 [round(delta["drains"] / seconds, 0.01)] 批 | 每批处理 [round(batched_services / max(batch_drain_total, 1), 0.01)] 次 | 各批次规模的处理占比：[shares.Join(", ")]"
	lines += "队列：平均等待 [round(delta["waited"] / max(delta["served"], 1) / world.tick_lag, 0.01)] 刻，最长 [round(ambience.metrics.queue_wait_window_max / world.tick_lag)] 刻 | [round(delta["deferred"] / max(delta["drains"], 1) * 100, 0.1)]% 的出队批次触及预算 | 暂停 [delta["paused"]] | 丢弃 [delta["dropped"]]"
	lines += "每秒渐变包 [round(delta["fade_packets"] / seconds, 0.01)] | 地块缓存命中率 [round(delta["hits"] / max(lookups, 1) * 100, 0.1)]% | 每分钟索引变化 [round(delta["index"] / seconds * 60, 0.1)] | 每秒门地块变化 [round(delta["doors"] / seconds, 0.01)]，重新处理 [round(delta["reserved"] / seconds, 0.01)] | 每秒超速静音 [round(delta["speed"] / seconds, 0.01)]"
	lines += "河声填充：[ambience.river_fill.done ? "从 [length(ambience.river_fill.seeds)] 个水域种子标记了 [ambience.river_fill.marked_tiles] 个地块，启动耗时 [round(ambience.river_fill.boot_ms, 0.1)] 毫秒 | 重建区域数 [delta["river_fill_rebuilds"]]" : "等待初始填充"]"
	return lines.Join("<br>")
