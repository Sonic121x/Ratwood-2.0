import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';
import { AvisaTab } from './Noticeboard/AvisaTab';
import { PostingsTab } from './Noticeboard/PostingsTab';
import { RosterTab } from './Noticeboard/RosterTab';
import { type NoticeboardData, type TabKey } from './Noticeboard/types';

export const Noticeboard = () => {
  const { data, act } = useBackend<NoticeboardData>();
  const [tab, setTab] = useState<TabKey>('postings');

  return (
    <Window title="告示板" width={1000} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, position: 'relative' }}>
          <button
            type="button"
            title="刷新市场数据 (5s 冷却)"
            style={{ ...inkButtonStyle({}), position: 'absolute', top: 8, right: 8 }}
            onClick={() => act('refresh_market')}
          >
            ↻
          </button>
          <div style={titleStyle}>告示板</div>
          <div style={subtitleStyle}>
            {data.realm_name || '王国'} &middot; 王国与民间的告示
          </div>
          <hr style={rulerStyle} />

          <div style={tabBarStyle}>
            <div
              style={tabStyle(tab === 'postings')}
              onClick={() => setTab('postings')}
            >
              告示
            </div>
            <div
              style={tabStyle(tab === 'avisa')}
              onClick={() => setTab('avisa')}
            >
              公报
            </div>
            <div
              style={tabStyle(tab === 'roster')}
              onClick={() => setTab('roster')}
            >
              佣兵名册
            </div>
          </div>

          {tab === 'postings' && <PostingsTab data={data} act={act} />}
          {tab === 'avisa' && <AvisaTab data={data} act={act} />}
          {tab === 'roster' && <RosterTab data={data} act={act} />}
        </div>
      </Window.Content>
    </Window>
  );
};
