import { useState } from 'react';

import { DANGER_LEVEL_LABELS } from '../../common/displayNames';
import {
  badgeStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import { type NoticeboardData, type ScoutRegion } from '../types';
const tableStyle: React.CSSProperties = {
  width: '100%',
  borderCollapse: 'collapse',
  fontFamily: SERIF,
  fontSize: FONT_BODY,
};

const headerCellStyle: React.CSSProperties = {
  textAlign: 'left',
  padding: '4px 8px 6px 8px',
  color: SEAL_AMBER,
  borderBottom: `1px solid ${INK_FAINT}`,
};

const headerCellWithDivider: React.CSSProperties = {
  ...headerCellStyle,
  borderLeft: `1px dashed ${PARCHMENT_SHADOW}`,
};

const cellStyle: React.CSSProperties = {
  padding: '6px 8px',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
  verticalAlign: 'top',
  color: INK,
};

const cellWithDivider: React.CSSProperties = {
  ...cellStyle,
  borderLeft: `1px dashed ${PARCHMENT_SHADOW}`,
};

// Ratwood deviation: AP's version has a fourth "Wardens' Word" column sourced from
// ScoutRegion.ic_descriptions, which noticeboard.dm's build_scout_regions() does not
// supply (ES's /datum/threat_region has no get_ic_description() proc - see types.ts).
// That column is dropped entirely rather than rendered against missing data.
export const ScoutsSection = ({ data }: { data: NoticeboardData }) => {
  const regions = data.scout_regions ?? [];
  const [helpOpen, setHelpOpen] = useState(false);

  return (
    <>
      <div style={{ marginBottom: 10 }}>
        <button
          type="button"
          style={{
            ...inkButtonStyle({}),
            fontSize: FONT_BODY,
            padding: '2px 6px',
          }}
          onClick={() => setHelpOpen((v) => !v)}
        >
          {helpOpen ? '收起斥候报告说明' : '关于斥候报告'}
        </button>
        {helpOpen && <HelpPanel />}
      </div>

      {regions.length === 0 ? (
        <EmptyMessage text="守林人们还没有从荒野传回消息." />
      ) : (
        <table style={tableStyle}>
          <thead>
            <tr>
              <th style={headerCellStyle}>区域</th>
              <th style={headerCellWithDivider}>危险</th>
              <th style={headerCellWithDivider}>封锁</th>
            </tr>
          </thead>
          <tbody>
            {regions.map((r) => (
              <RegionRow key={r.region_name} region={r} />
            ))}
          </tbody>
        </table>
      )}
    </>
  );
};

const RegionRow = ({ region }: { region: ScoutRegion }) => {
  return (
    <tr>
      <td style={cellStyle}>
        <div style={{ fontWeight: 'bold' }}>{region.region_name}</div>
      </td>
      <td style={cellWithDivider}>
        <span
          style={{
            color: region.danger_color,
            fontWeight: 'bold',
          }}
        >
          {DANGER_LEVEL_LABELS[region.danger_level] || region.danger_level}
        </span>
      </td>
      <td style={cellWithDivider}>
        {!!region.blockaded ? (
          <>
            <div
              style={{
                fontSize: FONT_BODY,
                color: SEAL_RED,
                fontWeight: 'bold',
              }}
            >
              {region.blockade_faction_label || '不明劫掠者'}
              <span
                style={{
                  marginLeft: 6,
                  color: INK_SOFT,
                  fontSize: FONT_BODY,
                  fontWeight: 'normal',
                }}
              >
                {region.blockade_days_active}天
              </span>
            </div>
            {!!region.blockade_region_label && (
              <div
                style={{
                  color: INK_SOFT,
                  fontSize: FONT_BODY,
                  marginTop: 1,
                }}
              >
                封锁 {region.blockade_region_label}
              </div>
            )}
            {!!region.blockade_writ_out ? (
              <div style={{ marginTop: 3 }}>
                <span style={badgeStyle(SEAL_AMBER)}>令状已下</span>
              </div>
            ) : (
              <div
                style={{
                  marginTop: 3,
                  color: SEAL_AMBER,
                  fontSize: FONT_BODY,
                }}
              >
                等候令状
              </div>
            )}
          </>
        ) : (
          <span style={{ color: INK_FAINT }}>-</span>
        )}
      </td>
    </tr>
  );
};

const EmptyMessage = ({ text }: { text: string }) => (
  <div
    style={{
      color: INK_FAINT,
      textAlign: 'center',
      padding: '24px 0',
    }}
  >
    {text}
  </div>
);

const HelpPanel = () => (
  <div
    style={{
      marginTop: 8,
      padding: '8px 12px',
      background: 'var(--p-card-bg)',
      border: `1px solid ${INK_FAINT}`,
      color: INK_SOFT,
      fontSize: FONT_BODY,
      lineHeight: 1.5,
    }}
  >
    <p style={{ margin: '0 0 6px 0' }}>
      斥候将区域的危险程度评为 <b>安全</b>、<b>低危</b>、{' '}
      <b>中危</b>、<b>危险</b> 到 <b>凶险</b>.
    </p>
    <p style={{ margin: '0 0 6px 0' }}>
      安全区域不太可能出现常见怪物与强盗的伏击.
      低威胁区域可能只会出现落单的敌人.
      勤勉的守林人能让某些区域彻底安全;
      另一些区域永无宁日, 而守林人辖区之外的土地依然危险.
    </p>
    <p style={{ margin: '0 0 6px 0' }}>
      引诱恶徒与怪物, 并在他们伏击时将其击杀, 即可降低危险.
      结伴而行会招来更大规模的伏击;
      每多一位同伴, 其人均贡献都低于独行者.
    </p>
    <p style={{ margin: 0 }}>
      守林人的号角会引发一场与该区域危险程度相称的大战 -
      这是驯服此地最可靠的办法.
      劫匪与怪物会随着时间重新渗入, 通常一夜之间.
      使用号角时请小心, 并带上朋友.
    </p>
  </div>
);
