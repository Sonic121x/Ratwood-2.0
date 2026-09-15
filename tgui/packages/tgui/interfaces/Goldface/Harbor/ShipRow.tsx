import { useState } from 'react';

import {
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  FONT_HEAD,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import type { ActFn, BulkLine, HarborRealm, HarborShip } from '../types';
import { RealmCard } from './RealmCard';

const formatDuration = (totalSeconds: number) => {
  if (totalSeconds <= 0) return '现在';
  const minutes = Math.floor(totalSeconds / 60);
  if (minutes < 1) return '不到一分钟';
  if (minutes === 1) return '1 分钟';
  return `${minutes} 分钟`;
};

const SMALL_WORDS = new Set([
  'a',
  'an',
  'and',
  'as',
  'at',
  'but',
  'by',
  'for',
  'in',
  'of',
  'on',
  'or',
  'the',
  'to',
  'with',
]);

const titleCase = (s: string) =>
  s
    .split(' ')
    .map((word, i) => {
      if (!word) return word;
      const lower = word.toLowerCase();
      if (i > 0 && SMALL_WORDS.has(lower)) return lower;
      return lower.charAt(0).toUpperCase() + lower.slice(1);
    })
    .join(' ');

type Props = {
  ship: HarborShip;
  budget: number;
  act: ActFn;
  realm?: HarborRealm;
  onHail?: () => void;
  hailDisabled?: boolean;
  hailDisabledReason?: string;
  onSendAway?: () => void;
};

type DemandGroup = 'goods' | 'food' | 'drinks';

const DEMAND_GROUP_ORDER: DemandGroup[] = ['goods', 'food', 'drinks'];

const DEMAND_GROUP_LABEL: Record<DemandGroup, string> = {
  goods: '货物',
  food: '食物',
  drinks: '饮料',
};

const tagToDemandGroup = (tag?: string): DemandGroup => {
  if (tag === 'victualling_drinks') {
    return 'drinks';
  }
  if (tag === 'victualling_fresh' || tag === 'victualling_preserved') {
    return 'food';
  }
  return 'goods';
};

const DemandGroupDivider = (props: { label: string }) => (
  <div
    style={{
      display: 'flex',
      alignItems: 'center',
      gap: '6px',
      margin: '6px 0 2px',
    }}
  >
    <div style={{ flex: 1, borderTop: `1px dashed ${PARCHMENT_SHADOW}` }} />
    <span
      style={{
        color: SEAL_AMBER,
        fontFamily: SERIF,
        fontWeight: 'bold',
        fontSize: FONT_SMALL,
        letterSpacing: '1px',
      }}
    >
      {props.label}
    </span>
    <div style={{ flex: 1, borderTop: `1px dashed ${PARCHMENT_SHADOW}` }} />
  </div>
);

const DemandLineRow = (props: { line: BulkLine }) => {
  const { line } = props;
  const done = line.qty_fulfilled >= line.qty_target;
  const hasKin =
    line.kin_offered_price !== undefined &&
    line.kin_offered_price > line.offered_price;
  const displayedPrice = hasKin
    ? (line.kin_offered_price as number)
    : line.offered_price;
  return (
    <div
      style={{
        ...denseRowStyle,
        alignItems: 'baseline',
        padding: '2px 0',
        borderBottom: 'none',
        fontSize: FONT_BODY,
        color: SEAL_GREEN,
      }}
      title={
        hasKin
          ? `收购 ${line.qty_target} ${titleCase(line.good_name)}, 单价 ${displayedPrice}m (亲缘 +${displayedPrice - line.offered_price}m, 基础价 ${line.offered_price}m). 目前已交付 ${line.qty_fulfilled}.`
          : `收购 ${line.qty_target} ${titleCase(line.good_name)}, 单价 ${line.offered_price}m (目前已交付 ${line.qty_fulfilled})`
      }
    >
      <span style={ellipsisCellStyle}>{titleCase(line.good_name)}</span>
      <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
        {line.qty_fulfilled}/{line.qty_target}
      </span>
      <span style={{ flex: '0 0 auto', fontWeight: 'bold' }}>
        {hasKin && (
          <span
            style={{
              color: INK_FAINT,
              textDecoration: 'line-through',
              marginRight: '4px',
              fontWeight: 'normal',
            }}
          >
            {line.offered_price}m
          </span>
        )}
        <span
          style={{
            color: done ? INK_FAINT : hasKin ? SEAL_GREEN : SEAL_AMBER,
          }}
        >
          {displayedPrice}m
        </span>
      </span>
    </div>
  );
};

const SupplyLineRow = (props: {
  line: BulkLine;
  shipId: string;
  budget: number;
  act: ActFn;
}) => {
  const { line, shipId, budget, act } = props;
  const remaining = Math.max(0, line.qty_target - line.qty_fulfilled);
  const initial = Math.min(remaining, 1);
  const [qty, setQty] = useState(initial);
  const safeQty = Math.min(Math.max(1, qty), remaining || 1);
  const hasKin =
    line.kin_offered_price !== undefined &&
    line.kin_offered_price < line.offered_price;
  const unitPrice = hasKin ? (line.kin_offered_price as number) : line.offered_price;
  const totalCost = unitPrice * safeQty;
  const cantAfford = budget < totalCost;
  const soldOut = remaining <= 0;
  return (
    <div
      style={{
        ...denseRowStyle,
        alignItems: 'baseline',
        padding: '2px 0',
        borderBottom: 'none',
        fontSize: FONT_BODY,
        color: SEAL_RED,
      }}
      title={
        hasKin
          ? `出售 ${titleCase(line.good_name)}, 单价 ${unitPrice}m (亲缘 -${line.offered_price - unitPrice}m, 原价 ${line.offered_price}m). 已售出 ${line.qty_fulfilled} / ${line.qty_target}.`
          : `出售 ${titleCase(line.good_name)}, 单价 ${line.offered_price}m (已售出 ${line.qty_fulfilled} / ${line.qty_target})`
      }
    >
      <span style={ellipsisCellStyle}>{titleCase(line.good_name)}</span>
      <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
        {line.qty_fulfilled}/{line.qty_target}
      </span>
      {hasKin ? (
        <span style={{ flex: '0 0 auto', fontWeight: 'bold' }}>
          <span
            style={{
              color: INK_FAINT,
              textDecoration: 'line-through',
              marginRight: '4px',
              fontWeight: 'normal',
            }}
          >
            {line.offered_price}m
          </span>
          <span style={{ color: SEAL_GREEN }}>{unitPrice}m</span>
        </span>
      ) : (
        <span style={{ flex: '0 0 auto', color: SEAL_AMBER, fontWeight: 'bold' }}>
          {line.offered_price}m
        </span>
      )}
      {soldOut ? (
        <span style={{ color: INK_FAINT }}>已售罄</span>
      ) : (
        <>
          <input
            type="number"
            min={1}
            max={remaining}
            step={1}
            value={safeQty}
            onChange={(e) => {
              const next = Number(e.target.value);
              if (!Number.isNaN(next)) setQty(next);
            }}
            style={{
              width: '42px',
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              color: INK,
              background: 'var(--p-button-bg)',
              border: `1px solid ${INK_FAINT}`,
              borderRadius: '2px',
              padding: '1px 3px',
              textAlign: 'right',
            }}
          />
          <button
            type="button"
            style={compactButtonStyle({ disabled: cantAfford })}
            disabled={cantAfford}
            title={
              cantAfford
                ? `需要 ${totalCost}m, 持有 ${budget}m`
                : `以 ${totalCost}m 购买 ${safeQty}`
            }
            onClick={() =>
              act('bulk_buy', {
                ship_id: shipId,
                good: line.good,
                qty: safeQty,
              })
            }
          >
            购买
          </button>
        </>
      )}
    </div>
  );
};

export const ShipRow = (props: Props) => {
  const {
    ship,
    budget,
    act,
    realm,
    onHail,
    hailDisabled,
    hailDisabledReason,
    onSendAway,
  } = props;
  const hasBulk =
    (ship.bulk_demands?.length ?? 0) + (ship.bulk_supplies?.length ?? 0) > 0;
  const [realmOpen, setRealmOpen] = useState(false);
  return (
    <div
      style={{
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
        }}
      >
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ color: INK, fontWeight: 'bold', fontSize: FONT_TITLE }}>
            {!!ship.auto_hailed && (
              <span
                title="此船在无商人看管港口时擅自驶入. 你可无偿将其遣走, 不受惩罚."
                style={{
                  marginRight: '6px',
                  padding: '0 4px',
                  border: `1px solid ${SEAL_AMBER}`,
                  borderRadius: '6px',
                  color: SEAL_AMBER,
                  fontSize: FONT_BODY,
                  fontWeight: 'bold',
                  letterSpacing: '0.5px',
                  verticalAlign: 'middle',
                }}
              >
                漂入
              </span>
            )}
            {ship.ship_name}
          </div>
          {ship.captain_name && (
            <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
              船长 {ship.captain_name}
              {ship.port_of_origin ? ` - 来自 ${ship.port_of_origin}` : ''}
            </div>
          )}
          {!ship.captain_name && ship.port_of_origin && (
            <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
              来自 {ship.port_of_origin}
            </div>
          )}
          {ship.seconds_until_departure !== undefined && (
            <div style={{ color: SEAL_AMBER, fontSize: FONT_LEAD }}>
              {formatDuration(ship.seconds_until_departure)}后离港
            </div>
          )}
        </div>
        <div
          style={{
            flex: '0 0 auto',
            textAlign: 'right',
            color: INK_SOFT,
            fontSize: FONT_LEAD,
            lineHeight: 1.3,
          }}
        >
          <div
            title={`吨位会影响可供货物的数量与预期恩惠. 100t 为基准 = 1.00x, 800t 大帆船封顶 2.00x. 本船: ${ship.tonnage_mult.toFixed(2)}x.`}
            style={{ position: 'relative' }}
          >
            {realm ? (
              <button
                type="button"
                onClick={(e) => {
                  e.stopPropagation();
                  setRealmOpen((o) => !o);
                }}
                style={{
                  background: 'transparent',
                  border: 'none',
                  padding: 0,
                  margin: 0,
                  color: SEAL_AMBER,
                  fontFamily: SERIF,
                  fontSize: 'inherit',
                  cursor: 'pointer',
                  borderBottom: `1px dotted ${SEAL_AMBER}`,
                }}
                title="点击查看该国度的常规需求与出售之物"
              >
                {ship.realm_id}
              </button>
            ) : (
              <span style={{ color: SEAL_AMBER }}>
                {ship.realm_id}
              </span>
            )}
            <span style={{ color: INK_FAINT }}> &middot; </span>
            {ship.ship_type} &middot; {ship.tonnage}t
            {ship.tonnage_mult > 1.0 && (
              <span style={{ color: SEAL_AMBER }}>
                {' '}({ship.tonnage_mult.toFixed(2)}x)
              </span>
            )}
            {realm && realmOpen && (
              <div
                onClick={(e) => e.stopPropagation()}
                style={{
                  position: 'absolute',
                  top: '100%',
                  right: 0,
                  marginTop: '4px',
                  zIndex: 10,
                  width: '320px',
                  textAlign: 'left',
                  padding: '8px 10px',
                  background: 'var(--p-bg)',
                  border: `1px solid ${INK}`,
                  borderRadius: '2px',
                  boxShadow: '2px 3px 8px rgba(0, 0, 0, 0.35)',
                  fontFamily: SERIF,
                  fontSize: FONT_BODY,
                  color: INK,
                }}
              >
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'baseline',
                    justifyContent: 'space-between',
                    marginBottom: '6px',
                  }}
                >
                  <span
                    style={{
                      color: SEAL_AMBER,
                      fontWeight: 'bold',
                      fontSize: FONT_BODY,
                    }}
                  >
                    {realm.name}
                  </span>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      setRealmOpen(false);
                    }}
                    style={{
                      background: 'transparent',
                      border: 'none',
                      color: INK_SOFT,
                      cursor: 'pointer',
                      fontSize: FONT_BODY,
                      padding: '0 4px',
                      lineHeight: 1,
                    }}
                    title="关闭"
                  >
                    ✕
                  </button>
                </div>
                <RealmCard realm={realm} />
              </div>
            )}
          </div>
          {ship.expected_favor > 0 && (
            <div
              style={{ color: SEAL_AMBER }}
              title={`送行恩惠: 达成目标 100% 为受敬, 你可获得全额交付价值作为恩惠, 并退还招呼. 达成 50% 为部分, 你可获得半数交付价值作为恩惠. 低于 50% 为失敬, 该船将扣除 ${Math.round(250 * ship.tonnage_mult)}m 恩惠.`}
            >
              {!!ship.is_kin && (
                <span
                  title="亲缘船只 - 亲缘加成生效"
                  style={{
                    marginRight: '6px',
                    padding: '0 4px',
                    border: `1px solid ${SEAL_GREEN}`,
                    borderRadius: '6px',
                    color: SEAL_GREEN,
                    fontSize: FONT_BODY,
                    fontWeight: 'bold',
                    letterSpacing: '0.5px',
                    verticalAlign: 'middle',
                  }}
                >
                  亲缘
                </span>
              )}
              恩惠: {ship.favor_earned}m / {ship.expected_favor}m
            </div>
          )}
        </div>
        {onHail && (
          <div style={{ flexShrink: 0 }}>
            <button
              type="button"
              style={inkButtonStyle({ disabled: !!hailDisabled })}
              disabled={!!hailDisabled}
              title={hailDisabled ? hailDisabledReason : '招呼此船'}
              onClick={onHail}
            >
              招呼
            </button>
          </div>
        )}
        {onSendAway && (
          <div style={{ flexShrink: 0 }}>
            <button
              type="button"
              style={inkButtonStyle({ disabled: !ship.can_send_away })}
              disabled={!ship.can_send_away}
              title={
                ship.auto_hailed
                  ? '此船自行漂入 - 可无偿将其遣走, 不受惩罚.'
                  : ship.can_send_away
                    ? '提前将这艘船送走.'
                    : '她刚刚才靠岸.'
              }
              onClick={onSendAway}
            >
              遣走
            </button>
          </div>
        )}
      </div>
      {hasBulk && (
        <div
          style={{
            marginTop: '4px',
            display: 'grid',
            gridTemplateColumns: '1fr 1fr',
            gap: '0 16px',
          }}
        >
          <div
            style={{
              paddingLeft: '6px',
              borderLeft: `2px solid ${SEAL_GREEN}`,
            }}
          >
            <div
              style={{
                color: SEAL_GREEN,
                fontWeight: 'bold',
                fontSize: FONT_HEAD,
                marginBottom: '3px',
              }}
            >
              收购
            </div>
            {ship.bulk_demands?.length ? (
              (() => {
                const grouped: Record<DemandGroup, BulkLine[]> = {
                  goods: [],
                  food: [],
                  drinks: [],
                };
                for (const line of ship.bulk_demands) {
                  grouped[tagToDemandGroup(line.tag)].push(line);
                }
                return DEMAND_GROUP_ORDER.filter(
                  (g) => grouped[g].length > 0,
                ).map((g) => (
                  <div key={g}>
                    <DemandGroupDivider label={DEMAND_GROUP_LABEL[g]} />
                    {grouped[g].map((line, i) => (
                      <DemandLineRow
                        key={`d-${g}-${line.good || line.good_name}-${i}`}
                        line={line}
                      />
                    ))}
                  </div>
                ));
              })()
            ) : (
              <div style={{ color: INK_FAINT, fontSize: FONT_SMALL, fontStyle: 'italic' }}>
                无所需求.
              </div>
            )}
          </div>
          <div
            style={{
              paddingLeft: '6px',
              borderLeft: `2px solid ${SEAL_RED}`,
            }}
          >
            <div
              style={{
                color: SEAL_RED,
                fontWeight: 'bold',
                fontSize: FONT_HEAD,
                marginBottom: '3px',
              }}
            >
              出售
            </div>
            {ship.bulk_supplies?.length ? (
              ship.bulk_supplies.map((line) => (
                <SupplyLineRow
                  key={`s-${line.good}`}
                  line={line}
                  shipId={ship.ship_id}
                  budget={budget}
                  act={act}
                />
              ))
            ) : (
              <div style={{ color: INK_FAINT, fontSize: FONT_SMALL, fontStyle: 'italic' }}>
                暂无供货.
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};
