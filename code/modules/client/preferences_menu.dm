// categories
GLOBAL_LIST_INIT(pref_categories, list(
	"Identity" = /datum/preferences/proc/page_identity,
	"Origin" = /datum/preferences/proc/page_origin,
	"Customization" = /datum/preferences/proc/page_loadout,
	"Character Settings" = /datum/preferences/proc/page_character_settings,
	"Voice" = /datum/preferences/proc/page_voice,
	"Body" = /datum/preferences/proc/page_features,
))

// skips char preview update on these options 2 avoid topic lag
GLOBAL_LIST_INIT(no_preview_prefs, list("category", "background", "flavortext", "nsfwflavortext", "ooc_notes", "erpprefs", "character_gallery", "rumour", "gossip", "rumour_preview", "ooc_extra", "change_title", "change_artist", "ooc_preview", "formathelp", "voicetype", "voicepack", "voice", "voice_pitch", "char_accent", "char_mannerism", "barksound", "barkspeed", "barkpitch", "barkvary", "barkvolume", "barkpreview", "combat_music", "dnr", "preferred_map", "familiar_prefs", "gnoll_prefs", "nickname", "highlight_color", "pronouns", "culinary", "tgui_theme", "parchment_skin", "tgui_ui_prefs", "playerquality", "triumphs", "family_board", "family", "gender_choice", "species_choice"))

GLOBAL_LIST_INIT(pref_columns, list(
	list("Identity", "Origin", "Voice", "Customization"),
	list("Character Settings", "Body", "Flavor Text"),
))

GLOBAL_LIST_INIT(selectable_languages, list(
	/datum/language/elvish,
	/datum/language/dwarvish,
	/datum/language/orcish,
	/datum/language/hellspeak,
	/datum/language/draconic,
	/datum/language/celestial,
	/datum/language/canilunzt,
	/datum/language/grenzelhoftian,
	/datum/language/kazengunese,
	/datum/language/etruscan,
	/datum/language/gronnic,
	/datum/language/hammerholdian,
	/datum/language/otavan,
	/datum/language/aavnic,
	/datum/language/merar,
	/datum/language/thievescant/signlanguage,
	/datum/language/abyssal,
))

/datum/preferences
	var/list/open_categories = list("Identity", "Origin", "Body", "Flavor Text")
	var/scroll_pos = 0
	/// Thumbnail HTML last sent to the Flavor Text section
	var/displayed_gallery_headshot

/datum/preferences/proc/yes_no(value)
	if(value)
		return "是"
	return "否"

/datum/preferences/proc/pref_link(label, preference, task = "input", byond_link = FALSE)
	var/href = "[byond_link ? "byond://" : ""]?_src_=prefs;preference=[preference]"
	if(task)
		href += ";task=[task]"
	return "<a href='[href]'>[(preference in list("name", "nickname", "setspouse", "family")) ? label : get_preferences_label_display(label)]</a>"

/datum/preferences/proc/bg_link(label, bg, slot)
	return "<a href='?_src_=prefs;preference=background;bg=[bg];slot=[slot]'>[get_preferences_label_display(label)]</a>"

/datum/preferences/proc/pref_item(label, value)
	return "<b>[get_preferences_label_display(label)]：</b> [value]"

/datum/preferences/proc/pref_line(list/items)
	return "<div class='r'>[items.Join("<br>")]</div>"

/datum/preferences/proc/pref_box(header, body, details, key)
	var/footer = ""
	if(details)
		var/label = "展开详情"
		if(key in open_categories)
			label = "收起详情"
			if(body)
				body += "<br>"
			body += details
		footer = "<div><a href='?_src_=prefs;preference=category;name=[url_encode(key)]'>\[[label]\]</a></div>"
	return "<div class='box'>[header]<div>[body]</div>[footer]</div>"

/datum/preferences/proc/pref_color_row(label, hex, preference)
	return pref_line(list(pref_item(label, "<span style='border: 1px solid #161616; background-color: #[hex];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> [pref_link("更改", preference)]")))

// da categories get built here
/datum/preferences/proc/get_character_page(mob/user)
	validate_background()
	is_banned_from(user.ckey, "Appearance")
	var/html = {"<style>
		body { font-size: 14px; }
		table { table-layout: fixed; }
		td { word-wrap: break-word; }
		.r { line-height: 1.5; font-size: 14px; margin: 2px 0; }
		.lab { font-weight: bold; color: #c9a96e; margin: 4px 0 1px 2px; }
		.lab a { background: none; border-color: transparent; padding: 0; color: #c9a96e; }
		.cbox { border: 1px solid #7b5353; background: #00000033; padding: 3px 6px; margin: 0 0 6px 0; }
		.box { border: 1px solid #7b5353; background: #1a0707; padding: 3px 6px; margin: 3px 0; }
		.cbox a, .box a { background: none; border-color: transparent; padding: 0; margin: 0 8px 0 0; }
		</style>
		<script>
		[js_byjax]
		function syncFlavorTextToggle() {
			var toggle = document.getElementById('preferences_flavor_toggle');
			var content = document.getElementById('preferences_flavor_content');
			if(!toggle || !content)
				return;
			var open = !!content.firstElementChild;
			toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
			toggle.innerHTML = (open ? '- ' : '+ ') + '角色描述';
		}
		function stamp(e) {
			e = e || window.event;
			var t = e.target || e.srcElement;
			while(t && t.tagName != 'A')
				t = t.parentNode;
			if(!t || !t.href || t.href.indexOf('_src_=prefs') == -1)
				return;
			var y = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
			t.href = t.href.replace(/;scroll=\[0-9.\]*/, '') + ';scroll=' + y;
		}
		document.onmousedown = stamp;
		document.onclick = stamp;
		var saved = parseInt(window.name);
		var target = isNaN(saved) ? [scroll_pos] : saved;
		var tracking = false;
		function restore() { window.scrollTo(0, target); }
		function track() {
			if(tracking)
				window.name = String(window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0);
		}
		window.onscroll = track;
		window.onload = function() {
			restore();
			setTimeout(restore, 50);
			setTimeout(restore, 200);
			setTimeout(function() { tracking = true; track(); }, 300);
		};
		</script>[get_top_html(user)]<table width='100%'><tr>"}
	for(var/list/column in GLOB.pref_columns)
		if(column == GLOB.pref_columns[1])
			html += "<td width='37%' valign='top'>"
		else
			html += "<td width='38%' valign='top'>"
		for(var/category in column)
			if(category == "Flavor Text")
				var/expanded = (category in open_categories)
				html += "<div class='lab'><a id='preferences_flavor_toggle' href='byond://?_src_=prefs;preference=category;name=[url_encode(category)]' aria-controls='preferences_flavor_content' aria-expanded='[expanded ? "true" : "false"]'>[expanded ? "-" : "+"] [get_preferences_label_display(category)]</a></div>"
				html += "<div id='preferences_flavor_content'>[expanded ? page_flavor_text() : ""]</div>"
				continue
			var/page = call(src, GLOB.pref_categories[category])(user)
			var/arrow = "+"
			if(category in open_categories)
				arrow = "-"
				page = "<div class='cbox'>[page]</div>"
			else
				page = ""
			html += "<div class='lab'><a href='?_src_=prefs;preference=category;name=[url_encode(category)]'>[arrow] [get_preferences_label_display(category)]</a></div>[page]"
		html += "</td>"
		if(column == GLOB.pref_columns[1])
			html += "<td width='25%'></td>"
	return "[html]</tr></table><script>restore();</script>"

/datum/preferences/proc/get_top_html(mob/user)
	var/triumphs = "无"
	if(user.get_triumphs())
		triumphs = "\Roman [user.get_triumphs()]"
	var/html = "<center>"
	html += "[pref_link("切换角色", "changeslot", "")] | [pref_link("职业选择", "job", "menu")] | [pref_link("反派选择", "antag", "menu")] | [pref_link("按键绑定", "keybinds", "menu")]<br>"
	html += "[pref_link("玩家评分：", "playerquality", "menu")] [get_playerquality(user.ckey, text = TRUE)] | [pref_link("凯旋点：", "triumphs", "menu")] [triumphs]"
	if(SStriumphs.triumph_buys_enabled)
		html += " [pref_link("凯旋点商店", "triumph_buy_menu", null)]"
	html += "<br>[pref_link(get_ui_style_name(), "tgui_ui_prefs", "menu")] | [pref_link("主题：[get_tgui_theme_display_name()]", "tgui_theme", "")] | [pref_link("羊皮纸：[get_parchment_skin_display_name()]", "parchment_skin", "")]<br>"
	html += get_preview_html()
	html += "</center><hr>"
	return html

/datum/preferences/proc/get_ui_style_name()
	if(tgui_pref)
		return "TGUI"
	return "传统界面"

/datum/preferences/proc/get_preview_html()
	var/html = ""
	var/datum/job/highest_pref
	for(var/job in job_preferences)
		if(job_preferences[job] > highest_pref)
			highest_pref = SSjob.GetJob(job)
	if(!isnull(highest_pref) && !istype(highest_pref, /datum/job/roguetown/jester))
		var/subclass_name = "无"
		if(preview_subclass)
			subclass_name = preview_subclass.name
		html += "子职业预览：[pref_link(subclass_name, "subclassoutfit")] | "
	else
		preview_subclass = null
	var/arousal_label = "无"
	if(preview_erect_state == ERECT_STATE_PARTIAL)
		arousal_label = "部分"
	if(preview_erect_state == ERECT_STATE_HARD)
		arousal_label = "勃起"
	html += "兴奋状态预览：[pref_link(arousal_label, "preview_erect_state", "")]"
	return html

/datum/preferences/proc/second_virtue_allowed()
	return istype(statpack, /datum/statpack/wildcard/virtuous) // 自定义修改：按类型识别德能属性组合，避免中文名称阻断第二美德

// annoying shit that makes sure u ain't cheating, runs on like every refresh (IDK might change it to be more selective)
/datum/preferences/proc/validate_background()
	if(length(pref_species.restricted_virtues))
		if(virtue.type in pref_species.restricted_virtues)
			virtue = GLOB.virtues[/datum/virtue/none]
		if(virtuetwo.type in pref_species.restricted_virtues)
			virtuetwo = GLOB.virtues[/datum/virtue/none]
	if(length(pref_species.restricted_quirks))
		for(var/datum/quirk/Q in quirks.Copy())
			if(Q.type in pref_species.restricted_quirks)
				quirks -= Q
	if(!second_virtue_allowed() || virtuetwo.type == virtue.type)
		virtuetwo = GLOB.virtues[/datum/virtue/none]
	var/list/seen_quirks = list()
	for(var/datum/quirk/Q in quirks.Copy())
		if((Q.type in seen_quirks) || istype(Q, /datum/quirk/none))
			quirks -= Q
		seen_quirks += Q.type

/datum/preferences/proc/page_identity(mob/user)
	var/html = ""
	if(is_banned_from(user.ckey, "Appearance"))
		html += "<b>你已被禁止使用自定义姓名与外观。你仍可调整角色，但进入游戏时将被随机化。</b><br>"
	var/name_link = "[pref_link(real_name, "name")] [pref_link("\[R\]", "name", "random")]"
	if(check_nameban(user.ckey))
		name_link = pref_link("已禁止自定义姓名", "name")
	html += pref_line(list(pref_item("Name", name_link)))
	html += pref_line(list(pref_item("Nickname", pref_link(nickname || real_name, "nickname"))))
	html += pref_line(list(pref_item("Nickname Color", pref_link("Change", "highlight_color"))))
	html += pref_line(list(pref_item("Pronouns", pref_link(pronouns, "pronouns")), pref_item("Age", pref_link(age, "age"))))
	var/race_flag = ""
	if(!spec_check(user))
		race_flag = " (!)"
	var/list/race_items = list(pref_item("Race", "[pref_link(get_species_display_name(pref_species.name), "species")][race_flag]"))
	if(pref_species.use_titles)
		race_items += pref_item("Race Title", pref_link(selected_title || "None", "race_title"))
	if(length(pref_species.custom_selection))
		var/race_bonus_display = "None"
		for(var/bonus in pref_species.custom_selection)
			if(race_bonus && pref_species.custom_selection[bonus] == race_bonus)
				race_bonus_display = bonus
				break
		race_items += pref_item("Race Bonus", pref_link(get_species_customization_display_name(race_bonus_display), "race_bonus_select"))
	else
		race_bonus = null
	html += pref_line(race_items)
	var/hand = "右利手"
	if(domhand == 1)
		hand = "左利手"
	if(!(AGENDER in pref_species.species_traits))
		var/body_type = "其他"
		if(gender == MALE)
			body_type = "男性化"
		if(gender == FEMALE)
			body_type = "女性化"
		html += pref_line(list(pref_item("Body Type", pref_link(body_type, "gender", ""))))
	html += pref_line(list(pref_item("Dominance", pref_link(hand, "domhand", ""))))
	if(!(AGENDER in pref_species.species_traits))
		if(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG])
			html += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_GENDER]'>始终随机体型：[yes_no(randomise[RANDOM_GENDER])]</a> "
			html += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_GENDER_ANTAG]'>担任反派时：[yes_no(randomise[RANDOM_GENDER_ANTAG])]</a><br>"
	return html

/datum/preferences/proc/page_origin(mob/user)
	var/html = ""
	var/origin_name = "None"
	if(origin)
		origin_name = origin.name
	html += pref_line(list(pref_item("Origin", pref_link(origin_name, "origin"))))
	var/datum/faith/selected_faith = GLOB.faithlist[selected_patron?.associated_faith]
	html += pref_line(list(pref_item("Faith", pref_link(selected_faith?.name || "INVALID", "faith")), pref_item("Patron", pref_link(selected_patron?.name || "INVALID", "patron"))))
	var/language_text = "由出身决定"
	if(!origin?.origin_language)
		language_text = get_language_link(extra_language, "lang_free")
	html += pref_line(list(pref_item("Language", language_text), pref_item("Relationships", pref_link("Change", "family_board", "menu")), pref_item("Food Preferences", pref_link("Change", "culinary", "menu"))))
	return html

/datum/preferences/proc/page_loadout(mob/user)
	var/html = pref_line(list(pref_item("Loadout Menu", pref_link("Change", "loadout", "menu"))))
	html += pref_line(list(pref_item("Presets", pref_link("Change", "loadout", "presets"))))
	html += page_stats(user)
	return html

/datum/preferences/proc/page_stats(mob/user)
	var/html = ""
	html += pref_box(pref_item("Statpack", bg_link(statpack.name, "statpack")), statpack.generate_modifier_string() || "")
	html += get_virtue_html("Primary Virtue", virtue, 1)
	if(second_virtue_allowed())
		html += get_virtue_html("Second Virtue", virtuetwo, 2)
	html += "<div class='lab'>怪癖</div>"
	var/triumph_gain = get_quirk_points_remaining()
	var/gain_color = "#e3c06f"
	var/gain_text = "[triumph_gain]"
	if(triumph_gain > 0)
		gain_color = "#91cf68"
		gain_text = "+[triumph_gain]"
	if(triumph_gain < 0)
		triumph_gain = -get_triumph_collateral()
		gain_color = "#cf2a2a"
		gain_text = "[triumph_gain]"
	html += "<div class='r'><font color='#c9a96e'><b>凯旋点收益：<font color='[gain_color]'>[gain_text]</font></b></font></div>"
	for(var/i in 1 to length(quirks))
		var/datum/quirk/current_quirk = quirks[i]
		var/quirk_header = "<b>[current_quirk.name]</b> ([current_quirk.point_cost]) [bg_link("\[Remove\]", "quirk_remove", i)]"
		if(current_quirk.configurable)
			quirk_header += " [bg_link("\[Configure\]", "quirk_config", i)]<br>[current_quirk.config_summary()]"
		var/list/quirk_lines = list()
		if(current_quirk.desc)
			quirk_lines += current_quirk.desc
		var/trait_details = get_trait_details_html(current_quirk)
		if(trait_details)
			quirk_lines += trait_details
		if(current_quirk.warning_text)
			quirk_lines += "<font color='#f44336'>[current_quirk.warning_text]</font>"
		html += pref_box(quirk_header, null, quirk_lines.Join("<br>"), current_quirk.name)
	html += pref_line(list(bg_link("Add Quirk", "quirk_add")))
	html += "<div class='lab'>恶习</div>"
	var/vice_count = 0
	for(var/i in 1 to VICE_SLOTS)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice)
			vice_count++
			var/vice_header = "<b>[vice.name]</b> (+[vice.point_value]) [bg_link("\[Remove\]", "vice_remove", i)]"
			if(vice.configurable)
				vice_header += " [bg_link("\[Configure\]", "vice_config", i)]<br>[vice.config_summary()]"
			html += pref_box(vice_header, null, vice.desc, vice.name)
	if(vice_count < VICE_SLOTS)
		html += pref_line(list(bg_link("Add Vice", "vice_add")))
	return html

/datum/preferences/proc/get_virtue_html(label, datum/virtue/V, slot)
	var/html = "<b>[get_preferences_label_display(label)]：</b> [bg_link(V.name, "virtue", slot)]"
	if(!istype(V, /datum/virtue/none))
		html += " [bg_link("\[Clear\]", "virtue_clear", slot)]"
	if(V.configurable)
		html += " [bg_link("\[Configure\]", "virtue_config", slot)]<br>[V.config_summary()]"
	return pref_box(html, V.desc, get_trait_details_html(V), "[label]")

/datum/preferences/proc/get_trait_details_html(datum/customization_trait/T)
	var/list/lines = list()
	if(T.custom_text)
		lines += "<i>[T.custom_text]</i>"
	if(LAZYLEN(T.added_traits))
		lines += "<b>获得特质：</b> [T.added_traits.Join("、")]"
	var/list/skill_lines = list()
	for(var/skill in T.added_skills)
		if(islist(skill))
			var/list/skill_block = skill
			var/datum/skill/S = skill_block[1]
			skill_lines += "[initial(S.name)] +[skill_block[2]]（上限 [skill_block[3]]）"
		else
			var/datum/skill/S = skill
			skill_lines += "[initial(S.name)] +[T.added_skills[skill]]"
	if(length(skill_lines))
		lines += "<b>获得技能：</b> [skill_lines.Join("、")]"
	if(LAZYLEN(T.added_stashed_items))
		lines += "<b>藏匿物品：</b> [T.added_stashed_items.Join("、")]"
	return lines.Join("<br>")

/datum/preferences/proc/get_language_link(language_path, bg)
	if(!ispath(language_path, /datum/language))
		return bg_link("Select", bg)
	var/datum/language/L = language_path
	return bg_link(initial(L.name), bg)

/datum/preferences/proc/get_language_choices()
	var/list/choices = list("无" = "None")
	for(var/language in GLOB.selectable_languages)
		if(language in pref_species.languages)
			continue
		var/datum/language/a_language = language
		choices[initial(a_language.name)] = language
	return choices

/datum/preferences/proc/page_character_settings(mob/user)
	var/html = pref_line(list(pref_item("Unrevivable", pref_link(yes_no(dnr_pref), "dnr"))))
	html += pref_line(list(pref_item("Combat Music", pref_link(combat_music.shortname || combat_music.name || "INVALID", "combat_music"))))
	html += pref_line(list(pref_item("Map Preferences", pref_link(preferred_map || "No Preference", "preferred_map"))))
	html += pref_line(list(pref_item("Familiar Preferences", pref_link("Change", "familiar_prefs")), pref_item("Gnoll Preferences", pref_link("Change", "gnoll_prefs"))))
	return html

/datum/preferences/proc/page_voice(mob/user)
	if(!voice_pack)
		voice_pack = "Default"
	var/datum/bark/B = GLOB.bark_list[bark_id]
	var/bark_name = "INVALID"
	if(B)
		bark_name = initial(B.name)
	var/html = pref_line(list(pref_item("Voice", pref_link(voice_type, "voicetype")), pref_item("Voice Pack", pref_link(voice_pack, "voicepack"))))
	html += pref_line(list(pref_item("Voice Color", pref_link("Change", "voice")), pref_item("Voice Pitch", pref_link(voice_pitch, "voice_pitch"))))
	html += pref_line(list(pref_item("Accent", pref_link(char_accent, "char_accent"))))
	html += pref_line(list(pref_item("Speech Mannerism", pref_link(get_mannerism_display_name(char_mannerism), "char_mannerism"))))
	html += pref_line(list(pref_item("Vocal Bark", pref_link(bark_name, "barksound")), pref_link("<b>Preview Bark</b>", "barkpreview")))
	html += pref_line(list(pref_item("Vocal Bark Speed", pref_link(bark_speed, "barkspeed")), pref_item("Vocal Bark Pitch", pref_link(bark_pitch, "barkpitch")), pref_item("Vocal Bark Variance", pref_link(bark_variance, "barkvary"))))
	html += pref_line(list(pref_item("Vocal Bark Volume", pref_link(bark_volume, "barkvolume"))))
	return html

/datum/preferences/proc/page_features(mob/user)
	var/html = ""
	var/list/appearance_items = list()
	if(pref_species.use_skintones)
		appearance_items += pref_item(pref_species.skin_tone_wording, pref_link("Change", "s_tone"))
		if(pref_species.mutant_skin_option)
			appearance_items += pref_item("Mutant Skintone", pref_link(yes_no(mutant_skin), "mutant_skin"))
	appearance_items += pref_item("Sprite Scale", pref_link("[features["body_size"] * 100]%", "body_size"))
	html += pref_line(appearance_items)
	if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))
		html += pref_color_row("Mutant Color #1", features["mcolor"], "mutant_color")
		html += pref_color_row("Mutant Color #2", features["mcolor2"], "mutant_color2")
		html += pref_color_row("Mutant Color #3", features["mcolor3"], "mutant_color3")
	if(LAZYLEN(pref_species.allowed_taur_types))
		var/obj/item/bodypart/taur/T = taur_type
		var/taur_name = "None"
		if(ispath(T))
			taur_name = T::name
		html += pref_line(list(pref_item("Taur Body Type", pref_link(taur_name, "taur_type"))))
		html += pref_color_row("Taur Color", taur_color, "taur_color")
		html += pref_color_row("Taur Markings", taur_markings, "taur_markings")
		html += pref_color_row("Taur Tertiary", taur_tertiary, "taur_tertiary")
	html += pref_line(list(pref_item("Features", pref_link("Change", "customizers", "menu")), pref_item("Markings", pref_link("Change", "markings", "menu"))))
	html += pref_line(list(pref_item("Descriptors", pref_link("Change", "descriptors", "menu"))))
	html += pref_line(list(pref_item("Update feature colors with change", pref_link(yes_no(update_mutant_colors), "update_mutant_colors"))))
	return html

/datum/preferences/proc/flavor_text_label()
	if(length(flavortext) < MINIMUM_FLAVOR_TEXT)
		return "<font color='#802929'>外貌描述</font>"
	return "外貌描述"

/datum/preferences/proc/page_flavor_text()
	var/ooc_label = "场外备注"
	if(length(ooc_notes) < MINIMUM_OOC_NOTES)
		ooc_label = "<font color='#802929'>场外备注</font>"
	var/help = pref_link("(?)", "formathelp")
	var/html = pref_line(list(pref_item("角色画廊", pref_link("Change", "character_gallery", byond_link = TRUE))))
	displayed_gallery_headshot = character_gallery_headshot_thumbnail()
	html += "<div id='preferences_gallery_headshot'>[displayed_gallery_headshot]</div>"
	html += pref_line(list(pref_item("<span id='preferences_flavortext_label'>[flavor_text_label()]</span>", "[help] [pref_link("Change", "flavortext", byond_link = TRUE)]")))
	html += pref_line(list(pref_item("NSFW Flavortext", "[help] [pref_link("Change", "nsfwflavortext", byond_link = TRUE)]")))
	html += pref_line(list(pref_item(ooc_label, "[help] [pref_link("Change", "ooc_notes")]")))
	html += pref_line(list(pref_item("ERP Preferences", "[help] [pref_link("Change", "erpprefs")]")))
	html += pref_line(list(pref_item("Rumours & Noble Gossip", help), "[pref_link("Set Rumours", "rumour")] [pref_link("Set Gossip", "gossip")] [pref_link("<i>Preview</i>", "rumour_preview")]"))
	html += pref_line(list(pref_item("Song", ""), "[pref_link("Change URL", "ooc_extra")] [pref_link("Title", "change_title")] [pref_link("Artist", "change_artist")]"))
	html += pref_line(list(pref_link("<b>Preview Examine</b>", "ooc_preview")))
	return "<div class='cbox'>[html]</div>"

// this controls all the mechanical customization shit. Nasty nasty code!
// handles background options w bg_link
/datum/preferences/proc/process_background_link(mob/user, list/href_list)
	var/slot = text2num(href_list["slot"])
	switch(href_list["bg"])
		if("statpack")
			var/list/statpacks_available = list()
			for(var/path as anything in GLOB.statpacks)
				var/datum/statpack/SP = GLOB.statpacks[path]
				if(!SP.name)
					continue
				var/display_name = SP.name
				var/stats = SP.generate_modifier_string()
				if(stats)
					display_name = "[SP.name] [stats]"
				statpacks_available[display_name] = SP
			statpacks_available = sort_list(statpacks_available)
			var/choice = tgui_input_list(user, "选择你的属性组合：", "属性组合选择", statpacks_available)
			if(choice)
				var/datum/statpack/selected = statpacks_available[choice]
				statpack = selected
				to_chat(user, span_notice("已选择属性组合：[choice]。"))
				to_chat(user, "<span class='info'>[selected.description_string()]</span>")
		if("virtue")
			if(slot == 2 && !second_virtue_allowed())
				to_chat(user, span_warning("无法选择第二美德！"))
				return
			var/datum/virtue/other = virtuetwo
			if(slot == 2)
				other = virtue
			var/list/available = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if(!V.name)
					continue
				if(V.type in pref_species.restricted_virtues)
					continue
				if(other && V.type == other.type)
					continue
				if(check_pick_vice_conflict(V.type, TRUE, user))
					continue
				if(other && check_pick_virtue_conflict(V.type, other.type, TRUE, user))
					continue
				if(check_virtue_quirk_conflict(V.type, TRUE, user))
					continue
				available[V.name] = V
			available = sort_list(available)
			var/choice = tgui_input_list(user, "选择你的美德：", "美德选择", available)
			if(choice)
				var/datum/virtue/selected = available[choice]
				if(slot == 2)
					virtuetwo = new selected.type()
				else
					virtue = new selected.type()
				to_chat(user, span_notice("已选择美德：[selected.name]。"))
				to_chat(user, "<span class='info'>[selected.desc]</span>")
		if("virtue_config")
			var/datum/virtue/V = virtue
			if(slot == 2)
				V = virtuetwo
			if(V?.configurable)
				V.configure(user)
		if("virtue_clear")
			if(slot == 2)
				virtuetwo = GLOB.virtues[/datum/virtue/none]
			else
				virtue = GLOB.virtues[/datum/virtue/none]
		if("quirk_add")
			var/list/available = list()
			for(var/path as anything in GLOB.quirks)
				var/datum/quirk/Q = GLOB.quirks[path]
				if(!Q.name || istype(Q, /datum/quirk/none) || has_quirk(Q.type))
					continue
				if(Q.type in pref_species.restricted_quirks)
					continue
				if(length(Q.allowed_species) && !(pref_species.type in Q.allowed_species))
					continue
				if(check_quirk_virtue_conflict(Q.type, TRUE, user) || check_pick_vice_conflict(Q.type, TRUE, user) || check_pick_quirk_conflict(Q.type, TRUE, user))
					continue
				available["[Q.name]（[Q.point_cost] 点）"] = Q
			if(!length(available))
				to_chat(user, span_warning("没有可添加的怪癖——所有与你的美德和恶习不冲突的怪癖均已拥有。"))
				return
			available = sort_list(available)
			var/prompt_text = "选择要添加的怪癖（剩余 [get_quirk_points_remaining()] 点）"
			var/triumph_collateral = get_triumph_collateral()
			if(triumph_collateral)
				prompt_text += "\n（花费 [triumph_collateral] 凯旋点）"
			var/choice = tgui_input_list(user, prompt_text, "怪癖选择", available)
			if(choice)
				var/datum/quirk/selected = available[choice]
				if(has_quirk(selected.type))
					return
				quirks += new selected.type()
				to_chat(user, span_notice("已添加怪癖：[selected.name]。"))
		if("quirk_remove")
			if(slot && slot <= length(quirks))
				quirks.Cut(slot, slot + 1)
		// quirks run their own procs 4 this, it's Less hardcoded for quirk options
		if("quirk_config")
			if(slot && slot <= length(quirks))
				var/datum/quirk/Q = quirks[slot]
				if(Q.configurable)
					Q.configure(user)
		if("vice_add")
			var/list/current_types = list()
			for(var/i in 1 to VICE_SLOTS)
				var/datum/charflaw/existing_vice = vars["vice[i]"]
				if(existing_vice)
					current_types += existing_vice.type
			if((/datum/charflaw/noflaw in current_types) || (/datum/charflaw/randflaw in current_types))
				current_types = list()
			var/list/all_vices = GLOB.character_flaws.Copy()
			all_vices["无缺陷（-3 凯旋点）"] = /datum/charflaw/noflaw
			var/list/available = list()
			for(var/vice_name in all_vices)
				var/vice_type = all_vices[vice_name]
				if((vice_type in current_types) || check_vice_pick_conflict(vice_type) || check_vice_vice_conflict(vice_type, current_types))
					continue
				if(length(current_types) && (vice_type == /datum/charflaw/noflaw || vice_type == /datum/charflaw/randflaw))
					continue
				available[vice_name] = vice_type
			if(length(current_types) >= VICE_SLOTS || !length(available))
				to_chat(user, span_warning("没有可添加的恶习。"))
				return
			available = sort_list(available)
			var/choice = tgui_input_list(user, "选择要添加的恶习。", "恶习选择", available)
			if(choice)
				var/new_vice_type = available[choice]
				if(!length(current_types))
					for(var/i in 1 to VICE_SLOTS)
						vars["vice[i]"] = null
				for(var/i in 1 to VICE_SLOTS)
					if(!vars["vice[i]"])
						vars["vice[i]"] = new new_vice_type()
						break
				charflaw = null
				to_chat(user, span_notice("已添加恶习：[choice]。"))
		if("vice_config")
			if(slot && slot <= VICE_SLOTS)
				var/datum/charflaw/vice = vars["vice[slot]"]
				if(vice?.configurable)
					vice.configure(user)
		if("vice_remove")
			if(slot && slot <= VICE_SLOTS)
				for(var/i in slot to VICE_SLOTS - 1)
					vars["vice[i]"] = vars["vice[i + 1]"]
				vars["vice[VICE_SLOTS]"] = null
				if(!vice1)
					vice1 = new /datum/charflaw/noflaw()
				charflaw = null
		if("lang_free")
			var/list/choices = get_language_choices()
			var/chosen_language = tgui_input_list(user, "选择角色的额外语言：", "额外语言", choices)
			if(chosen_language)
				extra_language = choices[chosen_language] || "None"

// this shit sucks !
/datum/preferences/proc/get_customization_pick(typepath)
	if(!typepath)
		return null
	return GLOB.virtues[typepath] || GLOB.quirks[typepath]

/datum/preferences/proc/get_virtue_effective_types(virtue_typepath)
	var/list/types = list()
	if(!virtue_typepath)
		return types
	types += virtue_typepath
	if(ispath(virtue_typepath, /datum/virtue/pack))
		var/datum/virtue/pack/P = GLOB.virtues[virtue_typepath]
		if(P)
			types += P.granted_virtues
	return types

/datum/preferences/proc/check_pick_virtue_conflict(pick_type, existing_type, show_message = FALSE, mob/user = null)
	if(!pick_type || !existing_type)
		return FALSE
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	var/datum/customization_trait/existing = get_customization_pick(existing_type)
	if(!pick || !existing)
		return FALSE
	var/list/pick_effective = get_virtue_effective_types(pick_type)
	var/list/existing_effective = get_virtue_effective_types(existing_type)
	if(length(pick.incompatible_virtues))
		for(var/t in existing_effective)
			if(t in pick.incompatible_virtues)
				if(show_message && user)
					to_chat(user, span_warning("[pick.name]与[existing.name]冲突！"))
				return TRUE
	if(length(existing.incompatible_virtues))
		for(var/t in pick_effective)
			if(t in existing.incompatible_virtues)
				if(show_message && user)
					to_chat(user, span_warning("[pick.name]与[existing.name]冲突！"))
				return TRUE
	return FALSE

/datum/preferences/proc/check_pick_vice_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	if(!pick || !length(pick.incompatible_vices))
		return FALSE
	for(var/i = 1 to 6)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice && (vice.type in pick.incompatible_vices))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name]与恶习[vice.name]冲突！"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_pick_quirk_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	if(!pick)
		return FALSE
	for(var/datum/quirk/Q in quirks)
		if(!Q || Q.type == pick_type)
			continue
		if(length(pick.incompatible_quirks) && (Q.type in pick.incompatible_quirks))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name]与[Q.name]冲突！"))
			return TRUE
		if(length(Q.incompatible_quirks) && (pick_type in Q.incompatible_quirks))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name]与[Q.name]冲突！"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_vice_pick_conflict(vice_type, show_message = FALSE, mob/user = null)
	if(!vice_type)
		return FALSE
	var/list/held = list()
	if(virtue)
		held += virtue
	if(virtuetwo)
		held += virtuetwo
	held += quirks
	for(var/datum/customization_trait/pick in held)
		if(length(pick.incompatible_vices) && (vice_type in pick.incompatible_vices))
			if(show_message && user)
				var/datum/charflaw/vice = GLOB.charflaw_singletons[vice_type]
				to_chat(user, span_warning("[vice?.name || "此恶习"]与[pick.name]冲突！"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_quirk_virtue_conflict(quirk_type, show_message = FALSE, mob/user = null)
	for(var/datum/virtue/virt in list(virtue, virtuetwo))
		if(virt && check_pick_virtue_conflict(quirk_type, virt.type, show_message, user))
			return TRUE
	return FALSE

/datum/preferences/proc/check_virtue_quirk_conflict(virtue_type, show_message = FALSE, mob/user = null)
	for(var/datum/quirk/Q in quirks)
		if(Q && check_pick_virtue_conflict(virtue_type, Q.type, show_message, user))
			return TRUE
	return FALSE

/datum/preferences/proc/check_vice_vice_conflict(vice_type, list/selected_vices, show_message = FALSE, mob/user = null)
	var/datum/charflaw/vice = GLOB.charflaw_singletons[vice_type]
	for(var/other in selected_vices)
		if(vice && (other in vice.incompatible_vices))
			if(show_message && user)
				var/datum/charflaw/other_vice = GLOB.charflaw_singletons[other]
				to_chat(user, span_warning("恶习[vice.name]与恶习[other_vice?.name]冲突！"))
			return TRUE
	return FALSE
