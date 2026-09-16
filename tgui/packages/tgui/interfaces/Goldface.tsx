import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { inkButtonStyle, tabBarStyle, tabStyle } from './common/parchment';
import { CulturalStockTab } from './Goldface/CulturalStock/CulturalStockTab';
import { HarborTab } from './Goldface/Harbor/HarborTab';
import { LedgerTab } from './Goldface/Ledger/LedgerTab';
import { MammonRow } from './Goldface/MammonRow';
import { ManagementTab } from './Goldface/Management/ManagementTab';
import { MarketTab } from './Goldface/Market/MarketTab';
import type { VendingData } from './Goldface/types';
import { VendingPanel } from './Goldface/VendingPanel';

type GoldfaceTab =
  | 'goods'
  | 'cultural'
  | 'harbor'
  | 'market'
  | 'management'
  | 'ledger';

export const Goldface = () => {
  const { act, data } = useBackend<VendingData>();
  const [tab, setTab] = useState<GoldfaceTab>('goods');
  const isCommand = !!data.is_command_center;
  const canRead = !!data.can_read;
  const isPublic = !!data.is_public;
  const isProprietor = !!data.is_proprietor;
  const isAgent = !!data.is_agent;

  const helpButton = (
    <button
      type="button"
      title="打开经济指南"
      style={inkButtonStyle({})}
      onClick={() => act('help')}
    >
      ?
    </button>
  );

  const mammonBar = (
    <div style={{ padding: '6px 28px 0 28px' }}>
      <MammonRow
        budget={data.budget}
        canRead={canRead}
        isProprietor={isProprietor}
        isPublic={isPublic}
        act={act}
      />
    </div>
  );

  if (!isCommand) {
    return (
      <Window width={880} height={800} theme="parchment">
        <Window.Content scrollable>
          <div
            style={{
              display: 'flex',
              justifyContent: 'flex-end',
              padding: '6px 28px 0 28px',
            }}
          >
            {helpButton}
          </div>
          {mammonBar}
          <VendingPanel data={data} act={act} />
        </Window.Content>
      </Window>
    );
  }

  const canSeeMerchantTabs = isProprietor;
  const canSeeHarborTabs = isProprietor || isAgent;
  const culturalStock = data.harbor?.cultural_stock ?? [];
  let activeTab = tab;
  if (
    (activeTab === 'harbor' || activeTab === 'cultural') &&
    !canSeeHarborTabs
  ) {
    activeTab = 'goods';
  } else if (
    (activeTab === 'market' ||
      activeTab === 'management' ||
      activeTab === 'ledger') &&
    !canSeeMerchantTabs
  ) {
    activeTab = 'goods';
  }

  return (
    <Window width={880} height={800} theme="parchment">
      <Window.Content scrollable>
        <div style={{ position: 'relative' }}>
          <div style={tabBarStyle}>
            <div
              style={tabStyle(activeTab === 'goods')}
              onClick={() => setTab('goods')}
            >
              货物
            </div>
            {canSeeHarborTabs && (
              <div
                style={tabStyle(activeTab === 'cultural')}
                onClick={() => setTab('cultural')}
              >
                文化货物
              </div>
            )}
            {canSeeHarborTabs && (
              <div
                style={tabStyle(activeTab === 'harbor')}
                onClick={() => setTab('harbor')}
              >
                港口
              </div>
            )}
            {canSeeMerchantTabs && (
              <div
                style={tabStyle(activeTab === 'market')}
                onClick={() => setTab('market')}
              >
                市场
              </div>
            )}
            {canSeeMerchantTabs && (
              <div
                style={tabStyle(activeTab === 'management')}
                onClick={() => setTab('management')}
              >
                管理
              </div>
            )}
            {canSeeMerchantTabs && (
              <div
                style={tabStyle(activeTab === 'ledger')}
                onClick={() => setTab('ledger')}
              >
                账本
              </div>
            )}
          </div>
          <div style={{ position: 'absolute', right: 0, top: '10px' }}>
            {helpButton}
          </div>
        </div>
        {mammonBar}
        {activeTab === 'goods' && <VendingPanel data={data} act={act} />}
        {activeTab === 'cultural' && canSeeHarborTabs && (
          <CulturalStockTab
            stock={culturalStock}
            catalogs={data.harbor?.catalogs}
            kinship={data.harbor?.kinship}
            budget={data.budget}
            isAgent={isAgent}
            act={act}
          />
        )}
        {activeTab === 'harbor' && canSeeHarborTabs && (
          <HarborTab
            harbor={data.harbor}
            budget={data.budget}
            isAgent={isAgent}
            act={act}
          />
        )}
        {activeTab === 'market' && canSeeMerchantTabs && (
          <MarketTab harbor={data.harbor} />
        )}
        {activeTab === 'management' && canSeeMerchantTabs && (
          <ManagementTab harbor={data.harbor} act={act} />
        )}
        {activeTab === 'ledger' && canSeeMerchantTabs && (
          <LedgerTab harbor={data.harbor} />
        )}
      </Window.Content>
    </Window>
  );
};
