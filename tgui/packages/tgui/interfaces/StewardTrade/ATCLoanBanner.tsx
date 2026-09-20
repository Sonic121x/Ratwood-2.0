import { useState } from 'react';
import { Button, NumberInput } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  bannerStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  SEAL_AMBER,
  SEAL_RED_SOFT,
} from '../common/parchment';
import type { AtcLoanState, Data } from './types';

export const ATCLoanBanner = (props: { atc_loan: AtcLoanState }) => {
  const { act, data } = useBackend<Data>();
  const { atc_loan } = props;
  const aldermanActing = !!data.is_alderman_acting;

  const [amount, setAmount] = useState(atc_loan.min);

  if (!atc_loan.can_view) {
    return null;
  }
  if (!atc_loan.available && atc_loan.loans_drawn === 0 && !atc_loan.arrears_consumed) {
    return null;
  }

  const accent = atc_loan.arrears_consumed ? SEAL_RED_SOFT : SEAL_AMBER;

  return (
    <div
      style={{
        ...bannerStyle(accent),
        padding: '10px 14px',
        textAlign: 'left',
        fontVariant: 'normal',
      }}
    >
      <div
        style={{
          fontSize: FONT_TITLE,
          fontWeight: 'bold',
          marginBottom: '4px',
          color: accent,
        }}
      >
        费伦提亚贸易公司 - 公司书记官的柜台
      </div>
      <div style={{ color: INK, marginBottom: '6px' }}>
        {atc_loan.available ? (
          <>
            书记官受理的紧急贷款金额为{' '}
            <b>{atc_loan.min}m 至 {atc_loan.max}m</b> 由公司的
            常设信贷提供, 按惯例收取{' '}
            <b>{atc_loan.interest_pct}% 的利息</b> 计息依据为
            本金. 提款后将失去欠款宽限期 - 若
            王权未能支付下一次薪资, 领地将被直接接管而
            不再另行警告.
          </>
        ) : (
          <>{atc_loan.blocker || '书记官无法受理.'}</>
        )}
      </div>
      {!!atc_loan.arrears_consumed && (
        <div
          style={{
            color: SEAL_RED_SOFT,
            fontSize: FONT_BODY,
            marginBottom: '6px',
          }}
        >
          欠公司款项: <b>{atc_loan.outstanding}m</b>. 所有
          流入王室金库的收入均用于抵债直至
          还清. 市民的宽限已失效; 再次拖欠
          薪资将跳过欠款期而直接进入接管.
        </div>
      )}
      {atc_loan.loans_drawn > 0 && (
        <div style={{ color: INK_FAINT, fontSize: FONT_BODY, marginBottom: '6px' }}>
          本轮已提款次数: {atc_loan.loans_drawn}.
        </div>
      )}
      {!!atc_loan.available && (
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            opacity: aldermanActing ? 0.55 : 1,
            textDecoration: aldermanActing ? 'line-through' : undefined,
          }}
          title={
            aldermanActing
              ? "The Alderman's writ does not extend to drawing loans against the Crown."
              : undefined
          }
        >
          <span>提款:</span>
          <NumberInput
            value={amount}
            minValue={atc_loan.min}
            maxValue={atc_loan.max}
            step={50}
            stepPixelSize={4}
            width="80px"
            disabled={aldermanActing}
            onChange={(v: number) => setAmount(v)}
          />
          <span>m</span>
          <span style={{ color: SEAL_RED_SOFT }}>
            (欠款 {Math.round(amount * (1 + atc_loan.interest_pct / 100))}m)
          </span>
          <Button.Confirm
            disabled={aldermanActing}
            onClick={() => act('take_atc_loan', { amount })}
          >
            向书记官申请
          </Button.Confirm>
        </div>
      )}
    </div>
  );
};
