import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_AMBER,
  SEAL_BLUE,
  SERIF,
} from '../../common/parchment';
import { type HarborDemand, type NoticeboardData } from '../types';

const orderGridStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: 10,
  alignItems: 'start',
};

const fieldLabelStyle: React.CSSProperties = {
  color: SEAL_AMBER,
  fontSize: FONT_BODY,
};

const formatDuration = (totalSeconds: number) => {
  if (totalSeconds <= 0) return '即将离港';
  const minutes = Math.floor(totalSeconds / 60);
  if (minutes < 1) return '马上离港';
  if (minutes === 1) return '1 分钟后离港';
  return `${minutes} 分钟后离港`;
};

const HarborDemandCard = ({ demand }: { demand: HarborDemand }) => (
  <div style={{ ...cardStyle, marginBottom: 0 }}>
    <div style={{ display: 'flex', alignItems: 'baseline', flexWrap: 'wrap' }}>
      <span style={badgeStyle(SEAL_BLUE)}>船只在港</span>
    </div>
    <div
      style={{
        fontSize: FONT_TITLE,
        fontWeight: 'bold',
        color: INK,
        fontFamily: SERIF,
        marginTop: 6,
      }}
    >
      {demand.ship_name}
    </div>
    <div
      style={{
        color: INK_SOFT,
        fontSize: FONT_BODY,
        marginTop: 2,
      }}
    >
      {demand.realm_name}的旗帜 &middot;{' '}
      {formatDuration(demand.seconds_until_departure)}
    </div>
    {demand.lines.length > 0 && (
      <div style={{ marginTop: 8 }}>
        <div style={fieldLabelStyle}>收购</div>
        <div style={{ marginTop: 2 }}>
          {demand.lines.map((line) => (
            <div
              key={line.good_name}
              style={{
                display: 'flex',
                alignItems: 'baseline',
                gap: 8,
                fontSize: FONT_BODY,
                color: INK,
                padding: '2px 0',
              }}
            >
              <span style={{ flex: 1 }}>{line.good_name}</span>
              <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
                {line.qty_fulfilled} / {line.qty_target}
              </span>
              <span
                style={{
                  flex: '0 0 auto',
                  color: SEAL_AMBER,
                  fontWeight: 'bold',
                }}
              >
                {line.offered_price}m 每件
              </span>
            </div>
          ))}
        </div>
      </div>
    )}
    {demand.cultural_stock.length > 0 && (
      <div style={{ marginTop: 8 }}>
        <div style={fieldLabelStyle}>上岸货物</div>
        <div style={{ marginTop: 2 }}>
          {demand.cultural_stock.map((entry) => (
            <div
              key={entry.name}
              style={{
                display: 'flex',
                alignItems: 'baseline',
                gap: 8,
                fontSize: FONT_BODY,
                color: INK,
                padding: '2px 0',
              }}
            >
              <span style={{ flex: 1 }}>{entry.name}</span>
              <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
                x{entry.qty}
              </span>
            </div>
          ))}
        </div>
        <div
          style={{
            marginTop: 4,
            color: INK_SOFT,
            fontSize: FONT_BODY,
          }}
        >
          相关条款请向商人询价.
        </div>
      </div>
    )}
    <div
      style={{
        marginTop: 8,
        color: INK_FAINT,
        fontSize: FONT_BODY,
      }}
    >
      把货物存入履约货箱,
      即可结清该船的大宗需求.
    </div>
  </div>
);

export const HarborSection = ({ data }: { data: NoticeboardData }) => {
  const demands = data.harbor_demands ?? [];
  if (demands.length === 0) {
    return (
      <div
        style={{
          color: INK_FAINT,
          textAlign: 'center',
          padding: '24px 0',
        }}
      >
        码头上没有异国船只.
      </div>
    );
  }
  return (
    <div style={orderGridStyle}>
      {demands.map((d) => (
        <HarborDemandCard key={d.ship_id} demand={d} />
      ))}
    </div>
  );
};
