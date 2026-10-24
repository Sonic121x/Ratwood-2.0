/proc/get_spellfist_chant_html(datum/caller, mob/living/carbon/human/H)
	var/html = {"<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
body {
	background-color: #1a1410;
	color: #d4c4a0;
	font-family: Georgia, 'Times New Roman', serif;
	margin: 0;
	padding: 20px;
}
.chant-container {
	max-width: 600px;
	margin: 0 auto;
	text-align: center;
}
h2 {
	color: #c9a96e;
	font-size: 20px;
	letter-spacing: 3px;
	text-transform: uppercase;
	border-bottom: 1px solid #8b7355;
	padding-bottom: 10px;
	margin-bottom: 25px;
}
.chant-text p {
	font-size: 12px;
	line-height: 1.7;
	margin: 3px 0;
}
.chant-text em {
	color: #e0d0b0;
}
.abilities {
	text-align: left;
	border-top: 1px solid #5a4a30;
	padding-top: 12px;
	margin-top: 15px;
}
.abilities h4 {
	color: #a08050;
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
	color: #b0a080;
}
.abilities li b {
	color: #d4c4a0;
}
.shared-info {
	background: #2a2015;
	border: 1px solid #5a4a30;
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
	color: #b0a080;
}
.shared-list li b {
	color: #d4c4a0;
}
.shared-info h4 {
	color: #a08050;
	font-size: 11px;
	letter-spacing: 1px;
	text-transform: uppercase;
	margin: 0 0 5px 0;
}
.sidearm-row {
	display: flex;
	gap: 10px;
	margin-top: 15px;
}
a.choose-btn {
	flex: 1;
	display: block;
	padding: 10px 15px;
	background: #3a2a15;
	border: 1px solid #8b7355;
	border-radius: 3px;
	color: #c9a96e;
	text-decoration: none;
	font-family: Georgia, serif;
	font-size: 13px;
	letter-spacing: 1px;
	text-align: center;
}
a.choose-btn:hover {
	background: #4a3a20;
	border-color: #c9a96e;
	color: #e0d0b0;
}
</style>
</head>
<body>
<div class="chant-container">
<h2>拳之道</h2>
<div class="chant-text">
<p><em>我是普赛顿之拳——祂意志的具现。</em></p>
<p><em>我身即兵！我志如焰！</em></p>
<p><em>拳所不及，才智取胜。</em></p>
<p><em>魔法不济，双拳回应。</em></p>
<p><em>人类！恶魔！野兽！皆将伏倒！</em></p>
<p><em>以祂之名，我出击！</em></p>
</div>
<div class="abilities">
<h4>能力</h4>
<ul>
<li><b>普赛顿之拳</b> — 最远 5 步的定点 3x3 砸地，造成 40 点钝伤。动量达到 3 点时，消耗 3 点使伤害翻倍至 80。</li>
<li><b>普赛顿之握</b> — 定点范围拉扯，将敌人拉向你。动量达到 3 点时，消耗 3 点额外造成 40 点钝伤。</li>
<li><b>普赛顿风暴</b> — 跃向远处目标，释放连击风暴。需要 7 点动量：3 拳加 1 脚；10 点时：9 拳加 1 脚。无法招架或闪避，只有防御姿态能打断。消耗全部动量。</li>
<li><b>武器赋能</b> — 至少需要 5 点动量。消耗全部动量强化下次近战，突破招架与闪避。冷却 30 秒。</li>
</ul>
</div>
<div class="shared-info" style="text-align: left;">
<h4 style="text-align: center;">奥术动量</h4>
<ul class="shared-list">
<li><b>积累</b> — 对活物的徒手打击与徒手武器攻击，每 2 秒提供 1 点动量。</li>
<li><b>消耗</b> — 之拳与之握消耗 3 点施放强化版本。风暴至少需要 7 点。</li>
<li><b>衰减</b> — 最后一次打击 10 秒后开始衰减，每 6 秒失去 1 层。</li>
<li><b>打断</b> — 倒地或眩晕会失去全部动量。</li>
<li><b>过载（7+）</b> — 可以施放普赛顿风暴。过载动量若开始衰减，所有动量同时泄出，造成反噬、短暂减速与易伤。</li>
<li><b>满值（10）</b> — 普赛顿风暴完全强化：9 拳加 1 脚。</li>
</ul>
</div>
<div class="sidearm-row">
<a class="choose-btn" href='?src=\ref[caller];sidearm=katar'>拳剑</a>
<a class="choose-btn" href='?src=\ref[caller];sidearm=knuckledusters'>指虎</a>
</div>
</div>
</body>
</html>
"}
	return html
