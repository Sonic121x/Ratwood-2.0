// Economy 3 guidebook — Common chapters. Ported from Azure-Peak PR #7000
// (apsrc/main, code/modules/crafting/recipe_books/book_entries/treasury/general_chapters.dm)
// with content pared back to what Emerald Summit actually implements.
//
// Cut entirely vs AP (no corresponding ES system exists):
//  - Outlawry: AP's chapter is about losing Charter protection via the outlaw system; the
//    mechanical hooks (TRAIT_OUTLAW voids exemptions/caps) are real as of item 6, but ES has
//    no dedicated outlawry flow to document beyond the Titan's Declare Outlaw command.
//  - The Innkeeper and the Guild (Rumor contracts), Towner Contracts, The Grand Contract Ledger:
//    AP's Guild quest/contract-board economy (QUEST_*, RUMOR_*, GUILD_REFERRAL_FEE_PCT defines)
//    has no equivalent anywhere in ES's codebase - grepped for every define AP's text cites and
//    found none. Cutting rather than documenting a contract board that doesn't exist.
//  - Alderman & City Assembly: code/modules/roguetown/roguemachine/noticeboard/assembly_floor.dm
//    is an explicit compat stub ("Azure-Peak's assembly_floor.dm hosts a full Commons
//    democracy/governance TGUI ... that does not exist anywhere in Emerald Summit").
//
// Reworked vs AP (ES has a real but different implementation):
//  - Charters of the Realm: real as of the item 6 decree port (code/modules/politics/,
//    SStreasury.decrees) - chapter 00 below documents it. Decree names are localized to this
//    realm (Great Writ of the Vale etc.) and reskinned per map via decree_reskins.
//  - Taxation and Levies: per-category rates are set from the throne's "Set Taxes" TaxSetter
//    panel (Taxation 2 port); the Steward's "Adjust Taxes" verb opens the same panel when the
//    ruler is absent. The old flat Sales Tax is gone. Charter exemptions/caps are live.
//  - Fines: Golden Bull per-stroke cap + daily ceiling and the one-fine-per-day rule are real
//    as of item 6, on top of the general fine cap (GENERIC_RATE_CAP).
//  - Patronage: all three writs are real as of the Step 16 Nervelock Panel port
//    (code/modules/banking/patronage_writ.dm; TRAIT_AGENT_MERCHANT/BATHHOUSE/CHURCH,
//    PATRON_CAP_* in code/__DEFINES/banking.dm). Drafted from the NERVELOCK's Patronage tab.
//  - Mercenary Statue: only the public mercenary roster is real
//    (code/game/objects/structures/roguetown/talkstatue_mercenary.dm + talkstatue_tgui.dm).
//    No "wretch roster" hidden tab exists anywhere in ES - cut that whole section.
//  - Zadcote and Zadcage: ported in the Step 12 Zadcote port
//    (code/modules/roguetown/roguemachine/zadcote/) consuming the 1:1 defines in
//    code/__DEFINES/economy/zadcote.dm. Chapter 07 below documents it. The Stewardry's
//    crown-import restock channel landed with the Step 15 crown-imports port.
//
// Kept close to AP (real, matching systems):
//  - Supply and Demand (economic events): code/controllers/subsystem/rogue/economy/economy.dm +
//    code/__DEFINES/economy/internal_trade_and_quests.dm match AP's values exactly.
//  - Jolly Tax Evasion: both dodge paths are real - Goldface's "secrets" toggle
//    (upgrade_flags & UPGRADE_NOTAX) and the Ship Fulfillment Crate's toggle_duty.

/datum/book_entry/treasury_general
	abstract_type = /datum/book_entry/treasury_general
	category = "Common"

// Numbered 00 so it leads the shelf without renumbering the chapters below.
/datum/book_entry/treasury_general/charters
	name = "00. 王国宪章"

/datum/book_entry/treasury_general/charters/inner_book_html(mob/user)
	var/datum/decree/great_writ = SStreasury.get_decree(DECREE_GREAT_WRIT)
	var/great_writ_name = great_writ?.name || "谷地大宪章"

	var/datum/decree/golden_bull = SStreasury.get_decree(DECREE_GOLDEN_BULL)
	var/golden_bull_name = golden_bull?.name || "王田金玺诏书"

	var/datum/decree/guild_charter = SStreasury.get_decree(DECREE_GUILD_CHARTER_OF_ARMS)
	var/guild_charter_name = guild_charter?.name || "武备行会宪章"

	var/datum/decree/indenture_of_war = SStreasury.get_decree(DECREE_INDENTURE_OF_WAR)
	var/indenture_of_war_name = indenture_of_war?.name || "战争契约"
	return {"
		<div>
		<p>宪章保护各类臣民，使其免受王室的税收与征费。
		统治者与摄政者可在王座前说出<b>revise charter</b>，暂停或恢复宪章。公告板的宪章栏目会显示当前状态。免税仅适用于食首者征费等直接税，不适用于进出口关税等间接税。法外之徒失去一切宪章保护。</p>
		</div>

		<ul>
			<li><b>[great_writ_name]</b>——贵族免缴税收与征费，也不得被罚款。</li>
			<li><b>天顶城协约</b>——教会及获认定的教会恩主免缴税收与征费。协约生效期间，每笔应税交易的[round(CONCORDAT_TITHE_RATE * 100)]%作为什一税划入教会基金。</li>
			<li><b>奥塔瓦协定</b>——宗教裁判所免缴税收与征费。</li>
			<li><b>[golden_bull_name]</b>——市民每次征费或罚款不超过余额的[GOLDEN_BULL_BURGHER_CAP * 100]%，每笔罚款不超过[GOLDEN_BULL_DAILY_FINE_CAP]玛门，人头税上限为[GOLDEN_BULL_POLL_CAP]m。生效期间，市民每天补充市民认捐。</li>
			<li><b>诺克与佩斯特拉盟约</b>——大学成员、药剂师和宫廷医师适用最低的人头税，上限为[NOC_PESTRA_POLL_CAP]m，并由王室支付最低工资。</li>
			<li><b>[guild_charter_name]</b>——公会佣兵每日人头税上限为[GUILD_CHARTER_OF_ARMS_POLL_CAP]m，生效期间公会每天向市民认捐汇入[GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS]m。</li>
			<li><b>[indenture_of_war_name]</b>——生效期间，驻军各级成员享有最低工资保障。</li>
			<li><b>大宪章</b>——一份尚未启用的现代宪章；领主若敢施行，所有王室征费与人头税都会归零，罚款仍然保留。</li>
		</ul>

		<p>每份宪章修订后有[DECREE_COOLDOWN / 600]分钟冷却。每天最多宣布一次暂停及一次恢复。王室财产被扣押时，多数宪章会被强制暂停，直至王室债务结清。</p>
		</div>
	"}


/datum/book_entry/treasury_general/levies
	name = "01. 税收与征费"

/datum/book_entry/treasury_general/levies/inner_book_html(mob/user)
	return {"
		<div>
		<p>王室通过直接税与间接税获取收入。王国宪章（见第00章）生效期间，可为某些臣民提供免税或税额上限。</p>
		</div>

		<h3>税收类别</h3>
		<ul>
			<li><b>契约征费</b>——对契约报酬征收。</li>
			<li><b>食首者征费</b>——对直接喂给食首者的悬赏人头征收。</li>
			<li><b>进口关税</b>——对从银面、金面等商贸机器购买的货物征收。</li>
			<li><b>出口税</b>——对通过领航员或船舶履约箱出售的货物征收。</li>
			<li><b>罚款</b>——从臣民账户中扣除的一次性处罚。</li>
		</ul>

		<p>在王座前说出<b>"Set Taxes"</b>即可打开统治者税务面板，设置各类征费和人头税税率；两者各有独立的一天冷却。统治者不在王国内时，宫廷总管的<b>"Adjust Taxes"</b>动作可打开同一面板。天顶城协约生效期间，征费税率不得低于教会什一税税率。</p>

		<h3>人头税</h3>
		<p>每天向拥有银行账户的臣民自动扣缴人头税。类别按社会身份区分：贵族、神职人员、宗教裁判所、廷臣、驻军、公会、商人、市民、冒险者、佣兵和农民。人头税上限为<b>每天[POLL_TAX_MAX_RATE]m</b>，最低可设置为<b>每天-[POLL_TAX_MAX_SUBSIDY]m</b>的补贴（负税率会从王室金库向臣民付款）。</p>

		<p>未缴人头税会累积为欠税。欠税达到<b>[POLL_TAX_DEBT_DAYS_TO_DEBTOR]</b>天后，臣民将被标记为<b>赤贫</b>。欠税不意味着允许见面就杀或见面就打——应将其视为追讨或豁免债务的角色扮演机会，而非色情角色扮演规则的豁免。</p>
		</div>
	"}


/datum/book_entry/treasury_general/fines
	name = "02. 罚款"

/datum/book_entry/treasury_general/fines/inner_book_html(mob/user)
	return {"
		<div>
		<p>罚款会直接从臣民账户扣除指定金额，单次不超过当前余额的<b>[GENERIC_RATE_CAP * 100]%</b>，每天不得对同一臣民罚款超过一次。大宪章使贵族完全免受罚款，金玺诏书则降低市民的罚款上限（见第00章）；法外之徒不享有这些宽免。</p>
		<p>在王室管辖下开立账户即表示自愿接受罚款。反复或过度罚款应作为角色内问题处理，不应把机制当作保障。</p>
		</div>
	"}


/datum/book_entry/treasury_general/patronage
	name = "03. 恩主：令状与名册"

/datum/book_entry/treasury_general/patronage/inner_book_html(mob/user)
	return {"
		<div>
		<p>三个势力可以授予恩主资格。势力负责人（商人、夜主或主教/殉道者）可在<b>任意神经锁的恩主页</b>起草令状，并交给选定的人；持有人手持使用即可接受任命。同一页面也显示当前名册，负责人可以撤销其中的资格。</p>

		<ul>
			<li><b>特许状</b>（费伦提亚贸易公司，最多[PATRON_CAP_MERCHANT]名代理人） - 代理人获得市民居留权，即使本职工作不同，金面也会承认其权限：可浏览及购买港口页的文化货物，并代表商人呼船入港或遣船离港。代理人在购买时，与自身角色出身地的船舶享有个人同乡关系（参见<i>同乡关系加成</i>）。代理人无权使用市场、管理和账簿控制功能。</li>
			<li><b>澡堂信物</b>（最多[PATRON_CAP_BATHHOUSE]名代理人） - 代理人可以操作澡堂的扎德鸟舍。</li>
			<li><b>恩主授衔信</b>（教会，最多[PATRON_CAP_CHURCH]名恩主） - 将持有人认定为信仰之友。</li>
		</ul>

		<p>令状印出后若未被接受，将在两分钟后失效。签发人不能接受自己签发的令状；持有人已在名册上或名额已满时，也无法接受。</p>
		</div>
	"}


/datum/book_entry/treasury_general/supply
	name = "04. 供给与需求"

/datum/book_entry/treasury_general/supply/inner_book_html(mob/user)
	return {"
		<div>
		<p>经济事件持续<b>[ECON_EVENT_DURATION]</b>天，并公布在公告板的<b>经济事件</b>栏目中。</p>

		<ul>
			<li><b>短缺</b>——受影响货物价格暴涨。若现有紧急长期订单<b>少于[STANDING_ORDERS_MAX_URGENT]份</b>，便会针对受灾地区发布一份。达到上限后，短缺仍会推高价格，但不会生成紧急订单。</li>
			<li><b>供过于求</b>——受影响货物价格下降。</li>
		</ul>

		<h3>提前结束短缺</h3>
		<p>短缺无需持续满<b>[ECON_EVENT_DURATION]</b>天。王室向有需求地区<b>出口</b>的每一单位受影响货物，都会计入救济进度。</p>

		<p>累计交货量达到受影响货物平均库存上限的<b>[round(ECON_EVENT_SATURATION_MULT * 100)]%</b>后，短缺立即结束：价格恢复正常，传讯网会宣布救济完成。</p>
		</div>
	"}


/datum/book_entry/treasury_general/tax_evasion
	name = "05. 快乐逃税"

/datum/book_entry/treasury_general/tax_evasion/inner_book_html(mob/user)
	return {"
		<div>
		<p>有两种可用的逃税开关，两者都有风险：</p>

		<ul>
			<li><b>金面的秘密菜单</b>——费伦提亚贸易公司成员（商人、店员）可切换“停止纳税”，跳过购买货物的进口关税。每台机器分别记录已缴与逃缴关税，仅公司成员可见。</li>
			<li><b>船舶履约箱的暗账开关</b>——商人或店员可在该箱上切换王室出口税为已缴或逃缴。每台机器分别统计逃缴税额。</li>
		</ul>

		<p>逃税者自行承担被王室发现与处罚的风险。王室没有自动审计工具，只能猜测与指控，无论是否有证据。</p>
		</div>
	"}


/datum/book_entry/treasury_general/mercenary_statue
	name = "06. 佣兵雕像"

/datum/book_entry/treasury_general/mercenary_statue/inner_book_html(mob/user)
	return {"
		<div>
		<p>佣兵雕像是一座传话雕像，让镇民联系已登记、可供雇用的佣兵。</p>

		<ul>
			<li>佣兵在雕像处登记，并切换状态：可雇用、已有契约、请勿打扰。</li>
			<li>任何人都可打开雕像，浏览名册，并给已登记佣兵发送私信。请勿打扰状态的收件人不会出现在选择列表中。</li>
			<li>发送者也可一次向所有可雇用佣兵广播消息。</li>
			<li>每对发送者与收件人有独立冷却以防刷屏，广播另有独立冷却。</li>
			<li>消息会被记录。发送者须站在雕像旁发送，佣兵可简单答复接受或拒绝，也可表示兴趣。</li>
		</ul>
		</div>
	"}


/datum/book_entry/treasury_general/zadcote
	name = "07. 扎德鸟舍与鸟笼"

/datum/book_entry/treasury_general/zadcote/inner_book_html(mob/user)
	return {"
		<div>
		<p>扎德鸟舍用于向绑定的鸟笼递送消息、包裹，心怀恶意者也可递送瓶装炸弹。每座鸟舍只隶属王室、费伦提亚贸易公司或澡堂中的一个势力，并只接受该势力的命令。</p>

		<p>鸟笼可放在背包内、随身携带或置于地上，扎德鸟都能可靠地找到它。每座鸟舍生成时会自动附带绑定的鸟笼。</p>

		<h3>绑定鸟笼</h3>
		<p>用未绑定鸟笼触碰鸟舍，即可绑定到[ZADCOTE_SLOT_CAP]个槽位之一。鸟舍操作者可在界面中重命名槽位。绑定会持续到操作者解除，持笼者无法自行解除。若扎德鸟飞行时解除槽位，它会完成当前行程后再断开绑定。</p>

		<h3>载荷等级</h3>
		<p>每次派遣可选择出动多少只扎德鸟。它们可在携带载荷的同时递送消息：</p>
		<ul>
			<li><b>1只扎德鸟</b>——一件小型物品。</li>
			<li><b>2只扎德鸟</b>——一件中型（普通）物品或一个小袋。</li>
			<li><b>3只扎德鸟</b>——一件大型或笨重物品，或一个容器。</li>
		</ul>

		<h3>飞行时间与折返</h3>
		<p>派出的鸟队约一分钟抵达鸟笼。若鸟笼届时已被摧毁，鸟队会带着完好载荷折返。绑定鸟笼即使无人携带，递送仍会完成；鸟舍会鸣响，告知操作者该鸟笼无人看管。</p>

		<h3>回复时限</h3>
		<p>扎德鸟落地后，持笼者有三分钟写回复并放入返程载荷。三分钟后鸟会自行起飞。返程容量与派遣容量相同。<b>自动起飞不会携带消息或包裹。</b>最后30秒的倒计时会变红。</p>

		<h3>损耗与鸟群补充包</h3>
		<p>返程扎德鸟有小概率因疲劳或伤害而损失。投送瓶装炸弹是<b>单程</b>任务，出动的鸟无法回收。势力可通过供应机器购买训练扎德鸟补充包：贸易公司使用金面，澡堂使用铜面，总管府通过神经主宰的王室进口渠道购买。用补充包触碰鸟舍，即可补入[ZADPACK_BUNDLE_SIZE]只扎德鸟。</p>

		<h3>召唤</h3>
		<p>持笼者可主动从绑定鸟舍召唤扎德鸟，以便主动回寄消息或包裹。若鸟量不足，或认为持笼者滥用此功能，鸟舍所有者可关闭召唤。</p>

		<h3>投弹！</h3>
		<p>鸟舍可递送瓶装炸弹，每次最多三枚，每五分钟只能派出一次。持笼者会看到鸟下方悬挂的炸弹，有时间丢下或扔出鸟笼，甚至可借此攻击不喜欢的人。管理员日志会记录每次投弹的发送者、接收者和爆炸地点。</p>

		<h3>窥视（仅贸易公司与澡堂）</h3>
		<p>商人与浴场主管的鸟舍可通过鸟笼上的绑定扎德鸟窥视。窥视消耗鸟舍自身储存的少量<b>窥视基金</b>。直接投入任意面额硬币即可充值，每次窥视扣除[ZAD_VOYEUR_COST_MAMMON]玛门。持笼者会感觉奥术能量涌动，鸟笼在窥视期间发蓝光。视野持续三分钟，足以确认持笼者安全，也足以惹麻烦。宫廷总管与王室无法通过鸟舍窥视，必须依靠宫廷法师的专业窥视术。</p>

		<h3>备用鸟笼与扎德鸟</h3>
		<p>备用鸟笼可从势力进口机器购买，每个[ZADCOTE_NEW_CAGE_COST_MAMMON]玛门。训练扎德鸟以每包[ZADPACK_BUNDLE_SIZE]只出售。</p>
		</div>
	"}
