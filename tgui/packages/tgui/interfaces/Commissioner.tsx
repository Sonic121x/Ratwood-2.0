 import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BrowseTab } from './Commissioner/BrowseTab';
import { ConfigPanel } from './Commissioner/ConfigPanel';
import { ManifestTab } from './Commissioner/ManifestTab';
import { OrdersTab } from './Commissioner/OrdersTab';
import type { CommissionerData } from './Commissioner/types';
import {
  FONT_BODY,
  INK,
  INK_SOFT,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SERIF,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

type CommissionerTab = 'browse' | 'manifest' | 'orders' | 'config';

export const Commissioner = () => {
  const { act, data } = useBackend<CommissionerData>();
  const [tab, setTab] = useState<CommissionerTab>('browse');
  const canRead = !!data.can_read;
  const isGuildmaster = !!data.is_guildmaster;
  const manifestCount = data.manifest.length;
  const orderCount = data.orders.length;

  let activeTab = tab;
  if (activeTab === 'config' && !isGuildmaster) activeTab = 'browse';

  return (
    <Window display_title="委托官" width={880} height={720} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>委托官</div>
          <div style={subtitleStyle}>
            发布锻造与工程委托。款项将由机器托管，
            直至订单完成。
          </div>
          <div style={rulerStyle} />

          <div
            style={{
              display: 'flex',
              alignItems: 'baseline',
              gap: '24px',
              marginBottom: '8px',
              fontFamily: SERIF,
            }}
          >
            <span style={{ color: SEAL_AMBER }}>
              托管款项
            </span>
            <span style={{ color: INK, fontWeight: 'bold', marginRight: 12 }}>
              {data.budget}m
            </span>
            <span style={{ color: SEAL_AMBER }}>
              你的存款
            </span>
            <span style={{ color: INK, fontWeight: 'bold' }}>
              {data.my_deposit}m
            </span>
            <span
              style={{
                marginLeft: 'auto',
                fontSize: FONT_BODY,
                color: INK_SOFT,
              }}
            >
              将钱币投入机器即可存款。
            </span>
          </div>

          <div style={tabBarStyle}>
            <div
              style={tabStyle(activeTab === 'browse')}
              onClick={() => setTab('browse')}
            >
              浏览
            </div>
            <div
              style={tabStyle(activeTab === 'manifest')}
              onClick={() => setTab('manifest')}
            >
              委托清单 {manifestCount > 0 && `(${manifestCount})`}
            </div>
            <div
              style={tabStyle(activeTab === 'orders')}
              onClick={() => setTab('orders')}
            >
              订单 {orderCount > 0 && `(${orderCount})`}
            </div>
            {isGuildmaster && (
              <div
                style={tabStyle(activeTab === 'config')}
                onClick={() => setTab('config')}
              >
                公会会长
              </div>
            )}
          </div>

          {activeTab === 'browse' && (
            <BrowseTab data={data} act={act} canRead={canRead} />
          )}
          {activeTab === 'manifest' && (
            <ManifestTab data={data} act={act} canRead={canRead} />
          )}
          {activeTab === 'orders' && (
            <OrdersTab data={data} act={act} canRead={canRead} />
          )}
          {activeTab === 'config' && isGuildmaster && (
            <ConfigPanel data={data} act={act} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
