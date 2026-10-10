#define CTAG_UKJ_DARK_ITINERANT "CTAG_UKJ_DARK_ITINERANT"
#define CTAG_UKJ_VARLET "CTAG_UKJ_VARLET"
#define CTAG_UKJ_DARK_CHAPLAIN "CTAG_UKJ_DARK_CHAPLAIN"

/datum/migrant_role/ukj_dark_itinerant
	name = "黑暗行者"
	role_category = "Adventurer"
	greet_text = "你用刀剑挣来了功绩，却没能获得应有的领地与头衔，于是转而侍奉飞升者。多年效力让你懂得，想要什么就亲手夺取。你的扈从还在学习这一点。"
	antag_datum = /datum/antagonist/ukj_dark_itinerant
	advclass_cat_rolls = list(CTAG_UKJ_DARK_ITINERANT = 20)
	grant_lit_torch = TRUE

/datum/migrant_role/ukj_varlet
	name = "扈从"
	role_category = "Adventurer"
	greet_text = "在一位堕落骑士收留你之前，你不过是个无名小卒，你也没多问他究竟效忠于谁。神明的声音对你而言仍很陌生，但你正学着聆听。"
	antag_datum = /datum/antagonist/ukj_dark_itinerant/varlet
	advclass_cat_rolls = list(CTAG_UKJ_VARLET = 20)

/datum/migrant_role/ukj_dark_chaplain
	name = "传道者"
	role_category = "Adventurer"
	greet_text = "你让同行的叛誓骑士坚定信仰。每个途经的城镇，不论情愿与否，都将听闻飞升者的名号。"
	antag_datum = /datum/antagonist/ukj_dark_itinerant/dark_chaplain
	advclass_cat_rolls = list(CTAG_UKJ_DARK_CHAPLAIN = 20)
