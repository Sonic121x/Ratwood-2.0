import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';
import { InstitutionalTab } from './MeisterPanel/InstitutionalTab';
import { LedgerTab } from './MeisterPanel/LedgerTab';
import { PatronageTab } from './MeisterPanel/PatronageTab';
import { PersonalTab } from './MeisterPanel/PersonalTab';
import { PollTaxTab } from './MeisterPanel/PollTaxTab';
import { type Data, type TabKey } from './MeisterPanel/types';

export const MeisterPanel = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('personal');

  const accessibleInstitutional = data.funds.some(
    (f) => f.can_issue || f.can_withdraw || f.can_view,
  );
  const accessiblePatronage = data.funds.some(
    (f) => f.has_patronage && data.patron_rosters[f.id]?.can_manage,
  );

  return (
    <Window title="神经锁" width={620} height={620} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>神经锁</div>
          <div style={subtitleStyle}>
            第 {data.day} 天 &middot; 个人余额：{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.account_balance}m
            </span>
          </div>
          <hr style={rulerStyle} />

          <div style={tabBarStyle}>
            <div
              style={tabStyle(tab === 'personal')}
              onClick={() => setTab('personal')}
            >
              个人
            </div>
            {accessibleInstitutional && (
              <div
                style={tabStyle(tab === 'institutional')}
                onClick={() => setTab('institutional')}
              >
                机构
              </div>
            )}
            {accessiblePatronage && (
              <div
                style={tabStyle(tab === 'patronage')}
                onClick={() => setTab('patronage')}
              >
                恩主
              </div>
            )}
            <div
              style={tabStyle(tab === 'polltax')}
              onClick={() => setTab('polltax')}
            >
              人头税
            </div>
            <div
              style={tabStyle(tab === 'ledger')}
              onClick={() => setTab('ledger')}
            >
              台账
            </div>
          </div>

          {tab === 'personal' && <PersonalTab data={data} act={act} />}
          {tab === 'institutional' && accessibleInstitutional && (
            <InstitutionalTab data={data} act={act} />
          )}
          {tab === 'patronage' && accessiblePatronage && (
            <PatronageTab data={data} act={act} />
          )}
          {tab === 'polltax' && <PollTaxTab data={data} act={act} />}
          {tab === 'ledger' && <LedgerTab data={data} act={act} />}
        </div>
      </Window.Content>
    </Window>
  );
};
