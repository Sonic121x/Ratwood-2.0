import { useState } from 'react';

import {
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  rulerStyle,
  subTabBarStyle,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import { ChartersSection } from './AvisaSections/ChartersSection';
import { EventsSection } from './AvisaSections/EventsSection';
import { HarborSection } from './AvisaSections/HarborSection';
import { MarketSection } from './AvisaSections/MarketSection';
import { ScoutsSection } from './AvisaSections/ScoutsSection';
import { TradeOrdersSection } from './AvisaSections/TradeOrdersSection';
import { type TabProps } from './types';

type AvisaSection =
  | 'charters'
  | 'trade_orders'
  | 'harbor'
  | 'market'
  | 'scouts'
  | 'events'
  | 'assembly';

type SectionMeta = {
  key: AvisaSection;
  label: string;
  blurb: string;
};

const SECTIONS: SectionMeta[] = [
  {
    key: 'charters',
    label: '特许状',
    blurb:
      "王室的现行敕令 - 其效力、其废止, 以及其颁印之年.",
  },
  {
    key: 'trade_orders',
    label: '贸易订单',
    blurb:
      "王国商人与储备库的需求, 等待履约.",
  },
  {
    key: 'harbor',
    label: '港口',
    blurb:
      '停靠码头的异国船只 - 它们的大宗需求与运上岸的文化货物.',
  },
  {
    key: 'market',
    label: '市场',
    blurb:
      "叫卖人的账目: 王国的买家渴求什么, 又不再收什么.",
  },
  {
    key: 'scouts',
    label: '斥候',
    blurb: '守林人们对各区域危险程度的报告.',
  },
  {
    key: 'events',
    label: '事件',
    blurb: '当下扰乱市场的短缺与过剩.',
  },
  {
    key: 'assembly',
    label: '议事会',
    blurb: '请愿、召集, 以及城市议事会的日常事务.',
  },
];

export const AvisaTab = ({ data, act }: TabProps) => {
  const [section, setSection] = useState<AvisaSection>('charters');
  const active = SECTIONS.find((s) => s.key === section) ?? SECTIONS[0];

  return (
    <>
      <div
        style={{
          ...titleStyle,
          fontSize: '20px',
          marginTop: 6,
        }}
      >
        王国公报
      </div>
      <div style={subtitleStyle}>
        王国的消息、敕令与贸易
      </div>
      <hr style={rulerStyle} />

      <div style={subTabBarStyle}>
        {SECTIONS.map((s) => (
          <div
            key={s.key}
            style={subTabStyle(section === s.key)}
            onClick={() => setSection(s.key)}
          >
            {s.label}
          </div>
        ))}
        {section === 'market' && (
          <button
            type="button"
            title="打开经济指南"
            style={{ ...inkButtonStyle({}), marginLeft: 'auto' }}
            onClick={() => act('help_market')}
          >
            ?
          </button>
        )}
      </div>

      <div
        style={{
          color: INK_SOFT,
          fontStyle: 'italic',
          fontSize: FONT_BODY,
          marginTop: 8,
          marginBottom: 8,
        }}
      >
        {active.blurb}
      </div>

      {section === 'charters' && <ChartersSection data={data} />}
      {section === 'trade_orders' && <TradeOrdersSection data={data} />}
      {section === 'harbor' && <HarborSection data={data} />}
      {section === 'market' && <MarketSection data={data} />}
      {section === 'scouts' && <ScoutsSection data={data} />}
      {section === 'events' && <EventsSection data={data} />}
      {section === 'assembly' && <AssemblySection act={act} />}
    </>
  );
};

const AssemblySection = ({ act }: { act: TabProps['act'] }) => (
  <div style={{ padding: '12px 0', textAlign: 'center' }}>
    <div
      style={{
        color: INK_FAINT,
        fontSize: FONT_BODY,
        marginBottom: 12,
      }}
    >
      议事厅已备好受理请愿与表决.
    </div>
    <button
      type="button"
      style={inkButtonStyle({})}
      onClick={() => act('open_assembly')}
    >
      进入议事会
    </button>
  </div>
);
