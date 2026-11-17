/datum/origin
	var/name = null
	var/desc = ""
	var/short_desc
	var/origin_title = null
	var/region_title = null
	var/map_x = 0
	var/map_y = 0
	var/origin_language = null
	var/list/origin_traits
	var/list/hated_by
	var/prejudice_stress
	var/prejudice_examine

GLOBAL_LIST_INIT(origins, build_origins())

/proc/build_origins()
	. = list()
	for(var/type in subtypesof(/datum/origin))
		.[type] = new type()

/datum/origin/otava
	name = ORIGIN_OTAVA
	desc = "一片严寒无情的高山之地，据说是普赛顿信仰的发源地。正教审判庭以奥塔瓦旧王国的首都为据点开展活动。"
	short_desc = "一片严寒无情的高山之地，据说是普赛顿信仰的发源地。"
	origin_title = "Otava"
	origin_language = /datum/language/otavan
	origin_traits = list(TRAIT_COLD_RESISTANCE, TRAIT_SLOW_METABOLISM)
	hated_by = list(ORIGIN_GRENZELHOFT)
	prejudice_stress = /datum/stressevent/prejudice/otava
	prejudice_examine = span_red("道貌岸然的奥塔万人！呸！")
	map_x = 183
	map_y = 151

/datum/origin/zybantine
	name = ORIGIN_ZYBANTINE
	desc = "兹班图帝国横跨诸国，将格里莫里亚的众多沙漠纳入版图。帝国崇尚力量与财富；不过传言纷纷，\
	都说这个富丽堂皇的帝国靠不光彩的手段聚敛财富。"
	short_desc = "兹班图帝国横跨诸国，将格里莫里亚的众多沙漠纳入版图。"
	origin_title = "Zybantine"
	origin_language = /datum/language/celestial
	origin_traits = list(TRAIT_HEAT_RESISTANCE, TRAIT_WATCHFUL)
	map_x = 364
	map_y = 325

/datum/origin/naledi
	name = ORIGIN_NALEDI
	desc = "纳莱迪曾是繁荣的帝国，数百年来，当地人始终在岛上与恶魔——当地语言称作精怪——交战。他们的故土\
	先遭齐佐撕裂，约一百年前又在巴奥莎的升神中几乎毁灭。据说最初的魔法就诞生于此。"
	short_desc = "纳莱迪曾是繁荣的帝国，数百年来，当地人始终在岛上与恶魔——当地语言称作精怪——交战。"
	origin_title = "Naledi"
	origin_language = /datum/language/celestial
	origin_traits = list(TRAIT_HEAT_RESISTANCE, TRAIT_GOLD_AFFINITY)
	map_x = 514
	map_y = 242

/datum/origin/ferentia
	name = ORIGIN_FERENTIA
	desc = "位于格伦泽尔霍夫特与伊特鲁斯卡西海岸外的岛国。费伦提亚人勤劳肯干，在辛苦劳作一天之后，\
	便热衷饮酒欢庆。这个王国过去曾抵御奥塔瓦与格伦泽尔霍夫特，如今则充当两国之间的调停者。"
	short_desc = "位于格伦泽尔霍夫特与伊特鲁斯卡西海岸外的岛国。"
	origin_title = "Ferentia"
	origin_traits = list(TRAIT_LOCAL_KNOWLEDGE, TRAIT_WATERLOVING)
	map_x = 151
	map_y = 200

/datum/origin/underdark
	name = ORIGIN_UNDERDARK
	desc = "据说幽暗地域是一片遍布格里莫里亚地壳的巨大洞穴与隧道网络，是黑暗精灵与狗头人的家园，\
	神秘的弗卢维安城邦墨丘利安也坐落于此。幽暗地域的洞窟危机四伏，从酸液河流到食人蜘蛛无所不有；\
	甚至还有夸张的传闻声称，巨龙也潜伏在地下。"
	short_desc = "据说幽暗地域是一片遍布格里莫里亚地壳的巨大洞穴与隧道网络，是黑暗精灵、狗头人以及神秘弗卢维安城邦墨丘利安的家园。"
	origin_title = ORIGIN_UNDERDARK
	origin_traits = list(TRAIT_LIGHT_SENSITIVITY)
	prejudice_stress = /datum/stressevent/prejudice/underdark
	prejudice_examine = span_red("肮脏的地底居民！呸！")
	map_x = 120
	map_y = 344

/datum/origin/hammerhold
	name = ORIGIN_HAMMERHOLD
	desc = "铁锤堡半岛与群岛居住着众多族群：半岛上敬奉阿比索尔的维坦人、鲁-耶尔蒙的红发居民，以及昔日\
	四季教区诸岛上的人们。这里有白金矮人要塞、曾为北方十神信仰中心的辉煌大教堂遗址，以及各式\
	小王国与领主辖地；他们仅松散地服从维坦之主——持环者的意志。"
	short_desc = "铁锤堡半岛与群岛居住着众多族群，包括敬奉阿比索尔的维坦人、鲁-耶尔蒙的红发居民，以及昔日四季教区诸岛上的人们。"
	origin_title = "Hammerhold"
	origin_language = /datum/language/hammerholdian
	origin_traits = list(TRAIT_HEARTY_DRINKER, TRAIT_COLD_RESISTANCE)
	map_x = 90
	map_y = 132

/datum/origin/grenzelhoft
	name = ORIGIN_GRENZELHOFT
	desc = "格伦泽尔霍夫特帝国是十神教廷的所在地，这一教派是格里莫里亚最主要的十神信仰。无穷无尽的死灵大军肆虐\
	帝国，许多宏伟城市与工匠城镇已被遗弃，居民转赴海外或首都谋生。尽管如此，格伦泽尔霍夫特依然\
	屹立不倒。"
	short_desc = "格伦泽尔霍夫特帝国是十神教廷的所在地，这一教派是格里莫里亚最主要的十神信仰。"
	origin_title = "Grenzelhoft"
	origin_language = /datum/language/grenzelhoftian
	origin_traits = list(TRAIT_DEADITE_RESISTANCE, TRAIT_METICULOUS)
	hated_by = list(ORIGIN_OTAVA)
	prejudice_stress = /datum/stressevent/prejudice/grenzelhoft
	prejudice_examine = span_red("烦人的格伦泽尔霍夫特人！呸！")
	map_x = 283
	map_y = 188

/datum/origin/avar
	name = ORIGIN_AVAR
	desc = "阿瓦尔由北方雄伟山脉、起伏草原与绵延的茂密针叶林组成。这里坐落着\
	仅次于奥塔瓦的第二大普赛顿王国，拥有东方山地最精锐的武力，以及格里莫里亚族群与文化最为多元的人民。"
	short_desc = "阿瓦尔由北方雄伟山脉、起伏草原与绵延的茂密针叶林组成。"
	origin_title = "Avar"
	origin_language = /datum/language/aavnic
	origin_traits = list(TRAIT_STEPPE_RIDER, TRAIT_ANCESTOR_GUARDIAN)
	hated_by = list(ORIGIN_GRONN)
	prejudice_stress = /datum/stressevent/prejudice/avar
	prejudice_examine = span_red("毫无趣味的阿夫尼克人！呸！")
	map_x = 417
	map_y = 189

/datum/origin/gronn
	name = ORIGIN_GRONN
	desc = "格隆恩草原饱受鲜血与战火蹂躏；格拉加尔战帮摧残着当地人民，还争相征服南方的阿瓦尔。\
	然而草原尚未彻底沦陷，许多城镇与游牧家庭仍在掠夺者的征服下，于危机四伏的境地中勉强求生。"
	short_desc = "格隆恩草原饱受鲜血与战火蹂躏；格拉加尔战帮摧残着当地人民，还争相征服南方的阿瓦尔。"
	origin_title = "Gronn"
	origin_language = /datum/language/gronnic
	origin_traits = list(TRAIT_COLD_RESISTANCE, TRAIT_BATTLE_CRY)
	hated_by = list(ORIGIN_AVAR)
	prejudice_stress = /datum/stressevent/prejudice/gronn
	prejudice_examine = span_red("信奉异端的格隆恩人！呸！")
	map_x = 445
	map_y = 116

/datum/origin/etrusca
	name = ORIGIN_ETRUSCA
	desc = "一个主要由美丽群岛组成、阳光明媚的贸易国家。伊特鲁斯卡以武艺与烹饪传统为傲，格里莫里亚各地的人们\
	都努力学习这个商贸之国的牧牛骑手与决斗家的技艺。"
	short_desc = "一个主要由美丽群岛组成、阳光明媚的贸易国家。"
	origin_title = "Etrusca"
	origin_language = /datum/language/etruscan
	origin_traits = list(TRAIT_BLACKLEG, TRAIT_WATERLOVING)
	map_x = 266
	map_y = 277

/datum/origin/kazengun
	name = ORIGIN_KAZENGUN
	desc = "风郡并非一个国家，而是三个相持数百年的王朝：岛屿西部的风郡幕府、\
	东部的普伊-梅恩王朝，以及北部的信义氏族。西方人常前往风郡，归来后便讲述当地武士与怪物的故事，\
	其中大多夸张失实。诸王朝与西方世界之间隔着浩瀚大洋，因此风郡的进口货物格外昂贵。"
	short_desc = "风郡并非一个国家，而是三个相持数百年的王朝。"
	origin_title = "Kazengun"
	origin_language = /datum/language/kazengunese
	origin_traits = list(TRAIT_SOFT_FOOTED)
	map_x = 120
	map_y = 374

/datum/preferences/proc/open_origin_map(mob/user)
	var/html = build_origin_map_html()
	user << browse_rsc(file("html/rwmap1.png"), "rwmap1.png")
	user << browse(html, "window=origin_map;size=685x540")
	onclose(user, "origin_map", src)

/datum/preferences/proc/open_origin_info(mob/user, datum/origin/O)
	var/html = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'></head><body style='background:#1a1209;color:#e8dcc8;font-family:Georgia,serif;padding:10px;'>" // 自定义修改：声明国家详情页编码，防止中文被浏览器按本地编码解析
	html += "<center><b style='color:#e8c87a;font-size:18px;'>[O.name]</b></center><hr>[O.desc]<br><br>"
	if(length(O.origin_traits))
		html += "<b style='color:#e8c87a;'>出身特质：</b>"
		for(var/trait in O.origin_traits)
			html += "<details><summary><i><font color='#ccbb82'>[trait]</font></i></summary>"
			html += "<i><font color='#a3ffe0'>[GLOB.roguetraits[trait]]</font></i></details>"
	html += "<br><center>[O.name]是我的故乡吗？<br><a href='byond://?src=\ref[src];preference=origin_select;type=[url_encode("[O.type]")]'>确认</a> | <a href='byond://?src=\ref[src];preference=origin_cancel'>否认</a></center></body></html>"
	user << browse(html, "window=origin_info;size=400x450")

/datum/preferences/proc/build_origin_map_html()
	var/html = ""
	html += "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><style>" // 自定义修改：使用兼容内嵌浏览器的编码声明，防止国家地图中文乱码
	html += {"body{margin:0;padding:0;background:#1a1209;color:#e8dcc8;font-family:Georgia,serif;overflow:hidden;user-select:none;}"}
	html += {".map-wrap{position:relative;width:550px;height:400px;display:block;margin:0 auto;}"}
	html += {".map-wrap img{width:550px;height:400px;display:block;pointer-events:none;}"}
	html += {".pin{position:absolute;width:18px;height:18px;border-radius:50%;background:#8b1a1a;border:2px solid #e8c87a;cursor:pointer;transform:translate(-50%,-50%);transition:all 0.15s ease;z-index:10;}"}
	html += {".pin:hover,.pin.selected{background:#e8c87a;border-color:#fff;box-shadow:0 0 10px rgba(232,200,122,0.9);transform:translate(-50%,-50%) scale(1.3);z-index:20;}"}
	html += {".pin.selected{background:#c8a020;}"}
	html += {".tooltip{position:fixed;background:rgba(18,12,5,0.97);border:1px solid #8b6914;border-radius:4px;padding:10px 14px;max-width:240px;z-index:100;pointer-events:none;display:none;color:#e8dcc8;}"}
	html += {".tooltip b{color:#e8c87a;font-size:14px;}"}
	html += {".tooltip p{margin:4px 0 0 0;font-size:12px;line-height:1.4;}"}
	html += {".panel{width:512px;margin:0 auto;padding:6px 0;text-align:center;background:#1a1209;border-top:1px solid #4a3010;}"}
	html += {".panel b{color:#e8c87a;font-size:13px;}"}
	html += {"#selected-label{color:#c8a020;font-size:13px;margin-top:3px;}"}
	html += {".confirm-btn{display:inline-block;margin-top:6px;padding:5px 18px;background:#5a2800;border:1px solid #8b6914;color:#e8dcc8;font-family:Georgia,serif;font-size:13px;cursor:pointer;border-radius:2px;}"}
	html += {".confirm-btn:hover{background:#8b4010;border-color:#e8c87a;}"}
	html += "</style></head><body>"
	html += "<div class='map-wrap'>"
	html += "<img src='rwmap1.png' alt='拉特伍德地图'>"
	for(var/otype as anything in GLOB.origins)
		var/datum/origin/O = GLOB.origins[otype]
		var/sel_cls = (origin == O) ? " selected" : ""
		var/safe_name = replacetext(O.name, "'", "\\'")
		var/safe_desc = replacetext(O.short_desc, "'", "\\'")
		var/node_href = "byond://?src=\ref[src];preference=origin_view;type=[url_encode("[otype]")]"
		html += "<div class='pin[sel_cls]' style='left:[O.map_x]px;top:[O.map_y]px;' "
		html += "onclick=\"window.location.href='[node_href]'; return false;\" "
		html += "onmouseenter=\"showTip(event,'[safe_name]','[safe_desc]')\" "
		html += "onmouseleave=\"hideTip()\"></div>"
	html += "</div>"
	html += "<div class='panel'>"
	var/current_label = origin ? origin.name : "未选择"
	html += "<b>当前选择：[current_label]</b>"
	html += "</div>"
	html += "<div class='tooltip' id='tip'></div>"
	html += "<script>"
	html += {"function showTip(e, name, desc) {"}
	html += "  var t = document.getElementById('tip');"
	html += "  t.innerHTML = '<b>' + name + '</b>' + (desc ? '<p>' + desc + '</p>' : '');"
	html += "  t.style.left = '-9999px';"
	html += "  t.style.display = 'block';"
	html += "  var x = e.clientX + 14;"
	html += "  var y = e.clientY + 14;"
	html += "  var tw = t.offsetWidth;"
	html += "  var th = t.offsetHeight;"
	html += "  if (x + tw > window.innerWidth) x = e.clientX - tw - 14;"
	html += "  if (y + th > window.innerHeight) y = e.clientY - th - 14;"
	html += "  t.style.left = x + 'px';"
	html += "  t.style.top = y + 'px';"
	html += "}"
	html += {"function hideTip() { document.getElementById('tip').style.display='none'; }"}
	html += "</script></body></html>"
	return html
