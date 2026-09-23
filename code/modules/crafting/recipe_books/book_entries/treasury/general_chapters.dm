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
	name = "00. Charters of the Realm"

/datum/book_entry/treasury_general/charters/inner_book_html(mob/user)
	var/datum/decree/great_writ = SStreasury.get_decree(DECREE_GREAT_WRIT)
	var/great_writ_name = great_writ?.name || "The Great Writ of the Vale"

	var/datum/decree/golden_bull = SStreasury.get_decree(DECREE_GOLDEN_BULL)
	var/golden_bull_name = golden_bull?.name || "The Golden Bull of Kingsfield"

	var/datum/decree/guild_charter = SStreasury.get_decree(DECREE_GUILD_CHARTER_OF_ARMS)
	var/guild_charter_name = guild_charter?.name || "The Guild Charter of Arms"

	var/datum/decree/indenture_of_war = SStreasury.get_decree(DECREE_INDENTURE_OF_WAR)
	var/indenture_of_war_name = indenture_of_war?.name || "The Indenture of War"
	return {"
		<div>
		<p>Charters protect classes of subject from the Crown's taxation and levies.
		The Ruler and Regent may suspend or restore a Charter, at the throne, by speaking <b>revise charter</b>. State is shown on the Charters section of the Notice Board. Note that tax exemption only applies to direct taxation like the Headeater Levy, not indirect taxation like Import or Export tariffs. Outlaws forfeit every Charter protection.</p>
		</div>

		<ul>
			<li><b>[great_writ_name]</b> - Nobility pays no tax and levy, and cannot be fined.</li>
			<li><b>The Zenitstadt Concordat</b> - The Church, and any declared benefactors of the Church, pays no taxation and levy. While in force, [round(CONCORDAT_TITHE_RATE * 100)]% of every taxed transaction is tithed to the Church Fund.</li>
			<li><b>The Otavan Accords</b> - The Inquisition pays no tax and no levy.</li>
			<li><b>[golden_bull_name]</b> - burghers are capped at [GOLDEN_BULL_BURGHER_CAP * 100]% of balance per levy or fine, with a [GOLDEN_BULL_DAILY_FINE_CAP]-mammon ceiling on each fine and a [GOLDEN_BULL_POLL_CAP]m poll-tax cap. While it stands, the burghers replenish the Burgher Pledge daily.</li>
			<li><b>The Covenant of Noc and Pestra</b> - University members, the Apothecary and the Court Physician are limited to the lightest poll tax of [NOC_PESTRA_POLL_CAP]m, and a minimum wage from the Crown's payroll.</li>
			<li><b>[guild_charter_name]</b> - Guild mercenaries are capped at [GUILD_CHARTER_OF_ARMS_POLL_CAP]m of poll tax per day, and the Guild remits [GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS]m daily to the Burgher's Pledge while in force.</li>
			<li><b>[indenture_of_war_name]</b> - Garrison ranks are subject to a minimum salary floor while this is in effect.</li>
			<li><b>The Magna Carta</b> - a dormant modern charter; if the Lord dares press it, every Crown levy and poll tax is zeroed. Fines remain.</li>
		</ul>

		<p>Each Charter has a [DECREE_COOLDOWN / 600]-minute cooldown after revision. No more than one suspension and one restoration may be proclaimed per day. Sequestration force-suspends most Charters until the Crown's debt is settled.</p>
		</div>
	"}


/datum/book_entry/treasury_general/levies
	name = "01. Taxation and Levies"

/datum/book_entry/treasury_general/levies/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown draws revenue from a mix of direct and indirect taxes. Charters of the Realm (see chapter 00) may exempt or cap certain classes of subject while they stand.</p>
		</div>

		<h3>Tax Categories</h3>
		<ul>
			<li><b>Contract Levy</b> - on contract payouts.</li>
			<li><b>Headeater Levy</b> - on bounty heads fed directly to the HEADEATER.</li>
			<li><b>Import Tariff</b> - on goods bought from merchant vendors including SILVERFACE and GOLDFACE.</li>
			<li><b>Export Duty</b> - on goods sold through the Navigator or the Ship Fulfillment Crate.</li>
			<li><b>Fine</b> - a one-off penalty struck against a subject's account.</li>
		</ul>

		<p>Per-category rates (levies and poll taxes) are set from the throne by speaking <b>"Set Taxes"</b>, which opens the Ruler's tax panel; levies and poll rates each carry an independent one-day cooldown. Should the ruler be absent from the realm, the Steward's <b>"Adjust Taxes"</b> verb opens the same panel. While the Zenitstadt Concordat stands, no levy may be set below the Church's tithe rate.</p>

		<h3>Poll Tax</h3>
		<p>Poll tax is levied daily against every subject with a bank account, drained automatically. Categories exist per social station (noble, clergy, inquisition, courtier, garrison, guilds, merchant, burgher, adventurer, mercenary, peasant). Poll taxes are hardcapped at <b>[POLL_TAX_MAX_RATE]m/day</b>, and can be set as low as a subsidy of <b>-[POLL_TAX_MAX_SUBSIDY]m/day</b> (a negative rate pays subjects from the Crown's Purse instead).</p>

		<p>Unpaid poll tax accumulates arrears. After <b>[POLL_TAX_DEBT_DAYS_TO_DEBTOR]</b> day(s) of arrears, the subject is marked <b>destitute</b>. Poll tax arrears do not authorise kill-on-sight or attack-on-sight - treat arrears as a roleplay opportunity to recover or forgive the debt, not an ERP exemption.</p>
		</div>
	"}


/datum/book_entry/treasury_general/fines
	name = "02. Fines"

/datum/book_entry/treasury_general/fines/inner_book_html(mob/user)
	return {"
		<div>
		<p>A fine strikes a subject's account directly for a stated amount, capped at <b>[GENERIC_RATE_CAP * 100]%</b> of their current balance per stroke, and no subject may be fined more than once per day. The Great Writ shields nobles from fines entirely, and the Golden Bull softens the cap for burghers (see chapter 00) - outlaws enjoy no such mercy.</p>
		<p>Fines are voluntarily consented to by nature of holding an account under the Crown's jurisdiction; treat repeated or excessive fining as an IC matter to resolve, not a mechanical guarantee.</p>
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
	name = "04. Supply and Demand"

/datum/book_entry/treasury_general/supply/inner_book_html(mob/user)
	return {"
		<div>
		<p>Economic events last <b>[ECON_EVENT_DURATION]</b> day(s) and are posted on the noticeboard under <b>Economic Events</b>.</p>

		<ul>
			<li><b>Shortage</b> - affected goods spike in price. One urgent standing order is posted against the afflicted region, <b>provided fewer than [STANDING_ORDERS_MAX_URGENT] urgent orders are already standing</b>. Past that cap, the shortage's price spike still happens, but no urgent order is spawned.</li>
			<li><b>Oversupply</b> - affected goods drop in price.</li>
		</ul>

		<h3>Ending a Shortage Early</h3>
		<p>A shortage does not have to run its full <b>[ECON_EVENT_DURATION]</b>-day course. Every unit of an affected good that the Crown <b>exports</b> to a region that demands it counts toward relief.</p>

		<p>Once cumulative deliveries cross <b>[round(ECON_EVENT_SATURATION_MULT * 100)]%</b> of the average stockpile limit across the affected goods, the shortage ends immediately: prices snap back to normal and SCOM announces the relief.</p>
		</div>
	"}


/datum/book_entry/treasury_general/tax_evasion
	name = "05. Jolly Tax Evasion"

/datum/book_entry/treasury_general/tax_evasion/inner_book_html(mob/user)
	return {"
		<div>
		<p>Two legitimate dodge switches exist, both risk-bearing:</p>

		<ul>
			<li><b>GOLDFACE's Secrets menu</b> - FTC members (Merchant, Shophand) can toggle "Stop Paying Taxes" to skip the import tariff on purchases. The machine tracks tariff paid and tariff evaded per-machine, visible to FTC members only.</li>
			<li><b>The Ship Fulfillment Crate's underledger toggle</b> - Merchant/Shophand can toggle Crown export duty between PAID and DODGED on that crate. Evaded duty is tallied per-machine.</li>
		</ul>

		<p>The risk of being caught and penalised by the Crown falls on whoever is dodging. The Crown has no automatic audit tool - it can only guess and accuse, with or without proof.</p>
		</div>
	"}


/datum/book_entry/treasury_general/mercenary_statue
	name = "06. The Mercenary Statue"

/datum/book_entry/treasury_general/mercenary_statue/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Mercenary Statue is a talkstatue that lets townsfolk reach registered mercenaries for hire.</p>

		<ul>
			<li>Mercenaries register with the statue and cycle their status: Available, Contracted, Do not Disturb.</li>
			<li>Anyone may open the statue, browse the roster, and send a registered mercenary a direct message. Recipients on Do not Disturb are hidden from the picker.</li>
			<li>A sender may also broadcast a message to every available mercenary at once.</li>
			<li>Each sender-recipient pairing has its own cooldown to prevent spam, and broadcasts carry a separate cooldown.</li>
			<li>Messages are logged. Senders must stand adjacent to the statue to send, and mercenaries reply with a simple YAE/NAE or a signal of interest.</li>
		</ul>
		</div>
	"}


/datum/book_entry/treasury_general/zadcote
	name = "07. Zadcote and Zadcage"

/datum/book_entry/treasury_general/zadcote/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Zadcote is used to send messages, parcels, and for the nefarious - bottlebombs to linked zadcages. Each Zadcote is bound to a single faction - the Crown, the Ferentian Trading Company, or the Bathhouse and accepts orders only from its faction.</p>

		<p>A Zadcage can ride in a pack, on a person, or be set down, and the zad will route to it reliably. Each zadcote spawns with its linked zadcages automatically..</p>

		<h3>Bonding a Zadcage</h3>
		<p>Strike a free Zadcage against a Zadcote to bond it to one of [ZADCOTE_SLOT_CAP] slots. The Zadcote operator may rename the slot in the interface. Bond persists until the operator severs it; the Zadcage holder cannot break it themselves. If you sever a slot while a zad is in flight, that zad completes its current trip before the bond goes dead.</p>

		<h3>Capacity tiers</h3>
		<p>Each dispatch chooses how many zads to send. Each of them may send a message, alongside a payload:</p>
		<ul>
			<li><b>1 zad</b> - A small item.</li>
			<li><b>2 zads</b> - A medium (normal) item or a pouch.</li>
			<li><b>3 zads</b> - A large / bulky item or container.</li>
		</ul>

		<h3>Flight time and turnback</h3>
		<p>A dispatched zad team takes about a minute to reach the Zadcage. If the Zadcage has been destroyed by then, the zads turn back with the payload intact. If the Zadcage is bonded but not on a person, delivery still completes - the Zadcote chimes to its operator so they know the cage was unattended.</p>

		<h3>Reply window</h3>
		<p>Once a zad lands, the Zadcage holder has three minutes to write a reply and place a return payload. After three minutes the zad lifts off on its own. Return capacity is equal to the dispatch capacity. <b>Auto-departure carries no message and no package.</b> The last 30 seconds tint the countdown red.</p>

		<h3>Attrition and Zadpacks</h3>
		<p>A returning zad has a small chance of being lost to exhaustion or harm. Bottlebomb flights are <b>one-way</b> - those zads are never recovered. A faction restocks its Zadcote with a Pack of Trained Zads bought through its supply machine: the ATC's at GOLDFACE, the Bathhouse's through BRASSFACE, and the Stewardry's through the NERVE MASTER's Crown imports. Strike the pack against the Zadcote to add [ZADPACK_BUNDLE_SIZE] fresh zads to the reserve.</p>

		<h3>Summoning</h3>
		<p>A Zadcage holder can actively summon zads from the linked zadcote, so they can send a message or package back proactively. The owner of the zadcote could turn it off if they are low on zads or think the bearer is abusing it.</p>

		<h3>Bombing!</h3>
		<p>The Zadcote can carry bottlebombs as a payload - up to three per dispatch. Bomb can only be sent once every five minutes. The Zadcage holder sees the zads arriving with bombs slung beneath, has time to drop or throw the cage, and may even weaponize it against someone they dislike. Admin logs every bomb dispatch by sender, receiver, and place of detonation.</p>

		<h3>Scrying (ATC and Bathhouse only)</h3>
		<p>The Merchant's Zadcote and the Bathmaster's Zadcote may scry through the bonded zad on a Zadcage. Scrying draws from a small <b>scrying fund</b> kept by the Zadcote itself. Feed coins of any denomination directly into the Zadcote to add to the fund, each scry deducts [ZAD_VOYEUR_COST_MAMMON] mammon. The Zadcage holder feels arcane energy stir, and the cage glows blue while the scrying is active. The view lasts three minutes, long enough to confirm the holder is safe - or to make trouble. The Steward and Crown have no scrying access through Zadcotes, they must relies on the Court Mage's expertise scrying.</p>

		<h3>Spare zadcages & zads</h3>
		<p>Spare Zadcages cost [ZADCOTE_NEW_CAGE_COST_MAMMON] mammon at the can be replaced by purchase from the faction's import machine. Trained zads sell as packs of [ZADPACK_BUNDLE_SIZE].</p>
		</div>
	"}
