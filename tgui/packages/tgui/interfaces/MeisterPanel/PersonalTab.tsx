import { useState } from 'react';

import {
  BUTTON_BG,
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import { type TabProps } from './types';

const DENOMS = [
  { id: 'GOLD', label: '金币', value: 10 },
  { id: 'SILVER', label: '银币', value: 5 },
  { id: 'BRONZE', label: '铜币', value: 1 },
];

export const PersonalTab = ({ data, act }: TabProps) => {
  const [denom, setDenom] = useState<string>('GOLD');
  const [coinAmount, setCoinAmount] = useState<string>('');
  const [repayAmount, setRepayAmount] = useState<string>('');

  const numericCoins = parseInt(coinAmount, 10) || 0;
  const denomMod = DENOMS.find((d) => d.id === denom)?.value ?? 1;
  const totalDraw = numericCoins * denomMod;
  const drawDisabled =
    numericCoins < 1 ||
    numericCoins > 20 ||
    totalDraw > data.account_balance;

  const numericRepay = parseInt(repayAmount, 10) || 0;
  const loan = data.active_loan;
  const repayDisabled =
    !loan ||
    numericRepay < 1 ||
    numericRepay > Math.min(loan.remaining, data.account_balance);

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>个人账户</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>余额</div>
        <div style={fieldValueStyle}>
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {data.account_balance}m
          </span>
        </div>
      </div>

      <div style={sectionHeaderStyle}>提取钱币</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>面额</div>
        <div style={fieldValueStyle}>
          {DENOMS.map((d) => (
            <button
              type="button"
              key={d.id}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: denom === d.id ? 'bold' : 'normal',
                background:
                  denom === d.id
                    ? 'var(--p-tab-active-bg)'
                    : BUTTON_BG,
              }}
              onClick={() => setDenom(d.id)}
            >
              {d.label} ({d.value}m)
            </button>
          ))}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>枚数</div>
        <div style={fieldValueStyle}>
          <input
            type="number"
            min={1}
            max={20}
            value={coinAmount}
            onChange={(e) => setCoinAmount(e.target.value)}
            style={{ ...inkInputStyle, width: 90 }}
          />
          <span style={{ marginLeft: 6, color: INK_FAINT }}>
            （最多 20 枚；合计 {totalDraw}m）
          </span>
        </div>
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: drawDisabled })}
          disabled={drawDisabled}
          onClick={() => {
            act('withdraw_personal', {
              denomination: denom,
              amount: numericCoins,
            });
            setCoinAmount('');
          }}
        >
          提取钱币
        </button>
      </div>

      <div style={sectionHeaderStyle}>未结贷款</div>
      {!loan && (
        <div style={{ color: INK_SOFT }}>
          你的记录中没有未结的贷款。
        </div>
      )}
      {!!loan && (
        <>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>债权人</div>
            <div style={fieldValueStyle}>{loan.creditor}</div>
          </div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>所欠</div>
            <div style={fieldValueStyle}>
              尚欠 {loan.remaining}m，本金 {loan.principal}m，日息{' '}
              {loan.interest_pct}%
            </div>
          </div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>状态</div>
            <div style={fieldValueStyle}>
              {loan.defaulted ? (
                <span style={{ color: SEAL_RED, fontWeight: 'bold' }}>
                  已于第 {loan.due_on_day} 天违约
                </span>
              ) : (
                <span>
                  到期日第 {loan.due_on_day} 天（尚余 {loan.days_until_due}
                  {' '}天）
                </span>
              )}
            </div>
          </div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>偿还</div>
            <div style={fieldValueStyle}>
              <input
                type="number"
                min={1}
                max={Math.min(loan.remaining, data.account_balance)}
                value={repayAmount}
                onChange={(e) => setRepayAmount(e.target.value)}
                style={{ ...inkInputStyle, width: 110 }}
              />
              <span style={{ marginLeft: 6, color: INK_FAINT }}>玛门</span>
            </div>
          </div>
          <div style={{ marginTop: 6, textAlign: 'right' }}>
            <button
              type="button"
              style={inkButtonStyle({ disabled: repayDisabled })}
              disabled={repayDisabled}
              onClick={() => {
                act('repay_loan', { amount: numericRepay });
                setRepayAmount('');
              }}
            >
              偿还
            </button>
          </div>
        </>
      )}
    </div>
  );
};
