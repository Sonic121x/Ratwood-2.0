import { WaxSeal, type WaxSealColor } from '../common/WaxSeal';
import { sealLine } from './shared';

type SealBanner = { mark: string; label: string; color: WaxSealColor };

export const COMMISSION_SEAL: SealBanner = {
  mark: 'C',
  label: '已受命',
  color: 'amber',
};

export const EXEMPT_SEAL: SealBanner = {
  mark: 'E',
  label: '免征关税',
  color: 'green',
};

const sealBannerStyle: React.CSSProperties = {
  display: 'inline-flex',
  flexDirection: 'column',
  alignItems: 'center',
  gap: '2px',
  margin: '0 8px',
};

const sealCaptionStyle: React.CSSProperties = {
  fontVariant: 'small-caps',
  fontSize: '0.72em',
  color: 'var(--p-ink-soft)',
  fontWeight: 'bold',
};

export const SealBannerView = (props: { seal: SealBanner }) => {
  const { seal } = props;
  return (
    <div style={sealBannerStyle}>
      <WaxSeal mark={seal.mark} label={seal.label} color={seal.color} size={48} />
      <div style={sealCaptionStyle}>{seal.label}</div>
    </div>
  );
};

export const SealLine = (props: {
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => {
  const { rulerTitle, issuedBy, issuedOn, bearer } = props;
  const issuer = issuedBy || rulerTitle;
  const dateText = issuedOn ? `钤印于 ${issuedOn}, ` : '';
  const bearerClause = bearer
    ? `授予 ${bearer} 执行.`
    : `授予凡愿领此令状执行之人.`;
  return (
    <p style={sealLine}>
      {dateText}依 {issuer} 之令状, {bearerClause}
    </p>
  );
};
