import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SEAL_RED_SOFT,
  sectionHeaderStyle,
  SERIF,
} from './common/parchment';

type CategoryRate = {
  category: string;
  rate: number;
};

type PollTaxRate = {
  category: string;
  label: string;
  rate: number;
};

type PollCategoryProjection = {
  category: string;
  rate: number;
  heads: number;
  taxable: number;
  per_tick: number;
};

type PollProjection = {
  income: number;
  subsidy: number;
  net: number;
  headcount: number;
  by_category: PollCategoryProjection[];
};

type Data = {
  categoryRates: CategoryRate[];
  pollTaxRates: PollTaxRate[];
  pollTaxMax: number;
  pollTaxMin: number;
  levyCooldown: boolean;
  pollCooldown: boolean;
  pollProjection: PollProjection;
};

const rowStyle: React.CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
  padding: '3px 0',
  borderBottom: '1px solid rgba(120,80,30,0.1)',
};

const labelStyle: React.CSSProperties = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: INK,
};

const PollProjectionPanel = (props: { projection: PollProjection }) => {
  const { projection } = props;
  const net = projection.net;
  const netColor = net > 0 ? SEAL_GREEN : net < 0 ? SEAL_RED : INK_SOFT;
  const netLabel =
    net > 0 ? `+${net}m / 每期` : net < 0 ? `${net}m / 每期` : '0m / 每期';
  return (
    <div
      style={{
        background: 'rgba(200,170,100,0.12)',
        border: `1px solid ${INK_FAINT}`,
        padding: '6px 10px',
        marginBottom: '10px',
        fontSize: FONT_BODY,
      }}
    >
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          marginBottom: '4px',
        }}
      >
        <span style={{ color: INK_SOFT, letterSpacing: '1px' }}>
          每期预计收支
        </span>
        <span style={{ color: netColor, fontWeight: 'bold' }}>{netLabel}</span>
      </div>
      <div
        style={{
          display: 'flex',
          gap: '12px',
          fontSize: FONT_BODY,
          color: INK_SOFT,
          marginBottom: '4px',
        }}
      >
        <span>
          收入：{' '}
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {projection.income}m
          </span>
        </span>
        <span>
          补贴：{' '}
          <span style={{ color: SEAL_RED_SOFT, fontWeight: 'bold' }}>
            -{projection.subsidy}m
          </span>
        </span>
        <span style={{ color: INK_FAINT, marginLeft: 'auto' }}>
          {projection.headcount} 人
        </span>
      </div>
      <div
        style={{
          fontSize: FONT_BODY,
          color: INK_SOFT,
        }}
      >
        按税额 × 应缴人数估算，未计入余额、预缴和欠税。
      </div>
    </div>
  );
};

export const TaxSetter = (props: any, context: any) => {
  const { act, data } = useBackend<Data>();
  // Backend exposes the levy and poll-tax once-per-day locks separately; each column gates on
  // its own. (The old single `onCooldown` key was never sent, so the lock UI was fully dead.)
  const levyCooldown = !!data.levyCooldown;
  const pollCooldown = !!data.pollCooldown;

  const [rates, setRates] = useState<Record<string, number>>(() => {
    if (!data.categoryRates) return {};
    return Object.fromEntries(
      data.categoryRates.map((c) => [c.category, c.rate]),
    );
  });

  const [pollRates, setPollRates] = useState<Record<string, number>>(() => {
    if (!data.pollTaxRates) return {};
    return Object.fromEntries(
      data.pollTaxRates.map((c) => [c.category, c.rate]),
    );
  });

  const updateRate = (category: string, newRate: number) => {
    setRates((prev) => ({ ...prev, [category]: newRate }));
  };

  const updatePollRate = (category: string, newRate: number) => {
    setPollRates((prev) => ({ ...prev, [category]: newRate }));
  };

  const payload = Object.entries(rates).map(([category, rate]) => ({
    category,
    rate,
  }));

  const pollPayload = Object.entries(pollRates).map(([category, rate]) => ({
    category,
    rate,
  }));

  const pollMax = data.pollTaxMax ?? 50;
  const pollMin = data.pollTaxMin ?? 0;
  const projection = data.pollProjection;

  return (
    <Window width={760} height={640} title="Tax Roll" display_title="税册" theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div
            style={{
              textAlign: 'center',
              fontSize: FONT_BODY,
              color: INK_SOFT,
              marginBottom: '10px',
            }}
          >
            税率每日只能调整一次，请慎重决定。
          </div>

          {(levyCooldown || pollCooldown) && (
            <div
              style={{
                background: 'rgba(140,60,30,0.12)',
                border: `1px solid ${SEAL_RED_SOFT}`,
                color: SEAL_RED_SOFT,
                padding: '6px 10px',
                textAlign: 'center',

                fontWeight: 'bold',
                marginBottom: '10px',
              }}
            >
              今日已调整税率，须待明日方可再次修改。
            </div>
          )}

          <div
            style={{
              display: 'flex',
              gap: '18px',
              alignItems: 'flex-start',
            }}
          >
            {/* Left column: Crown Levies */}
            <div style={{ flex: '0 0 300px' }}>
              <div style={sectionHeaderStyle}>王室征税</div>
              {data.categoryRates?.map((c) => (
                <div key={c.category} style={rowStyle}>
                  <span style={labelStyle}>{c.category}</span>
                  <NumberInput
                    step={1}
                    minValue={0}
                    maxValue={100}
                    unit="%"
                    value={rates[c.category] ?? c.rate}
                    onChange={(v: number) => updateRate(c.category, v)}
                  />
                </div>
              ))}
              <hr style={rulerStyle} />
              <div style={{ textAlign: 'center' }}>
                <button
                  disabled={levyCooldown}
                  style={{
                    ...inkButtonStyle({ disabled: levyCooldown }),
                    padding: '5px 24px',
                    fontSize: FONT_BODY,
                  }}
                  onClick={() =>
                    !levyCooldown && act('set_rates', { categoryRates: payload })
                  }
                >
                  确定
                </button>
              </div>
            </div>

            {/* Right column: Poll Tax */}
            <div style={{ flex: '1 1 auto', minWidth: 0 }}>
              <div style={sectionHeaderStyle}>人头税</div>
              <div
                style={{
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                  marginBottom: '8px',
                }}
              >
                按阶层每期结算。负数表示每期从
                王室金库向臣民发放补贴；正数表示征税。
                特许状保护的阶层可领取补贴，但免于缴税。
              </div>
              {projection && <PollProjectionPanel projection={projection} />}
              {data.pollTaxRates?.map((c) => (
                <div key={c.category} style={rowStyle}>
                  <span style={labelStyle}>{c.label}</span>
                  <NumberInput
                    step={1}
                    minValue={pollMin}
                    maxValue={pollMax}
                    unit="m"
                    value={pollRates[c.category] ?? c.rate}
                    onChange={(v: number) => updatePollRate(c.category, v)}
                  />
                </div>
              ))}
              <hr style={rulerStyle} />
              <div style={{ textAlign: 'center' }}>
                <button
                  disabled={pollCooldown}
                  style={{
                    ...inkButtonStyle({ disabled: pollCooldown }),
                    padding: '5px 24px',
                    fontSize: FONT_BODY,
                  }}
                  onClick={() =>
                    !pollCooldown &&
                    act('set_poll_rates', { pollTaxRates: pollPayload })
                  }
                >
                  设定人头税
                </button>
              </div>
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
