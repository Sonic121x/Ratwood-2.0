import {
  bannerStyle,
  FONT_BODY,
  SEAL_RED,
} from '../common/parchment';
import type { SequestrationState } from './types';

export const SequestrationBanner = (props: {
  sequestration: SequestrationState;
}) => {
  const { sequestration } = props;
  if (!sequestration?.active) {
    return null;
  }
  return (
    <div
      style={{
        ...bannerStyle(SEAL_RED),
        position: 'relative',
        fontSize: FONT_BODY,
        padding: '12px 16px',
      }}
    >
      <div
        style={{
          position: 'absolute',
          top: '4px',
          right: '8px',
          fontSize: FONT_BODY,
          fontStyle: 'italic',
          fontVariant: 'normal',
          color: SEAL_RED,
          opacity: 0.7,
        }}
      >
        以市民的印记封存
      </div>
      <div
        style={{
          fontSize: '18px',
          fontWeight: 'bold',
          marginBottom: '4px',
        }}
      >
        宣布接管
      </div>
      <div style={{ fontVariant: 'normal' }}>
        由于王权违约, 费伦提亚贸易公司接管了
        领地的收入并持续包征关税和盐税
        直至 {sequestration.debt}m 的债务还清.
        贸易管理和库存定价已被锁定. 请愿, 征税,
        以及施加罚款的权力仍然保留.
      </div>
    </div>
  );
};
