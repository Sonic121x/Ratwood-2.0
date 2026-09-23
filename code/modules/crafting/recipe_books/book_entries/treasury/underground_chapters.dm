// Economy 3 guidebook — Underground chapter. Ported from Azure-Peak PR #7000
// (apsrc/main, code/modules/crafting/recipe_books/book_entries/treasury/underground_chapters.dm)
// with content adjusted to what Emerald Summit actually implements.
//
// Ratwood has both bathhouse machines, though split differently from AP: BRASSFACE is the
// bathhouse goods vendor (merchant/bathmaster.dm) and PURITY the vice vendor (drugmachine.dm),
// each its own machine rather than AP's public-reflavor subtype. The Ordinance of the Baths is
// live as of the wiring audit: while in force, both machines' tariffs divert to the Church as a
// tithe, and the Bathhouse Vault's income is tithed as well; Bishop or Bathmaster toggles it at
// a Nervelock.

/datum/book_entry/treasury_underground
	abstract_type = /datum/book_entry/treasury_underground
	category = "Underground"

/datum/book_entry/treasury_underground/black_market
	name = "01. 黑市"

/datum/book_entry/treasury_underground/black_market/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>黑市：</b>商人让你失望了？黑市才是你的朋友！前往黑市废墟，使用那里的可疑领航员——它的抽成远高于正规渠道，但绝不过问货物的来历。</p>

		<h3>纯净</h3>
		<ul>
			<li>售卖违禁品的机器，开局由<code>nightman</code>钥匙锁定。其他人需要取得钥匙或成功撬锁才能使用。</li>
			<li>售卖普通金面、银面商品目录中没有的享乐品，如毒品、烟草等。</li>
			<li>它的姊妹机黄铜面是澡堂售货机，使用同一把钥匙，售卖酒类、服饰、乐器和其他享乐用品。</li>
		</ul>

		<h3>澡堂条例</h3>
		<ul>
			<p>教会与澡堂订有协议：澡堂在教会的许可与庇护下营业，作为回报，向教会缴纳营业什一税。条例生效期间，黄铜面与纯净售货机原本缴给王室的进口关税将转交教会，澡堂金库的部分收入也同样上缴。主教或澡堂老板可随时在神经锁处解除或恢复协议，无须说明理由；协议解除后，澡堂重新向王室缴纳关税。</p>
		</ul>
		</div>
	"}
