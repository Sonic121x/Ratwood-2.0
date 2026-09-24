import {
  FONT_BODY,
  INK_SOFT,
  subtitleStyle,
} from '../common/parchment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  dividedTwoColumnLayout,
  SectionTitle,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type { BmBucket, BucketSnapshot, RealBucket } from './types';

type Props = {
  b: BucketSnapshot;
};

const subTitle = {
  ...subtitleStyle,
  textAlign: 'left',
  marginBottom: '2px',
  fontSize: FONT_BODY,
} as const;

const RealMarketTable = (props: { rows: RealBucket[] }) => (
  <div>
    <div style={subTitle}>正规市场</div>
    <table style={twoColTable}>
      <thead>
        <tr>
          <td style={compactHeaderCell}>品类</td>
          <td style={{ ...compactHeaderCell, textAlign: 'right' }}>售出额</td>
          <td
            style={{ ...compactHeaderCell, textAlign: 'right', paddingRight: 0 }}
          >
            已释放额度
          </td>
        </tr>
      </thead>
      <tbody>
        {props.rows.map((row) => (
          <tr key={row.name}>
            <td style={compactDataCell}>{row.name}</td>
            <td style={{ ...compactDataCell, textAlign: 'right' }}>
              {row.sold}
            </td>
            <td
              style={{
                ...compactDataCell,
                textAlign: 'right',
                color: INK_SOFT,
                paddingRight: 0,
              }}
            >
              {row.relieved}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  </div>
);

const BlackMarketTable = (props: { rows: BmBucket[] }) => (
  <div>
    <div style={subTitle}>黑市</div>
    <table style={twoColTable}>
      <thead>
        <tr>
          <td style={compactHeaderCell}>品类</td>
          <td
            style={{ ...compactHeaderCell, textAlign: 'right', paddingRight: 0 }}
          >
            售出额
          </td>
        </tr>
      </thead>
      <tbody>
        {props.rows.map((row) => (
          <tr key={row.name}>
            <td style={compactDataCell}>{row.name}</td>
            <td
              style={{ ...compactDataCell, textAlign: 'right', paddingRight: 0 }}
            >
              {row.sold}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  </div>
);

export const BucketsSection = (props: Props) => {
  const { b } = props;
  return (
    <div style={compactCardStyle}>
      <SectionTitle>引航机品类统计</SectionTitle>
      <div style={dividedTwoColumnLayout}>
        <RealMarketTable rows={b.real} />
        <div style={verticalDividerStyle} />
        <BlackMarketTable rows={b.black_market} />
      </div>
    </div>
  );
};
