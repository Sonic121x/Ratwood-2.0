import { useState } from 'react';

import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  sectionHeaderStyle,
} from '../common/parchment';
import { type TabProps } from './types';

export const PollTaxTab = ({ data, act }: TabProps) => {
  const [days, setDays] = useState<string>('');
  const tax = data.poll_tax;
  const taxStatic = data.poll_tax_static;
  const taxUser = data.poll_tax_user;
  const numericDays = parseInt(days, 10) || 0;

  const effectiveRate = tax.rate > 0 ? tax.rate : taxStatic.fallback_rate;
  const presumed = tax.rate <= 0;
  const capRemaining = taxStatic.max_advance_days - tax.advance_days_held;
  const affordable = Math.floor(data.account_balance / Math.max(1, effectiveRate));
  const maxDays = Math.min(capRemaining, affordable);

  let rateLine = `${tax.rate}m/天`;
  if (tax.exempt) {
    rateLine = '依敕令豁免';
  } else if (tax.rate < 0) {
    rateLine = `王权补贴 ${-tax.rate}m/天`;
  } else if (tax.rate === 0) {
    rateLine = `未征收（按推定 ${taxStatic.fallback_rate}m/天 预缴）`;
  }

  const advanceBlocked =
    !taxUser.category ||
    tax.exempt ||
    tax.rate < 0 ||
    capRemaining <= 0 ||
    affordable <= 0;
  const submitDisabled =
    advanceBlocked || numericDays < 1 || numericDays > maxDays;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>人头税</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>阶层</div>
        <div style={fieldValueStyle}>
          {taxUser.category_label || '无应税阶层'}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>税率</div>
        <div style={fieldValueStyle}>{rateLine}</div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>已预缴天数</div>
        <div style={fieldValueStyle}>
          {tax.advance_days_held}
          {' '}天（上限 {taxStatic.max_advance_days}）
        </div>
      </div>

      {!!tax.exempt && (
        <div style={{ color: INK_SOFT, marginTop: 8 }}>
          你无需缴纳任何款项。没有可预缴的部分。
        </div>
      )}

      {!advanceBlocked && (
        <>
          <div style={sectionHeaderStyle}>预缴</div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>天数</div>
            <div style={fieldValueStyle}>
              <input
                type="number"
                min={1}
                max={maxDays}
                value={days}
                onChange={(e) => setDays(e.target.value)}
                style={{ ...inkInputStyle, width: 90 }}
              />
              <span style={{ marginLeft: 6, color: INK_FAINT }}>
                （最多 {maxDays} 天；{numericDays * effectiveRate}m
                {presumed ? '（推定）' : ''}）
              </span>
            </div>
          </div>
          <div style={{ marginTop: 6, textAlign: 'right' }}>
            <button
              type="button"
              style={inkButtonStyle({ disabled: submitDisabled })}
              disabled={submitDisabled}
              onClick={() => {
                act('advance_poll_tax', { days: numericDays });
                setDays('');
              }}
            >
              缴纳
            </button>
          </div>
        </>
      )}
    </div>
  );
};
