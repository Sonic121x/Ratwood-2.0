
/obj/structure/fluff/walldeco
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/decoration.dmi'
	anchored = TRUE
	density = FALSE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER+0.1

/obj/structure/fluff/walldeco/OnCrafted(dirin, user)
	pixel_x = 0
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32
	. = ..()

/obj/structure/fluff/walldeco/proc/get_attached_wall()
	return

/obj/structure/fluff/walldeco/wantedposter
	name = "匪徒告示"
	desc = "这里张贴着四处流窜的匪徒画像。看看这周有没有新的通缉吧……"
	icon_state = "wanted1"
	layer = BELOW_MOB_LAYER
	pixel_y = 32

/obj/structure/fluff/walldeco/wantedposter/r
	pixel_y = 0
	pixel_x = 32
/obj/structure/fluff/walldeco/wantedposter/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/fluff/walldeco/wantedposter/Initialize(mapload)
	. = ..()
	icon_state = "wanted[rand(1,3)]"
	dir = pick(GLOB.cardinals)

/obj/structure/fluff/walldeco/wantedposter/examine(mob/user)
	. = ..()
	if(user.Adjacent(src))
		if(SSrole_class_handler.bandits_in_round)
			. += span_bold("我看到这片区域最近有匪徒活动。")
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
		else
			. += span_bold("看起来最近没有匪徒活动的报告。")

/obj/structure/fluff/walldeco/innsign
	name = "招牌"
	desc = ""
	icon_state = "bar"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/steward
	name = "招牌"
	desc = ""
	icon_state = "steward"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/bsmith
	name = "招牌"
	desc = ""
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bsmith"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/goblet
	name = "招牌"
	desc = ""
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "goblet"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/flower
	name = "招牌"
	desc = ""
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "flower"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersign
	name = "招牌"
	desc = "理发外科医标志性的旋纹招牌。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersign"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersignreverse
	name = "招牌"
	desc = "理发外科医标志性的旋纹招牌。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersignflip"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/sparrowflag
	name = "麻雀旗"
	desc = ""
	icon_state = "sparrow"

/obj/structure/fluff/walldeco/xavo
	name = "Xavo战旗"
	desc = ""
	icon_state = "xavo"

/obj/structure/fluff/walldeco/serpflag
	name = "蛇纹旗"
	desc = ""
	icon_state = "serpent"

/obj/structure/fluff/walldeco/artificerflag
	name = "工匠公会"
	desc = ""
	icon_state = "artificer"

/obj/structure/fluff/walldeco/maidendrape
	name = "黑色帷幔"
	desc = "一幅垂挂的布幔。"
	icon_state = "black_drape"
	dir = SOUTH
	pixel_y = 32

/obj/structure/fluff/walldeco/wallshield
	name = ""
	desc = ""
	icon_state = "wallshield"

/obj/structure/fluff/walldeco/sign/merchantsign
	name = "商店招牌"
	icon_state = "shopsign_merchant_right"
	plane = -1
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/merchantsign/left
	icon_state = "shopsign_merchant_left"

/obj/structure/fluff/walldeco/psybanner
	name = "旗帜"
	icon_state = "Psybanner-PURPLE"

/obj/structure/fluff/walldeco/psybanner/red
	icon_state = "Psybanner-RED"

/obj/structure/fluff/walldeco/stone
	name = ""
	desc = ""
	icon_state = "walldec1"
	mouse_opacity = 0

/obj/structure/fluff/walldeco/stone/bronze
	color = "#ff9c1a"

/obj/structure/fluff/walldeco/church/line
	name = ""
	desc = ""
	icon_state = "churchslate"
	mouse_opacity = 0
	layer = ABOVE_NORMAL_TURF_LAYER+0.1
	plane = -8

/obj/structure/fluff/walldeco/stone/Initialize(mapload)
	icon_state = "walldec[rand(1,6)]"
	..()

/obj/structure/fluff/walldeco/maidensigil
	name = "石制纹章"
	desc = ""
	icon_state = "maidensigil"
	mouse_opacity = 0
	dir = SOUTH
	pixel_y = 32

/obj/structure/fluff/walldeco/maidensigil/r
	dir = WEST
	pixel_x = 16

/obj/structure/fluff/walldeco/bigpainting
	name = "绘画"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "sherwoods"
	pixel_y = 32
	pixel_x = -16

/obj/structure/fluff/walldeco/bigpainting/lake
	icon_state = "lake"

/obj/structure/fluff/walldeco/mona
	name = "绘画"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "mona"
	pixel_y = 32

/obj/structure/fluff/walldeco/chains
	name = "悬挂锁链"
	alpha = 180
	layer = 4.26
	icon_state = "chains1"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	can_buckle = 1
	buckle_lying = 0
	breakoutextra = 5 MINUTES
	buckleverb = "绑上"
	smeltresult = /obj/item/rope/chain

/obj/structure/fluff/walldeco/chains/Initialize(mapload)
	icon_state = "chains[rand(1,8)]"
	..()

/obj/structure/fluff/walldeco/customflag
	name = "谷地旗帜"
	desc = "一面旗帜在风中飘扬，展示着这座公国引以为傲的纹章配色。"
	icon_state = "wallflag"

/obj/structure/fluff/walldeco/customflag/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/structure/fluff/walldeco/customflag/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/fluff/walldeco/customflag/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "wallflag_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "wallflag_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)

/obj/structure/fluff/walldeco/customflag/rockhill
	name = "岩丘旗"

/obj/structure/fluff/walldeco/moon
	name = "旗帜"
	icon_state = "moon"

/obj/structure/fluff/walldeco/rpainting
	name = "绘画"
	icon_state = "painting_1"

/obj/structure/fluff/walldeco/rpainting/forest
	icon_state = "painting_2"

/obj/structure/fluff/walldeco/rpainting/crown
	icon_state = "painting_3"

/obj/structure/fluff/walldeco/med
	name = "图解"
	icon_state = "medposter"

/obj/structure/fluff/walldeco/med2
	name = "图解"
	icon_state = "medposter2"

/obj/structure/fluff/walldeco/med3
	name = "图解"
	icon_state = "medposter3"

/obj/structure/fluff/walldeco/med4
	name = "图解"
	icon_state = "medposter4"

/obj/structure/fluff/walldeco/med5
	name = "图解"
	icon_state = "medposter5"

/obj/structure/fluff/walldeco/med6
	name = "图解"
	icon_state = "medposter6"

/obj/structure/fluff/walldeco/alarm
	name = "低语警报器"
	icon_state = "alarm"
	desc = "一个安装在墙上的警报装置。"
	pixel_y = 32
	var/next_yap = 0
	var/onoff = 1 //Init on

/obj/structure/fluff/walldeco/alarm/attack_hand(mob/living/user)

	user.changeNext_move(CLICK_CD_MELEE)

	if(!(HAS_TRAIT(user, TRAIT_NOBLE)))
		playsound(src, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		say("把你的手从警报器上挪开，卑微生物！")
		return

	playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
	if(onoff == 0)
		onoff = 1
		icon_state = "alarm"
		say("警戒模式已重新启动。")
		next_yap = 0 //They won't believe us unless we yap again
		return
	if(onoff == 1)
		onoff = 0
		icon_state = "face"
		say("终于能稍作休息了。晚安。")
		return
	else //failsafe
		onoff = 1
		icon_state = "alarm"

/obj/structure/fluff/walldeco/alarm/Crossed(mob/living/user)

	if(onoff == 0)
		return

	if(next_yap > world.time) //Yap cooldown
		return

	if(ishuman(user)) //are we a person?
		var/mob/living/carbon/human/HU = user

		if(HU.anti_magic_check()) //are we shielded?
			return

		if(!(HU in SStreasury.bank_accounts)) //first off- do we not have an account? we'll ALWAYS scream if that's the case
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("安全区域发现未知人员，立刻止步！！")
			loud_message("[src]发出尖叫般的警报声", hearing_distance = 12)
			next_yap = world.time + 6 SECONDS
			return

		if(HAS_TRAIT(user, TRAIT_NOBLE))
			say("向您致意，[user.real_name]。尊贵静默期三十息，现已生效。")
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			next_yap = world.time + 30 SECONDS
			return

		if((HU in SStreasury.bank_accounts)) //do we not have an account?
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			say("已记录侍民[user.real_name]进入安全区域。")
			return

		else //?????
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("安全区域发现未授权人员，立刻止步！！")
			loud_message("[src]发出尖叫般的警报声", hearing_distance = 12)
			next_yap = world.time + 6 SECONDS

	else
		playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
		say("安全区域发现未知生物，立刻止步！！")
		loud_message("[src]发出尖叫般的警报声", hearing_distance = 12)
		next_yap = world.time + 6 SECONDS

/obj/structure/fluff/walldeco/vinez // overlay vines for more flexibile mapping
	icon_state = "vinez"

/obj/structure/fluff/walldeco/vinez/l
	pixel_x = -32

/obj/structure/fluff/walldeco/vinez/r
	pixel_x = 32

/obj/structure/fluff/walldeco/vinez/offset
	icon_state = "vinez"
	pixel_y = 32

/obj/structure/fluff/walldeco/vinez/blue
	icon_state = "vinez_blue"

/obj/structure/fluff/walldeco/vinez/red
	icon_state = "vinez_red"

/obj/structure/fluff/walldeco/bath // suggestive stonework
	icon_state = "bath1"
	pixel_x = -32
	alpha = 210

/obj/structure/fluff/walldeco/bath/two
	icon_state = "bath2"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/three
	icon_state = "bath3"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/four
	icon_state = "bath4"
	pixel_y = 32
	pixel_x = 0

/obj/structure/fluff/walldeco/bath/five
	icon_state = "bath5"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/six
	icon_state = "bath6"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/seven
	icon_state = "bath7"
	pixel_x = 32

/obj/structure/fluff/walldeco/bath/gents
	icon_state = "gents"
	pixel_x = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/bath/ladies
	icon_state = "ladies"
	pixel_x = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/bath/wallrope
	icon_state = "wallrope"
	layer = WALL_OBJ_LAYER+0.1
	pixel_x = 0
	pixel_y = 0
	color = "#d66262"

/obj/structure/fluff/walldeco/sign/saiga
	name = "醉羚招牌"
	icon_state = "shopsign_inn_saiga_right"
	plane = -1
	pixel_x = 3
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/saiga/left
	icon_state = "shopsign_inn_saiga_left"

/obj/structure/fluff/walldeco/sign/trophy
	name = "羚羊战利品"
	icon_state = "saiga_trophy"
	pixel_y = 32

/obj/effect/decal/shadow_floor
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shadow_floor"
	mouse_opacity = 0

/obj/effect/decal/shadow_floor/corner
	icon_state = "shad_floorcorn"


/obj/structure/fluff/walldeco/fakewall
	name = "墙……？"
	desc = "它看起来确实像一堵墙……"
	icon = 'icons/turf/walls/stone_wall.dmi'//change this
	icon_state = "stone"//change this
	density = FALSE
	opacity = TRUE
	max_integrity = 100

/obj/structure/fluff/walldeco/bogbanner
	name = "旗帜"
	desc = "一面垂挂在墙上的红色旗帜。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bogbanner-whole"
	layer = WALL_OBJ_LAYER+0.1

/obj/structure/fluff/walldeco/bogbanner/brown
	name = "旗帜"
	desc = "一面垂挂在墙上的红色旗帜。"
	icon_state = "bogbanner-brown"

/obj/structure/fluff/walldeco/bogbanner/zizo
	name = "亵渎旗帜"
	desc = "一面沾满血迹的旗帜，上面绘着亵渎的 Z 十字。"
	icon_state = "bogbanner-zizo"

/obj/structure/fluff/walldeco/bogbanner/bogguard
	name = "旗帜"
	desc = "一面破损的旗帜，上面绘着一条蛇。"
	icon_state = "bogbanner-snake"

/obj/structure/fluff/walldeco/bogbanner/bogguard/animated
	name = "旗帜"
	desc = "一面破损的旗帜，上面绘着一条蛇。"
	icon_state = "bogbanner-snake-anim"
