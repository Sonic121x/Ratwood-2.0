import { useState } from 'react';

import {
  cardStyle,
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_SOFT,
  pageStyle,
  PriceTag,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  titleStyle,
} from '../../common/parchment';
import type {
  ActFn,
  CatalogData,
  CatalogEntry,
  CulturalStockEntry,
  KinshipData,
} from '../types';

type Props = {
  stock: CulturalStockEntry[];
  catalogs?: CatalogData[];
  kinship?: KinshipData;
  budget: number;
  isAgent?: boolean;
  act: ActFn;
};

const StockCard = (props: {
  entry: CulturalStockEntry;
  budget: number;
  act: ActFn;
}) => {
  const { entry, budget, act } = props;
  const cantAfford = budget < entry.price;
  const hasTariff = entry.price_tariff > 0;
  const hasKin =
    !!entry.is_kin &&
    entry.price_base_pre_kin !== undefined &&
    entry.price_base_pre_kin > entry.price_base;
  const kinSaving = hasKin
    ? (entry.price_base_pre_kin as number) - entry.price_base
    : 0;
  const preKinPrice = hasKin
    ? (entry.price_base_pre_kin as number) + entry.price_tariff
    : 0;
  const priceTitle = hasKin
    ? `${entry.price_base}m + ${entry.price_tariff}m 王室关税 = ${entry.price}m (亲缘 -${kinSaving}m, 基础成本 ${entry.base_cost}m)`
    : hasTariff
      ? `${entry.price_base}m + ${entry.price_tariff}m 王室关税 = ${entry.price}m (原价 ${entry.base_cost}m)`
      : `${entry.price}m (原价 ${entry.base_cost}m)`;
  return (
    <div style={denseRowStyle}>
      <div
        style={{
          ...ellipsisCellStyle,
          color: INK,
          fontSize: FONT_TITLE,
        }}
        title={`${entry.name} - 库存 ${entry.qty}`}
      >
        {entry.pack_qty > 1 && (
          <span
            style={{
              color: INK_SOFT,
              marginRight: '4px',
              fontSize: FONT_LEAD,
            }}
          >
            x{entry.pack_qty}
          </span>
        )}
        {entry.name}
        <span
          style={{
            color: INK_SOFT,
            marginLeft: '6px',
            fontSize: FONT_SMALL,
          }}
        >
          ({entry.qty})
        </span>
      </div>
      <PriceTag
        price={entry.price}
        tariff={entry.price_tariff}
        cantAfford={cantAfford}
        title={priceTitle}
        strikethrough={hasKin ? preKinPrice : undefined}
      />
      <div style={{ flexShrink: 0 }}>
        <button
          type="button"
          style={compactButtonStyle({ disabled: cantAfford })}
          disabled={cantAfford}
          onClick={() =>
            act('cultural_buy', {
              pack: entry.pack,
              ship_id: entry.ship_id,
            })
          }
          title={`以 ${entry.price}m 购买 ${entry.name}`}
        >
          购买
        </button>
      </div>
    </div>
  );
};

const ShipSection = (props: {
  shipId: string;
  shipName: string;
  entries: CulturalStockEntry[];
  budget: number;
  act: ActFn;
  defaultExpanded: boolean;
}) => {
  const { shipName, entries, budget, act, defaultExpanded } = props;
  const [expanded, setExpanded] = useState(defaultExpanded);
  return (
    <div style={{ marginBottom: '8px' }}>
      <div
        style={{
          ...sectionHeaderStyle,
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
          marginTop: '4px',
        }}
        onClick={() => setExpanded((e) => !e)}
      >
        <span style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
          {expanded ? '▾' : '▸'}
        </span>
        <span>{shipName}</span>
        <span
          style={{
            color: INK_SOFT,
            fontSize: FONT_BODY,
            textTransform: 'none',
            fontVariant: 'normal',
            fontWeight: 'normal',
            marginLeft: '6px',
          }}
        >
          ({entries.length} 件货物)
        </span>
      </div>
      {expanded && (
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))',
            gap: '0 12px',
          }}
        >
          {entries.map((entry) => (
            <StockCard
              key={entry.pack}
              entry={entry}
              budget={budget}
              act={act}
            />
          ))}
        </div>
      )}
    </div>
  );
};

const CatalogStockCard = (props: {
  catalogId: string;
  entry: CatalogEntry;
  budget: number;
  act: ActFn;
}) => {
  const { catalogId, entry, budget, act } = props;
  const soldOut = entry.qty <= 0;
  const cantAfford = budget < entry.price;
  const disabled = soldOut || cantAfford;
  const hasTariff = entry.price_tariff > 0;
  const hasKin = entry.price_base_pre_kin > entry.price_base;
  const kinSaving = hasKin ? entry.price_base_pre_kin - entry.price_base : 0;
  const preKinPrice = hasKin ? entry.price_base_pre_kin + entry.price_tariff : 0;
  const priceTitle = hasKin
    ? `${entry.price_base}m + ${entry.price_tariff}m 王室关税 = ${entry.price}m (亲缘 -${kinSaving}m)`
    : hasTariff
      ? `${entry.price_base}m + ${entry.price_tariff}m 王室关税 = ${entry.price}m`
      : `${entry.price}m`;
  return (
    <div style={denseRowStyle}>
      <div
        style={{ ...ellipsisCellStyle, color: INK, fontSize: FONT_TITLE }}
        title={entry.name}
      >
        {entry.pack_qty > 1 && (
          <span
            style={{ color: INK_SOFT, marginRight: '4px', fontSize: FONT_LEAD }}
          >
            x{entry.pack_qty}
          </span>
        )}
        {entry.name}
        <span
          style={{
            color: soldOut ? SEAL_RED : INK_SOFT,
            marginLeft: '6px',
            fontSize: FONT_SMALL,
          }}
          title={`库存 ${entry.qty} / ${entry.stock_max} - 每日补满`}
        >
          ({entry.qty}/{entry.stock_max})
        </span>
      </div>
      <PriceTag
        price={entry.price}
        tariff={entry.price_tariff}
        cantAfford={cantAfford}
        title={priceTitle}
        strikethrough={hasKin ? preKinPrice : undefined}
      />
      <div style={{ flexShrink: 0 }}>
        <button
          type="button"
          style={compactButtonStyle({ disabled })}
          disabled={disabled}
          onClick={() => act('catalog_buy', { catalog: catalogId, pack: entry.pack })}
          title={
            soldOut
              ? `${entry.name} 已无库存 - 商队每日补满`
              : `以 ${entry.price}m 订购 ${entry.name}`
          }
        >
          {soldOut ? '缺货' : '购买'}
        </button>
      </div>
    </div>
  );
};

const CatalogSection = (props: {
  catalog: CatalogData;
  budget: number;
  act: ActFn;
}) => {
  const { catalog, budget, act } = props;
  const accessible = !!catalog.accessible;
  const [expanded, setExpanded] = useState(accessible);
  return (
    <div style={{ marginBottom: '8px' }}>
      <div
        style={{
          ...sectionHeaderStyle,
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
          marginTop: '4px',
        }}
        onClick={() => setExpanded((e) => !e)}
      >
        <span style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
          {expanded ? '▾' : '▸'}
        </span>
        <span>{catalog.name}</span>
        <span
          style={{
            color: accessible ? SEAL_GREEN : INK_SOFT,
            fontSize: FONT_BODY,
            textTransform: 'none',
            fontVariant: 'normal',
            fontWeight: 'normal',
            marginLeft: '6px',
          }}
        >
          {catalog.origin_access
            ? `(对你开放 - 减免 ${catalog.discount_pct}%)`
            : catalog.unlocked
              ? '(已签署协议)'
              : `(已密封 - 需 ${catalog.favor_cost} 恩惠签署)`}
        </span>
      </div>
      {expanded && (
        <>
          <div
            style={{
              ...noteStyleItalic,
              padding: '2px 0 6px',
            }}
          >
            {catalog.desc}
          </div>
          {accessible && (
            <div
              style={{
                ...noteStyleItalic,
                fontStyle: 'normal',
                padding: '0 0 6px',
              }}
            >
              商队每日补满其全部货载.
            </div>
          )}
          {accessible ? (
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))',
                gap: '0 12px',
              }}
            >
              {catalog.entries.map((entry) => (
                <CatalogStockCard
                  key={entry.pack}
                  catalogId={catalog.id}
                  entry={entry}
                  budget={budget}
                  act={act}
                />
              ))}
            </div>
          ) : (
            // TODO: flavor
            <div style={{ ...cardStyle, color: INK_SOFT, textAlign: 'center' }}>
              此特许状已密封. 在管理页花费{' '}
              {catalog.favor_cost} 恩惠即可开启它.
            </div>
          )}
        </>
      )}
    </div>
  );
};

const noteStyleItalic = {
  color: INK_SOFT,
  fontStyle: 'italic' as const,
  fontSize: FONT_BODY,
  lineHeight: 1.4,
};

const KinshipBanner = (props: { children: React.ReactNode }) => (
  <div
    style={{
      margin: '6px 0 8px',
      padding: '6px 10px',
      border: `1px dashed ${SEAL_GREEN}`,
      color: INK,
      fontFamily: SERIF,
      fontSize: FONT_BODY,
      lineHeight: 1.4,
    }}
  >
    {props.children}
  </div>
);

export const CulturalStockTab = (props: Props) => {
  const { stock, catalogs = [], kinship, budget, isAgent, act } = props;

  const catalogSections = catalogs.length > 0 && (
    <>
      <div
        style={{
          ...sectionHeaderStyle,
          marginTop: '12px',
        }}
      >
        贸易协议
      </div>
      {catalogs.map((catalog) => (
        <CatalogSection
          key={catalog.id}
          catalog={catalog}
          budget={budget}
          act={act}
        />
      ))}
    </>
  );

  const banners = (
    <>
      {!!isAgent && (
        <KinshipBanner>
          <span
            style={{
              color: SEAL_GREEN,
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            特许代理人
          </span>
          <span style={{ color: INK_SOFT }}>
            作为费伦提亚贸易公司的代理人, 你获准查阅、查看并购买
            任何停靠船只的文化货物, 并可代表商行管事
            查看并招呼船只.
          </span>
        </KinshipBanner>
      )}
      {kinship?.realm_name && (
        <KinshipBanner>
          <span
            style={{
              color: SEAL_GREEN,
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            亲缘: {kinship.realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            来自 {kinship.realm_name} 船只的文化货物便宜{' '}
            {kinship.buy_pct}%.
          </span>
        </KinshipBanner>
      )}
      {kinship?.agent_realm_name && (
        <KinshipBanner>
          <span
            style={{
              color: SEAL_GREEN,
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            代理人亲缘: {kinship.agent_realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            作为代理人, 你从 {kinship.agent_realm_name} 船只购买时可少付{' '}
            {kinship.buy_pct}%.
          </span>
        </KinshipBanner>
      )}
    </>
  );

  if (!stock.length) {
    return (
      <div style={pageStyle}>
        <div style={titleStyle}>文化货物</div>
        {banners}
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
            marginTop: '12px',
          }}
        >
          码头没有外国船只. 招呼一艘前来以查看她的
          文化货舱.
        </div>
        {catalogSections}
      </div>
    );
  }

  const byShip = new Map<string, { name: string; entries: CulturalStockEntry[] }>();
  for (const entry of stock) {
    const existing = byShip.get(entry.ship_id);
    if (existing) {
      existing.entries.push(entry);
    } else {
      byShip.set(entry.ship_id, {
        name: entry.ship_name,
        entries: [entry],
      });
    }
  }
  const ships = Array.from(byShip.entries());

  return (
    <div style={pageStyle}>
      <div style={titleStyle}>文化货物</div>
      {banners}
      <div
        style={{
          textAlign: 'center',
          color: INK_SOFT,
          fontSize: FONT_BODY,
          marginBottom: '8px',
        }}
      >
        由停靠船只卸下的上等货物. 她扬帆起航时它们便
        随之离去.
      </div>
      {ships.map(([shipId, info]) => (
        <ShipSection
          key={shipId}
          shipId={shipId}
          shipName={info.name}
          entries={info.entries}
          budget={budget}
          act={act}
          defaultExpanded={ships.length === 1}
        />
      ))}
      {catalogSections}
    </div>
  );
};
