import {
  bannerStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  SEAL_AMBER,
} from '../common/parchment';
import type { SequestrationState } from './types';

export const ArrearsBanner = (props: {
  sequestration: SequestrationState;
}) => {
  const { sequestration } = props;
  if (!sequestration?.in_arrears) {
    return null;
  }
  return (
    <div
      style={{
        ...bannerStyle(SEAL_AMBER),
        position: 'relative',
        fontSize: FONT_BODY,
        padding: '10px 14px',
      }}
    >
      <div
        style={{
          fontSize: FONT_TITLE,
          fontWeight: 'bold',
          marginBottom: '3px',
          color: SEAL_AMBER,
        }}
      >
        拖欠市民款项
      </div>
      <div style={{ fontVariant: 'normal', color: INK }}>
        王权欠腐木谷市民 <b>{sequestration.debt}m</b>
        作为当日的免息垫款. 王室金库的全部收入
        将用于抵债直至还清. 若王权未能支付
        次日黎明的薪资, 领地将被接管.
      </div>
    </div>
  );
};
