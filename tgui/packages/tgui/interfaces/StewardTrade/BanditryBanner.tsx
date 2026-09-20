import type { BanditryProjection } from './types';
import {
  bannerStyle,
  FONT_BODY,
  SEAL_AMBER,
  SEAL_RED_SOFT,
} from '../common/parchment';

export const BanditryBanner = (props: { projection: BanditryProjection }) => {
  const p = props.projection;
  const hasProjection = !!p && p.total > 0;
  const hasDebt = !!p && p.debt > 0;
  if (!hasProjection && !hasDebt) {
    return null;
  }
  return (
    <div style={bannerStyle(SEAL_RED_SOFT, true)}>
      {hasDebt && (
        <div>未偿匪患债务: {p.debt}m 正从全部收入中扣还</div>
      )}
      {hasProjection && (
        <div>预计匪患损失: -{p.total}m 于次日黎明结算</div>
      )}
      {(p.lines || []).map((line) => (
        <div
          key={line}
          style={{
            fontWeight: 'normal',
            fontVariant: 'normal',
            fontSize: FONT_BODY,
            color: SEAL_AMBER,
            letterSpacing: 0,
          }}
        >
          {line}
        </div>
      ))}
    </div>
  );
};
