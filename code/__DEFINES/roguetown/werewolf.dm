// Howl channel recipients — used in howl_channels list to define who can hear a howl.
#define HOWL_CHANNEL_WEREWOLF "werewolf" // Werewolves (/datum/antagonist/werewolf and subtypes)
#define HOWL_CHANNEL_DRUID    "druid"    // Druids, Dendorite Acolytes, and users with Call of the Moon
#define HOWL_CHANNEL_GNOLL    "gnoll"    // Gnolls (/datum/antagonist/gnoll)

GLOBAL_LIST_INIT(wolf_prefixes, list("赤", "月", "血", "绒", "饥", "锐", "暗", "银",
									"夜", "蛮", "烈", "铁", "风暴", "野", "烈", "冷酷",
									"猩红", "午夜", "钢", "恶"))
GLOBAL_LIST_INIT(wolf_suffixes, list("牙", "爪", "潜行者", "游猎者", "吼", "撕裂者", "嚎", "猎", "猎手",
									"灾", "怒", "怖", "狂", "疤", "碎裂者", "锤", "愤", "祸",
									"掠夺者", "寻觅者", "袭击者"))
