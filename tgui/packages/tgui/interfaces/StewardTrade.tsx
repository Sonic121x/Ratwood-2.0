import { useEffect, useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  INK,
  INK_FAINT,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { AdvancedView } from './StewardTrade/AdvancedView';
import { ArrearsBanner } from './StewardTrade/ArrearsBanner';
import { ATCLoanBanner } from './StewardTrade/ATCLoanBanner';
import { AutoImportView } from './StewardTrade/AutoImportView';
import { BanditryBanner } from './StewardTrade/BanditryBanner';
import { BlockadeBanner } from './StewardTrade/BlockadeBanner';
import { EventsBanner } from './StewardTrade/EventsBanner';
import { LedgerView } from './StewardTrade/LedgerView';
import { MarketView } from './StewardTrade/MarketView';
import { OrdersView } from './StewardTrade/OrdersView';
import { PetitionView } from './StewardTrade/PetitionView';
import { RegionsView } from './StewardTrade/RegionsView';
import { RoyalCustomPanel } from './StewardTrade/RoyalCustomPanel';
import { SequesteredOverlay } from './StewardTrade/SequesteredOverlay';
import { SequestrationBanner } from './StewardTrade/SequestrationBanner';
import { TabBar } from './StewardTrade/TabBar';
import { TradeModal, type TradeModalRequest } from './StewardTrade/TradeModal';
import type { Data, TabKey } from './StewardTrade/types';

export const StewardTrade = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('orders');
  const [tradeRequest, setTradeRequest] = useState<TradeModalRequest | null>(
    null,
  );

  useEffect(() => {
    if (tab === 'ledger') {
      act('ledger_open');
      return () => act('ledger_close');
    }
  }, [tab, act]);

  const aldermanActing = !!data.is_alderman_acting;
  const warrant = data.alderman_warrant;
  return (
    <Window
      title="Market Scroll"
      display_title="市场卷宗"
      width={860}
      height={820}
      theme="parchment"
    >
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>市场 & 库存</div>
          <div style={subtitleStyle}>
            第 {data.day} 日 &middot; 王室金库:{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.treasury}m
            </span>
          </div>
          <div
            style={{
              ...subtitleStyle,
              color: INK_FAINT,
              fontSize: FONT_BODY,
              marginTop: '2px',
            }}
          >
            黎明结算:{' '}
            <span style={{ color: SEAL_AMBER }}>
              +{data.expected_rural_revenue}m
            </span>{' '}
            乡村税收 &middot;{' '}
            <span style={{ color: SEAL_AMBER }}>
              -{data.expected_wage_outlay}m
            </span>{' '}
            薪资 &middot; 净额{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.expected_rural_revenue - data.expected_wage_outlay >= 0
                ? '+'
                : ''}
              {data.expected_rural_revenue - data.expected_wage_outlay}m
            </span>
          </div>
          <hr style={rulerStyle} />

          {aldermanActing && warrant && (
            <div
              style={{
                background: 'rgba(200,170,100,0.18)',
                border: `1px solid ${SEAL_AMBER}`,
                padding: '6px 12px',
                marginBottom: '10px',
                fontSize: FONT_BODY,
                color: INK,
              }}
            >
              <div
                style={{
                  color: SEAL_AMBER,
                  fontWeight: 'bold',
                  marginBottom: '2px',
                }}
              >
                市政长老的令状
              </div>
              <div>
                今日贸易授权剩余:{' '}
                <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                  {warrant.trade_remaining}m
                </span>{' '}
                总额度为 {warrant.trade_cap}m
              </div>
              <div style={{ color: INK_FAINT, fontSize: FONT_BODY }}>
                超出授权额度的交易将被拒绝. 款项仍由王室金库支付.
              </div>
            </div>
          )}

          <SequestrationBanner sequestration={data.sequestration} />
          <ArrearsBanner sequestration={data.sequestration} />
          <ATCLoanBanner atc_loan={data.atc_loan} />
          <BlockadeBanner regions={data.blockaded_regions} />
          <BanditryBanner projection={data.banditry_projection} />
          <EventsBanner events={data.active_events} goodCatalog={data.good_catalog} />

          <TabBar tab={tab} onSwitch={setTab} />
          <hr style={rulerStyle} />

          {tab === 'orders' && <OrdersView data={data} />}
          {tab === 'market' && (
            <SequesteredOverlay
              active={!!data.sequestration?.active}
              label="市场 & 库存"
            >
              <MarketView data={data} onTrade={setTradeRequest} />
            </SequesteredOverlay>
          )}
          {tab === 'regions' && (
            <SequesteredOverlay
              active={!!data.sequestration?.active}
              label="跨地区贸易"
            >
              <RegionsView data={data} />
            </SequesteredOverlay>
          )}
          {tab === 'auto_import' && (
            <SequesteredOverlay
              active={!!data.sequestration?.active}
              label="进口"
            >
              <AutoImportView data={data} />
            </SequesteredOverlay>
          )}
          {tab === 'petition' && <PetitionView data={data} />}
          {tab === 'ledger' && <LedgerView data={data} />}
          {tab === 'royal_custom' && <RoyalCustomPanel />}
          {tab === 'advanced' && (
            <SequesteredOverlay
              active={!!data.sequestration?.active}
              label="高级设置"
            >
              <AdvancedView data={data} />
            </SequesteredOverlay>
          )}
        </div>
        <TradeModal
          request={tradeRequest}
          onClose={() => setTradeRequest(null)}
        />
      </Window.Content>
    </Window>
  );
};
