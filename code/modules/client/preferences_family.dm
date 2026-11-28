// a lot of this design is taken from char prefs rework
/datum/family_board_menu
	var/datum/preferences/prefs
	var/list/open_sections = list("Requests", "Character", "Matchmaking", "Board")
	var/request_cooldown = 0
	var/base = "?_src_=prefs;preference=family_board;act="

/datum/family_board_menu/New(datum/preferences/P)
	. = ..()
	prefs = P

// advertisement
/datum/family_board_menu/proc/person_box(list/person, key, label, text, actions)
	var/html = "<div class='box'><table width='100%'><tr>"
	if(person["headshot"])
		html += "<td width='72' valign='top'><img src='[html_encode(person["headshot"])]' width='64' height='64'></td>"
	html += "<td valign='top'><b>[person["name"]]</b> · [get_species_display_name(person["species"])]，代词：[get_character_identity_display(person["pronouns"])]<br>[label]<br>"
	if(text)
		html += "<i>[text]</i><br>"
	html += "<a href='[base]view;id=[SSfamilytree.Token(key)]'>查看角色</a> [actions]</td></tr></table></div>"
	return html

/datum/family_board_menu/proc/show(mob/user)
	var/list/me = SSfamilytree.PrefInfo(prefs)
	var/my_id = me["id"]
	var/my_ckey = me["ckey"]
	for(var/list/link in SSfamilytree.links.Copy())
		if((link[1] == my_id && link[4] != prefs.real_name) || (link[2] == my_id && link[5] != prefs.real_name))
			SSfamilytree.links -= list(link)
	var/list/ad = SSfamilytree.board[my_id]
	if(ad && ad["name"] != prefs.real_name)
		SSfamilytree.board -= my_id
		SSfamilytree.saved_ads -= my_id
		ad = null
	if(ad)
		for(var/key in me)
			ad[key] = me[key]

	var/requests_html = ""
	var/request_count = 0
	for(var/list/req in SSfamilytree.requests)
		if(req["to"] != my_id)
			continue
		request_count++
		var/rid = SSfamilytree.Token("[req["from"]]>[req["to"]]")
		requests_html += person_box(req["info"], "[req["from"]]>[req["to"]]", "回应你的招募，申请成为你的<b>[get_family_relation_display(req["relation"])]</b>", req["message"], "<a href='[base]accept;rid=[rid]'>接受</a> <a href='[base]decline;rid=[rid]'>拒绝</a> <a href='[base]block;rid=[rid]'>拒绝并屏蔽</a>")
	if(!request_count)
		requests_html = "暂无申请。"

	var/ad_html = "你还没有发布招募。<a href='[base]post'>发布招募</a>"
	if(ad)
		ad_html = person_box(ad, my_id, "正在寻找：<b>[format_family_relations(ad["relations"])]</b>", ad["blurb"], "<a href='[base]post'>编辑</a> <a href='[base]unpost'>撤下招募</a>")

	var/board_html = ""
	var/ad_count = 0
	for(var/ad_id in SSfamilytree.board)
		var/list/other = SSfamilytree.board[ad_id]
		if(other["ckey"] == my_ckey || SSfamilytree.Blocked(my_ckey, other["ckey"]) || !SSfamilytree.Compatible(me, other))
			continue
		var/list/valid_relations = list()
		for(var/option in other["relations"])
			if((option in SSfamilytree.relation_options) && SSfamilytree.AgeOK(option, other["age"], me["age"]))
				valid_relations += option
		if(!valid_relations.len)
			continue
		var/skip = FALSE
		var/requested = FALSE
		for(var/list/link in SSfamilytree.links)
			if((link[1] == my_id && link[2] == ad_id) || (link[2] == my_id && link[1] == ad_id))
				skip = TRUE
		if(skip)
			continue
		for(var/list/req in SSfamilytree.requests)
			if(req["from"] == my_id && req["to"] == ad_id)
				requested = TRUE
		var/actions = "<a href='[base]request;id=[SSfamilytree.Token(ad_id)]'>发送申请</a>"
		if(requested)
			actions = "已申请 <a href='[base]withdraw;rid=[SSfamilytree.Token("[my_id]>[ad_id]")]'>撤回申请</a>"
		ad_count++
		board_html += person_box(other, ad_id, "正在寻找：<b>[format_family_relations(valid_relations)]</b>", other["blurb"], actions)
	if(!ad_count)
		board_html = "目前没有符合条件的招募。"

	var/mode = "仅限所选种族"
	if(prefs.species_blacklist)
		mode = "排除所选种族"
	var/matching_html = pref_line_html("种族偏好", "<a href='[base]blacklist'>[mode]</a> <a href='[base]species'>编辑名单（[length(prefs.species_filter)]）</a>")
	var/random_state = "否"
	if(prefs.random_match_on)
		random_state = "是"
	matching_html += "<div class='r'><b>参与随机匹配？</b> <a href='[base]random_toggle'>[random_state]</a></div>"
	if(prefs.random_match_on)
		for(var/relation in SSfamilytree.relation_options)
			var/state = "否"
			if(relation in prefs.random_match)
				state = "是"
			matching_html += pref_line_html(get_family_relation_display(relation), "<a href='[base]random;relation=[relation]'>[state]</a>")
		if(("Spouse" in prefs.random_match) || ("Lover" in prefs.random_match))
			matching_html += pref_line_html("期望性别", "<a href='[base]gender'>[get_family_gender_display(prefs.gender_choice)]</a>")

	var/house_state = "否"
	if(prefs.take_house_name)
		house_state = "是"
	var/relations_html = ""
	for(var/list/link in SSfamilytree.links)
		if(link[1] != my_id && link[2] != my_id)
			continue
		var/other_name = link[5]
		if(link[2] == my_id)
			other_name = link[4]
		var/role = capitalize(link[3])
		if(link[3] == "parent" && link[1] == my_id)
			role = "Offspring"
		if(link[3] == "parent" && link[2] == my_id)
			role = "Parent"
		var/status = ""
		var/toggle = "停用"
		if(length(link) >= 6 && length(link[6]))
			status = "（已停用）"
			if(my_id in link[6])
				toggle = "启用"
		var/rid = SSfamilytree.Token("[link[1]]>[link[2]]")
		relations_html += "<b>[other_name]</b> · [get_family_relation_display(role)][status] <a href='[base]toggle_link;rid=[rid]'>[toggle]</a> <a href='[base]unlink;rid=[rid]'>解除关系</a><br>"
	if(!relations_html)
		relations_html = "尚未建立任何关系。"
	var/links_html = pref_line_html("随家族姓氏", "<a href='[base]house_name'>[house_state]</a>") + relations_html
	if(length(SSfamilytree.blocks[my_ckey]))
		links_html += "<br><a href='[base]unblock_all'>解除对所有玩家的屏蔽</a>"

	var/requests_label = "收到的申请"
	if(request_count)
		requests_label = "收到的申请（[request_count]）"
	var/list/sections = list("Requests" = requests_html, "Character" = ad_html, "Matchmaking" = matching_html, "Board" = board_html, "Relationships" = links_html)
	var/html = {"<style>
		body { font-size: 14px; }
		.r { line-height: 1.5; font-size: 14px; margin: 2px 0; }
		.lab { font-weight: bold; color: #c9a96e; margin: 4px 0 1px 2px; }
		.lab a { background: none; border-color: transparent; padding: 0; color: #c9a96e; }
		.cbox { border: 1px solid #7b5353; background: #00000033; padding: 3px 6px; margin: 0 0 6px 0; }
		.box { border: 1px solid #7b5353; background: #1a0707; padding: 3px 6px; margin: 3px 0; }
		.cbox a, .box a { background: none; border-color: transparent; padding: 0; margin: 0 8px 0 0; }
		</style><center><b>[prefs.real_name]</b></center><hr>"}
	for(var/section in sections)
		var/label = get_family_section_display(section)
		if(section == "Requests")
			label = requests_label
		var/arrow = "+"
		var/body = ""
		if(section in open_sections)
			arrow = "-"
			body = "<div class='cbox'>[sections[section]]</div>"
		html += "<div class='lab'><a href='[base]section;name=[url_encode(section)]'>[arrow] [label]</a></div>[body]"

	var/datum/browser/popup = new(user, "family_board", "<div align='center'>人际关系公告板</div>", 560, 700)
	popup.set_content(html)
	popup.open(FALSE)

/datum/family_board_menu/proc/pref_line_html(label, value)
	return "<div class='r'><b>[label]：</b> [value]</div>"

/datum/family_board_menu/proc/handle_topic(mob/user, list/href_list)
	var/act = href_list["act"]
	if(!act)
		return
	var/list/me = SSfamilytree.PrefInfo(prefs)
	var/my_id = me["id"]
	var/my_ckey = me["ckey"]
	var/rid = href_list["rid"]
	switch(act)
		if("section")
			if(href_list["name"] in open_sections)
				open_sections -= href_list["name"]
			else
				open_sections += href_list["name"]
			return
		// rlly fucky rlly fucky but I'll get yelled at if this breaks privacy
		if("view")
			var/list/profile
			if(href_list["id"] == SSfamilytree.Token(my_id))
				profile = me
			for(var/ad_id in SSfamilytree.board)
				if(SSfamilytree.Token(ad_id) == href_list["id"])
					profile = SSfamilytree.board[ad_id]
			for(var/list/req in SSfamilytree.requests)
				if(req["to"] == my_id && SSfamilytree.Token("[req["from"]]>[req["to"]]") == href_list["id"])
					profile = req["info"]
			if(!profile)
				return
			// whole ass flavor text
			var/datum/preferences/family_snapshot/snap = new
			snap.real_name = profile["name"]
			snap.headshot_link = profile["headshot"]
			snap.flavortext = profile["flavortext"]
			snap.nsfwflavortext = profile["nsfwflavortext"]
			snap.ooc_notes = profile["ooc_notes"]
			snap.erpprefs = profile["erpprefs"]
			snap.ooc_extra = profile["ooc_extra"]
			snap.ooc_extra_img = profile["ooc_extra_img"]
			snap.nsfw_ooc_extra_img = profile["nsfw_ooc_extra_img"]
			snap.song_artist = profile["song_artist"]
			snap.song_title = profile["song_title"]
			snap.img_gallery = profile["img_gallery"]
			snap.nsfw_img_gallery = profile["nsfw_img_gallery"]
			snap.headshot_zoom = profile["headshot_zoom"]
			snap.headshot_x = profile["headshot_x"]
			snap.headshot_y = profile["headshot_y"]
			snap.headshot_framed = profile["headshot_framed"]
			snap.image_backdrop = profile["image_backdrop"]
			snap.card_backgrounds = profile["card_backgrounds"]
			snap.art_view_settings = profile["art_view_settings"]
			var/datum/examine_panel/panel = new(user)
			panel.pref = snap
			panel.holder = user
			panel.viewing = user
			panel.previewing = "character"
			panel.ui_interact(user)
			return
		if("post")
			var/list/old_ad = SSfamilytree.board[my_id]
			var/list/old_relations = list()
			if(old_ad)
				old_relations = old_ad["relations"]
			var/list/relations = select_family_options(user, SSfamilytree.relation_options, old_relations)
			if(!relations)
				return
			var/old_blurb = ""
			if(old_ad)
				old_blurb = old_ad["blurb"]
			var/blurb = stripped_input(user, "有什么想补充的吗？（最多 300 个字符）", "人际关系", old_blurb, 300)
			if(blurb == null)
				return
			var/list/new_ad = me.Copy()
			new_ad["relations"] = relations
			new_ad["blurb"] = blurb
			for(var/old_id in SSfamilytree.board.Copy())
				var/list/other_ad = SSfamilytree.board[old_id]
				if(other_ad["ckey"] != my_ckey || old_id == my_id)
					continue
				SSfamilytree.board -= old_id
				for(var/list/req in SSfamilytree.requests.Copy())
					if(req["to"] == old_id)
						SSfamilytree.requests -= list(req)
			SSfamilytree.board[my_id] = new_ad
			SSfamilytree.saved_ads[my_id] = new_ad
		if("unpost")
			SSfamilytree.board -= my_id
			SSfamilytree.saved_ads -= my_id
			for(var/list/req in SSfamilytree.requests.Copy())
				if(req["to"] == my_id)
					SSfamilytree.requests -= list(req)
		if("request")
			if(world.time < request_cooldown)
				to_chat(user, span_warning("申请太频繁了！请再等 [round((request_cooldown - world.time) / 10)] 秒。"))
				return
			var/target_id
			for(var/ad_id in SSfamilytree.board)
				if(SSfamilytree.Token(ad_id) == href_list["id"])
					target_id = ad_id
			var/list/target = SSfamilytree.board[target_id]
			if(!target)
				to_chat(user, span_warning("这条招募已经撤下了。"))
				return
			if(target["ckey"] == my_ckey || SSfamilytree.Blocked(my_ckey, target["ckey"]) || !SSfamilytree.Compatible(me, target))
				to_chat(user, span_warning("你无法回应这条招募。"))
				return
			for(var/list/req in SSfamilytree.requests)
				if(req["from"] == my_id && req["to"] == target_id)
					return
			var/list/valid_relations = list()
			for(var/option in target["relations"])
				if((option in SSfamilytree.relation_options) && SSfamilytree.AgeOK(option, target["age"], me["age"]))
					valid_relations += option
			if(!valid_relations.len)
				to_chat(user, span_warning("你无法回应这条招募。"))
				return
			var/chosen_relation = valid_relations[1]
			if(valid_relations.len > 1)
				chosen_relation = select_family_option(user, valid_relations)
			if(!chosen_relation)
				return
			var/message = stripped_input(user, "申请时想说些什么？（最多 200 个字符）", "人际关系", "", 200)
			if(message == null)
				return
			request_cooldown = world.time + 30 SECONDS
			SSfamilytree.requests += list(list("from" = my_id, "to" = target_id, "relation" = chosen_relation, "message" = message, "info" = me))
			var/client/target_client = GLOB.directory[target["ckey"]]
			if(target_client)
				SEND_SOUND(target_client.mob, sound('sound/misc/notice (2).ogg'))
				to_chat(target_client, span_notice("你的角色[target["name"]]收到了一份关系申请！<a href='?_src_=prefs;preference=family_board'>查看人际关系公告板</a>"))
		if("withdraw")
			for(var/list/req in SSfamilytree.requests.Copy())
				if(req["from"] == my_id && SSfamilytree.Token("[req["from"]]>[req["to"]]") == rid)
					SSfamilytree.requests -= list(req)
		if("accept", "decline", "block")
			for(var/list/req in SSfamilytree.requests.Copy())
				if(req["to"] != my_id || SSfamilytree.Token("[req["from"]]>[req["to"]]") != rid)
					continue
				SSfamilytree.requests -= list(req)
				var/list/from = req["info"]
				if(act == "block")
					if(!SSfamilytree.blocks[my_ckey])
						SSfamilytree.blocks[my_ckey] = list()
					SSfamilytree.blocks[my_ckey] += from["ckey"]
					for(var/list/other_req in SSfamilytree.requests.Copy())
						if(other_req["to"] == my_id && other_req["info"]["ckey"] == from["ckey"])
							SSfamilytree.requests -= list(other_req)
				if(act == "accept")
					var/list/link = list(my_id, req["from"], "spouse", prefs.real_name, from["name"])
					if(req["relation"] == "Sibling")
						link[3] = "sibling"
					if(req["relation"] == "Lover" || req["relation"] == "Friend" || req["relation"] == "Cousin")
						link[3] = LOWER_TEXT(req["relation"])
					if(req["relation"] == "Offspring")
						link[3] = "parent"
					if(req["relation"] == "Parent")
						link = list(req["from"], my_id, "parent", from["name"], prefs.real_name)
					SSfamilytree.links += list(link)
					var/client/from_client = GLOB.directory[from["ckey"]]
					if(from_client)
						SEND_SOUND(from_client.mob, sound('sound/misc/notice (2).ogg'))
						to_chat(from_client, span_notice("[prefs.real_name]接受了[from["name"]]的关系申请。<a href='?_src_=prefs;preference=family_board'>查看人际关系公告板</a>"))
		if("unlink")
			for(var/list/link in SSfamilytree.links.Copy())
				if((link[1] == my_id || link[2] == my_id) && SSfamilytree.Token("[link[1]]>[link[2]]") == rid)
					SSfamilytree.links -= list(link)
					SSfamilytree.connected -= list(link)
					var/mob/living/carbon/human/first
					var/mob/living/carbon/human/second
					for(var/mob/living/carbon/human/H in GLOB.human_list)
						if(H.family_id == link[1])
							first = H
						if(H.family_id == link[2])
							second = H
					if(first?.family_member_datum && second?.family_member_datum)
						switch(link[3])
							if("spouse")
								first.family_member_datum.RemoveSpouse(second.family_member_datum, TRUE)
								first.spouse_mob = null
								second.spouse_mob = null
							if("sibling")
								first.family_member_datum.siblings.Remove(second.family_member_datum)
								second.family_member_datum.siblings.Remove(first.family_member_datum)
							if("parent")
								first.family_member_datum.RemoveChild(second.family_member_datum)
							if("lover", "friend", "cousin")
								first.family_member_datum.other_relations -= second.family_member_datum
								second.family_member_datum.other_relations -= first.family_member_datum
								if(first.family_member_datum.lover == second.family_member_datum)
									first.family_member_datum.lover = null
									second.family_member_datum.lover = null
		if("toggle_link")
			for(var/list/link in SSfamilytree.links)
				if((link[1] == my_id || link[2] == my_id) && SSfamilytree.Token("[link[1]]>[link[2]]") == rid)
					if(length(link) < 6)
						link += list(list())
					if(my_id in link[6])
						link[6] -= list(my_id)
					else
						link[6] += my_id
		if("unblock_all")
			SSfamilytree.blocks -= my_ckey
		if("house_name")
			prefs.take_house_name = !prefs.take_house_name
			save_matching()
			return
		if("random_toggle")
			prefs.random_match_on = !prefs.random_match_on
			save_matching()
			return
		if("random")
			var/relation = href_list["relation"]
			if(!(relation in SSfamilytree.relation_options))
				return
			if(relation in prefs.random_match)
				prefs.random_match -= relation
			else
				prefs.random_match += relation
			save_matching()
			return
		if("gender")
			if(prefs.pronouns == THEY_THEM || prefs.pronouns == THEY_THEM_F || prefs.pronouns == IT_ITS)
				to_chat(user, span_warning("使用中性代词的角色只能选择“不限性别”。"))
				prefs.gender_choice = ANY_GENDER
				return
			var/new_gender = select_family_option(user, list(ANY_GENDER, SAME_GENDER, DIFFERENT_GENDER), TRUE)
			if(new_gender)
				prefs.gender_choice = new_gender
				save_matching()
			return
		if("blacklist")
			prefs.species_blacklist = !prefs.species_blacklist
			save_matching()
			return
		if("species")
			var/list/chosen = select_family_options(user, get_selectable_species(), prefs.species_filter, TRUE)
			if(!isnull(chosen))
				prefs.species_filter = chosen
				save_matching()
			return
	SSfamilytree.SaveBoard()

// saves shit right to slot I THINK it's fine.
/datum/family_board_menu/proc/save_matching()
	if(!prefs.path || !fexists(prefs.path))
		return
	var/savefile/S = new /savefile(prefs.path)
	S.cd = "/"
	if(!("character[prefs.default_slot]" in S.dir))
		return
	S.cd = "/character[prefs.default_slot]"
	WRITE_FILE(S["random_match"], prefs.random_match)
	WRITE_FILE(S["random_match_on"], prefs.random_match_on)
	WRITE_FILE(S["take_house_name"], prefs.take_house_name)
	WRITE_FILE(S["gender_choice"], prefs.gender_choice)
	WRITE_FILE(S["species_filter"], prefs.species_filter)
	WRITE_FILE(S["species_blacklist"], prefs.species_blacklist)

/datum/preferences/family_snapshot/New()
	return
