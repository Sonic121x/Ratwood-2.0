// Economy 3 guidebook — Steward chapters. Ported from Azure-Peak PR #7000
// (apsrc/main, code/modules/crafting/recipe_books/book_entries/treasury/realm_chapters.dm)
// with content pared back to what Emerald Summit actually implements.
//
// History note: this guidebook was first ported with the Alderman/City Assembly and the whole
// blockade/defense-commission layer CUT, because ES had only stubs then. Both have since landed
// (SScity_assembly + assembly_warrant; Quest 2's factions + Grand Contract Ledger + blockade
// lifecycle), so chapters "02. The City Assembly" and "03. Defense and Blockades" were restored
// and now describe the real systems. The Crown-only "Crown Authority" title list (Clerk, Grand
// Duke, Hand, Marshal, Councillor, Prince/Princess) stays cut - ES keeps its 3-role roster.
//
// Cut/rewritten vs AP:
//  - Alderman weight in Regional Trade: ES models the Alderman as a warrant-holder (see the
//    City Assembly chapter), not as a stockpile-price setter, so AP's "the Alderman cannot
//    alter stockpile pricing" caveat is simply not applicable and stays out of Regional Trade.
//  - Standing (Auto) Imports: the essentials list is 7 goods in ES, not AP's 6 - grepped
//    code/controllers/subsystem/rogue/economy/auto_import.dm and found coal, wood, grain,
//    iron ore, hide, fur, and fat all seeded by default.
//
// Kept close to AP (real, matching systems - defines cross-checked against
// code/__DEFINES/banking.dm, code/__DEFINES/economy/*.dm, and the implementing .dm files):
//  - Regional Trade (import/export pricing, stockpile autoprice/autolimit, surplus exports):
//    code/controllers/subsystem/rogue/economy/economy.dm.
//  - Standing (Auto) Imports: code/controllers/subsystem/rogue/economy/auto_import.dm.
//  - Of Standing Orders: economy.dm's daily_tick()/instantiate_standing_order().
//  - Warehouse: GLOB.steward_export_machines consumers in economy.dm.
//  - Insolvency, Sequestration and Loans: code/modules/banking/bankruptcy.dm - every define
//    (TREASURY_ARREARS_LOAN, ATC_LOAN_*, BANKRUPTCY_*) matches AP's values exactly.
//  - Banditry: code/controllers/subsystem/rogue/economy/banditry_drain.dm - every define
//    matches AP's values exactly, and it fires once per game-day from SSeconomy.daily_tick().
//    The code comments flag it as "a placeholder until raid and siege content ships" - kept
//    that framing from AP's original text since it's still accurate.

/datum/book_entry/treasury_realm
	abstract_type = /datum/book_entry/treasury_realm
	category = "Steward"

/datum/book_entry/treasury_realm/budgets
	name = "01. 预算与职权"

/datum/book_entry/treasury_realm/budgets/inner_book_html(mob/user)
	return {"
		<div>
		<h3>王室金库</h3>
		<p>王室实际持有的玛门余额，用于支付工资、进口、押金及其他通过神经主支取的开销（务必锁好！）。税收、罚款、向神经主直接存款、出口及履行长期订单均可补充金库。</p>

		<h3>市民认捐</h3>
		<p>这是领地市民承诺提供的虚拟资金池，而非实际硬币。每天补充，金额由固定基础额度和活跃玩家人数决定。</p>

		<h3>宫廷总管与市政长老</h3>
		<p>宫廷总管长期掌管这两项资金。领地也可以通过城市议会选出一位<b>市政长老</b>（参见下一章）；在任期间，市政长老拥有议会另行授予的每日支出授权，分为贸易额度与防务额度。席位空缺时，两项资金均由宫廷总管独自负责。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/assembly
	name = "02. 城市议会与市政长老"

/datum/book_entry/treasury_realm/assembly/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>城市议会</b>是领地的平民院。议会召开会议，选出<b>市政长老</b>并划定其职权范围。可通过城镇公告板上的入口进入议事厅。</p>

		<h3>会议</h3>
		<p>首次会议在回合开始约<b>[ASSEMBLY_FIRST_SESSION_MINUTES]分钟</b>后结算，此后的每次会议均在<b>黎明</b>结算。每次会议会同时结算所有待决议案，随后开启下一次会议。若参与投票的不同市民少于<b>[ASSEMBLY_QUORUM_VOTERS]</b>人，本次会议即告流会，一切维持现状。</p>

		<h3>谁能投票</h3>
		<p>领地中凡非处于法外之徒身份的市民均可投票。票权依身份而定，市民阶层与地方名流比普通民众拥有更高的票权；取得公民权或居留权后，流动人口或农民的票权将提升至完整的市民阶层票权。</p>

		<h3>议案</h3>
		<ul>
			<li><b>选举</b> - 从已宣布参选者中选出下一任市政长老（每人可发布简短的竞选承诺），也可投票选择<b>席位空缺</b>，让职位保持无人担任。现任市政长老会自动列入连任候选名单。候选人不得是法外之徒，不得已受谴责，也不得是<b>商人</b>或<b>店员</b>（因其可直接操控贸易而被禁止参选；包括澡堂人员在内的其他职业均可参选）。席位属于<i>本人</i>，而非角色档案：一旦身亡、辞职或离开领地，席位便会空缺。</li>
			<li><b>贸易授权</b> - 投票授予市政长老每日<b>0、150、300、450、600、750或900</b>玛门的<b>贸易额度</b>。</li>
			<li><b>防务授权</b> - 投票授予每日<b>0、250、500、750或1000</b>市民认捐的<b>防务额度</b>。</li>
			<li><b>罢免</b> - 达到<b>[ASSEMBLY_RECALL_THRESHOLD_PCT]%</b>的多数支持即可罢免现任市政长老。</li>
			<li><b>谴责</b> - 达到<b>[ASSEMBLY_CENSURE_THRESHOLD_PCT]%</b>的特定多数支持即可罢免市政长老，<i>并</i>禁止其在本回合剩余时间内再次任职。</li>
		</ul>
		<p>额度表决会通过仍获足够支持的最高额度档位；若<b>反对</b>票权达到已投总票权的<b>[ASSEMBLY_NAE_VETO_PCT]%</b>或以上，授权即被否决，额度归零。</p>

		<h3>市政长老的授权</h3>
		<p>就任后，市政长老获得支出<b>授权</b>，其额度会在每次黎明恢复至获准的上限。<b>贸易额度</b>用于通过宫廷总管的界面代王室开展贸易；<b>防务额度</b>用于支付发布在大契约台账上的反封锁防务委托（参见<i>防务与封锁</i>）。未用完的额度不会结转至次日，失去或放弃席位则会立即清空授权额度。</p>

		<p><b>暂未启用：</b>本版本暂时禁用了议会自行征收人头税的权力，待防止逃税的规则完善后再行启用，因此目前议会无法征收人头税。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/defense
	name = "03. 防务与封锁"

/datum/book_entry/treasury_realm/defense/inner_book_html(mob/user)
	return {"
		<div>
		<p>敌对势力可以<b>封锁</b>地区商路。回合开始时会出现少量封锁（<b>[BLOCKADE_ROUNDSTART_COUNT_MIN]-[BLOCKADE_ROUNDSTART_COUNT_MAX]</b>处），此后几天还可能出现更多。只有足以围攻商路的强悍势力才能发起封锁，且只能出现在威胁程度足以容纳它们的地区，因此安定地区保持畅通，危险地区则未必。</p>

		<h3>封锁的代价</h3>
		<p>地区遭封锁期间，贸易受到限制：进口价格乘以<b>[BLOCKADE_IMPORT_MULT]</b>，出口收入乘以<b>[BLOCKADE_EXPORT_MULT]</b>。王室必须作出应对，封锁会持续到被打破为止。</p>

		<h3>打破封锁</h3>
		<p>王室，或使用议会<b>防务额度</b>的市政长老（参见<i>城市议会与市政长老</i>），可在大契约台账上发布<b>反封锁防务契约</b>。冒险者接下令状，击退围攻势力的一波波敌人后，道路便会重新开放。刚解除封锁的地区在<b>[BLOCKADE_RECLEAR_COOLDOWN]</b>天内不会再次遭到封锁。</p>

		<p>此外，威胁等级为<b>危险</b>或<b>凶险</b>的地区，无论是否遭到封锁，都会在每次黎明消耗王室金库资金，参见<i>匪患</i>。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/trade
	name = "04. 地区贸易"

/datum/book_entry/treasury_realm/trade/inner_book_html(mob/user)
	// Built from the live table so a map that swaps a region out doesn't advertise a county
	// it has no road to.
	var/list/region_names = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/ER = GLOB.economic_regions[region_id]
		if(ER?.name)
			region_names += ER.name
	return {"
		<div>
		<p>王室与[length(region_names)]个地区开展贸易：[english_list(region_names)]。通过神经主可进入贸易与库存界面。</p>

		<h3>贸易定价</h3>
		<ul>
			<li>每个地区都有特定货物的每日产量与需求量，数量随活跃玩家人数变化。</li>
			<li>购买量超过每日产量后，<b>进口</b>价格会急剧上涨。</li>
			<li>销售量超过每日需求量后，<b>出口</b>价格会急剧下降。</li>
			<li><b>出口</b>价格始终比对应的进口价格低<b>[IMPORT_EXPORT_SPREAD * 100]%</b>。同一天买入再转售必定亏损。</li>
			<li><b>封锁</b>生效时，进口价格乘以<b>[BLOCKADE_IMPORT_MULT]</b>，出口收入乘以<b>[BLOCKADE_EXPORT_MULT]</b>。</li>
			<li>每次点击进行贸易，最多交易<b>[TRADE_MAX_BULK_UNITS]</b>单位货物。</li>
		</ul>

		<h3>库存定价、自动定价与自动限额</h3>
		<p>每种库存货物有两种价格：<b>收购价</b>（王室支付给存入货物的玩家）和<b>出售价</b>（王室向取出货物的玩家收取）。采用<b>自动定价</b>时，价格跟随货物的全局参考价，使王室每笔交易都能赚取差价。宫廷总管可以手动改写任一种价格，使该项切换为<b>手动</b>模式。手动设定的价格会一直保持，直到恢复自动模式。</p>

		<h3>库存限额：自动与手动</h3>
		<p>每种库存货物都有每日限额，超过后再存入便不再获得报酬。限额根据各地区每日总需求量与人口计算，预留<b>[STOCKPILE_AUTO_LIMIT_DAYS]</b>天的余量；没有需求记录的货物，最低限额为<b>[STOCKPILE_LIMIT_MIN]</b>单位。宫廷总管可以手动改写限额，使该项切换为<b>手动</b>模式。</p>

		<h3>盈余出口</h3>
		<p>王室每天自动检查库存，将超过各货物盈余底线的部分出口至出价最高的地区，数量不超过该地区当天剩余需求量。自动检查会跳过手动定价的货物，这些货物需要自行手动出口。</p>

		<h3>进口与库存</h3>
		<p>地区进口货物进入王室库存，用于履行长期订单并供应整个城市的经济需求。宫廷总管可以设置<b>采购余额底线</b>：若进口会使金库余额低于底线，该笔进口便会被拒绝。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/auto_import
	name = "05. 长期（自动）进口"

/datum/book_entry/treasury_realm/auto_import/inner_book_html(mob/user)
	return {"
		<div>
		<p>王室可以在每次黎明自动进口必需货物，免去宫廷总管每天手动购入相同基础物资的麻烦。货物会一直保留在清单上，直到被移除。</p>

		<h3>必需货物</h3>
		<p>默认长期进口七种货物：<b>煤炭、木材、谷物、铁矿石、兽皮、毛皮和脂肪</b>。宫廷总管可在市场卷轴的自动进口页移除任一种货物，之后也可重新添加。其他可进口货物，只要存在仍在供应的生产地区，也可以加入长期进口。</p>

		<h3>规则</h3>
		<p>每次黎明，清单上的每种货物均按以下规则处理：</p>
		<ul>
			<li>若库存已有<b>[AUTO_IMPORT_FLOOR]</b>单位或更多，则不进行进口。</li>
			<li>否则，王室从价格最低的生产地区购买<b>[AUTO_IMPORT_BATCH]</b>单位。</li>
			<li>若任何一单位的价格超过货物基础价格的<b>[AUTO_IMPORT_MAX_PRICE_MULT]倍</b>，则跳过进口。</li>
			<li>若进口会使王室金库低于宫廷总管设定的余额底线，则跳过进口（默认<b>[AUTO_IMPORT_PURSE_FLOOR_DEFAULT]m</b>，可调整）。</li>
		</ul>

		<p>面板保留最近<b>[AUTO_IMPORT_HISTORY_DAYS]</b>天的记录。长期进口仅使用王室金库资金。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/standing_orders
	name = "06. 长期订单详解"

/datum/book_entry/treasury_realm/standing_orders/inner_book_html(mob/user)
	return {"
		<div>
		<h3>类型</h3>
		<ul>
			<li><b>常规</b>——每次黎明生成（基础数量为<b>[STANDING_ORDERS_BASE_PER_DAY]</b>份，并随活跃玩家人数增加），每天最多<b>[STANDING_ORDERS_MAX_PER_DAY]</b>份。有效期为<b>[STANDING_ORDER_DURATION]</b>天。每单位报酬为基础价格乘以<b>[1 + STANDING_ORDER_BASE_BONUS]</b>。</li>
			<li><b>紧急</b>——由短缺事件生成，同时最多存在<b>[STANDING_ORDERS_MAX_URGENT]</b>份。有效期一天，报酬更高。</li>
			<li><b>仓库</b>——用于成品（装备、药剂），从出口仓库结算，而非库存。</li>
		</ul>

		<h3>履行订单</h3>
		<p>库存订单：存入货物，在神经主处确认，报酬随即计入王室金库。仓库订单：自动与已登记的出口机器匹配。</p>

		<p><b>部分履行：</b>若现有货物价值达到订单公布价值的至少<b>[round(STANDING_ORDER_PARTIAL_THRESHOLD * 100)]%</b>，宫廷总管仍可结算。买家支付已交货部分价值的<b>[round(STANDING_ORDER_PARTIAL_PAYOUT_MULT * 100)]%</b>，未交货部分的报酬则作废。</p>

		<h3>上限</h3>
		<p>每个地区最多<b>[STANDING_ORDERS_MAX_PER_REGION]</b>份订单，整个领地最多<b>[STANDING_ORDERS_POOL_CAP]</b>份订单。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/warehouse
	name = "07. 仓库"

/datum/book_entry/treasury_realm/warehouse/inner_book_html(mob/user)
	return {"
		<div>
		<p>已登记的宫廷总管出口机器接受成品，用于履行标记为仓库类型的长期订单。</p>

		<h3>装备订单</h3>
		<p>检查时只接受完全相同的装备类型，不会消耗其子类型或变体。</p>

		<h3>药剂订单</h3>
		<p>按试剂种类与容量检查。任何装有正确试剂的容器都可计入，按顺序消耗，直到满足订单。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/insolvent
	name = "08. 无力偿付、财产扣押与贷款"

/datum/book_entry/treasury_realm/insolvent/inner_book_html(mob/user)
	return {"
		<div>
		<p>若王室在黎明无法从金库足额支付工资，便会陷入无力偿付状态。处理分阶段进行：首先提供无息垫款，随后可选择紧急贷款，若王室再次无法付款，最终会进入财产扣押。</p>

		<h3>首次欠薪：欠款</h3>
		<p>若王室金库无法支付当天工资，便会获得无息垫款，金额<b>至少为[TREASURY_ARREARS_LOAN]m，并可补足实际缺口</b>，以确保当天正常发薪。垫款会登记为<b>欠款</b>；在还清之前，所有流入王室金库的资金都会先用于偿还欠款，再计入余额。</p>

		<h3>紧急贷款</h3>
		<p>王室可在任意一天借入<b>[ATC_LOAN_MIN_AMOUNT]m至[ATC_LOAN_MAX_AMOUNT]m</b>，本金立即计入王室金库。利息为<b>[round(ATC_LOAN_INTEREST_RATE * 100)]%</b>，从金库收入中自动扣还。首笔贷款还清前，不可再借第二笔。借款会<b>取消欠款宽限</b>：贷款尚未还清时若无法发薪，王室将直接进入财产扣押。</p>

		<h3>再次欠薪：财产扣押</h3>
		<p>若王室连续第二次在黎明无法发薪（或尚有贷款未清时欠薪一次），领地便会进入<b>财产扣押</b>：</p>
		<ul>
			<li>王室金库重置为<b>[BANKRUPTCY_OPERATING_FLOOR]m</b>。超过底线的资金被没收，不足底线则补足。</li>
			<li>在原有欠款或贷款之外，另登记<b>[BANKRUPTCY_DEBT_FLAT]m</b>债务。</li>
			<li>暂停所有王室工资，直到财产扣押解除。</li>
			<li>所有可进口货物均加入长期进口；自动出口提高到库存限额的<b>[round(BANKRUPTCY_AUTOEXPORT_PERCENTAGE * 100)]%</b>。手动进出口及库存定价功能被禁用。</li>
		</ul>

		<h3>恢复运作</h3>
		<p>债务归零后，财产扣押解除，工资于次日恢复。王室金库获得<b>[BANKRUPTCY_RECOVERY_RESET]m</b>启动资金。同一回合内领地可能多次进入财产扣押，每次都会新增债务。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/banditry
	name = "09. 匪患"

/datum/book_entry/treasury_realm/banditry/inner_book_html(mob/user)
	return {"
		<div>
		<p>威胁等级为<b>危险</b>或<b>凶险</b>的地区，会在每次黎明消耗王室金库资金。</p>

		<h3>匪患损耗</h3>
		<p>每个地区在每次黎明造成以下损耗：</p>
		<ul>
			<li><b>危险</b>：基础[BANDITRY_DRAIN_DANGEROUS_FLAT]m，每位活跃玩家另加[BANDITRY_DRAIN_DANGEROUS_PER_PLAYER]m。</li>
			<li><b>凶险</b>：基础[BANDITRY_DRAIN_BLEAK_FLAT]m，每位活跃玩家另加[BANDITRY_DRAIN_BLEAK_PER_PLAYER]m。</li>
		</ul>

		<h3>余额底线与匪患债务</h3>
		<p>仅由匪患造成的损耗不会使王室金库低于<b>[BANDITRY_DEBT_FLOOR]m</b>。超过这条底线的损耗会成为<b>匪患债务</b>，不断累积为欠款，并从金库的所有收入中扣还，直到结清。</p>

		<h3>应对办法</h3>
		<p>地区威胁下降，黎明损耗也会随之减少。匪患债务只能通过获取新收入并扣还来减少。在更完整的突袭与围攻内容推出之前，黎明损耗是一项临时机制；它无法像封锁那样通过一次委托解除（参见<i>防务与封锁</i>），只有地区威胁长期降低，才能缓解损耗。</p>
		</div>
	"}
