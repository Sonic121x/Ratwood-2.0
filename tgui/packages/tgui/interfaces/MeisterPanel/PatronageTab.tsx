import { useState } from 'react';

import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
  tabBarStyle,
  tabStyle,
} from '../common/parchment';
import {
  type PatronRoster,
  type PatronRosterStatic,
  type TabProps,
} from './types';

export const PatronageTab = ({ data, act }: TabProps) => {
  const fundsWithPatronage = data.funds.filter(
    (f) => f.has_patronage && data.patron_rosters_static[f.id]?.can_manage,
  );
  const [selectedFundId, setSelectedFundId] = useState<string>(
    fundsWithPatronage[0]?.id ?? '',
  );

  if (!fundsWithPatronage.length) {
    return (
      <div style={cardStyle}>
        <div style={{ color: INK_SOFT }}>
          你未持有任何恩主权限。
        </div>
      </div>
    );
  }

  const roster = data.patron_rosters[selectedFundId];
  const rosterStatic = data.patron_rosters_static[selectedFundId];

  return (
    <div style={cardStyle}>
      {fundsWithPatronage.length > 1 && (
        <div style={tabBarStyle}>
          {fundsWithPatronage.map((f) => (
            <div
              key={f.id}
              style={tabStyle(selectedFundId === f.id)}
              onClick={() => setSelectedFundId(f.id)}
            >
              {f.patron_label}
            </div>
          ))}
        </div>
      )}
      {!!roster && !!rosterStatic && (
        <RosterView
          fundId={selectedFundId}
          roster={roster}
          rosterStatic={rosterStatic}
          act={act}
        />
      )}
    </div>
  );
};

const RosterView = ({
  fundId,
  roster,
  rosterStatic,
  act,
}: {
  fundId: string;
  roster: PatronRoster;
  rosterStatic: PatronRosterStatic;
  act: TabProps['act'];
}) => {
  const enrolled = roster.patrons.length;
  const full = enrolled >= rosterStatic.cap;

  return (
    <>
      <div style={sectionHeaderStyle}>{rosterStatic.label}</div>
      {!!rosterStatic.explanation && (() => {
        const sigSplit = rosterStatic.explanation.lastIndexOf(' - ');
        const body =
          sigSplit >= 0
            ? rosterStatic.explanation.slice(0, sigSplit).trimEnd()
            : rosterStatic.explanation;
        const signature =
          sigSplit >= 0
            ? rosterStatic.explanation.slice(sigSplit + 3).trim()
            : '';
        return (
          <div
            style={{
              color: INK_SOFT,
              whiteSpace: 'pre-wrap',
              marginBottom: 10,
              lineHeight: 1.4,
            }}
          >
            {body}
            {!!signature && (
              <div
                style={{
                  fontStyle: 'italic',
                  textAlign: 'right',
                  marginTop: 6,
                }}
              >
                - {signature}
              </div>
            )}
          </div>
        );
      })()}
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>名册</div>
        <div style={fieldValueStyle}>
          已登记 {enrolled} / {rosterStatic.cap}
        </div>
      </div>
      {full && (
        <div style={{ color: SEAL_AMBER, marginBottom: 8 }}>
          名册已满。起草新令状前，须先撤销一名
          {'现有恩主。'}
        </div>
      )}
      {roster.patrons.map((p) => (
        <div key={p.ref} style={fieldRowStyle}>
          <div style={fieldValueStyle}>
            {p.name}
            {p.job ? `，${p.job}` : ''}
          </div>
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() =>
              act('revoke_patronage', {
                fund_id: fundId,
                target_ref: p.ref,
              })
            }
          >
            撤销
          </button>
        </div>
      ))}
      <div style={{ marginTop: 10, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: full })}
          disabled={full}
          onClick={() => act('issue_patronage', { fund_id: fundId })}
        >
          起草令状
        </button>
      </div>
    </>
  );
};
