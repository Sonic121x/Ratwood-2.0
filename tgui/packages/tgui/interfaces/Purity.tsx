import { useState } from 'react';
import { Input } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { NativeButton } from '../components/Localized';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { PackRow } from './Goldface/PackRow';
import type { ActFn, VendingPack } from './Goldface/types';
import { starsIfIlliterate } from './Goldface/util';

type PurityData = {
  motto: string;
  budget: number;
  locked: BooleanLike;
  can_read: BooleanLike;
  is_proprietor: BooleanLike;
  dodging: BooleanLike;
  tariff_rate_pct: number;
  tariff_paid: number;
  tariff_evaded: number;
  recent_payments: number;
  secret_budget: number;
  cut_pct: number;
  upgrade_a_unlocked: BooleanLike;
  upgrade_b_unlocked: BooleanLike;
  upgrade_a_cost: number;
  upgrade_b_cost: number;
  withdraw_tax: number;
  withdraw_net: number;
  items: VendingPack[];
};

const SecretsCard = (props: {
  data: PurityData;
  canRead: boolean;
  act: ActFn;
}) => {
  const { data, canRead, act } = props;
  const noCut = data.secret_budget < 1;
  return (
    <div style={{ ...cardStyle, marginTop: '12px' }}>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          color: INK_SOFT,
          textAlign: 'center',
          marginBottom: '6px',
        }}
      >
        {starsIfIlliterate('秘密', canRead)}
      </div>
      <div
        style={{
          textAlign: 'center',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
        }}
      >
        <span style={{ color: INK_SOFT }}>
          {starsIfIlliterate('洗钱金额：', canRead)} {data.recent_payments}
        </span>
        <span style={{ color: INK_FAINT, margin: '0 6px' }}>·</span>
        <span style={{ color: SEAL_AMBER }}>
          {starsIfIlliterate('主人，这是您的分成！', canRead)} {data.secret_budget}
          m ({data.cut_pct}%)
        </span>
      </div>
      <div
        style={{
          textAlign: 'center',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          marginTop: '2px',
        }}
      >
        <span style={{ color: SEAL_GREEN }}>已缴税：{data.tariff_paid}m</span>
        <span style={{ color: INK_FAINT, margin: '0 6px' }}>·</span>
        <span style={{ color: SEAL_RED }}>逃税额：{data.tariff_evaded}m</span>
      </div>
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          gap: '6px',
          marginTop: '8px',
          flexWrap: 'wrap',
        }}
      >
        <NativeButton
          type="button"
          style={inkButtonStyle({ disabled: noCut })}
          disabled={noCut}
          title={`Deposit ${data.withdraw_net}m into your account - the Crown keeps ${data.withdraw_tax}m in duty`} display_title={`向账户存入 ${data.withdraw_net}m，王室扣留 ${data.withdraw_tax}m 作为税款`}
          onClick={() => act('withdraw_cut', { mode: 'bank' })}
        >
          存入银行（税后 {data.withdraw_net}m）
        </NativeButton>
        <NativeButton
          type="button"
          style={inkButtonStyle({ disabled: noCut })}
          disabled={noCut}
          title={`Withdraw the full ${data.secret_budget}m as coin - no duty paid, counted as tax evaded`} display_title={`将全部 ${data.secret_budget}m 提取为硬币；未缴税款，将计作逃税`}
          onClick={() => act('withdraw_cut', { mode: 'direct' })}
        >
          直接提取（未缴税）
        </NativeButton>
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('toggle_tax')}
        >
          {data.dodging ? '恢复缴税' : '停止缴税'}
        </button>
        {!data.upgrade_a_unlocked && (
          <NativeButton
            type="button"
            style={inkButtonStyle()}
            title="Raise your laundering cut from 10% to 25%" display_title="将洗钱分成从 10% 提高至 25%"
            onClick={() => act('unlock_cut', { level: 'a' })}
          >
            解锁 25% 分成（{data.upgrade_a_cost}）
          </NativeButton>
        )}
        {!!data.upgrade_a_unlocked && !data.upgrade_b_unlocked && (
          <NativeButton
            type="button"
            style={inkButtonStyle()}
            title="Raise your laundering cut from 25% to 50%" display_title="将洗钱分成从 25% 提高至 50%"
            onClick={() => act('unlock_cut', { level: 'b' })}
          >
            解锁 50% 分成（{data.upgrade_b_cost}）
          </NativeButton>
        )}
      </div>
    </div>
  );
};

export const Purity = () => {
  const { act, data } = useBackend<PurityData>();
  const canRead = !!data.can_read;
  const isProprietor = !!data.is_proprietor;
  const [search, setSearch] = useState('');
  const needle = search.trim().toLowerCase();
  const shown = needle
    ? data.items.filter((p) => p.name.toLowerCase().includes(needle))
    : data.items;

  return (
    <Window width={560} height={720} theme="parchment" display_title="纯净">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>{starsIfIlliterate(data.motto, canRead)}</div>
          <div style={subtitleStyle}>
            王室进口关税：<b>{data.tariff_rate_pct}%</b>
            {isProprietor && !!data.dodging && (
              <span style={{ color: SEAL_RED, marginLeft: '8px' }}>
                <b>（逃税中）</b>
              </span>
            )}
          </div>
          <div style={rulerStyle} />
          <div style={fieldRowStyle}>
            <div
              style={{
                flex: '0 0 auto',
                fontFamily: SERIF,
                color: SEAL_AMBER,
                marginRight: '12px',
              }}
            >
              {starsIfIlliterate('已存入玛门币', canRead)}
            </div>
            <div style={{ ...fieldValueStyle, fontWeight: 'bold' }}>
              {data.budget}m
            </div>
            <button
              type="button"
              style={inkButtonStyle({ disabled: data.budget <= 0 })}
              disabled={data.budget <= 0}
              onClick={() => act('change')}
            >
              提取硬币
            </button>
          </div>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              margin: '8px 0',
            }}
          >
            <span
              style={{
                fontFamily: SERIF,
                fontSize: FONT_BODY,
                color: INK_SOFT,
              }}
            >
              搜索：
            </span>
            <Input
              value={search}
              onChange={setSearch}
              placeholder="输入文字筛选库存……"
              width="240px"
            />
            {!!search && (
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => setSearch('')}
              >
                清空
              </button>
            )}
          </div>
          {shown.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                color: INK_SOFT,
              }}
            >
              {needle ? `没有与“${search}”匹配的商品。` : '暂无库存。'}
            </div>
          ) : (
            <div
              style={{
                columnCount: 2,
                columnGap: '12px',
              }}
            >
              {shown.map((p) => (
                <div key={p.ref} style={{ breakInside: 'avoid' }}>
                  <PackRow
                    pack={p}
                    budget={data.budget}
                    canRead={canRead}
                    showCategory={false}
                    browseOnly={false}
                    act={act}
                  />
                </div>
              ))}
            </div>
          )}
          {isProprietor && (
            <SecretsCard data={data} canRead={canRead} act={act} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
