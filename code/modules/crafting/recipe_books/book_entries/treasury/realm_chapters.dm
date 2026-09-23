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
	name = "01. Budgets and Authority"

/datum/book_entry/treasury_realm/budgets/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Crown's Purse</h3>
		<p>The Crown's actual mammon balance. Used to pay wages, imports, deposits, and any other expenditure drawn through the Nerve Master (KEEP IT LOCKED!). Replenished by taxes, fines, direct deposit into the Nerve Master, exports, and fulfilling standing orders.</p>

		<h3>Burgher Pledge</h3>
		<p>Not actual coin, but a virtual pool pledged by the Burghers of the realm. It refills daily, scaling with a flat base and the active player count.</p>

		<h3>总管家与市政长老</h3>
		<p>总管家长期掌管这两项资金。领地也可以通过城市议会选出一位<b>市政长老</b>（参见下一章）；在任期间，市政长老拥有议会另行授予的每日支出授权，分为贸易额度与防务额度。席位空缺时，两项资金均由总管家独自负责。</p>
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
		<p>就任后，市政长老获得支出<b>授权</b>，其额度会在每次黎明恢复至获准的上限。<b>贸易额度</b>用于通过总管家的界面代王室开展贸易；<b>防务额度</b>用于支付发布在大契约台账上的反封锁防务委托（参见<i>防务与封锁</i>）。未用完的额度不会结转至次日，失去或放弃席位则会立即清空授权额度。</p>

		<p><b>暂未启用：</b>本版本暂时禁用了议会自行征收人头税的权力，待防止逃税的规则完善后再行启用，因此目前议会无法征收人头税。</p>
		</div>
	"}


/datum/book_entry/treasury_realm/defense
	name = "03. Defense and Blockades"

/datum/book_entry/treasury_realm/defense/inner_book_html(mob/user)
	return {"
		<div>
		<p>A region's trade road can be <b>blockaded</b> by a hostile faction. A handful stand up at round start (<b>[BLOCKADE_ROUNDSTART_COUNT_MIN]-[BLOCKADE_ROUNDSTART_COUNT_MAX]</b>), and more may fall upon the realm on later days. Only factions fierce enough to besiege a road can raise one, and only in regions whose threat is high enough to harbour them - so tame regions stay open and dangerous ones do not.</p>

		<h3>The Bite</h3>
		<p>While a region is blockaded its trade is throttled - Import Price x<b>[BLOCKADE_IMPORT_MULT]</b>, Export Revenue x<b>[BLOCKADE_EXPORT_MULT]</b> - and the Crown is called to answer it. The blockade holds until it is broken.</p>

		<h3>Breaking a Blockade</h3>
		<p>王室，或使用议会<b>防务额度</b>的市政长老（参见<i>城市议会与市政长老</i>），可在大契约台账上发布<b>反封锁防务契约</b>。冒险者接下令状，击退围攻势力的一波波敌人后，道路便会重新开放。刚解除封锁的地区在<b>[BLOCKADE_RECLEAR_COOLDOWN]</b>天内不会再次遭到封锁。</p>

		<p>Separately, a region's <b>Dangerous</b> or <b>Bleak</b> threat classification drains the Crown's Purse every dawn on its own, whether or not a blockade stands - see <i>Banditry</i>.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/trade
	name = "04. Regional Trade"

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
		<p>The Crown trades with [length(region_names)] regions: [english_list(region_names)]. Trade and Stockpile interfaces are accessed through the Nerve Master.</p>

		<h3>Trade Pricing</h3>
		<ul>
			<li>Each region has daily production and demand for specific goods. Volumes scale with active player count.</li>
			<li><b>Import</b> price rises sharply once purchases exceed daily production.</li>
			<li><b>Export</b> price falls sharply once sales exceed daily demand.</li>
			<li><b>Export</b> price is always <b>[IMPORT_EXPORT_SPREAD * 100]%</b> less than the matching import price. Buying and re-selling on the same day is always a loss.</li>
			<li><b>Blockade</b> (when one manages to stand): Import Price x<b>[BLOCKADE_IMPORT_MULT]</b>, Export Revenue x<b>[BLOCKADE_EXPORT_MULT]</b>.</li>
			<li>Each trade action is capped at <b>[TRADE_MAX_BULK_UNITS]</b> units per click.</li>
		</ul>

		<h3>Stockpile Pricing, Autoprice and Autolimit</h3>
		<p>Each stockpiled good has two prices: a <b>buy price</b> (Crown pays the depositing player) and a <b>sell price</b> (Crown charges the withdrawing player). On <b>Autoprice</b>, prices peg to the good's global reference so the Crown always profits a margin per transaction; the Steward may override either price by hand, which switches the entry to <b>Manual</b>. Manual entries hold whatever the Steward set until restored to Auto.</p>

		<h3>Stockpile Limit - Auto and Manual</h3>
		<p>Each stockpile entry has a per-day limit beyond which deposits no longer pay, computed from total daily demand across all regions, scaled by population, with <b>[STOCKPILE_AUTO_LIMIT_DAYS]</b> days of headroom and a <b>[STOCKPILE_LIMIT_MIN]</b>-unit floor for goods with no demand line. The Steward may override by hand, flipping the entry to <b>Manual</b>.</p>

		<h3>Surplus Exports</h3>
		<p>Stock above a per-good surplus floor is cleared by the Crown's daily auto-export sweep to the highest-paying region, capped at that region's remaining daily demand. Manual-priced entries are skipped by the sweep - hand-export those yourself.</p>

		<h3>Imports and the Stockpile</h3>
		<p>Regional imports enter the Crown's stockpile and feed standing orders and the city's economy at large. The Steward may set a <b>purchase floor</b>: imports are refused when they would drop the Purse below it.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/auto_import
	name = "05. Standing (Auto) Imports"

/datum/book_entry/treasury_realm/auto_import/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown may auto-import essential goods each dawn, sparing the Steward from manually re-importing the same basics every day. Goods stay on the list until removed.</p>

		<h3>Essentials</h3>
		<p>Seven goods are on standing import by default: <b>coal, wood, grain, iron ore, hide, fur, and fat</b>. The Steward may remove any of them from the Market Scroll's Auto-Import tab and re-add them later. Any other importable good with an active producing region can also be placed on standing import.</p>

		<h3>Rules</h3>
		<p>Each dawn, for each good on the list:</p>
		<ul>
			<li>If the stockpile already holds <b>[AUTO_IMPORT_FLOOR]</b> or more units, no import is made.</li>
			<li>Otherwise, the Crown buys <b>[AUTO_IMPORT_BATCH]</b> units from the cheapest producing region.</li>
			<li>The import is skipped if any unit would cost more than <b>[AUTO_IMPORT_MAX_PRICE_MULT]x</b> the good's base price.</li>
			<li>The import is skipped if it would drop the Crown's Purse below the Steward's purse floor (default <b>[AUTO_IMPORT_PURSE_FLOOR_DEFAULT]m</b>, adjustable).</li>
		</ul>

		<p>The panel retains the last <b>[AUTO_IMPORT_HISTORY_DAYS]</b> days of activity. Standing imports draw from the Crown's Purse only.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/standing_orders
	name = "06. Of Standing Orders"

/datum/book_entry/treasury_realm/standing_orders/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Types</h3>
		<ul>
			<li><b>Regular</b> - rolled each dawn (<b>[STANDING_ORDERS_BASE_PER_DAY]</b> base, plus more per active player), capped at <b>[STANDING_ORDERS_MAX_PER_DAY]</b>/day. <b>[STANDING_ORDER_DURATION]</b>-day lifespan. Payout: base x<b>[1 + STANDING_ORDER_BASE_BONUS]</b> per unit.</li>
			<li><b>Urgent</b> - spawned by shortage events, capped at <b>[STANDING_ORDERS_MAX_URGENT]</b> standing at a time. One-day lifespan, higher payout.</li>
			<li><b>Warehouse</b> - for finished goods (equipment, potions). Settled from the export warehouse, not the stockpile.</li>
		</ul>

		<h3>Fulfillment</h3>
		<p>Stockpile orders: deposit goods, confirm at the Nerve Master, payout minted to the Crown's Purse. Warehouse orders: matched automatically against registered export machines.</p>

		<p><b>Partial fulfillment:</b> if the on-hand goods cover at least <b>[round(STANDING_ORDER_PARTIAL_THRESHOLD * 100)]%</b> of an order's posted value, the Steward may settle it anyway. The buyer pays <b>[round(STANDING_ORDER_PARTIAL_PAYOUT_MULT * 100)]%</b> of the delivered share's value and the missing share is forfeit.</p>

		<h3>Limits</h3>
		<p>Max <b>[STANDING_ORDERS_MAX_PER_REGION]</b> orders per region. Max <b>[STANDING_ORDERS_POOL_CAP]</b> orders in the realm.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/warehouse
	name = "07. Warehouse"

/datum/book_entry/treasury_realm/warehouse/inner_book_html(mob/user)
	return {"
		<div>
		<p>Registered Steward export machines accept finished goods that fulfill warehouse-tagged standing orders.</p>

		<h3>Equipment Orders</h3>
		<p>Swept for exact-type match. Subtypes and variants are not consumed.</p>

		<h3>Potion Orders</h3>
		<p>Swept by reagent and volume. Any container holding the right reagent counts, consumed from the top until the order is met.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/insolvent
	name = "08. Insolvency, Sequestration and Loans"

/datum/book_entry/treasury_realm/insolvent/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown becomes insolvent if it fails to meet payroll from the Crown's Purse at dawn. Insolvency triggers in stages: first an interest-free advance, then an optional emergency loan, and finally sequestration if the Crown fails again.</p>

		<h3>First Failure - Arrears</h3>
		<p>If the Crown's Purse cannot meet the day's wages, an advance of <b>at least [TREASURY_ARREARS_LOAN]m, up to the actual shortfall</b>, is issued without interest. Wages pay normally for the day. The advance is registered as <b>arrears</b>; until settled, every coin of inflow into the Crown's Purse is skimmed against it before reaching the balance.</p>

		<h3>The Emergency Loan</h3>
		<p>On any day, the Crown may draw a loan for <b>[ATC_LOAN_MIN_AMOUNT]m to [ATC_LOAN_MAX_AMOUNT]m</b>. The principal is paid into the Crown's Purse immediately. Interest is <b>[round(ATC_LOAN_INTEREST_RATE * 100)]%</b>, repaid silently from skimmed inflow. No second loan may be drawn until the first is settled. Drawing the loan <b>forfeits the arrears grace</b>: missing payroll while the loan is outstanding sends the Crown directly to sequestration.</p>

		<h3>Second Failure - Sequestration</h3>
		<p>If the Crown misses payroll on a second consecutive dawn (or once with an outstanding loan), the realm enters <b>sequestration</b>:</p>
		<ul>
			<li>Crown's Purse is reset to <b>[BANKRUPTCY_OPERATING_FLOOR]m</b>. Anything above the floor is forfeit; anything below is topped up.</li>
			<li>A debt of <b>[BANKRUPTCY_DEBT_FLAT]m</b> is registered on top of any existing arrears or loan debt.</li>
			<li>All Crown salaries are suspended until sequestration lifts.</li>
			<li>Every importable good is placed on standing import; auto-export ratchets to <b>[round(BANKRUPTCY_AUTOEXPORT_PERCENTAGE * 100)]%</b> of stockpile limit. Manual import/export and stockpile pricing controls are disabled.</li>
		</ul>

		<h3>Recovery</h3>
		<p>When the debt reaches zero, sequestration lifts. Salaries resume the next day. The Crown's Purse is seeded with <b>[BANKRUPTCY_RECOVERY_RESET]m</b>. The realm may enter sequestration multiple times in the same round - each declaration adds fresh debt.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/banditry
	name = "09. Banditry"

/datum/book_entry/treasury_realm/banditry/inner_book_html(mob/user)
	return {"
		<div>
		<p>Regions classified as <b>Dangerous</b> or <b>Bleak</b> drain the Crown's Purse each dawn.</p>

		<h3>Banditry Drain</h3>
		<p>Per region, per dawn:</p>
		<ul>
			<li><b>Dangerous</b>: [BANDITRY_DRAIN_DANGEROUS_FLAT]m base + [BANDITRY_DRAIN_DANGEROUS_PER_PLAYER]m per active player.</li>
			<li><b>Bleak</b>: [BANDITRY_DRAIN_BLEAK_FLAT]m base + [BANDITRY_DRAIN_BLEAK_PER_PLAYER]m per active player.</li>
		</ul>

		<h3>The Floor and Banditry Debt</h3>
		<p>Banditry alone will not reduce the Crown's Purse below <b>[BANDITRY_DEBT_FLOOR]m</b>. Anything beyond that becomes <b>banditry debt</b> - an accruing arrears that skims every coin of treasury inflow until paid.</p>

		<h3>What You Can Do</h3>
		<p>As regional threat falls, so does the dawn drain. Banditry debt only shrinks as new income is earned and skimmed. This dawn drain is a placeholder until fuller raid and siege content ships; unlike a blockade (see <i>Defense and Blockades</i>), it cannot be lifted by a single commission - only a lasting fall in the region's threat will ease it.</p>
		</div>
	"}
