import { useState } from 'react';

import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  inkButtonStyle,
  INK_FAINT,
  INK_SOFT,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import { PaginatedLog } from './PaginatedLog';
import { type TabProps } from './types';

export const LedgerTab = ({ data, act }: TabProps) => {
  const personal = data.active_loan;
  const institutional = data.institutional_loans;
  const [repayAmounts, setRepayAmounts] = useState<Record<number, string>>({});

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>我的债务</div>
      {!personal && (
        <div style={{ color: INK_SOFT }}>
          你没有任何欠债。
        </div>
      )}
      {!!personal && (
        <div style={fieldRowStyle}>
          <div style={fieldLabelStyle}>{personal.creditor}</div>
          <div style={fieldValueStyle}>
            尚欠 {personal.remaining}m，本金 {personal.principal}m，日息{' '}
            {personal.interest_pct}%
            {personal.defaulted ? (
              <span
                style={{
                  marginLeft: 8,
                  color: SEAL_RED,
                  fontWeight: 'bold',
                }}
              >
                已违约
              </span>
            ) : (
              <span style={{ marginLeft: 8, color: INK_FAINT }}>
                （约 {personal.minutes_until_due} 分钟后到期）
              </span>
            )}
          </div>
        </div>
      )}

      <div style={sectionHeaderStyle}>机构台账</div>
      {!institutional.length && (
        <div style={{ color: INK_SOFT }}>
          你所管辖的机构没有任何未结贷款。
        </div>
      )}
      {institutional.map((loan, i) => (
        <div key={i} style={{ ...fieldRowStyle, flexDirection: 'column', gap: '4px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div style={fieldLabelStyle}>{loan.creditor_label}</div>
            <div style={fieldValueStyle}>
              {loan.is_institutional ? (
                <>
                  对 <b>{loan.target_label}</b> 的契约：{' '}
                </>
              ) : (
                <>
                  发给 <b>{loan.debtor || '未知'}</b> 的贷款：{' '}
                </>
              )}
              尚欠 {loan.remaining}m，本金 {loan.principal}m，日息 {loan.interest_pct}%
              {loan.defaulted ? (
                <span
                  style={{
                    marginLeft: 8,
                    color: SEAL_RED,
                    fontWeight: 'bold',
                  }}
                >
                  已违约
                </span>
              ) : (
                <span style={{ marginLeft: 8, color: INK_FAINT }}>
                  （约 {loan.minutes_until_due} 分钟后到期）
                </span>
              )}
            </div>
          </div>
          {loan.is_institutional && (
            <div style={{ display: 'flex', gap: '6px', alignItems: 'center', justifyContent: 'flex-end' }}>
              <input
                type="number"
                min="1"
                max={loan.remaining}
                placeholder="金额"
                value={repayAmounts[i] || ''}
                onChange={(e) => setRepayAmounts({ ...repayAmounts, [i]: e.target.value })}
                style={{ width: '80px', padding: '2px 4px' }}
              />
              <button
                style={inkButtonStyle()}
                onClick={() => {
                  act('repay_indenture', {
                    fund_id: loan.target_id,
                    amount: parseInt(repayAmounts[i] || '0', 10),
                  });
                  setRepayAmounts({ ...repayAmounts, [i]: '' });
                }}
              >
                偿还
              </button>
            </div>
          )}
        </div>
      ))}

      <div style={sectionHeaderStyle}>账目</div>
      <PaginatedLog entries={data.personal_log} />
    </div>
  );
};
