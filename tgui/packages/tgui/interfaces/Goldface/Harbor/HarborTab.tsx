import { useState } from 'react';

import {
  cardStyle,
  fieldRowStyle,
  FONT_BODY,
  INK,
  INK_SOFT,
  pageStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
  subTabBarStyle,
  subTabStyle,
} from '../../common/parchment';
import type { ActFn, HarborData } from '../types';
import { RealmsView } from './RealmsView';
import { ShipsView } from './ShipsView';

type HarborSubTab = 'ships' | 'realms';

const BudgetPair = (props: { label: string; value: React.ReactNode }) => (
  <div
    style={{
      display: 'flex',
      alignItems: 'baseline',
      gap: '8px',
    }}
  >
    <span
      style={{
        fontFamily: SERIF,
        color: SEAL_AMBER,
        fontSize: FONT_BODY,
      }}
    >
      {props.label}
    </span>
    <span style={{ fontFamily: SERIF, fontSize: FONT_BODY, color: INK }}>
      {props.value}
    </span>
  </div>
);

const BudgetStrip = (props: { harbor: HarborData }) => {
  const { harbor } = props;
  return (
    <div
      style={{
        ...fieldRowStyle,
        display: 'flex',
        gap: '32px',
        justifyContent: 'flex-start',
      }}
    >
      <BudgetPair
        label="今日招呼"
        value={
          <>
            <b>{harbor.hails_remaining}</b> / {harbor.hails_per_day}
          </>
        }
      />
      <BudgetPair
        label="码头泊位"
        value={
          <>
            <b>{harbor.dock_spots_used}</b> / {harbor.dock_spots_max}
          </>
        }
      />
    </div>
  );
};

export const HarborTab = (props: {
  harbor?: HarborData;
  budget: number;
  isAgent?: boolean;
  act: ActFn;
}) => {
  const { harbor, budget, isAgent, act } = props;
  const [tab, setTab] = useState<HarborSubTab>('ships');

  const agentBanner = isAgent ? (
    <div
      style={{
        margin: '6px 0 8px',
        padding: '6px 10px',
        border: `1px dashed ${SEAL_GREEN}`,
        color: INK,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        lineHeight: 1.4,
      }}
    >
      <span
        style={{
          color: SEAL_GREEN,
          fontWeight: 'bold',
          marginRight: '6px',
        }}
      >
        特许代理人
      </span>
      <span style={{ color: INK_SOFT }}>
        作为费伦提亚贸易公司的代理人, 你获准查阅、查看并购买
        任何停靠船只的文化货物, 并可代表商行管事
        查看并招呼船只.
      </span>
    </div>
  ) : null;

  if (!harbor) {
    return (
      <div style={pageStyle}>
        {agentBanner}
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
          }}
        >
          港口报告尚未拟就.
        </div>
      </div>
    );
  }

  return (
    <div style={pageStyle}>
      {agentBanner}
      <BudgetStrip harbor={harbor} />
      <div
        style={{
          margin: '4px 0 6px',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          color: INK_SOFT,
        }}
      >
        提示: 在此窗口按 Ctrl+F 可快速查找货物或国度.
      </div>
      {harbor.kinship?.realm_name && (
        <div
          style={{
            margin: '6px 0 8px',
            padding: '6px 10px',
            border: `1px dashed ${SEAL_GREEN}`,
            color: INK,
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            lineHeight: 1.4,
          }}
        >
          <span
            style={{
              color: SEAL_GREEN,
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            亲缘: {harbor.kinship.realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            每日至少有一艘来自 {harbor.kinship.realm_name} 的船出航, 售价便宜{' '}
            {harbor.kinship.buy_pct}%, 大宗需求的收购价多付 {harbor.kinship.sell_pct}
            %.
          </span>
        </div>
      )}
      {harbor.kinship?.agent_realm_name && (
        <div
          style={{
            margin: '6px 0 8px',
            padding: '6px 10px',
            border: `1px dashed ${SEAL_GREEN}`,
            color: INK,
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            lineHeight: 1.4,
          }}
        >
          <span
            style={{
              color: SEAL_GREEN,
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            代理人亲缘: {harbor.kinship.agent_realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            作为代理人, 你从 {harbor.kinship.agent_realm_name} 船只购买时
            可少付 {harbor.kinship.buy_pct}%.
          </span>
        </div>
      )}
      <div style={subTabBarStyle}>
        <button
          type="button"
          style={subTabStyle(tab === 'ships')}
          onClick={() => setTab('ships')}
        >
          船只
        </button>
        <button
          type="button"
          style={subTabStyle(tab === 'realms')}
          onClick={() => setTab('realms')}
        >
          国度
        </button>
      </div>
      {tab === 'ships' && (
        <ShipsView
          docked={harbor.ships_docked}
          pool={harbor.ships_pool}
          dockSpotsUsed={harbor.dock_spots_used}
          dockSpotsMax={harbor.dock_spots_max}
          hailsRemaining={harbor.hails_remaining}
          budget={budget}
          act={act}
          realms={harbor.realms}
        />
      )}
      {tab === 'realms' && <RealmsView realms={harbor.realms} />}
    </div>
  );
};
