// Economy 3 guidebook — Merchant chapters. Ported from Azure-Peak PR #7000
// (apsrc/main, code/modules/crafting/recipe_books/book_entries/treasury/merchant_chapters.dm)
// with content pared back to what Emerald Summit actually implements.
//
// AP's open_economy_guidebook() proc (which used AP's /datum/recipe_wiki multi-pane wiki UI)
// is intentionally NOT ported here - that system doesn't exist in ES. The ES-native
// replacement lives in economy_guidebook.dm in this same folder.
//
// Cut/rewritten vs AP:
//  - The Navigator: AP describes three variants (Public/Private/Smuggler) with per-machine
//    Crown-duty and Merchant-levy toggles and a Black Market saturation mechanic. ES's actual
//    navigator (code/modules/roguetown/roguemachine/merchant/navigator.dm) is a single legacy
//    machine type plus a /blackmarket subtype: no toggles, no per-machine tallies, a flat
//    "Guild's Tax" (SStreasury.queens_tax, or a hardcoded 70% on the blackmarket variant), and
//    items priced below 1m are still consumed (just unpaid), not refused outright. Rewritten to
//    describe the real machine.
//  - Goldface/Silverface: kept close to AP - the Secrets toggle, per-machine tariff tallies,
//    Harbor tab (hails/dock spots/cultural stock/merchant's levy), and Silverface's flat 50%
//    surcharge all match code/modules/roguetown/roguemachine/merchant/_goldface.dm exactly.
//    The Catalogs (Rosawood Arsenal, Anthraxi Armory) are real as of the wiring audit
//    (merchant/trade/merchant_catalog.dm); both unlock by merchant favor since neither has a
//    home kinship realm in this tree.
//  - Escrow/COMMISSIONER: matches AP tip - default percent_margin/flat_margin are 70%/5m on
//    both sides (code/modules/roguetown/roguemachine/escrow.dm).
//  - Rag Picker/Scrapper: kept. seed_budget defaults to 0 on the base type but both concrete
//    subtypes (scrapper.dm) set it to 50, matching AP's "50m starting budget" claim.
//  - Avisa Market Tab: AP describes a standalone Avisa newspaper interface. In ES, the
//    noticeboard's "help_market" button opens this very guidebook chapter (see
//    noticeboard.dm's ui_act "help_market" case) rather than a separate Avisa UI - rewritten to
//    describe the noticeboard's live Market view instead.

/datum/book_entry/treasury_merchant
	abstract_type = /datum/book_entry/treasury_merchant
	category = "Merchant"

/datum/book_entry/treasury_merchant/navigator
	name = "01. The Navigator"

/datum/book_entry/treasury_merchant/navigator/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>NAVIGATOR:</b> The heart of everyday commerce in [SSmapping.map_adjustment.realm_name]. This machine lifts sellable goods up by balloon roughly every two minutes.</p>

		<h3>How it works</h3>
		<ul>
			<li>Drop sellable items on the eight tiles surrounding the machine. A balloon arrives on a two-to-three minute timer and lifts everything sitting on its pads into the air.</li>
			<li>Anchored items, coins, and handcarts are skipped.</li>
			<li>Each lifted item's payout is its price, less the Guild's Tax (the realm's general tax rate). Items priced too low to clear a single mammon after tax are still lifted and lost - the machine does not refuse them outright.</li>
			<li>Clicking the Navigator shows the current Guild's Tax rate and the time to the next balloon.</li>
		</ul>

		<h3>The Suspicious (Black Market) Navigator</h3>
		<p>A separate variant found at the black market ruin skims a flat 70% off every lift instead of the Guild's Tax - "this is used at the navigator at the black market ruin, which rips you off." There is no per-machine duty toggle, tally, or Public/Private/Smuggler distinction on either variant in this build.</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/fulfillment_crate
	name = "02. 船舶履约货箱"

/datum/book_entry/treasury_merchant/fulfillment_crate/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>船舶履约货箱：</b>用于满足停泊外国船舶的大宗货物与补给需求的货箱。货款按停泊船舶对各项货物的报价计算，扣除王室出口关税及商人征缴后支付。</p>

		<h3>使用方法</h3>
		<ul>
			<li>你需要一个神经锁账户。货箱不会接收无账户者的货物。</li>
			<li><b>手持物品左键点击（或攻击）货箱：</b>交付该件物品。</li>
			<li><b>右键点击货箱：</b>一次性投入你所在格上的所有物品，完成后会公布总计。</li>
			<li>你所在格上的手推车和储物箱会被自动清点，货箱会逐件匹配其中的物品。</li>
			<li>已密封且酿制完成、可以装瓶的发酵桶，可直接拖到货箱上。</li>
		</ul>

		<h3>货箱接受什么</h3>
		<ul>
			<li><b>大宗货物：</b>通过贸易货物登记表识别的可交易原料或成品，须符合停泊船舶尚未满足的大宗需求。</li>
			<li><b>补给食品：</b>符合停泊船舶清单的成品菜肴和耐储食品，按物品的确切类型匹配。</li>
			<li><b>补给酒水：</b>符合船舶酒水需求的密封酿酒瓶；不收已开封的酒瓶，仅按桶收购的船舶则完全不收零散酒瓶。</li>
			<li><b>捆装材料</b>（如纤维、兽皮等可堆叠原料）最多收取该项需求的剩余数量，多余部分会留在原材料捆中。</li>
		</ul>

		<h3>货箱拒收什么</h3>
		<ul>
			<li>带有贸易公司封印的物品（从金面或银面购得的任何物品）。</li>
			<li>腐烂的食物。</li>
			<li>不在任何停泊船舶的待交付清单上的货物。</li>
		</ul>

		<h3>关税与商人抽成</h3>
		<p>商人或店伙计可以通过暗账开关，将这个货箱的王室出口关税切换为正常缴纳或逃避缴纳。物品品质高于或低于标准时，单价会相应上调或下调；享有同乡关系加成的船舶还会额外支付奖励（参见<i>同乡关系加成</i>）。</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/goldface
	name = "03. 金面与银面"

/datum/book_entry/treasury_merchant/goldface/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>金面与银面：</b>金面供商人自用；银面则是面向公众的版本，以加价出售相同货物。</p>

		<h3>金面</h3>
		<ul>
			<li>使用商人的钥匙（或装有该钥匙的钥匙圈）上锁与解锁。</li>
			<li>须手动投入钱币，再用余额购买货物。</li>
			<li>贸易公司成员（商人、店伙计）可以在秘密菜单中选择“停止缴税”，跳过进口关税。</li>
			<li>每台机器分别记录已缴及逃缴的关税，只有贸易公司成员可以查看。</li>
			<li>购得的物品带有贸易公司封印，无法通过领航员或船舶履约货箱再次出口。</li>
		</ul>

		<h3>港口页（金面专属）</h3>
		<p>金面是对外贸易的指挥中心。港口页显示停泊船舶、可呼叫的船舶，以及所有已发现国家的市场状况。呼船与需求机制详见<i>船舶、呼船与仓库</i>。</p>
		<ul>
			<li><b>文化货物：</b>停泊船舶携带各地特色商品包，价格比基础成本低[TRADE_CULTURAL_SHIP_DISCOUNT_PERCENT]%。除非逃税，否则仍需缴纳进口关税。</li>
			<li><b>大宗买卖与需求：</b>停泊船舶出售货物，也会加价大量收购货物，需求通常超过城镇独自能供应的数量。</li>
			<li><b>商人征缴：</b>商人或店伙计可以设定征缴比例（0至[TRADE_MERCHANT_LEVY_CAP_PERCENT]%）。船舶履约货箱从生产者货款中扣除的正是这项征缴。</li>
		</ul>

		<h3>银面（公共）</h3>
		<ul>
			<li>无法上锁，公共版本不接受钥匙。</li>
			<li>在基础成本与进口关税之外固定加收<b>[50]%</b>的附加费，使其相较金面更不划算，从而让生产者能够在价格上竞争。</li>
		</ul>
		</div>
	"}


/datum/book_entry/treasury_merchant/harbor_mechanics
	name = "04. 船舶、呼船与仓库"

/datum/book_entry/treasury_merchant/harbor_mechanics/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>港口机制：</b>商人负责呼船入港、与船舶买卖货物、积累恩惠，并遣送船舶离港。</p>

		<h3>呼船</h3>
		<ul>
			<li>每日有<b>[TRADE_SHIPS_HAIL_PER_DAY]</b>次呼船机会。每次可从候选船舶中招来一艘入港。</li>
			<li>船舶停泊<b>[TRADE_SHIP_SEND_AWAY_GRACE / 600]</b>分钟后即可遣离；若已达成其恩惠目标，则可立即遣离。</li>
			<li>码头默认可容纳<b>[TRADE_SHIP_DOCK_SPOTS_BASE]</b>艘船，花费恩惠租用额外泊位后，可增至<b>[TRADE_SHIP_DOCK_SPOTS_MAX]</b>艘。</li>
		</ul>

		<h3>饱和度</h3>
		<ul>
			<li>每个市场分类都有一个以玛门计量的仓储池。通过领航员出售货物或按需求采购货物，会使池中余额增加或减少。容量每回合重新随机生成，并随人口规模调整。</li>
			<li>仓储池装满后，该分类会停止收货，直至腾出空间。</li>
			<li>黑市另有独立的仓储池，容量仅为正常市场的一部分，每日自动恢复。</li>
		</ul>

		<h3>离港结算</h3>
		<p>每艘船入港时都有一个按吨位确定的预期恩惠目标。</p>
		<ul>
			<li><b>礼遇离港</b>（获得的恩惠达到或超过目标）：全额计入恩惠，并返还消耗的呼船次数。</li>
			<li><b>部分完成</b>（提前遣离或自动呼来的船舶）：获得较少恩惠，不返还呼船次数。</li>
			<li><b>失礼离港</b>（远低于目标时被自动遣离）：按吨位扣除固定数额的恩惠。</li>
		</ul>

		<h3>花费恩惠</h3>
		<p>积累的恩惠可用于解锁公司侏儒，接管银面加价收入；也可租用额外泊位，或启用自动呼船，让港口在你离开时自动招呼和遣离船舶。港口页可查看恩惠账簿、当前总额及历史最高总额。</p>
		<p>恩惠还可开通文化货物页上的两份专属外国目录：<b>玫瑰林军械库</b>（[ROSAWOOD_ARSENAL_FAVOR]恩惠），提供精灵武器与伊芙斯林物产；以及<b>安斯拉克西军械库</b>（[UNDERDARK_CARAVAN_FAVOR]恩惠），提供卓尔武器与蛛丝制品。两者库存有限，每日补货，照常征收进口关税。</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/kinship
	name = "05. 同乡关系加成"

/datum/book_entry/treasury_merchant/kinship/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>同乡关系加成：</b>与现任商人所选出身地相关的加成。来自某个外国的商人任职时，该国船舶会更频繁地出现，以更高价格收购，并以更低价格出售。</p>

		<h3>加成效果</h3>
		<ul>
			<li>向同乡船舶<b>购买时便宜[round((1 - KINSHIP_BUY_MULT) * 100)]%</b>，金面的大宗货物与文化商品包均可享受优惠。</li>
			<li>通过船舶履约货箱满足同乡国家船舶的大宗需求时，<b>售出货款增加[round((KINSHIP_SELL_MULT - 1) * 100)]%</b>。</li>
			<li>出售加成为<b>全局生效</b>，任何满足同乡船舶需求的生产者都能享受，而不仅是商人。</li>
		</ul>

		<h3>如何确定</h3>
		<ul>
			<li>加成取决于现任商人的角色出身。商人死亡或退场后，加成仍会保留，直至来自另一国家的新商人接任。</li>
			<li>同一国家的商人接任时，加成不会改变。</li>
		</ul>

		<h3>代理人的个人加成</h3>
		<p>店伙计或持有商人特许状的代理人，通过金面向<b>自己</b>角色出身地的船舶购买货物时，可享受个人折扣。若同一艘船同时适用全局同乡加成，两者不会叠加。</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/avisa_market
	name = "06. The Market on the Notice Board"

/datum/book_entry/treasury_merchant/avisa_market/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>MARKET VIEW:</b> The Notice Board carries a live Market view alongside its postings - the same view you're reading this guide from. It refreshes on demand and shows regional stockpile and trade conditions relevant to producers and traders.</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/escrow
	name = "07. 委托官"

/datum/book_entry/treasury_merchant/escrow/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>委托官：</b>任何人都可通过委托官发布锻造、工程或裁缝委托，款项由机器托管，直至公会成员交付成品。已发布的订单可以解除承接、取消、部分结算或拒绝。</p>

		<h3>发布订单（委托人）</h3>
		<ul>
			<li>向机器投入钱币，存款会记在你的名下。</li>
			<li>从目录中建立委托清单。每份配方的单价为材料成本乘以（1 + 比例加价/100），再加上固定加价；默认比例加价为<b>70%</b>，固定加价为<b>5m</b>，持有公会钥匙的人可以调整。</li>
			<li>尚未用于发布委托的存款随时可以取回。已发布但尚未被承接的订单可以取消，并获得全额退款。</li>
			<li>待接订单若在<b>[ESCROW_OPEN_EXPIRY_DAYS]</b>天内无人承接便会过期，款项会退回你的存款。</li>
		</ul>

		<h3>承接与交付（铁匠）</h3>
		<ul>
			<li>只有持有公会钥匙的人可以接单。</li>
			<li>将成品对着机器使用即可交付。物品耐久度必须至少为<b>[ESCROW_DURABILITY_FLOOR * 100]%</b>，且类型必须与要求完全一致。</li>
			<li>铁匠可以主动放弃接单，让订单恢复待接状态；已交付的物品会退回地面。</li>
			<li>已承接的订单若在<b>[ESCROW_CLAIM_EXPIRY_DAYS]</b>天内未完成，承接资格便会过期，订单自动恢复待接状态。</li>
		</ul>

		<h3>部分履约</h3>
		<p>若铁匠已交付部分但尚未交齐所需物品，可以进行部分结算，报酬按完成比例计算后再扣减<b>[ESCROW_PARTIAL_HAIRCUT_PERCENT]%</b>。剩余托管款项会退回委托人的存款。</p>

		<h3>公会钥匙权限</h3>
		<p>公会钥匙可以解锁以下功能：逐项编辑材料价格、调整比例加价和固定加价、设置每单物品上限、强制解除停滞订单的承接关系，以及说明理由后拒绝任何待接或已承接订单。</p>
		</div>
	"}


/datum/book_entry/treasury_merchant/rag_picker
	name = "08. The Scrapper"

/datum/book_entry/treasury_merchant/rag_picker/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>SCRAPPER:</b> A machine that pays coin immediately for scrap and cast-off materials it has been set up to accept. Bring it items matching its enabled material list and it weighs the offer and pays out from its own budget on the spot. It starts with a <b>50m</b> seed budget; once that runs dry, new mammon must be deposited before it can keep paying.</p>
		<p>The proprietor role for a given Scrapper sets its rates, enables or disables specific materials, and can adjust the machine as needed.</p>
		</div>
	"}
