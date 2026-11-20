/// The wax music device's OLDSCHOOL list, name to file. The dwarven music box plays one in place of
/// an upload for a listener who turned uploaded songs off
GLOBAL_LIST_INIT(oldschool_songs, list(
	"秋日航程" = 'sound/music/jukeboxes/oldschool/Autumn_Voyage.ogg',
	"号角" = 'sound/music/jukeboxes/oldschool/Fanfare.ogg',
	"伟业" = 'sound/music/jukeboxes/oldschool/Greatness.ogg',
	"中古" = 'sound/music/jukeboxes/oldschool/Medieval.ogg',
	"海上歌谣2" = 'sound/music/jukeboxes/oldschool/Sea_Shanty2.ogg',
	"光辉" = 'sound/music/jukeboxes/oldschool/Shine.ogg',
	"灵息" = 'sound/music/jukeboxes/oldschool/Spirit.ogg',
	"静夜" = 'sound/music/jukeboxes/oldschool/Still_Night.ogg',
	"远行" = 'sound/music/jukeboxes/oldschool/Venture.ogg',
	"往昔" = 'sound/music/jukeboxes/oldschool/Yesteryear.ogg'
))

/datum/looping_sound/music/musloop
	mid_sounds = list()
	mid_length = 2400
	volume = 70
	extra_range = 8
	/// Uses a sound token for native repeating playback and listener tracking
	use_sound_tokens = TRUE

/obj/structure/roguemachine/musicbox
	name = "蜡筒音乐机"
	desc = "一台为了记录布道而发明的奇妙装置。它如今为我们带来了来自异界的奇异音乐。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "music0"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	var/datum/looping_sound/music/musloop/soundloop
	/// Recording selected once in Initialize(). Must belong to a MUSIC_TAVCAT_* set
	var/list/init_curfile = list(
		'sound/music/jukeboxes/oldschool/Autumn_Voyage.ogg',
		'sound/music/jukeboxes/oldschool/Fanfare.ogg',
		'sound/music/jukeboxes/oldschool/Greatness.ogg',
		'sound/music/jukeboxes/oldschool/Medieval.ogg',
		'sound/music/jukeboxes/oldschool/Sea_Shanty2.ogg',
		'sound/music/jukeboxes/oldschool/Shine.ogg',
		'sound/music/jukeboxes/oldschool/Spirit.ogg',
		'sound/music/jukeboxes/oldschool/Still_Night.ogg',
		'sound/music/jukeboxes/oldschool/Venture.ogg',
		'sound/music/jukeboxes/oldschool/Yesteryear.ogg',
	)
	var/curfile // The current track that is playing right now
	var/playing = FALSE // If music is playing or not. playmusic() deals with this don't mess with it.
	var/curvol = 50 // The current volume at which audio is played. MAPPERS MAY TOUCH THIS.
	var/playuponspawn = FALSE // Does the music box start playing music when it first spawns in? MAPPERS MAY TOUCH THIS.
	var/list/static/songlist_otherworldly = list(
		"传闻" = 'sound/music/jukeboxes/otherworld/ac-ler.ogg',
		"摇篮曲地标" = 'sound/music/jukeboxes/otherworld/ac-lol.ogg',
		"献祭之水" = 'sound/music/jukeboxes/otherworld/acn-wos.ogg',
		"太阳风" = 'sound/music/jukeboxes/otherworld/av_solar.ogg',
		"巴尔萨泽" = 'sound/music/jukeboxes/otherworld/ac-balthasar.ogg',
		"死去的风车" = 'sound/music/jukeboxes/otherworld/dead_windmills.ogg',
		"天堂里的一切" = 'sound/music/jukeboxes/otherworld/in_heaven_eif.ogg',
		"爵士诺克" = 'sound/music/jukeboxes/otherworld/jazznocn.ogg',
		"维瓦拉露娜-达姆拉" = 'sound/music/jukeboxes/otherworld/vivalaluna-damla.ogg',
		"徒劳之影" = 'sound/music/jukeboxes/otherworld/fb-sofutile.ogg',
		"疑先生" = 'sound/music/jukeboxes/otherworld/mr_doubt.ogg'
	)
	var/list/static/songlist_generic = list(\
		"曲目一" = 'sound/music/jukeboxes/gen/tavern1.ogg',
		"曲目二" = 'sound/music/jukeboxes/gen/tavern2.ogg',
		"曲目三" = 'sound/music/jukeboxes/gen/tavern3.ogg'
	)

/obj/structure/roguemachine/musicbox/Initialize(mapload)
	. = ..()
	// Choose once per device. Changing the file during playback would restart the token
	curfile = pick(init_curfile)
	soundloop = new(src, FALSE)
	if(playuponspawn)
		start_playing()

/obj/structure/roguemachine/musicbox/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/structure/roguemachine/musicbox/update_icon()
	icon_state = "music[playing]"

/obj/structure/roguemachine/musicbox/proc/toggle_music()
	if(!playing)
		start_playing()
	else
		stop_playing()

/obj/structure/roguemachine/musicbox/proc/start_playing()
	playing = TRUE
	soundloop.set_mid_sounds(list(curfile))
	soundloop.volume = curvol
	soundloop.start()
	update_icon()

/obj/structure/roguemachine/musicbox/proc/stop_playing()
	playing = FALSE
	soundloop.stop()
	update_icon()

/obj/structure/roguemachine/musicbox/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	user.changeNext_move(CLICK_CD_INTENTCAP)

	var/button_selection = input(user, "我要按哪个按钮？", "[src]") as null | anything in list("停止/开始","更换曲目","调节音量")
	if(!Adjacent(user))
		return
	if(!button_selection)
		to_chat(user, span_info("我改变主意了……"))
		return
	user.visible_message(span_info("[user]按下了[src]上的一个按钮。"),span_info("我按下了[src]上的一个按钮。"))
	playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)

	if(button_selection=="停止/开始")
		toggle_music()

	if(button_selection=="更换曲目")
		var/songlists_selection = input(user, "选择哪一组曲目？", "[src]") as null | anything in list("异界", "通用", "旧式")
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user]按下了[src]上的一个按钮。"),span_info("我按下了[src]上的一个按钮。"))
		var/chosen_songlists_selection = null
		switch(songlists_selection)
			if("异界")
				chosen_songlists_selection = songlist_otherworldly
			if("通用")
				chosen_songlists_selection = songlist_generic
			if("旧式")
				chosen_songlists_selection = GLOB.oldschool_songs
		var/song_selection = input(user, "我要播放哪首曲子？", "\The [src]") as null | anything in chosen_songlists_selection
		if(!Adjacent(user))
			return
		if(!song_selection)
			to_chat(user, span_info("我改变主意了……"))
			return
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user]按下了[src]上的一个按钮。"),span_info("我按下了[src]上的一个按钮。"))
		curfile = chosen_songlists_selection[song_selection]
		stop_playing()
		start_playing()

	if(button_selection=="调节音量")
		var/volume_selection = input(user, "你想把音量调到多大？", "[src]（当前音量：[curvol]/[100]）") as num|null
		if(!Adjacent(user))
			return
		if(!volume_selection)
			to_chat(user, span_info("我改变主意了……"))
			return
		if(volume_selection == curvol)
			to_chat(user, span_info("旋钮本来就在这个音量上！"))
			return
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user]按下了[src]上的一个按钮。"),span_info("我按下了[src]上的一个按钮。"))
		volume_selection = clamp(volume_selection, 1, 100)
		if(curvol<volume_selection)
			to_chat(user, span_info("我把[src]调得更响了。"))
		else
			to_chat(user, span_info("我把[src]调得更轻了。"))
		curvol = volume_selection
		stop_playing()
		start_playing()

/obj/structure/roguemachine/musicbox/tavern
	init_curfile = list(
		'sound/music/jukeboxes/gen/tavern1.ogg',
		'sound/music/jukeboxes/gen/tavern2.ogg',
		'sound/music/jukeboxes/gen/tavern3.ogg',
		'sound/music/jukeboxes/otherworld/ac-lol.ogg',
		'sound/music/jukeboxes/otherworld/ac-balthasar.ogg',
		'sound/music/jukeboxes/otherworld/vivalaluna-damla.ogg',
	)
	curvol = 65
	playuponspawn = TRUE
/* The fuck is this
/obj/structure/roguemachine/musicbox/Initialize(mapload)
	. = ..()
	soundloop.extra_range = 12
	soundloop.falloff = 6
*/
