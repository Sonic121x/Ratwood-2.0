import type { ReactNode } from 'react';

import { useBackend } from '../../backend';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  SEAL_RED_SOFT,
  sectionHeaderStyle,
} from '../common/parchment';
import type { Data, Order } from './types';

const PAIR_ACCENT = '#7a5a2f';

const QUALITY_TIER_TOOLTIP = [
  'Quality multipliers vs. canonical price:',
  '  scavenged 25%',
  '  ruined 20%',
  '  awful 35%',
  '  crude 65%',
  '  rough 85%',
  '  (standard) 100%',
  '  fine 110%',
  '  flawless 120%',
  '  masterwork 135%',
].join('\n');

export const OrdersView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { active_orders, order_pool_cap, good_catalog, region_catalog } = props.data;
  const count = active_orders.length;

  const onFulfill = (ref: string) => act('fulfill_order', { ref });

  const consumed = new Set<string>();
  const rendered: ReactNode[] = [];
  for (const o of active_orders) {
    if (consumed.has(o.ref)) continue;
    if (o.pair_id) {
      const sibling = active_orders.find(
        (s) => s.pair_id === o.pair_id && s.ref !== o.ref,
      );
      consumed.add(o.ref);
      if (sibling) consumed.add(sibling.ref);
      rendered.push(
        <PairGroup
          key={o.pair_id}
          primary={o}
          sibling={sibling}
          regionCatalog={region_catalog}
          goodCatalog={good_catalog}
          onFulfill={onFulfill}
        />,
      );
    } else {
      consumed.add(o.ref);
      rendered.push(
        <OrderCard
          key={o.ref}
          order={o}
          regionCatalog={region_catalog}
          goodCatalog={good_catalog}
          onFulfill={onFulfill}
        />,
      );
    }
  }

  return (
    <div>
      <div style={sectionHeaderStyle}>
        当前常备订单 ({count}/{order_pool_cap})
      </div>
      {count === 0 ? (
        <div style={{ textAlign: 'center', color: INK_SOFT }}>
          当前没有订单. 请明日再来查看.
        </div>
      ) : (
        rendered
      )}
    </div>
  );
};

type CardProps = {
  order: Order;
  regionCatalog: Data['region_catalog'];
  goodCatalog: Data['good_catalog'];
  onFulfill: (ref: string) => void;
  embedded?: boolean;
};

const OrderCard = (props: CardProps) => {
  const o = props.order;
  const isUrgent = o.days_left <= 1;
  const pureWarehouse = !!o.has_warehouse && !o.has_stockpile;
  const barColor = o.region_blockaded
    ? SEAL_RED
    : pureWarehouse
      ? SEAL_BLUE
      : isUrgent
        ? SEAL_RED_SOFT
        : INK_SOFT;
  const style = props.embedded
    ? {
        ...cardStyle,
        borderLeft: `4px solid ${barColor}`,
        marginTop: 0,
        marginBottom: '6px',
        boxShadow: 'none',
      }
    : {
        ...cardStyle,
        borderLeft: `4px solid ${barColor}`,
      };
  return (
    <div style={style}>
      <div style={{ marginBottom: '4px' }}>
        <span style={{ fontWeight: 'bold', fontSize: FONT_BODY }}>{o.name}</span>
        {!!o.region_blockaded && (
          <span style={badgeStyle(SEAL_RED)}>已封锁</span>
        )}
        {!!o.has_warehouse && (
          <span style={badgeStyle(SEAL_BLUE)}>仓库</span>
        )}
        {!!o.has_stockpile && (
          <span style={badgeStyle(SEAL_GREEN)}>库存</span>
        )}
        {isUrgent && !o.region_blockaded && !pureWarehouse && (
          <span style={badgeStyle(SEAL_RED_SOFT)}>紧急</span>
        )}
        {!!o.petitioned && (
          <span style={badgeStyle('#a872c4')}>请愿订单</span>
        )}
      </div>
      {o.description && (
        <div
          style={{
            color: INK_SOFT,
            fontSize: FONT_BODY,
            marginBottom: '4px',
          }}
        >
          {o.description}
        </div>
      )}
      <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
        {props.regionCatalog[o.region_id]?.name ?? o.region_id} &middot;{' '}
        剩余 {o.days_left}天 &middot; 报酬:{' '}
        <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
          {o.payout}m
        </span>
      </div>
      <div style={{ marginTop: '4px' }}>
        <span style={{ color: INK_FAINT, fontSize: FONT_BODY }}>物品: </span>
        {o.items.map((it, i) => {
          const isStockpileItem = it.route === 'stockpile';
          const short = isStockpileItem && it.have < it.needed;
          const label = props.goodCatalog[it.good_id]?.name ?? it.good_id;
          return (
            <span key={it.good_id}>
              <span
                style={{
                  color: short ? SEAL_RED : SEAL_GREEN,
                  fontWeight: short ? 'bold' : 'normal',
                }}
              >
                {it.needed} {label}
                {isStockpileItem && ` (${it.have})`}
              </span>
              {i < o.items.length - 1 && (
                <span style={{ color: INK_FAINT }}>, </span>
              )}
            </span>
          );
        })}
      </div>
      {!!o.has_warehouse && (
        <div
          style={{
            marginTop: '4px',
            color: INK_FAINT,
            fontSize: FONT_BODY,
            cursor: 'help',
          }}
          title={QUALITY_TIER_TOOLTIP}
        >
          仓库货物的报酬根据交付物品的品质调整 -80% 至 +35%.
        </div>
      )}
      <div style={{ marginTop: '8px' }}>
        <FulfillButton
          order={o}
          onFulfill={() => props.onFulfill(o.ref)}
        />
      </div>
    </div>
  );
};

const PairGroup = (props: {
  primary: Order;
  sibling?: Order;
  regionCatalog: Data['region_catalog'];
  goodCatalog: Data['good_catalog'];
  onFulfill: (ref: string) => void;
}) => {
  const { primary, sibling } = props;
  const label = primary.pair_label ?? sibling?.pair_label ?? '配套订单';
  const regionName =
    props.regionCatalog[primary.region_id]?.name ?? primary.region_id;
  const totalPayout = primary.payout + (sibling?.payout ?? 0);
  return (
    <div
      style={{
        ...cardStyle,
        borderLeft: `4px solid ${PAIR_ACCENT}`,
        padding: '6px 8px',
      }}
    >
      <div
        style={{
          fontWeight: 'bold',
          fontSize: FONT_BODY,
          color: PAIR_ACCENT,
          marginBottom: '4px',
          textTransform: 'uppercase',
          letterSpacing: '1px',
        }}
      >
        {label} &middot; {regionName} &middot;{' '}
        <span style={{ color: SEAL_AMBER }}>合计 {totalPayout}m</span>{' '}
        <span style={{ color: INK_FAINT, fontWeight: 'normal' }}>
          (配套订单, 占一个栏位)
        </span>
      </div>
      <OrderCard {...props} order={primary} embedded />
      {sibling && <OrderCard {...props} order={sibling} embedded />}
    </div>
  );
};

const FulfillButton = (props: {
  order: Order;
  onFulfill: () => void;
}) => {
  const o = props.order;
  if (o.region_blockaded) {
    return (
      <button
        type="button"
        disabled
        style={inkButtonStyle({ color: SEAL_RED, disabled: true })}
      >
        交付 &mdash; 道路已封锁
      </button>
    );
  }
  const pureWarehouse = !!o.has_warehouse && !o.has_stockpile;
  const mixed = !!o.has_warehouse && !!o.has_stockpile;
  if (pureWarehouse) {
    return (
      <button
        type="button"
        onClick={props.onFulfill}
        style={inkButtonStyle({ color: SEAL_BLUE })}
      >
        从仓库交付
      </button>
    );
  }
  if (o.can_fulfill) {
    return (
      <button
        type="button"
        onClick={props.onFulfill}
        style={inkButtonStyle({ color: SEAL_GREEN })}
      >
        {mixed ? '交付 (仓库 + 库存)' : '从库存交付'}
      </button>
    );
  }
  if (o.can_partial) {
    return (
      <button
        type="button"
        onClick={props.onFulfill}
        title={`Settle short - ${o.partial_pct}% of value covered, paid at 85% of the delivered share. Missing: ${o.shortfall_text}`}
        style={inkButtonStyle({ color: SEAL_AMBER })}
      >
        部分交付 &mdash; {o.partial_pct}% ({o.partial_payout_preview}m)
      </button>
    );
  }
  return (
    <button
      type="button"
      disabled
      title={o.shortfall_text}
      style={inkButtonStyle({ disabled: true })}
    >
      交付 &mdash; {o.shortfall_text || '库存不足'}
    </button>
  );
};
