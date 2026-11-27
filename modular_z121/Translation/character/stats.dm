/// Attribute keys stay identical to upstream; translate only at display boundaries.
/proc/get_stat_display_name(stat_key)
	var/static/list/display_names = list(
		STATKEY_STR = "力量",
		STATKEY_PER = "感知",
		STATKEY_INT = "智力",
		STATKEY_CON = "体质",
		STATKEY_WIL = "意志",
		STATKEY_SPD = "速度",
		STATKEY_LCK = "幸运"
	)
	return display_names[stat_key] || stat_key

/// Native input returns a label; callers must resolve it through this list before applying stats.
/proc/get_stat_display_options(list/stat_keys)
	var/list/options = list()
	for(var/stat_key in stat_keys)
		options[get_stat_display_name(stat_key)] = stat_key
	return options

// Reagents are identified by type paths. Only their player-facing names are translated.
/datum/reagent/buff/New()
	. = ..()
	name = get_stat_display_name(name)

/atom/movable/screen/alert/status_effect/buff/alch/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = get_stat_display_name(name)

/// Keep the native menu's labels separate from the value returned to gameplay code.
/proc/input_stat_choice(mob/user, message, title, list/stat_keys)
	var/list/options = get_stat_display_options(stat_keys)
	var/choice = input(user, message, title) as anything in options
	return options[choice]

/// Older character saves used translated attribute values; normalize only at the load boundary.
/proc/migrate_legacy_stat_key(stat_key)
	if(!istext(stat_key))
		return stat_key
	var/static/list/legacy_keys = get_stat_display_options(MOBSTATS)
	return legacy_keys[stat_key] || stat_key
