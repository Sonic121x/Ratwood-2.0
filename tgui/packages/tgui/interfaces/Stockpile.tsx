import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subTabBarStyle,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type StockRow = {
  ref: string;
  name: string;
  desc: string;
  category: string;
  amount: number;
  limit: number;
  withdraw_price: number;
  deposit_price: number;
  export_price: number;
  import_price: number;
  withdraw_disabled: BooleanLike;
  accept_enabled: BooleanLike;
  event_tag: string;
  shortage_progress: number;
  shortage_target: number;
  shortage_affected: string;
};

type Bounty = {
  name: string;
  payout_price: number;
  percent: BooleanLike;
};

type Data = {
  budget: number;
  compact: BooleanLike;
  categories: string[];
  category: string;
  food_stipend: BooleanLike;
  fiscal_authority: BooleanLike;
  treasury_floor: number;
  below_floor: BooleanLike;
  charter_unlocked: BooleanLike;
  charter_active: BooleanLike;
  charter_margin: number;
  charter_volume: number;
  charter_threshold: number;
  stocks: StockRow[];
  bounties: Bounty[];
  no_deposit: BooleanLike;
  title: string;
  subtitle: string;
  community_progress: number;
  community_target: number;
  community_points: number;
  community_visible: BooleanLike;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

// Display-only labels: backend category/event keys stay English for filtering.
const CATEGORY_LABELS: Record<string, string> = {
  'Raw Materials': '原材料',
  Refined: '精炼物',
  Alchemy: '炼金',
  Fruit: '水果',
  Vegetable: '蔬菜',
  Animal: '动物',
  Seafood: '海产',
};

const EVENT_LABELS: Record<string, string> = {
  SHORTAGE: '短缺',
  GLUT: '过剩',
};

const CharterChip = (props: { data: Data }) => {
  const { data } = props;
  let label: string;
  let color: string;
  if (!data.charter_unlocked) {
    label = `特许状 ${data.charter_volume}/${data.charter_threshold}`;
    color = INK_FAINT;
  } else if (data.charter_active) {
    label = `特许状已生效 ${data.charter_margin}%`;
    color = SEAL_GREEN;
  } else {
    label = `特许状已中止 ${data.charter_margin}%`;
    color = SEAL_RED;
  }
  return (
    <span
      style={{
        color,
        fontWeight: 'bold',
        fontSize: FONT_BODY,
        fontFamily: SERIF,
      }}
    >
      {label}
    </span>
  );
};
const CommunityChip = (props: { data: Data }) => {
  const { data } = props;
  return (
    <span
      style={{
        color: SEAL_GREEN,
        fontWeight: 'bold',
        fontSize: FONT_BODY,
        fontFamily: SERIF,
      }}
      title="你每存入 40 单位货物就能获得一点社群声望 - 为你下一次梦境的睡眠点数提供加成."
    >
      社群声望 {data.community_progress}/{data.community_target}
      {data.community_points > 0 && ` (声望 ${data.community_points})`}
    </span>
  );
};
const StockRowView = (props: {
  row: StockRow;
  data: Data;
  act: ActFn;
  compact: boolean;
}) => {
  const { row, data, act, compact } = props;
  const noDeposit = !!data.no_deposit;
  // Ratwood deviation: the food stipend only covers food categories (backend-gated too)
  const stipendCovers =
    !!data.food_stipend &&
    ['Fruit', 'Vegetable', 'Animal', 'Seafood'].includes(row.category);
  const embargoed = !!row.withdraw_disabled && !data.fiscal_authority;
  const overriding = !!row.withdraw_disabled && !!data.fiscal_authority;
  const canWithdraw =
    !embargoed &&
    row.amount > 0 &&
    (row.withdraw_price <= data.budget || stipendCovers);
  const canImport =
    !embargoed && row.import_price > 0 && row.import_price <= data.budget;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        flexWrap: 'wrap',
        gap: '6px',
        padding: '2px 6px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
      }}
    >
      <div style={{ flex: '1 1 200px', minWidth: 0 }}>
        <span style={{ color: INK, fontWeight: 'bold' }}>{row.name}</span>
        <span style={{ color: INK_SOFT, marginLeft: '6px' }}>
          {row.amount}/{row.limit}
        </span>
        {!!row.event_tag && (
          <span
            style={{
              color: row.event_tag === 'GLUT' ? SEAL_GREEN : SEAL_RED,
              fontWeight: 'bold',
              fontSize: FONT_BODY,
              marginLeft: '6px',
              padding: '0 4px',
              border: `1px solid ${row.event_tag === 'GLUT' ? SEAL_GREEN : SEAL_RED}`,
              borderRadius: '2px',
            }}
            title={
              row.event_tag === 'SHORTAGE' && row.shortage_target > 0
                ? `再出口或出售 ${row.shortage_target - row.shortage_progress} 单位即可结束短缺. 以下货物均计入: ${row.shortage_affected}.`
                : undefined
            }
          >
            {EVENT_LABELS[row.event_tag] ?? row.event_tag}
            {row.event_tag === 'SHORTAGE' && row.shortage_target > 0 && (
              <span style={{ marginLeft: '4px', fontWeight: 'normal' }}>
                ({row.shortage_progress} / {row.shortage_target})
              </span>
            )}
          </span>
        )}
        {!row.accept_enabled && !noDeposit && (
          <span
            style={{
              color: INK_FAINT,
              fontSize: FONT_BODY,
              marginLeft: '4px',
            }}
          >
            (不收存入)
          </span>
        )}
        {!!row.withdraw_disabled && (
          <span
            style={{
              color: SEAL_RED,
              fontSize: FONT_BODY,
              marginLeft: '4px',
            }}
          >
            (不可取出)
          </span>
        )}
        {!compact && row.desc && (
          <span
            style={{
              color: INK_SOFT,
              fontSize: FONT_BODY,
              marginLeft: '6px',
            }}
          >
            - {row.desc}
          </span>
        )}
      </div>
      <div
        style={{
          flex: noDeposit ? '0 0 210px' : '0 0 304px',
          display: 'flex',
          gap: '4px',
          justifyContent: 'flex-end',
          alignItems: 'center',
        }}
      >
        {!noDeposit && (
          <span
            style={{
              display: 'inline-block',
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              fontWeight: 'bold',
              padding: '1px 8px',
              color: SEAL_AMBER,
              background: 'transparent',
              border: `1px dashed ${SEAL_AMBER}`,
              borderRadius: '2px',
              width: '90px',
              textAlign: 'center',
              boxSizing: 'border-box',
            }}
            title={
              row.export_price > 0
                ? `存入价格 ${row.deposit_price}m. 当仓储满时, 王权会将你的存货出口到本地各区域 (出口价每单位 ${row.export_price}m, 归王权所有).`
                : '存入价格 - 将对应的货物丢在机器处以出售.'
            }
          >
            出售 {row.deposit_price}m
          </span>
        )}
        <button
          type="button"
          style={{
            ...inkButtonStyle({ disabled: !canWithdraw }),
            width: '90px',
            textAlign: 'center',
            boxSizing: 'border-box',
          }}
          disabled={!canWithdraw}
          onClick={() => act('withdraw', { ref: row.ref })}
          title={
            overriding
              ? '已对公众关闭. 作为书记官 / 总管家, 你可以取出.'
              : undefined
          }
        >
          {embargoed ? '已关闭' : `购买 ${row.withdraw_price}m`}
        </button>
        <button
          type="button"
          style={{
            ...inkButtonStyle({ disabled: !canImport }),
            width: '110px',
            textAlign: 'center',
            boxSizing: 'border-box',
          }}
          disabled={!canImport}
          onClick={() => act('direct_import', { ref: row.ref })}
          title={
            row.import_price <= 0
              ? '今日没有任何地区供应这种货物.'
              : overriding
                ? '已对公众关闭. 作为书记官 / 总管家, 你可以取出.'
                : data.charter_active
                  ? '直接进口. 需向王权缴税.'
                  : '直接进口. 附加费用于支付运输.'
          }
        >
          {row.import_price > 0 ? `进口 ${row.import_price}m` : '无供应'}
        </button>
      </div>
    </div>
  );
};

const CONDITIONS_KEY = '__conditions__';

export const Stockpile = () => {
  const { act, data } = useBackend<Data>();
  const compact = !!data.compact;
  const conditionsCount = data.stocks.filter((r) => !!r.event_tag).length;
  const isConditionsTab = data.category === CONDITIONS_KEY;
  const filtered = isConditionsTab
    ? data.stocks.filter((r) => !!r.event_tag)
    : data.stocks.filter((r) => r.category === data.category);
  const noDeposit = !!data.no_deposit;
  return (
    <Window width={780} height={720} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>{data.title || '镇属仓储'}</div>
          <div style={subtitleStyle}>
            {data.subtitle ||
              '镇属仓储. 将货物存入机器, 这里的钱币用于支付取货与进口.'}
          </div>
          <div style={rulerStyle} />

          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '4px 8px',
              borderBottom: `1px solid ${PARCHMENT_SHADOW}`,
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              marginBottom: '6px',
              flexWrap: 'wrap',
            }}
          >
            <span style={{ color: SEAL_AMBER }}>
              钱袋
            </span>
            <span
              style={{
                color: data.budget > 0 ? INK : INK_FAINT,
                fontWeight: 'bold',
              }}
            >
              {data.budget}m
            </span>
            {!!data.food_stipend && (
              <span style={{ color: SEAL_GREEN }}>
                国库专线
              </span>
            )}
            {!!data.below_floor && (
              <span style={{ color: SEAL_RED }}>
                王权账册吃紧
              </span>
            )}
            <CharterChip data={data} />
            {!!data.community_visible && <CommunityChip data={data} />}
            <div style={{ marginLeft: 'auto', display: 'flex', gap: '4px' }}>
              <button
                type="button"
                style={inkButtonStyle({ disabled: data.budget <= 0 })}
                disabled={data.budget <= 0}
                onClick={() => act('refund_budget')}
              >
                退款
              </button>
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => act('toggle_compact')}
              >
                {compact ? '详细' : '紧凑'}
              </button>
            </div>
          </div>

          <div style={subTabBarStyle}>
            <div
              style={subTabStyle(isConditionsTab)}
              onClick={() => act('set_category', { category: CONDITIONS_KEY })}
            >
              状况 {conditionsCount > 0 && `(${conditionsCount})`}
            </div>
            {data.categories.map((c) => (
              <div
                key={c}
                style={subTabStyle(c === data.category)}
                onClick={() => act('set_category', { category: c })}
              >
                {CATEGORY_LABELS[c] ?? c}
              </div>
            ))}
          </div>

          <div style={sectionHeaderStyle}>
            {isConditionsTab
              ? `市场状况 (${filtered.length})`
              : `${CATEGORY_LABELS[data.category] ?? data.category} (${filtered.length})`}
          </div>
          {filtered.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                fontStyle: 'italic',
                color: INK_SOFT,
              }}
            >
              该分类下没有库存.
            </div>
          ) : (
            filtered.map((row) => (
              <StockRowView
                key={row.ref}
                row={row}
                data={data}
                act={act}
                compact={compact}
              />
            ))
          )}

          {!noDeposit && data.bounties.length > 0 && (
            <>
              <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
                常设悬赏
              </div>
              {data.bounties.map((b) => (
                <div
                  key={b.name}
                  style={{
                    display: 'flex',
                    gap: '8px',
                    padding: '4px 8px',
                    borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
                    fontFamily: SERIF,
                    fontSize: FONT_BODY,
                  }}
                >
                  <span style={{ flex: 1, color: INK }}>{b.name}</span>
                  <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                    {b.payout_price}
                    {b.percent ? '%' : 'm'}
                  </span>
                </div>
              ))}
            </>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
