import { useMemo, useState } from 'react';

import {
  cardStyle,
  dashedFrameStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  stickyLeftCellStyle,
} from '../../common/parchment';
import {
  type MarketCategory,
  type MarketData,
  type NoticeboardData,
  type RealmDemandRow,
} from '../types';

const FILL_YELLOW = 0.50;
const FILL_RED = 0.85;
const DEMAND_WARM = 1.001;
const TOP_N = 5;

const headerStripStyle: React.CSSProperties = {
  ...cardStyle,
  textAlign: 'center',
  marginBottom: 12,
};

const feedGridStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: 12,
  marginBottom: 14,
};

const feedColumnStyle: React.CSSProperties = {
  ...cardStyle,
  marginBottom: 0,
};

const feedTitleStyle: React.CSSProperties = {
  fontWeight: 'bold',
  fontSize: FONT_BODY,
  color: INK,
  marginBottom: 6,
  borderBottom: `1px solid ${INK_FAINT}`,
  paddingBottom: 2,
};

const feedRowStyle: React.CSSProperties = {
  display: 'flex',
  justifyContent: 'space-between',
  padding: '2px 0',
  fontSize: FONT_BODY,
  color: INK,
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
};

const ledgerGridStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  columnGap: 14,
  rowGap: 0,
};

const ledgerHeaderStyle: React.CSSProperties = {
  color: SEAL_AMBER,
  fontSize: FONT_BODY,
  borderBottom: `1px solid ${INK_FAINT}`,
  padding: '2px 4px 3px 4px',
  display: 'grid',
  gridTemplateColumns: 'minmax(0, 1fr) 70px 50px',
  columnGap: 6,
  alignItems: 'center',
};

const ledgerRowStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'minmax(0, 1fr) 70px 50px',
  columnGap: 6,
  alignItems: 'center',
  padding: '3px 4px',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
  fontSize: FONT_BODY,
  color: INK,
};

const ledgerNameStyle: React.CSSProperties = {
  overflow: 'hidden',
  textOverflow: 'ellipsis',
  whiteSpace: 'nowrap',
};

const fillColor = (fill: number, refused: boolean): string => {
  if (refused) return SEAL_RED;
  if (fill >= FILL_RED) return SEAL_RED;
  if (fill >= FILL_YELLOW) return '#b8851c';
  return SEAL_GREEN;
};

const demandColor = (mult: number): string => {
  if (mult >= 1.35) return SEAL_RED;
  if (mult >= 1.15) return '#b8501c';
  if (mult > DEMAND_WARM) return SEAL_AMBER;
  if (mult < 1) return SEAL_BLUE;
  return INK_FAINT;
};

const formatMult = (m: number): string => `${m.toFixed(2)}x`;
const formatPct = (n: number): string => `${Math.round(n * 100)}%`;

const matrixContainerStyle: React.CSSProperties = {
  ...dashedFrameStyle,
  marginTop: 10,
  overflowX: 'auto',
};

const matrixTableStyle: React.CSSProperties = {
  width: '100%',
  borderCollapse: 'collapse',
  fontSize: FONT_BODY,
  color: INK,
};

const matrixCornerStyle: React.CSSProperties = {
  ...stickyLeftCellStyle,
  textAlign: 'left',
  padding: '3px 6px',
  color: SEAL_AMBER,
  borderBottom: `1px solid ${INK_FAINT}`,
};

const matrixRealmHeaderStyle: React.CSSProperties = {
  padding: '3px 4px',
  fontSize: FONT_BODY,
  color: INK_SOFT,
  borderBottom: `1px solid ${INK_FAINT}`,
  textAlign: 'center',
  whiteSpace: 'nowrap',
  minWidth: '64px',
};

const matrixBucketLabelStyle: React.CSSProperties = {
  ...stickyLeftCellStyle,
  padding: '2px 8px 2px 4px',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
  fontWeight: 'bold',
  color: INK,
  whiteSpace: 'nowrap',
};

const matrixCellStyle: React.CSSProperties = {
  textAlign: 'center',
  padding: '2px 4px',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
};

const RealmDemandMatrix = (props: {
  realms: RealmDemandRow[];
  allBuckets: string[];
}) => {
  const { realms, allBuckets } = props;
  if (realms.length === 0 || allBuckets.length === 0) {
    return (
      <div style={{ ...matrixContainerStyle, color: INK_FAINT, fontStyle: 'italic' }}>
        商行管事们没有可分享的国度情报.
      </div>
    );
  }
  // Precompute one Set<bucket> per realm so the inner table-cell lookup is O(1) instead
  // of an Array.includes call per cell. With 11 realms x 16 buckets = 176 cells per render
  // this matters under static-data refresh churn.
  const realmDemandSets = realms.map((r) => ({
    realm: r,
    set: new Set(r.demanded),
  }));
  return (
    <div style={matrixContainerStyle}>
      <div
        style={{
          color: INK_SOFT,
          fontStyle: 'italic',
          fontSize: FONT_BODY,
          marginBottom: 4,
        }}
      >
        各外国国度需求的概览. 在引航机处呼唤某国度的船只, 可提升其类别在该处的需求. 贵重品与海鲜即使在无船在港时也保持全价; 其他类别在买家到来前只按半价支付.
      </div>
      <table style={matrixTableStyle}>
        <thead>
          <tr>
            <th style={matrixCornerStyle}>类别</th>
            {realmDemandSets.map(({ realm }) => (
              <th key={realm.realm_id} style={matrixRealmHeaderStyle} title={realm.name}>
                {realm.name}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {allBuckets.map((bucket) => (
            <tr key={bucket}>
              <td style={matrixBucketLabelStyle}>{bucket}</td>
              {realmDemandSets.map(({ realm, set }) => (
                <td key={realm.realm_id} style={matrixCellStyle}>
                  {set.has(bucket) ? (
                    <span style={{ color: SEAL_GREEN, fontWeight: 'bold' }}>
                      &#x2714;
                    </span>
                  ) : (
                    <span style={{ color: INK_FAINT }}>&middot;</span>
                  )}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export const MarketView = ({
  market,
  headerLabel,
  headerNote,
}: {
  market: MarketData | null | undefined;
  headerLabel?: string;
  headerNote?: string;
}) => {
  const categories: MarketCategory[] = market?.categories ?? [];

  const { hot, crashed } = useMemo(() => {
    const byDemand = categories
      .slice()
      .filter((c) => c.demand_mult > DEMAND_WARM)
      .sort((a, b) => b.demand_mult - a.demand_mult)
      .slice(0, TOP_N);
    const byCrashed = categories
      .slice()
      .filter((c) => c.refused || c.fill_ratio >= FILL_YELLOW)
      .sort((a, b) => b.fill_ratio - a.fill_ratio)
      .slice(0, TOP_N);
    return { hot: byDemand, crashed: byCrashed };
  }, [categories]);

  const { leftCol, rightCol } = useMemo(() => {
    const sorted = categories
      .slice()
      .sort((a, b) => a.category.localeCompare(b.category));
    const mid = Math.ceil(sorted.length / 2);
    return { leftCol: sorted.slice(0, mid), rightCol: sorted.slice(mid) };
  }, [categories]);

  const [loreOpen, setLoreOpen] = useState(false);
  const [matrixOpen, setMatrixOpen] = useState(false);

  if (!market || categories.length === 0) {
    return (
      <div
        style={{
          color: INK_FAINT,
          textAlign: 'center',
          padding: '24px 0',
        }}
      >
        商行管事们暂时还没有可报告的消息.
      </div>
    );
  }

  return (
    <>
      <div style={headerStripStyle}>
        <div
          style={{
            fontWeight: 'bold',
            fontSize: FONT_TITLE,
            color: INK,
          }}
        >
          {headerLabel ?? '市场概况'}
        </div>
        {market.theme_dispatch && (
          <div
            style={{
              color: SEAL_AMBER,
              fontStyle: 'italic',
              fontSize: FONT_BODY,
              marginTop: 4,
              fontWeight: 'bold',
            }}
          >
            {market.theme_dispatch}
          </div>
        )}
        {headerNote && (
          <div
            style={{
              color: INK_SOFT,
              fontStyle: 'italic',
              fontSize: FONT_BODY,
              marginTop: 2,
            }}
          >
            {headerNote}
          </div>
        )}
        <div
          onClick={() => setLoreOpen(!loreOpen)}
          style={{
            marginTop: 6,
            cursor: 'pointer',
            color: SEAL_AMBER,
            fontSize: FONT_BODY,
          }}
        >
          {loreOpen ? '[ 隐藏市场说明 ]' : '[ 市场如何运作 ]'}
        </div>
        <div
          onClick={() => setMatrixOpen(!matrixOpen)}
          style={{
            marginTop: 2,
            cursor: 'pointer',
            color: SEAL_AMBER,
            fontSize: FONT_BODY,
          }}
        >
          {matrixOpen
            ? '[ 隐藏国度需求矩阵 ]'
            : '[ 显示国度需求矩阵 ]'}
        </div>
        {matrixOpen && (
          <RealmDemandMatrix
            realms={market.realm_demand_matrix ?? []}
            allBuckets={market.all_buckets ?? []}
          />
        )}
        {loreOpen && (
          <div style={{ ...dashedFrameStyle, marginTop: 8 }}>
            <p style={{ margin: '0 0 6px 0' }}>
              从引航机吊起的货物会按类别分入费伦提亚贸易公司的仓库. 每周商行管事们都会权衡哪些货物短缺、哪些货物过剩, 引航机的支付额也随之变动.
            </p>
            <p style={{ margin: '0 0 6px 0' }}>
              <b style={{ color: SEAL_GREEN }}>饱和</b>追踪仓库的储备量. 只要还有空间, 货物就按面值出售. 一旦仓库装满, 市场便拒绝再收货.
            </p>
            <p style={{ margin: '0 0 6px 0' }}>
              <b style={{ color: SEAL_AMBER }}>需求</b>会在外国船只靠港时飙升. 船长为想要的货物支付高于市场的价格. 船一离港, 需求也随之而去.
            </p>
            <p style={{ margin: '0 0 6px 0' }}>
              <b>呼唤一艘船</b>会提升其需求, 并从仓库中取走存货, 在船只停港期间腾出更多销售空间.
            </p>
            <p style={{ margin: 0 }}>
              阴影中另有一条 <b style={{ color: SEAL_AMBER }}>黑市</b>在运作. 它的容量只有合法仓库的一半, 也不会因外国船只获得需求加成, 其价格更独立于常规市场. 每天都有走私者与小船悄悄抽走它的存货, 随着时间腾出空间.
            </p>

          </div>
        )}
      </div>

      <div style={feedGridStyle}>
        <div style={feedColumnStyle}>
          <div style={feedTitleStyle}>
            <span style={{ color: SEAL_RED }}>热销</span> - 买家正渴求这些货物
          </div>
          {hot.length === 0 ? (
            <div
              style={{
                color: INK_FAINT,
                fontStyle: 'italic',
                fontSize: FONT_BODY,
                padding: '6px 0',
              }}
            >
              目前没有类别处于特别需求之中.
            </div>
          ) : (
            hot.map((c) => (
              <div key={c.category} style={feedRowStyle}>
                <span title={c.category}>{c.category}</span>
                <span
                  style={{
                    color: demandColor(c.demand_mult),
                    fontWeight: 'bold',
                  }}
                >
                  {formatMult(c.demand_mult)}
                </span>
              </div>
            ))
          )}
        </div>

        <div style={feedColumnStyle}>
          <div style={feedTitleStyle}>
            <span style={{ color: SEAL_BLUE }}>渐满</span> - 仓库接近容量上限
          </div>
          {crashed.length === 0 ? (
            <div
              style={{
                color: INK_FAINT,
                fontStyle: 'italic',
                fontSize: FONT_BODY,
                padding: '6px 0',
              }}
            >
              没有仓库接近容量上限. 仍有充足空间可供出售.
            </div>
          ) : (
            crashed.map((c) => (
              <div key={c.category} style={feedRowStyle}>
                <span title={c.category}>{c.category}</span>
                <span
                  style={{
                    color: fillColor(c.fill_ratio, c.refused),
                    fontWeight: 'bold',
                  }}
                >
                  {c.refused ? '拒收' : formatPct(c.fill_ratio)}
                </span>
              </div>
            ))
          )}
        </div>
      </div>

      <div style={cardStyle}>
        <div style={feedTitleStyle}>完整账目</div>
        <div style={ledgerGridStyle}>
          {[leftCol, rightCol].map((col, idx) => (
            <div key={idx}>
              <div style={ledgerHeaderStyle}>
                <span>类别</span>
                <span style={{ textAlign: 'right' }}>仓库</span>
                <span style={{ textAlign: 'center' }}>需求</span>
              </div>
              {col.map((c) => {
                const refused = c.refused;
                const fillCol = fillColor(c.fill_ratio, refused);
                const demCol = demandColor(c.demand_mult);
                const warehouseText = refused
                  ? '已满'
                  : `${c.consumed}/${c.capacity}m`;
                return (
                  <div key={c.category} style={ledgerRowStyle}>
                    <span style={ledgerNameStyle} title={c.category}>{c.category}</span>
                    <span
                      style={{
                        textAlign: 'right',
                        color: fillCol,
                        fontWeight: 'bold',
                        fontSize: FONT_BODY,
                        whiteSpace: 'nowrap',
                      }}
                    >
                      {warehouseText}
                    </span>
                    <span
                      style={{
                        textAlign: 'center',
                        color: demCol,
                        fontWeight: 'bold',
                        fontSize: FONT_BODY,
                      }}
                    >
                      {formatMult(c.demand_mult)}
                    </span>
                  </div>
                );
              })}
            </div>
          ))}
        </div>
      </div>
    </>
  );
};

export const MarketSection = ({ data }: { data: NoticeboardData }) => (
  <MarketView market={data.market_data} />
);
