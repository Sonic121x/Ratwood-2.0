//Reskin + Flavor of diagnose spell w/ some different flavor. Used for Necromancers/Lich. Pickable instead of an offensive cantrip too.
/obj/effect/proc_holder/spell/invoked/diagnose/secular/zizo
	name = "奥术诊断"
	desc = "以娴熟的左道魔法远程诊察体液与隐疾。揭示目标状况，医疗技能越高，所得信息越详尽。将镊子嵌入病人体内，甚至可以辨识血液中的物质；即便最生疏的医师，也能从奇尔虫或水蛭的反应中得到线索。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	range = SPELL_RANGE_GROUND //Longer than regular diagnosis range. Progress Baby!
	invocations = list("洞悉安康。") //Study health.
	invocation_type = INVOCATION_WHISPER
	antimagic_allowed = FALSE //Arcane, duh.

// Enochian Analyze (T?) - Comes w/ diagnosis cantrip for free, tradeoff from an offensive cantrip.
/obj/effect/proc_holder/spell/invoked/engineeranalyze/zizo
	name = "以诺分析"
	desc = "借以诺魔力从齐佐的设计中洞察世界，无须专门工具即可远近检视构造细节。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	range = SPELL_RANGE_GROUND
	invocations = list("洞悉构造。")
	invocation_type = INVOCATION_WHISPER
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = FALSE
