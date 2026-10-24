/datum/magic_aspect/pyromancy
	name = "火焰术"
	latin_name = "主法相·火焰"
	desc = "以烈火原始的狂怒将敌人活活烧灼的第一阶学派。\
	传承古老，常被视为与阿斯特拉塔之光相关的神圣魔法。\
	火焰法师与冰霜法师的争斗声名远扬，不过如今许多法师会视情况协调两者。\
	其法术往往抵消冰霜术的效果，反之亦然。"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_PYROMANCY
	school_color = GLOW_COLOR_FIRE
	binding_chants = list(
		"我呼唤永恒之火！",
		"祈求心中火焰炽盛燃烧，升腾！",
		"火焰，与我缔结！",
	)
	unbinding_chants = list(
		"我解开束缚的火焰！",
		"我平息内在之火，安歇。",
		"火焰，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/telegraphed_strike/dragons_breath,
		/datum/action/cooldown/spell/projectile/fireball/barrage,
		/datum/action/cooldown/spell/fire_curtain,
		/datum/action/cooldown/spell/projectile/smoke_burst,
		/datum/action/cooldown/spell/create_campfire,
	)
	choice_spells = list(
		/datum/action/cooldown/spell/projectile/spitfire,
		/datum/action/cooldown/spell/ultio,
	)
	spell_order = list(
		ASPECT_CHOICE,
		/datum/action/cooldown/spell/telegraphed_strike/dragons_breath,
		/datum/action/cooldown/spell/projectile/fireball/barrage,
		/datum/action/cooldown/spell/fire_curtain,
		/datum/action/cooldown/spell/projectile/smoke_burst,
		/datum/action/cooldown/spell/create_campfire,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/projectile/pyroclasm,
		),
		"gefechtsgelehrter" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/fire_strike,
		),
	)

/datum/magic_aspect/cryomancy
	name = "冰霜术"
	latin_name = "主法相·冰霜"
	desc = "以每次打击逐步削弱敌人的第一阶学派。它在纯粹破坏力\
	与速度上的不足，由不断累积的衰弱效果弥补：敌人颤抖、迟缓，最终被冻住。\
	此学派在格隆、铁锤堡及格伦泽霍夫最为盛行，可能起源于其中某个国家。那里寒霜\
	司空见惯，法师容易想象驾驭其力量。冰霜法师与火焰法师的竞争声名远扬，\
	不过如今许多法师会视情况选择协调其中一种。"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_CRYOMANCY
	school_color = GLOW_COLOR_ICE
	binding_chants = list(
		"我呼唤永恒寒冰！",
		"呼唤深处盘桓的寒意，现身！",
		"寒冰，与我缔结！",
	)
	unbinding_chants = list(
		"我解开束缚的寒冰！",
		"我释放攫住血脉的寒意，消融。",
		"寒冰，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/frost_bolt,
		/datum/action/cooldown/spell/projectile/rimecast,
		/datum/action/cooldown/spell/forcewall/ice,
		/datum/action/cooldown/spell/verglas,
		/datum/action/cooldown/spell/fridigitation,
	)
	spell_order = list(
		/datum/action/cooldown/spell/projectile/frost_bolt,
		/datum/action/cooldown/spell/projectile/rimecast,
		/datum/action/cooldown/spell/forcewall/ice,
		/datum/action/cooldown/spell/verglas,
		/datum/action/cooldown/spell/fridigitation,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/frozen_mist,
		),
	)

/datum/magic_aspect/fulgurmancy
	name = "雷电术"
	latin_name = "主法相·雷电"
	desc = "以令人麻木的速度与压倒性力量打击敌人的第一阶学派。\
	雷电法师以可靠著称：法术快速、精准、稳定，远胜那些华而不实的学派。\
	据说最出色的雷电法师，从未见过自己的雷电偏离目标。"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_FULGURMANCY
	school_color = GLOW_COLOR_LIGHTNING
	binding_chants = list(
		"我呼唤风暴之怒！",
		"召来苍穹翻涌的风暴，出击！",
		"雷霆，与我缔结！",
	)
	unbinding_chants = list(
		"我解开束缚的风暴！",
		"我平息体内肆虐的风暴，静止。",
		"雷霆，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/arc_bolt,
		/datum/action/cooldown/spell/projectile/lightning_bolt,
		/datum/action/cooldown/spell/fulmination,
		/datum/action/cooldown/spell/levinstroke,
		/datum/action/cooldown/spell/light,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/greater_thunderstrike,
		),
	)

/datum/magic_aspect/geomancy
	name = "地术"
	latin_name = "主法相·大地"
	desc = "掌控大地本身的第一阶学派。石块是人类最古老的武器，地术也如大地般古老。\
	每道法术都沉重有力，灵巧的对手或许能及时躲开。但地术师无所畏惧——碎石爆射\
	断绝闪避可能，大地之握钉住对手，巨石将敌人碾成肉泥。\
	当大地本身与你为敌，谁能抵挡如此古老的力量？"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_GEOMANCY
	school_color = GLOW_COLOR_EARTHEN
	binding_chants = list(
		"我呼唤亘古大地！",
		"恳请不屈之岩，回应！",
		"大地，与我缔结！",
	)
	unbinding_chants = list(
		"我解开束缚的大地！",
		"我放下护持自身的岩石，崩解。",
		"大地，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/gravel_blast,
		/datum/action/cooldown/spell/tumult,
		/datum/action/cooldown/spell/menhir,
		/datum/action/cooldown/spell/geas,
		/datum/action/cooldown/spell/magicians_stone,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/meteor_strike,
		),
		"gefechtsgelehrter" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/grenzel_meteor,
		),
	)

/datum/magic_aspect/kinesis
	name = "动力术"
	latin_name = "主法相·力能"
	desc = "常被称为本源学派。动力术，亦称纯粹奥术，据说是最古老的魔法学派——\
	魔法本身便是将原始能量化作现实的技艺。依离纯粹力能的远近，魔法分为三阶：\
	第一阶塑造火、冰、石等原初物质；第二阶操纵经人手制造的事物；\
	第三阶扭曲抽象概念，触及神明领域。唯动力术独立于这套划分，因为它不转化任何东西。\
	它直接驾驭原始、纯净、几乎未经塑形的魔力，让法师仅凭意志碾压并扭曲世界。"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_KINESIS
	school_color = GLOW_COLOR_KINESIS
	binding_chants = list(
		"我呼唤无形之力！",
		"召来扭曲万物的力量，听命！",
		"力能，与我缔结！",
	)
	unbinding_chants = list(
		"我解开束缚的力能！",
		"我解放流经体内的力量，散去。",
		"力能，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/basic_offensive,
		/datum/action/cooldown/spell/crush,
		/datum/action/cooldown/spell/gravity,
		/datum/action/cooldown/spell/telegraphed_strike/kinetic_burst,
		/datum/action/cooldown/spell/arcyne_forge,
		/datum/action/cooldown/spell/levitation,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/mass_crush,
		),
	)

/datum/magic_aspect/telomancy
	name = "飞弹术"
	latin_name = "主法相·飞弹"
	desc = "飞弹法师认为自己只是动力术的分支，同样有资格称为『本源学派』。\ 确实，将纯粹奥术塑成魔法球，很可能是人类史上最早施放的法术之一。\
	动力术兼顾塑造魔力与操纵力能，而飞弹法师几乎专注于将魔力塑成致命投射物。"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_TELOMANCY
	school_color = GLOW_COLOR_ARCANE
	binding_chants = list(
		"我呼唤命定之矢！",
		"我将意志送向目标，愿其抵达。",
		"飞矢，与我缔结！",
	)
	unbinding_chants = list(
		"我解开束缚的飞矢！",
		"我放开选定的目标，自由而去。",
		"飞矢，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/arcyne_volley,
		/datum/action/cooldown/spell/void_beam,
		/datum/action/cooldown/spell/arcyne_burst,
		/datum/action/cooldown/spell/circumdatum,
		/datum/action/cooldown/spell/arcyne_forge,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/projectile/arcyne_barrage,
		),
	)

/datum/magic_aspect/ferramancy
	name = "炼铁术"
	latin_name = "主法相·钢铁"
	desc = "炼铁术属于第二阶魔法。在诸多主法相中，它或许最年轻——\
	不过也只比其他法相年轻千年左右。炼铁法师想象原初物质\
	经人手化为兵器工具，使其具现，再驱使它们斩裂敌人。\
	主法相中，唯有它常与拉沃克斯而非诺克相联系，可能源于拉沃克斯\
	向格拉加尔投掷兵器将其杀死的传说。专精此道的法师以自身技艺为傲，常认为\
	连接原始力量与人类巧思使其高人一等。也有学者因此鄙视其力量不够纯粹。\
	然而真正的原因，或许是金属撕裂结界与法师袍的效率胜过其他任何魔法。"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_FERRAMANCY
	school_color = GLOW_COLOR_METAL
	binding_chants = list(
		"我呼唤不驯之钢！",
		"呼唤心中锻炉，创造！",
		"钢铁，听我号令！",
	)
	unbinding_chants = list(
		"我熄灭心中锻炉！",
		"我止息锤与钢的鸣响，冷却。",
		"钢铁，归于安宁！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/ferramancy_strike/falling_crescent,
		/datum/action/cooldown/spell/ferramancy_strike/sorcerers_lance,
		/datum/action/cooldown/spell/ferramancy_strike/heavens_hammer,
		/datum/action/cooldown/spell/form_blade,
		/datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide,
		/datum/action/cooldown/spell/bind_armament,
		/datum/action/cooldown/spell/arcyne_forge,
		/datum/action/cooldown/spell/mending,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/blade_dance,
		),
		"gefechtsgelehrter" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/form_blade/form_hammer,
		),
	)

/datum/magic_aspect/battlewardry
	name = "战阵防护术"
	latin_name = "主法相·战阵防护"
	desc = "战阵防护术属于第二阶魔法。其他学派多引导毁灭，它却专精于阻止毁灭。战阵守护者以改良的战术符文陷阱惩罚鲁莽者，用力墙塑造战场，并为幸运的盟友层层加护。防护术虽常被视为被动保护，战阵守护者却绝不被动：他们的法术使整个战场依其意志成形。"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_BATTLEWARDRY
	school_color = GLOW_COLOR_WARD
	binding_chants = list(
		"我呼唤战阵庇护！",
		"我立起战之结界，守护！",
		"战阵庇护，与我缔结！",
	)
	unbinding_chants = list(
		"我解开束缚的庇护！",
		"我放下立起的结界，安歇。",
		"战阵庇护，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/battle_ward,
		/datum/action/cooldown/spell/forcewall,
		/datum/action/cooldown/spell/arrow_ward,
		/datum/action/cooldown/spell/bestow_ward,
		/datum/action/cooldown/spell/touch/rune_ward,
	)
	choice_spells = list(
		/datum/action/cooldown/spell/projectile/soulshot,
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/arcyne_fortress,
		),
	)

/*
/datum/magic_aspect/conjuration
	name = "Conjuration"
	latin_name = "Maior Aspectus Vocationis"
	desc = "A school devoted to tapping into the leyline, and calling forth the elements or others as one's servants. \
	Where other magi hurl mana formed into elements, Conjurer commands their servants from behind to fight. Though, an artificial mind is often lacking in intellect and technique - many a conjurer therefore practice Projection, taking over their conjured servants to assault their enemies directly. \
	Such magick cannot be maintained over a long range, and no conjurer can conjure a servant more powerful than fighting themselves. But the lack of long term risk is a major benefit, even if the conjurer suffers a horrific recoil once their conjured summons are taken down."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_CONJURATION
	school_color = GLOW_COLOR_ARCANE
	binding_chants = list(
		"Invoco famulos ex arcano!",
		"I call forth a servant to stand at my side, arise!",
		"Vocatio, in me ligare!",
	)
	unbinding_chants = list(
		"Solvo vocationem vinctam!",
		"I dismiss the servant I have called, return whence you came.",
		"Vocatio, a me discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/minion_order/conjurer,
		/datum/action/cooldown/spell/minion_mark,
		/datum/action/cooldown/spell/conjure_recall,
		/datum/action/cooldown/spell/conjure_dismiss,
		/datum/action/cooldown/spell/conjure_projection,
	)
	choice_spells = list(
		/datum/action/cooldown/spell/conjure_summon/primordial,
	)
	mastery_choice_spells = list(
	)
	spell_order = list(
		/datum/action/cooldown/spell/minion_order/conjurer,
		ASPECT_CHOICE,
		/datum/action/cooldown/spell/minion_mark,
		/datum/action/cooldown/spell/conjure_projection,
		/datum/action/cooldown/spell/conjure_recall,
		/datum/action/cooldown/spell/conjure_dismiss,
	)
	variants = list(
		"gefechtsgelehrter" = list(
		),
	)
*/

/datum/magic_aspect/augmentation
	name = "增幅术"
	latin_name = "主法相·增幅"
	desc = "学者争论增幅术究竟属于第一、第二还是第三阶。修习者自认为属第三阶——\
	通过增强人类形体的无穷潜能，荣幸地效仿神明。法术专注于强化身体，\
	绝不直接强化心智，因为那才是神明真正的领域；也不能如此直白地用魔法提升驾驭魔法的能力。\
	面对经奥术磨砺的战士，敌人必遭厄运……"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_AUGMENTATION
	school_color = GLOW_COLOR_BUFF
	binding_chants = list(
		"我呼唤沉睡的潜能！",
		"我唤起体内沉睡的潜能，醒来！",
		"增幅之力，与我缔结！",
	)
	unbinding_chants = list(
		"我解开束缚的潜能！",
		"我平息唤起的力量，安歇。",
		"增幅之力，离我而去！",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/basic_offensive,
		/datum/action/cooldown/spell/arcyne_burst,
		/datum/action/cooldown/spell/forcewall,
		/datum/action/cooldown/spell/augment_buff/blood_rush,
		/datum/action/cooldown/spell/augment_buff/guidance,
		/datum/action/cooldown/spell/augment_buff/precognition,
		/datum/action/cooldown/spell/augment_buff/surge,
		/datum/action/cooldown/spell/augment_buff/grasp,
		/datum/action/cooldown/spell/augment_buff/augment_defense,
		/datum/action/cooldown/spell/darkvision,
		/datum/action/cooldown/spell/mending,
		/datum/action/cooldown/spell/create_campfire,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/second_chance,
		),
	)
