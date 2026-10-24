/datum/magic_aspect/artifice
	name = "魔工术"
	latin_name = "次法相·魔工"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_METAL
	binding_chants = list(
		"赐我工匠之眼。",
		"工艺，与我同在！",
	)
	unbinding_chants = list(
		"我放下工匠的工具。",
		"工艺，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/arcyne_forge,
		/datum/action/cooldown/spell/mending,
	)

/datum/magic_aspect/exowardry
	name = "外御术"
	latin_name = "次法相·外御"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_ARCANE
	binding_chants = list(
		"让我筑墙抵御敌人。",
		"外御，与我同在！",
	)
	unbinding_chants = list(
		"我撤去筑起的墙。",
		"外御，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/forcewall,
	)


/datum/magic_aspect/displacement
	name = "位移术"
	latin_name = "次法相·位移"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_DISPLACEMENT
	binding_chants = list(
		"让我踏入诸界之间的缝隙。",
		"位移，与我同在！",
	)
	unbinding_chants = list(
		"我关闭开启的道路，不再漫游诸界。",
		"位移，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/phase,
	)

/datum/magic_aspect/autowardry
	name = "自御术"
	latin_name = "次法相·自御"
	desc = "为现有奥术结界增添特性。法相激活期间，原防护法术会被强化版本替换。"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_METAL
	binding_chants = list(
		"让我披上奥术之甲。",
		"自御，与我同在！",
	)
	unbinding_chants = list(
		"我褪去奥术披覆，显露本身。",
		"自御，离我而去！",
	)
	choice_spells = list(
		/datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide,
		/datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide,
	)

/datum/magic_aspect/lesser_augmentation
	name = "次级增幅术"
	latin_name = "次法相·增幅"
	desc = "学者争论增幅术究竟属于第一、第二还是第三阶。修习者自认为属第三阶——\
	通过增强人类形体的无穷潜能，荣幸地效仿神明。法术专注于强化身体，\
	绝不直接强化心智，因为那才是神明真正的领域；也不能如此直白地用魔法提升驾驭魔法的能力。\
	面对经奥术磨砺的战士，敌人必遭厄运。"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_BUFF
	binding_chants = list(
		"让我触及内在潜能。",
		"增幅，与我同在！",
	)
	unbinding_chants = list(
		"我平息内在潜能。",
		"增幅，离我而去！",
	)
	pointbuy_budget = 6
	pointbuy_spells = list(
		/datum/action/cooldown/spell/darkvision,
		/datum/action/cooldown/spell/augment_buff/blood_rush,
		/datum/action/cooldown/spell/augment_buff/guidance,
		/datum/action/cooldown/spell/featherfall,
		/datum/action/cooldown/spell/augment_buff/enlarge,
		/datum/action/cooldown/spell/leap,
		/datum/action/cooldown/spell/nondetection,
		/datum/action/cooldown/spell/augment_buff/surge,
		/datum/action/cooldown/spell/augment_buff/precognition,
		/datum/action/cooldown/spell/augment_buff/grasp,
		// 1-cost utility filler
		/datum/action/cooldown/spell/light,
		/datum/action/cooldown/spell/mending,
		/datum/action/cooldown/spell/create_campfire,
	)

/datum/magic_aspect/illusion
	name = "幻术"
	latin_name = "次法相·幻象"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_ILLUSION
	binding_chants = list(
		"让我编织不存在之物。",
		"幻象，与我同在！",
	)
	unbinding_chants = list(
		"我解开织成的帷幕。",
		"幻象，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/invisibility,
	)

/datum/magic_aspect/hearthcraft
	name = "炉火术"
	latin_name = "次法相·家宅"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_HEARTH
	binding_chants = list(
		"让我照料炉火与家园。",
		"家宅，与我同在！",
	)
	unbinding_chants = list(
		"我让炉火渐熄。",
		"家宅，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/great_shelter,
		/datum/action/cooldown/spell/create_campfire,
	)

/datum/magic_aspect/aegiscraft
	name = "神盾术"
	latin_name = "次法相·神盾"
	desc = "投射原始奥术力盾的技艺。这面盾为睿智法师提供急需的外部防护。 "
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_ARCANE
	binding_chants = list(
		"让我塑成使敌人败亡的盾。",
		"神盾，与我同在！",
	)
	unbinding_chants = list(
		"我放下盾牌，仅凭血肉面对敌人。",
		"神盾，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/conjure_aegis,
	)

/datum/magic_aspect/hex
	name = "咒术"
	latin_name = "次法相·诅咒"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_HEX
	binding_chants = list(
		"让我道出扭曲之言。",
		"诅咒，与我同在！",
	)
	unbinding_chants = list(
		"我收回扭曲之言。",
		"诅咒，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/wither,
	)
