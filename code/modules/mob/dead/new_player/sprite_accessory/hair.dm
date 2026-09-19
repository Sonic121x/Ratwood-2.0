/datum/sprite_accessory/hair
	abstract_type = /datum/sprite_accessory/hair
	color_key_name = "头发"
	layer = HAIR_LAYER

/datum/sprite_accessory/hair/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/hair/head
	abstract_type = /datum/sprite_accessory/hair/head
	icon = 'icons/mob/sprite_accessory/hair/human_hair.dmi'

/datum/sprite_accessory/hair/head/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEHAIR)

/datum/sprite_accessory/hair/head/bald
	name = "秃顶"
	icon_state = null

/datum/sprite_accessory/hair/head/shorthaireighties
	name = "80 年代发型"
	icon_state = "80s"

/datum/sprite_accessory/hair/head/shorthaireighties_alt
	name = "80 年代发型（变体）"
	icon_state = "80s_alt"

/datum/sprite_accessory/hair/head/afro
	name = "爆炸头"
	icon_state = "afro"

/datum/sprite_accessory/hair/head/afro2
	name = "爆炸头 2"
	icon_state = "afro2"

/datum/sprite_accessory/hair/head/afro_large
	name = "爆炸头（大）"
	icon_state = "afro-big"

/datum/sprite_accessory/hair/head/antenna
	name = "呆毛"
	icon_state = "antenna"

/datum/sprite_accessory/hair/head/balding
	name = "谢顶"
	icon_state = "balding"

/datum/sprite_accessory/hair/head/bangsdiagonal
	name = "刘海（斜分）"
	icon_state = "diagonalbangs"

/datum/sprite_accessory/hair/head/bedhead
	name = "乱发"
	icon_state = "bedhead"

/datum/sprite_accessory/hair/head/bedhead2
	name = "乱发 2"
	icon_state = "bedhead2"

/datum/sprite_accessory/hair/head/bedhead3
	name = "乱发 3"
	icon_state = "bedhead3"

/datum/sprite_accessory/hair/head/bedheadlong
	name = "乱发（长）"
	icon_state = "bedhead-long"

/datum/sprite_accessory/hair/head/bedheadlongest
	name = "乱发（超长）"
	icon_state = "bedhead-longest"

/datum/sprite_accessory/hair/head/badlycut
	name = "中长乱发"
	icon_state = "hair_verybadlycut"

/datum/sprite_accessory/hair/head/beehive
	name = "蜂巢头"
	icon_state = "beehive"

/datum/sprite_accessory/hair/head/beehive2
	name = "蜂巢头 2"
	icon_state = "beehive2"

/datum/sprite_accessory/hair/head/bob
	name = "波波头"
	icon_state = "bob"

/datum/sprite_accessory/hair/head/bob2
	name = "波波头 2"
	icon_state = "bob2"

/datum/sprite_accessory/hair/head/bob3
	name = "波波头 3"
	icon_state = "bob3"

/datum/sprite_accessory/hair/head/bob4
	name = "波波头 4"
	icon_state = "bob4"

/datum/sprite_accessory/hair/head/bobcurl
	name = "卷波波头"
	icon_state = "bobcurl"

/datum/sprite_accessory/hair/head/bob_mane
	name = "波波头（鬃毛）"
	icon_state = "bob_mane"

/datum/sprite_accessory/hair/head/boddicker
	name = "博迪克"
	icon_state = "boddicker"

/datum/sprite_accessory/hair/head/bowlcut
	name = "锅盖头"
	icon_state = "bowlcut"

/datum/sprite_accessory/hair/head/bowlcut2
	name = "锅盖头 2"
	icon_state = "bowlcut2"

/datum/sprite_accessory/hair/head/braid
	name = "辫子（及地）"
	icon_state = "braid"

/datum/sprite_accessory/hair/head/front_braid
	name = "前编辫"
	icon_state = "braid-front"

/datum/sprite_accessory/hair/head/not_floorlength_braid
	name = "辫子（高）"
	icon_state = "braid-high"

/datum/sprite_accessory/hair/head/lowbraid
	name = "辫子（低）"
	icon_state = "braid-low"

/datum/sprite_accessory/hair/head/shortbraid
	name = "辫子（短）"
	icon_state = "braid-short"

/datum/sprite_accessory/hair/head/braided
	name = "编辫"
	icon_state = "braided"

/datum/sprite_accessory/hair/head/braidtail
	name = "编尾"
	icon_state = "braided-tail"

/datum/sprite_accessory/hair/head/bun
	name = "丸子头"
	icon_state = "bun"

/datum/sprite_accessory/hair/head/bun2
	name = "丸子头 2"
	icon_state = "bun2"

/datum/sprite_accessory/hair/head/bun3
	name = "丸子头 3"
	icon_state = "bun3"

/datum/sprite_accessory/hair/head/lowbun
	name = "丸子头（低）"
	icon_state = "bun-low"

/datum/sprite_accessory/hair/head/largebun
	name = "丸子头（大）"
	icon_state = "bun-large"

/datum/sprite_accessory/hair/head/manbun
	name = "丸子头（男式）"
	icon_state = "bun-manbun"

/datum/sprite_accessory/hair/head/tightbun
	name = "丸子头（紧）"
	icon_state = "bun-tight"

/datum/sprite_accessory/hair/head/business
	name = "商务发型"
	icon_state = "business"

/datum/sprite_accessory/hair/head/business2
	name = "商务发型 2"
	icon_state = "business2"

/datum/sprite_accessory/hair/head/business3
	name = "商务发型 3"
	icon_state = "business3"

/datum/sprite_accessory/hair/head/business4
	name = "商务发型 4"
	icon_state = "business4"

/datum/sprite_accessory/hair/head/buzz
	name = "平头"
	icon_state = "buzzcut"

/datum/sprite_accessory/hair/head/cia
	name = "特工短发"
	icon_state = "cia"

/datum/sprite_accessory/hair/head/coffeehouse
	name = "咖啡馆"
	icon_state = "coffeehouse"

/datum/sprite_accessory/hair/head/combover
	name = "梳盖头"
	icon_state = "combover"

/datum/sprite_accessory/hair/head/comet
	name = "彗星"
	icon_state = "comet"

/datum/sprite_accessory/hair/head/cornrows1
	name = "玉米辫"
	icon_state = "cornrows"

/datum/sprite_accessory/hair/head/cornrows2
	name = "玉米辫 2"
	icon_state = "cornrows2"

/datum/sprite_accessory/hair/head/cornrowbraid
	name = "玉米辫（编辫）"
	icon_state = "cornrow-braid"

/datum/sprite_accessory/hair/head/cornrowbun
	name = "玉米辫丸子头"
	icon_state = "cornrow-bun"

/datum/sprite_accessory/hair/head/cornrowdualtail
	name = "玉米辫马尾"
	icon_state = "cornrow-tail"

/datum/sprite_accessory/hair/head/crew
	name = "板寸"
	icon_state = "crewcut"

/datum/sprite_accessory/hair/head/curls
	name = "卷发"
	icon_state = "curls"

/datum/sprite_accessory/hair/head/cut
	name = "修剪发型"
	icon_state = "cut"

/datum/sprite_accessory/hair/head/dandpompadour
	name = "纨绔飞机头"
	icon_state = "dandypompadour"

/datum/sprite_accessory/hair/head/dave
	name = "戴夫"
	icon_state = "dave"

/datum/sprite_accessory/hair/head/devillock
	name = "恶魔发绺"
	icon_state = "devillock"

/datum/sprite_accessory/hair/head/doublebun
	name = "双丸子头"
	icon_state = "doublebun"

/datum/sprite_accessory/hair/head/dreadlocks
	name = "脏辫"
	icon_state = "dreads"

/datum/sprite_accessory/hair/head/drillhair
	name = "钻卷"
	icon_state = "drillruru"

/datum/sprite_accessory/hair/head/drillhairextended
	name = "钻头卷（加长）"
	icon_state = "drillhairextended"

/datum/sprite_accessory/hair/head/emo
	name = "情绪风"
	icon_state = "emo"

/datum/sprite_accessory/hair/head/emo2
	name = "情绪风 2"
	icon_state = "emo2"

/datum/sprite_accessory/hair/head/emofringe
	name = "情绪风刘海"
	icon_state = "emofringe"

/datum/sprite_accessory/hair/head/longemo
	name = "情绪风长发"
	icon_state = "emolong"

/datum/sprite_accessory/hair/head/nofade
	name = "渐变（无）"
	icon_state = "fade-none"

/datum/sprite_accessory/hair/head/lowfade
	name = "渐变（低）"
	icon_state = "fade-low"

/datum/sprite_accessory/hair/head/medfade
	name = "渐变（中）"
	icon_state = "fade-medium"

/datum/sprite_accessory/hair/head/highfade
	name = "渐变（高）"
	icon_state = "fade-high"

/datum/sprite_accessory/hair/head/baldfade
	name = "渐变（秃）"
	icon_state = "fade-bald"

/datum/sprite_accessory/hair/head/father
	name = "父亲"
	icon_state = "father"

/datum/sprite_accessory/hair/head/feather
	name = "羽毛"
	icon_state = "feather"

/datum/sprite_accessory/hair/head/flair
	name = "风采"
	icon_state = "flair"

/datum/sprite_accessory/hair/head/flattop
	name = "平顶 / 军士"
	icon_state = "flattop"

/datum/sprite_accessory/hair/head/flattop_big
	name = "平顶（大）"
	icon_state = "flattop-big"

/datum/sprite_accessory/hair/head/flow_hair
	name = "飘逸发型"
	icon_state = "flow"

/datum/sprite_accessory/hair/head/gelled
	name = "背头"
	icon_state = "gelled"

/datum/sprite_accessory/hair/head/gentle
	name = "温婉"
	icon_state = "gentle"

/datum/sprite_accessory/hair/head/halfbang
	name = "半边刘海"
	icon_state = "halfbang"

/datum/sprite_accessory/hair/head/halfbang2
	name = "半边刘海 2"
	icon_state = "halfbang2"

/datum/sprite_accessory/hair/head/halfshaved
	name = "半边剃"
	icon_state = "halfshaved"

/datum/sprite_accessory/hair/head/hedgehog
	name = "刺猬头"
	icon_state = "hedgehog"

/datum/sprite_accessory/hair/head/himecut
	name = "姬发式"
	icon_state = "himecut"

/datum/sprite_accessory/hair/head/himecut2
	name = "姬发式 2"
	icon_state = "himecut2"

/datum/sprite_accessory/hair/head/shorthime
	name = "姬发式（短）"
	icon_state = "shorthime"

/datum/sprite_accessory/hair/head/himeup
	name = "姬发盘发"
	icon_state = "himeup"

/datum/sprite_accessory/hair/head/hitop
	name = "高顶"
	icon_state = "hitop"

/datum/sprite_accessory/hair/head/jade
	name = "翡翠"
	icon_state = "jade"

/datum/sprite_accessory/hair/head/jensen
	name = "詹森发型"
	icon_state = "jensen"

/datum/sprite_accessory/hair/head/joestar
	name = "乔斯达"
	icon_state = "joestar"

/datum/sprite_accessory/hair/head/keanu
	name = "基努发型"
	icon_state = "keanu"

/datum/sprite_accessory/hair/head/kusangi
	name = "草薙发型"
	icon_state = "kusanagi"

/datum/sprite_accessory/hair/head/long
	name = "长发 1"
	icon_state = "long"

/datum/sprite_accessory/hair/head/long2
	name = "长发 2"
	icon_state = "long2"

/datum/sprite_accessory/hair/head/long3
	name = "长发 3"
	icon_state = "long3"

/datum/sprite_accessory/hair/head/long_over_eye
	name = "遮眼长发"
	icon_state = "longovereye"

/datum/sprite_accessory/hair/head/longbangs
	name = "长刘海"
	icon_state = "lbangs"

/datum/sprite_accessory/hair/head/longfringe
	name = "长额发"
	icon_state = "longfringe"

/datum/sprite_accessory/hair/head/sidepartlongalt
	name = "长侧分"
	icon_state = "longsidepart"

/datum/sprite_accessory/hair/head/lizbeth
	name = "莉兹贝丝"
	icon_state = "lizbeth"

/datum/sprite_accessory/hair/head/mediumbraid
	name = "中长辫"
	icon_state = "mediumbraid"

/datum/sprite_accessory/hair/head/megaeyebrows
	name = "粗眉"
	icon_state = "megaeyebrows"

/datum/sprite_accessory/hair/head/messy
	name = "凌乱"
	icon_state = "messy"

/datum/sprite_accessory/hair/head/modern
	name = "摩登"
	icon_state = "modern"

/datum/sprite_accessory/hair/head/modern2
	name = "摩登（新款）"
	icon_state = "modern2"


/datum/sprite_accessory/hair/head/mohawk
	name = "莫西干"
	icon_state = "mohawk"

/datum/sprite_accessory/hair/head/reversemohawk
	name = "莫西干（反）"
	icon_state = "mohawk-reverse"

/datum/sprite_accessory/hair/head/shavedmohawk
	name = "莫西干（剃）"
	icon_state = "mohawk-shaved"

/datum/sprite_accessory/hair/head/unshavenmohawk
	name = "莫西干（大）"
	icon_state = "mohawk-unshaven"

/datum/sprite_accessory/hair/head/mulder
	name = "穆德"
	icon_state = "mulder"

/datum/sprite_accessory/hair/head/nitori
	name = "尼托莉"
	icon_state = "nitori"

/datum/sprite_accessory/hair/head/odango
	name = "团子头"
	icon_state = "odango"

/datum/sprite_accessory/hair/head/ombre
	name = "渐变染"
	icon_state = "ombre"

/datum/sprite_accessory/hair/head/oneshoulder
	name = "单肩"
	icon_state = "oneshoulder"

/datum/sprite_accessory/hair/head/over_eye
	name = "遮眼"
	icon_state = "shortovereye"

/datum/sprite_accessory/hair/head/oxton
	name = "奥克斯顿"
	icon_state = "oxton"

/datum/sprite_accessory/hair/head/parted
	name = "中分"
	icon_state = "parted"

/datum/sprite_accessory/hair/head/partedside
	name = "中分（侧）"
	icon_state = "part"

/datum/sprite_accessory/hair/head/pigtails
	name = "双辫"
	icon_state = "pigtails"

/datum/sprite_accessory/hair/head/pigtails2
	name = "双辫 2"
	icon_state = "pigtails2"

/datum/sprite_accessory/hair/head/pigtails3
	name = "双辫 3"
	icon_state = "pigtails3"

/datum/sprite_accessory/hair/head/kagami
	name = "双辫（镜）"
	icon_state = "pigtails-kagami"

/datum/sprite_accessory/hair/head/pixie
	name = "精灵短发"
	icon_state = "pixie"

/datum/sprite_accessory/hair/head/pompadour
	name = "飞机头"
	icon_state = "pompadour"

/datum/sprite_accessory/hair/head/bigpompadour
	name = "飞机头（大）"
	icon_state = "pompadour-big"

/datum/sprite_accessory/hair/head/ponytail1
	name = "马尾辫"
	icon_state = "ponytail"

/datum/sprite_accessory/hair/head/ponytail2
	name = "马尾辫 2"
	icon_state = "ponytail2"

/datum/sprite_accessory/hair/head/ponytail3
	name = "马尾辫 3"
	icon_state = "ponytail3"

/datum/sprite_accessory/hair/head/ponytail4
	name = "马尾辫 4"
	icon_state = "ponytail4"

/datum/sprite_accessory/hair/head/ponytail5
	name = "马尾辫 5"
	icon_state = "ponytail5"

/datum/sprite_accessory/hair/head/ponytail6
	name = "马尾辫 6"
	icon_state = "ponytail6"

/datum/sprite_accessory/hair/head/ponytail7
	name = "马尾辫 7"
	icon_state = "ponytail7"

/datum/sprite_accessory/hair/head/highponytail
	name = "马尾辫（高）"
	icon_state = "ponytail-high"

/datum/sprite_accessory/hair/head/longponytail
	name = "马尾辫（长）"
	icon_state = "ponytail-longstraight"

/datum/sprite_accessory/hair/head/stail
	name = "马尾辫（短）"
	icon_state = "ponytail-short"

/datum/sprite_accessory/hair/head/countryponytail
	name = "马尾辫（乡野）"
	icon_state = "ponytail-country"

/datum/sprite_accessory/hair/head/countryponytailalt
	name = "马尾辫（乡野变体）"
	icon_state = "countryalt"

/datum/sprite_accessory/hair/head/ponytailwitcher
	name = "马尾辫（猎魔人）"
	icon_state = "ponytail_witcher"

/datum/sprite_accessory/hair/head/ponytailwitcheralt
	name = "马尾辫（猎魔人变体）"
	icon_state = "ponytail_witcheralt"

/datum/sprite_accessory/hair/head/fringetail
	name = "马尾辫（额发）"
	icon_state = "fringetail"

/datum/sprite_accessory/hair/head/sidetail
	name = "马尾辫（侧）"
	icon_state = "sidetail"

/datum/sprite_accessory/hair/head/sidetail2
	name = "马尾辫（侧）2"
	icon_state = "sidetail2"

/datum/sprite_accessory/hair/head/sidetail3
	name = "马尾辫（侧）3"
	icon_state = "sidetail3"

/datum/sprite_accessory/hair/head/sidetail4
	name = "马尾辫（侧）4"
	icon_state = "sidetail4"

/datum/sprite_accessory/hair/head/spikyponytail
	name = "马尾辫（尖）"
	icon_state = "spikyponytail"

/datum/sprite_accessory/hair/head/poofy
	name = "蓬松"
	icon_state = "poofy"

/datum/sprite_accessory/hair/head/quiff
	name = "后梳蓬发"
	icon_state = "quiff"

/datum/sprite_accessory/hair/head/ronin
	name = "浪人"
	icon_state = "ronin"

/datum/sprite_accessory/hair/head/shaved
	name = "剃光"
	icon_state = "shaved"

/datum/sprite_accessory/hair/head/shavedpart
	name = "剃光分线"
	icon_state = "shavedpart"

/datum/sprite_accessory/hair/head/shortbangs
	name = "短刘海"
	icon_state = "shortbangs"

/datum/sprite_accessory/hair/head/short
	name = "短发"
	icon_state = "short"

/datum/sprite_accessory/hair/head/shorthair2
	name = "短发 2"
	icon_state = "shorthair2"

/datum/sprite_accessory/hair/head/shorthair3
	name = "短发 3"
	icon_state = "shorthair3"

/datum/sprite_accessory/hair/head/shorthair7
	name = "短发 7"
	icon_state = "shorthairg"

/datum/sprite_accessory/hair/head/rosa
	name = "短发 罗莎"
	icon_state = "rosa"

/datum/sprite_accessory/hair/head/shoulderlength
	name = "齐肩发"
	icon_state = "shoulder"

/datum/sprite_accessory/hair/head/sidecut
	name = "侧剃"
	icon_state = "sidecut"

/datum/sprite_accessory/hair/head/simple
	name = "简约"
	icon_state = "simple"

/datum/sprite_accessory/hair/head/simpleshort
	name = "简约（短）"
	icon_state = "simple_short"

/datum/sprite_accessory/hair/head/simplelong
	name = "简约（长）"
	icon_state = "simple_long"

/datum/sprite_accessory/hair/head/skinhead
	name = "光头党"
	icon_state = "skinhead"

/datum/sprite_accessory/hair/head/protagonist
	name = "略长发"
	icon_state = "protagonist"

/datum/sprite_accessory/hair/head/spicy
	name = "火辣"
	icon_state = "spicy"

/datum/sprite_accessory/hair/head/spiky
	name = "刺发"
	icon_state = "spikey"

/datum/sprite_accessory/hair/head/spiky2
	name = "刺发 2"
	icon_state = "spiky"

/datum/sprite_accessory/hair/head/spiky3
	name = "刺发 3"
	icon_state = "spiky2"

/datum/sprite_accessory/hair/head/stacy
	name = "斯泰西"
	icon_state = "stacy"

/datum/sprite_accessory/hair/head/stacybun
	name = "斯泰西（丸子头）"
	icon_state = "stacy_bun"

/datum/sprite_accessory/hair/head/strict
	name = "严谨"
	icon_state = "strict"

/datum/sprite_accessory/hair/head/strictshort
	name = "严谨（短）"
	icon_state = "strict_short"

/datum/sprite_accessory/hair/head/strictlong
	name = "严谨（长）"
	icon_state = "strict_long"

/datum/sprite_accessory/hair/head/stacybun
	name = "斯泰西（丸子头）"
	icon_state = "stacy_bun"

/datum/sprite_accessory/hair/head/swept
	name = "后梳发型"
	icon_state = "swept"

/datum/sprite_accessory/hair/head/swept2
	name = "后梳发型 2"
	icon_state = "swept2"

/datum/sprite_accessory/hair/head/taro
	name = "太郎"
	icon_state = "taro"

/datum/sprite_accessory/hair/head/thinning
	name = "稀疏"
	icon_state = "thinning"

/datum/sprite_accessory/hair/head/thinningfront
	name = "稀疏（前）"
	icon_state = "thinningfront"

/datum/sprite_accessory/hair/head/thinningrear
	name = "稀疏（后）"
	icon_state = "thinningrear"

/datum/sprite_accessory/hair/head/topknot
	name = "顶髻"
	icon_state = "topknot"

/datum/sprite_accessory/hair/head/tressshoulder
	name = "齐肩长辫"
	icon_state = "tressshoulder"

/datum/sprite_accessory/hair/head/trimmed
	name = "修剪整齐"
	icon_state = "trimmed"

/datum/sprite_accessory/hair/head/trimflat
	name = "平剪"
	icon_state = "trimflat"

/datum/sprite_accessory/hair/head/twintails
	name = "双马尾"
	icon_state = "twintail"

/datum/sprite_accessory/hair/head/uncaring
	name = "随性"
	icon_state = "makoto"

/datum/sprite_accessory/hair/head/undercut
	name = "侧削"
	icon_state = "undercut"

/datum/sprite_accessory/hair/head/undercutleft
	name = "侧削（左）"
	icon_state = "undercutleft"

/datum/sprite_accessory/hair/head/undercutright
	name = "侧削（右）"
	icon_state = "undercutright"

/datum/sprite_accessory/hair/head/unkept
	name = "不修边幅"
	icon_state = "unkept"

/datum/sprite_accessory/hair/head/updo
	name = "盘发"
	icon_state = "updo"

/datum/sprite_accessory/hair/head/longer
	name = "超长发"
	icon_state = "vlong"

/datum/sprite_accessory/hair/head/longest
	name = "超长发 2"
	icon_state = "longest"

/datum/sprite_accessory/hair/head/longest2
	name = "超长遮眼"
	icon_state = "longest2"

/datum/sprite_accessory/hair/head/veryshortovereye
	name = "超短遮眼"
	icon_state = "veryshortovereyealternate"

/datum/sprite_accessory/hair/head/longestalt
	name = "超长带额发"
	icon_state = "vlongfringe"

/datum/sprite_accessory/hair/head/volaju
	name = "沃拉朱"
	icon_state = "volaju"

/datum/sprite_accessory/hair/head/wisp
	name = "缕发"
	icon_state = "wisp"

/datum/sprite_accessory/hair/head/wispy
	name = "飘渺"
	icon_state = "wispy"

/datum/sprite_accessory/hair/head/hyenamane
	name = "鬣狗鬃毛"
	icon_state = "hyenamane"

/datum/sprite_accessory/hair/head/hyenamaneshort
	name = "鬣狗鬃毛（短）"
	icon_state = "hyenamaneshort"

/datum/sprite_accessory/hair/head/forelock
	name = "额前发"
	icon_state = "forelock"

/datum/sprite_accessory/hair/head/pirate
	name = "海盗"
	icon_state = "pirate"

/datum/sprite_accessory/hair/head/shavedmohawk
	name = "剃式莫西干"
	icon_state = "shavedmohawk"

/datum/sprite_accessory/hair/head/baldfade
	name = "秃顶渐变"
	icon_state = "baldfade"

/datum/sprite_accessory/hair/head/rogue
	name = "游侠"
	icon_state = "rogue"

/datum/sprite_accessory/hair/head/romantic
	name = "浪漫"
	icon_state = "romantic"

/datum/sprite_accessory/hair/head/runt
	name = "矮小"
	icon_state = "runt"

/datum/sprite_accessory/hair/head/son
	name = "儿子"
	icon_state = "son"

/datum/sprite_accessory/hair/head/bog
	name = "沼泽"
	icon_state = "bog"

/datum/sprite_accessory/hair/head/son2
	name = "儿子（变体）"
	icon_state = "son2"

/datum/sprite_accessory/hair/head/long4
	name = "长发（第四款）"
	icon_state = "long4"

/datum/sprite_accessory/hair/head/amazon
	name = "亚马逊"
	icon_state = "amazon"

/datum/sprite_accessory/hair/head/barmaid
	name = "酒馆女侍"
	icon_state = "barmaid"

/datum/sprite_accessory/hair/head/bob_rt
	name = "波波头（游侠）"
	icon_state = "bob_rt"

/datum/sprite_accessory/hair/head/messy_rt
	name = "凌乱（游侠）"
	icon_state = "messy_rt"

/datum/sprite_accessory/hair/head/homely
	name = "质朴"
	icon_state = "homely"

/datum/sprite_accessory/hair/head/longtails
	name = "长尾"
	icon_state = "longtails"

/datum/sprite_accessory/hair/head/hime
	name = "姬"
	icon_state = "hime"

/datum/sprite_accessory/hair/head/manbun
	name = "男式丸子头"
	icon_state = "manbun"

/datum/sprite_accessory/hair/head/tied
	name = "束发"
	icon_state = "tied"

/datum/sprite_accessory/hair/head/tied2
	name = "束发（变体）"
	icon_state = "tied2"

/datum/sprite_accessory/hair/head/fatherless
	name = "无父"
	icon_state = "fatherless"

/datum/sprite_accessory/hair/head/fatherless2
	name = "无父（变体）"
	icon_state = "fatherless2"

/datum/sprite_accessory/hair/head/kepthair
	name = "保留发型"
	icon_state = "kepthair"

/datum/sprite_accessory/hair/head/singlebraid
	name = "单辫"
	icon_state = "singlebraid"

/datum/sprite_accessory/hair/head/gloomy
	name = "阴郁"
	icon_state = "gloomy"

/datum/sprite_accessory/hair/head/gloomylong
	name = "阴郁（长）"
	icon_state = "gloomylong"

/datum/sprite_accessory/hair/head/shortmessy
	name = "凌乱（短）"
	icon_state = "shortmessy"

/datum/sprite_accessory/hair/head/mediumessy
	name = "凌乱（中）"
	icon_state = "mediummessy"

/datum/sprite_accessory/hair/head/zone
	name = "区域"
	icon_state = "zone"

/datum/sprite_accessory/hair/head/inari
	name = "稻荷"
	icon_state = "inari"

/datum/sprite_accessory/hair/head/ziegler
	name = "齐格勒"
	icon_state = "ziegler"

/datum/sprite_accessory/hair/head/zoey
	name = "佐伊"
	icon_state = "zoey"

/datum/sprite_accessory/hair/head/gronnbraid
	name = "格罗恩辫"
	icon_state = "gronnbraid"

/datum/sprite_accessory/hair/head/grenzelcut
	name = "格伦泽尔发型"
	icon_state = "grenzelcut"

/datum/sprite_accessory/hair/head/fluffy
	name = "蓬松"
	icon_state = "fluffy"

/datum/sprite_accessory/hair/head/fluffyovereye
	name = "蓬松（遮眼）"
	icon_state = "fluffy_overeye"

/datum/sprite_accessory/hair/head/fluffyshort
	name = "蓬松（短）"
	icon_state = "fluffyshort"

/datum/sprite_accessory/hair/head/fluffylong
	name = "蓬松（长）"
	icon_state = "fluffylong"

/datum/sprite_accessory/hair/head/jay
	name = "杰伊"
	icon_state = "jay"

/datum/sprite_accessory/hair/head/hairfre
	name = "海尔弗雷"
	icon_state = "hairfre"

/datum/sprite_accessory/hair/head/dawn
	name = "黎明"
	icon_state = "dawn"

/datum/sprite_accessory/hair/head/morning
	name = "清晨"
	icon_state = "morning"

/datum/sprite_accessory/hair/head/kobeni_1
	name = "科贝妮"
	icon_state = "kobeni_1"

/datum/sprite_accessory/hair/head/kobeni_2
	name = "科贝妮（变体）"
	icon_state = "kobeni_2"

/datum/sprite_accessory/hair/head/kobeni_tail
	name = "科贝妮（马尾辫）"
	icon_state = "kobeni_tail"

/datum/sprite_accessory/hair/head/gloomy_short
	name = "阴郁（短）"
	icon_state = "gloomy_short"

/datum/sprite_accessory/hair/head/gloomy_medium
	name = "阴郁（中）"
	icon_state = "gloomy_medium"

/datum/sprite_accessory/hair/head/gloomy_long
	name = "阴郁（长）"
	icon_state = "gloomy_long"

/datum/sprite_accessory/hair/head/emo_long
	name = "情绪风长发（新款）"
	icon_state = "emo_long"

/datum/sprite_accessory/hair/head/twintail_floor
	name = "及地双马尾"
	icon_state = "twintail_floor"

/datum/sprite_accessory/hair/head/sideways_ponytail
	name = "侧向马尾辫"
	icon_state = "sideways_ponytail"

/datum/sprite_accessory/hair/head/ponytail8
	name = "马尾辫 8"
	icon_state = "ponytail8"

/datum/sprite_accessory/hair/head/dreadlocks_long
	name = "脏辫（长）"
	icon_state = "dreadlocks_long"

/datum/sprite_accessory/hair/head/rows1
	name = "排辫 1"
	icon_state = "rows1"

/datum/sprite_accessory/hair/head/rows2
	name = "排辫 2"
	icon_state = "rows2"

/datum/sprite_accessory/hair/head/rowbraid
	name = "排辫"
	icon_state = "rowbraid"

/datum/sprite_accessory/hair/head/rowdualtail
	name = "双排尾"
	icon_state = "rowdualtail"

/datum/sprite_accessory/hair/head/rowbun
	name = "排丸子头"
	icon_state = "rowbun"

/datum/sprite_accessory/hair/head/long_over_eye_alt
	name = "遮眼长发（变体）"
	icon_state = "long_over_eye_alt"

/datum/sprite_accessory/hair/head/diagonalbangs
	name = "斜刘海"
	icon_state = "diagonalbangs"

/datum/sprite_accessory/hair/head/sabitsuki
	name = "萨比茨基"
	icon_state = "sabitsuki"

/datum/sprite_accessory/hair/head/sabitsuki_ponytail
	name = "萨比茨基（马尾辫）"
	icon_state = "sabitsuki_ponytail"

/datum/sprite_accessory/hair/head/cotton
	name = "棉花"
	icon_state = "cotton"

/datum/sprite_accessory/hair/head/cottonalt
	name = "棉花（变体）"
	icon_state = "cottonalt"

/datum/sprite_accessory/hair/head/bushy
	name = "浓密"
	icon_state = "bushy"

/datum/sprite_accessory/hair/head/bushy_alt
	name = "浓密（变体）"
	icon_state = "bushy_alt"

/datum/sprite_accessory/hair/head/curtains
	name = "窗帘式"
	icon_state = "curtains"

/datum/sprite_accessory/hair/head/glamourh
	name = "魅惑"
	icon_state = "glamourh"

/datum/sprite_accessory/hair/head/emma
	name = "艾玛"
	icon_state = "emma"

/datum/sprite_accessory/hair/head/damsel
	name = "少女"
	icon_state = "damsel"

/datum/sprite_accessory/hair/head/wavylong
	name = "波浪长发"
	icon_state = "wavylong"

/datum/sprite_accessory/hair/head/wavyovereye
	name = "波浪遮眼"
	icon_state = "wavyovereye"

/datum/sprite_accessory/hair/head/straightovereye
	name = "直发遮眼"
	icon_state = "straightovereye"

/datum/sprite_accessory/hair/head/straightside
	name = "直发侧分"
	icon_state = "straightside"

/datum/sprite_accessory/hair/head/straightshort
	name = "直发短发"
	icon_state = "straightshort"

/datum/sprite_accessory/hair/head/straightlong
	name = "直发长发"
	icon_state = "straightlong"

/datum/sprite_accessory/hair/head/fluffball
	name = "毛球"
	icon_state = "fluffball"

/datum/sprite_accessory/hair/head/halfshave_long
	name = "半剃长发"
	icon_state = "halfshave_long"

/datum/sprite_accessory/hair/head/halfshave_long_alt
	name = "半剃长发（变体）"
	icon_state = "halfshave_long_alt"

/datum/sprite_accessory/hair/head/halfshave_messy
	name = "半剃凌乱"
	icon_state = "halfshave_messy"

/datum/sprite_accessory/hair/head/halfshave_messylong
	name = "半剃凌乱长发"
	icon_state = "halfshave_messylong"

/datum/sprite_accessory/hair/head/halfshave_messy_alt
	name = "半剃凌乱（变体）"
	icon_state = "halfshave_messy_alt"

/datum/sprite_accessory/hair/head/halfshave_messylong_alt
	name = "半剃凌乱长发（变体）"
	icon_state = "halfshave_messylong_alt"

/datum/sprite_accessory/hair/head/halfshave_glamorous
	name = "半剃魅惑"
	icon_state = "halfshave_glamorous"

/datum/sprite_accessory/hair/head/halfshave_glamorous_alt
	name = "半剃魅惑（变体）"
	icon_state = "halfshave_glamorous_alt"

/datum/sprite_accessory/hair/head/thicklong
	name = "浓密长发"
	icon_state = "thicklong"

/datum/sprite_accessory/hair/head/thickshort
	name = "浓密短发"
	icon_state = "thickshort"

/datum/sprite_accessory/hair/head/thickcurly
	name = "浓密卷发"
	icon_state = "thickcurly"

/datum/sprite_accessory/hair/head/thicklong_alt
	name = "浓密长发（变体）"
	icon_state = "thicklong_alt"

/datum/sprite_accessory/hair/head/baum
	name = "鲍姆"
	icon_state = "baum"

/datum/sprite_accessory/hair/head/mcsqueeb
	name = "老麦克斯基布"
	icon_state = "mcsqueeb"

/datum/sprite_accessory/hair/head/highlander
	name = "高地人"
	icon_state = "highlander"

/datum/sprite_accessory/hair/head/royalcurls
	name = "皇家卷发"
	icon_state = "royalcurls"

/datum/sprite_accessory/hair/head/dreadlocksmessy
	name = "脏辫凌乱"
	icon_state = "dreadlong"

/datum/sprite_accessory/hair/head/suave
	name = "油滑"
	icon_state = "suave"

/datum/sprite_accessory/hair/head/kusanagi_alt
	name = "草薙（变体）"
	icon_state = "kusanagi_alt"

/datum/sprite_accessory/hair/head/shorthair6
	name = "短发 6"
	icon_state = "shorthair_alt"

/datum/sprite_accessory/hair/head/bubblebraids
	name = "泡泡辫"
	icon_state = "bubblebraid"

/datum/sprite_accessory/hair/head/bubblebraids_v2
	name = "泡泡辫变体"
	icon_state = "bubblebraid_v2"

/datum/sprite_accessory/hair/head/heiress
	name = "女继承人"
	icon_state = "heiress"

/datum/sprite_accessory/hair/head/playful
	name = "顽皮"
	icon_state = "playful"

/datum/sprite_accessory/hair/head/adventurer
	name = "冒险者"
	icon_state = "adventurer"

/datum/sprite_accessory/hair/head/amazon_f
	name = "亚马逊（女）"
	icon_state = "amazon_f"

/datum/sprite_accessory/hair/head/archivist
	name = "档案员"
	icon_state = "archivist"

/datum/sprite_accessory/hair/head/barbarian_f
	name = "野蛮人（女）"
	icon_state = "barbarian_f"

/datum/sprite_accessory/hair/head/beartails_f
	name = "熊尾（女）"
	icon_state = "beartails_f"

/datum/sprite_accessory/hair/head/berserker
	name = "狂战士"
	icon_state = "berserker"

/datum/sprite_accessory/hair/head/bob_f
	name = "波波头（女）"
	icon_state = "bob_f"

/datum/sprite_accessory/hair/head/boss
	name = "老板"
	icon_state = "boss"

/datum/sprite_accessory/hair/head/buns_f
	name = "丸子头（女）"
	icon_state = "buns_f"

/datum/sprite_accessory/hair/head/cavehead
	name = "洞穴人"
	icon_state = "cavehead"

/datum/sprite_accessory/hair/head/conscript
	name = "新兵"
	icon_state = "conscript"

/datum/sprite_accessory/hair/head/courtier
	name = "朝臣"
	icon_state = "courtier"

/datum/sprite_accessory/hair/head/curly_f
	name = "卷发（女）"
	icon_state = "curly_f"

/datum/sprite_accessory/hair/head/darkknight
	name = "黑暗骑士"
	icon_state = "darkknight"

/datum/sprite_accessory/hair/head/dome
	name = "圆顶"
	icon_state = "dome"

/datum/sprite_accessory/hair/head/druid
	name = "德鲁伊"
	icon_state = "druid"

/datum/sprite_accessory/hair/head/empress_f
	name = "女皇（女）"
	icon_state = "empress_f"

/datum/sprite_accessory/hair/head/fancy_elf
	name = "华丽精灵"
	icon_state = "fancy_elf"

/datum/sprite_accessory/hair/head/fancy_elf_f
	name = "华丽精灵（女）"
	icon_state = "fancy_elf_f"

/datum/sprite_accessory/hair/head/forester
	name = "林务员"
	icon_state = "forester"

/datum/sprite_accessory/hair/head/foreigner
	name = "异乡人"
	icon_state = "foreigner"

/datum/sprite_accessory/hair/head/forged
	name = "锻造"
	icon_state = "forged"

/datum/sprite_accessory/hair/head/forsaken
	name = "被弃者"
	icon_state = "forsaken"

/datum/sprite_accessory/hair/head/grumpy_f
	name = "暴躁（女）"
	icon_state = "grumpy_f"

/datum/sprite_accessory/hair/head/gnomish_f
	name = "侏儒（女）"
	icon_state = "gnomish_f"

/datum/sprite_accessory/hair/head/graceful
	name = "优雅"
	icon_state = "graceful"

/datum/sprite_accessory/hair/head/heroic
	name = "英勇"
	icon_state = "heroic"

/datum/sprite_accessory/hair/head/hearth_f
	name = "炉火（女）"
	icon_state = "hearth_f"

/datum/sprite_accessory/hair/head/hunter
	name = "猎人"
	icon_state = "hunter"

/datum/sprite_accessory/hair/head/homely_f
	name = "质朴（女）"
	icon_state = "homely_f"

/datum/sprite_accessory/hair/head/junia_tief_f
	name = "朱妮娅 提夫（女）"
	icon_state = "junia_tief_f"

/datum/sprite_accessory/hair/head/lady_f
	name = "贵妇（女）"
	icon_state = "lady_f"

/datum/sprite_accessory/hair/head/landlord
	name = "地主"
	icon_state = "landlord"

/datum/sprite_accessory/hair/head/lion
	name = "狮子"
	icon_state = "lion"

/datum/sprite_accessory/hair/head/loosebraid_f
	name = "松散辫（女）"
	icon_state = "loosebraid_f"

/datum/sprite_accessory/hair/head/lover_tief_m
	name = "恋人 提夫（男）"
	icon_state = "lover_tief_m"

/datum/sprite_accessory/hair/head/maid_f
	name = "女仆（女）"
	icon_state = "maid_f"

/datum/sprite_accessory/hair/head/maiden_f
	name = "少女（女）"
	icon_state = "maiden_f"

/datum/sprite_accessory/hair/head/martial
	name = "武术"
	icon_state = "martial"

/datum/sprite_accessory/hair/head/majestic
	name = "威严"
	icon_state = "majestic"

/datum/sprite_accessory/hair/head/majestic_dwarf
	name = "威严矮人"
	icon_state = "majestic_dwarf"

/datum/sprite_accessory/hair/head/majestic_elf
	name = "威严精灵"
	icon_state = "majestic_elf"

/datum/sprite_accessory/hair/head/majestic_f
	name = "威严（女）"
	icon_state = "majestic_f"

/datum/sprite_accessory/hair/head/messy_f
	name = "凌乱（女）"
	icon_state = "messy_f"

/datum/sprite_accessory/hair/head/monk
	name = "僧侣"
	icon_state = "monk"

/datum/sprite_accessory/hair/head/miner
	name = "矿工"
	icon_state = "miner"

/datum/sprite_accessory/hair/head/mystery_f
	name = "神秘（女）"
	icon_state = "mystery_f"

/datum/sprite_accessory/hair/head/mysterious_elf
	name = "神秘精灵"
	icon_state = "mysterious_elf"

/datum/sprite_accessory/hair/head/nobility
	name = "贵族"
	icon_state = "nobility"

/datum/sprite_accessory/hair/head/noblesse_f
	name = "贵气（女）"
	icon_state = "noblesse_f"

/datum/sprite_accessory/hair/head/nomadic
	name = "游牧"
	icon_state = "nomadic"

/datum/sprite_accessory/hair/head/orc_f
	name = "兽人（女）"
	icon_state = "orc_f"

/datum/sprite_accessory/hair/head/performer_tief_f
	name = "表演者 提夫（女）"
	icon_state = "performer_tief_f"

/datum/sprite_accessory/hair/head/plain_f
	name = "朴素（女）"
	icon_state = "plain_f"

/datum/sprite_accessory/hair/head/princely
	name = "王子气"
	icon_state = "princely"

/datum/sprite_accessory/hair/head/pixie_f
	name = "精灵（女）"
	icon_state = "pixie_f"

/datum/sprite_accessory/hair/head/scribe
	name = "抄写员"
	icon_state = "scribe"

/datum/sprite_accessory/hair/head/soilbride_f
	name = "土壤新娘（女）"
	icon_state = "soilbride_f"

/datum/sprite_accessory/hair/head/shrine_f
	name = "神社（女）"
	icon_state = "shrine_f"

/datum/sprite_accessory/hair/head/southern
	name = "南方"
	icon_state = "southern"

/datum/sprite_accessory/hair/head/swain
	name = "情郎"
	icon_state = "swain"

/datum/sprite_accessory/hair/head/squire_f
	name = "侍从（女）"
	icon_state = "squire_f"

/datum/sprite_accessory/hair/head/squire
	name = "侍从"
	icon_state = "squire"

/datum/sprite_accessory/hair/head/tails_f
	name = "尾巴（女）"
	icon_state = "tails_f"

/datum/sprite_accessory/hair/head/troubadour
	name = "吟游诗人"
	icon_state = "troubadour"

/datum/sprite_accessory/hair/head/tiedlong
	name = "长束发"
	icon_state = "tiedlong"

/datum/sprite_accessory/hair/head/tsidecut
	name = "T 侧剃"
	icon_state = "tsidecut"

/datum/sprite_accessory/hair/head/tied_f
	name = "束发（女）"
	icon_state = "tied_f"

/datum/sprite_accessory/hair/head/tiedup_f
	name = "束起（女）"
	icon_state = "tiedup_f"

/datum/sprite_accessory/hair/head/updo_f
	name = "盘发（女）"
	icon_state = "updo_f"

/datum/sprite_accessory/hair/head/warrior
	name = "战士"
	icon_state = "warrior"

/datum/sprite_accessory/hair/head/wisp_f
	name = "缕发（女）"
	icon_state = "wisp_f"

/datum/sprite_accessory/hair/head/wildside
	name = "野性"
	icon_state = "wildside"

/datum/sprite_accessory/hair/head/woodsman_elf
	name = "伐木精灵"
	icon_state = "woodsman_elf"

/datum/sprite_accessory/hair/head/queenly_f
	name = "女王（女）"
	icon_state = "queenly_f"

/datum/sprite_accessory/hair/head/zybantu
	name = "兹班廷"
	icon_state = "zybantu"

/datum/sprite_accessory/hair/head/chair_ponytail6
	name = "椅式马尾 6"
	icon_state = "chair_ponytail6"

/datum/sprite_accessory/hair/head/chair_manbun
	name = "椅式男丸子头"
	icon_state = "chair_manbun"

/datum/sprite_accessory/hair/head/fatherless_elf_f
	name = "无父精灵（女）"
	icon_state = "fatherless_elf_f"

/datum/sprite_accessory/hair/head/samurai
	name = "武士"
	icon_state = "samurai"

/datum/sprite_accessory/hair/head/yakuza
	name = "黑道"
	icon_state = "yakuza"

/datum/sprite_accessory/hair/head/novice
	name = "新手"
	icon_state = "novice"

/datum/sprite_accessory/hair/head/steppeman
	name = "草原人"
	icon_state = "steppeman"

/datum/sprite_accessory/hair/head/bishonen
	name = "美少年"
	icon_state = "bishonen"

/datum/sprite_accessory/hair/head/emperor
	name = "皇帝"
	icon_state = "emperor"

/datum/sprite_accessory/hair/head/empress
	name = "女皇"
	icon_state = "empress"

/datum/sprite_accessory/hair/head/warlady
	name = "女军侯"
	icon_state = "warlady"

/datum/sprite_accessory/hair/head/waterfield
	name = "沃特菲尔德"
	icon_state = "waterfield"

/datum/sprite_accessory/hair/head/homewaifu
	name = "居家妻子"
	icon_state = "homewaifu"

/datum/sprite_accessory/hair/head/casual
	name = "休闲"
	icon_state = "casual"

/datum/sprite_accessory/hair/head/martyr
	name = "殉道者"
	icon_state = "martyr"

/datum/sprite_accessory/hair/head/hprotagonist
	name = "男主角"
	icon_state = "hprotagonist"

/datum/sprite_accessory/hair/head/alsoprotagonist
	name = "男配角"
	icon_state = "alsoprotagonist"

/datum/sprite_accessory/hair/head/dunes
	name = "沙丘"
	icon_state = "dunes"

/datum/sprite_accessory/hair/head/lakkaribun
	name = "拉卡里丸子头"
	icon_state = "lakkaribun"

/datum/sprite_accessory/hair/head/lakkaricut
	name = "拉卡里发型"
	icon_state = "lakkaricut"

/datum/sprite_accessory/hair/head/sandcrop
	name = "沙丘短发"
	icon_state = "sandcrop"

/datum/sprite_accessory/hair/head/steward
	name = "管家"
	icon_state = "steward"

/datum/sprite_accessory/hair/head/zaladin
	name = "扎拉丁"
	icon_state = "zaladin"

/datum/sprite_accessory/hair/head/tomboy
	name = "假小子"
	icon_state = "tomboy_f"

/datum/sprite_accessory/hair/head/vagabond
	name = "流浪者"
	icon_state = "vagabond"

/datum/sprite_accessory/hair/head/puffdouble
	name = "双泡芙"
	icon_state = "puffdouble"

/datum/sprite_accessory/hair/head/puffleft
	name = "左泡芙"
	icon_state = "puffleft"

/datum/sprite_accessory/hair/head/puffright
	name = "右泡芙"
	icon_state = "puffright"

/datum/sprite_accessory/hair/head/puffright
	name = "右泡芙"
	icon_state = "puffright"

/datum/sprite_accessory/hair/head/alchemist
	name = "炼金术士"
	icon_state = "alchemist"

/datum/sprite_accessory/hair/head/fortuneteller
	name = "占卜师"
	icon_state = "fortuneteller"

/datum/sprite_accessory/hair/head/kajam
	name = "卡贾姆"
	icon_state = "kajam"

/datum/sprite_accessory/hair/head/mermaid
	name = "美人鱼"
	icon_state = "mermaid"

/datum/sprite_accessory/hair/head/phoenix
	name = "凤凰"
	icon_state = "phoenix"

/datum/sprite_accessory/hair/head/phoenix_half_shaven
	name = "凤凰半剃"
	icon_state = "phoenix_half_shaven"

/datum/sprite_accessory/hair/head/shorthair4
	name = "短发 4"
	icon_state = "shorthair4"

/datum/sprite_accessory/hair/head/slightlymessy
	name = "略凌乱"
	icon_state = "slightlymessy"

/datum/sprite_accessory/hair/head/flatpressed
	name = "平压"
	icon_state = "flatpressed"

/datum/sprite_accessory/hair/head/unkempt_curls
	name = "蓬乱卷发"
	icon_state = "unkempt_curls"

/datum/sprite_accessory/hair/head/shrine_priestess
	name = "神社巫女"
	icon_state = "shrine_priestess"

/datum/sprite_accessory/hair/head/beachwave
	name = "海滩波浪"
	icon_state = "beachwave"

/datum/sprite_accessory/hair/head/wolfcut
	name = "狼尾剪"
	icon_state = "wolfcut"

/datum/sprite_accessory/hair/head/triplebuns
	name = "三丸子头"
	icon_state = "triplebuns"

/datum/sprite_accessory/hair/head/nest
	name = "鸟巢"
	icon_state = "nest"

/datum/sprite_accessory/hair/head/strand
	name = "发缕"
	icon_state = "strand"

/datum/sprite_accessory/hair/head/sodden
	name = "湿透"
	icon_state = "sodden"

/datum/sprite_accessory/hair/head/indigozap
	name = "鲁莽"
	icon_state = "indigo_zap"

/datum/sprite_accessory/hair/head/rainbowdash
	name = "忠诚"
	icon_state = "rainbow_dash"
	
/datum/sprite_accessory/hair/head/renard
	name = "勒纳尔"
	icon_state = "renard"

/datum/sprite_accessory/hair/head/willowtree
	name = "柳树"
	icon_state = "willowtree"

/datum/sprite_accessory/hair/head/nimue
	name = "妮缪"
	icon_state = "nimue"

/datum/sprite_accessory/hair/head/willow
	name = "柳"
	icon_state = "willow"

/datum/sprite_accessory/hair/head/aki
	name = "亚纪"
	icon_state = "aki"

/datum/sprite_accessory/hair/head/vulpkian
	abstract_type = /datum/sprite_accessory/hair/head/vulpkian
	icon = 'icons/mob/sprite_accessory/hair/vulpkian_hair.dmi'

/datum/sprite_accessory/hair/head/vulpkian/anita
	name = "维纳丁 阿妮塔"
	icon_state = "anita"

/datum/sprite_accessory/hair/head/vulpkian/jagged
	name = "维纳丁 锯齿"
	icon_state = "jagged"

/datum/sprite_accessory/hair/head/vulpkian/kajam1
	name = "维纳丁 卡贾姆 1"
	icon_state = "kajam1"

/datum/sprite_accessory/hair/head/vulpkian/kajam2
	name = "维纳丁 卡贾姆 2"
	icon_state = "kajam2"

/datum/sprite_accessory/hair/head/vulpkian/keid
	name = "维纳丁 凯德"
	icon_state = "keid"

/datum/sprite_accessory/hair/head/vulpkian/mizar
	name = "维纳丁 米扎尔"
	icon_state = "mizar"

/datum/sprite_accessory/hair/head/vulpkian/raine
	name = "维纳丁 蕾恩"
	icon_state = "raine"

/datum/sprite_accessory/hair/facial
	abstract_type = /datum/sprite_accessory/hair/facial
	icon = 'icons/mob/sprite_accessory/hair/human_facial_hair.dmi'

/datum/sprite_accessory/hair/facial/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEFACIALHAIR)

/datum/sprite_accessory/hair/facial/shaved
	name = "剃光"
	icon_state = null

/datum/sprite_accessory/hair/facial/abe
	name = "胡须（林肯）"
	icon_state = "abe"

/datum/sprite_accessory/hair/facial/brokenman
	name = "胡须（破碎之人）"
	icon_state = "brokenman"

/datum/sprite_accessory/hair/facial/chinstrap
	name = "胡须（下颌带）"
	icon_state = "chin"

/datum/sprite_accessory/hair/facial/dwarf
	name = "胡须（矮人）"
	icon_state = "dwarf"

/datum/sprite_accessory/hair/facial/fullbeard
	name = "胡须（全脸）"
	icon_state = "fullbeard"

/datum/sprite_accessory/hair/facial/croppedfullbeard
	name = "胡须（短全脸）"
	icon_state = "croppedfullbeard"

/datum/sprite_accessory/hair/facial/gt
	name = "胡须（山羊胡）"
	icon_state = "gt"

/datum/sprite_accessory/hair/facial/hip
	name = "胡须（潮人）"
	icon_state = "hip"

/datum/sprite_accessory/hair/facial/jensen
	name = "胡须（詹森）"
	icon_state = "jensen"

/datum/sprite_accessory/hair/facial/neckbeard
	name = "胡须（颈须）"
	icon_state = "neckbeard"

/datum/sprite_accessory/hair/facial/vlongbeard
	name = "胡须（超长）"
	icon_state = "wise"

/datum/sprite_accessory/hair/facial/muttonmus
	name = "胡须（羊排胡）"
	icon_state = "muttonmus"

/datum/sprite_accessory/hair/facial/martialartist
	name = "胡须（武术家）"
	icon_state = "martialartist"

/datum/sprite_accessory/hair/facial/chinlessbeard
	name = "胡须（无下巴）"
	icon_state = "chinlessbeard"

/datum/sprite_accessory/hair/facial/moonshiner
	name = "胡须（私酒贩）"
	icon_state = "moonshiner"

/datum/sprite_accessory/hair/facial/longbeard
	name = "胡须（长）"
	icon_state = "longbeard"

/datum/sprite_accessory/hair/facial/volaju
	name = "胡须（沃拉朱）"
	icon_state = "volaju"

/datum/sprite_accessory/hair/facial/threeoclock
	name = "胡须（三时胡茬）"
	icon_state = "3oclock"

/datum/sprite_accessory/hair/facial/fiveoclock
	name = "胡须（五时胡茬）"
	icon_state = "5oclock"

/datum/sprite_accessory/hair/facial/fiveoclockm
	name = "胡须（五时小胡）"
	icon_state = "5oclock_moustache"

/datum/sprite_accessory/hair/facial/sevenoclock
	name = "胡须（七时胡茬）"
	icon_state = "7oclock"

/datum/sprite_accessory/hair/facial/sevenoclockm
	name = "胡须（七时小胡）"
	icon_state = "7oclock_moustache"

/datum/sprite_accessory/hair/facial/stubble
	name = "胡须（胡茬）"
	icon_state = "stubble"

/datum/sprite_accessory/hair/facial/pipe
	name = "胡须（烟斗）"
	icon_state = "pipe"

/datum/sprite_accessory/hair/facial/knightly
	name = "胡须（骑士）"
	icon_state = "knightly"

/datum/sprite_accessory/hair/facial/manly
	name = "胡须（阳刚）"
	icon_state = "manly"

/datum/sprite_accessory/hair/facial/viking
	name = "胡须（维京）"
	icon_state = "viking"

/datum/sprite_accessory/hair/facial/moustache
	name = "八字胡"
	icon_state = "moustache"

/datum/sprite_accessory/hair/facial/fiveoclockmoustache
	name = "八字胡（五时）"
	icon_state = "5oclockmoustache"

/datum/sprite_accessory/hair/facial/pencilstache
	name = "八字胡（铅笔）"
	icon_state = "pencilstache"

/datum/sprite_accessory/hair/facial/smallstache
	name = "八字胡（小巧）"
	icon_state = "smallstache"

/datum/sprite_accessory/hair/facial/walrus
	name = "八字胡（海象）"
	icon_state = "walrus"

/datum/sprite_accessory/hair/facial/fu
	name = "八字胡（傅满洲）"
	icon_state = "fumanchu"

/datum/sprite_accessory/hair/facial/hogan
	name = "八字胡（霍根）"
	icon_state = "hogan"

/datum/sprite_accessory/hair/facial/selleck
	name = "八字胡（塞莱克）"
	icon_state = "selleck"

/datum/sprite_accessory/hair/facial/chaplin
	name = "八字胡（方块）"
	icon_state = "chaplin"

/datum/sprite_accessory/hair/facial/vandyke
	name = "八字胡（范戴克）"
	icon_state = "vandyke"

/datum/sprite_accessory/hair/facial/watson
	name = "八字胡（华生）"
	icon_state = "watson"

/datum/sprite_accessory/hair/facial/sideburn
	name = "鬓角"
	icon_state = "sideburns"

/datum/sprite_accessory/hair/facial/burns
	name = "鬓角（伯恩斯）"
	icon_state = "burns"

/datum/sprite_accessory/hair/facial/elvis
	name = "鬓角（猫王）"
	icon_state = "elvis"

/datum/sprite_accessory/hair/facial/mutton
	name = "鬓角（羊排胡）"
	icon_state = "mutton"

/datum/sprite_accessory/hair/head/vox
	abstract_type = /datum/sprite_accessory/hair/head/vox
	icon = 'icons/mob/sprite_accessory/hair/vox_hair.dmi'

/datum/sprite_accessory/hair/head/vox/afro
	name = "爆炸头"
	icon_state = "afro"

/datum/sprite_accessory/hair/head/vox/crestedquills
	name = "冠羽刺"
	icon_state = "crestedquills"

/datum/sprite_accessory/hair/head/vox/emperorquills
	name = "帝王羽刺"
	icon_state = "emperorquills"

/datum/sprite_accessory/hair/head/vox/horns
	name = "角"
	icon_state = "horns"

/datum/sprite_accessory/hair/head/vox/keelquills
	name = "龙骨羽刺"
	icon_state = "keelquills"

/datum/sprite_accessory/hair/head/vox/keetquills
	name = "鹦鹉羽刺"
	icon_state = "keetquills"

/datum/sprite_accessory/hair/head/vox/kingly
	name = "王者"
	icon_state = "kingly"

/datum/sprite_accessory/hair/head/vox/mohawk
	name = "莫西干"
	icon_state = "mohawk"

/datum/sprite_accessory/hair/head/vox/nights
	name = "夜"
	icon_state = "nights"

/datum/sprite_accessory/hair/head/vox/razorclipped
	name = "剃刀短发"
	icon_state = "razorclipped"

/datum/sprite_accessory/hair/head/vox/razor
	name = "剃刀"
	icon_state = "razor"

/datum/sprite_accessory/hair/head/vox/shortquills
	name = "短羽刺"
	icon_state = "shortquills"

/datum/sprite_accessory/hair/head/vox/tielquills
	name = "凤头羽刺"
	icon_state = "tielquills"

/datum/sprite_accessory/hair/head/vox/yasu
	name = "安"
	icon_state = "yasu"

/datum/sprite_accessory/hair/facial/vox
	abstract_type = /datum/sprite_accessory/hair/facial/vox
	icon = 'icons/mob/sprite_accessory/hair/vox_facial_hair.dmi'

/datum/sprite_accessory/hair/facial/vox/beard
	name = "胡须"
	icon_state = "beard"

/datum/sprite_accessory/hair/facial/vox/colonel
	name = "胡须（上校）"
	icon_state = "colonel"

/datum/sprite_accessory/hair/facial/vox/fu
	name = "胡须（傅）"
	icon_state = "fu"

/datum/sprite_accessory/hair/facial/vox/neck
	name = "颈部羽刺"
	icon_state = "neck"
