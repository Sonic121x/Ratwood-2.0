import { INK_SOFT } from '../common/parchment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  dividedTwoColumnLayout,
  SectionTitle,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type { RealmRow, ShipSnapshot } from './types';

type Props = {
  s: ShipSnapshot;
};

const RealmTableHeader = () => (
  <thead>
    <tr>
      <td style={compactHeaderCell}>领地</td>
      <td style={{ ...compactHeaderCell, textAlign: 'right' }}>招呼次数</td>
      <td style={{ ...compactHeaderCell, textAlign: 'right' }}>平均停泊</td>
      <td style={{ ...compactHeaderCell, textAlign: 'right', paddingRight: 0 }}>
        恩惠
      </td>
    </tr>
  </thead>
);

const RealmTableRow = (props: { row: RealmRow }) => {
  const { row } = props;
  const dockText = row.avg_dock_min === null ? '-' : `${row.avg_dock_min}分钟`;
  return (
    <tr>
      <td style={compactDataCell}>{row.name}</td>
      <td style={{ ...compactDataCell, textAlign: 'right' }}>{row.hails}</td>
      <td style={{ ...compactDataCell, textAlign: 'right', color: INK_SOFT }}>
        {dockText}
      </td>
      <td style={{ ...compactDataCell, textAlign: 'right', paddingRight: 0 }}>
        {row.favor_earned}
      </td>
    </tr>
  );
};

const RealmTable = (props: { rows: RealmRow[] }) => (
  <table style={twoColTable}>
    <RealmTableHeader />
    <tbody>
      {props.rows.map((row) => (
        <RealmTableRow key={row.name} row={row} />
      ))}
    </tbody>
  </table>
);

export const ShipsSection = (props: Props) => {
  const { s } = props;
  const midpoint = Math.ceil(s.realms.length / 2);
  const leftHalf = s.realms.slice(0, midpoint);
  const rightHalf = s.realms.slice(midpoint);
  return (
    <div style={compactCardStyle}>
      <SectionTitle>
        外国船舶活动 - 共招呼 {s.total_hails} 次
        {s.total_hails === 1 ? '' : ''}
      </SectionTitle>
      <div style={dividedTwoColumnLayout}>
        <RealmTable rows={leftHalf} />
        <div style={verticalDividerStyle} />
        <RealmTable rows={rightHalf} />
      </div>
    </div>
  );
};
