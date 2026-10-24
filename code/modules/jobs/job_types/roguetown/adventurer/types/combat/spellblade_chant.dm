/proc/get_spellblade_chant_html(datum/caller, mob/living/carbon/human/H, faction = "conventional", extra_blade_weapon, extra_phalanx_weapon, extra_mace_weapon)
	var/blade_chant = get_blade_chant_text(faction, H)
	var/phalanx_chant = get_phalanx_chant_text(faction, H)
	var/macebearer_chant = get_macebearer_chant_text(faction, H)
	var/preamble_closing = get_preamble_closing(faction)

	var/title = "战颂"
	var/blade_btn = "咏唱剑刃之章"
	var/phalanx_btn = "咏唱方阵武士之章"
	var/mace_btn = "咏唱执锤者之章"
	if(faction == "undead")
		title = "MEMORIES"
		blade_btn = "醒来"
		phalanx_btn = "醒来"
		mace_btn = "醒来"
	var/blade_weapons
	var/phalanx_weapons
	var/mace_weapons
	switch(faction)
		if("blackoak")
			blade_weapons = "精灵长剑 / 精灵军刀 / 精灵曲刃剑 / 钢匕首"
			phalanx_weapons = "精灵战刃"
			mace_weapons = "钢钉头锤 / 钢战锤与盾牌 / 巨型钉头锤 / 战斧 / 钢巨斧"
		if("zizite")
			blade_weapons = "双手大刀 / 长剑 / 刺剑 / 军刀 / 钢巨剑 / 钢匕首与盾牌"
			phalanx_weapons = "长戟 / 长柄战斧 / 猎猪矛 / 多利短矛与盾牌 / 薙刀"
			mace_weapons = "钢钉头锤 / 钢战锤与盾牌 / 巨型钉头锤 / 战斧 / 钢巨斧"
		if("noccite")
			blade_weapons = "长剑 / 刺剑 / 军刀 / 钢巨剑 / 钢匕首与盾牌 / 暮光之牙"
			phalanx_weapons = "长戟 / 长柄战斧 / 猎猪矛 / 多利短矛与盾牌 / 薙刀"
			mace_weapons = "钢钉头锤 / 钢战锤与盾牌 / 巨型钉头锤 / 战斧 / 钢巨斧"
		if("almah")
			blade_weapons = "双持舍施尔弯刀 / 沙拉尔军刀与盾牌"
			phalanx_weapons = "长矛 / 多利短矛与盾牌"
			mace_weapons = "钢钉头锤 / 钢战锤与盾牌 / 巨型钉头锤 / 战斧 / 钢巨斧"
		if("undead")
			blade_weapons = "古代镰刃剑 / 军刀 / 腐蚀匕首与盾牌"
			phalanx_weapons = "古代长矛 / 古代长柄战斧 / 多利短矛与盾牌"
			mace_weapons = "古代钉头锤 / 古代战锤与盾牌 / 巨型钉头锤 / 古代战斧 / 钢巨斧"
		else
			blade_weapons = "长剑 / 刺剑 / 军刀 / 武装剑 / 短剑 / 环刀	/ 钢匕首与盾牌"
			phalanx_weapons = "长矛 / 多利短矛与盾牌 / 薙刀"
			mace_weapons = "钉头锤 / 战锤与盾牌 / 戈登达格棍 / 铁斧 / 巨斧"

	// Inject patron-specific weapons into weapon lists
	if(extra_blade_weapon)
		blade_weapons = "[extra_blade_weapon] / [blade_weapons]"
	if(extra_phalanx_weapon)
		phalanx_weapons = "[extra_phalanx_weapon] / [phalanx_weapons]"
	if(extra_mace_weapon)
		mace_weapons = "[extra_mace_weapon] / [mace_weapons]"

	// Color palette per faction
	var/col_bg			// body background
	var/col_text			// main text
	var/col_header		// h2, weapon-info, button text, loud preamble
	var/col_subheader	// h3, h4, closing preamble
	var/col_border		// borders, preamble text
	var/col_divider		// inner dividers
	var/col_gradient		// column/shared-info background
	var/col_em			// chant emphasized text
	var/col_li			// list item text
	var/col_btn_bg		// button background
	var/col_btn_hover	// button hover background
	var/col_glow_r		// box-shadow RGB
	var/col_glow_g
	var/col_glow_b
	switch(faction)
		if("zizite", "undead")
			col_bg = "#140a0a";			col_text = "#d4a0a0"
			col_header = "#c96e6e";		col_subheader = "#a05050"
			col_border = "#8b5555";		col_divider = "#5a3030"
			col_gradient = "#2a1010";	col_em = "#e0b0b0"
			col_li = "#b08080";			col_btn_bg = "#3a1515"
			col_btn_hover = "#4a2020";	col_glow_r = "139"; col_glow_g = "85"; col_glow_b = "85"
		if("noccite")
			col_bg = "#0a0e1a";			col_text = "#a0b8d4"
			col_header = "#6e8ec9";		col_subheader = "#5070a0"
			col_border = "#556b8b";		col_divider = "#304a5a"
			col_gradient = "#101828";	col_em = "#b0c8e0"
			col_li = "#8098b0";			col_btn_bg = "#152030"
			col_btn_hover = "#203040";	col_glow_r = "85"; col_glow_g = "107"; col_glow_b = "139"
		if("blackoak")
			col_bg = "#0a140e";			col_text = "#a0d4b0"
			col_header = "#6ec98e";		col_subheader = "#50a070"
			col_border = "#558b65";		col_divider = "#305a40"
			col_gradient = "#102a18";	col_em = "#b0e0c0"
			col_li = "#80b090";			col_btn_bg = "#153a20"
			col_btn_hover = "#204a30";	col_glow_r = "85"; col_glow_g = "139"; col_glow_b = "101"
		if("almah")
			col_bg = "#1a150a";			col_text = "#d4c090"
			col_header = "#e0b050";		col_subheader = "#c09840"
			col_border = "#a08030";		col_divider = "#6a5520"
			col_gradient = "#2a2010";	col_em = "#f0d080"
			col_li = "#c0a860";			col_btn_bg = "#3a2a10"
			col_btn_hover = "#4a3a18";	col_glow_r = "200"; col_glow_g = "160"; col_glow_b = "60"
		else // conventional — default warm brown/gold
			col_bg = "#1a1410";			col_text = "#d4c4a0"
			col_header = "#c9a96e";		col_subheader = "#a08050"
			col_border = "#8b7355";		col_divider = "#5a4a30"
			col_gradient = "#2a2015";	col_em = "#e0d0b0"
			col_li = "#b0a080";			col_btn_bg = "#3a2a15"
			col_btn_hover = "#4a3a20";	col_glow_r = "139"; col_glow_g = "115"; col_glow_b = "85"

	var/html = {"<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
body {
	background-color: [col_bg];
	color: [col_text];
	font-family: Georgia, 'Times New Roman', serif;
	margin: 0;
	padding: 20px;
}
.chant-container {
	max-width: 960px;
	margin: 0 auto;
	text-align: center;
}
h2 {
	color: [col_header];
	font-size: 20px;
	letter-spacing: 3px;
	text-transform: uppercase;
	border-bottom: 1px solid [col_border];
	padding-bottom: 10px;
	margin-bottom: 25px;
}
.columns {
	display: flex;
	gap: 20px;
	margin-bottom: 20px;
}
.column {
	flex: 1;
	display: flex;
	flex-direction: column;
	background: linear-gradient(135deg, [col_gradient] 0%, [col_bg] 50%, [col_gradient] 100%);
	border: 2px solid [col_border];
	border-radius: 4px;
	padding: 20px;
	box-shadow: 0 0 15px rgba([col_glow_r], [col_glow_g], [col_glow_b], 0.2);
}
.column-content {
	flex: 1;
}
.column h3 {
	color: [col_subheader];
	font-size: 15px;
	letter-spacing: 2px;
	margin: 0 0 15px 0;
}
.chant-text p {
	font-size: 12px;
	line-height: 1.7;
	margin: 3px 0;
}
.chant-text em {
	color: [col_em];
}
.abilities {
	text-align: left;
	border-top: 1px solid [col_divider];
	padding-top: 12px;
	margin-top: 15px;
}
.abilities h4 {
	color: [col_subheader];
	font-size: 11px;
	letter-spacing: 1px;
	margin: 0 0 8px 0;
	text-transform: uppercase;
	text-align: center;
}
.abilities ul {
	list-style: none;
	padding: 0;
	margin: 0;
}
.abilities li {
	font-size: 11px;
	line-height: 1.5;
	margin: 5px 0;
	color: [col_li];
}
.abilities li b {
	color: [col_text];
}
.weapon-info {
	text-align: center;
	font-size: 12px;
	color: [col_header];
	margin-top: 12px;
	padding-top: 8px;
	border-top: 1px solid [col_divider];
	font-style: italic;
}
a.choose-btn {
	display: block;
	margin-top: 15px;
	padding: 10px 15px;
	background: [col_btn_bg];
	border: 1px solid [col_border];
	border-radius: 3px;
	color: [col_header];
	text-decoration: none;
	font-family: Georgia, serif;
	font-size: 13px;
	letter-spacing: 1px;
	text-align: center;
}
a.choose-btn:hover {
	background: [col_btn_hover];
	border-color: [col_header];
	color: [col_em];
}
.shared-info {
	background: [col_gradient];
	border: 1px solid [col_divider];
	border-radius: 3px;
	padding: 10px 15px;
	text-align: center;
}
.shared-info + .shared-info {
	margin-top: 10px;
}
.shared-list {
	list-style: none;
	padding: 0;
	margin: 5px 0 0 0;
}
.shared-list li {
	font-size: 11px;
	line-height: 1.5;
	margin: 5px 0;
	color: [col_li];
}
.shared-list li b {
	color: [col_text];
}
.shared-info h4 {
	color: [col_subheader];
	font-size: 11px;
	letter-spacing: 1px;
	text-transform: uppercase;
	margin: 0 0 5px 0;
}
.shared-info p {
	font-size: 11px;
	color: [col_li];
	margin: 0;
}
.preamble {
	margin-top: 20px;
	padding: 15px 20px;
	border-top: 1px solid [col_divider];
	text-align: center;
	font-style: italic;
}
.preamble p {
	font-size: 11px;
	line-height: 1.8;
	margin: 4px 0;
	color: [col_border];
}
.preamble p.loud {
	color: [col_header];
	font-style: normal;
	font-weight: bold;
	letter-spacing: 1px;
}
.preamble p.closing {
	color: [col_subheader];
	margin-top: 10px;
}
</style>
</head>
<body>
<div class="chant-container">
<h2>[title]</h2>
<p style="font-size: 11px; color: [col_border]; margin-top: -15px; margin-bottom: 15px; font-style: italic;">你有 5 分钟作出选择。</p>
<div class="columns">
<div class="column">
<div class="column-content">
<h3>— 剑刃 —</h3>
<div class="chant-text">
[blade_chant]
</div>
<div class="abilities">
<h4>能力</h4>
<ul>
<li><b>疾斩</b> — 疾冲穿过敌人，攻击沿途所有目标。消耗 3 点动量可打击两次！</li>
<li><b>隔空击</b> — 随攻击意图变化的远程攻击。动量达到 3 点时，伤害翻倍。</li>
<li><b>地脉锚点</b> — 在地脉上锚定奥术牵系，再次施放可返回。75 点生命，持续 20 秒，范围 7 格。受束缚时无法返回。牵系被毁或到期即进入完整冷却。</li>
<li><b>剑刃风暴</b> — 投出阴影弹，命中后传送至目标身上，斩击目标及周围所有人。需要 7 点动量；10 点时增加打击次数。被反射的阴影会伤害你！</li>
</ul>
</div>
<p class="weapon-info">[blade_weapons]</p>
</div>
<a class="choose-btn" href='?src=\ref[caller];subclass=blade'>[blade_btn]</a>
</div>
<div class="column">
<div class="column-content">
<h3>— 方阵武士 —</h3>
<div class="chant-text">
[phalanx_chant]
</div>
<div class="abilities">
<h4>能力</h4>
<ul>
<li><b>费伦提亚方阵</b> — 为下一次近战注入奥术之力，命中后贯穿目标身后的直线敌人。强化（3 点动量）：穿刺更深，伤害更高。</li>
<li><b>费伦提亚投矛</b> — 投出寒冰幻影标枪，命中施加 2 层寒霜。强化后施加 3 层，必定冻结已沾染寒霜的目标。蓄力时不减速。</li>
<li><b>进击！</b> — 向前跃出最多 4 格，穿过敌人，落地后向前刺击。起跳前需短暂蓄力。强化后伤害翻倍。</li>
<li><b>清算之门</b> — 召出两柄幻影长矛列阵于两侧。持续 12 秒，每次近战命中使长矛向前刺出三格宽的直线。可被盾牌格挡。过载时充能由 3 次增至 6 次。</li>
</ul>
</div>
<p class="weapon-info">[phalanx_weapons]</p>
</div>
<a class="choose-btn" href='?src=\ref[caller];subclass=phalangite'>[phalanx_btn]</a>
</div>
<div class="column">
<div class="column-content">
<h3>— 执锤者 —</h3>
<div class="chant-text">
[macebearer_chant]
</div>
<div class="abilities">
<h4>能力</h4>
<ul>
<li><b>碎裂</b> — 蓄势后攻击正前方直线，将命中者击退一格。随武器造成切割或砸击，钝击威力稍弱。遇墙停止，但会破坏沿途建筑。强化后伤害翻倍。</li>
<li><b>震颤</b> — 蓄势后令周围环形地面爆发，击退所有邻近者。蓄势时随你移动，随武器造成切割或砸击。强化后伤害翻倍。</li>
<li><b>冲锋！</b> — 立刻向前疾冲四步，将沿途所有人推向两侧。不造成伤害，专用于移动与扰乱。</li>
<li><b>灾变</b> — 召出奥术巨锤并掷向目标区域，碾压 5x5 范围，使受害者易伤。满动量时伤害提高。</li>
</ul>
</div>
<p class="weapon-info">[mace_weapons]</p>
</div>
<a class="choose-btn" href='?src=\ref[caller];subclass=macebearer'>[mace_btn]</a>
</div>
</div>
<div class="shared-info">
<h4>共有能力</h4>
<p>武器绑定 · 武器召回 · 武器赋能 · 修复术 · 4 点实用法术点</p>
</div>
<div class="shared-info" style="text-align: left;">
<h4 style="text-align: center;">共有机制</h4>
<ul class="shared-list">
<li><b>奥术动量</b> — 近战命中活物时积累 1 点动量，即使被招架或闪避也有效。近战每 2 秒提供 1 层。消耗 3 点可释放强化能力。</li>
<li><b>衰减</b> — 最后一次打击 10 秒后开始衰减，每 6 秒失去 1 层。</li>
<li><b>打断</b> — 倒地或眩晕会失去全部动量。失衡损失 3 点。</li>
<li><b>过载（7）</b> — 解锁最强能力。过载动量若开始衰减，所有动量会同时泄出，造成反噬、短暂减速与易伤。尽快释放！</li>
<li><b>满值（10）</b> — 释放终极能力的强化版本。</li>
<li><b>武器赋能</b> — 至少需要 5 点动量。消耗全部动量强化下次近战，突破招架与闪避。明显红光会警示敌人。冷却 30 秒，持续 8 秒。</li>
<li><b>奥术涌动</b> — 部分非终极能力命中至少 2 个目标时，额外获得 1 点动量。</li>
<li><b>精准</b> — 奥术打击与近战挥击采用相同的部位判定。技能及超过十点的感知都能改善落点。瞄准胸部的打击始终命中该部位。</li>
</ul>
</div>
<div class="preamble">
<p>噢！塔里凯亚之刃！</p>
<p>昔日有一座伟大的城，就在这座山脚下，俯瞰费伦提亚海。</p>
<p>城邦繁荣，勇士在其中磨砺技艺，将奥术与刀剑相融。</p>
<p>我们是大师！技艺无双！招式无匹！举世艳羡！</p>
<p>拉涅申刃舞者、风郡剑士、格伦泽霍夫佣兵，无人能与我们匹敌！</p>
<p>法师！骑士！恶魔！皆倒在我们的剑下。</p>
<p class="loud">随后——她升华了，一切尽失。</p>
<p class="loud">果真如此吗？</p>
<p>噢！费伦提亚之刃！</p>
<p class="closing">[preamble_closing]</p>
</div>
</div>
</body>
</html>
"}
	return html

/proc/get_blade_chant_text(faction, mob/living/carbon/human/H)
	switch(faction)
		if("blackoak")
			return {"<p><em>我是塔里凯亚之刃——费伦提亚，她重生的名！</em></p>
<p><em>以剑为律！以血为墨！</em></p>
<p><em>我击必中！我刃锋锐！</em></p>
<p><em>以十数斩，守护家园。</em></p>
<p><em>五百载，不屈服！</em></p>
<p><em>凭血与钢，再续五百载！</em></p>"}
		if("zizite")
			return {"<p><em>我是进步之刃。</em></p>
<p><em>女士庇佑我，知识赐予我。</em></p>
<p><em>无知识禁求，无真理不探。</em></p>
<p><em>以一斩，断绝无知。</em></p>
<p><em>停滞即死亡，而我拒绝死去。</em></p>
<p><em>她言即进步，我为其先驱。</em></p>"}
		if("noccite")
			return {"<p><em>我，诺克之刃！永沐光明。</em></p>
<p><em>智慧为向导，知识为兵刃。</em></p>
<p><em>无真理不窥，无奥秘不触。</em></p>
<p><em>以十数斩，劈开无知。</em></p>
<p><em>我刃锋锐，我思更锐！</em></p>
<p><em>他言即智慧，我为其选民。</em></p>"}
		if("almah")
			return {"<p><em>我是拉涅申之刃。</em></p>
<p><em>以剑为针，以敌为锦。</em></p>
<p><em>我步迅疾，我刃锋锐。</em></p>
<p><em>以百斩，拆解诸敌。</em></p>
<p><em>无畏！无阻！无双！</em></p>
<p><em>凭剑与魔法！贯彻我志！</em></p>"}
		if("undead")
			return {"<p><em>有人称道风郡！有人颂扬伊特鲁斯卡！</em></p>
<p><em>却无人可比塔里凯亚之刃！</em></p>
<p><em>不可征服！不可分割！不可战胜！</em></p>
<p><em>百斩之下，众敌尽伏！</em></p>
<p><em>纵使诸神，也无法阻挡我们！</em></p>
<p><em>以塔里凯亚之名，我们出鞘——</em></p>
<p><b>醒来。醒来。</b></p>"}
	return {"<p><em>我是费伦提亚之刃。</em></p>
<p><em>以剑为声，以战为诗。</em></p>
<p><em>我击必中，我刃锋锐。</em></p>
<p><em>以百斩，肃清国土之敌。</em></p>
<p><em>我身即兵，极艺为归。</em></p>
<p><em>蒙她恩典，我已出鞘。</em></p>"}

/proc/get_phalanx_chant_text(faction, mob/living/carbon/human/H)
	switch(faction)
		if("blackoak")
			return {"<p><em>我是塔里凯亚之刃——费伦提亚，她重生的名！</em></p>
<p><em>以战刃为律！以血为墨！</em></p>
<p><em>我击迅疾！我刃锋锐！</em></p>
<p><em>以十数斩，劈倒敌人。</em></p>
<p><em>五百载，不屈服！</em></p>
<p><em>凭血与钢，再续五百载！</em></p>"}
		if("zizite")
			return {"<p><em>我是进步之盾。</em></p>
<p><em>女士庇佑我，知识赐予我。</em></p>
<p><em>无知识禁求，无真理不探。</em></p>
<p><em>以一刺，贯穿停滞。</em></p>
<p><em>停滞即死亡，而我拒绝死去。</em></p>
<p><em>她言即进步，我为其先驱。</em></p>"}
		if("noccite")
			return {"<p><em>我，诺克之矛！永沐光明。</em></p>
<p><em>智慧为向导，知识为兵刃。</em></p>
<p><em>无真理不窥，无奥秘不触。</em></p>
<p><em>以十数刺，贯穿无知。</em></p>
<p><em>我矛迅疾，我思更捷！</em></p>
<p><em>他言即智慧，我为其选民。</em></p>"}
		if("almah")
			return {"<p><em>我是拉涅申之矛。</em></p>
<p><em>以矛为线，以战场为织机。</em></p>
<p><em>我步迅疾，我矛锋锐。</em></p>
<p><em>以百刺，令诸敌尽伏。</em></p>
<p><em>无畏！无阻！无双！</em></p>
<p><em>凭矛与魔法！贯彻我志！</em></p>"}
		if("undead")
			return {"<p><em>有人称道科罗迪亚基！有人颂扬弗尔达克南！</em></p>
<p><em>却无人可比塔里凯亚之方阵！</em></p>
<p><em>不可征服！不可撼动！不可穿透！</em></p>
<p><em>百刺之下，万物皆穿！</em></p>
<p><em>纵使诸神，也无法阻挡我们！</em></p>
<p><em>以塔里凯亚之名，我们进军——</em></p>
<p><b>醒来。醒来。</b></p>"}
	return {"<p><em>我是费伦提亚之盾。</em></p>
<p><em>以矛为臂，以责为锚。</em></p>
<p><em>我击必中，我矛及远。</em></p>
<p><em>以百刺，阻敌于外。</em></p>
<p><em>我身即兵，极艺为归。</em></p>
<p><em>蒙她恩典，我屹立不倒。</em></p>"}

/proc/get_macebearer_chant_text(faction, mob/living/carbon/human/H)
	switch(faction)
		if("blackoak")
			return {"<p><em>我是塔里凯亚之锤——费伦提亚，她重生的名！</em></p>
<p><em>以锤为律！以血为墨！</em></p>
<p><em>从不低头！从未止步！</em></p>
<p><em>以十数击，粉碎一切威胁家园之敌。</em></p>
<p><em>五百载，不屈服！</em></p>
<p><em>凭血与钢，再续五百载！</em></p>"}
		if("zizite")
			return {"<p><em>我是进步之锤。</em></p>
<p><em>女士庇佑我，知识赐予我。</em></p>
<p><em>无墙不破，无障不碎。</em></p>
<p><em>以一击，砸开停滞。</em></p>
<p><em>停滞即死亡，而我拒绝死去。</em></p>
<p><em>她言即进步，我为其战锤。</em></p>"}
		if("noccite")
			return {"<p><em>我，诺克之锤！永沐光明。</em></p>
<p><em>智慧为向导，知识为兵刃。</em></p>
<p><em>无真理不窥，无奥秘不触。</em></p>
<p><em>以十数击，粉碎无知。</em></p>
<p><em>我锤坚强，我志更坚！</em></p>
<p><em>他言即智慧，我为其选民。</em></p>"}
		if("almah")
			return {"<p><em>我是拉涅申之锤。</em></p>
<p><em>以锤为凿，以敌为碑。</em></p>
<p><em>我步稳健，我锤沉重。</em></p>
<p><em>以百击，令诸敌尽伏。</em></p>
<p><em>无畏！无阻！无双！</em></p>
<p><em>凭锤与魔法！贯彻我志！</em></p>"}
		if("undead")
			return {"<p><em>有人称道铁锤堡！有人颂扬格隆！</em></p>
<p><em>却无人可比塔里凯亚之勇士！</em></p>
<p><em>不可阻挡！不可摧毁！永不屈服！</em></p>
<p><em>百击之下，万物皆碎！</em></p>
<p><em>纵使诸神，也无法阻挡我们！</em></p>
<p><em>以塔里凯亚之名，我们冲锋——</em></p>
<p><b>醒来。醒来。</b></p>"}
	return {"<p><em>我是费伦提亚之锤。</em></p>
<p><em>以锤为言，以毁灭为句点。</em></p>
<p><em>从不低头！从未止步！</em></p>
<p><em>以百击，将诸敌碎为尘埃。</em></p>
<p><em>我身即兵，征服为归。</em></p>
<p><em>蒙她恩典，我将征服！</em></p>"}

/proc/get_preamble_closing(faction)
	switch(faction)
		if("blackoak")
			return "磨砺族人的传统！雪精灵虽已消逝，你们的传承却未断绝！身为最卓越、最长寿的种族，延续魔剑士的遗产正是你们的使命！五百年的武艺与奥术辉煌，再续五百年！"
		if("zizite")
			return "磨砺守护神赐予的知识！她升华之后，无知者仍固守旧道，而你的女神身陷囚笼。唯有教诲留存。她的追随者腐化堕落，追逐不死与白骨，忘却她亦是进步之主。你将亲执利刃，切开世界的伤口，将其灼净，让她的光芒透入！你是她的先驱。"
		if("noccite")
			return "磨砺守护神赐予的智慧！蒙他恩赐，你已窥见世界的真相。古城虽逝，他的教诲犹存。诺克赋予你掌握自身命运的力量：治愈伤者的奇迹，洞察隐秘的视野，以及击倒敌人的魔法。以你的剑开辟新路，让他的光辉指引前方！你是他的选民。"
		if("almah")
			return "磨砺族人的技艺！让本地人见识阿尔玛的赫赫凶名。为钱财或极致武艺挥剑。目的并不重要，只要你享受每一步舞姿，并让敌人在曲终时倒下。"
		if("undead")
			return "你曾是塔里凯亚之刃。你醒来，面对的却是……什么？没有大魔鬼，没有天穹帝国。你为何而战？为何挥刃？每一个动作，每一次劈砍，每一记突刺，都刻进了这副老骨头。曾经握持兵器的手如今只剩白骨。你为何而战？是古老邪恶唤醒了你，还是你只是迷失着醒来，已然死去，却不知为何保留了意志？你为何而战？你为何而战？你为何而战？"
	return "磨砺五个世纪的传统！莫让技艺随古城一同陨落！为正义、利益或极致武艺挥剑！除堕入异端外，没有哪条道路是错的！"
