GLOBAL_LIST_INIT(bark_list, init_bark_list())
GLOBAL_LIST_INIT(bark_random_list, init_random_bark_list())

/proc/init_bark_list()
	. = list()
	for(var/datum/bark/path as anything in subtypesof(/datum/bark))
		.[path::id] = path

/proc/init_random_bark_list()
	. = list()
	for(var/datum/bark/path as anything in subtypesof(/datum/bark))
		if(path::allow_random)
			.[path::id] = path

//Datums for barks and bark accessories
/datum/bark
	var/name = "默认"
	var/id = "Default"
	var/soundpath //Path for the actual sound file used for the bark

	// Pitch vars. The actual range for a bark is [(pitch - (maxvariance*0.5)) to (pitch + (maxvariance*0.5))]
	// Make absolutely sure to take variance into account when curating a sound for bark purposes.
	var/minpitch = BARK_DEFAULT_MINPITCH
	var/maxpitch = BARK_DEFAULT_MAXPITCH
	var/minvariance = BARK_DEFAULT_MINVARY
	var/maxvariance = BARK_DEFAULT_MAXVARY

	// Speed vars. Speed determines the number of characters required for each bark, with lower speeds being faster with higher bark density
	var/minspeed = BARK_DEFAULT_MINSPEED
	var/maxspeed = BARK_DEFAULT_MAXSPEED

	// Visibility vars. Regardless of what's set below, these can still be obtained via adminbus and genetics. Rule of fun.
	var/list/ckeys_allowed
	var/ignore = FALSE //Controls whether or not this can be chosen in chargen
	var/allow_random = FALSE //Allows chargen randomization to use this. This is mainly to restrict the pool to sounds that fit well for most characters

/datum/bark/mutedc2
	name = "闷弦（低音）"
	id = "mutedc2"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/guitar_crisis_muted/C2.ogg'
	allow_random = TRUE

/datum/bark/mutedc3
	name = "闷弦（中音）"
	id = "mutedc3"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/guitar_crisis_muted/C3.ogg'
	allow_random = TRUE

/datum/bark/mutedc4
	name = "闷弦（高音）"
	id = "mutedc4"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/guitar_crisis_muted/C4.ogg'
	allow_random = TRUE

/datum/bark/banjoc3
	name = "班卓琴（中音）"
	id = "banjoc3"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/banjo/Cn3.ogg'
	allow_random = TRUE

/datum/bark/banjoc4
	name = "班卓琴（高音）"
	id = "banjoc4"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/banjo/Cn4.ogg'
	allow_random = TRUE

/datum/bark/squeaky
	name = "吱吱声"
	id = "squeak"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/toysqueak1.ogg'
	maxspeed = 4

/datum/bark/chitter
	name = "喳喳声"
	id = "chitter"
	minspeed = 4 //Even with the sound being replaced with a unique, shorter sound, this is still a little too long for higher speeds
	soundpath = 'code/modules/blooper/voice/bloopers/chitter.ogg'

/datum/bark/bullet
	name = "风声"
	id = "bullet"
	maxpitch = 1.6
	soundpath = 'code/modules/blooper/voice/bloopers/bulletflyby.ogg'

/datum/bark/coggers
	name = "铜管声"
	id = "coggers"
	soundpath = 'code/modules/blooper/voice/bloopers/integration_cog_install.ogg'

/datum/bark/moff/short
	name = "蛾人吱叫"
	id = "moffsqueak"
	soundpath = 'code/modules/blooper/voice/bloopers/mothsqueak.ogg'
	allow_random = TRUE
	ignore = FALSE

/datum/bark/meow //Meow bark?
	name = "喵叫"
	id = "meow"
	allow_random = TRUE
	soundpath = 'code/modules/blooper/voice/bloopers/meow1.ogg'
	minspeed = 5
	maxspeed = 11

/datum/bark/chirp
	name = "啁啾"
	id = "chirp"
	allow_random = TRUE
	soundpath = 'code/modules/blooper/voice/bloopers/chirp.ogg'

/datum/bark/caw
	name = "鸦鸣"
	id = "caw"
	allow_random = TRUE
	soundpath = 'code/modules/blooper/voice/bloopers/caw.ogg'

//Undertale
/datum/bark/alphys
	name = "艾菲斯"
	id = "alphys"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_alphys.ogg'
	minvariance = 0

/datum/bark/asgore
	name = "艾斯戈尔"
	id = "asgore"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_asgore.ogg'
	minvariance = 0

/datum/bark/flowey
	name = "小花（普通）"
	id = "flowey1"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_flowey_1.ogg'
	minvariance = 0

/datum/bark/flowey/evil
	name = "小花（邪恶）"
	id = "flowey2"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_flowey_2.ogg'
	minvariance = 0

/datum/bark/papyrus
	name = "帕派瑞斯"
	id = "papyrus"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_papyrus.ogg'
	minvariance = 0

/datum/bark/ralsei
	name = "拉尔赛"
	id = "ralsei"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_ralsei.ogg'
	minvariance = 0

/datum/bark/sans //real
	name = "杉斯"
	id = "sans"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_sans.ogg'
	minvariance = 0

/datum/bark/toriel
	name = "托丽尔"
	id = "toriel"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_toriel.ogg'
	minvariance = 0
	maxpitch = BARK_DEFAULT_MAXPITCH*2

/datum/bark/undyne
	name = "安黛因"
	id = "undyne"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_undyne.ogg'
	minvariance = 0

/datum/bark/temmie
	name = "提米"
	id = "temmie"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_temmie.ogg'
	minvariance = 0

/datum/bark/susie
	name = "苏西"
	id = "susie"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_susie.ogg'
	minvariance = 0

/datum/bark/gaster
	name = "加斯特"
	id = "gaster"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_gaster_1.ogg'
	minvariance = 0

/datum/bark/gen_monster
	name = "通用怪物1"
	id = "gen_monster_1"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_monster1.ogg'
	minvariance = 0

/datum/bark/gen_monster/alt
	name = "通用怪物2"
	id = "gen_monster_2"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_monster2.ogg'
	minvariance = 0

/datum/bark/wilson
	name = "威尔逊"
	id = "wilson"
	soundpath = 'code/modules/blooper/voice/bloopers/dont_starve/wilson_blooper.ogg'

/datum/bark/wolfgang
	name = "沃尔夫冈"
	id = "wolfgang"
	soundpath = 'code/modules/blooper/voice/bloopers/dont_starve/wolfgang_blooper.ogg'
	minspeed = 4
	maxspeed = 10

/datum/bark/woodie
	name = "伍迪"
	id = "woodie"
	soundpath = 'code/modules/blooper/voice/bloopers/dont_starve/woodie_blooper.ogg'
	minspeed = 4
	maxspeed = 10

/datum/bark/wurt
	name = "沃特"
	id = "wurt"
	soundpath = 'code/modules/blooper/voice/bloopers/dont_starve/wurt_blooper.ogg'

/datum/bark/blub
	name = "咕噜"
	id = "blub"
	soundpath = 'goon/sound/blub.ogg'

/datum/bark/buwoo
	name = "呜咕"
	id = "buwoo"
	soundpath = 'goon/sound/buwoo.ogg'

/datum/bark/cow
	name = "牛鸣"
	id = "cow"
	soundpath = 'goon/sound/cow.ogg'

/datum/bark/lizard
	name = "蜥蜴"
	id = "lizard"
	soundpath = 'goon/sound/lizard.ogg'

/datum/bark/pug
	name = "巴哥犬"
	id = "pug"
	soundpath = 'goon/sound/pug.ogg'

/datum/bark/pugg
	name = "巴哥犬变体"
	id = "pugg"
	soundpath = 'goon/sound/pugg.ogg'

/datum/bark/roach //Turkish characters be like
	name = "蟑螂"
	id = "roach"
	soundpath = 'goon/sound/roach.ogg'

/datum/bark/skelly
	name = "小骷髅"
	id = "skelly"
	soundpath = 'goon/sound/skelly.ogg'

/datum/bark/speak
	name = "说话声1"
	id = "speak1"
	soundpath = 'goon/sound/speak_1.ogg'

/datum/bark/speak/alt1
	name = "说话声2"
	id = "speak2"
	soundpath = 'goon/sound/speak_2.ogg'

/datum/bark/speak/alt2
	name = "说话声3"
	id = "speak3"
	soundpath = 'goon/sound/speak_3.ogg'

/datum/bark/speak/alt3
	name = "说话声4"
	id = "speak4"
	soundpath = 'goon/sound/speak_4.ogg'

/datum/bark/chitter/alt
	name = "喳喳声变体"
	id = "chitter2"
	soundpath = 'code/modules/blooper/voice/bloopers/moth/mothchitter2.ogg'

// The Mayhem Special
/datum/bark/whistle
	name = "哨声1"
	id = "whistle1"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/birdwhistle.ogg'

/datum/bark/whistle/alt1
	name = "哨声2"
	id = "whistle2"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/birdwhistle2.ogg'

/datum/bark/caw/alt1
	name = "鸦鸣2"
	id = "caw2"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/caw.ogg'
	minspeed = 4
	maxspeed = 9

/datum/bark/caw/alt2
	name = "鸦鸣3"
	id = "caw3"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/caw2.ogg'
	minspeed = 3
	maxspeed = 9

/datum/bark/caw/alt3
	name = "鸦鸣4"
	id = "caw4"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/caw3.ogg'
	minspeed = 3
	maxspeed = 9

/datum/bark/ehh
	name = "呃声1"
	id = "ehh1"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh.ogg'
	minspeed = 3
	maxspeed = 9

/datum/bark/ehh/alt1
	name = "呃声2"
	id = "ehh2"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh2.ogg'

/datum/bark/ehh/alt2
	name = "呃声3"
	id = "ehh3"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh3.ogg'

/datum/bark/ehh/alt3
	name = "呃声4"
	id = "ehh4"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh4.ogg'
	minspeed = 3
	maxspeed = 9

/datum/bark/ehh/alt5
	name = "呃声5"
	id = "ehh5"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh5.ogg'

/datum/bark/ribbit
	name = "蛙鸣"
	id = "ribbit"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ribbit.ogg'

/datum/bark/hoot
	name = "鸮鸣"
	id = "hoot"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/hoot.ogg'
	minspeed = 4
	maxspeed = 9

/datum/bark/tweet
	name = "鸟鸣"
	id = "tweet"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/tweet.ogg'
	
/datum/bark/uhm
	name = "嗯声"
	id = "uhm"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/uhm.ogg'

/datum/bark/wurtesh
	name = "沃特声"
	id = "wurtesh"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/wurble1.ogg'

/datum/bark/chitter2
	name = "喳喳声2"
	id = "chitter2"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/chitter1.ogg'

/datum/bark/xenohiss
	name = "异形嘶声"
	id = "Xenohiss"
	soundpath = 'code/modules/blooper/voice/bloopers/Xenohiss.ogg'
	minspeed = 10
	maxspeed = 16
