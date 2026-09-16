#define CTAG_KJ_KNIGHT "CTAG_KJ_KNIGHT"
#define CTAG_KJ_SQUIRE "CTAG_KJ_SQUIRE"
#define CTAG_KJ_CHAPLAIN "CTAG_KJ_CHAPLAIN"
#define CTAG_KJ_FOLLOWER "CTAG_KJ_FOLLOWER"

/datum/migrant_role/kj_knight
	name = "久经沙场的游侠骑士"
	greet_text = "比武场上的对决、攻城战以及路边的伏击：你都挺过来了。你的侍从也陪你经历过几次。完成对他们的训练，看着他们赢得属于自己的骑士马刺吧。"
	advclass_cat_rolls = list(CTAG_KJ_KNIGHT = 20)

/datum/migrant_role/kj_knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "爵士"
		if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
			honorary = "女爵"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/migrant_role/kj_squire
	name = "久经磨练的侍从"
	greet_text = "你已侍奉你的骑士数年。你能在战斗中自保，也能让他的甲胄保持完好，但骑士的册封仍在前方等着你。"
	advclass_cat_rolls = list(CTAG_KJ_SQUIRE = 20)

/datum/migrant_role/kj_chaplain
	name = "誓约随军教士"
	greet_text = "你随一位游侠骑士同行，照看他的灵魂，而更多时候还要照看他的伤口。"
	advclass_cat_rolls = list(CTAG_KJ_CHAPLAIN = 20)

/datum/migrant_role/kj_follower
	name = "誓约随从"
	greet_text = "你在路上侍奉一位游侠骑士。战斗由他应付，而让他得以继续前行的一切琐事，都由你来打理。"
	advclass_cat_rolls = list(CTAG_KJ_FOLLOWER = 20)
	allowed_races = ACCEPTED_RACES
	show_wanderer_examine = FALSE
