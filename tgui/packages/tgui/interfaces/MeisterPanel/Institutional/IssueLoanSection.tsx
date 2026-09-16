import { useState } from 'react';

import {
  BUTTON_BG,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  inkButtonStyle,
  inkInputStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
  tabBarStyle,
  tabStyle,
} from '../../common/parchment';
import { type FundEntry, type TabProps } from '../types';

type LoanTier = 'personal' | 'indenture';

const TERM_OPTIONS: number[] = [1, 2, 3];
const RATE_OPTIONS: number[] = [10, 15, 20, 25, 50];

export const IssueLoanSection = ({
  fund,
  data,
  act,
}: TabProps & { fund: FundEntry }) => {
  const [tier, setTier] = useState<LoanTier>('personal');
  const [amount, setAmount] = useState<string>('');
  const [term, setTerm] = useState<number>(2);
  const [rate, setRate] = useState<number>(25);
  const rateOptions = fund.allow_zero_rate
    ? [0, ...RATE_OPTIONS]
    : RATE_OPTIONS;
  const indentureTargets = data.funds.filter(
    (f) => f.id !== fund.id && f.supports_loans,
  );
  const [target, setTarget] = useState<string>(indentureTargets[0]?.id ?? '');

  const numeric = parseInt(amount, 10) || 0;
  // 已移除贷款发放日期窗口判断，保留金额和目标校验。
  const personalValid = numeric >= 50 && numeric <= 500;
  const indentureValid = numeric >= 501 && numeric <= 2000;
  const targetValid = tier === 'personal' || target !== '';
  const valid =
    (tier === 'personal' ? personalValid : indentureValid) && targetValid;
  const disabled = !valid;

  return (
    <>
      <div style={sectionHeaderStyle}>起草贷款</div>
      {/*pastWindow && (
        <div style={{ color: INK_FAINT, marginBottom: 8 }}>已移除超过截止日的贷款提示区。
          第 {data.max_issuance_day} 天之后不得再发放新贷款。个人贷款与机构契约在任意游戏日均可开具。
        </div>保留原有行位，方便后续对照和回调。
      )*/}
      <div style={tabBarStyle}>
        <div
          style={tabStyle(tier === 'personal')}
          onClick={() => setTier('personal')}
        >
          个人
        </div>
        <div
          style={tabStyle(tier === 'indenture')}
          onClick={() => setTier('indenture')}
        >
          契约
        </div>
      </div>

      {tier === 'indenture' && (
        <>
          <div
            style={{
              color: SEAL_AMBER,
              textAlign: 'center',
              marginBottom: 10,
            }}
          >
            契约一经接受与违约，都将公开宣告。
            {'举国上下皆会知晓。'}
          </div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>目标</div>
            <div style={fieldValueStyle}>
              {indentureTargets.length ? (
                indentureTargets.map((t) => (
                  <button
                    type="button"
                    key={t.id}
                    style={{
                      ...inkButtonStyle({}),
                      marginRight: 4,
                      fontWeight: target === t.id ? 'bold' : 'normal',
                      background:
                        target === t.id
                          ? 'var(--p-tab-active-bg)'
                          : BUTTON_BG,
                    }}
                    onClick={() => setTarget(t.id)}
                  >
                    {t.label}
                  </button>
                ))
              ) : (
                <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>
                  没有可选的机构。
                </span>
              )}
            </div>
          </div>
        </>
      )}

      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>本金</div>
        <div style={fieldValueStyle}>
          <input
            type="number"
            min={tier === 'personal' ? 50 : 501}
            max={tier === 'personal' ? 500 : 2000}
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            style={{ ...inkInputStyle, width: 110 }}
          />
          <span style={{ marginLeft: 6, color: INK_FAINT }}>
            {tier === 'personal' ? '(50 - 500m)' : '(501 - 2000m)'}
          </span>
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>期限</div>
        <div style={fieldValueStyle}>
          {TERM_OPTIONS.map((t) => (
            <button
              type="button"
              key={t}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: term === t ? 'bold' : 'normal',
                background:
                  term === t
                    ? 'var(--p-tab-active-bg)'
                    : BUTTON_BG,
              }}
              onClick={() => setTerm(t)}
            >
              {t} 天
            </button>
          ))}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>利率</div>
        <div style={fieldValueStyle}>
          {rateOptions.map((r) => (
            <button
              type="button"
              key={r}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: rate === r ? 'bold' : 'normal',
                background:
                  rate === r
                    ? 'var(--p-tab-active-bg)'
                    : BUTTON_BG,
              }}
              onClick={() => setRate(r)}
            >
              {r}%
            </button>
          ))}
        </div>
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled })}
          disabled={disabled}
          onClick={() => {
            act(tier === 'personal' ? 'issue_personal' : 'issue_indenture', {
              fund_id: fund.id,
              amount: numeric,
              term,
              rate,
              target: tier === 'indenture' ? target : undefined,
            });
            setAmount('');
          }}
        >
          签署令状
        </button>
      </div>
    </>
  );
};
