import { useState } from 'react';

import {
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  INK_FAINT,
  inkButtonStyle,
  inkInputStyle,
  sectionHeaderStyle,
} from '../../common/parchment';
import { type TabProps } from '../types';

/**
 * Bathhouse employment section, shown on the Bathhouse fund view. Workers and
 * agents of the Bathhouse may render coin into the coffers, and the Bathmaster
 * sets a separate per-day withdrawal cap for each group - and may suspend a
 * group's payments outright until she resumes them.
 */
export const BathhouseFundSection = ({ data, act }: TabProps) => {
  const [deposit, setDeposit] = useState<string>('');
  const [workerLimit, setWorkerLimit] = useState<string>(
    String(data.bathhouse_worker_withdraw_limit),
  );
  const [agentLimit, setAgentLimit] = useState<string>(
    String(data.bathhouse_agent_withdraw_limit),
  );

  const depositNum = parseInt(deposit, 10) || 0;
  const workerLimitNum = parseInt(workerLimit, 10) || 0;
  const agentLimitNum = parseInt(agentLimit, 10) || 0;
  const depositDisabled = depositNum <= 0 || depositNum > data.account_balance;

  return (
    <>
      <div style={sectionHeaderStyle}>雇佣条款</div>
      <div style={{ color: INK_FAINT, marginBottom: 8, fontSize: FONT_BODY }}>
        <div>
          浴场雇员每日最多可提取{' '}
          {data.bathhouse_worker_withdraw_limit}m
          {!!data.bathhouse_worker_suspended && '（已暂停发放）'}。
        </div>
        <div>
          浴场代理人每日最多可提取{' '}
          {data.bathhouse_agent_withdraw_limit}m
          {!!data.bathhouse_agent_suspended && '（已暂停发放）'}。
        </div>
      </div>
      {!data.is_bathmaster && (
        <div style={{ color: INK_FAINT, marginBottom: 8, fontSize: FONT_BODY }}>
          {data.bathhouse_viewer_suspended
            ? '夜主已暂停向你发放款项，须待她恢复。'
            : `你今日还可提取 ${data.bathhouse_withdraw_remaining}m。`}
        </div>
      )}

      <div style={sectionHeaderStyle}>上缴钱款</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>金额</div>
        <div style={fieldValueStyle}>
          <input
            type="number"
            min={1}
            max={data.account_balance}
            value={deposit}
            onChange={(e) => setDeposit(e.target.value)}
            style={{ ...inkInputStyle, width: 110 }}
          />
          <span style={{ marginLeft: 6, color: INK_FAINT }}>
            玛门币（账户余额 {data.account_balance}m）
          </span>
        </div>
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: depositDisabled })}
          disabled={depositDisabled}
          onClick={() => {
            act('deposit_institutional', {
              fund_id: 'bathhouse',
              amount: depositNum,
            });
            setDeposit('');
          }}
        >
          上缴至浴场
        </button>
      </div>

      {!!data.is_bathmaster && (
        <>
          <div style={sectionHeaderStyle}>每日提款上限</div>
          <GroupLimitControls
            label="雇员"
            limit={workerLimit}
            setLimit={setWorkerLimit}
            limitNum={workerLimitNum}
            suspended={!!data.bathhouse_worker_suspended}
            onSet={() =>
              act('set_bathhouse_limit', {
                group: 'worker',
                amount: workerLimitNum,
              })
            }
            onToggleSuspend={() =>
              act('toggle_bathhouse_suspension', { group: 'worker' })
            }
          />
          <GroupLimitControls
            label="代理人"
            limit={agentLimit}
            setLimit={setAgentLimit}
            limitNum={agentLimitNum}
            suspended={!!data.bathhouse_agent_suspended}
            onSet={() =>
              act('set_bathhouse_limit', {
                group: 'agent',
                amount: agentLimitNum,
              })
            }
            onToggleSuspend={() =>
              act('toggle_bathhouse_suspension', { group: 'agent' })
            }
          />
        </>
      )}
    </>
  );
};

/**
 * One row of Bathmaster controls for a single group (workers or agents): a
 * daily cap input with a Set button, plus a toggle that suspends or resumes
 * that group's payments entirely.
 */
const GroupLimitControls = (props: {
  label: string;
  limit: string;
  setLimit: (value: string) => void;
  limitNum: number;
  suspended: boolean;
  onSet: () => void;
  onToggleSuspend: () => void;
}) => (
  <div style={{ marginBottom: 10 }}>
    <div style={fieldRowStyle}>
      <div style={fieldLabelStyle}>{props.label}</div>
      <div style={fieldValueStyle}>
        <input
          type="number"
          min={0}
          max={10000}
          value={props.limit}
          onChange={(e) => props.setLimit(e.target.value)}
          style={{ ...inkInputStyle, width: 110 }}
        />
        <span style={{ marginLeft: 6, color: INK_FAINT }}>
          玛门币／人／日
        </span>
      </div>
    </div>
    <div style={{ marginTop: 6, textAlign: 'right' }}>
      <button
        type="button"
        style={{
          ...inkButtonStyle({ disabled: props.limitNum < 0 }),
          marginRight: 6,
        }}
        disabled={props.limitNum < 0}
        onClick={props.onSet}
      >
        设定上限
      </button>
      <button
        type="button"
        style={inkButtonStyle({})}
        onClick={props.onToggleSuspend}
      >
        {props.suspended ? '恢复发放' : '暂停发放'}
      </button>
    </div>
  </div>
);
