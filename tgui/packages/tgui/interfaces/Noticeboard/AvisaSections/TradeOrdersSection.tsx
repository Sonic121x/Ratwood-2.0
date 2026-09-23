import { useMemo, useState } from 'react';

import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import { type NoticeboardData, type TradeOrder } from '../types';

const PETITION_PURPLE = '#7a3aa6';

const orderGridStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: 10,
  alignItems: 'start',
};

const orderBucket = (o: TradeOrder): number => {
  if (o.blockaded) return 2;
  if (o.urgent) return 0;
  return 1;
};

export const TradeOrdersSection = ({ data }: { data: NoticeboardData }) => {
  const rawOrders = data.trade_orders ?? [];
  const orders = useMemo(
    () =>
      rawOrders.slice().sort((a, b) => {
        const bucketA = orderBucket(a);
        const bucketB = orderBucket(b);
        if (bucketA !== bucketB) {
          return bucketA - bucketB;
        }
        return b.total_payout - a.total_payout;
      }),
    [rawOrders],
  );
  const [helpOpen, setHelpOpen] = useState(false);

  return (
    <>
      <div style={{ marginBottom: 10 }}>
        <button
          type="button"
          style={{
            ...inkButtonStyle({}),
            fontSize: FONT_BODY,
            padding: '2px 6px',
          }}
          onClick={() => setHelpOpen((v) => !v)}
        >
          {helpOpen ? '收起贸易订单说明' : '关于贸易订单'}
        </button>
        {helpOpen && <HelpPanel />}
      </div>

      {orders.length === 0 ? (
        <EmptyMessage text="暂无发布的常设订单. 请稍后再来查看." />
      ) : (
        <div style={orderGridStyle}>
          {orders.map((o, i) => <OrderCard key={i} order={o} />)}
        </div>
      )}
    </>
  );
};

const OrderCard = ({ order }: { order: TradeOrder }) => {
  return (
    <div style={{ ...cardStyle, marginBottom: 0, minHeight: 280 }}>
      <div style={{ display: 'flex', alignItems: 'baseline', flexWrap: 'wrap' }}>
        {!!order.urgent && (
          <span style={badgeStyle(SEAL_RED)}>紧急</span>
        )}
        {!!order.blockaded && (
          <span style={badgeStyle(SEAL_RED)}>已封锁</span>
        )}
        {!!order.warehouse && (
          <span style={badgeStyle(SEAL_BLUE)}>仓库</span>
        )}
        {!!order.stockpile && (
          <span style={badgeStyle(SEAL_GREEN)}>储备库</span>
        )}
        {!!order.petitioned && (
          <span style={badgeStyle(PETITION_PURPLE)}>总管请愿</span>
        )}
      </div>

      <div
        style={{
          fontSize: FONT_TITLE,
          fontWeight: 'bold',
          color: INK,
          fontFamily: SERIF,
          marginTop: 6,
        }}
      >
        {order.name}
      </div>
      <div
        style={{
          color: INK_SOFT,
          fontSize: FONT_BODY,
          marginTop: 2,
        }}
      >
        {order.region_label} &middot; 剩余 {order.days_left}天
      </div>

      {!!order.description && (
        <div
          style={{
            color: INK,
            fontSize: FONT_BODY,
            marginTop: 6,
            whiteSpace: 'pre-wrap',
          }}
        >
          {order.description}
        </div>
      )}

      <div style={{ marginTop: 8 }}>
        <div style={fieldLabelStyle}>所需</div>
        <div style={{ marginTop: 2, color: INK }}>
          {order.requirements.length === 0 ? (
            <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>
              - 暂无记录 -
            </span>
          ) : (
            order.requirements
              .map((r) => `${r.quantity} ${r.label}`)
              .join(', ')
          )}
        </div>
      </div>

      <div
        style={{
          marginTop: 8,
          display: 'flex',
          alignItems: 'baseline',
          gap: 8,
        }}
      >
        <span style={fieldLabelStyle}>
          酬金
        </span>
        <span
          style={{
            color: SEAL_AMBER,
            fontWeight: 'bold',
            fontSize: FONT_BODY,
          }}
        >
          {order.total_payout}m
        </span>
      </div>
    </div>
  );
};

const fieldLabelStyle: React.CSSProperties = {
  color: SEAL_AMBER,
  fontSize: FONT_BODY,
};

const EmptyMessage = ({ text }: { text: string }) => (
  <div
    style={{
      color: INK_FAINT,
      textAlign: 'center',
      padding: '24px 0',
    }}
  >
    {text}
  </div>
);

const HelpPanel = () => (
  <div
    style={{
      marginTop: 8,
      padding: '8px 12px',
      background: 'var(--p-card-bg)',
      border: `1px solid ${INK_FAINT}`,
      color: INK_SOFT,
      fontSize: FONT_BODY,
      lineHeight: 1.5,
    }}
  >
    <p style={{ margin: '0 0 6px 0' }}>
      常设订单由王国的储备库与商人发布.
      前往神经主处找总管或书记官,
      以完成一份储备库订单.
    </p>
    <p style={{ margin: '0 0 6px 0' }}>
      <b>仓库</b>标记的订单需要把成品留在总管出口机
      处等待收取. 该送进储备库的货物,
      仍应交付给储备库.
    </p>
    <p style={{ margin: '0 0 6px 0' }}>
      当在手货物的价值达到订单价值的至少 50% 时, 可以按短缺额结算,
      并按已交付份额的 85% 支付 - 其余部分视为放弃.
    </p>
    <p style={{ margin: 0 }}>
      <b>已封锁</b>的地区在封锁解除之前无法由贸易商队抵达;
      <b>总管请愿</b>的订单由总管直接提出,
      并按较低的比例支付.
    </p>
  </div>
);
